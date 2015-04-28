From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1] iw_cxgb4: Fix kbuild bot reported warnings
Date: Wed, 29 Apr 2015 00:05:38 +0530
Message-ID: <1430246138-3218-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 20dca80f ("iw_cxgb4: 32b platform fixes") introduced warnings
related to inappropriate argument type while printing arguments

Reported by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c  | 5 +++--
 drivers/infiniband/hw/cxgb4/mem.c | 4 ++--
 drivers/infiniband/hw/cxgb4/qp.c  | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index be66d5d..1f114c0 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -340,7 +340,8 @@ static void advance_oldest_read(struct t4_wq *wq)
  */
 void c4iw_flush_hw_cq(struct c4iw_cq *chp)
 {
-	struct t4_cqe *hw_cqe, *swcqe, read_cqe;
+	struct t4_cqe *hw_cqe = NULL;
+	struct t4_cqe *swcqe, read_cqe;
 	struct c4iw_qp *qhp;
 	struct t4_swsqe *swsqe;
 	int ret;
@@ -975,7 +976,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		mm2->len = PAGE_SIZE;
 		insert_mmap(ucontext, mm2);
 	}
-	PDBG("%s cqid 0x%0x chp %p size %u memsize %zu, dma_addr 0x%0llx\n",
+	PDBG("%s cqid 0x%0x chp %p size %u memsize %lu, dma_addr 0x%0llx\n",
 	     __func__, chp->cq.cqid, chp, chp->cq.size,
 	     (uintptr_t)chp->cq.memsize,
 	     (unsigned long long) chp->cq.dma_addr);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 9a26649..42805f6 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -930,7 +930,7 @@ struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(struct ib_device *device,
 
 	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
 	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
-	     (void *)(uintptr_t)c4pl->dma_addr);
+	     (dma_addr_t *)(uintptr_t)c4pl->dma_addr);
 
 	return &c4pl->ibpl;
 }
@@ -941,7 +941,7 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_list *ibpl)
 
 	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
 	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
-	     (void *)(uintptr_t)c4pl->dma_addr);
+	     (dma_addr_t *)(uintptr_t)c4pl->dma_addr);
 
 	dma_free_coherent(&c4pl->dev->rdev.lldi.pdev->dev,
 			  c4pl->pll_len,
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7ce40c3..176a238 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1784,8 +1784,8 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	qhp->ibqp.qp_num = qhp->wq.sq.qid;
 	init_timer(&(qhp->timer));
 	INIT_LIST_HEAD(&qhp->db_fc_entry);
-	PDBG("%s sq id %u size %u memsize %zu num_entries %u "
-	     "rq id %u size %u memsize %zu num_entries %u\n", __func__,
+	PDBG("%s sq id %u size %u memsize %lu num_entries %u "
+	     "rq id %u size %u memsize %lu num_entries %u\n", __func__,
 	     qhp->wq.sq.qid, qhp->wq.sq.size, (unsigned long)qhp->wq.sq.memsize,
 	     attrs->cap.max_send_wr, qhp->wq.rq.qid, qhp->wq.rq.size,
 	     (unsigned long)qhp->wq.rq.memsize, attrs->cap.max_recv_wr);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
