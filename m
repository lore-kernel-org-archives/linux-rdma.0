From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Mon, 25 Sep 2017 13:20:14 +0800
Message-ID: <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924103426.GB25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 09/24/2017 06:34 PM, Leon Romanovsky wrote:
> On Sun, Sep 24, 2017 at 05:28:30PM +0800, Yi Zhang wrote:
>>> Is it possible that ib_dereg_mr failed?
>>>
>> It seems not, and finally the system get panic, here is the log:
> I looked on the issue during the weekend and didn't see any suspicious
> commit in the mlx4 alloc/mapping area.
>
> Can I ask you to perform git bisect to find the problematic change?
Hi Sagi
I did git bisect for this issue, seems it was introduced by your patch 
"Few more patches from the centralization set".
Here is the testing on the patch, let me know if  you need more info.

BAD  148b4e7 nvme-rdma: stop queues instead of simply flipping their state
BAD  a57bd54 nvme-rdma: introduce configure/destroy io queues
Log:
[  127.899255] nvme nvme0: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
[  128.074263] nvme nvme0: creating 40 I/O queues.
[  128.581822] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
[  177.486110] print_req_error: I/O error, dev nvme0n1, sector 0
[  191.256637] nvme nvme0: Reconnecting in 10 seconds...
[  201.855846] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  201.863353] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  201.869824] nvme nvme0: Failed reconnect attempt 1
[  201.875183] nvme nvme0: Reconnecting in 10 seconds...
[  212.087828] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  212.095330] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  212.101766] nvme nvme0: Failed reconnect attempt 2
[  212.107129] nvme nvme0: Reconnecting in 10 seconds...
[  222.328398] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  222.335900] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  222.342335] nvme nvme0: Failed reconnect attempt 3
[  222.347699] nvme nvme0: Reconnecting in 10 seconds...
[  232.567791] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  232.575292] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  232.581730] nvme nvme0: Failed reconnect attempt 4
[  232.587094] nvme nvme0: Reconnecting in 10 seconds...
[  242.827727] nvme nvme0: creating 40 I/O queues.
[  242.832810] DMAR: ERROR: DMA PTE for vPFN 0xe129b already set (to 
103c692002 not 1000915003)
[  242.842265] ------------[ cut here ]------------
[  242.847437] WARNING: CPU: 0 PID: 783 at 
drivers/iommu/intel-iommu.c:2299 __domain_mapping+0x363/0x370
[  242.857755] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert 
iscsi_target_mod ibd
[  242.936919]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci 
crc32c_intel ptp libata i2c_core pps_core devlink dm_mirror 
dm_region_hash dmd
[  242.958625] CPU: 0 PID: 783 Comm: kworker/u368:1 Not tainted 
4.13.0-rc7.a57bd54+ #15
[  242.967304] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  242.975687] Workqueue: ib_addr process_one_req [ib_core]
[  242.981631] task: ffff881019491740 task.stack: ffffc9000b534000
[  242.989011] RIP: 0010:__domain_mapping+0x363/0x370
[  242.995108] RSP: 0018:ffffc9000b537a50 EFLAGS: 00010202
[  243.001694] RAX: 0000000000000004 RBX: 0000001000915003 RCX: 
0000000000000000
[  243.010433] RDX: 0000000000000000 RSI: ffff88103e60e038 RDI: 
ffff88103e60e038
[  243.019170] RBP: ffffc9000b537ab0 R08: 0000000000000000 R09: 
0000000000000000
[  243.027893] R10: 00000000000002f7 R11: 0000000001000915 R12: 
ffff88201ea5c4d8
[  243.036632] R13: 0000000000000001 R14: 0000000000000001 R15: 
00000000000e129b
[  243.045348] FS:  0000000000000000(0000) GS:ffff88103e600000(0000) 
knlGS:0000000000000000
[  243.055142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  243.062337] CR2: 00007f9d3b0fab70 CR3: 00000020245b7000 CR4: 
00000000001406f0
[  243.071076] Call Trace:
[  243.074564]  __intel_map_single+0xeb/0x180
[  243.079903]  intel_alloc_coherent+0xb5/0x130
[  243.085445]  mlx4_buf_alloc+0xe5/0x1c0 [mlx4_core]
[  243.091555]  mlx4_ib_alloc_cq_buf.isra.9+0x38/0xd0 [mlx4_ib]
[  243.098621]  mlx4_ib_create_cq+0x223/0x440 [mlx4_ib]
[  243.104901]  ? find_gid.isra.5+0x167/0x1f0 [ib_core]
[  243.111178]  ib_alloc_cq+0x49/0x170 [ib_core]
[  243.116791]  nvme_rdma_cm_handler+0x3e7/0x886 [nvme_rdma]
[  243.123557]  ? cma_attach_to_dev+0x17/0x50 [rdma_cm]
[  243.129838]  ? cma_acquire_dev+0x1e3/0x3b0 [rdma_cm]
[  243.136115]  ? account_entity_dequeue+0xaa/0xe0
[  243.141918]  addr_handler+0xa4/0x1c0 [rdma_cm]
[  243.147604]  process_one_req+0x8d/0x120 [ib_core]
[  243.153585]  process_one_work+0x149/0x360
[  243.158807]  worker_thread+0x4d/0x3c0
[  243.163618]  kthread+0x109/0x140
[  243.167936]  ? rescuer_thread+0x380/0x380
[  243.173131]  ? kthread_park+0x60/0x60
[  243.177930]  ret_from_fork+0x25/0x30
[  243.182641] Code: f1 a9 81 4c 89 5d a0 4c 89 4d a8 e8 0b 58 c1 ff 8b 
05 f2 16 88 00 4c 8b 4d a8 4c 8b 5d a0 85 c0 74 09 83 e8 01 89 05 dd 16 
88 00 <0f> ff e9 bc fd ff ff e8 21 3d bb ff 90 0f 1f 44 00 00 55 4
[  243.205193] ---[ end trace 725c2de52628c061 ]---
[  243.211723] mlx4_core 0000:04:00.0: dma_pool_free mlx4_cmd, 
cccccccccccccccc/cc242fcccccc2801 (bad dma)
[  243.211724] mlx4_core 0000:04:00.0: dma_pool_free mlx4_cmd, 
cccccccccccccccc/cccccccccccccccc (bad dma)
[  243.212312] general protection fault: 0000 [#1] SMP
[  243.212312] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert 
iscsi_target_mod ibd
[  243.212339]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci 
crc32c_intel ptp libata i2c_core pps_core devlink dm_mirror 
dm_region_hash dmd
[  243.212353] CPU: 36 PID: 783 Comm: kworker/u368:1 Tainted: G        
W       4.13.0-rc7.a57bd54+ #15
[  243.212353] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
1.6.2 01/08/2016
[  243.212360] Workqueue: ib_addr process_one_req [ib_core]
[  243.212361] task: ffff881019491740 task.stack: ffffc9000b534000
[  243.212364] RIP: 0010:kmem_cache_alloc_trace+0x7d/0x1b0
[  243.212364] RSP: 0018:ffffc9000b537c88 EFLAGS: 00010282
[  243.212365] RAX: 0000000000000000 RBX: 00000000014080c0 RCX: 
0000000000006b83
[  243.212366] RDX: 0000000000006b82 RSI: 00000000014080c0 RDI: 
ffff88018fc07a80
[  243.212366] RBP: ffffc9000b537cc0 R08: 000000000001ed40 R09: 
0000000000000000
[  243.212373] R10: ffff88018fc07a80 R11: 000000000103c693 R12: 
00000000014080c0
[  243.212374] R13: ffffffffa08b317f R14: ffff88018fc07a80 R15: 
cccccccccccccccc
[  243.212375] FS:  0000000000000000(0000) GS:ffff88103ea80000(0000) 
knlGS:0000000000000000
[  243.212375] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  243.212376] CR2: 00007f736b47c000 CR3: 000000201b770000 CR4: 
00000000001406e0
[  243.212377] Call Trace:
[  243.212379]  nvme_rdma_cm_handler+0x4ef/0x886 [nvme_rdma]
[  243.212382]  ? cma_attach_to_dev+0x17/0x50 [rdma_cm]
[  243.212383]  ? nvme_rdma_memreg_done+0x30/0x30 [nvme_rdma]
[  243.212385]  addr_handler+0xa4/0x1c0 [rdma_cm]
[  243.212390]  process_one_req+0x8d/0x120 [ib_core]
[  243.212398]  process_one_work+0x149/0x360
[  243.212399]  worker_thread+0x4d/0x3c0
[  243.212400]  kthread+0x109/0x140
[  243.212401]  ? rescuer_thread+0x380/0x380
[  243.212403]  ? kthread_park+0x60/0x60
[  243.212404]  ret_from_fork+0x25/0x30
[  243.212405] Code: 4c 03 05 6f 12 dd 7e 4d 8b 38 49 8b 40 10 4d 85 ff 
0f 84 ec 00 00 00 48 85 c0 0f 84 e3 00 00 00 49 63 42 20 48 8d 4a 01 4d 
8b 02 <49> 8b 1c 07 4c 89 f8 65 49 0f c7 08 0f 94 c0 84 c0 74 b9 4
[  243.212420] RIP: kmem_cache_alloc_trace+0x7d/0x1b0 RSP: ffffc9000b537c88
[  243.212519] ---[ end trace 725c2de52628c062 ]---
[  243.216792] Kernel panic - not syncing: Fatal exception
[  243.216878] Kernel Offset: disabled
[  243.583898] ---[ end Kernel panic - not syncing: Fatal exception

Panic after connection with below commits, detailed log here: 
https://pastebin.com/7z0XSGSd
31fdf18     nvme-rdma: reuse configure/destroy_admin_queue
3f02fff       nvme-rdma: don't free tagset on resets
18398af    nvme-rdma: disable the controller on resets
b28a308   nvme-rdma: move tagset allocation to a dedicated routine

good    34b6c23 nvme: Add admin_tagset pointer to nvme_ctrl


Thanks
Yi
> Added Tariq to the thread.
>
> Thanks
>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
