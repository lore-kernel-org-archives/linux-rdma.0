From: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Subject: [patch 3/6] RDMA/cxgb3 - ib_post_send fixes
Date: Wed, 02 Dec 2009 20:36:05 -0600
Message-ID: <4B172415.90808@zago.net>
References: <20091203023350.646158428@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203023350.646158428-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_send()'s bad_wr when an error occurred.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_qp.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6.31/drivers/infiniband/hw/cxgb3/iwch_qp.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/cxgb3/iwch_qp.c	2009-12-02
19:20:53.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/cxgb3/iwch_qp.c	2009-12-02
19:23:20.000000000 -0600
@@ -365,18 +365,19 @@
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (qhp->attr.state > IWCH_QP_STATE_RTS) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 	num_wrs = Q_FREECNT(qhp->wq.sq_rptr, qhp->wq.sq_wptr,
 		  qhp->wq.sq_size_log2);
 	if (num_wrs <= 0) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out;
 	}
 	while (wr) {
 		if (num_wrs == 0) {
 			err = -ENOMEM;
-			*bad_wr = wr;
 			break;
 		}
 		idx = Q_PTR2IDX(qhp->wq.wptr, qhp->wq.size_log2);
@@ -428,10 +429,8 @@
 			     wr->opcode);
 			err = -EINVAL;
 		}
-		if (err) {
-			*bad_wr = wr;
+		if (err)
 			break;
-		}
 		wqe->send.wrid.id0.hi = qhp->wq.sq_wptr;
 		sqp->wr_id = wr->wr_id;
 		sqp->opcode = wr2opcode(t3_wr_opcode);
@@ -454,6 +453,10 @@
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
