function TealiumTask(tealiumTask as Object)
    return {
        init: TealiumTaskInit
        trackView: TealiumTaskTrackView
        trackEvent: TealiumTaskTrackEvent
        _tealiumTask: tealiumTask
        _tealiumTaskTrack: TealiumTaskTrack
    }
end function

sub TealiumTaskInit(account as String, profile as String, logLevel = 3 as Integer, env = "prod" as String)
    m._tealiumTask.account = account
    m._tealiumTask.profile = profile
    m._tealiumTask.logLevel = logLevel
    m._tealiumTask.env = env
    m._tealiumTask.control = "run"
end sub

sub TealiumTaskTrackView(name as String, payload = {} as Object)
    m._tealiumTaskTrack("view", name, payload)
end sub

sub TealiumTaskTrackEvent(name as String, payload = {} as Object)
    m._tealiumTaskTrack("event", name, payload)
end sub

sub TealiumTaskTrack(eventType as String, name as String, payload = {} as Object)
    m._tealiumTask.tealiumEvent = {eventType: eventType, name: name, payload: payload}
end sub