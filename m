Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373B43C3C07
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 08:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787819139; cv=none; b=KqAQB3IemBiYTYQrClu1svf3pnhgufZEXIS1RN8wGJRAdQAQ42oc3IZcJ1Gzg4xJmJvu2qRLuPEuPx4YrI326IR3/ilmsV88Wm1vCbz+1b8kaiGxIGWpmgyLavsTlB9TjmzaZTB1FA3Sr6iy/GPzFE64eaHw7iDJqWMhej7x948=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787819139; c=relaxed/simple;
	bh=gqt2bUtIVxR7Fl5ZUCWwd4QkwTeYa8bAXB5yOw1Q2DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YujKPfLru/N+HsGxQbGWJ17jCy9eK+6B0kQyyZqZPft88JL1C9RZ8hYXDy09Q5RU8BPW7+NPhLhrHWNSDdZRFI/sS7YS28XDwxi3KCI7nTVlkdAgPo6ICBCJBx76kran5O0FWUa4hp4/G5X1C+eqE6TEO5GO0ZQ6oRyTOW4MjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x9Ss7sLv; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x9Ss7sLv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787819126; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=41/OgMiZJB4bLKX4wqSi3j9WHocEJ19PmaCfpbXPqJc=;
	b=x9Ss7sLvf6d5xwNgKg36mX7u2aWE3WzPaQ3h8s5ZQsUCK2yfdDnd6t8St+b0UhW+6k5jld7LMKKY1XzfI2Pg9eZkyQQc0Y/ixlTSTgBZVnT5lEWP0WGOpJFn8AC3XGVJEcqA4dUqsr/MNQWU3VVYOSAVG9EKMwWYsfbgLNZfe4w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9j9daz_1787819125;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9j9daz_1787819125 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 16:25:26 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v2 1/4] RDMA/erdma: Support non-contiguous kernel QP buffers
Date: Thu, 27 Aug 2026 16:25:20 +0800
Message-ID: <20260827082523.36294-2-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260827082523.36294-1-chengyou@linux.alibaba.com>
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
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
 drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
 4 files changed, 179 insertions(+), 102 deletions(-)

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
index 65b1af1e6623..a2de700bce90 100644
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
@@ -512,21 +495,13 @@ static void free_kernel_qp(struct erdma_qp *qp)
 	vfree(qp->kern_qp.swr_tbl);
 	vfree(qp->kern_qp.rwr_tbl);
 
-	if (qp->kern_qp.sq_buf)
-		dma_free_coherent(&dev->pdev->dev,
-				  qp->attrs.sq_size << SQEBB_SHIFT,
-				  qp->kern_qp.sq_buf,
-				  qp->kern_qp.sq_buf_dma_addr);
+	put_mtt_entries(dev, &qp->kern_qp.sq_mem);
 
 	if (qp->kern_qp.sq_dbrec)
 		dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
 			      qp->kern_qp.sq_dbrec_dma);
 
-	if (qp->kern_qp.rq_buf)
-		dma_free_coherent(&dev->pdev->dev,
-				  qp->attrs.rq_size << RQE_SHIFT,
-				  qp->kern_qp.rq_buf,
-				  qp->kern_qp.rq_buf_dma_addr);
+	put_mtt_entries(dev, &qp->kern_qp.rq_mem);
 
 	if (qp->kern_qp.rq_dbrec)
 		dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
@@ -556,9 +531,7 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 		goto err_out;
 
 	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	kqp->sq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
-					 &kqp->sq_buf_dma_addr, GFP_KERNEL);
-	if (!kqp->sq_buf)
+	if (erdma_alloc_kmem(dev, &kqp->sq_mem, size))
 		goto err_out;
 
 	kqp->sq_dbrec =
@@ -567,9 +540,7 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 		goto err_out;
 
 	size = qp->attrs.rq_size << RQE_SHIFT;
-	kqp->rq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
-					 &kqp->rq_buf_dma_addr, GFP_KERNEL);
-	if (!kqp->rq_buf)
+	if (erdma_alloc_kmem(dev, &kqp->rq_mem, size))
 		goto err_out;
 
 	kqp->rq_dbrec =
@@ -826,12 +797,80 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
 	}
 }
 
+static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
+{
+	struct erdma_buf_list *buf_list;
+	u32 i;
+
+	if (!mem->kmem)
+		return;
+
+	buf_list = mem->kmem->buf_list;
+	if (buf_list) {
+		for (i = 0; i < mem->page_cnt; i++)
+			if (buf_list[i].buf)
+				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+						  buf_list[i].buf,
+						  buf_list[i].dma_addr);
+		kfree(buf_list);
+	}
+
+	kfree(mem->kmem);
+	mem->kmem = NULL;
+}
+
+static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
+			    size_t size)
+{
+	struct erdma_buf_list *buf_list;
+	u32 i;
+
+	mem->type = ERDMA_KMEM;
+	mem->page_size = PAGE_SIZE;
+	mem->page_offset = 0;
+	mem->page_cnt = DIV_ROUND_UP(size, PAGE_SIZE);
+	mem->mtt_nents = mem->page_cnt;
+	mem->len = size;
+
+	mem->kmem = kzalloc_obj(*mem->kmem);
+	if (!mem->kmem)
+		goto err_free_mem;
+
+	buf_list = kcalloc(mem->page_cnt, sizeof(*buf_list), GFP_KERNEL);
+	if (!buf_list)
+		goto err_free_mem;
+	mem->kmem->buf_list = buf_list;
+
+	for (i = 0; i < mem->page_cnt; i++) {
+		buf_list[i].buf = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
+						     &buf_list[i].dma_addr,
+						     GFP_KERNEL);
+		if (!buf_list[i].buf)
+			goto err_free_mem;
+	}
+
+	mem->mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt), true);
+	if (IS_ERR(mem->mtt)) {
+		mem->mtt = NULL;
+		goto err_free_mem;
+	}
+	for (i = 0; i < mem->page_cnt; i++)
+		mem->mtt->buf[i] = buf_list[i].dma_addr;
+
+	return 0;
+
+err_free_mem:
+	erdma_free_kmem(dev, mem);
+	return -ENOMEM;
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
@@ -867,10 +906,14 @@ static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
 
 static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem)
 {
-	if (mem->mtt)
+	if (mem->mtt) {
 		erdma_destroy_mtt(dev, mem->mtt);
+		mem->mtt = NULL;
+	}
 
-	if (mem->umem) {
+	if (mem->type == ERDMA_KMEM) {
+		erdma_free_kmem(dev, mem);
+	} else if (mem->umem) {
 		ib_umem_release(mem->umem);
 		mem->umem = NULL;
 	}
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index c73cecf92f61..eb7318cf7a52 100644
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
+		struct erdma_kmem *kmem;
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
+	return (u8 *)mem->kmem->buf_list[offset >> PAGE_SHIFT].buf +
+	       offset_in_page(offset);
+}
+
+static inline void erdma_kmem_clear(struct erdma_mem *mem)
+{
+	u32 i;
+
+	for (i = 0; i < mem->page_cnt; i++)
+		memset(mem->kmem->buf_list[i].buf, 0, PAGE_SIZE);
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

