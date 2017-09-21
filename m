From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Thu, 21 Sep 2017 07:44:21 -0700
Message-ID: <20170921144421.GA15285@infradead.org>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1215229914.8516804.1505998051674.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adding linux-rdma, the dma mappings happen in the mlx4 driver

On Thu, Sep 21, 2017 at 08:47:31AM -0400, Yi Zhang wrote:
> Hi
> 
> With below steps, it's easy to reproduce this issue on host side, I cannot reproduce it on 4.13.
> So I guess it's one regression issue on 4.14.0-rc1, let me know if you need more info.
> 
> host side: 
> #connect the target
> 
> target side:
> #nvmetcli clear
> #sleep 90
> #nvmetcli restore /etc/rdma.json
> 
> Host side log:
> 
> [  184.318537] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
> [  184.502114] nvme nvme0: creating 40 I/O queues.
> [  185.017751] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
> [  191.303659] nvme nvme0: rescanning
> [  252.226387] nvme nvme0: Reconnecting in 10 seconds...
> [  262.389578] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  262.397084] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  262.403514] nvme nvme0: Failed reconnect attempt 1
> [  262.408875] nvme nvme0: Reconnecting in 10 seconds...
> [  272.616908] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  272.624408] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  272.630839] nvme nvme0: Failed reconnect attempt 2
> [  272.636230] nvme nvme0: Reconnecting in 10 seconds...
> [  282.856896] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  282.864398] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  282.870831] nvme nvme0: Failed reconnect attempt 3
> [  282.876232] nvme nvme0: Reconnecting in 10 seconds...
> [  293.116196] nvme nvme0: creating 40 I/O queues.
> [  293.209662] DMAR: ERROR: DMA PTE for vPFN 0xe0f59 already set (to 10369a9001 not 10115ed001)
> [  293.219117] ------------[ cut here ]------------
> [  293.224284] WARNING: CPU: 14 PID: 751 at drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
> [  293.234698] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore iTCO_wdt ipmi_si intel_rapl_perf iTCO_vendor_support ipmi_devintf dcdbas sg pcspkr ipmi_msghandler ioatdma mei_me mei dca shpchp lpc_ich acpi_pad acpi_power_meter wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c 
 mlx4_en sd_mod
> [  293.313884]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata i2c_core crc32c_intel devlink pps_core dm_mirror dm_region_hash dm_log dm_mod
> [  293.335583] CPU: 14 PID: 751 Comm: kworker/u369:7 Not tainted 4.14.0-rc1 #2
> [  293.343374] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
> [  293.351750] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
> [  293.359249] task: ffff881032ecdd00 task.stack: ffffc900084d8000
> [  293.365873] RIP: 0010:__domain_mapping+0x367/0x380
> [  293.371230] RSP: 0018:ffffc900084dbc60 EFLAGS: 00010202
> [  293.377075] RAX: 0000000000000004 RBX: 00000010115ed001 RCX: 0000000000000000
> [  293.385056] RDX: 0000000000000000 RSI: ffff88103e7ce038 RDI: ffff88103e7ce038
> [  293.393040] RBP: ffffc900084dbcc0 R08: 0000000000000000 R09: 0000000000000000
> [  293.401024] R10: 00000000000002f7 R11: 00000000010115ed R12: ffff88103b9e1ac8
> [  293.409744] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000000e0f59
> [  293.418456] FS:  0000000000000000(0000) GS:ffff88103e7c0000(0000) knlGS:0000000000000000
> [  293.428229] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  293.435391] CR2: 0000154ecabc9140 CR3: 0000001005709001 CR4: 00000000001606e0
> [  293.444112] Call Trace:
> [  293.447594]  __intel_map_single+0xeb/0x180
> [  293.452918]  intel_map_page+0x39/0x40
> [  293.457765]  mlx4_ib_alloc_mr+0x141/0x220 [mlx4_ib]
> [  293.463965]  ib_alloc_mr+0x26/0x50 [ib_core]
> [  293.469471]  nvme_rdma_reinit_request+0x3a/0x70 [nvme_rdma]
> [  293.476433]  ? nvme_rdma_free_ctrl+0xb0/0xb0 [nvme_rdma]
> [  293.483100]  blk_mq_reinit_tagset+0x5c/0x90
> [  293.488508]  nvme_rdma_configure_io_queues+0x211/0x290 [nvme_rdma]
> [  293.496152]  nvme_rdma_reconnect_ctrl_work+0x5b/0xd0 [nvme_rdma]
> [  293.503598]  process_one_work+0x149/0x360
> [  293.508815]  worker_thread+0x4d/0x3c0
> [  293.513638]  kthread+0x109/0x140
> [  293.517973]  ? rescuer_thread+0x380/0x380
> [  293.523176]  ? kthread_park+0x60/0x60
> [  293.527993]  ret_from_fork+0x25/0x30
> [  293.532705] Code: b2 aa 81 4c 89 5d a0 4c 89 4d a8 e8 87 e1 c0 ff 8b 05 fe 6e 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 6e 87 00 <0f> ff e9 b8 fd ff ff e8 8d c7 ba ff 0f 1f 00 66 2e 0f 1f 84 00 
> [  293.555293] ---[ end trace c324b9449c77b573 ]---
> [  293.562133] DMAR: ERROR: DMA PTE for vPFN 0xe0f59 already set (to 10369a9001 not 1002790001)
> [  293.572343] ------------[ cut here ]------------
> [  293.578288] WARNING: CPU: 14 PID: 751 at drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
> [  293.589473] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore iTCO_wdt ipmi_si intel_rapl_perf iTCO_vendor_support ipmi_devintf dcdbas sg pcspkr ipmi_msghandler ioatdma mei_me mei dca shpchp lpc_ich acpi_pad acpi_power_meter wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c 
 mlx4_en sd_mod
> [  293.674124]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata i2c_core crc32c_intel devlink pps_core dm_mirror dm_region_hash dm_log dm_mod
> [  293.697394] CPU: 14 PID: 751 Comm: kworker/u369:7 Tainted: G        W       4.14.0-rc1 #2
> [  293.707322] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
> [  293.716456] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
> [  293.724706] task: ffff881032ecdd00 task.stack: ffffc900084d8000
> [  293.732095] RIP: 0010:__domain_mapping+0x367/0x380
> [  293.738214] RSP: 0018:ffffc900084dbc60 EFLAGS: 00010206
> [  293.744810] RAX: 0000000000000003 RBX: 0000001002790001 RCX: 0000000000000000
> [  293.753541] RDX: 0000000000000000 RSI: ffff88103e7ce038 RDI: ffff88103e7ce038
> [  293.762280] RBP: ffffc900084dbcc0 R08: 0000000000000000 R09: 0000000000000000
> [  293.771011] R10: 00000000000003ff R11: 0000000001002790 R12: ffff88103b9e1ac8
> [  293.779752] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000000e0f59
> [  293.788487] FS:  0000000000000000(0000) GS:ffff88103e7c0000(0000) knlGS:0000000000000000
> [  293.798295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  293.805480] CR2: 0000154ecabc9140 CR3: 0000001005709001 CR4: 00000000001606e0
> [  293.814226] Call Trace:
> [  293.817726]  __intel_map_single+0xeb/0x180
> [  293.823058]  intel_map_page+0x39/0x40
> [  293.827906]  mlx4_ib_alloc_mr+0x141/0x220 [mlx4_ib]
> [  293.834112]  ib_alloc_mr+0x26/0x50 [ib_core]
> [  293.839640]  nvme_rdma_reinit_request+0x3a/0x70 [nvme_rdma]
> [  293.846628]  ? nvme_rdma_free_ctrl+0xb0/0xb0 [nvme_rdma]
> [  293.853322]  blk_mq_reinit_tagset+0x5c/0x90
> [  293.858757]  nvme_rdma_configure_io_queues+0x211/0x290 [nvme_rdma]
> [  293.866429]  nvme_rdma_reconnect_ctrl_work+0x5b/0xd0 [nvme_rdma]
> [  293.873891]  process_one_work+0x149/0x360
> [  293.879132]  worker_thread+0x4d/0x3c0
> [  293.883979]  kthread+0x109/0x140
> [  293.888336]  ? rescuer_thread+0x380/0x380
> [  293.893554]  ? kthread_park+0x60/0x60
> [  293.898399]  ret_from_fork+0x25/0x30
> [  293.903139] Code: b2 aa 81 4c 89 5d a0 4c 89 4d a8 e8 87 e1 c0 ff 8b 05 fe 6e 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 6e 87 00 <0f> ff e9 b8 fd ff ff e8 8d c7 ba ff 0f 1f 00 66 2e 0f 1f 84 00 
> [  293.925798] ---[ end trace c324b9449c77b574 ]---
> [  294.460186] nvme nvme0: Successfully reconnected
> [  294.460243] nvme nvme0: MEMREG for CQE 0xffff88100663a640 failed with status memory management operation error (6)
> [  325.850105] general protection fault: 0000 [#1] SMP
> [  325.856354] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore iTCO_wdt ipmi_si intel_rapl_perf iTCO_vendor_support ipmi_devintf dcdbas sg pcspkr ipmi_msghandler ioatdma mei_me mei dca shpchp lpc_ich acpi_pad acpi_power_meter wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c 
 mlx4_en sd_mod
> [  325.940982]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata i2c_core crc32c_intel devlink pps_core dm_mirror dm_region_hash dm_log dm_mod
> [  325.964245] CPU: 22 PID: 3707 Comm: git Tainted: G        W       4.14.0-rc1 #2
> [  325.973198] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
> [  325.982332] task: ffff881036451740 task.stack: ffffc90009368000
> [  325.989746] RIP: 0010:xfs_attr_shortform_getvalue+0x25/0x120 [xfs]
> [  325.997412] RSP: 0018:ffffc9000936b920 EFLAGS: 00010282
> [  326.004006] RAX: 63656a626f3a755f RBX: ffffc9000936b980 RCX: ffffc9000936b980
> [  326.012738] RDX: 0000000001000000 RSI: ffffc9000936b980 RDI: ffffc9000936b980
> [  326.021465] RBP: ffffc9000936b958 R08: ffffffff81a740c0 R09: 0000000000000000
> [  326.030194] R10: 0000000000000008 R11: ffff881002f52700 R12: ffffc9000936ba54
> [  326.038913] R13: ffff882023b9fc00 R14: 0000000000000000 R15: 0000000000000008
> [  326.047642] FS:  000014c3de00e740(0000) GS:ffff88103e8c0000(0000) knlGS:0000000000000000
> [  326.057445] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  326.064627] CR2: 00000000007b7d44 CR3: 000000018b0cb005 CR4: 00000000001606e0
> [  326.073370] Call Trace:
> [  326.076885]  xfs_attr_get_ilocked+0x63/0x70 [xfs]
> [  326.082917]  xfs_attr_get+0xca/0x120 [xfs]
> [  326.088269]  xfs_xattr_get+0x4c/0x70 [xfs]
> [  326.093592]  __vfs_getxattr+0x57/0x70
> [  326.098428]  inode_doinit_with_dentry+0x33c/0x580
> [  326.104430]  selinux_d_instantiate+0x1c/0x20
> [  326.109947]  security_d_instantiate+0x32/0x50
> [  326.115558]  d_splice_alias+0x4c/0x370
> [  326.120505]  xfs_vn_lookup+0x87/0xb0 [xfs]
> [  326.125819]  lookup_slow+0xa2/0x160
> [  326.130448]  walk_component+0x160/0x250
> [  326.135461]  ? legitimize_path.isra.33+0x2e/0x60
> [  326.141346]  path_lookupat+0x79/0x210
> [  326.146162]  ? cpumask_any_but+0x31/0x40
> [  326.151267]  filename_lookup+0xaf/0x190
> [  326.156276]  ? kmem_cache_alloc+0x9c/0x1b0
> [  326.161576]  ? getname_flags+0x4f/0x1f0
> [  326.166583]  ? getname_flags+0x6f/0x1f0
> [  326.171586]  user_path_at_empty+0x36/0x40
> [  326.176768]  vfs_statx+0x77/0xe0
> [  326.181058]  SYSC_newlstat+0x3d/0x70
> [  326.185726]  ? __audit_syscall_entry+0xaf/0x100
> [  326.191463]  ? syscall_trace_enter+0x1d0/0x2b0
> [  326.197090]  ? __audit_syscall_exit+0x209/0x290
> [  326.202799]  SyS_newlstat+0xe/0x10
> [  326.207226]  do_syscall_64+0x67/0x180
> [  326.211926]  entry_SYSCALL64_slow_path+0x25/0x25
> [  326.217674] RIP: 0033:0x14c3dd4961a5
> [  326.222237] RSP: 002b:00007fff730b3478 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
> [  326.231250] RAX: ffffffffffffffda RBX: 0000000000ca3c50 RCX: 000014c3dd4961a5
> [  326.239774] RDX: 00007fff730b3530 RSI: 00007fff730b3530 RDI: 0000000000ca3ca0
> [  326.248281] RBP: 0000000000ca3ca0 R08: 0000000000000000 R09: 0000000000000000
> [  326.256770] R10: 0000000000000001 R11: 0000000000000246 R12: 00007fff730b3530
> [  326.265239] R13: 0000000000000000 R14: 0000000000000170 R15: 00007fff730b3530
> [  326.273684] Code: 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f9 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 10 48 8b 47 38 48 8b 40 38 48 8b 40 18 <44> 0f b6 70 02 48 8d 58 04 b8 c3 ff ff ff 45 85 f6 0f 84 82 00 
> [  326.295785] RIP: xfs_attr_shortform_getvalue+0x25/0x120 [xfs] RSP: ffffc9000936b920
> [  326.304910] ---[ end trace c324b9449c77b575 ]---
> [  326.362863] Kernel panic - not syncing: Fatal exception
> [  326.362964] Kernel Offset: disabled
> [  326.427058] ---[ end Kernel panic - not syncing: Fatal exception
> 
> 
> Best Regards,
>   Yi Zhang
> 
> 
> 
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
---end quoted text---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
