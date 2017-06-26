From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Deadlock on device removal event for NVMeF target
Date: Mon, 26 Jun 2017 17:59:20 -0500
Message-ID: <20170626225920.GA11700@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi/Christoph,

I am seeing a deadlock for a device removal event on NVMeF target.

The sequence of events leading to the deadlock are as follows,

1. i40iw posts IW_CM_EVENT_CLOSE events for all QPs causing the corresponding 
NVMet RDMA Queues to disconnect and schedule release of any pending work on WQ
2. i40iw triggers device removal 
	ib_unregister_device
	[..]
	cma_remove_id_dev (takes a handler lock before calling the event handler)
	nvmet_rdma_cm_handler
	nvmet_rdma_device_removal (queue->state = NVMET_RDMA_Q_DISCONNECTING due to 1.)
	flush_scheduled_work (blocks till all scheduled work is drained from WQ)
	nvmet_rdma_release_queue_work (queue->state = NVMET_RDMA_Q_DISCONNECTING)
	rdma_destroy_id (waits on the same handler lock as cma_remove_id_dev causing the deadlock)
     
So this problem can occur when there is a device removal event while the queue is in 
disconnect state with the some oustanding work that hasnt been drained from the WQ at the
time flush_scheduled_work is called.

Here is a call trace with some debug logs. The problematic cm_id is ffff8806e9924d18.

[371.577371] nvmet_rdma: nvmet_rdma_cm_handler: disconnected (10): cm_id ffff8806de8acd18
[371.577378] nvmet_rdma: __nvmet_rdma_queue_disconnect: cm_id= ffff8806de8acd18 queue->state= 1 queue->idx = 1
[371.577381] nvmet_rdma: __nvmet_rdma_queue_disconnect: rdma_disconnect cm_id= ffff8806de8acd18
[371.577501] nvmet_rdma: nvmet_rdma_cm_handler: disconnected (10): cm_id ffff8806e9924d18
[371.577502] nvmet_rdma: nvmet_rdma_cm_handler: device removal (11): cm_id ffff8806e6b6d5a8
[371.577504] nvmet_rdma: nvmet_rdma_device_removal: queue           (null)
[371.577506] nvmet_rdma: __nvmet_rdma_queue_disconnect: cm_id= ffff8806e9924d18 queue->state= 1 queue->idx = 0
[371.577507] rdma_destroy_id id ffff8806e6b6d5a8
[371.577509] nvmet_rdma: __nvmet_rdma_queue_disconnect: rdma_disconnect cm_id= ffff8806e9924d18
[371.577870] nvmet_rdma: nvmet_rdma_cm_handler: device removal (11): cm_id ffff8806e9924d18
[371.577877] nvmet_rdma: nvmet_rdma_device_removal: calling flush_scheduled_work queue state 2 idx 0 cm_id ffff8806e9924d18
[371.580174] nvmet_rdma: nvmet_rdma_queue_response_post_send: 2 opcode 2 queue_state 2 queue_idx 0
[371.580198] nvmet_rdma: sending cmd response failed
[371.596356] nvmet_rdma: nvmet_rdma_release_queue_work: calling rdma_destroy_id cm_id ffff8806de8acd18 queue_idx 1 state 2
[371.596358] rdma_destroy_id id ffff8806de8acd18
[371.596512] nvmet_rdma: nvmet_rdma_release_queue_work: calling rdma_destroy_id cm_id ffff8806e9924d18 queue_idx 0 state 2
[371.596514] rdma_destroy_id id ffff8806e9924d18                    ------------------------------------------------> Hang                                                             
[614.390162] INFO: task kworker/6:1:4429 blocked for more than 120 seconds.
[614.390165]       Tainted: G           O    4.11.0-rc8+ #11
[614.390166] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[614.390167] kworker/6:1     D30016  4429      2 0x00000000
[614.390176] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[614.390178] Call Trace:
[614.390182]  __schedule+0x378/0xbf0
[614.390185]  schedule+0x38/0x90
[614.390186]  schedule_preempt_disabled+0x10/0x20
[614.390188]  __mutex_lock+0x2ac/0x960
[614.390190]  ? __mutex_lock+0xb6/0x960
[614.390193]  ? rdma_destroy_id+0x6a/0x2e0 [rdma_cm]
[614.390196]  mutex_lock_nested+0x16/0x20
[614.390198]  rdma_destroy_id+0x6a/0x2e0 [rdma_cm]
[614.390201]  nvmet_rdma_release_queue_work+0x78/0x80 [nvmet_rdma]
[614.390203]  process_one_work+0x203/0x710
[614.390204]  ? process_one_work+0x16f/0x710
[614.390207]  worker_thread+0x126/0x4a0
[614.390210]  kthread+0x112/0x150
[614.390212]  ? process_one_work+0x710/0x710
[614.390213]  ? kthread_create_on_node+0x40/0x40
[614.390216]  ret_from_fork+0x2e/0x40
[614.390219] INFO: lockdep is turned off.
[614.390239] INFO: task rmmod:8443 blocked for more than 120 seconds.
[614.390241]       Tainted: G           O    4.11.0-rc8+ #11
[614.390242] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[614.390243] rmmod           D29880  8443   7036 0x00000080
[614.390248] Call Trace:
[614.390250]  __schedule+0x378/0xbf0
[614.390252]  schedule+0x38/0x90
[614.390254]  schedule_timeout+0x235/0x4f0
[614.390257]  ? mark_held_locks+0x71/0x90
[614.390259]  ? _raw_spin_unlock_irq+0x27/0x40
[614.390261]  wait_for_completion+0xb4/0x120
[614.390264]  ? wake_up_q+0x70/0x70
[614.390267]  flush_workqueue+0x211/0x6c0
[614.390269]  ? flush_workqueue+0x100/0x6c0
[614.390271]  ? vprintk_emit+0x211/0x2e0
[614.390275]  ? printk+0x43/0x45
[614.390277]  ? wait_for_completion+0x36/0x120
[614.390280]  nvmet_rdma_cm_handler+0x34f/0xf50 [nvmet_rdma]
[614.390282]  ? cma_comp+0x39/0x50 [rdma_cm]
[614.390284]  ? mark_held_locks+0x71/0x90
[614.390286]  ? _raw_spin_unlock_irqrestore+0x31/0x50
[614.390289]  ? trace_hardirqs_on+0xd/0x10
[614.390292]  cma_remove_one+0x1fc/0x220 [rdma_cm]
[614.390299]  ib_unregister_device+0xd8/0x170 [ib_core]
[614.390303]  i40iw_destroy_rdma_device+0x55/0x160 [i40iw]
[614.390307]  i40iw_deinit_device+0x96/0x460 [i40iw]
[614.390311]  i40iw_close+0x54/0xc0 [i40iw]
[614.390316]  i40e_unregister_client+0xaf/0x1b0 [i40e]
[614.390320]  i40iw_exit_module+0x10/0xaa4 [i40iw]
[614.390322]  SyS_delete_module+0x16a/0x230
[614.390325]  do_syscall_64+0x59/0x1a0
[614.390327]  entry_SYSCALL64_slow_path+0x25/0x25
[614.390329] RIP: 0033:0x7f955841d697
[614.390339] INFO: lockdep is turned off

This patch fixed the problem but I am not sure if it is the correct fix.

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9e45cde..d0fb307 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1349,6 +1349,12 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
                spin_lock_irqsave(&queue->state_lock, flags);
                if (queue->state != NVMET_RDMA_Q_DISCONNECTING)
                        queue->state = NVMET_RDMA_IN_DEVICE_REMOVAL;
+               else {
+                       /*queue is disconnecting; so cm_id and queues will be destroyed*/
+                       spin_unlock_irqrestore(&queue->state_lock, flags);
+                       return 0;
+               }
+
                spin_unlock_irqrestore(&queue->state_lock, flags);
                nvmet_rdma_queue_disconnect(queue);
                flush_scheduled_work();


Shiraz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
