From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: opensm not reaching nodes
Date: Thu, 11 Oct 2012 13:56:46 -0700
Message-ID: <CA+ZH+jH6VQcgFn8xRqwQVbxWQNiv5T0O-SL1w_nuWGyNpOPFxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm upgrading a cluster to CentOS-6.2 running an OFED-1.5.4.1 IB
stack.  Every time a node tries to join the fabric, opensmd comes back
with this:

Oct 11 12:09:42 777493 [41F7700] 0x01 -> state_mgr_light_sweep_start:
ERR 3315: Unknown remote side for node 0x0008f10500108bfa (Voltaire
4036 # p3r17i1) port 15. Adding to light sweep sampling list
Oct 11 12:09:42 777532 [41F7700] 0x01 -> Directed Path Dump of 3 hop
path: Path = 0,1,23,5Oct 11 12:09:43 578014 [37F6700] 0x01 ->
log_send_error: ERR 5411: DR SMP Send completed with error
(IB_TIMEOUT) -- dropping
                        Method 0x1, Attr 0x15, TID 0x14a2
Oct 11 12:09:43 578050 [37F6700] 0x01 -> Received SMP on a 4 hop path:
Initial path = 0,1,23,5,15, Return path  = 0,0,0,0,0
Oct 11 12:09:43 578065 [37F6700] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT): SubnGet(PortInfo), attr_mod
0x0, TID 0x14a2

These nodes work just fine on an older stack (CentOS-5.5,
OFED-1.5.3.1), and I've been running the same stack that I'm trying to
upgrade to (CentOS-6.2, OFED-1.5.4.1 with opensm 3.1.3.14) in
production for months on other clusters.  I've tried multiple versions
of opensm already (both old and new).  This cluster has slightly
different hardware (including the HCAs), but why isn't the SM able to
reach these nodes?

ibv_devinfo (on the old stack) shows:
hca_id:    mlx4_0
    transport:            InfiniBand (0)
    fw_ver:                2.7.9294
    node_guid:            78e7:d103:0021:6984
    sys_image_guid:            78e7:d103:0021:6987
    vendor_id:            0x02c9
    vendor_part_id:            26438
    hw_ver:                0xB0
    board_id:            HP_0200000003
    phys_port_cnt:            2
        port:    1
            state:            PORT_ACTIVE (4)
            max_mtu:        2048 (4)
            active_mtu:        2048 (4)
            sm_lid:            10
            port_lid:        306
            port_lmc:        0x00
            link_layer:        IB

        port:    2
            state:            PORT_DOWN (1)
            max_mtu:        2048 (4)
            active_mtu:        256 (1)
            sm_lid:            0
            port_lid:        0
            port_lmc:        0x00
            link_layer:        Ethernet

Let me know and I can provide any information necessary to help debug.

-JE
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
