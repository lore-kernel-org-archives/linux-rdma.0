From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/20] IB/hfi1: Prevent kernel QP post send hard lockups
Date: Sun, 09 Apr 2017 10:16:35 -0700
Message-ID: <20170409171633.10579.64026.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver progress routines can call cond_resched() when
a timeslice is exhausted and irqs are enabled.

If the ULP had been holding a spin lock without disabling irqs and
the post send directly called the progress routine, the cond_resched()
could yield allowing another thread from the same ULP to deadlock
on that same lock.

Correct by replacing the current hfi1_do_send() calldown with a unique
one for post send and adding an argument to hfi1_do_send() to indicate
that the send engine is running in a thread.   If the routine is not
running in a thread, avoid calling cond_resched().

CC: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7.x-
Fixes: Commit 831464ce4b74 ("IB/hfi1: Don't call cond_resched in atomic mode when sending packets")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ruc.c   |   26 ++++++++++++++++----------
 drivers/infiniband/hw/hfi1/verbs.c |    4 ++--
 drivers/infiniband/hw/hfi1/verbs.h |    6 ++++--
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 879eb9b..ccf8d80 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -784,23 +784,29 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 /* when sending, force a reschedule every one of these periods */
 #define SEND_RESCHED_TIMEOUT (5 * HZ)  /* 5s in jiffies */
 
+void hfi1_do_send_from_rvt(struct rvt_qp *qp)
+{
+	hfi1_do_send(qp, false);
+}
+
 void _hfi1_do_send(struct work_struct *work)
 {
 	struct iowait *wait = container_of(work, struct iowait, iowork);
 	struct rvt_qp *qp = iowait_to_qp(wait);
 
-	hfi1_do_send(qp);
+	hfi1_do_send(qp, true);
 }
 
 /**
  * hfi1_do_send - perform a send on a QP
  * @work: contains a pointer to the QP
+ * @in_thread: true if in a workqueue thread
  *
  * Process entries in the send work queue until credit or queue is
  * exhausted.  Only allow one CPU to send a packet per QP.
  * Otherwise, two threads could send packets out of order.
  */
-void hfi1_do_send(struct rvt_qp *qp)
+void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 {
 	struct hfi1_pkt_state ps;
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -868,8 +874,10 @@ void hfi1_do_send(struct rvt_qp *qp)
 			qp->s_hdrwords = 0;
 			/* allow other tasks to run */
 			if (unlikely(time_after(jiffies, timeout))) {
-				if (workqueue_congested(cpu,
-							ps.ppd->hfi1_wq)) {
+				if (!in_thread ||
+				    workqueue_congested(
+						cpu,
+						ps.ppd->hfi1_wq)) {
 					spin_lock_irqsave(
 						&qp->s_lock,
 						ps.flags);
@@ -882,11 +890,9 @@ void hfi1_do_send(struct rvt_qp *qp)
 						*ps.ppd->dd->send_schedule);
 					return;
 				}
-				if (!irqs_disabled()) {
-					cond_resched();
-					this_cpu_inc(
-					   *ps.ppd->dd->send_schedule);
-				}
+				cond_resched();
+				this_cpu_inc(
+					*ps.ppd->dd->send_schedule);
 				timeout = jiffies + (timeout_int) / 8;
 			}
 			spin_lock_irqsave(&qp->s_lock, ps.flags);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 7f49719..e112762 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -1816,7 +1816,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
-	dd->verbs_dev.rdi.driver_f.do_send = hfi1_do_send;
+	dd->verbs_dev.rdi.driver_f.do_send = hfi1_do_send_from_rvt;
 	dd->verbs_dev.rdi.driver_f.schedule_send = hfi1_schedule_send;
 	dd->verbs_dev.rdi.driver_f.schedule_send_no_lock = _hfi1_schedule_send;
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 6c549e7..46b00ed 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -355,7 +355,9 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 
 void _hfi1_do_send(struct work_struct *work);
 
-void hfi1_do_send(struct rvt_qp *qp);
+void hfi1_do_send_from_rvt(struct rvt_qp *qp);
+
+void hfi1_do_send(struct rvt_qp *qp, bool in_thread);
 
 void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
