From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Mon, 25 Sep 2017 10:06:06 +0300
Message-ID: <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Sagi
> I did git bisect for this issue, seems it was introduced by your patch 
> "Few more patches from the centralization set".
> Here is the testing on the patch, let me know if  you need more info.

Thanks for reporting.

> BAD  148b4e7 nvme-rdma: stop queues instead of simply flipping their state
> BAD  a57bd54 nvme-rdma: introduce configure/destroy io queues
> Log:
> [  127.899255] nvme nvme0: new ctrl: NQN 
> "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
> [  128.074263] nvme nvme0: creating 40 I/O queues.
> [  128.581822] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
> [  177.486110] print_req_error: I/O error, dev nvme0n1, sector 0
> [  191.256637] nvme nvme0: Reconnecting in 10 seconds...
> [  201.855846] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  201.863353] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  201.869824] nvme nvme0: Failed reconnect attempt 1
> [  201.875183] nvme nvme0: Reconnecting in 10 seconds...
> [  212.087828] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  212.095330] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  212.101766] nvme nvme0: Failed reconnect attempt 2
> [  212.107129] nvme nvme0: Reconnecting in 10 seconds...
> [  222.328398] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  222.335900] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  222.342335] nvme nvme0: Failed reconnect attempt 3
> [  222.347699] nvme nvme0: Reconnecting in 10 seconds...
> [  232.567791] nvme nvme0: Connect rejected: status 8 (invalid service ID).
> [  232.575292] nvme nvme0: rdma_resolve_addr wait failed (-104).
> [  232.581730] nvme nvme0: Failed reconnect attempt 4
> [  232.587094] nvme nvme0: Reconnecting in 10 seconds...
> [  242.827727] nvme nvme0: creating 40 I/O queues.
> [  242.832810] DMAR: ERROR: DMA PTE for vPFN 0xe129b already set (to 
> 103c692002 not 1000915003)
> [  242.842265] ------------[ cut here ]------------
> [  242.847437] WARNING: CPU: 0 PID: 783 at 
> drivers/iommu/intel-iommu.c:2299 __domain_mapping+0x363/0x370
> [  242.857755] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
> sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables 
> iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert 
> iscsi_target_mod ibd
> [  242.936919]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
> sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci 
> crc32c_intel ptp libata i2c_core pps_core devlink dm_mirror 
> dm_region_hash dmd
> [  242.958625] CPU: 0 PID: 783 Comm: kworker/u368:1 Not tainted 
> 4.13.0-rc7.a57bd54+ #15
> [  242.967304] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 
> 1.6.2 01/08/2016
> [  242.975687] Workqueue: ib_addr process_one_req [ib_core]
> [  242.981631] task: ffff881019491740 task.stack: ffffc9000b534000
> [  242.989011] RIP: 0010:__domain_mapping+0x363/0x370
> [  242.995108] RSP: 0018:ffffc9000b537a50 EFLAGS: 00010202
> [  243.001694] RAX: 0000000000000004 RBX: 0000001000915003 RCX: 
> 0000000000000000
> [  243.010433] RDX: 0000000000000000 RSI: ffff88103e60e038 RDI: 
> ffff88103e60e038
> [  243.019170] RBP: ffffc9000b537ab0 R08: 0000000000000000 R09: 
> 0000000000000000
> [  243.027893] R10: 00000000000002f7 R11: 0000000001000915 R12: 
> ffff88201ea5c4d8
> [  243.036632] R13: 0000000000000001 R14: 0000000000000001 R15: 
> 00000000000e129b
> [  243.045348] FS:  0000000000000000(0000) GS:ffff88103e600000(0000) 
> knlGS:0000000000000000
> [  243.055142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  243.062337] CR2: 00007f9d3b0fab70 CR3: 00000020245b7000 CR4: 
> 00000000001406f0
> [  243.071076] Call Trace:
> [  243.074564]  __intel_map_single+0xeb/0x180
> [  243.079903]  intel_alloc_coherent+0xb5/0x130
> [  243.085445]  mlx4_buf_alloc+0xe5/0x1c0 [mlx4_core]
> [  243.091555]  mlx4_ib_alloc_cq_buf.isra.9+0x38/0xd0 [mlx4_ib]
> [  243.098621]  mlx4_ib_create_cq+0x223/0x440 [mlx4_ib]
> [  243.104901]  ? find_gid.isra.5+0x167/0x1f0 [ib_core]
> [  243.111178]  ib_alloc_cq+0x49/0x170 [ib_core]
> [  243.116791]  nvme_rdma_cm_handler+0x3e7/0x886 [nvme_rdma]
> [  243.123557]  ? cma_attach_to_dev+0x17/0x50 [rdma_cm]
> [  243.129838]  ? cma_acquire_dev+0x1e3/0x3b0 [rdma_cm]
> [  243.136115]  ? account_entity_dequeue+0xaa/0xe0
> [  243.141918]  addr_handler+0xa4/0x1c0 [rdma_cm]
> [  243.147604]  process_one_req+0x8d/0x120 [ib_core]
> [  243.153585]  process_one_work+0x149/0x360
> [  243.158807]  worker_thread+0x4d/0x3c0
> [  243.163618]  kthread+0x109/0x140
> [  243.167936]  ? rescuer_thread+0x380/0x380
> [  243.173131]  ? kthread_park+0x60/0x60
> [  243.177930]  ret_from_fork+0x25/0x30

I'm not able to reproduce this.

I still don't understand how we call ib_alloc_cq and get to
a mapped buffer, its calling dma_alloc_coherent.

Can you try the following patch and report what's going on?
--
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 92a03ff5fb4d..3befaa0c53ff 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -927,10 +927,6 @@ static void nvme_rdma_reconnect_ctrl_work(struct 
work_struct *work)

         ++ctrl->ctrl.nr_reconnects;

-       if (ctrl->ctrl.queue_count > 1)
-               nvme_rdma_destroy_io_queues(ctrl, false);
-
-       nvme_rdma_destroy_admin_queue(ctrl, false);
         ret = nvme_rdma_configure_admin_queue(ctrl, false);
         if (ret)
                 goto requeue;
@@ -938,7 +934,7 @@ static void nvme_rdma_reconnect_ctrl_work(struct 
work_struct *work)
         if (ctrl->ctrl.queue_count > 1) {
                 ret = nvme_rdma_configure_io_queues(ctrl, false);
                 if (ret)
-                       goto requeue;
+                       goto destroy_admin;
         }

         changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE);
@@ -956,6 +952,8 @@ static void nvme_rdma_reconnect_ctrl_work(struct 
work_struct *work)

         return;

+destroy_admin:
+       nvme_rdma_destroy_admin_queue(ctrl, false);
  requeue:
         dev_info(ctrl->ctrl.device, "Failed reconnect attempt %d\n",
                         ctrl->ctrl.nr_reconnects);
@@ -990,6 +988,10 @@ static void nvme_rdma_error_recovery_work(struct 
work_struct *work)
         blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
         nvme_start_queues(&ctrl->ctrl);

+       if (ctrl->ctrl.queue_count > 1)
+               nvme_rdma_destroy_io_queues(ctrl, false);
+       nvme_rdma_destroy_admin_queue(ctrl, false);
+
         nvme_rdma_reconnect_or_remove(ctrl);
  }
--

I guess we could see weird phenomenons if we have a resource leak,
but I ran kmemleak and could not get anything in this area...

> Panic after connection with below commits, detailed log here: 
> https://pastebin.com/7z0XSGSd
> 31fdf18     nvme-rdma: reuse configure/destroy_admin_queue
> 3f02fff       nvme-rdma: don't free tagset on resets
> 18398af    nvme-rdma: disable the controller on resets
> b28a308   nvme-rdma: move tagset allocation to a dedicated routine
> 
> good    34b6c23 nvme: Add admin_tagset pointer to nvme_ctrl

Is that a reproducible panic? I'm not seeing this at all.

Can you run gdb on nvme-rdma.ko
$ l *(nvme_rdma_create_ctrl+0x37d)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
