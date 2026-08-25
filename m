Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE713B9D84
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661928; cv=none; b=orApfay72Nbf7qxD/9OxccsRTh5NpEUbAn70NOHQN1TBR9BG8j/K8kcrFF/EsMpiTRYJwdsLr/B2J/rFCiewDmp77WqVbtPBYeyeWFTRsJevu/8YWJbF1+hA4F03n3vK4rL0aayl1e7FzoITar47oYwG/27eyhedEczgeQ5/UnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661928; c=relaxed/simple;
	bh=RvBDYDIc8VKAUZtgqi2sVzhlrDdBRj8ch28/iFnboBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxFWBX8IeW9KsGSlK2F2rA2DaWay2XDlYgVzGgBTWOw1F4Y0TPhXdhUpVa97Q3tkNvJcW4C+7+1wTRgLeUknAdMJETbZCmlEVQDT9SN1PZxb0X0fS4RehadAlCUhBZDnay7+RCmUrVQ51f/FZuYQEWijs+TciSyfCCSVEFWHuJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TZCoh2DA; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TZCoh2DA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787661919; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=neaD84WXsJR6WfcqtzSKIv7q9nDHXowCFTaSfi3/0w0=;
	b=TZCoh2DAzy4UK9LJr6oky8DMJsI+OJR/fGvg4qKexWsVT+VBG0JL2Z57qMg4TjUPOLTcoxGan6N9HkVcQdhf8HAhG2fwKuOQZG9l98f7/BF19XTX1iEmOq8hDQI8Gw7qrReayJvjypxN1HSMzSUtbmYoG+bWfCnCTBoO9SEDXgs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9dy.Xf_1787661918;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9dy.Xf_1787661918 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 20:45:18 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-next 4/4] RDMA/erdma: Move kernel QP helpers after memory helpers
Date: Tue, 25 Aug 2026 20:45:10 +0800
Message-ID: <20260825124515.99370-5-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260825124515.99370-1-chengyou@linux.alibaba.com>
References: <20260825124515.99370-1-chengyou@linux.alibaba.com>
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
 drivers/infiniband/hw/erdma/erdma_verbs.c | 166 +++++++++++-----------
 1 file changed, 81 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index d03094244e78..5c6a53ee4573 100644
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
@@ -474,87 +470,6 @@ static int erdma_qp_validate_attr(struct erdma_dev *dev,
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
-
-	if (qp->kern_qp.sq_dbrec)
-		dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
-			      qp->kern_qp.sq_dbrec_dma);
-
-	erdma_mem_uninit(dev, &qp->kern_qp.rq_mem);
-
-	if (qp->kern_qp.rq_dbrec)
-		dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
-			      qp->kern_qp.rq_dbrec_dma);
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
-	int ret;
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
-	kqp->rwr_tbl = vmalloc_array(qp->attrs.rq_size, sizeof(u64));
-	if (!kqp->swr_tbl || !kqp->rwr_tbl) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
-
-	size = qp->attrs.sq_size << SQEBB_SHIFT;
-	attr.len = size;
-	ret = erdma_mem_init(dev, &kqp->sq_mem, &attr);
-	if (ret)
-		goto err_out;
-
-	kqp->sq_dbrec =
-		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
-	if (!kqp->sq_dbrec) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
-
-	size = qp->attrs.rq_size << RQE_SHIFT;
-	attr.len = size;
-	ret = erdma_mem_init(dev, &kqp->rq_mem, &attr);
-	if (ret)
-		goto err_out;
-
-	kqp->rq_dbrec =
-		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
-	if (!kqp->rq_dbrec) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
-
-	return 0;
-
-err_out:
-	free_kernel_qp(qp);
-	return ret;
-}
-
 static void erdma_init_mtt_leaf(struct erdma_mem *mem, struct erdma_mtt *mtt)
 {
 	struct ib_block_iter biter;
@@ -954,6 +869,87 @@ static void erdma_mem_uninit(struct erdma_dev *dev, struct erdma_mem *mem)
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
+
+	if (qp->kern_qp.sq_dbrec)
+		dma_pool_free(dev->db_pool, qp->kern_qp.sq_dbrec,
+			      qp->kern_qp.sq_dbrec_dma);
+
+	erdma_mem_uninit(dev, &qp->kern_qp.rq_mem);
+
+	if (qp->kern_qp.rq_dbrec)
+		dma_pool_free(dev->db_pool, qp->kern_qp.rq_dbrec,
+			      qp->kern_qp.rq_dbrec_dma);
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
+	int ret;
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
+	kqp->rwr_tbl = vmalloc_array(qp->attrs.rq_size, sizeof(u64));
+	if (!kqp->swr_tbl || !kqp->rwr_tbl) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	size = qp->attrs.sq_size << SQEBB_SHIFT;
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->sq_mem, &attr);
+	if (ret)
+		goto err_out;
+
+	kqp->sq_dbrec =
+		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->sq_dbrec_dma);
+	if (!kqp->sq_dbrec) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	size = qp->attrs.rq_size << RQE_SHIFT;
+	attr.len = size;
+	ret = erdma_mem_init(dev, &kqp->rq_mem, &attr);
+	if (ret)
+		goto err_out;
+
+	kqp->rq_dbrec =
+		dma_pool_zalloc(dev->db_pool, GFP_KERNEL, &kqp->rq_dbrec_dma);
+	if (!kqp->rq_dbrec) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	free_kernel_qp(qp);
+	return ret;
+}
+
 static int erdma_map_user_dbrecords(struct erdma_ucontext *ctx,
 				    u64 dbrecords_va,
 				    struct erdma_user_dbrecords_page **dbr_page,
-- 
2.31.1

