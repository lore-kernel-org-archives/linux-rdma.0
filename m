From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] IB/qib: Remove destroy queue pair code
Date: Wed, 03 Feb 2016 14:20:35 -0800
Message-ID: <20160203222032.4030.53250.stgit@scvm10.sc.intel.com>
References: <20160203221808.4030.95183.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221808.4030.95183.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Destroy QP functionality in rdmavt will be used instead.
Remove the remove_qp function being called exclusively by destroy qp code.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |  105 ---------------------------------
 drivers/infiniband/hw/qib/qib_verbs.c |    1 
 drivers/infiniband/hw/qib/qib_verbs.h |    2 -
 3 files changed, 0 insertions(+), 108 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index cee4aa3..45bed5f 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -209,58 +209,6 @@ bail:
 	return ret;
 }
 
-static inline unsigned qpn_hash(struct qib_ibdev *dev, u32 qpn)
-{
-	return hash_32(qpn, dev->rdi.qp_dev->qp_table_bits);
-}
-
-/*
- * Remove the QP from the table so it can't be found asynchronously by
- * the receive interrupt routine.
- */
-static void remove_qp(struct qib_ibdev *dev, struct rvt_qp *qp)
-{
-	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
-	unsigned long flags;
-	int removed = 1;
-	spinlock_t *qpt_lock_ptr; /* Pointer to make checkpatch happy */
-
-	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
-
-	qpt_lock_ptr = &dev->rdi.qp_dev->qpt_lock;
-	if (rcu_dereference_protected(ibp->rvp.qp[0],
-				      lockdep_is_held(qpt_lock_ptr)) == qp) {
-		RCU_INIT_POINTER(ibp->rvp.qp[0], NULL);
-	} else if (rcu_dereference_protected(ibp->rvp.qp[1],
-			lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)) == qp) {
-		RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
-	} else {
-		struct rvt_qp *q;
-		struct rvt_qp __rcu **qpp;
-
-		removed = 0;
-		qpp = &dev->rdi.qp_dev->qp_table[n];
-		for (; (q = rcu_dereference_protected(*qpp,
-				lockdep_is_held(qpt_lock_ptr))) != NULL;
-				qpp = &q->next)
-			if (q == qp) {
-				RCU_INIT_POINTER(*qpp,
-					rcu_dereference_protected(qp->next,
-					 lockdep_is_held(qpt_lock_ptr)));
-				removed = 1;
-				break;
-			}
-	}
-
-	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
-	if (removed) {
-		synchronize_rcu();
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
-	}
-}
-
 /**
  * qib_free_all_qps - check for QPs still in use
  */
@@ -489,59 +437,6 @@ void flush_qp_waiters(struct rvt_qp *qp)
 }
 
 /**
- * qib_destroy_qp - destroy a queue pair
- * @ibqp: the queue pair to destroy
- *
- * Returns 0 on success.
- *
- * Note that this can be called while the QP is actively sending or
- * receiving!
- */
-int qib_destroy_qp(struct ib_qp *ibqp)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct qib_ibdev *dev = to_idev(ibqp->device);
-	struct qib_qp_priv *priv = qp->priv;
-
-	/* Make sure HW and driver activity is stopped. */
-	spin_lock_irq(&qp->s_lock);
-	if (qp->state != IB_QPS_RESET) {
-		qp->state = IB_QPS_RESET;
-		spin_lock(&dev->rdi.pending_lock);
-		if (!list_empty(&priv->iowait))
-			list_del_init(&priv->iowait);
-		spin_unlock(&dev->rdi.pending_lock);
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
-		spin_unlock_irq(&qp->s_lock);
-		cancel_work_sync(&priv->s_work);
-		del_timer_sync(&qp->s_timer);
-		wait_event(priv->wait_dma, !atomic_read(&priv->s_dma_busy));
-		if (priv->s_tx) {
-			qib_put_txreq(priv->s_tx);
-			priv->s_tx = NULL;
-		}
-		remove_qp(dev, qp);
-		wait_event(qp->wait, !atomic_read(&qp->refcount));
-		rvt_clear_mr_refs(qp, 1);
-	} else
-		spin_unlock_irq(&qp->s_lock);
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
  * qib_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 187f150..e534355 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1697,7 +1697,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_port = qib_query_port;
 	ibdev->modify_port = qib_modify_port;
 	ibdev->query_gid = qib_query_gid;
-	ibdev->destroy_qp = qib_destroy_qp;
 	ibdev->process_mad = qib_process_mad;
 	ibdev->get_port_immutable = qib_port_immutable;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 0487d62..e12bb9d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -346,8 +346,6 @@ int qib_get_counters(struct qib_pportdata *ppd,
 
 __be32 qib_compute_aeth(struct rvt_qp *qp);
 
-int qib_destroy_qp(struct ib_qp *ibqp);
-
 /*
  * Functions provided by qib driver for rdmavt to use
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
