'TealiumLog.brs - Tealium debug log component for Roku integration with Tealium services
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
Function createTealiumLog(logLevel as Integer) as Object
       instantiate = Function (logLevel as Integer) as Object
           return {
               initialize: Function () as Object
                   print "Tealium Logger Created"
                   m.logFile = ""
                  return m
               End Function

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
                _printLog: Function (message as String, logLevel as Integer) as String
                   date = CreateObject("roDateTime")
                   m.logFile = m.logFile + "Tealium Log " + date.ToISOString() + chr(10)
                   enableLog = True
                   threshold = m.logLevelThreshold
                   if threshold >= logLevel then
                       print message
                       if enableLog = True then
                           m.logFile = m.logFile + message + chr(10)
                       end if
                       return message
                   end if
                   return ""
               End Function
       }
       End Function
       return instantiate(logLevel).initialize()
   End Function
