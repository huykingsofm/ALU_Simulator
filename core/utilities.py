"""
#==================================Introduction==========================================
# Author:           Le Ngoc Huy - UIT K12
# Contact:
# 	Email:          huykingsofm@gmail.com
# 	Edu Email:      17520074@gm.uit.edu.vn
#   Github:         https://github.com/huykingsofm/ALU_Simulator.git
#
#
# File name:        utilities.py
# Language:         Python
# Modified Date:    Dec 10 2018
# PURPOSE:          provide some special functions
# 
# PUBLIC FUNCTION
#   maxValue(nbit)                      return int
#   any2dec(a, base)                    return int
#   dec2bin(dec)                        return string
#   getbit(a, n)                        return 1/0
#   turn_on_bit(a, n)                   return int
#   out_of_range(value, min, max)       return boolean
#   removeRedundancyOfString(s)         return string
#   compressLog(log)                    return string
#
# See detail in below..........
#==========================================================================================
"""

import numpy as np
import re

def maxValue(nbit):
    """
    Function  maxValue(nbit)
    Purpose:  Create maximum number have n bit
    Parameter:
       nbit     (int)     the number of bit of number
    
    Return: maximum n-bit number value
    
    Example:
       maxValue(3) ------> maximum value of 3-bit number
       Return: 7 (responding 111 in binary)
    """
    res = 0
    while nbit > 0:
        res = (res << 1) + 1
        nbit = nbit - 1

    return res

def any2dec(a, base):
    """
    Purpose: Revert from any base-number to base-10 (decimal)

    Parameters:
        a       (string)  the number which need to be converted to decimal
        base    (int)     the base of number a(base in [2, 16])
    
    Return: 
       Success, return the responding decimal number
       Failure, return -1
    
     Example:
       any2dec("10", 2) ----> revert "10" in base-2(binary) to decimal
       Return: 2
    """
    # preprocessing
    n = len(a)
    letter = np.array(['A', 'B', 'C', 'D', 'E', 'F', 'G'])
    
    # check base range
    if  base < 2 or base > 16:
        return -1

    # check elements
    for i in range(n):
        # if it is a number, it must be less than base
        if (a[i].isdigit()):
            if int(a[i]) >= base:
                return -1

        # check if it is a character
        elif (a[i].isalpha()):  
            if (base <= 10):    # base must be greater than 10
                return -1
        
            if (a[i] < 'A' or a[i] >= letter[base - 10]):
                return -1
        # if it is neither number nor character
        else:
            return -1

    # change all character to number
    num = np.zeros((n), dtype = np.uint64)
    for i in range(n):
        if (a[i].isdigit()):
            num[i] = int(a[i])
        else:
            num[i] = np.where(letter == a[i])[0][0] + 10

    # change base
    pow = 1
    res = 0
    for i in range(n - 1, -1, -1):
        res += int(num[i]) * pow
        pow = pow * base
    
    return res


def dec2bin(d, nbit = 24, sep = 6):
    """
    Purpose: Convert decimal to binary with readable format

    Parameters:
        d       int     deciamal number
        nbit    int     number of bit in binary
        sep     int     number of bit every clusters
    
    Return:
        The number in binary

    Example:
        dec2bin(10, 6, 3)
        Return : "001 010"
    """
    
    # conver decimal binary
    b = bin(d)
    b = b[2:]

    # check number of bit whether exceed to nbit or not
    n = nbit - len(b)

    # if number of bit out of nbit then cut reduncdancy
    if (n < 0):
        b = b[-n:]
    
    # add zero in to left of string to enough nbit
    b = b.rjust(nbit, "0")

    # separate string into many clusters to make more readable
    if sep > 0 :
        for i in range(len(b) - sep, -1, -sep):
            b = b[:i] + " " + b[i:]

    return b

def get_bit(a, n):
    """
    Purpose : check a bit of a number

    Parameter:
        a   int     any number
        n   int     the order of bit need to be gotten in number

    Return:
        1 or 0 depend on value of bit

    Example:
        get_bit(10, 0) ------> get first bit of 10
        Return : 0 (10 = 1010 in binary)
        get_bit(10, 1) ------> get second bit of 10
        Return : 1
    """
    return (a >> n) & 1


def turn_on_bit(a, n):
    """
    Purpose : turn on a bit of a number

    Parameter:
        a   int     any number
        n   int     the order of bit need to be turned on in number

    Return:
        value of a after the bit turned on

    Example:
        get_bit(10, 0) ------> turn on first bit of 10
        Return : 11 (10 = 1010 ----> turn on first bit = 1011 = 11)
        get_bit(10, 1) ------> turn on second bit of 10
        Return : 10 (10 = 1010 ----> turn on second bit = 1010 = 10)
    """
    return a | (1 << n)

def out_of_range(value, min, max):
    """
    Purpose: check value whether be out of range or not
    
    Parameters:
        value   int     passed value
        min     int     minimum of value
        max     int     maximum of value

    Return:
        True if value is out of range
        False if opposition

    Example:
        out_of_range(10, 0, 10) ----> check 10 out of [0, 10]
        Return : False
        out_of_range(-3, 0, 10) ----> check -3 out of [0, 10]
        Return : True
    """
    if (value < min or value > max):
        return True
    return False


def removeRedundancyOfString(s):
    """
    Purpose: remove all brackets and redundant spaces of string

    Parameter:
        s   string      the passed string

    Return:
        the string without brackets and redundant spaces

    Example:
        removeRedundancyOfString("[1  2   3]")
        Return: "1 2 3"
    """
    # remove bracket
    s = str(s).replace("[", "")
    s = s.replace("]", "")

    # remove redundant space
    s = s.strip()
    s = re.sub(' +', ' ', s)
    return s

def convertLog(log):    
    """
    Purpose: Convert log returned by ALU.run() to string

    Parameter:
        log     ndarray     the log which is returned by ALU.run() 

    Return:
        A string instead of ndarray with a different format
    """

    # store init step
    
    nLog = log.shape[0]
    nReg = log.shape[1] - 1 

    log_s = ""
    for k in range(nReg):
        log_s += str(log[0][0][k])
        if k != nReg - 1:
            log_s += " "
    # store remain steps
    for i in range(1, nLog):
        #store changeFlag
        log_s += "," + str(log[i][nReg][0])

        #store registers
        for j in range(nReg):
            log_s += ","
            for k in range(nReg):
                log_s += str(log[i][j][k])
                if k != nReg - 1:
                    log_s += " "

    return log_s