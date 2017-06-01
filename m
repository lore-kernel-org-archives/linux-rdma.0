From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/SA: Fix kernel panic in CMA request handler
 flow
Date: Thu, 01 Jun 2017 18:29:00 -0400
Message-ID: <1496356140.7171.70.camel@redhat.com>
References: <20170521160954.20311-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170521160954.20311-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-05-21 at 19:09 +0300, Leon Romanovsky wrote:
> Commit 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and
> ROCE specific fields") moved the service_id to be specific attribute
> for IB and OPA SA Path Record, and thus wasn't assigned for RoCE.
> 
> This caused to the following kernel panic in the CMA request handler
> flow:
> 
> [   27.074594] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000008
> [   27.074731] IP: __radix_tree_lookup+0x1d/0xe0
> [   27.074782] PGD 1dadcb067
> [   27.074783] PUD 1dadc3067
> [   27.074821] PMD 0
> [   27.074855]
> [   27.074916] Oops: 0000 [#1] SMP
> [   27.074950] Modules linked in: netconsole nfsv3 nfs fscache
> rdma_ucm ib_ucm
> rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx4_en
> mlx4_ib ib_core
> mlx4_core sg crc32_pclmul crc32c_intel dm_mirror dm_region_hash
> dm_log dm_mod
> acpi_cpufreq ppdev serio_raw parport_pc i2c_piix4 parport
> virtio_balloon pcspkr
> ghash_clmulni_intel nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> uinput
> binfmt_misc ata_generic pata_acpi cirrus mlx5_core drm_kms_helper
> syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm drm ata_piix libata virtio_blk
> e1000
> virtio_pci ptp virtio_ring pps_core floppy i2c_core virtio [last
> unloaded:
> ipmi_msghandler]
> [   27.075252] CPU: 4 PID: 205 Comm: kworker/4:1 Not tainted 4.11.0-
> rc6+ #71
> [   27.075307] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
> [   27.075356] Workqueue: ib_cm cm_work_handler [ib_cm]
> [   27.075401] task: ffff88022e3b8000 task.stack: ffffc90001298000
> [   27.075449] RIP: 0010:__radix_tree_lookup+0x1d/0xe0
> [   27.075495] RSP: 0018:ffffc9000129bb98 EFLAGS: 00010292
> [   27.075546] RAX: ffff88022e990180 RBX: ffffc9000129bc10 RCX:
> 0000000000000000
> [   27.075600] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000
> [   27.075650] RBP: ffffc9000129bbc8 R08: ffffc9000129bad0 R09:
> 0000000000000002
> [   27.075700] R10: 0000000000000002 R11: 0000000000000000 R12:
> 0000000000000000
> [   27.075770] R13: 0000000000000000 R14: 0000000000000000 R15:
> 0000000000000000
> [   27.075823] FS:  0000000000000000(0000) GS:ffff880237300000(0000)
> knlGS:0000000000000000
> [   27.075879] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   27.075924] CR2: 0000000000000008 CR3: 0000000227bcd000 CR4:
> 00000000001406e0
> [   27.075979] Call Trace:
> [   27.076015]  radix_tree_lookup+0xd/0x10
> [   27.076055]  cma_ps_find+0x59/0x70 [rdma_cm]
> [   27.076097]  cma_id_from_event+0xd2/0x470 [rdma_cm]
> [   27.076144]  ? ib_init_ah_from_path+0x39a/0x590 [ib_core]
> [   27.076193]  cma_req_handler+0x25/0x480 [rdma_cm]
> [   27.076237]  cm_process_work+0x25/0x120 [ib_cm]
> [   27.076280]  ? cm_get_bth_pkey.isra.62+0x3c/0xa0 [ib_cm]
> [   27.076350]  cm_req_handler+0xb03/0xd40 [ib_cm]
> [   27.076430]  ? sched_clock_cpu+0x11/0xb0
> [   27.076478]  cm_work_handler+0x194/0x1588 [ib_cm]
> [   27.076525]  process_one_work+0x160/0x410
> [   27.076565]  worker_thread+0x137/0x4a0
> [   27.076614]  kthread+0x112/0x150
> [   27.076684]  ? max_active_store+0x60/0x60
> [   27.077642]  ? kthread_park+0x90/0x90
> [   27.078530]  ret_from_fork+0x2c/0x40
> 
> This patch moves it back to the common SA Path Record structure
> and removes the redundant setter and getter.
> 
> Tested on Connect-IB and Connect-X4 in Infiniband and RoCE
> respectively.
> 
> Fixes: 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and
> ROCE specific fields")
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
