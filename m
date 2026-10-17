Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8907941A4F9;
	Sat, 17 Oct 2026 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219462; cv=none; b=tm2Q24Q3NaL+Y1rFrjk2sRn2VTVFOgo8Bsy9EzE8skyL+JWCGoE8rQld80DuXLAorAHmDjHVGu/E993WOK+cIzE56hhJWKXa6AmBnRe1ZaZHvntXgxqECahR1Ol3MSjn3nii5jvuIRdfT4Z5SWYyLcjaCAbWGNp9mlshP7hn9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219462; c=relaxed/simple;
	bh=vbA6A3Rwehqz3MaYpXfN8W4sLKSnwgTEttHe6By9fss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVBi6dJ+vZSEP2YhzpUSLmiqX/0z4dVXQcJ4nzOE2SfodfpSO+LknY/vY5INvblG1edl7h2ndV4DpnvLMQNPJFEuir3R7Q3zdOP2uP3fgVw/Xqu+3luZLtJSBKeDSDVlNXv+JMqCd1GvWVwtBKPdTNBA7kwPflvujXPhtI1946U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VSsuqXzp; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VSsuqXzp"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 95EEC20B7171; Fri, 16 Oct 2026 23:44:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 95EEC20B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792219453;
	bh=S8bP6SBvLuzYwhF5d48dAzeysqKNs+fWRFIncOIdjeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSsuqXzpcnk9Qtrm3tZydRy3x3bHWkb5Xh3Fw6/h8HHT4OVpT6ZPQcvWOXMTJ3GAo
	 QP8r8GD6VL++35tuDh9n5aY7iydRHDdc5LPIDDnUVZnck1MwtefSP5BrFS0BS6yHjS
	 HgYw4aZk2V7d/7ziBb0x2FtnzhP92BPoxRTeEsbs=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 08/10] RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
Date: Fri, 16 Oct 2026 23:44:11 -0700
Message-ID: <20261017064413.995985-9-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
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
v5:
- Remove the unused QP state field.
v3:
- Skip kernel state update handling for userspace QPs.
- Warn and refuse to add userspace QPs to the CQ error lists.
- Add mana_remove_qp_from_cqs() for UC
v2:
- Skip software CQ notifications for IB_POLL_DIRECT.

 drivers/infiniband/hw/mana/cq.c |  2 +-
 drivers/infiniband/hw/mana/qp.c | 53 ++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index a4d886b9ecc6..90a43c7feb31 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -589,7 +589,7 @@ static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
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
-- 
2.43.0
