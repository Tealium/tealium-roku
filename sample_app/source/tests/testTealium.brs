'testTealium.brs - tests for Tealium-Roku components using Mark Roddy's Brightscript testing framework
'
'Authors: Chris Anderberg, Jason Koo, Karen Tamayo, Merritt Tidwell
'License: See the accompanying License.txt file for full license details'
'Copyright (C) 2016 Tealium Inc.
'
'--------------------------------
'Unit tests for "createTealium"
'--------------------------------

' test that the createTealium function creates an object with required properties
Function testTealiumHasProperties(t as Object)
    print "Entering testTealiumHasProperties"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    tealium = createTealium(testAccount, testProfile, testEnv, 3)

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

    For Each prop in requiredProps
        t.assertNotInvalid(tealium[prop])
    End For
End Function

' test that _getAccountInfo returns the correct info
Function testTealiumGetAccountInfo(t as Object)
    print "Entering testTealiumGetAccountInfo"
    
    For i=1 To 100
        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()
    
        tealium = createTealium(testAccount$, testProfile$, testEnv$, 3)
        accountInfo = tealium._getAccountInfo()
        
        t.assertEqual(accountInfo.tealium_account, testAccount$)
        t.assertEqual(accountInfo.tealium_profile, testProfile$)
        t.assertEqual(accountInfo.tealium_environment, testEnv$)
    End For
End Function

' test that _getLibraryInfo returns the correct info
Function testTealiumGetLibraryInfo(t as Object)
    print "Entering testTealiumGetLibraryInfo"
    
    testAccount$ = "testAccount" + Rnd(1000000000).toStr()
    testProfile$ = "testProfile" + Rnd(1000000000).toStr()
    testEnv$ = "testEnv" + Rnd(1000000000).toStr()

    tealium = createTealium(testAccount$, testProfile$, testEnv$, 3)
    libraryInfo = tealium._getLibraryInfo()
    
    t.assertEqual(libraryInfo.tealium_library_name, "roku")
    t.assertEqual(libraryInfo.tealium_library_version, "1.1.0")
End Function

' test that the createTealium function assigns account, profile, and environment correctly
Function testCreateTealiumSetsAccountProfileEnvironment(t as Object)
    print "Entering testtestTealiumSetsAccountProfileEnvironment"

    For i=1 To 100

        testAccount$ = "testAccount" + Rnd(1000000000).toStr()
        testProfile$ = "testProfile" + Rnd(1000000000).toStr()
        testEnv$ = "testEnv" + Rnd(1000000000).toStr()

        tealium = createTealium(testAccount$, testProfile$, testEnv$, 3)

        'Check that the account, profile, and environment were correctly assigned
'        print "Account assigned : " + tealium.account
'        print "Profile assigned : " + tealium.profile
'        print "Environment assigned : " + tealium.environment

        t.assertEqual(tealium.account, testAccount$)
        t.assertEqual(tealium.profile, testProfile$)
        t.assertEqual(tealium.environment, testEnv$)

    End For
End Function

' test that the createTealium function won't accept malformed parameters for account, profile, or environment
Function testCreateTealiumRejectsMalformedParams(t as Object)
        print "Entering testCreateTealiumRejectsMalformedParams"
        
        'should reject empty strings
        t.assertInvalid(createTealium("", "testProfile", "testEnvironment", 3))
        t.assertInvalid(createTealium("testAccount", "", "testEnvironment", 3))
        t.assertInvalid(createTealium("testAccount", "testProfile", "", 3))
        
        'should reject params with spaces
        t.assertInvalid(createTealium("test account", "testProfile", "testEnvironment", 3))
        t.assertInvalid(createTealium("testAccount", "test profile", "testEnvironment", 3))
        t.assertInvalid(createTealium("testAccount", "testProfile", "test environment", 3))
End Function

'----------------------------------
'Unit tests for "SetLogLevel"
'----------------------------------

'test the "_getLogLevel" function
Function testTealiumGetLogLevel(t as Object)
    print "Entering testTealiumGetLogLevel"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    tealium = createTealium(testAccount, testProfile, testEnv, 3)

    print "get log level"
    logLevel% = tealium._tealiumLog.logLevelThreshold
    print "test log level is in range"
    t.assertTrue(logLevel% >= 0)
    t.assertTrue(logLevel% <= 3)
End Function

'test the "SetLogLevel" function
Function testTealiumSetLogLevel(t as Object)
    print "Entering testTealiumSetLogLevel"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"

    ' test each of the possible log levels
    For i=0 To 3
        tealium = createTealium(testAccount, testProfile, testEnv, i)
        t.assertTrue(tealium._tealiumLog.logLevelThreshold=i)
    End For
End Function

'test ResetSessionId
Function testTealiumResetSessionId(t as Object)
    print "Entering testTealiumResetSessionId"
    
    p = CreateObject("roMessagePort")
    
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    For i=1 to 10
        'get current session id
        oldSessionId = tealium.sessionId
        print("waiting...")
        
        'wait for a random time between 1 second and 4 seconds
        wait(Rnd(3000) + 1000, p)
        
        'reset the session id
        tealium.ResetSessionId()
        newSessionId = tealium.sessionId
        
        'assert the old and new session id are different
        t.assertFalse(oldSessionId=newSessionId)
        
        
        print "old session id: " oldSessionId
        print "new session id: " newSessionId
    End For
End Function

'check that randomNumbers are random for each instance and the number is 16 characters'
Function testTealiumGetRandomNumber(t as Object)
    print "Entering testGetRandomNumber"

    tealium = createTealium("account1", "profile", "dev", 3)
    random1 = tealium._getRandomNumber()

    tealium2 = createTealium("account2", "profile", "dev", 3)
    random2 = tealium2._getRandomNumber()

    tealium3 = createTealium("account3", "profile", "dev", 3)
    random3 = tealium3._getRandomNumber()

    tealium4 = createTealium("account4", "profile", "dev", 3)
    random4 = tealium4._getRandomNumber()

    tealium5 = createTealium("account5", "profile", "dev", 3)
    random5 = tealium5._getRandomNumber()

    tealium6 = createTealium("account6", "profile", "dev", 3)
    random6 = tealium6._getRandomNumber()

    randomArray = [random1, random2, random3, random4, random5, random6]

    for i=0 to randomArray.Count()-1
        print randomArray.GetEntry(i)
        for k=i+1 to randomArray.Count()
            t.assertNotEqual(randomArray.GetEntry(i), randomArray.GetEntry(k))
        end for
    end for

    t.assertTrue(Len(random1)=16)
    t.assertTrue(Len(random2)=16)
    t.assertTrue(Len(random3)=16)
    t.assertTrue(Len(random4)=16)
    t.assertTrue(Len(random5)=16)
    t.assertTrue(Len(random6)=16)

End Function

'Make sure 2 tealium instances created have different vids
Function testDuplicateVisitorId(t as Object)
    tealium1 = createTealium("account", "profile", "env", 3)
    tealium2 = createTealium("anotherAccount", "profile", "env", 3)
    visitorId1 = tealium1.visitorId
    visitorId2 = tealium2.visitorId
    t.assertNotEqual(visitorId1, visitorId2)
End Function

'Make sure the reset vid works
Function testResetVisitorId(t as Object)
    tealium = createTealium("resetAccount", "profile", "env", 3)
    vidOriginal = tealium.visitorId
    tealium._resetVisitorId()
    vidNew = tealium.visitorId
    print "original vid: " vidOriginal
    print "new vid: " vidNew
    t.assertNotEqual(vidOriginal, vidNew)
End Function

'Check persistence of visitor id
Function testPersistVisitorId(t as Object)
    tealium = createTealium("resetAccount", "profile", "env", 3)
    vidOriginal = tealium.visitorId
    'Directly call for visitor Id
    vidCheck = tealium._getVisitorId()
    t.assertEqual(vidOriginal, vidCheck)
End Function

'------------------------------------------------------------
'Track Event Unit Tests
'------------------------------------------------------------

Function testCreateTealiumCollect(t as Object)
    print "......................................................."
    print "Entering testCreateTealiumCollect"
    
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    collect = createTealiumCollect(tealium._tealiumLog)
    
    t.assertNotInvalid(collect)
End Function

' test that the createTealium function creates an object with required properties
Function testTealiumCollectHasProperties(t as Object)
    print "......................................................."
    print "Entering testTealiumCollectHasProperties"

    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    collect = createTealiumCollect(tealium._tealiumLog)

    'Check that the tealium object contains required properties
    requiredProps = [
        "_dispatchEvent"
        "_sendHttpRequest"
        "_tealiumLog"
        "_appendQueryParams"
    ]

    For Each prop in requiredProps
        t.assertNotInvalid(collect[prop])
    End For
End Function

Function testAppendQueryParams(t as Object)
    print "......................................................."
    print "Entering testAppendQueryParams"

    ' create a tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    ' create a collect object
    collect = createTealiumCollect(tealium._tealiumLog)
    
    urlTransfer = CreateObject("roUrlTransfer")
    
    ' check that the _appendQueryParams function returns expected results for various input
    t.assertEqual(collect._appendQueryParams(urlTransfer, {}), "")
    t.assertEqual(collect._appendQueryParams(urlTransfer, {test: "test"}), "test=test")
    t.assertEqual(collect._appendQueryParams(urlTransfer, {test: "test", data: "data"}), "data=data&test=test")
    t.assertEqual(collect._appendQueryParams(urlTransfer, {test: "test", data: "data", a: "a", z: "z"}), "a=a&data=data&test=test&z=z")
    t.assertEqual(collect._appendQueryParams(urlTransfer, {data: "test", test: "data", z: "a", a: "z"}), "a=z&data=test&test=data&z=a")
End Function

Function testSendHttpRequestRecievesCorrectParams(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestRecievesCorrectParams"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    ' create the collect object
    collect = createTealiumCollect(tealium._tealiumLog)
    
    ' create property for saving test results
    collect.testResults = {}
    
    ' create dummy callback function that does nothing
    dummyCallback = Function(event)
    End Function
    
    ' create dummy callback object with dummy callback function
    callbackObj = {callback: dummyCallback}
    
    ' stub the _sendHttpRequest function to simply save the parameters it receives into the test results parameter
    collect._sendHttpRequest = Function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.callbackObj = callbackObj
    End Function
    
    ' run the test for a couple cases
    collect._dispatchEvent({test: "test", data: "data"}, callbackObj)
    
    t.assertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.assertEqual(collect.testResults.params, "data=data&test=test")
    t.assertEqual(collect.testResults.callbackObj, callbackObj)
    
    ' override the default url
    collect.SetBaseURL("https://mydomain.com/test.gif")
    collect._dispatchEvent({test: "test", data: "data"}, callbackObj)
    
    t.assertEqual(collect.testResults.url, "https://mydomain.com/test.gif")
    t.assertEqual(collect.testResults.params, "data=data&test=test")
    t.assertEqual(collect.testResults.callbackObj, callbackObj)
End Function

Function testSendHttpRequestWithDefaultUrl(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestWithDefaultUrl"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    ' create the collect object
    collect = createTealiumCollect(tealium._tealiumLog)
    
    ' create property for saving test results
    collect.testResults = {}
    
    ' create dummy callback function that does nothing
    dummyCallback = Function(event)
    End Function
    
    ' create dummy callback function that does nothing
    callbackObj = {callback: dummyCallback}
    
    ' shim the _sendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__sendHttpRequest = collect._sendHttpRequest
    collect._sendHttpRequest = Function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.urlTransfer = urlTransfer
        m.testResults.callbackObj = callbackObj
        m.testResults.fullUrl = m.__sendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    End Function
    
    ' run the test using the shimmed version of _sendHttpRequest using invalid for the default url
    collect._dispatchEvent({test: "test", data: "data"}, callbackObj)
    
    t.assertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.assertEqual(collect.testResults.params, "data=data&test=test")
    t.assertEqual(collect.testResults.callbackObj, callbackObj)
End Function

Function testSendHttpRequestCanOverrideUrl(t as Object)
    print "......................................................."
    print "Entering testSendHttpRequestCanOverrideUrl"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    ' create the collect object
    collect = createTealiumCollect(tealium._tealiumLog)
    
    ' create property for saving test results
    collect.testResults = {}
    
    ' create dummy callback function that does nothing
    dummyCallback = Function(event)
    End Function
    
    ' create dummy callback function that does nothing
    callbackObj = {callback: dummyCallback}
    
    ' shim the _sendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__sendHttpRequest = collect._sendHttpRequest    
    collect._sendHttpRequest = Function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.urlTransfer = urlTransfer
        m.testResults.callbackObj = callbackObj
        m.testResults.fullUrl = m.__sendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    End Function
    
    ' run the test using the shimmed version of _sendHttpRequest overriding the default url
    newURL = collect.SetBaseURL("https://mydomain.com/test.gif")
    collect._dispatchEvent({test: "test", data: "data"}, callbackObj)
    
    t.assertEqual(collect.testResults.url, "https://mydomain.com/test.gif")
    t.assertEqual(collect.testResults.params, "data=data&test=test")
    t.assertEqual(collect.testResults.callbackObj, callbackObj)
End Function

Function testTealiumTrackEvent(t as Object)
    parseParams = Function (params as String) as Object
        ' split a string by all its ampersand "&" symbols
        splitStrByAmpersand = Function (s as String) as Object
            c = "&"
            result = []
            curStr = ""
            
            For i=1 to Len(s)
                If mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                Else
                    curStr = curStr + mid(s, i, 1)
                End If
            End For
            
            result.push(curStr)
            curStr = ""
            
            return result
        End Function
        
        ' split a string by all its equal "=" symbols
        splitStrByEquals = Function (s as String) as Object
            c = "="
            result = []
            curStr = ""
            
            For i=1 to Len(s)
                If mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                Else
                    curStr = curStr + mid(s, i, 1)
                End If
            End For
            
            result.push(curStr)
            curStr = ""
            
            return result
        End Function
        
        ' given an array and a function that takes a single argument, apply the function
        ' to each element in the array and return a new array
        map = Function (arr as Object, f as Function) as Object
            result = []
            
            For Each e In arr
                result.push(f(e))
            End For
            
            return result
        End Function
        
        ' get array of all key value pairs in the query params
        intermediate = map(splitStrByAmpersand(params), splitStrByEquals)
        
        ' convert the result into an object
        result = {}
        For Each element in intermediate
            result[element[0]] = element[1]
        End For
        
        return result
    End Function
    
    getUrlParams = Function (url as String) as String
        ' split a string by all its question mark "?" symbols
        splitStrByQuestion = Function (s as String) as Object
            c = "?"
            result = []
            curStr = ""
            
            For i=1 to Len(s)
                If mid(s, i, 1)=c
                    result.push(curStr)
                    curStr = ""
                Else
                    curStr = curStr + mid(s, i, 1)
                End If
            End For
            
            result.push(curStr)
            curStr = ""
            
            return result
        End Function
        
        return splitStrByQuestion(url)[1]
    End Function
    
    
    print "......................................................."
    print "Entering testTealiumTrackEvent"

    ' create tealium object
    testAccount = "testAccount"
    testProfile = "testProfile"
    testEnv = "testEnv"
    
    tealium = createTealium(testAccount, testProfile, testEnv, 3)
    
    ' create the collect object
    collect = tealium.tealiumCollect
    
    ' create property for saving test results
    collect.testResults = {}
    
    ' create dummy callback function that does nothing
    dummyCallback = Function(event)
    End Function
    
    ' create dummy callback function that does nothing
    callbackObj = {callback: dummyCallback}
    
    ' shim the _sendHttpRequest function and save the parameters passed in the results parameter
    ' this will call the original function after saving the parameters
    collect.__sendHttpRequest = collect._sendHttpRequest
    collect._sendHttpRequest = Function (url as String, params as String, urlTransfer as Object, callbackObj) as Object
        m.testResults.url = url
        m.testResults.params = params
        m.testResults.callbackObj = callbackObj
        m.testResults.urlTransfer = urlTransfer
        m.testResults.fullUrl = m.__sendHttpRequest(url, params, urlTransfer, callbackObj)
        return m.testResults.fullUrl
    End Function
    
    ' run the test using the shimmed version of _sendHttpRequest using invalid for the default url
    tealium.TrackEvent("activity","testEvent", {test: "test", data: "data"}, callbackObj)
    
    eventData = parseParams(getUrlParams(collect.testResults.fullUrl))
    parsedParams = parseParams(collect.testResults.params)
    
    ' print the sent event data and the params received by _sendHttpRequest for comparison
    'print eventData
    'print parsedParams
    
    ' check the url and callback are correct
    t.assertEqual(collect.testResults.url, "https://collect.tealiumiq.com/vdata/i.gif")
    t.assertEqual(collect.testResults.callbackObj, callbackObj)
    
    ' check that each variable send to the server is correct given
    ' the params recieved by the _sendHttpRequest function
    For Each key in parsedParams
        t.assertEqual(parsedParams[key], eventData[key])
    End For
End Function
