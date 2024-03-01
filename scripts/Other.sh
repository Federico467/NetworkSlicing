#!/bin/bash
echo 'Resetting switches...'
./reset.sh

echo 'Creating Slices...'


# [SWITCH 1]
echo '------Switch 1-------'



# [SWITCH 2]
echo '------Switch 2-------'


# [SWITCH 3]
echo '------Switch 3-------'
sudo ovs-vsctl -- \
set port s3-eth1 qos=@newqos -- \
set port s3-eth3 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:35=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=10000000


# [SWITCH 4]
echo '------Switch 4-------'


# [SWITCH 5]
echo '------Switch 5-------'
sudo ovs-vsctl -- \
set port s5-eth2 qos=@newqos -- \
set port s5-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:35=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=10000000



echo 'Slices Done'
echo ' ------------------------------------------------- '

# [SWITCH 1]
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop


# [SWITCH 2]
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop

# [SWITCH 3]
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=1,idle_timeout=0,actions=set_queue:35,output:3
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:35,output:1

# [SWITCH 4]
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=2,idle_timeout=0,actions=set_queue:35,output:4
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:35,output:2
sudo ovs-ofctl add-flow s4 ip,priority=65500,in_port=5,idle_timeout=0,actions=drop

# [SWITCH 5]
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s5 ip,priority=65500,in_port=5,idle_timeout=0,actions=drop