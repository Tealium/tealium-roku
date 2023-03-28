Function TestSuite__Main() as Object

    this = BaseTestSuite()


    this.Name = "MainTestSuite"

    this.SetUp = MainTestSuite__SetUp
    this.TearDown = MainTestSuite__TearDown

    this.addTest("TealiumHasProperties", TestCase__Main_TealiumHasProperties)
    this.addTest("TealiumHasEnvironment", TestCase__Main_TealiumHasEnvironment)
    this.addTest("TealiumHasDatasource", TestCase__Main_TealiumHasDatasource)
    this.addTest("TealiumGetAccountInfo", TestCase__Main_TealiumGetAccountInfo)
    this.addTest("TealiumGetLibraryInfo", TestCase__Main_TealiumGetLibraryInfo)
    this.addTest("TealiumSetsAccountProfile", TestCase__Main_TealiumSetsAccountProfile)
    this.addTest("TealiumSetsEnvironment", TestCase__Main_TealiumSetsEnvironment)
    this.addTest("TealiumSetsDatasource", TestCase__Main_TealiumSetsDatasource)
    this.addTest("TealiumBuilderRejectsMalformedParams", TestCase__Main_TealiumBuilderRejectsMalformedParams)
    this.addTest("TealiumGetLogLevel", TestCase__Main_TealiumGetLogLevel)
    this.addTest("TealiumSetLogLevel", TestCase__Main_TealiumSetLogLevel)
    this.addTest("TealiumSetLogLevelViaConstructor", TestCase__Main_TealiumSetLogLevelViaConstructor)
    this.addTest("TealiumResetSessionId", TestCase__Main_TealiumResetSessionId)
    this.addTest("TealiumGetRandomNumber", TestCase__Main_TealiumGetRandomNumber)
    this.addTest("DuplicateVisitorId", TestCase__Main_DuplicateVisitorId)
    this.addTest("ResetVisitorId", TestCase__Main_ResetVisitorId)
    this.addTest("PersistVisitorId", TestCase__Main_PersistVisitorId)
    this.addTest("CreateTealiumCollect", TestCase__Main_CreateTealiumCollect)
    this.addTest("TealiumCollectHasProperties", TestCase__Main_TealiumCollectHasProperties)
    this.addTest("SendHttpRequestRecievesCorrectParams", TestCase__Main_SendHttpRequestRecievesCorrectParams)
    this.addTest("SendHttpRequestWithDefaultUrl", TestCase__Main_SendHttpRequestWithDefaultUrl)
    this.addTest("SendHttpRequestCanOverrideUrl", TestCase__Main_SendHttpRequestCanOverrideUrl)
    this.addTest("TealiumTrackEvent", TestCase__Main_TealiumTrackEvent)
    this.addTest("CreateTealiumShim", TestCase__Main_CreateTealiumShim)

    return this
End Function

Sub MainTestSuite__SetUp()
    print("Test Setup")
End Sub

Sub MainTestSuite__TearDown()
    print("Test Tear Down")
End Sub

'----------------------------------------------------------------
' Check if data has an expected amount of items
'
' @return An empty string if test is success or error message if not.
'----------------------------------------------------------------
Function TestCase__Main_TealiumHasProperties() as String
print "Entering testTealiumHasProperties"

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

    'Check that the tealium object contains required properties
    requiredProps = [
        "account"
        "profile"
        "ResetSessionId"
        "TrackEvent"
        "toStr"
        "_tealiumLog"
    ]

    hasInvalidProp = false
    for each prop in requiredProps
        if tealium[prop] = invalid then
            hasInvalidProp = true
        end if
    end for
    return m.assertFalse(hasInvalidProp, "Invalid prop found")
End Function

function TestCase__Main_TealiumHasEnvironment() as String
    print "Entering testTealiumHasEnvironment"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    tealium = TealiumBuilder(testAccount, testProfile).SetEnvironment(testEnv).Build()

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

    hasInvalidProp = false
    for each prop in requiredProps
        if tealium[prop] = invalid then
            hasInvalidProp = true
        end if
    end for
    return m.assertFalse(hasInvalidProp, "Invalid prop found")
end function

' test that the TealiumBuilder creates an object with datasource
function TestCase__Main_TealiumHasDatasource() as String
    print "Entering testTealiumHasDatasource"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testDatasource = "testDatasource"

    tealium = TealiumBuilder(testAccount, testProfile).SetDatasource(testDatasource).Build()

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

    hasInvalidProp = false
    for each prop in requiredProps
        if tealium[prop] = invalid then
            hasInvalidProp = true
        end if
    end for
    return m.assertFalse(hasInvalidProp, "Invalid prop found")
end function

'test that _GetAccountInfo returns the correct info
function TestCase__Main_TealiumGetAccountInfo() as String
    print "Entering testTealiumGetAccountInfo"

    response = ""

    for i = 1 to 5
        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()
        testDatasource$ = "testDatasource" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$).SetEnvironment(testEnv$).SetDatasource(testDatasource$).Build()
        accountInfo = tealium._GetAccountInfo()

        response += m.AssertEqual(accountInfo.tealium_account, testAccount$, "Invalid Account")
        response += m.AssertEqual(accountInfo.tealium_profile, testProfile$, "Invalid Profile")
        response += m.AssertEqual(accountInfo.tealium_environment, testEnv$, "Invalid Env")
        response += m.AssertEqual(accountInfo.tealium_datasource, testDatasource$, "Invalid Datasource")
    end for
    return response
end function

'test that _GetLibraryInfo returns the correct info
function TestCase__Main_TealiumGetLibraryInfo() as String
    print "Entering testTealiumGetLibraryInfo"

    testAccount$ = "testAccount" + Rnd(1000000000).toStr()
    testProfile$ = "testProfile" + Rnd(1000000000).toStr()

    tealium = TealiumBuilder(testAccount$, testProfile$).Build()
    libraryInfo = tealium._GetLibraryInfo()

    response = ""
    response += m.AssertEqual(libraryInfo.tealium_library_name, "roku")
    response += m.AssertEqual(libraryInfo.tealium_library_version, "2.0.0")
    return response
end function

' test that the TealiumBuilder assigns account and profile correctly
function TestCase__Main_TealiumSetsAccountProfile() as String

    response = ""
    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$).Build()

        response += m.AssertEqual(tealium.account, testAccount$, "Incorrect Account")
        response += m.AssertEqual(tealium.profile, testProfile$, "Incorrect Profile")

    end for
    return response
end function

' test that the TealiumBuilder assigns environment correctly
function TestCase__Main_TealiumSetsEnvironment() as String
    
    response = ""

    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$).SetEnvironment(testEnv$).Build()

        response += m.AssertEqual(tealium.account, testAccount$, "Invalid Account")
        response += m.AssertEqual(tealium.profile, testProfile$, "Invalid Profile")
        response += m.AssertEqual(tealium.environment, testEnv$, "Invalid Env")

    end for
    return response
end function

' test that the TealiumBuilder assigns datasource correctly
function TestCase__Main_TealiumSetsDatasource() as String
    response = ""
    for i = 1 to 5

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testDatasource$ = "testDatasource" + Rnd(1000000000).toStr()

        tealium = TealiumBuilder(testAccount$, testProfile$).SetDatasource(testDatasource$).Build()

        response += m.AssertEqual(tealium.account, testAccount$, "Account does not match")
        response += m.AssertEqual(tealium.profile, testProfile$, "Profile does not match")
        response += m.AssertEqual(tealium.datasource, testDatasource$, "Datasources does not match")

    end for
    return response
end function

' test that the TealiumBuilder won't accept malformed parameters for account, profile, environment, or datasource
function TestCase__Main_TealiumBuilderRejectsMalformedParams() as String
    
    response = ""
    response += m.AssertInvalid(TealiumBuilder("", "testProfile").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "testProfile").SetEnvironment("").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "testProfile").SetDatasource("").Build(), "Builder is not invalid")

    response += m.AssertInvalid(TealiumBuilder("test Account", "testProfile").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "test Profile").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "testProfile").SetEnvironment("test environment").Build(), "Builder is not invalid")
    response += m.AssertInvalid(TealiumBuilder("testAccount", "testProfile").SetDatasource("test datasource").Build(), "Builder is not invalid")
    return response
end function

'----------------------------------
'Unit tests for "SetLogLevel"
'----------------------------------

'test the "_GetLogLevel" function
function TestCase__Main_TealiumGetLogLevel() as String
    response = ""
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

    logLevel% = tealium._TealiumLog.logLevelThreshold
    response += m.AssertTrue(logLevel% >= 0, "Loglevel Invalid")
    response += m.AssertTrue(logLevel% <= 3, "Loglevel Invalid")
    return response
end function

'test the "SetLogLevel" function
function TestCase__Main_TealiumSetLogLevel() as String
    testAccount = "testAccount"
    testProfile = "testProfile"

    ' test each of the possible log levels
    response = ""
    for i = 0 to 3
        tealium = TealiumBuilder(testAccount, testProfile).SetLogLevel(i).Build()
        response += m.AssertTrue(tealium._tealiumLog.logLevelThreshold=i, "Threshold doesn't match")
    end for
    return response
end function

'test setting the log level through the builder constructor
function TestCase__Main_TealiumSetLogLevelViaConstructor() as String
    testAccount = "testAccount"
    testProfile = "testProfile"

    ' test each of the possible log levels
    response = ""
    for i = 0 to 3
        tealium = TealiumBuilder(testAccount, testProfile, i).Build()
        response += m.AssertTrue(tealium._tealiumLog.logLevelThreshold=i, "Threshold doesn't match")
    end for
    return response
end function

'test ResetSessionId
function TestCase__Main_TealiumResetSessionId() as String
    p = CreateObject("roMessagePort")

    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

    response = ""
    for i=1 to 10
        'get current session id
        oldSessionId = tealium.sessionId

        'wait for a random time between 1 second and 4 seconds
        wait(Rnd(3000) + 1000, p)

        'reset the session id
        tealium.ResetSessionId()
        newSessionId = tealium.sessionId

        'assert the old and new session id are different
        response += m.AssertFalse(oldSessionId=newSessionId, "Session Ids don't match")


        print "old session id: " oldSessionId
        print "new session id: " newSessionId
    end for
    return response
end function

'check that randomNumbers are random for each instance and the number is 16 characters'
function TestCase__Main_TealiumGetRandomNumber() as String
    response = ""
    tealium = TealiumBuilder("account1", "profile").Build()
    random1 = tealium._GetRandomNumber()

    tealium2 = TealiumBuilder("account2", "profile").Build()
    random2 = tealium2._GetRandomNumber()

    tealium3 = TealiumBuilder("account3", "profile").Build()
    random3 = tealium3._GetRandomNumber()

    tealium4 = TealiumBuilder("account4", "profile").Build()
    random4 = tealium4._GetRandomNumber()

    tealium5 = TealiumBuilder("account5", "profile").Build()
    random5 = tealium5._GetRandomNumber()

    tealium6 = TealiumBuilder("account6", "profile").Build()
    random6 = tealium6._GetRandomNumber()

    randomArray = [random1, random2, random3, random4, random5, random6]

    for i=0 to randomArray.Count()-1
        print randomArray.GetEntry(i)
        for k=i+1 to randomArray.Count()
            response += m.AssertNotEqual(randomArray.GetEntry(i), randomArray.GetEntry(k), "Number isn't random")
        end for
    end for

    response += m.AssertTrue(Len(random1)=16, "Length isn't correct")
    response += m.AssertTrue(Len(random2)=16, "Length isn't correct")
    response += m.AssertTrue(Len(random3)=16, "Length isn't correct")
    response += m.AssertTrue(Len(random4)=16, "Length isn't correct")
    response += m.AssertTrue(Len(random5)=16, "Length isn't correct")
    response += m.AssertTrue(Len(random6)=16, "Length isn't correct")
    return response
end function

'Make sure 2 tealium instances created have different vids
function TestCase__Main_DuplicateVisitorId() as String
    tealium1 = TealiumBuilder("account", "profile").Build()
    tealium2 = TealiumBuilder("anotheraccount", "profile").Build()
    visitorId1 = tealium1.visitorId
    visitorId2 = tealium2.visitorId
    return m.AssertNotEqual(visitorId1, visitorId2, "Values are equal")
end function

'Make sure the reset vid works
function TestCase__Main_ResetVisitorId() as String
    tealium = TealiumBuilder("resetAccount", "profile").Build()
    vidOriginal = tealium.visitorId
    tealium._ResetVisitorId()
    vidNew = tealium.visitorId
    print "original vid: " vidOriginal
    print "new vid: " vidNew
    return m.AssertNotEqual(vidOriginal, vidNew, "Visitor Ids Match")
end function

'Check persistence of visitor id
function TestCase__Main_PersistVisitorId() as String
    tealium = TealiumBuilder("resetAccount", "profile").Build()
    vidOriginal = tealium.visitorId
    'Directly call for visitor Id
    vidCheck = tealium._GetVisitorId()
    return m.AssertEqual(vidOriginal, vidCheck)
end function

'------------------------------------------------------------
'Track Event Unit Tests
'------------------------------------------------------------

function TestCase__Main_CreateTealiumCollect() as String
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

    collect = CreateTealiumCollect(tealium._tealiumLog)

    return m.AssertNotInvalid(collect)
end function

' test that TealiumBuilder creates an object with required properties
function TestCase__Main_TealiumCollectHasProperties() as String
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

    collect = CreateTealiumCollect(tealium._tealiumLog)

    'Check that the tealium object contains required properties
    requiredProps = [
        "_DispatchEvent"
        "_SendHttpRequest"
        "_tealiumLog"
    ]

    hasInvalidProp = false
    for each prop in requiredProps
        if collect[prop] = invalid then
            hasInvalidProp = true
        end if
    end for
    return m.assertFalse(hasInvalidProp)
end function

function TestCase__Main_SendHttpRequestRecievesCorrectParams() as String
    response = ""
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

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

    response += m.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/event")
    response += m.AssertEqual(collect.testResults.params, FormatJson({"data":"data","test":"test"}))
    response += m.AssertEqual(collect.testResults.callbackObj, callbackObj)

    ' override the default url
    collect.SetBaseURL("https://mydomain.com/event")
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    response += m.AssertEqual(collect.testResults.url, "https://mydomain.com/event")
    response += m.AssertEqual(collect.testResults.params, FormatJson({"data":"data","test":"test"}))
    response += m.AssertEqual(collect.testResults.callbackObj, callbackObj)
    return response
end function

function TestCase__Main_SendHttpRequestWithDefaultUrl() as String
    response = ""
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

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

    response += m.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/event")
    response += m.AssertEqual(collect.testResults.params, FormatJson({"data":"data","test":"test"}))
    response += m.AssertEqual(collect.testResults.callbackObj, callbackObj)
    return response
end function

function TestCase__Main_SendHttpRequestCanOverrideUrl() as String
    response = ""
    testAccount = "testAccount"
    testProfile = "testProfile"

    tealium = TealiumBuilder(testAccount, testProfile).Build()

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
    newURL = collect.SetBaseURL("https://mydomain.com/event")
    collect._DispatchEvent({test: "test", data: "data"}, callbackObj)

    response += m.AssertEqual(collect.testResults.url, "https://mydomain.com/event")
    response += m.AssertEqual(collect.testResults.params, FormatJson({"data":"data","test":"test"}))
    response += m.AssertEqual(collect.testResults.callbackObj, callbackObj)
    return response
end function

function TestCase__Main_TealiumTrackEvent() as String
    response = ""
    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    testDatasource = "testDatasource"

    tealium = TealiumBuilder(testAccount, testProfile).SetEnvironment(testEnv).SetDatasource(testDatasource).Build()

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

    ' check the url and callback are correct
    response += m.AssertEqual(collect.testResults.url, "https://collect.tealiumiq.com/event")
    response += m.AssertEqual(collect.testResults.callbackObj, callbackObj)

    paramsObject = ParseJson(collect.testResults.params)
    response += m.AssertEqual(paramsObject["data"], "data")
    response += m.AssertEqual(paramsObject["test"], "test")
    response += m.AssertEqual(paramsObject["tealium_account"], "testAccount")
    response += m.AssertEqual(paramsObject["tealium_datasource"], "testDatasource")
    response += m.AssertEqual(paramsObject["tealium_environment"], "testEnv")
    response += m.AssertEqual(paramsObject["tealium_profile"], "testProfile")
    response += m.AssertEqual(paramsObject["event_name"], "testEvent")
    response += m.AssertEqual(paramsObject["tealium_event"], "testEvent")
    response += m.AssertEqual(paramsObject["tealium_event_type"], "activity")
    response += m.AssertEqual(paramsObject["tealium_library_name"], "roku")
    response += m.AssertEqual(paramsObject["tealium_library_version"], "2.0.0")
    return response
end function

function TestCase__Main_CreateTealiumShim() as String
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

    hasInvalidProp = false
    for each prop in requiredProps
        if tealium[prop] = invalid then
            hasInvalidProp = true
        end if
    end for
    return m.AssertFalse(hasInvalidProp)
end function