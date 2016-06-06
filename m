From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Mon, 6 Jun 2016 16:36:54 -0600
Message-ID: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm trying to understand why our Connect-IB card is not performing as
well as our ConnectX-3 card. There are 3 ports between the two cards
and 12 paths to the iSER target which is a RAM disk.

8: ib0.9770@ib0: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:02:0a:fe:80:00:00:00:00:00:00:0c:c4:7a:ff:ff:4f:e5:d1 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.218.128.17/16 brd 10.218.255.255 scope global ib0.9770
   inet 10.218.202.17/16 brd 10.218.255.255 scope global secondary ib0.9770:0
   inet 10.218.203.17/16 brd 10.218.255.255 scope global secondary ib0.9770:1
   inet 10.218.204.17/16 brd 10.218.255.255 scope global secondary ib0.9770:2
   inet6 fe80::ec4:7aff:ff4f:e5d1/64 scope link
9: ib1.9770@ib1: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:00:2d:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:df:90 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.219.128.17/16 brd 10.219.255.255 scope global ib1.9770
   inet 10.219.202.17/16 brd 10.219.255.255 scope global secondary ib1.9770:0
   inet 10.219.203.17/16 brd 10.219.255.255 scope global secondary ib1.9770:1
   inet 10.219.204.17/16 brd 10.219.255.255 scope global secondary ib1.9770:2
   inet6 fe80::e61d:2d03:0:df90/64 scope link
10: ib2.9770@ib2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:00:2f:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:df:98 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.220.128.17/16 brd 10.220.255.255 scope global ib2.9770
   inet 10.220.202.17/16 brd 10.220.255.255 scope global secondary ib2.9770:0
   inet 10.220.203.17/16 brd 10.220.255.255 scope global secondary ib2.9770:1
   inet 10.220.204.17/16 brd 10.220.255.255 scope global secondary ib2.9770:2
   inet6 fe80::e61d:2d03:0:df98/64 scope link

The ConnectX-3 card is ib0 and Connect-IB is ib{1,2}.

# ibv_devinfo
hca_id: mlx5_0
       transport:                      InfiniBand (0)
       fw_ver:                         10.16.1006
       node_guid:                      e41d:2d03:0000:df90
       sys_image_guid:                 e41d:2d03:0000:df90
       vendor_id:                      0x02c9
       vendor_part_id:                 4113
       hw_ver:                         0x0
       board_id:                       MT_1210110019
       phys_port_cnt:                  2
               port:   1
                       state:                  PORT_ACTIVE (4)
                       max_mtu:                4096 (5)
                       active_mtu:             4096 (5)
                       sm_lid:                 1
                       port_lid:               29
                       port_lmc:               0x00
                       link_layer:             InfiniBand

               port:   2
                       state:                  PORT_ACTIVE (4)
                       max_mtu:                4096 (5)
                       active_mtu:             4096 (5)
                       sm_lid:                 1
                       port_lid:               28
                       port_lmc:               0x00
                       link_layer:             InfiniBand

hca_id: mlx4_0
       transport:                      InfiniBand (0)
       fw_ver:                         2.35.5100
       node_guid:                      0cc4:7aff:ff4f:e5d0
       sys_image_guid:                 0cc4:7aff:ff4f:e5d3
       vendor_id:                      0x02c9
       vendor_part_id:                 4099
       hw_ver:                         0x0
       board_id:                       SM_2221000001000
       phys_port_cnt:                  1
               port:   1
                       state:                  PORT_ACTIVE (4)
                       max_mtu:                4096 (5)
                       active_mtu:             4096 (5)
                       sm_lid:                 1
                       port_lid:               34
                       port_lmc:               0x00
                       link_layer:             InfiniBand

When I run fio against each path individually, I get:

disk;target IP;bandwidth,IOPs,Execution time
sdn;10.218.128.17;5053682;1263420;16599
sde;10.218.202.17;5032158;1258039;16670
sdh;10.218.203.17;4993516;1248379;16799
sdk;10.218.204.17;5081848;1270462;16507
sdc;10.219.128.17;3750942;937735;22364
sdf;10.219.202.17;3746921;936730;22388
sdi;10.219.203.17;3873929;968482;21654
sdl;10.219.204.17;3841465;960366;21837
sdd;10.220.128.17;3760358;940089;22308
sdg;10.220.202.17;3866252;966563;21697
sdj;10.220.203.17;3757495;939373;22325
sdm;10.220.204.17;4064051;1016012;20641

However, running ib_send_bw, I get:

# ib_send_bw -d mlx4_0 -i 1 10.218.128.17 -F --report_gbits
---------------------------------------------------------------------------------------
                   Send BW Test
Dual-port       : OFF          Device         : mlx4_0
Number of qps   : 1            Transport type : IB
Connection type : RC           Using SRQ      : OFF
TX depth        : 128
CQ Moderation   : 100
Mtu             : 2048[B]
Link type       : IB
Max inline data : 0[B]
rdma_cm QPs     : OFF
Data ex. method : Ethernet
---------------------------------------------------------------------------------------
local address: LID 0x3f QPN 0x02b5 PSN 0x87274e
remote address: LID 0x22 QPN 0x0213 PSN 0xaf9232
---------------------------------------------------------------------------------------
#bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
Conflicting CPU frequency values detected: 3219.835000 != 3063.531000
Test integrity may be harmed !
Warning: measured timestamp frequency 2599.95 differs from nominal 3219.84 MHz
65536      1000             50.57              50.57              0.096461
---------------------------------------------------------------------------------------
# ib_send_bw -d mlx5_0 -i 1 10.219.128.17 -F --report_gbits
---------------------------------------------------------------------------------------
                   Send BW Test
Dual-port       : OFF          Device         : mlx5_0
Number of qps   : 1            Transport type : IB
Connection type : RC           Using SRQ      : OFF
TX depth        : 128
CQ Moderation   : 100
Mtu             : 4096[B]
Link type       : IB
Max inline data : 0[B]
rdma_cm QPs     : OFF
Data ex. method : Ethernet
---------------------------------------------------------------------------------------
local address: LID 0x12 QPN 0x003e PSN 0x75f1a0
remote address: LID 0x1d QPN 0x003e PSN 0x7f7f71
---------------------------------------------------------------------------------------
#bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
Conflicting CPU frequency values detected: 3399.906000 != 2747.773000
Test integrity may be harmed !
Warning: measured timestamp frequency 2599.98 differs from nominal 3399.91 MHz
65536      1000             52.12              52.12              0.099414
---------------------------------------------------------------------------------------
# ib_send_bw -d mlx5_0 -i 2 10.220.128.17 -F --report_gbits
---------------------------------------------------------------------------------------
                   Send BW Test
Dual-port       : OFF          Device         : mlx5_0
Number of qps   : 1            Transport type : IB
Connection type : RC           Using SRQ      : OFF
TX depth        : 128
CQ Moderation   : 100
Mtu             : 4096[B]
Link type       : IB
Max inline data : 0[B]
rdma_cm QPs     : OFF
Data ex. method : Ethernet
---------------------------------------------------------------------------------------
local address: LID 0x0f QPN 0x0041 PSN 0xb7203d
remote address: LID 0x1c QPN 0x0041 PSN 0xf8b80a
---------------------------------------------------------------------------------------
#bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
Conflicting CPU frequency values detected: 3327.796000 != 1771.046000
Test integrity may be harmed !
Warning: measured timestamp frequency 2599.97 differs from nominal 3327.8 MHz
65536      1000             52.14              52.14              0.099441
---------------------------------------------------------------------------------------

Here I see that the ConnectX-3 cards with iSER is matching the
performance of the ib_send_bw. However, the Connect-IB performs better
than the mlx4 with ib_send_bw, but performs much worse with iSER.

This is running the 4.4.4 kernel. Is there some ideas of what I can do
to get the iSER performance out of the Connect-IB cards?

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
