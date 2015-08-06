From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 22/22] IB/iser: Chain all iser transaction send work requests
Date: Thu,  6 Aug 2015 18:33:06 +0300
Message-ID: <1438875186-4310-23-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Chaning of send work requests benefits performance by
reducing the send queue lock contention (acquired in
ib_post_send) and saves us HW doorbells which is posted
only once.

Currently, in normal IO flows iser does not chain the CDB send
work request with the registration work request. Also in PI
flows, signature work requests are not chained as well.

Lets chain those and post only once.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c  |   1 +
 drivers/infiniband/ulp/iser/iscsi_iser.h  |  34 +++++++++
 drivers/infiniband/ulp/iser/iser_memory.c | 120 +++++++++++++-----------------
 drivers/infiniband/ulp/iser/iser_verbs.c  |  21 +++---
 4 files changed, 99 insertions(+), 77 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9eeefc8..ec87ce1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -204,6 +204,7 @@ iser_initialize_task_headers(struct iscsi_task *task,
 		goto out;
 	}
 
+	tx_desc->wr_idx = 0;
 	tx_desc->mapped = true;
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 0bdd7e7..86f6583 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -265,6 +265,14 @@ enum iser_desc_type {
 	ISCSI_TX_DATAOUT
 };
 
+/* Maximum number of work requests per task:
+ * Data memory region local invalidate + fast registration
+ * Protection memory region local invalidate + fast registration
+ * Signature memory region local invalidate + fast registration
+ * PDU send
+ */
+#define ISER_MAX_WRS 7
+
 /**
  * struct iser_tx_desc - iSER TX descriptor (for send wr_id)
  *
@@ -277,6 +285,11 @@ enum iser_desc_type {
  *                 unsolicited data-out or control
  * @num_sge:       number sges used on this TX task
  * @mapped:        Is the task header mapped
+ * @wr_idx:        Current WR index
+ * @wrs:           Array of WRs per task
+ * @data_reg:      Data buffer registration details
+ * @prot_reg:      Protection buffer registration details
+ * @sig_attrs:     Signature attributes
  */
 struct iser_tx_desc {
 	struct iser_hdr              iser_header;
@@ -286,6 +299,11 @@ struct iser_tx_desc {
 	struct ib_sge		     tx_sg[2];
 	int                          num_sge;
 	bool			     mapped;
+	u8                           wr_idx;
+	struct ib_send_wr            wrs[ISER_MAX_WRS];
+	struct iser_mem_reg          data_reg;
+	struct iser_mem_reg          prot_reg;
+	struct ib_sig_attrs          sig_attrs;
 };
 
 #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
@@ -689,4 +707,20 @@ iser_reg_desc_get_fmr(struct ib_conn *ib_conn);
 void
 iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
 		      struct iser_fr_desc *desc);
+
+static inline struct ib_send_wr *
+iser_tx_next_wr(struct iser_tx_desc *tx_desc)
+{
+	struct ib_send_wr *cur_wr = &tx_desc->wrs[tx_desc->wr_idx];
+	struct ib_send_wr *last_wr;
+
+	if (tx_desc->wr_idx) {
+		last_wr = &tx_desc->wrs[tx_desc->wr_idx - 1];
+		last_wr->next = cur_wr;
+	}
+	tx_desc->wr_idx++;
+
+	return cur_wr;
+}
+
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 750f03f..2493cc7 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -664,10 +664,11 @@ iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 {
 	u32 rkey;
 
-	memset(inv_wr, 0, sizeof(*inv_wr));
 	inv_wr->opcode = IB_WR_LOCAL_INV;
 	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
 	inv_wr->ex.invalidate_rkey = mr->rkey;
+	inv_wr->send_flags = 0;
+	inv_wr->num_sge = 0;
 
 	rkey = ib_inc_rkey(mr->rkey);
 	ib_update_fast_reg_key(mr, rkey);
@@ -680,47 +681,38 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		struct iser_mem_reg *prot_reg,
 		struct iser_mem_reg *sig_reg)
 {
-	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct ib_send_wr sig_wr, inv_wr;
-	struct ib_send_wr *bad_wr, *wr = NULL;
-	struct ib_sig_attrs sig_attrs;
+	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	struct ib_sig_attrs *sig_attrs = &tx_desc->sig_attrs;
+	struct ib_send_wr *wr;
 	int ret;
 
-	memset(&sig_attrs, 0, sizeof(sig_attrs));
-	ret = iser_set_sig_attrs(iser_task->sc, &sig_attrs);
+	memset(sig_attrs, 0, sizeof(*sig_attrs));
+	ret = iser_set_sig_attrs(iser_task->sc, sig_attrs);
 	if (ret)
 		goto err;
 
-	iser_set_prot_checks(iser_task->sc, &sig_attrs.check_mask);
+	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
 	if (!pi_ctx->sig_mr_valid) {
-		iser_inv_rkey(&inv_wr, pi_ctx->sig_mr);
-		wr = &inv_wr;
+		wr = iser_tx_next_wr(tx_desc);
+		iser_inv_rkey(wr, pi_ctx->sig_mr);
 	}
 
-	memset(&sig_wr, 0, sizeof(sig_wr));
-	sig_wr.opcode = IB_WR_REG_SIG_MR;
-	sig_wr.wr_id = ISER_FASTREG_LI_WRID;
-	sig_wr.sg_list = &data_reg->sge;
-	sig_wr.num_sge = 1;
-	sig_wr.wr.sig_handover.sig_attrs = &sig_attrs;
-	sig_wr.wr.sig_handover.sig_mr = pi_ctx->sig_mr;
+	wr = iser_tx_next_wr(tx_desc);
+	wr->opcode = IB_WR_REG_SIG_MR;
+	wr->wr_id = ISER_FASTREG_LI_WRID;
+	wr->sg_list = &data_reg->sge;
+	wr->num_sge = 1;
+	wr->send_flags = 0;
+	wr->wr.sig_handover.sig_attrs = sig_attrs;
+	wr->wr.sig_handover.sig_mr = pi_ctx->sig_mr;
 	if (scsi_prot_sg_count(iser_task->sc))
-		sig_wr.wr.sig_handover.prot = &prot_reg->sge;
-	sig_wr.wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE |
-					      IB_ACCESS_REMOTE_READ |
-					      IB_ACCESS_REMOTE_WRITE;
-
-	if (!wr)
-		wr = &sig_wr;
+		wr->wr.sig_handover.prot = &prot_reg->sge;
 	else
-		wr->next = &sig_wr;
-
-	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
-	if (ret) {
-		iser_err("reg_sig_mr failed, ret:%d\n", ret);
-		goto err;
-	}
+		wr->wr.sig_handover.prot = NULL;
+	wr->wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE |
+					   IB_ACCESS_REMOTE_READ |
+					   IB_ACCESS_REMOTE_WRITE;
 	pi_ctx->sig_mr_valid = 0;
 
 	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
@@ -744,9 +736,9 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	struct iser_device *device = ib_conn->device;
 	struct ib_mr *mr = rsc->mr;
 	struct ib_fast_reg_page_list *frpl = rsc->frpl;
-	struct ib_send_wr fastreg_wr, inv_wr;
-	struct ib_send_wr *bad_wr, *wr = NULL;
-	int ret, offset, size, plen;
+	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	struct ib_send_wr *wr;
+	int offset, size, plen;
 
 	plen = iser_sg_to_page_vec(mem, device->ib_device, frpl->page_list,
 				   &offset, &size);
@@ -756,34 +748,23 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	}
 
 	if (!rsc->mr_valid) {
-		iser_inv_rkey(&inv_wr, mr);
-		wr = &inv_wr;
+		wr = iser_tx_next_wr(tx_desc);
+		iser_inv_rkey(wr, mr);
 	}
 
-	/* Prepare FASTREG WR */
-	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
-	fastreg_wr.wr_id = ISER_FASTREG_LI_WRID;
-	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
-	fastreg_wr.wr.fast_reg.iova_start = frpl->page_list[0] + offset;
-	fastreg_wr.wr.fast_reg.page_list = frpl;
-	fastreg_wr.wr.fast_reg.page_list_len = plen;
-	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
-	fastreg_wr.wr.fast_reg.length = size;
-	fastreg_wr.wr.fast_reg.rkey = mr->rkey;
-	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
-					       IB_ACCESS_REMOTE_WRITE |
-					       IB_ACCESS_REMOTE_READ);
-
-	if (!wr)
-		wr = &fastreg_wr;
-	else
-		wr->next = &fastreg_wr;
-
-	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
-	if (ret) {
-		iser_err("fast registration failed, ret:%d\n", ret);
-		return ret;
-	}
+	wr = iser_tx_next_wr(tx_desc);
+	wr->opcode = IB_WR_FAST_REG_MR;
+	wr->wr_id = ISER_FASTREG_LI_WRID;
+	wr->send_flags = 0;
+	wr->wr.fast_reg.iova_start = frpl->page_list[0] + offset;
+	wr->wr.fast_reg.page_list = frpl;
+	wr->wr.fast_reg.page_list_len = plen;
+	wr->wr.fast_reg.page_shift = SHIFT_4K;
+	wr->wr.fast_reg.length = size;
+	wr->wr.fast_reg.rkey = mr->rkey;
+	wr->wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
+					IB_ACCESS_REMOTE_WRITE |
+					IB_ACCESS_REMOTE_READ);
 	rsc->mr_valid = 0;
 
 	reg->sge.lkey = mr->lkey;
@@ -795,7 +776,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
 		 reg->sge.addr, reg->sge.length);
 
-	return ret;
+	return 0;
 }
 
 static int
@@ -853,6 +834,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 	struct iser_device *device = ib_conn->device;
 	struct iser_data_buf *mem = &task->data[dir];
 	struct iser_mem_reg *reg = &task->rdma_reg[dir];
+	struct iser_mem_reg *data_reg;
 	struct iser_fr_desc *desc = NULL;
 	int err;
 
@@ -866,27 +848,31 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 		reg->mem_h = desc;
 	}
 
-	err = iser_reg_data_sg(task, mem, desc, reg);
+	if (scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL)
+		data_reg = reg;
+	else
+		data_reg = &task->desc.data_reg;
+
+	err = iser_reg_data_sg(task, mem, desc, data_reg);
 	if (unlikely(err))
 		goto err_reg;
 
 	if (scsi_get_prot_op(task->sc) != SCSI_PROT_NORMAL) {
-		struct iser_mem_reg prot_reg;
+		struct iser_mem_reg *prot_reg = &task->desc.prot_reg;
 
-		memset(&prot_reg, 0, sizeof(prot_reg));
 		if (scsi_prot_sg_count(task->sc)) {
 			mem = &task->prot[dir];
 			err = iser_handle_unaligned_buf(task, mem, dir);
 			if (unlikely(err))
 				goto err_reg;
 
-			err = iser_reg_prot_sg(task, mem, desc, &prot_reg);
+			err = iser_reg_prot_sg(task, mem, desc, prot_reg);
 			if (unlikely(err))
 				goto err_reg;
 		}
 
-		err = iser_reg_sig_mr(task, desc->pi_ctx, reg,
-				      &prot_reg, reg);
+		err = iser_reg_sig_mr(task, desc->pi_ctx, data_reg,
+				      prot_reg, reg);
 		if (unlikely(err))
 			goto err_reg;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index f69cee7..ad2d2b5 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1116,23 +1116,24 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
 int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 		   bool signal)
 {
-	int		  ib_ret;
-	struct ib_send_wr send_wr, *send_wr_failed;
+	struct ib_send_wr *bad_wr, *wr = iser_tx_next_wr(tx_desc);
+	int ib_ret;
 
 	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
 				      tx_desc->dma_addr, ISER_HEADERS_LEN,
 				      DMA_TO_DEVICE);
 
-	send_wr.next	   = NULL;
-	send_wr.wr_id	   = (uintptr_t)tx_desc;
-	send_wr.sg_list	   = tx_desc->tx_sg;
-	send_wr.num_sge	   = tx_desc->num_sge;
-	send_wr.opcode	   = IB_WR_SEND;
-	send_wr.send_flags = signal ? IB_SEND_SIGNALED : 0;
+	wr->next = NULL;
+	wr->wr_id = (uintptr_t)tx_desc;
+	wr->sg_list = tx_desc->tx_sg;
+	wr->num_sge = tx_desc->num_sge;
+	wr->opcode = IB_WR_SEND;
+	wr->send_flags = signal ? IB_SEND_SIGNALED : 0;
 
-	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
+	ib_ret = ib_post_send(ib_conn->qp, &tx_desc->wrs[0], &bad_wr);
 	if (ib_ret)
-		iser_err("ib_post_send failed, ret:%d\n", ib_ret);
+		iser_err("ib_post_send failed, ret:%d opcode:%d\n",
+			 ib_ret, bad_wr->opcode);
 
 	return ib_ret;
 }
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
