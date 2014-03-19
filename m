From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ib_send_lat fails when rx_depth > 255
Date: Wed, 19 Mar 2014 00:12:50 -0400
Message-ID: <CADPSxAiVGuvWwa0dMUc4XKxxDLGsiUgEyxbfkSD-cm30GPZDdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I have machines connected by ConnectX-3 40Gbps Ethernet and 40 Gbps
Infiniband. I removed the Infiniband device using the instructions
over here: http://www.6by9.net/using-linux-sys-to-disable-ethernet-hardware-devices/.

Here is the output of ibv_devinfo at one such machine:

hca_id: mlx4_0
transport: InfiniBand (0)
fw_ver: 2.11.500
node_guid: 0002:c903:0046:1e80
sys_image_guid: 0002:c903:0046:1e80
vendor_id: 0x02c9
vendor_part_id: 4099
hw_ver: 0x0
board_id: MT_1060140023
phys_port_cnt: 1
port: 1
state: PORT_ACTIVE (4)
max_mtu: 4096 (5)
active_mtu: 1024 (3)
sm_lid: 0
port_lid: 0
port_lmc: 0x00
link_layer: Ethernet

I have an application that I developed over Infiniband and I'm
thinking of trying it over RoCE. My first question is, will it just
work with RoCE or will it require significant changes?

To check if my RoCE is working, I've been trying the perftest
benchmarks. Most of it seems to work. However, ib_send_lat gives a
problem:

'ib_send_lat -s 32 -n 20000 -c UD -F -r 256' fails with:
---------------------------------------------------------------------------------------
                    Send Latency Test
 Dual-port       : OFF Device         : mlx4_0
 Number of qps   : 1 Transport type : IB
 Connection type : UD Using SRQ      : OFF
 RX depth        : 256
 Mtu             : 1024[B]
 Link type       : Ethernet
 Gid index       : 0
 Max inline data : 188[B]
 rdma_cm QPs : OFF
 Data ex. method : Ethernet
---------------------------------------------------------------------------------------
 Unable to create QP.
 Couldn't create IB resources

However, if I use "-r 255", it works. Isn't 255 a very small maximum
value for a queue depth? How can I find the maximum supported RX depth
by the NIC?

Thanks for your help!

--Anuj Kalia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
