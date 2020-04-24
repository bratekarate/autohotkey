Hotkey, IfWinActive, ahk_class OsWindow
Hotkey, LButton, DoNothing, Off
Hotkey, RButton, DoNothing, Off
Hotkey, MButton, DoNothing, Off
Hotkey, XButton1, DoNothing, Off
Hotkey, XButton2, DoNothing, Off
Hotkey, Enter, DoNothing, Off
Hotkey, Escape, DoNothing, Off
Hotkey, Alt, DoNothing, Off
Hotkey, Tab, DoNothing, Off
Hotkey, Lwin, DoNothing, Off
Hotkey, Rwin, DoNothing, Off
Hotkey, !F4, DoNothing, Off
Hotkey, !Tab, DoNothing, Off
Hotkey, ^Esc, DoNothing, Off
Hotkey, ^!Del, DoNothing, Off

;; Program Files (x86) path
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")

Util := { InputsDisabled: false, disableCount: 0, startupScriptRunning: false }
Util.DisableKeys := Func("DisableKeys")
Util.EnableKeys := Func("EnableKeys")
Util.DoWithActivatedWindowAndReset := Func("DoWithActivatedWindowAndReset")

Wc3Game := { ProgramFilesX86: ProgramFilesX86, GamePath: "\Warcraft III\x86_64\Warcraft III.exe", gameFilterPattern: "foot", Util: Util }
Wc3Game.RunWc3 := Func("RunWc3")
Wc3Game.RunWc3ConnectBnet := Func("RunWc3ConnectBnet")
Wc3Game.GoCustomGameList := Func("GoCustomGameList")
Wc3Game.ConnectToBnet := Func("ConnectToBnet")

Bindings := { hero: 1, footies: 2, turtle: 3, jamie: 4, pocky: 5,  mainBase: 6 }
FootyCommands := { Bindings: Bindings }
FootyCommands.TechAtk := Func("TechAtk")
FootyCommands.SelectMainBase := Func("SelectMainBase")
FootyCommands.SelectMainBaseMilis := Func("SelectMainBaseMilis")
FootyCommands.SelectMainBaseAndCalback := Func("SelectMainBaseAndCalback")
FootyCommands.SelectMainBaseRaw := FUNC("SelectMainBaseRaw")
FootyCommands.SelectHero := Func("SelectHero")
FootyCommands.UpHuman:= Func("UpHuman")
FootyCommands.UpOrc:= Func("UpOrc")
FootyCommands.UpNightelf:= Func("UpNightelf")
FootyCommands.UpUndead:= Func("UpUndead")
FootyCommands.UpEnitian:= Func("UpEnitian")
FootyCommands.DoWithSelectMainbaseAndBackToHero := Func("DoWithSelectMainbaseAndBackToHero")
FootyCommands.DoShit := Func("DoShit")

InGameCommands := { Footy: FootyCommands }

FootyCommands.parent := InGameCommands

AutoRefreshCommands := { RefreshActive: false, Util: Util }
AutoRefreshCommands.ToggleAutoRefresh := Func("ToggleAutoRefresh")
AutoRefreshCommands.ToggleAutoSwitch := Func("ToggleAutoSwitch")
AutoRefreshCommands.StopAutoSwitch := Func("StopAutoSwitch")
AutoRefreshCommands.StopAutoRefresh := Func("StopAutoRefresh")
AutoRefreshCommands.StartAutoRefresh := Func("StartAutoRefresh")
AutoRefreshCommands.StartAutoRefresh := Func("StartAutoRefresh") 
AutoRefreshCommands.DoToggleAutoRefresh := Func("DoToggleAutoRefresh")

LobbyCommands := { AutoRefresh: AutoRefreshCommands }

AutoRefreshCommands.parent := LobbyCommands

GameCommands := { InGame: InGameCommands, Lobby: LobbyCommands, Util: Util}
GameCommands.DispatchWithActivatedWindow := Func("DispatchWithActivatedWindow")
GameCommands.DispatchWithActivatedWindowIfNotStartup := Func("DispatchWithActivatedWindowIfNotStartup")
GameCommands.DispatchIfNotStartup := Func("DispatchIfNotStartup")

LobbyCommands.parent := GameCommands
InGameCommands.parent := GameCommands

Wc3Game.GameCommands := GameCommands

doToggleFunction := GameCommands.Lobby.AutoRefresh.DoToggleAutoRefresh
;; HOTKEYS
	
;; STRG + ALT + W
^!w::Wc3Game.RunWc3ConnectBnet()

;; STRG + ALT + SHIFT * W
^!+w:: 
	CloseWc3IfOpen()
	Wc3Game.RunWc3ConnectBnet()
return

#IfWinActive ahk_class OsWindow

;; STRG + Shift + R
^+r::GameCommands.Lobby.AutoRefresh.ToggleAutoRefresh() 
^+s::GameCommands.Lobby.AutoSwitch.ToggleAutoSwitch()


$~Esc::GameCommands.Lobby.AutoRefresh.StopAutoRefresh()

$~!a::GameCommands.Lobby.AutoRefresh.StopAutoRefresh()

$~!s::GameCommands.Lobby.AutoRefresh.StopAutoRefresh()

^r::DoRefresh()


^+h::GameCommands.InGame.Footy.UpHuman()

^+a::GameCommands.InGame.Footy.TechAtk()

^+o::GameCommands.InGame.Footy.UpOrc()

^+LButton::GameCommands.InGame.Footy.DoShit()

#IfWinActive


;; IN game command functions

DoWithSelectMainbaseAndBackToHero(this, callback) {
	this.SelectMainBase(callback)
	;this.SelectHero()
}

TechAtk(this) {
	techAtk := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("TechAtkRaw"), "Tech +1 Atk Tier")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(techAtk)	
}

TechAtkRaw() {
	send a
}

UpHuman(this) {
	upHuman := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("UpHumanRaw"), "Upgrade Human")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(upHuman)	
}	

UpHumanRaw() {
	send z
}

UpOrc(this) {
	upOrc := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("UpOrcRaw"), "Upgrade Orc")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(upOrc)
}

UpOrcRaw() {
	send x
} 

UpUndead(this) {
	upUndead := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("UpUndeadRaw"), "Upgrade Undead")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(upUndead)
}

UpUndeadRaw() {
	send c
}

UpNightelf(this) {
	upNightelf := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("UpNightelfRaw"), "Upgrade Nightelf")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(upNightelf)
}

UpNightelfRaw() {
	send v
}

UpEnitian(this) {
	upEnitian := this.DoWithSelectMainbaseAndBackToHero.bind(this, Func("UpEnitianRaw"), "Upgrade Enitian")
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(upEnitian)
}

UpEnitianRaw() {
	send w
}

DoShit(this) {
	this.parent.parent.DispatchWithActivatedWindowIfNotStartup(Func("DoShitRaw"), "DO some shit boooi")
}

DoShitRaw() {
	MouseGetPos, xpos, ypos
	Send, x
	Send, {shift down}
	Send, v
	MouseClick, left, xpos, ypos
	send, z
	MouseClick, left, xpos, ypos
	Send, {Shift up}
}

SelectMainBase(this, callback) {
	this.SelectMainBaseMilis(callback, 50)
}

SelectMainBaseMilis(this, callback, delayMilis := 0){
	if(delayMilis == 0) {
		this.SelectMainBaseAndCalback(callback)
	} else {
		selectMainBaseAndCallback := this.SelectMainBaseAndCalback.bind(this, callback)
		SetTimer, % selectMainBaseAndCallback, % -delayMilis
	}
}

SelectMainBaseAndCalback(this, callback) {
	this.SelectMainBaseRaw()
	callback.Call()
}

SelectMainBaseRaw(this) {
	Send % this.Bindings.mainBase
}

SelectHero(this) {
	send % this.Bindings.hero
}

DispatchWithActivatedWindowIfNotStartup(this, callback, message := "", callback2 := "", callbackMessage := "") {
	this.DispatchIfNotStartup(Func("DoWithActivatedWindowAndReset").bind(this.Util, callback), message)
}

DispatchWithActivatedWindow(this, callback, message := "", callback2 := "", callbackMessage := "") {
	Dispatch(Func("DoWithActivatedWindowAndReset").bind(this.Util, callback), message)
}

DispatchIfNotStartup(this, callback, message := "") {	
	Notify("startup: " . this.Util.startupScriptRunning)
	if(this.Util.startupScriptRunning) {
		Notify("Startup Script running. Cannot Execute Game command")
		return
	}
	Dispatch(callback, message)
}

Dispatch(callback, message := "") {
	NotifyIfMessagePresent(message)
	
	callback.Call()	
}

	
;; Launch and Connect Functions

RunWc3ConnectBnet(this)
{
	this.Util.startupScriptRunning := true
	
	if(WinExist("ahk_class OsWindow")) {
		return
	}
	this.RunWc3()
	WaitForWc3ToStart()
	;this.Util.DisableKeys()
	WaitForInternet()
	Sleep, 6000
	this.ConnectToBnet()
	this.GoCustomGameList()
	;this.Util.EnableKeys()
	
	this.Util.startupScriptRunning := false
}

RunWc3(this)
{
	if(FileExist(this.ProgramFilesX86 . this.GamePath))
	{
		Run % this.ProgramFilesX86 . this.GamePath
	}
	Sleep 1000
}

GoCustomGameList(this) 
{
	this.GameCommands.DispatchWithActivatedWindow(Func("SendAltGInput"), "Open Custom Game List")
	;WinActivate, ahk_class OsWindow
	
	Sleep, 4500 
	this.GameCommands.DispatchWithActivatedWindow(Func("SendFilterText").bind(this.gameFilterPattern), "Type in Filter Text")
}

SendFilterText(filterText) {
	Sleep 500
	Send % filterText
	Sleep 500
}

SendAltGInput(){
	Sleep 2000
	SendInput, {alt} g
	Sleep 500
}

ConnectToBnet(this){
	this.GameCommands.DispatchWithActivatedWindow(Func("SendAltBInput"), "Enter Bnet")
	;wait for next screen
	Sleep, 2500

	this.GameCommands.DispatchWithActivatedWindow(Func("SendPw"), "Login with PW")
	Sleep, 6000
}

SendPw() {
	Sleep 500
	Send, egitarre	
	Send, {enter}
	Sleep 1500
}

SendAltBInput() {
	sleep 500
	SendInput, {Alt} b
	Sleep 1500
}

WaitForInternet()
{
	Connected := False
	while(Not Connected){
		RunWait %ComSpec% /C Ping -n 1 -w 3000 google.com,, Hide
		Connected := NOT ErrorLevel	
		if(!Connected) {
			Sleep, 500
		}
	}
}

WaitForWc3ToStart()
{
	while(!WinExist("ahk_class OsWindow")) 
	{	
		Sleep, 100		
	}
}

CloseWc3IfOpen()
{
	Process, Exist, Warcraft III.exe
	if !ErrorLevel = 0
	{
		Process, Close, Warcraft III.exe
		Sleep 100
	} 
}


;; Autorefresh Functions


DoToggleAutoRefresh(this, toggle) {
	this.RefreshActive := toggle
	if(toggle) 
	{
		DoStartAutoRefresh()
	} else 	{
		DoStopAutoRefresh()
	}
}

DoToggleAutoSwitch(this, toggle) {
    this.SwitchActive := toggle
    if(toggle) {
        DoStartAutoSwitch()
    } else {
        DoStopAutoSwitch()
    }
}

ToggleAutoRefresh(this) {
	newActive := !this.RefreshActive
    DispatchToggleAutoRefresh(this, newActive)
}

ToggleAutoSwitchScreen(this) {
    newActive := !this.AutoSwtichActive
    DispatchToggleAutoSwitch(this, newActive)
}

DispatchToggleAutoSwitch(this, newActive) {
    doToggleSwitch := this.DoToggleAutoSwitch.bind(this, newActive)
    this.parent.parent.DispatchIfNotStartup(doToggleSwitch, (newActive ? "activate auto switch" : "deactivate autoswitch"))
}

DispatchToggleAutoRefresh(this, newActive) {
    doToggle := this.DoToggleAutoRefresh.bind(this, newActive)
    this.parent.parent.DispatchIfNotStartup(doToggle, (newActive ? "activate autorefresh" : "deactivate autorefresh"))	
}

DoStartAutoSwitch() {
    SetTimer, SwitchIngame, 100000
}

DoStopAutoSwitch() {
    SetTimer, SwitchIngame, Off
}

DoStartAutoRefresh() {
	SetTimer, Refresh, 15000
}

DoStopAutoRefresh() {
	SetTimer, Refresh, Off
} 

ShortTooltip(ToolText) {
	Tooltip % ToolText
	RemoveTooltipFunc := Func("RemoveTooltip")
	SetTimer % RemoveTooltipFunc, -3000
}

RemoveTooltip() {
	Tooltip
}

SwitchIngame:
    DoWithActivatedWindowAndReset(Util, Func("DoNothing"), "Autoswitch Executed")
return

Refresh: 
	DoWithActivatedWindowAndReset(Util, Func("DoRefresh"), "Autorefresh Executed")
return	

AfterRefreshTooltip() {
	Notify("Autorefresh durchgefuehrt. Kehre zum Ausgangsfenster zurueck" )
}

DoRefresh() {
	Send, {Home}
	SendInput, {Shift Down}{Ctrl Down}
	Send, {End}  ; Start selecting text chat inputs from right to left
	Send, {Shift Up}{Ctrl Up}
	SendInput, {Ctrl Down}x
	SendInput, {Ctrl Up}
	SendInput, {!}closeall{enter}
	SendInput, {!}openall{enter}

	;setTimer, CloseAndOpen, -1000
}

DoWithActivatedWindowAndReset(this, callback, afterWindowSwitchMessage := "", callback2 := "")
{	
	WinGet, active_id, ID, A
	window_active := WinActive("ahk_class OsWindow")
	
	if(!window_active) {		
		WinActivate, ahk_class OsWindow
	}	
	
	this.DisableKeys()
		
	callback.Call()			
			
	if(!window_active)
	{
		WinMinimize, ahk_class OsWindow
		WinActivate, akh_id %active_id%
		if(callback2) {
			callback2.Call()
		}
		if(afterWindowSwitchMessage) {
			tempMessage = "%afterWindowSwitchMessage%"
			Notify("Automatically switched Windows because of: " tempMessage "" . ". Restoring previous window.")
		}
	}	
	this.EnableKeys()
}

EnableKeys(this) {
	if(this.disableCount == 0) {
		ToggleKeys(true)
		this.InputsDisabled := false
	} else {
		this.disableCount--
	}
}

DisableKeys(this) {
	if(!this.InputsDisabled) {
		ToggleKeys(false)
		this.InputsDisabled := true
	}  else {
		this.disableCount++
	}
}

ToggleKeys(toggle) {
	OnOrOff := !toggle ? "On" : "Off"
	;Notify("Toggle keys to " . (toggle ? "On" : "Off"))
	Hotkey, LButton, % OnOrOff
	Hotkey, RButton, % OnOrOff
	Hotkey, MButton, % OnOrOff
	Hotkey, XButton1, % OnOrOff
	Hotkey, XButton2, % OnOrOff
	Hotkey, Enter, % OnOrOff
	Hotkey, Escape, % OnOrOff
	Hotkey, Tab, % OnOrOff
	Hotkey, Lwin, % OnOrOff
	Hotkey, Rwin, % OnOrOff
	Hotkey, !F4, % OnOrOff
	Hotkey, !Tab, % OnOrOff
	Hotkey, ^Esc, % OnOrOff
	Hotkey, ^!Del, % OnOrOff
	Sleep 1000
}

DoNothing() {
	Notify("User input temporarily disabled")
}

Notify(message) {
	ShortTooltip(message)
}


NotifyIfMessagePresent(message) {
	if(message) {
		Notify(message)
	}
}
