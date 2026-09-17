Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DDB4D9F7D
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646719; cv=none; b=ilWsBv1ZjVGyJ4O3mD4EDpmfBqKqyi1C9AvmTxBkV5Dr3PVtCYx5+qkevdHEiCYYuRPKjlD4h6SSGaU5oeRaCj4fG1gBXzhrokdLlrwpc0n30yuwIt00lChICC5c1gpnaJeQaZoygwZJRzf/ZD/zMepcs2SmvxuV8ox3NwClyiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646719; c=relaxed/simple;
	bh=iESrhcnM8++g+by5w6Pq5FG3J72iB2OZ7e4vUnbYSZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+bub9JMBePdRCCaHYtYoTYdpJM9IoiF/h3m1TKZ4uHsI6jflapHcuL7R4zIXJXce6x1lQH/IYE4SMW2zYTjKCUqS1HvDN9RolmIoGxIY5jT0PK4jphjYNbeYIW1efrbZbCKYUlbyEH/b2yTwmd4SuVhwPsIY09s0tjwj77X9PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EQqY4sjn; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EQqY4sjn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789646703; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FBugwOLMUBkuwVphN3hFJ23mEOCYFGNiLxHrnpdtfDc=;
	b=EQqY4sjnINEfBWsfVi4yzdgcTg6iRHJj0xkWUiiuiA0VukEeKmwGyh4ll5Y/UrtfvAtYYQLS26XQpkC3ilzcz0WZi3TiUiVbv9pOhN3EFOzWzChZ4y7jiOha+6pgCoWHhTN8kgy4FsLzJtPVc3c54wkctys5ObrbRHs0hFvq/Mg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XB82DpN_1789646702;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XB82DpN_1789646702 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Sep 2026 20:05:02 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v4 3/5] RDMA/erdma: Support non-contiguous kernel CQ buffers
Date: Thu, 17 Sep 2026 20:04:57 +0800
Message-ID: <20260917120459.13286-4-chengyou@linux.alibaba.com>
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

A single coherent allocation for a kernel CQ can fail when memory is
fragmented.

Use page-sized coherent buffers and describe them with the existing MTT.
Keep the userspace CQ path and doorbell allocation unchanged.

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_cq.c    | 14 ++---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 76 +++++++++--------------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  3 +-
 3 files changed, 36 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cq.c b/drivers/infiniband/hw/erdma/erdma_cq.c
index 4cc0254b0ab5..daec74f0aa6d 100644
--- a/drivers/infiniband/hw/erdma/erdma_cq.c
+++ b/drivers/infiniband/hw/erdma/erdma_cq.c
@@ -8,8 +8,8 @@
 
 static void *get_next_valid_cqe(struct erdma_cq *cq)
 {
-	__be32 *cqe = get_queue_entry(cq->kern_cq.qbuf, cq->kern_cq.ci,
-				      cq->depth, CQE_SHIFT);
+	__be32 *cqe = erdma_kmem_get_entry(
+		&cq->kern_cq.qbuf_mem, cq->kern_cq.ci, cq->depth, CQE_SHIFT);
 	u32 owner = FIELD_GET(ERDMA_CQE_HDR_OWNER_MASK,
 			      be32_to_cpu(READ_ONCE(*cqe)));
 
@@ -242,15 +242,15 @@ void erdma_remove_cqes_of_qp(struct ib_cq *ibcq, u32 qpn)
 
 	while (ncqe > 0) {
 		cur_cq_ci = prev_cq_ci + ncqe - 1;
-		cqe = get_queue_entry(cq->kern_cq.qbuf, cur_cq_ci, cq->depth,
-				      CQE_SHIFT);
+		cqe = erdma_kmem_get_entry(&cq->kern_cq.qbuf_mem, cur_cq_ci,
+					   cq->depth, CQE_SHIFT);
 
 		if (be32_to_cpu(cqe->qpn) == qpn) {
 			++nqp_cqe;
 		} else if (nqp_cqe) {
-			dst_cqe = get_queue_entry(cq->kern_cq.qbuf,
-						  cur_cq_ci + nqp_cqe,
-						  cq->depth, CQE_SHIFT);
+			dst_cqe = erdma_kmem_get_entry(&cq->kern_cq.qbuf_mem,
+						       cur_cq_ci + nqp_cqe,
+						       cq->depth, CQE_SHIFT);
 			owner = FIELD_GET(ERDMA_CQE_HDR_OWNER_MASK,
 					  be32_to_cpu(dst_cqe->hdr));
 			cqe->hdr = cpu_to_be32(
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index ec29701675ca..345b75377681 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -177,7 +177,6 @@ static int create_cq_cmd(struct erdma_ucontext *uctx, struct erdma_cq *cq)
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
 	struct erdma_cmdq_create_cq_req req;
 	struct erdma_mem *mem;
-	u32 page_size;
 
 	erdma_cmdq_build_reqhdr(&req.hdr, CMDQ_SUBMOD_RDMA,
 				CMDQ_OPCODE_CREATE_CQ);
@@ -187,48 +186,34 @@ static int create_cq_cmd(struct erdma_ucontext *uctx, struct erdma_cq *cq)
 	req.cfg1 = FIELD_PREP(ERDMA_CMD_CREATE_CQ_EQN_MASK, cq->assoc_eqn);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
-		page_size = SZ_32M;
-		req.cfg0 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
-				       ilog2(page_size) - ERDMA_HW_PAGE_SHIFT);
-		req.qbuf_addr_l = lower_32_bits(cq->kern_cq.qbuf_dma_addr);
-		req.qbuf_addr_h = upper_32_bits(cq->kern_cq.qbuf_dma_addr);
-
-		req.cfg1 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_CNT_MASK, 1) |
-			    FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_LEVEL_MASK,
-				       ERDMA_MR_MTT_0LEVEL);
-
-		req.first_page_offset = 0;
+		mem = &cq->kern_cq.qbuf_mem;
 		req.cq_dbrec_dma = cq->kern_cq.dbrec_dma;
 	} else {
 		mem = &cq->user_cq.qbuf_mem;
-		req.cfg0 |=
-			FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
-				   ilog2(mem->page_size) - ERDMA_HW_PAGE_SHIFT);
-		if (mem->mtt_nents == 1) {
-			req.qbuf_addr_l = lower_32_bits(mem->mtt->buf[0]);
-			req.qbuf_addr_h = upper_32_bits(mem->mtt->buf[0]);
-			req.cfg1 |=
-				FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_LEVEL_MASK,
-					   ERDMA_MR_MTT_0LEVEL);
-		} else {
-			req.qbuf_addr_l = lower_32_bits(mem->mtt->buf_dma);
-			req.qbuf_addr_h = upper_32_bits(mem->mtt->buf_dma);
-			req.cfg1 |=
-				FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_LEVEL_MASK,
-					   ERDMA_MR_MTT_1LEVEL);
-		}
-		req.cfg1 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_CNT_MASK,
-				       mem->mtt_nents);
-
-		req.first_page_offset = mem->page_offset;
 		req.cq_dbrec_dma = cq->user_cq.dbrec_dma;
+	}
 
-		if (uctx->ext_db.enable) {
-			req.cfg1 |= FIELD_PREP(
-				ERDMA_CMD_CREATE_CQ_MTT_DB_CFG_MASK, 1);
-			req.cfg2 = FIELD_PREP(ERDMA_CMD_CREATE_CQ_DB_CFG_MASK,
-					      uctx->ext_db.cdb_off);
-		}
+	req.cfg0 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_PAGESIZE_MASK,
+			       ilog2(mem->page_size) - ERDMA_HW_PAGE_SHIFT);
+	if (mem->mtt_nents == 1) {
+		req.qbuf_addr_l = lower_32_bits(mem->mtt->buf[0]);
+		req.qbuf_addr_h = upper_32_bits(mem->mtt->buf[0]);
+		req.cfg1 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_LEVEL_MASK,
+				       ERDMA_MR_MTT_0LEVEL);
+	} else {
+		req.qbuf_addr_l = lower_32_bits(mem->mtt->buf_dma);
+		req.qbuf_addr_h = upper_32_bits(mem->mtt->buf_dma);
+		req.cfg1 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_LEVEL_MASK,
+				       ERDMA_MR_MTT_1LEVEL);
+	}
+	req.cfg1 |=
+		FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_CNT_MASK, mem->mtt_nents);
+	req.first_page_offset = mem->page_offset;
+
+	if (uctx && uctx->ext_db.enable) {
+		req.cfg1 |= FIELD_PREP(ERDMA_CMD_CREATE_CQ_MTT_DB_CFG_MASK, 1);
+		req.cfg2 = FIELD_PREP(ERDMA_CMD_CREATE_CQ_DB_CFG_MASK,
+				      uctx->ext_db.cdb_off);
 	}
 
 	return erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
@@ -1398,8 +1383,7 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	wait_for_completion(&cq->free);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
-		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
-				  cq->kern_cq.qbuf, cq->kern_cq.qbuf_dma_addr);
+		put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
 		dma_pool_free(dev->db_pool, cq->kern_cq.dbrec,
 			      cq->kern_cq.dbrec_dma);
 	} else {
@@ -1997,10 +1981,8 @@ static int erdma_init_kernel_cq(struct erdma_cq *cq)
 {
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
 
-	cq->kern_cq.qbuf =
-		dma_alloc_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
-				   &cq->kern_cq.qbuf_dma_addr, GFP_KERNEL);
-	if (!cq->kern_cq.qbuf)
+	if (erdma_alloc_kmem(dev, &cq->kern_cq.qbuf_mem,
+			     cq->depth << CQE_SHIFT))
 		return -ENOMEM;
 
 	cq->kern_cq.dbrec = dma_pool_zalloc(dev->db_pool, GFP_KERNEL,
@@ -2015,8 +1997,7 @@ static int erdma_init_kernel_cq(struct erdma_cq *cq)
 	return 0;
 
 err_out:
-	dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
-			  cq->kern_cq.qbuf, cq->kern_cq.qbuf_dma_addr);
+	put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
 
 	return -ENOMEM;
 }
@@ -2083,8 +2064,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		erdma_unmap_user_dbrecords(ctx, &cq->user_cq.user_dbr_page);
 		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
 	} else {
-		dma_free_coherent(&dev->pdev->dev, depth << CQE_SHIFT,
-				  cq->kern_cq.qbuf, cq->kern_cq.qbuf_dma_addr);
+		put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
 		dma_pool_free(dev->db_pool, cq->kern_cq.dbrec,
 			      cq->kern_cq.dbrec_dma);
 	}
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 401e76e846b9..28e898f1b6f5 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -352,8 +352,7 @@ struct erdma_qp {
 };
 
 struct erdma_kcq_info {
-	void *qbuf;
-	dma_addr_t qbuf_dma_addr;
+	struct erdma_mem qbuf_mem;
 	u32 ci;
 	u32 cmdsn;
 	u32 notify_cnt;
-- 
2.31.1

