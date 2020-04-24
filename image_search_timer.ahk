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
    ; search swort image
    ;ImageSearch, OutX, OutY, 780, 970, 850, 1040, *32 sword.bmp 

    ; search friend button in option menu
    ;ImageSearch, OutX, OutY, 90, 1000, 150, 1055, *32 friends.bmp 

    ;switch ErrorLevel 
    ;{
    ;case 0:
    ;    ToolTipDefault("X: " OutX ", Y: " OutY)
    ;    MouseClick, Left, % OutX, % OutY
    ;    Sleep 500
    ;case 1:        
    ;    MsgBox, Image not found
    ;case 2:        
    ;    MsgBox, Failed to open image file or malformed options
    ;default:
    ;    MsgBox, Unknown error
    ;}

    ;SearchImageFunc := Func("WaitForImageAndClick").bind("friends.bmp", 90, 1000, 150, 1055)
    ;SearchImageFunc := Func("WaitEitherImageAndClick").bind("friends.bmp", "friends_hl.bmp", 90, 1000, 150, 1055)
    SearchImageFunc := Func("WaitEitherImageAndClick").bind("spo_war.bmp", "spo_war_hl.bmp", 190, 880, 410, 915)
    SetTimer, % SearchImageFunc, 50
}

WaitForImageAndClick(Image, X1, Y1, X2, Y2)
{
    ImageSearch, OutX, OutY, % X1, % Y1, % X2, % Y2, % "*32 " Image
        
    switch ErrorLevel 
    {
    case 0:
        ToolTipDefault("X: " OutX ", Y: " OutY)
        MouseClick, Left, % OutX, % OutY
        SetTimer, % SearchImageFunc, Off
    case 2:        
        MsgBox, Failed to open image file or malformed options
        SetTimer, % SearchImageFunc, Off
    }
}

WaitEitherImageAndClick(Image1, Image2, X1, Y1, X2, Y2)
{
    Images := [image1, image2]
    
    for Index, Value in Images   
    {
        ImageSearch, OutX, OutY, % X1, % Y1, % X2, % Y2, % "*32 " Value

        switch ErrorLevel 
        {
        case 0:
            ToolTipDefault("X: " OutX ", Y: " OutY)
            MouseClick, Left, % OutX, % OutY
            SetTimer, % SearchImageFunc, Off
        case 2:        
            MsgBox, Failed to open image file or malformed options
            SetTimer, % SearchImageFunc, Off
        }
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
