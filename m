Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901586;
	b=UcD95diAxewdQksueHngXGbarCvbBfLJEryMmuI+iZvs3//iN/G8cAZVexrXmUvnvaOV
	 0qcOb1SYGjv1x+aNy13Ii/97DazPdUaAHHIVKGg6r6F8yGJlB8gLCpJlbCHNHzZpk8k1j
	 h6oYUTe0FXc9jFuO3BRvfXt9kqYua6/SH3O67hOooy8BgsagImQNdx3DJvZ+1PR9c1nxa
	 +ZU2gnomoDLGiZ4ksbJ9pQoZUxrqI4NYAJwaDxyhXzd8+1ATRb1pEiY3OiQSvZW66DdF3
	 F7d5hnXWDlOrr+UR8MfNyhdoDcv3mKzDkiYhk6Y4HKWGR9Y9oUe4SBegQ4WXMwszOSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901586;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=r08hALRnEcw9/skaYYKZfCVw8ln83YWJNX4t3ZLDSM4=;
	b=uKa7/Vij0fr1Y/qTWkMVaQuCT3C1xL/eP5gkLdSdmAZxY5BtzN5HEycCmXXfNQbQTJiw
	 oKxZVQ/E/a36shPwieJBbv46tqiL3evBDH17Za8qyaAhzj8LzsPcuDnuaVlh6uKhrrVdI
	 2wGnzZI4OCJNin4gR2RCNqYeRZyKbnk36NzyuN9JEKe7J2NUYeixXni53whObpIhsMvP3
	 UgTsYWmw/ory/lBPoO8p5zZRj9Xbyfw/IgfOZyKr0kjmE4bg2Jh4vD7dA5t2ZUoJZAb+B
	 MNcR5EEIXlZ0tmJIirp2lX9AqC1wpRq+QQ+1kKYodYi8pFmStZVa+RnxPt0H1lpd3Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=NlFrdnq+;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93789606A33B;
	Thu,  5 Nov 2026 17:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93789606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=NlFrdnq+
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id D5D5820B716E; Thu,  5 Nov 2026 09:59:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D5D5820B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793901568;
	bh=r08hALRnEcw9/skaYYKZfCVw8ln83YWJNX4t3ZLDSM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlFrdnq+P/2Kp2O0IwlQ3IDNhgHNEFJqTrHNHckr4q84fG7f/pmR/sGoqCTPrrqjs
	 JYQTPsL2bXpEDG6EW8SZlwli1tkWqj1a06apn0lXx4tKTHpQdQ3mH3sbpkH4oKm2XP
	 53sPAsDhmcU5AEpffgBWBXuiCA1qg/aLI/z7cYGQ=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v9 8/9] RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
Date: Thu,  5 Nov 2026 09:59:27 -0800
Message-ID: <20261105175928.1326682-9-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Complete the RC software flush path by adding a kernel QP to the CQ
error lists when it transitions to the ERR state.

Invoke the CQ handlers after the transition to flush pending work
requests.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v6:
- Notify after posting to error-listed QPs adn reuse new helper for GSI.
- Report pending flush WCs (mana_ib_cq_has_flush_work) for IB_CQ_REPORT_MISSED_EVENTS
v5:
- Remove the unused QP state field.
v3:
- Skip kernel state update handling for userspace QPs.
- Warn and refuse to add userspace QPs to the CQ error lists.
- Add mana_remove_qp_from_cqs() for UC
v2:
- Skip software CQ notifications for IB_POLL_DIRECT.

 drivers/infiniband/hw/mana/cq.c | 27 +++++++++++++++--
 drivers/infiniband/hw/mana/qp.c | 53 ++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mana/wr.c | 42 +++++++++++++++++++-------
 3 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 408dee5ad458..cc519d3e42f4 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -278,6 +278,25 @@ static inline void mana_ib_cq_doorbell(struct mana_ib_cq *cq, uint8_t arm)
 	mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), gdma_cq, idx, arm, 0);
 }
 
+static bool mana_ib_cq_has_flush_work(struct mana_ib_cq *cq)
+{
+	struct mana_ib_qp *qp;
+
+	list_for_each_entry(qp, &cq->send_err_qp_list, send_err_node) {
+		if (!shadow_queue_empty(&qp->shadow_sq))
+			return true;
+		if (!shadow_queue_empty(&qp->shadow_mmq))
+			return true;
+	}
+
+	list_for_each_entry(qp, &cq->recv_err_qp_list, recv_err_node) {
+		if (!shadow_queue_empty(&qp->shadow_rq))
+			return true;
+	}
+
+	return false;
+}
+
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
@@ -290,8 +309,12 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 
 	spin_lock_irqsave(&cq->cq_lock, irq_flags);
 	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
-	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
+	if (flags & IB_CQ_REPORT_MISSED_EVENTS) {
 		missed = cq->has_pending_cqe;
+		/* Software flushes cannot retrigger the hardware CQ notification. */
+		if (!missed)
+			missed = mana_ib_cq_has_flush_work(cq);
+	}
 	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);
 
 	return missed;
@@ -592,7 +615,7 @@ static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
 		list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
-	if (cq->ibcq.comp_handler)
+	if (cq->ibcq.poll_ctx != IB_POLL_DIRECT && cq->ibcq.comp_handler)
 		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 }
 
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 5d6f45b9f53d..18242e1a6360 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -770,6 +770,27 @@ destroy_queues:
 	return err;
 }
 
+static void mana_add_qp_to_error_cqs(struct mana_ib_qp *qp)
+{
+	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
+	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
+	unsigned long flags;
+
+	if (WARN_ON_ONCE(qp->ibqp.uobject))
+		return;
+
+	/* Keep ERR QPs linked until reset/destroy, including later drain WRs. */
+	spin_lock_irqsave(&send_cq->cq_lock, flags);
+	if (list_empty(&qp->send_err_node))
+		list_add_tail(&qp->send_err_node, &send_cq->send_err_qp_list);
+	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
+
+	spin_lock_irqsave(&recv_cq->cq_lock, flags);
+	if (list_empty(&qp->recv_err_node))
+		list_add_tail(&qp->recv_err_node, &recv_cq->recv_err_qp_list);
+	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
+}
+
 static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
 {
 	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
@@ -1070,15 +1091,16 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return 0;
 }
 
-static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+static bool mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				    int attr_mask, struct ib_udata *udata)
 {
 	struct mana_ib_dev *mdev = container_of(ibqp->device, struct mana_ib_dev, ib_dev);
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 	struct gdma_queue *rq;
+	bool notify = false;
 
-	if (udata)
-		return;
+	if (udata || ibqp->uobject)
+		return false;
 
 	if (attr_mask & IB_QP_PATH_MTU)
 		qp->mtu = attr->path_mtu;
@@ -1091,6 +1113,10 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		default:
 			break;
 		}
+		if (attr->qp_state == IB_QPS_ERR) {
+			mana_add_qp_to_error_cqs(qp);
+			notify = true;
+		}
 	}
 
 	if (attr_mask & IB_QP_SQ_PSN) {
@@ -1106,12 +1132,27 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 						     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
 		}
 	}
+
+	return notify;
+}
+
+static void mana_ib_notify_error_cqs(struct mana_ib_qp *qp)
+{
+	struct ib_cq *send_cq = qp->ibqp.send_cq;
+	struct ib_cq *recv_cq = qp->ibqp.recv_cq;
+
+	if (send_cq->poll_ctx != IB_POLL_DIRECT && send_cq->comp_handler)
+		send_cq->comp_handler(send_cq, send_cq->cq_context);
+	if (recv_cq != send_cq && recv_cq->poll_ctx != IB_POLL_DIRECT &&
+	    recv_cq->comp_handler)
+		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
 }
 
 int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	bool notify = false;
 	int ret;
 
 	mutex_lock(&qp->modify_lock);
@@ -1130,11 +1171,14 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out_unlock;
 	}
 
-	mana_ib_modify_qp_state(ibqp, attr, attr_mask, udata);
+	notify = mana_ib_modify_qp_state(ibqp, attr, attr_mask, udata);
 
 out_unlock:
 	mutex_unlock(&qp->modify_lock);
 
+	if (notify)
+		mana_ib_notify_error_cqs(qp);
+
 	return ret;
 }
 
@@ -1256,6 +1300,7 @@ static int mana_ib_destroy_uc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 		return err;
 
 	mana_table_remove_qp(mdev, qp);
+	mana_remove_qp_from_cqs(qp, false);
 	/* Ignore return code as there is not much we can do about it.
 	 * The error message is printed inside.
 	 */
diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 8cec2e621fa7..272106e26edf 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -72,6 +72,25 @@ static inline u8 convert_wr_to_hw_opcode(enum ib_wr_opcode opcode)
 	}
 }
 
+static void mana_ib_notify_flush(struct ib_cq *ibcq, struct list_head *err_node)
+{
+	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
+	unsigned long flags;
+	bool flush;
+
+	if (ibcq->poll_ctx == IB_POLL_DIRECT)
+		return;
+	if (!ibcq->comp_handler)
+		return;
+
+	spin_lock_irqsave(&cq->cq_lock, flags);
+	flush = !list_empty(err_node);
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
+	if (flush)
+		ibcq->comp_handler(ibcq, ibcq->cq_context);
+}
+
 static int mana_ib_post_rq(struct mana_ib_qp *qp, const struct ib_recv_wr *wr)
 {
 	struct ib_sge mana_ib_dummy_sge = {.addr = 1, .length = 0, .lkey = 0};
@@ -129,8 +148,10 @@ static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *
 		ring_rq = true;
 	}
 
-	if (ring_rq)
+	if (ring_rq) {
 		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), rq);
+		mana_ib_notify_flush(qp->ibqp.recv_cq, &qp->recv_err_node);
+	}
 
 	return err;
 }
@@ -141,6 +162,7 @@ static int mana_ib_post_recv_rc(struct mana_ib_qp *qp, const struct ib_recv_wr *
 	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
 	struct mana_ib_queue *ib_rq = mana_qp_get_rq(qp);
 	unsigned long flags;
+	bool posted = false;
 	u8 wqe_cnt = 0;
 	int err = 0;
 
@@ -152,6 +174,7 @@ static int mana_ib_post_recv_rc(struct mana_ib_qp *qp, const struct ib_recv_wr *
 			*bad_wr = wr;
 			break;
 		}
+		posted = true;
 		wqe_cnt++;
 		if (wqe_cnt == 0xFF) {
 			mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), ib_rq->kmem,
@@ -167,6 +190,9 @@ static int mana_ib_post_recv_rc(struct mana_ib_qp *qp, const struct ib_recv_wr *
 					     wqe_cnt, 0);
 
 	spin_unlock_irqrestore(&qp->rq_lock, flags);
+	if (posted)
+		mana_ib_notify_flush(qp->ibqp.recv_cq, &qp->recv_err_node);
+
 	return err;
 }
 
@@ -259,11 +285,8 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *
 				const struct ib_send_wr **bad_wr)
 {
 	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
-	struct mana_ib_cq *cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct gdma_queue *queue = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].kmem;
-	unsigned long flags;
 	bool ring_sq = false;
-	bool flush_send;
 	int err = 0;
 
 	for (; wr; wr = wr->next) {
@@ -277,13 +300,7 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *
 
 	if (ring_sq) {
 		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
-
-		spin_lock_irqsave(&cq->cq_lock, flags);
-		flush_send = !list_empty(&qp->send_err_node);
-		spin_unlock_irqrestore(&cq->cq_lock, flags);
-
-		if (flush_send && cq->ibcq.comp_handler)
-			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+		mana_ib_notify_flush(qp->ibqp.send_cq, &qp->send_err_node);
 	}
 
 	return err;
@@ -577,6 +594,9 @@ static int mana_ib_post_send_rc(struct mana_ib_qp *qp, const struct ib_send_wr *
 					 qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER].kmem);
 
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
+	if (ring_sq || ring_mmq)
+		mana_ib_notify_flush(qp->ibqp.send_cq, &qp->send_err_node);
+
 	return err;
 }
 
-- 
2.43.0

