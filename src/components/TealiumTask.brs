sub init()
  m.top.functionName = "execute"
end sub

sub execute()
  setupTask()
  startListener()
end sub

sub setupTask()
  m.port = createObject("roMessagePort")
  account = m.top.account
  profile = m.top.profile
  logLevel = m.top.logLevel
  env = m.top.env
  m.tealium = TealiumBuilder(account, profile, logLevel).SetEnvironment(env).Build()

  m.top.observeField("tealiumEvent", m.port)
  
  m.taskCheckInterval = 250
end sub

sub startListener()
  if m.tealium = invalid then
    return
  end if
  
  if m.top.tealiumEvent <> invalid then
    TealiumTrack(m.top.tealiumEvent)
  end if

  while (true)
      message = wait(m.taskCheckInterval, m.port)
      messageType = type(message)
      if messageType = "roSGNodeEvent" then
          field = message.getField()
          if field = "tealiumEvent" then
            TealiumTrack(message.getData())
          end if
      end if
  end while
end sub

sub TealiumTrack(data)
  if data.eventType = "view" then
    m.tealium.TrackView(data.name, data.payload)
  else
    m.tealium.trackEvent(data.name, data.payload)
  end if
end sub