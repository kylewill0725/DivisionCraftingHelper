#SingleInstance force
FileInstall, pic.png, %A_AppData%\DivisionCraftingHelper.png

mats := [1, 8, 2, 7, 3, 6, 4, 5, 9, 16, 10, 15, 11, 14, 12, 13]

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


vCrafting := 0

Craft:
	vCrafting := 1
	selected := mats[1]
	Gui, Submit, NoHide
	inpt := [GWP, GDZWP, GTL, GDZTL, GEL, GDZEL, GFB, GDZFB, BWP, BDZWP, BTL, BDZTL, BEL, BDZEL, BFB, BDZFB]
	matStr := ["Gold Weapon Parts", "Gold Weapon Parts (DZ)", "Gold Tools", "Gold Tools (DZ)", "Gold Electronics", "Gold Electronics (DZ)", "Gold Fabric", "Gold Fabric (DZ)", "Blue Weapon Parts", "Blue Weapon Parts (DZ)", "Blue Tools", "Blue Tools (DZ)", "Blue Electronics", "Blue Electronics (DZ)", "Blue Fabric", "Blue Fabric (DZ)"]
	craftCnt := [0]
	confirmStr := ""
	totalCrafts := 0
	hasItems := 0
	
	for k, v in inpt
	{
		if (v)
		{
			hasItems := 1
			totalCrafts += craftCnt[k] := Floor(Mod(k, 2) ? v/5 : v/2)
			confirmStr := append(confirmStr, Format("{1:s}: {2:i}`r", matStr[k], craftCnt[k]))
			
		}
	}
	if !(hasItems)
		return
	
	
	confirmStr := append(confirmStr, "Estimated Time: " . Floor(totalCrafts*(1401/60000)) . " Minutes and " . Floor(totalCrafts*(1401/1000) - Floor((totalCrafts)*(1401/60000))*60) . " Seconds")
	;MsgBox,% 4097,, %confirmStr%
	;IfMsgBox Cancel
		;return
  
	Sleep 3000
	;While not WinActive("ahk_exe TheDivision.exe")
		;Sleep 3000
	if not vCrafting
			return
	
	for k, v in craftCnt
	{
		GuiControl, , Stat,% matStr[k]
		JumpTo(mats[k])
		CraftIt(v)
	}
	GuiControl, , Stat,
	JumpTo(mats[1])
	vCrafting := 0
return

CraftIt(cnt)
{
	global
	
	ctrls := { 1: GWPHD, 8: GDZWPHD, 2: GTLHD, 4: GDZTLHD, 3: GELHD, 6: GDZELHD, 4: GFBHD, 5: GDZFBHD, 9: BWPHD, 16: BDZWPHD, 10: BTLHD, 15: BDZTLHD, 11: BELHD, 14: BDZELHD, 12: BFBHD, 13: BDZFBHD }
	vals := { 1: GWP, 8: GDZWP, 2: GTL, 4: GDZTL, 3: GEL, 6: GDZEL, 4: GFB, 8: GDZFB, 9: BWP, 16: BDZWP, 10: BTL, 15: BDZTL, 11: BEL, 14: BDZEL, 12: BFB, BDZFB }
	
	Loop %cnt%
	{
		;While not WinActive("ahk_exe TheDivision.exe")
			;Sleep 1000
		if not vCrafting 
			return
		
		Sleep 1
		;Send {SPACE Down}
		Sleep 500
		GuiControl, , % ctrls[selected], % vals[selected] - (Mod(selected, 2) ? 5 : 2) == 0 ? emptyString : vals[selected] - (Mod(selected, 2) ? 5 : 2)
		vals[selected] -= (Mod(selected, 2) ? 5 : 2)
		;Send {SPACE Up}
  		Sleep 800
		;Send {ESC Down}
		Sleep 100
		;Send {Esc Up}
		
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
		;While not WinActive("ahk_exe TheDivision.exe")
			;Sleep 1000
		if not vCrafting
			return
		
		;Send, {Up Down}
		Sleep, 1
		selected--
		;Send, {Up Up}
		Sleep, 1		
	}
}

Down(cnt)
{
	global vCrafting
	global selected
	
	Loop %cnt%
	{
		;While not WinActive("ahk_exe TheDivision.exe")
			;Sleep 1000
		if not vCrafting
			return
		
		;Send, {Down Down}
		Sleep, 1
		selected++
		;Send, {Down Up}
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

class material 
{
	
}