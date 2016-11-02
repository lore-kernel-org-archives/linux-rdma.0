From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Wed, 2 Nov 2016 14:18:27 -0500
Message-ID: <01d601d2353d$e3d10810$ab731830$@opengridcomputing.com>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com> <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me> <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com> <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me> <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com> <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me> <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com> <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me> <024e01d23476$6668b890$333a29b0$@opengridcomputing.com> <3512b8bb-4d29-b90a-49e1-ebf1085c47d7@grimberg.me> <004701d2351a$d9e4ad70$8dae0850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004701d2351a$d9e4ad70$8dae0850$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> I'll also try and reproduce this on mlx4 to rule out
> iwarp and cxgb4 anomolies.

Running the same test over mlx4/roce, I hit a warning in list_debug, and then a
stuck CPU...

I see this a few times:

[  916.207157] ------------[ cut here ]------------
[  916.212455] WARNING: CPU: 1 PID: 5553 at lib/list_debug.c:33
__list_add+0xbe/0xd0
[  916.220670] list_add corruption. prev->next should be next
(ffffffffa0847070), but was           (null). (prev=ffff880833baaf20).
[  916.233852] Modules linked in: iw_cxgb4 cxgb4 nvmet_rdma nvmet null_blk brd
ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_dfrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM
iptable_mangle iptable_filter ip_tables bridge 8021q mrp garp stp llc
ipmi_devintf cachefiles fscache rdma_ucm rdma_cm iw_cm ib_ipoib ib_cm ib_uverb
ib_umad ocrdma be2net iw_nes libcrc32c iw_cxgb3 cxgb3 mdio ib_qib rdmavt mlx5_ib
mlx5_core mlx4_ib mlx4_en mlx4_core ib_mthca ib_core binfmt_misc dm_mirror
dm_region_hash dm_log vhost_net macvtap macvlan vhost tun kvmirqbypass uinput
iTCO_wdt iTCO_vendor_support mxm_wmi pcspkr dm_mod i2c_i801 i2c_smbus sg lpc_ich
mfd_core mei_me mei nvme nvme_core igb dca ptp pps_core ipmi_si ipmi_msghandler
wmi ext4(E) mbcache(E) jbd2(E) sd_mod(E)ahci(E) libahci(E) libata(E) mgag200(E)
ttm(E) drm_kms_helper(E) drm(E) fb_sys_fops(E) sysimgblt(E) sysfillrect(E)
syscopyarea(E) i2c_algo_bit(E) i2c_core(E) [last unloaded: cxgb4]
[  916.337427] CPU: 1 PID: 5553 Comm: kworker/1:15 Tainted: G            E
4.8.0+ #131
[  916.346192] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
[  916.354126] Workqueue: ib_cm cm_work_handler [ib_cm]
[  916.360096]  0000000000000000 ffff880817483968 ffffffff8135a817
ffffffff8137813e
[  916.368594]  ffff8808174839c8 ffff8808174839c8 0000000000000000
ffff8808174839b8
[  916.377112]  ffffffff81086dad 000000f002080020 0000002134f11400
ffff880834f11470
[  916.385642] Call Trace:
[  916.389181]  [<ffffffff8135a817>] dump_stack+0x67/0x90
[  916.395430]  [<ffffffff8137813e>] ? __list_add+0xbe/0xd0
[  916.401863]  [<ffffffff81086dad>] __warn+0xfd/0x120
[  916.407862]  [<ffffffff81086e89>] warn_slowpath_fmt+0x49/0x50
[  916.414741]  [<ffffffff8137813e>] __list_add+0xbe/0xd0
[  916.421034]  [<ffffffff816e0be6>] ? mutex_lock+0x16/0x40
[  916.427522]  [<ffffffffa0844d40>] nvmet_rdma_queue_connect+0x110/0x1a0
[nvmet_rdma]
[  916.436374]  [<ffffffffa0845430>] nvmet_rdma_cm_handler+0x100/0x1b0
[nvmet_rdma]
[  916.444998]  [<ffffffffa072e1d0>] cma_req_handler+0x200/0x300 [rdma_cm]
[  916.452847]  [<ffffffffa06f3937>] cm_process_work+0x27/0x100 [ib_cm]
[  916.460452]  [<ffffffffa06f61ea>] cm_req_handler+0x35a/0x540 [ib_cm]
[  916.468070]  [<ffffffffa06f641b>] cm_work_handler+0x4b/0xd0 [ib_cm]
[  916.475614]  [<ffffffff810a1483>] process_one_work+0x183/0x4d0
[  916.482751]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[  916.489539]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[  916.495985]  [<ffffffff810a211d>] worker_thread+0x16d/0x530
[  916.502892]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[  916.509730]  [<ffffffff810cb9b6>] ? __wake_up_common+0x56/0x90
[  916.516926]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[  916.524568]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[  916.531084]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[  916.538758]  [<ffffffff810a6c5c>] kthread+0xcc/0xf0
[  916.545053]  [<ffffffff810b1aae>] ? schedule_tail+0x1e/0xc0
[  916.552082]  [<ffffffff816e2eff>] ret_from_fork+0x1f/0x40
[  916.558935]  [<ffffffff810a6b90>] ? kthread_freezable_should_stop+0x70/0x70
[  916.567430] ---[ end trace a294c05aa08938f6 ]---

...

And then a cpu gets stuck:

[  988.672768] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
[kworker/1:12:5549]
[  988.681814] Modules linked in: iw_cxgb4 cxgb4 nvmet_rdma nvmet null_blk brd
ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_dfrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM
iptable_mangle iptable_filter ip_tables bridge 8021q mrp garp stp llc
ipmi_devintf cachefiles fscache rdma_ucm rdma_cm iw_cm ib_ipoib ib_cm ib_uverb
ib_umad ocrdma be2net iw_nes libcrc32c iw_cxgb3 cxgb3 mdio ib_qib rdmavt mlx5_ib
mlx5_core mlx4_ib mlx4_en mlx4_core ib_mthca ib_core binfmt_misc dm_mirror
dm_region_hash dm_log vhost_net macvtap macvlan vhost tun kvmirqbypass uinput
iTCO_wdt iTCO_vendor_support mxm_wmi pcspkr dm_mod i2c_i801 i2c_smbus sg lpc_ich
mfd_core mei_me mei nvme nvme_core igb dca ptp pps_core ipmi_si ipmi_msghandler
wmi ext4(E) mbcache(E) jbd2(E) sd_mod(E)ahci(E) libahci(E) libata(E) mgag200(E)
ttm(E) drm_kms_helper(E) drm(E) fb_sys_fops(E) sysimgblt(E) sysfillrect(E)
syscopyarea(E) i2c_algo_bit(E) i2c_core(E) [last unloaded: cxgb4]
[  988.786988] CPU: 1 PID: 5549 Comm: kworker/1:12 Tainted: G        W   EL
4.8.0+ #131
[  988.796023] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
[  988.804188] Workqueue: events nvmet_keep_alive_timer [nvmet]
[  988.811068] task: ffff880819328000 task.stack: ffff880819324000
[  988.818195] RIP: 0010:[<ffffffffa084361c>]  [<ffffffffa084361c>]
nvmet_rdma_delete_ctrl+0x3c/0xb0 [nvmet_rdma]
[  988.829434] RSP: 0018:ffff880819327c58  EFLAGS: 00000287
[  988.835946] RAX: ffff880834f11b20 RBX: ffff880834f11b20 RCX: 0000000000000000
[  988.844285] RDX: 0000000000000001 RSI: ffff88085fa58ae0 RDI: ffffffffa0847040
[  988.852626] RBP: ffff880819327c88 R08: ffff88085fa58ae0 R09: ffff880819327918
[  988.860968] R10: 0000000000000920 R11: 0000000000000001 R12: ffff880834f11a00
[  988.869310] R13: ffff88081a6a4800 R14: 0000000000000000 R15: ffff88085fa5d505
[  988.877655] FS:  0000000000000000(0000) GS:ffff88085fa40000(0000)
knlGS:0000000000000000
[  988.886955] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  988.893906] CR2: 00007f28fcc6e74b CR3: 0000000001c06000 CR4: 00000000000406e0
[  988.902246] Stack:
[  988.905457]  ffff880817fc6720 0000000000000002 000000000000000f
ffff88081a6a4800
[  988.914142]  ffff88085fa58ac0 ffff88085fa5d500 ffff880819327ca8
ffffffffa0830237
[  988.922825]  ffff88085fa58ac0 ffff8808584ce900 ffff880819327d88
ffffffff810a1483
[  988.931507] Call Trace:
[  988.935152]  [<ffffffffa0830237>] nvmet_keep_alive_timer+0x37/0x40 [nvmet]
[  988.943232]  [<ffffffff810a1483>] process_one_work+0x183/0x4d0
[  988.950273]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[  988.956963]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[  988.963299]  [<ffffffff8102eb34>] ? __switch_to+0x1e4/0x790
[  988.970070]  [<ffffffff810a211d>] worker_thread+0x16d/0x530
[  988.976848]  [<ffffffff816deda0>] ? __schedule+0x1f0/0x5b0
[  988.983541]  [<ffffffff810cb9b6>] ? __wake_up_common+0x56/0x90
[  988.990578]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[  988.998055]  [<ffffffff816df260>] ? schedule+0x40/0xb0
[  989.004394]  [<ffffffff810a1fb0>] ? maybe_create_worker+0x120/0x120
[  989.011861]  [<ffffffff810a6c5c>] kthread+0xcc/0xf0
[  989.017944]  [<ffffffff810b1aae>] ? schedule_tail+0x1e/0xc0
[  989.024728]  [<ffffffff816e2eff>] ret_from_fork+0x1f/0x40
[  989.031325]  [<ffffffff810a6b90>] ? kthread_freezable_should_stop+0x70/0x70
[  989.039488] Code: 90 49 89 fd 48 c7 c7 40 70 84 a0 e8 cf d5 e9 e0 48 8b 05 68
3a 00 00 48 3d 70 70 84 a0 4c 8d a0 e0 fe ff ff 48 89 c3 75 1c eb 55 <49> 8b 84
24 20 01 00 00 48 3d 70 70 84 a0 4c 8d a0 e0 fe ff ff



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
