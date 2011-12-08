From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
Date: Thu, 8 Dec 2011 15:43:40 +0200
Message-ID: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all

We've hit a kernel panic running 3.1.1-2.fc16.x86_64 on Fedora 16 when
registering 144 buffers of 32 MB each.

We're using libibverbs-1.1.5-5.fc16.x86_64.

Any help would be appreciated. Would a firmware upgrade make a difference?

ibv_devinfo output:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.8.600
        node_guid:                      0002:c903:0010:df98
        sys_image_guid:                 0002:c903:0010:df9b
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xB0
        board_id:                       MT_0FC0110009
        phys_port_cnt:                  2

Regards

Albert

[  597.407974] ------------[ cut here ]------------
[  597.412843] kernel BUG at drivers/iommu/intel-iommu.c:1767!
[  597.418652] invalid opcode: 0000 [#1] SMP
[  597.423114] CPU 0
[  597.424993] Modules linked in: binfmt_misc ses enclosure mlx4_ib
mlx4_en microcode serio_raw joydev i2c_i801 iTCO_wdt
iTCO_vendor_support ioatdma igb mpt2sas mlx4_core scsi_transport_sas
raid_class i7core_edac edac_core dca w83795 w83627ehf hwmon_vid
coretemp adm1021 i2c_core ib_ipoib ib_cm ib_addr ib_sa ib_uverbs
ib_umad ib_mad ib_core ipmi_poweroff ipmi_watchdog ipmi_devintf
ipmi_si ipmi_msghandler [last unloaded: scsi_wait_scan]
[  597.467309]
[  597.469040] Pid: 3789, comm: flowrouter Not tainted
3.1.1-2.fc16.x86_64 #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
[  597.479379] RIP: 0010:[<ffffffff813c0542>]  [<ffffffff813c0542>]
__domain_mapping+0x41/0x251
[  597.488304] RSP: 0018:ffff8814ac599bf8  EFLAGS: 00010206
[  597.493849] RAX: 000000000fffffff RBX: ffff881674b93018 RCX: 0000000000000024
[  597.501210] RDX: ffff881674b93018 RSI: ffffffffffffff80 RDI: ffff88178dc04e00
[  597.508575] RBP: ffff8814ac599c68 R08: 000000000000007f R09: 0000000000000003
[  597.515936] R10: 00000000000162b7 R11: 0000000000016268 R12: ffff881674b93018
[  597.523297] R13: 000000000000007f R14: ffffffffffffff80 R15: 000000000000007f
[  597.530663] FS:  00007f6e3cb67700(0000) GS:ffff8817dfc00000(0000)
knlGS:0000000000000000
[  597.539170] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  597.545154] CR2: 00007f6e34003038 CR3: 0000002e4b14f000 CR4: 00000000000006f0
[  597.552510] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  597.559870] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  597.567230] Process flowrouter (pid: 3789, threadinfo
ffff8814ac598000, task ffff88168c82c590)
[  597.576263] Stack:
[  597.578513]  ffff88168c82c590 000000000000007f ffff88178dc04e00
ffff88178dc04e00
[  597.586585]  0000fffffffff000 000000000000007f 0000000000000000
ffffffffffffff80
[  597.594647]  000000000000007f ffff881674b93018 ffff88178dc04e00
000000000000007f
[  597.602700] Call Trace:
[  597.605387]  [<ffffffff813c1bef>] intel_map_sg+0x15c/0x1d6
[  597.611108]  [<ffffffffa003bbe6>] ib_umem_get+0x317/0x42d [ib_core]
[  597.617612]  [<ffffffffa0162305>] mlx4_ib_reg_user_mr+0x79/0x15b [mlx4_ib]
[  597.624710]  [<ffffffff81043ff3>] ? should_resched+0xe/0x2d
[  597.630512]  [<ffffffff814b5ad5>] ? _cond_resched+0xe/0x22
[  597.636232]  [<ffffffffa0062fe6>] ib_uverbs_reg_mr+0x144/0x29a [ib_uverbs]
[  597.643334]  [<ffffffffa00613c1>] ib_uverbs_write+0xb6/0xc1 [ib_uverbs]
[  597.650177]  [<ffffffff81129186>] vfs_write+0xac/0xf3
[  597.655463]  [<ffffffff81129375>] sys_write+0x4a/0x6e
[  597.660744]  [<ffffffff814bd902>] system_call_fastpath+0x16/0x1b
[  597.666973] Code: 48 89 4d c0 48 89 7d a8 49 89 d4 6b 4f 4c 09 48
89 75 c8 4d 89 c7 83 c1 12 83 f9 3f 7f 0f 4a 8d 44 06 ff 48 d3 e8 48
85 c0 74 02 <0f> 0b 41 f6 c1 03 0f 84 e9 01 00 00 41 81 e1 03 08 00 00
45 31
[  597.690327] RIP  [<ffffffff813c0542>] __domain_mapping+0x41/0x251
[  597.696704]  RSP <ffff8814ac599bf8>
[  597.700601] ---[ end trace bd543b01b0d3c89e ]---
[  597.705549] ------------[ cut here ]------------
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
