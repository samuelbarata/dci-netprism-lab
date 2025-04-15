#!/usr/bin/env python3
import random
import socket
import sys

from scapy.all import IP, TCP, UDP, Ether, get_if_hwaddr, get_if_list, sendp

def get_if():
    ifs=get_if_list()
    iface=None
    for i in get_if_list():
        if "eth1" in i:
            iface=i
            break;
    if not iface:
        print("Cannot find eth1 interface")
        exit(1)
    return iface

def main():

    if len(sys.argv)<3:
        print('pass 2 arguments: <L3 destination> "<message>" [L2 destination]')
        exit(1)

    addr = socket.gethostbyname(sys.argv[1])
    iface = get_if()

    print("sending on interface %s to %s" % (iface, str(addr)))
    if len(sys.argv) == 4:
        pkt = Ether(src=get_if_hwaddr(iface), dst=sys.argv[3])
    else:
        pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
    pkt = pkt /IP(dst=addr, ttl=0xff) / UDP(dport=1234, sport=random.randint(49152,65535)) / sys.argv[2]
    pkt.show2()
    sendp(pkt, iface=iface, verbose=False)

if __name__ == '__main__':
    main()
