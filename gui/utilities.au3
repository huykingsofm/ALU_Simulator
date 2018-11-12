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
;	EventOnCoverPic(PicID, cursor, curPic, newPic, px, py, w, h, ByRef fOver)
;	ControlOnClick(cursor)
;	extractLog(data, flag)
;	seperate(binary, sep)
;	getmin(a, b)
;	getmax(a, b)
;	Fade(hWnd, flag)
;	_hBmpToPicControl(iCID, hBmp, iFlag = 0)
;	_GetWHI(sImage)
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

   $ERROR_UNDENTIFIED = 1
   $ERROR_ZERODIVISION = 2
   $ERROR_OVERFLOW = 4
   $ERROR_NEGATIVE = 8
   $ERROR_VALUERANGE = 16
   $ERROR_BASERANGE = 32
   $ERROR_BITRANGE = 64

#EndRegion

#include-once
#include <String.au3>
#include <GDIPlus.au3>
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
; Func EventOnCoverPic(PicID, cursor, curPic, newPic, px, py, w, h, ByRef fOver); Purpose: Change status of control if cursor cover it
;
; Purpose: Change status of Pic if cursor cover it
;
; Parameters:
;	+ PicID: 			handler of Pic
;	+ cursor:			value is returned by GUIGetCursorInfo()
;	+ curPic:			hBITMAP is return by _GetWHI()
;	+ newColor:			hBITMAP is return by _GetWHI()
;	+ px, py, w, h:		position (left, top, witdh, height) of Pic
;	+ fOver:			a flag check whether cursor is on control or not
; Return:
;	+ no return
;=============================================================================
Func EventOnCoverPic($PicID, $cursor, $curPic, $newPic, $px, $py, $w, $h, ByRef $fOver)
   If $cursor[4] = $PicID Then
	  If $fOver = False Then
		 _hBmpToPicControl($PicID, $newPic)
		 GUICtrlSetPos($PicID, $px, $py, $w, $h)
		 $fOver = True
	  EndIf
   Else
	  If $fOver = True Then
		 _hBmpToPicControl($PicID, $curPic)
		 GUICtrlSetPos($PicID, $px, $py, $w, $h)
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


;==============================================================================
; Func Fade(hWnd, flag)
; Purpose: Provide a Smooth starting and ending GUI
;
; Parameters:
;	+ hWnd: handle of GUI
;	+ flag = 1, starting GUI
;	  flag = 0, ending GUI
;
; Return:
;	no-return
;================================================================================
Func Fade($hWnd, $flag)
   $b = 255
   $e = 0
   $s = -15

   If $flag == 1 Then
	  $b = 0
	  $e = 252
	  $s = 12
   EndIf

   For $i = $b To $e Step $s
	  WinSetTrans($hWnd, "", $i)
	  Sleep(1)
   Next
EndFunc

;================================================================================
; Func _GetWHI(sImage)
;
; Purpose : Get infomation of image
;
; Parameter:
; 	+ sImage = Path to your image
; Returns
;	+ Array[3]
;         Array[0] = Width
;         Array[1] = Height
;         Array[2] = handle to a HBITMAP
;================================================================================
Func _GetWHI($sImage)
    Local $hImage, $aRet[3]
    _GDIPlus_Startup()
    $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    $aRet[0] = _GDIPlus_ImageGetWidth($hImage)
    $aRet[1] = _GDIPlus_ImageGetHeight($hImage)
    $aRet[2] = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_Shutdown()
    Return $aRet
 EndFunc   ;==>_GetWHI

;=================================================================================
; Func _hBmpToPicControl(iCID, hBmp, iFlag = 0)
;
; Purpose : Insert BITMAP image into ControlPic
;
; Parameters:
; 	+ iCID = Control ID as returned from GUICtrlCreatePic()
; 	+ hBmp = HBITMAP as returned by _GetWHI()
; 	+ iFlag = Set to 1 will delete the $hBmp object after setting it the pic control
;=================================================================================
Func _hBmpToPicControl($iCID, $hBmp, $iFlag = 0)
    Local Const $STM_SETIMAGE = 0x0172
    Local Const $IMAGE_BITMAP = 0
    Local $hOldBmp
    $hOldBmp = GUICtrlSendMsg($iCID, $STM_SETIMAGE, $IMAGE_BITMAP, $hBmp)
    If $hOldBmp Then _WinAPI_DeleteObject($hOldBmp)
    If $iFlag Then _WinAPI_DeleteObject($hBmp)
EndFunc   ;==>_hBmpToPicControl