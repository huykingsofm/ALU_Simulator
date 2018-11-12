;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		mul2.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Lauch multiple with 2 registers in detail
; PUBLIC FUNCTION:
;	start_mul2(data, nbit)
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "utilities.au3"

;============================================================================
; Func start_mul2(data, nbit)
; Purpose: Create a table contains a log of 3-register-multiple
;
; Parameters:
;	+ data:			value is returned by ALUCall("ALU")
;	+ nbit:			number of bits will be display on table
; Return:
;	+ no return
;=============================================================================

Func start_mul2($data, $nbit)
   ; Set some neccessary value
   $d = extractLog($data, $EXTRACT_MUL2)
   $sep = Int($nbit/4)
   $sep = ($sep >= 3) ? $sep : $nbit

   #Region ### CONSTANT
   $COLOR_LABEL = 0x444444

   Local $COLOR_ITEM[2]
   $COLOR_ITEM[0] = 0xFFFFFF
   $COLOR_ITEM[1] = 0xCCCCCC

   $H = 40
   $W_ITER = 60
   $W_STEP = 250
   $W_MULCAND = 240
   $W_PROMULER = 480
   $PX = 35
   $PY = 230
   $STYLE = BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER)

   $C_UPDOWN = 0x00AAEE
   $C_UPDOWN_HOVER = 0x00BBFF
   #EndRegion CONSTANT
   #Region ### Create GUI
   $mul2 = GUICreate("mul2", 1100, 640, 145, 35, $WS_POPUP)
   GUISetBkColor(0x333333)
   GUISetFont(9, 300, 0, "Consolas")

   #Region ### CREATE Title and Button
   $Title = GUICtrlCreateLabel("ALU SIMULATOR FOR MULTIPLE WITH 2 REGISTERS", 0, 0, 1100, 68, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Bahnschrift Condensed")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x333333)

   $WHI_up = _GetWHI("img/up.png")
   $WHI_up1 = _GetWHI("img/up1.png")

   $up = GUICtrlCreatePic("", 575, 70, 100, 101)
   _hBmpToPicControl($up, $WHI_up[2])
   GUICtrlSetPos(-1, 500, 70, 100, 65)

   $WHI_down = _GetWHI("img/down.png")
   $WHI_down1 = _GetWHI("img/down1.png")

   $down = GUICtrlCreatePic("", 575, 550, 100, 101)
   _hBmpToPicControl($down, $WHI_down[2])
   GUICtrlSetPos(-1,  500, 560, 100, 65)

   $back = GUICtrlCreateLabel("BACK", 830, 570, 100, 60, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   #EndRegion
   #Region ### Create Label of table
   Local $Label[4]

   $x = $PX
   $y = $PY - 80
   $Label[0] = GUICtrlCreateLabel("Iterator", $x, $y, $W_ITER, $H, $STYLE)
   $x = $x + $W_ITER
   $Label[1] = GUICtrlCreateLabel("Step", $x, $y, $W_STEP, $H, $STYLE)
   $x = $x + $W_STEP
   $Label[2] = GUICtrlCreateLabel("Multiplicand", $x, $y, $W_MULCAND, $H, $STYLE)
   $x = $x + $W_MULCAND
   $Label[3] = GUICtrlCreateLabel("Product/Multiplier", $x, $y, $W_PROMULER, $H, $STYLE)

   For $i = 0 To 3
	  GUICtrlSetBkColor($Label[$i], $COLOR_LABEL)
	  GUICtrlSetColor($Label[$i], 0xFFFFFF)
   Next
   #EndRegion
   #Region ### Create and load init step
   Local $init[4]
   $x = $PX
   $y = $PY - 40
   $init[0] = GUICtrlCreateLabel("0", $x, $y, $W_ITER, $H, $STYLE)
   $x = $x + $W_ITER
   $init[1] = GUICtrlCreateLabel("Initilization", $x, $y, $W_STEP, $H, $STYLE)
   $x = $x + $W_STEP
   $init[2] = GUICtrlCreateLabel("", $x, $y, $W_MULCAND, $H, $STYLE)
   $x = $x + $W_MULCAND
   $init[3] = GUICtrlCreateLabel("", $x, $y, $W_PROMULER, $H, $STYLE)

   For $i = 0 To 3
	  GUICtrlSetBkColor($init[$i], 0xDDDD)
	  GUICtrlSetColor($init[$i], 0x000000)
   Next

      ; Load data to initilization label
   $t = StringSplit($d[1], " ")

   GUICtrlSetData($init[2], seperate($t[1], $sep))
   GUICtrlSetData($init[3], seperate($t[2], $sep))
   #EndRegion Init step
   #Region ### Create table
   Local $iter[4]
   Local $step[4][2]
   Local $mulcand[4][2]
   Local $prodmuler[4][2]

   for $i = 0 To 3
	  $iter[$i] = GUICtrlCreateLabel("", $PX, $PY + 2 * $i * $H, $W_ITER, 2 * $H, $STYLE)
	  GUICtrlSetBkColor($iter[$i], $COLOR_ITEM[Mod($i, 2)])

	  for $j = 0 To 1
		 $x = $PX
		 $x = $x + $W_ITER
		 $step[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 2 + $j) * $H, $W_STEP, $H, BitOr($SS_LEFT, $SS_CENTERIMAGE, $WS_BORDER))
		 GUICtrlSetBkColor($step[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_STEP
		 $mulcand[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 2 + $j) * $H, $W_MULCAND, $H, $STYLE)
		 GUICtrlSetBkColor($mulcand[$i][$j],  $COLOR_ITEM[Mod($i, 2)])

		 $x = $x + $W_MULCAND
		 $prodmuler[$i][$j] = GUICtrlCreateLabel("", $x, $PY + ($i * 2 + $j) * $H, $W_PROMULER, $H, $STYLE)
		 GUICtrlSetBkColor($prodmuler[$i][$j],  $COLOR_ITEM[Mod($i, 2)])
	  Next
	  GUICtrlSetData($step[$i][1], "2. shift right Product/Multiplier")
   Next
   #EndRegion Create tale

   ; First load
   $begin = 1
   load_mul2($d, $begin, $nbit, $iter, $step, $mulcand, $prodmuler)

   WinSetTrans($mul2, "", 0)

   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   Fade($mul2, 1)

   $fOverUp = False
   $fOverDown = False
   $fOverBack = False

   While 1
	  $cursor = GUIGetCursorInfo($mul2)

	  EventOnCoverPic($up, $cursor, $WHI_up[2], $WHI_up1[2], 500, 70, 100, 65, $fOverUp)
	  EventOnCoverPic($down, $cursor, $WHI_down[2], $WHI_down1[2], 500, 560, 100, 65, $fOverDown)
	  EventOnCover($back, $cursor, $COLOR_BUTTON, $COLOR_BUTTON_HOVER, 830, 570, 100, 60, 22, True, $fOverBack)

	  $click = ControlOnClick($cursor)

	  Switch $click
		 Case $back
			Fade($mul2, 0)
			GUIDelete($mul2)
			ExitLoop
		 Case $up
			$begint = $begin
			$begin = getmax($begin - 3, 1)
			If ($begin <> $begint) Then
			   load_mul2($d, $begin, $nbit, $iter, $step, $mulcand, $prodmuler)
			   Sleep($SOFT_TIME)
			EndIf
		 Case $down
			$begint = $begin
			$begin = getmin($begin + 3, getmax($nbit - 3, 1))
			If $begin <> $begint Then
			   load_mul2($d, $begin, $nbit, $iter, $step, $mulcand, $prodmuler)
			   Sleep($SOFT_TIME)
			EndIf
	  EndSwitch
   WEnd

   start_selection($data, $nbit)
EndFunc


;============================================================================
; Func load_mul2(d, begin, nbit, iter, step, mulcand, prodmuler)
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
Func load_mul2($d, $begin, $nbit, $iter, $step, $mulcand, $prodmuler)
   $sep = Int($nbit / 4)
   $sep = ($sep >= 3) ? $sep : $nbit

   $count = ($begin - 1) * 3 + 2
   For $i = 0 To getmin(3, $nbit - 1)
	  $check = Number($d[$count])
	   GUICtrlSetData($iter[$i], $begin + $i)

	  ; check change of product
	  If ($check == 1)Then;yes
		 GUICtrlSetData($step[$i][0], "1. ProMul = Hi(ProMul) + Mcand")
	  Else				; no
		 GUICtrlSetData($step[$i][0], "1. No operation")
	  EndIf
	  $count += 1
	  For $j = 0 To 1
		 $t = StringSplit($d[$count], " ")

		 GUICtrlSetData($mulcand[$i][$j], seperate($t[1], $sep))
		 GUICtrlSetData($prodmuler[$i][$j], seperate($t[2], $sep))
		 Sleep(1)

		 $count += 1
	  Next
   Next

   For $i = $nbit To 3
	  GUICtrlSetData($step[$i][0], "")
	  GUICtrlSetData($step[$i][1], "")

	  GUICtrlSetData($mulcand[$i][0], "")
	  GUICtrlSetData($prodmuler[$i][1], "")
   Next
EndFunc
