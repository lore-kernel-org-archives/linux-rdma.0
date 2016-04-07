From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 13/16] i40iw: Add base memory management extensions
Date: Thu,  7 Apr 2016 11:31:01 -0500
Message-ID: <1460046664-552-14-git-send-email-mustafa.ismail@intel.com>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460046664-552-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implement fast register mr, Local invalidate, send with
invalidate and RDMA read with invalidate.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  60 +++++++++
 drivers/infiniband/hw/i40iw/i40iw_type.h  |   3 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 204 ++++++++++++++++++++++++++++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.h |   1 +
 4 files changed, 260 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index f05802b..6e5a73b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2909,6 +2909,65 @@ static enum i40iw_status_code i40iw_sc_mw_alloc(
 }
 
 /**
+ * i40iw_sc_mr_fast_register - Posts RDMA fast register mr WR to iwarp qp
+ * @qp: sc qp struct
+ * @info: fast mr info
+ * @post_sq: flag for cqp db to ring
+ */
+enum i40iw_status_code i40iw_sc_mr_fast_register(
+				struct i40iw_sc_qp *qp,
+				struct i40iw_fast_reg_stag_info *info,
+				bool post_sq)
+{
+	u64 temp, header;
+	u64 *wqe;
+	u32 wqe_idx;
+
+	wqe = i40iw_qp_get_next_send_wqe(&qp->qp_uk, &wqe_idx, I40IW_QP_WQE_MIN_SIZE,
+					 0, info->wr_id);
+	if (!wqe)
+		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
+
+	i40iw_debug(qp->dev, I40IW_DEBUG_MR, "%s: wr_id[%llxh] wqe_idx[%04d] location[%p]\n",
+		    __func__, info->wr_id, wqe_idx,
+		    &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
+	temp = (info->addr_type == I40IW_ADDR_TYPE_VA_BASED) ? (uintptr_t)info->va : info->fbo;
+	set_64bit_val(wqe, 0, temp);
+
+	temp = RS_64(info->first_pm_pbl_index >> 16, I40IWQPSQ_FIRSTPMPBLIDXHI);
+	set_64bit_val(wqe,
+		      8,
+		      LS_64(temp, I40IWQPSQ_FIRSTPMPBLIDXHI) |
+		      LS_64(info->reg_addr_pa >> I40IWQPSQ_PBLADDR_SHIFT, I40IWQPSQ_PBLADDR));
+
+	set_64bit_val(wqe,
+		      16,
+		      info->total_len |
+		      LS_64(info->first_pm_pbl_index, I40IWQPSQ_FIRSTPMPBLIDXLO));
+
+	header = LS_64(info->stag_key, I40IWQPSQ_STAGKEY) |
+		 LS_64(info->stag_idx, I40IWQPSQ_STAGINDEX) |
+		 LS_64(I40IWQP_OP_FAST_REGISTER, I40IWQPSQ_OPCODE) |
+		 LS_64(info->chunk_size, I40IWQPSQ_LPBLSIZE) |
+		 LS_64(info->page_size, I40IWQPSQ_HPAGESIZE) |
+		 LS_64(info->access_rights, I40IWQPSQ_STAGRIGHTS) |
+		 LS_64(info->addr_type, I40IWQPSQ_VABASEDTO) |
+		 LS_64(info->read_fence, I40IWQPSQ_READFENCE) |
+		 LS_64(info->local_fence, I40IWQPSQ_LOCALFENCE) |
+		 LS_64(info->signaled, I40IWQPSQ_SIGCOMPL) |
+		 LS_64(qp->qp_uk.swqe_polarity, I40IWQPSQ_VALID);
+
+	i40iw_insert_wqe_hdr(wqe, header);
+
+	i40iw_debug_buf(qp->dev, I40IW_DEBUG_WQE, "FAST_REG WQE",
+			wqe, I40IW_QP_WQE_MIN_SIZE);
+
+	if (post_sq)
+		i40iw_qp_post_wr(&qp->qp_uk);
+	return 0;
+}
+
+/**
  * i40iw_sc_send_lsmm - send last streaming mode message
  * @qp: sc qp struct
  * @lsmm_buf: buffer with lsmm message
@@ -4570,6 +4629,7 @@ static struct i40iw_priv_qp_ops iw_priv_qp_ops = {
 	i40iw_sc_send_lsmm_nostag,
 	i40iw_sc_send_rtt,
 	i40iw_sc_post_wqe0,
+	i40iw_sc_mr_fast_register,
 };
 
 static struct i40iw_priv_cq_ops iw_priv_cq_ops = {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index 5b6a491..c926198 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -1041,6 +1041,9 @@ struct i40iw_priv_qp_ops {
 	void (*qp_send_lsmm_nostag)(struct i40iw_sc_qp *, void *, u32);
 	void (*qp_send_rtt)(struct i40iw_sc_qp *, bool);
 	enum i40iw_status_code (*qp_post_wqe0)(struct i40iw_sc_qp *, u8);
+	enum i40iw_status_code (*iw_mr_fast_register)(struct i40iw_sc_qp *,
+						      struct i40iw_fast_reg_stag_info *,
+						      bool);
 };
 
 struct i40iw_priv_cq_ops {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index b7fd9f3..9da5361 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -725,8 +725,10 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 	iwarp_info = &iwqp->iwarp_info;
 	iwarp_info->rd_enable = true;
 	iwarp_info->wr_rdresp_en = true;
-	if (!iwqp->user_mode)
+	if (!iwqp->user_mode) {
+		iwarp_info->fast_reg_en = true;
 		iwarp_info->priv_mode_en = true;
+	}
 	iwarp_info->ddp_ver = 1;
 	iwarp_info->rdmap_ver = 1;
 
@@ -1447,6 +1449,139 @@ static int i40iw_handle_q_mem(struct i40iw_device *iwdev,
 }
 
 /**
+ * i40iw_hw_alloc_stag - cqp command to allocate stag
+ * @iwdev: iwarp device
+ * @iwmr: iwarp mr pointer
+ */
+static int i40iw_hw_alloc_stag(struct i40iw_device *iwdev, struct i40iw_mr *iwmr)
+{
+	struct i40iw_allocate_stag_info *info;
+	struct i40iw_pd *iwpd = to_iwpd(iwmr->ibmr.pd);
+	enum i40iw_status_code status;
+	int err = 0;
+	struct i40iw_cqp_request *cqp_request;
+	struct cqp_commands_info *cqp_info;
+
+	cqp_request = i40iw_get_cqp_request(&iwdev->cqp, true);
+	if (!cqp_request)
+		return -ENOMEM;
+
+	cqp_info = &cqp_request->info;
+	info = &cqp_info->in.u.alloc_stag.info;
+	memset(info, 0, sizeof(*info));
+	info->page_size = PAGE_SIZE;
+	info->stag_idx = iwmr->stag >> I40IW_CQPSQ_STAG_IDX_SHIFT;
+	info->pd_id = iwpd->sc_pd.pd_id;
+	info->total_len = iwmr->length;
+	cqp_info->cqp_cmd = OP_ALLOC_STAG;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.alloc_stag.dev = &iwdev->sc_dev;
+	cqp_info->in.u.alloc_stag.scratch = (uintptr_t)cqp_request;
+
+	status = i40iw_handle_cqp_op(iwdev, cqp_request);
+	if (status) {
+		err = -ENOMEM;
+		i40iw_pr_err("CQP-OP MR Reg fail");
+	}
+	return err;
+}
+
+/**
+ * i40iw_alloc_mr - register stag for fast memory registration
+ * @pd: ibpd pointer
+ * @mr_type: memory for stag registrion
+ * @max_num_sg: man number of pages
+ */
+static struct ib_mr *i40iw_alloc_mr(struct ib_pd *pd,
+				    enum ib_mr_type mr_type,
+				    u32 max_num_sg)
+{
+	struct i40iw_pd *iwpd = to_iwpd(pd);
+	struct i40iw_device *iwdev = to_iwdev(pd->device);
+	struct i40iw_pble_alloc *palloc;
+	struct i40iw_pbl *iwpbl;
+	struct i40iw_mr *iwmr;
+	enum i40iw_status_code status;
+	u32 stag;
+	int err_code = -ENOMEM;
+
+	iwmr = kzalloc(sizeof(*iwmr), GFP_KERNEL);
+	if (!iwmr)
+		return ERR_PTR(-ENOMEM);
+
+	stag = i40iw_create_stag(iwdev);
+	if (!stag) {
+		err_code = -EOVERFLOW;
+		goto err;
+	}
+	iwmr->stag = stag;
+	iwmr->ibmr.rkey = stag;
+	iwmr->ibmr.lkey = stag;
+	iwmr->ibmr.pd = pd;
+	iwmr->ibmr.device = pd->device;
+	iwpbl = &iwmr->iwpbl;
+	iwpbl->iwmr = iwmr;
+	iwmr->type = IW_MEMREG_TYPE_MEM;
+	palloc = &iwpbl->pble_alloc;
+	iwmr->page_cnt = max_num_sg;
+	mutex_lock(&iwdev->pbl_mutex);
+	status = i40iw_get_pble(&iwdev->sc_dev, iwdev->pble_rsrc, palloc, iwmr->page_cnt);
+	mutex_unlock(&iwdev->pbl_mutex);
+	if (!status)
+		goto err1;
+
+	if (palloc->level != I40IW_LEVEL_1)
+		goto err2;
+	err_code = i40iw_hw_alloc_stag(iwdev, iwmr);
+	if (err_code)
+		goto err2;
+	iwpbl->pbl_allocated = true;
+	i40iw_add_pdusecount(iwpd);
+	return &iwmr->ibmr;
+err2:
+	i40iw_free_pble(iwdev->pble_rsrc, palloc);
+err1:
+	i40iw_free_stag(iwdev, stag);
+err:
+	kfree(iwmr);
+	return ERR_PTR(err_code);
+}
+
+/**
+ * i40iw_set_page - populate pbl list for fmr
+ * @ibmr: ib mem to access iwarp mr pointer
+ * @addr: page dma address fro pbl list
+ */
+static int i40iw_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct i40iw_mr *iwmr = to_iwmr(ibmr);
+	struct i40iw_pbl *iwpbl = &iwmr->iwpbl;
+	struct i40iw_pble_alloc *palloc = &iwpbl->pble_alloc;
+	u64 *pbl;
+
+	if (unlikely(iwmr->npages == iwmr->page_cnt))
+		return -ENOMEM;
+
+	pbl = (u64 *)palloc->level1.addr;
+	pbl[iwmr->npages++] = cpu_to_le64(addr);
+	return 0;
+}
+
+/**
+ * i40iw_map_mr_sg - map of sg list for fmr
+ * @ibmr: ib mem to access iwarp mr pointer
+ * @sg: scatter gather list for fmr
+ * @sg_nents: number of sg pages
+ */
+static int i40iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents)
+{
+	struct i40iw_mr *iwmr = to_iwmr(ibmr);
+
+	iwmr->npages = 0;
+	return ib_sg_to_pages(ibmr, sg, sg_nents, i40iw_set_page);
+}
+
+/**
  * i40iw_hwreg_mr - send cqp command for memory registration
  * @iwdev: iwarp device
  * @iwmr: iwarp mr pointer
@@ -1884,12 +2019,14 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 	enum i40iw_status_code ret;
 	int err = 0;
 	unsigned long flags;
+	bool inv_stag;
 
 	iwqp = (struct i40iw_qp *)ibqp;
 	ukqp = &iwqp->sc_qp.qp_uk;
 
 	spin_lock_irqsave(&iwqp->lock, flags);
 	while (ib_wr) {
+		inv_stag = false;
 		memset(&info, 0, sizeof(info));
 		info.wr_id = (u64)(ib_wr->wr_id);
 		if ((ib_wr->send_flags & IB_SEND_SIGNALED) || iwqp->sig_all)
@@ -1899,19 +2036,28 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 
 		switch (ib_wr->opcode) {
 		case IB_WR_SEND:
-			if (ib_wr->send_flags & IB_SEND_SOLICITED)
-				info.op_type = I40IW_OP_TYPE_SEND_SOL;
-			else
-				info.op_type = I40IW_OP_TYPE_SEND;
+			/* fall-through */
+		case IB_WR_SEND_WITH_INV:
+			if (ib_wr->opcode == IB_WR_SEND) {
+				if (ib_wr->send_flags & IB_SEND_SOLICITED)
+					info.op_type = I40IW_OP_TYPE_SEND_SOL;
+				else
+					info.op_type = I40IW_OP_TYPE_SEND;
+			} else {
+				if (ib_wr->send_flags & IB_SEND_SOLICITED)
+					info.op_type = I40IW_OP_TYPE_SEND_SOL_INV;
+				else
+					info.op_type = I40IW_OP_TYPE_SEND_INV;
+			}
 
 			if (ib_wr->send_flags & IB_SEND_INLINE) {
 				info.op.inline_send.data = (void *)(unsigned long)ib_wr->sg_list[0].addr;
 				info.op.inline_send.len = ib_wr->sg_list[0].length;
-				ret = ukqp->ops.iw_inline_send(ukqp, &info, rdma_wr(ib_wr)->rkey, false);
+				ret = ukqp->ops.iw_inline_send(ukqp, &info, ib_wr->ex.invalidate_rkey, false);
 			} else {
 				info.op.send.num_sges = ib_wr->num_sge;
 				info.op.send.sg_list = (struct i40iw_sge *)ib_wr->sg_list;
-				ret = ukqp->ops.iw_send(ukqp, &info, rdma_wr(ib_wr)->rkey, false);
+				ret = ukqp->ops.iw_send(ukqp, &info, ib_wr->ex.invalidate_rkey, false);
 			}
 
 			if (ret)
@@ -1939,6 +2085,9 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			if (ret)
 				err = -EIO;
 			break;
+		case IB_WR_RDMA_READ_WITH_INV:
+			inv_stag = true;
+			/* fall-through*/
 		case IB_WR_RDMA_READ:
 			info.op_type = I40IW_OP_TYPE_RDMA_READ;
 			info.op.rdma_read.rem_addr.tag_off = rdma_wr(ib_wr)->remote_addr;
@@ -1947,10 +2096,47 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			info.op.rdma_read.lo_addr.tag_off = ib_wr->sg_list->addr;
 			info.op.rdma_read.lo_addr.stag = ib_wr->sg_list->lkey;
 			info.op.rdma_read.lo_addr.len = ib_wr->sg_list->length;
-			ret = ukqp->ops.iw_rdma_read(ukqp, &info, false, false);
+			ret = ukqp->ops.iw_rdma_read(ukqp, &info, inv_stag, false);
 			if (ret)
 				err = -EIO;
 			break;
+		case IB_WR_LOCAL_INV:
+			info.op_type = I40IW_OP_TYPE_INV_STAG;
+			info.op.inv_local_stag.target_stag = ib_wr->ex.invalidate_rkey;
+			ret = ukqp->ops.iw_stag_local_invalidate(ukqp, &info, true);
+			if (ret)
+				err = -EIO;
+			break;
+		case IB_WR_REG_MR:
+		{
+			struct i40iw_mr *iwmr = to_iwmr(reg_wr(ib_wr)->mr);
+			int page_shift = ilog2(reg_wr(ib_wr)->mr->page_size);
+			int flags = reg_wr(ib_wr)->access;
+			struct i40iw_pble_alloc *palloc = &iwmr->iwpbl.pble_alloc;
+			struct i40iw_sc_dev *dev = &iwqp->iwdev->sc_dev;
+			struct i40iw_fast_reg_stag_info info;
+
+			info.access_rights = I40IW_ACCESS_FLAGS_LOCALREAD;
+			info.access_rights |= i40iw_get_user_access(flags);
+			info.stag_key = reg_wr(ib_wr)->key & 0xff;
+			info.stag_idx = reg_wr(ib_wr)->key >> 8;
+			info.wr_id = ib_wr->wr_id;
+
+			info.addr_type = I40IW_ADDR_TYPE_VA_BASED;
+			info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
+			info.total_len = iwmr->ibmr.length;
+			info.first_pm_pbl_index = palloc->level1.idx;
+			info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
+			info.signaled = ib_wr->send_flags & IB_SEND_SIGNALED;
+
+			if (page_shift == 21)
+				info.page_size = 1; /* 2M page */
+
+			ret = dev->iw_priv_qp_ops->iw_mr_fast_register(&iwqp->sc_qp, &info, true);
+			if (ret)
+				err = -EIO;
+			break;
+		}
 		default:
 			err = -EINVAL;
 			i40iw_pr_err(" upost_send bad opcode = 0x%x\n",
@@ -2326,6 +2512,8 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	iwibdev->ibdev.query_device = i40iw_query_device;
 	iwibdev->ibdev.create_ah = i40iw_create_ah;
 	iwibdev->ibdev.destroy_ah = i40iw_destroy_ah;
+	iwibdev->ibdev.alloc_mr = i40iw_alloc_mr;
+	iwibdev->ibdev.map_mr_sg = i40iw_map_mr_sg;
 	iwibdev->ibdev.iwcm = kzalloc(sizeof(*iwibdev->ibdev.iwcm), GFP_KERNEL);
 	if (!iwibdev->ibdev.iwcm) {
 		ib_dealloc_device(&iwibdev->ibdev);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
index 1101f77..0acb6c8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
@@ -92,6 +92,7 @@ struct i40iw_mr {
 	struct ib_umem *region;
 	u16 type;
 	u32 page_cnt;
+	u32 npages;
 	u32 stag;
 	u64 length;
 	u64 pgaddrmem[MAX_SAVE_PAGE_ADDRS];
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
