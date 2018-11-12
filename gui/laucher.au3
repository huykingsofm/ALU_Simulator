;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		laucher.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose: 	Provide a procedure which run a Laucher to start a series of Metro-UIs of ALU Simulator
;			Morever, it also connect to API to run some special functions
; PUPBLIC FUNCTION:
;	start_laucher()
;=============================================================================================================

; Include some nessessary libraries
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "entry.au3"
#include "ALU.au3"

;============================================================================
; Func start_laucher()
; Purpose: Provide a connection to ALU
;
; Parameters:
;	+ no parameter
; Return:
;	+ no return
;=============================================================================

Func start_laucher()
   #Region LOCAL CONSTANT
   $PY = 250

   $PX_LAUCH = 100
   $PX_CLOSE = 360

   #EndRegion

   #Region ### START Koda GUI section ### Form=
   $laucher = GUICreate("laucher", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor($C_WINDOW)

   $Welcome = GUICtrlCreateLabel("Welcome to ALU Simulator", 0, 0, $W_WINDOW, 250, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 50, 400, 0, "Bahnschrift Condensed")

   $about = GUICtrlCreateLabel("designed by Le Ngoc Huy - UIT K12    ", 0, 155, $W_WINDOW, 50, BitOr($SS_RIGHT, $SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 20, 400, 0, "Bahnschrift Condensed")

   $lauch = GUICtrlCreateLabel("LAUCH", $PX_LAUCH, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   GUICtrlSetState(-1, $GUI_HIDE)

   $close = GUICtrlCreateLabel("CLOSE", $PX_CLOSE, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   GUICtrlSetState(-1, $GUI_HIDE)

   $wait = GUICtrlCreateLabel("Connecting...", 0, 280,$W_WINDOW, 100, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 30, 400, 0, "Time New Romans")

   WinSetTrans($laucher, "", 0)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###


   ; If Connection is not ready, show laucher with message "Connecting..."
   ; Otherwise, start laucher without that message
   $FadeFlag = 0
   If $Connection = -1 Then
	  Fade($laucher, 1)
   Else
	  $FadeFlag = 1
   EndIf

   ; Try to connect with ALU
   $flag = 0

   If $Connection = -1 Then
	  $Connection = ALUConnect()
   EndIf

   ; If connect successful, show control to go to entry of ALU
   If $Connection <> -1 Then
	  GUICtrlSetState($wait, $GUI_HIDE)
	  GUICtrlSetState($lauch, $GUI_SHOW)
	  GUICtrlSetState($close, $GUI_SHOW)


   ; If fail connection, show "Connection error" and exit then
   Else
	  GUICtrlSetData($wait, "Connection Error")
	  Sleep(3000)
	  Exit
   EndIf


   ; Start laucher without message "Connecting..."
   If $FadeFlag = 1 Then
	  Fade($laucher, 1)
	  $FadeFlag = 1
   EndIf


   $fOverLauch = False
   $fOverClose = False

   While 1
	  $cursor = GUIGetCursorInfo($laucher)

	  ; Change status of label if cursor covers it
	  EventOnCover($lauch, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, $PX_LAUCH, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverLauch)
	  EventOnCover($close, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, $PX_CLOSE, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverClose)


	  ; Get and solve click event
	  $click = ControlOnClick($cursor)
	  Switch $click
		 Case $lauch
			Fade($laucher, 0)
			GUIDelete($laucher)
			$flag = 1
			ExitLoop
		 Case $close
			Fade($laucher, 0)
			GUIDelete($laucher)
			$flag = 0
			ExitLoop
	  EndSwitch
   WEnd

   If $flag = 1 Then
	  start_entry()
   EndIf
EndFunc