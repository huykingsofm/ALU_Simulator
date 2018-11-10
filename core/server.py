"""
#==================================Introduction==========================================
# Author:           Le Ngoc Huy - UIT K12
# Contact:
# 	Email:          huykingsofm@gmail.com
# 	Edu Email:      17520074@gm.uit.edu.vn
#   Github:         https://github.com/huykingsofm/ALU_Simulator.git
#
#
# File name:        server.py
# Language:         Python
# Modified Date:    Dec 10 2018
# PURPOSE:          provide a API to wait a connection from ALU laucher
#========================================================================================
"""
import numpy as np
import socket
from utilities import dec2bin, convertLog
from ALU import ALU


def importALU(data):
    """
    Purpose: Convert all logs and error returned by ALU.run() to string

    Parameter:
        data    ndarray     include parameters of ALU
    
    Return:
        If success, return a string format of logs and error
        If failure, return only <error> format
    """
    a = data[0]
    b = data[1]
    base = int(data[2])
    nbit = int(data[3])

    processor = ALU(a, b, base, nbit)
    error = processor.error
    m3, m2, d3 = processor.run()

    # solve m3
    m3_s = ""
    if (error & ALU.ERROR_UNDENTIFIED) != ALU.ERROR_UNDENTIFIED:
        m3_s = convertLog(m3, nbit)
        
    # solve m2
    m2_s = ""
    if (error & ALU.ERROR_UNDENTIFIED) != ALU.ERROR_UNDENTIFIED:
        m2_s = convertLog(m2, nbit)

    # solve d3
    d3_s = ""
    if error == 0:
        d3_s = convertLog(d3, nbit)

    return str(error) + "|" + m3_s + "|" + m2_s + "|" + d3_s

def call(data):
    """
    Purpose: Perform called function

    Parameter:
    data    string      a string which format "func_name|arg1,arg2,..."

    Return:
    If success, return a value responding called function
    If failure, return empty string
    """
    data = data.upper()
    data = data.split("|")

    func = data[0]
    arg = data[1].split(",")
    
    returnValue = ""

    if (func == "ALU" and len(arg) == 4):
        returnValue = importALU(arg)
        
    elif (func == "DEC2BIN" and len(arg) == 2):
        dec = np.uint64(arg[0])
        nbit = int(arg[1])
        returnValue = dec2bin(dec, nbit = nbit, sep = int(nbit / 4))

    return returnValue

def openAPI():
    """
    Purpose: Open API to connect to another program
    No-Return
    """
    HOST = '127.0.0.1'  # (localhost)
    PORT = 65432        # Port to listen on (non-privileged ports are > 1023)

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen()
    print('Begin listening......')
    conn, addr = server.accept()
        
    print('Connected by', addr)
    while True:
        print("waiting.....")
        data = conn.recv(1024)
        if not data:
            conn.close()
            break

        data = data.decode()
        print("Receive : ", data)

        data = call(data)
        print("Solved")

        conn.sendall(data.encode())
        print("Sended")

    server.close()
    print("Close connection completely.....")

#=============MAIN================================
openAPI()