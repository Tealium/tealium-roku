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
function TealiumCore(logLevel as Integer, account as String, profile as String, environment=invalid, datasource=invalid) as Object
    Instantiate = function (logLevel as Integer, account as String, profile as String, environment=invalid, datasource=invalid) as Object
        return {
            'Initialize gets called in the createTealium function. Use to do any kind of setup after creating the object.
            Initialize: function () as Object
                'default properties
                m.tealiumCollect = CreateTealiumCollect(m._tealiumLog)
                m.ResetSessionId()
                m.visitorId = m._GetVisitorId()
                m._Print("Created " + m.ToStr(), 3)
                return m
            end function

            '-------------------------------------
            'PUBLIC
            '-------------------------------------

            account: account
            profile: profile
            environment: environment
            datasource: datasource

            'Resets Session ID - if needed
            ResetSessionId: function () as Integer
                sessionId = CreateObject("roDateTime").asSeconds() * -1000
                message = "Session ID Reset to: " + sessionId.ToStr()
                m.sessionId = sessionId
                m._Print(message, 3)
                return sessionId
            end function

            'Primary Tealium Track Event
            '@param eventType of track. Should be one of the following: activity, conversion, derived, interaction, view
            '@param title of the track event as a string. This will be the data source value for 'event_name' (required)
            '@param data roAssociativeArray 'dictionary' of additional data source keys and values (optional)
            '@param callbackObj An object with a function property 'callback' that can take an option roEvent argument
            TrackEvent: function(eventType as String, title as String, data as Object)
                'Combine data with TealiumUniversalDataSources with event_name any in data that is a match will overwrite key/value
                'create roAssocArray - add all universal data sources
                dataSources = CreateObject("roAssociativeArray")
                'append client provided data sources
                dataSources.Append(m._GetUniversalDataSources())
                if data <> invalid then
                    dataSources.Append(data)
                end If
                'append type
                dataSources["tealium_event_type"] = eventType
                dataSources["event_name"] = title
                dataSources["tealium_event"] = title
                'call dispatchEvent
                m.tealiumCollect._DispatchEvent(dataSources)
                m._Print("Tracking", 3)
            end function

            'Convenience description
            ToStr: function() as String
                if m.environment <> invalid
                    return "Tealium instance for account: " + m.account + " profile: " + m.profile + " environment: " + m.environment
                else
                    return "Tealium instance for account: " + m.account + " profile: " + m.profile
                end if
            end function

            '-------------------------------------
            'PRIVATE
            '-------------------------------------

            _tealiumLog: createTealiumLog(logLevel)

            'Creates a new visitor id based off of the time that the request occurred.
            'Does not persist the id by itself, call the tealiumWriteToFile function from
            'the function calling this function.
             _CreateNewVisitorId: function () as String
                info = CreateObject("roDeviceInfo")
                uuid = info.GetRandomUUID()
                cleanUuid = uuid.Replace("-", "")
                m._Print("New Visitor Id: "+ cleanUuid, 3)
                return cleanUuid
             end function

            'Deletes persistent data for target key
            '@return: boolean if successful
            _DeleteFromFile: function (key as String) as Boolean
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
                m._Print(message,3)
                return success
            end function

            'Fetch Tealium instance account information (account, profile, environment)
            '@returns: AssociativeArray object
            _GetAccountInfo: function () as Object
                acctInfo = CreateObject("roAssociativeArray")
                acctInfo.tealium_account = m.account
                acctInfo.tealium_profile = m.profile
                if m.environment <> invalid
                    acctInfo.tealium_environment = m.environment
                end if
                if m.datasource <> invalid
                    acctInfo.tealium_datasource = m.datasource
                end if
                return acctInfo
            end function

            'Fetch Tealium  library information
            '@returns: AssociativeArray object
            _GetLibraryInfo: function () as Object
                libInfo = CreateObject("roAssociativeArray")
                libInfo.tealium_library_name = "roku"
                libInfo.tealium_library_version = "2.0.0"
                return libInfo
            end function

            'Fetch Persistent Data (Account and Library Data)
            '@returns: AssociativeArray
            _GetPersistentData: function () as Object
                persistentData = CreateObject("roAssociativeArray")
                'Fetch account and library data, as well as visitor ID
                acctData = m._GetAccountInfo()
                libData = m._GetLibraryInfo()
                vid = m.visitorId

                'Add data to one AssociativeArray
                persistentData.Append(acctData)
                persistentData.Append(libData)
                persistentData.tealium_visitor_id = vid
                persistentData.tealium_vid = vid
                return persistentData
            end function

            _GetRandomNumber: function () As String
                hexChars = "0123456789"
                hexString = ""
                for i = 0 to 15
                    hexString = hexString + hexChars.Mid(Rnd(9) - 1, 1)
                Next
                Return hexString
            end function

            _GetTimeStamp: function () as Integer
                date = CreateObject("roDateTime").asSeconds()
                return date
            end function

            _GetUniversalDataSources: function () as Object
                dataSources = CreateObject("roAssociativeArray")
                dataSources.Append(m._GetPersistentData())
                dataSources.Append(m._GetVolatileData())
                return dataSources
            end function

            'Gets needed datasources that will not persist
            '@returns: roAssociativeArray
            _GetVolatileData: function () as Object
                this = {
                    tealium_random : m._GetRandomNumber()
                    tealium_session_id : m.sessionId
                    tealium_timestamp_epoch : m._GetTimeStamp()
                }
                return this
            end function

            'Gets a tealium visitor id associated with a particular account-profile-env
            '@return: String 32 character long alphanumeric
            _GetVisitorId: function () as String
                vidConstant = "tealium_visitor_id"
                'Check to see if an existing visitor id exists for this instance of tealium
                priorVid = m._ReadFromFile(vidConstant)
                if priorVid <> invalid then
                    if priorVid <> "" then
                        m._Print("Existing Visitor Id: "+ priorVid, 3)
                        return priorVid
                    end if
                end if

                'If not, create new
                vid = m._CreateNewVisitorId()
                'persist
                m._writeToFile(vidConstant, vid)
                return vid
            end function

            'For internally logging messages based on desired log level
            ' 0 - None
            ' 1 - Errors
            ' 2 - Warnings
            ' 3 - General
             _Print: function (message as String, logLevel as Integer) as String
                If m._tealiumLog <> invalid then
                    logMessage = m._tealiumLog._PrintLog(message, logLevel)
                    return logMessage
                end If

                return ""
            end function

            'Loads persistent data from tealiumWriteToFile function
            '@returns: String value
            _ReadFromFile: function (key as String) as Object
                section = m._sectionName()
                sec = CreateObject("roRegistrySection", section)
                if sec.Exists(key) then return sec.Read(key)
                return invalid
            end function

             'Clears tealium visitor id from persistence - mainly for testing
             '@return: boolean indiction success or failure
             _resetVisitorId: function () as boolean
                vidConstant = "tealium_visitor_id"
                success = m._DeleteFromFile(vidConstant)
                if success = true then
                    'assign a new visitor id to the instance
                    m.visitorId = m._GetVisitorId()
                end if
                return success
             end function

            _sectionName: function () as String
                if m.environment <> invalid
                    section = m.account + "." + m.profile + "."+ m.environment
                else
                    section = m.account + "." + m.profile
                end if
                return section
            end function

            'For persisting data
            ' If tealium object not passed in, will write to global tealium file
            _writeToFile: function (key as String, value as String)
                section = m._sectionName()
                sec = CreateObject("roRegistrySection", section)
                sec.Write(key, value)
                sec.Flush() 'commit it
            end function
        }
    end function
    return Instantiate(logLevel, account, profile, environment, datasource).Initialize()
end function
