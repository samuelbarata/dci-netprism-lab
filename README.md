# DCI NetPrism Development Lab

## Network Topology
![DCI Topology](assets/dci-netprism-topo.svg)

## Fabric

All routers in the Fabric are running **SR Linux**.

- Clients connected via **orange** links are part of **MAC-VRF 1**.
- Clients connected via **red** links are part of **MAC-VRF 2**.
- Clients on **green** links are **not assigned** to any network instance.
- Clients MAC address follow the format ``02:00:00:<dc>:<vrf>:<id>`

Router interconnects within the Fabric are established using **eBGP**.

The **Spine routers** function as **route reflectors** for the overlay network.

## WAN

All routers in the WAN also run **SR OS**.

- **IS-IS** is used as the IGP for WAN connectivity.
- For DCI connections, **Provider 1** and **Provider 4** act as **route reflectors**, allowing **DCGWs** to exchange **EVPN routes**.
- WAN traffic is encapsulated using **MPLS**.
