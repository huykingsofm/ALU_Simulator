;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		div3.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Lauch division with 3 registers in detail
; PUBPLIC FUNCTION:
;	start_div3(data, nbit)
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "utilities.au3"

;============================================================================
; Func start_div3(data, nbit)
; Purpose: Create a table contains a log of 3-register-multiple
;
; Parameters:
;	+ data:			value is returned by ALUCall("ALU")
;	+ nbit:			number of bits will be display on table
; Return:
;	+ no return
;=============================================================================

Func start_div3($data, $nbit)
   ; Set some neccessary value
   $d = extractLog($data, $EXTRACT_DIV3)
   $sep = Int($nbit/4)
   $sep = ($sep >= 3) ? $sep : $nbit

   #Region ### CONSTANT
   $COLOR_LABEL = 0x444444

   Local $COLOR_ITEM[2]
   $COLOR_ITEM[0] = 0xFFFFFF
   $COLOR_ITEM[1] = 0xCCCCCC

   $N = 3
   $H = 40
   $W_ITER = 60
   $W_STEP = 120
   $W_MULCAND = 200
   $W_PROMULER = 400
   $PX = 10
   $PY = 220
   $STYLE = BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER)

   $C_UPDOWN = 0x00AAEE
   $C_UPDOWN_HOVER = 0x00BBFF
   #EndRegion CONSTANT
   #Region ### Create GUI
   $div3 = GUICreate("div3", 1200, 660, 70, 35, $WS_POPUP)
   GUISetBkColor(0x333333)
   GUISetFont(9, 100, 0, "Consolas")

   #Region ### Create Title and Button
   $Title = GUICtrlCreateLabel("ALU SIMULATOR FOR DIVISION WITH 3 REGISTERS", 0, 0, 1200, 68, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Bahnschrift Condensed")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x333333)

   $up = GUICtrlCreateLabel("UP", 555, 70, 100, 60, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $C_UPDOWN)

   $down = GUICtrlCreateLabel("DOWN", 555, 590, 100, 60, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $C_UPDOWN)

   $back = GUICtrlCreateLabel("BACK", 880, 590, 100, 60, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   #EndRegion Create title and button
   #Region ### Create Label
   Local $Label[5]

   $x = $PX
   $y = $PY - 80
   $Label[0] = GUICtrlCreateLabel("Iterator", $x, $y, $W_ITER, $H, $STYLE)
   $x = $x + $W_ITER
   $Label[1] = GUICtrlCreateLabel("Step", $x, $y, $W_STEP, $H, $STYLE)
   $x = $x + $W_STEP
   $Label[2] = GUICtrlCreateLabel("Quotient", $x, $y, $W_MULCAND, $H, $STYLE)
   $x = $x + $W_MULCAND
   $Label[3] = GUICtrlCreateLabel("Divisor", $x, $y, $W_PROMULER, $H, $STYLE)
   $x = $x + $W_PROMULER
   $Label[4] = GUICtrlCreateLabel("Remainder", $x, $y, $W_PROMULER, $H, $STYLE)

   For $i = 0 To 4
	  GUICtrlSetBkColor($Label[$i], $COLOR_LABEL)
	  GUICtrlSetColor($Label[$i], 0xFFFFFF)
   Next
   #EndRegion Create Label
   #Region ### Create and load init step
   Local $init[5]
   $x = $PX
   $y = $PY - 40
   $init[0] = GUICtrlCreateLabel("0", $x, $y, $W_ITER, $H, $STYLE)
   $x = $x + $W_ITER
   $init[1] = GUICtrlCreateLabel("Initilization", $x, $y, $W_STEP, $H, $STYLE)
   $x = $x + $W_STEP
   $init[2] = GUICtrlCreateLabel("", $x, $y, $W_MULCAND, $H, $STYLE)
   $x = $x + $W_MULCAND
   $init[3] = GUICtrlCreateLabel("", $x, $y, $W_PROMULER, $H, $STYLE)
   $x = $x + $W_PROMULER
   $init[4] = GUICtrlCreateLabel("", $x, $y, $W_PROMULER, $H, $STYLE)

   For $i = 0 To 4
	  GUICtrlSetBkColor($init[$i], 0x00DDDD)
	  GUICtrlSetColor($init[$i], 0x000000)
   Next

   ; Load data to initilization label
   $t = StringSplit($d[1], " ")

   GUICtrlSetData($init[2], seperate($t[1], $sep))
   GUICtrlSetData($init[3], seperate($t[2], $sep))
   GUICtrlSetData($init[4], seperate($t[3], $sep))
   #EndRegion Init step
   #Region ### Create table
   Local $iter[3]
   Local $step[3][3]
   Local $quotient[3][3]
   Local $divisor[3][3]
   Local $remainder[3][3]

   for $i = 0 To 2
	  $iter[$i] = GUICtrlCreateLabel("", $PX, $PY + 3 * $i * $H, $W_ITER, 3 * $H, $STYLE)
	  GUICtrlSetBkColor($iter[$i], $COLOR_ITEM[Mod($i, 2)])

	  for $j = 0 To 2
		 $x = $PX
		 $x = $x + $W_ITER
		 If $j = 1 Then
			$step[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_STEP, $H, BitOr($SS_LEFT, $WS_BORDER))
		 Else
			$step[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_STEP, $H, BitOr($SS_LEFT, $SS_CENTERIMAGE, $WS_BORDER))
		 EndIf
		 GUICtrlSetBkColor($step[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_STEP
		 $quotient[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_MULCAND, $H, $STYLE)
		 GUICtrlSetBkColor($quotient[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_MULCAND
		 $divisor[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_PROMULER, $H, $STYLE)
		 GUICtrlSetBkColor($divisor[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_PROMULER
		 $remainder[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_PROMULER, $H, $STYLE)
		 GUICtrlSetBkColor($remainder[$i][$j],  $COLOR_ITEM[Mod($i, 2)])
	  Next
	  GUICtrlSetData($step[$i][0], "1. R = R - D")
	  GUICtrlSetData($step[$i][2], "3. slr Divisor")
   Next
   #EndRegion create table
   ; First load
   $begin = 1
   load_div3($d, $begin, $nbit, $iter, $step, $quotient, $divisor, $remainder)

   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   $fOverUp = False
   $fOverDown = False
   $fOverBack = False

   While 1
	  $cursor = GUIGetCursorInfo($div3)
	  EventOnCover($up, $cursor, $C_UPDOWN, $C_UPDOWN_HOVER, 555, 70, 100, 60, 22, True, $fOverUp)
	  EventOnCover($down, $cursor, $C_UPDOWN, $C_UPDOWN_HOVER, 555, 590, 100, 60, 22, True, $fOverDown)
	  EventOnCover($back, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, 880, 590, 100, 60, 22, True, $fOverBack)

	  $click = ControlOnClick($cursor)

	  Switch $click
		 Case $back
			GUIDelete($div3)
			Sleep($SOFT_TIME)
			ExitLoop
		 Case $up
			$begint = $begin
			$begin = getmax($begin - 2, 1)
			If ($begin <> $begint) Then
			   load_div3($d, $begin, $nbit, $iter, $step, $quotient, $divisor, $remainder)
			   Sleep($SOFT_TIME)
			EndIf
		 Case $down
			$begint = $begin
			$begin = getmin($begin + 2, getmax($nbit - 1, 1))
			If $begin <> $begint Then
			   load_div3($d, $begin, $nbit, $iter, $step, $quotient, $divisor, $remainder)
			   Sleep($SOFT_TIME)
			EndIf
	  EndSwitch
   WEnd

   start_selection($data, $nbit)
EndFunc

;============================================================================
; Func load_div3(d, begin, nbit, iter, step, quotient, divisor, remainder)
; Purpose: Fill in table with step begin at <begin>
;
; Parameters:
;	+ d : 		data returned by ALUCall("ALU")
;	+ begin: 	begining step
;	+ nbit:		number of bits will be displayed
;	+ ...:		handler of controls on GUI
; Return:
;	+ no return
;=============================================================================
Func load_div3($d, $begin, $nbit, $iter, $step, $quotient, $divisor, $remainder)
   $sep = Int($nbit / 4)
   $sep = ($sep >= 3) ? $sep : $nbit

   $count = ($begin - 1) * 4 + 2

   For $i = 0 To getmin(2, $nbit)
	  $check = Number($d[$count])
	  GUICtrlSetData($iter[$i], $begin + $i)

	  If ($check == 1)Then		;yes
		 GUICtrlSetData($step[$i][1], "2. R > 0, sll Q " & @CRLF & "    Q(0) = 1")

	  Else						;no
		 GUICtrlSetData($step[$i][1], "2. R < 0,R = R+D" & @CRLF & "      sll Q")
	  EndIf
	  $count += 1
	  For $j = 0 To 2
		 $t = StringSplit($d[$count], " ")

		 GUICtrlSetData($quotient[$i][$j], seperate($t[1], $sep))
		 GUICtrlSetData($divisor[$i][$j], seperate($t[2], $sep))
		 GUICtrlSetData($remainder[$i][$j], seperate($t[3], $sep))

		 $count += 1
	  Next
   Next
   For $i = $nbit + 1 To 2
	  GUICtrlSetData($step[$i][0], "")
	  GUICtrlSetData($step[$i][1], "")
	  GUICtrlSetData($step[$i][2], "")

	  GUICtrlSetData($quotient[$i][0], "")
	  GUICtrlSetData($divisor[$i][1], "")
	  GUICtrlSetData($remainder[$i][2], "")
   Next
EndFunc