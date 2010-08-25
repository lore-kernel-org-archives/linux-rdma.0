From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ibnetdiscover issue with multiported CA (or router) with multiple
 ports on same subnet
Date: Wed, 25 Aug 2010 13:27:02 -0400
Message-ID: <AANLkTi=54yw-YcpXNvWmsCFybZhTZX6Hp6=KW6Gz9KLH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha,

I'm seeing an issue with ibnetdiscover from a CA port where it appears
to extend a path at a "remote" CA port (it's actually another port on
the same CA) to query NodeInfo of the next hop beyond it. I get the
following error message:

src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr
0x11:0) bad status 110; Connection timed out

where smpquery -D nodeinfo of 0,1,20 is a CA which can also be seen
from the topology.

It appears to stem from the following code snippet from
libibnetdisc/src/ibnetdisc.c:recv_port_info

        if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
            == IB_PORT_PHYS_STATE_LINKUP
            && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
                (node == fabric->from_node && port_num == local_port))) {
                ib_portid_t path = smp->path;
                if (extend_dpath(engine, &path, port_num) > 0)
                        query_node_info(engine, &path, node);
        }

that was introduced by:
commit fcb8d5e7588e38508a8e354c37009d73c0a3889f
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sat Apr 10 02:43:24 2010 +0300

    libibnetdisc: no backward NodeInfo queries

    Then switch is reached via port N we don't need to query back via this
    port - source node is discovered already. Finally this saves some amount
    of unnecessary MADs.

    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

and subsequently modified by:
commit 49d149c63a44d99259f516a15af53d8cf3f0e7c9
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Tue Apr 13 19:54:45 2010 +0300

    libibnetdisc: don't try to cross discovery over CA

    When discovery is running from CA node it shouldn't try to cross over
    all ports, but only via local one (send over non-local ports will fail
    since CA doesn't route MADs).

    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

due to the (node == fabric->from_node && port_num == local_port)
clause being TRUE.

ibnetdiscover
src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr
0x11:0) bad status 110; Connection timed out
#
# Topology file: generated on Wed Aug 25 18:52:16 2010
#
# Initiated from node 0002c9020020ee0c port 0002c9020020ee0d

vendid=0x2c9
devid=0xb924
sysimgguid=0xb8cffff00438b
switchguid=0xb8cffff00438b(b8cffff00438b)
Switch  24 "S-000b8cffff00438b"         # "MT47396 Infiniscale-III
Mellanox Technologies" base port 0 lid 4 lmc 0
[5]     "H-0002c903000010e0"[1](2c903000010e1)          # "sw124
HCA-1" lid 5 4xDDR
[6]     "H-0002c9030000d1c8"[1](2c9030000d1c9)          # "sw123
HCA-1" lid 0 4xDDR
[7]     "H-0002c9020020ee0c"[1](2c9020020ee0d)          # "sw075
HCA-1" lid 2 4xDDR
[20]    "H-0002c9020020ee0c"[2](2c9020020ee0e)          # "sw075
HCA-1" lid 3 4xDDR

...

vendid=0x2c9
devid=0x6278
sysimgguid=0x2c9020020ee0f
caguid=0x2c9020020ee0c
Ca      2 "H-0002c9020020ee0c"          # "sw075 HCA-1"
[1](2c9020020ee0d)      "S-000b8cffff00438b"[7]         # lid 2 lmc 0
"MT47396 Infiniscale-III Mellanox Technologies" lid 4 4xDDR
[2](2c9020020ee0e)      "S-000b8cffff00438b"[20]                # lid
3 lmc 0 "MT47396 Infiniscale-III Mellanox Technologies" lid 4 4xDDR


smpquery -D nodeinfo 0,1,20
# Node info: DR path slid 65535; dlid 65535; 0,1,20
BaseVers:........................1
ClassVers:.......................1
NodeType:........................Channel Adapter
NumPorts:........................2
SystemGuid:......................0x0002c9020020ee0f
Guid:............................0x0002c9020020ee0c
PortGuid:........................0x0002c9020020ee0e
PartCap:.........................64
DevId:...........................0x6278
Revision:........................0x000000a0
LocalPort:.......................2
VendorId:........................0x0002c9

I don't think the local port part of the test above (node ==
fabric->from_node && port_num == local_port)  is correct where:

        local_port = (uint8_t) mad_get_field(port_info, 0,
IB_PORT_LOCAL_PORT_F);

Instead, shouldn't port_num be checked against the local port that
initiated the ibnetdiscover (which in this case is port 1) ? If so, a
"from_portnum" could be added/saved in the fabric structure and used
for this check. Do you concur with this approach ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
