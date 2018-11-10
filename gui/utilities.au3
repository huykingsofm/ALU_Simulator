;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		utilities.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Support some functions to create Metro-UI and extract data
;
; PUBPLIC FUNCTIONS:
;	EventOnCover(controlID, cursor, curColor, newColor, px, py, w, h, fontsize, changeFlag, ByRef fOver)
;	ControlOnClick(cursor)
;	extractLog(data, flag)
;	seperate(binary, sep)
;	getmin(a, b)
;	getmax(a, b)
;
; PUBPLIC CONSTANTS:
;	See detail in below......
;=============================================================================================================

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


   $EXTRACT_ERROR = 1
   $EXTRACT_MUL3 = 2
   $EXTRACT_MUL2 = 4
   $EXTRACT_DIV3 = 8
#EndRegion

#include-once
#include <String.au3>

;============================================================================
; Func EventOnCover(controlID, cursor, curColor, newColor, px, py, w, h, fontsize, changeFlag, ByRef fOver)
; Purpose: Change status of control if cursor cover it
;
; Parameters:
;	+ controlID: 		handler of control
;	+ cursor:			value is returned by GUIGetCursorInfo()
;	+ curColor:			current color of control
;	+ newColor:			color of control when the cursor cover it
;	+ px, py, w, h:		position (left, top, witdh, height) of control
;	+ fontsize:			font size of text of control
;	+ changeFlag:		if Flag is off(False), the control change only color
;	+ fOver:			a flag check whether cursor is on control or not
; Return:
;	+ no return
;=============================================================================
Func EventOnCover($controlID, $cursor, $curColor, $newColor, $px, $py, $w, $h, $fontsize, $changeFlag, ByRef $fOver)
   If $cursor[4] = $ControlID Then
	  If $fOver = False Then
		 If $changeFlag Then
			GUICtrlSetPos($controlID, $px -2, $py - 2, $w + 4, $h + 4)
			GUICtrlSetFont($controlID, $fontsize + 1, 400, 0, "Arial Rounded MT Bold")
		 EndIf
		 GUICtrlSetBkColor($controlID, $newColor)
		 $fOver = True
	  EndIf
   Else
	  If $fOver = True Then
		 If $changeFlag Then
			GUICtrlSetPos($controlID, $px, $py, $w, $h)
			GUICtrlSetFont($controlID, $fontsize, 400, 0, "Arial Rounded MT Bold")
		 EndIf
		 GUICtrlSetBkColor($controlID, $curColor)
		 $fOver = False
	  EndIf
   EndIf
EndFunc


;============================================================================
; Func ControlOnClick(cursor)
; Purpose: Return control which cursor is on
;
; Parameters:
;	+ cursor:			value is returned by GUIGetCursorInfo()
; Return:
;	+ If cursor is on a control, return handler of it
;	+ If cursor is not on any control, return -1
;=============================================================================
Func ControlOnClick($cursor)
   If $cursor[2] = 1 Then
	  Return $cursor[4]
   Else
	  Return -1
   EndIf
EndFunc


;============================================================================
; Func extractLog(data, flag)
; Purpose: get some nessessary fraction of data
;
; Parameters:
;	+ data:			value is returned by ALUCall("ALU")
;	+ flag:			one of constants
;					EXTRACT_ERROR: 	get error of data
;					EXTRACT_MUL3:	get log of 3-register-multiple
;					EXTRACT_MUL2:	get log of 2-register-multiple
;					EXTRACT_DIV3:	get log of 3-register-division
; Return:
;	+ If success, return fraction data responding flag
;	+ If failure, return "error"
;=============================================================================
Func extractLog($data, $flag)

   $log = StringSplit($data, "|")

   $res = "error"

   If BitAND($flag, $EXTRACT_ERROR) Then
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


;============================================================================
; Func seperate(binary, sep)
; Purpose: seperate binary number string into many part to make more readable
;
; Parameters:
;	+ binary:			binary string
;	+ sep:				the width of each fraction
; Return:
;	return the binary string after seperating
;=============================================================================
Func seperate($binary, $sep)
   $n = StringLen($binary)

   For $i = $n - $sep To 0 Step -$sep
	  $binary = _StringInsert($binary, " ", $i)
   Next

   Return $binary
EndFunc
