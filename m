From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Sun, 24 Sep 2017 13:34:26 +0300
Message-ID: <20170924103426.GB25094@mtr-leonro.local>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e8aa9f2e-14b1-23f0-f672-07a913842c9d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 24, 2017 at 05:28:30PM +0800, Yi Zhang wrote:
>
> > Is it possible that ib_dereg_mr failed?
> >
> It seems not, and finally the system get panic, here is the log:

I looked on the issue during the weekend and didn't see any suspicious
commit in the mlx4 alloc/mapping area.

Can I ask you to perform git bisect to find the problematic change?

Added Tariq to the thread.

Thanks

>
> [  104.373784] nvme nvme0: new ctrl: NQN
> "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
> [  104.564001] nvme nvme0: creating 40 I/O queues.
> [  105.070022] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
> [  144.135070] nvme nvme0: rescanning
> [  204.383678] nvme nvme0: Reconnecting in 10 seconds...
> [  214.506489] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  214.513996] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  214.520426] nvme nvme0: Failed reconnect attempt 1
> [  214.525788] nvme nvme0: Reconnecting in 10 seconds...
> [  224.733962] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  224.741464] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  224.747898] nvme nvme0: Failed reconnect attempt 2
> [  224.753301] nvme nvme0: Reconnecting in 10 seconds...
> [  234.973834] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  234.981335] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  234.987768] nvme nvme0: Failed reconnect attempt 3
> [  234.993150] nvme nvme0: Reconnecting in 10 seconds...
> [  245.233395] nvme nvme0: creating 40 I/O queues.
> [  245.238480] DMAR: ERROR: DMA PTE for vPFN 0xe109b already set (to
> 10098cc002 not 103b85e003)
> [  245.247940] ------------[ cut here ]------------
> [  245.253110] WARNING: CPU: 38 PID: 6 at drivers/iommu/intel-iommu.c:2305
> __domain_mapping+0x367/0x380
> [  245.263329] Modules linked in: nvme_rdma nvme_fabrics nvme_core
> sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ibd
> [  245.342493]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata
> crc32c_intel i2c_core pps_core devlink dm_mirror dm_region_hash dmd
> [  245.364191] CPU: 38 PID: 6 Comm: kworker/u368:0 Not tainted 4.14.0-rc1+
> #7
> [  245.371880] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2
> 01/08/2016
> [  245.380265] Workqueue: ib_addr process_one_req [ib_core]
> [  245.386211] task: ffff88018cb245c0 task.stack: ffffc9000009c000
> [  245.392836] RIP: 0010:__domain_mapping+0x367/0x380
> [  245.398194] RSP: 0018:ffffc9000009fa98 EFLAGS: 00010202
> [  245.404039] RAX: 0000000000000004 RBX: 000000103b85e003 RCX:
> 0000000000000000
> [  245.412018] RDX: 0000000000000000 RSI: ffff88103eace038 RDI:
> ffff88103eace038
> [  245.420001] RBP: ffffc9000009faf8 R08: 0000000000000000 R09:
> 0000000000000000
> [  245.427983] R10: 00000000000002f7 R11: 000000000103b85e R12:
> ffff881009bc74d8
> [  245.436711] R13: 0000000000000001 R14: 0000000000000001 R15:
> 00000000000e109b
> [  245.445419] FS:  0000000000000000(0000) GS:ffff88103eac0000(0000)
> knlGS:0000000000000000
> [  245.455199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  245.462357] CR2: 000014940a9b7140 CR3: 00000010119b5000 CR4:
> 00000000001606e0
> [  245.471074] Call Trace:
> [  245.474549]  __intel_map_single+0xeb/0x180
> [  245.479868]  intel_alloc_coherent+0xb5/0x130
> [  245.485388]  mlx4_buf_alloc+0xe5/0x1c0 [mlx4_core]
> [  245.491482]  mlx4_ib_alloc_cq_buf.isra.9+0x38/0xd0 [mlx4_ib]
> [  245.498540]  mlx4_ib_create_cq+0x223/0x450 [mlx4_ib]
> [  245.504822]  ib_alloc_cq+0x49/0x170 [ib_core]
> [  245.510413]  nvme_rdma_cm_handler+0x3a2/0x7ab [nvme_rdma]
> [  245.517179]  ? cma_acquire_dev+0x1e3/0x3b0 [rdma_cm]
> [  245.523456]  addr_handler+0xa4/0x1c0 [rdma_cm]
> [  245.529147]  process_one_req+0x8d/0x120 [ib_core]
> [  245.535132]  process_one_work+0x149/0x360
> [  245.540334]  worker_thread+0x4d/0x3c0
> [  245.545145]  kthread+0x109/0x140
> [  245.549462]  ? rescuer_thread+0x380/0x380
> [  245.554654]  ? kthread_park+0x60/0x60
> [  245.559456]  ret_from_fork+0x25/0x30
> [  245.564153] Code: fe aa 81 4c 89 5d a0 4c 89 4d a8 e8 87 e1 c0 ff 8b 05
> fe 6e 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 6e 87 00
> <0f> ff e9 b8 fd ff ff e8 8d c7 ba ff 0f 1f 00 66 2e 0f 1f 8
> [  245.586712] ---[ end trace 56749c1831388ff8 ]---
> [  245.592920] mlx4_core 0000:04:00.0: dma_pool_free mlx4_cmd,
> cccccccccccccccc/ccd80eccccccf203 (bad dma)
> [  245.604179] mlx4_core 0000:04:00.0: dma_pool_free mlx4_cmd,
> cccccccccccccccc/cccccccccccccccc (bad dma)
> [  245.615647] general protection fault: 0000 [#1] SMP
> [  245.621836] Modules linked in: nvme_rdma nvme_fabrics nvme_core
> sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ibd
> [  245.706171]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata
> crc32c_intel i2c_core pps_core devlink dm_mirror dm_region_hash dmd
> [  245.729344] CPU: 38 PID: 6 Comm: kworker/u368:0 Tainted: G W
> 4.14.0-rc1+ #7
> [  245.739128] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2
> 01/08/2016
> [  245.748234] Workqueue: ib_addr process_one_req [ib_core]
> [  245.754905] task: ffff88018cb245c0 task.stack: ffffc9000009c000
> [  245.762256] RIP: 0010:prefetch_freepointer.isra.65+0x11/0x20
> [  245.769313] RSP: 0018:ffffc9000009fcc0 EFLAGS: 00010286
> [  245.775881] RAX: 0000000000000000 RBX: cccccccccccccccc RCX:
> 0000000000001793
> [  245.784591] RDX: 0000000000001792 RSI: cccccccccccccccc RDI:
> ffff88018fc07aa0
> [  245.793294] RBP: ffffc9000009fcc0 R08: 000000000001ed40 R09:
> ffff8810098cccc0
> [  245.802002] R10: ffffffff818a99e0 R11: 00000000010098cd R12:
> 00000000014080c0
> [  245.810706] R13: ffffffffa07bd1e0 R14: ffff88018fc07a80 R15:
> ffff88018fc07a80
> [  245.819409] FS:  0000000000000000(0000) GS:ffff88103eac0000(0000)
> knlGS:0000000000000000
> [  245.829184] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  245.836342] CR2: 000014940a9b7140 CR3: 00000010119b5000 CR4:
> 00000000001606e0
> [  245.845056] Call Trace:
> [  245.848524]  kmem_cache_alloc_trace+0xa0/0x1c0
> [  245.854220]  nvme_rdma_cm_handler+0x4e0/0x7ab [nvme_rdma]
> [  245.860990]  addr_handler+0xa4/0x1c0 [rdma_cm]
> [  245.866694]  process_one_req+0x8d/0x120 [ib_core]
> [  245.872687]  process_one_work+0x149/0x360
> [  245.877899]  worker_thread+0x4d/0x3c0
> [  245.882720]  kthread+0x109/0x140
> [  245.887051]  ? rescuer_thread+0x380/0x380
> [  245.892244]  ? kthread_park+0x60/0x60
> [  245.897054]  ret_from_fork+0x25/0x30
> [  245.901760] Code: 31 d2 e8 b3 ea ff ff 5b 41 5c 5d c3 0f 1f 40 00 66 2e
> 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 85 f6 48 89 e5 74 0a 48 63 07
> <48> 8b 04 06 0f 18 08 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 0
> [  245.924349] RIP: prefetch_freepointer.isra.65+0x11/0x20 RSP:
> ffffc9000009fcc0
> [  245.933145] ---[ end trace 56749c1831388ff9 ]---
> [  245.942680] Kernel panic - not syncing: Fatal exception
> [  245.950207] Kernel Offset: disabled
> [  245.958566] ---[ end Kernel panic - not syncing: Fatal exception
> [  245.966082] ------------[ cut here ]------------
> [  245.972014] WARNING: CPU: 38 PID: 6 at kernel/sched/core.c:1179
> set_task_cpu+0x191/0x1a0
> [  245.981822] Modules linked in: nvme_rdma nvme_fabrics nvme_core
> sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ibd
> [  246.066533]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata
> crc32c_intel i2c_core pps_core devlink dm_mirror dm_region_hash dmd
> [  246.089836] CPU: 38 PID: 6 Comm: kworker/u368:0 Tainted: G      D W
> 4.14.0-rc1+ #7
> [  246.099683] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2
> 01/08/2016
> [  246.108849] Workqueue: ib_addr process_one_req [ib_core]
> [  246.115566] task: ffff88018cb245c0 task.stack: ffffc9000009c000
> [  246.122948] RIP: 0010:set_task_cpu+0x191/0x1a0
> [  246.128668] RSP: 0018:ffff88103eac3c38 EFLAGS: 00010046
> [  246.135255] RAX: 0000000000000100 RBX: ffff88207bf445c0 RCX:
> 0000000000000001
> [  246.143978] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
> ffff88207bf445c0
> [  246.152699] RBP: ffff88103eac3c58 R08: 0000000000000001 R09:
> 0000000000000000
> [  246.161418] R10: 0000000000000001 R11: 0000000003e236eb R12:
> ffff88207bf4516c
> [  246.170137] R13: 0000000000000001 R14: 0000000000000001 R15:
> 000000000001b900
> [  246.178854] FS:  0000000000000000(0000) GS:ffff88103eac0000(0000)
> knlGS:0000000000000000
> [  246.188644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  246.195812] CR2: 000014940a9b7140 CR3: 00000010119b5000 CR4:
> 00000000001606e0
> [  246.204540] Call Trace:
> [  246.208027]  <IRQ>
> [  246.211016]  try_to_wake_up+0x166/0x470
> [  246.216036]  default_wake_function+0x12/0x20
> [  246.221537]  __wake_up_common+0x8a/0x160
> [  246.226641]  __wake_up_locked+0x16/0x20
> [  246.231643]  ep_poll_callback+0xd0/0x300
> [  246.236727]  __wake_up_common+0x8a/0x160
> [  246.241817]  __wake_up_common_lock+0x7e/0xc0
> [  246.247291]  __wake_up+0x13/0x20
> [  246.251596]  wake_up_klogd_work_func+0x40/0x60
> [  246.257265]  irq_work_run_list+0x4d/0x70
> [  246.262353]  ? tick_sched_do_timer+0x70/0x70
> [  246.267830]  irq_work_tick+0x40/0x50
> [  246.272530]  update_process_times+0x42/0x60
> [  246.277912]  tick_sched_handle+0x2d/0x60
> [  246.282987]  tick_sched_timer+0x39/0x70
> [  246.287945]  __hrtimer_run_queues+0xe5/0x230
> [  246.293371]  hrtimer_interrupt+0xa8/0x1a0
> [  246.298509]  smp_apic_timer_interrupt+0x5f/0x130
> [  246.304322]  apic_timer_interrupt+0x9d/0xb0
> [  246.309640]  </IRQ>
> [  246.312633] RIP: 0010:panic+0x1fd/0x245
> [  246.317554] RSP: 0018:ffffc9000009fb18 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff10
> [  246.326659] RAX: 0000000000000034 RBX: 0000000000000200 RCX:
> 0000000000000006
> [  246.335268] RDX: 0000000000000000 RSI: 0000000000000086 RDI:
> ffff88103eace030
> [  246.343856] RBP: ffffc9000009fb88 R08: 0000000000000000 R09:
> 0000000000000877
> [  246.352424] R10: 00000000000003ff R11: 0000000000000001 R12:
> ffffffff81a3e1d8
> [  246.360975] R13: 0000000000000000 R14: 0000000000000000 R15:
> ffff88018fc07a80
> [  246.369508]  ? panic+0x1f6/0x245
> [  246.373657]  oops_end+0xb8/0xd0
> [  246.377676]  die+0x42/0x50
> [  246.381194]  do_general_protection+0xd2/0x160
> [  246.386540]  ? nvme_rdma_cm_handler+0x4e0/0x7ab [nvme_rdma]
> [  246.393238]  general_protection+0x22/0x30
> [  246.398181] RIP: 0010:prefetch_freepointer.isra.65+0x11/0x20
> [  246.404964] RSP: 0018:ffffc9000009fcc0 EFLAGS: 00010286
> [  246.411258] RAX: 0000000000000000 RBX: cccccccccccccccc RCX:
> 0000000000001793
> [  246.419692] RDX: 0000000000001792 RSI: cccccccccccccccc RDI:
> ffff88018fc07aa0
> [  246.428115] RBP: ffffc9000009fcc0 R08: 000000000001ed40 R09:
> ffff8810098cccc0
> [  246.436543] R10: ffffffff818a99e0 R11: 00000000010098cd R12:
> 00000000014080c0
> [  246.444970] R13: ffffffffa07bd1e0 R14: ffff88018fc07a80 R15:
> ffff88018fc07a80
> [  246.453402]  ? nvme_rdma_cm_handler+0x4e0/0x7ab [nvme_rdma]
> [  246.460087]  kmem_cache_alloc_trace+0xa0/0x1c0
> [  246.465511]  nvme_rdma_cm_handler+0x4e0/0x7ab [nvme_rdma]
> [  246.472004]  addr_handler+0xa4/0x1c0 [rdma_cm]
> [  246.477424]  process_one_req+0x8d/0x120 [ib_core]
> [  246.483128]  process_one_work+0x149/0x360
> [  246.488045]  worker_thread+0x4d/0x3c0
> [  246.492577]  kthread+0x109/0x140
> [  246.496620]  ? rescuer_thread+0x380/0x380
> [  246.501540]  ? kthread_park+0x60/0x60
> [  246.506070]  ret_from_fork+0x25/0x30
> [  246.510496] Code: ff 80 8b ac 08 00 00 04 e9 23 ff ff ff 0f ff e9 bf fe
> ff ff f7 83 84 00 00 00 fd ff ff ff 0f 84 c9 fe ff ff 0f ff e9 c2 fe ff ff
> <0f> ff e9 d1 fe ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 0
> [  246.532545] ---[ end trace 56749c1831388ffa ]---
>
> > can you please apply the following patch and report if you see a warning?
> > --
> > diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> > index 92a03ff5fb4d..ef50b58b0bb6 100644
> > --- a/drivers/nvme/host/rdma.c
> > +++ b/drivers/nvme/host/rdma.c
> > @@ -274,7 +274,7 @@ static int nvme_rdma_reinit_request(void *data,
> > struct request *rq)
> >         struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
> >         int ret = 0;
> >
> > -       ib_dereg_mr(req->mr);
> > +       WARN_ON_ONCE(ib_dereg_mr(req->mr));
> >
> >         req->mr = ib_alloc_mr(dev->pd, IB_MR_TYPE_MEM_REG,
> >                         ctrl->max_fr_pages);
> > --
> >
> > _______________________________________________
> > Linux-nvme mailing list
> > Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > http://lists.infradead.org/mailman/listinfo/linux-nvme
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnHijIACgkQ5GN7iDZy
WKcPBg/8D0l3pC2y7hbS4K83efiwYiBeR2N0Z9OVG661yyH+XS5JRfcHzebAmLPB
Lv0R+tC5e69cw6yOx9gch6Z9eF6ScYQGg2tXPrBxtFecyRI0BlkWsNFGrbDPqmJd
BzHVB9jKC9M/XwzEB90Uzsxpwk2X490IsJK6UyeGcySTwf9C452MB/08UMh3dfPS
IaIzdq6v4EqRxKQKtbHC7hwKeaWgBzKBOGOdXUFxXcATxHQJ+stMD43eAl0qTWq0
ckozUBZsnKkUYcjcnWEuX6/zlTDhtyx5RRaKJRTxbzHZg410wl81DcrrhPnebqbY
NXNGIRZO+vphAHyy1EVZaRzyLd9rTVQ2oBbMVEqEQln522RY40XnDhhHr5JI50bc
R+mi4NtdDRDV6TzyF2RFEE+2FPZimlKPX5pz0H0sLQmggqZXM7d5GDK62de9ctSi
5TERX1HjtJAmGWCRWYoVijEj5PrISLz1G3FHf2cPc4ut4UWpTRmJBDennZ5U8/i5
9ULAWpnY1xXwiH3rwJjv5ETMvjamwiE5rVAblbnIb4d9b+UagMXuoCxDkL3mP31C
/2P3UPvqKt81lxKWAajlUat6K5sbDN/B7zYoFfdWfVNnLmNuhq7QbJJy9Sa1j5YQ
cOrSE5EhDY0JXgyRRwq37Bd3DL8SnGM4GTxyzkBTBb6kmtat93s=
=cKjR
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
