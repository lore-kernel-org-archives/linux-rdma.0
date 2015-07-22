From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 15/43] ocrdma: Drop ocrdma_alloc_frmr
Date: Wed, 22 Jul 2015 09:55:15 +0300
Message-ID: <1437548143-24893-16-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 41 -----------------------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |  1 -
 3 files changed, 43 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index d7ebe04..47d2814 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -295,7 +295,6 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.reg_user_mr = ocrdma_reg_user_mr;
 
 	dev->ibdev.alloc_mr = ocrdma_alloc_mr;
-	dev->ibdev.alloc_fast_reg_mr = ocrdma_alloc_frmr;
 	dev->ibdev.alloc_fast_reg_page_list = ocrdma_alloc_frmr_page_list;
 	dev->ibdev.free_fast_reg_page_list = ocrdma_free_frmr_page_list;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3487780..fb97db1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -3030,47 +3030,6 @@ pbl_err:
 	return ERR_PTR(-ENOMEM);
 }
 
-struct ib_mr *ocrdma_alloc_frmr(struct ib_pd *ibpd, int max_page_list_len)
-{
-	int status;
-	struct ocrdma_mr *mr;
-	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
-
-	if (max_page_list_len > dev->attr.max_pages_per_frmr)
-		return ERR_PTR(-EINVAL);
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-
-	status = ocrdma_get_pbl_info(dev, mr, max_page_list_len);
-	if (status)
-		goto pbl_err;
-	mr->hwmr.fr_mr = 1;
-	mr->hwmr.remote_rd = 0;
-	mr->hwmr.remote_wr = 0;
-	mr->hwmr.local_rd = 0;
-	mr->hwmr.local_wr = 0;
-	mr->hwmr.mw_bind = 0;
-	status = ocrdma_build_pbl_tbl(dev, &mr->hwmr);
-	if (status)
-		goto pbl_err;
-	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, 0);
-	if (status)
-		goto mbx_err;
-	mr->ibmr.rkey = mr->hwmr.lkey;
-	mr->ibmr.lkey = mr->hwmr.lkey;
-	dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] =
-		(unsigned long) mr;
-	return &mr->ibmr;
-mbx_err:
-	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
-pbl_err:
-	kfree(mr);
-	return ERR_PTR(-ENOMEM);
-}
-
 struct ib_fast_reg_page_list *ocrdma_alloc_frmr_page_list(struct ib_device
 							  *ibdev,
 							  int page_list_len)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index eebcda2..d09ff8e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -100,7 +100,6 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
 			      enum ib_mr_type mr_type,
 			      u32 max_entries,
 			      u32 flags);
-struct ib_mr *ocrdma_alloc_frmr(struct ib_pd *pd, int max_page_list_len);
 struct ib_fast_reg_page_list *ocrdma_alloc_frmr_page_list(struct ib_device
 							*ibdev,
 							int page_list_len);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
