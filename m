From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual
 functions in virtual machine
Date: Tue, 29 Jan 2013 16:18:15 +0100
Message-ID: <CAOoYFkErXNxSBrQC_spMwcEiVmOpkzqQwuTQPOwO70bigsgYkQ@mail.gmail.com>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
	<201301281835.18533.jackm@dev.mellanox.co.il>
	<CAOoYFkE6YNfEJGJqGmpQTdSxR2Y_9pzkdcnHf_7jjqq57B_Nsw@mail.gmail.com>
	<201301291644.35771.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201301291644.35771.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support for interrupt remapping should be now available (kernel has
been recompiled with but is there any way to check if it's available
?).
I tried to do what you say in step 2 (num_vfs=1 and probe_vf=0) but it
doesn't change anything. I also tried num_vfs=2 and probe_vf=1 but
nothing is better.
Nevertheless, a strange information message appear in shell when I
boot my guest :

  Message from syslogd@localhost at Jan 29 15:51:49 ...
   kernel:Disabling IRQ #16

I put dmesg log from step 2 (host and guest) again :

[ 1419.382452] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
[ 1419.382454] mlx4_core: Initializing 0000:05:00.0
[ 1419.382653] mlx4_core 0000:05:00.0: Enabling SR-IOV with 1 VFs
[ 1419.483687] pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600
[ 1419.484427] mlx4_core 0000:05:00.0: Running in master mode
[ 1420.486608] mlx4_core 0000:05:00.0: FW version 2.9.1200 (cmd intf
rev 3), max commands 16
[ 1420.486610] mlx4_core 0000:05:00.0: Catastrophic error buffer at
0x1f020, size 0x10, BAR 0
[ 1420.486612] mlx4_core 0000:05:00.0: Communication vector bar:2 offset:0x800
[ 1420.486613] mlx4_core 0000:05:00.0: FW size 385 KB
[ 1420.486615] mlx4_core 0000:05:00.0: Clear int @ f0058, BAR 0
[ 1420.488474] mlx4_core 0000:05:00.0: Mapped 26 chunks/6168 KB for FW.
[ 1421.155871] mlx4_core 0000:05:00.0: BlueFlame available (reg size
512, regs/page 8)
[ 1421.156035] mlx4_core 0000:05:00.0: Base MM extensions: flags
00000cc0, rsvd L_Key 00000500
[ 1421.156036] mlx4_core 0000:05:00.0: Max ICM size 4294967296 MB
[ 1421.156038] mlx4_core 0000:05:00.0: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 1421.156040] mlx4_core 0000:05:00.0: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 1421.156041] mlx4_core 0000:05:00.0: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 1421.156043] mlx4_core 0000:05:00.0: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 1421.156045] mlx4_core 0000:05:00.0: reserved MPTs: 16, reserved MTTs: 16
[ 1421.156046] mlx4_core 0000:05:00.0: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 1421.156048] mlx4_core 0000:05:00.0: Max QP/MCG: 131072, reserved MGMs: 0
[ 1421.156049] mlx4_core 0000:05:00.0: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 1421.156051] mlx4_core 0000:05:00.0: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 3
[ 1421.156052] mlx4_core 0000:05:00.0: Max SQ desc size: 1008, max SQ S/G: 62
[ 1421.156054] mlx4_core 0000:05:00.0: Max RQ desc size: 512, max RQ S/G: 32
[ 1421.156055] mlx4_core 0000:05:00.0: Max GSO size: 131072
[ 1421.156056] mlx4_core 0000:05:00.0: Max counters: 256
[ 1421.156058] mlx4_core 0000:05:00.0: Max RSS Table size: 256
[ 1421.156059] mlx4_core 0000:05:00.0: DEV_CAP flags:
[ 1421.156060] mlx4_core 0000:05:00.0:     RC transport
[ 1421.156062] mlx4_core 0000:05:00.0:     UC transport
[ 1421.156063] mlx4_core 0000:05:00.0:     UD transport
[ 1421.156064] mlx4_core 0000:05:00.0:     XRC transport
[ 1421.156065] mlx4_core 0000:05:00.0:     FCoIB support
[ 1421.156066] mlx4_core 0000:05:00.0:     SRQ support
[ 1421.156068] mlx4_core 0000:05:00.0:     IPoIB checksum offload
[ 1421.156069] mlx4_core 0000:05:00.0:     P_Key violation counter
[ 1421.156070] mlx4_core 0000:05:00.0:     Q_Key violation counter
[ 1421.156071] mlx4_core 0000:05:00.0:     DPDP
[ 1421.156073] mlx4_core 0000:05:00.0:     Big LSO headers
[ 1421.156074] mlx4_core 0000:05:00.0:     APM support
[ 1421.156075] mlx4_core 0000:05:00.0:     Atomic ops support
[ 1421.156077] mlx4_core 0000:05:00.0:     Address vector port checking support
[ 1421.156078] mlx4_core 0000:05:00.0:     UD multicast support
[ 1421.156079] mlx4_core 0000:05:00.0:     Router support
[ 1421.156080] mlx4_core 0000:05:00.0:     IBoE support
[ 1421.156082] mlx4_core 0000:05:00.0:     Unicast loopback support
[ 1421.156083] mlx4_core 0000:05:00.0:     UDP RSS support
[ 1421.156084] mlx4_core 0000:05:00.0:     Unicast VEP steering support
[ 1421.156085] mlx4_core 0000:05:00.0:     Multicast VEP steering support
[ 1421.156087] mlx4_core 0000:05:00.0:     Counters support
[ 1421.156088] mlx4_core 0000:05:00.0:     RSS support
[ 1421.156090] mlx4_core 0000:05:00.0:     RSS Toeplitz Hash Function support
[ 1421.156091] mlx4_core 0000:05:00.0:     RSS XOR Hash Function support
[ 1421.156093] mlx4_core 0000:05:00.0: Steering mode is: B0 steering,
oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
[ 1421.156099] mlx4_core 0000:05:00.0:   profile[ 0] (  CMPT): 2^26
entries @ 0x         0, size 0x 100000000
[ 1421.156101] mlx4_core 0000:05:00.0:   profile[ 1] (RDMARC): 2^22
entries @ 0x 100000000, size 0x   8000000
[ 1421.156103] mlx4_core 0000:05:00.0:   profile[ 2] (   MTT): 2^24
entries @ 0x 108000000, size 0x   8000000
[ 1421.156105] mlx4_core 0000:05:00.0:   profile[ 3] (    QP): 2^18
entries @ 0x 110000000, size 0x   4000000
[ 1421.156107] mlx4_core 0000:05:00.0:   profile[ 4] (  DMPT): 2^19
entries @ 0x 114000000, size 0x   2000000
[ 1421.156109] mlx4_core 0000:05:00.0:   profile[ 5] (  ALTC): 2^18
entries @ 0x 116000000, size 0x   1000000
[ 1421.156111] mlx4_core 0000:05:00.0:   profile[ 6] (   SRQ): 2^16
entries @ 0x 117000000, size 0x    800000
[ 1421.156113] mlx4_core 0000:05:00.0:   profile[ 7] (    CQ): 2^16
entries @ 0x 117800000, size 0x    800000
[ 1421.156115] mlx4_core 0000:05:00.0:   profile[ 8] (   MCG): 2^13
entries @ 0x 118000000, size 0x    800000
[ 1421.156117] mlx4_core 0000:05:00.0:   profile[ 9] (  AUXC): 2^18
entries @ 0x 118800000, size 0x     40000
[ 1421.156119] mlx4_core 0000:05:00.0:   profile[10] (    EQ): 2^10
entries @ 0x 118840000, size 0x     20000
[ 1421.156120] mlx4_core 0000:05:00.0: HCA context memory: reserving 4596096 KB
[ 1421.156136] mlx4_core 0000:05:00.0: 4596096 KB of HCA context
requires 9068 KB aux memory.
[ 1421.185505] mlx4_core 0000:05:00.0: Mapped 39 chunks/9068 KB for ICM aux.
[ 1421.186824] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
[ 1421.188122] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
40000000 for ICM.
[ 1421.189418] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
80000000 for ICM.
[ 1421.189754] mlx4_core 0000:05:00.0: Mapped 1 chunks/64 KB at
c0000000 for ICM.
[ 1421.190400] mlx4_core 0000:05:00.0: Mapped 1 chunks/128 KB at
118840000 for ICM.
[ 1421.191677] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
108000000 for ICM.
[ 1421.193001] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
114000000 for ICM.
[ 1421.194279] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
110000000 for ICM.
[ 1421.195563] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118800000 for ICM.
[ 1421.196841] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
116000000 for ICM.
[ 1421.198127] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
100000000 for ICM.
[ 1421.199405] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
117800000 for ICM.
[ 1421.200684] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
117000000 for ICM.
[ 1421.201964] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118000000 for ICM.
[ 1421.203240] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118040000 for ICM.
[ 1421.204517] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118080000 for ICM.
[ 1421.205802] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1180c0000 for ICM.
[ 1421.207079] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118100000 for ICM.
[ 1421.208356] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118140000 for ICM.
[ 1421.209633] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118180000 for ICM.
[ 1421.210912] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1181c0000 for ICM.
[ 1421.212191] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118200000 for ICM.
[ 1421.213465] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118240000 for ICM.
[ 1421.214742] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118280000 for ICM.
[ 1421.216024] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1182c0000 for ICM.
[ 1421.217303] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118300000 for ICM.
[ 1421.218580] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118340000 for ICM.
[ 1421.219855] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118380000 for ICM.
[ 1421.221132] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1183c0000 for ICM.
[ 1421.222407] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118400000 for ICM.
[ 1421.223685] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118440000 for ICM.
[ 1421.224963] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118480000 for ICM.
[ 1421.226245] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1184c0000 for ICM.
[ 1421.227522] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118500000 for ICM.
[ 1421.228801] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118540000 for ICM.
[ 1421.230079] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118580000 for ICM.
[ 1421.231355] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1185c0000 for ICM.
[ 1421.232633] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118600000 for ICM.
[ 1421.233909] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118640000 for ICM.
[ 1421.235186] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118680000 for ICM.
[ 1421.236470] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1186c0000 for ICM.
[ 1421.237748] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118700000 for ICM.
[ 1421.239026] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118740000 for ICM.
[ 1421.240303] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
118780000 for ICM.
[ 1421.241581] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
1187c0000 for ICM.
[ 1421.744993] mlx4_core 0000:05:00.0: Started init_resource_tracker: 80 slaves
[ 1421.745454] mlx4_core 0000:05:00.0: irq 176 for MSI/MSI-X
[ 1421.745466] mlx4_core 0000:05:00.0: irq 177 for MSI/MSI-X
[ 1421.750286] mlx4_core 0000:05:00.0: NOP command IRQ test passed
[ 1421.750911] mlx4_core: Initializing 0000:82:00.0
[ 1421.751006] mlx4_core 0000:82:00.0: Enabling SR-IOV with 1 VFs
[ 1421.851346] pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
[ 1421.852051] mlx4_core 0000:82:00.0: Running in master mode
[ 1422.853834] mlx4_core 0000:82:00.0: FW version 2.11.500 (cmd intf
rev 3), max commands 16
[ 1422.853837] mlx4_core 0000:82:00.0: Catastrophic error buffer at
0x1f020, size 0x10, BAR 0
[ 1422.853839] mlx4_core 0000:82:00.0: Communication vector bar:2 offset:0x800
[ 1422.853840] mlx4_core 0000:82:00.0: FW size 385 KB
[ 1422.853842] mlx4_core 0000:82:00.0: Clear int @ f0058, BAR 0
[ 1422.855140] mlx4_core 0000:82:00.0: Mapped 26 chunks/6168 KB for FW.
[ 1425.518005] mlx4_core 0000:82:00.0: BlueFlame available (reg size
512, regs/page 8)
[ 1425.518117] mlx4_core 0000:82:00.0: Base MM extensions: flags
00104cc0, rsvd L_Key 00008000
[ 1425.518119] mlx4_core 0000:82:00.0: Max ICM size 4294967296 MB
[ 1425.518120] mlx4_core 0000:82:00.0: Max QPs: 16777216, reserved
QPs: 64, entry size: 256
[ 1425.518122] mlx4_core 0000:82:00.0: Max SRQs: 16777216, reserved
SRQs: 64, entry size: 128
[ 1425.518124] mlx4_core 0000:82:00.0: Max CQs: 16777216, reserved
CQs: 128, entry size: 128
[ 1425.518125] mlx4_core 0000:82:00.0: Max EQs: 32, reserved EQs: 28,
entry size: 128
[ 1425.518127] mlx4_core 0000:82:00.0: reserved MPTs: 256, reserved MTTs: 32
[ 1425.518128] mlx4_core 0000:82:00.0: Max PDs: 131072, reserved PDs:
4, reserved UARs: 7
[ 1425.518130] mlx4_core 0000:82:00.0: Max QP/MCG: 131072, reserved MGMs: 0
[ 1425.518131] mlx4_core 0000:82:00.0: Max CQEs: 4194304, max WQEs:
16384, max SRQ WQEs: 16384
[ 1425.518133] mlx4_core 0000:82:00.0: Local CA ACK delay: 15, max
MTU: 4096, port width cap: 2
[ 1425.518134] mlx4_core 0000:82:00.0: Max SQ desc size: 1008, max SQ S/G: 62
[ 1425.518136] mlx4_core 0000:82:00.0: Max RQ desc size: 512, max RQ S/G: 32
[ 1425.518137] mlx4_core 0000:82:00.0: Max GSO size: 131072
[ 1425.518138] mlx4_core 0000:82:00.0: Max counters: 256
[ 1425.518140] mlx4_core 0000:82:00.0: Max RSS Table size: 256
[ 1425.518141] mlx4_core 0000:82:00.0: DEV_CAP flags:
[ 1425.518142] mlx4_core 0000:82:00.0:     RC transport
[ 1425.518144] mlx4_core 0000:82:00.0:     UC transport
[ 1425.518145] mlx4_core 0000:82:00.0:     UD transport
[ 1425.518146] mlx4_core 0000:82:00.0:     XRC transport
[ 1425.518147] mlx4_core 0000:82:00.0:     FCoIB support
[ 1425.518148] mlx4_core 0000:82:00.0:     SRQ support
[ 1425.518150] mlx4_core 0000:82:00.0:     IPoIB checksum offload
[ 1425.518151] mlx4_core 0000:82:00.0:     P_Key violation counter
[ 1425.518152] mlx4_core 0000:82:00.0:     Q_Key violation counter
[ 1425.518154] mlx4_core 0000:82:00.0:     DPDP
[ 1425.518155] mlx4_core 0000:82:00.0:     Big LSO headers
[ 1425.518156] mlx4_core 0000:82:00.0:     APM support
[ 1425.518158] mlx4_core 0000:82:00.0:     Atomic ops support
[ 1425.518159] mlx4_core 0000:82:00.0:     Address vector port checking support
[ 1425.518160] mlx4_core 0000:82:00.0:     UD multicast support
[ 1425.518161] mlx4_core 0000:82:00.0:     Router support
[ 1425.518163] mlx4_core 0000:82:00.0:     IBoE support
[ 1425.518164] mlx4_core 0000:82:00.0:     Unicast loopback support
[ 1425.518165] mlx4_core 0000:82:00.0:     FCS header control
[ 1425.518167] mlx4_core 0000:82:00.0:     UDP RSS support
[ 1425.518168] mlx4_core 0000:82:00.0:     Unicast VEP steering support
[ 1425.518169] mlx4_core 0000:82:00.0:     Multicast VEP steering support
[ 1425.518170] mlx4_core 0000:82:00.0:     Counters support
[ 1425.518172] mlx4_core 0000:82:00.0:     Port management change event support
[ 1425.518173] mlx4_core 0000:82:00.0:     64 byte EQE support
[ 1425.518175] mlx4_core 0000:82:00.0:     64 byte CQE support
[ 1425.518176] mlx4_core 0000:82:00.0:     RSS support
[ 1425.518177] mlx4_core 0000:82:00.0:     RSS Toeplitz Hash Function support
[ 1425.518178] mlx4_core 0000:82:00.0:     RSS XOR Hash Function support
[ 1425.518180] mlx4_core 0000:82:00.0:     Device manage flow steering support
[ 1425.518182] mlx4_core 0000:82:00.0: 64B EQEs/CQEs supported by the
device but not enabled
[ 1425.518184] mlx4_core 0000:82:00.0: Steering mode is: B0 steering,
oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
[ 1425.518190] mlx4_core 0000:82:00.0:   profile[ 0] (  CMPT): 2^26
entries @ 0x         0, size 0x 100000000
[ 1425.518193] mlx4_core 0000:82:00.0:   profile[ 1] (RDMARC): 2^22
entries @ 0x 100000000, size 0x   8000000
[ 1425.518195] mlx4_core 0000:82:00.0:   profile[ 2] (   MTT): 2^24
entries @ 0x 108000000, size 0x   8000000
[ 1425.518197] mlx4_core 0000:82:00.0:   profile[ 3] (    QP): 2^18
entries @ 0x 110000000, size 0x   4000000
[ 1425.518199] mlx4_core 0000:82:00.0:   profile[ 4] (  DMPT): 2^19
entries @ 0x 114000000, size 0x   2000000
[ 1425.518200] mlx4_core 0000:82:00.0:   profile[ 5] (  ALTC): 2^18
entries @ 0x 116000000, size 0x   1000000
[ 1425.518202] mlx4_core 0000:82:00.0:   profile[ 6] (   SRQ): 2^16
entries @ 0x 117000000, size 0x    800000
[ 1425.518204] mlx4_core 0000:82:00.0:   profile[ 7] (    CQ): 2^16
entries @ 0x 117800000, size 0x    800000
[ 1425.518206] mlx4_core 0000:82:00.0:   profile[ 8] (   MCG): 2^13
entries @ 0x 118000000, size 0x    800000
[ 1425.518208] mlx4_core 0000:82:00.0:   profile[ 9] (  AUXC): 2^18
entries @ 0x 118800000, size 0x     40000
[ 1425.518210] mlx4_core 0000:82:00.0:   profile[10] (    EQ): 2^10
entries @ 0x 118840000, size 0x     20000
[ 1425.518212] mlx4_core 0000:82:00.0: HCA context memory: reserving 4596096 KB
[ 1425.518228] mlx4_core 0000:82:00.0: 4596096 KB of HCA context
requires 9068 KB aux memory.
[ 1425.554670] mlx4_core 0000:82:00.0: Mapped 39 chunks/9068 KB for ICM aux.
[ 1425.556059] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
[ 1425.557429] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
40000000 for ICM.
[ 1425.558795] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
80000000 for ICM.
[ 1425.559144] mlx4_core 0000:82:00.0: Mapped 1 chunks/64 KB at
c0000000 for ICM.
[ 1425.559827] mlx4_core 0000:82:00.0: Mapped 1 chunks/128 KB at
118840000 for ICM.
[ 1425.561182] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
108000000 for ICM.
[ 1425.562580] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
114000000 for ICM.
[ 1425.563932] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
110000000 for ICM.
[ 1425.565306] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118800000 for ICM.
[ 1425.566666] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
116000000 for ICM.
[ 1425.568018] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
100000000 for ICM.
[ 1425.569390] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
117800000 for ICM.
[ 1425.570754] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
117000000 for ICM.
[ 1425.572109] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118000000 for ICM.
[ 1425.573454] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118040000 for ICM.
[ 1425.574822] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118080000 for ICM.
[ 1425.576175] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1180c0000 for ICM.
[ 1425.577533] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118100000 for ICM.
[ 1425.578899] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118140000 for ICM.
[ 1425.580246] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118180000 for ICM.
[ 1425.581593] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1181c0000 for ICM.
[ 1425.582929] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118200000 for ICM.
[ 1425.584289] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118240000 for ICM.
[ 1425.585645] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118280000 for ICM.
[ 1425.587011] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1182c0000 for ICM.
[ 1425.588376] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118300000 for ICM.
[ 1425.589740] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118340000 for ICM.
[ 1425.591098] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118380000 for ICM.
[ 1425.592460] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1183c0000 for ICM.
[ 1425.593820] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118400000 for ICM.
[ 1425.595170] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118440000 for ICM.
[ 1425.596532] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118480000 for ICM.
[ 1425.597912] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1184c0000 for ICM.
[ 1425.599257] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118500000 for ICM.
[ 1425.600610] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118540000 for ICM.
[ 1425.601967] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118580000 for ICM.
[ 1425.603314] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1185c0000 for ICM.
[ 1425.604674] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118600000 for ICM.
[ 1425.606018] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118640000 for ICM.
[ 1425.607374] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118680000 for ICM.
[ 1425.608741] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1186c0000 for ICM.
[ 1425.610095] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118700000 for ICM.
[ 1425.611456] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118740000 for ICM.
[ 1425.612815] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
118780000 for ICM.
[ 1425.614165] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
1187c0000 for ICM.
[ 1426.193222] mlx4_core 0000:82:00.0: Started init_resource_tracker: 80 slaves
[ 1426.193692] mlx4_core 0000:82:00.0: irq 178 for MSI/MSI-X
[ 1426.193705] mlx4_core 0000:82:00.0: irq 179 for MSI/MSI-X
[ 1426.200029] mlx4_core 0000:82:00.0: NOP command IRQ test passed
[ 1426.200605] mlx4_core: Initializing 0000:05:00.1
[ 1426.200618] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
[ 1426.200654] mlx4_core 0000:05:00.1: Skipping virtual function:1
[ 1426.200674] mlx4_core: Initializing 0000:82:00.1
[ 1426.200685] mlx4_core 0000:82:00.1: enabling device (0000 -> 0002)
[ 1426.200711] mlx4_core 0000:82:00.1: Skipping virtual function:1
[ 1438.961741] pci-stub 0000:82:00.1: claimed by stub
[ 1438.967250] pci-stub 0000:82:00.1: enabling device (0000 -> 0002)
[ 1438.969739] mlx4_core 0000:82:00.0: FLR event for slave: 1
[ 1438.969775] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
[ 1438.969776] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
[ 1439.070931] assign device 0:82:0.1
[ 1439.073469] mlx4_core 0000:82:00.0: FLR event for slave: 1
[ 1439.073526] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
[ 1439.073529] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
[ 1439.226723] mlx4_core 0000:82:00.0: Received reset from slave:1
[ 1439.239542] pci-stub 0000:82:00.1: irq 180 for MSI/MSI-X
[ 1439.272548] pci-stub 0000:82:00.1: irq 180 for MSI/MSI-X
[ 1439.272559] pci-stub 0000:82:00.1: irq 181 for MSI/MSI-X
[ 1449.381120] mlx4_core 0000:82:00.0: Received reset from slave:1


mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
mlx4_core: Initializing 0000:00:0b.0
mlx4_core 0000:00:0b.0: enabling device (0000 -> 0002)
mlx4_core 0000:00:0b.0: Detected virtual function - running in slave mode
mlx4_core 0000:00:0b.0: Sending reset
mlx4_core 0000:00:0b.0: Sending vhcr0
mlx4_core 0000:00:0b.0: 64B EQEs/CQEs supported by the device but not enabled
mlx4_core 0000:00:0b.0: HCA minimum page size:512
mlx4_core 0000:00:0b.0: irq 48 for MSI/MSI-X
mlx4_core 0000:00:0b.0: irq 49 for MSI/MSI-X
mlx4_core 0000:00:0b.0: failed execution of VHCR_POST commandopcode 0x31
mlx4_core 0000:00:0b.0: NOP command failed to generate MSI-X interrupt IRQ 49).
mlx4_core 0000:00:0b.0: Trying again without MSI-X.
mlx4_core: probe of 0000:00:0b.0 failed with error -16

Mathis

2013/1/29 Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
> On Tuesday 29 January 2013 15:15, Mathis GAVILLON wrote:
>> In fact, one boxe wasn't check in IOMMU submenu (Support for Interrupt
>> Remapping (EXPERIMENTAL)). I've recompiled the kernel of the host and
>> guest (is it necessary for this last one ?). But the error message is
>> already present. Just below, new dmeg log from host and guest O/S
>> (mlx4_core loaded with options num_vfs=1 probe_vf=1 debug_level=1 on
>> host and debug_level=1 on guest) :
>>
> Please do the following:
> 1. Check the Support for Interrupt Remapping (EXPERIMENTAL) box and recompile/reinstall.
> 2. set probe_vf=0, so that no vfs will run on the Hypervisor.  That way you will
>    see if any VF comes up without the "noise" in /var/log/messages in the Hypervisor generated
>    by having one of the VFs run on the Hypervisor.
>
> 3. I noticed that you are enabling only a single VF, and that you are having the
>    VF come up first on the Hypervisor, then moving it to run on a guest.
>    It is better not to do things that way. Best to have it come up cleanly once on
>    the guest. (the FLR event in your log results from this move.  The VF gets reset).
>
>    If you must have a VF running on the Hypervisor, use "num_vfs=2 probe_vf=1".
>    You will then see Devices ...xx.0, ...xx.1 and ...xx.2 in lspci.  The first VF
>    (...xx.1) will be initialized on the Hypervisor.  Attach ...xx.2 to the VM.
>
> -Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
