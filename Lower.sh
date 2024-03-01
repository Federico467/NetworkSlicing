#!/bin/bash
echo 'Resetting switches...'
./reset.sh


echo '*** Creating Slices...'


# [SWITCH 1]
echo '------Switch 1-------'
sudo ovs-vsctl -- \
set port s1-eth3 qos=@newqos -- \
set port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:56=@2q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=8000000 -- \
--id=@2q create queue other-config:min-rate=100000 other-config:max-rate=4000000


# [SWITCH 2]
echo '------Switch 2-------'


# [SWITCH 3]
echo '------Switch 3-------'


# [SWITCH 4]
echo '------Switch 4-------'
sudo ovs-vsctl -- \
set port s4-eth1 qos=@newqos -- \
set port s4-eth2 qos=@newqos -- \
set port s4-eth3 qos=@newqos -- \
set port s4-eth5 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:47=@1q \
queues:56=@2q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=2000000 -- \
--id=@2q create queue other-config:min-rate=100000 other-config:max-rate=4000000

# [SWITCH 5]
echo '------Switch 5-------'
sudo ovs-vsctl -- \
set port s5-eth1 qos=@newqos -- \
set port s4-eth2 qos=@newqos -- \
set port s4-eth4 qos=@newqos -- \
set port s4-eth5 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:47=@1q \
queues:56=@2q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=2000000 -- \
--id=@2q create queue other-config:min-rate=100000 other-config:max-rate=4000000


echo 'Slices Done'
echo ' ------------------------------------------------- '

# [SWITCH 1]
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:56,output:4
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:56,output:3


# [SWITCH 2]
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop

# [SWITCH 3]
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop

# [SWITCH 4]
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=1,idle_timeout=0,actions=set_queue:47,output:5
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=2,idle_timeout=0,actions=set_queue:56,output:3
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:56,output:2
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=5,idle_timeout=0,actions=set_queue:47,output:1

# [SWITCH 5]
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=1,idle_timeout=0,actions=set_queue:56,output:4
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=2,idle_timeout=0,actions=set_queue:47,output:5
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:56,output:1
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=5,idle_timeout=0,actions=set_queue:47,output:2