From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Oops with mlx5/NFSoRDMA client with 4.7-rc5ish
Date: Thu, 30 Jun 2016 14:44:49 -0400
Message-ID: <94C521BC-7BB0-46B7-8597-F1BE10C8CB04@oracle.com>
References: <730f57aa-b1f6-c6da-4936-bebba1954ca7@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <730f57aa-b1f6-c6da-4936-bebba1954ca7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 30, 2016, at 2:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> This could easily be an mlx5 issue given that it starts with a DMAR
> error, but I would also hope that NFSoRDMA can manage to survive the
> DMAR error.

I'm afraid I don't know what a DMAR error is.

Those are happening in the forward path (send) and the
GPF happens on receive. Can you give me an idea what
the source code looks like around

  rpcrdma_reply_handler+0x18e/0xce0 ?


> Nothing fancy in this case, it's a plain NFSv3 mount over
> RDMA.  Client is mlx5, server in this case is using mlx4.  Activity was
> doing a build of a user space package over NFS.

I don't have any mlx5 here, so I can't make any statements
about whether NFS/RDMA works with those. I know there have
been several cases where mlx5 was advertising incorrect
device attr values to consumers, and NFS/RDMA has tripped
over that. No idea if we've zapped every issue there.

Probably the best thing to do is figure out what's going
on with the driver, and go from there.

And also, someday I should get an mlx5 device installed
in my client.


> [504616.657635] mlx5_ib0: can't use GFP_NOIO for QPs on device mlx5_2,
> using GFP_KERNEL
> [504616.728741] rpcrdma: connection to 172.31.0.254:20049 on mlx5_2,
> memreg 'frwr', 128 credits, 16 responders
> [504657.816589] DMAR: ERROR: DMA PTE for vPFN 0xe998a already set (to
> f820a2002 not f820a2002)
> [504657.825973] ------------[ cut here ]------------
> [504657.831273] WARNING: CPU: 13 PID: 111036 at
> drivers/iommu/intel-iommu.c:2248 __domain_mapping+0x4ef/0x510
> [504657.842106] Modules linked in: nfsv3 nfs fscache nfnetlink_queue
> nfnetlink_log nfnetlink bluetooth rfkill rpcsec_gss_krb5 sch_mqprio
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock 8021q garp mrp stp llc rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core ext4 jbd2 mbcache
> sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt
> ipmi_ssif iTCO_vendor_support ipmi_devintf mxm_wmi dcdbas lrw gf128mul
> glue_helper ablk_helper cryptd intel_cstate intel_rapl ioatdma mei_me
> ipmi_si pcspkr mei ipmi_msghandler lpc_ich dca shpchp wmi
> acpi_power_meter nfsd auth_rpcgss nfs_acl lockd sch_fq_codel grace
> sunrpc ip_tables xfs raid0 sd_mod mlx5_core mgag200 i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt tg3 fb_sys_fops ttm
> ahci libahci drm libata crc32c_intel ptp megaraid_sas pps_core fjes
> [504657.947721] CPU: 13 PID: 111036 Comm: cc1 Tainted: G        W
> 4.7.0-rc4-00053-g01ae141 #110
> [504657.957765] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
> 2.0.2 03/15/2016
> [504657.966431]  0000000000000206 000000003dba5356 ffff881c85527650
> ffffffff814e9337
> [504657.974845]  0000000000000000 0000000000000000 ffff881c85527690
> ffffffff810c44de
> [504657.983252]  000008c885527670 0000000f820a2002 0000000000000001
> 0000000000000001
> [504657.991659] Call Trace:
> [504657.994494]  [<ffffffff814e9337>] dump_stack+0xb7/0x100
> [504658.000456]  [<ffffffff810c44de>] __warn+0x15e/0x190
> [504658.006121]  [<ffffffff810c453d>] warn_slowpath_null+0x2d/0x40
> [504658.012738]  [<ffffffff816af89f>] __domain_mapping+0x4ef/0x510
> [504658.019365]  [<ffffffff816b2710>] intel_map_sg+0x150/0x320
> [504658.025603]  [<ffffffffc0af19d9>] frwr_op_map+0x4f9/0x620 [rpcrdma]
> [504658.032724]  [<ffffffffc0aeb26c>] rpcrdma_marshal_req+0x82c/0xd00
> [rpcrdma]
> [504658.040629]  [<ffffffffc0316da4>] ? xdr_reserve_space+0x24/0x190
> [sunrpc]
> [504658.048322]  [<ffffffffc0ae9468>] xprt_rdma_send_request+0x38/0x150
> [rpcrdma]
> [504658.056407]  [<ffffffffc02f8918>] xprt_transmit+0x88/0x4e0 [sunrpc]
> [504658.063519]  [<ffffffffc02f2c8d>] call_transmit+0x22d/0x3a0 [sunrpc]
> [504658.070729]  [<ffffffffc02f2a60>] ? call_decode+0x2f0/0x2f0 [sunrpc]
> [504658.077939]  [<ffffffffc02f2a60>] ? call_decode+0x2f0/0x2f0 [sunrpc]
> [504658.085149]  [<ffffffffc0303ebd>] __rpc_execute+0xbd/0x6b0 [sunrpc]
> [504658.092261]  [<ffffffffc0306ec1>] rpc_execute+0xc1/0x160 [sunrpc]
> [504658.099178]  [<ffffffffc02f4d2c>] rpc_run_task+0x1bc/0x220 [sunrpc]
> [504658.106292]  [<ffffffffc02f5090>] rpc_call_sync+0x60/0x110 [sunrpc]
> [504658.113404]  [<ffffffffc0a482d3>] nfs3_get_acl+0x203/0x760 [nfsv3]
> [504658.120419]  [<ffffffff813b247f>] get_acl+0xaf/0x190
> [504658.126083]  [<ffffffff813b26ef>] posix_acl_create+0x6f/0x280
> [504658.133489]  [<ffffffffc0a44564>] nfs3_proc_create+0xb4/0x420 [nfsv3]
> [504658.141636]  [<ffffffffc0e8235c>] nfs_create+0xbc/0x290 [nfs]
> [504658.149001]  [<ffffffffc0e885ad>] ? nfs_permission+0x2bd/0x340 [nfs]
> [504658.157040]  [<ffffffff813324ab>] lookup_open+0x72b/0x9d0
> [504658.163999]  [<ffffffff81334d8e>] do_last+0x79e/0xf70
> [504658.170554]  [<ffffffff8133561b>] path_openat+0xbb/0x530
> [504658.177393]  [<ffffffff81337c75>] do_filp_open+0xa5/0x140
> [504658.184326]  [<ffffffff8129b364>] ? __handle_mm_fault+0xcb4/0x10e0
> [504658.192125]  [<ffffffff8134d838>] ? __alloc_fd+0x68/0x2b0
> [504658.199032]  [<ffffffff8131b3d5>] do_sys_open+0x185/0x350
> [504658.205920]  [<ffffffff8131b5c6>] SyS_open+0x26/0x30
> [504658.212312]  [<ffffffff81aa4872>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [504658.220359] ---[ end trace 4aa2ed1c62d4d8b6 ]---
> [504658.795802] DMAR: ERROR: DMA PTE for vPFN 0xe7723 already set (to
> 1ca993f002 not 195eb2e002)
> [504658.806336] ------------[ cut here ]------------
> [504658.812328] WARNING: CPU: 7 PID: 111110 at
> drivers/iommu/intel-iommu.c:2248 __domain_mapping+0x4ef/0x510
> [504658.823701] Modules linked in: nfsv3 nfs fscache nfnetlink_queue
> nfnetlink_log nfnetlink bluetooth rfkill rpcsec_gss_krb5 sch_mqprio
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock 8021q garp mrp stp llc rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core ext4 jbd2 mbcache
> sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt
> ipmi_ssif iTCO_vendor_support ipmi_devintf mxm_wmi dcdbas lrw gf128mul
> glue_helper ablk_helper cryptd intel_cstate intel_rapl ioatdma mei_me
> ipmi_si pcspkr mei ipmi_msghandler lpc_ich dca shpchp wmi
> acpi_power_meter nfsd auth_rpcgss nfs_acl lockd sch_fq_codel grace
> sunrpc ip_tables xfs raid0 sd_mod mlx5_core mgag200 i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt tg3 fb_sys_fops ttm
> ahci libahci drm libata crc32c_intel ptp megaraid_sas pps_core fjes
> [504658.934648] CPU: 7 PID: 111110 Comm: make Tainted: G        W
> 4.7.0-rc4-00053-g01ae141 #110
> [504658.945384] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
> 2.0.2 03/15/2016
> [504658.954760]  0000000000000206 000000008173503a ffff880c802c3798
> ffffffff814e9337
> [504658.963888]  0000000000000000 0000000000000000 ffff880c802c37d8
> ffffffff810c44de
> [504658.973014]  000008c8802c37b8 000000195eb2e002 0000000000000001
> 0000000000000001
> [504658.982148] Call Trace:
> [504658.985718]  [<ffffffff814e9337>] dump_stack+0xb7/0x100
> [504658.992395]  [<ffffffff810c44de>] __warn+0x15e/0x190
> [504658.998777]  [<ffffffff810c453d>] warn_slowpath_null+0x2d/0x40
> [504659.006128]  [<ffffffff816af89f>] __domain_mapping+0x4ef/0x510
> [504659.013475]  [<ffffffff816b2710>] intel_map_sg+0x150/0x320
> [504659.020433]  [<ffffffffc0af19d9>] frwr_op_map+0x4f9/0x620 [rpcrdma]
> [504659.028262]  [<ffffffffc0aeb26c>] rpcrdma_marshal_req+0x82c/0xd00
> [rpcrdma]
> [504659.036871]  [<ffffffffc0ae9468>] xprt_rdma_send_request+0x38/0x150
> [rpcrdma]
> [504659.045688]  [<ffffffffc02f8918>] xprt_transmit+0x88/0x4e0 [sunrpc]
> [504659.053534]  [<ffffffffc02f2c8d>] call_transmit+0x22d/0x3a0 [sunrpc]
> [504659.061481]  [<ffffffffc02f2a60>] ? call_decode+0x2f0/0x2f0 [sunrpc]
> [504659.069425]  [<ffffffffc02f2a60>] ? call_decode+0x2f0/0x2f0 [sunrpc]
> [504659.077361]  [<ffffffffc0303ebd>] __rpc_execute+0xbd/0x6b0 [sunrpc]
> [504659.085197]  [<ffffffffc0306ec1>] rpc_execute+0xc1/0x160 [sunrpc]
> [504659.092845]  [<ffffffffc02f4d2c>] rpc_run_task+0x1bc/0x220 [sunrpc]
> [504659.100685]  [<ffffffffc02f5090>] rpc_call_sync+0x60/0x110 [sunrpc]
> [504659.108524]  [<ffffffffc0a427f2>]
> nfs3_rpc_wrapper.constprop.6+0xb2/0x120 [nfsv3]
> [504659.117731]  [<ffffffffc0a43887>] nfs3_proc_readdir+0xf7/0x1f0 [nfsv3]
> [504659.125877]  [<ffffffffc0e86d74>]
> nfs_readdir_xdr_to_array+0x2a4/0x5d0 [nfs]
> [504659.134596]  [<ffffffff812ff762>] ? memcg_check_events+0x32/0x2d0
> [504659.142250]  [<ffffffff81248bd2>] ?
> __add_to_page_cache_locked+0x282/0x520
> [504659.150782]  [<ffffffffc0e87bba>] nfs_readdir_filler+0x2a/0xd0 [nfs]
> [504659.158735]  [<ffffffff8124c12f>] do_read_cache_page+0x2cf/0x5b0
> [504659.166305]  [<ffffffffc0e87b90>] ? nfs_readdir+0xaf0/0xaf0 [nfs]
> [504659.173971]  [<ffffffff8124c461>] read_cache_page+0x21/0x30
> [504659.181056]  [<ffffffffc0e87378>] nfs_readdir+0x2d8/0xaf0 [nfs]
> [504659.188529]  [<ffffffffc0a47600>] ?
> nfs3_xdr_dec_read3res+0x1f0/0x1f0 [nfsv3]
> [504659.197368]  [<ffffffff8133c362>] iterate_dir+0x222/0x280
> [504659.204265]  [<ffffffff8133cb6c>] SyS_getdents+0xcc/0x1c0
> [504659.211155]  [<ffffffff8133c770>] ? filldir64+0x210/0x210
> [504659.218031]  [<ffffffff8109bd68>] ? do_page_fault+0x68/0x120
> [504659.225188]  [<ffffffff81aa4872>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [504659.233240] ---[ end trace 4aa2ed1c62d4d8b7 ]---
> [504659.239570] general protection fault: 0000 [#1] SMP
> [504659.245816] Modules linked in: nfsv3 nfs fscache nfnetlink_queue
> nfnetlink_log nfnetlink bluetooth rfkill rpcsec_gss_krb5 sch_mqprio
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock 8021q garp mrp stp llc rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core ext4 jbd2 mbcache
> sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt
> ipmi_ssif iTCO_vendor_support ipmi_devintf mxm_wmi dcdbas lrw gf128mul
> glue_helper ablk_helper cryptd intel_cstate intel_rapl ioatdma mei_me
> ipmi_si pcspkr mei ipmi_msghandler lpc_ich dca shpchp wmi
> acpi_power_meter nfsd auth_rpcgss nfs_acl lockd sch_fq_codel grace
> sunrpc ip_tables xfs raid0 sd_mod mlx5_core mgag200 i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt tg3 fb_sys_fops ttm
> ahci libahci drm libata crc32c_intel ptp megaraid_sas pps_core fjes
> [504659.357020] CPU: 5 PID: 91952 Comm: kworker/u517:2 Tainted: G
> W       4.7.0-rc4-00053-g01ae141 #110
> [504659.368629] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
> 2.0.2 03/15/2016
> [504659.378020] Workqueue: xprtrdma_receive rpcrdma_receive_worker [rpcrdma]
> [504659.386351] task: ffff881cf66bd000 ti: ffff88195f044000 task.ti:
> ffff88195f044000
> [504659.395547] RIP: 0010:[<ffffffffc0aeba2e>]  [<ffffffffc0aeba2e>]
> rpcrdma_reply_handler+0x18e/0xce0 [rpcrdma]
> [504659.407390] RSP: 0018:ffff88195f047d68  EFLAGS: 00010286
> [504659.414182] RAX: ffff881ca993f100 RBX: ffff881ca8880000 RCX:
> ffff881cf66bd000
> [504659.423022] RDX: ffff881cf7aca4b8 RSI: 0000000000000028 RDI:
> ffff881ca8880000
> [504659.431863] RBP: ffff88195f047e00 R08: 000000000000138a R09:
> 0000000000000029
> [504659.440703] R10: 0000000000000000 R11: 01000000db2b2a63 R12:
> ffff881cf229af00
> [504659.449543] R13: ffff881cc65a5000 R14: ffff881ca8880428 R15:
> ffff881cf7aca400
> [504659.458382] FS:  0000000000000000(0000) GS:ffff881d0a880000(0000)
> knlGS:0000000000000000
> [504659.468298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [504659.475591] CR2: 00002b301933391c CR3: 0000000002015000 CR4:
> 00000000001406e0
> [504659.484446] Stack:
> [504659.487576]  ffff881cf66bd080 ffff881d0a898eb8 0000000000000001
> ffff88195f047de8
> [504659.496786]  ffffffff8104092f ffff881d00000000 0000000500018e40
> ffff881cf66bd940
> [504659.506002]  ffff881d04ec1940 ffff881cf66bd080 d4e41a40859fdf10
> ffff881d0a898e40
> [504659.515215] Call Trace:
> [504659.518863]  [<ffffffff8104092f>] ? __switch_to+0x39f/0x8d0
> [504659.526011]  [<ffffffffc0aecbfa>] rpcrdma_receive_worker+0x1a/0x30
> [rpcrdma]
> [504659.534811]  [<ffffffff810ebdbd>] process_one_work+0x24d/0x660
> [504659.542252]  [<ffffffff810ecaae>] worker_thread+0x21e/0x7d0
> [504659.549397]  [<ffffffff810ec890>] ? kzalloc+0x30/0x30
> [504659.555978]  [<ffffffff810f4ec8>] kthread+0x118/0x150
> [504659.562532]  [<ffffffff81aa4a7f>] ret_from_fork+0x1f/0x40
> [504659.569466]  [<ffffffff810f4db0>] ? flush_kthread_worker+0xd0/0xd0
> [504659.577276] Code: b0 c6 01 00 01 41 8b b5 00 01 00 00 e8 bc b3 80 ff
> 48 85 c0 49 89 c7 0f 84 69 02 00 00 49 8b 87 c8 00 00 00 4c 8b 98 08 ff
> ff ff <49> 83 7b 30 00 4c 89 5d c0 0f 84 95 00 00 00 48 83 05 83 c6 01
> [504659.600726] RIP  [<ffffffffc0aeba2e>]
> rpcrdma_reply_handler+0x18e/0xce0 [rpcrdma]
> [504659.610043]  RSP <ffff88195f047d68>
> [504659.617978] ---[ end trace 4aa2ed1c62d4d8b8 ]---
> [504659.681561] Kernel panic - not syncing: Fatal exception in interrupt
> [504659.689794] Kernel Offset: disabled
> [504659.742431] ---[ end Kernel panic - not syncing: Fatal exception in
> interrupt
> [504659.751430] ------------[ cut here ]------------
> [504659.757607] WARNING: CPU: 5 PID: 91952 at arch/x86/kernel/smp.c:125
> native_smp_send_reschedule+0x5e/0x70
> [504659.769233] Modules linked in: nfsv3 nfs fscache nfnetlink_queue
> nfnetlink_log nfnetlink bluetooth rfkill rpcsec_gss_krb5 sch_mqprio
> target_core_user uio target_core_pscsi target_core_file
> target_core_iblock 8021q garp mrp stp llc rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core ext4 jbd2 mbcache
> sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt
> ipmi_ssif iTCO_vendor_support ipmi_devintf mxm_wmi dcdbas lrw gf128mul
> glue_helper ablk_helper cryptd intel_cstate intel_rapl ioatdma mei_me
> ipmi_si pcspkr mei ipmi_msghandler lpc_ich dca shpchp wmi
> acpi_power_meter nfsd auth_rpcgss nfs_acl lockd sch_fq_codel grace
> sunrpc ip_tables xfs raid0 sd_mod mlx5_core mgag200 i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt tg3 fb_sys_fops ttm
> ahci libahci drm libata crc32c_intel ptp megaraid_sas pps_core fjes
> [504659.882444] CPU: 5 PID: 91952 Comm: kworker/u517:2 Tainted: G      D
> W       4.7.0-rc4-00053-g01ae141 #110
> [504659.894280] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
> 2.0.2 03/15/2016
> [504659.903882] Workqueue: xprtrdma_receive rpcrdma_receive_worker [rpcrdma]
> [504659.912419]  0000000000000002 000000006be37cb4 ffff881d0a883c48
> ffffffff814e9337
> [504659.921760]  0000000000000000 0000000000000000 ffff881d0a883c88
> ffffffff810c44de
> [504659.931090]  0000007d00000000 ffff881cf5183000 0000000000000000
> ffff881cf518365c
> [504659.940407] Call Trace:
> [504659.944139]  <IRQ>  [<ffffffff814e9337>] dump_stack+0xb7/0x100
> [504659.951673]  [<ffffffff810c44de>] __warn+0x15e/0x190
> [504659.958227]  [<ffffffff810c453d>] warn_slowpath_null+0x2d/0x40
> [504659.965750]  [<ffffffff8107585e>] native_smp_send_reschedule+0x5e/0x70
> [504659.974050]  [<ffffffff81103c38>] try_to_wake_up+0x568/0x5e0
> [504659.981376]  [<ffffffff81103cca>] default_wake_function+0x1a/0x30
> [504659.989182]  [<ffffffff81126105>] __wake_up_common+0x65/0xc0
> [504659.996494]  [<ffffffff8112617b>] __wake_up_locked+0x1b/0x30
> [504660.003796]  [<ffffffff8138c0d7>] ep_poll_callback+0x107/0x2e0
> [504660.011283]  [<ffffffff81126105>] __wake_up_common+0x65/0xc0
> [504660.018569]  [<ffffffff81126579>] __wake_up+0x49/0x70
> [504660.025170]  [<ffffffff8114096b>] wake_up_klogd_work_func+0x5b/0x90
> [504660.033132]  [<ffffffff812156e1>] irq_work_run_list+0x81/0xe0
> [504660.040503]  [<ffffffff81179ac0>] ? tick_sched_do_timer+0xb0/0xb0
> [504660.048260]  [<ffffffff81215b40>] irq_work_tick+0x70/0x80
> [504660.055234]  [<ffffffff8116257c>] update_process_times+0x7c/0xb0
> [504660.062886]  [<ffffffff8117962e>] tick_sched_handle.isra.14+0x4e/0x70
> [504660.071017]  [<ffffffff81179b1d>] tick_sched_timer+0x5d/0xa0
> [504660.078283]  [<ffffffff81163915>] __hrtimer_run_queues+0x185/0x420
> [504660.086135]  [<ffffffff81163ea8>] hrtimer_interrupt+0xc8/0x250
> [504660.093600]  [<ffffffff81079a1d>] local_apic_timer_interrupt+0x3d/0x80
> [504660.101844]  [<ffffffff81aa745d>] smp_apic_timer_interrupt+0x6d/0x90
> [504660.109879]  [<ffffffff81aa551c>] apic_timer_interrupt+0x8c/0xa0
> [504660.117507]  <EOI>  [<ffffffff81244957>] ? panic+0x2e3/0x342
> [504660.124756]  [<ffffffff81244949>] ? panic+0x2d5/0x342
> [504660.131305]  [<ffffffff81046ddd>] oops_end+0x13d/0x140
> [504660.137948]  [<ffffffff8104754e>] die+0x6e/0xa0
> [504660.143902]  [<ffffffff8104331c>] do_general_protection+0x12c/0x200
> [504660.151799]  [<ffffffff81aa6a68>] general_protection+0x28/0x30
> [504660.159206]  [<ffffffffc0aeba2e>] ?
> rpcrdma_reply_handler+0x18e/0xce0 [rpcrdma]
> [504660.168263]  [<ffffffffc0aeba14>] ?
> rpcrdma_reply_handler+0x174/0xce0 [rpcrdma]
> [504660.177296]  [<ffffffff8104092f>] ? __switch_to+0x39f/0x8d0
> [504660.184371]  [<ffffffffc0aecbfa>] rpcrdma_receive_worker+0x1a/0x30
> [rpcrdma]
> [504660.193082]  [<ffffffff810ebdbd>] process_one_work+0x24d/0x660
> [504660.200413]  [<ffffffff810ecaae>] worker_thread+0x21e/0x7d0
> [504660.207431]  [<ffffffff810ec890>] ? kzalloc+0x30/0x30
> [504660.213843]  [<ffffffff810f4ec8>] kthread+0x118/0x150
> [504660.220222]  [<ffffffff81aa4a7f>] ret_from_fork+0x1f/0x40
> [504660.226974]  [<ffffffff810f4db0>] ? flush_kthread_worker+0xd0/0xd0
> [504660.234579] ---[ end trace 4aa2ed1c62d4d8b9 ]---
> 
> 
> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>              GPG KeyID: 0E572FDD
> 
> 

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
