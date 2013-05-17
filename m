From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: BUG: unable to handle kernel paging request at 0000000000070a78 IPoIB
Date: Fri, 17 May 2013 16:16:38 +0200
Message-ID: <51963BC6.1050901@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I've saw this before, anyone have suggestion how to fix this.

May 17 16:09:13 ib2 kernel: [  528.500381] BUG: unable to handle kernel
paging request at 0000000000070a78
May 17 16:09:13 ib2 kernel: [  528.500529] IP: [<ffffffffa0166810>]
ipoib_cm_tx_handler+0x30/0x2a0 [ib_ipoib]
May 17 16:09:13 ib2 kernel: [  528.500655] PGD 1f6b89067 PUD 20d41a067
PMD 0
May 17 16:09:13 ib2 kernel: [  528.500807] Oops: 0000 [#1] SMP
May 17 16:09:13 ib2 kernel: [  528.501056] ib0: failed to send RTU: -22
May 17 16:09:13 ib2 kernel: [  528.500927] Modules linked in:
ib_ipoib(O) rdma_ucm rdma_cm iw_cm ib_addr ib_cm ib_uverbs ib_umad
mlx4_ib ib_sa ib_mad ib_core ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables cpufreq_powersave
cpufreq_conservative cpufreq_stats cpufreq_userspace binfmt_misc fuse
loop acpi_cpufreq mperf kvm_amd kvm tpm_tis tpm psmouse edac_core
tpm_bios evdev serio_raw microcode edac_mce_amd processor shpchp
thermal_sys pci_hotplug asus_atk0110 i2c_piix4 button dm_multipath
scsi_dh mlx4_en sg sd_mod crc_t10dif r8169 mlx4_core ahci libahci libata
scsi_mod [last unloaded: ib_ipoib]
May 17 16:09:13 ib2 kernel: [  528.503008] CPU 2
May 17 16:09:13 ib2 kernel: [  528.503052] Pid: 58, comm: kworker/2:1
Tainted: G           O 3.9.0-rc7-pserver #4 System manufacturer System
Product Name/M4A89GTD-PRO
May 17 16:09:13 ib2 kernel: [  528.503183] RIP:
0010:[<ffffffffa0166810>]  [<ffffffffa0166810>]
ipoib_cm_tx_handler+0x30/0x2a0 [ib_ipoib]
May 17 16:09:13 ib2 kernel: [  528.503303] RSP: 0018:ffff88020e20dc68
EFLAGS: 00010293
May 17 16:09:13 ib2 kernel: [  528.503362] RAX: ffff88020e20dfd8 RBX:
ffff8801f5f19400 RCX: 0000000000000000
May 17 16:09:13 ib2 kernel: [  528.503425] RDX: 0000000000000003 RSI:
ffff8801f896e0e8 RDI: ffff8801f5f19400
May 17 16:09:13 ib2 kernel: [  528.503484] RBP: ffff88020e20dcb8 R08:
0000000000000000 R09: 0000000000000001
May 17 16:09:13 ib2 kernel: [  528.503544] R10: 0000000000000000 R11:
0000000000000000 R12: ffff8801f896e000
May 17 16:09:13 ib2 kernel: [  528.503603] R13: ffff88020d34d7e0 R14:
0000000000070a40 R15: ffff8801f896e0e8
May 17 16:09:13 ib2 kernel: [  528.503666] FS:  00007ff811ffb700(0000)
GS:ffff88021fc80000(0000) knlGS:0000000000000000
May 17 16:09:13 ib2 kernel: [  528.503777] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
May 17 16:09:13 ib2 kernel: [  528.503834] CR2: 0000000000070a78 CR3:
000000020cb73000 CR4: 00000000000007e0
May 17 16:09:13 ib2 kernel: [  528.503894] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 17 16:09:13 ib2 kernel: [  528.503954] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 17 16:09:13 ib2 kernel: [  528.504014] Process kworker/2:1 (pid: 58,
threadinfo ffff88020e20c000, task ffff88020e12df40)
May 17 16:09:13 ib2 kernel: [  528.504124] Stack:
May 17 16:09:13 ib2 kernel: [  528.504173]  0000000000000086
ffff88020d524860 ffff88020e20dc88 ffffffff810a891d
May 17 16:09:13 ib2 kernel: [  528.504366]  ffff88020e20dca8
ffff8801f5f19400 ffff8801f896e000 ffff8801f5f19470
May 17 16:09:13 ib2 kernel: [  528.504557]  ffff88020d561b00
0000000000000000 ffff88020e20dd08 ffffffffa00cbc75
May 17 16:09:13 ib2 kernel: [  528.504748] Call Trace:
May 17 16:09:13 ib2 kernel: [  528.504808]  [<ffffffff810a891d>] ?
trace_hardirqs_off+0xd/0x10
May 17 16:09:13 ib2 kernel: [  528.504875]  [<ffffffffa00cbc75>]
cm_process_work+0x25/0x120 [ib_cm]
May 17 16:09:13 ib2 kernel: [  528.504942]  [<ffffffffa00cec61>]
cm_work_handler+0x591/0xb40 [ib_cm]
May 17 16:09:13 ib2 kernel: [  528.505007]  [<ffffffff810677c6>]
process_one_work+0x1d6/0x560
May 17 16:09:13 ib2 kernel: [  528.505069]  [<ffffffff81067755>] ?
process_one_work+0x165/0x560
May 17 16:09:13 ib2 kernel: [  528.505132]  [<ffffffff81068e29>]
worker_thread+0x119/0x370
May 17 16:09:13 ib2 kernel: [  528.505193]  [<ffffffff81068d10>] ?
manage_workers+0x340/0x340
May 17 16:09:13 ib2 kernel: [  528.505257]  [<ffffffff8106e846>]
kthread+0xe6/0xf0
May 17 16:09:13 ib2 kernel: [  528.505319]  [<ffffffff8106e760>] ?
__init_kthread_worker+0x70/0x70
May 17 16:09:13 ib2 kernel: [  528.505383]  [<ffffffff817c842c>]
ret_from_fork+0x7c/0xb0
May 17 16:09:13 ib2 kernel: [  528.505444]  [<ffffffff8106e760>] ?
__init_kthread_worker+0x70/0x70
May 17 16:09:13 ib2 kernel: [  528.505502] Code: 57 41 56 41 55 41 54 53
48 83 ec 28 66 66 66 66 90 4c 8b 6f 08 8b 16 48 89 fb 49 89 f7 4d 8b 75
20 49 81 c6 40 0a 00 00 83 fa 0b <4d> 8b 66 38 77 2a 89 d0 ff 24 c5 60
ae 16 a0 90 44 8b 1d 31 7e
May 17 16:09:13 ib2 kernel: [  528.507522] RIP  [<ffffffffa0166810>]
ipoib_cm_tx_handler+0x30/0x2a0 [ib_ipoib]
May 17 16:09:13 ib2 kernel: [  528.507633]  RSP <ffff88020e20dc68>
May 17 16:09:13 ib2 kernel: [  528.507685] CR2: 0000000000070a78
May 17 16:09:13 ib2 kernel: [  528.507741] ---[ end trace
bcb226cccac815a8 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
