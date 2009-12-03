From: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Subject: [patch 4/6] RDMA/cxgb3 - ib_post_recv fixes
Date: Wed, 02 Dec 2009 20:36:11 -0600
Message-ID: <4B17241B.1080603@zago.net>
References: <20091203023350.646158428@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203023350.646158428-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_recv()'s bad_wr when an error occurred.
Like the other IB drivers, return ENOMEM when the queue is full.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_qp.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6.31/drivers/infiniband/hw/cxgb3/iwch_qp.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/cxgb3/iwch_qp.c	2009-12-02
19:23:20.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/cxgb3/iwch_qp.c	2009-12-02
19:23:21.000000000 -0600
@@ -474,18 +474,19 @@
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (qhp->attr.state > IWCH_QP_STATE_RTS) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 	num_wrs = Q_FREECNT(qhp->wq.rq_rptr, qhp->wq.rq_wptr,
 			    qhp->wq.rq_size_log2) - 1;
 	if (!wr) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		return -EINVAL;
+		err = -ENOMEM;
+		goto out;
 	}
 	while (wr) {
 		if (wr->num_sge > T3_MAX_SGE) {
 			err = -EINVAL;
-			*bad_wr = wr;
 			break;
 		}
 		idx = Q_PTR2IDX(qhp->wq.wptr, qhp->wq.size_log2);
@@ -497,10 +498,10 @@
 				err = build_zero_stag_recv(qhp, wqe, wr);
 		else
 			err = -ENOMEM;
-		if (err) {
-			*bad_wr = wr;
+
+		if (err)
 			break;
-		}
+
 		build_fw_riwrh((void *) wqe, T3_WR_RCV, T3_COMPLETION_FLAG,
 			       Q_GENBIT(qhp->wq.wptr, qhp->wq.size_log2),
 			       0, sizeof(struct t3_receive_wr) >> 3, T3_SOPEOP);
@@ -514,6 +515,10 @@
 	}
 	spin_unlock_irqrestore(&qhp->lock, flag);
 	ring_doorbell(qhp->wq.doorbell, qhp->wq.qpid);
+
+out:
+	if (err)
+		*bad_wr = wr;
 	return err;
 }


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
