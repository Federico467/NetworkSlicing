#!/bin/bash

sudo ovs-ofctl del-flows s1 
sudo ovs-ofctl del-flows s2
sudo ovs-ofctl del-flows s3
sudo ovs-ofctl del-flows s4
sudo ovs-ofctl del-flows s5

sudo ovs-vsctl del-port s1 s1-eth1 -- \
add-port s1 s1-eth1
sudo ovs-vsctl del-port s1 s1-eth2 -- \
add-port s1 s1-eth2
sudo ovs-vsctl del-port s1 s1-eth3 -- \
add-port s1 s1-eth3
sudo ovs-vsctl del-port s1 s1-eth4 -- \
add-port s1 s1-eth4


sudo ovs-vsctl del-port s2 s2-eth1 -- \
add-port s2 s2-eth1
sudo ovs-vsctl del-port s2 s2-eth2 -- \
add-port s2 s2-eth2
sudo ovs-vsctl del-port s2 s2-eth3 -- \
add-port s2 s2-eth3
sudo ovs-vsctl del-port s2 s2-eth4 -- \
add-port s2 s2-eth4

sudo ovs-vsctl del-port s3 s3-eth1 -- \
add-port s3 s3-eth1
sudo ovs-vsctl del-port s3 s3-eth2 -- \
add-port s3 s3-eth2
sudo ovs-vsctl del-port s3 s3-eth3 -- \
add-port s3 s3-eth3


sudo ovs-vsctl del-port s4 s4-eth1 -- \
add-port s4 s4-eth1
sudo ovs-vsctl del-port s4 s4-eth2 -- \
add-port s4 s4-eth2
sudo ovs-vsctl del-port s4 s4-eth3 -- \
add-port s4 s4-eth3
sudo ovs-vsctl del-port s4 s4-eth4 -- \
add-port s4 s4-eth4
sudo ovs-vsctl del-port s4 s4-eth5 -- \
add-port s4 s4-eth5



sudo ovs-vsctl del-port s5 s5-eth1 -- \
add-port s5 s5-eth1
sudo ovs-vsctl del-port s5 s5-eth2 -- \
add-port s5 s5-eth2
sudo ovs-vsctl del-port s5 s5-eth3 -- \
add-port s5 s5-eth3
sudo ovs-vsctl del-port s5 s5-eth4 -- \
add-port s5 s5-eth4
sudo ovs-vsctl del-port s5 s5-eth5 -- \
add-port s5 s5-eth5

echo "Switches reset to default"