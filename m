From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Fix deadlock with txreq allocation slow path
Date: Wed, 20 Jul 2016 17:12:54 -0400
Message-ID: <20160720211254.15373.67532.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A failure in the get_txreq() inline will result in a
slow path retry using __get_txreq().

__get_txreq() attempts to procure the qp s_lock, which
is already held in all callers.

Fix by deleting the s_lock maintenance in __get_txreq()
and add sparse syntax hooks to future proof the code.

Ported from upstream 2aee309d3e01 to 4.6 stable.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs_txreq.c |    4 +---
 drivers/staging/rdma/hfi1/verbs_txreq.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.c b/drivers/staging/rdma/hfi1/verbs_txreq.c
index bc95c41..d8fb056 100644
--- a/drivers/staging/rdma/hfi1/verbs_txreq.c
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.c
@@ -92,11 +92,10 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 
 struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 				struct rvt_qp *qp)
+	__must_hold(&qp->s_lock)
 {
 	struct verbs_txreq *tx = ERR_PTR(-EBUSY);
-	unsigned long flags;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
 	write_seqlock(&dev->iowait_lock);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		struct hfi1_qp_priv *priv;
@@ -116,7 +115,6 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	}
 out:
 	write_sequnlock(&dev->iowait_lock);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return tx;
 }
 
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/staging/rdma/hfi1/verbs_txreq.h
index 1cf69b2..a1d6e08 100644
--- a/drivers/staging/rdma/hfi1/verbs_txreq.h
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.h
@@ -73,6 +73,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 
 static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 					    struct rvt_qp *qp)
+	__must_hold(&qp->slock)
 {
 	struct verbs_txreq *tx;
 	struct hfi1_qp_priv *priv = qp->priv;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
