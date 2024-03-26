#!/bin/bash

sudo ovs-ofctl del-flows s1 
sudo ovs-ofctl del-flows s2
sudo ovs-ofctl del-flows s3
sudo ovs-ofctl del-flows s4
sudo ovs-ofctl del-flows s5

echo "Switches reset to default"