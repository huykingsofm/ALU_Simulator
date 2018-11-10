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
; Purpose:			Lauch selection form to select operation
; PUPBLIC FUNCTION:
;	start_selection(data, nbit)
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "utilities.au3"
#include "mul3.au3"
#include "mul2.au3"
#include "div3.au3"



;============================================================================
; Func start_selection(data, nbit)
; Purpose: Create a GUI which provide a option to select seeing a operator log
;
; Parameters:
;	+ data:			value is returned by ALUCall("ALU")
;	+ nbit:			number of bits will be display on table
; Return:
;	+ no return
;=============================================================================
Func start_selection($data, $nbit)

   #Region ### Create GUI
   $selection = GUICreate("selection", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
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
	  EventOnCover($mul_3, $cursor, 0x777777, 0x888888, 0, 0, $W, $H, 22, False, $fOverMul3)
	  EventOnCover($mul_2, $cursor, 0x999999, 0xAAAAAA, 0, $H, $W, $H, 22, False, $fOverMul2)
	  EventOnCover($div_3, $cursor, 0xBBBBBB, 0xCCCCCC, 0, 2 * $H, $W, $H, 22, False, $fOverDiv3)
	  EventOnCover($back, $cursor, 0x222222, 0x333333, $W, 0, $W_BUTTON, $H_WINDOW, 22, False, $fOverBack)

	  $click = ControlOnClick($cursor)

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

			$error = extractLog($data, $EXTRACT_ERROR)

			If BitAND($error, $zeroError) Then
			   DisplayNotification("ERROR", "Zero Division Error")
			ElseIf BitAND($error, $overflowError) Then
			   DisplayNotification("ERROR", "Get Risk of OverFlow")
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
	  start_entry()
   ElseIf $flag = 2 Then
	  start_mul3($data, $nbit)
   ElseIf $flag = 3 Then
	  start_mul2($data, $nbit)
   ElseIf $flag = 4 Then
	  start_div3($data, $nbit)
   EndIf
EndFunc
