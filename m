From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/4] IB/isert: kill struct isert_rdma_wr
Date: Mon, 15 Feb 2016 21:10:59 +0100
Message-ID: <1455567060-18381-4-git-send-email-hch@lst.de>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455567060-18381-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is exactly one instance per struct isert_cmd, so merge the two to
simplify everyones life.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 219 ++++++++++++++++----------------
 drivers/infiniband/ulp/isert/ib_isert.h |  30 ++---
 2 files changed, 119 insertions(+), 130 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8ef25c6..c93be93 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -49,13 +49,11 @@ static struct workqueue_struct *isert_release_wq;
 static void
 isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
-isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr);
+isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn);
 static void
 isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
-isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr);
+isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn);
 static int
 isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd);
 static int
@@ -1086,7 +1084,7 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 {
 	struct iser_tx_desc *tx_desc = &isert_cmd->tx_desc;
 
-	isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
+	isert_cmd->iser_ib_op = ISER_IB_SEND;
 	tx_desc->tx_cqe.done = isert_send_done;
 	send_wr->wr_cqe = &tx_desc->tx_cqe;
 
@@ -1697,54 +1695,50 @@ isert_unmap_data_buf(struct isert_conn *isert_conn, struct isert_data_buf *data)
 static void
 isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (wr->data.sg) {
+	if (isert_cmd->data.sg) {
 		isert_dbg("Cmd %p unmap_sg op\n", isert_cmd);
-		isert_unmap_data_buf(isert_conn, &wr->data);
+		isert_unmap_data_buf(isert_conn, &isert_cmd->data);
 	}
 
-	if (wr->rdma_wr) {
+	if (isert_cmd->rdma_wr) {
 		isert_dbg("Cmd %p free send_wr\n", isert_cmd);
-		kfree(wr->rdma_wr);
-		wr->rdma_wr = NULL;
+		kfree(isert_cmd->rdma_wr);
+		isert_cmd->rdma_wr = NULL;
 	}
 
-	if (wr->ib_sge) {
+	if (isert_cmd->ib_sge) {
 		isert_dbg("Cmd %p free ib_sge\n", isert_cmd);
-		kfree(wr->ib_sge);
-		wr->ib_sge = NULL;
+		kfree(isert_cmd->ib_sge);
+		isert_cmd->ib_sge = NULL;
 	}
 }
 
 static void
 isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (wr->fr_desc) {
-		isert_dbg("Cmd %p free fr_desc %p\n", isert_cmd, wr->fr_desc);
-		if (wr->fr_desc->ind & ISERT_PROTECTED) {
-			isert_unmap_data_buf(isert_conn, &wr->prot);
-			wr->fr_desc->ind &= ~ISERT_PROTECTED;
+	if (isert_cmd->fr_desc) {
+		isert_dbg("Cmd %p free fr_desc %p\n", isert_cmd, isert_cmd->fr_desc);
+		if (isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
+			isert_unmap_data_buf(isert_conn, &isert_cmd->prot);
+			isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
 		}
 		spin_lock_bh(&isert_conn->pool_lock);
-		list_add_tail(&wr->fr_desc->list, &isert_conn->fr_pool);
+		list_add_tail(&isert_cmd->fr_desc->list, &isert_conn->fr_pool);
 		spin_unlock_bh(&isert_conn->pool_lock);
-		wr->fr_desc = NULL;
+		isert_cmd->fr_desc = NULL;
 	}
 
-	if (wr->data.sg) {
+	if (isert_cmd->data.sg) {
 		isert_dbg("Cmd %p unmap_sg op\n", isert_cmd);
-		isert_unmap_data_buf(isert_conn, &wr->data);
+		isert_unmap_data_buf(isert_conn, &isert_cmd->data);
 	}
 
-	wr->ib_sge = NULL;
-	wr->rdma_wr = NULL;
+	isert_cmd->ib_sge = NULL;
+	isert_cmd->rdma_wr = NULL;
 }
 
 static void
@@ -1903,7 +1897,6 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct iser_tx_desc *desc =
 		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
 	struct isert_cmd *isert_cmd = desc->isert_cmd;
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct se_cmd *cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret = 0;
 
@@ -1915,13 +1908,14 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
-		ret = isert_check_pi_status(cmd, wr->fr_desc->pi_ctx->sig_mr);
-		wr->fr_desc->ind &= ~ISERT_PROTECTED;
+	if (isert_cmd->fr_desc && isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
+		ret = isert_check_pi_status(cmd,
+				isert_cmd->fr_desc->pi_ctx->sig_mr);
+		isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
 	}
 
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	wr->rdma_wr_num = 0;
+	isert_cmd->rdma_wr_num = 0;
 	if (ret)
 		transport_send_check_condition_and_sense(cmd, cmd->pi_err, 0);
 	else
@@ -1936,7 +1930,6 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct iser_tx_desc *desc =
 		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
 	struct isert_cmd *isert_cmd = desc->isert_cmd;
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	int ret = 0;
@@ -1949,16 +1942,16 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
+	if (isert_cmd->fr_desc && isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
 		ret = isert_check_pi_status(se_cmd,
-					    wr->fr_desc->pi_ctx->sig_mr);
-		wr->fr_desc->ind &= ~ISERT_PROTECTED;
+					    isert_cmd->fr_desc->pi_ctx->sig_mr);
+		isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
 	}
 
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	cmd->write_data_done = wr->data.len;
-	wr->rdma_wr_num = 0;
+	cmd->write_data_done = isert_cmd->data.len;
+	isert_cmd->rdma_wr_num = 0;
 
 	isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
@@ -2343,13 +2336,12 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 }
 
 static int
-isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr)
+isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 {
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_data_buf *data = &wr->data;
+	struct isert_data_buf *data = &isert_cmd->data;
 	struct ib_rdma_wr *rdma_wr;
 	struct ib_sge *ib_sge;
 	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
@@ -2357,10 +2349,12 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
-	offset = wr->iser_ib_op == ISER_IB_RDMA_READ ? cmd->write_data_done : 0;
+	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
+			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
 				 se_cmd->t_data_nents, se_cmd->data_length,
-				 offset, wr->iser_ib_op, &wr->data);
+				 offset, isert_cmd->iser_ib_op,
+				 &isert_cmd->data);
 	if (ret)
 		return ret;
 
@@ -2373,45 +2367,44 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		ret = -ENOMEM;
 		goto unmap_cmd;
 	}
-	wr->ib_sge = ib_sge;
+	isert_cmd->ib_sge = ib_sge;
 
-	wr->rdma_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
-	wr->rdma_wr = kzalloc(sizeof(struct ib_rdma_wr) * wr->rdma_wr_num,
-				GFP_KERNEL);
-	if (!wr->rdma_wr) {
-		isert_dbg("Unable to allocate wr->rdma_wr\n");
+	isert_cmd->rdma_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
+	isert_cmd->rdma_wr = kzalloc(sizeof(struct ib_rdma_wr) *
+			isert_cmd->rdma_wr_num, GFP_KERNEL);
+	if (!isert_cmd->rdma_wr) {
+		isert_dbg("Unable to allocate isert_cmd->rdma_wr\n");
 		ret = -ENOMEM;
 		goto unmap_cmd;
 	}
 
-	wr->isert_cmd = isert_cmd;
 	rdma_write_max = isert_conn->max_sge * PAGE_SIZE;
 
-	for (i = 0; i < wr->rdma_wr_num; i++) {
-		rdma_wr = &isert_cmd->rdma_wr.rdma_wr[i];
+	for (i = 0; i < isert_cmd->rdma_wr_num; i++) {
+		rdma_wr = &isert_cmd->rdma_wr[i];
 		data_len = min(data_left, rdma_write_max);
 
 		rdma_wr->wr.send_flags = 0;
-		if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
+		if (isert_cmd->iser_ib_op == ISER_IB_RDMA_WRITE) {
 			isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
 
 			rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
 			rdma_wr->remote_addr = isert_cmd->read_va + offset;
 			rdma_wr->rkey = isert_cmd->read_stag;
-			if (i + 1 == wr->rdma_wr_num)
+			if (i + 1 == isert_cmd->rdma_wr_num)
 				rdma_wr->wr.next = &isert_cmd->tx_desc.send_wr;
 			else
-				rdma_wr->wr.next = &wr->rdma_wr[i + 1].wr;
+				rdma_wr->wr.next = &isert_cmd->rdma_wr[i + 1].wr;
 		} else {
 			isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
 
 			rdma_wr->wr.opcode = IB_WR_RDMA_READ;
 			rdma_wr->remote_addr = isert_cmd->write_va + va_offset;
 			rdma_wr->rkey = isert_cmd->write_stag;
-			if (i + 1 == wr->rdma_wr_num)
+			if (i + 1 == isert_cmd->rdma_wr_num)
 				rdma_wr->wr.send_flags = IB_SEND_SIGNALED;
 			else
-				rdma_wr->wr.next = &wr->rdma_wr[i + 1].wr;
+				rdma_wr->wr.next = &isert_cmd->rdma_wr[i + 1].wr;
 		}
 
 		ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
@@ -2579,10 +2572,10 @@ isert_set_prot_checks(u8 prot_checks)
 
 static int
 isert_reg_sig_mr(struct isert_conn *isert_conn,
-		 struct se_cmd *se_cmd,
-		 struct isert_rdma_wr *rdma_wr,
+		 struct isert_cmd *isert_cmd,
 		 struct fast_reg_descriptor *fr_desc)
 {
+	struct se_cmd *se_cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	struct ib_sig_handover_wr sig_wr;
 	struct ib_send_wr inv_wr, *bad_wr, *wr = NULL;
 	struct pi_context *pi_ctx = fr_desc->pi_ctx;
@@ -2604,13 +2597,13 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	memset(&sig_wr, 0, sizeof(sig_wr));
 	sig_wr.wr.opcode = IB_WR_REG_SIG_MR;
 	sig_wr.wr.wr_cqe = NULL;
-	sig_wr.wr.sg_list = &rdma_wr->ib_sg[DATA];
+	sig_wr.wr.sg_list = &isert_cmd->ib_sg[DATA];
 	sig_wr.wr.num_sge = 1;
 	sig_wr.access_flags = IB_ACCESS_LOCAL_WRITE;
 	sig_wr.sig_attrs = &sig_attrs;
 	sig_wr.sig_mr = pi_ctx->sig_mr;
 	if (se_cmd->t_prot_sg)
-		sig_wr.prot = &rdma_wr->ib_sg[PROT];
+		sig_wr.prot = &isert_cmd->ib_sg[PROT];
 
 	if (!wr)
 		wr = &sig_wr.wr;
@@ -2624,35 +2617,34 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	}
 	fr_desc->ind &= ~ISERT_SIG_KEY_VALID;
 
-	rdma_wr->ib_sg[SIG].lkey = pi_ctx->sig_mr->lkey;
-	rdma_wr->ib_sg[SIG].addr = 0;
-	rdma_wr->ib_sg[SIG].length = se_cmd->data_length;
+	isert_cmd->ib_sg[SIG].lkey = pi_ctx->sig_mr->lkey;
+	isert_cmd->ib_sg[SIG].addr = 0;
+	isert_cmd->ib_sg[SIG].length = se_cmd->data_length;
 	if (se_cmd->prot_op != TARGET_PROT_DIN_STRIP &&
 	    se_cmd->prot_op != TARGET_PROT_DOUT_INSERT)
 		/*
 		 * We have protection guards on the wire
 		 * so we need to set a larget transfer
 		 */
-		rdma_wr->ib_sg[SIG].length += se_cmd->prot_length;
+		isert_cmd->ib_sg[SIG].length += se_cmd->prot_length;
 
 	isert_dbg("sig_sge: addr: 0x%llx  length: %u lkey: %x\n",
-		  rdma_wr->ib_sg[SIG].addr, rdma_wr->ib_sg[SIG].length,
-		  rdma_wr->ib_sg[SIG].lkey);
+		  isert_cmd->ib_sg[SIG].addr, isert_cmd->ib_sg[SIG].length,
+		  isert_cmd->ib_sg[SIG].lkey);
 err:
 	return ret;
 }
 
 static int
 isert_handle_prot_cmd(struct isert_conn *isert_conn,
-		      struct isert_cmd *isert_cmd,
-		      struct isert_rdma_wr *wr)
+		      struct isert_cmd *isert_cmd)
 {
 	struct isert_device *device = isert_conn->device;
 	struct se_cmd *se_cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret;
 
-	if (!wr->fr_desc->pi_ctx) {
-		ret = isert_create_pi_ctx(wr->fr_desc,
+	if (!isert_cmd->fr_desc->pi_ctx) {
+		ret = isert_create_pi_ctx(isert_cmd->fr_desc,
 					  device->ib_device,
 					  device->pd);
 		if (ret) {
@@ -2667,16 +2659,20 @@ isert_handle_prot_cmd(struct isert_conn *isert_conn,
 					 se_cmd->t_prot_sg,
 					 se_cmd->t_prot_nents,
 					 se_cmd->prot_length,
-					 0, wr->iser_ib_op, &wr->prot);
+					 0,
+					 isert_cmd->iser_ib_op,
+					 &isert_cmd->prot);
 		if (ret) {
 			isert_err("conn %p failed to map protection buffer\n",
 				  isert_conn);
 			return ret;
 		}
 
-		memset(&wr->ib_sg[PROT], 0, sizeof(wr->ib_sg[PROT]));
-		ret = isert_fast_reg_mr(isert_conn, wr->fr_desc, &wr->prot,
-					ISERT_PROT_KEY_VALID, &wr->ib_sg[PROT]);
+		memset(&isert_cmd->ib_sg[PROT], 0, sizeof(isert_cmd->ib_sg[PROT]));
+		ret = isert_fast_reg_mr(isert_conn, isert_cmd->fr_desc,
+					&isert_cmd->prot,
+					ISERT_PROT_KEY_VALID,
+					&isert_cmd->ib_sg[PROT]);
 		if (ret) {
 			isert_err("conn %p failed to fast reg mr\n",
 				  isert_conn);
@@ -2684,29 +2680,28 @@ isert_handle_prot_cmd(struct isert_conn *isert_conn,
 		}
 	}
 
-	ret = isert_reg_sig_mr(isert_conn, se_cmd, wr, wr->fr_desc);
+	ret = isert_reg_sig_mr(isert_conn, isert_cmd, isert_cmd->fr_desc);
 	if (ret) {
 		isert_err("conn %p failed to fast reg mr\n",
 			  isert_conn);
 		goto unmap_prot_cmd;
 	}
-	wr->fr_desc->ind |= ISERT_PROTECTED;
+	isert_cmd->fr_desc->ind |= ISERT_PROTECTED;
 
 	return 0;
 
 unmap_prot_cmd:
 	if (se_cmd->t_prot_sg)
-		isert_unmap_data_buf(isert_conn, &wr->prot);
+		isert_unmap_data_buf(isert_conn, &isert_cmd->prot);
 
 	return ret;
 }
 
 static int
-isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr)
+isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 {
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
 	struct fast_reg_descriptor *fr_desc = NULL;
 	struct ib_rdma_wr *rdma_wr;
@@ -2717,49 +2712,51 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
-	offset = wr->iser_ib_op == ISER_IB_RDMA_READ ? cmd->write_data_done : 0;
+	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
+			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
 				 se_cmd->t_data_nents, se_cmd->data_length,
-				 offset, wr->iser_ib_op, &wr->data);
+				 offset, isert_cmd->iser_ib_op,
+				 &isert_cmd->data);
 	if (ret)
 		return ret;
 
-	if (wr->data.dma_nents != 1 || isert_prot_cmd(isert_conn, se_cmd)) {
+	if (isert_cmd->data.dma_nents != 1 ||
+	    isert_prot_cmd(isert_conn, se_cmd)) {
 		spin_lock_irqsave(&isert_conn->pool_lock, flags);
 		fr_desc = list_first_entry(&isert_conn->fr_pool,
 					   struct fast_reg_descriptor, list);
 		list_del(&fr_desc->list);
 		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
-		wr->fr_desc = fr_desc;
+		isert_cmd->fr_desc = fr_desc;
 	}
 
-	ret = isert_fast_reg_mr(isert_conn, fr_desc, &wr->data,
-				ISERT_DATA_KEY_VALID, &wr->ib_sg[DATA]);
+	ret = isert_fast_reg_mr(isert_conn, fr_desc, &isert_cmd->data,
+				ISERT_DATA_KEY_VALID, &isert_cmd->ib_sg[DATA]);
 	if (ret)
 		goto unmap_cmd;
 
 	if (isert_prot_cmd(isert_conn, se_cmd)) {
-		ret = isert_handle_prot_cmd(isert_conn, isert_cmd, wr);
+		ret = isert_handle_prot_cmd(isert_conn, isert_cmd);
 		if (ret)
 			goto unmap_cmd;
 
-		ib_sg = &wr->ib_sg[SIG];
+		ib_sg = &isert_cmd->ib_sg[SIG];
 	} else {
-		ib_sg = &wr->ib_sg[DATA];
+		ib_sg = &isert_cmd->ib_sg[DATA];
 	}
 
-	memcpy(&wr->s_ib_sge, ib_sg, sizeof(*ib_sg));
-	wr->ib_sge = &wr->s_ib_sge;
-	wr->rdma_wr_num = 1;
-	memset(&wr->s_rdma_wr, 0, sizeof(wr->s_rdma_wr));
-	wr->rdma_wr = &wr->s_rdma_wr;
-	wr->isert_cmd = isert_cmd;
+	memcpy(&isert_cmd->s_ib_sge, ib_sg, sizeof(*ib_sg));
+	isert_cmd->ib_sge = &isert_cmd->s_ib_sge;
+	isert_cmd->rdma_wr_num = 1;
+	memset(&isert_cmd->s_rdma_wr, 0, sizeof(isert_cmd->s_rdma_wr));
+	isert_cmd->rdma_wr = &isert_cmd->s_rdma_wr;
 
-	rdma_wr = &isert_cmd->rdma_wr.s_rdma_wr;
-	rdma_wr->wr.sg_list = &wr->s_ib_sge;
+	rdma_wr = &isert_cmd->s_rdma_wr;
+	rdma_wr->wr.sg_list = &isert_cmd->s_ib_sge;
 	rdma_wr->wr.num_sge = 1;
 	rdma_wr->wr.wr_cqe = &isert_cmd->tx_desc.tx_cqe;
-	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
+	if (isert_cmd->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
 
 		rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
@@ -2784,7 +2781,7 @@ unmap_cmd:
 		list_add_tail(&fr_desc->list, &isert_conn->fr_pool);
 		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
 	}
-	isert_unmap_data_buf(isert_conn, &wr->data);
+	isert_unmap_data_buf(isert_conn, &isert_cmd->data);
 
 	return ret;
 }
@@ -2794,7 +2791,6 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->device;
 	struct ib_send_wr *wr_failed;
@@ -2803,8 +2799,8 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	isert_dbg("Cmd: %p RDMA_WRITE data_length: %u\n",
 		 isert_cmd, se_cmd->data_length);
 
-	wr->iser_ib_op = ISER_IB_RDMA_WRITE;
-	rc = device->reg_rdma_mem(conn, cmd, wr);
+	isert_cmd->iser_ib_op = ISER_IB_RDMA_WRITE;
+	rc = device->reg_rdma_mem(isert_cmd, conn);
 	if (rc) {
 		isert_err("Cmd: %p failed to prepare RDMA res\n", isert_cmd);
 		return rc;
@@ -2821,8 +2817,8 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 		isert_init_send_wr(isert_conn, isert_cmd,
 				   &isert_cmd->tx_desc.send_wr);
-		isert_cmd->rdma_wr.s_rdma_wr.wr.next = &isert_cmd->tx_desc.send_wr;
-		wr->rdma_wr_num += 1;
+		isert_cmd->s_rdma_wr.wr.next = &isert_cmd->tx_desc.send_wr;
+		isert_cmd->rdma_wr_num += 1;
 
 		rc = isert_post_recv(isert_conn, isert_cmd->rx_desc);
 		if (rc) {
@@ -2831,7 +2827,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		}
 	}
 
-	rc = ib_post_send(isert_conn->qp, &wr->rdma_wr->wr, &wr_failed);
+	rc = ib_post_send(isert_conn->qp, &isert_cmd->rdma_wr->wr, &wr_failed);
 	if (rc)
 		isert_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
 
@@ -2850,7 +2846,6 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->device;
 	struct ib_send_wr *wr_failed;
@@ -2858,14 +2853,14 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 
 	isert_dbg("Cmd: %p RDMA_READ data_length: %u write_data_done: %u\n",
 		 isert_cmd, se_cmd->data_length, cmd->write_data_done);
-	wr->iser_ib_op = ISER_IB_RDMA_READ;
-	rc = device->reg_rdma_mem(conn, cmd, wr);
+	isert_cmd->iser_ib_op = ISER_IB_RDMA_READ;
+	rc = device->reg_rdma_mem(isert_cmd, conn);
 	if (rc) {
 		isert_err("Cmd: %p failed to prepare RDMA res\n", isert_cmd);
 		return rc;
 	}
 
-	rc = ib_post_send(isert_conn->qp, &wr->rdma_wr->wr, &wr_failed);
+	rc = ib_post_send(isert_conn->qp, &isert_cmd->rdma_wr->wr, &wr_failed);
 	if (rc)
 		isert_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index aae4a91..b751b6a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -145,20 +145,6 @@ enum {
 	SIG = 2,
 };
 
-struct isert_rdma_wr {
-	struct isert_cmd	*isert_cmd;
-	enum iser_ib_op_code	iser_ib_op;
-	struct ib_sge		*ib_sge;
-	struct ib_sge		s_ib_sge;
-	int			rdma_wr_num;
-	struct ib_rdma_wr	*rdma_wr;
-	struct ib_rdma_wr	s_rdma_wr;
-	struct ib_sge		ib_sg[3];
-	struct isert_data_buf	data;
-	struct isert_data_buf	prot;
-	struct fast_reg_descriptor *fr_desc;
-};
-
 struct isert_cmd {
 	uint32_t		read_stag;
 	uint32_t		write_stag;
@@ -171,7 +157,16 @@ struct isert_cmd {
 	struct iscsi_cmd	*iscsi_cmd;
 	struct iser_tx_desc	tx_desc;
 	struct iser_rx_desc	*rx_desc;
-	struct isert_rdma_wr	rdma_wr;
+	enum iser_ib_op_code	iser_ib_op;
+	struct ib_sge		*ib_sge;
+	struct ib_sge		s_ib_sge;
+	int			rdma_wr_num;
+	struct ib_rdma_wr	*rdma_wr;
+	struct ib_rdma_wr	s_rdma_wr;
+	struct ib_sge		ib_sg[3];
+	struct isert_data_buf	data;
+	struct isert_data_buf	prot;
+	struct fast_reg_descriptor *fr_desc;
 	struct work_struct	comp_work;
 	struct scatterlist	sg;
 };
@@ -239,9 +234,8 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
-	int			(*reg_rdma_mem)(struct iscsi_conn *conn,
-						    struct iscsi_cmd *cmd,
-						    struct isert_rdma_wr *wr);
+	int			(*reg_rdma_mem)(struct isert_cmd *isert_cmd,
+						struct iscsi_conn *conn);
 	void			(*unreg_rdma_mem)(struct isert_cmd *isert_cmd,
 						  struct isert_conn *isert_conn);
 };
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
