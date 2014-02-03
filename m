From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Mon, 3 Feb 2014 11:27:09 +0400
Message-ID: <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
 <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-02-03 Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> What kernel you used before? can you please send here the dmesg output when
> the mlx4_core driver loads with debug_level=1


Before that i'm using 2.6.32 from debian squeeze...
dmesg:
[583789.683677] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
[583789.683710] mlx4_core: Initializing 0000:03:00.0
[583790.687071] mlx4_core 0000:03:00.0: FW version 2.6.900 (cmd intf
rev 3), max commands 16
[583790.687077] mlx4_core 0000:03:00.0: Catastrophic error buffer at
0x1f020, size 0x10, BAR 0
[583790.687081] mlx4_core 0000:03:00.0: Communication vector bar:0 offset:0x0
[583790.687084] mlx4_core 0000:03:00.0: FW size 385 KB
[583790.687088] mlx4_core 0000:03:00.0: Internal clock bar:0 offset:0x0
[583790.687091] mlx4_core 0000:03:00.0: Clear int @ f0058, BAR 0
[583790.688781] mlx4_core 0000:03:00.0: Mapped 26 chunks/6168 KB for FW.
[583791.325846] mlx4_core 0000:03:00.0: BlueFlame available (reg size
512, regs/page 8)
[583791.325952] mlx4_core 0000:03:00.0: Base MM extensions: flags
00000cc0, rsvd L_Key 00000500
[583791.325954] mlx4_core 0000:03:00.0: Max ICM size 4294967296 MB
[583791.325957] mlx4_core 0000:03:00.0: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[583791.325959] mlx4_core 0000:03:00.0: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[583791.325962] mlx4_core 0000:03:00.0: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[583791.325964] mlx4_core 0000:03:00.0: Max EQs: 512, reserved EQs: 4,
entry size: 128
[583791.325967] mlx4_core 0000:03:00.0: reserved MPTs: 16, reserved MTTs: 16
[583791.325969] mlx4_core 0000:03:00.0: Max PDs: 8388608, reserved
PDs: 4, reserved UARs: 1
[583791.325971] mlx4_core 0000:03:00.0: Max QP/MCG: 8388608, reserved MGMs: 0
[583791.325974] mlx4_core 0000:03:00.0: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[583791.325976] mlx4_core 0000:03:00.0: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 3
[583791.325978] mlx4_core 0000:03:00.0: Max SQ desc size: 1008, max SQ S/G: 62
[583791.325981] mlx4_core 0000:03:00.0: Max RQ desc size: 512, max RQ S/G: 32
[583791.325983] mlx4_core 0000:03:00.0: Max GSO size: 131072
[583791.325985] mlx4_core 0000:03:00.0: Max counters: 0
[583791.325987] mlx4_core 0000:03:00.0: Max RSS Table size: 256
[583791.325989] mlx4_core 0000:03:00.0: DEV_CAP flags:
[583791.325991] mlx4_core 0000:03:00.0:     RC transport
[583791.325993] mlx4_core 0000:03:00.0:     UC transport
[583791.325995] mlx4_core 0000:03:00.0:     UD transport
[583791.325997] mlx4_core 0000:03:00.0:     XRC transport
[583791.325999] mlx4_core 0000:03:00.0:     FCoIB support
[583791.326001] mlx4_core 0000:03:00.0:     SRQ support
[583791.326003] mlx4_core 0000:03:00.0:     IPoIB checksum offload
[583791.326005] mlx4_core 0000:03:00.0:     P_Key violation counter
[583791.326007] mlx4_core 0000:03:00.0:     Q_Key violation counter
[583791.326009] mlx4_core 0000:03:00.0:     Big LSO headers
[583791.326011] mlx4_core 0000:03:00.0:     APM support
[583791.326013] mlx4_core 0000:03:00.0:     Atomic ops support
[583791.326015] mlx4_core 0000:03:00.0:     Address vector port checking support
[583791.326017] mlx4_core 0000:03:00.0:     UD multicast support
[583791.326019] mlx4_core 0000:03:00.0:     Router support
[583791.326021] mlx4_core 0000:03:00.0:     IBoE support
[583791.326023] mlx4_core 0000:03:00.0:     RSS support
[583791.326025] mlx4_core 0000:03:00.0:     RSS Toeplitz Hash Function support
[583791.326027] mlx4_core 0000:03:00.0:     RSS XOR Hash Function support
[583791.326030] mlx4_core 0000:03:00.0: Steering mode is: A0 steering,
oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
[583791.326037] mlx4_core 0000:03:00.0:   profile[ 0] (  CMPT): 2^26
entries @ 0x         0, size 0x 100000000
[583791.326040] mlx4_core 0000:03:00.0:   profile[ 1] (RDMARC): 2^22
entries @ 0x 100000000, size 0x   8000000
[583791.326043] mlx4_core 0000:03:00.0:   profile[ 2] (    QP): 2^18
entries @ 0x 108000000, size 0x   4000000
[583791.326045] mlx4_core 0000:03:00.0:   profile[ 3] (   MTT): 2^23
entries @ 0x 10c000000, size 0x   4000000
[583791.326048] mlx4_core 0000:03:00.0:   profile[ 4] (  DMPT): 2^19
entries @ 0x 110000000, size 0x   2000000
[583791.326051] mlx4_core 0000:03:00.0:   profile[ 5] (  ALTC): 2^18
entries @ 0x 112000000, size 0x   1000000
[583791.326054] mlx4_core 0000:03:00.0:   profile[ 6] (   SRQ): 2^16
entries @ 0x 113000000, size 0x    800000
[583791.326057] mlx4_core 0000:03:00.0:   profile[ 7] (    CQ): 2^16
entries @ 0x 113800000, size 0x    800000
[583791.326060] mlx4_core 0000:03:00.0:   profile[ 8] (   MCG): 2^13
entries @ 0x 114000000, size 0x    800000
[583791.326063] mlx4_core 0000:03:00.0:   profile[ 9] (  AUXC): 2^18
entries @ 0x 114800000, size 0x     40000
[583791.326066] mlx4_core 0000:03:00.0:   profile[10] (    EQ): 2^06
entries @ 0x 114840000, size 0x      2000
[583791.326068] mlx4_core 0000:03:00.0: HCA context memory: reserving 4530440 KB
[583791.326089] mlx4_core 0000:03:00.0: 4530440 KB of HCA context
requires 8888 KB aux memory.
[583791.348513] mlx4_core 0000:03:00.0: Mapped 38 chunks/8888 KB for ICM aux.
[583791.349649] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
[583791.350756] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
40000000 for ICM.
[583791.351862] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
80000000 for ICM.
[583791.351894] mlx4_core 0000:03:00.0: Mapped 1 chunks/4 KB at
c0000000 for ICM.
[583791.351942] mlx4_core 0000:03:00.0: Mapped 1 chunks/8 KB at
114840000 for ICM.
[583791.353028] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
10c000000 for ICM.
[583791.354151] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
110000000 for ICM.
[583791.355235] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
108000000 for ICM.
[583791.356319] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114800000 for ICM.
[583791.357404] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
112000000 for ICM.
[583791.358489] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
100000000 for ICM.
[583791.359571] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
113800000 for ICM.
[583791.360657] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
113000000 for ICM.
[583791.361741] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114000000 for ICM.
[583791.362824] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114040000 for ICM.
[583791.363907] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114080000 for ICM.
[583791.364991] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1140c0000 for ICM.
[583791.366074] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114100000 for ICM.
[583791.367158] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114140000 for ICM.
[583791.368240] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114180000 for ICM.
[583791.369324] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1141c0000 for ICM.
[583791.370409] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114200000 for ICM.
[583791.371491] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114240000 for ICM.
[583791.372574] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114280000 for ICM.
[583791.373657] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1142c0000 for ICM.
[583791.374741] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114300000 for ICM.
[583791.375823] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114340000 for ICM.
[583791.376908] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114380000 for ICM.
[583791.377992] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1143c0000 for ICM.
[583791.379073] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114400000 for ICM.
[583791.380158] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114440000 for ICM.
[583791.381242] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114480000 for ICM.
[583791.382326] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1144c0000 for ICM.
[583791.383408] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114500000 for ICM.
[583791.384493] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114540000 for ICM.
[583791.385577] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114580000 for ICM.
[583791.386659] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1145c0000 for ICM.
[583791.387742] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114600000 for ICM.
[583791.388824] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114640000 for ICM.
[583791.389909] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114680000 for ICM.
[583791.390992] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1146c0000 for ICM.
[583791.392076] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114700000 for ICM.
[583791.393159] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114740000 for ICM.
[583791.394243] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
114780000 for ICM.
[583791.395325] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at
1147c0000 for ICM.
[583791.905303] mlx4_core 0000:03:00.0: irq 59 for MSI/MSI-X
[583791.905313] mlx4_core 0000:03:00.0: irq 60 for MSI/MSI-X
[583791.905319] mlx4_core 0000:03:00.0: irq 61 for MSI/MSI-X
[583791.905327] mlx4_core 0000:03:00.0: irq 62 for MSI/MSI-X
[583791.905333] mlx4_core 0000:03:00.0: irq 63 for MSI/MSI-X
[583791.905340] mlx4_core 0000:03:00.0: irq 64 for MSI/MSI-X
[583791.905346] mlx4_core 0000:03:00.0: irq 65 for MSI/MSI-X
[583791.905354] mlx4_core 0000:03:00.0: irq 66 for MSI/MSI-X
[583791.905360] mlx4_core 0000:03:00.0: irq 67 for MSI/MSI-X
[583791.905366] mlx4_core 0000:03:00.0: irq 68 for MSI/MSI-X
[583791.905373] mlx4_core 0000:03:00.0: irq 69 for MSI/MSI-X
[583791.905379] mlx4_core 0000:03:00.0: irq 70 for MSI/MSI-X
[583791.905386] mlx4_core 0000:03:00.0: irq 71 for MSI/MSI-X
[583791.970917] mlx4_core 0000:03:00.0: NOP command IRQ test passed
[583791.971212] mlx4_core 0000:03:00.0: command 0xc failed: fw status = 0x40



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
