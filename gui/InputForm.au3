;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		InputForm.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Create a form to input data into ALU
;=============================================================================================================
;
#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "error_msg.au3"
#include "selection.au3"

Func start_inputForm()
   #Region ### CONSTANT
   $PY = 300

   $PX_IMPORT = 100
   $PX_BACK = 360
   #EndRegion

   #Region ### START Koda GUI section ### Form=e:\save code\python\alu project\img\inputdata.kxf
   ; Create a new GUI
   $InputForm = GUICreate("ALU", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor($C_WINDOW)

   ; Create title in head GUI
   $Title = GUICtrlCreateLabel("ALU Simulator", 0, 0, $W_WINDOW, 100, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 50, 400, 0, "Bahnschrift Condensed")

   #Region Create 2 input boxes which store A, B - the numbers are entries of ALU
   ; image and label
   $LabelA = GUICtrlCreateLabel("A", 118, 130, 49, 36, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x222222)

   $LabelB = GUICtrlCreateLabel("B", 118, 180, 49, 36, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x222222)

   $PicA = GUICtrlCreatePic("E:\Save code\Python\ALU project\img\input1.jpg", 166, 110, 300, 40)
   GUICtrlSetState($PicA, $GUI_DISABLE)

   $PicB = GUICtrlCreatePic("E:\Save code\Python\ALU project\img\input1.jpg", 166, 160, 300, 40)
   GUICtrlSetState($PicB, $GUI_DISABLE)

   ; Create input boxes
   $InputA = GUICtrlCreateInput('', 170, 135, 280, 20, 0x0001, 0)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   GUICtrlSetFont(-1, 13, 800, Default, "Sogoe UI Bold", 5)
   GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "First number...")

   $InputB = GUICtrlCreateInput('', 170, 185, 280, 20, 0x0001, 0)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   GUICtrlSetFont(-1, 13, 800, Default, "Sogoe UI Bold", 5)
   GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "Second number...")
   #EndRegion

   ; Create selection of base-n Number
   ; n can be bin(base-2), oct(base-8), dec(base-10), hex(base-16), or other in [1, 16]
   $labelBin = GUICtrlCreateLabel("BIN", 50, 250)
   GUICtrlSetFont(-1, 10, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $bin = GUICtrlCreateRadio("", 85, 249, 20, 20)

   $labelOct = GUICtrlCreateLabel("OCT", 150, 250)
   GUICtrlSetFont(-1, 10, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $oct = GUICtrlCreateRadio("", 185, 249, 20, 20)

   $labelDec = GUICtrlCreateLabel("DEC", 250, 250)
   GUICtrlSetFont(-1, 10, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $dec = GUICtrlCreateRadio(Null, 285, 249, 20, 20)

   $labelHex = GUICtrlCreateLabel("HEX", 350, 250)
   GUICtrlSetFont(-1, 10, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $hex = GUICtrlCreateRadio("", 385, 249, 20, 20)

   $defaultNbit = 24
   $nbitInput = GUICtrlCreateInput("", 450, 248, 50, 0, $ES_NUMBER)
   GUICtrlSetFont(-1, 10, 800, 0, "Arial")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetFont(-1, 10, 800, Default, "Arial", 5)
   GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "24")

   ; Create 2 buttons
   ; "IMPORT" to import 2 numbers into ALU
   ; "BACK" to go back laucher
   $back = GUICtrlCreateLabel("BACK", $PX_BACK, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 800, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   $import = GUICtrlCreateLabel("IMPORT", $PX_IMPORT, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 800, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   ControlFocus("ALU", "", $Title)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   $fOverBack = False
   $fOverImport = False
   $flag = 0
   While 1
	  $cursor = GUIGetCursorInfo($InputForm)
	  ; Change label status when the cursor covers it
	  EventWhenCoverLabel($back, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, $PX_BACK, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverBack)
	  EventWhenCoverLabel($import, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, $PX_IMPORT, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverImport)

	  ; Solve click event
	  $event = EventWhenClickLabel($cursor)

	  If $event <> -1 Then
		 Switch $event
			Case $back
			   GUIDelete($InputForm)
			   Sleep($SOFT_TIME)
			   $flag = 1
			   ExitLoop
			Case $import
			   $a = GUICtrlRead($inputA)
			   $b = GUICtrlRead($inputB)
			   $base = ""
			   $nbit = ""

			   If GUICtrlRead($bin) = 1 Then
				  $base = "2"
			   ElseIf GUICtrlRead($oct) = 1 Then
				  $base = "8"
			   ElseIf GUICtrlRead($dec) = 1 Then
				  $base = "10"
			   ElseIf GUICtrlRead($hex) = 1 Then
				  $base = "16"
			   EndIf

			   If (GUICtrlRead($nbitInput)) == "" Then
				  $nbit = $defaultNbit
			   Else
				  $nbit = Number(GUICtrlRead($nbitInput))
			   EndIf

			   If $a = "" Then
				  DisplayError("ERROR", "Number should be fill in")
			   ElseIf Not check($a) Then
				  DisplayError("ERROR", "Input must be a number")
			   ElseIf $b = "" Then
				  DisplayError("ERROR", "Number should be fill in")
			   ElseIf Not check($b) Then
				  DisplayError("ERROR", "Input must be a number")
			   ElseIf $base = "" Then
				  DisplayError("ERROR", "You must choose a base")
			   ElseIf $nbit	= "" Then
				  DisplayError("ERROR", "You must choose number of bit")
			   Else
				  $data = CallFunc($Connection, "ALU", $a & "," & $b & "," & $base & "," & $nbit)
				  If $data = "error" or $data = "" Then
					 DisplayError("ERROR", "Connection Error, Try again")
					 ContinueLoop
				  EndIf

				  Switch extractData($data, $EXTRACT_CHECK)
					 Case 1
						DisplayError("ERROR", "Undentified Error Occur")
					 Case 8
						DisplayError("ERROR", "Positive number is not permitted")
					 Case Else
						GUIDelete($InputForm)
						Sleep($SOFT_TIME)
						$flag = 2
						ExitLoop
				  EndSwitch
			   EndIf

			Case Else
			   If $event = 0 Then
				  $event = $Title
			   EndIf
			   ControlFocus("ALU", "", $event)
			   If $event = $bin or $event = $oct or $event = $dec or $event = $hex Then
				  ControlFocus("ALU", "", $event)
			   EndIf
		 EndSwitch
	  EndIf
   WEnd
   If $flag = 1 Then
	  start_laucher()
   ElseIf $flag = 2 Then
	  start_selection($data, $nbit)
   EndIf
EndFunc

Func check($a)
   $b = StringSplit($a, "")

   For $i = 1 To $b[0]
	  If (StringIsAlNum($b[$i]) = 0 And StringIsAlpha($b[$i]) = 0) Then
		Return False
	  EndIf
   Next

   Return True
EndFunc

start_inputForm()