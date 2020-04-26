#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Define DoNothing hotkeys that block defaults (e.g. alt+f4). Blocking is not active until enabled explicitly.
BlockInput, MouseMoveOff   
Hotkey, MButton, DoNothing, Off
Hotkey, XButton1, DoNothing, Off
Hotkey, XButton2, DoNothing, Off
Hotkey, Enter, DoNothing, Off
Hotkey, Alt, DoNothing, Off
Hotkey, Tab, DoNothing, Off
Hotkey, Lwin, DoNothing, Off
Hotkey, Rwin, DoNothing, Off
Hotkey, !F4, DoNothing, Off
Hotkey, !Tab, DoNothing, Off
Hotkey, ^Esc, DoNothing, Off
;Hotkey, ^!Del, DoNothing, Off ; cannot block ctrl+alt+del in new windows versions.

; Global variables and function references.
global Stop := True
global OpenBoxesFunc := Func("OpenBoxes")
SendTkeyFunc := Func("SendKey").Bind("t")
global PressTifVermActiveFunc := Func("DoIfWinActive").Bind("ahk_class main_window", SendTkeyFunc)

; Hotkeys active inside Vermintide 2.
#IfWinActive ahk_class main_window
^t::AutoTag()
^b::SpoilsOfWar()
^i::EquipStrongestItems()
^s::SelectWeakestSalvageItems()
#IfWinActive

; Global Hotkeys
^+c::StopAll()
^+s::Status()

; High level functions

AutoTag()
{
    ToolTipTopLeft2s("Starting autotag")
    Stop := False
    SetTimer, % PressTifVermActiveFunc, 100
}

SelectWeakestSalvageItems()
{
    BlockInputs(true)
    StartY := 300
    Counter := 0
    Max := 9

    While (StartY <= 860) 
    {
        StartX := 1315
        While (StartX <= 1675)
        {
            If (Counter >= Max)
            {
                BlockInputs(false)
                MsgBox, 3, % "Salvage Items?", % "Do you really want to salvage these items?"
                IfMsgBox Yes
                {
                    PressSalvageButton()
                    ;MsgBox,, % "Salvaged", % "Items have been salvaged."
                }
                Else IfMsgBox Cancel
                { 
                    CancelSalvage()
                    ;MsgBox,, % "Cancelled", % "Salvage was cancelled!"
                }
                Return 
            } 

            MouseClick, Right, % StartX, % StartY  

            Counter++
            StartX += 90
            Sleep 200
        }
        StartY += 90
    }
    BlockInputs(false)
}

PressSalvageButton()
{
    BlockInputs(True)
    Stop := False
    ClickTwoSecondsFunc := Func("ClickSecondsImage")
    WaitForImageAndDo(["salvage.bmp", "salvage_hl.bmp"], 905, 885, 1011, 915, ClickTwoSecondsFunc)
    BlockInputs(False)
}

ClickSecondsImage(X, Y)
{
    MouseClick, Left, % X, % Y,,, D
    Sleep, 1000
    MouseClick, Left, % X, % Y,,, U
}

CancelSalvage()
{
    BlockInputs(true)
    StartY := 510
    
    While (StartY <= 690)
    {
        StartX := 860
        While (StartX <= 1040)
        {
            MouseClick, Right, % StartX, % StartY
            
            StartX += 90
            Sleep 200
        }
        StartY += 90
    }
    BlockInputs(false)
}

SpoilsOfWar()
{
    ToolTipTopLeft2s("Starting auto spoils of war")
    Stop := False
    BlockInputs(true)

    Send, {i down}
    Sleep 200
    Send, {i up}

    WaitForImageAndDo(["spo_war.bmp", "spo_war_hl.bmp"], 190, 880, 410, 915, Func("LeftClick"))

    If (Stop = True) {
        return
    }

    OpenBoxesFunc.Call()
    if(Stop = False)
    {
        SetTimer, % OpenBoxesFunc, 200 
    }
}

OpenBoxes()
{
    WaitForImageAndDo(["open.bmp", "open_hl.bmp"], 915, 1000, 1010, 1030, Func("LeftClick"))
    WaitForImageAndDo(["skull.bmp", "skull_hl.bmp"], 270, 490, 440, 650, Func("OpenThreeSlots"))
    WaitForImageAndDo(["continue.bmp", "continue_hl.bmp"], 875, 995, 1050, 1035, Func("LeftClick"))
    ;WaitForImageAndDo(["close.bmp", "close_hl.bmp"], 1630, 995, 1745, 1035, Func("LeftClick"))
}

EquipStrongestItems()
{
    StopAll()
    BlockInputs(true)
    Send, i
    Sleep, 500
    ; Meele menu open by default
    RightClickStrongestItem()
    Sleep, 500
    ; Click range menu
    MouseClick, Left, 1400, 150
    Sleep, 500
    RightClickStrongestItem()
    Sleep, 500
    ; Click necklace menu
    MouseClick, Left, 1500, 150
    Sleep, 500
    RightClickStrongestItem()
    Sleep, 500
    ; Click charm menu
    MouseClick, Left, 1600, 150
    Sleep, 500
    RightClickStrongestItem()
    Sleep, 500
    ; Click trinket menu
    MouseClick, Left, 1700, 150
    Sleep, 500
    RightClickStrongestItem()
    Sleep, 500
    SendInput, {Escape}
    BlockInputs(false)
}

RightClickStrongestItem() {
    MouseClick, Right, 1300, 300
}

StopAll() {
    If (Stop = 1) {
        ToolTipTopLeft2s("Nothing to stop")
        Return
    }
    ToolTipTopLeft2s("Stopping all makros")
    Stop := 1 
    SetTimer, % OpenBoxesFunc, Off 
    ;SetTimer, % PressTifVermActiveFunc, Off        
    BlockInputs(false)
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

OpenThreeSlots(X, Y)
{
    MouseClick, Left, % X, % Y
    Sleep 500
    MouseClick, Left, % X + 600, % Y
    Sleep 500
    MouseClick, Left, % X + 1200, % Y
}

SendKey(Key)
{
    Send, % Key
}

MoveMouse(X, Y)
{
    MouseMove, % X, % Y
}

LeftClick(X, Y)
{
    MouseClick, Left, % X, % Y
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

WaitForImageAndDo(ImageInput, X1, Y1, X2, Y2, Callback)
{
    Images := isObject(ImageInput) ? ImageInput : [ImageInput]
    Searching := True
    
    while Searching = True && Stop = False
    {
        for Index, Value in Images   
        {
            ImageSearch, OutX, OutY, % X1, % Y1, % X2, % Y2, % "*32 " Value

            switch ErrorLevel 
            {
            case 0:
                ;ToolTipDefault("X: " OutX ", Y: " OutY)
                Callback.Bind(OutX, OutY).Call()
                Searching := False
                break
            case 2:        
                MsgBox, % "Failed to open image file or malformed options"
                Searching := False
                break
            default:
                continue
            }
        }
        Sleep 50
    } 
    
}

DoIfWinActive(Window, Callback)
{
    If (!WinActive(Window) || Stop = True)
        return

    Callback.Call()
}

BlockInputs(toggle)
{
    if(toggle = true) {
       BlockInput, MouseMove
    } else {
       BlockInput, MouseMoveOff   
    }

    OnOrOff := toggle ? "On" : "Off"

	Hotkey, MButton, % OnOrOff
	Hotkey, XButton1, % OnOrOff
	Hotkey, XButton2, % OnOrOff
	Hotkey, Enter, % OnOrOff
	Hotkey, Tab, % OnOrOff
	Hotkey, Lwin, % OnOrOff
	Hotkey, Rwin, % OnOrOff
	Hotkey, !F4, % OnOrOff
	Hotkey, !Tab, % OnOrOff
	Hotkey, ^Esc, % OnOrOff
	;Hotkey, ^!Del, % OnOrOff ; cannot block ctrl+alt+del in new windows versions  
}
	
DoNothing() {
	ToolTipTopLeft2s("User input temporarily disabled")
}
