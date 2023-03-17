'tealiumLog.brs - Tealium debug log for Roku integration with Tealium services
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'*******************************************************
'Tealium Log
'*******************************************************

'Constructor for a Tealium Log object for debugging use
'@param logLevel The log level threshold for this logger: 0-None,1-ErrorsOnly,2-Warnings,3-All
'                   Higher log levels include messages from lower log levels
'@return Object An instance of Tealium Log.
function CreateTealiumLog(logLevel as Integer) as Object
    Instantiate = function (logLevel as Integer) as Object
        return {
            Initialize: function () as Object
                print "Tealium Logger Created"
                m.logFile = ""
                return m
            end function

            '-------------------------------------
            'PUBLIC
            '-------------------------------------

            logLevelThreshold: logLevel

            '-------------------------------------
            'PRIVATE
            '-------------------------------------
            'For internally logging messages based on desired log level
            ' 0 - None
            ' 1 - Errors
            ' 2 - Warnings
            ' 3 - General
            _PrintLog: function (message as String, logLevel as Integer) as String
                date = CreateObject("roDateTime")
                m.logFile = m.logFile + "Tealium Log " + date.ToISOString() + chr(10)
                enableLog = true
                threshold = m.logLevelThreshold
                if threshold >= logLevel then
                    print message
                    if enableLog = true then
                        m.logFile = m.logFile + message + chr(10)
                    end if
                    return message
                end if
                return ""
            end function
        }
    end function

    return Instantiate(logLevel).Initialize()
end function
