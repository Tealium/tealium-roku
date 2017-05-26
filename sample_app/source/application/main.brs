' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Main()
    ShowChannelTextScreen()
end sub


sub ShowChannelTextScreen()

    'Initialize port for event listening
    m.port = CreateObject("roMessagePort")

    'Create UI
    screen = CreateObject("roTextScreen")
    screen.SetMessagePort(m.port)
    screen.SetTitle("Tealium Sample Application")
    screen.AddButton(0, "Trigger Trackable Event")
    screen.AddButton(1, "Test Tealium")
    screen.Show()

    'Initialize Tealium
    teal = TealiumBuilder("tealiummobile", "demo", 3).SetEnvironment("dev").Build()

    while true
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roTextScreenEvent" then
           if msg.isButtonPressed() then
               print "Button pressed..."
                if msg.GetIndex() = 0
                    'Execute a sample Tealium track event
                    Button1Trigger(teal, screen)
                else if msg.GetIndex() = 1
                    'Run tests against the Tealium library
                    Button2Trigger(screen)
                end if
           else if msg.IsScreenClosed() then
                return
           end if
        end if
    end while
end sub

sub Button1Trigger(teal as Object, screen as Object)
    print "Button1"
    'Execute a Tealium track call

    'Optional data dictionary
    data = CreateObject("roAssociativeArray")
    data.testKey = "testValue"

    'Optional callback object
    foo = CreateObject("roAssociativeArray")
    foo.callBack = function (event)
        responseHeaders = event.GetResponseHeaders()
        responseKeys = event.GetResponseHeaders().Keys()
        responseCode = event.GetResponseCode()

        print "Response for track dispatch received: " + responseCode.toStr()
        print "Response headers:"
        for each key in responseKeys
            value = responseHeaders[key]
            print key + " : " + value
        end for

    end function

    'Tealium track call
    teal.TrackEvent("activity", "button pressed", data, foo)

    'Update textView
    screen.AddText(teal._tealiumLog.logFile)
end sub

sub Button2Trigger(screen as Object)

    print "Button 2"
    screen.AddText("Testing in progress, this could take up to 60 seconds. Please wait for testing output.")

    'Run tests
    BrsTestMain()

    'Adds test output to textView
    screen.AddText(m.logfile)

end sub
