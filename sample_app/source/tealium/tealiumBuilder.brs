'tealiumBuilder.brs - Tealium Builder for Roku integration with Tealium services
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'*******************************************************
'Tealium
'*******************************************************

'Builder for Tealium object instance

'@param account Tealium account name as a string (required)
'@param profile Tealium profile name as a string (required)
'@param environment Tealium environment identifier as a string (required)
'@param logLevel as an integer 0-None,1-Errors,2-Warnings,3-Messages | higher log levels include lower
'@return Object Instance of Tealium

function TealiumBuilder(account as String, profile as String, logLevel as Integer) as Object
    return {
        _account: account
        _profile: profile
        _logLevel: logLevel
        _environment: invalid
        _datasource: invalid

        _IsValidAccount: function () as Boolean
            'valid if doesn't contain empty spaces and not an empty string
            return m._account.Instr(0, " ") = -1 and m._account <> ""
        end function

        _IsValidProfile: function () as Boolean
            'valid if doesn't contain empty spaces, and not an empty string
            return m._profile.Instr(0, " ") = -1 and m._profile <> ""
        end function

        _IsValidDatasource: function () as Boolean
            'when defined, only valid if doesn't contain empty spaces, and not an empty string
            if m._datasource <> invalid
                return m._datasource.Instr(0, " ") = -1 and m._datasource <> ""
            else
                'datasource is optional, so still valid if not defined
                return true
            end if
        end function

        _IsValidEnvironment: function () as Boolean
            'when defined, only valid if doesn't contain empty spaces, and not an empty string
            if m._environment <> invalid
                return m._environment.Instr(0, " ") = -1 and m._environment <> ""
            else
                'environment is optional, so still valid if not defined
                return true
            end if
        end function

        _IsValidConfig: function () as Boolean
            'valid if account, profile, datasource, and environment are all valid.
            'datasource and environment are valid if they are not defined since they are optional
            return m._IsValidAccount() and m._IsValidProfile() and m._IsValidDatasource() and m._IsValidEnvironment()
        end function

        SetDatasource: function (datasource as String) as Object
            m._datasource = datasource
            return m
        end function

        SetEnvironment: function (environment as String) as Object
            m._environment = environment
            return m
        end function

        Build: function () as Object
            if m._IsValidConfig()
                return TealiumCore(m._logLevel, m._account, m._profile, m._environment, m._datasource)
            end if
            return invalid
        end function
    }
end function
