From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Thu, 12 Oct 2017 16:24:32 +0800
Message-ID: <ff355fcf-5089-f297-d3fa-9b86d133236b@redhat.com>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
 <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
 <e44f4640-44b2-4692-ca57-08f9ebf4da2c@redhat.com>
 <729c512f-55ff-25e4-6dd9-8b4dcc31bb8d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <729c512f-55ff-25e4-6dd9-8b4dcc31bb8d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Lets take this one step at a time, starting with this issue.
>
> First, there is a reason why a simple create_ctrl fails, can we isolate
> exactly which call fails? Was something else going on that might have
> made the simple create_ctrl fail?
>
> We don't see any "rdma_resolve_addr failed" or "failed to connect queue"
> messages but we do see "creating I/O queues" which means that we either
> failed at IO tagset allocation or initializing connect_q.
>
> We have a missing error code assignment so can you try the following 
> patch:

Hi Sagi
Sorry for the late response, here is the log with your patch, let me 
know if you need more test.

[  236.980239] nvme nvme0: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
[  237.131416] nvme_rdma: nvme_rdma_free_tagset: freeing ADMIN tagset
[  237.173614] nvme nvme0: creating 40 I/O queues.
[  237.688843] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
[  243.384596] nvme nvme0: rescanning
[  243.527922] nvme nvme0: Reconnecting in 10 seconds...
[  254.010547] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  254.018052] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  254.024482] nvme nvme0: Failed reconnect attempt 1
[  254.029844] nvme nvme0: Reconnecting in 10 seconds...
[  264.238223] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  264.245727] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  264.252159] nvme nvme0: Failed reconnect attempt 2
[  264.257545] nvme nvme0: Reconnecting in 10 seconds...
[  274.477977] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  274.485470] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  274.491905] nvme nvme0: Failed reconnect attempt 3
[  274.497287] nvme nvme0: Reconnecting in 10 seconds...
[  284.737691] nvme nvme0: creating 40 I/O queues.
[  284.745163] DMAR: ERROR: DMA PTE for vPFN 0xe0e9d already set (to 
100a1db001 not 1011432003)
[  284.754617] ------------[ cut here ]------------
[  284.759790] WARNING: CPU: 12 PID: 6 at 
drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
[  284.770010] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  284.849181]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  284.870886] CPU: 12 PID: 6 Comm: kworker/u368:0 Not tainted 
4.14.0-rc4.10.02.sagi+ #30
[  284.879746] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  284.888133] Workqueue: ib_addr process_one_req [ib_core]
[  284.894074] task: ffff88018cb50000 task.stack: ffffc9000009c000
[  284.900699] RIP: 0010:__domain_mapping+0x367/0x380
[  284.906051] RSP: 0018:ffffc9000009fa98 EFLAGS: 00010202
[  284.911899] RAX: 0000000000000004 RBX: 0000001011432003 RCX: 
0000000000000000
[  284.920643] RDX: 0000000000000000 RSI: ffff88103e78e058 RDI: 
ffff88103e78e058
[  284.929371] RBP: ffffc9000009faf8 R08: 0000000000000000 R09: 
0000000000000000
[  284.938088] R10: 00000000000002f7 R11: 0000000001011432 R12: 
ffff88201ab634e8
[  284.946814] R13: 0000000000000001 R14: 0000000000000001 R15: 
00000000000e0e9d
[  284.955533] FS:  0000000000000000(0000) GS:ffff88103e780000(0000) 
knlGS:0000000000000000
[  284.965318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  284.972491] CR2: 00007f9348b7b000 CR3: 000000202f7e7005 CR4: 
00000000001606e0
[  284.981227] Call Trace:
[  284.984712]  __intel_map_single+0xeb/0x180
[  284.990059]  intel_alloc_coherent+0xb5/0x130
[  284.995584]  mlx4_buf_alloc+0xe5/0x1c0 [mlx4_core]
[  285.001690]  mlx4_ib_alloc_cq_buf.isra.9+0x38/0xd0 [mlx4_ib]
[  285.008754]  mlx4_ib_create_cq+0x223/0x450 [mlx4_ib]
[  285.015027]  ib_alloc_cq+0x49/0x170 [ib_core]
[  285.020634]  nvme_rdma_cm_handler+0x3a2/0x7ab [nvme_rdma]
[  285.027416]  ? cma_acquire_dev+0x1e3/0x3b0 [rdma_cm]
[  285.033689]  addr_handler+0xa4/0x1c0 [rdma_cm]
[  285.039417]  process_one_req+0x8d/0x120 [ib_core]
[  285.045408]  process_one_work+0x149/0x360
[  285.050620]  worker_thread+0x4d/0x3c0
[  285.055432]  kthread+0x109/0x140
[  285.059780]  ? rescuer_thread+0x380/0x380
[  285.064987]  ? kthread_park+0x60/0x60
[  285.069805]  ret_from_fork+0x25/0x30
[  285.074511] Code: 10 ab 81 4c 89 5d a0 4c 89 4d a8 e8 27 ac c0 ff 8b 
05 fe 39 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 39 
87 00 <0f> ff e9 b8 fd ff ff e8 ed 8e b
[  285.097088] ---[ end trace 501470fecce57311 ]---
[  285.103299] DMAR: DRHD: handling fault status reg 2
[  285.103761] DMAR: ERROR: DMA PTE for vPFN 0xe0e9d already set (to 
100a1db001 not 100526b002)
[  285.103766] ------------[ cut here ]------------
[  285.103768] WARNING: CPU: 12 PID: 6 at 
drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
[  285.103768] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  285.103785]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  285.103791] CPU: 12 PID: 6 Comm: kworker/u368:0 Tainted: G W       
4.14.0-rc4.10.02.sagi+ #30
[  285.103792] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  285.103797] Workqueue: ib_addr process_one_req [ib_core]
[  285.103798] task: ffff88018cb50000 task.stack: ffffc9000009c000
[  285.103799] RIP: 0010:__domain_mapping+0x367/0x380
[  285.103800] RSP: 0018:ffffc9000009fc48 EFLAGS: 00010206
[  285.103800] RAX: 0000000000000003 RBX: 000000100526b002 RCX: 
0000000000000000
[  285.103801] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 
0000000000000282
[  285.103801] RBP: ffffc9000009fca8 R08: 0000000000000050 R09: 
0000000000000000
[  285.103802] R10: 0000000000000860 R11: 000000000100526b R12: 
ffff88201ab634e8
[  285.103803] R13: 0000000000000001 R14: 0000000000000001 R15: 
00000000000e0e9d
[  285.103803] FS:  0000000000000000(0000) GS:ffff88103e780000(0000) 
knlGS:0000000000000000
[  285.103804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.103805] CR2: 00007f9348b7b000 CR3: 000000202f7e7005 CR4: 
00000000001606e0
[  285.103805] Call Trace:
[  285.103808]  __intel_map_single+0xeb/0x180
[  285.103809]  intel_map_page+0x39/0x40
[  285.103811]  nvme_rdma_cm_handler+0x47b/0x7ab [nvme_rdma]
[  285.103813]  addr_handler+0xa4/0x1c0 [rdma_cm]
[  285.103817]  process_one_req+0x8d/0x120 [ib_core]
[  285.103818]  process_one_work+0x149/0x360
[  285.103819]  worker_thread+0x4d/0x3c0
[  285.103821]  kthread+0x109/0x140
[  285.103822]  ? rescuer_thread+0x380/0x380
[  285.103823]  ? kthread_park+0x60/0x60
[  285.103825]  ret_from_fork+0x25/0x30
[  285.103826] Code: 10 ab 81 4c 89 5d a0 4c 89 4d a8 e8 27 ac c0 ff 8b 
05 fe 39 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 39 
87 00 <0f> ff e9 b8 fd ff ff e8 ed 8e b
[  285.103839] ---[ end trace 501470fecce57312 ]---
[  285.190580] DMAR: ERROR: DMA PTE for vPFN 0xe0e9d already set (to 
100a1db001 not 100d51b001)
[  285.190586] ------------[ cut here ]------------
[  285.190590] WARNING: CPU: 30 PID: 757 at 
drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
[  285.190590] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  285.190609]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  285.190616] CPU: 30 PID: 757 Comm: kworker/u369:7 Tainted: G        
W       4.14.0-rc4.10.02.sagi+ #30
[  285.190617] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  285.190619] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
[  285.190620] task: ffff881032bd8000 task.stack: ffffc9000851c000
[  285.190622] RIP: 0010:__domain_mapping+0x367/0x380
[  285.190622] RSP: 0018:ffffc9000851fc60 EFLAGS: 00010202
[  285.190623] RAX: 0000000000000002 RBX: 000000100d51b001 RCX: 
0000000000000000
[  285.190624] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 
0000000000000292
[  285.190624] RBP: ffffc9000851fcc0 R08: 0000000000000050 R09: 
0000000000000000
[  285.190625] R10: 0000000000000881 R11: 000000000100d51b R12: 
ffff88201ab634e8
[  285.190625] R13: 0000000000000001 R14: 0000000000000001 R15: 
00000000000e0e9d
[  285.190626] FS:  0000000000000000(0000) GS:ffff88103e9c0000(0000) 
knlGS:0000000000000000
[  285.190626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.190627] CR2: 00007f4a9e61fb70 CR3: 0000001011bdd001 CR4: 
00000000001606e0
[  285.190628] Call Trace:
[  285.190630]  __intel_map_single+0xeb/0x180
[  285.190632]  intel_map_page+0x39/0x40
[  285.190636]  mlx4_ib_alloc_mr+0x141/0x220 [mlx4_ib]
[  285.190642]  ib_alloc_mr+0x26/0x50 [ib_core]
[  285.190644]  nvme_rdma_reinit_request+0x3a/0x70 [nvme_rdma]
[  285.190645]  ? nvme_rdma_free_ctrl+0xb0/0xb0 [nvme_rdma]
[  285.190647]  blk_mq_reinit_tagset+0x5c/0x90
[  285.190649]  nvme_rdma_configure_io_queues+0x204/0x280 [nvme_rdma]
[  285.190650]  nvme_rdma_reconnect_ctrl_work+0x5b/0xe0 [nvme_rdma]
[  285.190652]  process_one_work+0x149/0x360
[  285.190653]  worker_thread+0x4d/0x3c0
[  285.190655]  kthread+0x109/0x140
[  285.190656]  ? rescuer_thread+0x380/0x380
[  285.190657]  ? kthread_park+0x60/0x60
[  285.190660]  ret_from_fork+0x25/0x30
[  285.190660] Code: 10 ab 81 4c 89 5d a0 4c 89 4d a8 e8 27 ac c0 ff 8b 
05 fe 39 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 39 
87 00 <0f> ff e9 b8 fd ff ff e8 ed 8e b
[  285.190673] ---[ end trace 501470fecce57313 ]---
[  285.819126] DMAR: [DMA Write] Request device [04:00.0] fault addr 
e0e9d000 [fault reason 05] PTE Write access is not set
[  286.035086] nvme nvme0: Successfully reconnected
[  286.035143] nvme nvme0: MEMREG for CQE 0xffff88100a1e6f80 failed with 
status memory management operation error (6)
[  286.187508] nvme nvme0: Reconnecting in 10 seconds...
[  296.270043] nvme nvme0: creating 40 I/O queues.
[  296.336505] DMAR: ERROR: DMA PTE for vPFN 0xe0e9d already set (to 
1012082002 not 1012082002)
[  296.346704] ------------[ cut here ]------------
[  296.352618] WARNING: CPU: 32 PID: 815 at 
drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
[  296.363755] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  296.447983]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  296.471170] CPU: 32 PID: 815 Comm: kworker/u368:1 Tainted: G        
W       4.14.0-rc4.10.02.sagi+ #30
[  296.482344] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  296.491493] Workqueue: ib_addr process_one_req [ib_core]
[  296.498221] task: ffff8810373d2e80 task.stack: ffffc9000849c000
[  296.505613] RIP: 0010:__domain_mapping+0x367/0x380
[  296.511751] RSP: 0018:ffffc9000849fc48 EFLAGS: 00010202
[  296.518380] RAX: 0000000000000001 RBX: 0000001012082002 RCX: 
0000000000000000
[  296.527146] RDX: 0000000000000000 RSI: ffff88103ea0e058 RDI: 
ffff88103ea0e058
[  296.535918] RBP: ffffc9000849fca8 R08: 0000000000000000 R09: 
0000000000000000
[  296.544691] R10: 00000000000003ff R11: 0000000001012082 R12: 
ffff88201ab634e8
[  296.553462] R13: 0000000000000001 R14: 0000000000000001 R15: 
00000000000e0e9d
[  296.562240] FS:  0000000000000000(0000) GS:ffff88103ea00000(0000) 
knlGS:0000000000000000
[  296.572078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  296.579292] CR2: 00007fdc7ae90000 CR3: 0000001034df0002 CR4: 
00000000001606e0
[  296.588070] Call Trace:
[  296.591620]  __intel_map_single+0xeb/0x180
[  296.597012]  intel_map_page+0x39/0x40
[  296.601912]  nvme_rdma_cm_handler+0x47b/0x7ab [nvme_rdma]
[  296.608760]  addr_handler+0xa4/0x1c0 [rdma_cm]
[  296.614540]  process_one_req+0x8d/0x120 [ib_core]
[  296.620602]  process_one_work+0x149/0x360
[  296.625883]  worker_thread+0x4d/0x3c0
[  296.630779]  kthread+0x109/0x140
[  296.635177]  ? rescuer_thread+0x380/0x380
[  296.640453]  ? kthread_park+0x60/0x60
[  296.645341]  ret_from_fork+0x25/0x30
[  296.650132] Code: 10 ab 81 4c 89 5d a0 4c 89 4d a8 e8 27 ac c0 ff 8b 
05 fe 39 87 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 e9 39 
87 00 <0f> ff e9 b8 fd ff ff e8 ed 8e b
[  296.672876] ---[ end trace 501470fecce57314 ]---
[  297.231475] nvme nvme0: Successfully reconnected
[  297.231523] nvme nvme0: MEMREG for CQE 0xffff88100a1e6f80 failed with 
status memory management operation error (6)
[  297.378026] nvme nvme0: Reconnecting in 10 seconds...
[  307.765849] ------------[ cut here ]------------
[  307.771793] kernel BUG at drivers/iommu/iova.c:836!
[  307.778007] invalid opcode: 0000 [#1] SMP
[  307.783257] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  307.867936]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  307.891229] CPU: 30 PID: 757 Comm: kworker/u369:7 Tainted: G        
W       4.14.0-rc4.10.02.sagi+ #30
[  307.902427] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  307.911579] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
[  307.919847] task: ffff881032bd8000 task.stack: ffffc9000851c000
[  307.927232] RIP: 0010:iova_magazine_free_pfns+0x76/0x80
[  307.933827] RSP: 0018:ffffc9000851fc58 EFLAGS: 00010046
[  307.940415] RAX: 0000000000000000 RBX: 0000000000000017 RCX: 
0000000100400038
[  307.949132] RDX: 00000000000e0e9c RSI: 00000000000e0e9d RDI: 
ffff8810372c4e58
[  307.957857] RBP: ffffc9000851fc78 R08: ffff88202fd41a40 R09: 
0000000100400038
[  307.966586] R10: 000000002fd41c01 R11: ffff88202fd41a40 R12: 
ffff880ffda45000
[  307.975308] R13: ffff8810372c4e58 R14: 0000000000000046 R15: 
ffff880ffda45000
[  307.984032] FS:  0000000000000000(0000) GS:ffff88103e9c0000(0000) 
knlGS:0000000000000000
[  307.993834] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  308.001012] CR2: 00007f4a9e61fb70 CR3: 0000001011bdd001 CR4: 
00000000001606e0
[  308.009749] Call Trace:
[  308.013243]  free_iova_fast+0xc9/0x1d0
[  308.018198]  fq_ring_free+0x78/0xc0
[  308.022845]  queue_iova+0x111/0x130
[  308.027478]  intel_unmap+0xa5/0x130
[  308.032118]  intel_unmap_page+0xe/0x10
[  308.037044]  nvme_rdma_free_ring.constprop.61+0x4a/0x90 [nvme_rdma]
[  308.044789]  nvme_rdma_destroy_queue_ib+0x3a/0x50 [nvme_rdma]
[  308.051951]  nvme_rdma_free_queue+0x1a/0x30 [nvme_rdma]
[  308.058529]  nvme_rdma_destroy_io_queues+0x80/0xb0 [nvme_rdma]
[  308.065786]  nvme_rdma_reconnect_ctrl_work+0x30/0xe0 [nvme_rdma]
[  308.073240]  process_one_work+0x149/0x360
[  308.078470]  worker_thread+0x4d/0x3c0
[  308.083299]  kthread+0x109/0x140
[  308.087652]  ? rescuer_thread+0x380/0x380
[  308.092878]  ? kthread_park+0x60/0x60
[  308.097699]  ret_from_fork+0x25/0x30
[  308.102407] Code: ef e8 ef fe ff ff 48 63 d3 49 3b 14 24 72 d7 4c 89 
f6 4c 89 ef e8 3b 3d 2b 00 49 c7 04 24 00 00 00 00 5b 41 5c 41 5d 41 5e 
5d c3 <0f> 0b 0f 1f 84 00 00 00 00 00 0
[  308.124980] RIP: iova_magazine_free_pfns+0x76/0x80 RSP: ffffc9000851fc58
[  308.133265] ---[ end trace 501470fecce57315 ]---
[  308.142811] Kernel panic - not syncing: Fatal exception
[  308.149425] Kernel Offset: disabled
[  308.158679] ---[ end Kernel panic - not syncing: Fatal exception
[  308.166135] ------------[ cut here ]------------
[  308.172010] WARNING: CPU: 30 PID: 757 at kernel/sched/core.c:1179 
set_task_cpu+0x191/0x1a0
[  308.181959] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma id
[  308.266001]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ahci mlx4_core libahci ptp 
libata crc32c_intel i2c_core pps_core devlink d
[  308.289112] CPU: 30 PID: 757 Comm: kworker/u369:7 Tainted: G D 
W       4.14.0-rc4.10.02.sagi+ #30
[  308.300236] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  308.309330] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
[  308.317552] task: ffff881032bd8000 task.stack: ffffc9000851c000
[  308.324905] RIP: 0010:set_task_cpu+0x191/0x1a0
[  308.330621] RSP: 0018:ffff88103e9c3c38 EFLAGS: 00010046
[  308.337191] RAX: 0000000000000200 RBX: ffff881034cc5d00 RCX: 
0000000000000001
[  308.345896] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
ffff881034cc5d00
[  308.354604] RBP: ffff88103e9c3c58 R08: 0000000000000000 R09: 
0000000000000000
[  308.363314] R10: 00000000000003ff R11: 0000000000000001 R12: 
ffff881034cc68ac
[  308.372018] R13: 0000000000000000 R14: 0000000000000000 R15: 
000000000001b900
[  308.380720] FS:  0000000000000000(0000) GS:ffff88103e9c0000(0000) 
knlGS:0000000000000000
[  308.390495] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  308.397632] CR2: 00007f4a9e61fb70 CR3: 0000001011bdd001 CR4: 
00000000001606e0
[  308.406347] Call Trace:
[  308.409809]  <IRQ>
[  308.412789]  try_to_wake_up+0x166/0x470
[  308.417816]  default_wake_function+0x12/0x20
[  308.423325]  __wake_up_common+0x8a/0x160
[  308.428438]  __wake_up_locked+0x16/0x20
[  308.433450]  ep_poll_callback+0xd0/0x300
[  308.438562]  __wake_up_common+0x8a/0x160
[  308.443664]  __wake_up_common_lock+0x7e/0xc0
[  308.449150]  __wake_up+0x13/0x20
[  308.453455]  wake_up_klogd_work_func+0x40/0x60
[  308.459124]  irq_work_run_list+0x4d/0x70
[  308.464217]  ? tick_sched_do_timer+0x70/0x70
[  308.469701]  irq_work_tick+0x40/0x50
[  308.474409]  update_process_times+0x42/0x60
[  308.479800]  tick_sched_handle+0x2d/0x60
[  308.484881]  tick_sched_timer+0x39/0x70
[  308.489852]  __hrtimer_run_queues+0xe5/0x230
[  308.495291]  hrtimer_interrupt+0xa8/0x1a0
[  308.500466]  smp_apic_timer_interrupt+0x5f/0x130
[  308.506320]  apic_timer_interrupt+0x9d/0xb0
[  308.511661]  </IRQ>
[  308.514658] RIP: 0010:panic+0x1fd/0x245
[  308.519603] RSP: 0018:ffffc9000851f9a8 EFLAGS: 00000246 ORIG_RAX: 
ffffffffffffff10
[  308.528740] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 
0000000000000006
[  308.537352] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 
ffff88103e9ce050
[  308.545943] RBP: ffffc9000851fa18 R08: 0000000000000000 R09: 
00000000000008f9
[  308.554511] R10: 00000000000003ff R11: 0000000000000001 R12: 
ffffffff81a3f340
[  308.563067] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000004
[  308.571619]  ? panic+0x1f6/0x245
[  308.575773]  oops_end+0xb8/0xd0
[  308.579822]  die+0x42/0x50
[  308.583348]  do_trap+0x16a/0x180
[  308.587442]  do_error_trap+0x89/0x110
[  308.592007]  ? iova_magazine_free_pfns+0x76/0x80
[  308.597624]  ? rem_res_range+0x1ae/0x200 [mlx4_core]
[  308.603625]  do_invalid_op+0x20/0x30
[  308.608063]  invalid_op+0x18/0x20
[  308.612198] RIP: 0010:iova_magazine_free_pfns+0x76/0x80
[  308.618473] RSP: 0018:ffffc9000851fc58 EFLAGS: 00010046
[  308.624735] RAX: 0000000000000000 RBX: 0000000000000017 RCX: 
0000000100400038
[  308.633146] RDX: 00000000000e0e9c RSI: 00000000000e0e9d RDI: 
ffff8810372c4e58
[  308.641555] RBP: ffffc9000851fc78 R08: ffff88202fd41a40 R09: 
0000000100400038
[  308.649969] R10: 000000002fd41c01 R11: ffff88202fd41a40 R12: 
ffff880ffda45000
[  308.658387] R13: ffff8810372c4e58 R14: 0000000000000046 R15: 
ffff880ffda45000
[  308.666799]  ? iova_magazine_free_pfns+0x3e/0x80
[  308.672399]  free_iova_fast+0xc9/0x1d0
[  308.677046]  fq_ring_free+0x78/0xc0
[  308.681370]  queue_iova+0x111/0x130
[  308.685691]  intel_unmap+0xa5/0x130
[  308.690011]  intel_unmap_page+0xe/0x10
[  308.694626]  nvme_rdma_free_ring.constprop.61+0x4a/0x90 [nvme_rdma]
[  308.702056]  nvme_rdma_destroy_queue_ib+0x3a/0x50 [nvme_rdma]
[  308.708909]  nvme_rdma_free_queue+0x1a/0x30 [nvme_rdma]
[  308.715182]  nvme_rdma_destroy_io_queues+0x80/0xb0 [nvme_rdma]
[  308.722148]  nvme_rdma_reconnect_ctrl_work+0x30/0xe0 [nvme_rdma]
[  308.729311]  process_one_work+0x149/0x360
[  308.734242]  worker_thread+0x4d/0x3c0
[  308.738783]  kthread+0x109/0x140
[  308.742840]  ? rescuer_thread+0x380/0x380
[  308.747774]  ? kthread_park+0x60/0x60
[  308.752309]  ret_from_fork+0x25/0x30
[  308.756747] Code: ff 80 8b ac 08 00 00 04 e9 23 ff ff ff 0f ff e9 bf 
fe ff ff f7 83 84 00 00 00 fd ff ff ff 0f 84 c9 fe ff ff 0f ff e9 c2 fe 
ff ff <0f> ff e9 d1 fe ff ff 0f 1f 84 0
[  308.778800] ---[ end trace 501470fecce57316 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
