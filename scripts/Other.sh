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
other-config:max-rate=10000000000 \
queues:34=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=10000000




# [SWITCH 4]
echo '------Switch 4-------'
sudo ovs-vsctl -- \
set port s4-eth1 qos=@newqos -- \
set port s4-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000000 \
queues:34=@1q -- \
--id=@1q create queue other-config:min-rate=100000 other-config:max-rate=10000000



echo 'Slices Done'
echo ' ------------------------------------------------- '

# [SWITCH 1]



# [SWITCH 2]


# [SWITCH 3]
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:34,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:34,normal

# [SWITCH 4]
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:34,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:34,normal

# [SWITCH 5]
