From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual functions in virtual machine
Date: Mon, 28 Jan 2013 18:35:18 +0200
Message-ID: <201301281835.18533.jackm@dev.mellanox.co.il>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com> <CAOoYFkGe=kKDDKvhOdRVCXQbGfV52q38dz6cYTpQXmFGOsBwsg@mail.gmail.com> <CAOoYFkFVvK+1YNJ_N6r0N_3ZMF6P9Q+0dbsDg4v8=3JfDPVOOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOoYFkFVvK+1YNJ_N6r0N_3ZMF6P9Q+0dbsDg4v8=3JfDPVOOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Which VF did you map to the guest O/S?
In your configuration, both HCAs will have the PF and the
first VF running on the hypervisor,
and the remaining VFs available for binding to guests.

You have:
mlx4_core 0000:05:00.0: Enabling SR-IOV with 3 VFs <== PF
pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600 <== VFs
pci 0000:05:00.2: [15b3:1002] type 00 class 0x0c0600
pci 0000:05:00.3: [15b3:1002] type 00 class 0x0c0600

05:00.0 and 05:00.1 run on the hypervisor, and 05:00.2/3 are
available for binding to guests.

Similarly, 
mlx4_core 0000:82:00.0: Enabling SR-IOV with 3 VFs
pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
pci 0000:82:00.2: [15b3:1004] type 00 class 0x028000
pci 0000:82:00.3: [15b3:1004] type 00 class 0x028000

82:00.0 and 82:00.1 run on the hypervisor, and 82:00.2/3 are
available for binding to guests.

The "skipping" messages you see for 2/3 indicate that these
are not yet bound, and the hypervisor is not claiming them
(this arises from setting probe_vf=1 --> only ONE guest is
claimed/bound by the Hypervisor).

I don't see any "received reset from xxx" lines in the dumps
below, which would indicate that the hypervisor received a
reset request from a guest O/S bound to one of the available VFs.

This looks to me like a kernel configuration problem.

You did not mention what CPU you are using.
Did you do the following when building your kernel?
	make menuconfig (stuff below is shown for kernel 3.7. I don't know if it
                         changed in 3.8)
        Then, under "Device Drivers", put an '*' by "IOMMU hardware support" and
        go into that submenu.
	Make sure to check ALL the boxes which apply for your CPU in the IOMMU submenu.

For Intel, at least, you should also add "intel_iommu=on" to the line for your kernel
in file /boot/grub/menu.lst

-Jack

On Monday 28 January 2013 10:29, Mathis GAVILLON wrote:
> The version of firmware I gave you was wrong (I've two cards
> (ConnectX2 and ConnectX3, I only use ConnectX 3) in my computer and I
> took the bad one). The firmware installed on my ConnectX3 Infiniband
> Card is 2.11.500.
> KVM is 1.2.2-1 version.
> I tried to load the driver with options you gave me but the error
> message is the same. Nothing else happen.
> 
> Here is the dmesg command return from host (mlx4_core loaded with
> options debug_level=1, num_vfs=3, probe_vf=1) :
> 
> [root@barb0 ~]# dmesg
> [65182.838953] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> [65182.838955] mlx4_core: Initializing 0000:05:00.0
> [65182.839144] mlx4_core 0000:05:00.0: Enabling SR-IOV with 3 VFs
> [65182.940316] pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600
> [65182.941105] pci 0000:05:00.2: [15b3:1002] type 00 class 0x0c0600
> [65182.941876] pci 0000:05:00.3: [15b3:1002] type 00 class 0x0c0600
> [65182.942585] mlx4_core 0000:05:00.0: Running in master mode
> [65183.945306] mlx4_core 0000:05:00.0: FW version 2.9.1200 (cmd intf
> rev 3), max commands 16
> [65183.945309] mlx4_core 0000:05:00.0: Catastrophic error buffer at
> 0x1f020, size 0x10, BAR 0
> [65183.945311] mlx4_core 0000:05:00.0: Communication vector bar:2 offset:0x800
> [65183.945312] mlx4_core 0000:05:00.0: FW size 385 KB
> [65183.945313] mlx4_core 0000:05:00.0: Clear int @ f0058, BAR 0
> [65183.947177] mlx4_core 0000:05:00.0: Mapped 26 chunks/6168 KB for FW.
> [65184.614576] mlx4_core 0000:05:00.0: BlueFlame available (reg size
> 512, regs/page 8)
> [65184.614742] mlx4_core 0000:05:00.0: Base MM extensions: flags
> 00000cc0, rsvd L_Key 00000500
> [65184.614743] mlx4_core 0000:05:00.0: Max ICM size 4294967296 MB
> [65184.614745] mlx4_core 0000:05:00.0: Max QPs: 16777216, reserved
> QPs: 64, entry size: 256
> [65184.614747] mlx4_core 0000:05:00.0: Max SRQs: 16777216, reserved
> SRQs: 64, entry size: 128
> [65184.614748] mlx4_core 0000:05:00.0: Max CQs: 16777216, reserved
> CQs: 128, entry size: 128
> [65184.614750] mlx4_core 0000:05:00.0: Max EQs: 32, reserved EQs: 28,
> entry size: 128
> [65184.614751] mlx4_core 0000:05:00.0: reserved MPTs: 16, reserved MTTs: 16
> [65184.614753] mlx4_core 0000:05:00.0: Max PDs: 131072, reserved PDs:
> 4, reserved UARs: 7
> [65184.614754] mlx4_core 0000:05:00.0: Max QP/MCG: 131072, reserved MGMs: 0
> [65184.614756] mlx4_core 0000:05:00.0: Max CQEs: 4194304, max WQEs:
> 16384, max SRQ WQEs: 16384
> [65184.614758] mlx4_core 0000:05:00.0: Local CA ACK delay: 15, max
> MTU: 4096, port width cap: 3
> [65184.614759] mlx4_core 0000:05:00.0: Max SQ desc size: 1008, max SQ S/G: 62
> [65184.614760] mlx4_core 0000:05:00.0: Max RQ desc size: 512, max RQ S/G: 32
> [65184.614762] mlx4_core 0000:05:00.0: Max GSO size: 131072
> [65184.614763] mlx4_core 0000:05:00.0: Max counters: 256
> [65184.614764] mlx4_core 0000:05:00.0: Max RSS Table size: 256
> [65184.614766] mlx4_core 0000:05:00.0: DEV_CAP flags:
> [65184.614767] mlx4_core 0000:05:00.0:     RC transport
> [65184.614768] mlx4_core 0000:05:00.0:     UC transport
> [65184.614769] mlx4_core 0000:05:00.0:     UD transport
> [65184.614771] mlx4_core 0000:05:00.0:     XRC transport
> [65184.614772] mlx4_core 0000:05:00.0:     FCoIB support
> [65184.614773] mlx4_core 0000:05:00.0:     SRQ support
> [65184.614774] mlx4_core 0000:05:00.0:     IPoIB checksum offload
> [65184.614775] mlx4_core 0000:05:00.0:     P_Key violation counter
> [65184.614777] mlx4_core 0000:05:00.0:     Q_Key violation counter
> [65184.614778] mlx4_core 0000:05:00.0:     DPDP
> [65184.614779] mlx4_core 0000:05:00.0:     Big LSO headers
> [65184.614780] mlx4_core 0000:05:00.0:     APM support
> [65184.614782] mlx4_core 0000:05:00.0:     Atomic ops support
> [65184.614783] mlx4_core 0000:05:00.0:     Address vector port checking support
> [65184.614784] mlx4_core 0000:05:00.0:     UD multicast support
> [65184.614785] mlx4_core 0000:05:00.0:     Router support
> [65184.614787] mlx4_core 0000:05:00.0:     IBoE support
> [65184.614788] mlx4_core 0000:05:00.0:     Unicast loopback support
> [65184.614789] mlx4_core 0000:05:00.0:     UDP RSS support
> [65184.614790] mlx4_core 0000:05:00.0:     Unicast VEP steering support
> [65184.614792] mlx4_core 0000:05:00.0:     Multicast VEP steering support
> [65184.614793] mlx4_core 0000:05:00.0:     Counters support
> [65184.614795] mlx4_core 0000:05:00.0:     RSS support
> [65184.614796] mlx4_core 0000:05:00.0:     RSS Toeplitz Hash Function support
> [65184.614797] mlx4_core 0000:05:00.0:     RSS XOR Hash Function support
> [65184.614800] mlx4_core 0000:05:00.0: Steering mode is: B0 steering,
> oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
> [65184.614807] mlx4_core 0000:05:00.0:   profile[ 0] (  CMPT): 2^26
> entries @ 0x         0, size 0x 100000000
> [65184.614809] mlx4_core 0000:05:00.0:   profile[ 1] (RDMARC): 2^22
> entries @ 0x 100000000, size 0x   8000000
> [65184.614811] mlx4_core 0000:05:00.0:   profile[ 2] (   MTT): 2^24
> entries @ 0x 108000000, size 0x   8000000
> [65184.614813] mlx4_core 0000:05:00.0:   profile[ 3] (    QP): 2^18
> entries @ 0x 110000000, size 0x   4000000
> [65184.614815] mlx4_core 0000:05:00.0:   profile[ 4] (  DMPT): 2^19
> entries @ 0x 114000000, size 0x   2000000
> [65184.614816] mlx4_core 0000:05:00.0:   profile[ 5] (  ALTC): 2^18
> entries @ 0x 116000000, size 0x   1000000
> [65184.614818] mlx4_core 0000:05:00.0:   profile[ 6] (   SRQ): 2^16
> entries @ 0x 117000000, size 0x    800000
> [65184.614820] mlx4_core 0000:05:00.0:   profile[ 7] (    CQ): 2^16
> entries @ 0x 117800000, size 0x    800000
> [65184.614822] mlx4_core 0000:05:00.0:   profile[ 8] (   MCG): 2^13
> entries @ 0x 118000000, size 0x    800000
> [65184.614824] mlx4_core 0000:05:00.0:   profile[ 9] (  AUXC): 2^18
> entries @ 0x 118800000, size 0x     40000
> [65184.614826] mlx4_core 0000:05:00.0:   profile[10] (    EQ): 2^10
> entries @ 0x 118840000, size 0x     20000
> [65184.614827] mlx4_core 0000:05:00.0: HCA context memory: reserving 4596096 KB
> [65184.614844] mlx4_core 0000:05:00.0: 4596096 KB of HCA context
> requires 9068 KB aux memory.
> [65184.644227] mlx4_core 0000:05:00.0: Mapped 39 chunks/9068 KB for ICM aux.
> [65184.645547] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
> [65184.646846] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 40000000 for ICM.
> [65184.648146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 80000000 for ICM.
> [65184.648483] mlx4_core 0000:05:00.0: Mapped 1 chunks/64 KB at
> c0000000 for ICM.
> [65184.649133] mlx4_core 0000:05:00.0: Mapped 1 chunks/128 KB at
> 118840000 for ICM.
> [65184.650413] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 108000000 for ICM.
> [65184.651737] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 114000000 for ICM.
> [65184.653016] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 110000000 for ICM.
> [65184.654304] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118800000 for ICM.
> [65184.655585] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 116000000 for ICM.
> [65184.656866] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 100000000 for ICM.
> [65184.658146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 117800000 for ICM.
> [65184.659426] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 117000000 for ICM.
> [65184.660705] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118000000 for ICM.
> [65184.661986] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118040000 for ICM.
> [65184.663265] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118080000 for ICM.
> [65184.664550] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1180c0000 for ICM.
> [65184.665839] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118100000 for ICM.
> [65184.667117] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118140000 for ICM.
> [65184.668395] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118180000 for ICM.
> [65184.669675] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1181c0000 for ICM.
> [65184.670955] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118200000 for ICM.
> [65184.672234] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118240000 for ICM.
> [65184.673511] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118280000 for ICM.
> [65184.674794] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1182c0000 for ICM.
> [65184.676070] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118300000 for ICM.
> [65184.677351] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118340000 for ICM.
> [65184.678629] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118380000 for ICM.
> [65184.679906] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1183c0000 for ICM.
> [65184.681185] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118400000 for ICM.
> [65184.682463] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118440000 for ICM.
> [65184.683742] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118480000 for ICM.
> [65184.685028] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1184c0000 for ICM.
> [65184.686306] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118500000 for ICM.
> [65184.687583] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118540000 for ICM.
> [65184.688869] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118580000 for ICM.
> [65184.690148] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1185c0000 for ICM.
> [65184.691428] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118600000 for ICM.
> [65184.692706] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118640000 for ICM.
> [65184.693984] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118680000 for ICM.
> [65184.695268] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1186c0000 for ICM.
> [65184.696546] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118700000 for ICM.
> [65184.697825] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118740000 for ICM.
> [65184.699103] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 118780000 for ICM.
> [65184.700380] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 1187c0000 for ICM.
> [65185.202376] mlx4_core 0000:05:00.0: Started init_resource_tracker: 80 slaves
> [65185.202819] mlx4_core 0000:05:00.0: irq 176 for MSI/MSI-X
> [65185.202826] mlx4_core 0000:05:00.0: irq 177 for MSI/MSI-X
> [65185.207838] mlx4_core 0000:05:00.0: NOP command IRQ test passed
> [65185.208638] mlx4_core: Initializing 0000:82:00.0
> [65185.208742] mlx4_core 0000:82:00.0: Enabling SR-IOV with 3 VFs
> [65185.309000] pci 0000:82:00.1: [15b3:1004] type 00 class 0x028000
> [65185.309781] pci 0000:82:00.2: [15b3:1004] type 00 class 0x028000
> [65185.310507] pci 0000:82:00.3: [15b3:1004] type 00 class 0x028000
> [65185.311176] mlx4_core 0000:82:00.0: Running in master mode
> [65186.312479] mlx4_core 0000:82:00.0: FW version 2.11.500 (cmd intf
> rev 3), max commands 16
> [65186.312482] mlx4_core 0000:82:00.0: Catastrophic error buffer at
> 0x1f020, size 0x10, BAR 0
> [65186.312484] mlx4_core 0000:82:00.0: Communication vector bar:2 offset:0x800
> [65186.312485] mlx4_core 0000:82:00.0: FW size 385 KB
> [65186.312486] mlx4_core 0000:82:00.0: Clear int @ f0058, BAR 0
> [65186.313785] mlx4_core 0000:82:00.0: Mapped 26 chunks/6168 KB for FW.
> [65188.980410] mlx4_core 0000:82:00.0: BlueFlame available (reg size
> 512, regs/page 8)
> [65188.980535] mlx4_core 0000:82:00.0: Base MM extensions: flags
> 00104cc0, rsvd L_Key 00008000
> [65188.980536] mlx4_core 0000:82:00.0: Max ICM size 4294967296 MB
> [65188.980538] mlx4_core 0000:82:00.0: Max QPs: 16777216, reserved
> QPs: 64, entry size: 256
> [65188.980540] mlx4_core 0000:82:00.0: Max SRQs: 16777216, reserved
> SRQs: 64, entry size: 128
> [65188.980541] mlx4_core 0000:82:00.0: Max CQs: 16777216, reserved
> CQs: 128, entry size: 128
> [65188.980543] mlx4_core 0000:82:00.0: Max EQs: 32, reserved EQs: 28,
> entry size: 128
> [65188.980544] mlx4_core 0000:82:00.0: reserved MPTs: 256, reserved MTTs: 32
> [65188.980546] mlx4_core 0000:82:00.0: Max PDs: 131072, reserved PDs:
> 4, reserved UARs: 7
> [65188.980548] mlx4_core 0000:82:00.0: Max QP/MCG: 131072, reserved MGMs: 0
> [65188.980549] mlx4_core 0000:82:00.0: Max CQEs: 4194304, max WQEs:
> 16384, max SRQ WQEs: 16384
> [65188.980551] mlx4_core 0000:82:00.0: Local CA ACK delay: 15, max
> MTU: 4096, port width cap: 2
> [65188.980552] mlx4_core 0000:82:00.0: Max SQ desc size: 1008, max SQ S/G: 62
> [65188.980554] mlx4_core 0000:82:00.0: Max RQ desc size: 512, max RQ S/G: 32
> [65188.980555] mlx4_core 0000:82:00.0: Max GSO size: 131072
> [65188.980556] mlx4_core 0000:82:00.0: Max counters: 256
> [65188.980558] mlx4_core 0000:82:00.0: Max RSS Table size: 256
> [65188.980559] mlx4_core 0000:82:00.0: DEV_CAP flags:
> [65188.980560] mlx4_core 0000:82:00.0:     RC transport
> [65188.980561] mlx4_core 0000:82:00.0:     UC transport
> [65188.980563] mlx4_core 0000:82:00.0:     UD transport
> [65188.980564] mlx4_core 0000:82:00.0:     XRC transport
> [65188.980565] mlx4_core 0000:82:00.0:     FCoIB support
> [65188.980566] mlx4_core 0000:82:00.0:     SRQ support
> [65188.980568] mlx4_core 0000:82:00.0:     IPoIB checksum offload
> [65188.980569] mlx4_core 0000:82:00.0:     P_Key violation counter
> [65188.980570] mlx4_core 0000:82:00.0:     Q_Key violation counter
> [65188.980571] mlx4_core 0000:82:00.0:     DPDP
> [65188.980573] mlx4_core 0000:82:00.0:     Big LSO headers
> [65188.980574] mlx4_core 0000:82:00.0:     APM support
> [65188.980575] mlx4_core 0000:82:00.0:     Atomic ops support
> [65188.980576] mlx4_core 0000:82:00.0:     Address vector port checking support
> [65188.980578] mlx4_core 0000:82:00.0:     UD multicast support
> [65188.980579] mlx4_core 0000:82:00.0:     Router support
> [65188.980580] mlx4_core 0000:82:00.0:     IBoE support
> [65188.980582] mlx4_core 0000:82:00.0:     Unicast loopback support
> [65188.980583] mlx4_core 0000:82:00.0:     FCS header control
> [65188.980584] mlx4_core 0000:82:00.0:     UDP RSS support
> [65188.980586] mlx4_core 0000:82:00.0:     Unicast VEP steering support
> [65188.980587] mlx4_core 0000:82:00.0:     Multicast VEP steering support
> [65188.980588] mlx4_core 0000:82:00.0:     Counters support
> [65188.980589] mlx4_core 0000:82:00.0:     Port management change event support
> [65188.980591] mlx4_core 0000:82:00.0:     64 byte EQE support
> [65188.980592] mlx4_core 0000:82:00.0:     64 byte CQE support
> [65188.980593] mlx4_core 0000:82:00.0:     RSS support
> [65188.980595] mlx4_core 0000:82:00.0:     RSS Toeplitz Hash Function support
> [65188.980596] mlx4_core 0000:82:00.0:     RSS XOR Hash Function support
> [65188.980597] mlx4_core 0000:82:00.0:     Device manage flow steering support
> [65188.980599] mlx4_core 0000:82:00.0: 64B EQEs/CQEs supported by the
> device but not enabled
> [65188.980602] mlx4_core 0000:82:00.0: Steering mode is: B0 steering,
> oper_log_mgm_entry_size = 10, modparam log_num_mgm_entry_size = 10
> [65188.980609] mlx4_core 0000:82:00.0:   profile[ 0] (  CMPT): 2^26
> entries @ 0x         0, size 0x 100000000
> [65188.980611] mlx4_core 0000:82:00.0:   profile[ 1] (RDMARC): 2^22
> entries @ 0x 100000000, size 0x   8000000
> [65188.980613] mlx4_core 0000:82:00.0:   profile[ 2] (   MTT): 2^24
> entries @ 0x 108000000, size 0x   8000000
> [65188.980615] mlx4_core 0000:82:00.0:   profile[ 3] (    QP): 2^18
> entries @ 0x 110000000, size 0x   4000000
> [65188.980616] mlx4_core 0000:82:00.0:   profile[ 4] (  DMPT): 2^19
> entries @ 0x 114000000, size 0x   2000000
> [65188.980618] mlx4_core 0000:82:00.0:   profile[ 5] (  ALTC): 2^18
> entries @ 0x 116000000, size 0x   1000000
> [65188.980620] mlx4_core 0000:82:00.0:   profile[ 6] (   SRQ): 2^16
> entries @ 0x 117000000, size 0x    800000
> [65188.980622] mlx4_core 0000:82:00.0:   profile[ 7] (    CQ): 2^16
> entries @ 0x 117800000, size 0x    800000
> [65188.980624] mlx4_core 0000:82:00.0:   profile[ 8] (   MCG): 2^13
> entries @ 0x 118000000, size 0x    800000
> [65188.980625] mlx4_core 0000:82:00.0:   profile[ 9] (  AUXC): 2^18
> entries @ 0x 118800000, size 0x     40000
> [65188.980627] mlx4_core 0000:82:00.0:   profile[10] (    EQ): 2^10
> entries @ 0x 118840000, size 0x     20000
> [65188.980629] mlx4_core 0000:82:00.0: HCA context memory: reserving 4596096 KB
> [65188.980645] mlx4_core 0000:82:00.0: 4596096 KB of HCA context
> requires 9068 KB aux memory.
> [65189.017150] mlx4_core 0000:82:00.0: Mapped 39 chunks/9068 KB for ICM aux.
> [65189.018533] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at 0 for ICM.
> [65189.019895] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 40000000 for ICM.
> [65189.021266] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 80000000 for ICM.
> [65189.021621] mlx4_core 0000:82:00.0: Mapped 1 chunks/64 KB at
> c0000000 for ICM.
> [65189.022303] mlx4_core 0000:82:00.0: Mapped 1 chunks/128 KB at
> 118840000 for ICM.
> [65189.023671] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 108000000 for ICM.
> [65189.025060] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 114000000 for ICM.
> [65189.026419] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 110000000 for ICM.
> [65189.027778] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118800000 for ICM.
> [65189.029123] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 116000000 for ICM.
> [65189.030477] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 100000000 for ICM.
> [65189.031834] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 117800000 for ICM.
> [65189.033197] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 117000000 for ICM.
> [65189.034559] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118000000 for ICM.
> [65189.035906] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118040000 for ICM.
> [65189.037254] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118080000 for ICM.
> [65189.038633] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1180c0000 for ICM.
> [65189.039991] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118100000 for ICM.
> [65189.041349] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118140000 for ICM.
> [65189.042700] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118180000 for ICM.
> [65189.044050] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1181c0000 for ICM.
> [65189.045409] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118200000 for ICM.
> [65189.046758] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118240000 for ICM.
> [65189.048098] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118280000 for ICM.
> [65189.049466] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1182c0000 for ICM.
> [65189.050813] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118300000 for ICM.
> [65189.052169] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118340000 for ICM.
> [65189.053521] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118380000 for ICM.
> [65189.054862] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1183c0000 for ICM.
> [65189.056218] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118400000 for ICM.
> [65189.057563] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118440000 for ICM.
> [65189.058913] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118480000 for ICM.
> [65189.060272] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1184c0000 for ICM.
> [65189.061616] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118500000 for ICM.
> [65189.062971] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118540000 for ICM.
> [65189.064314] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118580000 for ICM.
> [65189.065669] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1185c0000 for ICM.
> [65189.067011] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118600000 for ICM.
> [65189.068364] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118640000 for ICM.
> [65189.069728] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118680000 for ICM.
> [65189.071086] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1186c0000 for ICM.
> [65189.072438] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118700000 for ICM.
> [65189.073788] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118740000 for ICM.
> [65189.075145] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 118780000 for ICM.
> [65189.076503] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 1187c0000 for ICM.
> [65189.643406] mlx4_core 0000:82:00.0: Started init_resource_tracker: 80 slaves
> [65189.643891] mlx4_core 0000:82:00.0: irq 178 for MSI/MSI-X
> [65189.643899] mlx4_core 0000:82:00.0: irq 179 for MSI/MSI-X
> [65189.650122] mlx4_core 0000:82:00.0: NOP command IRQ test passed
> [65189.650652] mlx4_core: Initializing 0000:05:00.1
> [65189.650667] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
> [65189.650709] mlx4_core 0000:05:00.1: Detected virtual function -
> running in slave mode
> [65189.650792] mlx4_core 0000:05:00.1: Sending reset
> [65189.650847] mlx4_core 0000:05:00.0: Received reset from slave:1
> [65189.650859] mlx4_core 0000:05:00.1: Sending vhcr0
> [65189.651166] mlx4_core 0000:05:00.1: BlueFlame not available
> [65189.651412] mlx4_core 0000:05:00.1: Base MM extensions: flags
> 00000cc0, rsvd L_Key 00000500
> [65189.651414] mlx4_core 0000:05:00.1: Max ICM size 4294967296 MB
> [65189.651417] mlx4_core 0000:05:00.1: Max QPs: 16777216, reserved
> QPs: 64, entry size: 256
> [65189.651419] mlx4_core 0000:05:00.1: Max SRQs: 16777216, reserved
> SRQs: 64, entry size: 128
> [65189.651421] mlx4_core 0000:05:00.1: Max CQs: 16777216, reserved
> CQs: 128, entry size: 128
> [65189.651422] mlx4_core 0000:05:00.1: Max EQs: 32, reserved EQs: 28,
> entry size: 128
> [65189.651424] mlx4_core 0000:05:00.1: reserved MPTs: 16, reserved MTTs: 16
> [65189.651425] mlx4_core 0000:05:00.1: Max PDs: 131072, reserved PDs:
> 4, reserved UARs: 7
> [65189.651427] mlx4_core 0000:05:00.1: Max QP/MCG: 131072, reserved MGMs: 0
> [65189.651428] mlx4_core 0000:05:00.1: Max CQEs: 4194304, max WQEs:
> 16384, max SRQ WQEs: 16384
> [65189.651430] mlx4_core 0000:05:00.1: Local CA ACK delay: 15, max
> MTU: 4096, port width cap: 3
> [65189.651431] mlx4_core 0000:05:00.1: Max SQ desc size: 1008, max SQ S/G: 62
> [65189.651433] mlx4_core 0000:05:00.1: Max RQ desc size: 512, max RQ S/G: 32
> [65189.651434] mlx4_core 0000:05:00.1: Max GSO size: 131072
> [65189.651436] mlx4_core 0000:05:00.1: Max counters: 256
> [65189.651437] mlx4_core 0000:05:00.1: Max RSS Table size: 256
> [65189.651438] mlx4_core 0000:05:00.1: DEV_CAP flags:
> [65189.651440] mlx4_core 0000:05:00.1:     RC transport
> [65189.651441] mlx4_core 0000:05:00.1:     UC transport
> [65189.651442] mlx4_core 0000:05:00.1:     UD transport
> [65189.651443] mlx4_core 0000:05:00.1:     XRC transport
> [65189.651444] mlx4_core 0000:05:00.1:     FCoIB support
> [65189.651446] mlx4_core 0000:05:00.1:     SRQ support
> [65189.651447] mlx4_core 0000:05:00.1:     IPoIB checksum offload
> [65189.651448] mlx4_core 0000:05:00.1:     P_Key violation counter
> [65189.651449] mlx4_core 0000:05:00.1:     Q_Key violation counter
> [65189.651451] mlx4_core 0000:05:00.1:     DPDP
> [65189.651452] mlx4_core 0000:05:00.1:     Big LSO headers
> [65189.651453] mlx4_core 0000:05:00.1:     APM support
> [65189.651454] mlx4_core 0000:05:00.1:     Atomic ops support
> [65189.651456] mlx4_core 0000:05:00.1:     Address vector port checking support
> [65189.651457] mlx4_core 0000:05:00.1:     UD multicast support
> [65189.651458] mlx4_core 0000:05:00.1:     Router support
> [65189.651459] mlx4_core 0000:05:00.1:     IBoE support
> [65189.651461] mlx4_core 0000:05:00.1:     Unicast loopback support
> [65189.651462] mlx4_core 0000:05:00.1:     UDP RSS support
> [65189.651463] mlx4_core 0000:05:00.1:     Unicast VEP steering support
> [65189.651465] mlx4_core 0000:05:00.1:     Multicast VEP steering support
> [65189.651466] mlx4_core 0000:05:00.1:     Counters support
> [65189.651467] mlx4_core 0000:05:00.1:     Port management change event support
> [65189.651469] mlx4_core 0000:05:00.1:     RSS support
> [65189.651470] mlx4_core 0000:05:00.1:     RSS Toeplitz Hash Function support
> [65189.651471] mlx4_core 0000:05:00.1:     RSS XOR Hash Function support
> [65189.651567] mlx4_core 0000:05:00.1: HCA minimum page size:512
> [65189.652182] mlx4_core 0000:05:00.1: Steering mode is: B0 steering
> [65189.652184] mlx4_core 0000:05:00.1: Failed to map blue flame area
> [65189.652438] mlx4_core 0000:05:00.1: irq 180 for MSI/MSI-X
> [65189.652446] mlx4_core 0000:05:00.1: irq 181 for MSI/MSI-X
> [65189.657770] mlx4_core 0000:05:00.1: NOP command IRQ test passed
> [65189.657791] mlx4_core: Initializing 0000:05:00.2
> [65189.657801] mlx4_core 0000:05:00.2: enabling device (0000 -> 0002)
> [65189.657836] mlx4_core 0000:05:00.2: Skipping virtual function:2
> [65189.657856] mlx4_core: Initializing 0000:05:00.3
> [65189.657865] mlx4_core 0000:05:00.3: enabling device (0000 -> 0002)
> [65189.657887] mlx4_core 0000:05:00.3: Skipping virtual function:3
> [65189.657904] mlx4_core: Initializing 0000:82:00.1
> [65189.657914] mlx4_core 0000:82:00.1: enabling device (0000 -> 0002)
> [65189.657940] mlx4_core 0000:82:00.1: Detected virtual function -
> running in slave mode
> [65189.658047] mlx4_core 0000:82:00.1: Sending reset
> [65189.658128] mlx4_core 0000:82:00.0: Received reset from slave:1
> [65189.658137] mlx4_core 0000:82:00.1: Sending vhcr0
> [65189.658463] mlx4_core 0000:82:00.1: BlueFlame not available
> [65189.658646] mlx4_core 0000:82:00.1: Base MM extensions: flags
> 00104cc0, rsvd L_Key 00008000
> [65189.658650] mlx4_core 0000:82:00.1: Max ICM size 4294967296 MB
> [65189.658653] mlx4_core 0000:82:00.1: Max QPs: 16777216, reserved
> QPs: 64, entry size: 256
> [65189.658655] mlx4_core 0000:82:00.1: Max SRQs: 16777216, reserved
> SRQs: 64, entry size: 128
> [65189.658657] mlx4_core 0000:82:00.1: Max CQs: 16777216, reserved
> CQs: 128, entry size: 128
> [65189.658658] mlx4_core 0000:82:00.1: Max EQs: 32, reserved EQs: 28,
> entry size: 128
> [65189.658660] mlx4_core 0000:82:00.1: reserved MPTs: 256, reserved MTTs: 32
> [65189.658661] mlx4_core 0000:82:00.1: Max PDs: 131072, reserved PDs:
> 4, reserved UARs: 7
> [65189.658663] mlx4_core 0000:82:00.1: Max QP/MCG: 131072, reserved MGMs: 0
> [65189.658664] mlx4_core 0000:82:00.1: Max CQEs: 4194304, max WQEs:
> 16384, max SRQ WQEs: 16384
> [65189.658666] mlx4_core 0000:82:00.1: Local CA ACK delay: 15, max
> MTU: 4096, port width cap: 2
> [65189.658667] mlx4_core 0000:82:00.1: Max SQ desc size: 1008, max SQ S/G: 62
> [65189.658669] mlx4_core 0000:82:00.1: Max RQ desc size: 512, max RQ S/G: 32
> [65189.658670] mlx4_core 0000:82:00.1: Max GSO size: 131072
> [65189.658671] mlx4_core 0000:82:00.1: Max counters: 256
> [65189.658673] mlx4_core 0000:82:00.1: Max RSS Table size: 256
> [65189.658674] mlx4_core 0000:82:00.1: DEV_CAP flags:
> [65189.658675] mlx4_core 0000:82:00.1:     RC transport
> [65189.658676] mlx4_core 0000:82:00.1:     UC transport
> [65189.658678] mlx4_core 0000:82:00.1:     UD transport
> [65189.658679] mlx4_core 0000:82:00.1:     XRC transport
> [65189.658680] mlx4_core 0000:82:00.1:     FCoIB support
> [65189.658681] mlx4_core 0000:82:00.1:     SRQ support
> [65189.658682] mlx4_core 0000:82:00.1:     IPoIB checksum offload
> [65189.658684] mlx4_core 0000:82:00.1:     P_Key violation counter
> [65189.658685] mlx4_core 0000:82:00.1:     Q_Key violation counter
> [65189.658688] mlx4_core 0000:82:00.1:     DPDP
> [65189.658691] mlx4_core 0000:82:00.1:     Big LSO headers
> [65189.658695] mlx4_core 0000:82:00.1:     APM support
> [65189.658699] mlx4_core 0000:82:00.1:     Atomic ops support
> [65189.658702] mlx4_core 0000:82:00.1:     Address vector port checking support
> [65189.658705] mlx4_core 0000:82:00.1:     UD multicast support
> [65189.658707] mlx4_core 0000:82:00.1:     Router support
> [65189.658708] mlx4_core 0000:82:00.1:     IBoE support
> [65189.658709] mlx4_core 0000:82:00.1:     Unicast loopback support
> [65189.658710] mlx4_core 0000:82:00.1:     FCS header control
> [65189.658712] mlx4_core 0000:82:00.1:     UDP RSS support
> [65189.658713] mlx4_core 0000:82:00.1:     Unicast VEP steering support
> [65189.658714] mlx4_core 0000:82:00.1:     Multicast VEP steering support
> [65189.658715] mlx4_core 0000:82:00.1:     Counters support
> [65189.658717] mlx4_core 0000:82:00.1:     Port management change event support
> [65189.658718] mlx4_core 0000:82:00.1:     64 byte EQE support
> [65189.658719] mlx4_core 0000:82:00.1:     64 byte CQE support
> [65189.658721] mlx4_core 0000:82:00.1:     RSS support
> [65189.658722] mlx4_core 0000:82:00.1:     RSS Toeplitz Hash Function support
> [65189.658723] mlx4_core 0000:82:00.1:     RSS XOR Hash Function support
> [65189.658725] mlx4_core 0000:82:00.1:     Device manage flow steering support
> [65189.658727] mlx4_core 0000:82:00.1: 64B EQEs/CQEs supported by the
> device but not enabled
> [65189.658863] mlx4_core 0000:82:00.1: HCA minimum page size:512
> [65189.659129] mlx4_core 0000:82:00.1: Steering mode is: B0 steering
> [65189.659130] mlx4_core 0000:82:00.1: Failed to map blue flame area
> [65189.659417] mlx4_core 0000:82:00.1: irq 182 for MSI/MSI-X
> [65189.659428] mlx4_core 0000:82:00.1: irq 183 for MSI/MSI-X
> [65189.666007] mlx4_core 0000:82:00.1: NOP command IRQ test passed
> [65189.666033] mlx4_core: Initializing 0000:82:00.2
> [65189.666045] mlx4_core 0000:82:00.2: enabling device (0000 -> 0002)
> [65189.666083] mlx4_core 0000:82:00.2: Skipping virtual function:2
> [65189.666106] mlx4_core: Initializing 0000:82:00.3
> [65189.666116] mlx4_core 0000:82:00.3: enabling device (0000 -> 0002)
> [65189.666142] mlx4_core 0000:82:00.3: Skipping virtual function:3
> [65189.690937] <mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX
> InfiniBand driver v1.0 (April 4, 2008)
> [65189.779306] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 110040000 for ICM.
> [65189.780627] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 100080000 for ICM.
> [65189.786286] mlx4_core 0000:05:00.0: mlx4_ib: multi-function enabled
> [65189.788526] mlx4_core 0000:05:00.0: mlx4_ib: initializing demux
> service for 80 qp1 clients
> [65189.792146] mlx4_core 0000:05:00.0: Mapped 1 chunks/256 KB at
> 100040000 for ICM.
> [65189.793859] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
> [65189.803736] IPv6: ADDRCONF(NETDEV_UP): ib1: link is not ready
> [65189.862554] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 110040000 for ICM.
> [65189.863888] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 100080000 for ICM.
> [65189.864185] mlx4_core 0000:82:00.0: mlx4_ib: multi-function enabled
> [65189.865217] mlx4_core 0000:82:00.0: mlx4_ib: initializing demux
> service for 80 qp1 clients
> [65189.868388] mlx4_core 0000:82:00.0: Mapped 1 chunks/256 KB at
> 100040000 for ICM.
> [65189.875240] IPv6: ADDRCONF(NETDEV_UP): ib2: link is not ready
> [65189.991130] mlx4_core 0000:05:00.1: mlx4_ib: multi-function enabled
> [65189.991132] mlx4_core 0000:05:00.1: mlx4_ib: operating in qp1 tunnel mode
> [65189.994633] IPv6: ADDRCONF(NETDEV_UP): ib3: link is not ready
> [65190.005505] IPv6: ADDRCONF(NETDEV_UP): ib4: link is not ready
> [65190.061269] mlx4_core 0000:82:00.1: mlx4_ib: multi-function enabled
> [65190.061271] mlx4_core 0000:82:00.1: mlx4_ib: operating in qp1 tunnel mode
> [65190.071641] IPv6: ADDRCONF(NETDEV_UP): ib5: link is not ready
> 
> Here is dmesg command return of virtual machine (mlx4_core loaded with
> options debug_level=1) :
> 
> [root@welling0 ~]# dmesg
> mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> mlx4_core: Initializing 0000:00:08.0
> mlx4_core 0000:00:08.0: Detected virtual function - running in slave mode
> mlx4_core 0000:00:08.0: Sending reset
> mlx4_core 0000:00:08.0: Sending vhcr0
> mlx4_core 0000:00:08.0: BlueFlame not available
> mlx4_core 0000:00:08.0: Base MM extensions: flags 00104cc0, rsvd L_Key 00008000
> mlx4_core 0000:00:08.0: Max ICM size 4294967296 MB
> mlx4_core 0000:00:08.0: Max QPs: 16777216, reserved QPs: 64, entry size: 256
> mlx4_core 0000:00:08.0: Max SRQs: 16777216, reserved SRQs: 64, entry size: 128
> mlx4_core 0000:00:08.0: Max CQs: 16777216, reserved CQs: 128, entry size: 128
> mlx4_core 0000:00:08.0: Max EQs: 32, reserved EQs: 28, entry size: 128
> mlx4_core 0000:00:08.0: reserved MPTs: 256, reserved MTTs: 32
> mlx4_core 0000:00:08.0: Max PDs: 131072, reserved PDs: 4, reserved UARs: 7
> mlx4_core 0000:00:08.0: Max QP/MCG: 131072, reserved MGMs: 0
> mlx4_core 0000:00:08.0: Max CQEs: 4194304, max WQEs: 16384, max SRQ WQEs: 16384
> mlx4_core 0000:00:08.0: Local CA ACK delay: 15, max MTU: 4096, port width cap: 2
> mlx4_core 0000:00:08.0: Max SQ desc size: 1008, max SQ S/G: 62
> mlx4_core 0000:00:08.0: Max RQ desc size: 512, max RQ S/G: 32
> mlx4_core 0000:00:08.0: Max GSO size: 131072
> mlx4_core 0000:00:08.0: Max counters: 256
> mlx4_core 0000:00:08.0: Max RSS Table size: 256
> mlx4_core 0000:00:08.0: DEV_CAP flags:
> mlx4_core 0000:00:08.0:     RC transport
> mlx4_core 0000:00:08.0:     UC transport
> mlx4_core 0000:00:08.0:     UD transport
> mlx4_core 0000:00:08.0:     XRC transport
> mlx4_core 0000:00:08.0:     FCoIB support
> mlx4_core 0000:00:08.0:     SRQ support
> mlx4_core 0000:00:08.0:     IPoIB checksum offload
> mlx4_core 0000:00:08.0:     P_Key violation counter
> mlx4_core 0000:00:08.0:     Q_Key violation counter
> mlx4_core 0000:00:08.0:     DPDP
> mlx4_core 0000:00:08.0:     Big LSO headers
> mlx4_core 0000:00:08.0:     APM support
> mlx4_core 0000:00:08.0:     Atomic ops support
> mlx4_core 0000:00:08.0:     Address vector port checking support
> mlx4_core 0000:00:08.0:     UD multicast support
> mlx4_core 0000:00:08.0:     Router support
> mlx4_core 0000:00:08.0:     IBoE support
> mlx4_core 0000:00:08.0:     Unicast loopback support
> mlx4_core 0000:00:08.0:     FCS header control
> mlx4_core 0000:00:08.0:     UDP RSS support
> mlx4_core 0000:00:08.0:     Unicast VEP steering support
> mlx4_core 0000:00:08.0:     Multicast VEP steering support
> mlx4_core 0000:00:08.0:     Counters support
> mlx4_core 0000:00:08.0:     Port management change event support
> mlx4_core 0000:00:08.0:     64 byte EQE support
> mlx4_core 0000:00:08.0:     64 byte CQE support
> mlx4_core 0000:00:08.0:     RSS support
> mlx4_core 0000:00:08.0:     RSS Toeplitz Hash Function support
> mlx4_core 0000:00:08.0:     RSS XOR Hash Function support
> mlx4_core 0000:00:08.0:     Device manage flow steering support
> mlx4_core 0000:00:08.0: 64B EQEs/CQEs supported by the device but not enabled
> mlx4_core 0000:00:08.0: HCA minimum page size:512
> mlx4_core 0000:00:08.0: Steering mode is: B0 steering
> mlx4_core 0000:00:08.0: Failed to map blue flame area
> mlx4_core 0000:00:08.0: irq 48 for MSI/MSI-X
> mlx4_core 0000:00:08.0: irq 49 for MSI/MSI-X
> mlx4_core 0000:00:08.0: failed execution of VHCR_POST commandopcode 0x31
> mlx4_core 0000:00:08.0: NOP command failed to generate MSI-X interrupt IRQ 49).
> mlx4_core 0000:00:08.0: Trying again without MSI-X.
> mlx4_core: probe of 0000:00:08.0 failed with error -16
> 
> Mathis
> 
> 
> 2013/1/24 Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > ---------- Forwarded message ----------
> > From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Date: 2013/1/24
> > Subject: Re: Error message when trying to use Infiniband virtual
> > functions in virtual machine
> > To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc : linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> >
> >
> > On Wed, Jan 23, 2013 at 5:29 PM, Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> I'm working on a project in which I try to virtualize Infiniband. I use ConnectX3 Infiniband cards with FW 2.9.1200.
> >> I've installed a Fedora 18 OS with 3.8.0rc2 recompiled kernel. I use KVM 1.2 to run virtual machines.
> >
> > Your firmware version is a bit old... if you can upgrade to the latest
> > GA on the Mellanox site (2.11.0500) would be good,
> >
> > So what version of  qemu is installed on the distro you use? Are you
> > able to work over a ConnectX VF if probed
> > to the host? e.g use num_vfs=3 probe_vf=1 and see how the related mlx4
> > device (e.g mlx4_1) is functioning.
> >
> > Also would be of help if you probe mlx4_core on both VM and host with
> > debug_level=1
> >
> >
> > Or.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
