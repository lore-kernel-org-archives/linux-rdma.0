From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/3] iw_cxgb4: don't block in destroy_qp awaiting the last
 deref
Date: Mon, 18 Jul 2016 13:44:48 -0700
Message-ID: <90b07add78b64320f5a4f99b8f71633214c1823c.1468879135.git.swise@opengridcomputing.com>
References: <cover.1468879135.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1468879135.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Blocking in c4iw_destroy_qp() causes a deadlock when apps destroy a qp
or disconnect a cm_id from their cm event handler function.  There is
no nead to block here anyway, so just replace the refcnt atomic with a
kref object and free the memory on the last put.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 +-
 drivers/infiniband/hw/cxgb4/qp.c       | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index f6f34a7..0420c21 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -472,7 +472,7 @@ struct c4iw_qp {
 	struct t4_wq wq;
 	spinlock_t lock;
 	struct mutex mutex;
-	atomic_t refcnt;
+	struct kref kref;
 	wait_queue_head_t wait;
 	struct timer_list timer;
 	int sq_sig_all;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 0d461f3..770531a3 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -683,17 +683,25 @@ static int build_inv_stag(union t4_wr *wqe, struct ib_send_wr *wr,
 	return 0;
 }
 
+void _free_qp(struct kref *kref)
+{
+	struct c4iw_qp *qhp;
+
+	qhp = container_of(kref, struct c4iw_qp, kref);
+	PDBG("%s qhp %p\n", __func__, qhp);
+	kfree(qhp);
+}
+
 void c4iw_qp_add_ref(struct ib_qp *qp)
 {
 	PDBG("%s ib_qp %p\n", __func__, qp);
-	atomic_inc(&(to_c4iw_qp(qp)->refcnt));
+	kref_get(&to_c4iw_qp(qp)->kref);
 }
 
 void c4iw_qp_rem_ref(struct ib_qp *qp)
 {
 	PDBG("%s ib_qp %p\n", __func__, qp);
-	if (atomic_dec_and_test(&(to_c4iw_qp(qp)->refcnt)))
-		wake_up(&(to_c4iw_qp(qp)->wait));
+	kref_put(&to_c4iw_qp(qp)->kref, _free_qp);
 }
 
 static void add_to_fc_list(struct list_head *head, struct list_head *entry)
@@ -1592,8 +1600,6 @@ int c4iw_destroy_qp(struct ib_qp *ib_qp)
 	wait_event(qhp->wait, !qhp->ep);
 
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.sq.qid);
-	atomic_dec(&qhp->refcnt);
-	wait_event(qhp->wait, !atomic_read(&qhp->refcnt));
 
 	spin_lock_irq(&rhp->lock);
 	if (!list_empty(&qhp->db_fc_entry))
@@ -1606,8 +1612,9 @@ int c4iw_destroy_qp(struct ib_qp *ib_qp)
 	destroy_qp(&rhp->rdev, &qhp->wq,
 		   ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
 
+	c4iw_qp_rem_ref(ib_qp);
+
 	PDBG("%s ib_qp %p qpid 0x%0x\n", __func__, ib_qp, qhp->wq.sq.qid);
-	kfree(qhp);
 	return 0;
 }
 
@@ -1704,7 +1711,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	init_completion(&qhp->rq_drained);
 	mutex_init(&qhp->mutex);
 	init_waitqueue_head(&qhp->wait);
-	atomic_set(&qhp->refcnt, 1);
+	kref_init(&qhp->kref);
 
 	ret = insert_handle(rhp, &rhp->qpidr, qhp, qhp->wq.sq.qid);
 	if (ret)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
