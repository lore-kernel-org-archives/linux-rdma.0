Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5C63FBEAD
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106007; cv=none; b=t4FdrE3Aus5zVGumehVBECjlCTsMWkNXxE/i5iCnnjRMvHsGnNWpO0fOe4qXhdzA+95xjzLZ1PyZS3wuyJdIdTx1F1KslT+S3sctl9JxFdpqOj5cECAw/Kz1KeVJDTU9nx8xUJC9KPO3YQbodRhkVg5NSmo2nzTmix4WzVLSdyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106007; c=relaxed/simple;
	bh=Y3y45cuh+SV30skB6p11Z+XEjj62uMyfClEdnfrxr50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNdYoem9Zx1XWKHS2GlG5ZpX+BBB+NgNONzUAVgEdiSgPHrz/+LR3fpoo9/lfVkZxovaAnTo3E/nUuTIEW6JBrWfO5VNcEQx10smXRYuoh6uyHJW4KPJYmwYatBaf7C88U7FpEL13GP+RUNGrXOzvh/gQ12YWkCql4iq+8w+Q4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nNar19eB; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nNar19eB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779105999; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Uto7/PvFrP9ntEXLNFDX9pwJdoaJd5dMx4XNCPiw4YE=;
	b=nNar19eBR+WzCg+c+W5Ql8sDzEvaHt9jBXKJ1Amza3LUJFrmjDsWuWVFucA42DzqYAsT8Tnu+xuD586f1S6toTJQMY0TJFHTq7vvST+lmjGVib2rr5tfmr4zaCqTcLUf2TuUVdOtgnvGI2RnQ9A/rRCovql2fPu6glfTeEMbfTQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=boshiyu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X392coi_1779105998;
Received: from localhost(mailfrom:boshiyu@linux.alibaba.com fp:SMTPD_---0X392coi_1779105998 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 20:06:39 +0800
From: Boshi Yu <boshiyu@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com
Subject: [PATCH for-next v2 1/3] RDMA/erdma: Rename get/put_mtt_entries to erdma_mem_init/uninit
Date: Mon, 18 May 2026 20:06:26 +0800
Message-ID: <20260518120637.16831-2-boshiyu@linux.alibaba.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20260518120637.16831-1-boshiyu@linux.alibaba.com>
References: <20260518120637.16831-1-boshiyu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The get_mtt_entries() interface actually initializes the struct
erdma_mem. Rename the get_mtt_entries/put_mtt_entries to
erdma_mem_init/erdma_mem_uninit, respectively.

Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 60 +++++++++++------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index b59c2e3a5306..5ab66c9d8bdc 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -823,9 +823,9 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
 	}
 }
 
-static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
-			   u64 start, u64 len, int access, u64 virt,
-			   unsigned long req_page_size, bool force_continuous)
+static int erdma_mem_init(struct erdma_dev *dev, struct erdma_mem *mem,
+			  u64 start, u64 len, int access, u64 virt,
+			  unsigned long req_page_size, bool force_continuous)
 {
 	int ret = 0;
 
@@ -862,7 +862,7 @@ static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
 	return ret;
 }
 
-static void put_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem)
+static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem)
 {
 	if (mem->mtt)
 		erdma_destroy_mtt(dev, mem->mtt);
@@ -946,45 +946,45 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
 		   qp->attrs.rq_size * RQE_SIZE))
 		return -EINVAL;
 
-	ret = get_mtt_entries(qp->dev, &qp->user_qp.sq_mem, va,
-			      qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
-			      (SZ_1M - SZ_4K), true);
+	ret = erdma_mem_init(qp->dev, &qp->user_qp.sq_mem, va,
+			     qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
+			     (SZ_1M - SZ_4K), true);
 	if (ret)
 		return ret;
 
 	rq_offset = ALIGN(qp->attrs.sq_size << SQEBB_SHIFT, ERDMA_HW_PAGE_SIZE);
 	qp->user_qp.rq_offset = rq_offset;
 
-	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
+	ret = erdma_mem_init(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
 			      qp->attrs.rq_size << RQE_SHIFT, 0, va + rq_offset,
 			      (SZ_1M - SZ_4K), true);
 	if (ret)
-		goto put_sq_mtt;
+		goto uninit_sq_mem;
 
 	ret = erdma_map_user_dbrecords(uctx, dbrec_va,
 				       &qp->user_qp.user_dbr_page,
 				       &dbrec_dma);
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
 
@@ -1246,14 +1246,14 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	ret = get_mtt_entries(dev, &mr->mem, start, len, access, virt,
-			      SZ_2G - SZ_4K, false);
+	ret = erdma_mem_init(dev, &mr->mem, start, len, access, virt,
+			     SZ_2G - SZ_4K, false);
 	if (ret)
 		goto err_out_free;
 
 	ret = erdma_create_stag(dev, &stag);
 	if (ret)
-		goto err_out_put_mtt;
+		goto err_uninit_mem;
 
 	mr->ibmr.lkey = mr->ibmr.rkey = stag;
 	mr->ibmr.pd = ibpd;
@@ -1273,8 +1273,8 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX],
 		       mr->ibmr.lkey >> 8);
 
-err_out_put_mtt:
-	put_mtt_entries(dev, &mr->mem);
+err_uninit_mem:
+	erdma_mem_uninit(dev, &mr->mem);
 
 err_out_free:
 	kfree(mr);
@@ -1304,7 +1304,7 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX], ibmr->lkey >> 8);
 
-	put_mtt_entries(dev, &mr->mem);
+	erdma_mem_uninit(dev, &mr->mem);
 
 	kfree(mr);
 	return 0;
@@ -1335,7 +1335,7 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 			      cq->kern_cq.dbrec_dma);
 	} else {
 		erdma_unmap_user_dbrecords(ctx, &cq->user_cq.user_dbr_page);
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 	}
 
 	xa_erase(&dev->cq_xa, cq->cqn);
@@ -1382,8 +1382,8 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	if (rdma_is_kernel_res(&qp->ibqp.res)) {
 		free_kernel_qp(qp);
 	} else {
-		put_mtt_entries(dev, &qp->user_qp.sq_mem);
-		put_mtt_entries(dev, &qp->user_qp.rq_mem);
+		erdma_mem_uninit(dev, &qp->user_qp.sq_mem);
+		erdma_mem_uninit(dev, &qp->user_qp.rq_mem);
 		erdma_unmap_user_dbrecords(ctx, &qp->user_qp.user_dbr_page);
 	}
 
@@ -1905,9 +1905,9 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 	int ret;
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
 
-	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
-			      ureq->qbuf_len, 0, ureq->qbuf_va, SZ_64M - SZ_4K,
-			      true);
+	ret = erdma_mem_init(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
+			     ureq->qbuf_len, 0, ureq->qbuf_va, SZ_64M - SZ_4K,
+			     true);
 	if (ret)
 		return ret;
 
@@ -1915,7 +1915,7 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 				       &cq->user_cq.user_dbr_page,
 				       &cq->user_cq.dbrec_dma);
 	if (ret)
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 
 	return ret;
 }
@@ -2006,7 +2006,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 err_free_res:
 	if (!rdma_is_kernel_res(&ibcq->res)) {
 		erdma_unmap_user_dbrecords(ctx, &cq->user_cq.user_dbr_page);
-		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
+		erdma_mem_uninit(dev, &cq->user_cq.qbuf_mem);
 	} else {
 		dma_free_coherent(&dev->pdev->dev, depth << CQE_SHIFT,
 				  cq->kern_cq.qbuf, cq->kern_cq.qbuf_dma_addr);
-- 
2.46.0

