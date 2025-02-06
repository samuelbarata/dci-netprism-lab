CLAB_TOPO=netprism.clab.yaml && alias netprism="docker run -t --network samuel --rm -v /etc/hosts:/etc/hosts:ro -v ${PWD}/${CLAB_TOPO}:/topo.yml samuelbarata/netprism:latest -t /topo.yml"
CLAB_TOPO=netprism.clab.yaml && alias fcli="docker run -t --network samuel --rm -v /etc/hosts:/etc/hosts:ro -v ${PWD}/${CLAB_TOPO}:/topo.yml  ghcr.io/srl-labs/nornir-srl:latest -t /topo.yml"
