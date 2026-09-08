Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904EC34EF11
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 03:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838674; cv=none; b=jP9lZ2PfJr6p86Q/Pubt6KGQss4+5pehvNXmxyHPofMVS1ABD2KV3KnricPZ7f0MrhB9vVCZ18yBEPFoLVgDHlP+8zv7SbL+UNvCYUrw+bTLElrOQvALbH7tjmGeZCwKWwL1aPN1JAoHTSIxG7SDeCoCWO0ik6hltkmradENvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838674; c=relaxed/simple;
	bh=mQqBIMZGopLw0HcoTW5gYkroXlJiqyVbokFPj28dQmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb8r6YNdv4sJBePDYnOe3RqMxBECVKdPCuL+EENKKm9b8IUYv/XeHNjl2AsOr2c8jJ3tBwXUU6qkx/Z2AJdjQB7uG83ZRHuBAG3Wl98HEpV04CFr4aqHTT4rQU5lBQrwgrqTH7JLnl1mvxpXoMJxiNQ5ib4clDLRMRmLmdvQsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wHc2Cnwm; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wHc2Cnwm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788838632; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=yo6k5udhX52F8NIaYiHHR7XB+0ASOgn45+KBHNs0wlE=;
	b=wHc2CnwmGFgDGOnSxg2m4YLK6N4RBoxhpgLcSoruomWyB4r9sHx6Xrx2ZnzoRnh0KeoIQu8CjKoYc/S61CTwiR+bryLWl22JS8TSa64tsae3dRTxeCLzJu/WoEqqjtinkO0fkcga2xdJkwjjSGySxAo9HyAxt3Wq0jIIQ+u+AVk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XAaH5-P_1788838631;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XAaH5-P_1788838631 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 11:37:11 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next v3 1/5] RDMA/erdma: Unwind kernel QP initialization failures
Date: Tue,  8 Sep 2026 11:37:05 +0800
Message-ID: <20260908033709.89898-2-chengyou@linux.alibaba.com>
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

Allocation failures currently use the normal kernel QP teardown path.

Unwind failures directly so free_kernel_qp() only handles complete QPs.

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 58 ++++++++++++-----------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 65b1af1e6623..57a35f8b32cf 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -512,25 +512,14 @@ static void free_kernel_qp(struct erdma_qp *qp)
 	vfree(qp->kern_qp.swr_tbl);
 	vfree(qp->kern_qp.rwr_tbl);
 
-	if (qp->kern_qp.sq_buf)
-		dma_free_coherent(&dev->pdev->dev,
-				  qp->attrs.sq_size << SQEBB_SHIFT,
-				  qp->kern_qp.sq_buf,
-				  qp->kern_qp.sq_buf_dma_addr);
-
-	if (qp->kern_qp.sq_dbrec)
-		dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
-			      qp->kern_qp.sq_dbrec_dma);
-
-	if (qp->kern_qp.rq_buf)
-		dma_free_coherent(&dev->pdev->dev,
-				  qp->attrs.rq_size << RQE_SHIFT,
-				  qp->kern_qp.rq_buf,
-				  qp->kern_qp.rq_buf_dma_addr);
-
-	if (qp->kern_qp.rq_dbrec)
-		dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
-			      qp->kern_qp.rq_dbrec_dma);
+	dma_free_coherent(&dev->pdev->dev, qp->attrs.sq_size << SQEBB_SHIFT,
+			  qp->kern_qp.sq_buf, qp->kern_qp.sq_buf_dma_addr);
+	dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
+		      qp->kern_qp.sq_dbrec_dma);
+	dma_free_coherent(&dev->pdev->dev, qp->attrs.rq_size << RQE_SHIFT,
+			  qp->kern_qp.rq_buf, qp->kern_qp.rq_buf_dma_addr);
+	dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
+		      qp->kern_qp.rq_dbrec_dma);
 }
 
 static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
@@ -551,36 +540,51 @@ static int init_kernel_qp(struct erdma_dev *dev, struct erdma_qp *qp,
 	kqp->hw_rq_db = dev->func_bar + ERDMA_BAR_RQDB_SPACE_OFFSET;
 
 	kqp->swr_tbl = vmalloc_array(qp->attrs.sq_size, sizeof(u64));
+	if (!kqp->swr_tbl)
+		return -ENOMEM;
+
 	kqp->rwr_tbl = vmalloc_array(qp->attrs.rq_size, sizeof(u64));
-	if (!kqp->swr_tbl || !kqp->rwr_tbl)
-		goto err_out;
+	if (!kqp->rwr_tbl)
+		goto err_free_swr_tbl;
 
 	size = qp->attrs.sq_size << SQEBB_SHIFT;
 	kqp->sq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
 					 &kqp->sq_buf_dma_addr, GFP_KERNEL);
 	if (!kqp->sq_buf)
-		goto err_out;
+		goto err_free_rwr_tbl;
 
 	kqp->sq_dbrec =
 		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
 	if (!kqp->sq_dbrec)
-		goto err_out;
+		goto err_free_sq_buf;
 
 	size = qp->attrs.rq_size << RQE_SHIFT;
 	kqp->rq_buf = dma_alloc_coherent(&dev->pdev->dev, size,
 					 &kqp->rq_buf_dma_addr, GFP_KERNEL);
 	if (!kqp->rq_buf)
-		goto err_out;
+		goto err_free_sq_dbrec;
 
 	kqp->rq_dbrec =
 		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
 	if (!kqp->rq_dbrec)
-		goto err_out;
+		goto err_free_rq_buf;
 
 	return 0;
 
-err_out:
-	free_kernel_qp(qp);
+err_free_rq_buf:
+	dma_free_coherent(&dev->pdev->dev, size, kqp->rq_buf,
+			  kqp->rq_buf_dma_addr);
+err_free_sq_dbrec:
+	dma_pool_free(dev->db_pool, kqp->sq_dbrec, kqp->sq_dbrec_dma);
+err_free_sq_buf:
+	size = qp->attrs.sq_size << SQEBB_SHIFT;
+	dma_free_coherent(&dev->pdev->dev, size, kqp->sq_buf,
+			  kqp->sq_buf_dma_addr);
+err_free_rwr_tbl:
+	vfree(kqp->rwr_tbl);
+err_free_swr_tbl:
+	vfree(kqp->swr_tbl);
+
 	return -ENOMEM;
 }
 
-- 
2.31.1

