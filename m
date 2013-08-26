From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/14] RDMA/ocrdma: Dont use PD 0 for usepace CQ DB.
Date: Mon, 26 Aug 2013 15:27:44 +0530
Message-ID: <5fcd889c-41d3-4cfd-b0b0-069b3174fdf0@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Create_CQ verb doesnt provide a PD pointer. So, Till now we
are creating all (User mode/ Kenel mode)CQ DB regions from PD0.
This will result in mmapping PD0 to applications. A rougue userspace
application can screw things for us.

Also more serious issues is even be2net NIC uses PD0.
This patch address this problem by,
1) Create a PD page for every userspace application when the alloc_ucontext
is called. This will be destroyed in dealloc_ucontext.
2) For all CQ's created by application will use the PD allocated
in ucontext.
3) First Create_PD call from application will result in returning the
PD address from its ucontext(No new PD will be created).
4) For subsecquent create_pd calls from application, we create new PDs for
the application.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   3 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 196 +++++++++++++++++++++++-----
 5 files changed, 175 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 1c8ba4c..fde8fb0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -324,6 +324,9 @@ struct ocrdma_ucontext {
 
 	struct list_head mm_head;
 	struct mutex mm_list_lock; /* protects list entries of mm type */
+	struct ocrdma_pd *cntxt_pd;
+	int pd_in_use;
+
 	struct {
 		u32 *va;
 		dma_addr_t pa;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 16ce664..618c212 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1309,7 +1309,7 @@ static void ocrdma_unbind_eq(struct ocrdma_dev *dev, u16 eq_id)
 }
 
 int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
-			 int entries, int dpp_cq)
+			 int entries, int dpp_cq, u16 pd_id)
 {
 	int status = -ENOMEM; int max_hw_cqe;
 	struct pci_dev *pdev = dev->nic_info.pdev;
@@ -1357,7 +1357,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	cmd->cmd.ev_cnt_flags = OCRDMA_CREATE_CQ_DEF_FLAGS;
 
 	cq->eqn = ocrdma_bind_eq(dev);
-	cmd->cmd.req.rsvd_version = OCRDMA_CREATE_CQ_VER2;
+	cmd->cmd.req.rsvd_version = OCRDMA_CREATE_CQ_VER3;
 	cqe_count = cq->len / cqe_size;
 	if (cqe_count > 1024) {
 		/* Set cnt to 3 to indicate more than 1024 cq entries */
@@ -1393,6 +1393,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 		cq->phase_change = true;
 	}
 
+	cmd->cmd.pd_id = pd_id; /* valid only for v3 */
 	ocrdma_build_q_pages(&cmd->cmd.pa[0], hw_pages, cq->pa, page_size);
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (status)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index cc90ac3..044db74 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -78,6 +78,11 @@ static inline void ocrdma_copy_le32_to_cpu(void *dst, void *src, u32 len)
 #endif
 }
 
+static inline u64 ocrdma_get_db_addr(struct ocrdma_dev *dev, u32 pdid)
+{
+	return dev->nic_info.unmapped_db + (pdid * dev->nic_info.db_page_size);
+}
+
 int ocrdma_init_hw(struct ocrdma_dev *);
 void ocrdma_cleanup_hw(struct ocrdma_dev *);
 
@@ -100,7 +105,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *, int fmr, u32 lkey);
 int ocrdma_reg_mr(struct ocrdma_dev *, struct ocrdma_hw_mr *hwmr,
 			u32 pd_id, int acc);
 int ocrdma_mbx_create_cq(struct ocrdma_dev *, struct ocrdma_cq *,
-				int entries, int dpp_cq);
+				int entries, int dpp_cq, u16 pd_id);
 int ocrdma_mbx_destroy_cq(struct ocrdma_dev *, struct ocrdma_cq *);
 
 int ocrdma_mbx_create_qp(struct ocrdma_qp *, struct ib_qp_init_attr *attrs,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index d1a9fb7..1e2992f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -547,6 +547,7 @@ enum {
 
 enum {
 	OCRDMA_CREATE_CQ_VER2			= 2,
+	OCRDMA_CREATE_CQ_VER3                   = 3,
 
 	OCRDMA_CREATE_CQ_PAGE_CNT_MASK		= 0xFFFF,
 	OCRDMA_CREATE_CQ_PAGE_SIZE_SHIFT	= 16,
@@ -580,7 +581,8 @@ struct ocrdma_create_cq_cmd {
 	u32 pgsz_pgcnt;
 	u32 ev_cnt_flags;
 	u32 eqn;
-	u32 cqe_count;
+	u16 cqe_count;
+	u16 pd_id;
 	u32 rsvd6;
 	struct ocrdma_pa pa[OCRDMA_CREATE_CQ_MAX_PAGES];
 };
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 39567b6..812da17 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -215,6 +215,108 @@ static bool ocrdma_search_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 	return found;
 }
 
+static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
+					  struct ocrdma_ucontext *uctx,
+					  struct ib_udata *udata)
+{
+	struct ocrdma_pd *pd = NULL;
+	int status = 0;
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	if (udata && uctx) {
+		pd->dpp_enabled =
+			dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY;
+		pd->num_dpp_qp =
+			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
+	}
+
+retry:
+	status = ocrdma_mbx_alloc_pd(dev, pd);
+	if (status) {
+		if (pd->dpp_enabled) {
+			pd->dpp_enabled = false;
+			pd->num_dpp_qp = 0;
+			goto retry;
+		} else {
+			kfree(pd);
+			return ERR_PTR(status);
+		}
+	}
+
+	return pd;
+}
+
+static inline int is_ucontext_pd(struct ocrdma_ucontext *uctx,
+				 struct ocrdma_pd *pd)
+{
+	return (uctx->cntxt_pd == pd ? true : false);
+}
+
+static int _ocrdma_dealloc_pd(struct ocrdma_dev *dev,
+			      struct ocrdma_pd *pd)
+{
+	int status = 0;
+
+	status = ocrdma_mbx_dealloc_pd(dev, pd);
+	kfree(pd);
+	return status;
+}
+
+static int ocrdma_alloc_ucontext_pd(struct ocrdma_dev *dev,
+				    struct ocrdma_ucontext *uctx,
+				    struct ib_udata *udata)
+{
+	int status = 0;
+
+	uctx->cntxt_pd = _ocrdma_alloc_pd(dev, uctx, udata);
+	if (IS_ERR(uctx->cntxt_pd)) {
+		status = PTR_ERR(uctx->cntxt_pd);
+		uctx->cntxt_pd = NULL;
+		goto err;
+	}
+
+	uctx->cntxt_pd->uctx = uctx;
+	uctx->cntxt_pd->ibpd.device = &dev->ibdev;
+err:
+	return status;
+}
+
+static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
+{
+	int status = 0;
+	struct ocrdma_pd *pd = uctx->cntxt_pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
+
+	BUG_ON(uctx->pd_in_use);
+	uctx->cntxt_pd = NULL;
+	status = _ocrdma_dealloc_pd(dev, pd);
+	return status;
+}
+
+static struct ocrdma_pd *ocrdma_get_ucontext_pd(struct ocrdma_ucontext *uctx)
+{
+	struct ocrdma_pd *pd = NULL;
+
+	mutex_lock(&uctx->mm_list_lock);
+	if (!uctx->pd_in_use) {
+		uctx->pd_in_use = true;
+		pd = uctx->cntxt_pd;
+	}
+	mutex_unlock(&uctx->mm_list_lock);
+
+	return pd;
+}
+
+static void ocrdma_release_ucontext_pd(struct ocrdma_ucontext *uctx)
+{
+	mutex_lock(&uctx->mm_list_lock);
+	uctx->pd_in_use = false;
+	mutex_unlock(&uctx->mm_list_lock);
+}
+
 struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 					  struct ib_udata *udata)
 {
@@ -249,6 +351,11 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	status = ocrdma_add_mmap(ctx, resp.ah_tbl_page, resp.ah_tbl_len);
 	if (status)
 		goto map_err;
+
+	status = ocrdma_alloc_ucontext_pd(dev, ctx, udata);
+	if (status)
+		goto pd_err;
+
 	resp.dev_id = dev->id;
 	resp.max_inline_data = dev->attr.max_inline_data;
 	resp.wqe_size = dev->attr.wqe_size;
@@ -262,6 +369,7 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	return &ctx->ibucontext;
 
 cpy_err:
+pd_err:
 	ocrdma_del_mmap(ctx, ctx->ah_tbl.pa, ctx->ah_tbl.len);
 map_err:
 	dma_free_coherent(&pdev->dev, ctx->ah_tbl.len, ctx->ah_tbl.va,
@@ -272,11 +380,14 @@ map_err:
 
 int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 {
+	int status = 0;
 	struct ocrdma_mm *mm, *tmp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ibctx);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibctx->device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 
+	status = ocrdma_dealloc_ucontext_pd(uctx);
+
 	ocrdma_del_mmap(uctx, uctx->ah_tbl.pa, uctx->ah_tbl.len);
 	dma_free_coherent(&pdev->dev, uctx->ah_tbl.len, uctx->ah_tbl.va,
 			  uctx->ah_tbl.pa);
@@ -286,7 +397,7 @@ int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 		kfree(mm);
 	}
 	kfree(uctx);
-	return 0;
+	return status;
 }
 
 int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
@@ -346,8 +457,7 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_dev *dev, struct ocrdma_pd *pd,
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.id = pd->id;
 	rsp.dpp_enabled = pd->dpp_enabled;
-	db_page_addr = dev->nic_info.unmapped_db +
-			(pd->id * dev->nic_info.db_page_size);
+	db_page_addr = ocrdma_get_db_addr(dev, pd->id);
 	db_page_size = dev->nic_info.db_page_size;
 
 	status = ocrdma_add_mmap(uctx, db_page_addr, db_page_size);
@@ -386,31 +496,26 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 {
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
 	struct ocrdma_pd *pd;
+	struct ocrdma_ucontext *uctx = NULL;
 	int status;
+	u8 is_uctx_pd = false;
 
-	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd)
-		return ERR_PTR(-ENOMEM);
 	if (udata && context) {
-		pd->dpp_enabled =
-			(dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY);
-		pd->num_dpp_qp =
-			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
-	}
-retry:
-	status = ocrdma_mbx_alloc_pd(dev, pd);
-	if (status) {
-		/* try for pd with out dpp */
-		if (pd->dpp_enabled) {
-			pd->dpp_enabled = false;
-			pd->num_dpp_qp = 0;
-			goto retry;
-		} else {
-			kfree(pd);
-			return ERR_PTR(status);
+		uctx = get_ocrdma_ucontext(context);
+		pd = ocrdma_get_ucontext_pd(uctx);
+		if (pd) {
+			is_uctx_pd = true;
+			goto pd_mapping;
 		}
 	}
 
+	pd = _ocrdma_alloc_pd(dev, uctx, udata);
+	if (IS_ERR(pd)) {
+		status = PTR_ERR(pd);
+		goto exit;
+	}
+
+pd_mapping:
 	if (udata && context) {
 		status = ocrdma_copy_pd_uresp(dev, pd, context, udata);
 		if (status)
@@ -419,8 +524,13 @@ retry:
 	return &pd->ibpd;
 
 err:
-	status = ocrdma_mbx_dealloc_pd(dev, pd);
-	kfree(pd);
+	if (is_uctx_pd) {
+		ocrdma_release_ucontext_pd(uctx);
+	} else {
+		status = ocrdma_mbx_dealloc_pd(dev, pd);
+		kfree(pd);
+	}
+exit:
 	return ERR_PTR(status);
 }
 
@@ -428,20 +538,25 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 {
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
-	int status;
+	struct ocrdma_ucontext *uctx = NULL;
+	int status = 0;
 	u64 usr_db;
 
-	status = ocrdma_mbx_dealloc_pd(dev, pd);
-	if (pd->uctx) {
+	uctx = pd->uctx;
+	if (uctx) {
 		u64 dpp_db = dev->nic_info.dpp_unmapped_addr +
-		    (pd->id * PAGE_SIZE);
+			(pd->id * PAGE_SIZE);
 		if (pd->dpp_enabled)
 			ocrdma_del_mmap(pd->uctx, dpp_db, PAGE_SIZE);
-		usr_db = dev->nic_info.unmapped_db +
-		    (pd->id * dev->nic_info.db_page_size);
+		usr_db = ocrdma_get_db_addr(dev, pd->id);
 		ocrdma_del_mmap(pd->uctx, usr_db, dev->nic_info.db_page_size);
+
+		if (is_ucontext_pd(uctx, pd)) {
+			ocrdma_release_ucontext_pd(uctx);
+			return status;
+		}
 	}
-	kfree(pd);
+	status = _ocrdma_dealloc_pd(dev, pd);
 	return status;
 }
 
@@ -701,7 +816,7 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 				struct ib_ucontext *ib_ctx)
 {
 	int status;
-	struct ocrdma_ucontext *uctx;
+	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ib_ctx);
 	struct ocrdma_create_cq_uresp uresp;
 
 	memset(&uresp, 0, sizeof(uresp));
@@ -710,7 +825,7 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	uresp.num_pages = 1;
 	uresp.max_hw_cqe = cq->max_hw_cqe;
 	uresp.page_addr[0] = cq->pa;
-	uresp.db_page_addr = dev->nic_info.unmapped_db;
+	uresp.db_page_addr =  ocrdma_get_db_addr(dev, uctx->cntxt_pd->id);
 	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.phase_change = cq->phase_change ? 1 : 0;
 	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
@@ -719,7 +834,6 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 		       __func__, dev->id, cq->id);
 		goto err;
 	}
-	uctx = get_ocrdma_ucontext(ib_ctx);
 	status = ocrdma_add_mmap(uctx, uresp.db_page_addr, uresp.db_page_size);
 	if (status)
 		goto err;
@@ -739,6 +853,8 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 {
 	struct ocrdma_cq *cq;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
+	struct ocrdma_ucontext *uctx = NULL;
+	u16 pd_id = 0;
 	int status;
 	struct ocrdma_create_cq_ureq ureq;
 
@@ -756,7 +872,12 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 	INIT_LIST_HEAD(&cq->sq_head);
 	INIT_LIST_HEAD(&cq->rq_head);
 
-	status = ocrdma_mbx_create_cq(dev, cq, entries, ureq.dpp_cq);
+	if (ib_ctx) {
+		uctx = get_ocrdma_ucontext(ib_ctx);
+		pd_id = uctx->cntxt_pd->id;
+	}
+
+	status = ocrdma_mbx_create_cq(dev, cq, entries, ureq.dpp_cq, pd_id);
 	if (status) {
 		kfree(cq);
 		return ERR_PTR(status);
@@ -797,13 +918,16 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 	int status;
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
+	int pdid = 0;
 
 	status = ocrdma_mbx_destroy_cq(dev, cq);
 
 	if (cq->ucontext) {
+		pdid = cq->ucontext->cntxt_pd->id;
 		ocrdma_del_mmap(cq->ucontext, (u64) cq->pa,
 				PAGE_ALIGN(cq->len));
-		ocrdma_del_mmap(cq->ucontext, dev->nic_info.unmapped_db,
+		ocrdma_del_mmap(cq->ucontext,
+				ocrdma_get_db_addr(dev, pdid),
 				dev->nic_info.db_page_size);
 	}
 	dev->cq_tbl[cq->id] = NULL;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
