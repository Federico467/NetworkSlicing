#!/bin/bash
echo 'Resetting switches...'
./reset.sh


echo '*** Creating Slices...'


# [SWITCH 1]
echo '------Switch 1-------'
sudo ovs-vsctl -- \
set port s1-eth1 qos=@newqos -- \
set port s1-eth2 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000000 \
queues:12=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=8000000


# [SWITCH 2]
echo '------Switch 2-------'
sudo ovs-vsctl -- \
set port s2-eth1 qos=@newqos -- \
set port s2-eth2 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000000 \
queues:12=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=8000000

# [SWITCH 3]
echo '------Switch 3-------'


# [SWITCH 4]
echo '------Switch 4-------'
sudo ovs-vsctl -- \
set port s4-eth1 qos=@newqos -- \
set port s4-eth2 qos=@newqos -- \
set port s4-eth5 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000000 \
queues:47=@1q \
queues:56=@2q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=2000000 -- \
--id=@2q create queue other-config:min-rate=100000 other-config:max-rate=4000000

# [SWITCH 5]
echo '------Switch 5-------'
sudo ovs-vsctl -- \
set port s5-eth1 qos=@newqos -- \
set port s5-eth2 qos=@newqos -- \
set port s5-eth5 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000000 \
queues:47=@1q \
queues:56=@2q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=2000000 -- \
--id=@2q create queue other-config:min-rate=100000 other-config:max-rate=4000000


echo 'Slices Done'
echo ' ------------------------------------------------- '

# [SWITCH 1]
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:12,normal
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:12,normal


# [SWITCH 2]
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:12,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:12,normal

# [SWITCH 3]


# [SWITCH 4]
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:47,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:56,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:47,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:56,normal

# [SWITCH 5]
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:47,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:56,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:47,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:56,normal