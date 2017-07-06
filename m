From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Free QP PBLEs when the QP is destroyed
Date: Wed,  5 Jul 2017 21:25:33 -0500
Message-ID: <20170706022533.34860-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the physical buffer list entries (PBLEs) of a QP are freed
up at i40iw_dereg_mr, they can be assigned to a newly
created QP before the previous QP is destroyed. Fix this
by freeing PBLEs only when the QP is destroyed.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 15 +++++++++++----
 drivers/infiniband/hw/i40iw/i40iw_verbs.h |  2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 4dbe61e..4aa0264c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -426,9 +426,13 @@ void i40iw_free_qp_resources(struct i40iw_device *iwdev,
 			     struct i40iw_qp *iwqp,
 			     u32 qp_num)
 {
+	struct i40iw_pbl *iwpbl = &iwqp->iwpbl;
+
 	i40iw_dealloc_push_page(iwdev, &iwqp->sc_qp);
 	if (qp_num)
 		i40iw_free_resource(iwdev, iwdev->allocated_qps, qp_num);
+	if (iwpbl->pbl_allocated)
+		i40iw_free_pble(iwdev->pble_rsrc, &iwpbl->pble_alloc);
 	i40iw_free_dma_mem(iwdev->sc_dev.hw, &iwqp->q2_ctx_mem);
 	i40iw_free_dma_mem(iwdev->sc_dev.hw, &iwqp->kqp.dma_mem);
 	kfree(iwqp->kqp.wrid_mem);
@@ -483,7 +487,7 @@ static int i40iw_setup_virt_qp(struct i40iw_device *iwdev,
 			       struct i40iw_qp *iwqp,
 			       struct i40iw_qp_init_info *init_info)
 {
-	struct i40iw_pbl *iwpbl = iwqp->iwpbl;
+	struct i40iw_pbl *iwpbl = &iwqp->iwpbl;
 	struct i40iw_qp_mr *qpmr = &iwpbl->qp_mr;
 
 	iwqp->page = qpmr->sq_page;
@@ -688,19 +692,22 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 			ucontext = to_ucontext(ibpd->uobject->context);
 
 			if (req.user_wqe_buffers) {
+				struct i40iw_pbl *iwpbl;
+
 				spin_lock_irqsave(
 				    &ucontext->qp_reg_mem_list_lock, flags);
-				iwqp->iwpbl = i40iw_get_pbl(
+				iwpbl = i40iw_get_pbl(
 				    (unsigned long)req.user_wqe_buffers,
 				    &ucontext->qp_reg_mem_list);
 				spin_unlock_irqrestore(
 				    &ucontext->qp_reg_mem_list_lock, flags);
 
-				if (!iwqp->iwpbl) {
+				if (!iwpbl) {
 					err_code = -ENODATA;
 					i40iw_pr_err("no pbl info\n");
 					goto error;
 				}
+				memcpy(&iwqp->iwpbl, iwpbl, sizeof(iwqp->iwpbl));
 			}
 		}
 		err_code = i40iw_setup_virt_qp(iwdev, iwqp, &init_info);
@@ -2063,7 +2070,7 @@ static int i40iw_dereg_mr(struct ib_mr *ib_mr)
 			ucontext = to_ucontext(ibpd->uobject->context);
 			i40iw_del_memlist(iwmr, ucontext);
 		}
-		if (iwpbl->pbl_allocated)
+		if (iwpbl->pbl_allocated && iwmr->type != IW_MEMREG_TYPE_QP)
 			i40iw_free_pble(iwdev->pble_rsrc, palloc);
 		kfree(iwmr);
 		return 0;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
index 07c3fec..9067443 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
@@ -170,7 +170,7 @@ struct i40iw_qp {
 	struct i40iw_qp_kmode kqp;
 	struct i40iw_dma_mem host_ctx;
 	struct timer_list terminate_timer;
-	struct i40iw_pbl *iwpbl;
+	struct i40iw_pbl iwpbl;
 	struct i40iw_dma_mem q2_ctx_mem;
 	struct i40iw_dma_mem ietf_mem;
 	struct completion sq_drained;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
