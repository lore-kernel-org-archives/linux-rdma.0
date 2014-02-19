From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 09/12] IB/isert: Introduce isert_map/unmap_data_buf
Date: Wed, 19 Feb 2014 17:50:22 +0200
Message-ID: <1392825025-29943-10-git-send-email-sagig@mellanox.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

export map/unmap data buffer to a routine that may
be used in various places in the code and keep the
mapping data in a designated descriptor. Also, let
isert_fast_reg_mr to decide weather to use global
MR or do fast registration.

This commit does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  238 +++++++++++++++----------------
 drivers/infiniband/ulp/isert/ib_isert.h |   14 ++-
 2 files changed, 127 insertions(+), 125 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d18d08a..cbf0248 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1392,19 +1392,60 @@ isert_rx_completion(struct iser_rx_desc *desc, struct isert_conn *isert_conn,
 	}
 }
 
+static int
+isert_map_data_buf(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
+		   struct scatterlist *sg, u32 nents, u32 length, u32 offset,
+		   enum iser_ib_op_code op, struct isert_data_buf *data)
+{
+	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+
+	data->dma_dir = op == ISER_IB_RDMA_WRITE ?
+			      DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+	data->len = length - offset;
+	data->offset = offset;
+	data->sg_off = data->offset / PAGE_SIZE;
+
+	data->sg = &sg[data->sg_off];
+	data->nents = min_t(unsigned int, nents - data->sg_off,
+					  ISCSI_ISER_SG_TABLESIZE);
+	data->len = min_t(unsigned int, data->len, ISCSI_ISER_SG_TABLESIZE *
+					PAGE_SIZE);
+
+	data->dma_nents = ib_dma_map_sg(ib_dev, data->sg, data->nents,
+					data->dma_dir);
+	if (unlikely(!data->dma_nents)) {
+		pr_err("Cmd: unable to dma map SGs %p\n", sg);
+		return -EINVAL;
+	}
+
+	pr_debug("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
+		 isert_cmd, data->dma_nents, data->sg, data->nents, data->len);
+
+	return 0;
+}
+
+static void
+isert_unmap_data_buf(struct isert_conn *isert_conn, struct isert_data_buf *data)
+{
+	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+
+	ib_dma_unmap_sg(ib_dev, data->sg, data->nents, data->dma_dir);
+	memset(data, 0, sizeof(*data));
+}
+
+
+
 static void
 isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 
 	pr_debug("isert_unmap_cmd: %p\n", isert_cmd);
-	if (wr->sge) {
+
+	if (wr->data.sg) {
 		pr_debug("isert_unmap_cmd: %p unmap_sg op\n", isert_cmd);
-		ib_dma_unmap_sg(ib_dev, wr->sge, wr->num_sge,
-				(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-				DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		wr->sge = NULL;
+		isert_unmap_data_buf(isert_conn, &wr->data);
 	}
 
 	if (wr->send_wr) {
@@ -1424,7 +1465,6 @@ static void
 isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	LIST_HEAD(unmap_list);
 
 	pr_debug("unreg_fastreg_cmd: %p\n", isert_cmd);
@@ -1438,12 +1478,9 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 		wr->fr_desc = NULL;
 	}
 
-	if (wr->sge) {
+	if (wr->data.sg) {
 		pr_debug("unreg_fastreg_cmd: %p unmap_sg op\n", isert_cmd);
-		ib_dma_unmap_sg(ib_dev, wr->sge, wr->num_sge,
-				(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-				DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		wr->sge = NULL;
+		isert_unmap_data_buf(isert_conn, &wr->data);
 	}
 
 	wr->ib_sge = NULL;
@@ -1548,7 +1585,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
-	cmd->write_data_done = wr->cur_rdma_length;
+	cmd->write_data_done = wr->data.len;
 
 	pr_debug("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
@@ -2046,54 +2083,39 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_data_buf *data = &wr->data;
 	struct ib_send_wr *send_wr;
 	struct ib_sge *ib_sge;
-	struct scatterlist *sg_start;
-	u32 sg_off = 0, sg_nents;
-	u32 offset = 0, data_len, data_left, rdma_write_max, va_offset = 0;
-	int ret = 0, count, i, ib_sge_cnt;
+	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
+	int ret = 0, i, ib_sge_cnt;
 
-	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
-		data_left = se_cmd->data_length;
-	} else {
-		sg_off = cmd->write_data_done / PAGE_SIZE;
-		data_left = se_cmd->data_length - cmd->write_data_done;
-		offset = cmd->write_data_done;
-		isert_cmd->tx_desc.isert_cmd = isert_cmd;
-	}
+	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
-	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = se_cmd->t_data_nents - sg_off;
+	offset = wr->iser_ib_op == ISER_IB_RDMA_READ ? cmd->write_data_done : 0;
+	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
+				 se_cmd->t_data_nents, se_cmd->data_length,
+				 offset, wr->iser_ib_op, &wr->data);
+	if (ret)
+		return ret;
 
-	count = ib_dma_map_sg(ib_dev, sg_start, sg_nents,
-			      (wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			      DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	if (unlikely(!count)) {
-		pr_err("Cmd: %p unrable to map SGs\n", isert_cmd);
-		return -EINVAL;
-	}
-	wr->sge = sg_start;
-	wr->num_sge = sg_nents;
-	wr->cur_rdma_length = data_left;
-	pr_debug("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
-		 isert_cmd, count, sg_start, sg_nents, data_left);
+	data_left = data->len;
+	offset = data->offset;
 
-	ib_sge = kzalloc(sizeof(struct ib_sge) * sg_nents, GFP_KERNEL);
+	ib_sge = kzalloc(sizeof(struct ib_sge) * data->nents, GFP_KERNEL);
 	if (!ib_sge) {
 		pr_warn("Unable to allocate ib_sge\n");
 		ret = -ENOMEM;
-		goto unmap_sg;
+		goto unmap_cmd;
 	}
 	wr->ib_sge = ib_sge;
 
-	wr->send_wr_num = DIV_ROUND_UP(sg_nents, isert_conn->max_sge);
+	wr->send_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
 	wr->send_wr = kzalloc(sizeof(struct ib_send_wr) * wr->send_wr_num,
 				GFP_KERNEL);
 	if (!wr->send_wr) {
 		pr_debug("Unable to allocate wr->send_wr\n");
 		ret = -ENOMEM;
-		goto unmap_sg;
+		goto unmap_cmd;
 	}
 
 	wr->isert_cmd = isert_cmd;
@@ -2132,10 +2154,9 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	}
 
 	return 0;
-unmap_sg:
-	ib_dma_unmap_sg(ib_dev, sg_start, sg_nents,
-			(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+unmap_cmd:
+	isert_unmap_data_buf(isert_conn, data);
+
 	return ret;
 }
 
@@ -2179,10 +2200,10 @@ isert_map_fr_pagelist(struct ib_device *ib_dev,
 }
 
 static int
-isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
-		  struct isert_conn *isert_conn, struct scatterlist *sg_start,
-		  struct ib_sge *ib_sge, u32 sg_nents, u32 offset,
-		  unsigned int data_len)
+isert_fast_reg_mr(struct isert_conn *isert_conn,
+		  struct fast_reg_descriptor *fr_desc,
+		  struct isert_data_buf *mem,
+		  struct ib_sge *sge)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct ib_send_wr fr_wr, inv_wr;
@@ -2191,13 +2212,19 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 	u32 page_off;
 	u8 key;
 
-	sg_nents = min_t(unsigned int, sg_nents, ISCSI_ISER_SG_TABLESIZE);
-	page_off = offset % PAGE_SIZE;
+	if (mem->dma_nents == 1) {
+		sge->lkey = isert_conn->conn_mr->lkey;
+		sge->addr = ib_sg_dma_address(ib_dev, &mem->sg[0]);
+		sge->length = ib_sg_dma_len(ib_dev, &mem->sg[0]);
+		return 0;
+	}
+
+	page_off = mem->offset % PAGE_SIZE;
 
 	pr_debug("Use fr_desc %p sg_nents %d offset %u\n",
-		 fr_desc, sg_nents, offset);
+		 fr_desc, mem->nents, mem->offset);
 
-	pagelist_len = isert_map_fr_pagelist(ib_dev, sg_start, sg_nents,
+	pagelist_len = isert_map_fr_pagelist(ib_dev, mem->sg, mem->nents,
 					     &fr_desc->data_frpl->page_list[0]);
 
 	if (!fr_desc->valid) {
@@ -2218,7 +2245,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 	fr_wr.wr.fast_reg.page_list = fr_desc->data_frpl;
 	fr_wr.wr.fast_reg.page_list_len = pagelist_len;
 	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
-	fr_wr.wr.fast_reg.length = data_len;
+	fr_wr.wr.fast_reg.length = mem->len;
 	fr_wr.wr.fast_reg.rkey = fr_desc->data_mr->rkey;
 	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
 
@@ -2234,12 +2261,12 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 	}
 	fr_desc->valid = false;
 
-	ib_sge->lkey = fr_desc->data_mr->lkey;
-	ib_sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
-	ib_sge->length = data_len;
+	sge->lkey = fr_desc->data_mr->lkey;
+	sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
+	sge->length = mem->len;
 
 	pr_debug("RDMA ib_sge: addr: 0x%16llx  length: %u lkey: %08x\n",
-		 ib_sge->addr, ib_sge->length, ib_sge->lkey);
+		 sge->addr, sge->length, sge->lkey);
 
 	return ret;
 }
@@ -2250,54 +2277,43 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr;
-	struct ib_sge *ib_sge;
-	struct scatterlist *sg_start;
-	struct fast_reg_descriptor *fr_desc;
-	u32 sg_off = 0, sg_nents;
-	u32 offset = 0, data_len, data_left, rdma_write_max;
-	int ret = 0, count;
+	struct fast_reg_descriptor *fr_desc = NULL;
+	u32 offset;
+	int ret = 0;
 	unsigned long flags;
 
-	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
-		data_left = se_cmd->data_length;
-	} else {
-		offset = cmd->write_data_done;
-		sg_off = offset / PAGE_SIZE;
-		data_left = se_cmd->data_length - cmd->write_data_done;
-		isert_cmd->tx_desc.isert_cmd = isert_cmd;
-	}
+	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
-	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = se_cmd->t_data_nents - sg_off;
+	offset = wr->iser_ib_op == ISER_IB_RDMA_READ ? cmd->write_data_done : 0;
+	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
+				 se_cmd->t_data_nents, se_cmd->data_length,
+				 offset, wr->iser_ib_op, &wr->data);
+	if (ret)
+		return ret;
 
-	count = ib_dma_map_sg(ib_dev, sg_start, sg_nents,
-			      (wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			      DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	if (unlikely(!count)) {
-		pr_err("Cmd: %p unrable to map SGs\n", isert_cmd);
-		return -EINVAL;
+	if (wr->data.dma_nents != 1) {
+		spin_lock_irqsave(&isert_conn->conn_lock, flags);
+		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
+					   struct fast_reg_descriptor, list);
+		list_del(&fr_desc->list);
+		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
+		wr->fr_desc = fr_desc;
 	}
-	wr->sge = sg_start;
-	wr->num_sge = sg_nents;
-	pr_debug("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
-		 isert_cmd, count, sg_start, sg_nents, data_left);
 
-	memset(&wr->s_ib_sge, 0, sizeof(*ib_sge));
-	ib_sge = &wr->s_ib_sge;
-	wr->ib_sge = ib_sge;
+	ret = isert_fast_reg_mr(isert_conn, fr_desc, &wr->data, &wr->s_ib_sge);
+	if (ret)
+		goto unmap_cmd;
 
+	wr->ib_sge = &wr->s_ib_sge;
 	wr->send_wr_num = 1;
 	memset(&wr->s_send_wr, 0, sizeof(*send_wr));
 	wr->send_wr = &wr->s_send_wr;
-
 	wr->isert_cmd = isert_cmd;
-	rdma_write_max = ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE;
 
 	send_wr = &isert_cmd->rdma_wr.s_send_wr;
-	send_wr->sg_list = ib_sge;
+	send_wr->sg_list = &wr->s_ib_sge;
 	send_wr->num_sge = 1;
 	send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
@@ -2313,37 +2329,15 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		send_wr->send_flags = IB_SEND_SIGNALED;
 	}
 
-	data_len = min(data_left, rdma_write_max);
-	wr->cur_rdma_length = data_len;
-
-	/* if there is a single dma entry, dma mr is sufficient */
-	if (count == 1) {
-		ib_sge->addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
-		ib_sge->length = ib_sg_dma_len(ib_dev, &sg_start[0]);
-		ib_sge->lkey = isert_conn->conn_mr->lkey;
-		wr->fr_desc = NULL;
-	} else {
+	return 0;
+unmap_cmd:
+	if (fr_desc) {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
-		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
-					   struct fast_reg_descriptor, list);
-		list_del(&fr_desc->list);
+		list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
 		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
-		wr->fr_desc = fr_desc;
-
-		ret = isert_fast_reg_mr(fr_desc, isert_conn, sg_start,
-					ib_sge, sg_nents, offset, data_len);
-		if (ret) {
-			list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
-			goto unmap_sg;
-		}
 	}
+	isert_unmap_data_buf(isert_conn, &wr->data);
 
-	return 0;
-
-unmap_sg:
-	ib_dma_unmap_sg(ib_dev, sg_start, sg_nents,
-			(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	return ret;
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 708a069..18cb2e4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -55,18 +55,26 @@ struct fast_reg_descriptor {
 	bool			valid;
 };
 
+struct isert_data_buf {
+	struct scatterlist     *sg;
+	int			nents;
+	u32			sg_off;
+	u32			len; /* cur_rdma_length */
+	u32			offset;
+	unsigned int		dma_nents;
+	enum dma_data_direction dma_dir;
+};
+
 struct isert_rdma_wr {
 	struct list_head	wr_list;
 	struct isert_cmd	*isert_cmd;
 	enum iser_ib_op_code	iser_ib_op;
 	struct ib_sge		*ib_sge;
 	struct ib_sge		s_ib_sge;
-	int			num_sge;
-	struct scatterlist	*sge;
 	int			send_wr_num;
 	struct ib_send_wr	*send_wr;
 	struct ib_send_wr	s_send_wr;
-	u32			cur_rdma_length;
+	struct isert_data_buf	data;
 	struct fast_reg_descriptor *fr_desc;
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
