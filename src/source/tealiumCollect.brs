'tealiumCollect.brs - Tealium collect dispatch for Roku integration with Tealium services
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'*******************************************************
'Tealium Collect Dispatch Service
'*******************************************************

'Constructor for Tealium Collect dispatch service object
'@param tealiumLog Instance of the tealiumLog used by the Tealium instance for debugging purposes
'@return Object This class as an roAssociativeArray
function CreateTealiumCollect(tealiumLog) as Object
    Instantiate = function (tealiumLog) as Object
        return {
            Initialize: function () as Object
                print "Tealium Collect Created"
                m.baseUrl = m.DefaultUrl()
                m._UrlTransfer = m._NewUrlTransfer()
               return m
            end function

            '-------------------------------------
            'PUBLIC
            '-------------------------------------

            DefaultUrl: function () as String
                return "https://collect.tealiumiq.com/event"
            end function

            SetBaseUrl: function (newBaseUrl as String) as String
                m.baseUrl = newBaseUrl
                return m.baseUrl
            end function

            '-------------------------------------
            'PRIVATE
            '-------------------------------------

            'Tealium log property for debugging
            _tealiumLog: tealiumLog

            _NewUrlTransfer: function () as Object
                'Create URL transfer object, set port and URL
                urlTransfer = CreateObject("roUrlTransfer")
                port = CreateObject("roMessagePort")
                urlTransfer.SetMessagePort(port)
                return urlTransfer
            end function

            'Executes dispatch
            _DispatchEvent: function (dataSources as Object, callbackObj as Object) as Object
                'repackage data sources as http params and add to base vdata URL - default URL:
                'call GetPostBody
                postBody = m._GetPostBody(m._UrlTransfer, dataSources)
                'call sendHttpRequest
                return m._SendHttpRequest (m.baseUrl, postBody, m._UrlTransfer, callbackObj)
            end function

            'Async call with timeout - so it will be synchronous public
            _SendHttpRequest: function (url as String, postBody as String, urlTransfer as Object, callbackObj) as Object
                'Set Timeout
                seconds% = 0
                timeout% = 0
                if seconds% <> invalid then
                    timeout% = 1000 * seconds%
                end if

               if url.instr("https") > -1 then
                    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
                    urlTransfer.InitClientCertificates()
                end if

                'GET request
                urlTransfer.AddHeader("Content-type", "application/json")
                urlTransfer.SetUrl(url)
                if urlTransfer.AsyncPostFromString(postBody) then
                    message = "Requested URL: " + url
                    m._Print(message, 3)
                    message = "Post Body: " + postBody
                    m._Print(message, 3)
                    'Capture url event message
                    event = wait (timeout%, urlTransfer.GetPort())
                    if type(event) = "roUrlEvent"
                        code = event.GetResponseCode()

                        if code = 200 then
                            message = code.ToStr() + " - Request OK"
                            m._Print(message, 3)
                        else
                            message = "Failed Response with Error: (" + code.ToStr() + ") " + event.GetFailureReason()
                            m._Print(message, 3)
                        end if
                    else if event = invalid then
                        message = "AsyncGetFromString timeout"
                        m._Print(message, 3)
                        urlTransfer.AsyncCancel()
                    else
                        message = "AsyncPostFromString Unknown Event: " + event
                        m._Print(message, 3)
                    end if
                    if callbackObj <> invalid then
                        if callbackObj.DoesExist("callback") <> invalid then
                            callbackObj.callback(event)
                        end if
                    end if
                end if
                return url
            end function

            'Add data sources to base url as query string params
            '@param urlTransfer Object to perform encoding
            '@param dataSources roAssociativeArray type (Required)
            '@return String query string parameters
            _GetPostBody: function (urlTransfer as Object, dataSources as Object) as String
                return FormatJson(dataSources)
            end function

            _Print: function (message as String, logLevel as Integer)
                m._tealiumLog._PrintLog(message, logLevel)
            end function
        }
    end function
    return Instantiate(tealiumLog).Initialize()
end function
