Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D374DE706
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646722; cv=none; b=uV0BmGwlo2DowxFJyX7SVh4cGUt9mD2iyl8Lox0i38+c863BIBR1c11KXkLrBwbRbbgBL4eRLDtKIf8Gy0mEUZZPr4B9SRCBcgUciF+8bnIZMl//iCtru/L1JuwiJeg0RAZmq/sdotVuGMAvs3qfvu4XPiGHBr55XaxqPw1mluM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646722; c=relaxed/simple;
	bh=JNyj8J3fJQ00+srgxJwl2wFvB1ULtw3kFv9LqI7Yy78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX7KWQcxQw96dk0otGsXSa2Ih6T+P+5qf2a5fykowtprE+Jr3mkkgLjc6rHhbEXWrmm2ggvMghFoSCoamD9oFIF6rQAPr+kW46f4qP3Y8Ani9qeJFlaSwJKuO6ivbgYVq2wtYn5RrqKeKf0ywhkJmCxXiNQ9uf/vlC1Ekl85rOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tckqb10R; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tckqb10R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789646702; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XDgi6B0oButJG2xtbCF2auN/o1tpkxrj4dFE8KJ/0I4=;
	b=tckqb10RsJmU8vbT8RoovAP5IteuwvJ/ZPQxykjTix85mkcZIrobJbEepMM7A2cNObgn464RImUBPTbY2EpNcbSvNMmmvJWVbiEMHpkDN5WdqSWIuNVSxOZ1ptuS888JZkVBuK3RktN0Cy0BQDSjJn/AleenXBiMnp5R3VAV9Aw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XB8Bsxq_1789646701;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XB8Bsxq_1789646701 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Sep 2026 20:05:01 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v4 2/5] RDMA/erdma: Support non-contiguous kernel QP buffers
Date: Thu, 17 Sep 2026 20:04:56 +0800
Message-ID: <20260917120459.13286-3-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260917120459.13286-1-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A single coherent allocation for kernel QP queues can fail for large
queues when memory is fragmented.

Allocate page-sized coherent buffers and describe them with the existing
MTT. Keep the userspace QP path unchanged.

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
 drivers/infiniband/hw/erdma/erdma_qp.c    |  38 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 211 +++++++++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
 4 files changed, 188 insertions(+), 109 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cq.c b/drivers/infiniband/hw/erdma/erdma_cq.c
index 1f456327e63c..4cc0254b0ab5 100644
--- a/drivers/infiniband/hw/erdma/erdma_cq.c
+++ b/drivers/infiniband/hw/erdma/erdma_cq.c
@@ -161,8 +161,8 @@ static int erdma_poll_one_cqe(struct erdma_cq *cq, struct ib_wc *wc)
 	if (qtype == ERDMA_CQE_QTYPE_SQ) {
 		id_table = kern_qp->swr_tbl;
 		depth = qp->attrs.sq_size;
-		wqe_hdr = get_queue_entry(qp->kern_qp.sq_buf, wqe_idx,
-					  qp->attrs.sq_size, SQEBB_SHIFT);
+		wqe_hdr = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, wqe_idx,
+					       qp->attrs.sq_size, SQEBB_SHIFT);
 		kern_qp->sq_ci =
 			FIELD_GET(ERDMA_SQE_HDR_WQEBB_CNT_MASK, *wqe_hdr) +
 			wqe_idx + 1;
diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
index e002343832f7..fc335b674746 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -259,8 +259,8 @@ static void erdma_reset_qp(struct erdma_qp *qp)
 	qp->kern_qp.rq_ci = 0;
 	memset(qp->kern_qp.swr_tbl, 0, qp->attrs.sq_size * sizeof(u64));
 	memset(qp->kern_qp.rwr_tbl, 0, qp->attrs.rq_size * sizeof(u64));
-	memset(qp->kern_qp.sq_buf, 0, qp->attrs.sq_size << SQEBB_SHIFT);
-	memset(qp->kern_qp.rq_buf, 0, qp->attrs.rq_size << RQE_SHIFT);
+	erdma_kmem_clear(&qp->kern_qp.sq_mem);
+	erdma_kmem_clear(&qp->kern_qp.rq_mem);
 	erdma_remove_cqes_of_qp(&qp->scq->ibcq, QP_ID(qp));
 	if (qp->rcq != qp->scq)
 		erdma_remove_cqes_of_qp(&qp->rcq->ibcq, QP_ID(qp));
@@ -332,8 +332,8 @@ static int fill_inline_data(struct erdma_qp *qp,
 
 	wqe_idx += (sgl_offset >> SQEBB_SHIFT);
 	sgl_offset &= (SQEBB_SIZE - 1);
-	data = get_queue_entry(qp->kern_qp.sq_buf, wqe_idx, qp->attrs.sq_size,
-			       SQEBB_SHIFT);
+	data = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, wqe_idx,
+				    qp->attrs.sq_size, SQEBB_SHIFT);
 
 	while (i < send_wr->num_sge) {
 		bytes += send_wr->sg_list[i].length;
@@ -356,8 +356,9 @@ static int fill_inline_data(struct erdma_qp *qp,
 			wqe_idx += (sgl_offset >> SQEBB_SHIFT);
 			sgl_offset &= (SQEBB_SIZE - 1);
 
-			data = get_queue_entry(qp->kern_qp.sq_buf, wqe_idx,
-					       qp->attrs.sq_size, SQEBB_SHIFT);
+			data = erdma_kmem_get_entry(&qp->kern_qp.sq_mem,
+						    wqe_idx, qp->attrs.sq_size,
+						    SQEBB_SHIFT);
 			if (!remain_size)
 				break;
 		}
@@ -385,8 +386,8 @@ static int fill_sgl(struct erdma_qp *qp, const struct ib_send_wr *send_wr,
 	while (i < send_wr->num_sge) {
 		wqe_idx += (sgl_offset >> SQEBB_SHIFT);
 		sgl_offset &= (SQEBB_SIZE - 1);
-		sgl = get_queue_entry(qp->kern_qp.sq_buf, wqe_idx,
-				      qp->attrs.sq_size, SQEBB_SHIFT);
+		sgl = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, wqe_idx,
+					   qp->attrs.sq_size, SQEBB_SHIFT);
 
 		bytes += send_wr->sg_list[i].length;
 		memcpy(sgl + sgl_offset, &send_wr->sg_list[i],
@@ -463,8 +464,8 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 	    send_wr->opcode != IB_WR_SEND_WITH_IMM)
 		return -EINVAL;
 
-	entry = get_queue_entry(qp->kern_qp.sq_buf, idx, qp->attrs.sq_size,
-				SQEBB_SHIFT);
+	entry = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, idx,
+				     qp->attrs.sq_size, SQEBB_SHIFT);
 
 	/* Clear the SQE header section. */
 	*entry = 0;
@@ -524,8 +525,8 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 		read_sqe->sink_to_h =
 			cpu_to_le32(upper_32_bits(send_wr->sg_list[0].addr));
 
-		sge = get_queue_entry(qp->kern_qp.sq_buf, idx + 1,
-				      qp->attrs.sq_size, SQEBB_SHIFT);
+		sge = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, idx + 1,
+					   qp->attrs.sq_size, SQEBB_SHIFT);
 		sge->addr = cpu_to_le64(rdma_wr->remote_addr);
 		sge->key = cpu_to_le32(rdma_wr->rkey);
 		sge->length = cpu_to_le32(send_wr->sg_list[0].length);
@@ -569,8 +570,9 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 		if (mr->mem.mtt_nents <= ERDMA_MAX_INLINE_MTT_ENTRIES) {
 			attrs |= FIELD_PREP(ERDMA_SQE_MR_MTT_TYPE_MASK, 0);
 			/* Copy SGLs to SQE content to accelerate */
-			memcpy(get_queue_entry(qp->kern_qp.sq_buf, idx + 1,
-					       qp->attrs.sq_size, SQEBB_SHIFT),
+			memcpy(erdma_kmem_get_entry(&qp->kern_qp.sq_mem,
+						    idx + 1, qp->attrs.sq_size,
+						    SQEBB_SHIFT),
 			       mr->mem.mtt->buf, MTT_SIZE(mr->mem.mtt_nents));
 			wqe_size = sizeof(struct erdma_reg_mr_sqe) +
 				   MTT_SIZE(mr->mem.mtt_nents);
@@ -605,8 +607,8 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 				cpu_to_le64(atomic_wr(send_wr)->compare_add);
 		}
 
-		sge = get_queue_entry(qp->kern_qp.sq_buf, idx + 1,
-				      qp->attrs.sq_size, SQEBB_SHIFT);
+		sge = erdma_kmem_get_entry(&qp->kern_qp.sq_mem, idx + 1,
+					   qp->attrs.sq_size, SQEBB_SHIFT);
 		sge->addr = cpu_to_le64(atomic_wr(send_wr)->remote_addr);
 		sge->key = cpu_to_le32(atomic_wr(send_wr)->rkey);
 		sge++;
@@ -702,8 +704,8 @@ static int erdma_post_recv_one(struct erdma_qp *qp,
 			       const struct ib_recv_wr *recv_wr)
 {
 	struct erdma_rqe *rqe =
-		get_queue_entry(qp->kern_qp.rq_buf, qp->kern_qp.rq_pi,
-				qp->attrs.rq_size, RQE_SHIFT);
+		erdma_kmem_get_entry(&qp->kern_qp.rq_mem, qp->kern_qp.rq_pi,
+				     qp->attrs.rq_size, RQE_SHIFT);
 
 	rqe->qe_idx = cpu_to_le16(qp->kern_qp.rq_pi + 1);
 	rqe->qpn = cpu_to_le32(QP_ID(qp));
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 57a35f8b32cf..ec29701675ca 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -19,6 +19,10 @@
 #include "erdma_cm.h"
 #include "erdma_verbs.h"
 
+static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
+			    size_t size);
+static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem);
+
 static void assemble_qbuf_mtt_for_cmd(struct erdma_mem *mem, u32 *cfg,
 				      u64 *addr0, u64 *addr1)
 {
@@ -41,7 +45,7 @@ static int create_qp_cmd(struct erdma_ucontext *uctx, struct erdma_qp *qp)
 	struct erdma_dev *dev = to_edev(qp->ibqp.device);
 	struct erdma_pd *pd = to_epd(qp->ibqp.pd);
 	struct erdma_cmdq_create_qp_req req;
-	struct erdma_uqp *user_qp;
+	struct erdma_mem *sq_mem, *rq_mem;
 	u64 resp0, resp1;
 	int err;
 
@@ -63,67 +67,46 @@ static int create_qp_cmd(struct erdma_ucontext *uctx, struct erdma_qp *qp)
 				      ERDMA_QPT_UD);
 
 	if (rdma_is_kernel_res(&qp->ibqp.res)) {
-		u32 pgsz_range = ilog2(SZ_1M) - ERDMA_HW_PAGE_SHIFT;
-
-		req.sq_cqn_mtt_cfg =
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-				   pgsz_range) |
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->scq->cqn);
-		req.rq_cqn_mtt_cfg =
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-				   pgsz_range) |
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->rcq->cqn);
-
-		req.sq_mtt_cfg =
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_OFFSET_MASK, 0) |
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_CNT_MASK, 1) |
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_LEVEL_MASK,
-				   ERDMA_MR_MTT_0LEVEL);
-		req.rq_mtt_cfg = req.sq_mtt_cfg;
-
-		req.rq_buf_addr = qp->kern_qp.rq_buf_dma_addr;
-		req.sq_buf_addr = qp->kern_qp.sq_buf_dma_addr;
+		sq_mem = &qp->kern_qp.sq_mem;
+		rq_mem = &qp->kern_qp.rq_mem;
 		req.sq_dbrec_dma = qp->kern_qp.sq_dbrec_dma;
 		req.rq_dbrec_dma = qp->kern_qp.rq_dbrec_dma;
 	} else {
-		user_qp = &qp->user_qp;
-		req.sq_cqn_mtt_cfg = FIELD_PREP(
-			ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-			ilog2(user_qp->sq_mem.page_size) - ERDMA_HW_PAGE_SHIFT);
-		req.sq_cqn_mtt_cfg |=
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->scq->cqn);
-
-		req.rq_cqn_mtt_cfg = FIELD_PREP(
-			ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
-			ilog2(user_qp->rq_mem.page_size) - ERDMA_HW_PAGE_SHIFT);
-		req.rq_cqn_mtt_cfg |=
-			FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->rcq->cqn);
-
-		req.sq_mtt_cfg = user_qp->sq_mem.page_offset;
-		req.sq_mtt_cfg |= FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_CNT_MASK,
-					     user_qp->sq_mem.mtt_nents);
-
-		req.rq_mtt_cfg = user_qp->rq_mem.page_offset;
-		req.rq_mtt_cfg |= FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_CNT_MASK,
-					     user_qp->rq_mem.mtt_nents);
-
-		assemble_qbuf_mtt_for_cmd(&user_qp->sq_mem, &req.sq_mtt_cfg,
-					  &req.sq_buf_addr, req.sq_mtt_entry);
-		assemble_qbuf_mtt_for_cmd(&user_qp->rq_mem, &req.rq_mtt_cfg,
-					  &req.rq_buf_addr, req.rq_mtt_entry);
-
-		req.sq_dbrec_dma = user_qp->sq_dbrec_dma;
-		req.rq_dbrec_dma = user_qp->rq_dbrec_dma;
+		sq_mem = &qp->user_qp.sq_mem;
+		rq_mem = &qp->user_qp.rq_mem;
+		req.sq_dbrec_dma = qp->user_qp.sq_dbrec_dma;
+		req.rq_dbrec_dma = qp->user_qp.rq_dbrec_dma;
+	}
 
-		if (uctx->ext_db.enable) {
-			req.sq_cqn_mtt_cfg |=
-				FIELD_PREP(ERDMA_CMD_CREATE_QP_DB_CFG_MASK, 1);
-			req.db_cfg =
-				FIELD_PREP(ERDMA_CMD_CREATE_QP_SQDB_CFG_MASK,
-					   uctx->ext_db.sdb_off) |
-				FIELD_PREP(ERDMA_CMD_CREATE_QP_RQDB_CFG_MASK,
-					   uctx->ext_db.rdb_off);
-		}
+	req.sq_cqn_mtt_cfg =
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
+			   ilog2(sq_mem->page_size) - ERDMA_HW_PAGE_SHIFT);
+	req.sq_cqn_mtt_cfg |=
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->scq->cqn);
+	req.rq_cqn_mtt_cfg =
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_PAGE_SIZE_MASK,
+			   ilog2(rq_mem->page_size) - ERDMA_HW_PAGE_SHIFT);
+	req.rq_cqn_mtt_cfg |=
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_CQN_MASK, qp->rcq->cqn);
+
+	req.sq_mtt_cfg =
+		sq_mem->page_offset |
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_CNT_MASK, sq_mem->mtt_nents);
+	req.rq_mtt_cfg =
+		rq_mem->page_offset |
+		FIELD_PREP(ERDMA_CMD_CREATE_QP_MTT_CNT_MASK, rq_mem->mtt_nents);
+
+	assemble_qbuf_mtt_for_cmd(sq_mem, &req.sq_mtt_cfg, &req.sq_buf_addr,
+				  req.sq_mtt_entry);
+	assemble_qbuf_mtt_for_cmd(rq_mem, &req.rq_mtt_cfg, &req.rq_buf_addr,
+				  req.rq_mtt_entry);
+	if (uctx && uctx->ext_db.enable) {
+		req.sq_cqn_mtt_cfg |=
+			FIELD_PREP(ERDMA_CMD_CREATE_QP_DB_CFG_MASK, 1);
+		req.db_cfg = FIELD_PREP(ERDMA_CMD_CREATE_QP_SQDB_CFG_MASK,
+					uctx->ext_db.sdb_off) |
+			     FIELD_PREP(ERDMA_CMD_CREATE_QP_RQDB_CFG_MASK,
+					uctx->ext_db.rdb_off);
 	}
 
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), &resp0, &resp1,
@@ -512,12 +495,10 @@ static void free_kernel_qp(struct erdma_qp *qp)
 	vfree(qp->kern_qp.swr_tbl);
 	vfree(qp->kern_qp.rwr_tbl);
 
-	dma_free_coherent(&dev->pdev->dev, qp->attrs.sq_size << SQEBB_SHIFT,
-			  qp->kern_qp.sq_buf, qp->kern_qp.sq_buf_dma_addr);
+	put_mtt_entries(dev, &qp->kern_qp.sq_mem);
 	dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
 		      qp->kern_qp.sq_dbrec_dma);
-	dma_free_coherent(&dev->pdev->dev, qp->attrs.rq_size << RQE_SHIFT,
-			  qp->kern_qp.rq_buf, qp->kern_qp.rq_buf_dma_addr);
+	put_mtt_entries(dev, &qp->kern_qp.rq_mem);
 	dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
 		      qp->kern_qp.rq_dbrec_dma);
 }
@@ -526,6 +507,7 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 			  struct ib_qp_init_attr *attrs)
 {
 	struct erdma_kqp *kqp = &qp->kern_qp;
+	int ret = -ENOMEM;
 	int size;
 
 	if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
@@ -548,44 +530,43 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 		goto err_free_swr_tbl;
 
 	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	kqp->sq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
-					 &kqp->sq_buf_dma_addr, GFP_KERNEL);
-	if (!kqp->sq_buf)
+	ret = erdma_alloc_kmem(dev, &kqp->sq_mem, size);
+	if (ret)
 		goto err_free_rwr_tbl;
 
 	kqp->sq_dbrec =
 		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
-	if (!kqp->sq_dbrec)
-		goto err_free_sq_buf;
+	if (!kqp->sq_dbrec) {
+		ret = -ENOMEM;
+		goto err_free_sq_mem;
+	}
 
 	size = qp->attrs.rq_size << RQE_SHIFT;
-	kqp->rq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
-					 &kqp->rq_buf_dma_addr, GFP_KERNEL);
-	if (!kqp->rq_buf)
+	ret = erdma_alloc_kmem(dev, &kqp->rq_mem, size);
+	if (ret)
 		goto err_free_sq_dbrec;
 
 	kqp->rq_dbrec =
 		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
-	if (!kqp->rq_dbrec)
-		goto err_free_rq_buf;
+	if (!kqp->rq_dbrec) {
+		ret = -ENOMEM;
+		goto err_free_rq_mem;
+	}
 
 	return 0;
 
-err_free_rq_buf:
-	dma_free_coherent(&dev->pdev->dev, size, kqp->rq_buf,
-			  kqp->rq_buf_dma_addr);
+err_free_rq_mem:
+	put_mtt_entries(dev, &kqp->rq_mem);
 err_free_sq_dbrec:
 	dma_pool_free(dev->db_pool, kqp->sq_dbrec, kqp->sq_dbrec_dma);
-err_free_sq_buf:
-	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	dma_free_coherent(&dev->pdev->dev, size, kqp->sq_buf,
-			  kqp->sq_buf_dma_addr);
+err_free_sq_mem:
+	put_mtt_entries(dev, &kqp->sq_mem);
 err_free_rwr_tbl:
 	vfree(kqp->rwr_tbl);
 err_free_swr_tbl:
 	vfree(kqp->swr_tbl);
 
-	return -ENOMEM;
+	return ret;
 }
 
 static void erdma_fill_bottom_mtt(struct erdma_dev *dev, struct erdma_mem *mem)
@@ -830,12 +811,76 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
 	}
 }
 
+static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
+{
+	struct erdma_buf_list *buf_list = mem->kmem.buf_list;
+	u32 i;
+
+	for (i = 0; i < mem->page_cnt; i++)
+		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE, buf_list[i].buf,
+				  buf_list[i].dma_addr);
+
+	kfree(buf_list);
+}
+
+static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
+			    size_t size)
+{
+	struct erdma_buf_list *buf_list;
+	struct erdma_mtt *mtt;
+	int ret = -ENOMEM;
+	u32 i;
+
+	mem->type = ERDMA_KMEM;
+	mem->page_size = PAGE_SIZE;
+	mem->page_offset = 0;
+	mem->page_cnt = DIV_ROUND_UP(size, PAGE_SIZE);
+	mem->mtt_nents = mem->page_cnt;
+	mem->len = size;
+
+	buf_list = kcalloc(mem->page_cnt, sizeof(*buf_list), GFP_KERNEL);
+	if (!buf_list)
+		return -ENOMEM;
+
+	for (i = 0; i < mem->page_cnt; i++) {
+		buf_list[i].buf = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
+						     &buf_list[i].dma_addr,
+						     GFP_KERNEL);
+		if (!buf_list[i].buf)
+			goto err_free_pages;
+	}
+
+	mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt), true);
+	if (IS_ERR(mtt)) {
+		ret = PTR_ERR(mtt);
+		goto err_free_pages;
+	}
+
+	for (i = 0; i < mem->page_cnt; i++)
+		mtt->buf[i] = buf_list[i].dma_addr;
+	dma_sync_single_for_device(&dev->pdev->dev, mtt->buf_dma, mtt->size,
+				   DMA_TO_DEVICE);
+	mem->kmem.buf_list = buf_list;
+	mem->mtt = mtt;
+
+	return 0;
+
+err_free_pages:
+	while (i--)
+		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE, buf_list[i].buf,
+				  buf_list[i].dma_addr);
+	kfree(buf_list);
+
+	return ret;
+}
+
 static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
 			   u64 start, u64 len, int access, u64 virt,
 			   unsigned long req_page_size, bool force_continuous)
 {
 	int ret = 0;
 
+	mem->type = ERDMA_UMEM;
 	mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
 	if (IS_ERR(mem->umem)) {
 		ret = PTR_ERR(mem->umem);
@@ -874,10 +919,10 @@ static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem)
 	if (mem->mtt)
 		erdma_destroy_mtt(dev, mem->mtt);
 
-	if (mem->umem) {
+	if (mem->type == ERDMA_KMEM)
+		erdma_free_kmem(dev, mem);
+	else if (mem->umem)
 		ib_umem_release(mem->umem);
-		mem->umem = NULL;
-	}
 }
 
 static int erdma_map_user_dbrecords(struct erdma_ucontext *ctx,
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index c73cecf92f61..401e76e846b9 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -111,8 +111,26 @@ struct erdma_mtt {
 	struct erdma_mtt *low_level;
 };
 
+enum erdma_mem_type {
+	ERDMA_UMEM = 0,
+	ERDMA_KMEM = 1,
+};
+
+struct erdma_buf_list {
+	void *buf;
+	dma_addr_t dma_addr;
+};
+
+struct erdma_kmem {
+	struct erdma_buf_list *buf_list;
+};
+
 struct erdma_mem {
-	struct ib_umem *umem;
+	enum erdma_mem_type type;
+	union {
+		struct ib_umem *umem;
+		struct erdma_kmem kmem;
+	};
 	struct erdma_mtt *mtt;
 
 	u32 page_size;
@@ -124,6 +142,23 @@ struct erdma_mem {
 	u64 len;
 };
 
+static inline void *erdma_kmem_get_entry(struct erdma_mem *mem, u32 idx,
+					 u32 depth, u32 shift)
+{
+	u32 offset = (idx & (depth - 1)) << shift;
+
+	return (u8 *)mem->kmem.buf_list[offset >> PAGE_SHIFT].buf +
+	       offset_in_page(offset);
+}
+
+static inline void erdma_kmem_clear(struct erdma_mem *mem)
+{
+	u32 i;
+
+	for (i = 0; i < mem->page_cnt; i++)
+		memset(mem->kmem.buf_list[i].buf, 0, PAGE_SIZE);
+}
+
 struct erdma_mr {
 	struct ib_mr ibmr;
 	struct erdma_mem mem;
@@ -183,11 +218,8 @@ struct erdma_kqp {
 	void __iomem *hw_sq_db;
 	void __iomem *hw_rq_db;
 
-	void *sq_buf;
-	dma_addr_t sq_buf_dma_addr;
-
-	void *rq_buf;
-	dma_addr_t rq_buf_dma_addr;
+	struct erdma_mem sq_mem;
+	struct erdma_mem rq_mem;
 
 	void *sq_dbrec;
 	void *rq_dbrec;
-- 
2.31.1

