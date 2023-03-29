#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Lets the script keep runnning after async SetTimer
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx

NoOp() {
}

global NoOpFn := Func("NoOp")

; Locks/Unlocks keystrokes and mouse clicks.
ToggleLock(cmd) {
    SetFormat, IntegerFast, Hex
    Count := 0
    if (cmd) {
      BlockInput, MouseMove
      Loop 0x1FF  ; Blocks keystrokes
      Hotkey, sc%A_Index%, %NoOpFn%, On
      Loop 0x7    ; Blocks mouse clicks
      Hotkey, *vk%A_Index%, %NoOpFn%, On
    } else {
      BlockInput, MouseMoveOff
      Loop 0x1FF  ; Unblocks keystrokes
      Hotkey, sc%A_Index%, %NoOpFn%, Off
      Loop 0x7    ; Unblocks mouse clicks
      Hotkey, *vk%A_Index%, %NoOpFn%, Off
    }
}

global UnBlockerFn := Func("UnBlocker")
UnBlocker() {
    ToggleLock(0)
    SetTimer % UnBlockerFn, off ; deactivates himself
}

Blocker() {
    SetTimer, % UnBlockerFn, 10000
    ToggleLock(1)
}

WindowExec(Win) {
    Blocker()

    OldActive := WinExist("A")
    WinActivate % "ahk_id " Win

    Sleep 200
    Send, {Esc}
    Sleep, 500
    Send, {Esc}
    Sleep 200 

    WinActivate % "ahk_id " OldActive

    UnBlocker()
}

WindowRefresh() {
    if Win := WinExist("^CAPCom.*") {
        TrayTip Refresh, Warning`, refreshing in 30s
        Sleep 30000
        WindowExec(Win)
    } else {
        TrayTip Not Found, Could not find window to refresh
    }
}

WindowRefreshFn := Func("WindowRefresh")
SetTimer, % WindowExecFn, 570000 ; Every 9.5 Minutes

WindowExec()
