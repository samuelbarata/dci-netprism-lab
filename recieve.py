from scapy.all import sniff, UDP, IP, get_if_list

counter = 0

def get_if():
    iface=None
    for i in get_if_list():
        if "eth1" in i:
            iface=i
            break;
    if not iface:
        print("Cannot find eth1 interface")
        exit(1)
    return iface

# Callback function to handle each received packet
def handle_packet(packet):
    global counter
    if UDP in packet and packet[UDP].dport == 1234:
        print(f"Received packet {counter} from {packet[IP].src}:{packet[UDP].sport}")
        print(f"Payload: {bytes(packet[UDP].payload)}")
        counter+=1

if __name__ == '__main__':
    print("Listening for UDP packets on port 1234...")
    sniff(iface=get_if(), filter="udp port 1234", prn=handle_packet)
