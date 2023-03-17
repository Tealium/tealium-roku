'createTealium.brs - Tealium for Roku integration with Tealium services
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'*******************************************************
'Tealium
'*******************************************************

'(DEPRECATED) Constructor shim for Tealium object allows for backward compatability
'
'@param account Tealium account name as a string (required)
'@param profile Tealium profile name as a string (required)
'@param environment Tealium environment identifier as a string (required)
'@param logLevel as an integer 0-None,1-Errors,2-Warnings,3-Messages | higher log levels include lower
'@return Object Instance of Tealium

'DEPRECATED - if you have any old code that calls this function, we recomend using the builder pattern instead
function CreateTealium(account as String, profile as String, environment as String, logLevel as Integer) as Object
    return TealiumBuilder(account, profile, logLevel).SetEnvironment(environment).Build()
end function
