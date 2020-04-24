#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global TestFunc := Func("MyTest")
global SearchImageFunc
global Counter := 0

^t::Test()

Test()
{

    ;SearchImageFunc := Func("WaitForImageAndClick").bind("spo_war.bmp", "spo_war_hl.bmp", 190, 880, 410, 915)
    ;SetTimer, % SearchImageFunc, 50
    WaitForImageAndClick(["spo_war.bmp", "spo_war_hl.bmp"], 190, 880, 410, 915)
}

WaitForImageAndClick(ImageInput, X1, Y1, X2, Y2)
{
    Images := isObject(ImageInput) ? ImageInput : [ImageInput]
    Searching := True
    
    while Searching = True
    {
        for Index, Value in Images   
        {
            ImageSearch, OutX, OutY, % X1, % Y1, % X2, % Y2, % "*32 " Value

            switch ErrorLevel 
            {
            case 0:
                ;ToolTipDefault("X: " OutX ", Y: " OutY)
                MouseClick, Left, % OutX, % OutY
                Searching := False
            case 2:        
                MsgBox, Failed to open image file or malformed options
                Searching := False
            }
        }
        Sleep 50
    } 
    
}


ToolTipDefault(text)
{
    TimedToolTip(text, "", "", 3000)
}

TimedToolTip(text, x, y, time)
{
    ToolTip, % text, % x, % y
    ToolTipOff := Func("RemoveToolTip")
    SetTimer, % ToolTipOff, % -time
}

MyTest()
{
    Sleep, 6000
    Counter += 1
    ToolTip, % "Testtip " Counter, 500, 500
    ToolTipOff := Func("RemoveToolTip")
    SetTimer, % ToolTipOff, -2000
}

RemoveToolTip()
{
    ToolTip
}
