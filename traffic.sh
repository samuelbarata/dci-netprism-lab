#!/bin/bash

set -eu

#  VRF-1
# 10.128.1.1/
# 2002::10:128:1:1
# VRF-2
# 10.128.2.2
# 2002::10:128:2:2

# VRF 1
# iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5201 -B 2002::10:128:1:1 -P 32 -b 125K -M 1400 &

# VRF 2
# iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5201 -B 2002::10:128:2:2 -P 32 -b 125K -M 1400 &

startAll() {
    echo "starting traffic on all clients"
    docker exec c3dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5201 -B 2002::10:128:1:3 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c4dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5202 -B 2002::10:128:1:4 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c5dc1 iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5203 -B 2002::10:128:2:5 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c6dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5204 -B 2002::10:128:1:6 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c8dc2 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5205 -B 2002::10:128:1:8 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c9dc2 iperf3 -c 2002::10:128:2:2 -t 10000 -i 1 -p 5206 -B 2002::10:128:2:9 -P 32 -b 125K -M 1400 > /dev/null &
    docker exec c10dc1 iperf3 -c 2002::10:128:1:1 -t 10000 -i 1 -p 5207 -B 2002::10:128:1:8 -P 32 -b 125K -M 1400 > /dev/null &
}

pingAll() {
    echo "pinging all clients"
    # docker exec c9dc2 ping --help
    docker exec c3dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c4dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c5dc1 ping -c 10 -W 1 -6 -A 2002::10:128:2:2
    docker exec c6dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c8dc2 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
    docker exec c9dc2 ping -c 10 -W 1 -6 -A 2002::10:128:2:2
    docker exec c10dc1 ping -c 10 -W 1 -6 -A 2002::10:128:1:1
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
}


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
        pingAll
    fi
fi
