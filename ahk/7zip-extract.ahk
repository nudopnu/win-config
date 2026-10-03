#Requires AutoHotkey v2.0
#SingleInstance Force

; Strg+Alt+X im Explorer: markierte Archive mit 7-Zip nach "<Archivname>\" entpacken,
; wie "Entpacken nach ..." im 7-Zip-Kontextmenü.

SevenZip := "C:\Program Files\7-Zip\7zG.exe"
ArchiveExtensions := ["zip", "7z", "rar", "tar", "gz", "tgz", "bz2", "xz"]

#HotIf WinActive("ahk_class CabinetWClass")
^!x:: {
    if !FileExist(SevenZip) {
        MsgBox("7-Zip wurde nicht gefunden:`n" SevenZip, "7-Zip entpacken", "Icon!")
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
        ; Kein Backslash am Ende von -o, sonst maskiert er das schließende Anführungszeichen
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

; Liefert das Explorer-Fenster des aktiven Tabs (Windows 11 hat mehrere Tabs pro Fenster).
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
