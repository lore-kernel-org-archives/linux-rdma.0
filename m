From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] RDMA/ocrdma: Removed redundant dev reference.
Date: Wed, 7 Aug 2013 12:52:33 +0530
Message-ID: <59c8f041-8c64-4699-9739-dbc15c9793f0@CMEXHTCAS1.ad.emulex.com>
References: <1375860157-10588-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375860157-10588-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Removed redundant dev reference from below structures.
1) ocrdma_cq.
2) ocrdma_ah.
3) ocrdma_hw_mr.
4) ocrdma_mw.
5) ocrdma_srq.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  5 --
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 10 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 26 ++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 76 +++++++++++++----------------
 5 files changed, 57 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 5c00600..8d54dc7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -172,7 +172,6 @@ struct ocrdma_dev {
 
 struct ocrdma_cq {
 	struct ib_cq ibcq;
-	struct ocrdma_dev *dev;
 	struct ocrdma_cqe *va;
 	u32 phase;
 	u32 getp;	/* pointer to pending wrs to
@@ -214,7 +213,6 @@ struct ocrdma_pd {
 
 struct ocrdma_ah {
 	struct ib_ah ibah;
-	struct ocrdma_dev *dev;
 	struct ocrdma_av *av;
 	u16 sgid_index;
 	u32 id;
@@ -234,7 +232,6 @@ struct ocrdma_qp_hwq_info {
 
 struct ocrdma_srq {
 	struct ib_srq ibsrq;
-	struct ocrdma_dev *dev;
 	u8 __iomem *db;
 	struct ocrdma_qp_hwq_info rq;
 	u64 *rqe_wr_id_tbl;
@@ -293,7 +290,6 @@ struct ocrdma_qp {
 };
 
 struct ocrdma_hw_mr {
-	struct ocrdma_dev *dev;
 	u32 lkey;
 	u8 fr_mr;
 	u8 remote_atomic;
@@ -321,7 +317,6 @@ struct ocrdma_mr {
 
 struct ocrdma_ucontext {
 	struct ib_ucontext ibucontext;
-	struct ocrdma_dev *dev;
 
 	struct list_head mm_head;
 	struct mutex mm_list_lock; /* protects list entries of mm type */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 55f94ac..9c5a230 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -36,12 +36,11 @@
 #include "ocrdma_ah.h"
 #include "ocrdma_hw.h"
 
-static inline int set_av_attr(struct ocrdma_ah *ah,
+static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 				struct ib_ah_attr *attr, int pdid)
 {
 	int status = 0;
 	u16 vlan_tag; bool vlan_enabled = false;
-	struct ocrdma_dev *dev = ah->dev;
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
@@ -101,12 +100,11 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	ah = kzalloc(sizeof *ah, GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
-	ah->dev = dev;
 
 	status = ocrdma_alloc_av(dev, ah);
 	if (status)
 		goto av_err;
-	status = set_av_attr(ah, attr, pd->id);
+	status = set_av_attr(dev, ah, attr, pd->id);
 	if (status)
 		goto av_conf_err;
 
@@ -127,7 +125,9 @@ av_err:
 int ocrdma_destroy_ah(struct ib_ah *ibah)
 {
 	struct ocrdma_ah *ah = get_ocrdma_ah(ibah);
-	ocrdma_free_av(ah->dev, ah);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibah->device);
+
+	ocrdma_free_av(dev, ah);
 	kfree(ah);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index eb41a1c..6bbcc78 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -523,16 +523,21 @@ static int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,
 	ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_CQ,
 			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
 
-	cmd->pgsz_pgcnt = PAGES_4K_SPANNED(cq->va, cq->size);
+	cmd->req.rsvd_version = OCRDMA_CREATE_CQ_VER2;
+	cmd->pgsz_pgcnt = (cq->size / OCRDMA_MIN_Q_PAGE_SIZE) <<
+		OCRDMA_CREATE_CQ_PAGE_SIZE_SHIFT;
+	cmd->pgsz_pgcnt |= PAGES_4K_SPANNED(cq->va, cq->size);
+
 	cmd->ev_cnt_flags = OCRDMA_CREATE_CQ_DEF_FLAGS;
-	cmd->eqn = (eq->id << OCRDMA_CREATE_CQ_EQID_SHIFT);
+	cmd->eqn = eq->id;
+	cmd->cqe_count = cq->size / sizeof(struct ocrdma_mcqe);
 
-	ocrdma_build_q_pages(&cmd->pa[0], cmd->pgsz_pgcnt,
+	ocrdma_build_q_pages(&cmd->pa[0], cq->size / OCRDMA_MIN_Q_PAGE_SIZE,
 			     cq->dma, PAGE_SIZE_4K);
 	status = be_roce_mcc_cmd(dev->nic_info.netdev,
 				 cmd, sizeof(*cmd), NULL, NULL);
 	if (!status) {
-		cq->id = (rsp->cq_id & OCRDMA_CREATE_CQ_RSP_CQ_ID_MASK);
+		cq->id = (u16) (rsp->cq_id & OCRDMA_CREATE_CQ_RSP_CQ_ID_MASK);
 		cq->created = true;
 	}
 	return status;
@@ -2326,7 +2331,7 @@ mbx_err:
 	return status;
 }
 
-int ocrdma_mbx_create_srq(struct ocrdma_srq *srq,
+int ocrdma_mbx_create_srq(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
 			  struct ib_srq_init_attr *srq_attr,
 			  struct ocrdma_pd *pd)
 {
@@ -2336,7 +2341,6 @@ int ocrdma_mbx_create_srq(struct ocrdma_srq *srq,
 	struct ocrdma_create_srq_rsp *rsp;
 	struct ocrdma_create_srq *cmd;
 	dma_addr_t pa;
-	struct ocrdma_dev *dev = srq->dev;
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	u32 max_rqe_allocated;
 
@@ -2406,13 +2410,15 @@ int ocrdma_mbx_modify_srq(struct ocrdma_srq *srq, struct ib_srq_attr *srq_attr)
 {
 	int status = -ENOMEM;
 	struct ocrdma_modify_srq *cmd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(srq->ibsrq.device);
+
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_SRQ, sizeof(*cmd));
 	if (!cmd)
 		return status;
 	cmd->id = srq->id;
 	cmd->limit_max_rqe |= srq_attr->srq_limit <<
 	    OCRDMA_MODIFY_SRQ_LIMIT_SHIFT;
-	status = ocrdma_mbx_cmd(srq->dev, (struct ocrdma_mqe *)cmd);
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	kfree(cmd);
 	return status;
 }
@@ -2421,11 +2427,13 @@ int ocrdma_mbx_query_srq(struct ocrdma_srq *srq, struct ib_srq_attr *srq_attr)
 {
 	int status = -ENOMEM;
 	struct ocrdma_query_srq *cmd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(srq->ibsrq.device);
+
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_SRQ, sizeof(*cmd));
 	if (!cmd)
 		return status;
 	cmd->id = srq->rq.dbid;
-	status = ocrdma_mbx_cmd(srq->dev, (struct ocrdma_mqe *)cmd);
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (status == 0) {
 		struct ocrdma_query_srq_rsp *rsp =
 		    (struct ocrdma_query_srq_rsp *)cmd;
@@ -2450,7 +2458,7 @@ int ocrdma_mbx_destroy_srq(struct ocrdma_dev *dev, struct ocrdma_srq *srq)
 	if (!cmd)
 		return status;
 	cmd->id = srq->id;
-	status = ocrdma_mbx_cmd(srq->dev, (struct ocrdma_mqe *)cmd);
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (srq->rq.va)
 		dma_free_coherent(&pdev->dev, srq->rq.len,
 				  srq->rq.va, srq->rq.pa);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index be5db77..5d8e6f5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -112,8 +112,7 @@ int ocrdma_mbx_modify_qp(struct ocrdma_dev *, struct ocrdma_qp *,
 int ocrdma_mbx_query_qp(struct ocrdma_dev *, struct ocrdma_qp *,
 			struct ocrdma_qp_params *param);
 int ocrdma_mbx_destroy_qp(struct ocrdma_dev *, struct ocrdma_qp *);
-
-int ocrdma_mbx_create_srq(struct ocrdma_srq *,
+int ocrdma_mbx_create_srq(struct ocrdma_dev *, struct ocrdma_srq *,
 			  struct ib_srq_init_attr *,
 			  struct ocrdma_pd *);
 int ocrdma_mbx_modify_srq(struct ocrdma_srq *, struct ib_srq_attr *);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d3d2d54..2df980b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -229,7 +229,6 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
-	ctx->dev = dev;
 	INIT_LIST_HEAD(&ctx->mm_head);
 	mutex_init(&ctx->mm_list_lock);
 
@@ -274,7 +273,8 @@ int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 {
 	struct ocrdma_mm *mm, *tmp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ibctx);
-	struct pci_dev *pdev = uctx->dev->nic_info.pdev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibctx->device);
+	struct pci_dev *pdev = dev->nic_info.pdev;
 
 	ocrdma_del_mmap(uctx, uctx->ah_tbl.pa, uctx->ah_tbl.len);
 	dma_free_coherent(&pdev->dev, uctx->ah_tbl.len, uctx->ah_tbl.va,
@@ -291,7 +291,7 @@ int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
 	struct ocrdma_ucontext *ucontext = get_ocrdma_ucontext(context);
-	struct ocrdma_dev *dev = ucontext->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(context->device);
 	unsigned long vm_page = vma->vm_pgoff << PAGE_SHIFT;
 	u64 unmapped_db = (u64) dev->nic_info.unmapped_db;
 	unsigned long len = (vma->vm_end - vma->vm_start);
@@ -431,11 +431,10 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	return status;
 }
 
-static int ocrdma_alloc_lkey(struct ocrdma_mr *mr, u32 pdid, int acc,
-			    u32 num_pbls, u32 addr_check)
+static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
+			    u32 pdid, int acc, u32 num_pbls, u32 addr_check)
 {
 	int status;
-	struct ocrdma_dev *dev = mr->hwmr.dev;
 
 	mr->hwmr.fr_mr = 0;
 	mr->hwmr.local_rd = 1;
@@ -472,8 +471,7 @@ struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *ibpd, int acc)
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->hwmr.dev = dev;
-	status = ocrdma_alloc_lkey(mr, pd->id, acc, 0,
+	status = ocrdma_alloc_lkey(dev, mr, pd->id, acc, 0,
 				   OCRDMA_ADDR_CHECK_DISABLE);
 	if (status) {
 		kfree(mr);
@@ -502,7 +500,8 @@ static void ocrdma_free_mr_pbl_tbl(struct ocrdma_dev *dev,
 	}
 }
 
-static int ocrdma_get_pbl_info(struct ocrdma_mr *mr, u32 num_pbes)
+static int ocrdma_get_pbl_info(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
+			      u32 num_pbes)
 {
 	u32 num_pbls = 0;
 	u32 idx = 0;
@@ -518,7 +517,7 @@ static int ocrdma_get_pbl_info(struct ocrdma_mr *mr, u32 num_pbes)
 		num_pbls = roundup(num_pbes, (pbl_size / sizeof(u64)));
 		num_pbls = num_pbls / (pbl_size / sizeof(u64));
 		idx++;
-	} while (num_pbls >= mr->hwmr.dev->attr.max_num_mr_pbl);
+	} while (num_pbls >= dev->attr.max_num_mr_pbl);
 
 	mr->hwmr.num_pbes = num_pbes;
 	mr->hwmr.num_pbls = num_pbls;
@@ -626,14 +625,13 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(status);
-	mr->hwmr.dev = dev;
 	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc, 0);
 	if (IS_ERR(mr->umem)) {
 		status = -EFAULT;
 		goto umem_err;
 	}
 	num_pbes = ib_umem_page_count(mr->umem);
-	status = ocrdma_get_pbl_info(mr, num_pbes);
+	status = ocrdma_get_pbl_info(dev, mr, num_pbes);
 	if (status)
 		goto umem_err;
 
@@ -669,7 +667,7 @@ umem_err:
 int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 {
 	struct ocrdma_mr *mr = get_ocrdma_mr(ib_mr);
-	struct ocrdma_dev *dev = mr->hwmr.dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ib_mr->device);
 	int status;
 
 	status = ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
@@ -684,7 +682,8 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 	return status;
 }
 
-static int ocrdma_copy_cq_uresp(struct ocrdma_cq *cq, struct ib_udata *udata,
+static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
+				struct ib_udata *udata,
 				struct ib_ucontext *ib_ctx)
 {
 	int status;
@@ -696,13 +695,13 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_cq *cq, struct ib_udata *udata,
 	uresp.num_pages = 1;
 	uresp.max_hw_cqe = cq->max_hw_cqe;
 	uresp.page_addr[0] = cq->pa;
-	uresp.db_page_addr = cq->dev->nic_info.unmapped_db;
-	uresp.db_page_size = cq->dev->nic_info.db_page_size;
+	uresp.db_page_addr = dev->nic_info.unmapped_db;
+	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.phase_change = cq->phase_change ? 1 : 0;
 	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (status) {
 		pr_err("%s(%d) copy error cqid=0x%x.\n",
-		       __func__, cq->dev->id, cq->id);
+		       __func__, dev->id, cq->id);
 		goto err;
 	}
 	uctx = get_ocrdma_ucontext(ib_ctx);
@@ -741,7 +740,6 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 	spin_lock_init(&cq->comp_handler_lock);
 	INIT_LIST_HEAD(&cq->sq_head);
 	INIT_LIST_HEAD(&cq->rq_head);
-	cq->dev = dev;
 
 	status = ocrdma_mbx_create_cq(dev, cq, entries, ureq.dpp_cq);
 	if (status) {
@@ -749,7 +747,7 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 		return ERR_PTR(status);
 	}
 	if (ib_ctx) {
-		status = ocrdma_copy_cq_uresp(cq, udata, ib_ctx);
+		status = ocrdma_copy_cq_uresp(dev, cq, udata, ib_ctx);
 		if (status)
 			goto ctx_err;
 	}
@@ -783,7 +781,7 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 {
 	int status;
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
-	struct ocrdma_dev *dev = cq->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
 
 	status = ocrdma_mbx_destroy_cq(dev, cq);
 
@@ -1455,7 +1453,8 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	return status;
 }
 
-static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
+static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
+				struct ib_udata *udata)
 {
 	int status;
 	struct ocrdma_create_srq_uresp uresp;
@@ -1464,11 +1463,11 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
 	uresp.num_rq_pages = 1;
 	uresp.rq_page_addr[0] = srq->rq.pa;
 	uresp.rq_page_size = srq->rq.len;
-	uresp.db_page_addr = srq->dev->nic_info.unmapped_db +
-	    (srq->pd->id * srq->dev->nic_info.db_page_size);
-	uresp.db_page_size = srq->dev->nic_info.db_page_size;
+	uresp.db_page_addr = dev->nic_info.unmapped_db +
+	    (srq->pd->id * dev->nic_info.db_page_size);
+	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.num_rqe_allocated = srq->rq.max_cnt;
-	if (srq->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
 		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ1_OFFSET;
 		uresp.db_shift = 24;
 	} else {
@@ -1505,10 +1504,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 		return ERR_PTR(status);
 
 	spin_lock_init(&srq->q_lock);
-	srq->dev = dev;
 	srq->pd = pd;
 	srq->db = dev->nic_info.db + (pd->id * dev->nic_info.db_page_size);
-	status = ocrdma_mbx_create_srq(srq, init_attr, pd);
+	status = ocrdma_mbx_create_srq(dev, srq, init_attr, pd);
 	if (status)
 		goto err;
 
@@ -1535,7 +1533,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 	}
 
 	if (udata) {
-		status = ocrdma_copy_srq_uresp(srq, udata);
+		status = ocrdma_copy_srq_uresp(dev, srq, udata);
 		if (status)
 			goto arm_err;
 	}
@@ -1581,10 +1579,9 @@ int ocrdma_destroy_srq(struct ib_srq *ibsrq)
 {
 	int status;
 	struct ocrdma_srq *srq;
-	struct ocrdma_dev *dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibsrq->device);
 
 	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
 
 	status = ocrdma_mbx_destroy_srq(dev, srq);
 
@@ -2351,7 +2348,7 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
 	bool expand = false;
 	int polled_hw_cqes = 0;
 	struct ocrdma_qp *qp = NULL;
-	struct ocrdma_dev *dev = cq->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(cq->ibcq.device);
 	struct ocrdma_cqe *cqe;
 	u16 cur_getp; bool polled = false; bool stop = false;
 
@@ -2432,14 +2429,11 @@ static int ocrdma_add_err_cqe(struct ocrdma_cq *cq, int num_entries,
 int ocrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	int cqes_to_poll = num_entries;
-	struct ocrdma_cq *cq = NULL;
-	unsigned long flags;
-	struct ocrdma_dev *dev;
+	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
 	int num_os_cqe = 0, err_cqes = 0;
 	struct ocrdma_qp *qp;
-
-	cq = get_ocrdma_cq(ibcq);
-	dev = cq->dev;
+	unsigned long flags;
 
 	/* poll cqes from adapter CQ */
 	spin_lock_irqsave(&cq->cq_lock, flags);
@@ -2470,16 +2464,14 @@ int ocrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 {
-	struct ocrdma_cq *cq;
-	unsigned long flags;
-	struct ocrdma_dev *dev;
+	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
 	u16 cq_id;
 	u16 cur_getp;
 	struct ocrdma_cqe *cqe;
+	unsigned long flags;
 
-	cq = get_ocrdma_cq(ibcq);
 	cq_id = cq->id;
-	dev = cq->dev;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
 	if (cq_flags & IB_CQ_NEXT_COMP || cq_flags & IB_CQ_SOLICITED)
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
