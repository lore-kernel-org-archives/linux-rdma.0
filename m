From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_lat whos
Date: Thu, 9 Dec 2010 12:33:10 +0200
Message-ID: <4D00B066.80807@Voltaire.com>
References: <4CE3B455.4080003@Voltaire.com> <4CE3BCE3.7090107@Voltaire.com> <4CE50190.3080707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE50190.3080707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ido Shamai wrote:
> The latest git tree is available at git://git.openfabrics.org/~shamoya/perftest.git 

Ido, on a related issue - I'm trying to run ib_send_lat in IBoE environment and it fails. 

I'm using the latest cut of the perftest sources from git, as for the other components (libibverbs, libmlx4, kernel, FW and HW, see below). Its a system of two nodes connected back-to-back with port1 being IB and port2 being Eth, so the same perftest code works okay on IB / p1-p1 I have ping working fine over mlx4_en, so basically things are okay, I think you made a comment few weeks ago that perftest should be working now with IBoE, so I wonder what goes wrong here?

client side:
> ib_send_lat -d mlx4_0 -i 2 boo1
> ------------------------------------------------------------------
>                     Send Latency Test
>  Connection type : RC
>  Inline data is used up to 400 bytes message
>  Mtu : 1024
>  Link type is Ethernet
>  Using gid index 0 as source GID
>  local address: LID 0000 QPN 0x44004f PSN 0x6b567a
>  GID: 254:128:00:00:00:00:00:00:02:02:201:255:254:07:237:03
>  remote address: LID 0000 QPN 0x48004f PSN 0x3e78fc
>  GID: 254:128:00:00:00:00:00:00:02:02:201:255:254:07:236:243
> ------------------------------------------------------------------
>  #bytes #iterations    t_min[usec]    t_max[usec]  t_typical[usec]
>  Completion with error at server
>  Failed status 5: wr_id 0 syndrom 0xf4
> rcnt=0

server side
> ib_send_lat -d mlx4_0 -i 2
> ------------------------------------------------------------------
>                     Send Latency Test
>  Connection type : RC
>  Inline data is used up to 400 bytes message
>  Mtu : 1024
>  Link type is Ethernet
>  local address: LID 0000 QPN 0x48004f PSN 0x3e78fc
>  GID: 254:128:00:00:00:00:00:00:02:02:201:255:254:07:236:243
>  remote address: LID 0000 QPN 0x44004f PSN 0x6b567a
>  GID: 254:128:00:00:00:00:00:00:02:02:201:255:254:07:237:03
> ------------------------------------------------------------------
>  #bytes #iterations    t_min[usec]    t_max[usec]  t_typical[usec]


Or.

its ConnectX2 on both sides with firmware 2.7.700
>  ibv_devinfo
> hca_id: mlx4_0
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.7.700
>         node_guid:                      0002:c903:0007:ed02
>         sys_image_guid:                 0002:c903:0007:ed05
>         vendor_id:                      0x02c9
>         vendor_part_id:                 26428
>         hw_ver:                         0xB0
>         board_id:                       MT_0DD0120009
>         phys_port_cnt:                  2
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                2048 (4)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 12
>                         port_lid:               9
>                         port_lmc:               0x00
>                         link_layer:             IB
> 
>                 port:   2
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                2048 (4)
>                         active_mtu:             1024 (3)
>                         sm_lid:                 0
>                         port_lid:               0
>                         port_lmc:               0x00
>                         link_layer:             Ethernet


> ofa_kernel:
> git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
> commit 21556e24411b4e4b0694f70244d4a33a454ddbf5

> libibverbs:
> http://www.openfabrics.org/downloads/libibverbs/libibverbs-1.1.4-0.14.gb6c138b.tar.gz

> libmlx4:
> http://www.openfabrics.org/downloads/libmlx4/libmlx4-1.0-0.13.g4e5c43f.tar.gz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
