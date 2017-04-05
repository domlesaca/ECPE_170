#!/usr/bin/env python3

# Python DNS query client
#
# Example usage:
#   ./dns.py --type=A --name=www.pacific.edu --server=8.8.8.8
#   ./dns.py --type=AAAA --name=www.google.com --server=8.8.8.8

# Should provide equivalent results to:
#   dig www.pacific.edu A @8.8.8.8 +noedns
#   dig www.google.com AAAA @8.8.8.8 +noedns
#   (note that the +noedns option is used to disable the pseduo-OPT
#    header that dig adds. Our Python DNS client does not need
#    to produce that optional, more modern header)


from dns_tools import dns  # Custom module for boilerplate code
from dns_tools import dns_header_bitfields

import argparse
import ctypes
import random
import socket
import struct
import sys

def main():
    max_recv = 64 * 1024
    # Setup configuration
    parser = argparse.ArgumentParser(description='DNS client for ECPE 170')
    parser.add_argument('--type', action='store', dest='qtype',
                        required=True, help='Query Type (A or AAAA)')
    parser.add_argument('--name', action='store', dest='qname',
                        required=True, help='Query Name')
    parser.add_argument('--server', action='store', dest='server_ip',
                        required=True, help='DNS Server IP')

    args = parser.parse_args()
    qtype = args.qtype
    qname = args.qname
    server_ip = args.server_ip
    port = 53
    server_address = (server_ip, port)

    if qtype not in ("A", "AAAA"):
        print("Error: Query Type must be 'A' (IPv4) or 'AAAA' (IPv6)")
        sys.exit()

    # Create UDP socket
    # ---------
    # STUDENT TO-DO
    # ---------
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    except socket.error as error:
        print('ERROR:  couldnt create socket')
        print('Description:  ', str(error))
        sys.exit()


    # Generate DNS request message
    # ---------
    # STUDENT TO-DO
    # ---------
    bitfields = dns_header_bitfields()
    bitfields.qr = 0
    bitfields.opcode = 0
    bitfields.aa = 0
    bitfields.tc = 0
    bitfields.rd = 1
    bitfields.ra = 0
    bitfields.reserved = 0
    bitfields.rcode = 0

    messageID = 0xfe3c
    qdcount = 1
    ancount = 0
    nscount = 0
    arcount = 0

    splitname = qname.split('.')

    request = bytearray()
    request += struct.pack('!H2sHHHH',
                           messageID,
                           bytes(bitfields),
                           qdcount,
                           ancount,
                           nscount,
                           arcount)
    for x in splitname:
        request += struct.pack('B', len(x))
        request += x.encode('ascii')
    request += struct.pack('B', 0)

    request += struct.pack('B', 0)
    if qtype == 'A':
        qtypenum = 1
    else:
        qtypenum = 0x001c
    request += struct.pack('B', qtypenum)

    request += struct.pack('B', 0)
    request += struct.pack('B', 1)

    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    print('Sending request for ', qname, ', type ', qtype, ', to server ',
          server_ip, ', port ', port)
    try:
        s.sendto(request, server_address)
    except socket.error as error:
        print('ERROR:  couldnt send request')
        print('Description:  ', str(error))
        sys.exit()

    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    res = b''

    try:
        (raw_bytes, address) = s.recvfrom(4096)
        res += raw_bytes

    except socket.error as error:
        print('ERROR:  failed to receive bytes from host')
        print('Description:  ', str(error))
        sys.exit()

    # Close socket
    # ---------
    # STUDENT TO-DO
    # ---------
    try:
        s.close()
    except socket.error as error:
        print('ERROR:  failed to close socket')
        print('Description:  ', str(error))
        sys.exit()

    # Decode DNS message and display to screen
    dns.decode_dns(raw_bytes)


if __name__ == "__main__":
    sys.exit(main())
