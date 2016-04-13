#SingleInstance force

currentVersion := "1-1-0"

checkVersion()

FileDelete, log.txt

;Gui Code Start
Gui, Main:Default
Gui,Add,Button,gCancel x195 y0 w40 h20 Center,Close
Gui,Add,Button,gHelp x20 y0 Center hwndHelp,Help
Gui,Font, s6.3 q2
Gui,Font, s10
Gui, Add, Tab2,x0 yp+50 hwndTABCTRL, Gold|Gold (DZ)|Blue|Blue (DZ)

Gui, Tab, Gold
Gui,Add,Edit,vGWP gWPCheck hwndGWPHD x40 y80 w100 h20
SetEditCueBanner(GWPHD, "Weapon Parts")
Gui,Add,Edit,vGTL gTLCheck hwndGTLHD x40 yp+25 w100 h20
SetEditCueBanner(GTLHD, "Tools")
Gui,Add,Edit,vGEL gELCheck hwndGELHD x40 yp+25 w100 h20
SetEditCueBanner(GELHD, "Electronics")
Gui,Add,Edit,vGFB gFBCheck hwndGFBHD x40 yp+25 w100 h20
SetEditCueBanner(GFBHD, "Fabric")

Gui, Tab, Gold (DZ)
Gui,Add,Edit,vGWPDZ gWPCheck hwndGWPDZHD x40 y80 w100 h20
SetEditCueBanner(GWPDZHD, "Weapon Parts")
Gui,Add,Edit,vGTLDZ gTLCheck hwndGTLDZHD x40 yp+25 w100 h20
SetEditCueBanner(GTLDZHD, "Tools")
Gui,Add,Edit,vGELDZ gELCheck hwndGELDZHD x40 yp+25 w100 h20
SetEditCueBanner(GELDZHD, "Electronics")
Gui,Add,Edit,vGFBDZ gFBCheck hwndGFBDZHD x40 yp+25 w100 h20
SetEditCueBanner(GFBDZHD, "Fabric")

Gui, Tab, Blue
Gui,Add,Edit,vBWP gWPCheck hwndBWPHD x40 y80 w100 h20
SetEditCueBanner(BWPHD, "Weapon Parts")
Gui,Add,Edit,vBTL gTLCheck hwndBTLHD x40 yp+25 w100 h20
SetEditCueBanner(BTLHD, "Tools")
Gui,Add,Edit,vBEL gELCheck hwndBELHD x40 yp+25 w100 h20
SetEditCueBanner(BELHD, "Electronics")
Gui,Add,Edit,vBFB gFBCheck hwndBFBHD x40 yp+25 w100 h20
SetEditCueBanner(BFBHD, "Fabric")

Gui, Tab, Blue (DZ)
Gui,Add,Edit,vBWPDZ gWPCheck hwndBWPDZHD x40 y80 w100 h20
SetEditCueBanner(BWPDZHD, "Weapon Parts")
Gui,Add,Edit,vBTLDZ gTLCheck hwndBTLDZHD x40 yp+25 w100 h20
SetEditCueBanner(BTLDZHD, "Tools")
Gui,Add,Edit,vBELDZ gELCheck hwndBELDZHD x40 yp+25 w100 h20
SetEditCueBanner(BELDZHD, "Electronics")
Gui,Add,Edit,vBFBDZ gFBCheck hwndBFBDZHD x40 yp+25 w100 h20
SetEditCueBanner(BFBDZHD, "Fabric")

Gui, Tab

Gui,Add,Button,vCF gCraft x64 yp+25 w43 h23,Craft
Gui,Add,Button,gStop x128 yp+0 w43 h23,Stop
Gui,Add,Text,vStat x45 yp+25 w150 h20 Center,
Gui, -SysMenu +OwnDialogs
Gui,Show,w235 h240, Crafting Helper
WinSet, AlwaysOnTop, On, Crafting Helper
;Gui Code End


;Is the function crafting?
vCrafting := 0

;Material declarations
;Naming format: object Color Type (oGoldWeaponParts)
oGWP := new Material("Gold Weapon Parts", GWPHD, "GWP", 1, 15)
oGTL := new Material("Gold Tools", GTLHD, "GTL", 2, 15)
oGEL := new Material("Gold Electronics", GELHD, "GEL", 3, 15)
oGFB := new Material("Gold Fabric", GFBHD, "GFB", 4, 15)

oGWPDZ := new Material("Gold Weapon Parts (DZ)", GWPDZHD, "GWPDZ", 8, 5)
oGTLDZ := new Material("Gold Tools (DZ)", GTLDZHD, "GTLDZ", 7, 5)
oGELDZ := new Material("Gold Electronics (DZ)", GELDZHD, "GELDZ", 6, 5)
oGFBDZ := new Material("Gold Fabric (DZ)", GFBDZHD, "GFBDZ", 5, 5)

oBWP := new Material("Blue Weapon Parts", BWPHD, "BWP", 9, 10)
oBTL := new Material("Blue Tools", BTLHD, "BTL", 10, 10)
oBEL := new Material("Blue Electronics", BELHD, "BEL", 11, 10)
oBFB := new Material("Blue Fabric", BFBHD, "BFB", 12, 10)

oBWPDZ := new Material("Blue Weapon Parts (DZ)", BWPDZHD, "BWPDZ", 16, 5)
oBTLDZ := new Material("Blue Tools (DZ)", BTLDZHD, "BTLDZ", 15, 5)
oBELDZ := new Material("Blue Electronics (DZ)", BELDZHD, "BELDZ", 14, 5)
oBFBDZ := new Material("Blue Fabric (DZ)", BFBDZHD, "BFBDZ", 13, 5)

mats := [oGWP, oGTL, oGEL, oGFB, oGFBDZ, oGELDZ, oGTLDZ, oGWPDZ, oBWP, oBTL, oBEL, oBFB, oBFBDZ, oBELDZ, oBTLDZ, oBWPDZ]

Craft:
	sLog("##############################")
	sLog("Started")
	sLog("##############################")
	vCrafting := 1
	;Currently selected slot
	selected := mats[1].slot
	;Used to update textbox variables
	Gui, Submit, NoHide
	confirmStr := ""
	loadedSlots := Object()
	totalCrafts := 0
	hasItems := 0
	
	sLog("Crafting Counter")
	for k, v in mats
	{
		temp := % v.var
		cnt := % %temp%
		sLog(v.var . ": " . cnt)
		sLog(v.var . ": " . v.GetCount())
		if (cnt)
		{
			hasItems := 1
			
			totalCrafts += v.GetCount()
			loadedSlots[k] := v
			if (v.GetCount())
				confirmStr := append(confirmStr, Format("{1:s}: {2:i}`r", v.name, v.GetCount()))			
		}
	}
	sLog("Total Crafts: " . totalCrafts)
	if !(hasItems)
		return
	
	confirmStr := append(confirmStr, "Estimated Time: " . Floor(totalCrafts*(1401/60000)) . " Minutes and " . Floor(totalCrafts*(1401/1000) - Floor((totalCrafts)*(1401/60000))*60) . " Seconds")
	sLog("Confirm String: " . confirmStr)
	
	MsgBox,% 4097,, %confirmStr%
	IfMsgBox Cancel
	{
		gosub Stop
		return
	}
	
	guiLock()
	
	Sleep 3000
	While not WinActive("ahk_exe TheDivision.exe")
		Sleep 3000
	if not vCrafting
	{
		gosub Stop
		return
	}
	
	for k, v in loadedSlots
	{
		GuiControl, , Stat, % v.name
		sLog("Crafting: " . v.GetCount() . " " . v.name)
		JumpTo(v.slot)
		CraftIt(v.GetCount())
		
	}
	GuiControl, , Stat,
	JumpTo(mats[1].slot)
	gosub Stop
return

CraftIt(cnt)
{
	global
	
	Loop %cnt%
	{
		While not WinActive("ahk_exe TheDivision.exe")
			Sleep 1000
		if not vCrafting
		{
			gosub Stop
			return
		}
		
		Sleep 1
		Send {SPACE Down}
		Sleep 500
		temp := mats[selected].var
		%temp% -= mats[selected].cost
		sLog("Crafted. New count: " . %temp%)
		GuiControl, , % mats[selected].hwid, % %temp% ? %temp% : emptyString
		Send {SPACE Up}
  		Sleep 800
		Send {ESC Down}
		Sleep 100
		Send {Esc Up}
		
	}
}

JumpTo(index)
{
	global selected
	
	sLog("Moving to: " . index)
	if (index - selected >= 0)
		Down(index - selected)
	else
		Up(Abs(index - selected))
}

Up(cnt)
{
	global vCrafting
	global selected
	 
	Loop %cnt%
	{
		While not WinActive("ahk_exe TheDivision.exe")
			Sleep 1000
		if not vCrafting
		{
			gosub Stop
			return
		}
		
		Send, {Up Down}
		Sleep, 1
		selected--
		Send, {Up Up}
		Sleep, 1	
		sLog(selected)
	}
}

Down(cnt)
{
	global vCrafting
	global selected
	
	Loop %cnt%
	{
		While not WinActive("ahk_exe TheDivision.exe")
			Sleep 1000
		if not vCrafting
		{
			gosub Stop
			return
		}
		
		Send, {Down Down}
		Sleep, 1
		selected++
		Send, {Down Up}
		Sleep, 1
		sLog(selected)
	}
}

Cancel:
	FileDelete, %A_AppData%\DivisionCraftingHelper.png
	ExitApp
return

Stop:
	sLog("##############################")
	sLog("Stopped")
	sLog("##############################")
	vCrafting := 0
	guiUnlock()
return

Help:
	run, https://github.com/kylewill0725/DivisionCraftingHelper/blob/master/README.md
return

#If MouseIsOver("MyTestGui") and vCrafting
LButton::
	MouseGetPos, xPos, yPos, hWin, hControl
	if (hControl == "Button4")
	{
		gosub Stop
	} else if ((xPos >= 0 or xPos <= 54) and (yPos >= 75 or yPos <= 100))
	{
		GuiControl, Choose, TABCTRL, 1
	} else if ((xPos >= 55 or xPos <= 124) and (yPos >= 75 or yPos <= 100))
	{
		GuiControl, Choose, TABCTRL, 2
	} else if ((xPos >= 125 or xPos <= 170) and (yPos >= 75 or yPos <= 100))
	{
		GuiControl, Choose, TABCTRL, 3
	}else if ((xPos >= 171 or xPos <= 235) and (yPos >= 75 or yPos <= 100))
	{
		GuiControl, Choose, TABCTRL, 4
	}
return


guiLock()
{
	global
	
	Gui, +E0x08000000
	GuiControl, Disable, Help
	for k, v in mats
	{
		GuiControl, Disable,% v.hwid
	}
}

guiUnlock()
{
	global
	
	Gui, -E0x08000000
	GuiControl, Enable, Help
	for k, v in mats
	{
		GuiControl, Enable,% v.hwid
	}
}


;Credit to https://autohotkey.com/docs/commands/_If.htm
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

; Input Checking
;-----------------------
WPCheck:

	Gui, Submit, NoHide
	
	if WP is not digit
	{
		Send, {Backspace}
	}
return

TLCheck:

	Gui, Submit, NoHide
	
	if TL is not digit
	{
		Send, {Backspace}
	}
return

ELCheck:

	Gui, Submit, NoHide
	
	if EL is not digit
	{
		Send, {Backspace}
	}
return

FBCheck:

	Gui, Submit, NoHide
	
	if FB is not digit
	{
		Send, {Backspace}
	}
return
;-----------------------

; Grey background text
; Credit to https://autohotkey.com/board/topic/76529-solvedgray-placeholder-text/?hl=em_setcuebanner#entry486765
SetEditCueBanner(HWND, Cue) {  ; requires AHL_L

   Static EM_SETCUEBANNER := (0x1500 + 1)

   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)

}

append(str1, str2)
{
	return str1 . str2
}

sLog(str)
{
	FormatTime, now, A_Now, yy-MM-dd hh:mm:ss
	FileAppend,% now . ":" . str . "`n", log.txt
}

checkVersion() 
{
	global currentVersion
	
	web := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	web.Open("GET", "https://raw.githubusercontent.com/kylewill0725/DivisionCraftingHelper/master/version", true)
	web.Send()
	web.WaitForResponse()
	response := web.ResponseText
	StringReplace, response, response, `n,,A
	if (response != currentVersion := "1-1-0"
	{
		MsgBox,4,, "An update is available for this software. Would you like to update?"
		IfMsgBox, Yes
		{
			run, https://github.com/kylewill0725/DivisionCraftingHelper
			ExitApp
		}
	}
}

class Material {
	
	__New(parName, parHWID, parVar, parSlot, varCost)
	{
		this.name := parName
		this.hwid := parHWID
		this.var := parVar
		this.slot := parSlot
		this.cost := varCost
	}
	
	GetCount()
	{
		temp := this.var
		baseCnt := % %temp%
		return baseCnt//this.cost
	}

}
