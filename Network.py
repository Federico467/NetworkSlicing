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

        # # Create a topology with 5 switches and 7 hosts
        # # Add hosts and switches
        for i in range(1, 8):
            h = self.addHost('h%s' % (i+1))
        

        for i in range(1, 6):
            sconfig = {"dpid": "%016x" % (i + 1)}
            s = self.addSwitch('s%d' % (i + 1), **sconfig)
        
        # Add links, hosts to switches have infinite bandwith
        self.addLink('h1', 's1', bw=1000)
        self.addLink('h2', 's2', bw=1000)
        self.addLink('h3', 's3', bw=1000)
        self.addLink('h4', 's4', bw=1000)
        self.addLink('h5', 's4', bw=1000)
        self.addLink('h6', 's5', bw=1000)
        self.addLink('h7', 's5', bw=1000)

        # Add links between switches
        self.addLink('s1', 's2', bw=3)
        self.addLink('s2', 's3', bw=3)
        self.addLink('s3', 's4', bw=5)
        self.addLink('s4', 's5', bw=1)
        self.addLink('s5', 's1', bw=2)
        self.addLink('s5', 's2', bw=5)
        self.addLink('s4', 's1', bw=4)

def runNetwork():
    # Create a network with a remote controller
    net = Mininet(
        topo=MyTopo(), 
        link=TCLink,
        controller=RemoteController, #da controllare ordine paramentri
        switch=OVSKernelSwitch,
        build=False,
        autoSetMacs=True,
        autoStaticArp=True,)
    net.addController('c0', controller=RemoteController, ip="127.0.0.1", port=6633)
    net.build()
    net.start()
    info('** Running CLI\n')
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel('info') # set Mininet log level
    runNetwork()
