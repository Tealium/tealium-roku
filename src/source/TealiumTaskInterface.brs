function TealiumTask(tealiumTask as Object)
    return {
        init: TealiumTaskInit
        trackView: TealiumTaskTrackView
        trackInteraction: TealiumTaskTrackInteraction
        trackActivity: TealiumTaskTrackActivity
        trackConversion: TealiumTaskTrackConversion
        trackDerived: TealiumTaskTrackDerived
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

sub TealiumTaskTrackInteraction(name as String, payload = {} as Object)
    m._tealiumTaskTrack("interaction", name, payload)
end sub

sub TealiumTaskTrackActivity(name as String, payload = {} as Object)
    m._tealiumTaskTrack("activity", name, payload)
end sub

sub TealiumTaskTrackConversion(name as String, payload = {} as Object)
    m._tealiumTaskTrack("conversion", name, payload)
end sub

sub TealiumTaskTrackDerived(name as String, payload = {} as Object)
    m._tealiumTaskTrack("derived", name, payload)
end sub

sub TealiumTaskTrack(eventType as String, name as String, payload = {} as Object)
    m._tealiumTask.tealiumEvent = {eventType: eventType, name: name, payload: payload}
end sub