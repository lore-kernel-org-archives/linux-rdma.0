From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: ib_uverbs: list corruption destroying a cq
Date: Wed, 26 Jul 2017 12:12:52 -0600
Message-ID: <CAANLjFp08BDmfmKH9LNj1PqAS0NpL-q0OT0gHdv3tHpnZonsTg@mail.gmail.com>
References: <00d301d30627$26b58d80$7420a880$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00d301d30627$26b58d80$7420a880$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 26, 2017 at 9:52 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> Hey all,
>
> The test group hit this during a heavy rdma stress test that sets up a few
> thousand connections, runs some IO, then tears down the connections.  It
> repeatedly does this.  After around 4 hours, they see the warning below.  Looks
> like the list pointer were from freed memory (poisoned)?    This is with
> linux-4.13-rc2.
>
> Has anyone else seen this?  I didn't find anything looking in recent posts...
>
> Thanks,
>
> Steve
>
> ---
>
> list_del corruption. prev->next should be ffff9514cf64be90, but was
> dead000000000100
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 27966 at lib/list_debug.c:53
> __list_del_entry_valid+0x83/0xa0
> Modules linked in: rdma_ucm iw_cxgb4 cxgb4 nfsv3 nfs_acl nfs fscache lockd grace
> rpcrdma sunrpc rdma_cm ib_cm iw_cm ib_uverbs ebtable_nat ebtables ipt_REJECT
> nf_reject _ipv4 xt_CHECKSUM bridge autofs4 target_core_iblock target_core_file
> target_core_pscsi target_core_mod configfs bnx2fc cnic uio fcoe libfcoe libfc
> 8021q garp scsi_tran sport_fc stp llc dm_mirror dm_region_hash dm_log vhost_net
> vhost tap tun kvm_intel kvm irqbypass uinput ppdev floppy parport_pc parport
> iTCO_wdt iTCO_vendor_support pc spkr serio_raw sg i2c_i801 lpc_ich mfd_core igb
> dca shpchp i5400_edac i5k_amb dm_mod(E) dax(E) ext4(E) jbd2(E) mbcache(E)
> sd_mod(E) pata_acpi(E) ata_generic(E) ata_pii x(E) ib_core(E) libcxgb(E) ipv6(E)
> crc_ccitt(E) ptp(E) pps_core(E) radeon(E) ttm(E) drm_kms_helper(E) drm(E)
> fb_sys_fops(E) sysimgblt(E)
>  sysfillrect(E) syscopyarea(E) i2c_algo_bit(E) i2c_core(E) [last unloaded:
> cxgb4]
> CPU: 3 PID: 27966 Comm: mbw Tainted: G            E   4.13.0-rc2 #1
> Hardware name: Supermicro X7DWU/X7DWU, BIOS 1.2c 11/19/2010
> task: ffff951450fb6780 task.stack: ffffa81588144000
> RIP: 0010:__list_del_entry_valid+0x83/0xa0
> RSP: 0000:ffffa81588147b38 EFLAGS: 00010092
> RAX: 0000000000000054 RBX: ffff9514731e4240 RCX: 0000000000000000
> RDX: ffff9514efd94880 RSI: ffff9514efd8cb68 RDI: ffff9514efd8cb68
> RBP: ffffa81588147b38 R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000000074 R11: 000000000000000f R12: ffff9514a230b000
> R13: ffff9514cf64be80 R14: ffff9514d19bab38 R15: ffff9514d19bab58
> FS:  000014e8e054d720(0000) GS:ffff9514efd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000006df4b0 CR3: 000000052dcb9000 CR4: 00000000000406e0
> Call Trace:
>  ib_uverbs_release_ucq+0x64/0x160 [ib_uverbs]
>  uverbs_free_cq+0x51/0x80 [ib_uverbs]
>  remove_commit_idr_uobject+0x22/0x50 [ib_uverbs]
>  ? uverbs_uobject_free+0x32/0x40 [ib_uverbs]
>  uverbs_cleanup_ucontext+0xe6/0x1a0 [ib_uverbs]
>  ib_uverbs_cleanup_ucontext+0x23/0x40 [ib_uverbs]
>  ib_uverbs_close+0x3c/0x120 [ib_uverbs]
>  __fput+0xc8/0x240
>  ____fput+0xe/0x10
>  task_work_run+0x68/0xa0
>  ? free_fs_struct+0x32/0x40
>  do_exit+0x16a/0x470
>  ? __getnstimeofday64+0x4d/0xf0
>  ? getnstimeofday64+0xe/0x20
>  ? __audit_syscall_entry+0xaa/0x100
>  do_group_exit+0x4e/0xc0
>  SyS_exit_group+0x17/0x20
>  do_syscall_64+0x55/0xd0
>  entry_SYSCALL64_slow_path+0x25/0x25
> RIP: 0033:0x3fe06acf38
> RSP: 002b:00007ffc10a6efd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000003fe098a838 RCX: 0000003fe06acf38
> RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff98
> R10: 0000003fe0991828 R11: 0000000000000246 R12: 0000003fe098a838
> R13: 00007ffc10a6f0d0 R14: 0000000000000000 R15: 0000000000000000
> Code: c0 c9 c3 48 89 fe 31 c0 48 c7 c7 78 17 a2 93 e8 78 a2 d9 ff 0f ff 31 c0 c9
> c3 48 89 fe 31 c0 48 c7 c7 38 17 a2 93 e8 61 a2 d9 ff <0f> ff 31 c0 c9 c3 48 89
> fe 31  c0 48 c7 c7 00 17 a2 93 e8 4a a2
> ---[ end trace 8aab4de4e7eb9238 ]---

We have hit a similar list error with iSER on the 4.9.x series kernel.
Not sure if they are related.

[174144.405626] ------------[ cut here ]------------
[174144.405635] WARNING: CPU: 11 PID: 11466 at lib/list_debug.c:62
__list_del_entry+0x82/0xd0
[174144.405636] list_del corruption. next->prev should be
ffff887ae67112b0, but was ffff887ae6701b68
[174144.405682] Modules linked in: ib_isert target_core_user uio
target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
ip_vs nf_conntrack macvlan bonding iptable_filter ib_iser rdma_ucm
ib_ucm ib_uverbs ib_umad ipmi_devintf sb_edac edac_core
x86_pkg_temp_thermal intel_powerclamp coretemp raid10 zfs(PO) iTCO_wdt
iTCO_vendor_support kvm_intel zunicode(PO) zavl(PO) kvm zcommon(PO)
znvpair(PO) spl(O) irqbypass pcspkr joydev i2c_i801 i2c_smbus sg
mei_me lpc_ich mei mfd_core ioatdma shpchp ipmi_si ipmi_msghandler
acpi_power_meter acpi_pad ip_tables xfs libcrc32c mlx4_en mlx4_ib
raid1 rdma_cm iw_cm ib_cm mlx5_ib ib_core sd_mod 8021q garp mrp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw
gf128mul glue_helper ablk_helper cryptd ast drm_kms_helper syscopyarea
sysfillrect sysimgblt
[174144.405690]  mlx5_core fb_sys_fops ttm mlx4_core drm ahci libahci
igb libata dca ptp pps_core i2c_algo_bit wmi sunrpc dm_mirror
dm_region_hash dm_log dm_mod
[174144.405692] CPU: 11 PID: 11466 Comm: kworker/11:2 Tainted: P
    O    4.9.32-5.el7.centos.x86_64 #1
[174144.405693] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
BIOS 1.1 08/03/2015
[174144.405701] Workqueue: target_completion target_complete_ok_work
[174144.405704]  ffffc90369e03d50 ffffffff8134fbdc ffffc90369e03da0
0000000000000000
[174144.405705]  ffffc90369e03d90 ffffffff81083501 0000003e00000246
ffff887ae67112a8
[174144.405707]  ffff887f658ca0c0 ffff887f7f2d8800 ffff887f7f2e3c00
ffff887ae67112b0
[174144.405708] Call Trace:
[174144.405715]  [<ffffffff8134fbdc>] dump_stack+0x63/0x87
[174144.405718]  [<ffffffff81083501>] __warn+0xd1/0xf0
[174144.405719]  [<ffffffff8108357f>] warn_slowpath_fmt+0x5f/0x80
[174144.405721]  [<ffffffff81515b59>] ? target_complete_ok_work+0x169/0x360
[174144.405723]  [<ffffffff8136f552>] __list_del_entry+0x82/0xd0
[174144.405726]  [<ffffffff8109d042>] process_one_work+0xe2/0x400
[174144.405727]  [<ffffffff8109d9a5>] worker_thread+0x125/0x4b0
[174144.405729]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
[174144.405730]  [<ffffffff8109d880>] ? rescuer_thread+0x380/0x380
[174144.405733]  [<ffffffff810a36b6>] kthread+0xe6/0x100
[174144.405735]  [<ffffffff810a35d0>] ? kthread_park+0x60/0x60
[174144.405738]  [<ffffffff8175aa55>] ret_from_fork+0x25/0x30
[174144.405739] ---[ end trace 131fc2a58d958f73 ]---
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
