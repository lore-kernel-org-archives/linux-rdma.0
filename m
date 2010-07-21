From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch 2/6] infiniband: remove dependency on __GFP_NOFAIL
Date: Tue, 20 Jul 2010 19:44:56 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1007201938570.8728@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1007201936210.8728@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1007201936210.8728-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The alloc_skb() in various allocations are failable, so remove
__GFP_NOFAIL from their masks.

Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c  |    4 ++--
 drivers/infiniband/hw/cxgb4/mem.c |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -43,7 +43,7 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	int ret;
 
 	wr_len = sizeof *res_wr + sizeof *res;
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
@@ -118,7 +118,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	/* build fw_ri_res_wr */
 	wr_len = sizeof *res_wr + sizeof *res;
 
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto err4;
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -59,7 +59,7 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 		wr_len = roundup(sizeof *req + sizeof *sc +
 				 roundup(copy_len, T4_ULPTX_MIN_IO), 16);
 
-		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+		skb = alloc_skb(wr_len, GFP_KERNEL);
 		if (!skb)
 			return -ENOMEM;
 		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -130,7 +130,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	/* build fw_ri_res_wr */
 	wr_len = sizeof *res_wr + 2 * sizeof *res;
 
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto err7;
@@ -961,7 +961,7 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
 	     qhp->ep->hwtid);
 
-	skb = alloc_skb(sizeof *wqe, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(sizeof *wqe, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
@@ -1035,7 +1035,7 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	PDBG("%s qhp %p qid 0x%x tid %u\n", __func__, qhp, qhp->wq.sq.qid,
 	     qhp->ep->hwtid);
 
-	skb = alloc_skb(sizeof *wqe, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(sizeof *wqe, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
