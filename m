From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: crash on device removal
Date: Tue, 12 Jul 2016 11:34:54 -0500
Message-ID: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Christoph, 

I see a crash when shutting down a nvme host node via 'reboot' that has 1 target
device attached.  The shutdown causes iw_cxgb4 to be removed which triggers the
device removal logic in the nvmf rdma transport.  The crash is here:

(gdb) list *nvme_rdma_free_qe+0x18
0x1e8 is in nvme_rdma_free_qe (drivers/nvme/host/rdma.c:196).
191     }
192
193     static void nvme_rdma_free_qe(struct ib_device *ibdev, struct
nvme_rdma_qe *qe,
194                     size_t capsule_size, enum dma_data_direction dir)
195     {
196             ib_dma_unmap_single(ibdev, qe->dma, capsule_size, dir);
197             kfree(qe->data);
198     }
199
200     static int nvme_rdma_alloc_qe(struct ib_device *ibdev, struct
nvme_rdma_qe *qe,

Apparently qe is NULL.

Looking at the device removal path, the logic appears correct (see
nvme_rdma_device_unplug() and the nice function comment :) ).  I'm wondering if
concurrently to the host device removal path cleaning up queues, the target is
disconnecting all of its queues due to the first disconnect event from the host
causing some cleanup race on the host side?  Although since the removal path
executing in the cma event handler upcall, I don't think another thread would be
handling a disconnect event.  Maybe the qp async event handler flow?

Thoughts?

Here is the Oops:

[  710.929451] iw_cxgb4:0000:83:00.4: Detach
[  711.242989] iw_cxgb4:0000:82:00.4: Detach
[  711.247039] nvme nvme1: Got rdma device removal event, deleting ctrl
[  711.298244] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[  711.306162] IP: [<ffffffffa039a1e8>] nvme_rdma_free_qe+0x18/0x80 [nvme_rdma]
[  711.313286] PGD 0
[  711.315348] Oops: 0000 [#1] SMP
[  711.318519] Modules linked in: nvme_rdma nvme_fabrics brd iw_cxgb4 cxgb4
ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM
iptable_mangle iptable_filter ip_tables bridge 8021q mrp garp stp llc cachefiles
fscache rdma_ucm rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad ocrdma be2net
iw_nes libcrc32c iw_cxgb3 cxgb3 mdio ib_qib rdmavt mlx5_ib mlx5_core mlx4_en
ib_mthca binfmt_misc dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan
vhost tun kvm irqbypass uinput iTCO_wdt iTCO_vendor_support mxm_wmi pcspkr
mlx4_ib ib_core mlx4_core dm_mod i2c_i801 sg ipmi_ssif ipmi_si ipmi_msghandler
nvme nvme_core lpc_ich mfd_core mei_me mei igb dca ptp pps_core wmi ext4(E)
mbcache(E) jbd2(E) sd_mod(E) ahci(E) libahci(E) libata(E) mgag200(E) ttm(E)
drm_kms_helper(E) drm(E) fb_sys_fops(E) sysimgblt(E) sysfillrect(E)
syscopyarea(E) i2c_algo_bit(E) i2c_core(E) [last unloaded: cxgb4]
[  711.412158] CPU: 0 PID: 4213 Comm: reboot Tainted: G            E
4.7.0-rc2-block-for-next+ #77
[  711.421064] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
[  711.428058] task: ffff881033b495c0 ti: ffff88100fc24000 task.ti:
ffff88100fc24000
[  711.435563] RIP: 0010:[<ffffffffa039a1e8>]  [<ffffffffa039a1e8>]
nvme_rdma_free_qe+0x18/0x80 [nvme_rdma]
[  711.445104] RSP: 0018:ffff88100fc279a8  EFLAGS: 00010292
[  711.450442] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
[  711.457608] RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff881034168000
[  711.464775] RBP: ffff88100fc279b8 R08: 0000000000000001 R09: ffffea0001e51d10
[  711.471943] R10: ffffea0001e51d18 R11: 0000000000000000 R12: 0000000000000000
[  711.479112] R13: 0000000000000020 R14: ffff881034168000 R15: ffff8810345b8140
[  711.486285] FS:  00007feac7042700(0000) GS:ffff88103ee00000(0000)
knlGS:0000000000000000
[  711.494405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  711.500175] CR2: 0000000000000010 CR3: 00000010229d7000 CR4: 00000000000406f0
[  711.507341] Stack:
[  711.509367]  ffff881034285000 0000000000000001 ffff88100fc279f8
ffffffffa039adcf
[  711.516868]  ffff88100fc279d8 ffff881034285000 ffff881037f9f000
ffff881034272c00
[  711.524384]  ffff88100fc27b18 ffff881034272dd8 ffff88100fc27a88
ffffffffa039c8f5
[  711.531897] Call Trace:
[  711.534371]  [<ffffffffa039adcf>] nvme_rdma_destroy_queue_ib+0x5f/0x90
[nvme_rdma]
[  711.541972]  [<ffffffffa039c8f5>] nvme_rdma_cm_handler+0x2c5/0x340
[nvme_rdma]
[  711.549228]  [<ffffffff811ff71d>] ? kmem_cache_free+0x1dd/0x200
[  711.555177]  [<ffffffffa070e669>] ? cma_comp+0x49/0x60 [rdma_cm]
[  711.561217]  [<ffffffffa071310f>] cma_remove_id_dev+0x8f/0xa0 [rdma_cm]
[  711.567860]  [<ffffffffa07131d7>] cma_process_remove+0xb7/0x100 [rdma_cm]
[  711.574678]  [<ffffffff812a4de4>] ? __kernfs_remove+0x114/0x1d0
[  711.580626]  [<ffffffffa071325e>] cma_remove_one+0x3e/0x60 [rdma_cm]
[  711.587015]  [<ffffffffa03b8ca0>] ib_unregister_device+0xb0/0x150 [ib_core]
[  711.595252]  [<ffffffffa0816034>] c4iw_unregister_device+0x64/0x90 [iw_cxgb4]
[  711.603648]  [<ffffffffa0809357>] c4iw_remove+0x27/0x60 [iw_cxgb4]
[  711.611069]  [<ffffffffa080a061>] c4iw_uld_state_change+0x111/0x250
[iw_cxgb4]
[  711.619532]  [<ffffffff816da18d>] ? _cond_resched+0x1d/0x30
[  711.626317]  [<ffffffff81371971>] ? list_del+0x11/0x40
[  711.632678]  [<ffffffffa07ce71a>] detach_ulds+0x4a/0xf0 [cxgb4]
[  711.639822]  [<ffffffffa07ce94d>] remove_one+0x18d/0x1b0 [cxgb4]
[  711.647060]  [<ffffffff81397c21>] pci_device_shutdown+0x41/0x90
[  711.654189]  [<ffffffff814861f5>] device_shutdown+0x45/0x1b0
[  711.661051]  [<ffffffff810ac746>] kernel_restart_prepare+0x36/0x40
[  711.668414]  [<ffffffff810ac8c6>] kernel_restart+0x16/0x60
[  711.675084]  [<ffffffff810acb15>] SYSC_reboot+0x1a5/0x230
[  711.681645]  [<ffffffff81245ad1>] ? mntput+0x21/0x30
[  711.687738]  [<ffffffff812267a7>] ? __fput+0x177/0x240
[  711.693964]  [<ffffffff8122691e>] ? ____fput+0xe/0x10
[  711.700097]  [<ffffffff81003476>] ? do_audit_syscall_entry+0x66/0x70
[  711.707481]  [<ffffffff81003578>] ? syscall_trace_enter_phase1+0xf8/0x120
[  711.715273]  [<ffffffff81003344>] ? exit_to_usermode_loop+0x74/0xf0
[  711.722514]  [<ffffffff810acbae>] SyS_reboot+0xe/0x10
[  711.728517]  [<ffffffff81003f08>] do_syscall_64+0x78/0x1d0
[  711.734931]  [<ffffffff8106e327>] ? do_page_fault+0x37/0x90
[  711.741410]  [<ffffffff816ddee1>] entry_SYSCALL64_slow_path+0x25/0x25
[  711.748731] Code: 01 00 00 c9 c3 0f 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55
48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 8b 87 f0 02 00 00 48 89 f3 <48> 8b 76
10 48 85 c0 74 13 ff 50 10 48 8b 7b 08 e8 93 4d e6 e0
[  711.770832] RIP  [<ffffffffa039a1e8>] nvme_rdma_free_qe+0x18/0x80 [nvme_rdma]
[  711.778904]  RSP <ffff88100fc279a8>
[  711.783290] CR2: 0000000000000010

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
