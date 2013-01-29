From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual
 functions in virtual machine
Date: Tue, 29 Jan 2013 14:15:28 +0100
Message-ID: <CAOoYFkE6YNfEJGJqGmpQTdSxR2Y_9pzkdcnHf_7jjqq57B_Nsw@mail.gmail.com>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
	<CAOoYFkGe=kKDDKvhOdRVCXQbGfV52q38dz6cYTpQXmFGOsBwsg@mail.gmail.com>
	<CAOoYFkFVvK+1YNJ_N6r0N_3ZMF6P9Q+0dbsDg4v8=3JfDPVOOA@mail.gmail.com>
	<201301281835.18533.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201301281835.18533.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I try to map the first virtual function with guest O/S. I understand
(in your mail) that all virtual functions (which are maped to a guest
O/S) must be probed. I didn't know it, that's why I tried with both
situations.

In fact, one boxe wasn't check in IOMMU submenu (Support for Interrupt
Remapping (EXPERIMENTAL)). I've recompiled the kernel of the host and
guest (is it necessary for this last one ?). But the error message is
already present. Just below, new dmeg log from host and guest O/S
(mlx4_core loaded with options num_vfs=1 probe_vf=1 debug_level=1 on
host and debug_level=1 on guest) :

[ 7061.889083] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
[ 7061.889085] mlx4_core: Initializing 0000:05:00.0
[ 7061.889317] mlx4_core 0000:05:00.0: Enabling SR-IOV with 1 VFs
[ 7061.989979] pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600
[ 7061.990728] mlx4_core 0000:05:00.0: Running in master mode
[ 7062.993002] mlx4_core 0000:05:00.0: FW version 2.9.1200 (cmd intf
rev 3), max commands 16
[ 7062.993005] mlx4_core 0000:05:00.0: Catastrophic error buffer at
0x1f020, size 0x10, BAR 0
[ 7062.993006] mlx4_core 0000:05:00.0: Communication vector bar:2 offset:0x800
[ 7062.993008] mlx4_core 0000:05:00.0: FW size 385 KB
[ 7062.993009] mlx4_core 0000:05:00.0: Clear int @ f0058, BAR 0
[ 7062.994914] mlx4_core 0000:05:00.0: Mapped 26 chunks/6168 KB for FW.
[ 7063.662759] mlx4_core 0000:05:00.0: BlueFlame available (reg size
512, regs/page 8)
[ 7063.662941] mlx4_core 0000:05:00.0: Base MM extensions: flags
00000cc0, rsvd L_Key 00000500
[ 7063.662942] mlx4_core 0000:05:00.0: Max ICM size 4294967296 MB
[ 7063.662944] mlx4_core 0000:05:00.0: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 7063.662946] mlx4_core 0000:05:00.0: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 7063.662947] mlx4_core 0000:05:00.0: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 7063.662949] mlx4_core 0000:05:00.0: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 7063.662950] mlx4_core 0000:05:00.0: reserved MPTs: 16, reserved MTTs: 16
[ 7063.662952] mlx4_core 0000:05:00.0: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 7063.662953] mlx4_core 0000:05:00.0: Max QP/MCG: 131072, reserved MGMs: 0
[ 7063.662955] mlx4_core 0000:05:00.0: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 7063.662957] mlx4_core 0000:05:00.0: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 3
[ 7063.662958] mlx4_core 0000:05:00.0: Max SQ desc size: 1008, max SQ S/G: 62
[ 7063.662959] mlx4_core 0000:05:00.0: Max RQ desc size: 512, max RQ S/G: 32
[ 7063.662961] mlx4_core 0000:05:00.0: Max GSO size: 131072
[ 7063.662962] mlx4_core 0000:05:00.0: Max counters: 256
[ 7063.662963] mlx4_core 0000:05:00.0: Max RSS Table size: 256
[ 7063.662965] mlx4_core 0000:05:00.0: DEV_CAP flags:
[ 7063.662966] mlx4_core 0000:05:00.0:     RC transport
[ 7063.662967] mlx4_core 0000:05:00.0:     UC transport
[ 7063.662968] mlx4_core 0000:05:00.0:     UD transport
[ 7063.662970] mlx4_core 0000:05:00.0:     XRC transport
[ 7063.662971] mlx4_core 0000:05:00.0:     FCoIB support
[ 7063.662973] mlx4_core 0000:05:00.0:     SRQ support
[ 7063.662974] mlx4_core 0000:05:00.0:     IPoIB checksum offload
[ 7063.662975] mlx4_core 0000:05:00.0:     P_Key violation counter
[ 7063.662977] mlx4_core 0000:05:00.0:     Q_Key violation counter
[ 7063.662978] mlx4_core 0000:05:00.0:     DPDP
[ 7063.662979] mlx4_core 0000:05:00.0:     Big LSO headers
[ 7063.662980] mlx4_core 0000:05:00.0:     APM support
[ 7063.662982] mlx4_core 0000:05:00.0:     Atomic ops support
[ 7063.662983] mlx4_core 0000:05:00.0:     Address vector port checking support
[ 7063.662984] mlx4_core 0000:05:00.0:     UD multicast support
[ 7063.662986] mlx4_core 0000:05:00.0:     Router support
[ 7063.662987] mlx4_core 0000:05:00.0:     IBoE support
[ 7063.662988] mlx4_core 0000:05:00.0:     Unicast loopback support
[ 7063.662989] mlx4_core 0000:05:00.0:     UDP RSS support
[ 7063.662991] mlx4_core 0000:05:00.0:     Unicast VEP steering support
[ 7063.662992] mlx4_core 0000:05:00.0:     Multicast VEP steering support
[ 7063.662993] mlx4_core 0000:05:00.0:     Counters support
[ 7063.662995] mlx4_core 0000:05:00.0:     RSS support
[ 7063.662996] mlx4_core 0000:05:00.0:     RSS Toeplitz Hash Function support
[ 7063.662997] mlx4_core 0000:05:00.0:     RSS XOR Hash Function support
[ 7063.663000] mlx4_core 0000:05:00.0: Steering mode is: B0 steering,
oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
[ 7063.663006] mlx4_core 0000:05:00.0:   profile[ 0] (  CMPT): 2^26
entries @ 0x         0, size 0x 100000000
[ 7063.663008] mlx4_core 0000:05:00.0:   profile[ 1] (RDMARC): 2^22
entries @ 0x 100000000, size 0x   8000000
[ 7063.663010] mlx4_core 0000:05:00.0:   profile[ 2] (   MTT): 2^24
entries @ 0x 108000000, size 0x   8000000
[ 7063.663012] mlx4_core 0000:05:00.0:   profile[ 3] (    QP): 2^18
entries @ 0x 110000000, size 0x   4000000
[ 7063.663014] mlx4_core 0000:05:00.0:   profile[ 4] (  DMPT): 2^19
entries @ 0x 114000000, size 0x   2000000
[ 7063.663015] mlx4_core 0000:05:00.0:   profile[ 5] (  ALTC): 2^18
entries @ 0x 116000000, size 0x   1000000
[ 7063.663017] mlx4_core 0000:05:00.0:   profile[ 6] (   SRQ): 2^16
entries @ 0x 117000000, size 0x    800000
[ 7063.663019] mlx4_core 0000:05:00.0:   profile[ 7] (    CQ): 2^16
entries @ 0x 117800000, size 0x    800000
[ 7063.663021] mlx4_core 0000:05:00.0:   profile[ 8] (   MCG): 2^13
entries @ 0x 118000000, size 0x    800000
[ 7063.663023] mlx4_core 0000:05:00.0:   profile[ 9] (  AUXC): 2^18
entries @ 0x 118800000, size 0x     40000
[ 7063.663025] mlx4_core 0000:05:00.0:   profile[10] (    EQ): 2^10
entries @ 0x 118840000, size 0x     20000
[ 7063.663026] mlx4_core 0000:05:00.0: HCA context memory: reserving 4596096 KB
[ 7063.663044] mlx4_core 0000:05:00.0: 4596096 KB of HCA context
requires 9068 KB aux memory.
[ 7063.692455] mlx4_core 0000:05:00.0: Mapped 39 chunks/9068 KB for ICM aux.
[ 7063.693778] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
[ 7063.695078] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
40000000 for ICM.
[ 7063.696378] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
80000000 for ICM.
[ 7063.696715] mlx4_core 0000:05:00.0: Mapped 1 chunks/64 KB at
c0000000 for ICM.
[ 7063.697362] mlx4_core 0000:05:00.0: Mapped 1 chunks/128 KB at
118840000 for ICM.
[ 7063.698641] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
108000000 for ICM.
[ 7063.699963] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
114000000 for ICM.
[ 7063.701248] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
110000000 for ICM.
[ 7063.702536] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118800000 for ICM.
[ 7063.703817] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
116000000 for ICM.
[ 7063.705099] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
100000000 for ICM.
[ 7063.706378] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
117800000 for ICM.
[ 7063.707656] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
117000000 for ICM.
[ 7063.708941] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118000000 for ICM.
[ 7063.710220] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118040000 for ICM.
[ 7063.711507] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118080000 for ICM.
[ 7063.712796] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1180c0000 for ICM.
[ 7063.714073] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118100000 for ICM.
[ 7063.715350] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118140000 for ICM.
[ 7063.716628] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118180000 for ICM.
[ 7063.717907] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1181c0000 for ICM.
[ 7063.719194] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118200000 for ICM.
[ 7063.720473] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118240000 for ICM.
[ 7063.721751] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118280000 for ICM.
[ 7063.723041] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1182c0000 for ICM.
[ 7063.724321] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118300000 for ICM.
[ 7063.725599] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118340000 for ICM.
[ 7063.726883] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118380000 for ICM.
[ 7063.728168] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1183c0000 for ICM.
[ 7063.729456] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118400000 for ICM.
[ 7063.730741] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118440000 for ICM.
[ 7063.732025] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118480000 for ICM.
[ 7063.733322] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1184c0000 for ICM.
[ 7063.734601] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118500000 for ICM.
[ 7063.735879] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118540000 for ICM.
[ 7063.737165] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118580000 for ICM.
[ 7063.738441] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1185c0000 for ICM.
[ 7063.739721] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118600000 for ICM.
[ 7063.741005] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118640000 for ICM.
[ 7063.742290] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118680000 for ICM.
[ 7063.743579] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1186c0000 for ICM.
[ 7063.744863] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118700000 for ICM.
[ 7063.746147] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118740000 for ICM.
[ 7063.747424] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118780000 for ICM.
[ 7063.748702] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1187c0000 for ICM.
[ 7064.308524] mlx4_core 0000:05:00.0: Started init_resource_tracker: 80 slaves
[ 7064.309007] mlx4_core 0000:05:00.0: irq 176 for MSI/MSI-X
[ 7064.309019] mlx4_core 0000:05:00.0: irq 177 for MSI/MSI-X
[ 7064.314858] mlx4_core 0000:05:00.0: NOP command IRQ test passed
[ 7064.315674] mlx4_core: Initializing 0000:82:00.0
[ 7064.315774] mlx4_core 0000:82:00.0: Enabling SR-IOV with 1 VFs
[ 7064.416589] pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
[ 7064.417304] mlx4_core 0000:82:00.0: Running in master mode
[ 7065.419026] mlx4_core 0000:82:00.0: FW version 2.11.500 (cmd intf
rev 3), max commands 16
[ 7065.419028] mlx4_core 0000:82:00.0: Catastrophic error buffer at
0x1f020, size 0x10, BAR 0
[ 7065.419030] mlx4_core 0000:82:00.0: Communication vector bar:2 offset:0x800
[ 7065.419032] mlx4_core 0000:82:00.0: FW size 385 KB
[ 7065.419033] mlx4_core 0000:82:00.0: Clear int @ f0058, BAR 0
[ 7065.420332] mlx4_core 0000:82:00.0: Mapped 26 chunks/6168 KB for FW.
[ 7068.086064] mlx4_core 0000:82:00.0: BlueFlame available (reg size
512, regs/page 8)
[ 7068.086196] mlx4_core 0000:82:00.0: Base MM extensions: flags
00104cc0, rsvd L_Key 00008000
[ 7068.086198] mlx4_core 0000:82:00.0: Max ICM size 4294967296 MB
[ 7068.086199] mlx4_core 0000:82:00.0: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 7068.086201] mlx4_core 0000:82:00.0: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 7068.086203] mlx4_core 0000:82:00.0: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 7068.086204] mlx4_core 0000:82:00.0: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 7068.086206] mlx4_core 0000:82:00.0: reserved MPTs: 256, reserved MTTs: 32
[ 7068.086208] mlx4_core 0000:82:00.0: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 7068.086209] mlx4_core 0000:82:00.0: Max QP/MCG: 131072, reserved MGMs: 0
[ 7068.086211] mlx4_core 0000:82:00.0: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 7068.086213] mlx4_core 0000:82:00.0: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 2
[ 7068.086214] mlx4_core 0000:82:00.0: Max SQ desc size: 1008, max SQ S/G: 62
[ 7068.086215] mlx4_core 0000:82:00.0: Max RQ desc size: 512, max RQ S/G: 32
[ 7068.086217] mlx4_core 0000:82:00.0: Max GSO size: 131072
[ 7068.086218] mlx4_core 0000:82:00.0: Max counters: 256
[ 7068.086219] mlx4_core 0000:82:00.0: Max RSS Table size: 256
[ 7068.086221] mlx4_core 0000:82:00.0: DEV_CAP flags:
[ 7068.086222] mlx4_core 0000:82:00.0:     RC transport
[ 7068.086223] mlx4_core 0000:82:00.0:     UC transport
[ 7068.086224] mlx4_core 0000:82:00.0:     UD transport
[ 7068.086226] mlx4_core 0000:82:00.0:     XRC transport
[ 7068.086227] mlx4_core 0000:82:00.0:     FCoIB support
[ 7068.086228] mlx4_core 0000:82:00.0:     SRQ support
[ 7068.086229] mlx4_core 0000:82:00.0:     IPoIB checksum offload
[ 7068.086231] mlx4_core 0000:82:00.0:     P_Key violation counter
[ 7068.086232] mlx4_core 0000:82:00.0:     Q_Key violation counter
[ 7068.086233] mlx4_core 0000:82:00.0:     DPDP
[ 7068.086235] mlx4_core 0000:82:00.0:     Big LSO headers
[ 7068.086236] mlx4_core 0000:82:00.0:     APM support
[ 7068.086237] mlx4_core 0000:82:00.0:     Atomic ops support
[ 7068.086238] mlx4_core 0000:82:00.0:     Address vector port checking support
[ 7068.086240] mlx4_core 0000:82:00.0:     UD multicast support
[ 7068.086241] mlx4_core 0000:82:00.0:     Router support
[ 7068.086242] mlx4_core 0000:82:00.0:     IBoE support
[ 7068.086244] mlx4_core 0000:82:00.0:     Unicast loopback support
[ 7068.086245] mlx4_core 0000:82:00.0:     FCS header control
[ 7068.086246] mlx4_core 0000:82:00.0:     UDP RSS support
[ 7068.086247] mlx4_core 0000:82:00.0:     Unicast VEP steering support
[ 7068.086249] mlx4_core 0000:82:00.0:     Multicast VEP steering support
[ 7068.086250] mlx4_core 0000:82:00.0:     Counters support
[ 7068.086252] mlx4_core 0000:82:00.0:     Port management change event support
[ 7068.086253] mlx4_core 0000:82:00.0:     64 byte EQE support
[ 7068.086254] mlx4_core 0000:82:00.0:     64 byte CQE support
[ 7068.086256] mlx4_core 0000:82:00.0:     RSS support
[ 7068.086257] mlx4_core 0000:82:00.0:     RSS Toeplitz Hash Function support
[ 7068.086258] mlx4_core 0000:82:00.0:     RSS XOR Hash Function support
[ 7068.086260] mlx4_core 0000:82:00.0:     Device manage flow steering support
[ 7068.086263] mlx4_core 0000:82:00.0: 64B EQEs/CQEs supported by the
device but not enabled
[ 7068.086266] mlx4_core 0000:82:00.0: Steering mode is: B0 steering,
oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
[ 7068.086271] mlx4_core 0000:82:00.0:   profile[ 0] (  CMPT): 2^26
entries @ 0x         0, size 0x 100000000
[ 7068.086273] mlx4_core 0000:82:00.0:   profile[ 1] (RDMARC): 2^22
entries @ 0x 100000000, size 0x   8000000
[ 7068.086275] mlx4_core 0000:82:00.0:   profile[ 2] (   MTT): 2^24
entries @ 0x 108000000, size 0x   8000000
[ 7068.086277] mlx4_core 0000:82:00.0:   profile[ 3] (    QP): 2^18
entries @ 0x 110000000, size 0x   4000000
[ 7068.086279] mlx4_core 0000:82:00.0:   profile[ 4] (  DMPT): 2^19
entries @ 0x 114000000, size 0x   2000000
[ 7068.086281] mlx4_core 0000:82:00.0:   profile[ 5] (  ALTC): 2^18
entries @ 0x 116000000, size 0x   1000000
[ 7068.086283] mlx4_core 0000:82:00.0:   profile[ 6] (   SRQ): 2^16
entries @ 0x 117000000, size 0x    800000
[ 7068.086285] mlx4_core 0000:82:00.0:   profile[ 7] (    CQ): 2^16
entries @ 0x 117800000, size 0x    800000
[ 7068.086286] mlx4_core 0000:82:00.0:   profile[ 8] (   MCG): 2^13
entries @ 0x 118000000, size 0x    800000
[ 7068.086288] mlx4_core 0000:82:00.0:   profile[ 9] (  AUXC): 2^18
entries @ 0x 118800000, size 0x     40000
[ 7068.086290] mlx4_core 0000:82:00.0:   profile[10] (    EQ): 2^10
entries @ 0x 118840000, size 0x     20000
[ 7068.086292] mlx4_core 0000:82:00.0: HCA context memory: reserving 4596096 KB
[ 7068.086309] mlx4_core 0000:82:00.0: 4596096 KB of HCA context
requires 9068 KB aux memory.
[ 7068.122796] mlx4_core 0000:82:00.0: Mapped 39 chunks/9068 KB for ICM aux.
[ 7068.124193] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
[ 7068.125561] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
40000000 for ICM.
[ 7068.126936] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
80000000 for ICM.
[ 7068.127289] mlx4_core 0000:82:00.0: Mapped 1 chunks/64 KB at
c0000000 for ICM.
[ 7068.127981] mlx4_core 0000:82:00.0: Mapped 1 chunks/128 KB at
118840000 for ICM.
[ 7068.129333] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
108000000 for ICM.
[ 7068.130740] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
114000000 for ICM.
[ 7068.132097] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
110000000 for ICM.
[ 7068.133457] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118800000 for ICM.
[ 7068.134819] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
116000000 for ICM.
[ 7068.136195] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
100000000 for ICM.
[ 7068.137547] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
117800000 for ICM.
[ 7068.138927] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
117000000 for ICM.
[ 7068.140292] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118000000 for ICM.
[ 7068.141659] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118040000 for ICM.
[ 7068.143009] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118080000 for ICM.
[ 7068.144369] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1180c0000 for ICM.
[ 7068.145725] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118100000 for ICM.
[ 7068.147083] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118140000 for ICM.
[ 7068.148431] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118180000 for ICM.
[ 7068.149801] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1181c0000 for ICM.
[ 7068.151179] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118200000 for ICM.
[ 7068.152538] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118240000 for ICM.
[ 7068.153901] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118280000 for ICM.
[ 7068.155277] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1182c0000 for ICM.
[ 7068.156626] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118300000 for ICM.
[ 7068.157985] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118340000 for ICM.
[ 7068.159323] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118380000 for ICM.
[ 7068.160691] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1183c0000 for ICM.
[ 7068.162058] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118400000 for ICM.
[ 7068.163416] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118440000 for ICM.
[ 7068.164775] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118480000 for ICM.
[ 7068.166152] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1184c0000 for ICM.
[ 7068.167510] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118500000 for ICM.
[ 7068.168873] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118540000 for ICM.
[ 7068.170236] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118580000 for ICM.
[ 7068.171594] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1185c0000 for ICM.
[ 7068.172959] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118600000 for ICM.
[ 7068.174297] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118640000 for ICM.
[ 7068.175657] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118680000 for ICM.
[ 7068.177028] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1186c0000 for ICM.
[ 7068.178382] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118700000 for ICM.
[ 7068.179745] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118740000 for ICM.
[ 7068.181102] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118780000 for ICM.
[ 7068.182455] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1187c0000 for ICM.
[ 7068.762473] mlx4_core 0000:82:00.0: Started init_resource_tracker: 80 slaves
[ 7068.762941] mlx4_core 0000:82:00.0: irq 178 for MSI/MSI-X
[ 7068.762951] mlx4_core 0000:82:00.0: irq 179 for MSI/MSI-X
[ 7068.769218] mlx4_core 0000:82:00.0: NOP command IRQ test passed
[ 7068.769774] mlx4_core: Initializing 0000:05:00.1
[ 7068.769786] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
[ 7068.769823] mlx4_core 0000:05:00.1: Detected virtual function -
running in slave mode
[ 7068.769913] mlx4_core 0000:05:00.1: Sending reset
[ 7068.770021] mlx4_core 0000:05:00.0: Received reset from slave:1
[ 7068.770033] mlx4_core 0000:05:00.1: Sending vhcr0
[ 7068.770391] mlx4_core 0000:05:00.1: BlueFlame not available
[ 7068.770681] mlx4_core 0000:05:00.1: Base MM extensions: flags
00000cc0, rsvd L_Key 00000500
[ 7068.770685] mlx4_core 0000:05:00.1: Max ICM size 4294967296 MB
[ 7068.770686] mlx4_core 0000:05:00.1: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 7068.770688] mlx4_core 0000:05:00.1: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 7068.770690] mlx4_core 0000:05:00.1: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 7068.770691] mlx4_core 0000:05:00.1: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 7068.770693] mlx4_core 0000:05:00.1: reserved MPTs: 16, reserved MTTs: 16
[ 7068.770694] mlx4_core 0000:05:00.1: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 7068.770696] mlx4_core 0000:05:00.1: Max QP/MCG: 131072, reserved MGMs: 0
[ 7068.770697] mlx4_core 0000:05:00.1: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 7068.770699] mlx4_core 0000:05:00.1: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 3
[ 7068.770700] mlx4_core 0000:05:00.1: Max SQ desc size: 1008, max SQ S/G: 62
[ 7068.770702] mlx4_core 0000:05:00.1: Max RQ desc size: 512, max RQ S/G: 32
[ 7068.770703] mlx4_core 0000:05:00.1: Max GSO size: 131072
[ 7068.770704] mlx4_core 0000:05:00.1: Max counters: 256
[ 7068.770706] mlx4_core 0000:05:00.1: Max RSS Table size: 256
[ 7068.770707] mlx4_core 0000:05:00.1: DEV_CAP flags:
[ 7068.770708] mlx4_core 0000:05:00.1:     RC transport
[ 7068.770709] mlx4_core 0000:05:00.1:     UC transport
[ 7068.770711] mlx4_core 0000:05:00.1:     UD transport
[ 7068.770712] mlx4_core 0000:05:00.1:     XRC transport
[ 7068.770713] mlx4_core 0000:05:00.1:     FCoIB support
[ 7068.770714] mlx4_core 0000:05:00.1:     SRQ support
[ 7068.770716] mlx4_core 0000:05:00.1:     IPoIB checksum offload
[ 7068.770717] mlx4_core 0000:05:00.1:     P_Key violation counter
[ 7068.770718] mlx4_core 0000:05:00.1:     Q_Key violation counter
[ 7068.770719] mlx4_core 0000:05:00.1:     DPDP
[ 7068.770721] mlx4_core 0000:05:00.1:     Big LSO headers
[ 7068.770722] mlx4_core 0000:05:00.1:     APM support
[ 7068.770723] mlx4_core 0000:05:00.1:     Atomic ops support
[ 7068.770724] mlx4_core 0000:05:00.1:     Address vector port checking support
[ 7068.770726] mlx4_core 0000:05:00.1:     UD multicast support
[ 7068.770727] mlx4_core 0000:05:00.1:     Router support
[ 7068.770728] mlx4_core 0000:05:00.1:     IBoE support
[ 7068.770729] mlx4_core 0000:05:00.1:     Unicast loopback support
[ 7068.770731] mlx4_core 0000:05:00.1:     UDP RSS support
[ 7068.770732] mlx4_core 0000:05:00.1:     Unicast VEP steering support
[ 7068.770733] mlx4_core 0000:05:00.1:     Multicast VEP steering support
[ 7068.770735] mlx4_core 0000:05:00.1:     Counters support
[ 7068.770736] mlx4_core 0000:05:00.1:     Port management change event support
[ 7068.770737] mlx4_core 0000:05:00.1:     RSS support
[ 7068.770739] mlx4_core 0000:05:00.1:     RSS Toeplitz Hash Function support
[ 7068.770740] mlx4_core 0000:05:00.1:     RSS XOR Hash Function support
[ 7068.770856] mlx4_core 0000:05:00.1: HCA minimum page size:512
[ 7068.771367] mlx4_core 0000:05:00.1: Steering mode is: B0 steering
[ 7068.771369] mlx4_core 0000:05:00.1: Failed to map blue flame area
[ 7068.771638] mlx4_core 0000:05:00.1: irq 180 for MSI/MSI-X
[ 7068.771650] mlx4_core 0000:05:00.1: irq 181 for MSI/MSI-X
[ 7068.777099] mlx4_core 0000:05:00.1: NOP command IRQ test passed
[ 7068.777122] mlx4_core: Initializing 0000:82:00.1
[ 7068.777133] mlx4_core 0000:82:00.1: enabling device (0000 -> 0002)
[ 7068.777174] mlx4_core 0000:82:00.1: Detected virtual function -
running in slave mode
[ 7068.777297] mlx4_core 0000:82:00.1: Sending reset
[ 7068.777362] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 7068.777372] mlx4_core 0000:82:00.1: Sending vhcr0
[ 7068.777707] mlx4_core 0000:82:00.1: BlueFlame not available
[ 7068.777869] mlx4_core 0000:82:00.1: Base MM extensions: flags
00104cc0, rsvd L_Key 00008000
[ 7068.777870] mlx4_core 0000:82:00.1: Max ICM size 4294967296 MB
[ 7068.777872] mlx4_core 0000:82:00.1: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 7068.777874] mlx4_core 0000:82:00.1: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 7068.777875] mlx4_core 0000:82:00.1: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 7068.777877] mlx4_core 0000:82:00.1: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 7068.777879] mlx4_core 0000:82:00.1: reserved MPTs: 256, reserved MTTs: 32
[ 7068.777880] mlx4_core 0000:82:00.1: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 7068.777882] mlx4_core 0000:82:00.1: Max QP/MCG: 131072, reserved MGMs: 0
[ 7068.777883] mlx4_core 0000:82:00.1: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 7068.777885] mlx4_core 0000:82:00.1: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 2
[ 7068.777887] mlx4_core 0000:82:00.1: Max SQ desc size: 1008, max SQ S/G: 62
[ 7068.777888] mlx4_core 0000:82:00.1: Max RQ desc size: 512, max RQ S/G: 32
[ 7068.777889] mlx4_core 0000:82:00.1: Max GSO size: 131072
[ 7068.777891] mlx4_core 0000:82:00.1: Max counters: 256
[ 7068.777892] mlx4_core 0000:82:00.1: Max RSS Table size: 256
[ 7068.777893] mlx4_core 0000:82:00.1: DEV_CAP flags:
[ 7068.777895] mlx4_core 0000:82:00.1:     RC transport
[ 7068.777896] mlx4_core 0000:82:00.1:     UC transport
[ 7068.777897] mlx4_core 0000:82:00.1:     UD transport
[ 7068.777898] mlx4_core 0000:82:00.1:     XRC transport
[ 7068.777899] mlx4_core 0000:82:00.1:     FCoIB support
[ 7068.777901] mlx4_core 0000:82:00.1:     SRQ support
[ 7068.777902] mlx4_core 0000:82:00.1:     IPoIB checksum offload
[ 7068.777903] mlx4_core 0000:82:00.1:     P_Key violation counter
[ 7068.777904] mlx4_core 0000:82:00.1:     Q_Key violation counter
[ 7068.777906] mlx4_core 0000:82:00.1:     DPDP
[ 7068.777907] mlx4_core 0000:82:00.1:     Big LSO headers
[ 7068.777908] mlx4_core 0000:82:00.1:     APM support
[ 7068.777909] mlx4_core 0000:82:00.1:     Atomic ops support
[ 7068.777911] mlx4_core 0000:82:00.1:     Address vector port checking support
[ 7068.777912] mlx4_core 0000:82:00.1:     UD multicast support
[ 7068.777913] mlx4_core 0000:82:00.1:     Router support
[ 7068.777915] mlx4_core 0000:82:00.1:     IBoE support
[ 7068.777916] mlx4_core 0000:82:00.1:     Unicast loopback support
[ 7068.777917] mlx4_core 0000:82:00.1:     FCS header control
[ 7068.777918] mlx4_core 0000:82:00.1:     UDP RSS support
[ 7068.777920] mlx4_core 0000:82:00.1:     Unicast VEP steering support
[ 7068.777921] mlx4_core 0000:82:00.1:     Multicast VEP steering support
[ 7068.777922] mlx4_core 0000:82:00.1:     Counters support
[ 7068.777924] mlx4_core 0000:82:00.1:     Port management change event support
[ 7068.777925] mlx4_core 0000:82:00.1:     64 byte EQE support
[ 7068.777926] mlx4_core 0000:82:00.1:     64 byte CQE support
[ 7068.777928] mlx4_core 0000:82:00.1:     RSS support
[ 7068.777929] mlx4_core 0000:82:00.1:     RSS Toeplitz Hash Function support
[ 7068.777930] mlx4_core 0000:82:00.1:     RSS XOR Hash Function support
[ 7068.777932] mlx4_core 0000:82:00.1:     Device manage flow steering support
[ 7068.777933] mlx4_core 0000:82:00.1: 64B EQEs/CQEs supported by the
device but not enabled
[ 7068.778041] mlx4_core 0000:82:00.1: HCA minimum page size:512
[ 7068.778342] mlx4_core 0000:82:00.1: Steering mode is: B0 steering
[ 7068.778343] mlx4_core 0000:82:00.1: Failed to map blue flame area
[ 7068.778631] mlx4_core 0000:82:00.1: irq 182 for MSI/MSI-X
[ 7068.778642] mlx4_core 0000:82:00.1: irq 183 for MSI/MSI-X
[ 7068.784770] mlx4_core 0000:82:00.1: NOP command IRQ test passed
[ 7267.277498] RPC: Registered named UNIX socket transport module.
[ 7267.277500] RPC: Registered udp transport module.
[ 7267.277501] RPC: Registered tcp transport module.
[ 7267.277502] RPC: Registered tcp NFSv4.1 backchannel transport module.
[ 7267.521859] Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
[ 7267.579717] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[ 7267.580043] NFSD: starting 90-second grace period (net ffffffff81ab1c40)
[ 7560.813405] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 7560.813663] pci-stub 0000:82:00.1: claimed by stub
[ 7560.819403] pci-stub 0000:82:00.1: enabling device (0000 -> 0002)
[ 7560.821843] mlx4_core 0000:82:00.0: FLR event for slave: 1
[ 7560.821890] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
[ 7560.821893] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
[ 7560.923233] assign device 0:82:0.1
[ 7560.925757] mlx4_core 0000:82:00.0: FLR event for slave: 1
[ 7560.925768] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
[ 7560.925770] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
[ 7561.046117] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 7561.060850] pci-stub 0000:82:00.1: irq 182 for MSI/MSI-X
[ 7561.083880] pci-stub 0000:82:00.1: irq 182 for MSI/MSI-X
[ 7561.083895] pci-stub 0000:82:00.1: irq 183 for MSI/MSI-X
[ 7571.189144] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 7618.874766] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 7618.888390] pci-stub 0000:82:00.1: irq 182 for MSI/MSI-X
[ 7618.909284] pci-stub 0000:82:00.1: irq 182 for MSI/MSI-X
[ 7618.909308] pci-stub 0000:82:00.1: irq 183 for MSI/MSI-X
[ 7629.014979] mlx4_core 0000:82:00.0: Received reset from slave:1


mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
mlx4_core: Initializing 0000:00:08.0
mlx4_core 0000:00:08.0: Detected virtual function - running in slave mode
mlx4_core 0000:00:08.0: Sending reset
mlx4_core 0000:00:08.0: Sending vhcr0
mlx4_core 0000:00:08.0: BlueFlame not available
mlx4_core 0000:00:08.0: Base MM extensions: flags 00104cc0, rsvd L_Key 00008000
mlx4_core 0000:00:08.0: Max ICM size 4294967296 MB
mlx4_core 0000:00:08.0: Max QPs: 16777216, reserved QPs: 64, entry size: 256
mlx4_core 0000:00:08.0: Max SRQs: 16777216, reserved SRQs: 64, entry size: 128
mlx4_core 0000:00:08.0: Max CQs: 16777216, reserved CQs: 128, entry size: 128
mlx4_core 0000:00:08.0: Max EQs: 32, reserved EQs: 28, entry size: 128
mlx4_core 0000:00:08.0: reserved MPTs: 256, reserved MTTs: 32
mlx4_core 0000:00:08.0: Max PDs: 131072, reserved PDs: 4, reserved UARs: 7
mlx4_core 0000:00:08.0: Max QP/MCG: 131072, reserved MGMs: 0
mlx4_core 0000:00:08.0: Max CQEs: 4194304, max WQEs: 16384, max SRQ WQEs: 16384
mlx4_core 0000:00:08.0: Local CA ACK delay: 15, max MTU: 4096, port width cap: 2
mlx4_core 0000:00:08.0: Max SQ desc size: 1008, max SQ S/G: 62
mlx4_core 0000:00:08.0: Max RQ desc size: 512, max RQ S/G: 32
mlx4_core 0000:00:08.0: Max GSO size: 131072
mlx4_core 0000:00:08.0: Max counters: 256
mlx4_core 0000:00:08.0: Max RSS Table size: 256
mlx4_core 0000:00:08.0: DEV_CAP flags:
mlx4_core 0000:00:08.0:     RC transport
mlx4_core 0000:00:08.0:     UC transport
mlx4_core 0000:00:08.0:     UD transport
mlx4_core 0000:00:08.0:     XRC transport
mlx4_core 0000:00:08.0:     FCoIB support
mlx4_core 0000:00:08.0:     SRQ support
mlx4_core 0000:00:08.0:     IPoIB checksum offload
mlx4_core 0000:00:08.0:     P_Key violation counter
mlx4_core 0000:00:08.0:     Q_Key violation counter
mlx4_core 0000:00:08.0:     DPDP
mlx4_core 0000:00:08.0:     Big LSO headers
mlx4_core 0000:00:08.0:     APM support
mlx4_core 0000:00:08.0:     Atomic ops support
mlx4_core 0000:00:08.0:     Address vector port checking support
mlx4_core 0000:00:08.0:     UD multicast support
mlx4_core 0000:00:08.0:     Router support
mlx4_core 0000:00:08.0:     IBoE support
mlx4_core 0000:00:08.0:     Unicast loopback support
mlx4_core 0000:00:08.0:     FCS header control
mlx4_core 0000:00:08.0:     UDP RSS support
mlx4_core 0000:00:08.0:     Unicast VEP steering support
mlx4_core 0000:00:08.0:     Multicast VEP steering support
mlx4_core 0000:00:08.0:     Counters support
mlx4_core 0000:00:08.0:     Port management change event support
mlx4_core 0000:00:08.0:     64 byte EQE support
mlx4_core 0000:00:08.0:     64 byte CQE support
mlx4_core 0000:00:08.0:     RSS support
mlx4_core 0000:00:08.0:     RSS Toeplitz Hash Function support
mlx4_core 0000:00:08.0:     RSS XOR Hash Function support
mlx4_core 0000:00:08.0:     Device manage flow steering support
mlx4_core 0000:00:08.0: 64B EQEs/CQEs supported by the device but not enabled
mlx4_core 0000:00:08.0: HCA minimum page size:512
mlx4_core 0000:00:08.0: Steering mode is: B0 steering
mlx4_core 0000:00:08.0: Failed to map blue flame area
mlx4_core 0000:00:08.0: irq 48 for MSI/MSI-X
mlx4_core 0000:00:08.0: irq 49 for MSI/MSI-X
mlx4_core 0000:00:08.0: failed execution of VHCR_POST commandopcode 0x31
mlx4_core 0000:00:08.0: NOP command failed to generate MSI-X interrupt IRQ 49).
mlx4_core 0000:00:08.0: Trying again without MSI-X.
mlx4_core: probe of 0000:00:08.0 failed with error -16

Mathis

2013/1/28 Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
> Which VF did you map to the guest O/S?
> In your configuration, both HCAs will have the PF and the
> first VF running on the hypervisor,
> and the remaining VFs available for binding to guests.
>
> You have:
> mlx4_core 0000:05:00.0: Enabling SR-IOV with 3 VFs <== PF
> pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600 <== VFs
> pci 0000:05:00.2: [15b3:1002] type 00 class 0x0c0600
> pci 0000:05:00.3: [15b3:1002] type 00 class 0x0c0600
>
> 05:00.0 and 05:00.1 run on the hypervisor, and 05:00.2/3 are
> available for binding to guests.
>
> Similarly,
> mlx4_core 0000:82:00.0: Enabling SR-IOV with 3 VFs
> pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
> pci 0000:82:00.2: [15b3:1004] type 00 class 0x028000
> pci 0000:82:00.3: [15b3:1004] type 00 class 0x028000
>
> 82:00.0 and 82:00.1 run on the hypervisor, and 82:00.2/3 are
> available for binding to guests.
>
> The "skipping" messages you see for 2/3 indicate that these
> are not yet bound, and the hypervisor is not claiming them
> (this arises from setting probe_vf=1 --> only ONE guest is
> claimed/bound by the Hypervisor).
>
> I don't see any "received reset from xxx" lines in the dumps
> below, which would indicate that the hypervisor received a
> reset request from a guest O/S bound to one of the available VFs.
>
> This looks to me like a kernel configuration problem.
>
> You did not mention what CPU you are using.
> Did you do the following when building your kernel?
>         make menuconfig (stuff below is shown for kernel 3.7. I don't know if it
>                          changed in 3.8)
>         Then, under "Device Drivers", put an '*' by "IOMMU hardware support" and
>         go into that submenu.
>         Make sure to check ALL the boxes which apply for your CPU in the IOMMU submenu.
>
> For Intel, at least, you should also add "intel_iommu=on" to the line for your kernel
> in file /boot/grub/menu.lst
>
> -Jack
>
> On Monday 28 January 2013 10:29, Mathis GAVILLON wrote:
>> The version of firmware I gave you was wrong (I've two cards
>> (ConnectX2 and ConnectX3, I only use ConnectX 3) in my computer and I
>> took the bad one). The firmware installed on my ConnectX3 Infiniband
>> Card is 2.11.500.
>> KVM is 1.2.2-1 version.
>> I tried to load the driver with options you gave me but the error
>> message is the same. Nothing else happen.
>>
>> Here is the dmesg command return from host (mlx4_core loaded with
>> options debug_level=1, num_vfs=3, probe_vf=1) :
>>
>> [root@barb0 ~]# dmesg
>> [65182.838953] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
>> [65182.838955] mlx4_core: Initializing 0000:05:00.0
>> [65182.839144] mlx4_core 0000:05:00.0: Enabling SR-IOV with 3 VFs
>> [65182.940316] pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600
>> [65182.941105] pci 0000:05:00.2: [15b3:1002] type 00 class 0x0c0600
>> [65182.941876] pci 0000:05:00.3: [15b3:1002] type 00 class 0x0c0600
>> [65182.942585] mlx4_core 0000:05:00.0: Running in master mode
>> [65183.945306] mlx4_core 0000:05:00.0: FW version 2.9.1200 (cmd intf
>> rev 3), max commands 16
>> [65183.945309] mlx4_core 0000:05:00.0: Catastrophic error buffer at
>> 0x1f020, size 0x10, BAR 0
>> [65183.945311] mlx4_core 0000:05:00.0: Communication vector bar:2 offset:0x800
>> [65183.945312] mlx4_core 0000:05:00.0: FW size 385 KB
>> [65183.945313] mlx4_core 0000:05:00.0: Clear int @ f0058, BAR 0
>> [65183.947177] mlx4_core 0000:05:00.0: Mapped 26 chunks/6168 KB for FW.
>> [65184.614576] mlx4_core 0000:05:00.0: BlueFlame available (reg size
>> 512, regs/page 8)
>> [65184.614742] mlx4_core 0000:05:00.0: Base MM extensions: flags
>> 00000cc0, rsvd L_Key 00000500
>> [65184.614743] mlx4_core 0000:05:00.0: Max ICM size 4294967296 MB
>> [65184.614745] mlx4_core 0000:05:00.0: Max QPs: 16777216, reserved
>> QPs: 64, entry size: 256
>> [65184.614747] mlx4_core 0000:05:00.0: Max SRQs: 16777216, reserved
>> SRQs: 64, entry size: 128
>> [65184.614748] mlx4_core 0000:05:00.0: Max CQs: 16777216, reserved
>> CQs: 128, entry size: 128
>> [65184.614750] mlx4_core 0000:05:00.0: Max EQs: 32, reserved EQs: 28,
>> entry size: 128
>> [65184.614751] mlx4_core 0000:05:00.0: reserved MPTs: 16, reserved MTTs: 16
>> [65184.614753] mlx4_core 0000:05:00.0: Max PDs: 131072, reserved PDs:
>> 4, reserved UARs: 7
>> [65184.614754] mlx4_core 0000:05:00.0: Max QP/MCG: 131072, reserved MGMs: 0
>> [65184.614756] mlx4_core 0000:05:00.0: Max CQEs: 4194304, max WQEs:
>> 16384, max SRQ WQEs: 16384
>> [65184.614758] mlx4_core 0000:05:00.0: Local CA ACK delay: 15, max
>> MTU: 4096, port width cap: 3
>> [65184.614759] mlx4_core 0000:05:00.0: Max SQ desc size: 1008, max SQ S/G: 62
>> [65184.614760] mlx4_core 0000:05:00.0: Max RQ desc size: 512, max RQ S/G: 32
>> [65184.614762] mlx4_core 0000:05:00.0: Max GSO size: 131072
>> [65184.614763] mlx4_core 0000:05:00.0: Max counters: 256
>> [65184.614764] mlx4_core 0000:05:00.0: Max RSS Table size: 256
>> [65184.614766] mlx4_core 0000:05:00.0: DEV_CAP flags:
>> [65184.614767] mlx4_core 0000:05:00.0:     RC transport
>> [65184.614768] mlx4_core 0000:05:00.0:     UC transport
>> [65184.614769] mlx4_core 0000:05:00.0:     UD transport
>> [65184.614771] mlx4_core 0000:05:00.0:     XRC transport
>> [65184.614772] mlx4_core 0000:05:00.0:     FCoIB support
>> [65184.614773] mlx4_core 0000:05:00.0:     SRQ support
>> [65184.614774] mlx4_core 0000:05:00.0:     IPoIB checksum offload
>> [65184.614775] mlx4_core 0000:05:00.0:     P_Key violation counter
>> [65184.614777] mlx4_core 0000:05:00.0:     Q_Key violation counter
>> [65184.614778] mlx4_core 0000:05:00.0:     DPDP
>> [65184.614779] mlx4_core 0000:05:00.0:     Big LSO headers
>> [65184.614780] mlx4_core 0000:05:00.0:     APM support
>> [65184.614782] mlx4_core 0000:05:00.0:     Atomic ops support
>> [65184.614783] mlx4_core 0000:05:00.0:     Address vector port checking support
>> [65184.614784] mlx4_core 0000:05:00.0:     UD multicast support
>> [65184.614785] mlx4_core 0000:05:00.0:     Router support
>> [65184.614787] mlx4_core 0000:05:00.0:     IBoE support
>> [65184.614788] mlx4_core 0000:05:00.0:     Unicast loopback support
>> [65184.614789] mlx4_core 0000:05:00.0:     UDP RSS support
>> [65184.614790] mlx4_core 0000:05:00.0:     Unicast VEP steering support
>> [65184.614792] mlx4_core 0000:05:00.0:     Multicast VEP steering support
>> [65184.614793] mlx4_core 0000:05:00.0:     Counters support
>> [65184.614795] mlx4_core 0000:05:00.0:     RSS support
>> [65184.614796] mlx4_core 0000:05:00.0:     RSS Toeplitz Hash Function support
>> [65184.614797] mlx4_core 0000:05:00.0:     RSS XOR Hash Function support
>> [65184.614800] mlx4_core 0000:05:00.0: Steering mode is: B0 steering,
>> oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
>> [65184.614807] mlx4_core 0000:05:00.0:   profile[ 0] (  CMPT): 2^26
>> entries @ 0x         0, size 0x 100000000
>> [65184.614809] mlx4_core 0000:05:00.0:   profile[ 1] (RDMARC): 2^22
>> entries @ 0x 100000000, size 0x   8000000
>> [65184.614811] mlx4_core 0000:05:00.0:   profile[ 2] (   MTT): 2^24
>> entries @ 0x 108000000, size 0x   8000000
>> [65184.614813] mlx4_core 0000:05:00.0:   profile[ 3] (    QP): 2^18
>> entries @ 0x 110000000, size 0x   4000000
>> [65184.614815] mlx4_core 0000:05:00.0:   profile[ 4] (  DMPT): 2^19
>> entries @ 0x 114000000, size 0x   2000000
>> [65184.614816] mlx4_core 0000:05:00.0:   profile[ 5] (  ALTC): 2^18
>> entries @ 0x 116000000, size 0x   1000000
>> [65184.614818] mlx4_core 0000:05:00.0:   profile[ 6] (   SRQ): 2^16
>> entries @ 0x 117000000, size 0x    800000
>> [65184.614820] mlx4_core 0000:05:00.0:   profile[ 7] (    CQ): 2^16
>> entries @ 0x 117800000, size 0x    800000
>> [65184.614822] mlx4_core 0000:05:00.0:   profile[ 8] (   MCG): 2^13
>> entries @ 0x 118000000, size 0x    800000
>> [65184.614824] mlx4_core 0000:05:00.0:   profile[ 9] (  AUXC): 2^18
>> entries @ 0x 118800000, size 0x     40000
>> [65184.614826] mlx4_core 0000:05:00.0:   profile[10] (    EQ): 2^10
>> entries @ 0x 118840000, size 0x     20000
>> [65184.614827] mlx4_core 0000:05:00.0: HCA context memory: reserving 4596096 KB
>> [65184.614844] mlx4_core 0000:05:00.0: 4596096 KB of HCA context
>> requires 9068 KB aux memory.
>> [65184.644227] mlx4_core 0000:05:00.0: Mapped 39 chunks/9068 KB for ICM aux.
>> [65184.645547] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
>> [65184.646846] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 40000000 for ICM.
>> [65184.648146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 80000000 for ICM.
>> [65184.648483] mlx4_core 0000:05:00.0: Mapped 1 chunks/64 KB at
>> c0000000 for ICM.
>> [65184.649133] mlx4_core 0000:05:00.0: Mapped 1 chunks/128 KB at
>> 118840000 for ICM.
>> [65184.650413] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 108000000 for ICM.
>> [65184.651737] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 114000000 for ICM.
>> [65184.653016] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 110000000 for ICM.
>> [65184.654304] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118800000 for ICM.
>> [65184.655585] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 116000000 for ICM.
>> [65184.656866] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 100000000 for ICM.
>> [65184.658146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 117800000 for ICM.
>> [65184.659426] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 117000000 for ICM.
>> [65184.660705] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118000000 for ICM.
>> [65184.661986] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118040000 for ICM.
>> [65184.663265] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118080000 for ICM.
>> [65184.664550] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1180c0000 for ICM.
>> [65184.665839] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118100000 for ICM.
>> [65184.667117] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118140000 for ICM.
>> [65184.668395] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118180000 for ICM.
>> [65184.669675] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1181c0000 for ICM.
>> [65184.670955] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118200000 for ICM.
>> [65184.672234] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118240000 for ICM.
>> [65184.673511] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118280000 for ICM.
>> [65184.674794] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1182c0000 for ICM.
>> [65184.676070] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118300000 for ICM.
>> [65184.677351] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118340000 for ICM.
>> [65184.678629] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118380000 for ICM.
>> [65184.679906] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1183c0000 for ICM.
>> [65184.681185] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118400000 for ICM.
>> [65184.682463] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118440000 for ICM.
>> [65184.683742] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118480000 for ICM.
>> [65184.685028] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1184c0000 for ICM.
>> [65184.686306] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118500000 for ICM.
>> [65184.687583] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118540000 for ICM.
>> [65184.688869] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118580000 for ICM.
>> [65184.690148] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1185c0000 for ICM.
>> [65184.691428] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118600000 for ICM.
>> [65184.692706] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118640000 for ICM.
>> [65184.693984] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118680000 for ICM.
>> [65184.695268] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1186c0000 for ICM.
>> [65184.696546] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118700000 for ICM.
>> [65184.697825] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118740000 for ICM.
>> [65184.699103] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 118780000 for ICM.
>> [65184.700380] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 1187c0000 for ICM.
>> [65185.202376] mlx4_core 0000:05:00.0: Started init_resource_tracker: 80 slaves
>> [65185.202819] mlx4_core 0000:05:00.0: irq 176 for MSI/MSI-X
>> [65185.202826] mlx4_core 0000:05:00.0: irq 177 for MSI/MSI-X
>> [65185.207838] mlx4_core 0000:05:00.0: NOP command IRQ test passed
>> [65185.208638] mlx4_core: Initializing 0000:82:00.0
>> [65185.208742] mlx4_core 0000:82:00.0: Enabling SR-IOV with 3 VFs
>> [65185.309000] pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
>> [65185.309781] pci 0000:82:00.2: [15b3:1004] type 00 class 0x028000
>> [65185.310507] pci 0000:82:00.3: [15b3:1004] type 00 class 0x028000
>> [65185.311176] mlx4_core 0000:82:00.0: Running in master mode
>> [65186.312479] mlx4_core 0000:82:00.0: FW version 2.11.500 (cmd intf
>> rev 3), max commands 16
>> [65186.312482] mlx4_core 0000:82:00.0: Catastrophic error buffer at
>> 0x1f020, size 0x10, BAR 0
>> [65186.312484] mlx4_core 0000:82:00.0: Communication vector bar:2 offset:0x800
>> [65186.312485] mlx4_core 0000:82:00.0: FW size 385 KB
>> [65186.312486] mlx4_core 0000:82:00.0: Clear int @ f0058, BAR 0
>> [65186.313785] mlx4_core 0000:82:00.0: Mapped 26 chunks/6168 KB for FW.
>> [65188.980410] mlx4_core 0000:82:00.0: BlueFlame available (reg size
>> 512, regs/page 8)
>> [65188.980535] mlx4_core 0000:82:00.0: Base MM extensions: flags
>> 00104cc0, rsvd L_Key 00008000
>> [65188.980536] mlx4_core 0000:82:00.0: Max ICM size 4294967296 MB
>> [65188.980538] mlx4_core 0000:82:00.0: Max QPs: 16777216, reserved
>> QPs: 64, entry size: 256
>> [65188.980540] mlx4_core 0000:82:00.0: Max SRQs: 16777216, reserved
>> SRQs: 64, entry size: 128
>> [65188.980541] mlx4_core 0000:82:00.0: Max CQs: 16777216, reserved
>> CQs: 128, entry size: 128
>> [65188.980543] mlx4_core 0000:82:00.0: Max EQs: 32, reserved EQs: 28,
>> entry size: 128
>> [65188.980544] mlx4_core 0000:82:00.0: reserved MPTs: 256, reserved MTTs: 32
>> [65188.980546] mlx4_core 0000:82:00.0: Max PDs: 131072, reserved PDs:
>> 4, reserved UARs: 7
>> [65188.980548] mlx4_core 0000:82:00.0: Max QP/MCG: 131072, reserved MGMs: 0
>> [65188.980549] mlx4_core 0000:82:00.0: Max CQEs: 4194304, max WQEs:
>> 16384, max SRQ WQEs: 16384
>> [65188.980551] mlx4_core 0000:82:00.0: Local CA ACK delay: 15, max
>> MTU: 4096, port width cap: 2
>> [65188.980552] mlx4_core 0000:82:00.0: Max SQ desc size: 1008, max SQ S/G: 62
>> [65188.980554] mlx4_core 0000:82:00.0: Max RQ desc size: 512, max RQ S/G: 32
>> [65188.980555] mlx4_core 0000:82:00.0: Max GSO size: 131072
>> [65188.980556] mlx4_core 0000:82:00.0: Max counters: 256
>> [65188.980558] mlx4_core 0000:82:00.0: Max RSS Table size: 256
>> [65188.980559] mlx4_core 0000:82:00.0: DEV_CAP flags:
>> [65188.980560] mlx4_core 0000:82:00.0:     RC transport
>> [65188.980561] mlx4_core 0000:82:00.0:     UC transport
>> [65188.980563] mlx4_core 0000:82:00.0:     UD transport
>> [65188.980564] mlx4_core 0000:82:00.0:     XRC transport
>> [65188.980565] mlx4_core 0000:82:00.0:     FCoIB support
>> [65188.980566] mlx4_core 0000:82:00.0:     SRQ support
>> [65188.980568] mlx4_core 0000:82:00.0:     IPoIB checksum offload
>> [65188.980569] mlx4_core 0000:82:00.0:     P_Key violation counter
>> [65188.980570] mlx4_core 0000:82:00.0:     Q_Key violation counter
>> [65188.980571] mlx4_core 0000:82:00.0:     DPDP
>> [65188.980573] mlx4_core 0000:82:00.0:     Big LSO headers
>> [65188.980574] mlx4_core 0000:82:00.0:     APM support
>> [65188.980575] mlx4_core 0000:82:00.0:     Atomic ops support
>> [65188.980576] mlx4_core 0000:82:00.0:     Address vector port checking support
>> [65188.980578] mlx4_core 0000:82:00.0:     UD multicast support
>> [65188.980579] mlx4_core 0000:82:00.0:     Router support
>> [65188.980580] mlx4_core 0000:82:00.0:     IBoE support
>> [65188.980582] mlx4_core 0000:82:00.0:     Unicast loopback support
>> [65188.980583] mlx4_core 0000:82:00.0:     FCS header control
>> [65188.980584] mlx4_core 0000:82:00.0:     UDP RSS support
>> [65188.980586] mlx4_core 0000:82:00.0:     Unicast VEP steering support
>> [65188.980587] mlx4_core 0000:82:00.0:     Multicast VEP steering support
>> [65188.980588] mlx4_core 0000:82:00.0:     Counters support
>> [65188.980589] mlx4_core 0000:82:00.0:     Port management change event support
>> [65188.980591] mlx4_core 0000:82:00.0:     64 byte EQE support
>> [65188.980592] mlx4_core 0000:82:00.0:     64 byte CQE support
>> [65188.980593] mlx4_core 0000:82:00.0:     RSS support
>> [65188.980595] mlx4_core 0000:82:00.0:     RSS Toeplitz Hash Function support
>> [65188.980596] mlx4_core 0000:82:00.0:     RSS XOR Hash Function support
>> [65188.980597] mlx4_core 0000:82:00.0:     Device manage flow steering support
>> [65188.980599] mlx4_core 0000:82:00.0: 64B EQEs/CQEs supported by the
>> device but not enabled
>> [65188.980602] mlx4_core 0000:82:00.0: Steering mode is: B0 steering,
>> oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
>> [65188.980609] mlx4_core 0000:82:00.0:   profile[ 0] (  CMPT): 2^26
>> entries @ 0x         0, size 0x 100000000
>> [65188.980611] mlx4_core 0000:82:00.0:   profile[ 1] (RDMARC): 2^22
>> entries @ 0x 100000000, size 0x   8000000
>> [65188.980613] mlx4_core 0000:82:00.0:   profile[ 2] (   MTT): 2^24
>> entries @ 0x 108000000, size 0x   8000000
>> [65188.980615] mlx4_core 0000:82:00.0:   profile[ 3] (    QP): 2^18
>> entries @ 0x 110000000, size 0x   4000000
>> [65188.980616] mlx4_core 0000:82:00.0:   profile[ 4] (  DMPT): 2^19
>> entries @ 0x 114000000, size 0x   2000000
>> [65188.980618] mlx4_core 0000:82:00.0:   profile[ 5] (  ALTC): 2^18
>> entries @ 0x 116000000, size 0x   1000000
>> [65188.980620] mlx4_core 0000:82:00.0:   profile[ 6] (   SRQ): 2^16
>> entries @ 0x 117000000, size 0x    800000
>> [65188.980622] mlx4_core 0000:82:00.0:   profile[ 7] (    CQ): 2^16
>> entries @ 0x 117800000, size 0x    800000
>> [65188.980624] mlx4_core 0000:82:00.0:   profile[ 8] (   MCG): 2^13
>> entries @ 0x 118000000, size 0x    800000
>> [65188.980625] mlx4_core 0000:82:00.0:   profile[ 9] (  AUXC): 2^18
>> entries @ 0x 118800000, size 0x     40000
>> [65188.980627] mlx4_core 0000:82:00.0:   profile[10] (    EQ): 2^10
>> entries @ 0x 118840000, size 0x     20000
>> [65188.980629] mlx4_core 0000:82:00.0: HCA context memory: reserving 4596096 KB
>> [65188.980645] mlx4_core 0000:82:00.0: 4596096 KB of HCA context
>> requires 9068 KB aux memory.
>> [65189.017150] mlx4_core 0000:82:00.0: Mapped 39 chunks/9068 KB for ICM aux.
>> [65189.018533] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
>> [65189.019895] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 40000000 for ICM.
>> [65189.021266] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 80000000 for ICM.
>> [65189.021621] mlx4_core 0000:82:00.0: Mapped 1 chunks/64 KB at
>> c0000000 for ICM.
>> [65189.022303] mlx4_core 0000:82:00.0: Mapped 1 chunks/128 KB at
>> 118840000 for ICM.
>> [65189.023671] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 108000000 for ICM.
>> [65189.025060] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 114000000 for ICM.
>> [65189.026419] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 110000000 for ICM.
>> [65189.027778] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118800000 for ICM.
>> [65189.029123] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 116000000 for ICM.
>> [65189.030477] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 100000000 for ICM.
>> [65189.031834] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 117800000 for ICM.
>> [65189.033197] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 117000000 for ICM.
>> [65189.034559] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118000000 for ICM.
>> [65189.035906] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118040000 for ICM.
>> [65189.037254] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118080000 for ICM.
>> [65189.038633] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1180c0000 for ICM.
>> [65189.039991] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118100000 for ICM.
>> [65189.041349] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118140000 for ICM.
>> [65189.042700] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118180000 for ICM.
>> [65189.044050] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1181c0000 for ICM.
>> [65189.045409] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118200000 for ICM.
>> [65189.046758] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118240000 for ICM.
>> [65189.048098] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118280000 for ICM.
>> [65189.049466] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1182c0000 for ICM.
>> [65189.050813] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118300000 for ICM.
>> [65189.052169] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118340000 for ICM.
>> [65189.053521] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118380000 for ICM.
>> [65189.054862] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1183c0000 for ICM.
>> [65189.056218] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118400000 for ICM.
>> [65189.057563] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118440000 for ICM.
>> [65189.058913] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118480000 for ICM.
>> [65189.060272] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1184c0000 for ICM.
>> [65189.061616] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118500000 for ICM.
>> [65189.062971] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118540000 for ICM.
>> [65189.064314] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118580000 for ICM.
>> [65189.065669] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1185c0000 for ICM.
>> [65189.067011] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118600000 for ICM.
>> [65189.068364] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118640000 for ICM.
>> [65189.069728] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118680000 for ICM.
>> [65189.071086] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1186c0000 for ICM.
>> [65189.072438] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118700000 for ICM.
>> [65189.073788] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118740000 for ICM.
>> [65189.075145] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 118780000 for ICM.
>> [65189.076503] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 1187c0000 for ICM.
>> [65189.643406] mlx4_core 0000:82:00.0: Started init_resource_tracker: 80 slaves
>> [65189.643891] mlx4_core 0000:82:00.0: irq 178 for MSI/MSI-X
>> [65189.643899] mlx4_core 0000:82:00.0: irq 179 for MSI/MSI-X
>> [65189.650122] mlx4_core 0000:82:00.0: NOP command IRQ test passed
>> [65189.650652] mlx4_core: Initializing 0000:05:00.1
>> [65189.650667] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
>> [65189.650709] mlx4_core 0000:05:00.1: Detected virtual function -
>> running in slave mode
>> [65189.650792] mlx4_core 0000:05:00.1: Sending reset
>> [65189.650847] mlx4_core 0000:05:00.0: Received reset from slave:1
>> [65189.650859] mlx4_core 0000:05:00.1: Sending vhcr0
>> [65189.651166] mlx4_core 0000:05:00.1: BlueFlame not available
>> [65189.651412] mlx4_core 0000:05:00.1: Base MM extensions: flags
>> 00000cc0, rsvd L_Key 00000500
>> [65189.651414] mlx4_core 0000:05:00.1: Max ICM size 4294967296 MB
>> [65189.651417] mlx4_core 0000:05:00.1: Max QPs: 16777216, reserved
>> QPs: 64, entry size: 256
>> [65189.651419] mlx4_core 0000:05:00.1: Max SRQs: 16777216, reserved
>> SRQs: 64, entry size: 128
>> [65189.651421] mlx4_core 0000:05:00.1: Max CQs: 16777216, reserved
>> CQs: 128, entry size: 128
>> [65189.651422] mlx4_core 0000:05:00.1: Max EQs: 32, reserved EQs: 28,
>> entry size: 128
>> [65189.651424] mlx4_core 0000:05:00.1: reserved MPTs: 16, reserved MTTs: 16
>> [65189.651425] mlx4_core 0000:05:00.1: Max PDs: 131072, reserved PDs:
>> 4, reserved UARs: 7
>> [65189.651427] mlx4_core 0000:05:00.1: Max QP/MCG: 131072, reserved MGMs: 0
>> [65189.651428] mlx4_core 0000:05:00.1: Max CQEs: 4194304, max WQEs:
>> 16384, max SRQ WQEs: 16384
>> [65189.651430] mlx4_core 0000:05:00.1: Local CA ACK delay: 15, max
>> MTU: 4096, port width cap: 3
>> [65189.651431] mlx4_core 0000:05:00.1: Max SQ desc size: 1008, max SQ S/G: 62
>> [65189.651433] mlx4_core 0000:05:00.1: Max RQ desc size: 512, max RQ S/G: 32
>> [65189.651434] mlx4_core 0000:05:00.1: Max GSO size: 131072
>> [65189.651436] mlx4_core 0000:05:00.1: Max counters: 256
>> [65189.651437] mlx4_core 0000:05:00.1: Max RSS Table size: 256
>> [65189.651438] mlx4_core 0000:05:00.1: DEV_CAP flags:
>> [65189.651440] mlx4_core 0000:05:00.1:     RC transport
>> [65189.651441] mlx4_core 0000:05:00.1:     UC transport
>> [65189.651442] mlx4_core 0000:05:00.1:     UD transport
>> [65189.651443] mlx4_core 0000:05:00.1:     XRC transport
>> [65189.651444] mlx4_core 0000:05:00.1:     FCoIB support
>> [65189.651446] mlx4_core 0000:05:00.1:     SRQ support
>> [65189.651447] mlx4_core 0000:05:00.1:     IPoIB checksum offload
>> [65189.651448] mlx4_core 0000:05:00.1:     P_Key violation counter
>> [65189.651449] mlx4_core 0000:05:00.1:     Q_Key violation counter
>> [65189.651451] mlx4_core 0000:05:00.1:     DPDP
>> [65189.651452] mlx4_core 0000:05:00.1:     Big LSO headers
>> [65189.651453] mlx4_core 0000:05:00.1:     APM support
>> [65189.651454] mlx4_core 0000:05:00.1:     Atomic ops support
>> [65189.651456] mlx4_core 0000:05:00.1:     Address vector port checking support
>> [65189.651457] mlx4_core 0000:05:00.1:     UD multicast support
>> [65189.651458] mlx4_core 0000:05:00.1:     Router support
>> [65189.651459] mlx4_core 0000:05:00.1:     IBoE support
>> [65189.651461] mlx4_core 0000:05:00.1:     Unicast loopback support
>> [65189.651462] mlx4_core 0000:05:00.1:     UDP RSS support
>> [65189.651463] mlx4_core 0000:05:00.1:     Unicast VEP steering support
>> [65189.651465] mlx4_core 0000:05:00.1:     Multicast VEP steering support
>> [65189.651466] mlx4_core 0000:05:00.1:     Counters support
>> [65189.651467] mlx4_core 0000:05:00.1:     Port management change event support
>> [65189.651469] mlx4_core 0000:05:00.1:     RSS support
>> [65189.651470] mlx4_core 0000:05:00.1:     RSS Toeplitz Hash Function support
>> [65189.651471] mlx4_core 0000:05:00.1:     RSS XOR Hash Function support
>> [65189.651567] mlx4_core 0000:05:00.1: HCA minimum page size:512
>> [65189.652182] mlx4_core 0000:05:00.1: Steering mode is: B0 steering
>> [65189.652184] mlx4_core 0000:05:00.1: Failed to map blue flame area
>> [65189.652438] mlx4_core 0000:05:00.1: irq 180 for MSI/MSI-X
>> [65189.652446] mlx4_core 0000:05:00.1: irq 181 for MSI/MSI-X
>> [65189.657770] mlx4_core 0000:05:00.1: NOP command IRQ test passed
>> [65189.657791] mlx4_core: Initializing 0000:05:00.2
>> [65189.657801] mlx4_core 0000:05:00.2: enabling device (0000 -> 0002)
>> [65189.657836] mlx4_core 0000:05:00.2: Skipping virtual function:2
>> [65189.657856] mlx4_core: Initializing 0000:05:00.3
>> [65189.657865] mlx4_core 0000:05:00.3: enabling device (0000 -> 0002)
>> [65189.657887] mlx4_core 0000:05:00.3: Skipping virtual function:3
>> [65189.657904] mlx4_core: Initializing 0000:82:00.1
>> [65189.657914] mlx4_core 0000:82:00.1: enabling device (0000 -> 0002)
>> [65189.657940] mlx4_core 0000:82:00.1: Detected virtual function -
>> running in slave mode
>> [65189.658047] mlx4_core 0000:82:00.1: Sending reset
>> [65189.658128] mlx4_core 0000:82:00.0: Received reset from slave:1
>> [65189.658137] mlx4_core 0000:82:00.1: Sending vhcr0
>> [65189.658463] mlx4_core 0000:82:00.1: BlueFlame not available
>> [65189.658646] mlx4_core 0000:82:00.1: Base MM extensions: flags
>> 00104cc0, rsvd L_Key 00008000
>> [65189.658650] mlx4_core 0000:82:00.1: Max ICM size 4294967296 MB
>> [65189.658653] mlx4_core 0000:82:00.1: Max QPs: 16777216, reserved
>> QPs: 64, entry size: 256
>> [65189.658655] mlx4_core 0000:82:00.1: Max SRQs: 16777216, reserved
>> SRQs: 64, entry size: 128
>> [65189.658657] mlx4_core 0000:82:00.1: Max CQs: 16777216, reserved
>> CQs: 128, entry size: 128
>> [65189.658658] mlx4_core 0000:82:00.1: Max EQs: 32, reserved EQs: 28,
>> entry size: 128
>> [65189.658660] mlx4_core 0000:82:00.1: reserved MPTs: 256, reserved MTTs: 32
>> [65189.658661] mlx4_core 0000:82:00.1: Max PDs: 131072, reserved PDs:
>> 4, reserved UARs: 7
>> [65189.658663] mlx4_core 0000:82:00.1: Max QP/MCG: 131072, reserved MGMs: 0
>> [65189.658664] mlx4_core 0000:82:00.1: Max CQEs: 4194304, max WQEs:
>> 16384, max SRQ WQEs: 16384
>> [65189.658666] mlx4_core 0000:82:00.1: Local CA ACK delay: 15, max
>> MTU: 4096, port width cap: 2
>> [65189.658667] mlx4_core 0000:82:00.1: Max SQ desc size: 1008, max SQ S/G: 62
>> [65189.658669] mlx4_core 0000:82:00.1: Max RQ desc size: 512, max RQ S/G: 32
>> [65189.658670] mlx4_core 0000:82:00.1: Max GSO size: 131072
>> [65189.658671] mlx4_core 0000:82:00.1: Max counters: 256
>> [65189.658673] mlx4_core 0000:82:00.1: Max RSS Table size: 256
>> [65189.658674] mlx4_core 0000:82:00.1: DEV_CAP flags:
>> [65189.658675] mlx4_core 0000:82:00.1:     RC transport
>> [65189.658676] mlx4_core 0000:82:00.1:     UC transport
>> [65189.658678] mlx4_core 0000:82:00.1:     UD transport
>> [65189.658679] mlx4_core 0000:82:00.1:     XRC transport
>> [65189.658680] mlx4_core 0000:82:00.1:     FCoIB support
>> [65189.658681] mlx4_core 0000:82:00.1:     SRQ support
>> [65189.658682] mlx4_core 0000:82:00.1:     IPoIB checksum offload
>> [65189.658684] mlx4_core 0000:82:00.1:     P_Key violation counter
>> [65189.658685] mlx4_core 0000:82:00.1:     Q_Key violation counter
>> [65189.658688] mlx4_core 0000:82:00.1:     DPDP
>> [65189.658691] mlx4_core 0000:82:00.1:     Big LSO headers
>> [65189.658695] mlx4_core 0000:82:00.1:     APM support
>> [65189.658699] mlx4_core 0000:82:00.1:     Atomic ops support
>> [65189.658702] mlx4_core 0000:82:00.1:     Address vector port checking support
>> [65189.658705] mlx4_core 0000:82:00.1:     UD multicast support
>> [65189.658707] mlx4_core 0000:82:00.1:     Router support
>> [65189.658708] mlx4_core 0000:82:00.1:     IBoE support
>> [65189.658709] mlx4_core 0000:82:00.1:     Unicast loopback support
>> [65189.658710] mlx4_core 0000:82:00.1:     FCS header control
>> [65189.658712] mlx4_core 0000:82:00.1:     UDP RSS support
>> [65189.658713] mlx4_core 0000:82:00.1:     Unicast VEP steering support
>> [65189.658714] mlx4_core 0000:82:00.1:     Multicast VEP steering support
>> [65189.658715] mlx4_core 0000:82:00.1:     Counters support
>> [65189.658717] mlx4_core 0000:82:00.1:     Port management change event support
>> [65189.658718] mlx4_core 0000:82:00.1:     64 byte EQE support
>> [65189.658719] mlx4_core 0000:82:00.1:     64 byte CQE support
>> [65189.658721] mlx4_core 0000:82:00.1:     RSS support
>> [65189.658722] mlx4_core 0000:82:00.1:     RSS Toeplitz Hash Function support
>> [65189.658723] mlx4_core 0000:82:00.1:     RSS XOR Hash Function support
>> [65189.658725] mlx4_core 0000:82:00.1:     Device manage flow steering support
>> [65189.658727] mlx4_core 0000:82:00.1: 64B EQEs/CQEs supported by the
>> device but not enabled
>> [65189.658863] mlx4_core 0000:82:00.1: HCA minimum page size:512
>> [65189.659129] mlx4_core 0000:82:00.1: Steering mode is: B0 steering
>> [65189.659130] mlx4_core 0000:82:00.1: Failed to map blue flame area
>> [65189.659417] mlx4_core 0000:82:00.1: irq 182 for MSI/MSI-X
>> [65189.659428] mlx4_core 0000:82:00.1: irq 183 for MSI/MSI-X
>> [65189.666007] mlx4_core 0000:82:00.1: NOP command IRQ test passed
>> [65189.666033] mlx4_core: Initializing 0000:82:00.2
>> [65189.666045] mlx4_core 0000:82:00.2: enabling device (0000 -> 0002)
>> [65189.666083] mlx4_core 0000:82:00.2: Skipping virtual function:2
>> [65189.666106] mlx4_core: Initializing 0000:82:00.3
>> [65189.666116] mlx4_core 0000:82:00.3: enabling device (0000 -> 0002)
>> [65189.666142] mlx4_core 0000:82:00.3: Skipping virtual function:3
>> [65189.690937] <mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX
>> InfiniBand driver v1.0 (April 4, 2008)
>> [65189.779306] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 110040000 for ICM.
>> [65189.780627] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 100080000 for ICM.
>> [65189.786286] mlx4_core 0000:05:00.0: mlx4_ib: multi-function enabled
>> [65189.788526] mlx4_core 0000:05:00.0: mlx4_ib: initializing demux
>> service for 80 qp1 clients
>> [65189.792146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
>> 100040000 for ICM.
>> [65189.793859] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
>> [65189.803736] IPv6: ADDRCONF(NETDEV_UP): ib1: link is not ready
>> [65189.862554] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 110040000 for ICM.
>> [65189.863888] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 100080000 for ICM.
>> [65189.864185] mlx4_core 0000:82:00.0: mlx4_ib: multi-function enabled
>> [65189.865217] mlx4_core 0000:82:00.0: mlx4_ib: initializing demux
>> service for 80 qp1 clients
>> [65189.868388] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
>> 100040000 for ICM.
>> [65189.875240] IPv6: ADDRCONF(NETDEV_UP): ib2: link is not ready
>> [65189.991130] mlx4_core 0000:05:00.1: mlx4_ib: multi-function enabled
>> [65189.991132] mlx4_core 0000:05:00.1: mlx4_ib: operating in qp1 tunnel mode
>> [65189.994633] IPv6: ADDRCONF(NETDEV_UP): ib3: link is not ready
>> [65190.005505] IPv6: ADDRCONF(NETDEV_UP): ib4: link is not ready
>> [65190.061269] mlx4_core 0000:82:00.1: mlx4_ib: multi-function enabled
>> [65190.061271] mlx4_core 0000:82:00.1: mlx4_ib: operating in qp1 tunnel mode
>> [65190.071641] IPv6: ADDRCONF(NETDEV_UP): ib5: link is not ready
>>
>> Here is dmesg command return of virtual machine (mlx4_core loaded with
>> options debug_level=1) :
>>
>> [root@welling0 ~]# dmesg
>> mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
>> mlx4_core: Initializing 0000:00:08.0
>> mlx4_core 0000:00:08.0: Detected virtual function - running in slave mode
>> mlx4_core 0000:00:08.0: Sending reset
>> mlx4_core 0000:00:08.0: Sending vhcr0
>> mlx4_core 0000:00:08.0: BlueFlame not available
>> mlx4_core 0000:00:08.0: Base MM extensions: flags 00104cc0, rsvd L_Key 00008000
>> mlx4_core 0000:00:08.0: Max ICM size 4294967296 MB
>> mlx4_core 0000:00:08.0: Max QPs: 16777216, reserved QPs: 64, entry size: 256
>> mlx4_core 0000:00:08.0: Max SRQs: 16777216, reserved SRQs: 64, entry size: 128
>> mlx4_core 0000:00:08.0: Max CQs: 16777216, reserved CQs: 128, entry size: 128
>> mlx4_core 0000:00:08.0: Max EQs: 32, reserved EQs: 28, entry size: 128
>> mlx4_core 0000:00:08.0: reserved MPTs: 256, reserved MTTs: 32
>> mlx4_core 0000:00:08.0: Max PDs: 131072, reserved PDs: 4, reserved UARs: 7
>> mlx4_core 0000:00:08.0: Max QP/MCG: 131072, reserved MGMs: 0
>> mlx4_core 0000:00:08.0: Max CQEs: 4194304, max WQEs: 16384, max SRQ WQEs: 16384
>> mlx4_core 0000:00:08.0: Local CA ACK delay: 15, max MTU: 4096, port width cap: 2
>> mlx4_core 0000:00:08.0: Max SQ desc size: 1008, max SQ S/G: 62
>> mlx4_core 0000:00:08.0: Max RQ desc size: 512, max RQ S/G: 32
>> mlx4_core 0000:00:08.0: Max GSO size: 131072
>> mlx4_core 0000:00:08.0: Max counters: 256
>> mlx4_core 0000:00:08.0: Max RSS Table size: 256
>> mlx4_core 0000:00:08.0: DEV_CAP flags:
>> mlx4_core 0000:00:08.0:     RC transport
>> mlx4_core 0000:00:08.0:     UC transport
>> mlx4_core 0000:00:08.0:     UD transport
>> mlx4_core 0000:00:08.0:     XRC transport
>> mlx4_core 0000:00:08.0:     FCoIB support
>> mlx4_core 0000:00:08.0:     SRQ support
>> mlx4_core 0000:00:08.0:     IPoIB checksum offload
>> mlx4_core 0000:00:08.0:     P_Key violation counter
>> mlx4_core 0000:00:08.0:     Q_Key violation counter
>> mlx4_core 0000:00:08.0:     DPDP
>> mlx4_core 0000:00:08.0:     Big LSO headers
>> mlx4_core 0000:00:08.0:     APM support
>> mlx4_core 0000:00:08.0:     Atomic ops support
>> mlx4_core 0000:00:08.0:     Address vector port checking support
>> mlx4_core 0000:00:08.0:     UD multicast support
>> mlx4_core 0000:00:08.0:     Router support
>> mlx4_core 0000:00:08.0:     IBoE support
>> mlx4_core 0000:00:08.0:     Unicast loopback support
>> mlx4_core 0000:00:08.0:     FCS header control
>> mlx4_core 0000:00:08.0:     UDP RSS support
>> mlx4_core 0000:00:08.0:     Unicast VEP steering support
>> mlx4_core 0000:00:08.0:     Multicast VEP steering support
>> mlx4_core 0000:00:08.0:     Counters support
>> mlx4_core 0000:00:08.0:     Port management change event support
>> mlx4_core 0000:00:08.0:     64 byte EQE support
>> mlx4_core 0000:00:08.0:     64 byte CQE support
>> mlx4_core 0000:00:08.0:     RSS support
>> mlx4_core 0000:00:08.0:     RSS Toeplitz Hash Function support
>> mlx4_core 0000:00:08.0:     RSS XOR Hash Function support
>> mlx4_core 0000:00:08.0:     Device manage flow steering support
>> mlx4_core 0000:00:08.0: 64B EQEs/CQEs supported by the device but not enabled
>> mlx4_core 0000:00:08.0: HCA minimum page size:512
>> mlx4_core 0000:00:08.0: Steering mode is: B0 steering
>> mlx4_core 0000:00:08.0: Failed to map blue flame area
>> mlx4_core 0000:00:08.0: irq 48 for MSI/MSI-X
>> mlx4_core 0000:00:08.0: irq 49 for MSI/MSI-X
>> mlx4_core 0000:00:08.0: failed execution of VHCR_POST commandopcode 0x31
>> mlx4_core 0000:00:08.0: NOP command failed to generate MSI-X interrupt IRQ 49).
>> mlx4_core 0000:00:08.0: Trying again without MSI-X.
>> mlx4_core: probe of 0000:00:08.0 failed with error -16
>>
>> Mathis
>>
>>
>> 2013/1/24 Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > ---------- Forwarded message ----------
>> > From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Date: 2013/1/24
>> > Subject: Re: Error message when trying to use Infiniband virtual
>> > functions in virtual machine
>> > To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Cc : linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> >
>> >
>> > On Wed, Jan 23, 2013 at 5:29 PM, Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> I'm working on a project in which I try to virtualize Infiniband. I use ConnectX3 Infiniband cards with FW 2.9.1200.
>> >> I've installed a Fedora 18 OS with 3.8.0rc2 recompiled kernel. I use KVM 1.2 to run virtual machines.
>> >
>> > Your firmware version is a bit old... if you can upgrade to the latest
>> > GA on the Mellanox site (2.11.0500) would be good,
>> >
>> > So what version of  qemu is installed on the distro you use? Are you
>> > able to work over a ConnectX VF if probed
>> > to the host? e.g use num_vfs=3 probe_vf=1 and see how the related mlx4
>> > device (e.g mlx4_1) is functioning.
>> >
>> > Also would be of help if you probe mlx4_core on both VM and host with
>> > debug_level=1
>> >
>> >
>> > Or.
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
