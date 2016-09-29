From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: PROBLEM: nvmet rxe : Kernel oops when running nvmf IO over rdma_rxe
Date: Thu, 29 Sep 2016 14:10:24 -0600
Message-ID: <1475179824-10377-1-git-send-email-sbates@raithlin.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All

So I thought I would try and run NVMe over Fabrics over
Soft-RoCE. Both were adding to 4.8 so what could possibly go wrong
;-). I am getting a pretty consistent kernel oops so I though I would
post this so people could take a look.

Cheers

Stephen

Problem
-------

Kernel panics when attempting to run NVMe over Fabrics I/O over
soft-RoCE.

Interestingly nvme discover and connect seem to go well. In some cases
I even seem to be able to issue some IO against the /dev/nvme0n1
device on the host. However pretty quick I get a kernel oops on the
target as shown below.

My testing of soft-roce itself using userspace tools like ib_write_bw
seem to be passing. So I am thinking the interaction between the
kernel space interface for RXE and NVMf are not playing well
together.

Suspect Modules
---------------

nvmet, rdma_rxe

Steps to Reproduce
------------------

1. Monolithic 4.8-rc8 kernel. I can provide a .config if people want
it.
2. Boot up two QEMU instances connected together via a e1000 vNIC and
a QEMU socket connection.
3. Bind rdma_rxe to the relevant ethernet ports on each VM using the
rxe_cfg user-space tool.
4. Setup NVMf target namespace on the target. I did this was a short
shell script.
5. Do nvme discover and connect on host (I used nvme-cli for this).
6. Try and issue IO on the NVMe block device created on the host.

Some of this is recorded in my qemu-minimal Github repo which you can
find here:

https://github.com/sbates130272/qemu-minimal

Oops Trace
-----------

I am including a couple of lines before the oops because I suspect
they might be relevant. addr2line decodes the last addrss in the call
trace as

ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);

[  272.511262] nvmet: creating controller 1 for NQN
nqn.2014-08.org.nvmexpress:NVMf:uuid:1fa5a811-6324-42bb-aab0-3e1fa4d14b90.
[  272.758552] nvmet: adding queue 1 to ctrl 1.
[  313.308896] nvmet_rdma: freeing queue 1
[  313.310315] nvmet_rdma: freeing queue 0
[  313.313056] general protection fault: 0000 [#1] SMP
[  313.313672] Modules linked in:
[  313.314015] CPU: 0 PID: 420 Comm: kworker/0:1 Not tainted 4.8.0-rc8
#50
[  313.314015] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[  313.314015] Workqueue: events nvmet_rdma_release_queue_work
[  313.314015] task: ffff88007c728000 task.stack: ffff88007c750000
[  313.314015] RIP: 0010:[<ffffffff81453500>]  [<ffffffff81453500>]
nvmet_rdma_free_rsps+0x80/0x110
[  313.314015] RSP: 0018:ffff88007c753db8  EFLAGS: 00010282
[  313.314015] RAX: dead000000000200 RBX: ffff8800795c1320 RCX:
00000001810000e9
[  313.314015] RDX: dead000000000100 RSI: ffffea0001f07f80 RDI:
0000000040000000
[  313.314015] RBP: ffff88007c753de0 R08: 000000007c1feb01 R09:
00000001810000e9
[  313.314015] R10: ffffea0001f07f00 R11: ffffea0001f25800 R12:
0000000000001320
[  313.314015] R13: 0000000000008800 R14: ffff88007c2c6a00 R15:
ffff88007b93e400
[  313.314015] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[  313.314015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  313.314015] CR2: 00007f13ddc13005 CR3: 000000007c1d4000 CR4:
00000000000006f0
[  313.314015] Stack:
[  313.314015]  ffff88007c2c6a00 0000000000000002 ffff88007c1adc00
ffff88007fc1b500
[  313.314015]  ffff88007c2c6ac8 ffff88007c753df8 ffffffff814537b9
ffff88007b93e400
[  313.314015]  ffff88007c753e20 ffffffff81453820 ffff88007d3bfd80
ffff88007fc17040
[  313.314015] Call Trace:
[  313.314015]  [<ffffffff814537b9>] nvmet_rdma_free_queue+0x49/0x90
[  313.314015]  [<ffffffff81453820>]
nvmet_rdma_release_queue_work+0x20/0x50
[  313.314015]  [<ffffffff8106d856>] process_one_work+0x146/0x410
[  313.314015]  [<ffffffff8106deb1>] worker_thread+0x61/0x490
[  313.314015]  [<ffffffff8106de50>] ? rescuer_thread+0x330/0x330
[  313.314015]  [<ffffffff8106de50>] ? rescuer_thread+0x330/0x330
[  313.314015]  [<ffffffff81072c06>] kthread+0xd6/0xf0
[  313.314015]  [<ffffffff8173ae8f>] ret_from_fork+0x1f/0x40
[  313.314015]  [<ffffffff81072b30>] ? kthread_park+0x50/0x50
[  313.314015] Code: c4 20 02 00 00 e8 b1 b2 d1 ff 4d 39 ec 0f 84 82
00 00 00 4c 89 e3 49 03 9e a0 00 00 00 48 8b 83 18 02 00 00 48 8b 93
10 02 00 00 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 48 89
83 10
[  313.314015] RIP  [<ffffffff81453500>]
nvmet_rdma_free_rsps+0x80/0x110
[  313.314015]  RSP <ffff88007c753db8>

ver_linux
---------

Linux cgy1-donard 4.6.0+3-00004-ga573b70 #118 SMP Fri Jun 3 15:21:30
MDT 2016 x86_64 GNU/Linux

GNU C                   4.9.2
GNU Make                4.0
Binutils                2.25
Util-linux              2.25.2
Mount                   2.25.2
Linux C Library         2.19
Dynamic linker (ldd)    2.19
Procps                  3.3.9
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.23
Udev                    215
Modules Loaded          ablk_helper acpi_cpufreq aesni_intel
aes_x86_64 ahci ansi_cprng auth_rpcgss autofs4 binfmt_misc bridge
br_netfilter btrfs button configfs coretemp crc32c_intel cryptd cxgb4
dca dm_mod drbg edac_core ehci_hcd ehci_pci evdev ext4 fscache fuse
gf128mul ghash_clmulni_intel glue_helper grace hid hid_generic hmac
i2c_algo_bit i2c_core i2c_i801 ib_addr ib_cm ib_core ib_ipoib ib_mad
ib_sa ib_umad ib_uverbs igb ioatdma ipmi_devintf ipmi_msghandler
ipmi_poweroff ipmi_si ipmi_watchdog iptable_filter iptable_nat
ip_tables ipt_MASQUERADE irqbypass isci iTCO_vendor_support iTCO_wdt
iw_cm iw_cxgb4 jbd2 joydev kvm kvm_intel libahci libata libnvdimm
libsas llc lockd loop lpc_ich lrw mbcache md_mod mfd_core mlx4_core
mlx4_ib mlx5_core mlx5_ib msr nd_btt nd_e820 nd_pmem nf_conntrack
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat nf_nat_ipv4
nf_nat_masquerade_ipv4 nfs nfs_acl nfsd nvme nvme_core ohci_hcd
oid_registry overlay pcspkr pps_core processor psmouse ptp raid6_pq
rdma_cm rdma_ucm sb_edac scsi_mod scsi_transport_sas sd_mod serio_raw
sg sha256_generic shpchp stp sunrpc tpm tpm_tis tun uhci_hcd
usb_common usbcore usbhid wmi x86_pkg_temp_thermal xhci_hcd xor
x_tables xt_addrtype xt_conntrack


Cheers

Stephen
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
