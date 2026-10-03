#Requires AutoHotkey v2.0
#SingleInstance Force

; Ctrl+Alt+X in Explorer: extract selected archives with 7-Zip to "<archive name>\",
; like "Extract to ..." in the 7-Zip context menu.

SevenZip := "C:\Program Files\7-Zip\7zG.exe"
ArchiveExtensions := ["zip", "7z", "rar", "tar", "gz", "tgz", "bz2", "xz"]

#HotIf WinActive("ahk_class CabinetWClass")
^!x:: {
    if !FileExist(SevenZip) {
        MsgBox("7-Zip not found:`n" SevenZip, "7-Zip extract", "Icon!")
        return
    }
    window := GetActiveExplorerTab(WinActive("A"))
    if !window
        return

    for item in window.Document.SelectedItems() {
        path := item.Path
        SplitPath(path, , &dir, &ext, &nameNoExt)
        if !IsArchive(ext)
            continue
        ; No trailing backslash in -o, otherwise it escapes the closing quote
        Run('"' SevenZip '" x "' path '" -o"' dir '\' nameNoExt '"')
    }
}
#HotIf

IsArchive(ext) {
    for e in ArchiveExtensions
        if (StrLower(ext) = e)
            return true
    return false
}

; Returns the Explorer window of the active tab (Windows 11 has multiple tabs per window).
GetActiveExplorerTab(hwnd) {
    activeTab := 0
    try activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd)
    for w in ComObject("Shell.Application").Windows {
        if (w.hwnd != hwnd)
            continue
        if activeTab {
            static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
            shellBrowser := ComObjQuery(w, IID_IShellBrowser, IID_IShellBrowser)
            ComCall(3, shellBrowser, "uint*", &thisTab := 0)
            if (thisTab != activeTab)
                continue
        }
        return w
    }
    return 0
}
