

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
from ryu.lib.packet import packet

class NetworkSlicing(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(NetworkSlicing, self).__init__(*args, **kwargs)

        # Define the port to port mapping
        self.portToPortSlicing = {
            1: {"00:00:00:00:00:01": 1,
                "00:00:00:00:00:02": 2,
                "00:00:00:00:00:03": 2,
                "00:00:00:00:00:04": 4,
                "00:00:00:00:00:05": 4,
                "00:00:00:00:00:06": 3,
                "00:00:00:00:00:07": 3
            },
            2: {"00:00:00:00:00:01": 2,
                "00:00:00:00:00:02": 1,
                "00:00:00:00:00:03": 3,
                "00:00:00:00:00:04": 2,
                "00:00:00:00:00:05": 2,
                "00:00:00:00:00:06": 4,
                "00:00:00:00:00:07": 4
            },
            3: {"00:00:00:00:00:01": 2,
                "00:00:00:00:00:02": 2,
                "00:00:00:00:00:03": 1,
                "00:00:00:00:00:04": 3,
                "00:00:00:00:00:05": 3,
                "00:00:00:00:00:06": 3,
                "00:00:00:00:00:07": 3
            },
            4: {"00:00:00:00:00:01": 3,
                "00:00:00:00:00:02": 3,
                "00:00:00:00:00:03": 4,
                "00:00:00:00:00:04": 1,
                "00:00:00:00:00:05": 2,
                "00:00:00:00:00:06": 5,
                "00:00:00:00:00:07": 5
            },
            5: {"00:00:00:00:00:01": 3,
                "00:00:00:00:00:02": 3,
                "00:00:00:00:00:03": 3,
                "00:00:00:00:00:04": 5,
                "00:00:00:00:00:05": 5,
                "00:00:00:00:00:06": 1,
                "00:00:00:00:00:07": 2
            }
        }

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # install table-miss flow entry
        match = parser.OFPMatch()
        actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER,
                                          ofproto.OFPCML_NO_BUFFER)]
        self.add_flow(datapath, 0, match, actions)




    def send_packet(self, datapath, in_port, actions, msg):
        data = None
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # Construct packet_out message and send it.
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data
        
        out = parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id,
                                  in_port=in_port, actions=actions, data=data)
        
        datapath.send_msg(out)





    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        
        # Construct flow_mod message and send it.

        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                match=match, instructions=inst)
        datapath.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):

        msg = ev.msg
        datapath = msg.datapath
        parser = datapath.ofproto_parser
        in_port = msg.match['in_port']
        dpid = datapath.id

        '''
        eth = packet.Packet(msg.data).get_protocol(ethernet.ethernet)
        if eth.ethertype == ether_types.ETH_TYPE_LLDP:
            # ignore lldp packet
            return
        '''   

        dest=packet.Packet(msg.data).get_protocol(ethernet.ethernet).dst

        #discarding LLDP packets
        if packet.Packet(msg.data).get_protocol(ethernet.ethernet).ethertype == ether_types.ETH_TYPE_LLDP:
            return
        
        if dest in self.portToPortSlicing[dpid]:
            out_port = self.portToPortSlicing[dpid][dest]
            print("Packet in: ", dest, " to ", out_port)
            match = parser.OFPMatch(eth_dst=dest)
            print("Match: ", match)
            actions = [parser.OFPActionOutput(out_port)]
            print("Actions: ", actions)


            self.add_flow(datapath, 1, match, actions)  # Add flow entry to the switch
            self.send_packet(datapath, in_port, actions, msg) # Send the packet out to the switch
        else:
            out_port = datapath.ofproto.OFPP_FLOOD




# Path: NetworkSlicing.py