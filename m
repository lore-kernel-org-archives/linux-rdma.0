Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC078364EB8
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 03:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838676; cv=none; b=E+2tEKjvWW7nv3gIEx3dOyFtO6emM0Xk4CP/bpnG9INq4blGPzvPEKQdClmtHNpOEbFm8hhu8gMCPyB1GECBi7VTckbkYrATY8rmEtxBXLbJQ08WPYCTzNzcg2skZQsUF5xiQ1cCMe2lqp/hhy5cCG6Q4bP016ZCP3E/DyZ2iBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838676; c=relaxed/simple;
	bh=DtEsxRxBnHTxxdoiVzB/VWLMpOFWgI1rlxYphkN6Qv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGA8spocv9KR6erusmYwRhcLxptKd4EawcfYOhjoKqdZAUQHeADhi+AFzldEgofQC5RCG8iypJUq9kmMnCaocIQ9nPSkm3Ri4F/yhgM6A1kO0xmxUJXbkndNoUCtnyRXGeffrCMfseBccU92s2zsUMhS7g5LHi50zpDr3gBvanI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RPtDDr/p; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RPtDDr/p"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788838635; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JHyrzXPNdoT9A5/qB0txoLApoxkbwf4tGnqGgWxhcYQ=;
	b=RPtDDr/pH656TgPAKXBh0zXxyKUL20zqpgSo7aUImFRZfO74Brfi2U5SQ42cO4vGJG5qwB+6idjkAJ+bO0CXmM6sk0SaTBk1VxAAp7xBhaVOfx2SesUCg75RpvUiVqhllOIkonFnp+Ol5QAU2a+rRTmwWc20ikZcqNNiYXnLYo4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAaCyRg_1788838634;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAaCyRg_1788838634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 11:37:15 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v3 5/5] RDMA/erdma: Move kernel QP helpers after memory helpers
Date: Tue,  8 Sep 2026 11:37:09 +0800
Message-ID: <20260908033709.89898-6-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260908033709.89898-1-chengyou@linux.alibaba.com>
References: <20260908033709.89898-1-chengyou@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the kernel QP helpers after the shared memory helpers to remove
forward declarations.

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 168 +++++++++++-----------
 1 file changed, 82 insertions(+), 86 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 968137c8d478..dddbab81f411 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -19,10 +19,6 @@
 #include "erdma_cm.h"
 #include "erdma_verbs.h"
 
-static int erdma_mem_init(struct erdma_dev *dev, struct erdma_mem *mem,
-			  struct erdma_mem_init_attr *attr);
-static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem);
-
 static void assemble_qbuf_mtt_for_cmd(struct erdma_mem *mem, u32 *cfg,
 				      u64 *addr0, u64 *addr1)
 {
@@ -473,88 +469,6 @@ static int erdma_qp_validate_attr(struct erdma_dev *dev,
 	return 0;
 }
 
-static void free_kernel_qp(struct erdma_qp *qp)
-{
-	struct erdma_dev *dev = qp->dev;
-
-	vfree(qp->kern_qp.swr_tbl);
-	vfree(qp->kern_qp.rwr_tbl);
-
-	erdma_mem_uninit(dev, &qp->kern_qp.sq_mem);
-	dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
-		      qp->kern_qp.sq_dbrec_dma);
-	erdma_mem_uninit(dev, &qp->kern_qp.rq_mem);
-	dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
-		      qp->kern_qp.rq_dbrec_dma);
-}
-
-static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
-			  struct ib_qp_init_attr *attrs)
-{
-	struct erdma_mem_init_attr attr = {
-		.type = ERDMA_KMEM,
-	};
-	struct erdma_kqp *kqp = &qp->kern_qp;
-	int size;
-	int ret = -ENOMEM;
-
-	if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
-		kqp->sig_all = 1;
-
-	kqp->sq_pi = 0;
-	kqp->sq_ci = 0;
-	kqp->rq_pi = 0;
-	kqp->rq_ci = 0;
-	kqp->hw_sq_db =
-		dev->func_bar + (ERDMA_SDB_SHARED_PAGE_INDEX << PAGE_SHIFT);
-	kqp->hw_rq_db = dev->func_bar + ERDMA_BAR_RQDB_SPACE_OFFSET;
-
-	kqp->swr_tbl = vmalloc_array(qp->attrs.sq_size, sizeof(u64));
-	if (!kqp->swr_tbl)
-		return -ENOMEM;
-
-	kqp->rwr_tbl = vmalloc_array(qp->attrs.rq_size, sizeof(u64));
-	if (!kqp->rwr_tbl)
-		goto err_free_swr_tbl;
-
-	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	attr.len = size;
-	ret = erdma_mem_init(dev, &kqp->sq_mem, &attr);
-	if (ret)
-		goto err_free_rwr_tbl;
-
-	kqp->sq_dbrec =
-		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
-	if (!kqp->sq_dbrec)
-		goto err_free_sq_mem;
-
-	size = qp->attrs.rq_size << RQE_SHIFT;
-	attr.len = size;
-	ret = erdma_mem_init(dev, &kqp->rq_mem, &attr);
-	if (ret)
-		goto err_free_sq_dbrec;
-
-	kqp->rq_dbrec =
-		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
-	if (!kqp->rq_dbrec)
-		goto err_free_rq_mem;
-
-	return 0;
-
-err_free_rq_mem:
-	erdma_mem_uninit(dev, &kqp->rq_mem);
-err_free_sq_dbrec:
-	dma_pool_free(dev->db_pool, kqp->sq_dbrec, kqp->sq_dbrec_dma);
-err_free_sq_mem:
-	erdma_mem_uninit(dev, &kqp->sq_mem);
-err_free_rwr_tbl:
-	vfree(kqp->rwr_tbl);
-err_free_swr_tbl:
-	vfree(kqp->swr_tbl);
-
-	return ret;
-}
-
 static void erdma_init_mtt_leaf(struct erdma_mem *mem, struct erdma_mtt *mtt)
 {
 	struct ib_block_iter biter;
@@ -933,6 +847,88 @@ static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem)
 	erdma_mem_free(dev, mem);
 }
 
+static void free_kernel_qp(struct erdma_qp *qp)
+{
+	struct erdma_dev *dev = qp->dev;
+
+	vfree(qp->kern_qp.swr_tbl);
+	vfree(qp->kern_qp.rwr_tbl);
+
+	erdma_mem_uninit(dev, &qp->kern_qp.sq_mem);
+	dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
+		      qp->kern_qp.sq_dbrec_dma);
+	erdma_mem_uninit(dev, &qp->kern_qp.rq_mem);
+	dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
+		      qp->kern_qp.rq_dbrec_dma);
+}
+
+static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
+			  struct ib_qp_init_attr *attrs)
+{
+	struct erdma_mem_init_attr attr = {
+		.type = ERDMA_KMEM,
+	};
+	struct erdma_kqp *kqp = &qp->kern_qp;
+	int size;
+	int ret = -ENOMEM;
+
+	if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
+		kqp->sig_all = 1;
+
+	kqp->sq_pi = 0;
+	kqp->sq_ci = 0;
+	kqp->rq_pi = 0;
+	kqp->rq_ci = 0;
+	kqp->hw_sq_db =
+		dev->func_bar + (ERDMA_SDB_SHARED_PAGE_INDEX << PAGE_SHIFT);
+	kqp->hw_rq_db = dev->func_bar + ERDMA_BAR_RQDB_SPACE_OFFSET;
+
+	kqp->swr_tbl = vmalloc_array(qp->attrs.sq_size, sizeof(u64));
+	if (!kqp->swr_tbl)
+		return -ENOMEM;
+
+	kqp->rwr_tbl = vmalloc_array(qp->attrs.rq_size, sizeof(u64));
+	if (!kqp->rwr_tbl)
+		goto err_free_swr_tbl;
+
+	size = qp->attrs.sq_size << SQEBB_SHIFT;
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->sq_mem, &attr);
+	if (ret)
+		goto err_free_rwr_tbl;
+
+	kqp->sq_dbrec =
+		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
+	if (!kqp->sq_dbrec)
+		goto err_free_sq_mem;
+
+	size = qp->attrs.rq_size << RQE_SHIFT;
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->rq_mem, &attr);
+	if (ret)
+		goto err_free_sq_dbrec;
+
+	kqp->rq_dbrec =
+		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
+	if (!kqp->rq_dbrec)
+		goto err_free_rq_mem;
+
+	return 0;
+
+err_free_rq_mem:
+	erdma_mem_uninit(dev, &kqp->rq_mem);
+err_free_sq_dbrec:
+	dma_pool_free(dev->db_pool, kqp->sq_dbrec, kqp->sq_dbrec_dma);
+err_free_sq_mem:
+	erdma_mem_uninit(dev, &kqp->sq_mem);
+err_free_rwr_tbl:
+	vfree(kqp->rwr_tbl);
+err_free_swr_tbl:
+	vfree(kqp->swr_tbl);
+
+	return ret;
+}
+
 static int erdma_map_user_dbrecords(struct erdma_ucontext *ctx,
 				    u64 dbrecords_va,
 				    struct erdma_user_dbrecords_page **dbr_page,
-- 
2.31.1

