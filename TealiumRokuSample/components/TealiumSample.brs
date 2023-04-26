sub init()
    m.top.backgroundURI = "pkg:/images/tealium_background.jpg"

    m.ButtonGroup = m.top.findNode("tealiumButtonGroup")
    m.LayoutGroup = m.top.findNode("layoutGroup")

    m.ButtonGroup.buttons = [ "Track View", "Track Event" ]

    di = CreateObject("roDeviceInfo")
    screenSize = di.GetDisplaySize()
    LayoutGroupRect = m.LayoutGroup.boundingRect()
    centerx = (screenSize.w - LayoutGroupRect.width) / 2
    centery = (screenSize.h - LayoutGroupRect.height) / 2
    m.LayoutGroup.translation = [ centerx, centery ]

    m.ButtonGroup.observeField("buttonSelected","buttonPressed")

    task = m.top.findNode("tealiumTask")
    m.tealiumTask = TealiumTask(task)
    m.tealiumTask.init("tealiummobile", "demo")


    m.top.setFocus(true)
  end sub


  sub buttonPressed()
    data = CreateObject("roAssociativeArray")
    data.testKey = "testValue"
    if m.ButtonGroup.buttonSelected = 0 then
      m.tealiumTask.trackView("tealium_roku_view", data)
    else if m.ButtonGroup.buttonSelected = 1 then
      m.tealiumTask.trackEvent("tealium_roku_event", data)
    end if
  end sub