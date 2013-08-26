From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/14] RDMA/ocrdma: Create IRD queue fix and more.
Date: Mon, 26 Aug 2013 15:27:38 +0530
Message-ID: <eb6599bf-5c4f-4fba-ad01-fb1bfb8ae09c@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1)	Fix ocrdma_get_num_posted_shift for upto 128 QPs.
2)	Create for min of dev->max_wqe and requested wqe in create_qp.
3)	As part of creating ird queue, populate with basic header templates.
4)	Make sure all the DB memory allocated to userspace are page aligned.
5)	Fix issue in checking the mmap local cache.
6)	Some code cleanup.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 21 +++++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 97 +++++++++++++++++------------
 3 files changed, 73 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index e798837..b451166 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -382,7 +382,7 @@ static inline struct ocrdma_srq *get_ocrdma_srq(struct ib_srq *ibsrq)
 static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp)
 {
 	return ((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY &&
-		 qp->id < 64) ? 24 : 16);
+		 qp->id < 128) ? 24 : 16);
 }
 
 static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 97bb1ce..31fd3ff 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -259,6 +259,7 @@ static int ocrdma_get_mbx_cqe_errno(u16 cqe_status)
 		err_num = -EAGAIN;
 		break;
 	case OCRDMA_MBX_CQE_STATUS_DMA_FAILED:
+	default:
 		err_num = -EIO;
 		break;
 	}
@@ -1340,8 +1341,6 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	struct ocrdma_create_cq_rsp *rsp;
 	u32 hw_pages, cqe_size, page_size, cqe_count;
 
-	if (dpp_cq)
-		return -EINVAL;
 	if (entries > dev->attr.max_cqe) {
 		pr_err("%s(%d) max_cqe=0x%x, requester_cqe=0x%x\n",
 		       __func__, dev->id, dev->attr.max_cqe, entries);
@@ -1735,10 +1734,9 @@ static int ocrdma_set_create_qp_sq_cmd(struct ocrdma_create_qp_req *cmd,
 	u32 max_wqe_allocated;
 	u32 max_sges = attrs->cap.max_send_sge;
 
-	max_wqe_allocated = attrs->cap.max_send_wr;
-	/* need to allocate one extra to for GEN1 family */
-	if (dev->nic_info.dev_family != OCRDMA_GEN2_FAMILY)
-		max_wqe_allocated += 1;
+	/* QP1 may exceed 127 */
+	max_wqe_allocated = min_t(int, attrs->cap.max_send_wr + 1,
+				dev->attr.max_wqe);
 
 	status = ocrdma_build_q_conf(&max_wqe_allocated,
 		dev->attr.wqe_size, &hw_pages, &hw_page_size);
@@ -1850,6 +1848,8 @@ static int ocrdma_set_create_qp_ird_cmd(struct ocrdma_create_qp_req *cmd,
 	dma_addr_t pa = 0;
 	int ird_page_size = dev->attr.ird_page_size;
 	int ird_q_len = dev->attr.num_ird_pages * ird_page_size;
+	struct ocrdma_hdr_wqe *rqe;
+	int i  = 0;
 
 	if (dev->attr.ird == 0)
 		return 0;
@@ -1861,6 +1861,15 @@ static int ocrdma_set_create_qp_ird_cmd(struct ocrdma_create_qp_req *cmd,
 	memset(qp->ird_q_va, 0, ird_q_len);
 	ocrdma_build_q_pages(&cmd->ird_addr[0], dev->attr.num_ird_pages,
 			     pa, ird_page_size);
+	for (; i < ird_q_len / dev->attr.rqe_size; i++) {
+		rqe = (struct ocrdma_hdr_wqe *)(qp->ird_q_va +
+			(i * dev->attr.rqe_size));
+		rqe->cw = 0;
+		rqe->cw |= 2;
+		rqe->cw |= (OCRDMA_TYPE_LKEY << OCRDMA_WQE_TYPE_SHIFT);
+		rqe->cw |= (8 << OCRDMA_WQE_SIZE_SHIFT);
+		rqe->cw |= (8 << OCRDMA_WQE_NXT_WQE_SIZE_SHIFT);
+	}
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 5f68dff..278b33b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -186,7 +186,7 @@ static void ocrdma_del_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 
 	mutex_lock(&uctx->mm_list_lock);
 	list_for_each_entry_safe(mm, tmp, &uctx->mm_head, entry) {
-		if (len != mm->key.len || phy_addr != mm->key.phy_addr)
+		if (len != mm->key.len && phy_addr != mm->key.phy_addr)
 			continue;
 
 		list_del(&mm->entry);
@@ -204,7 +204,7 @@ static bool ocrdma_search_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 
 	mutex_lock(&uctx->mm_list_lock);
 	list_for_each_entry(mm, &uctx->mm_head, entry) {
-		if (len != mm->key.len || phy_addr != mm->key.phy_addr)
+		if (len != mm->key.len && phy_addr != mm->key.phy_addr)
 			continue;
 
 		found = true;
@@ -307,7 +307,10 @@ int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	if ((vm_page >= unmapped_db) && (vm_page <= (unmapped_db +
 		dev->nic_info.db_total_size)) &&
 		(len <=	dev->nic_info.db_page_size)) {
-		/* doorbell mapping */
+		if (vma->vm_flags & VM_READ)
+			return -EPERM;
+
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		status = io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 					    len, vma->vm_page_prot);
 	} else if (dev->nic_info.dpp_unmapped_len &&
@@ -315,12 +318,13 @@ int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		(vm_page <= (u64) (dev->nic_info.dpp_unmapped_addr +
 			dev->nic_info.dpp_unmapped_len)) &&
 		(len <= dev->nic_info.dpp_unmapped_len)) {
-		/* dpp area mapping */
+		if (vma->vm_flags & VM_READ)
+			return -EPERM;
+
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		status = io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 					    len, vma->vm_page_prot);
 	} else {
-		/* queue memory mapping */
 		status = remap_pfn_range(vma, vma->vm_start,
 					 vma->vm_pgoff, len, vma->vm_page_prot);
 	}
@@ -351,9 +355,9 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_dev *dev, struct ocrdma_pd *pd,
 
 	if (pd->dpp_enabled) {
 		dpp_page_addr = dev->nic_info.dpp_unmapped_addr +
-				(pd->id * OCRDMA_DPP_PAGE_SIZE);
+				(pd->id * PAGE_SIZE);
 		status = ocrdma_add_mmap(uctx, dpp_page_addr,
-				 OCRDMA_DPP_PAGE_SIZE);
+				 PAGE_SIZE);
 		if (status)
 			goto dpp_map_err;
 		rsp.dpp_page_addr_hi = upper_32_bits(dpp_page_addr);
@@ -369,7 +373,7 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_dev *dev, struct ocrdma_pd *pd,
 
 ucopy_err:
 	if (pd->dpp_enabled)
-		ocrdma_del_mmap(pd->uctx, dpp_page_addr, OCRDMA_DPP_PAGE_SIZE);
+		ocrdma_del_mmap(pd->uctx, dpp_page_addr, PAGE_SIZE);
 dpp_map_err:
 	ocrdma_del_mmap(pd->uctx, db_page_addr, db_page_size);
 	return status;
@@ -392,10 +396,18 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 		pd->num_dpp_qp =
 			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
 	}
+retry:
 	status = ocrdma_mbx_alloc_pd(dev, pd);
 	if (status) {
-		kfree(pd);
-		return ERR_PTR(status);
+		/* try for pd with out dpp */
+		if (pd->dpp_enabled) {
+			pd->dpp_enabled = false;
+			pd->num_dpp_qp = 0;
+			goto retry;
+		} else {
+			kfree(pd);
+			return ERR_PTR(status);
+		}
 	}
 
 	if (udata && context) {
@@ -421,9 +433,9 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	status = ocrdma_mbx_dealloc_pd(dev, pd);
 	if (pd->uctx) {
 		u64 dpp_db = dev->nic_info.dpp_unmapped_addr +
-		    (pd->id * OCRDMA_DPP_PAGE_SIZE);
+		    (pd->id * PAGE_SIZE);
 		if (pd->dpp_enabled)
-			ocrdma_del_mmap(pd->uctx, dpp_db, OCRDMA_DPP_PAGE_SIZE);
+			ocrdma_del_mmap(pd->uctx, dpp_db, PAGE_SIZE);
 		usr_db = dev->nic_info.unmapped_db +
 		    (pd->id * dev->nic_info.db_page_size);
 		ocrdma_del_mmap(pd->uctx, usr_db, dev->nic_info.db_page_size);
@@ -693,7 +705,7 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 
 	memset(&uresp, 0, sizeof(uresp));
 	uresp.cq_id = cq->id;
-	uresp.page_size = cq->len;
+	uresp.page_size = PAGE_ALIGN(cq->len);
 	uresp.num_pages = 1;
 	uresp.max_hw_cqe = cq->max_hw_cqe;
 	uresp.page_addr[0] = cq->pa;
@@ -788,7 +800,8 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 	status = ocrdma_mbx_destroy_cq(dev, cq);
 
 	if (cq->ucontext) {
-		ocrdma_del_mmap(cq->ucontext, (u64) cq->pa, cq->len);
+		ocrdma_del_mmap(cq->ucontext, (u64) cq->pa,
+				PAGE_ALIGN(cq->len));
 		ocrdma_del_mmap(cq->ucontext, dev->nic_info.unmapped_db,
 				dev->nic_info.db_page_size);
 	}
@@ -817,14 +830,17 @@ static void ocrdma_del_qpn_map(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 				  struct ib_qp_init_attr *attrs)
 {
-	if (attrs->qp_type != IB_QPT_GSI &&
-	    attrs->qp_type != IB_QPT_RC &&
-	    attrs->qp_type != IB_QPT_UD) {
+	if ((attrs->qp_type != IB_QPT_GSI) &&
+	    (attrs->qp_type != IB_QPT_RC) &&
+	    (attrs->qp_type != IB_QPT_UC) &&
+	    (attrs->qp_type != IB_QPT_UD)) {
 		pr_err("%s(%d) unsupported qp type=0x%x requested\n",
 		       __func__, dev->id, attrs->qp_type);
 		return -EINVAL;
 	}
-	if (attrs->cap.max_send_wr > dev->attr.max_wqe) {
+	/* Skip the check for QP1 to support CM size of 128 */
+	if ((attrs->qp_type != IB_QPT_GSI) &&
+	    (attrs->cap.max_send_wr > dev->attr.max_wqe)) {
 		pr_err("%s(%d) unsupported send_wr=0x%x requested\n",
 		       __func__, dev->id, attrs->cap.max_send_wr);
 		pr_err("%s(%d) supported send_wr=0x%x\n",
@@ -875,11 +891,9 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 	/* verify consumer QPs are not trying to use GSI QP's CQ */
 	if ((attrs->qp_type != IB_QPT_GSI) && (dev->gsi_qp_created)) {
 		if ((dev->gsi_sqcq == get_ocrdma_cq(attrs->send_cq)) ||
-		    (dev->gsi_sqcq == get_ocrdma_cq(attrs->recv_cq)) ||
-		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->send_cq)) ||
-		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->recv_cq))) {
+			(dev->gsi_rqcq == get_ocrdma_cq(attrs->recv_cq))) {
 			pr_err("%s(%d) Consumer QP cannot use GSI CQs.\n",
-			       __func__, dev->id);
+				__func__, dev->id);
 			return -EINVAL;
 		}
 	}
@@ -902,13 +916,13 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	uresp.qp_id = qp->id;
 	uresp.sq_dbid = qp->sq.dbid;
 	uresp.num_sq_pages = 1;
-	uresp.sq_page_size = qp->sq.len;
+	uresp.sq_page_size = PAGE_ALIGN(qp->sq.len);
 	uresp.sq_page_addr[0] = qp->sq.pa;
 	uresp.num_wqe_allocated = qp->sq.max_cnt;
 	if (!srq) {
 		uresp.rq_dbid = qp->rq.dbid;
 		uresp.num_rq_pages = 1;
-		uresp.rq_page_size = qp->rq.len;
+		uresp.rq_page_size = PAGE_ALIGN(qp->rq.len);
 		uresp.rq_page_addr[0] = qp->rq.pa;
 		uresp.num_rqe_allocated = qp->rq.max_cnt;
 	}
@@ -1043,6 +1057,9 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 	}
 	qp->dev = dev;
 	ocrdma_set_qp_init_params(qp, pd, attrs);
+	if (udata == NULL)
+		qp->cap_flags |= (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
+					OCRDMA_QP_FAST_REG);
 
 	mutex_lock(&dev->dev_lock);
 	status = ocrdma_mbx_create_qp(qp, attrs, ureq.enable_dpp_cq,
@@ -1053,8 +1070,6 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 
 	/* user space QP's wr_id table are managed in library */
 	if (udata == NULL) {
-		qp->cap_flags |= (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
-				  OCRDMA_QP_FAST_REG);
 		status = ocrdma_alloc_wr_id_tbl(qp);
 		if (status)
 			goto map_err;
@@ -1290,22 +1305,17 @@ static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
 static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
 {
 	int free_cnt;
-	if (q->head >= q->tail)
-		free_cnt = (q->max_cnt - q->head) + q->tail;
-	else
-		free_cnt = q->tail - q->head;
-	return free_cnt;
+	return ((q->max_wqe_idx - q->head) + q->tail) % q->max_cnt;
 }
 
 static int is_hw_sq_empty(struct ocrdma_qp *qp)
 {
-	return (qp->sq.tail == qp->sq.head &&
-		ocrdma_hwq_free_cnt(&qp->sq) ? 1 : 0);
+	return (qp->sq.tail == qp->sq.head);
 }
 
 static int is_hw_rq_empty(struct ocrdma_qp *qp)
 {
-	return (qp->rq.tail == qp->rq.head) ? 1 : 0;
+	return (qp->rq.tail == qp->rq.head);
 }
 
 static void *ocrdma_hwq_head(struct ocrdma_qp_hwq_info *q)
@@ -1456,9 +1466,11 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	mutex_unlock(&dev->dev_lock);
 
 	if (pd->uctx) {
-		ocrdma_del_mmap(pd->uctx, (u64) qp->sq.pa, qp->sq.len);
+		ocrdma_del_mmap(pd->uctx, (u64) qp->sq.pa,
+				PAGE_ALIGN(qp->sq.len));
 		if (!qp->srq)
-			ocrdma_del_mmap(pd->uctx, (u64) qp->rq.pa, qp->rq.len);
+			ocrdma_del_mmap(pd->uctx, (u64) qp->rq.pa,
+					PAGE_ALIGN(qp->rq.len));
 	}
 
 	ocrdma_del_flush_qp(qp);
@@ -1603,7 +1615,8 @@ int ocrdma_destroy_srq(struct ib_srq *ibsrq)
 	status = ocrdma_mbx_destroy_srq(dev, srq);
 
 	if (srq->pd->uctx)
-		ocrdma_del_mmap(srq->pd->uctx, (u64) srq->rq.pa, srq->rq.len);
+		ocrdma_del_mmap(srq->pd->uctx, (u64) srq->rq.pa,
+				PAGE_ALIGN(srq->rq.len));
 
 	kfree(srq->idx_bit_fields);
 	kfree(srq->rqe_wr_id_tbl);
@@ -1650,7 +1663,7 @@ static int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 				    struct ocrdma_sge *sge,
 				    struct ib_send_wr *wr, u32 wqe_size)
 {
-	if (wr->send_flags & IB_SEND_INLINE) {
+	if (wr->send_flags & IB_SEND_INLINE && qp->qp_type != IB_QPT_UD) {
 		if (wr->sg_list[0].length > qp->max_inline_data) {
 			pr_err("%s() supported_len=0x%x,\n"
 			       " unspported len req=0x%x\n", __func__,
@@ -1662,6 +1675,8 @@ static int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 		       wr->sg_list[0].length);
 		hdr->total_len = wr->sg_list[0].length;
 		wqe_size += roundup(hdr->total_len, OCRDMA_WQE_ALIGN_BYTES);
+		if (0 == wr->sg_list[0].length)
+			wqe_size += sizeof(struct ocrdma_sge);
 		hdr->cw |= (OCRDMA_TYPE_INLINE << OCRDMA_WQE_TYPE_SHIFT);
 	} else {
 		ocrdma_build_sges(hdr, sge, wr->num_sge, wr->sg_list);
@@ -2208,7 +2223,8 @@ static bool ocrdma_poll_success_scqe(struct ocrdma_qp *qp,
 		ocrdma_update_wc(qp, ibwc, tail);
 		*polled = true;
 	}
-	wqe_idx = le32_to_cpu(cqe->wq.wqeidx) &	OCRDMA_CQE_WQEIDX_MASK;
+	wqe_idx = (le32_to_cpu(cqe->wq.wqeidx) &
+			OCRDMA_CQE_WQEIDX_MASK) & qp->sq.max_wqe_idx;
 	if (tail != wqe_idx)
 		expand = true; /* Coalesced CQE can't be consumed yet */
 
@@ -2257,7 +2273,8 @@ static void ocrdma_update_free_srq_cqe(struct ib_wc *ibwc,
 	u32 wqe_idx;
 
 	srq = get_ocrdma_srq(qp->ibqp.srq);
-	wqe_idx = le32_to_cpu(cqe->rq.buftag_qpn) >> OCRDMA_CQE_BUFTAG_SHIFT;
+	wqe_idx = (le32_to_cpu(cqe->rq.buftag_qpn) >>
+			OCRDMA_CQE_BUFTAG_SHIFT) & srq->rq.max_wqe_idx;
 	ibwc->wr_id = srq->rqe_wr_id_tbl[wqe_idx];
 	spin_lock_irqsave(&srq->q_lock, flags);
 	ocrdma_srq_toggle_bit(srq, wqe_idx);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
