From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] RDMA/cxgb4: Serialize calls to cq's comp_handler by lock
Date: Mon, 24 Oct 2011 21:20:21 +0530
Message-ID: <1319471422-30113-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 01e7da6ba53ca4d6189a1eae45607c0331c871f2 introduced a potential
problem wherein the cq's comp_handler can get called simultaneously from
different places in iw_cxgb4 driver. This does not comply with
Documentation/infiniband/core_locking.txt, which states that at a given
point of time, there should be only one callback per CQ should be active.

This problem was reported by Parav Pandit <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>.
Based on discussion between Parav Pandit and Steve Wise, this patch
aims to correct above problem by serializing the calls to cq's comp_handler
using a spin_lock.

Reported-by: Parav Pandit <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |    1 +
 drivers/infiniband/hw/cxgb4/ev.c       |   10 ++++++++--
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 drivers/infiniband/hw/cxgb4/qp.c       |   15 +++++++++++++--
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 901c5fb..f35a935 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -818,6 +818,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	chp->cq.size--;				/* status page */
 	chp->ibcq.cqe = entries - 2;
 	spin_lock_init(&chp->lock);
+	spin_lock_init(&chp->comp_handler_lock);
 	atomic_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);
 	ret = insert_handle(rhp, &rhp->cqidr, chp, chp->cq.cqid);
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index c13041a..397cb36 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -42,6 +42,7 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 {
 	struct ib_event event;
 	struct c4iw_qp_attributes attrs;
+	unsigned long flag;
 
 	if ((qhp->attr.state == C4IW_QP_STATE_ERROR) ||
 	    (qhp->attr.state == C4IW_QP_STATE_TERMINATE)) {
@@ -72,7 +73,9 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 	if (qhp->ibqp.event_handler)
 		(*qhp->ibqp.event_handler)(&event, qhp->ibqp.qp_context);
 
+	spin_lock_irqsave(&chp->comp_handler_lock, flag);
 	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+	spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
 }
 
 void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe)
@@ -183,11 +186,14 @@ out:
 int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
 {
 	struct c4iw_cq *chp;
+	unsigned long flag;
 
 	chp = get_chp(dev, qid);
-	if (chp)
+	if (chp) {
+		spin_lock_irqsave(&chp->comp_handler_lock, flag);
 		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
-	else
+		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
+	} else
 		PDBG("%s unknown cqid 0x%x\n", __func__, qid);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 62cea0e..1357c5b 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -309,6 +309,7 @@ struct c4iw_cq {
 	struct c4iw_dev *rhp;
 	struct t4_cq cq;
 	spinlock_t lock;
+	spinlock_t comp_handler_lock;
 	atomic_t refcnt;
 	wait_queue_head_t wait;
 };
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index b59b56c..a391a4a 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -945,8 +945,11 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&rchp->lock, flag);
-	if (flushed)
+	if (flushed) {
+		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+	}
 
 	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, flag);
@@ -956,13 +959,17 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	flushed = c4iw_flush_sq(&qhp->wq, &schp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&schp->lock, flag);
-	if (flushed)
+	if (flushed) {
+		spin_lock_irqsave(&schp->comp_handler_lock, flag);
 		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
+		spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+	}
 }
 
 static void flush_qp(struct c4iw_qp *qhp)
 {
 	struct c4iw_cq *rchp, *schp;
+	unsigned long flag;
 
 	rchp = get_chp(qhp->rhp, qhp->attr.rcq);
 	schp = get_chp(qhp->rhp, qhp->attr.scq);
@@ -970,11 +977,15 @@ static void flush_qp(struct c4iw_qp *qhp)
 	if (qhp->ibqp.uobject) {
 		t4_set_wq_in_error(&qhp->wq);
 		t4_set_cq_in_error(&rchp->cq);
+		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
 		if (schp != rchp) {
 			t4_set_cq_in_error(&schp->cq);
+			spin_lock_irqsave(&schp->comp_handler_lock, flag);
 			(*schp->ibcq.comp_handler)(&schp->ibcq,
 					schp->ibcq.cq_context);
+			spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
 		}
 		return;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
