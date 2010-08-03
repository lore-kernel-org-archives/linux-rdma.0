From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2] IB/srp: use multiple CPU cores more effectively
Date: Tue, 3 Aug 2010 16:02:37 +0200
Message-ID: <201008031602.37294.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SRP I/O with small block sizes causes a high CPU load. Processing IB
completions on the context of a kernel thread instead of in interrupt context
allows to process up to 25% more I/O operations per second. This patch does
add a kernel parameter 'thread' that allows to specify whether to process IB
completions in interrupt context or in kernel thread context. Also, the IB
receive notification processing loop is rewritten as proposed earlier by Ralph
Campbell (see also https://patchwork.kernel.org/patch/89426/). As the
measurement results below show, rewriting the IB receive notification
processing loop did not have a measurable impact on performance. Processing
IB receive notifications in thread context however does have a measurable
impact: workloads with I/O depth one are processed at most 10% slower and
workloads with larger I/O depths are processed up to 25% faster.

Changes compared to version one of this patch:
- Changed default mode from thread=y to thread=n, such that the default
  behavior of ib_srp is unaffected.
- Fixed a bug in the IB completion processing loop that caused session
  abortion to fail after cable disconnect (changed "return" into "break").
- Limited the description of the thread kernel parameter to eighty columns
  such that checkpatch doesn't complain about it.

Measurement results:

block size  number of    IOPS        IOPS      IOPS
 in bytes    threads     without     with      with
  ($bs)     ($numjobs)  this patch  thread=n  thread=y
   512           1        25,400      25,400    23,100
   512         128       122,000     122,000   153,000
  4096           1        25,000      25,000    22,700
  4096         128       122,000     121,000   157,000
 65536           1        14,300      14,400    13,600
 65536           4        36,700      36,700    36,600
524288           1         3,470       3,430     3,420
524288           4         5,020       5,020     4,990

performance test used to gather the above results:
  fio --bs=${bs} --ioengine=sg --buffered=0 --size=128M --rw=read \
      --thread --numjobs=${numjobs} --loops=100 --group_reporting \
      --gtod_reduce=1 --name=${dev} --filename=${dev}
other ib_srp kernel module parameters: srp_sg_tablesize=128
SRP target settings: storage type NULLIO; SCSI queue depth 128.
IB HCA type: QDR.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed3f9eb..8817804 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2009-2010 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -38,6 +39,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/jiffies.h>
+#include <linux/kthread.h>
 
 #include <asm/atomic.h>
 
@@ -66,6 +68,12 @@ module_param(srp_sg_tablesize, int, 0444);
 MODULE_PARM_DESC(srp_sg_tablesize,
 		 "Max number of gather/scatter entries per I/O (default is 12, max 255)");
 
+static bool thread;
+module_param(thread, bool, 0444);
+MODULE_PARM_DESC(thread,
+		 "Whether to process IB completions in interrupt context"
+		 " (false) or kernel thread context (true)");
+
 static int topspin_workarounds = 1;
 
 module_param(topspin_workarounds, int, 0444);
@@ -81,6 +89,8 @@ MODULE_PARM_DESC(mellanox_workarounds,
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
+static void srp_notify_recv_thread(struct ib_cq *cq, void *target_ptr);
+static int srp_compl_thread(void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
@@ -229,7 +239,9 @@ static int srp_create_target_ib(struct srp_target_port *target)
 		return -ENOMEM;
 
 	target->recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
+				       thread ? srp_notify_recv_thread
+				       : srp_recv_completion,
+				       NULL, target, SRP_RQ_SIZE, 0);
 	if (IS_ERR(target->recv_cq)) {
 		ret = PTR_ERR(target->recv_cq);
 		goto err;
@@ -242,7 +254,18 @@ static int srp_create_target_ib(struct srp_target_port *target)
 		goto err_recv_cq;
 	}
 
-	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
+	if (thread) {
+		init_waitqueue_head(&target->wait_queue);
+		target->thread = kthread_run(srp_compl_thread, target,
+					     "ib_srp_compl");
+		if (IS_ERR(target->thread)) {
+			ret = PTR_ERR(target->thread);
+			goto err_send_cq;
+		}
+	} else {
+		target->thread = NULL;
+		ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
+	}
 
 	init_attr->event_handler       = srp_qp_event;
 	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
@@ -257,7 +280,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	target->qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
 	if (IS_ERR(target->qp)) {
 		ret = PTR_ERR(target->qp);
-		goto err_send_cq;
+		goto err_thread;
 	}
 
 	ret = srp_init_qp(target, target->qp);
@@ -270,6 +293,10 @@ static int srp_create_target_ib(struct srp_target_port *target)
 err_qp:
 	ib_destroy_qp(target->qp);
 
+err_thread:
+	if (target->thread)
+		kthread_stop(target->thread);
+
 err_send_cq:
 	ib_destroy_cq(target->send_cq);
 
@@ -286,6 +313,8 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	int i;
 
 	ib_destroy_qp(target->qp);
+	if (target->thread)
+		kthread_stop(target->thread);
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
 
@@ -917,23 +946,45 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 				      DMA_FROM_DEVICE);
 }
 
+static void srp_notify_recv_thread(struct ib_cq *cq, void *target_ptr)
+{
+	struct srp_target_port *target = target_ptr;
+
+	wake_up_interruptible(&target->wait_queue);
+}
+
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
 	struct ib_wc wc;
 
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status) {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed receive status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
-			break;
+	do {
+		while (ib_poll_cq(cq, 1, &wc) > 0) {
+			if (wc.status) {
+				shost_printk(KERN_ERR, target->scsi_host,
+					     PFX "failed receive status %d\n",
+					     wc.status);
+				target->qp_in_error = 1;
+				break;
+			}
+
+			srp_handle_recv(target, &wc);
 		}
+	} while (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP
+				      | IB_CQ_REPORT_MISSED_EVENTS) > 0);
+}
+
+static int srp_compl_thread(void *target_ptr)
+{
+	struct srp_target_port *target = target_ptr;
 
-		srp_handle_recv(target, &wc);
+	while (!kthread_should_stop()) {
+		wait_event_interruptible(target->wait_queue,
+			(srp_recv_completion(target->recv_cq, target),
+			 kthread_should_stop()));
 	}
+
+	return 0;
 }
 
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5a80eac..5ceb4a4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -129,6 +129,8 @@ struct srp_target_port {
 	struct ib_sa_query     *path_query;
 	int			path_query_id;
 
+	wait_queue_head_t       wait_queue;
+	struct task_struct     *thread;
 	struct ib_cm_id	       *cm_id;
 	struct ib_cq	       *recv_cq;
 	struct ib_cq	       *send_cq;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
