Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1F1407590
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 12:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660209; cv=none; b=aY8LtScFXNOdTQpik03MYznNw+ZrckkxV6x/AIAwEda73sTjke6/L0D/KO4kjl6EOh70G+2Z2BwnmwpK0YaClIFeTsl8q5ULq6ErTGcFHg5ALHfzM3ggtRrcmg8IXu5Nzw3NvlVUaO+CZV7WQwbZevDEgFSVQbwG6CjsJRdrEiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660209; c=relaxed/simple;
	bh=miUKeJmO8ZZme7qG+llRQKjjxy3Epn0qp0Bf6tygHlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B2+h5DmTvtcypttBoaIQPtQp99nm0asVL5G0bBkT4h/Xo1uGs/S8qGjgwiOC22lqkxPBclhwq+XKS5xHpBn+aoO0BdwBScOq0pCjzeA77O9l57n/UUtKr14/u+XXP5FtCTwzbTuqm7FNGP2dpVdODFMOsvfdMHCr0RijyNQNDC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xJtWhXWr; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xJtWhXWr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787660199; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=i4NVc1id5T6FBaQyDLz+Xxu6ep5lDpa7pmH8vnnHvmQ=;
	b=xJtWhXWrbLu0iNLwzsj1E5y/PYIX7fVaSxPFdK9JfJqFsJNRFVMIIZZDYAgY3AXAu4PZE675FCMwOwWjgDd3eipm1yj8DcFtfiGSdrd0UdQqvj9HzPE1FrsxhYyMwkR/572iGSTSfIbPcYWKO5F0Ss+BMbPVd4iFpRwZoca5Q4k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9dxV5t_1787660198;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9dxV5t_1787660198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 20:16:38 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-rc] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Tue, 25 Aug 2026 20:16:36 +0800
Message-ID: <20260825121638.75509-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Locked QP and CQ lookups from EQ interrupts can deadlock with
create-path XArray updates. If an interrupt arrives while the create
path holds the plain xa_lock, the lookup spins forever trying to
acquire the same lock.

Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
including the GSI QP store and error paths.

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 65b1af1e6623..f18b88bba281 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1021,15 +1021,15 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	init_completion(&qp->safe_free);
 
 	if (qp->ibqp.qp_type == IB_QPT_GSI) {
-		old_entry = xa_store(&dev->qp_xa, 1, qp, GFP_KERNEL);
+		old_entry = xa_store_irq(&dev->qp_xa, 1, qp, GFP_KERNEL);
 		if (xa_is_err(old_entry))
 			ret = xa_err(old_entry);
 		else
 			qp->ibqp.qp_num = 1;
 	} else {
-		ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
-				      XA_LIMIT(1, dev->attrs.max_qp - 1),
-				      &dev->next_alloc_qpn, GFP_KERNEL);
+		ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
+					  XA_LIMIT(1, dev->attrs.max_qp - 1),
+					  &dev->next_alloc_qpn, GFP_KERNEL);
 	}
 
 	if (ret < 0) {
@@ -1089,7 +1089,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	else
 		free_kernel_qp(qp);
 err_out_xa:
-	xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
 err_out:
 	return ret;
 }
@@ -1993,9 +1993,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 
-	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
-			      XA_LIMIT(1, dev->attrs.max_cq - 1),
-			      &dev->next_alloc_cqn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
+				  XA_LIMIT(1, dev->attrs.max_cq - 1),
+				  &dev->next_alloc_cqn, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -2041,7 +2041,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 err_out_xa:
-	xa_erase(&dev->cq_xa, cq->cqn);
+	xa_erase_irq(&dev->cq_xa, cq->cqn);
 
 	return ret;
 }
-- 
2.31.1

