From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/1] nvme-rdma: correctly unwind on bad subsystemnqn error
Date: Wed, 22 Jun 2016 13:14:37 -0700
Message-ID: <29f60c6f2d57d3c6ea511d74eb61f37bb105b81c.1466626499.git.swise@opengridcomputing.com>
References: <cover.1466626499.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1466626499.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When attempting to connect to a valid NVMF RDMA target but using an
invalid subsystemnqn, the failure unwind path in the host rdma transport
causes a touch-after-free crash with memory debugging enabled in the
kernel config:

nvme nvme1: Connect Invalid Data Parameter, subsysnqn "bazinga"
BUG: unable to handle kernel paging request at ffff880fea7a01f8
IP: [<ffffffffa081ea96>] __ib_process_cq+0x46/0xc0 [ib_core]
PGD 1e88067 PUD 10784d6067 PMD 1078382067 PTE 8000000fea7a0060
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: nvme_rdma nvme_fabrics rdma_ucm rdma_cm iw_cm configfs
iw_cxgb4 cxgb4 ip6table_filter ip6_tables ebtable_nat ebtables
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
nf_reject_ipv4 xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge
autofs4 8021q garp stp llc cachefiles fscache ib_ipoib ib_cm ib_uverbs
ib_umad iw_nes libcrc32c iw_cxgb3 cxgb3 mdio ib_qib rdmavt mlx4_en
ib_mthca dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan vhost
tun kvm irqbypass uinput iTCO_wdt iTCO_vendor_support pcspkr mlx4_ib
ib_core ipv6 mlx4_core dm_mod i2c_i801 sg lpc_ich mfd_core nvme nvme_core
igb dca ptp pps_core acpi_cpufreq ext4(E) mbcache(E) jbd2(E) sd_mod(E)
nouveau(E) ttm(E) drm_kms_helper(E) drm(E) fb_sys_fops(E) sysimgblt(E)
sysfillrect(E) syscopyarea(E) i2c_algo_bit(E) i2c_core(E) mxm_wmi(E)
video(E) ahci(E) libahci(E) wmi(E) [last unloaded: cxgb4]
CPU: 0 PID: 3555 Comm: kworker/u32:0 Tainted: G            E
4.7.0-rc2-nvmf-all.3-debug+ #63
Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
Workqueue: iw_cxgb4 process_work [iw_cxgb4]
task: ffff881026564380 ti: ffff880fffe74000 task.ti: ffff880fffe74000
RIP: 0010:[<ffffffffa081ea96>]  [<ffffffffa081ea96>]
__ib_process_cq+0x46/0xc0 [ib_core]
RSP: 0018:ffff881077203df8  EFLAGS: 00010282
RAX: 0000000000000002 RBX: ffff8810279e3e00 RCX: ffff880fea0c8000
RDX: ffff880fea7a01f8 RSI: ffff881023825c00 RDI: ffff8810279e3e00
RBP: ffff881077203e38 R08: 0000000000000000 R09: ffff8810772038b8
R10: 0000000000000548 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000100 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff881077200000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff880fea7a01f8 CR3: 0000001027a93000 CR4: 00000000000406f0
Stack:
 0000000000000246 0000000281a52c80 ffff881077203e48 ffff8810279e3e40
 ffff881077211f90 0000000000000100 ffff8810279e3e00 ffff881077203e88
 ffff881077203e68 ffffffffa081ee62 ffff8810279e3e40 ffff881077211f90
Call Trace:
 <IRQ>
 [<ffffffffa081ee62>] ib_poll_handler+0x32/0x80 [ib_core]
 [<ffffffff813077a7>] irq_poll_softirq+0xb7/0x110
 [<ffffffff810684dd>] ? trace_event_raw_event_softirq+0x5d/0xa0
 [<ffffffff816203fb>] __do_softirq+0xeb/0x2d8
 [<ffffffff81068927>] ? irq_exit+0x47/0xb0
 [<ffffffff81620125>] ? do_IRQ+0x65/0xf0
 [<ffffffff8161f7dc>] do_softirq_own_stack+0x1c/0x30
 <EOI>
 [<ffffffff81068708>] do_softirq+0x38/0x40
 [<ffffffff810687e5>] __local_bh_enable_ip+0x85/0x90
 [<ffffffffa03ab624>] t4_ofld_send+0x124/0x180 [cxgb4]
 [<ffffffffa039958e>] cxgb4_remove_tid+0x9e/0x140 [cxgb4]
 [<ffffffffa03e425c>] _c4iw_free_ep+0x5c/0x100 [iw_cxgb4]
 [<ffffffffa03e86c2>] peer_close+0x102/0x260 [iw_cxgb4]
 [<ffffffff8112cb46>] ? trace_event_buffer_commit+0x146/0x1d0
 [<ffffffff81532d37>] ? skb_dequeue+0x67/0x80
 [<ffffffffa03e813e>] process_work+0x4e/0x70 [iw_cxgb4]
 [<ffffffff8107cd3b>] process_one_work+0x17b/0x510
 [<ffffffff8161a1ac>] ? __schedule+0x23c/0x630
 [<ffffffff811152f4>] ? ring_buffer_unlock_commit+0x24/0xb0
 [<ffffffff8111b701>] ? trace_buffer_unlock_commit_regs+0x61/0x80
 [<ffffffff8161a700>] ? schedule+0x40/0xb0
 [<ffffffff8107ddd6>] worker_thread+0x166/0x580
 [<ffffffff8161a1ac>] ? __schedule+0x23c/0x630
 [<ffffffff8108e342>] ? default_wake_function+0x12/0x20
 [<ffffffff8109fe06>] ? __wake_up_common+0x56/0x90
 [<ffffffff8107dc70>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8161a700>] ? schedule+0x40/0xb0
 [<ffffffff8107dc70>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8108273c>] kthread+0xcc/0xf0
 [<ffffffff8108ccbe>] ? schedule_tail+0x1e/0xc0
 [<ffffffff8161df0f>] ret_from_fork+0x1f/0x40
 [<ffffffff81082670>] ? kthread_freezable_should_stop+0x70/0x70
Code: fb 41 89 f5 48 8b 03 48 8b 53 38 be 10 00 00 00 48 89 df ff 90 f8 01
00 00 85 c0 89 45 cc 7e 6d 45 31 ff 45 31 f6 eb 13 48 89 df <ff> 12 41 83
c6 01 49 83 c7 40 44 3b 75 cc 7d 39 4c 89 fe 48 03
RIP  [<ffffffffa081ea96>] __ib_process_cq+0x46/0xc0 [ib_core]
 RSP <ffff881077203df8>
CR2: ffff880fea7a01f8

The crash is due to the nvme tagsets getting freed before rdma work
requests that reference that memory are completed.

Here is the unwind flow from nvme_rdma_configure_admin_queue()

...
        error = nvmf_connect_admin_queue(&ctrl->ctrl);
        if (error)
                goto out_cleanup_queue;
...

out_cleanup_queue:
        blk_cleanup_queue(ctrl->ctrl.admin_q);
out_free_tagset:
        blk_mq_free_tag_set(&ctrl->admin_tag_set);
out_put_dev:
        nvme_rdma_dev_put(ctrl->device);
out_free_queue:
        nvme_rdma_free_queue(&ctrl->queues[0]);
        return error;

And here is the flow from nvme_rdma_destroy_admin_queue():

...
        nvme_rdma_free_qe(ctrl->queues[0].device->dev,
&ctrl->async_event_sqe,
                        sizeof(struct nvme_command), DMA_TO_DEVICE);
        nvme_rdma_free_queue(&ctrl->queues[0]);
        blk_cleanup_queue(ctrl->ctrl.admin_q);
        blk_mq_free_tag_set(&ctrl->admin_tag_set);
        nvme_rdma_dev_put(ctrl->device);
...

Note that the former calls nvme_rdma_free_queue() after the blk_* function
calls, and the latter calls it before the blk_* function calls.

This patch fixes nvme_rdma_configure_admin_queue() so it unwinds in the
same order as nvme_rdma_destroy_admin_queue().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index e1205c0..cfd8035 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1552,8 +1552,10 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl)
 	 * as the MRs in the request structures need a valid ib_device.
 	 */
 	error = -EINVAL;
-	if (!nvme_rdma_dev_get(ctrl->device))
-		goto out_free_queue;
+	if (!nvme_rdma_dev_get(ctrl->device)) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
+		goto out;
+	}
 
 	ctrl->max_fr_pages = min_t(u32, NVME_RDMA_MAX_SEGMENTS,
 		ctrl->device->dev->attrs.max_fast_reg_page_list_len);
@@ -1570,23 +1572,29 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl)
 	ctrl->admin_tag_set.timeout = ADMIN_TIMEOUT;
 
 	error = blk_mq_alloc_tag_set(&ctrl->admin_tag_set);
-	if (error)
+	if (error) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_put_dev;
+	}
 
 	ctrl->ctrl.admin_q = blk_mq_init_queue(&ctrl->admin_tag_set);
 	if (IS_ERR(ctrl->ctrl.admin_q)) {
 		error = PTR_ERR(ctrl->ctrl.admin_q);
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_free_tagset;
 	}
 
 	error = nvmf_connect_admin_queue(&ctrl->ctrl);
-	if (error)
+	if (error) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_cleanup_queue;
+	}
 
 	error = nvmf_reg_read64(&ctrl->ctrl, NVME_REG_CAP, &ctrl->cap);
 	if (error) {
 		dev_err(ctrl->ctrl.device,
 			"prop_get NVME_REG_CAP failed\n");
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_cleanup_queue;
 	}
 
@@ -1594,21 +1602,27 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl)
 		min_t(int, NVME_CAP_MQES(ctrl->cap) + 1, ctrl->ctrl.sqsize);
 
 	error = nvme_enable_ctrl(&ctrl->ctrl, ctrl->cap);
-	if (error)
+	if (error) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_cleanup_queue;
+	}
 
 	ctrl->ctrl.max_hw_sectors =
 		(ctrl->max_fr_pages - 1) << (PAGE_SHIFT - 9);
 
 	error = nvme_init_identify(&ctrl->ctrl);
-	if (error)
+	if (error) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_cleanup_queue;
+	}
 
 	error = nvme_rdma_alloc_qe(ctrl->queues[0].device->dev,
 			&ctrl->async_event_sqe, sizeof(struct nvme_command),
 			DMA_TO_DEVICE);
-	if (error)
+	if (error) {
+		nvme_rdma_free_queue(&ctrl->queues[0]);
 		goto out_cleanup_queue;
+	}
 
 	nvme_start_keep_alive(&ctrl->ctrl);
 
@@ -1620,8 +1634,7 @@ out_free_tagset:
 	blk_mq_free_tag_set(&ctrl->admin_tag_set);
 out_put_dev:
 	nvme_rdma_dev_put(ctrl->device);
-out_free_queue:
-	nvme_rdma_free_queue(&ctrl->queues[0]);
+out:
 	return error;
 }
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
