#Requires AutoHotkey v2.0

#o::{
    if WinExist("ahk_class mintty") {
        WinMaximize("ahk_class mintty")
        WinActivate("ahk_class mintty")
    } else {
        Run('"C:\Program Files\Git\git-bash.exe" --cd-to-home', EnvGet("USERPROFILE"))
        WinWait("ahk_class mintty")
        WinMaximize("ahk_class mintty")
        WinActivate("ahk_class mintty")
    }
}
