From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 4.9-rc] iw_cxgb4: invalidate the mr when posting a read_w_inv
 wr
Date: Thu, 3 Nov 2016 12:09:38 -0700
Message-ID: <20161103191128.12306E0BD0@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Also, rearrange things a bit to have a common c4iw_invalidate_mr()
function used everywhere that we need to invalidate.

Fixes: 49b53a93a64a ("iw_cxgb4: add fast-path for small REG_MR operations")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       | 17 +++--------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c      | 12 ++++++++++++
 drivers/infiniband/hw/cxgb4/qp.c       | 16 ++++++++--------
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 867b8cf..19c6477 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -666,18 +666,6 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 	return ret;
 }
 
-static void invalidate_mr(struct c4iw_dev *rhp, u32 rkey)
-{
-	struct c4iw_mr *mhp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rhp->lock, flags);
-	mhp = get_mhp(rhp, rkey >> 8);
-	if (mhp)
-		mhp->attr.state = 0;
-	spin_unlock_irqrestore(&rhp->lock, flags);
-}
-
 /*
  * Get one cq entry from c4iw and map it to openib.
  *
@@ -733,7 +721,7 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 		    CQE_OPCODE(&cqe) == FW_RI_SEND_WITH_SE_INV) {
 			wc->ex.invalidate_rkey = CQE_WRID_STAG(&cqe);
 			wc->wc_flags |= IB_WC_WITH_INVALIDATE;
-			invalidate_mr(qhp->rhp, wc->ex.invalidate_rkey);
+			c4iw_invalidate_mr(qhp->rhp, wc->ex.invalidate_rkey);
 		}
 	} else {
 		switch (CQE_OPCODE(&cqe)) {
@@ -762,7 +750,8 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 
 			/* Invalidate the MR if the fastreg failed */
 			if (CQE_STATUS(&cqe) != T4_ERR_SUCCESS)
-				invalidate_mr(qhp->rhp, CQE_WRID_FR_STAG(&cqe));
+				c4iw_invalidate_mr(qhp->rhp,
+						   CQE_WRID_FR_STAG(&cqe));
 			break;
 		default:
 			printk(KERN_ERR MOD "Unexpected opcode %d "
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 7e7f79e..4788e1a 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -999,6 +999,6 @@ extern int db_coalescing_threshold;
 extern int use_dsgl;
 void c4iw_drain_rq(struct ib_qp *qp);
 void c4iw_drain_sq(struct ib_qp *qp);
-
+void c4iw_invalidate_mr(struct c4iw_dev *rhp, u32 rkey);
 
 #endif
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 80e2774..410408f 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -770,3 +770,15 @@ int c4iw_dereg_mr(struct ib_mr *ib_mr)
 	kfree(mhp);
 	return 0;
 }
+
+void c4iw_invalidate_mr(struct c4iw_dev *rhp, u32 rkey)
+{
+	struct c4iw_mr *mhp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rhp->lock, flags);
+	mhp = get_mhp(rhp, rkey >> 8);
+	if (mhp)
+		mhp->attr.state = 0;
+	spin_unlock_irqrestore(&rhp->lock, flags);
+}
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 5790e1d..b7ac97b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -706,12 +706,8 @@ static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
 	return 0;
 }
 
-static int build_inv_stag(struct c4iw_dev *dev, union t4_wr *wqe,
-			  struct ib_send_wr *wr, u8 *len16)
+static int build_inv_stag(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 {
-	struct c4iw_mr *mhp = get_mhp(dev, wr->ex.invalidate_rkey >> 8);
-
-	mhp->attr.state = 0;
 	wqe->inv.stag_inv = cpu_to_be32(wr->ex.invalidate_rkey);
 	wqe->inv.r2 = 0;
 	*len16 = DIV_ROUND_UP(sizeof wqe->inv, 16);
@@ -842,10 +838,13 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_RDMA_READ_WITH_INV:
 			fw_opcode = FW_RI_RDMA_READ_WR;
 			swsqe->opcode = FW_RI_READ_REQ;
-			if (wr->opcode == IB_WR_RDMA_READ_WITH_INV)
+			if (wr->opcode == IB_WR_RDMA_READ_WITH_INV) {
+				c4iw_invalidate_mr(qhp->rhp,
+						   wr->sg_list[0].lkey);
 				fw_flags = FW_RI_RDMA_READ_INVALIDATE;
-			else
+			} else {
 				fw_flags = 0;
+			}
 			err = build_rdma_read(wqe, wr, &len16);
 			if (err)
 				break;
@@ -878,7 +877,8 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				fw_flags |= FW_RI_LOCAL_FENCE_FLAG;
 			fw_opcode = FW_RI_INV_LSTAG_WR;
 			swsqe->opcode = FW_RI_LOCAL_INV;
-			err = build_inv_stag(qhp->rhp, wqe, wr, &len16);
+			err = build_inv_stag(wqe, wr, &len16);
+			c4iw_invalidate_mr(qhp->rhp, wr->ex.invalidate_rkey);
 			break;
 		default:
 			PDBG("%s post of type=%d TBD!\n", __func__,
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
