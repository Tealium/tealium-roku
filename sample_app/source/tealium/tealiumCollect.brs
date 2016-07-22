'Tealium.brs - Primary Tealium component for Roku integration with Tealium services
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
Function createTealiumCollect(tealiumLog) as Object
    instantiate = Function (tealiumLog) as Object
        return {
            initialize: Function () as Object
                print "Tealium Collect Created"
                m.baseURL = m.DefaultURL()
                m._urlTransfer = m._newURLTransfer()
               return m
            End Function
            
            '-------------------------------------
            'PUBLIC
            '-------------------------------------
            
            DefaultURL: Function () as String
                return "https://collect.tealiumiq.com/vdata/i.gif"
            End Function
            
            SetBaseURL: Function (newBaseURL as String) as String
                m.baseURL = newBaseURL
                return m.baseURL
            End Function
            
            '-------------------------------------
            'PRIVATE
            '-------------------------------------

            'Tealium log property for debugging
            _tealiumLog: tealiumLog
            
            _newURLTransfer: Function () as Object
                'Create URL transfer object, set port and URL
                urlTransfer = CreateObject("roUrlTransfer")
                port = CreateObject("roMessagePort")
                urlTransfer.SetMessagePort(port)
                return urlTransfer
            End Function
                
            'Executes dispatch
            _dispatchEvent: Function (dataSources as Object, callbackObj as Object) as Object
                'repackage data sources as http params and add to base vdata URL - default URL: 
                'call appendQueryParams
                params = m._appendQueryParams(m._urlTransfer, dataSources)
                'call sendHttpRequest 
                return m._sendHttpRequest (m.baseURL, params, m._urlTransfer, callbackObj)
            End Function
            
            'Async call with timeout - so it will be synchronous public 
            _sendHttpRequest: Function (url as String, encodedParams as String, urlTransfer as Object,callbackObj) as Object
                'Set Timeout 
                seconds% = 0
                timeout% = 0
                If seconds% <> Invalid then
                    timeout% = 1000 * seconds% 
                End If
                           
               If url.instr("https") > -1 Then 
                    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
                    urlTransfer.InitClientCertificates()
                End If
                      
                'GET request
                fullURL = url + "?" + encodedParams
                urlTransfer.SetUrl(fullURL)
                If (urlTransfer.AsyncGetToString()) Then
                    message = "Requested URL: " + fullURL
                    m._print(message, 3)
                    'Capture url event message
                    event = wait (timeout%, urlTransfer.GetPort())
                    If type(event) = "roUrlEvent"
                        code = event.GetResponseCode()
                      
                        If code = 200 Then
                            message = code.toStr() + " - Request OK"
                            m._print(message, 3)
                        Else
                            message = "Failed Response with Error: (" + code.toStr() + ") " + event.GetFailureReason()
                            m._print(message, 3)
                        End If
                    Else If event = Invalid Then
                        message = "AsyncGetFromString timeout"
                        m._print(message, 3)
                        urlTransfer.AsyncCancel()
                    Else
                        message = "AsyncPostFromString Unknown Event: " + event
                        m._print(message, 3)
                    End If
                End If
                If callbackObj <> Invalid Then
                    If callbackObj.DoesExist("callback") <> Invalid Then
                        callbackObj.callback(event)
                    End If
                End If
                return fullURL
            End Function
            
            'Add data sources to base url as query string params
            '@param urlTransfer Object to perform encoding
            '@param dataSources roAssociativeArray type (Required)
            '@return String query string parameters 
            _appendQueryParams: Function (urlTransfer as Object, dataSources as Object) as String
                queryParams = ""
                
                keys = dataSources.Keys()
                length = keys.Count()
                'Use indexed for loop instead
                For i=0 To length Step 1
                    
                    key = keys[i]
              
                    If key <> Invalid Then
                        If dataSources.LookUp(key) <> Invalid Then
                            If i <> 0 Then
                                queryParams += "&"
                            End If
                            
                            encodedKey = urlTransfer.Escape(key)
                            queryParams += encodedKey
                            queryParams += "="
                            value = dataSources.LookUp(key).toStr()
                            encodedValue = urlTransfer.Escape(value)
                            queryParams += encodedValue
                            
                        End If    
                    End If 
                End For    
                return queryParams
            End Function
            
            _print: Function (message as String, logLevel as Integer)
                m._tealiumLog._printLog(message, logLevel)
            End Function
        }
    End Function
    return instantiate(tealiumLog).initialize()
End Function