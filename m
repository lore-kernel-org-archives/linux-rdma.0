From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/4] RDMA/cxgb4: Fix race in fini path.
Date: Fri, 23 Jul 2010 14:12:27 -0500
Message-ID: <20100723191227.15832.60399.stgit@build.ogc.int>
References: <20100723191221.15832.79704.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723191221.15832.79704.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There exists a race condition where the app disconnects, which initiates
an orderly close (via rdma_fini()) concurrently with an ingress abort
condition which initiates an abortive close operation.  Since rdma_fini()
must be called without IRQs disabled, the fini can be called after the
QP has been transitioned to ERROR.  This is ok, but we need to protect
against qp->ep getting NULLed.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7d87fe5..6d13f82 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -961,7 +961,8 @@ static void flush_qp(struct c4iw_qp *qhp, unsigned long *flag)
 	__flush_qp(qhp, rchp, schp, flag);
 }
 
-static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
+static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
+		     struct c4iw_ep *ep)
 {
 	struct fw_ri_wr *wqe;
 	int ret;
@@ -969,12 +970,12 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	struct sk_buff *skb;
 
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
-	     qhp->ep->hwtid);
+	     ep->hwtid);
 
 	skb = alloc_skb(sizeof *wqe, GFP_KERNEL | __GFP_NOFAIL);
 	if (!skb)
 		return -ENOMEM;
-	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
+	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
 
 	wqe = (struct fw_ri_wr *)__skb_put(skb, sizeof(*wqe));
 	memset(wqe, 0, sizeof *wqe);
@@ -982,7 +983,7 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 		FW_WR_OP(FW_RI_INIT_WR) |
 		FW_WR_COMPL(1));
 	wqe->flowid_len16 = cpu_to_be32(
-		FW_WR_FLOWID(qhp->ep->hwtid) |
+		FW_WR_FLOWID(ep->hwtid) |
 		FW_WR_LEN16(DIV_ROUND_UP(sizeof *wqe, 16)));
 	wqe->cookie = (u64)&wr_wait;
 
@@ -1212,17 +1213,16 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 		case C4IW_QP_STATE_CLOSING:
 			BUG_ON(atomic_read(&qhp->ep->com.kref.refcount) < 2);
 			qhp->attr.state = C4IW_QP_STATE_CLOSING;
+			ep = qhp->ep;
 			if (!internal) {
 				abort = 0;
 				disconnect = 1;
-				ep = qhp->ep;
 				c4iw_get_ep(&ep->com);
 			}
 			spin_unlock_irqrestore(&qhp->lock, flag);
-			ret = rdma_fini(rhp, qhp);
+			ret = rdma_fini(rhp, qhp, ep);
 			spin_lock_irqsave(&qhp->lock, flag);
 			if (ret) {
-				ep = qhp->ep;
 				c4iw_get_ep(&ep->com);
 				disconnect = abort = 1;
 				goto err;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
