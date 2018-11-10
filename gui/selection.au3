;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		ALU Simulator.au3
; Language:			AutoIT
; Modified Date:	December 10 2018
; Purpose:			Lauch selection-UI to select operation
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "gui_utilities.au3"
#include "InputForm.au3"
#include "mul3.au3"
#include "mul2.au3"
#include "div3.au3"

#Region ### START Koda GUI section ### Form=
Func start_selection($data, $nbit)
   $selection = GUICreate("Form2", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor(0x222222)

   $W = $W_WINDOW - $W_BUTTON
   $H = $H_WINDOW/3

   $mul_3 = GUICtrlCreateLabel("Multiple With 3 Registers", 0, 0, $W, $H, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, 0x777777)
   $mul_2 = GUICtrlCreateLabel("Multiple With 2 Registers", 0, $H, $W, $H, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, 0x999999)
   $div_3 = GUICtrlCreateLabel("Division With 3 Registers", 0, 2 * $H, $W, $H, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, 0xBBBBBB)

   $back = GUICtrlCreateLabel("BACK", $W, 0, $W_BUTTON, $H_WINDOW, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, 0x222222)
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   $fOverMul3 = False
   $fOverMul2 = False
   $fOverDiv3 = False
   $fOverBack = False

   $flag = 0

   While 1
	  $cursor = GUIGetCursorInfo($selection)
	  EventWhenCoverLabel($mul_3, $cursor, 0x777777, 0x888888, 0, 0, $W, $H, 22, False, $fOverMul3)
	  EventWhenCoverLabel($mul_2, $cursor, 0x999999, 0xAAAAAA, 0, $H, $W, $H, 22, False, $fOverMul2)
	  EventWhenCoverLabel($div_3, $cursor, 0xBBBBBB, 0xCCCCCC, 0, 2 * $H, $W, $H, 22, False, $fOverDiv3)
	  EventWhenCoverLabel($back, $cursor, 0x222222, 0x333333, $W, 0, $W_BUTTON, $H_WINDOW, 22, False, $fOverBack)

	  $click = EventWhenClickLabel($cursor)

	  Switch $click
		 Case $back
			GUIDelete($selection)
			Sleep($SOFT_TIME)
			$flag = 1
			ExitLoop
		 Case $mul_3
			GUIDelete($selection)
			Sleep($SOFT_TIME)
			$flag = 2
			ExitLoop
		 Case $mul_2
			GUIDelete($selection)
			Sleep($SOFT_TIME)
			$flag = 3
			ExitLoop
		 Case $div_3
			$zeroError = 2
			$overflowError = 4

			$error = extractData($data, $EXTRACT_CHECK)

			If BitAND($error, $zeroError) Then
			   DisplayError("ERROR", "Zero Division Error")
			ElseIf BitAND($error, $overflowError) Then
			   DisplayError("ERROR", "Get Risk of OverFlow")
			Else
			   GUIDelete($selection)
			   $flag = 4
			   Sleep($SOFT_TIME)
			   ExitLoop
			EndIf
			Sleep($SOFT_TIME)
	  EndSwitch
   WEnd

   If $flag = 1 Then
	  start_inputForm()
   ElseIf $flag = 2 Then
	  start_mul3($data, $nbit)
   ElseIf $flag = 3 Then
	  start_mul2($data, $nbit)
   ElseIf $flag = 4 Then
	  start_div3($data, $nbit)
   EndIf
EndFunc
