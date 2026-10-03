Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C474737DE9B;
	Sat,  3 Oct 2026 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791009696; cv=none; b=oTLCrhQyEY4j1IQYbvpnhoODl5riQaTUrNOETpdqurooV0xnJcFg8PdGNcM5STcr8Df4abb21rH+atEAVodvVfHO0g0TSzPbfAjYzM7VAjTzHMT+LFYU+xjQHRGxUzsLMp2fmqct8HF3Xb7nzTFDc2DwvQQ/VRtb3lyxr4SrGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791009696; c=relaxed/simple;
	bh=LK+wW/PXmBUY9LDHhAkAzvQV+nEoqVimBlwRT92Rr74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUCJrGykUHfSuYz1OCyZSC0u32GoW5dNrbr3Q9SsWv5XpIMhGlROREDYTgmCj51Iga+lqIJA57OCYShYTGqqVGXL3cAqqrYnM2e02X7oWtbbYc5HUZNFGZTT/1duy9Ky7rAwWF5Gv/rF7xRKZxVOTDcbxAtf13s8TBhyT3zOq14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=chrONFm4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="chrONFm4"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 512CC20B716F; Fri,  2 Oct 2026 23:40:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 512CC20B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791009638;
	bh=MWl8Yx/CWwjUymbAyHGx0oH10tOH27B99gicjpQvGEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chrONFm4DYp3O99dwKwUtaE7qw2jMfUmNjE3S0GVjY2Zw7ZeAIC8SdVTFG/uDcyzT
	 rHN4t1aqcKlzYxPNfhZDHsT22PuQXQJZBnKiryyGybak+DCjxlQ3AhQmZQ7NcmX27O
	 mXc0rIc1Mb+OdRwhbxziFLDAP3AXuYXPO3tHAA5I=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 08/10] RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
Date: Fri,  2 Oct 2026 23:40:35 -0700
Message-ID: <20261003064037.2092669-9-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Complete the RC software flush path by adding a kernel QP to the CQ
error lists when it transitions to the ERR state.

Invoke the CQ handlers after the transition to flush pending work
requests.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
Changes in v2:
- Skip software CQ notifications for IB_POLL_DIRECT.

 drivers/infiniband/hw/mana/cq.c      |  2 +-
 drivers/infiniband/hw/mana/mana_ib.h |  1 +
 drivers/infiniband/hw/mana/qp.c      | 48 ++++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 29eb12c1848e..b2fded9fbf40 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -585,7 +585,7 @@ static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
 		list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
-	if (cq->ibcq.comp_handler)
+	if (cq->ibcq.poll_ctx != IB_POLL_DIRECT && cq->ibcq.comp_handler)
 		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 }
 
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 1fc816792fc6..755fb87bfda1 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -269,6 +269,7 @@ struct mana_ib_qp {
 	bool pending_mmq_fence;
 	bool sq_sig_all;
 	enum ib_mtu mtu;
+	enum ib_qp_state state;
 
 	/* Serializes receive WR posting. */
 	spinlock_t rq_lock;
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 65b0ebf4df3f..294f4f885b54 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -735,6 +735,24 @@ destroy_queues:
 	return err;
 }
 
+static void mana_add_qp_to_error_cqs(struct mana_ib_qp *qp)
+{
+	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
+	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
+	unsigned long flags;
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
@@ -1027,15 +1045,16 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
 
 	if (udata)
-		return;
+		return false;
 
 	if (attr_mask & IB_QP_PATH_MTU)
 		qp->mtu = attr->path_mtu;
@@ -1048,6 +1067,11 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		default:
 			break;
 		}
+		qp->state = attr->qp_state;
+		if (attr->qp_state == IB_QPS_ERR) {
+			mana_add_qp_to_error_cqs(qp);
+			notify = true;
+		}
 	}
 
 	if (attr_mask & IB_QP_SQ_PSN) {
@@ -1063,12 +1087,27 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
@@ -1087,11 +1126,14 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
 
-- 
2.43.0
