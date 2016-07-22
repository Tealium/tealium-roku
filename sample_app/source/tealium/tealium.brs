'Tealium.brs - Primary Tealium component for Roku integration with Tealium services
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'*******************************************************
'Tealium
'*******************************************************

'Constructor for Tealium object instance
'@param account Tealium account name as a string (required)
'@param profile Tealium profile name as a string (required)
'@param environment Tealium environment identifier as a string (required)
'@param logLevel as an integer 0-None,1-Errors,2-Warnings,3-Messages | higher log levels include lower
'@return Object Instance of Tealium
Function createTealium(account as String, profile as String, environment as String, logLevel as Integer) as Object
    instantiate = Function (account as String, profile as String, environment as String, logLevel as Integer) as Object
        return {
            'Initialize gets called in the createTealium function. Use to do any kind of setup after creating the object.
            initialize: Function () as Object
                'validation
                if (m._isValidConfig(m.account, m.profile, m.environment) = false) then
                    return invalid
                End if
                'default properties
                m.tealiumCollect = createTealiumCollect(m._tealiumLog)
                m.ResetSessionId()
                m.visitorId = m._getVisitorId()
                m._print("Created " + m.toStr(), 3)
                return m
            End Function
            
            '-------------------------------------
            'PUBLIC
            '-------------------------------------

            account: account
            profile: profile
            environment: environment
            
            'Resets Session ID - if needed
            ResetSessionId: Function () as Integer
                sessionId = CreateObject("roDateTime").asSeconds() * -1000
                message = "Session ID Reset to: " + sessionId.ToStr()
                m.sessionId = sessionId
                m._print(message, 3)
                return sessionId
            End Function

            'Tealium Track Event
            '@param title of the track event as a string. This will be the data source value for 'event_name' (required)
            '@param data roAssociativeArray 'dictionary' of additional data source keys and values (optional)
            '@param callbackObj An object with a function property 'callback' that can take an option roEvent argument
            TrackEvent: Function(title as String, data as Object, callbackObj as Object)
                'Combine data with TealiumUniversalDataSources with event_name any in data that is a match will overwrite key/value
                'create roAssocArray - add all universal data sources
                dataSources = CreateObject("roAssociativeArray")
                'append client provided data sources
                dataSources.Append(m._getUniversalDataSources())
                if data <> Invalid Then
                    dataSources.Append(data)
                end If
                'append title tealium_event_name
                dataSources["event_name"] = title
                'call dispatchEvent
                m.tealiumCollect._dispatchEvent(dataSources, callbackObj)
                m._print("Tracking", 3)
            End Function

            'Convenience description
            toStr: Function() as String
                return "Tealium instance for account: " + m.account + " profile: " + m.profile + " environment: " + m.environment
            End Function

            '-------------------------------------
            'PRIVATE
            '-------------------------------------

            _tealiumLog: createTealiumLog(logLevel)

            _isValidConfig: Function (account as String, profile as String, environment as String) as Boolean
                'Simple invalid profile bail-out checks - if any white spaces
                if (account.Instr(0, " ") <> -1) then
                    return false
                End if
                if (profile.Instr(0, " ") <> -1) then
                    return false
                End if
                if (environment.Instr(0, " ") <> -1) then
                    return false
                End if
                
                'Simple invalid profile bail-out checks - if any empty strings                
                If (account = "") then 
                    return false
                End If
                If (profile = "") then 
                    return false
                End If
                If (environment = "") then 
                    return false
                End If
                
                return true
                
            End Function
            
            'Creates a new visitor id based off of the time that the request occurred.
            'Does not persist the id by itself, call the tealiumWriteToFile function from
            'the function calling this function.
             _createNewVisitorId: Function () as String
                info = CreateObject("roDeviceInfo")
                uuid = info.GetRandomUUID()
                cleanUuid = uuid.Replace("-", "")
                m._print("New Visitor Id: "+ cleanUuid, 3)
                return cleanUuid
             End Function

            'Deletes persistent data for target key
            '@return: boolean if successful
            _deleteFromFile: Function (key as String) as Boolean
                section = m._sectionName()
                sec = CreateObject("roRegistrySection", section)
                success = sec.Delete(key)
                sec.Flush()

                'Reporting
                if success = true then
                    successString = "true"
                else
                    successString = "false"
                end if
                message = "Could delete key: " + key + " from " + section + ": " + successString
                m._print(message,3)
                return success
            End Function

            'Fetch Tealium instance account information (account, profile, environment)
            '@returns: AssociativeArray object
            _getAccountInfo: Function () as Object
                acctInfo = CreateObject("roAssociativeArray")
                acctInfo.tealium_account = m.account
                acctInfo.tealium_profile = m.profile
                acctInfo.tealium_environment = m.environment
                return acctInfo
            End Function

            'Fetch Tealium  library information
            '@returns: AssociativeArray object
            _getLibraryInfo: Function () as Object
                libInfo = CreateObject("roAssociativeArray")
                libInfo.tealium_library_name = "roku"
                libInfo.tealium_library_version = "1.0.0"
                return libInfo
            End Function

            'Fetch Persistent Data (Account and Library Data)
            '@returns: AssociativeArray
            _getPersistentData: Function () as Object
                persistentData = CreateObject("roAssociativeArray")
                'Fetch account and library data, as well as visitor ID
                acctData = m._getAccountInfo()
                libData = m._getLibraryInfo()
                vid = m.visitorId

                'Add data to one AssociativeArray
                persistentData.Append(acctData)
                persistentData.Append(libData)
                persistentData.tealium_visitor_id = vid
                persistentData.tealium_vid = vid
                return persistentData
            End Function

            _getRandomNumber: Function () As String
                hexChars = "0123456789"
                hexString = ""
                For i = 0 to 15
                    hexString = hexString + hexChars.Mid(Rnd(9) - 1, 1)
                Next
                Return hexString
            End Function

            _getTimeStamp: Function () as Integer
                date = CreateObject("roDateTime").asSeconds()
                return date
            End Function

            _getUniversalDataSources: Function () as Object
                dataSources = CreateObject("roAssociativeArray")
                dataSources.Append(m._getPersistentData())
                dataSources.Append(m._getVolatileData())
                return dataSources
            End Function

            'Gets needed datasources that will not persist
            '@returns: roAssociativeArray
            _getVolatileData: Function () as Object
                this = {
                    tealium_random : m._getRandomNumber()
                    tealium_session_id : m.sessionId
                    tealium_timestamp_epoch : m._getTimeStamp()
                }
                return this
            End Function

            'Gets a tealium visitor id associated with a particular account-profile-env
            '@return: String 32 character long alphanumeric
            _getVisitorId: Function () as String
                vidConstant = "tealium_visitor_id"
                'Check to see if an existing visitor id exists for this instance of tealium
                priorVid = m._readFromFile(vidConstant)
                if priorVid <> invalid then
                    if priorVid <> "" then
                        m._print("Existing Visitor Id: "+ priorVid, 3)
                        return priorVid
                    end if
                end if

                'If not, create new
                vid = m._createNewVisitorId()
                'persist
                m._writeToFile(vidConstant, vid)
                return vid
            End Function

            'For internally logging messages based on desired log level
            ' 0 - None
            ' 1 - Errors
            ' 2 - Warnings
            ' 3 - General
             _print: Function (message as String, logLevel as Integer) as String
                If m._tealiumLog <> Invalid Then
                    logMessage = m._tealiumLog._printLog(message, logLevel)
                    return logMessage
                End If
                 
                return ""
            End Function

            'Loads persistent data from tealiumWriteToFile function
            '@returns: String value
            _readFromFile: Function (key as String) as Object
                section = m._sectionName()
                sec = CreateObject("roRegistrySection", section)
                if sec.Exists(key) then return sec.Read(key)
                return invalid
            End Function

             'Clears tealium visitor id from persistence - mainly for testing
             '@return: boolean indiction success or failure
             _resetVisitorId: Function () as boolean
                vidConstant = "tealium_visitor_id"
                success = m._deleteFromFile(vidConstant)
                if success = true then
                    'assign a new visitor id to the instance
                    m.visitorId = m._getVisitorId()
                end if
                return success
             End Function

            _sectionName: Function () as String
                section = m.account + "." + m.profile + "."+ m.environment
                return section
            End Function

            'For persisting data
            ' If tealium object not passed in, will write to global tealium file
            _writeToFile: Function (key as String, value as String)
                section = m._sectionName()
                sec = CreateObject("roRegistrySection", section)
                sec.Write(key, value)
                sec.Flush() 'commit it
            End Function
        }
    End Function
    return instantiate(account, profile, environment, logLevel).initialize()
End Function