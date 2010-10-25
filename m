From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Mon, 25 Oct 2010 11:26:38 +0200
Message-ID: <4CC54D4E.7050203@Voltaire.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com> <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> On Sun, Oct 24, 2010 at 6:22 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>>  > No you did not. It was there already but we never noticed before Yossi's patch.
>> But AFAICT Yossi's patch (5eb620c8) went into 2.6.22 about 2.5 years
>> ago... wasn't that already there way before the IBoE stuff started?

> I see... I think the reason it started failing comes from this portion of patch 8:

I pulled/built/booted with the for-next branch of Roland's tree, and I can't get IB link for the node, 
I don't think this is my problem, since I'm on L2 IB and not Eth, but should this work with pre 2.7 
firmware?! if not, maybe patch the mlx4 driver to print some error,

> # ibv_devinfo
> hca_id: mlx4_0
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.6.818
>         node_guid:                      0002:c903:0002:6be2
>         sys_image_guid:                 0002:c903:0002:6be5
>         vendor_id:                      0x02c9
>         vendor_part_id:                 26418
>         hw_ver:                         0xA0
>         board_id:                       MT_0A50110002
>         phys_port_cnt:                  2
>                 port:   1
>                         state:                  PORT_INIT (2)
>                         max_mtu:                2048 (4)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 0
>                         port_lid:               0
>                         port_lmc:               0x00
> 
>                 port:   2
>                         state:                  PORT_INIT (2)
>                         max_mtu:                2048 (4)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 0
>                         port_lid:               0
>                         port_lmc:               0x00

> # dmesg
> mlx4_core: Mellanox ConnectX core driver v0.01 (May 1, 2007)
> mlx4_core: Initializing 0000:0b:00.0
> mlx4_core 0000:0b:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
> mlx4_core 0000:0b:00.0: setting latency timer to 64
> mlx4_core 0000:0b:00.0: FW version 2.6.818 (cmd intf rev 3), max commands 16
> mlx4_core 0000:0b:00.0: Catastrophic error buffer at 0x1f020, size 0x10, BAR 0
> mlx4_core 0000:0b:00.0: FW size 385 KB
> mlx4_core 0000:0b:00.0: Clear int @ f0058, BAR 0
> mlx4_core 0000:0b:00.0: Mapped 26 chunks/6168 KB for FW.
> mlx4_core 0000:0b:00.0: BlueFlame available (reg size 512, regs/page 256)
> mlx4_core 0000:0b:00.0: Base MM extensions: flags 00000cc0, rsvd L_Key 00000500
> mlx4_core 0000:0b:00.0: Max ICM size 4294967296 MB
> mlx4_core 0000:0b:00.0: Max QPs: 16777216, reserved QPs: 64, entry size: 256
> mlx4_core 0000:0b:00.0: Max SRQs: 16777216, reserved SRQs: 64, entry size: 128
> mlx4_core 0000:0b:00.0: Max CQs: 16777216, reserved CQs: 128, entry size: 128
> mlx4_core 0000:0b:00.0: Max EQs: 512, reserved EQs: 4, entry size: 128
> mlx4_core 0000:0b:00.0: reserved MPTs: 16, reserved MTTs: 16
> mlx4_core 0000:0b:00.0: Max PDs: 8388608, reserved PDs: 4, reserved UARs: 1
> mlx4_core 0000:0b:00.0: Max QP/MCG: 8388608, reserved MGMs: 0
> mlx4_core 0000:0b:00.0: Max CQEs: 4194304, max WQEs: 16384, max SRQ WQEs: 16384
> mlx4_core 0000:0b:00.0: Local CA ACK delay: 15, max MTU: 4096, port width cap: 3
> mlx4_core 0000:0b:00.0: Max SQ desc size: 1008, max SQ S/G: 62
> mlx4_core 0000:0b:00.0: Max RQ desc size: 512, max RQ S/G: 32
> mlx4_core 0000:0b:00.0: Max GSO size: 131072
> mlx4_core 0000:0b:00.0: DEV_CAP flags:
> mlx4_core 0000:0b:00.0:     RC transport
> mlx4_core 0000:0b:00.0:     UC transport
> mlx4_core 0000:0b:00.0:     UD transport
> mlx4_core 0000:0b:00.0:     XRC transport
> mlx4_core 0000:0b:00.0:     FCoIB support
> mlx4_core 0000:0b:00.0:     SRQ support
> mlx4_core 0000:0b:00.0:     IPoIB checksum offload
> mlx4_core 0000:0b:00.0:     P_Key violation counter
> mlx4_core 0000:0b:00.0:     Q_Key violation counter
> mlx4_core 0000:0b:00.0:     Big LSO headers
> mlx4_core 0000:0b:00.0:     APM support
> mlx4_core 0000:0b:00.0:     Atomic ops support
> mlx4_core 0000:0b:00.0:     Address vector port checking support
> mlx4_core 0000:0b:00.0:     UD multicast support
> mlx4_core 0000:0b:00.0:     Router support
> mlx4_core 0000:0b:00.0:     IBoE support
> mlx4_core 0000:0b:00.0:   profile[ 0] (  CMPT): 2^26 entries @ 0x         0, size 0x 100000000
> mlx4_core 0000:0b:00.0:   profile[ 1] (RDMARC): 2^21 entries @ 0x 100000000, size 0x   4000000
> mlx4_core 0000:0b:00.0:   profile[ 2] (   MTT): 2^20 entries @ 0x 104000000, size 0x   4000000
> mlx4_core 0000:0b:00.0:   profile[ 3] (    QP): 2^17 entries @ 0x 108000000, size 0x   2000000
> mlx4_core 0000:0b:00.0:   profile[ 4] (  ALTC): 2^17 entries @ 0x 10a000000, size 0x    800000
> mlx4_core 0000:0b:00.0:   profile[ 5] (   SRQ): 2^16 entries @ 0x 10a800000, size 0x    800000
> mlx4_core 0000:0b:00.0:   profile[ 6] (    CQ): 2^16 entries @ 0x 10b000000, size 0x    800000
> mlx4_core 0000:0b:00.0:   profile[ 7] (  DMPT): 2^17 entries @ 0x 10b800000, size 0x    800000
> mlx4_core 0000:0b:00.0:   profile[ 8] (   MCG): 2^13 entries @ 0x 10c000000, size 0x    200000
> mlx4_core 0000:0b:00.0:   profile[ 9] (  AUXC): 2^17 entries @ 0x 10c200000, size 0x     20000
> mlx4_core 0000:0b:00.0:   profile[10] (    EQ): 2^04 entries @ 0x 10c220000, size 0x      1000
> mlx4_core 0000:0b:00.0: HCA context memory: reserving 4393092 KB
> mlx4_core 0000:0b:00.0: 4393092 KB of HCA context requires 8620 KB aux memory.
> mlx4_core 0000:0b:00.0: Mapped 37 chunks/8620 KB for ICM aux.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 40000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 80000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/4 KB at c0000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/4 KB at 10c220000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 104000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10b800000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 108000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/128 KB at 10c200000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10a000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 100000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10b000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10a800000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c000000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c040000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c080000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c0c0000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c100000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c140000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c180000 for ICM.
> mlx4_core 0000:0b:00.0: Mapped 1 chunks/256 KB at 10c1c0000 for ICM.
> mlx4_core 0000:0b:00.0: irq 82 for MSI/MSI-X
> mlx4_core 0000:0b:00.0: irq 83 for MSI/MSI-X
> mlx4_core 0000:0b:00.0: irq 84 for MSI/MSI-X
> mlx4_core 0000:0b:00.0: irq 85 for MSI/MSI-X
> mlx4_core 0000:0b:00.0: irq 86 for MSI/MSI-X
> mlx4_core 0000:0b:00.0: NOP command IRQ test passed
> mlx4_en: Mellanox ConnectX HCA Ethernet driver v1.4.1.1 (June 2009)
> mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0 (April 4, 2008)
> ADDRCONF(NETDEV_UP): ib0: link is not ready
> ADDRCONF(NETDEV_UP): ib1: link is not ready
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
