From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] RDMA/cxgb3: Serialize calls to cq's comp_handler by lock
Date: Mon, 24 Oct 2011 21:20:22 +0530
Message-ID: <1319471422-30113-2-git-send-email-kumaras@chelsio.com>
References: <1319471422-30113-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319471422-30113-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

iw_cxgb3 has a potential problem wherein the cq's comp_handler
can get called simultaneously from different places in iw_cxgb3
driver. This does not comply with Documentation/infiniband/core_locking.txt,
which states that at a given point of time, there should be only one
callback per CQ should be active.

Such problem was reported by Parav Pandit <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> for
iw_cxgb4 driver. Based on discussion between Parav Pandit and Steve Wise,
this patch aims to correct above problem by serializing the calls to cq's
comp_handler using a spin_lock.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_ev.c       |    6 ++++++
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.h |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |   14 ++++++++++++--
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index 71e0d84..abcc9e7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -46,6 +46,7 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	struct ib_event event;
 	struct iwch_qp_attributes attrs;
 	struct iwch_qp *qhp;
+	unsigned long flag;
 
 	spin_lock(&rnicp->lock);
 	qhp = get_qhp(rnicp, CQE_QPID(rsp_msg->cqe));
@@ -94,7 +95,9 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	if (qhp->ibqp.event_handler)
 		(*qhp->ibqp.event_handler)(&event, qhp->ibqp.qp_context);
 
+	spin_lock_irqsave(&chp->comp_handler_lock, flag);
 	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+	spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
 
 	if (atomic_dec_and_test(&qhp->refcnt))
 		wake_up(&qhp->wait);
@@ -107,6 +110,7 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 	struct iwch_cq *chp;
 	struct iwch_qp *qhp;
 	u32 cqid = RSPQ_CQID(rsp_msg);
+	unsigned long flag;
 
 	rnicp = (struct iwch_dev *) rdev_p->ulp;
 	spin_lock(&rnicp->lock);
@@ -170,7 +174,9 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 		 */
 		if (qhp->ep && SQ_TYPE(rsp_msg->cqe))
 			dst_confirm(qhp->ep->dst);
+		spin_lock_irqsave(&chp->comp_handler_lock, flag);
 		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
 		break;
 
 	case TPT_ERR_STAG:
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index c7d9411..37c224f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -190,6 +190,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 	chp->rhp = rhp;
 	chp->ibcq.cqe = 1 << chp->cq.size_log2;
 	spin_lock_init(&chp->lock);
+	spin_lock_init(&chp->comp_handler_lock);
 	atomic_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);
 	if (insert_handle(rhp, &rhp->cqidr, chp, chp->cq.cqid)) {
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 9a342c9..87c14b0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -103,6 +103,7 @@ struct iwch_cq {
 	struct iwch_dev *rhp;
 	struct t3_cq cq;
 	spinlock_t lock;
+	spinlock_t comp_handler_lock;
 	atomic_t refcnt;
 	wait_queue_head_t wait;
 	u32 __user *user_rptr_addr;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index ecd313f..bea5839 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -822,8 +822,11 @@ static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
 	flushed = cxio_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&rchp->lock, *flag);
-	if (flushed)
+	if (flushed) {
+		spin_lock_irqsave(&rchp->comp_handler_lock, *flag);
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		spin_unlock_irqrestore(&rchp->comp_handler_lock, *flag);
+	}
 
 	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, *flag);
@@ -833,8 +836,11 @@ static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
 	flushed = cxio_flush_sq(&qhp->wq, &schp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&schp->lock, *flag);
-	if (flushed)
+	if (flushed) {
+		spin_lock_irqsave(&schp->comp_handler_lock, *flag);
 		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
+		spin_unlock_irqrestore(&schp->comp_handler_lock, *flag);
+	}
 
 	/* deref */
 	if (atomic_dec_and_test(&qhp->refcnt))
@@ -853,11 +859,15 @@ static void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	if (qhp->ibqp.uobject) {
 		cxio_set_wq_in_error(&qhp->wq);
 		cxio_set_cq_in_error(&rchp->cq);
+		spin_lock_irqsave(&rchp->comp_handler_lock, *flag);
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		spin_unlock_irqrestore(&rchp->comp_handler_lock, *flag);
 		if (schp != rchp) {
 			cxio_set_cq_in_error(&schp->cq);
+			spin_lock_irqsave(&schp->comp_handler_lock, *flag);
 			(*schp->ibcq.comp_handler)(&schp->ibcq,
 						   schp->ibcq.cq_context);
+			spin_unlock_irqrestore(&schp->comp_handler_lock, *flag);
 		}
 		return;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
