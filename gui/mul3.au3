;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		mul3.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Lauch multiple with 3 registers in detail
; PUBPLIC FUNCTION:
;	start_mul3(data, nbit)
;=============================================================================================================
;

#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "utilities.au3"

;============================================================================
; Func start_mul3(data, nbit)
; Purpose: Create a table contains a log of 3-register-multiple
;
; Parameters:
;	+ data:			value is returned by ALUCall("ALU")
;	+ nbit:			number of bits will be display on table
; Return:
;	+ no return
;=============================================================================
Func start_mul3($data, $nbit)
   ; Set some neccessary value
   $d = extractLog($data, $EXTRACT_MUL3)
   $sep = Int($nbit / 4)
   $sep = ($sep >= 3) ? $sep : $nbit


   #Region ### CONSTANTS
   $COLOR_LABEL = 0x444444

   Local $COLOR_ITEM[2]
   $COLOR_ITEM[0] = 0xB4B4B4
   $COLOR_ITEM[1] = 0xD6D6D6

   $COLOR_ITEM[0] = 0xFFFFFF
   $COLOR_ITEM[1] = 0xCCCCCC

   $H = 40
   $W_ITER = 60
   $W_STEP = 170
   $W_MULCAND = 210
   $W_PROMULER = 400
   $PX = 5
   $PY = 220
   $STYLE = BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER)

   $C_UPDOWN = 0x00AAEE
   $C_UPDOWN_HOVER = 0x00BBFF

   #EndRegion CONSTANT
   #Region ### Create GUI
   $mul3 = GUICreate("mul3", 1250, 660, 45, 35, $WS_POPUP, $WS_EX_COMPOSITED)
   GUISetBkColor(0x333333)
   GUISetFont(9, 300, 0, "Consolas")

   #Region ### Create Title and Button
   $Title = GUICtrlCreateLabel("ALU SIMULATOR FOR MULTIPLE WITH 3 REGISTERS", 0, 0, 1250, 68, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Bahnschrift Condensed")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x333333)


   $WHI_up = _GetWHI("img/up.png")
   $WHI_up1 = _GetWHI("img/up1.png")

   $up = GUICtrlCreatePic("", 575, 70, 100, 101)
   _hBmpToPicControl($up, $WHI_up[2])
   GUICtrlSetPos(-1, 575, 70, 100, 65)

   $WHI_down = _GetWHI("img/down.png")
   $WHI_down1 = _GetWHI("img/down1.png")

   $down = GUICtrlCreatePic("", 575, 570, 100, 101)
   _hBmpToPicControl($down, $WHI_down[2])
   GUICtrlSetPos(-1,  575, 590, 100, 65)

   $back = GUICtrlCreateLabel("BACK", 915, 590, 100, 60, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   #EndRegion Create Tiltle and button
   #Region ### Create Label of table
   Local $Label[5]

   $x = $PX
   $y = $PY - 80
   $Label[0] = GUICtrlCreateLabel("Iterator", $x, $y, $W_ITER, $H, $STYLE)
   $x = $x + $W_ITER
   $Label[1] = GUICtrlCreateLabel("Step", $x, $y, $W_STEP, $H, $STYLE)
   $x = $x + $W_STEP
   $Label[2] = GUICtrlCreateLabel("Multiplicand", $x, $y, $W_MULCAND, $H, $STYLE)
   $x = $x + $W_MULCAND
   $Label[3] = GUICtrlCreateLabel("Multiplier", $x, $y, $W_PROMULER, $H, $STYLE)
   $x = $x + $W_PROMULER
   $Label[4] = GUICtrlCreateLabel("Product", $x, $y, $W_PROMULER, $H, $STYLE)

   For $i = 0 To 4
	  GUICtrlSetBkColor($Label[$i], $COLOR_LABEL)
	  GUICtrlSetColor($Label[$i], 0xFFFFFF)
   Next
   #EndRegion
   #Region ### Create and Load Init Step
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

   #EndRegion Load init step
   #Region ### Create table
   Local $iter[3]
   Local $step[3][3]
   Local $mulcand[3][3]
   Local $muler[3][3]
   Local $prod[3][3]

   for $i = 0 To 2
	  $iter[$i] = GUICtrlCreateLabel("", $PX, $PY + 3 * $i * $H, $W_ITER, 3 * $H, $STYLE)
	  GUICtrlSetBkColor($iter[$i], $COLOR_ITEM[Mod($i, 2)])

	  for $j = 0 To 2
		 $x = $PX
		 $x = $x + $W_ITER
		 $step[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_STEP, $H, BitOr($SS_LEFT, $SS_CENTERIMAGE, $WS_BORDER))
		 GUICtrlSetBkColor($step[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_STEP
		 $mulcand[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_MULCAND, $H, $STYLE)
		 GUICtrlSetBkColor($mulcand[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_MULCAND
		 $muler[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_PROMULER, $H, $STYLE)
		 GUICtrlSetBkColor($muler[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_PROMULER
		 $prod[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 3 + $j) * $H, $W_PROMULER, $H, $STYLE)
		 GUICtrlSetBkColor($prod[$i][$j],  $COLOR_ITEM[Mod($i, 2)])
	  Next
	  GUICtrlSetData($step[$i][1], "2. sll Multiplicand")
	  GUICtrlSetData($step[$i][2], "3. slr Multiplier")
   Next
   #EndRegion Create table

   ; First load
   $begin = 1
   load_mul3($d, $begin, $nbit, $iter, $step, $mulcand, $muler, $prod)

   WinSetTrans($mul3, "", 0)

   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   Fade($mul3, 1)

   $fOverUp = False
   $fOverDown = False
   $fOverBack = False

   While 1
	  $cursor = GUIGetCursorInfo($mul3)

	  EventOnCoverPic($up, $cursor, $WHI_up[2], $WHI_up1[2], 575, 70, 100, 65, $fOverUp)
	  EventOnCoverPic($down, $cursor, $WHI_down[2], $WHI_down1[2], 575, 590, 100, 65, $fOverDown)
	  EventOnCover($back, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, 915, 590, 100, 60, 22, True, $fOverBack)

	  $click = ControlOnClick($cursor)

	  Switch $click
		 Case $back
			Fade($mul3, 0)
			GUIDelete($mul3)
			ExitLoop
		 Case $up
			$begint = $begin
			$begin = getmax($begin - 2, 1)
			If ($begin <> $begint) Then
			   load_mul3($d, $begin, $nbit, $iter, $step, $mulcand, $muler, $prod)
			   Sleep($SOFT_TIME)
			EndIf
		 Case $down
			$begint = $begin
			$begin = getmin($begin + 2, getmax($nbit - 2, 1))
			If $begin <> $begint Then
			   load_mul3($d, $begin, $nbit, $iter, $step, $mulcand, $muler, $prod)
			   Sleep($SOFT_TIME)
			EndIf
	  EndSwitch
   WEnd

   start_selection($data, $nbit)
EndFunc

;============================================================================
; Func load_mul3(d, begin, nbit, iter, step, mulcand, muler, prod)
; Purpose: Fill in table with step begin at <begin>
;
; Parameters:
;	+ d: 		data returned by ALUCall("ALU")
;	+ begin: 	begining step
;	+ nbit:		number of bits will be displayed
;	+ ...:		handler of controls on GUI
; Return:
;	+ no return
;=============================================================================
Func load_mul3($d, $begin, $nbit, $iter, $step, $mulcand, $muler, $prod)
   $sep = Int($nbit / 4)
   $sep = ($sep >= 3) ? $sep : $nbit

   $count = ($begin - 1) * 4 + 2
   For $i = 0 To getmin(2, $nbit - 1)
	  $check = Number($d[$count])
	  GUICtrlSetData($iter[$i], $begin + $i)

	  ; check change of product
	  If ($check == 1)Then;yes
		 GUICtrlSetData($step[$i][0], "1. Pro = Pro + Mcand")
	  Else				; no
		 GUICtrlSetData($step[$i][0], "1. No operation")
	  EndIf
	  $count += 1
	  For $j = 0 To 2
		 $t = StringSplit($d[$count], " ")

		 GUICtrlSetData($mulcand[$i][$j], seperate($t[1], $sep))
		 GUICtrlSetData($muler[$i][$j], seperate($t[2], $sep))
		 GUICtrlSetData($prod[$i][$j], seperate($t[3], $sep))
		 Sleep(1)

		 $count += 1
	  Next
   Next

   For $i = $nbit To 2
	  GUICtrlSetData($step[$i][0], "")
	  GUICtrlSetData($step[$i][1], "")
	  GUICtrlSetData($step[$i][2], "")

	  GUICtrlSetData($mulcand[$i][0], "")
	  GUICtrlSetData($muler[$i][1], "")
	  GUICtrlSetData($prod[$i][2], "")
   Next
EndFunc