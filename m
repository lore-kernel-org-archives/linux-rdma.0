From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/11] IB/isert: convert to the generic RDMA READ/WRITE API
Date: Tue,  3 May 2016 18:01:13 +0200
Message-ID: <1462291273-22403-12-git-send-email-hch@lst.de>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1462291273-22403-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Replace the homegrown RDMA READ/WRITE code in isert with the generic API,
which also adds iWarp support to the I/O path as a side effect.  Note
that full iWarp operation will need a few additional patches from Steve.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 841 ++++----------------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
 2 files changed, 85 insertions(+), 825 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a44a736..897b5a4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -33,7 +33,8 @@
 
 #define	ISERT_MAX_CONN		8
 #define ISER_MAX_RX_CQ_LEN	(ISERT_QP_MAX_RECV_DTOS * ISERT_MAX_CONN)
-#define ISER_MAX_TX_CQ_LEN	(ISERT_QP_MAX_REQ_DTOS  * ISERT_MAX_CONN)
+#define ISER_MAX_TX_CQ_LEN \
+	((ISERT_QP_MAX_REQ_DTOS + ISCSI_DEF_XMIT_CMDS_MAX) * ISERT_MAX_CONN)
 #define ISER_MAX_CQ_LEN		(ISER_MAX_RX_CQ_LEN + ISER_MAX_TX_CQ_LEN + \
 				 ISERT_MAX_CONN)
 
@@ -46,14 +47,6 @@ static LIST_HEAD(device_list);
 static struct workqueue_struct *isert_comp_wq;
 static struct workqueue_struct *isert_release_wq;
 
-static void
-isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
-static int
-isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn);
-static void
-isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
-static int
-isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn);
 static int
 isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd);
 static int
@@ -142,6 +135,7 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.recv_cq = comp->cq;
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS + 1;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
+	attr.cap.max_rdma_ctxs = ISCSI_DEF_XMIT_CMDS_MAX;
 	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
 	isert_conn->max_sge = min(device->ib_device->attrs.max_sge,
 				  device->ib_device->attrs.max_sge_rd);
@@ -270,9 +264,9 @@ isert_alloc_comps(struct isert_device *device)
 				 device->ib_device->num_comp_vectors));
 
 	isert_info("Using %d CQs, %s supports %d vectors support "
-		   "Fast registration %d pi_capable %d\n",
+		   "pi_capable %d\n",
 		   device->comps_used, device->ib_device->name,
-		   device->ib_device->num_comp_vectors, device->use_fastreg,
+		   device->ib_device->num_comp_vectors,
 		   device->pi_capable);
 
 	device->comps = kcalloc(device->comps_used, sizeof(struct isert_comp),
@@ -313,18 +307,6 @@ isert_create_device_ib_res(struct isert_device *device)
 	isert_dbg("devattr->max_sge: %d\n", ib_dev->attrs.max_sge);
 	isert_dbg("devattr->max_sge_rd: %d\n", ib_dev->attrs.max_sge_rd);
 
-	/* asign function handlers */
-	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
-	    ib_dev->attrs.device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
-		device->use_fastreg = 1;
-		device->reg_rdma_mem = isert_reg_rdma;
-		device->unreg_rdma_mem = isert_unreg_rdma;
-	} else {
-		device->use_fastreg = 0;
-		device->reg_rdma_mem = isert_map_rdma;
-		device->unreg_rdma_mem = isert_unmap_cmd;
-	}
-
 	ret = isert_alloc_comps(device);
 	if (ret)
 		goto out;
@@ -417,146 +399,6 @@ isert_device_get(struct rdma_cm_id *cma_id)
 }
 
 static void
-isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
-{
-	struct fast_reg_descriptor *fr_desc, *tmp;
-	int i = 0;
-
-	if (list_empty(&isert_conn->fr_pool))
-		return;
-
-	isert_info("Freeing conn %p fastreg pool", isert_conn);
-
-	list_for_each_entry_safe(fr_desc, tmp,
-				 &isert_conn->fr_pool, list) {
-		list_del(&fr_desc->list);
-		ib_dereg_mr(fr_desc->data_mr);
-		if (fr_desc->pi_ctx) {
-			ib_dereg_mr(fr_desc->pi_ctx->prot_mr);
-			ib_dereg_mr(fr_desc->pi_ctx->sig_mr);
-			kfree(fr_desc->pi_ctx);
-		}
-		kfree(fr_desc);
-		++i;
-	}
-
-	if (i < isert_conn->fr_pool_size)
-		isert_warn("Pool still has %d regions registered\n",
-			isert_conn->fr_pool_size - i);
-}
-
-static int
-isert_create_pi_ctx(struct fast_reg_descriptor *desc,
-		    struct ib_device *device,
-		    struct ib_pd *pd)
-{
-	struct pi_context *pi_ctx;
-	int ret;
-
-	pi_ctx = kzalloc(sizeof(*desc->pi_ctx), GFP_KERNEL);
-	if (!pi_ctx) {
-		isert_err("Failed to allocate pi context\n");
-		return -ENOMEM;
-	}
-
-	pi_ctx->prot_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-				      ISCSI_ISER_SG_TABLESIZE);
-	if (IS_ERR(pi_ctx->prot_mr)) {
-		isert_err("Failed to allocate prot frmr err=%ld\n",
-			  PTR_ERR(pi_ctx->prot_mr));
-		ret = PTR_ERR(pi_ctx->prot_mr);
-		goto err_pi_ctx;
-	}
-	desc->ind |= ISERT_PROT_KEY_VALID;
-
-	pi_ctx->sig_mr = ib_alloc_mr(pd, IB_MR_TYPE_SIGNATURE, 2);
-	if (IS_ERR(pi_ctx->sig_mr)) {
-		isert_err("Failed to allocate signature enabled mr err=%ld\n",
-			  PTR_ERR(pi_ctx->sig_mr));
-		ret = PTR_ERR(pi_ctx->sig_mr);
-		goto err_prot_mr;
-	}
-
-	desc->pi_ctx = pi_ctx;
-	desc->ind |= ISERT_SIG_KEY_VALID;
-	desc->ind &= ~ISERT_PROTECTED;
-
-	return 0;
-
-err_prot_mr:
-	ib_dereg_mr(pi_ctx->prot_mr);
-err_pi_ctx:
-	kfree(pi_ctx);
-
-	return ret;
-}
-
-static int
-isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
-		     struct fast_reg_descriptor *fr_desc)
-{
-	fr_desc->data_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-				       ISCSI_ISER_SG_TABLESIZE);
-	if (IS_ERR(fr_desc->data_mr)) {
-		isert_err("Failed to allocate data frmr err=%ld\n",
-			  PTR_ERR(fr_desc->data_mr));
-		return PTR_ERR(fr_desc->data_mr);
-	}
-	fr_desc->ind |= ISERT_DATA_KEY_VALID;
-
-	isert_dbg("Created fr_desc %p\n", fr_desc);
-
-	return 0;
-}
-
-static int
-isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
-{
-	struct fast_reg_descriptor *fr_desc;
-	struct isert_device *device = isert_conn->device;
-	struct se_session *se_sess = isert_conn->conn->sess->se_sess;
-	struct se_node_acl *se_nacl = se_sess->se_node_acl;
-	int i, ret, tag_num;
-	/*
-	 * Setup the number of FRMRs based upon the number of tags
-	 * available to session in iscsi_target_locate_portal().
-	 */
-	tag_num = max_t(u32, ISCSIT_MIN_TAGS, se_nacl->queue_depth);
-	tag_num = (tag_num * 2) + ISCSIT_EXTRA_TAGS;
-
-	isert_conn->fr_pool_size = 0;
-	for (i = 0; i < tag_num; i++) {
-		fr_desc = kzalloc(sizeof(*fr_desc), GFP_KERNEL);
-		if (!fr_desc) {
-			isert_err("Failed to allocate fast_reg descriptor\n");
-			ret = -ENOMEM;
-			goto err;
-		}
-
-		ret = isert_create_fr_desc(device->ib_device,
-					   device->pd, fr_desc);
-		if (ret) {
-			isert_err("Failed to create fastreg descriptor err=%d\n",
-			       ret);
-			kfree(fr_desc);
-			goto err;
-		}
-
-		list_add_tail(&fr_desc->list, &isert_conn->fr_pool);
-		isert_conn->fr_pool_size++;
-	}
-
-	isert_dbg("Creating conn %p fastreg pool size=%d",
-		 isert_conn, isert_conn->fr_pool_size);
-
-	return 0;
-
-err:
-	isert_conn_free_fastreg_pool(isert_conn);
-	return ret;
-}
-
-static void
 isert_init_conn(struct isert_conn *isert_conn)
 {
 	isert_conn->state = ISER_CONN_INIT;
@@ -565,8 +407,6 @@ isert_init_conn(struct isert_conn *isert_conn)
 	init_completion(&isert_conn->login_req_comp);
 	kref_init(&isert_conn->kref);
 	mutex_init(&isert_conn->mutex);
-	spin_lock_init(&isert_conn->pool_lock);
-	INIT_LIST_HEAD(&isert_conn->fr_pool);
 	INIT_WORK(&isert_conn->release_work, isert_release_work);
 }
 
@@ -739,9 +579,6 @@ isert_connect_release(struct isert_conn *isert_conn)
 
 	BUG_ON(!device);
 
-	if (device->use_fastreg)
-		isert_conn_free_fastreg_pool(isert_conn);
-
 	isert_free_rx_descriptors(isert_conn);
 	if (isert_conn->cm_id)
 		rdma_destroy_id(isert_conn->cm_id);
@@ -1080,7 +917,6 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 {
 	struct iser_tx_desc *tx_desc = &isert_cmd->tx_desc;
 
-	isert_cmd->iser_ib_op = ISER_IB_SEND;
 	tx_desc->tx_cqe.done = isert_send_done;
 	send_wr->wr_cqe = &tx_desc->tx_cqe;
 
@@ -1160,16 +996,6 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
-			if (!conn->sess->sess_ops->SessionType &&
-			    isert_conn->device->use_fastreg) {
-				ret = isert_conn_create_fastreg_pool(isert_conn);
-				if (ret) {
-					isert_err("Conn: %p failed to create"
-					       " fastreg pool\n", isert_conn);
-					return ret;
-				}
-			}
-
 			ret = isert_alloc_rx_descriptors(isert_conn);
 			if (ret)
 				return ret;
@@ -1633,97 +1459,26 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
 }
 
-static int
-isert_map_data_buf(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
-		   struct scatterlist *sg, u32 nents, u32 length, u32 offset,
-		   enum iser_ib_op_code op, struct isert_data_buf *data)
-{
-	struct ib_device *ib_dev = isert_conn->cm_id->device;
-
-	data->dma_dir = op == ISER_IB_RDMA_WRITE ?
-			      DMA_TO_DEVICE : DMA_FROM_DEVICE;
-
-	data->len = length - offset;
-	data->offset = offset;
-	data->sg_off = data->offset / PAGE_SIZE;
-
-	data->sg = &sg[data->sg_off];
-	data->nents = min_t(unsigned int, nents - data->sg_off,
-					  ISCSI_ISER_SG_TABLESIZE);
-	data->len = min_t(unsigned int, data->len, ISCSI_ISER_SG_TABLESIZE *
-					PAGE_SIZE);
-
-	data->dma_nents = ib_dma_map_sg(ib_dev, data->sg, data->nents,
-					data->dma_dir);
-	if (unlikely(!data->dma_nents)) {
-		isert_err("Cmd: unable to dma map SGs %p\n", sg);
-		return -EINVAL;
-	}
-
-	isert_dbg("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
-		  isert_cmd, data->dma_nents, data->sg, data->nents, data->len);
-
-	return 0;
-}
-
 static void
-isert_unmap_data_buf(struct isert_conn *isert_conn, struct isert_data_buf *data)
+isert_rdma_rw_ctx_destroy(struct isert_cmd *cmd, struct isert_conn *conn)
 {
-	struct ib_device *ib_dev = isert_conn->cm_id->device;
-
-	ib_dma_unmap_sg(ib_dev, data->sg, data->nents, data->dma_dir);
-	memset(data, 0, sizeof(*data));
-}
-
-
-
-static void
-isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
-{
-	isert_dbg("Cmd %p\n", isert_cmd);
+	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
+	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
 
-	if (isert_cmd->data.sg) {
-		isert_dbg("Cmd %p unmap_sg op\n", isert_cmd);
-		isert_unmap_data_buf(isert_conn, &isert_cmd->data);
-	}
-
-	if (isert_cmd->rdma_wr) {
-		isert_dbg("Cmd %p free send_wr\n", isert_cmd);
-		kfree(isert_cmd->rdma_wr);
-		isert_cmd->rdma_wr = NULL;
-	}
-
-	if (isert_cmd->ib_sge) {
-		isert_dbg("Cmd %p free ib_sge\n", isert_cmd);
-		kfree(isert_cmd->ib_sge);
-		isert_cmd->ib_sge = NULL;
-	}
-}
-
-static void
-isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
-{
-	isert_dbg("Cmd %p\n", isert_cmd);
-
-	if (isert_cmd->fr_desc) {
-		isert_dbg("Cmd %p free fr_desc %p\n", isert_cmd, isert_cmd->fr_desc);
-		if (isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
-			isert_unmap_data_buf(isert_conn, &isert_cmd->prot);
-			isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
-		}
-		spin_lock_bh(&isert_conn->pool_lock);
-		list_add_tail(&isert_cmd->fr_desc->list, &isert_conn->fr_pool);
-		spin_unlock_bh(&isert_conn->pool_lock);
-		isert_cmd->fr_desc = NULL;
-	}
+	if (!cmd->rw.nr_ops)
+		return;
 
-	if (isert_cmd->data.sg) {
-		isert_dbg("Cmd %p unmap_sg op\n", isert_cmd);
-		isert_unmap_data_buf(isert_conn, &isert_cmd->data);
+	if (isert_prot_cmd(conn, se_cmd)) {
+		rdma_rw_ctx_destroy_signature(&cmd->rw, conn->qp,
+				conn->cm_id->port_num, se_cmd->t_data_sg,
+				se_cmd->t_data_nents, se_cmd->t_prot_sg,
+				se_cmd->t_prot_nents, dir);
+	} else {
+		rdma_rw_ctx_destroy(&cmd->rw, conn->qp, conn->cm_id->port_num,
+				se_cmd->t_data_sg, se_cmd->t_data_nents, dir);
 	}
 
-	isert_cmd->ib_sge = NULL;
-	isert_cmd->rdma_wr = NULL;
+	cmd->rw.nr_ops = 0;
 }
 
 static void
@@ -1732,7 +1487,6 @@ isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct iscsi_conn *conn = isert_conn->conn;
-	struct isert_device *device = isert_conn->device;
 	struct iscsi_text_rsp *hdr;
 
 	isert_dbg("Cmd %p\n", isert_cmd);
@@ -1760,7 +1514,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 			}
 		}
 
-		device->unreg_rdma_mem(isert_cmd, isert_conn);
+		isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
@@ -1894,14 +1648,9 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (isert_cmd->fr_desc && isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
-		ret = isert_check_pi_status(cmd,
-				isert_cmd->fr_desc->pi_ctx->sig_mr);
-		isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
-	}
+	ret = isert_check_pi_status(cmd, isert_cmd->rw.sig->sig_mr);
+	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
 
-	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	isert_cmd->rdma_wr_num = 0;
 	if (ret)
 		transport_send_check_condition_and_sense(cmd, cmd->pi_err, 0);
 	else
@@ -1929,16 +1678,12 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-	if (isert_cmd->fr_desc && isert_cmd->fr_desc->ind & ISERT_PROTECTED) {
-		ret = isert_check_pi_status(se_cmd,
-					    isert_cmd->fr_desc->pi_ctx->sig_mr);
-		isert_cmd->fr_desc->ind &= ~ISERT_PROTECTED;
-	}
-
 	iscsit_stop_dataout_timer(cmd);
-	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	cmd->write_data_done = isert_cmd->data.len;
-	isert_cmd->rdma_wr_num = 0;
+
+	if (isert_prot_cmd(isert_conn, se_cmd))
+		ret = isert_check_pi_status(se_cmd, isert_cmd->rw.sig->sig_mr);
+	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
+	cmd->write_data_done = 0;
 
 	isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
@@ -2111,7 +1856,6 @@ isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->device;
 
 	spin_lock_bh(&conn->cmd_lock);
 	if (!list_empty(&cmd->i_conn_node))
@@ -2120,8 +1864,7 @@ isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 
 	if (cmd->data_direction == DMA_TO_DEVICE)
 		iscsit_stop_dataout_timer(cmd);
-
-	device->unreg_rdma_mem(isert_cmd, isert_conn);
+	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
 }
 
 static enum target_prot_op
@@ -2274,234 +2017,6 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	return isert_post_response(isert_conn, isert_cmd);
 }
 
-static int
-isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
-		    struct ib_sge *ib_sge, struct ib_rdma_wr *rdma_wr,
-		    u32 data_left, u32 offset)
-{
-	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
-	struct scatterlist *sg_start, *tmp_sg;
-	struct isert_device *device = isert_conn->device;
-	struct ib_device *ib_dev = device->ib_device;
-	u32 sg_off, page_off;
-	int i = 0, sg_nents;
-
-	sg_off = offset / PAGE_SIZE;
-	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, isert_conn->max_sge);
-	page_off = offset % PAGE_SIZE;
-
-	rdma_wr->wr.sg_list = ib_sge;
-	rdma_wr->wr.wr_cqe = &isert_cmd->tx_desc.tx_cqe;
-
-	/*
-	 * Perform mapping of TCM scatterlist memory ib_sge dma_addr.
-	 */
-	for_each_sg(sg_start, tmp_sg, sg_nents, i) {
-		isert_dbg("RDMA from SGL dma_addr: 0x%llx dma_len: %u, "
-			  "page_off: %u\n",
-			  (unsigned long long)tmp_sg->dma_address,
-			  tmp_sg->length, page_off);
-
-		ib_sge->addr = ib_sg_dma_address(ib_dev, tmp_sg) + page_off;
-		ib_sge->length = min_t(u32, data_left,
-				ib_sg_dma_len(ib_dev, tmp_sg) - page_off);
-		ib_sge->lkey = device->pd->local_dma_lkey;
-
-		isert_dbg("RDMA ib_sge: addr: 0x%llx  length: %u lkey: %x\n",
-			  ib_sge->addr, ib_sge->length, ib_sge->lkey);
-		page_off = 0;
-		data_left -= ib_sge->length;
-		if (!data_left)
-			break;
-		ib_sge++;
-		isert_dbg("Incrementing ib_sge pointer to %p\n", ib_sge);
-	}
-
-	rdma_wr->wr.num_sge = ++i;
-	isert_dbg("Set outgoing sg_list: %p num_sg: %u from TCM SGLs\n",
-		  rdma_wr->wr.sg_list, rdma_wr->wr.num_sge);
-
-	return rdma_wr->wr.num_sge;
-}
-
-static int
-isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
-{
-	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_conn *isert_conn = conn->context;
-	struct isert_data_buf *data = &isert_cmd->data;
-	struct ib_rdma_wr *rdma_wr;
-	struct ib_sge *ib_sge;
-	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
-	int ret = 0, i, ib_sge_cnt;
-
-	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
-			cmd->write_data_done : 0;
-	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
-				 se_cmd->t_data_nents, se_cmd->data_length,
-				 offset, isert_cmd->iser_ib_op,
-				 &isert_cmd->data);
-	if (ret)
-		return ret;
-
-	data_left = data->len;
-	offset = data->offset;
-
-	ib_sge = kzalloc(sizeof(struct ib_sge) * data->nents, GFP_KERNEL);
-	if (!ib_sge) {
-		isert_warn("Unable to allocate ib_sge\n");
-		ret = -ENOMEM;
-		goto unmap_cmd;
-	}
-	isert_cmd->ib_sge = ib_sge;
-
-	isert_cmd->rdma_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
-	isert_cmd->rdma_wr = kzalloc(sizeof(struct ib_rdma_wr) *
-			isert_cmd->rdma_wr_num, GFP_KERNEL);
-	if (!isert_cmd->rdma_wr) {
-		isert_dbg("Unable to allocate isert_cmd->rdma_wr\n");
-		ret = -ENOMEM;
-		goto unmap_cmd;
-	}
-
-	rdma_write_max = isert_conn->max_sge * PAGE_SIZE;
-
-	for (i = 0; i < isert_cmd->rdma_wr_num; i++) {
-		rdma_wr = &isert_cmd->rdma_wr[i];
-		data_len = min(data_left, rdma_write_max);
-
-		rdma_wr->wr.send_flags = 0;
-		if (isert_cmd->iser_ib_op == ISER_IB_RDMA_WRITE) {
-			isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
-
-			rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
-			rdma_wr->remote_addr = isert_cmd->read_va + offset;
-			rdma_wr->rkey = isert_cmd->read_stag;
-			if (i + 1 == isert_cmd->rdma_wr_num)
-				rdma_wr->wr.next = &isert_cmd->tx_desc.send_wr;
-			else
-				rdma_wr->wr.next = &isert_cmd->rdma_wr[i + 1].wr;
-		} else {
-			isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
-
-			rdma_wr->wr.opcode = IB_WR_RDMA_READ;
-			rdma_wr->remote_addr = isert_cmd->write_va + va_offset;
-			rdma_wr->rkey = isert_cmd->write_stag;
-			if (i + 1 == isert_cmd->rdma_wr_num)
-				rdma_wr->wr.send_flags = IB_SEND_SIGNALED;
-			else
-				rdma_wr->wr.next = &isert_cmd->rdma_wr[i + 1].wr;
-		}
-
-		ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
-					rdma_wr, data_len, offset);
-		ib_sge += ib_sge_cnt;
-
-		offset += data_len;
-		va_offset += data_len;
-		data_left -= data_len;
-	}
-
-	return 0;
-unmap_cmd:
-	isert_unmap_data_buf(isert_conn, data);
-
-	return ret;
-}
-
-static inline void
-isert_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
-{
-	u32 rkey;
-
-	memset(inv_wr, 0, sizeof(*inv_wr));
-	inv_wr->wr_cqe = NULL;
-	inv_wr->opcode = IB_WR_LOCAL_INV;
-	inv_wr->ex.invalidate_rkey = mr->rkey;
-
-	/* Bump the key */
-	rkey = ib_inc_rkey(mr->rkey);
-	ib_update_fast_reg_key(mr, rkey);
-}
-
-static int
-isert_fast_reg_mr(struct isert_conn *isert_conn,
-		  struct fast_reg_descriptor *fr_desc,
-		  struct isert_data_buf *mem,
-		  enum isert_indicator ind,
-		  struct ib_sge *sge)
-{
-	struct isert_device *device = isert_conn->device;
-	struct ib_device *ib_dev = device->ib_device;
-	struct ib_mr *mr;
-	struct ib_reg_wr reg_wr;
-	struct ib_send_wr inv_wr, *bad_wr, *wr = NULL;
-	int ret, n;
-
-	if (mem->dma_nents == 1) {
-		sge->lkey = device->pd->local_dma_lkey;
-		sge->addr = ib_sg_dma_address(ib_dev, &mem->sg[0]);
-		sge->length = ib_sg_dma_len(ib_dev, &mem->sg[0]);
-		isert_dbg("sge: addr: 0x%llx  length: %u lkey: %x\n",
-			 sge->addr, sge->length, sge->lkey);
-		return 0;
-	}
-
-	if (ind == ISERT_DATA_KEY_VALID)
-		/* Registering data buffer */
-		mr = fr_desc->data_mr;
-	else
-		/* Registering protection buffer */
-		mr = fr_desc->pi_ctx->prot_mr;
-
-	if (!(fr_desc->ind & ind)) {
-		isert_inv_rkey(&inv_wr, mr);
-		wr = &inv_wr;
-	}
-
-	n = ib_map_mr_sg(mr, mem->sg, mem->nents, 0, PAGE_SIZE);
-	if (unlikely(n != mem->nents)) {
-		isert_err("failed to map mr sg (%d/%d)\n",
-			 n, mem->nents);
-		return n < 0 ? n : -EINVAL;
-	}
-
-	isert_dbg("Use fr_desc %p sg_nents %d offset %u\n",
-		  fr_desc, mem->nents, mem->offset);
-
-	reg_wr.wr.next = NULL;
-	reg_wr.wr.opcode = IB_WR_REG_MR;
-	reg_wr.wr.wr_cqe = NULL;
-	reg_wr.wr.send_flags = 0;
-	reg_wr.wr.num_sge = 0;
-	reg_wr.mr = mr;
-	reg_wr.key = mr->lkey;
-	reg_wr.access = IB_ACCESS_LOCAL_WRITE;
-
-	if (!wr)
-		wr = &reg_wr.wr;
-	else
-		wr->next = &reg_wr.wr;
-
-	ret = ib_post_send(isert_conn->qp, wr, &bad_wr);
-	if (ret) {
-		isert_err("fast registration failed, ret:%d\n", ret);
-		return ret;
-	}
-	fr_desc->ind &= ~ind;
-
-	sge->lkey = mr->lkey;
-	sge->addr = mr->iova;
-	sge->length = mr->length;
-
-	isert_dbg("sge: addr: 0x%llx  length: %u lkey: %x\n",
-		  sge->addr, sge->length, sge->lkey);
-
-	return ret;
-}
-
 static inline void
 isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
 		     struct ib_sig_domain *domain)
@@ -2526,6 +2041,8 @@ isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
 static int
 isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 {
+	memset(sig_attrs, 0, sizeof(*sig_attrs));
+
 	switch (se_cmd->prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
@@ -2547,228 +2064,59 @@ isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 		return -EINVAL;
 	}
 
+	sig_attrs->check_mask =
+	       (se_cmd->prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
+	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
+	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
 	return 0;
 }
 
-static inline u8
-isert_set_prot_checks(u8 prot_checks)
-{
-	return (prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
-	       (prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
-	       (prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
-}
-
-static int
-isert_reg_sig_mr(struct isert_conn *isert_conn,
-		 struct isert_cmd *isert_cmd,
-		 struct fast_reg_descriptor *fr_desc)
-{
-	struct se_cmd *se_cmd = &isert_cmd->iscsi_cmd->se_cmd;
-	struct ib_sig_handover_wr sig_wr;
-	struct ib_send_wr inv_wr, *bad_wr, *wr = NULL;
-	struct pi_context *pi_ctx = fr_desc->pi_ctx;
-	struct ib_sig_attrs sig_attrs;
-	int ret;
-
-	memset(&sig_attrs, 0, sizeof(sig_attrs));
-	ret = isert_set_sig_attrs(se_cmd, &sig_attrs);
-	if (ret)
-		goto err;
-
-	sig_attrs.check_mask = isert_set_prot_checks(se_cmd->prot_checks);
-
-	if (!(fr_desc->ind & ISERT_SIG_KEY_VALID)) {
-		isert_inv_rkey(&inv_wr, pi_ctx->sig_mr);
-		wr = &inv_wr;
-	}
-
-	memset(&sig_wr, 0, sizeof(sig_wr));
-	sig_wr.wr.opcode = IB_WR_REG_SIG_MR;
-	sig_wr.wr.wr_cqe = NULL;
-	sig_wr.wr.sg_list = &isert_cmd->ib_sg[DATA];
-	sig_wr.wr.num_sge = 1;
-	sig_wr.access_flags = IB_ACCESS_LOCAL_WRITE;
-	sig_wr.sig_attrs = &sig_attrs;
-	sig_wr.sig_mr = pi_ctx->sig_mr;
-	if (se_cmd->t_prot_sg)
-		sig_wr.prot = &isert_cmd->ib_sg[PROT];
-
-	if (!wr)
-		wr = &sig_wr.wr;
-	else
-		wr->next = &sig_wr.wr;
-
-	ret = ib_post_send(isert_conn->qp, wr, &bad_wr);
-	if (ret) {
-		isert_err("fast registration failed, ret:%d\n", ret);
-		goto err;
-	}
-	fr_desc->ind &= ~ISERT_SIG_KEY_VALID;
-
-	isert_cmd->ib_sg[SIG].lkey = pi_ctx->sig_mr->lkey;
-	isert_cmd->ib_sg[SIG].addr = 0;
-	isert_cmd->ib_sg[SIG].length = se_cmd->data_length;
-	if (se_cmd->prot_op != TARGET_PROT_DIN_STRIP &&
-	    se_cmd->prot_op != TARGET_PROT_DOUT_INSERT)
-		/*
-		 * We have protection guards on the wire
-		 * so we need to set a larget transfer
-		 */
-		isert_cmd->ib_sg[SIG].length += se_cmd->prot_length;
-
-	isert_dbg("sig_sge: addr: 0x%llx  length: %u lkey: %x\n",
-		  isert_cmd->ib_sg[SIG].addr, isert_cmd->ib_sg[SIG].length,
-		  isert_cmd->ib_sg[SIG].lkey);
-err:
-	return ret;
-}
-
 static int
-isert_handle_prot_cmd(struct isert_conn *isert_conn,
-		      struct isert_cmd *isert_cmd)
-{
-	struct isert_device *device = isert_conn->device;
-	struct se_cmd *se_cmd = &isert_cmd->iscsi_cmd->se_cmd;
+isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
+		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
+{
+	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
+	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
+	u8 port_num = conn->cm_id->port_num;
+	u64 addr;
+	u32 rkey, offset;
 	int ret;
 
-	if (!isert_cmd->fr_desc->pi_ctx) {
-		ret = isert_create_pi_ctx(isert_cmd->fr_desc,
-					  device->ib_device,
-					  device->pd);
-		if (ret) {
-			isert_err("conn %p failed to allocate pi_ctx\n",
-				  isert_conn);
-			return ret;
-		}
-	}
-
-	if (se_cmd->t_prot_sg) {
-		ret = isert_map_data_buf(isert_conn, isert_cmd,
-					 se_cmd->t_prot_sg,
-					 se_cmd->t_prot_nents,
-					 se_cmd->prot_length,
-					 0,
-					 isert_cmd->iser_ib_op,
-					 &isert_cmd->prot);
-		if (ret) {
-			isert_err("conn %p failed to map protection buffer\n",
-				  isert_conn);
-			return ret;
-		}
-
-		memset(&isert_cmd->ib_sg[PROT], 0, sizeof(isert_cmd->ib_sg[PROT]));
-		ret = isert_fast_reg_mr(isert_conn, isert_cmd->fr_desc,
-					&isert_cmd->prot,
-					ISERT_PROT_KEY_VALID,
-					&isert_cmd->ib_sg[PROT]);
-		if (ret) {
-			isert_err("conn %p failed to fast reg mr\n",
-				  isert_conn);
-			goto unmap_prot_cmd;
-		}
-	}
-
-	ret = isert_reg_sig_mr(isert_conn, isert_cmd, isert_cmd->fr_desc);
-	if (ret) {
-		isert_err("conn %p failed to fast reg mr\n",
-			  isert_conn);
-		goto unmap_prot_cmd;
-	}
-	isert_cmd->fr_desc->ind |= ISERT_PROTECTED;
-
-	return 0;
-
-unmap_prot_cmd:
-	if (se_cmd->t_prot_sg)
-		isert_unmap_data_buf(isert_conn, &isert_cmd->prot);
-
-	return ret;
-}
-
-static int
-isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
-{
-	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_conn *isert_conn = conn->context;
-	struct fast_reg_descriptor *fr_desc = NULL;
-	struct ib_rdma_wr *rdma_wr;
-	struct ib_sge *ib_sg;
-	u32 offset;
-	int ret = 0;
-	unsigned long flags;
-
-	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
-			cmd->write_data_done : 0;
-	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
-				 se_cmd->t_data_nents, se_cmd->data_length,
-				 offset, isert_cmd->iser_ib_op,
-				 &isert_cmd->data);
-	if (ret)
-		return ret;
-
-	if (isert_cmd->data.dma_nents != 1 ||
-	    isert_prot_cmd(isert_conn, se_cmd)) {
-		spin_lock_irqsave(&isert_conn->pool_lock, flags);
-		fr_desc = list_first_entry(&isert_conn->fr_pool,
-					   struct fast_reg_descriptor, list);
-		list_del(&fr_desc->list);
-		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
-		isert_cmd->fr_desc = fr_desc;
-	}
-
-	ret = isert_fast_reg_mr(isert_conn, fr_desc, &isert_cmd->data,
-				ISERT_DATA_KEY_VALID, &isert_cmd->ib_sg[DATA]);
-	if (ret)
-		goto unmap_cmd;
-
-	if (isert_prot_cmd(isert_conn, se_cmd)) {
-		ret = isert_handle_prot_cmd(isert_conn, isert_cmd);
-		if (ret)
-			goto unmap_cmd;
-
-		ib_sg = &isert_cmd->ib_sg[SIG];
+	if (dir == DMA_FROM_DEVICE) {
+		addr = cmd->write_va;
+		rkey = cmd->write_stag;
+		offset = cmd->iscsi_cmd->write_data_done;
 	} else {
-		ib_sg = &isert_cmd->ib_sg[DATA];
+		addr = cmd->read_va;
+		rkey = cmd->read_stag;
+		offset = 0;
 	}
 
-	memcpy(&isert_cmd->s_ib_sge, ib_sg, sizeof(*ib_sg));
-	isert_cmd->ib_sge = &isert_cmd->s_ib_sge;
-	isert_cmd->rdma_wr_num = 1;
-	memset(&isert_cmd->s_rdma_wr, 0, sizeof(isert_cmd->s_rdma_wr));
-	isert_cmd->rdma_wr = &isert_cmd->s_rdma_wr;
+	if (isert_prot_cmd(conn, se_cmd)) {
+		struct ib_sig_attrs sig_attrs;
 
-	rdma_wr = &isert_cmd->s_rdma_wr;
-	rdma_wr->wr.sg_list = &isert_cmd->s_ib_sge;
-	rdma_wr->wr.num_sge = 1;
-	rdma_wr->wr.wr_cqe = &isert_cmd->tx_desc.tx_cqe;
-	if (isert_cmd->iser_ib_op == ISER_IB_RDMA_WRITE) {
-		isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
+		ret = isert_set_sig_attrs(se_cmd, &sig_attrs);
+		if (ret)
+			return ret;
 
-		rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
-		rdma_wr->remote_addr = isert_cmd->read_va;
-		rdma_wr->rkey = isert_cmd->read_stag;
-		rdma_wr->wr.send_flags = !isert_prot_cmd(isert_conn, se_cmd) ?
-				      0 : IB_SEND_SIGNALED;
+		WARN_ON_ONCE(offset);
+		ret = rdma_rw_ctx_signature_init(&cmd->rw, conn->qp, port_num,
+				se_cmd->t_data_sg, se_cmd->t_data_nents,
+				se_cmd->t_prot_sg, se_cmd->t_prot_nents,
+				&sig_attrs, addr, rkey, dir);
 	} else {
-		isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
-
-		rdma_wr->wr.opcode = IB_WR_RDMA_READ;
-		rdma_wr->remote_addr = isert_cmd->write_va;
-		rdma_wr->rkey = isert_cmd->write_stag;
-		rdma_wr->wr.send_flags = IB_SEND_SIGNALED;
+		ret = rdma_rw_ctx_init(&cmd->rw, conn->qp, port_num,
+				se_cmd->t_data_sg, se_cmd->t_data_nents,
+				offset, addr, rkey, dir);
 	}
-
-	return 0;
-
-unmap_cmd:
-	if (fr_desc) {
-		spin_lock_irqsave(&isert_conn->pool_lock, flags);
-		list_add_tail(&fr_desc->list, &isert_conn->fr_pool);
-		spin_unlock_irqrestore(&isert_conn->pool_lock, flags);
+	if (ret < 0) {
+		isert_err("Cmd: %p failed to prepare RDMA res\n", cmd);
+		return ret;
 	}
-	isert_unmap_data_buf(isert_conn, &isert_cmd->data);
 
+	ret = rdma_rw_ctx_post(&cmd->rw, conn->qp, port_num, cqe, chain_wr);
+	if (ret < 0)
+		isert_err("Cmd: %p failed to post RDMA res\n", cmd);
 	return ret;
 }
 
@@ -2778,21 +2126,17 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->device;
-	struct ib_send_wr *wr_failed;
+	struct ib_cqe *cqe = NULL;
+	struct ib_send_wr *chain_wr = NULL;
 	int rc;
 
 	isert_dbg("Cmd: %p RDMA_WRITE data_length: %u\n",
 		 isert_cmd, se_cmd->data_length);
 
-	isert_cmd->iser_ib_op = ISER_IB_RDMA_WRITE;
-	rc = device->reg_rdma_mem(isert_cmd, conn);
-	if (rc) {
-		isert_err("Cmd: %p failed to prepare RDMA res\n", isert_cmd);
-		return rc;
-	}
-
-	if (!isert_prot_cmd(isert_conn, se_cmd)) {
+	if (isert_prot_cmd(isert_conn, se_cmd)) {
+		isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
+		cqe = &isert_cmd->tx_desc.tx_cqe;
+	} else {
 		/*
 		 * Build isert_conn->tx_desc for iSCSI response PDU and attach
 		 */
@@ -2803,56 +2147,35 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 		isert_init_send_wr(isert_conn, isert_cmd,
 				   &isert_cmd->tx_desc.send_wr);
-		isert_cmd->s_rdma_wr.wr.next = &isert_cmd->tx_desc.send_wr;
-		isert_cmd->rdma_wr_num += 1;
 
 		rc = isert_post_recv(isert_conn, isert_cmd->rx_desc);
 		if (rc) {
 			isert_err("ib_post_recv failed with %d\n", rc);
 			return rc;
 		}
-	}
 
-	rc = ib_post_send(isert_conn->qp, &isert_cmd->rdma_wr->wr, &wr_failed);
-	if (rc)
-		isert_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
-
-	if (!isert_prot_cmd(isert_conn, se_cmd))
-		isert_dbg("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
-			 "READ\n", isert_cmd);
-	else
-		isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ\n",
-			 isert_cmd);
+		chain_wr = &isert_cmd->tx_desc.send_wr;
+	}
 
+	isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
+	isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ\n", isert_cmd);
 	return 1;
 }
 
 static int
 isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 {
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = conn->context;
-	struct isert_device *device = isert_conn->device;
-	struct ib_send_wr *wr_failed;
-	int rc;
 
 	isert_dbg("Cmd: %p RDMA_READ data_length: %u write_data_done: %u\n",
-		 isert_cmd, se_cmd->data_length, cmd->write_data_done);
-	isert_cmd->iser_ib_op = ISER_IB_RDMA_READ;
-	rc = device->reg_rdma_mem(isert_cmd, conn);
-	if (rc) {
-		isert_err("Cmd: %p failed to prepare RDMA res\n", isert_cmd);
-		return rc;
-	}
+		 isert_cmd, cmd->se_cmd.data_length, cmd->write_data_done);
 
-	rc = ib_post_send(isert_conn->qp, &isert_cmd->rdma_wr->wr, &wr_failed);
-	if (rc)
-		isert_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
+	isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
+	isert_rdma_rw_ctx_post(isert_cmd, conn->context,
+			&isert_cmd->tx_desc.tx_cqe, NULL);
 
 	isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
 		 isert_cmd);
-
 	return 0;
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 147900c..e512ba9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -3,6 +3,7 @@
 #include <linux/in6.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
+#include <rdma/rw.h>
 #include <scsi/iser.h>
 
 
@@ -53,10 +54,7 @@
 
 #define ISERT_MIN_POSTED_RX	(ISCSI_DEF_XMIT_CMDS_MAX >> 2)
 
-#define ISERT_INFLIGHT_DATAOUTS	8
-
-#define ISERT_QP_MAX_REQ_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX *    \
-				(1 + ISERT_INFLIGHT_DATAOUTS) + \
+#define ISERT_QP_MAX_REQ_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX +    \
 				ISERT_MAX_TX_MISC_PDUS	+ \
 				ISERT_MAX_RX_MISC_PDUS)
 
@@ -71,13 +69,6 @@ enum isert_desc_type {
 	ISCSI_TX_DATAIN
 };
 
-enum iser_ib_op_code {
-	ISER_IB_RECV,
-	ISER_IB_SEND,
-	ISER_IB_RDMA_WRITE,
-	ISER_IB_RDMA_READ,
-};
-
 enum iser_conn_state {
 	ISER_CONN_INIT,
 	ISER_CONN_UP,
@@ -118,42 +109,6 @@ static inline struct iser_tx_desc *cqe_to_tx_desc(struct ib_cqe *cqe)
 	return container_of(cqe, struct iser_tx_desc, tx_cqe);
 }
 
-
-enum isert_indicator {
-	ISERT_PROTECTED		= 1 << 0,
-	ISERT_DATA_KEY_VALID	= 1 << 1,
-	ISERT_PROT_KEY_VALID	= 1 << 2,
-	ISERT_SIG_KEY_VALID	= 1 << 3,
-};
-
-struct pi_context {
-	struct ib_mr		       *prot_mr;
-	struct ib_mr		       *sig_mr;
-};
-
-struct fast_reg_descriptor {
-	struct list_head		list;
-	struct ib_mr		       *data_mr;
-	u8				ind;
-	struct pi_context	       *pi_ctx;
-};
-
-struct isert_data_buf {
-	struct scatterlist     *sg;
-	int			nents;
-	u32			sg_off;
-	u32			len; /* cur_rdma_length */
-	u32			offset;
-	unsigned int		dma_nents;
-	enum dma_data_direction dma_dir;
-};
-
-enum {
-	DATA = 0,
-	PROT = 1,
-	SIG = 2,
-};
-
 struct isert_cmd {
 	uint32_t		read_stag;
 	uint32_t		write_stag;
@@ -166,16 +121,7 @@ struct isert_cmd {
 	struct iscsi_cmd	*iscsi_cmd;
 	struct iser_tx_desc	tx_desc;
 	struct iser_rx_desc	*rx_desc;
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
+	struct rdma_rw_ctx	rw;
 	struct work_struct	comp_work;
 	struct scatterlist	sg;
 };
@@ -210,10 +156,6 @@ struct isert_conn {
 	struct isert_device	*device;
 	struct mutex		mutex;
 	struct kref		kref;
-	struct list_head	fr_pool;
-	int			fr_pool_size;
-	/* lock to protect fastreg pool */
-	spinlock_t		pool_lock;
 	struct work_struct	release_work;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
@@ -236,7 +178,6 @@ struct isert_comp {
 };
 
 struct isert_device {
-	int			use_fastreg;
 	bool			pi_capable;
 	int			refcount;
 	struct ib_device	*ib_device;
@@ -244,10 +185,6 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
-	int			(*reg_rdma_mem)(struct isert_cmd *isert_cmd,
-						struct iscsi_conn *conn);
-	void			(*unreg_rdma_mem)(struct isert_cmd *isert_cmd,
-						  struct isert_conn *isert_conn);
 };
 
 struct isert_np {
-- 
2.1.4
