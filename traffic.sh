#!/bin/bash

set -eu

#  VRF-1
# 10.128.1.1
# 2002::10:128:1:1

# VRF-2
# 10.128.2.2
# 2002::10:128:2:2

# VRF-3
# 10.128.3.11
# 2002::10:128:3:11

# VRF 1
# iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5201 -B 2002::10:128:1:1 -P 32 -b 125K -M 1400 &

# VRF 2
# iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5201 -B 2002::10:128:2:2 -P 32 -b 125K -M 1400 &

# VRF 3
# iperf3 -c 2002::10:128:3:11 -t 10000 -i 1 -p 5201 -B 2002::10:128:3:11 -P 32 -b 125K -M 1400 &

startAll() {
    echo "starting traffic on all clients"
    docker exec c3dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5201 -B 2002::10:128:1:3 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c4dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5202 -B 2002::10:128:1:4 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c6dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5204 -B 2002::10:128:1:6 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c8dc2 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5205 -B 2002::10:128:1:8 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c10dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5207 -B 2002::10:128:1:10 -P 32 -b 125K -M 1400 > /dev/null &

    docker exec c5dc1 iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5203 -B 2002::10:128:2:5 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c9dc2 iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5206 -B 2002::10:128:2:9 -P 32 -b 125K -M 1400 > /dev/null &

    docker exec c12dc1 iperf3 -c 2002::10:128:3:11 -t 10000 -i 1 -p 5201 -B 2002::10:128:3:12 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c13dc2 iperf3 -c 2002::10:128:3:11 -t 10000 -i 1 -p 5202 -B 2002::10:128:3:13 -P 32 -b 125K -M 1400 > /dev/null &
}

pingVRF1() {
    echo "pinging all VRF-1 clients"
    docker exec c3dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c4dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c6dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c8dc2 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c10dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
}

pingVRF2() {
    echo "pinging all VRF-2 clients"
    docker exec c5dc1 ping -c 10 -W 1 -6 -A 2002::10:128:2:2
    docker exec c9dc2 ping -c 10 -W 1 -6 -A 2002::10:128:2:2
}

pingVRF3() {
    echo "pinging all VRF-3 clients"
    docker exec c12dc1 ping -c 10 -W 1 -6 -A 2002::10:128:3:11
    docker exec c13dc2 ping -c 10 -W 1 -6 -A 2002::10:128:3:11
}

stopAll() {
    echo "stopping all traffic"
    docker exec c3dc1 pkill iperf3
    docker exec c4dc1 pkill iperf3
    docker exec c5dc1 pkill iperf3
    docker exec c6dc1 pkill iperf3
    docker exec c8dc2 pkill iperf3
    docker exec c9dc2 pkill iperf3
    docker exec c10dc1 pkill iperf3
    docker exec c12dc1 pkill iperf3
    docker exec c13dc2 pkill iperf3
}

# Packets:
# docker exec c1dc1 python3 /recieve.py
# docker exec c3dc1 python3 /send.py 10.128.1.1 ola aa:c1:ab:59:4e:d0

# start traffic
if [ $1 == "start" ]; then
    if [ $2 == "all" ]; then
        startAll
    fi
fi

# stop traffic
if [ $1 == "stop" ]; then
    if [ $2 == "all" ]; then
        stopAll
    fi
fi

# ping all clients
if [ $1 == "ping" ]; then
    if [ $2 == "all" ]; then
        pingVRF1
        pingVRF2
        pingVRF3
    fi
    if [ $2 == "vrf" ]; then
        if [ $3 == "1" ]; then
            pingVRF1
        fi
        if [ $3 == "2" ]; then
            pingVRF2
        fi
        if [ $3 == "3" ]; then
            pingVRF3
        fi
    fi
fi
