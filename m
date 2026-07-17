Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BFF33D6ED;
	Fri, 17 Jul 2026 19:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315837; cv=none; b=UQB+k0uhW+vqUbF2fZSIfNgE9LbNs7pFOtUGyfXKmRo4X7gAu/HTK5aJLgIdaXcevgNdns4Or3UjAitO76O5R2l4bQVY2dFPW2+NIRd8aYb8aSyTcHTyykkCwoHpJ6dtFsi/TjsNoRoq+cLr+ZRJP8E2ogWCj0OiH97JuSxWE+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315837; c=relaxed/simple;
	bh=/totilil14+atLGZ4mHtcfhyYzgo1Z6Buwz3SqzcLQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFz3HJ1Wjcp13eZBMjAlTmpFNwORbHYTGcWU1O/zfOqi/6WvAOAVIlqHhCLTMgy1RWXCkF1OSdikKFuk5QyAohoWq547dbtv0Ab129IH8CHShXCnnL4gEVoU53AmjD8nZEnc54HshnwYvRGL4bOeaFxecwMBX/6Y8BAB+C6pMv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=KSWukxCa; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="KSWukxCa"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 4917420B716A; Fri, 17 Jul 2026 12:16:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4917420B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784315819;
	bh=5AU7pbjw0GPhlGMzNKpfaq+DVgQhxDUHpGsaQ8Zi2JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSWukxCaMhIOKqbcSLlzDa5PFh5wMISXIkLFgsPzF2vsceoReev6WTsFJHwHX2EwX
	 7krHHWXbhH5JFEiKAG0Q1yblTRvRA9RITfC9w/yNJLheIoYlouYB2xmn7EYJJCeTOU
	 Os9sAHJh+4Bx+EQM2gNXY3+IbMoK8yxvJ9xn66Mc=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 1/2] RDMA/mana_ib: unify QP lookup table
Date: Fri, 17 Jul 2026 12:16:58 -0700
Message-ID: <20260717191659.486802-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260717191659.486802-1-kotaranov@linux.microsoft.com>
References: <20260717191659.486802-1-kotaranov@linux.microsoft.com>
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
 drivers/infiniband/hw/mana/mana_ib.h | 30 ++++++++++++
 drivers/infiniband/hw/mana/qp.c      | 70 ++++++++++++----------------
 2 files changed, 59 insertions(+), 41 deletions(-)

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
index b5ff07e34..5e53f6ac2 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -461,22 +461,22 @@ static enum gdma_queue_type mana_ib_queue_type(struct ib_qp_init_attr *attr, u32
 	return type;
 }
 
-static int mana_table_store_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static int mana_table_store_qp_qids(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
+				    struct mana_ib_queue *sq, struct mana_ib_queue *rq)
 {
-	return xa_insert_irq(&mdev->qp_table_wq, qp->ibqp.qp_num, qp,
-			     GFP_KERNEL);
-}
+	u32 qids, qidr;
+	int err;
 
-static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
-{
-	xa_erase_irq(&mdev->qp_table_wq, qp->ibqp.qp_num);
-}
+	if (!sq || !rq)
+		return -EINVAL;
 
-static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
-{
-	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
-	u32 qidr = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
-	int err;
+	/* Set the send queue bit */
+	qids = sq->id | MANA_SENDQ_MASK;
+	qidr = rq->id;
+
+	/* Remove subtype bits */
+	qids &= ~MANA_QID_SUBTYPE_MASK;
+	qidr &= ~MANA_QID_SUBTYPE_MASK;
 
 	err = xa_insert_irq(&mdev->qp_table_wq, qids, qp, GFP_KERNEL);
 	if (err)
@@ -493,10 +493,21 @@ static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *q
 	return err;
 }
 
-static void mana_table_remove_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+static void mana_table_remove_qp_qids(struct mana_ib_dev *mdev, struct mana_ib_queue *sq,
+				      struct mana_ib_queue *rq)
 {
-	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
-	u32 qidr = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
+	u32 qids, qidr;
+
+	if (!sq || !rq)
+		return;
+
+	/* Set the send queue bit */
+	qids = sq->id | MANA_SENDQ_MASK;
+	qidr = rq->id;
+
+	/* Remove subtype bits */
+	qids &= ~MANA_QID_SUBTYPE_MASK;
+	qidr &= ~MANA_QID_SUBTYPE_MASK;
 
 	xa_erase_irq(&mdev->qp_table_wq, qids);
 	xa_erase_irq(&mdev->qp_table_wq, qidr);
@@ -507,36 +518,13 @@ static int mana_table_store_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 	refcount_set(&qp->refcount, 1);
 	init_completion(&qp->free);
 
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
-
-	return -EINVAL;
+	return mana_table_store_qp_qids(mdev, qp, mana_qp_get_sq(qp), mana_qp_get_rq(qp));
 }
 
 static void mana_table_remove_qp(struct mana_ib_dev *mdev,
 				 struct mana_ib_qp *qp)
 {
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
-		return;
-	}
+	mana_table_remove_qp_qids(mdev, mana_qp_get_sq(qp), mana_qp_get_rq(qp));
 	mana_put_qp_ref(qp);
 	wait_for_completion(&qp->free);
 }
-- 
2.43.0

