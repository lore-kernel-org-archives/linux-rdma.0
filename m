From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 12/12] IB/isert: Support T10-PI protected transactions
Date: Sun, 16 Feb 2014 19:38:17 +0200
Message-ID: <1392572297-5333-13-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

In case the Target core passed transport T10 protection
operation:

1. Register data buffer (data memory region)
2. Register protection buffer if exsists (prot memory region)
3. Register signature region (signature memory region)
   - use work request IB_WR_REG_SIG_MR
4. Execute RDMA
5. Upon RDMA completion check the signature status
   - if succeeded send good SCSI response
   - if failed send SCSI bad response with appropriate sense buffer

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  328 ++++++++++++++++++++++++++++---
 drivers/infiniband/ulp/isert/ib_isert.h |    1 +
 2 files changed, 299 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 50c7948..1eb719a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1552,6 +1552,10 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 	if (wr->fr_desc) {
 		pr_debug("unreg_fastreg_cmd: %p free fr_desc %p\n",
 			 isert_cmd, wr->fr_desc);
+		if (wr->fr_desc->ind & ISERT_PROTECTED) {
+			isert_unmap_data_buf(isert_conn, &wr->prot);
+			wr->fr_desc->ind &= ~ISERT_PROTECTED;
+		}
 		spin_lock_bh(&isert_conn->conn_lock);
 		list_add_tail(&wr->fr_desc->list, &isert_conn->conn_fr_pool);
 		spin_unlock_bh(&isert_conn->conn_lock);
@@ -1657,12 +1661,55 @@ static void
 isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 			    struct isert_cmd *isert_cmd)
 {
+	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
+	struct ib_mr_status mr_status;
+	int ret = 0;
 
+	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
+		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
+					 IB_MR_CHECK_SIG_STATUS, &mr_status);
+		if (ret) {
+			pr_err("ib_check_mr_status failed, ret %d\n", ret);
+			goto fail_mr_status;
+		}
+		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+			u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+			switch (mr_status.sig_err.err_type) {
+			case IB_SIG_BAD_GUARD:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_REFTAG:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_APPTAG:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+				break;
+			}
+			se_cmd->bad_sector =
+				mr_status.sig_err.sig_err_offset / block_size;
+
+			pr_err("isert: PI error found type %d at sector 0x%llx "
+			       "expected 0x%x vs actual 0x%x\n",
+			       mr_status.sig_err.err_type,
+			       (unsigned long long)se_cmd->bad_sector,
+			       mr_status.sig_err.expected,
+			       mr_status.sig_err.actual);
+			ret = 1;
+		}
+	}
+
+fail_mr_status:
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	isert_put_response(isert_conn->conn, cmd);
+	if (ret)
+		transport_send_check_condition_and_sense(se_cmd,
+							 se_cmd->pi_err, 0);
+	else
+		isert_put_response(isert_conn->conn, cmd);
 }
 
 static void
@@ -1674,7 +1721,43 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
+	struct ib_mr_status mr_status;
+	int ret;
 
+	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
+		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
+					 IB_MR_CHECK_SIG_STATUS, &mr_status);
+		if (ret) {
+			pr_err("ib_check_mr_status failed, ret %d\n", ret);
+			goto fail_mr_status;
+		}
+		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+			u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+			switch (mr_status.sig_err.err_type) {
+			case IB_SIG_BAD_GUARD:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_REFTAG:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_APPTAG:
+				se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+				break;
+			}
+			se_cmd->bad_sector =
+				mr_status.sig_err.sig_err_offset / block_size;
+
+			pr_err("isert: PI error found type %d at sector 0x%llx "
+			       "expected 0x%x vs actual 0x%x\n",
+			       mr_status.sig_err.err_type,
+			       (unsigned long long)se_cmd->bad_sector,
+			       mr_status.sig_err.expected,
+			       mr_status.sig_err.actual);
+		}
+	}
+
+fail_mr_status:
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	cmd->write_data_done = wr->data.len;
@@ -2296,9 +2379,12 @@ static int
 isert_fast_reg_mr(struct isert_conn *isert_conn,
 		  struct fast_reg_descriptor *fr_desc,
 		  struct isert_data_buf *mem,
+		  enum isert_indicator ind,
 		  struct ib_sge *sge)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_mr *mr;
+	struct ib_fast_reg_page_list *frpl;
 	struct ib_send_wr fr_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
 	int ret, pagelist_len;
@@ -2309,37 +2395,50 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		sge->lkey = isert_conn->conn_mr->lkey;
 		sge->addr = ib_sg_dma_address(ib_dev, &mem->sg[0]);
 		sge->length = ib_sg_dma_len(ib_dev, &mem->sg[0]);
+		pr_debug("%s:%d sge: addr: 0x%llx  length: %u lkey: %x\n",
+			 __func__, __LINE__, sge->addr, sge->length,
+			 sge->lkey);
 		return 0;
 	}
 
+	if (ind == ISERT_DATA_KEY_VALID) {
+		/* Registering data buffer */
+		mr = fr_desc->data_mr;
+		frpl = fr_desc->data_frpl;
+	} else {
+		/* Registering protection buffer */
+		mr = fr_desc->pi_ctx->prot_mr;
+		frpl = fr_desc->pi_ctx->prot_frpl;
+
+	}
+
 	page_off = mem->offset % PAGE_SIZE;
 
 	pr_debug("Use fr_desc %p sg_nents %d offset %u\n",
 		 fr_desc, mem->nents, mem->offset);
 
 	pagelist_len = isert_map_fr_pagelist(ib_dev, mem->sg, mem->nents,
-					     &fr_desc->data_frpl->page_list[0]);
+					     &frpl->page_list[0]);
 
 	if (!(fr_desc->ind & ISERT_DATA_KEY_VALID)) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
 		inv_wr.opcode = IB_WR_LOCAL_INV;
-		inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
+		inv_wr.ex.invalidate_rkey = mr->rkey;
 		wr = &inv_wr;
 		/* Bump the key */
-		key = (u8)(fr_desc->data_mr->rkey & 0x000000FF);
-		ib_update_fast_reg_key(fr_desc->data_mr, ++key);
+		key = (u8)(mr->rkey & 0x000000FF);
+		ib_update_fast_reg_key(mr, ++key);
 	}
 
 	/* Prepare FASTREG WR */
 	memset(&fr_wr, 0, sizeof(fr_wr));
 	fr_wr.opcode = IB_WR_FAST_REG_MR;
-	fr_wr.wr.fast_reg.iova_start =
-		fr_desc->data_frpl->page_list[0] + page_off;
-	fr_wr.wr.fast_reg.page_list = fr_desc->data_frpl;
+	fr_wr.wr.fast_reg.iova_start = frpl->page_list[0] + page_off;
+	fr_wr.wr.fast_reg.page_list = frpl;
 	fr_wr.wr.fast_reg.page_list_len = pagelist_len;
 	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
 	fr_wr.wr.fast_reg.length = mem->len;
-	fr_wr.wr.fast_reg.rkey = fr_desc->data_mr->rkey;
+	fr_wr.wr.fast_reg.rkey = mr->rkey;
 	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
 
 	if (!wr)
@@ -2352,25 +2451,154 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		pr_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
-	fr_desc->ind &= ~ISERT_DATA_KEY_VALID;
+	fr_desc->ind &= ~ind;
 
-	sge->lkey = fr_desc->data_mr->lkey;
-	sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
+	sge->lkey = mr->lkey;
+	sge->addr = frpl->page_list[0] + page_off;
 	sge->length = mem->len;
 
-	pr_debug("RDMA ib_sge: addr: 0x%16llx  length: %u lkey: %08x\n",
-		 sge->addr, sge->length, sge->lkey);
+	pr_debug("%s:%d sge: addr: 0x%llx  length: %u lkey: %x\n",
+		 __func__, __LINE__, sge->addr, sge->length,
+		 sge->lkey);
 
 	return ret;
 }
 
 static int
+isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
+{
+	sig_attrs->mem.sig_type = IB_SIG_TYPE_T10_DIF;
+	sig_attrs->wire.sig_type = IB_SIG_TYPE_T10_DIF;
+	sig_attrs->mem.sig.dif.pi_interval =
+				se_cmd->se_dev->dev_attrib.block_size;
+	sig_attrs->wire.sig.dif.pi_interval =
+				se_cmd->se_dev->dev_attrib.block_size;
+
+	switch (se_cmd->prot_op) {
+	case TARGET_PROT_DIN_INSERT:
+	case TARGET_PROT_DOUT_STRIP:
+		sig_attrs->mem.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs->wire.sig.dif.type = se_cmd->prot_type;
+		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs->wire.sig.dif.bg = 0;
+		sig_attrs->wire.sig.dif.app_tag = 0;
+		sig_attrs->wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		break;
+	case TARGET_PROT_DOUT_INSERT:
+	case TARGET_PROT_DIN_STRIP:
+		sig_attrs->mem.sig.dif.type = se_cmd->prot_type;
+		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs->mem.sig.dif.bg = 0;
+		sig_attrs->mem.sig.dif.app_tag = 0;
+		sig_attrs->mem.sig.dif.ref_tag = se_cmd->reftag_seed;
+		sig_attrs->wire.sig.dif.type = IB_T10DIF_NONE;
+		break;
+	case TARGET_PROT_DIN_PASS:
+	case TARGET_PROT_DOUT_PASS:
+		sig_attrs->mem.sig.dif.type = se_cmd->prot_type;
+		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs->mem.sig.dif.bg = 0;
+		sig_attrs->mem.sig.dif.app_tag = 0;
+		sig_attrs->mem.sig.dif.ref_tag = se_cmd->reftag_seed;
+		sig_attrs->wire.sig.dif.type = se_cmd->prot_type;
+		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs->wire.sig.dif.bg = 0;
+		sig_attrs->wire.sig.dif.app_tag = 0;
+		sig_attrs->wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		break;
+	default:
+		pr_err("Unsupported PI operation %d\n", se_cmd->prot_op);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline u8
+isert_set_prot_checks(u8 prot_checks)
+{
+	return (prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
+	       (prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
+	       (prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
+}
+
+static int
+isert_reg_sig_mr(struct isert_conn *isert_conn, struct se_cmd *se_cmd,
+		 struct fast_reg_descriptor *fr_desc,
+		 struct ib_sge *data_sge, struct ib_sge *prot_sge,
+		 struct ib_sge *sig_sge)
+{
+	struct ib_send_wr sig_wr, inv_wr;
+	struct ib_send_wr *bad_wr, *wr = NULL;
+	struct pi_context *pi_ctx = fr_desc->pi_ctx;
+	struct ib_sig_attrs sig_attrs = {0};
+	int ret;
+	u32 key;
+
+	ret = isert_set_sig_attrs(se_cmd, &sig_attrs);
+	if (ret)
+		goto err;
+
+	sig_attrs.check_mask = isert_set_prot_checks(se_cmd->prot_checks);
+
+	if (!(fr_desc->ind & ISERT_SIG_KEY_VALID)) {
+		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.opcode = IB_WR_LOCAL_INV;
+		inv_wr.ex.invalidate_rkey = pi_ctx->sig_mr->rkey;
+		wr = &inv_wr;
+		/* Bump the key */
+		key = (u8)(pi_ctx->sig_mr->rkey & 0x000000FF);
+		ib_update_fast_reg_key(pi_ctx->sig_mr, ++key);
+	}
+
+	memset(&sig_wr, 0, sizeof(sig_wr));
+	sig_wr.opcode = IB_WR_REG_SIG_MR;
+	sig_wr.sg_list = data_sge;
+	sig_wr.num_sge = 1;
+	sig_wr.wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE;
+	sig_wr.wr.sig_handover.sig_attrs = &sig_attrs;
+	sig_wr.wr.sig_handover.sig_mr = pi_ctx->sig_mr;
+	if (se_cmd->t_prot_sg)
+		sig_wr.wr.sig_handover.prot = prot_sge;
+
+	if (!wr)
+		wr = &sig_wr;
+	else
+		wr->next = &sig_wr;
+
+	ret = ib_post_send(isert_conn->conn_qp, wr, &bad_wr);
+	if (ret) {
+		pr_err("fast registration failed, ret:%d\n", ret);
+		goto err;
+	}
+	fr_desc->ind &= ~ISERT_SIG_KEY_VALID;
+
+	sig_sge->lkey = pi_ctx->sig_mr->lkey;
+	sig_sge->addr = 0;
+	sig_sge->length = se_cmd->data_length;
+	if (se_cmd->prot_op != TARGET_PROT_DIN_STRIP &&
+	    se_cmd->prot_op != TARGET_PROT_DOUT_INSERT)
+		/*
+		 * We have protection guards on the wire
+		 * so we need to set a larget transfer
+		 */
+		sig_sge->length += se_cmd->prot_length;
+
+	pr_debug("sig_sge: addr: 0x%llx  length: %u lkey: %x\n",
+		 sig_sge->addr, sig_sge->length,
+		 sig_sge->lkey);
+err:
+	return ret;
+}
+
+static int
 isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
+	struct ib_sge data_sge;
 	struct ib_send_wr *send_wr;
 	struct fast_reg_descriptor *fr_desc = NULL;
 	u32 offset;
@@ -2386,7 +2614,8 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (ret)
 		return ret;
 
-	if (wr->data.dma_nents != 1) {
+	if (wr->data.dma_nents != 1 ||
+	    se_cmd->prot_type != TARGET_PROT_NORMAL) {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
 		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
 					   struct fast_reg_descriptor, list);
@@ -2395,10 +2624,39 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		wr->fr_desc = fr_desc;
 	}
 
-	ret = isert_fast_reg_mr(isert_conn, fr_desc, &wr->data, &wr->s_ib_sge);
+	ret = isert_fast_reg_mr(isert_conn, fr_desc, &wr->data,
+				ISERT_DATA_KEY_VALID, &data_sge);
 	if (ret)
 		goto unmap_cmd;
 
+	if (se_cmd->prot_type != TARGET_PROT_NORMAL) {
+		struct ib_sge prot_sge, sig_sge;
+
+		if (se_cmd->t_prot_sg) {
+			ret = isert_map_data_buf(isert_conn, isert_cmd,
+						 se_cmd->t_prot_sg,
+						 se_cmd->t_prot_nents,
+						 se_cmd->prot_length,
+						 0, wr->iser_ib_op, &wr->prot);
+			if (ret)
+				goto unmap_cmd;
+
+			ret = isert_fast_reg_mr(isert_conn, fr_desc, &wr->prot,
+						ISERT_PROT_KEY_VALID, &prot_sge);
+			if (ret)
+				goto unmap_prot_cmd;
+		}
+
+		ret = isert_reg_sig_mr(isert_conn, se_cmd, fr_desc,
+				       &data_sge, &prot_sge, &sig_sge);
+		if (ret)
+			goto unmap_prot_cmd;
+
+		fr_desc->ind |= ISERT_PROTECTED;
+		memcpy(&wr->s_ib_sge, &sig_sge, sizeof(sig_sge));
+	} else
+		memcpy(&wr->s_ib_sge, &data_sge, sizeof(data_sge));
+
 	wr->ib_sge = &wr->s_ib_sge;
 	wr->send_wr_num = 1;
 	memset(&wr->s_send_wr, 0, sizeof(*send_wr));
@@ -2413,8 +2671,8 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		send_wr->opcode = IB_WR_RDMA_WRITE;
 		send_wr->wr.rdma.remote_addr = isert_cmd->read_va;
 		send_wr->wr.rdma.rkey = isert_cmd->read_stag;
-		send_wr->send_flags = 0;
-		send_wr->next = &isert_cmd->tx_desc.send_wr;
+		send_wr->send_flags = se_cmd->prot_type == TARGET_PROT_NORMAL ?
+				      0 : IB_SEND_SIGNALED;
 	} else {
 		send_wr->opcode = IB_WR_RDMA_READ;
 		send_wr->wr.rdma.remote_addr = isert_cmd->write_va;
@@ -2423,6 +2681,9 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	}
 
 	return 0;
+unmap_prot_cmd:
+	if (se_cmd->t_prot_sg)
+		isert_unmap_data_buf(isert_conn, &wr->prot);
 unmap_cmd:
 	if (fr_desc) {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
@@ -2454,26 +2715,33 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		return rc;
 	}
 
-	/*
-	 * Build isert_conn->tx_desc for iSCSI response PDU and attach
-	 */
-	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
-			     &isert_cmd->tx_desc.iscsi_header);
-	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_conn, isert_cmd,
-			   &isert_cmd->tx_desc.send_wr, true);
+	if (se_cmd->prot_type == TARGET_PROT_NORMAL) {
+		/*
+		 * Build isert_conn->tx_desc for iSCSI response PDU and attach
+		 */
+		isert_create_send_desc(isert_conn, isert_cmd,
+				       &isert_cmd->tx_desc);
+		iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
+				     &isert_cmd->tx_desc.iscsi_header);
+		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
+		isert_init_send_wr(isert_conn, isert_cmd,
+				   &isert_cmd->tx_desc.send_wr, true);
+		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
+	}
 
 	atomic_inc(&isert_conn->post_send_buf_count);
-
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
 		atomic_dec(&isert_conn->post_send_buf_count);
 	}
-	pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data READ\n",
-		 isert_cmd);
 
+	if (se_cmd->prot_type == TARGET_PROT_NORMAL)
+		pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
+			 "READ\n", isert_cmd);
+	else
+		pr_debug("Cmd: %p posted RDMA_WRITE for iSER Data READ\n",
+			 isert_cmd);
 	return 1;
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index d984172..0e2253e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -89,6 +89,7 @@ struct isert_rdma_wr {
 	struct ib_send_wr	*send_wr;
 	struct ib_send_wr	s_send_wr;
 	struct isert_data_buf	data;
+	struct isert_data_buf	prot;
 	struct fast_reg_descriptor *fr_desc;
 };
 
-- 
1.7.1
