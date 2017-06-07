'testTealium.brs - tests for Tealium-Roku components using Mark Roddy's Brightscript testing framework
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'--------------------------------
'Unit tests for tealium
'--------------------------------

' test that the TealiumBuilder creates an object with required properties
function TestTealiumHasProperties(t as Object)
    print "Entering testTealiumHasProperties"

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    'Check that the tealium object contains required properties
    requiredProps = [
        "account"
        "profile"
        "ResetSessionId"
        "TrackEvent"
        "toStr"
        "_tealiumLog"
    ]

    for each prop in requiredProps
        t.AssertNotInvalid(tealium[prop])
    end for
end function

' test that the TealiumBuilder creates an object with environment
function TestTealiumHasEnvironment(t as Object)
    print "Entering testTealiumHasEnvironment"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    tealium = TealiumBuilder(testAccount, testProfile, 3).SetEnvironment(testEnv).Build()

    'Check that the tealium object contains required properties
    requiredProps = [
        "account"
        "profile"
        "environment"
        "ResetSessionId"
        "TrackEvent"
        "toStr"
        "_tealiumLog"
    ]

    for each prop in requiredProps
        t.AssertNotInvalid(tealium[prop])
    end for
end function

' test that the TealiumBuilder creates an object with datasource
function TestTealiumHasDatasource(t as Object)
    print "Entering testTealiumHasDatasource"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testDatasource = "testDatasource"

    tealium = TealiumBuilder(testAccount, testProfile, 3).SetDatasource(testDatasource).Build()

    'Check that the tealium object contains required properties
    requiredProps = [
        "account"
        "profile"
        "datasource"
        "ResetSessionId"
        "TrackEvent"
        "toStr"
        "_tealiumLog"
    ]

    for each prop in requiredProps
        t.AssertNotInvalid(tealium[prop])
    end for
end function

'test that _GetAccountInfo returns the correct info
function TestTealiumGetAccountInfo(t as Object)
    print "Entering testTealiumGetAccountInfo"

    for i = 1 to 5
        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()
        testDatasource$ = "testDatasource" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$, 3).SetEnvironment(testEnv$).SetDatasource(testDatasource$).Build()
        accountInfo = tealium._GetAccountInfo()

        t.AssertEqual(accountInfo.tealium_account, testAccount$)
        t.AssertEqual(accountInfo.tealium_profile, testProfile$)
        t.AssertEqual(accountInfo.tealium_environment, testEnv$)
        t.AssertEqual(accountInfo.tealium_datasource, testDatasource$)
    end for
end function

'test that _GetLibraryInfo returns the correct info
function TestTealiumGetLibraryInfo(t as Object)
    print "Entering testTealiumGetLibraryInfo"

    testAccount$ = "testAccount" + Rnd(1000000000).toStr()
    testProfile$ = "testProfile" + Rnd(1000000000).toStr()

    tealium = TealiumBuilder(testAccount$, testProfile$, 3).Build()
    libraryInfo = tealium._GetLibraryInfo()

    t.AssertEqual(libraryInfo.tealium_library_name, "roku")
    t.AssertEqual(libraryInfo.tealium_library_version, "1.2.0")
end function

' test that the TealiumBuilder assigns account and profile correctly
function TestBuildTealiumSetsAccountProfile(t as Object)
    print "Entering testtestTealiumSetsAccountProfileEnvironment"

    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$, 3).Build()

        'Check that the account, profile, and environment were correctly assigned
'        print "Account assigned : " + tealium.account
'        print "Profile assigned : " + tealium.profile

        t.AssertEqual(tealium.account, testAccount$)
        t.AssertEqual(tealium.profile, testProfile$)

    end for
end function

' test that the TealiumBuilder assigns environment correctly
function TestBuildTealiumSetsEnvironment(t as Object)
    print "Entering testtestTealiumSetsAccountProfileEnvironment"

    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$, 3).SetEnvironment(testEnv$).Build()

        'Check that the account, profile, and environment were correctly assigned
'        print "Account assigned : " + tealium.account
'        print "Profile assigned : " + tealium.profile
'        print "Environment assigned : " + tealium.environment

        t.AssertEqual(tealium.account, testAccount$)
        t.AssertEqual(tealium.profile, testProfile$)
        t.AssertEqual(tealium.environment, testEnv$)

    end for
end function

' test that the TealiumBuilder assigns datasource correctly
function TestBuildTealiumSetsDatasource(t as Object)
    print "Entering testBuildTealiumSetsDatasource"

    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testDatasource$ = "testDatasource" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$, 3).SetDatasource(testDatasource$).Build()

        'Check that the account, profile, and environment were correctly assigned
'        print "Account assigned : " + tealium.account
'        print "Profile assigned : " + tealium.profile
'        print "Datasource assigned : " + tealium.datasource

        t.AssertEqual(tealium.account, testAccount$)
        t.AssertEqual(tealium.profile, testProfile$)
        t.AssertEqual(tealium.datasource, testDatasource$)

    end for
end function

' test that the TealiumBuilder won't accept malformed parameters for account, profile, environment, or datasource
function TestTealiumBuilderRejectsMalformedParams(t as Object)
        print "Entering testTealiumBuilderRejectsMalformedParams"

        'should reject empty strings
        t.AssertInvalid(TealiumBuilder("", "testProfile", 3).Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "", 3).Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "testProfile", 3).SetEnvironment("").Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "testProfile", 3).SetDatasource("").Build())

        'should reject params with spaces
        t.AssertInvalid(TealiumBuilder("test Account", "testProfile", 3).Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "test Profile", 3).Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "testProfile", 3).SetEnvironment("test environment").Build())
        t.AssertInvalid(TealiumBuilder("testAccount", "testProfile", 3).SetDatasource("test datasource").Build())
end function

'----------------------------------
'Unit tests for "SetLogLevel"
'----------------------------------

'test the "_GetLogLevel" function
function TestTealiumGetLogLevel(t as Object)
    print "Entering testTealiumGetLogLevel"

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    print "get log level"
    logLevel% = tealium._TealiumLog.logLevelThreshold
    print "test log level is in range"
    t.AssertTrue(logLevel% >= 0)
    t.AssertTrue(logLevel% <= 3)
end function

'test the "SetLogLevel" function
function TestTealiumSetLogLevel(t as Object)
    print "Entering testTealiumSetLogLevel"

    testAccount = "testAccount"
    testProfile = "testProfile"

    ' test each of the possible log levels
    for i = 0 to 3
        tealium = TealiumBuilder(testAccount, testProfile, i).Build()
        t.AssertTrue(tealium._tealiumLog.logLevelThreshold=i)
    end for
end function

'test ResetSessionId
function TestTealiumResetSessionId(t as Object)
    print "Entering testTealiumResetSessionId"

    p = CreateObject("roMessagePort")

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    for i=1 to 10
        'get current session id
        oldSessionId = tealium.sessionId
        print("waiting...")

        'wait for a random time between 1 second and 4 seconds
        wait(Rnd(3000) + 1000, p)

        'reset the session id
        tealium.ResetSessionId()
        newSessionId = tealium.sessionId

        'assert the old and new session id are different
        t.AssertFalse(oldSessionId=newSessionId)


        print "old session id: " oldSessionId
        print "new session id: " newSessionId
    end for
end function

'check that randomNumbers are random for each instance and the number is 16 characters'
function TestTealiumGetRandomNumber(t as Object)
    print "Entering testGetRandomNumber"

    tealium = TealiumBuilder("account1", "profile", 3).Build()
    random1 = tealium._GetRandomNumber()

    tealium2 = TealiumBuilder("account2", "profile", 3).Build()
    random2 = tealium2._GetRandomNumber()

    tealium3 = TealiumBuilder("account3", "profile", 3).Build()
    random3 = tealium3._GetRandomNumber()

    tealium4 = TealiumBuilder("account4", "profile", 3).Build()
    random4 = tealium4._GetRandomNumber()

    tealium5 = TealiumBuilder("account5", "profile", 3).Build()
    random5 = tealium5._GetRandomNumber()

    tealium6 = TealiumBuilder("account6", "profile", 3).Build()
    random6 = tealium6._GetRandomNumber()

    randomArray = [random1, random2, random3, random4, random5, random6]

    for i=0 to randomArray.Count()-1
        print randomArray.GetEntry(i)
        for k=i+1 to randomArray.Count()
            t.AssertNotEqual(randomArray.GetEntry(i), randomArray.GetEntry(k))
        end for
    end for

    t.AssertTrue(Len(random1)=16)
    t.AssertTrue(Len(random2)=16)
    t.AssertTrue(Len(random3)=16)
    t.AssertTrue(Len(random4)=16)
    t.AssertTrue(Len(random5)=16)
    t.AssertTrue(Len(random6)=16)

end function

'Make sure 2 tealium instances created have different vids
function TestDuplicateVisitorId(t as Object)
    tealium1 = TealiumBuilder("account", "profile", 3).Build()
    tealium2 = TealiumBuilder("anotheraccount", "profile", 3).Build()
    visitorId1 = tealium1.visitorId
    visitorId2 = tealium2.visitorId
    t.AssertNotEqual(visitorId1, visitorId2)
end function

'Make sure the reset vid works
function TestResetVisitorId(t as Object)
    tealium = TealiumBuilder("resetAccount", "profile", 3).Build()
    vidOriginal = tealium.visitorId
    tealium._ResetVisitorId()
    vidNew = tealium.visitorId
    print "original vid: " vidOriginal
    print "new vid: " vidNew
    t.AssertNotEqual(vidOriginal, vidNew)
end function

'Check persistence of visitor id
function TestPersistVisitorId(t as Object)
    tealium = TealiumBuilder("resetAccount", "profile", 3).Build()
    vidOriginal = tealium.visitorId
    'Directly call for visitor Id
    vidCheck = tealium._GetVisitorId()
    t.AssertEqual(vidOriginal, vidCheck)
end function

'------------------------------------------------------------
'Track Event Unit Tests
'------------------------------------------------------------

function TestCreateTealiumCollect(t as Object)
    print "......................................................."
    print "Entering testCreateTealiumCollect"

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    collect = CreateTealiumCollect(tealium._tealiumLog)

    t.AssertNotInvalid(collect)
end function

' test that TealiumBuilder creates an object with required properties
function TestTealiumCollectHasProperties(t as Object)
    print "......................................................."
    print "Entering testTealiumCollectHasProperties"

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    collect = CreateTealiumCollect(tealium._tealiumLog)

    'Check that the tealium object contains required properties
    requiredProps = [
        "_DispatchEvent"
        "_SendHttpRequest"
        "_tealiumLog"
        "_AppendQueryParams"
    ]

    for each prop in requiredProps
        t.AssertNotInvalid(collect[prop])
    end for
end function

function TestAppendQueryParams(t as Object)
    print "......................................................."
    print "Entering testAppendQueryParams"

    ' create a tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    ' create a collect object
    collect = CreateTealiumCollect(tealium._tealiumLog)

    urlTransfer = CreateObject("roUrlTransfer")

    ' check that the _AppendQueryParams function returns expected results for various input
    t.AssertEqual(collect._AppendQueryParams(urlTransfer, {}), "")
    t.AssertEqual(collect._AppendQueryParams(urlTransfer, {test: "test"}), "test=test")
    t.AssertEqual(collect._AppendQueryParams(urlTransfer, {test: "test", data: "data"}), "data=data&test=test")
    t.AssertEqual(collect._AppendQueryParams(urlTransfer, {test: "test", data: "data", a: "a", z: "z"}), "a=a&data=data&test=test&z=z")
    t.AssertEqual(collect._AppendQueryParams(urlTransfer, {data: "test", test: "data", z: "a", a: "z"}), "a=z&data=test&test=data&z=a")
end function

function TestSendHttpRequestRecievesCorrectParams(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestRecievesCorrectParams"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    ' create the collect object
    collect = CreateTealiumCollect(tealium._tealiumLog)

    ' create property for saving test results
    collect.testResults = {}

    ' create dummy callback function that does nothing
    DummyCallback = function(event)
    end function

    ' create dummy callback object with dummy callback function
    callbackObj = {callback: DummyCallback}

    ' stub the _SendHttpRequest function to simply save the parameters it receives into the test results parameter
    collect._SendHttpRequest = function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.callbackObj = callbackObj
    end function

    ' run the test for a couple cases
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    t.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.AssertEqual(collect.testResults.params, "data=data&test=test")
    t.AssertEqual(collect.testResults.callbackObj, callbackObj)

    ' override the default url
    collect.SetBaseURL("https://mydomain.com/test.gif")
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    t.AssertEqual(collect.testResults.url, "https://mydomain.com/test.gif")
    t.AssertEqual(collect.testResults.params, "data=data&test=test")
    t.AssertEqual(collect.testResults.callbackObj, callbackObj)
end function

function TestSendHttpRequestWithDefaultUrl(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestWithDefaultUrl"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    ' create the collect object
    collect = CreateTealiumCollect(tealium._tealiumLog)

    ' create property for saving test results
    collect.testResults = {}

    ' create dummy callback function that does nothing
    DummyCallback = function(event)
    end function

    ' create dummy callback function that does nothing
    callbackObj = {callback: DummyCallback}

    ' shim the _SendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__SendHttpRequest = collect._SendHttpRequest
    collect._SendHttpRequest = function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.urlTransfer = urlTransfer
        m.testResults.callbackObj = callbackObj
        m.testResults.fullUrl = m.__SendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    end function

    ' run the test using the shimmed version of _SendHttpRequest using invalid for the default url
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    t.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.AssertEqual(collect.testResults.params, "data=data&test=test")
    t.AssertEqual(collect.testResults.callbackObj, callbackObj)
end function

function TestSendHttpRequestCanOverrideUrl(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestCanOverrideUrl"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile, 3).Build()

    ' create the collect object
    collect = CreateTealiumCollect(tealium._tealiumLog)

    ' create property for saving test results
    collect.testResults = {}

    ' create dummy callback function that does nothing
    DummyCallback = function(event)
    end function

    ' create dummy callback function that does nothing
    callbackObj = {callback: DummyCallback}

    ' shim the _SendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__SendHttpRequest = collect._SendHttpRequest
    collect._SendHttpRequest = function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.urlTransfer = urlTransfer
        m.testResults.callbackObj = callbackObj
        m.testResults.fullUrl = m.__SendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    end function

    ' run the test using the shimmed version of _SendHttpRequest overriding the default url
    newURL = collect.SetBaseURL("https://mydomain.com/test.gif")
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    t.AssertEqual(collect.testResults.url, "https://mydomain.com/test.gif")
    t.AssertEqual(collect.testResults.params, "data=data&test=test")
    t.AssertEqual(collect.testResults.callbackObj, callbackObj)
end function

function TestTealiumTrackEvent(t as Object)
    ParseParams = function (params as String) as Object
        ' split a string by all its ampersand "&" symbols
        SplitStrByAmpersand = function (s as String) as Object
            c = "&"
            result = []
            curStr = ""

            for i=1 to Len(s)
                if mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                else
                    curStr = curStr + mid(s, i, 1)
                end if
            end for

            result.push(curStr)
            curStr = ""

            return result
        end function

        ' split a string by all its equal "=" symbols
        SplitStrByEquals = function (s as String) as Object
            c = "="
            result = []
            curStr = ""

            for i=1 to Len(s)
                if mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                else
                    curStr = curStr + mid(s, i, 1)
                end if
            end for

            result.push(curStr)
            curStr = ""

            return result
        end function

        ' given an array and a function that takes a single argument, apply the function
        ' to each element in the array and return a new array
        Map = function (arr as Object, f as function) as Object
            result = []

            for each e In arr
                result.push(f(e))
            end for

            return result
        end function

        ' get array of all key value pairs in the query params
        intermediate = Map(SplitStrByAmpersand(params), SplitStrByEquals)

        ' convert the result into an object
        result = {}
        for each element in intermediate
            result[element[0]] = element[1]
        end for

        return result
    end function

    GetUrlParams = function (url as String) as String
        ' split a string by all its question mark "?" symbols
        splitStrByQuestion = function (s as String) as Object
            c = "?"
            result = []
            curStr = ""

            for i=1 to Len(s)
                if mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                else
                    curStr = curStr + mid(s, i, 1)
                end if
            end for

            result.push(curStr)
            curStr = ""

            return result
        end function

        return splitStrByQuestion(url)[1]
    end function


    print "......................................................."
    print "Entering testTealiumTrackEvent"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    testDatasource = "testDatasource"

    tealium = TealiumBuilder(testAccount, testProfile, 3).SetEnvironment(testEnv).SetDatasource(testDatasource).Build()

    ' create the collect object
    collect = tealium.tealiumCollect

    ' create property for saving test results
    collect.testResults = {}

    ' create dummy callback function that does nothing
    DummyCallback = function(event)
    end function

    ' create dummy callback function that does nothing
    callbackObj = {callback: DummyCallback}

    ' shim the _SendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__SendHttpRequest = collect._SendHttpRequest
    collect._SendHttpRequest = function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.callbackObj = callbackObj
        m.testResults.urlTransfer = urlTransfer
        m.testResults.fullUrl = m.__SendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    end function

    ' run the test using the shimmed version of _SendHttpRequest using invalid for the default url
    tealium.TrackEvent("activity","testEvent", {test: "test", data: "data"}, callbackObj)

    eventData = ParseParams(GetUrlParams(collect.testResults.fullUrl))
    parsedParams = ParseParams(collect.testResults.params)

    ' print the sent event data and the params received by _SendHttpRequest for comparison
    'print eventData
    'print parsedParams

    ' check the url and callback are correct
    t.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.AssertEqual(collect.testResults.callbackObj, callbackObj)

    ' check that each variable send to the server is correct given
    ' the params recieved by the _SendHttpRequest function
    for each key in parsedParams
        t.AssertEqual(parsedParams[key], eventData[key])
    end for
end function

function TestCreateTealiumShim(t as Object)
    print "testCreateTealiumShim"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    tealium = CreateTealium(testAccount, testProfile, testEnv, 3)

    'Check that the tealium object contains required properties
    requiredProps = [
        "account"
        "profile"
        "environment"
        "ResetSessionId"
        "TrackEvent"
        "toStr"
        "_tealiumLog"
    ]

    for each prop in requiredProps
        t.AssertNotInvalid(tealium[prop])
    end for
end function
