From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NULL pointer deref in k.o/for-4.5
Date: Wed, 6 Jan 2016 13:16:03 -0500
Message-ID: <C52C1CEA-9DC4-4594-9D7C-942C25116414@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Encountered the below just after booting my NFS/RDMA
server with 4.4.0-rc6-00011-g6948cb2 (k.o/for-4.5 plus
my NFS/RDMA for-4.5 patches). The system is up and
ping-able via eth0, but high-level networking (like sshd
and nfsd) does not work, and my ib0 i/f is missing.

This is an x86_64 system with one CX-3 Pro HCA.

All seems well with a stock v4.4-rc4 kernel.


Jan  6 12:44:13 klimt kernel: <mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver v2.2-1 (Feb 2014)
Jan  6 12:44:13 klimt kernel: <mlx4_ib> mlx4_ib_add: counter index 0 for port 1 allocated 0
Jan  6 12:44:13 klimt kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
Jan  6 12:44:13 klimt kernel: IP: [<ffffffff81652655>] __mutex_lock_slowpath+0x75/0x120
Jan  6 12:44:13 klimt kernel: PGD 853947067 PUD 8546cb067 PMD 0 
Jan  6 12:44:13 klimt kernel: Oops: 0002 [#1] SMP 
Jan  6 12:44:13 klimt kernel: Modules linked in: mlx4_ib(+) mlx4_en ib_sa ib_mad ib_core vxlan ip6_udp_tunnel udp_tunnel ib_addr sr_mod cdrom sd_mod ast drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core igb ahci libahci libata ptp pps_core dca i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Jan  6 12:44:13 klimt kernel: CPU: 3 PID: 431 Comm: modprobe Not tainted 4.4.0-rc6-00011-g6948cb2 #79
Jan  6 12:44:13 klimt kernel: Hardware name: Supermicro Super Server/X10SRL-F, BIOS 1.0c 09/09/2015
Jan  6 12:44:13 klimt kernel: task: ffff88085571aa80 ti: ffff88084f414000 task.ti: ffff88084f414000
Jan  6 12:44:13 klimt kernel: RIP: 0010:[<ffffffff81652655>]  [<ffffffff81652655>] __mutex_lock_slowpath+0x75/0x120
Jan  6 12:44:13 klimt kernel: RSP: 0018:ffff88084f417810  EFLAGS: 00010282
Jan  6 12:44:13 klimt kernel: RAX: 0000000000000000 RBX: ffff88084f633950 RCX: ffff88085571aa80
Jan  6 12:44:13 klimt kernel: RDX: 0000000000000001 RSI: ffff88085571aae0 RDI: ffff88084f633954
Jan  6 12:44:13 klimt kernel: RBP: ffff88084f417858 R08: 0000000000000101 R09: ffff880854f02f00
Jan  6 12:44:13 klimt kernel: R10: ffffffffa0150a85 R11: ffffea002156d400 R12: ffff88084f633954
Jan  6 12:44:13 klimt kernel: R13: ffff88085571aa80 R14: 00000000ffffffff R15: ffff88084f633958
Jan  6 12:44:13 klimt kernel: FS:  00007f32227c0740(0000) GS:ffff88087fcc0000(0000) knlGS:0000000000000000
Jan  6 12:44:13 klimt kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan  6 12:44:13 klimt kernel: CR2: 0000000000000000 CR3: 0000000853cb6000 CR4: 00000000001406e0
Jan  6 12:44:13 klimt kernel: Stack:
Jan  6 12:44:13 klimt kernel: ffff88084f633958 0000000000000000 ffffffff81309502 000000003b473ac0
Jan  6 12:44:13 klimt kernel: ffff88084f633950 ffff88084f417888 ffff88084f633940 ffff88084f633950
Jan  6 12:44:13 klimt kernel: ffff88084f630000 ffff88084f417870 ffffffff8165271f ffff88084f630000
Jan  6 12:44:13 klimt kernel: Call Trace:
Jan  6 12:44:13 klimt kernel: [<ffffffff81309502>] ? get_from_free_list+0x42/0x50
Jan  6 12:44:13 klimt kernel: [<ffffffff8165271f>] mutex_lock+0x1f/0x2f
Jan  6 12:44:13 klimt kernel: [<ffffffffa02d7af7>] iboe_process_mad.isra.13+0x77/0x190 [mlx4_ib]
Jan  6 12:44:13 klimt kernel: [<ffffffffa02da3a4>] mlx4_ib_process_mad+0x4d4/0x550 [mlx4_ib]
Jan  6 12:44:13 klimt kernel: [<ffffffff8126256a>] ? kernfs_next_descendant_post+0x1a/0x50
Jan  6 12:44:13 klimt kernel: [<ffffffff81263332>] ? kernfs_add_one+0x112/0x150
Jan  6 12:44:13 klimt kernel: [<ffffffff811cc46d>] ? kmem_cache_alloc_trace+0x3d/0x1d0
Jan  6 12:44:13 klimt kernel: [<ffffffffa0150a85>] ? get_perf_mad+0x85/0x160 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa0150aee>] get_perf_mad+0xee/0x160 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa0150b98>] get_counter_table+0x38/0x70 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffff811cc528>] ? kmem_cache_alloc_trace+0xf8/0x1d0
Jan  6 12:44:13 klimt kernel: [<ffffffffa0150dc2>] ? add_port+0xc2/0x450 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa0150e0f>] add_port+0x10f/0x450 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa0151238>] ib_device_register_sysfs+0xe8/0x160 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa0152280>] ib_register_device+0x320/0x500 [ib_core]
Jan  6 12:44:13 klimt kernel: [<ffffffff810cb13b>] ? vprintk_default+0x3b/0x40
Jan  6 12:44:13 klimt kernel: [<ffffffff8117080f>] ? printk+0x5d/0x74
Jan  6 12:44:13 klimt kernel: [<ffffffffa02dee69>] mlx4_ib_add+0xbb9/0xfe0 [mlx4_ib]
Jan  6 12:44:13 klimt kernel: [<ffffffffa023f000>] ? 0xffffffffa023f000
Jan  6 12:44:13 klimt kernel: [<ffffffffa0192f6f>] mlx4_add_device+0x3f/0xb0 [mlx4_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa023f000>] ? 0xffffffffa023f000
Jan  6 12:44:13 klimt kernel: [<ffffffffa01930b2>] mlx4_register_interface+0xd2/0x100 [mlx4_core]
Jan  6 12:44:13 klimt kernel: [<ffffffffa023f04c>] mlx4_ib_init+0x4c/0x1000 [mlx4_ib]
Jan  6 12:44:13 klimt kernel: [<ffffffff81002183>] do_one_initcall+0x113/0x1f0
Jan  6 12:44:13 klimt kernel: [<ffffffff811afdd7>] ? __vunmap+0xd7/0x100
Jan  6 12:44:13 klimt kernel: [<ffffffff811cc46d>] ? kmem_cache_alloc_trace+0x3d/0x1d0
Jan  6 12:44:13 klimt kernel: [<ffffffff811709c3>] ? do_init_module+0x27/0x1e8
Jan  6 12:44:13 klimt kernel: [<ffffffff811709fc>] do_init_module+0x60/0x1e8
Jan  6 12:44:13 klimt kernel: [<ffffffff810f7fb7>] load_module+0x12f7/0x1950
Jan  6 12:44:13 klimt kernel: [<ffffffff810f4020>] ? store_uevent+0x70/0x70
Jan  6 12:44:13 klimt kernel: [<ffffffff810f49d4>] ? copy_module_from_fd.isra.37+0xb4/0x160
Jan  6 12:44:13 klimt kernel: [<ffffffff810f881f>] SyS_finit_module+0x9f/0xd0
Jan  6 12:44:13 klimt kernel: [<ffffffff8165446e>] entry_SYSCALL_64_fastpath+0x12/0x71
Jan  6 12:44:13 klimt kernel: Code: 04 4c 89 e7 e8 9d 1a 00 00 8b 03 83 f8 01 74 25 48 8b 43 10 4c 8d 7b 08 48 89 63 10 41 be ff ff ff ff 4c 89 3c 24 48 89 44 24 08 <48> 89 20 4c 89 6c 24 10 eb 0b 31 c0 87 03 83 f8 01 75 d2 eb 57 
Jan  6 12:44:13 klimt kernel: RIP  [<ffffffff81652655>] __mutex_lock_slowpath+0x75/0x120
Jan  6 12:44:13 klimt kernel: RSP <ffff88084f417810>
Jan  6 12:44:13 klimt kernel: CR2: 0000000000000000
Jan  6 12:44:13 klimt kernel: ---[ end trace cea4b2a7abe96d8c ]---


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
