Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA90472F83;
	Thu, 23 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808011; cv=none; b=WkXOicaP2D+Q3xCkG7c006LbldsKZpJ8mvN+AUB7N9GxzVDpxl8bsm1f6T1wHpwIOzdirqyF+Z59lrmLPESDHRuyNBJELU6Adf9rTjGDNtDg9HIN6GlNsDEQ/qVnt6mVtQc7FVLsYZheNyMPrymflaDTajuqpmn6Z8+7LrdP3io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808011; c=relaxed/simple;
	bh=kwpRZ72+6RROi/16zj7N6lU3Th2nxQqipqnoL6V3lhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfEhmXfQv+9vTLasoZQsQqwH/ghu38DjbT1MVztMLmZmHo8IxDr368yp+WdnBY3tcvSe5f8+HXKhnghFFFEX3w4yxNiNaOijrAwzbEZsj6se9mv+MRnrU0W7BGuBX7bICmmcnDnsQG+0DiWFUv6KVJ+tgDhb4zxdphMBfd4UkOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=agbDG/vD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="agbDG/vD"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 65EB720B7168; Thu, 23 Jul 2026 04:59:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 65EB720B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784807995;
	bh=x9L6aC36Df0pExg2h1H/NsTfIYnec+YLvFE0k6sBk6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agbDG/vDgfPEtQ1Dqt+yQGvfC+yor/QKRelI6rs/r3MjAPBBnQ0OAuwVtlncjg1Cn
	 9bY+Skp+iRCRO4s5WvJ6CIqAy6EoYR6zCbWGTn9O88bETPVLpPG6w3zZDds5L4a5Dx
	 cyqKh9dPRh+7JjFGvzVuLh4XfGNG/THXMBrM+5Jk=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 1/2] RDMA/mana_ib: unify QP lookup table
Date: Thu, 23 Jul 2026 04:59:54 -0700
Message-ID: <20260723115955.1859519-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
References: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Add helpers to retrieve the send and receive queues of a QP.
Use these helpers when storing queue IDs in the lookup table.
MANA queue IDs are 2-bit aligned, allowing the two least
significant bits to be omitted when storing and looking up
queue IDs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v4->v5: inline store functions inside mana_table_store_qp() to explicitly
see the call of drain at the same level.
 drivers/infiniband/hw/mana/mana_ib.h | 30 +++++++++
 drivers/infiniband/hw/mana/qp.c      | 97 ++++++++++++----------------
 2 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index da05966af..18688072f 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -26,6 +26,8 @@
 
 /* Send queue ID mask */
 #define MANA_SENDQ_MASK	BIT(31)
+/* Queue ID encodes type in the lower 2 bits */
+#define MANA_QID_SUBTYPE_MASK 0x3
 
 /*
  * The hardware limit of number of MRs is greater than maximum number of MRs
@@ -582,12 +584,40 @@ static inline struct gdma_context *mdev_to_gc(struct mana_ib_dev *mdev)
 	return mdev->gdma_dev->gdma_context;
 }
 
+static inline struct mana_ib_queue *mana_qp_get_sq(struct mana_ib_qp *qp)
+{
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		return &qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER];
+	case IB_QPT_UD:
+	case IB_QPT_GSI:
+		return &qp->ud_qp.queues[MANA_UD_SEND_QUEUE];
+	default:
+		return NULL;
+	}
+}
+
+static inline struct mana_ib_queue *mana_qp_get_rq(struct mana_ib_qp *qp)
+{
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		return &qp->rc_qp.queues[MANA_RC_RECV_QUEUE_RESPONDER];
+	case IB_QPT_UD:
+	case IB_QPT_GSI:
+		return &qp->ud_qp.queues[MANA_UD_RECV_QUEUE];
+	default:
+		return NULL;
+	}
+}
+
 static inline struct mana_ib_qp *mana_get_qp_ref(struct mana_ib_dev *mdev,
 						 u32 qid, bool is_sq)
 {
 	struct mana_ib_qp *qp;
 	unsigned long flag;
 
+	/* Remove subtype bits */
+	qid &= ~MANA_QID_SUBTYPE_MASK;
 	if (is_sq)
 		qid |= MANA_SENDQ_MASK;
 
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index c52f3ec14..47e1fadbd 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -461,89 +461,74 @@ static enum gdma_queue_type mana_ib_queue_type(struct ib_qp_init_attr *attr, u32
 	return type;
 }
 
-static int mana_table_store_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
 {
-	return xa_insert_irq(&mdev->qp_table_wq, qp->ibqp.qp_num, qp,
-			     GFP_KERNEL);
+	mana_put_qp_ref(qp);
+	wait_for_completion(&qp->free);
 }
 
-static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static int mana_table_store_qp_qid(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
+				   u32 qid, bool is_sq)
 {
-	xa_erase_irq(&mdev->qp_table_wq, qp->ibqp.qp_num);
+	/* Remove subtype bits */
+	qid &= ~MANA_QID_SUBTYPE_MASK;
+	if (is_sq)
+		qid |= MANA_SENDQ_MASK;
+
+	return xa_insert_irq(&mdev->qp_table_wq, qid, qp, GFP_KERNEL);
 }
 
-static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
+static void mana_table_remove_qp_qid(struct mana_ib_dev *mdev, u32 qid, bool is_sq)
 {
-	mana_put_qp_ref(qp);
-	wait_for_completion(&qp->free);
+	/* Remove subtype bits */
+	qid &= ~MANA_QID_SUBTYPE_MASK;
+	if (is_sq)
+		qid |= MANA_SENDQ_MASK;
+
+	xa_erase_irq(&mdev->qp_table_wq, qid);
 }
 
-static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static int mana_table_store_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 {
-	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
-	u32 qidr = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
+	struct mana_ib_queue *sq, *rq;
 	int err;
 
-	err = xa_insert_irq(&mdev->qp_table_wq, qids, qp, GFP_KERNEL);
+	refcount_set(&qp->refcount, 1);
+	init_completion(&qp->free);
+	sq = mana_qp_get_sq(qp);
+	rq = mana_qp_get_rq(qp);
+
+	if (!sq || !rq)
+		return -EINVAL;
+
+	err = mana_table_store_qp_qid(mdev, qp, sq->id, true);
 	if (err)
 		return err;
 
-	err = xa_insert_irq(&mdev->qp_table_wq, qidr, qp, GFP_KERNEL);
+	err = mana_table_store_qp_qid(mdev, qp, rq->id, false);
 	if (err)
-		goto remove_sq;
+		goto err_remove_sq;
 
 	return 0;
 
-remove_sq:
-	xa_erase_irq(&mdev->qp_table_wq, qids);
+err_remove_sq:
+	mana_table_remove_qp_qid(mdev, sq->id, true);
 	mana_table_drain_qp_ref(qp);
 	return err;
 }
 
-static void mana_table_remove_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
-{
-	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
-	u32 qidr = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
-
-	xa_erase_irq(&mdev->qp_table_wq, qids);
-	xa_erase_irq(&mdev->qp_table_wq, qidr);
-}
-
-static int mana_table_store_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static void mana_table_remove_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 {
-	refcount_set(&qp->refcount, 1);
-	init_completion(&qp->free);
-
-	switch (qp->ibqp.qp_type) {
-	case IB_QPT_RC:
-		return mana_table_store_rc_qp(mdev, qp);
-	case IB_QPT_UD:
-	case IB_QPT_GSI:
-		return mana_table_store_ud_qp(mdev, qp);
-	default:
-		ibdev_dbg(&mdev->ib_dev, "Unknown QP type for storing in mana table, %d\n",
-			  qp->ibqp.qp_type);
-	}
+	struct mana_ib_queue *sq, *rq;
 
-	return -EINVAL;
-}
+	sq = mana_qp_get_sq(qp);
+	rq = mana_qp_get_rq(qp);
 
-static void mana_table_remove_qp(struct mana_ib_dev *mdev,
-				 struct mana_ib_qp *qp)
-{
-	switch (qp->ibqp.qp_type) {
-	case IB_QPT_RC:
-		mana_table_remove_rc_qp(mdev, qp);
-		break;
-	case IB_QPT_UD:
-	case IB_QPT_GSI:
-		mana_table_remove_ud_qp(mdev, qp);
-		break;
-	default:
-		ibdev_dbg(&mdev->ib_dev, "Unknown QP type for removing from mana table, %d\n",
-			  qp->ibqp.qp_type);
+	if (!sq || !rq)
 		return;
-	}
+
+	mana_table_remove_qp_qid(mdev, sq->id, true);
+	mana_table_remove_qp_qid(mdev, rq->id, false);
 	mana_table_drain_qp_ref(qp);
 }
 
-- 
2.43.0

