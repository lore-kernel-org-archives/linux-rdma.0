Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F110B4DA9B2
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646719; cv=none; b=b8FzOn6Kh+ckZbAcn/VS4Cmof8R9V4qOIe2Y/fFIFdvEDKqQ/zkiZrUDdoEeuJqScbQcM37/C1xsFKqhagKjbhKLPzTcQfvUqdPv6AGtAB4IYDDfUvcXadKlwfZvF0BCA92+jpRUdqZxSz+mIioIf4XT50q0cVVPojmNqIttxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646719; c=relaxed/simple;
	bh=crlMf5JrKHUhRId0P5Vs6bDPC3M0b92Y+otZDmMJvFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7Kj9RqFCNUx624hH+wsUIpWDlygiyP4ZtJUEhFLYgfNpp9z5tuYR93FS/AGNexp0ss2LL2Pg6Z0zBpNsjmrLGQmpivNmDrH6FyJrjfgZvHm9oHREZN0BjBWs/mhl3VOueXHyUr1EAIxyEI9l3idbvfvUotdeK/PYGpUtU4YFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GXFGs+2T; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GXFGs+2T"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789646703; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Av/8VtUG1fTikLXetdaCC3YmJ0FqDg3lk/GiVXLyNc4=;
	b=GXFGs+2To/PFq/s82K5jasq6HfahDkGmVZY4O6cmpGPVXkYuGbXP2PS29/D99ypgDLCtBhOaYMStmElYPqJcF73zswjzi7TJLVShjZm62Qpq8GePl8tFm1TiijgEXSaXT4dGYuDJdZVJpEpCKSaaiqhBiKPIkOEzA36dWmpoXmA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XB82Dpt_1789646702;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XB82Dpt_1789646702 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Sep 2026 20:05:03 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v4 4/5] RDMA/erdma: Unify userspace and kernel queue buffer management
Date: Thu, 17 Sep 2026 20:04:58 +0800
Message-ID: <20260917120459.13286-5-chengyou@linux.alibaba.com>
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

Userspace and kernel space queue buffers use separate helpers despite
sharing MTT metadata and lifetime rules. Manage both through
erdma_mem_init() and erdma_mem_uninit(), while keeping backing allocation
and release type-specific.

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 268 +++++++++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.h |  22 +-
 2 files changed, 175 insertions(+), 115 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 345b75377681..1ff31c4587bd 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -19,9 +19,9 @@
 #include "erdma_cm.h"
 #include "erdma_verbs.h"
 
-static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
-			    size_t size);
-static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem);
+static int erdma_mem_init(struct erdma_dev *dev, struct erdma_mem *mem,
+			  struct erdma_mem_init_attr *attr);
+static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem);
 
 static void assemble_qbuf_mtt_for_cmd(struct erdma_mem *mem, u32 *cfg,
 				      u64 *addr0, u64 *addr1)
@@ -480,10 +480,10 @@ static void free_kernel_qp(struct erdma_qp *qp)
 	vfree(qp->kern_qp.swr_tbl);
 	vfree(qp->kern_qp.rwr_tbl);
 
-	put_mtt_entries(dev, &qp->kern_qp.sq_mem);
+	erdma_mem_uninit(dev, &qp->kern_qp.sq_mem);
 	dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
 		      qp->kern_qp.sq_dbrec_dma);
-	put_mtt_entries(dev, &qp->kern_qp.rq_mem);
+	erdma_mem_uninit(dev, &qp->kern_qp.rq_mem);
 	dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
 		      qp->kern_qp.rq_dbrec_dma);
 }
@@ -491,6 +491,9 @@ static void free_kernel_qp(struct erdma_qp *qp)
 static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 			  struct ib_qp_init_attr *attrs)
 {
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_KMEM,
+	};
 	struct erdma_kqp *kqp = &qp->kern_qp;
 	int ret = -ENOMEM;
 	int size;
@@ -515,7 +518,8 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 		goto err_free_swr_tbl;
 
 	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	ret = erdma_alloc_kmem(dev, &kqp->sq_mem, size);
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->sq_mem, &attr);
 	if (ret)
 		goto err_free_rwr_tbl;
 
@@ -527,7 +531,8 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 	}
 
 	size = qp->attrs.rq_size << RQE_SHIFT;
-	ret = erdma_alloc_kmem(dev, &kqp->rq_mem, size);
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->rq_mem, &attr);
 	if (ret)
 		goto err_free_sq_dbrec;
 
@@ -541,11 +546,11 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 	return 0;
 
 err_free_rq_mem:
-	put_mtt_entries(dev, &kqp->rq_mem);
+	erdma_mem_uninit(dev, &kqp->rq_mem);
 err_free_sq_dbrec:
 	dma_pool_free(dev->db_pool, kqp->sq_dbrec, kqp->sq_dbrec_dma);
 err_free_sq_mem:
-	put_mtt_entries(dev, &kqp->sq_mem);
+	erdma_mem_uninit(dev, &kqp->sq_mem);
 err_free_rwr_tbl:
 	vfree(kqp->rwr_tbl);
 err_free_swr_tbl:
@@ -554,17 +559,28 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 	return ret;
 }
 
-static void erdma_fill_bottom_mtt(struct erdma_dev *dev, struct erdma_mem *mem)
+static void erdma_init_mtt_leaf(struct erdma_mem *mem, struct erdma_mtt *mtt)
 {
-	struct erdma_mtt *mtt = mem->mtt;
 	struct ib_block_iter biter;
 	u32 idx = 0;
 
+	if (mem->type == ERDMA_UMEM) {
+		rdma_umem_for_each_dma_block(mem->umem, &biter, mem->page_size)
+			mtt->buf[idx++] = rdma_block_iter_dma_address(&biter);
+	} else {
+		for (; idx < mem->page_cnt; idx++)
+			mtt->buf[idx] = mem->kmem.buf_list[idx].dma_addr;
+	}
+}
+
+static void erdma_init_bottom_mtt(struct erdma_mem *mem)
+{
+	struct erdma_mtt *mtt = mem->mtt;
+
 	while (mtt->low_level)
 		mtt = mtt->low_level;
 
-	rdma_umem_for_each_dma_block(mem->umem, &biter, mem->page_size)
-		mtt->buf[idx++] = rdma_block_iter_dma_address(&biter);
+	erdma_init_mtt_leaf(mem, mtt);
 }
 
 static struct erdma_mtt *erdma_create_cont_mtt(struct erdma_dev *dev,
@@ -796,7 +812,7 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
 	}
 }
 
-static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
+static void erdma_kmem_free(struct erdma_dev *dev, struct erdma_mem *mem)
 {
 	struct erdma_buf_list *buf_list = mem->kmem.buf_list;
 	u32 i;
@@ -808,26 +824,17 @@ static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
 	kfree(buf_list);
 }
 
-static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
-			    size_t size)
+static int erdma_kmem_alloc(struct erdma_dev *dev, struct erdma_mem *mem,
+			    u32 page_cnt)
 {
 	struct erdma_buf_list *buf_list;
-	struct erdma_mtt *mtt;
-	int ret = -ENOMEM;
 	u32 i;
 
-	mem->type = ERDMA_KMEM;
-	mem->page_size = PAGE_SIZE;
-	mem->page_offset = 0;
-	mem->page_cnt = DIV_ROUND_UP(size, PAGE_SIZE);
-	mem->mtt_nents = mem->page_cnt;
-	mem->len = size;
-
-	buf_list = kcalloc(mem->page_cnt, sizeof(*buf_list), GFP_KERNEL);
+	buf_list = kcalloc(page_cnt, sizeof(*buf_list), GFP_KERNEL);
 	if (!buf_list)
 		return -ENOMEM;
 
-	for (i = 0; i < mem->page_cnt; i++) {
+	for (i = 0; i < page_cnt; i++) {
 		buf_list[i].buf = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
 						     &buf_list[i].dma_addr,
 						     GFP_KERNEL);
@@ -835,19 +842,7 @@ static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
 			goto err_free_pages;
 	}
 
-	mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt), true);
-	if (IS_ERR(mtt)) {
-		ret = PTR_ERR(mtt);
-		goto err_free_pages;
-	}
-
-	for (i = 0; i < mem->page_cnt; i++)
-		mtt->buf[i] = buf_list[i].dma_addr;
-	dma_sync_single_for_device(&dev->pdev->dev, mtt->buf_dma, mtt->size,
-				   DMA_TO_DEVICE);
 	mem->kmem.buf_list = buf_list;
-	mem->mtt = mtt;
-
 	return 0;
 
 err_free_pages:
@@ -856,58 +851,85 @@ static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
 				  buf_list[i].dma_addr);
 	kfree(buf_list);
 
-	return ret;
+	return -ENOMEM;
 }
 
-static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
-			   u64 start, u64 len, int access, u64 virt,
-			   unsigned long req_page_size, bool force_continuous)
+static void erdma_mem_free(struct erdma_dev *dev, struct erdma_mem *mem)
 {
-	int ret = 0;
+	switch (mem->type) {
+	case ERDMA_UMEM:
+		ib_umem_release(mem->umem);
+		break;
+	case ERDMA_KMEM:
+		erdma_kmem_free(dev, mem);
+		break;
+	default:
+		break;
+	}
+}
 
-	mem->type = ERDMA_UMEM;
-	mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
-	if (IS_ERR(mem->umem)) {
-		ret = PTR_ERR(mem->umem);
-		mem->umem = NULL;
-		return ret;
+static int erdma_mem_init(struct erdma_dev *dev, struct erdma_mem *mem,
+			  struct erdma_mem_init_attr *attr)
+{
+	struct erdma_mtt *mtt;
+	int ret;
+
+	mem->type = attr->type;
+
+	switch (mem->type) {
+	case ERDMA_UMEM:
+		mem->umem = ib_umem_get_va(&dev->ibdev, attr->start, attr->len,
+					   attr->access);
+		if (IS_ERR(mem->umem)) {
+			ret = PTR_ERR(mem->umem);
+			return ret;
+		}
+
+		mem->page_size = ib_umem_find_best_pgsz(
+			mem->umem, attr->req_page_size, attr->virt);
+		mem->mtt_nents =
+			ib_umem_num_dma_blocks(mem->umem, mem->page_size);
+		break;
+	case ERDMA_KMEM:
+		mem->page_size = PAGE_SIZE;
+		mem->mtt_nents = DIV_ROUND_UP(attr->len, PAGE_SIZE);
+		ret = erdma_kmem_alloc(dev, mem, mem->mtt_nents);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	mem->va = virt;
-	mem->len = len;
-	mem->page_size = ib_umem_find_best_pgsz(mem->umem, req_page_size, virt);
-	mem->page_offset = start & (mem->page_size - 1);
-	mem->mtt_nents = ib_umem_num_dma_blocks(mem->umem, mem->page_size);
+	mem->va = attr->virt;
+	mem->len = attr->len;
+	mem->page_offset = attr->start & (mem->page_size - 1);
 	mem->page_cnt = mem->mtt_nents;
-	mem->mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt),
-				    force_continuous);
-	if (IS_ERR(mem->mtt)) {
-		ret = PTR_ERR(mem->mtt);
-		goto error_ret;
+	mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt),
+			       !(attr->flags & ERDMA_MEM_FLAG_MR_BUF));
+	if (IS_ERR(mtt)) {
+		ret = PTR_ERR(mtt);
+		goto err_free_mem;
 	}
+	mem->mtt = mtt;
 
-	erdma_fill_bottom_mtt(dev, mem);
+	erdma_init_bottom_mtt(mem);
+	if (mtt->continuous)
+		dma_sync_single_for_device(&dev->pdev->dev, mtt->buf_dma,
+					   mtt->size, DMA_TO_DEVICE);
 
 	return 0;
 
-error_ret:
-	if (mem->umem) {
-		ib_umem_release(mem->umem);
-		mem->umem = NULL;
-	}
+err_free_mem:
+	erdma_mem_free(dev, mem);
 
 	return ret;
 }
 
-static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem)
+static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem)
 {
-	if (mem->mtt)
-		erdma_destroy_mtt(dev, mem->mtt);
-
-	if (mem->type == ERDMA_KMEM)
-		erdma_free_kmem(dev, mem);
-	else if (mem->umem)
-		ib_umem_release(mem->umem);
+	erdma_destroy_mtt(dev, mem->mtt);
+	erdma_mem_free(dev, mem);
 }
 
 static int erdma_map_user_dbrecords(struct erdma_ucontext *ctx,
@@ -975,6 +997,9 @@ erdma_unmap_user_dbrecords(struct erdma_ucontext *ctx,
 static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 			u64 va, u32 len, u64 dbrec_va)
 {
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_UMEM,
+	};
 	dma_addr_t dbrec_dma;
 	u32 rq_offset;
 	int ret;
@@ -983,45 +1008,47 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 		   qp->attrs.rq_size * RQE_SIZE))
 		return -EINVAL;
 
-	ret = get_mtt_entries(qp->dev, &qp->user_qp.sq_mem, va,
-			      qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
-			      (SZ_1M - SZ_4K), true);
+	attr.start = va;
+	attr.virt = va;
+	attr.len = qp->attrs.sq_size << SQEBB_SHIFT;
+	attr.req_page_size = SZ_1M - SZ_4K;
+	ret = erdma_mem_init(qp->dev, &qp->user_qp.sq_mem, &attr);
 	if (ret)
 		return ret;
 
 	rq_offset = ALIGN(qp->attrs.sq_size << SQEBB_SHIFT, ERDMA_HW_PAGE_SIZE);
 	qp->user_qp.rq_offset = rq_offset;
 
-	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
-			      qp->attrs.rq_size << RQE_SHIFT, 0, va + rq_offset,
-			      (SZ_1M - SZ_4K), true);
+	attr.start = va + rq_offset;
+	attr.virt = va + rq_offset;
+	attr.len = qp->attrs.rq_size << RQE_SHIFT;
+	ret = erdma_mem_init(qp->dev, &qp->user_qp.rq_mem, &attr);
 	if (ret)
-		goto put_sq_mtt;
+		goto uninit_sq_mem;
 
 	ret = erdma_map_user_dbrecords(uctx, dbrec_va,
-				       &qp->user_qp.user_dbr_page,
-				       &dbrec_dma);
+				       &qp->user_qp.user_dbr_page, &dbrec_dma);
 	if (ret)
-		goto put_rq_mtt;
+		goto uninit_rq_mem;
 
 	qp->user_qp.sq_dbrec_dma = dbrec_dma;
 	qp->user_qp.rq_dbrec_dma = dbrec_dma + ERDMA_DB_SIZE;
 
 	return 0;
 
-put_rq_mtt:
-	put_mtt_entries(qp->dev, &qp->user_qp.rq_mem);
+uninit_rq_mem:
+	erdma_mem_uninit(qp->dev, &qp->user_qp.rq_mem);
 
-put_sq_mtt:
-	put_mtt_entries(qp->dev, &qp->user_qp.sq_mem);
+uninit_sq_mem:
+	erdma_mem_uninit(qp->dev, &qp->user_qp.sq_mem);
 
 	return ret;
 }
 
 static void free_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx)
 {
-	put_mtt_entries(qp->dev, &qp->user_qp.sq_mem);
-	put_mtt_entries(qp->dev, &qp->user_qp.rq_mem);
+	erdma_mem_uninit(qp->dev, &qp->user_qp.sq_mem);
+	erdma_mem_uninit(qp->dev, &qp->user_qp.rq_mem);
 	erdma_unmap_user_dbrecords(uctx, &qp->user_qp.user_dbr_page);
 }
 
@@ -1268,8 +1295,11 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 				u64 virt, int access, struct ib_dmah *dmah,
 				struct ib_udata *udata)
 {
-	struct erdma_mr *mr = NULL;
 	struct erdma_dev *dev = to_edev(ibpd->device);
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_UMEM,
+	};
+	struct erdma_mr *mr = NULL;
 	u32 stag;
 	int ret;
 
@@ -1283,8 +1313,13 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	ret = get_mtt_entries(dev, &mr->mem, start, len, access, virt,
-			      SZ_2G - SZ_4K, false);
+	attr.start = start;
+	attr.virt = virt;
+	attr.len = len;
+	attr.req_page_size = SZ_2G - SZ_4K;
+	attr.access = access;
+	attr.flags = ERDMA_MEM_FLAG_MR_BUF;
+	ret = erdma_mem_init(dev, &mr->mem, &attr);
 	if (ret)
 		goto err_out_free;
 
@@ -1294,8 +1329,6 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 
 	mr->ibmr.lkey = mr->ibmr.rkey = stag;
 	mr->ibmr.pd = ibpd;
-	mr->mem.va = virt;
-	mr->mem.len = len;
 	mr->access = ERDMA_MR_ACC_LR | to_erdma_access_flags(access);
 	mr->valid = 1;
 	mr->type = ERDMA_MR_TYPE_NORMAL;
@@ -1311,7 +1344,7 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 		       mr->ibmr.lkey >> 8);
 
 err_out_put_mtt:
-	put_mtt_entries(dev, &mr->mem);
+	erdma_mem_uninit(dev, &mr->mem);
 
 err_out_free:
 	kfree(mr);
@@ -1348,7 +1381,8 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX], ibmr->lkey >> 8);
 
-	put_mtt_entries(dev, &mr->mem);
+	if (mr->type != ERDMA_MR_TYPE_DMA)
+		erdma_mem_uninit(dev, &mr->mem);
 
 	kfree(mr);
 	return 0;
@@ -1383,12 +1417,12 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	wait_for_completion(&cq->free);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
-		put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->kern_cq.qbuf_mem);
 		dma_pool_free(dev->db_pool, cq->kern_cq.dbrec,
 			      cq->kern_cq.dbrec_dma);
 	} else {
 		erdma_unmap_user_dbrecords(ctx, &cq->user_cq.user_dbr_page);
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 	}
 
 	return 0;
@@ -1440,8 +1474,8 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	if (rdma_is_kernel_res(&qp->ibqp.res)) {
 		free_kernel_qp(qp);
 	} else {
-		put_mtt_entries(dev, &qp->user_qp.sq_mem);
-		put_mtt_entries(dev, &qp->user_qp.rq_mem);
+		erdma_mem_uninit(dev, &qp->user_qp.sq_mem);
+		erdma_mem_uninit(dev, &qp->user_qp.rq_mem);
 		erdma_unmap_user_dbrecords(ctx, &qp->user_qp.user_dbr_page);
 	}
 
@@ -1959,12 +1993,17 @@ int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 			      struct erdma_ureq_create_cq *ureq)
 {
-	int ret;
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_UMEM,
+	};
+	int ret;
 
-	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
-			      ureq->qbuf_len, 0, ureq->qbuf_va, SZ_64M - SZ_4K,
-			      true);
+	attr.start = ureq->qbuf_va;
+	attr.virt = ureq->qbuf_va;
+	attr.len = ureq->qbuf_len;
+	attr.req_page_size = SZ_64M - SZ_4K;
+	ret = erdma_mem_init(dev, &cq->user_cq.qbuf_mem, &attr);
 	if (ret)
 		return ret;
 
@@ -1972,7 +2011,7 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 				       &cq->user_cq.user_dbr_page,
 				       &cq->user_cq.dbrec_dma);
 	if (ret)
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 
 	return ret;
 }
@@ -1980,10 +2019,15 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 static int erdma_init_kernel_cq(struct erdma_cq *cq)
 {
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_KMEM,
+		.len = cq->depth << CQE_SHIFT,
+	};
+	int ret;
 
-	if (erdma_alloc_kmem(dev, &cq->kern_cq.qbuf_mem,
-			     cq->depth << CQE_SHIFT))
-		return -ENOMEM;
+	ret = erdma_mem_init(dev, &cq->kern_cq.qbuf_mem, &attr);
+	if (ret)
+		return ret;
 
 	cq->kern_cq.dbrec = dma_pool_zalloc(dev->db_pool, GFP_KERNEL,
 					    &cq->kern_cq.dbrec_dma);
@@ -1997,7 +2041,7 @@ static int erdma_init_kernel_cq(struct erdma_cq *cq)
 	return 0;
 
 err_out:
-	put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
+	erdma_mem_uninit(dev, &cq->kern_cq.qbuf_mem);
 
 	return -ENOMEM;
 }
@@ -2062,9 +2106,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 err_free_res:
 	if (!rdma_is_kernel_res(&ibcq->res)) {
 		erdma_unmap_user_dbrecords(ctx, &cq->user_cq.user_dbr_page);
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 	} else {
-		put_mtt_entries(dev, &cq->kern_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->kern_cq.qbuf_mem);
 		dma_pool_free(dev->db_pool, cq->kern_cq.dbrec,
 			      cq->kern_cq.dbrec_dma);
 	}
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 28e898f1b6f5..02bf3723680d 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -112,8 +112,9 @@ struct erdma_mtt {
 };
 
 enum erdma_mem_type {
-	ERDMA_UMEM = 0,
-	ERDMA_KMEM = 1,
+	ERDMA_NO_MEM = 0,
+	ERDMA_UMEM = 1,
+	ERDMA_KMEM = 2,
 };
 
 struct erdma_buf_list {
@@ -125,19 +126,34 @@ struct erdma_kmem {
 	struct erdma_buf_list *buf_list;
 };
 
+enum erdma_mem_flags {
+	ERDMA_MEM_FLAG_MR_BUF = (1 << 0),
+};
+
+struct erdma_mem_init_attr {
+	enum erdma_mem_type type;
+	u64 start;
+	u64 virt;
+	u64 len;
+	unsigned long req_page_size;
+	int access;
+	u32 flags;
+};
+
 struct erdma_mem {
 	enum erdma_mem_type type;
 	union {
 		struct ib_umem *umem;
 		struct erdma_kmem kmem;
 	};
-	struct erdma_mtt *mtt;
 
 	u32 page_size;
 	u32 page_offset;
 	u32 page_cnt;
 	u32 mtt_nents;
 
+	struct erdma_mtt *mtt;
+
 	u64 va;
 	u64 len;
 };
-- 
2.31.1

