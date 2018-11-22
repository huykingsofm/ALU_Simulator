#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Func __displayAbout()

   $image = "img/card_ALUSimulator.jpg"
   $aRet = _GetWHI($image)

   $W_SCREEN = 1366
   $H_SCREEN = 786

   Local $W_WINDOW = $aRet[0]
   Local $H_WINDOW = $aRet[1]
   Local $PX_WINDOW = ($W_SCREEN - $W_WINDOW) / 2
   Local $PY_WINDOW = ($H_SCREEN - $H_WINDOW) / 2
   #Region ### START Koda GUI section ### Form=
   $about = GUICreate("Form1", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW,$WS_POPUP)
   $card = GUICtrlCreatePic($image, 0, 0, $W_WINDOW, $H_WINDOW)
   WinSetTrans($about, "", 0)
   GUISetState(@SW_SHOW)
   Fade($about, 1)
   #EndRegion ### END Koda GUI section ###

   While 1
	  $cursor = GUIGetCursorInfo($about)
	  If $cursor[2] = 1 Then
		 Fade($about, 0)
		 $cursor[2] = 0
		 GUIDelete($about)
		 ExitLoop
	  EndIf
   WEnd
EndFunc