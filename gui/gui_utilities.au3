;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		gui_utilities.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Support some functions to create Metro-UI and extract data
;=============================================================================================================
;
#include-once
#include <String.au3>
#Region GLOBAL CONSTANT
   $PX_WINDOW = 400
   $PY_WINDOW = 150
   $W_WINDOW = 600
   $H_WINDOW = 440

   $W_BUTTON = 130
   $H_BUTTON = 100

   $C_WINDOW = 0x222222

   $COLOR_BUTTON = 0xDDDDDD
   $COLOR_BUTTON_HOVER = 0xEEEEEE

   $SOFT_TIME = 250
#EndRegion

Func EventWhenCoverLabel($controlID, $cursor, $curColor, $setColor, $px, $py, $w, $h, $sF, $change, ByRef $fOver)
   If $cursor[4] = $ControlID Then
	  If $fOver = False Then
		 If $change Then
			GUICtrlSetPos($controlID, $px -2, $py - 2, $w + 4, $h + 4)
			GUICtrlSetFont($controlID, $sF + 1, 400, 0, "Arial Rounded MT Bold")
		 EndIf
		 GUICtrlSetBkColor($controlID, $setColor)
		 $fOver = True
	  EndIf
   Else
	  If $fOver = True Then
		 If $change Then
			GUICtrlSetPos($controlID, $px, $py, $w, $h)
			GUICtrlSetFont($controlID, $sF, 400, 0, "Arial Rounded MT Bold")
		 EndIf
		 GUICtrlSetBkColor($controlID, $curColor)
		 $fOver = False
	  EndIf
   EndIf
EndFunc

Func EventWhenClickLabel($cursor)
   If $cursor[2] = 1 Then
	  Return $cursor[4]
   Else
	  Return -1
   EndIf
EndFunc


$EXTRACT_CHECK = 1
$EXTRACT_MUL3 = 2
$EXTRACT_MUL2 = 4
$EXTRACT_DIV3 = 16

Func extractData($data, $flag)

   $log = StringSplit($data, "|")

   $res = "error"

   If BitAND($flag, $EXTRACT_CHECK) Then
	  Return $log[1]
   EndIf

   If BitAND($flag, $EXTRACT_MUL3) Then
	  ;Return $log[2]
	  Return StringSplit($log[2], ",")
   EndIf

   If BitAND($flag, $EXTRACT_MUL2) Then
	  Return StringSplit($log[3], ",")
   EndIf

   If BitAND($flag, $EXTRACT_DIV3) Then
	  Return StringSplit($log[4], ",")
   EndIf

   Return $res
EndFunc


Func getmin($a, $b)
   Return $a <= $b ? $a : $b
EndFunc

Func getmax($a, $b)
   Return $a >= $b ? $a : $b
EndFunc
