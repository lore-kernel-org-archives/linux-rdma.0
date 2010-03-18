From: "Boris Shpolyansky" <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: problems running rdmaoe examples
Date: Thu, 18 Mar 2010 10:54:10 -0700
Message-ID: <1E3DCD1C63492545881FACB6063A57C1055E57FE@mtiexch01.mti.com>
References: <6978b4af1003181041m3d03afc7t8687e88be2e4b179@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rui,

It seems that you are trying to run RDMAoE over InfiniBand device (and
probably over InfiniBand network). I believe you intent was to do actual
testing over 10GE network. Please, clarify.

Boris Shpolyansky
Sr. Member of Technical Staff, Applications
 
Mellanox Technologies Inc.
350 Oakmead Parkway, Suite 100
Sunnyvale, CA 94085
Tel.: (408) 916 0014
Fax: (408) 585 0314
Cell: (408) 834 9365
www.mellanox.com

Mellanox on Twitter and Facebook


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Rui Machado
Sent: Thursday, March 18, 2010 10:41 AM
To: linux-rdma
Subject: problems running rdmaoe examples

Hi list,

I installed OFED-1.5.1-rc4 on a couple of machines to give a try to
mlx4_en and RDMAoE capabilities.
Trying to run ibv_rc_pingpong as:
server: ibv_rc_pingpong -i 2 -g 0
client: ibv_rc_pingpong -i 2 -g 0 192.168.60.101

results in the following output:

(client)
  local address:  LID 0x0000, QPN 0x5c004d, PSN 0x579776, GID
fe80::202:c9ff:fe02:ca06
  remote address: LID 0x0000, QPN 0x38004d, PSN 0xde57b8, GID
fe80::202:c9ff:fe02:ca02
Failed status transport retry counter exceeded (12) for wr_id 2

(server)
  local address:  LID 0x0000, QPN 0x38004d, PSN 0xde57b8, GID
fe80::202:c9ff:fe02:ca02
  remote address: LID 0x0000, QPN 0x5c004d, PSN 0x579776, GID
fe80::202:c9ff:fe02:ca06

My ibv_devinfo reports:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.7.000
        node_guid:                      0002:c903:0002:ca04
        sys_image_guid:                 0002:c903:0002:ca07
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xA0
        board_id:                       MT_04E0120005
        phys_port_cnt:                  2
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             2048 (4)
                        sm_lid:                 6
                        port_lid:               6
                        port_lmc:               0x00
                        link_layer:             IB

                port:   2
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             1024 (3)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet


Can someone give me any hint on what's the problem here (forgot to do
something?)?

Platform:
Linux 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
x86_64 x86_64 GNU/Linux
openSUSE 11.1 (x86_64)

Thanks in advance,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
