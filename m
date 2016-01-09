From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 24/27] IB/hfi1: Remove destroy qp verb
Date: Sat, 09 Jan 2016 07:18:52 -0800
Message-ID: <20160109151852.30800.8102.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This removes the destroy qp verbs in favor of using rdmavt.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |   53 -------------------------------------
 drivers/staging/rdma/hfi1/qp.h    |   11 --------
 drivers/staging/rdma/hfi1/verbs.c |    2 +
 3 files changed, 1 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 332dc75..5a9d22e 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -287,59 +287,6 @@ __be32 hfi1_compute_aeth(struct rvt_qp *qp)
 }
 
 /**
- * hfi1_destroy_qp - destroy a queue pair
- * @ibqp: the queue pair to destroy
- *
- * Returns 0 on success.
- *
- * Note that this can be called while the QP is actively sending or
- * receiving!
- */
-int hfi1_destroy_qp(struct ib_qp *ibqp)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct hfi1_ibdev *dev = to_idev(ibqp->device);
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	/* Make sure HW and driver activity is stopped. */
-	spin_lock_irq(&qp->r_lock);
-	spin_lock(&qp->s_lock);
-	if (qp->state != IB_QPS_RESET) {
-		qp->state = IB_QPS_RESET;
-		flush_iowait(qp);
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
-		spin_unlock(&qp->s_lock);
-		spin_unlock_irq(&qp->r_lock);
-		cancel_work_sync(&priv->s_iowait.iowork);
-		del_timer_sync(&qp->s_timer);
-		iowait_sdma_drain(&priv->s_iowait);
-		flush_tx_list(qp);
-		rvt_remove_qp(ib_to_rvt(ibqp->device), qp);
-		wait_event(qp->wait, !atomic_read(&qp->refcount));
-		spin_lock_irq(&qp->r_lock);
-		spin_lock(&qp->s_lock);
-		rvt_clear_mr_refs(qp, 1);
-		clear_ahg(qp);
-	}
-	spin_unlock(&qp->s_lock);
-	spin_unlock_irq(&qp->r_lock);
-
-	/* all user's cleaned up, mark it available */
-	rvt_free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
-	rvt_dec_qp_cnt(&dev->rdi);
-
-	if (qp->ip)
-		kref_put(&qp->ip->ref, rvt_release_mmap_info);
-	else
-		vfree(qp->r_rq.wq);
-	vfree(qp->s_wq);
-	kfree(priv->s_hdr);
-	kfree(priv);
-	kfree(qp);
-	return 0;
-}
-
-/**
  * hfi1_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 160077a..0f30129 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -82,17 +82,6 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			     struct ib_qp_init_attr *init_attr,
 			     struct ib_udata *udata);
 /**
- * hfi1_destroy_qp - destroy a queue pair
- * @ibqp: the queue pair to destroy
- *
- * Returns 0 on success.
- *
- * Note that this can be called while the QP is actively sending or
- * receiving!
- */
-int hfi1_destroy_qp(struct ib_qp *ibqp);
-
-/**
  * hfi1_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index ac6b1be..b8350a8 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1639,7 +1639,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->create_qp = NULL;
 	ibdev->modify_qp = NULL;
 	ibdev->query_qp = hfi1_query_qp;
-	ibdev->destroy_qp = hfi1_destroy_qp;
+	ibdev->destroy_qp = NULL;
 	ibdev->post_send = NULL;
 	ibdev->post_recv = post_receive;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
