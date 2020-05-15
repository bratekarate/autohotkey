#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Define DoNothing hotkeys that block defaults (e.g. alt+f4). Blocking is not active until enabled explicitly.
;BlockInput, MouseMoveOff   
;Hotkey, MButton, DoNothing, Off
;Hotkey, XButton1, DoNothing, Off
;Hotkey, XButton2, DoNothing, Off
;Hotkey, Enter, DoNothing, Off
;Hotkey, Alt, DoNothing, Off
;Hotkey, Tab, DoNothing, Off
;Hotkey, Lwin, DoNothing, Off
;Hotkey, Rwin, DoNothing, Off
;Hotkey, !F4, DoNothing, Off
;Hotkey, !Tab, DoNothing, Off
;Hotkey, ^Esc, DoNothing, Off
;Hotkey, ^!Del, DoNothing, Off ; cannot block ctrl+alt+del in new windows versions.

; Global variables and function references.
global Stop := True
SendWkeyFunc := Func("PressKeyXms").Bind("w", 150)
global PressWifGtaActive := Func("DoIfWinActive").Bind("ahk_class grcWindow", SendWkeyFunc)

; Hotkeys active inside Vermintide 2.
#IfWinActive ahk_class grcWindow
^+t::AutoWalk()
#IfWinActive

; Global Hotkeys
^+c::StopAll()
^+s::Status()

; High level functions

AutoWalk()
{
    ToolTipTopLeft2s("Starting autowalk")
    Stop := False
    SetTimer, % PressWifGtaActive, 20000
}

StopAll() {
    If (Stop = 1) {
        ToolTipTopLeft2s("Nothing to stop")
        Return
    }
    ToolTipTopLeft2s("Stopping all makros")
    Stop := 1 
    SetTimer, % PressWifGtaActive , Off        
}

Status()
{
    If(Stop = 0) {
        ToolTipTopLeft2s("Makro is running")
    } else {
        ToolTipTopLeft2s("Nothing is running")
    }
}

;Wrapper functions for use as function references

SendKey(Key)
{
    Send, % Key
}

PressKeyXms(Key, Ms)
{
    Send, {%Key% down}
    Sleep, % Ms
    Send, {%Key% up}
}

RemoveToolTip()
{
    ToolTip
}

; ToolTip convenience functions

ToolTipTopLeft2s(text) {
    TimedToolTip(text, 0, 0, -2000)
}

TimedToolTip(text, x, y, time)
{
    ToolTip, % text, % x, % y 
    RemoveToolTipFunc := Func("RemoveToolTip")
    SetTimer, % RemoveToolTipFunc, % time
}

; Helper functions

DoIfWinActive(Window, Callback)
{
    If (!WinActive(Window) || Stop = True)
        return

    Callback.Call()
}

