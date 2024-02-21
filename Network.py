#!/usr/bin/python3

#file to ceate mininet topology and run the network

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import OVSKernelSwitch, RemoteController
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from mininet.link import TCLink

# Network Slicing  
class MyTopo(Topo):
    def __init__(self):
        Topo.__init__(self)

        linkSwitches={}
        linkHosts={}

        # Create a topology with 5 switches and 7 hosts
        for i in range(0, 7):
            self.addHost('h%d' % (i+1))

        for i in range(0, 5):
            sconfig = {"dpid": "%016x" % (i + 1)}
            self.addSwitch('s%d' % (i + 1), **sconfig)

        
        # Add links, hosts to switches have infinite bandwith
        self.addLink('s1', 'h1', port1=1, port2=6 **linkHosts)
        self.addLink('s2', 'h2', port1=1, port2=6 **linkHosts)
        self.addLink('s3', 'h3', port1=1, port2=6 **linkHosts)
        self.addLink('s4', 'h4', port1=1, port2=6 **linkHosts)
        self.addLink('s4', 'h5', port1=2, port2=6 **linkHosts)
        self.addLink('s5', 'h6', port1=1, port2=6 **linkHosts)
        self.addLink('s5', 'h7', port1=2, port2=6 **linkHosts)
        
        # Add links between switches
        self.addLink('s1', 's2', port1=2, port2=2 **linkSwitches)
        self.addLink('s1', 's5', port1=3, port2=4 **linkSwitches)
        self.addLink('s1', 's4', port1=4, port2=3 **linkSwitches)
        self.addLink('s2', 's3', port1=3, port2=2 **linkSwitches)
        self.addLink('s2', 's5', port1=4, port2=3 **linkSwitches)
        self.addLink('s3', 's4', port1=3, port2=4 **linkSwitches)
        self.addLink('s4', 's5', port1=5, port2=5 **linkSwitches)
        
       

        

def runNetwork():
    # Create a network with a remote controller
    net = Mininet(
        topo=MyTopo(),
        switch=OVSKernelSwitch,
        build=False,
        autoSetMacs=True,
        autoStaticArp=True,
        link=TCLink,
    )
    net.addController('c0', controller=RemoteController, ip="127.0.0.1", port=6633)
    net.build()
    net.start()
    info('** Running CLI\n')
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel('info') # set Mininet log level
    runNetwork()

