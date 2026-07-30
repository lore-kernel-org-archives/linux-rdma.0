Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB51338593
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 12:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415769; cv=none; b=Wh9Zvz2JBfLw1V5aWOJofAefcoPj9bfYHTIimDzaS2BC1q1kOOklIr99m6IYR/W5o+Q4o47TsenOJCkyWRXnHkaj6bgGBXlFzcOvM3LrmSBiZhNEuskAbyFYf4tNp3IcI2h3Xw4XfVrOJHPY8CrTU+oqQGfGbGQhCyeZ1URX72Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415769; c=relaxed/simple;
	bh=ldLAPzV2/we9mEQ0gVwgBLKKCP1xJ03Sl7jo3vt2eOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KeotN1KmQF8JNEEj/hQwwh3e44nFaTd2IcyqI0416dg4ENRt0VdMtlK2jix7g8aCanLo/5z1p4ve+VFf55kPk0MLhkNiwj1DmPTpXCrqolG3hYVMtNrK2oAkFXc4w+yIjHGGMUSq1h9QG2pN1NVgcX/NgOK7lJLv11dd+PYwgz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j4iKIHYR; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j4iKIHYR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785415757; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sorAn0GE/fcqfmP5OTs1k6nYnwdqsyn83vk7GQUQJ/A=;
	b=j4iKIHYRDknvdg/TfBjpx92bq7CGdmgIQES/NAo6CP0NExXKW0VYvStITr8aSxhL7EqL+kJPAuC7kSc6OpuuOz41P7I3FON23Hot5U8GSMYtPH3y/KWOB2BQ1aiw4SeoAQ68alw1b/GGb4ZTwrN9T1VrgvuKxy/3gBXoGbMhjfI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X85IDst_1785415437;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X85IDst_1785415437 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 20:43:58 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH 1/2] RDMA/erdma: Hold CQ references when processing EQ events
Date: Thu, 30 Jul 2026 20:43:53 +0800
Message-ID: <20260730124357.12976-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EQ handlers look up CQs from dev->cq_xa and invoke CQ completion or
error callbacks outside the xarray lock. erdma_destroy_cq() can erase the
CQ from the xarray and free its queue buffer and doorbell record while a
previously scheduled EQ handler is still using the CQ.

Add a CQ refcount and take a reference under the xarray lock with
refcount_inc_not_zero(). Remove the CQ from the xarray before dropping
the destroy-path reference, then wait for in-flight EQ users before
releasing CQ resources.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_eq.c    |  6 ++++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 12 +++++++++--
 drivers/infiniband/hw/erdma/erdma_verbs.h | 25 +++++++++++++++++++++--
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index a8784e07acd6..96e74fcf417c 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -52,7 +52,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 		if (FIELD_GET(ERDMA_AEQE_HDR_TYPE_MASK,
 			      le32_to_cpu(aeqe->hdr)) == ERDMA_AE_TYPE_CQ_ERR) {
 			cqn = le32_to_cpu(aeqe->event_data0);
-			cq = find_cq_by_cqn(dev, cqn);
+			cq = erdma_cq_get_by_cqn(dev, cqn);
 			if (!cq)
 				continue;
 
@@ -62,6 +62,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			if (cq->ibcq.event_handler)
 				cq->ibcq.event_handler(&event,
 						       cq->ibcq.cq_context);
+			erdma_cq_put(cq);
 		} else {
 			qpn = le32_to_cpu(aeqe->event_data0);
 			qp = find_qp_by_qpn(dev, qpn);
@@ -157,7 +158,7 @@ void erdma_ceq_completion_handler(struct erdma_eq_cb *ceq_cb)
 		poll_cnt++;
 		cqn = FIELD_GET(ERDMA_CEQE_HDR_CQN_MASK, READ_ONCE(*ceqe));
 
-		cq = find_cq_by_cqn(dev, cqn);
+		cq = erdma_cq_get_by_cqn(dev, cqn);
 		if (!cq)
 			continue;
 
@@ -166,6 +167,7 @@ void erdma_ceq_completion_handler(struct erdma_eq_cb *ceq_cb)
 
 		if (cq->ibcq.comp_handler)
 			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+		erdma_cq_put(cq);
 	}
 
 	notify_eq(&ceq_cb->eq);
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index ab6abbab029e..2adcd00c4199 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1326,6 +1326,7 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct erdma_dev *dev = to_edev(ibcq->device);
 	struct erdma_ucontext *ctx = rdma_udata_to_drv_context(
 		udata, struct erdma_ucontext, ibucontext);
+	unsigned long flags;
 	int err;
 	struct erdma_cmdq_destroy_cq_req req;
 
@@ -1340,6 +1341,13 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 				       "failed to destroy CQ %u: %d\n",
 				       cq->cqn, err);
 
+	xa_lock_irqsave(&dev->cq_xa, flags);
+	__xa_erase(&dev->cq_xa, cq->cqn);
+	xa_unlock_irqrestore(&dev->cq_xa, flags);
+
+	erdma_cq_put(cq);
+	wait_for_completion(&cq->free);
+
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
 				  cq->kern_cq.qbuf, cq->kern_cq.qbuf_dma_addr);
@@ -1350,8 +1358,6 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
 	}
 
-	xa_erase(&dev->cq_xa, cq->cqn);
-
 	return 0;
 }
 
@@ -1980,6 +1986,8 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	cq->ibcq.cqe = depth;
 	cq->depth = depth;
 	cq->assoc_eqn = attr->comp_vector + 1;
+	refcount_set(&cq->refcount, 1);
+	init_completion(&cq->free);
 
 	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
 			      XA_LIMIT(1, dev->attrs.max_cq - 1),
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 7d8d3fe501d5..894e080435fb 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -7,6 +7,9 @@
 #ifndef __ERDMA_VERBS_H__
 #define __ERDMA_VERBS_H__
 
+#include <linux/completion.h>
+#include <linux/refcount.h>
+
 #include "erdma.h"
 
 /* RDMA Capability. */
@@ -341,6 +344,8 @@ struct erdma_cq {
 
 	u32 depth;
 	u32 assoc_eqn;
+	refcount_t refcount;
+	struct completion free;
 
 	union {
 		struct erdma_kcq_info kern_cq;
@@ -355,9 +360,25 @@ static inline struct erdma_qp *find_qp_by_qpn(struct erdma_dev *dev, int id)
 	return (struct erdma_qp *)xa_load(&dev->qp_xa, id);
 }
 
-static inline struct erdma_cq *find_cq_by_cqn(struct erdma_dev *dev, int id)
+static inline struct erdma_cq *erdma_cq_get_by_cqn(struct erdma_dev *dev,
+						   int id)
+{
+	struct erdma_cq *cq;
+	unsigned long flags;
+
+	xa_lock_irqsave(&dev->cq_xa, flags);
+	cq = xa_load(&dev->cq_xa, id);
+	if (cq && !refcount_inc_not_zero(&cq->refcount))
+		cq = NULL;
+	xa_unlock_irqrestore(&dev->cq_xa, flags);
+
+	return cq;
+}
+
+static inline void erdma_cq_put(struct erdma_cq *cq)
 {
-	return (struct erdma_cq *)xa_load(&dev->cq_xa, id);
+	if (refcount_dec_and_test(&cq->refcount))
+		complete(&cq->free);
 }
 
 void erdma_qp_get(struct erdma_qp *qp);
-- 
2.31.1

