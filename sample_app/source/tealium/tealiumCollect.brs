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
                return "https://collect.tealiumiq.com/vdata/i.gif"
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
                'call appendQueryParams
                params = m._AppendQueryParams(m._UrlTransfer, dataSources)
                'call sendHttpRequest
                return m._SendHttpRequest (m.baseUrl, params, m._UrlTransfer, callbackObj)
            end function

            'Async call with timeout - so it will be synchronous public
            _SendHttpRequest: function (url as String, encodedParams as String, urlTransfer as Object,callbackObj) as Object
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
                fullUrl = url + "?" + encodedParams
                urlTransfer.SetUrl(fullUrl)
                if urlTransfer.AsyncGetToString() then
                    message = "Requested URL: " + fullUrl
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
                end if
                if callbackObj <> invalid then
                    if callbackObj.DoesExist("callback") <> invalid then
                        callbackObj.callback(event)
                    end if
                end if
                return fullUrl
            end function

            'Add data sources to base url as query string params
            '@param urlTransfer Object to perform encoding
            '@param dataSources roAssociativeArray type (Required)
            '@return String query string parameters
            _AppendQueryParams: function (urlTransfer as Object, dataSources as Object) as String
                queryParams = ""

                keys = dataSources.Keys()
                length = keys.Count()
                'Use indexed for loop instead
                for i=0 to length step 1

                    key = keys[i]

                    if key <> invalid then
                        if dataSources.LookUp(key) <> invalid then
                            if i <> 0 then
                                queryParams += "&"
                            end if

                            encodedKey = urlTransfer.Escape(key)
                            queryParams += encodedKey
                            queryParams += "="
                            value = dataSources.LookUp(key).ToStr()
                            encodedValue = urlTransfer.Escape(value)
                            queryParams += encodedValue

                        end if
                    end if
                end for
                return queryParams
            end function

            _Print: function (message as String, logLevel as Integer)
                m._tealiumLog._PrintLog(message, logLevel)
            end function
        }
    end function
    return Instantiate(tealiumLog).Initialize()
end function
