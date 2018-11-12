"""
#==================================Introduction==========================================
# Author:           Le Ngoc Huy - UIT K12
# Contact:
# 	Email:          huykingsofm@gmail.com
# 	Edu Email:      17520074@gm.uit.edu.vn
#   Github:         https://github.com/huykingsofm/ALU_Simulator.git
#
#
# File name:        ALU.py
# Language:         Python
# Modified Date:    Dec 11 2018
# PURPOSE:          provide a class to create detail process logs in Arithmetic Logic Unit(ALU) Processor
#                   include multiple and division operations.
# 
# CONSTRUCTION
# 
# Class ALU(a, b, base, nbit)
#   CONST     
#       ERROR_UNDENTIFIED = 1
#       ERROR_ZERODIVISION = 2
#       ERROR_OVERFLOW = 4
#       ERROR_NEGATIVE = 8
#       ERROR_VALUERANGE = 16
#       ERROR_BASERANGE = 32
#       ERROR_BITRANGE = 64
#
#   FUNC
#       run()                   return      (ndarray, ndarray, ndarray) 
#       convertLog(log)         return      string
#   VARIABLE
#       error   int     a bitmask error
#
#   See detail below........
#==========================================================================
"""
from utilities import *

class ALU:
    #=====CONSTANT===============
    ERROR_UNDENTIFIED = 1
    ERROR_ZERODIVISION = 2
    ERROR_OVERFLOW = 4
    ERROR_NEGATIVE = 8
    ERROR_VALUERANGE = 16
    ERROR_BASERANGE = 32
    ERROR_BITRANGE = 64

    def __init__(self, a, b, base = 10, nbit = 24):
        # Set neccessary value
        #Create log to store all steps
        self.log_m3 = []
        self.log_m2 = []
        self.log_d3 = []
        
        self.__isrun = 0                # m3 = 1
                                        # m2 = 2
                                        # d3 = 4

        self.__nbit = nbit              # The number of bit in this processor
        self.error = 0                  # If there is no-error in processing, error = 0
                                        # If there is a zero division error, error = 2
                                        # If there is overflow on division, error = 4
                                        # If there is any negative number, error = 8
                                        # If there is a value which is out of range , error = 16
                                        # If the base is out of range, error = 32
                                        # If number of bit is out of range, error = 64
                                        # otherwise, error = 1  

        # check base and number of bit range
        # base number is limited in [1, 16]
        # This processor represent maximum 24-bit binary
        if (out_of_range(base, 2, 16)):
            self.error |= self.ERROR_BASERANGE

        if  (out_of_range(self.__nbit, 1, 24)):
            self.error |= self.ERROR_BITRANGE

        # check negative number
        if (a[0] == '-' or b[0] == '-'):
            a = a.lstrip("-")
            b = b.lstrip("-")
            self.error |= self.ERROR_NEGATIVE

        # Convert operators into base-10(decimal)
        self.__operator1 = any2dec(a, base)
        self.__operator2 = any2dec(b, base)

        # check range of operator values
        max = maxValue(self.__nbit)       # maximum value of n-bit binary number
        if (out_of_range(self.__operator1, 0, max) or out_of_range(self.__operator2, 0, max)):
            self.error |= self.ERROR_VALUERANGE

        # check for division
        if self.__operator2 == 0:
            self.error |= self.ERROR_ZERODIVISION
        
        if self.__operator2 > maxValue(self.__nbit - 1):
            self.error |= self.ERROR_OVERFLOW

    def __run_mul3(self):
        # Check error
        error = self.error
        ERROR = self.ERROR_BASERANGE | self.ERROR_BITRANGE | self.ERROR_VALUERANGE | self.ERROR_NEGATIVE
        if (error & ERROR):
            return
        
        # initilization
        multiplier = self.__operator2
        multiplicand = self.__operator1
        product = 0
        
        # init step
        self.log_m3 = [[multiplier, multiplicand, product]]
        
        # remain steps
        # go through all step, except init step
        for i in range(1, self.__nbit + 1):
            # If first bit of multipler is 1 
            # 1a -> Product = Product + Mulcand
            # Else 1b -> no operation  
            self.log_m3 += [[0]] 
            if (get_bit(multiplier, 0) == 1):
                self.log_m3[i][0] = 1                    #turn on changeFlag
                product = product + multiplicand   
            
            self.log_m3[i] += [[multiplier, multiplicand, product]]

            # 2 -> shilf left mulcand
            multiplicand = multiplicand << 1
            self.log_m3[i] += [[multiplier, multiplicand, product]]

            # 3 -> shilf right multiplier
            multiplier = multiplier >> 1
            self.log_m3[i] += [[multiplier, multiplicand, product]]
            self.__isrun |= 1

    def __run_mul2(self): 
        # check error
        error = self.error
        ERROR = self.ERROR_BASERANGE | self.ERROR_BITRANGE | self.ERROR_VALUERANGE | self.ERROR_NEGATIVE
        
        if (error & ERROR):
            return
       
        # initilization
        multiplicand = self.__operator1
        ProductMultiplier = self.__operator2
        
        # init step
        self.log_m2= [[multiplicand, ProductMultiplier]]
        
        # remain steps
        # go through all steps, except init step
        for i in range(1, self.__nbit + 1):
            # If first bit of ProductMultiplier is 1 
            # 1a -> ProductMultiplier = Hi(ProductMultiplier) + Mulcand
            # Else 1b -> Else no operation   
            self.log_m2 += [[0]]
            if (get_bit(ProductMultiplier, 0) == 1):
                self.log_m2[i][0] = 1                        #turn on changeFlag
                ProductMultiplier = ProductMultiplier + (multiplicand << self.__nbit)
            
            self.log_m2[i] += [[multiplicand, ProductMultiplier]]

            # 2 -> shilf right Product/Multiplier
            ProductMultiplier = ProductMultiplier >> 1
            self.log_m2[i] += [[multiplicand, ProductMultiplier]]
            self.__isrun |= 2

    def __run_div3(self):
        #check error
        error = self.error
        ERROR = self.ERROR_BASERANGE | self.ERROR_BITRANGE | self.ERROR_VALUERANGE | self.ERROR_NEGATIVE\
         | self.ERROR_OVERFLOW | self.ERROR_ZERODIVISION 
        
        # check whether there is any error or not
        if (error & ERROR):
            return

        # initilization
        divisor = self.__operator2 << self.__nbit
        remainder =self.__operator1
        quotient = 0
        
        # init step
        self.log_d3 = [[quotient, divisor, remainder]]
        
        # remain steps
        # go through all step, except init step
        for i in range(1, self.__nbit + 2):
            self.log_d3 += [[0]]
            # 1 -> remainder = remainder - divisor
            remainder = remainder - divisor
            self.log_d3[i] += [[quotient, divisor, remainder]]

            # 2 -> shilf left quotient 1 bit
            # if remainder < 0(last bit = 1), a -> remainder = remainder + divisor
            # else b -> turn on first bit of quotient
            quotient = quotient << 1
            if (get_bit(remainder, self.__nbit * 2 - 1) == 1):
                remainder = remainder + divisor
            else:
                self.log_d3[i][0] = 1        #turn on changeFlag
                quotient = turn_on_bit(quotient, 0)

            self.log_d3[i] += [[quotient, divisor, remainder]]

            # 3 -> shilf right divisor
            divisor = divisor >> 1
            self.log_d3[i] += [[quotient, divisor, remainder]]   
            self.__isrun |= 4 
        
    def run(self):
        # run all processes and return logs
        self.__run_mul3()
        self.__run_mul2()
        self.__run_div3()
        return(self.log_m3, self.log_m2, self.log_d3)

    def convertLog(self, log):    
        """
        Purpose: Convert log returned by ALU.run() to string

        Parameter:
            log     ndarray     the log which is returned by ALU.run() 

        Return:
            A string instead of ndarray with a different format
        """

        nLog = len(log)
        if (nLog <= 0):
            return ""

        nReg = len(log[0]) 

        log_s = ""

        # store init step
        for k in range(nReg):
            p = 2 if k != 0 else 1
            log_s += dec2bin(log[0][k], nbit = self.__nbit * p, sep=self.__nbit * p)
            log_s += " " if k != nReg - 1 else ""
        
        # store remain steps
        for i in range(1, nLog):
            #store changeFlag
            log_s += "," + str(log[i][0])

            #store registers
            for j in range(1, nReg + 1):
                log_s += ","
                for k in range(nReg):
                    p = 2 if k != 0 else 1
                    log_s += dec2bin(log[i][j][k], nbit = self.__nbit * p, sep = self.__nbit * p)
                    log_s += " " if k != nReg - 1 else ""

        return log_s
    def convertAll(self):
        """
        Purpose: Convert all logs and error returned by ALU.run() to string

        Parameter:
            no-parameter
        Return:
            If success, return a string format of logs and error
            If failure, return only <error> format
        """
        runAll = 1 | 2 | 4
        if not (self.__isrun & runAll): 
            return -1

        m3_s = self.convertLog(self.log_m3)
        m2_s = self.convertLog(self.log_m2)
        d3_s = self.convertLog(self.log_d3)
    
        return str(self.error) + "|" + m3_s + "|" + m2_s + "|" + d3_s


