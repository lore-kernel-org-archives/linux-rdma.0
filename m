From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 05/14] RDMA/bnxt_re: Free doorbell page index (DPI) during dealloc ucontext
Date: Mon, 22 May 2017 03:15:35 -0700
Message-ID: <1495448144-18966-6-git-send-email-selvin.xavier@broadcom.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495448144-18966-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

The driver must free the DPI during the dealloc_ucontext
instead of freeing it during dealloc_pd. However, the DPI
allocation scheme remains unchanged.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 58 ++++++++++++++++----------------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  3 +-
 2 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index e91bd68..42dfbf3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -597,30 +597,13 @@ int bnxt_re_dealloc_pd(struct ib_pd *ib_pd)
 	int rc;
 
 	bnxt_re_destroy_fence_mr(pd);
-	if (ib_pd->uobject && pd->dpi.dbr) {
-		struct ib_ucontext *ib_uctx = ib_pd->uobject->context;
-		struct bnxt_re_ucontext *ucntx;
 
-		/* Free DPI only if this is the first PD allocated by the
-		 * application and mark the context dpi as NULL
-		 */
-		ucntx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
-
-		rc = bnxt_qplib_dealloc_dpi(&rdev->qplib_res,
-					    &rdev->qplib_res.dpi_tbl,
-					    &pd->dpi);
+	if (pd->qplib_pd.id) {
+		rc = bnxt_qplib_dealloc_pd(&rdev->qplib_res,
+					   &rdev->qplib_res.pd_tbl,
+					   &pd->qplib_pd);
 		if (rc)
-			dev_err(rdev_to_dev(rdev), "Failed to deallocate HW DPI");
-			/* Don't fail, continue*/
-		ucntx->dpi = NULL;
-	}
-
-	rc = bnxt_qplib_dealloc_pd(&rdev->qplib_res,
-				   &rdev->qplib_res.pd_tbl,
-				   &pd->qplib_pd);
-	if (rc) {
-		dev_err(rdev_to_dev(rdev), "Failed to deallocate HW PD");
-		return rc;
+			dev_err(rdev_to_dev(rdev), "Failed to deallocate HW PD");
 	}
 
 	kfree(pd);
@@ -652,23 +635,22 @@ struct ib_pd *bnxt_re_alloc_pd(struct ib_device *ibdev,
 	if (udata) {
 		struct bnxt_re_pd_resp resp;
 
-		if (!ucntx->dpi) {
+		if (!ucntx->dpi.dbr) {
 			/* Allocate DPI in alloc_pd to avoid failing of
 			 * ibv_devinfo and family of application when DPIs
 			 * are depleted.
 			 */
 			if (bnxt_qplib_alloc_dpi(&rdev->qplib_res.dpi_tbl,
-						 &pd->dpi, ucntx)) {
+						 &ucntx->dpi, ucntx)) {
 				rc = -ENOMEM;
 				goto dbfail;
 			}
-			ucntx->dpi = &pd->dpi;
 		}
 
 		resp.pdid = pd->qplib_pd.id;
 		/* Still allow mapping this DBR to the new user PD. */
-		resp.dpi = ucntx->dpi->dpi;
-		resp.dbr = (u64)ucntx->dpi->umdbr;
+		resp.dpi = ucntx->dpi.dpi;
+		resp.dbr = (u64)ucntx->dpi.umdbr;
 
 		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
 		if (rc) {
@@ -944,7 +926,7 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 		qplib_qp->rq.nmap = umem->nmap;
 	}
 
-	qplib_qp->dpi = cntx->dpi;
+	qplib_qp->dpi = &cntx->dpi;
 	return 0;
 rqfail:
 	ib_umem_release(qp->sumem);
@@ -2352,7 +2334,7 @@ struct ib_cq *bnxt_re_create_cq(struct ib_device *ibdev,
 		}
 		cq->qplib_cq.sghead = cq->umem->sg_head.sgl;
 		cq->qplib_cq.nmap = cq->umem->nmap;
-		cq->qplib_cq.dpi = uctx->dpi;
+		cq->qplib_cq.dpi = &uctx->dpi;
 	} else {
 		cq->max_cql = min_t(u32, entries, MAX_CQL_PER_POLL);
 		cq->cql = kcalloc(cq->max_cql, sizeof(struct bnxt_qplib_cqe),
@@ -3431,8 +3413,26 @@ int bnxt_re_dealloc_ucontext(struct ib_ucontext *ib_uctx)
 	struct bnxt_re_ucontext *uctx = container_of(ib_uctx,
 						   struct bnxt_re_ucontext,
 						   ib_uctx);
+
+	struct bnxt_re_dev *rdev = uctx->rdev;
+	int rc = 0;
+
 	if (uctx->shpg)
 		free_page((unsigned long)uctx->shpg);
+
+	if (uctx->dpi.dbr) {
+		/* Free DPI only if this is the first PD allocated by the
+		 * application and mark the context dpi as NULL
+		 */
+		rc = bnxt_qplib_dealloc_dpi(&rdev->qplib_res,
+					    &rdev->qplib_res.dpi_tbl,
+					    &uctx->dpi);
+		if (rc)
+			dev_err(rdev_to_dev(rdev), "Deallocte HW DPI failed!");
+			/* Don't fail, continue*/
+		uctx->dpi.dbr = NULL;
+	}
+
 	kfree(uctx);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 7a072ad..f0be321 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -59,7 +59,6 @@ struct bnxt_re_pd {
 	struct bnxt_re_dev	*rdev;
 	struct ib_pd		ib_pd;
 	struct bnxt_qplib_pd	qplib_pd;
-	struct bnxt_qplib_dpi	dpi;
 	struct bnxt_re_fence_data fence;
 };
 
@@ -126,7 +125,7 @@ struct bnxt_re_mw {
 struct bnxt_re_ucontext {
 	struct bnxt_re_dev	*rdev;
 	struct ib_ucontext	ib_uctx;
-	struct bnxt_qplib_dpi	*dpi;
+	struct bnxt_qplib_dpi	dpi;
 	void			*shpg;
 	spinlock_t		sh_lock;	/* protect shpg */
 };
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
