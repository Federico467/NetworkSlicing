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

        linkSwitches=dict(bw=10)
        linkHosts=dict(bw=1000)

        # Create a topology with 5 switches and 7 hosts

        for i in range(0, 5):
            sconfig = {"dpid": "%016x" % (i + 1)}
            self.addSwitch('s%d' % (i + 1), **sconfig)

        for i in range(0, 7):
            self.addHost('h%s' % (i+1))

        
        # Add links between switches
        self.addLink('s1', 's2', **linkSwitches)
        self.addLink('s2', 's3', **linkSwitches)
        self.addLink('s3', 's4', **linkSwitches)
        self.addLink('s4', 's5', **linkSwitches)
        self.addLink('s5', 's1', **linkSwitches)
        self.addLink('s5', 's2', **linkSwitches)
        self.addLink('s4', 's1', **linkSwitches)
        
        # Add links, hosts to switches have infinite bandwith
        self.addLink('h1', 's1', **linkHosts)
        self.addLink('h2', 's2', **linkHosts)
        self.addLink('h3', 's3', **linkHosts)
        self.addLink('h4', 's4', **linkHosts)
        self.addLink('h5', 's4', **linkHosts)
        self.addLink('h6', 's5', **linkHosts)
        self.addLink('h7', 's5', **linkHosts)

        

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

