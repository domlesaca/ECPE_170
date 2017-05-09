# final exam python code
# Dominic Lesaca
# ecpe170

from dns_tools import dns  # Custom module for boilerplate code
from dns_tools import dns_header_bitfields

import argparse
import ctypes
import random
import socket
import struct
import sys

def main():

    #setting data to be sent
    version = 1
    a = 5
    b = 6
    name = "Dominic Lesaca"
    nameLen = len(name)

    server_ip = "10.10.5.203"
    port = 3456
    server_address = (server_ip, port)

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    except socket.error as error:
        print('ERROR:  couldnt create socket')
        print('Description:  ', str(error))
        sys.exit()

    request = bytearray()
    request += struct.pack('>BIII',version, a, b, nameLen)
    request += name.encode('ascii')

    print('Sending request')
    try:
        s.sendto(request, server_address)
    except socket.error as error:
        print('ERROR:  couldnt send request')
        print('Description:  ', str(error))
        sys.exit()

    res = b''

    try:
        (raw_bytes, address) = s.recvfrom(4096)
        res += raw_bytes

    except socket.error as error:
        print('ERROR:  failed to receive bytes from host')
        print('Description:  ', str(error))
        sys.exit()

    try:
        s.close()
    except socket.error as error:
        print('ERROR:  failed to close socket')
        print('Description:  ', str(error))
        sys.exit()

    (version, status, sum) = struct.unpack('!Bhi', raw_bytes)
    print('Version Number: ', version)
    if status == 1:
        print('Success')
        print(a, '+', b, '=', sum)
    else:
        print('Faliure')

if __name__ == '__main__':
    #print(struct.calcsize('!Bhi'))
    sys.exit(main())