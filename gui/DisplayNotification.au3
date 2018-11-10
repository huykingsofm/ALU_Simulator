;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		DisplayNotification.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Provide a notification message window
;
; PUBLIC FUNCTION:
;	DisplayNotification(title, msg)
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "utilities.au3"

;============================================================================
; Func DisplayNotification(title, msg)
; Purpose: Display a window to notify user with a title and message
;
; Parameters:
;	+ title:	a title of window
;	+ msg:		a message will be notified
; Return:
;	+ no return
;=============================================================================
Func DisplayNotification($title, $msg)
   #Region # Create GUI
   $notification = GUICreate("Notification", 352, 215, 518, 270, BitOR($WS_MINIMIZEBOX,$WS_POPUP,$WS_GROUP))
   GUISetBkColor(0xDDDDDD)

   $close = GUICtrlCreateLabel("CLOSE", 135, 135, 2 * $W_BUTTON/3, 2 * $H_BUTTON/3, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetBkColor(-1, 0x005555)
   GUICtrlSetColor(-1,0xFFFFFF)
   GUICtrlSetFont(-1, 15, 400, 0, "Arial Rounded MT Bold")

   $Label1 = GUICtrlCreateLabel($title, 0, 0, 352, 53, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Bahnschrift Condensed")
   GUICtrlSetBkColor(-1, 0x005555)
   GUICtrlSetColor(-1,0xFFFFFF)
   $Label2 = GUICtrlCreateLabel($msg, 0, 53, 352, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 19, 400, 0, "Sogoe UI Bold")
   GUICtrlSetColor(-1,0)
   GUICtrlSetBkColor(-1, 0xDDDDDD)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   $fOverClose = False
   While 1
	  $cursor = GUIGetCursorInfo($notification)
	  EventOnCover($close, $cursor, 0x005555, 0x006666, 135, 135, 2 * $W_BUTTON/3, 2 * $H_BUTTON/3, 15, True, $fOverClose)

	  $click = ControlOnClick($cursor)
	  If ($click = $close) Then
		 GUIDelete($notification)
		 ExitLoop
	  EndIf
   WEnd
EndFunc