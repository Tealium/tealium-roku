' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

Sub Main()
    showChannelTextScreen()
End Sub


Sub showChannelTextScreen()

    'Initialize port for event listening
    m.port = CreateObject("roMessagePort")
    
    'Create UI
    screen = CreateObject("roTextScreen")
    screen.setMessagePort(m.port)
    screen.SetTitle("Tealium Sample Application")
    screen.AddButton(0, "Trigger Trackable Event")
    screen.AddButton(1, "Test Tealium")
    screen.show()
   
    'Initialize Tealium
    teal = createTealium("tealiummobile", "demo", "dev", 3)

    While(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        If msgType = "roTextScreenEvent" then
           If msg.isButtonPressed() Then
               print "Button pressed..."        
                if msg.GetIndex() = 0
                    'Execute a sample Tealium track event
                    button1Trigger(teal, screen)
                Else if msg.GetIndex() = 1
                    'Run tests against the Tealium library
                    button2Trigger(screen)
                End If
           Else If msg.isScreenClosed() Then
                return
           End If
        End If
    End While
End Sub

Sub button1Trigger(teal as Object, screen as Object)
    print "Button1"
    'Execute a Tealium track call
    
    'Optional data dictionary
    data = CreateObject("roAssociativeArray")
    data.testKey = "testValue"
    
    'Optional callback object
    foo = CreateObject("roAssociativeArray")
    foo.callBack = Function (event)
        responseHeaders = event.GetResponseHeaders()
        responseKeys = event.GetResponseHeaders().Keys()        
        responseCode = event.GetResponseCode()

        print "Response for track dispatch received: " + responseCode.toStr()
        print "Response headers:"
        for each key in responseKeys
            value = responseHeaders[key]
            print key + " : " + value
        End for
        
    End Function
    
    'Tealium track call
    teal.TrackEvent("activity", "button pressed", data, foo)

    'Update textView
    screen.AddText(teal._tealiumLog.logFile)
End Sub

Sub button2Trigger(screen as Object)

    print "Button 2"
    screen.AddText("Testing in progress, this could take up to 60 seconds. Please wait for testing output.")

    'Run tests
    BrsTestMain()

    'Adds test output to textView
    screen.AddText(m.logfile)

End Sub
