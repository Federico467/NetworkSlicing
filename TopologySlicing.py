

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3

class NetworkSlicing(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(NetworkSlicing, self).__init__(*args, **kwargs)

        # Define the port to port mapping
        self.portToPortSlicing = {
            1: {1: 2, 2: 1, 4: 3, 3: 4},
            2: {2: 1, 1: 2},
            3: {2: 1, 1: 2},
            4: {1: 5, 5: 1, 2: 3, 3: 2},
            5: {2: 5, 5: 2, 1: 4, 4: 1}
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

        out_port = 999

        if dpid in self.portToPortSlicing and in_port in self.portToPortSlicing[dpid]:
        # do something with self.portToPortSlicing[dpid][in_port]
            out_port = self.portToPortSlicing[dpid][in_port]
           # print("dpid:", dpid)
           # print("in_port:", in_port)
           # print("out_port:", out_port)

        if out_port == 999:
            return
        actions = [parser.OFPActionOutput(out_port)]
        match = parser.OFPMatch(in_port=in_port)

        self.add_flow(datapath, 1, match, actions)  # Add flow entry to the switch
        self.send_packet(datapath, in_port, actions, msg) # Send the packet out to the switch





# Path: NetworkSlicing.py