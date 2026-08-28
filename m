Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C7A286AC
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 03:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787886232; cv=none; b=LBIM8APFZMLzBdEKxwzN7Z63ypvs2M59pPT/U6I94YWjlh67v3gG4B/Rj8MXrdTxkeRPw6Nd/iiJThJYFx8vSz8zDcyl/640K9gpDDi7PjlXBWHR56y2XlqgPJUOjWaIk0MFnjgjgXeCSo1BEfvVFEyA14wg2+/OuQYgrUwAB3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787886232; c=relaxed/simple;
	bh=hsd2sI4FspglJm60BACtddMxGwytuCfNqsfLZrBXGSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=atn3kPZzsWuXwRhTQnjHOIFmO8oDo2Lr3K3185TKtQGM4T3axCBnqAYkRyMas0o+PmwnGcacfKvod6LjiJSszsRrzlYY5BglmL2G5zXinqdEo4mkvll+K165VAdvn6xajRDO6Yt4UROLRGW1b5Dic0sad5jaGwLB1Yb+/1GZVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WUupyh8X; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WUupyh8X"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787886226; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BHgiApYA9N0fXvVJQ4y8CKsS82SqB8icNGFQL2xHnu0=;
	b=WUupyh8XXlLexzvUx+JN1nWcrXJh33YfjjTne4ZPCeSxm2x6iye6yRVOuC4IOcBh0Mm22+ikeAVYC9cFvYAw7neyrU+vGnNbVr8mFdxq9ZVWB9J6DgXtG7cIcZckUOVenhg8mCAN+XZBZOy3pjpdF5wkSOKw4iF5el7VIq8p5og=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9l7HFj_1787886224;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9l7HFj_1787886224 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 11:03:45 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH for-rc v2] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Fri, 28 Aug 2026 11:03:44 +0800
Message-ID: <20260828030344.88021-1-chengyou@linux.alibaba.com>
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
including the GSI QP store and error paths. Initialize both arrays with
XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
Changes from v1:
- Add XA_FLAGS_LOCK_IRQ to the QP and CQ XArrays to fix an issue identified
  by the Sashiko automated review.

 drivers/infiniband/hw/erdma/erdma_main.c  |  4 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 7e87a815e853..445182c6bc5d 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -572,8 +572,8 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	INIT_LIST_HEAD(&dev->cep_list);
 
 	spin_lock_init(&dev->lock);
-	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
 	dev->next_alloc_cqn = 1;
 	dev->next_alloc_qpn = 1;
 
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
