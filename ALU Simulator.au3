;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
; File Name: 		ALU Simulator.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Lauch ALU-Simulator
;=============================================================================================================
;

#include-once
#include "gui/laucher.au3"


; Set a global variable which handle connection with API
; This variable will be assign in start_laucher procedure
Global $Connection = -1

; Start LAUCHER, stay in laucher.au3
start_laucher()

; Close connection when program finishes
ALUClose($Connection)