#SingleInstance force
FileInstall, pic.png, %A_AppData%\DivisionCraftingHelper.png

;Gui Code Start
Gui,Add,Button,gCancel x195 y0 w40 h20 Center,Close
Gui,Add,Button,gHelp x20 y0 w100 h40 Center,Screen Should`rLook Like This
Gui,Font, s6.3 q2
Gui,Font, s10
Gui, Add, Tab2,x0 yp+50, Gold|Gold (DZ)|Blue|Blue (DZ)

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
Gui,Add,Edit,vGDZWP gWPCheck hwndGDZWPHD x40 y80 w100 h20
SetEditCueBanner(GDZWPHD, "Weapon Parts")
Gui,Add,Edit,vGDZTL gTLCheck hwndGDZTLHD x40 yp+25 w100 h20
SetEditCueBanner(GDZTLHD, "Tools")
Gui,Add,Edit,vGDZEL gELCheck hwndGDZELHD x40 yp+25 w100 h20
SetEditCueBanner(GDZELHD, "Electronics")
Gui,Add,Edit,vGDZFB gFBCheck hwndGDZFBHD x40 yp+25 w100 h20
SetEditCueBanner(GDZFBHD, "Fabric")

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
Gui,Add,Edit,vBDZWP gWPCheck hwndBDZWPHD x40 y80 w100 h20
SetEditCueBanner(BDZWPHD, "Weapon Parts")
Gui,Add,Edit,vBDZTL gTLCheck hwndBDZTLHD x40 yp+25 w100 h20
SetEditCueBanner(BDZTLHD, "Tools")
Gui,Add,Edit,vBDZEL gELCheck hwndBDZELHD x40 yp+25 w100 h20
SetEditCueBanner(BDZELHD, "Electronics")
Gui,Add,Edit,vBDZFB gFBCheck hwndBDZFBHD x40 yp+25 w100 h20
SetEditCueBanner(BDZFBHD, "Fabric")

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
oGWP := new Material("Gold Weapon Parts", GWPHD, "GWP", 1, 0)
oGTL := new Material("Gold Tools", GTLHD, "GTL", 2, 0)
oGEL := new Material("Gold Electronics", GELHD, "GEL", 3, 0)
oGFB := new Material("Gold Fabric", GFBHD, "GFB", 4, 0)

oGWPDZ := new Material("Gold Weapon Parts (DZ)", GWPDZHD, "GWPDZ", 8, 1)
oGTLDZ := new Material("Gold Tools (DZ)", GTLDZHD, "GTLDZ", 7, 1)
oGELDZ := new Material("Gold Electronics (DZ)", GELDZHD, "GELDZ", 6, 1)
oGFBDZ := new Material("Gold Fabric (DZ)", GFBDZHD, "GFBDZ", 5, 1)

oBWP := new Material("Blue Weapon Parts", BWPHD, "BWP", 9, 0)
oBTL := new Material("Blue Tools", BTLHD, "BTL", 10, 0)
oBEL := new Material("Blue Electronics", BELHD, "BEL", 11, 0)
oBFB := new Material("Blue Fabric", BFBHD, "BFB", 12, 0)

oBWPDZ := new Material("Blue Weapon Parts (DZ)", BWPDZHD, "BWPDZ", 16, 1)
oBTLDZ := new Material("Blue Tools (DZ)", BTLDZHD, "BTLDZ", 15, 1)
oBELDZ := new Material("Blue Electronics (DZ)", BELDZHD, "BELDZ", 14, 1)
oBFBDZ := new Material("Blue Fabric (DZ)", BFBDZHD, "BFBDZ", 13, 1)

mats := [oGWP, oGTL, oGEL, oGFB, oGWPDZ, oGTLDZ, oGELDZ, oGFBDZ, oBWP, oBTL, oBEL, oBFB, oBWPDZ, oBTLDZ, oBELDZ, oBFBDZ]

Craft:
	vCrafting := 1
	;Currently selected slot
	selected := mats[1].slot
	;Used to update textbox variables
	Gui, Submit, NoHide
	confirmStr := ""
	loadedSlots := Object()
	totalCrafts := 0
	hasItems := 0
	
	for k, v in mats
	{
		temp := % v.var
		cnt := % %temp%
		if (cnt)
		{
			hasItems := 1
			
			totalCrafts += v.isDZ ? cnt//2 : cnt//5
			loadedSlots[k] := v
			confirmStr := append(confirmStr, Format("{1:s}: {2:i}`r", v.name, v.GetCount()))			
		}
	}
	if !(hasItems)
		return
	
	confirmStr := append(confirmStr, "Estimated Time: " . Floor(totalCrafts*(1401/60000)) . " Minutes and " . Floor(totalCrafts*(1401/1000) - Floor((totalCrafts)*(1401/60000))*60) . " Seconds")
	MsgBox,% 4097,, %confirmStr%
	IfMsgBox Cancel
		return
  
	Sleep 3000
	While not WinActive("ahk_exe TheDivision.exe")
		Sleep 3000
	if not vCrafting
			return
	
	for k, v in loadedSlots
	{
		GuiControl, , Stat, % v.name
		JumpTo(v.slot)
		CraftIt(v.GetCount())
	}
	GuiControl, , Stat,
	JumpTo(mats[1].slot)
	vCrafting := 0
return

CraftIt(cnt)
{
	global
	
	Loop %cnt%
	{
		While not WinActive("ahk_exe TheDivision.exe")
			Sleep 1000
		if not vCrafting 
			return
		
		Sleep 1
		Send {SPACE Down}
		Sleep 500
		temp := mats[selected].var
		%temp% -= (mats[selected].isDZ ? 2 : 5)
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
			return
		
		Send, {Up Down}
		Sleep, 1
		selected--
		Send, {Up Up}
		Sleep, 1		
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
			return
		
		Send, {Down Down}
		Sleep, 1
		selected++
		Send, {Down Up}
		Sleep, 1
	}
}

Cancel:
	FileDelete, %A_AppData%\DivisionCraftingHelper.png
	ExitApp
return

Stop:
	vCrafting := 0
return

Help:
	SplashImage, %A_AppData%\DivisionCraftingHelper.png, M2 zw-1 zh500
return

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

class Material {
	
	__New(parName, parHWID, parVar, parSlot, varIsDZ)
	{
		this.name := parName
		this.hwid := parHWID
		this.var := parVar
		this.slot := parSlot
		this.isDZ := varIsDZ
	}
	
	GetCount()
	{
		temp := this.var
		baseCnt := % %temp%
		return this.isDZ ? baseCnt//2 : baseCnt//5
	}

}