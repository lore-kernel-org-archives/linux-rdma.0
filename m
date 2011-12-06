From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: crash unloading mlx4 in 3.2-rc3
Date: Tue, 6 Dec 2011 17:38:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373256536F5@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm in the process of debugging this, but I see the following crash in 3.2-rc3 when unloading the IB stack.  I'm unloading the drivers immediately after the system comes up after booting.

- Sean


Dec  5 18:23:34 cst-lin0 kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
Dec  5 18:23:34 cst-lin0 kernel: IP: [<ffffffff812455e4>] bitmap_clear+0xa4/0xd0
Dec  5 18:23:34 cst-lin0 kernel: PGD 333fae067 PUD 3341b9067 PMD 0 
Dec  5 18:23:34 cst-lin0 kernel: Oops: 0002 [#1] SMP 
Dec  5 18:23:34 cst-lin0 kernel: CPU 0 
Dec  5 18:23:34 cst-lin0 kernel: Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT bridge stp llc autofs4 nfs lockd fscache auth_rpcgss nfs_acl sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 xt_physdev iptable_filter ip_tables dm_mirror dm_region_hash dm_log kvm_intel kvm uinput serio_raw pcspkr sg i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support e1000e ioatdma dca i7core_edac edac_core mlx4_ib(-) ib_mad ib_core mlx4_en mlx4_core ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci dm_mod [last unloaded: microcode]
Dec  5 18:23:34 cst-lin0 kernel:
Dec  5 18:23:34 cst-lin0 kernel: Pid: 6883, comm: rmmod Not tainted 3.2.0-rc3 #1 Intel Corporation S5500HV/S5500HV
Dec  5 18:23:34 cst-lin0 kernel: RIP: 0010:[<ffffffff812455e4>]  [<ffffffff812455e4>] bitmap_clear+0xa4/0xd0
Dec  5 18:23:34 cst-lin0 kernel: RSP: 0018:ffff880335089de0  EFLAGS: 00010286
Dec  5 18:23:34 cst-lin0 kernel: RAX: 7fffffffffffffff RBX: ffff880334430940 RCX: 0000000000000001
Dec  5 18:23:34 cst-lin0 kernel: RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
Dec  5 18:23:34 cst-lin0 kernel: RBP: ffff880335089de8 R08: ffffffffffffffff R09: 0000000000000000
Dec  5 18:23:34 cst-lin0 kernel: R10: 00000000ffffffc0 R11: ffffffff81deb300 R12: 00000000ffffffff
Dec  5 18:23:34 cst-lin0 kernel: R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
Dec  5 18:23:34 cst-lin0 kernel: FS:  00007f65b2443700(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
Dec  5 18:23:34 cst-lin0 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec  5 18:23:34 cst-lin0 kernel: CR2: 0000000000000000 CR3: 0000000333a7b000 CR4: 00000000000006f0
Dec  5 18:23:34 cst-lin0 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  5 18:23:34 cst-lin0 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  5 18:23:34 cst-lin0 kernel: Process rmmod (pid: 6883, threadinfo ffff880335088000, task ffff880333e0d520)
Dec  5 18:23:34 cst-lin0 kernel: Stack:
Dec  5 18:23:34 cst-lin0 kernel: ffff880334430940 ffff880335089e18 ffffffffa00ed176 ffffc9001260c000
Dec  5 18:23:34 cst-lin0 kernel: 0000000000000001 ffff880334430000 ffff8801b4a68000 ffff880335089e28
Dec  5 18:23:34 cst-lin0 kernel: ffffffffa00ed1c3 ffff880335089e38 ffffffffa00f5ba5 ffff880335089e68
Dec  5 18:23:34 cst-lin0 kernel: Call Trace:
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa00ed176>] mlx4_bitmap_free_range+0x46/0x80 [mlx4_core]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa00ed1c3>] mlx4_bitmap_free+0x13/0x20 [mlx4_core]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa00f5ba5>] mlx4_counter_free+0x15/0x20 [mlx4_core]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa0127b82>] mlx4_ib_remove+0x82/0x120 [mlx4_ib]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa00f376d>] mlx4_remove_device+0x6d/0x80 [mlx4_core]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa00f3843>] mlx4_unregister_interface+0x43/0x80 [mlx4_core]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffffa012f448>] mlx4_ib_cleanup+0x10/0x1e [mlx4_ib]
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffff8109d370>] sys_delete_module+0x1a0/0x270
Dec  5 18:23:34 cst-lin0 kernel: [<ffffffff814e1382>] system_call_fastpath+0x16/0x1b
Dec  5 18:23:34 cst-lin0 kernel: Code: 7c df 08 48 c7 c0 ff ff ff ff c1 e1 06 41 29 ca 44 89 d1 85 c9 74 17 01 f2 49 c7 c0 ff ff ff ff f6 c2 3f 75 12 4c 21 c0 48 f7 d0 
Dec  5 18:23:34 cst-lin0 kernel: RIP  [<ffffffff812455e4>] bitmap_clear+0xa4/0xd0
Dec  5 18:23:34 cst-lin0 kernel: RSP <ffff880335089de0>
Dec  5 18:23:34 cst-lin0 kernel: CR2: 0000000000000000
Dec  5 18:23:34 cst-lin0 kernel: ---[ end trace 9f46d5b6f4fe8152 ]---
Dec  5 18:25:01 cst-lin0 abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Dec  5 18:25:01 cst-lin0 abrtd: Directory 'kerneloops-1323138301-5798-1' creation detected
Dec  5 18:25:01 cst-lin0 abrtd: New crash /var/spool/abrt/kerneloops-1323138301-5798-1, processing
Dec  5 18:25:02 cst-lin0 kernel: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
