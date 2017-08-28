From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/hfi1: Convert hfi1_error_port_qps() to use
 new QP iterator
Date: Mon, 28 Aug 2017 11:23:51 -0700
Message-ID: <20170828182350.29434.19484.stgit@scvm10.sc.intel.com>
References: <20170828182121.29434.18989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828182121.29434.18989.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change hfi1_error_port_qps() to use the new rvt_qp_iter() in its QP
scanning.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |   79 ++++++++++++++++++++-------------------
 1 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 6daa396..af71131 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -870,6 +870,45 @@ void notify_error_qp(struct rvt_qp *qp)
 }
 
 /**
+ * hfi1_qp_iter_cb - callback for iterator
+ * @qp - the qp
+ * @v - the sl in low bits of v
+ *
+ * This is called from the iterator callback to work
+ * on an individual qp.
+ */
+static void hfi1_qp_iter_cb(struct rvt_qp *qp, u64 v)
+{
+	int lastwqe;
+	struct ib_event ev;
+	struct hfi1_ibport *ibp =
+		to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	u8 sl = (u8)v;
+
+	if (qp->port_num != ppd->port ||
+	    (qp->ibqp.qp_type != IB_QPT_UC &&
+	     qp->ibqp.qp_type != IB_QPT_RC) ||
+	    rdma_ah_get_sl(&qp->remote_ah_attr) != sl ||
+	    !(ib_rvt_state_ops[qp->state] & RVT_POST_SEND_OK))
+		return;
+
+	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_hlock);
+	spin_lock(&qp->s_lock);
+	lastwqe = rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
+	spin_unlock(&qp->s_lock);
+	spin_unlock(&qp->s_hlock);
+	spin_unlock_irq(&qp->r_lock);
+	if (lastwqe) {
+		ev.device = qp->ibqp.device;
+		ev.element.qp = &qp->ibqp;
+		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	}
+}
+
+/**
  * hfi1_error_port_qps - put a port's RC/UC qps into error state
  * @ibp: the ibport.
  * @sl: the service level.
@@ -880,44 +919,8 @@ void notify_error_qp(struct rvt_qp *qp)
  */
 void hfi1_error_port_qps(struct hfi1_ibport *ibp, u8 sl)
 {
-	struct rvt_qp *qp = NULL;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_ibdev *dev = &ppd->dd->verbs_dev;
-	int n;
-	int lastwqe;
-	struct ib_event ev;
-
-	rcu_read_lock();
-
-	/* Deal only with RC/UC qps that use the given SL. */
-	for (n = 0; n < dev->rdi.qp_dev->qp_table_size; n++) {
-		for (qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]); qp;
-			qp = rcu_dereference(qp->next)) {
-			if (qp->port_num == ppd->port &&
-			    (qp->ibqp.qp_type == IB_QPT_UC ||
-			     qp->ibqp.qp_type == IB_QPT_RC) &&
-			    rdma_ah_get_sl(&qp->remote_ah_attr) == sl &&
-			    (ib_rvt_state_ops[qp->state] &
-			     RVT_POST_SEND_OK)) {
-				spin_lock_irq(&qp->r_lock);
-				spin_lock(&qp->s_hlock);
-				spin_lock(&qp->s_lock);
-				lastwqe = rvt_error_qp(qp,
-						       IB_WC_WR_FLUSH_ERR);
-				spin_unlock(&qp->s_lock);
-				spin_unlock(&qp->s_hlock);
-				spin_unlock_irq(&qp->r_lock);
-				if (lastwqe) {
-					ev.device = qp->ibqp.device;
-					ev.element.qp = &qp->ibqp;
-					ev.event =
-						IB_EVENT_QP_LAST_WQE_REACHED;
-					qp->ibqp.event_handler(&ev,
-						qp->ibqp.qp_context);
-				}
-			}
-		}
-	}
 
-	rcu_read_unlock();
+	rvt_qp_iter(&dev->rdi, sl, hfi1_qp_iter_cb);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
