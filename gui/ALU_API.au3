;=======================================================Introduction==========================================
;Author: 			Le Ngoc Huy - UIT K12
;Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/ALU_Simulator.git
;
;
;File name:			ALU_API.au3
;Language:			AutoIT
;Modified Date:		Dec 10 2018
;Purpose: 			support performing some special functions via a program written by Python
;
;
;Functions consist of:
;
;Func: ALU(a, b, base, nbit)
;	- Perform caculation of multiple and division with a ALU, then return a log(or record) of processes
;	- Parameters:
;		+ every parameters are string
;		+ <a>, <b> is entry numbers of ALU
;		+ <base> is base of number, 2 <= <base> <= 16
;		+ <nbit> is number of bit will be performed
;
;	- Return the value having a form like "<error>|<mul_3>|<mul_2>|<div_2>"
;
;	- <error> is bitmask-error value in ALU-process
;	- <mul_3> decribes a log(or record) of process of multiple with 3 registers(multipicand, multiplier, product)
;	- <mul_2> decribes a log(or record) of process of multiple with 2 registers(multiplicand, product/multiplier)
;	- <div_3> decribes a log(or record) of process of division with 3 registers(quotient, divisor, remainder)
;	       where
;		  + <error> = BitOrIn[0, 1, 2, 4, 8]
;					with [0-no error, 1-undentified error, 2-zero division error, 4-overflow error, 8-negative number error]
;		  + <mul_3> and <div_3> are N steps which like <change, value11 value12 value13, value21 value 22 value 23, value31 value 32 value 33>
;		  + <mul_2> is N steps which like <change, value11 value12 value13, value21 value 22 value 23>
;
;		  Note1 : every steps in (mul_3, mul_2, div_3) are seperated by commas
;		  Note2 : all values are in base-10 number(decimal)
;		  Note3 : <change> says that whether its step have been changed specially in (product/quotient) or not
;		  Note4 : each in (mul_3, mul_2, div_3) have a init step with responding value in head
;		  Note5 : If error in <1>, [mul_3, mul_2, div_3] = ""
;				  If error in <2 or 4>, div_3 = ""
;
;	Example:
;		Func: ALU("2", "3", "10", "3")
;		Return value: "<0>|<2 3 0>, <0, 2 3 0, 1 3 0, 1 6 0>, <1, 1 6 6, 0 6 6, 0 12 6>,<..>|<mul_2>|<div_3>"
;		Explain :
;			+ <0> is error value, it said that there is no error in this case
;				if error value is <3>, it said that there 2 errors(undentified error and zero division error)
;			+ first <2 3 0> is init step in (multipicand, multiplier, product) respectively
;			+ <0, ...> said that the step don't have any change in product
;			+ <.., 2 3 0, 1 3 0, 1 6 0> is 3 actions in multiple with 3 registers, include (1.P = P + Mcand or no-operation, 2. sll Mcand, 3. slr Mplier)
;			+ <1, 1 6 6, 0 6 6, 0 12 6> also decribes 3 actions with a change
;			+ <..> is remain step in multiple with 3 registers
;			+ <mul_2> and <div_2> are analysised respectively
;
;		Func: ALU("2", "3", "10", "3")
;		Return value: "<1>|||"
;		Explain: 3 bit can not perform 2 * 3 in decimal
;
;Func: dec2bin(dec, n)
;	- Conver decimal to <n>-bit binary in string form
;	- Parameters:
;		+ all parameters are string
;		+ <dec> : the number needs to be converted (in decimal)
;		+ <n> : the number of bit of binary number after returning
;
;	- Return a <n>-bit binary number responding <dec>
;
;	- Example:
;		dec2bin("10", "7")
;		Return value : "0001010"
;
;		+Note : support up to unsinged int 64-bit number(uint64 in C++ or Python)
;=======================================================



;=========================Define==========================




;=======================================================
;Function ALUConnect
;Start connect to API to be able to perform the other functions
;No-parameter
;Return:
;	+ If success, return a value which handle connection, it will be used to perform the other functions
;	+ If failure, return -1
;=======================================================
Func ALUConnect()
   ; Set socket of API - which to connect to it
   $HOST = '127.0.0.1'
   $PORT = 65432

   ; Start TCP, prepare to connect
   TCPStartup()

   ; Check if the server have opened before or not
   $TCPConnection = TCPConnect($HOST, $PORT)

   ; If server have yet opened, open it in hide mode
   If $TCPConnection = -1 Then
	  Run("API/server.exe", '', @SW_HIDE)
   EndIf

   ; Trying to conect to server in a limit time
   ; The max limit time is 460 in practice, and average value is 150
   $limit_time = 500

   While $TCPConnection = -1 And $limit_time > 0
	  $limit_time -= 1
	  $TCPConnection = TCPConnect($HOST, $PORT)
   WEnd

   Return $TCPConnection
EndFunc


;================================================
;Func ALUClose(Connection)
;Close connection with API
;Parameter:
;	+ Connection : The handle value which is returned by ALUConnect()
;No-Return
;================================================
Func ALUClose($Connection)
   If $Connection <> -1 Then
	  TCPCloseSocket($Connection)
   EndIf
EndFunc


;================================================
;Func CallFunc(Connection, Func, Arg)
;Perform the function via a written program
;
;Parameters:
;	+ Connection : the handle value which is returned by ALUConnect()
;	+ Func : name of function
;	+ Arg : Arguments of function. It's a string and seperated by commas
;Return:
;	+ If fail connection error, return error
;	+ If success, return value in responding function
;	+ If API can not identify that function, return empty string ""
;Example:
;	1. CallFunc(Connection, "dec2bin", "10, 7")
;	   Return : "0001010"
;	2. CallFunc(Connection, "ALU", "10, 7")
;	   Return : ""
;================================================
Func CallFunc($Connection, $func, $arg)
   ;join function name and argument into one string to pass it to API
   $call = $func & "|" & $arg

   ;
   ;To avoid error in transmission, the program will send 2 queries in turn
   ;If both of 2 revData equal absolutely, it is said that there is no error in transmission
   ;Otherwise, the program will send query again
   ;above process is repeated in a limit time

   $revData1 = ""
   $revData2 = ""

   $limit_time = 5
   Do
	  TCPSend($Connection, $call)
	  $revData1 = TCPRecv($Connection, 1024 * 5)
	  Sleep(2)
	  TCPSend($Connection, $call)
	  $revData2 = TCPRecv($Connection, 1024 * 5)
	  $limit_time -= 1
   Until StringCompare($revData1, $revData2) = 0 Or $limit_time <= 0

   If StringCompare($revData1, $revData2) <> 0 Then
	  Return "error"
   EndIf

   Return $revData1
EndFunc