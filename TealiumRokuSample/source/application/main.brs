sub RunUserInterface(args)
  if args.RunTests = "true"
      print("Starting Tests")
      Runner = TestRunner()

      Runner.SetFunctions([
          TestSuite__Main
      ])

      Runner.Logger.SetVerbosity(3)
      Runner.Logger.SetEcho(false)
      Runner.Logger.SetJUnit(false)
      Runner.SetFailFast(true)
      
      Runner.Run()
      print("Starting Tests")
  end if
  showChannelSGScreen()
end sub
  
sub showChannelSGScreen()
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  screen.CreateScene("TealiumSample")
  screen.show()

  while true
      msg = wait(0, m.port)
      msgType = type(msg)
      if msgType = "roTextScreenEvent" then
          if msg.IsScreenClosed() then
              return
          end if
      end if
  end while
end sub

