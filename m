Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704665;
	b=epQ0ZpeFKImbTx6AlpQ43/8yF892Ef2PgpEl18Q0OW4oekisSK4infWZ/Q+kteFKLER3
	 ZyVCIS6tWMAX5gyNbv7QMkoc/qfROcuqyZYeVBk7H2dfaBmE+WYc01lfWm0vh2mr6Cu2R
	 wuCHgsn/dgjNdbgHDaWI/TknHudxJuV4z+GFOcTQOOmNBrzRWVbE4pZ/ZQChgrziVnffH
	 uwc2lgxw35BaedOHc/0ziYovhaZCx1T352QovWpQEVkxyAg2CEcOIZTMKUnMbr32S9Rb/
	 7o+qWMzvvJVtd88C2s6JQoXBEL8sZrWnTtkonjA23bdaKGcx5eMh4q6rgpqomAdsIgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704665;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2jir547rIz8uTAQl9jFkGG5SL+qrfQs77rntGI1czfE=;
	b=0B8FWnKy1yDotWD9A5ymksiaZxr+ATxKLaq6t0ij95CB1Ip9GCQ5Vw0133BiRUDJ868s
	 VAXKQoBMZ6qm9+D6yde0Igt/tKbl1PAeBWi2WBAd5teuw4dFqMVNpRL/ZEvMBinefDhM/
	 DkeHRnH9Qo+LTWofH1FC2LfyWTY12D63T/MD6hK51grNdBFpaBUJ1jCuK3yJ6Rcm4aKHo
	 QtRjzSjc/4CLhntBJ+LV8Jilt3mRpmJ6bcjuiXqtelsW9ttqGhD0lSVR3zeNcWP2mpsR4
	 XjjJTFeVzpEl+cKuEKjsWz7NMy2rUHF9y+8rPo51PQTjqZQSlk2CkVqggC8l7f73+Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Is7zY3PK;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DE7606D822;
	Tue,  3 Nov 2026 11:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2DE7606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Is7zY3PK
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id A6C9B20B716E; Tue,  3 Nov 2026 03:17:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6C9B20B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793704649;
	bh=2jir547rIz8uTAQl9jFkGG5SL+qrfQs77rntGI1czfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Is7zY3PKz1oJSSoiQ0LY0wm66+OAacmM3CMa0RVR0z8Iww36UeQ8q2swQerS4NVEH
	 hOZ32ox5cfLk/c4n6+7tHvqM3ysL5CsS4y3CY4+VASkOaXWOdsESSS7OB1IaAlk+tU
	 6XgMlYF7WreBiDmRckxz6kUSDg5y7LbR1I4v/LGs=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v8 8/9] RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
Date: Tue,  3 Nov 2026 03:17:28 -0800
Message-ID: <20261103111729.729886-9-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
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
index a4d886b9ecc6..d6fa1942b535 100644
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
@@ -589,7 +612,7 @@ static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
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
