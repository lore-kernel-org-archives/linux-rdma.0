From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 for-next 14/14] RDMA/bnxt_re: Remove FMR support
Date: Wed, 14 Jun 2017 03:26:35 -0700
Message-ID: <1497435995-20480-15-git-send-email-selvin.xavier@broadcom.com>
References: <1497435995-20480-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497435995-20480-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some issues observed with FMR implementation
while running stress traffic. So removing the
FMR verbs support for now.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
v2 -> v3:
	- Removes the FMR verbs instead of the config option

 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 98 +-------------------------------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  6 --
 drivers/infiniband/hw/bnxt_re/main.c     |  4 --
 3 files changed, 2 insertions(+), 106 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 6b0f0cf..6629727 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -189,8 +189,8 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_total_mcast_qp_attach = 0;
 	ib_attr->max_ah = dev_attr->max_ah;
 
-	ib_attr->max_fmr = dev_attr->max_fmr;
-	ib_attr->max_map_per_fmr = 1;	/* ? */
+	ib_attr->max_fmr = 0;
+	ib_attr->max_map_per_fmr = 0;
 
 	ib_attr->max_srq = dev_attr->max_srq;
 	ib_attr->max_srq_wr = dev_attr->max_srq_wqes;
@@ -3209,100 +3209,6 @@ int bnxt_re_dealloc_mw(struct ib_mw *ib_mw)
 	return rc;
 }
 
-/* Fast Memory Regions */
-struct ib_fmr *bnxt_re_alloc_fmr(struct ib_pd *ib_pd, int mr_access_flags,
-				 struct ib_fmr_attr *fmr_attr)
-{
-	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
-	struct bnxt_re_dev *rdev = pd->rdev;
-	struct bnxt_re_fmr *fmr;
-	int rc;
-
-	if (fmr_attr->max_pages > MAX_PBL_LVL_2_PGS ||
-	    fmr_attr->max_maps > rdev->dev_attr.max_map_per_fmr) {
-		dev_err(rdev_to_dev(rdev), "Allocate FMR exceeded Max limit");
-		return ERR_PTR(-ENOMEM);
-	}
-	fmr = kzalloc(sizeof(*fmr), GFP_KERNEL);
-	if (!fmr)
-		return ERR_PTR(-ENOMEM);
-
-	fmr->rdev = rdev;
-	fmr->qplib_fmr.pd = &pd->qplib_pd;
-	fmr->qplib_fmr.type = CMDQ_ALLOCATE_MRW_MRW_FLAGS_PMR;
-
-	rc = bnxt_qplib_alloc_mrw(&rdev->qplib_res, &fmr->qplib_fmr);
-	if (rc)
-		goto fail;
-
-	fmr->qplib_fmr.flags = __from_ib_access_flags(mr_access_flags);
-	fmr->ib_fmr.lkey = fmr->qplib_fmr.lkey;
-	fmr->ib_fmr.rkey = fmr->ib_fmr.lkey;
-
-	atomic_inc(&rdev->mr_count);
-	return &fmr->ib_fmr;
-fail:
-	kfree(fmr);
-	return ERR_PTR(rc);
-}
-
-int bnxt_re_map_phys_fmr(struct ib_fmr *ib_fmr, u64 *page_list, int list_len,
-			 u64 iova)
-{
-	struct bnxt_re_fmr *fmr = container_of(ib_fmr, struct bnxt_re_fmr,
-					     ib_fmr);
-	struct bnxt_re_dev *rdev = fmr->rdev;
-	int rc;
-
-	fmr->qplib_fmr.va = iova;
-	fmr->qplib_fmr.total_size = list_len * PAGE_SIZE;
-
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &fmr->qplib_fmr, page_list,
-			       list_len, true);
-	if (rc)
-		dev_err(rdev_to_dev(rdev), "Failed to map FMR for lkey = 0x%x!",
-			fmr->ib_fmr.lkey);
-	return rc;
-}
-
-int bnxt_re_unmap_fmr(struct list_head *fmr_list)
-{
-	struct bnxt_re_dev *rdev;
-	struct bnxt_re_fmr *fmr;
-	struct ib_fmr *ib_fmr;
-	int rc = 0;
-
-	/* Validate each FMRs inside the fmr_list */
-	list_for_each_entry(ib_fmr, fmr_list, list) {
-		fmr = container_of(ib_fmr, struct bnxt_re_fmr, ib_fmr);
-		rdev = fmr->rdev;
-
-		if (rdev) {
-			rc = bnxt_qplib_dereg_mrw(&rdev->qplib_res,
-						  &fmr->qplib_fmr, true);
-			if (rc)
-				break;
-		}
-	}
-	return rc;
-}
-
-int bnxt_re_dealloc_fmr(struct ib_fmr *ib_fmr)
-{
-	struct bnxt_re_fmr *fmr = container_of(ib_fmr, struct bnxt_re_fmr,
-					       ib_fmr);
-	struct bnxt_re_dev *rdev = fmr->rdev;
-	int rc;
-
-	rc = bnxt_qplib_free_mrw(&rdev->qplib_res, &fmr->qplib_fmr);
-	if (rc)
-		dev_err(rdev_to_dev(rdev), "Failed to free FMR");
-
-	kfree(fmr);
-	atomic_dec(&rdev->mr_count);
-	return rc;
-}
-
 /* uverbs */
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 1456ccd..a0bb7e3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -196,12 +196,6 @@ int bnxt_re_dereg_mr(struct ib_mr *mr);
 struct ib_mw *bnxt_re_alloc_mw(struct ib_pd *ib_pd, enum ib_mw_type type,
 			       struct ib_udata *udata);
 int bnxt_re_dealloc_mw(struct ib_mw *mw);
-struct ib_fmr *bnxt_re_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-				 struct ib_fmr_attr *fmr_attr);
-int bnxt_re_map_phys_fmr(struct ib_fmr *fmr, u64 *page_list, int list_len,
-			 u64 iova);
-int bnxt_re_unmap_fmr(struct list_head *fmr_list);
-int bnxt_re_dealloc_fmr(struct ib_fmr *fmr);
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
 				  struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 00dab7c..c067b9c 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -510,10 +510,6 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	ibdev->dereg_mr			= bnxt_re_dereg_mr;
 	ibdev->alloc_mr			= bnxt_re_alloc_mr;
 	ibdev->map_mr_sg		= bnxt_re_map_mr_sg;
-	ibdev->alloc_fmr		= bnxt_re_alloc_fmr;
-	ibdev->map_phys_fmr		= bnxt_re_map_phys_fmr;
-	ibdev->unmap_fmr		= bnxt_re_unmap_fmr;
-	ibdev->dealloc_fmr		= bnxt_re_dealloc_fmr;
 
 	ibdev->reg_user_mr		= bnxt_re_reg_user_mr;
 	ibdev->alloc_ucontext		= bnxt_re_alloc_ucontext;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
