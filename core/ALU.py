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
# Modified Date:    Dec 10 2018
# PURPOSE:          provide a class to create detail process log in Arithmetic Logic Unit(ALU) Processor
#                   include multiple and division operation.
# 
# CONSTRUCTION
# 
# Class ALU(a, b, base, nbit)
#   CONST     
#       ERROR_UNDENTIFIED = 1
#       ERROR_ZERODIVISION = 2
#       ERROR_OVERFLOW = 4
#       ERROR_NEGATIVE = 8
#   FUNC
#       run() return (ndarray, ndarray, ndarray) 
#   VARIABLE
#       error   int     a bitmask error
#
#   See detail below........
#==========================================================================
"""
import numpy as np
from utilities import *

class ALU:
    #=====CONSTANT===============
    ERROR_UNDENTIFIED = 1
    ERROR_ZERODIVISION = 2
    ERROR_OVERFLOW = 4
    ERROR_NEGATIVE = 8

    def __init__(self, a, b, base = 10, nbit = 24):
        # Set nesscessary value
        self.__nbit = nbit              # The number of bit in this processor
        self.error = 0                  # If there is no-error in processing, error = 0
                                        # If there is a zero division error, error = 2
                                        # If there is overflow on division, error = 4
                                        # If there is any negative number, error = 8
                                        # otherwise, error = 1  

        # check base and number of bit range
        # base number is limited in [1, 16]
        # This processor represent maximum 24-bit binary
        if (out_of_range(base, 2, 16)) or (out_of_range(self.__nbit, 1, 24)):
            self.error |= self.ERROR_UNDENTIFIED

        # check negative number
        if (a[0] == '-' or b[0] == '-'):
            a = a.lstrip("-")
            b = b.lstrip("-")
            self.error |= self.ERROR_NEGATIVE

        # Convert operators into base-10(decimal)
        self.__operator1 = any2dec(a, base)
        self.__operator2 = any2dec(b, base)

        # check whether error happens in processing or not
        if (self.__operator1 < 0 or self.__operator2 < 0):
            self.error |= self.ERROR_UNDENTIFIED

        # check range of operator values
        max = maxValue(self.__nbit)       # maximum value of n-bit binary number
        if (out_of_range(self.__operator1, 0, max) or out_of_range(self.__operator2, 0, max)):
            self.error |= self.ERROR_UNDENTIFIED

        # check for division
        if self.__operator2 == 0:
            self.error |= self.ERROR_ZERODIVISION
        
        if self.__operator2 > maxValue(self.__nbit - 1):
            self.error |= self.ERROR_OVERFLOW

    def __run_mul3(self):
        # log
        # shape[0] : number of steps(include init step)
        # shape[1] : number of actions every step + 1 ChangeFlag
        # shape[2] = number of registers
        log = np.zeros((self.__nbit + 1, 4, 3), dtype = np.uint64)

        # Check error
        if (self.error & self.ERROR_UNDENTIFIED) and (self.error & self.ERROR_NEGATIVE):
            return
        
        # initilization
        multiplier = self.__operator2
        multiplicand = self.__operator1
        product = 0
        
        # init step
        log[0][0] = [multiplier, multiplicand, product]
        
        # remain steps
        for i in range(1, self.__nbit + 1):
            # If first bit of multipler is 1, 1a -> Product = Product + Mulcand
            # Else 1b -> no operation   
            if (get_bit(multiplier, 0) == 1):
                log[i][3][0] = 1
                product = product + multiplicand
            
            log[i, 0] = [multiplier, multiplicand, product]

            # 2 -> shilf left mulcand
            multiplicand = multiplicand << 1
            log[i, 1] = [multiplier, multiplicand, product]

            # 3 -> shilf right multiplier
            multiplier = multiplier >> 1
            log[i, 2] = [multiplier, multiplicand, product]

        return log

    def __run_mul2(self):
        # log
        # shape[0] : number of steps(include init step)
        # shape[1] : number of actions every step + 1 ChangeFlag
        # shape[2] = number of registers
        log = np.zeros((self.__nbit + 1, 3, 2), dtype = np.uint64)

        # check error
        if (self.error & self.ERROR_UNDENTIFIED) and (self.error & self.ERROR_NEGATIVE):
            return
       
        # initilization
        multiplicand = self.__operator1
        ProductMultiplier = self.__operator2
        
        # init step
        log[0][0] = [multiplicand, ProductMultiplier]
        
        # remain steps
        for i in range(1, self.__nbit + 1):
            # 1->If first bit of ProductMultiplier is 1 
            # a. Hi(ProductMultiplier) = Hi(ProductMultiplier) + Mulcand
            # Else b. Else no operation   
            if (get_bit(ProductMultiplier, 0) == 1):
                log[i][2][0] = 1
                ProductMultiplier = ProductMultiplier + (multiplicand << self.__nbit)
            
            log[i, 0] = [multiplicand, ProductMultiplier]

            # 2 -> shilf right Product/Multiplier
            ProductMultiplier = ProductMultiplier >> 1
            log[i, 1] = [multiplicand, ProductMultiplier]

        return(log)

    def __run_div3(self):
        # log
        # shape[0] : number of steps(include init step)
        # shape[1] : number of actions every step + 1 ChangeFlag
        # shape[2] = number of registers
        log = np.zeros((self.__nbit + 2, 4, 3), dtype = np.uint64)
       
        # check if there is any error or not
        if (self.error & self.ERROR_OVERFLOW) or (self.error & self.ERROR_ZERODIVISION):
            return

        # initilization
        divisor = self.__operator2 << self.__nbit
        remainder = self.__operator1
        quotient = 0
        
        # init step
        log[0][0] = [quotient, divisor, remainder]
        
        # remain steps
        for i in range(1, self.__nbit + 2):
            # 1 -> remainder = remainder - divisor
            remainder = remainder - divisor
            log[i][0] = [quotient, divisor, remainder]

            # 2 -> shilf left quotient 1 bit
            # a. if remainder < 0, remainder = remainder + divisor
            # b. else turn on first bit of quotient
            quotient = quotient << 1
            if (get_bit(remainder, self.__nbit * 2 - 1) == 1):
                remainder = remainder + divisor
            else:
                log[i][3][0] = 1
                quotient = turn_on_bit(quotient, 0)

            log[i][1] = [quotient, divisor, remainder]

            # 3 -> shilf right divisor
            divisor = divisor >> 1
            log[i][2] = [quotient, divisor, remainder]    

        return log
        
    def run(self):
        # run all processes and return logs
        m3 = self.__run_mul3()
        m2 = self.__run_mul2()
        d3 = self.__run_div3()
        return(m3, m2, d3)


