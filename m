Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365252;
	b=uySjEMo93lZJv+XzpDqtYmMXSPWqyustvLozUqYIXzhnB7lWZ9ZjmOitbfOSSJxRaMDu
	 vyNLkm0CM8dkJPOu91m6Kq+SRumObt6JphiDY4AxXKNNfw3FDWcNvcZYR9ULwTrBwBPd9
	 Iw8FnZ5FS/K4HHUfNZs0SC2mUGCLnRLmX1y6x9yxElGGm4eO2xqomjBYdilENbceLkZ5f
	 f3FExcuQfO88Rt1clJLCdxATxrujMixJRGz0gpUsldRgc3XIem/U9EytaoFgd7CpajwGR
	 RhvyA9zUW2N+u+L8SHDaKhiBvXUfU/XU9S5LWCbjwVRm/lFaoRRtGqgjO/Plxug4vqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365252;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Zlo3wYmw4XFcteKGyKTP2lVJSiQERshCz1+hs7XTvnk=;
	b=KyVP+49vkaJc/GWWRmEDerPapAnieLDBOkLiOSqyRb5Mz3WztSFsHCk4aYEJ1et+xS7K
	 tXnPyNFUZ/PSegzvw/IUsGVVgLextBD1L4N31fulnriReGqpTnq+Y1n+sKGA8fWLjjBj9
	 gOxhi8OFoQclGIJMfv2Nq+Lk+uPVGFj3lrHBNmLipi353ODAYGiK57mPLU5xRfR5ztq8A
	 9hgseuCZfLe+qV6t8ukZbTpYdSWZEyGPx78MghxWFrOcTZEItb802IENbETR54im42XyO
	 7SDwOTIReTo3xTDY38FrJRV8YVbEKVlSoVKlRjZWGcVDCajfUjyiqwAaJ0vQvpKBYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=RN5WBDPb;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA419606A320;
	Fri, 30 Oct 2026 13:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA419606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=RN5WBDPb
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 7FDD220B7168; Fri, 30 Oct 2026 06:00:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7FDD220B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793365238;
	bh=Zlo3wYmw4XFcteKGyKTP2lVJSiQERshCz1+hs7XTvnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN5WBDPbYt/64e+AS5nmmi61r0ko3S6FzinZLOBJH5Vg8pLcHvn4nR8ndvIIEvJzU
	 46x2i3t9/Abhe4z0aGQDMxvaZEMacEG4oLHr42nFOqDTnfSUyfpCkn6b6Jm7HHctV6
	 jq/AXaHdigHbN3+vhLSqnfewxyzBYZu80e//Ik1Q=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v6 02/10] RDMA/mana: Create and destroy kernel RC QPs
Date: Fri, 30 Oct 2026 06:00:30 -0700
Message-ID: <20261030130038.4040789-3-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
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

Implement kernel RC QP creation and destruction. This feature requires
extended-WQE and power-of-two-SQ support from the HW.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v5:
- Validate kernel QP queue sizes before allocating queues.
- Bound SGE counts and enforce the TX/RX WQE size limits.
v4:
- Reject RNIC firmware send-SGE counts below 2.
- Subtract the reserved SGE for extra-large OOB only for RNIC mana_ib.

 drivers/infiniband/hw/mana/main.c    |  10 +-
 drivers/infiniband/hw/mana/mana_ib.h |   6 +
 drivers/infiniband/hw/mana/qp.c      | 206 +++++++++++++++++++++++++--
 3 files changed, 211 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index ceb4ec58023a..f54905764f59 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -733,6 +733,13 @@ int mana_ib_gd_query_adapter_caps(struct mana_ib_dev *dev)
 	if (err)
 		return err;
 
+	/* Hardware supports at least one data SGE plus one reserved for extra-large OOB. */
+	if (resp.max_send_sge_count < 2) {
+		ibdev_err(&dev->ib_dev, "Invalid max_send_sge_count %u, expected at least 2\n",
+			  resp.max_send_sge_count);
+		return -EINVAL;
+	}
+
 	caps->max_sq_id = resp.max_sq_id;
 	caps->max_rq_id = resp.max_rq_id;
 	caps->max_cq_id = resp.max_cq_id;
@@ -748,7 +755,8 @@ int mana_ib_gd_query_adapter_caps(struct mana_ib_dev *dev)
 				resp.max_requester_sq_size / GDMA_MAX_SQE_SIZE,
 				resp.max_requester_rq_size / GDMA_MAX_RQE_SIZE);
 	caps->max_inline_data_size = resp.max_inline_data_size;
-	caps->max_send_sge_count = resp.max_send_sge_count;
+	/* Account for the SGE reserved for extra-large OOB. */
+	caps->max_send_sge_count = resp.max_send_sge_count - 1;
 	caps->max_recv_sge_count = resp.max_recv_sge_count;
 	caps->feature_flags = resp.feature_flags;
 
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 5ca6e2acf974..6f5df64e838a 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -267,6 +267,10 @@ struct mana_ib_qp {
 	u32 sq_psn;
 	bool sq_sig_all;
 
+	/* Serializes receive WR posting. */
+	spinlock_t rq_lock;
+	/* Serializes send and memory-management WR posting. */
+	spinlock_t sq_lock;
 	/* Serializes QP modification and error-list transitions. */
 	struct mutex modify_lock;
 
@@ -274,6 +278,7 @@ struct mana_ib_qp {
 	struct list_head recv_err_node;
 	struct shadow_queue shadow_rq;
 	struct shadow_queue shadow_sq;
+	struct shadow_queue shadow_mmq;
 
 	refcount_t		refcount;
 	struct completion	free;
@@ -315,6 +320,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
 	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
 	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
 	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
 };
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index ae2ebbcc759a..387586c45aa0 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -427,27 +427,88 @@ static u32 mana_ib_fixed_wqe_size(u32 sge, u32 oob_size)
 	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
 }
 
-static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_type)
+static u32 mana_ib_queue_size(struct mana_ib_dev *mdev, struct ib_qp_init_attr *attr,
+			      u32 queue_type)
 {
-	u32 queue_size;
+	u32 send_wr = max(attr->cap.max_send_wr, 1U);
+	u32 recv_wr = max(attr->cap.max_recv_wr, 1U);
+	u32 max_wqe_size = MAX_TX_WQE_SIZE;
+	u32 wr, wqe_size, read_sge;
+	u64 queue_size;
+
+	if (attr->cap.max_send_sge > MAX_TX_WQE_SIZE / sizeof(struct gdma_sge) ||
+	    attr->cap.max_recv_sge > MAX_RX_WQE_SIZE / sizeof(struct gdma_sge))
+		return 0;
 
 	switch (attr->qp_type) {
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
-		if (queue_type == MANA_UD_SEND_QUEUE)
-			queue_size = attr->cap.max_send_wr *
-				mana_ib_wqe_size(attr->cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
-		else
-			queue_size = attr->cap.max_recv_wr *
-				mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
+		if (queue_type == MANA_UD_SEND_QUEUE) {
+			wr = send_wr;
+			wqe_size = mana_ib_wqe_size(attr->cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
+		} else {
+			wr = recv_wr;
+			max_wqe_size = MAX_RX_WQE_SIZE;
+			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
+		}
+		break;
+	case IB_QPT_RC:
+		switch (queue_type) {
+		case MANA_RC_SEND_QUEUE_REQUESTER:
+			wr = send_wr;
+			wqe_size = mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
+							  INLINE_OOB_EXTRA_LARGE_SIZE);
+			break;
+		case MANA_RC_SEND_QUEUE_MMQ:
+			wr = send_wr;
+			wqe_size = mana_ib_wqe_size(1U, INLINE_OOB_EXTRA_LARGE_SIZE);
+			break;
+		case MANA_RC_SEND_QUEUE_RESPONDER:
+			return MANA_PAGE_SIZE;
+		case MANA_RC_RECV_QUEUE_REQUESTER:
+			wr = send_wr;
+			max_wqe_size = MAX_RX_WQE_SIZE;
+			read_sge = min(attr->cap.max_send_sge, mdev->ib_dev.attrs.max_sge_rd);
+			wqe_size = mana_ib_wqe_size(read_sge, INLINE_OOB_SMALL_SIZE);
+			break;
+		case MANA_RC_RECV_QUEUE_RESPONDER:
+			wr = recv_wr;
+			max_wqe_size = MAX_RX_WQE_SIZE;
+			wqe_size = mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
+			break;
+		default:
+			return 0;
+		}
 		break;
 	default:
 		return 0;
 	}
 
+	if (!wqe_size || wqe_size > max_wqe_size)
+		return 0;
+
+	queue_size = (u64)wr * wqe_size;
+	if (queue_size > U32_MAX / 2 + 1)
+		return 0;
+
 	return MANA_PAGE_ALIGN(roundup_pow_of_two(queue_size));
 }
 
+static int mana_ib_check_kernel_qp_sizes(struct mana_ib_dev *mdev,
+					 struct ib_qp_init_attr *attr, u32 num_queues)
+{
+	u32 i;
+
+	for (i = 0; i < num_queues; i++) {
+		if (!mana_ib_queue_size(mdev, attr, i)) {
+			ibdev_dbg(&mdev->ib_dev, "Invalid kernel QP queue %u size\n", i);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static enum gdma_queue_type mana_ib_queue_type(struct ib_qp_init_attr *attr, u32 queue_type)
 {
 	enum gdma_queue_type type;
@@ -460,6 +521,21 @@ static enum gdma_queue_type mana_ib_queue_type(struct ib_qp_init_attr *attr, u32
 		else
 			type = GDMA_RQ;
 		break;
+	case IB_QPT_RC:
+		switch (queue_type) {
+		case MANA_RC_SEND_QUEUE_REQUESTER:
+		case MANA_RC_SEND_QUEUE_RESPONDER:
+		case MANA_RC_SEND_QUEUE_MMQ:
+			type = GDMA_SQ;
+			break;
+		case MANA_RC_RECV_QUEUE_REQUESTER:
+		case MANA_RC_RECV_QUEUE_RESPONDER:
+			type = GDMA_RQ;
+			break;
+		default:
+			type = GDMA_INVALID_QUEUE;
+		}
+		break;
 	default:
 		type = GDMA_INVALID_QUEUE;
 	}
@@ -725,8 +801,12 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	if (udata)
 		return -EOPNOTSUPP;
 
+	err = mana_ib_check_kernel_qp_sizes(mdev, attr, MANA_UD_QUEUE_TYPE_MAX);
+	if (err)
+		return err;
+
 	for (i = 0; i < MANA_UD_QUEUE_TYPE_MAX; ++i) {
-		queue_size = mana_ib_queue_size(attr, i);
+		queue_size = mana_ib_queue_size(mdev, attr, i);
 		err = mana_ib_create_kernel_queue(mdev, queue_size, mana_ib_queue_type(attr, i),
 						  &qp->ud_qp.queues[i]);
 		if (err) {
@@ -779,12 +859,111 @@ destroy_queues:
 	return err;
 }
 
+static int mana_init_kernel_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
+				  struct ib_qp_init_attr *attr, u64 *flags)
+{
+	u32 wqe_size;
+	int err;
+
+	err = create_shadow_queue(&qp->shadow_rq, attr->cap.max_recv_wr,
+				  sizeof(struct shadow_wqe_header));
+	if (err)
+		return err;
+
+	err = create_shadow_queue(&qp->shadow_sq, attr->cap.max_send_wr,
+				  sizeof(struct shadow_wqe_header));
+	if (err)
+		goto destroy_rq;
+
+	err = create_shadow_queue(&qp->shadow_mmq, attr->cap.max_send_wr,
+				  sizeof(struct shadow_wqe_header));
+	if (err)
+		goto destroy_sq;
+
+	wqe_size = mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
+					  INLINE_OOB_EXTRA_LARGE_SIZE);
+	*flags |= MANA_RC_FLAG_FIXED_SIZE_WQE;
+	if (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT)
+		*flags |= MANA_RC_FLAG_MSN_IN_WQE;
+	qp->rc_qp.wqe_size_in_bu = wqe_size / GDMA_WQE_BU_SIZE;
+
+	return 0;
+
+destroy_sq:
+	destroy_shadow_queue(&qp->shadow_sq);
+destroy_rq:
+	destroy_shadow_queue(&qp->shadow_rq);
+	return err;
+}
+
+static int mana_ib_create_rc_qp_kernel(struct ib_qp *ibqp, struct ib_pd *ibpd,
+				       struct ib_qp_init_attr *attr)
+{
+	struct mana_ib_dev *mdev = container_of(ibpd->device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	u32 doorbell = mdev->gdma_dev->doorbell;
+	u32 queue_size;
+	u64 flags = 0;
+	int i, err;
+
+	if (!(mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_EXTENDED_WQE_FORMAT))
+		return -EOPNOTSUPP;
+	if (!(mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT))
+		return -EOPNOTSUPP;
+
+	err = mana_ib_check_kernel_qp_sizes(mdev, attr, MANA_RC_QUEUE_TYPE_MAX);
+	if (err)
+		return err;
+
+	for (i = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
+		queue_size = mana_ib_queue_size(mdev, attr, i);
+		err = mana_ib_create_kernel_queue(mdev, queue_size,
+						  mana_ib_queue_type(attr, i),
+						  &qp->rc_qp.queues[i]);
+		if (err)
+			goto destroy_queues;
+	}
+
+	err = mana_init_kernel_rc_qp(mdev, qp, attr, &flags);
+	if (err)
+		goto destroy_queues;
+
+	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
+	if (err)
+		goto deinit_queues;
+
+	qp->ibqp.qp_num = qp->rc_qp.queues[MANA_RC_RECV_QUEUE_RESPONDER].id;
+	qp->port = attr->port_num;
+
+	for (i = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i)
+		qp->rc_qp.queues[i].kmem->id = qp->rc_qp.queues[i].id;
+
+	err = mana_table_store_qp(mdev, qp);
+	if (err)
+		goto destroy_qp;
+
+	return 0;
+
+destroy_qp:
+	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+deinit_queues:
+	destroy_shadow_queue(&qp->shadow_rq);
+	destroy_shadow_queue(&qp->shadow_sq);
+	destroy_shadow_queue(&qp->shadow_mmq);
+destroy_queues:
+	while (i-- > 0)
+		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
+	return err;
+}
+
 int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		      struct ib_udata *udata)
 {
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 
 	qp->sq_sig_all = attr->sq_sig_type == IB_SIGNAL_ALL_WR;
+	spin_lock_init(&qp->rq_lock);
+	spin_lock_init(&qp->sq_lock);
 	mutex_init(&qp->modify_lock);
 	INIT_LIST_HEAD(&qp->send_err_node);
 	INIT_LIST_HEAD(&qp->recv_err_node);
@@ -798,7 +977,10 @@ int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 		return mana_ib_create_qp_raw(ibqp, ibqp->pd, attr, udata);
 	case IB_QPT_RC:
-		return mana_ib_create_rc_qp(ibqp, ibqp->pd, attr, udata);
+		if (udata)
+			return mana_ib_create_rc_qp(ibqp, ibqp->pd, attr, udata);
+		else
+			return mana_ib_create_rc_qp_kernel(ibqp, ibqp->pd, attr);
 	case IB_QPT_UC:
 		return mana_ib_create_uc_qp(ibqp, ibqp->pd, attr, udata);
 	case IB_QPT_UD:
@@ -1030,7 +1212,11 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 		return err;
 
 	mana_table_remove_qp(mdev, qp);
+	mana_remove_qp_from_cqs(qp, false);
 
+	destroy_shadow_queue(&qp->shadow_rq);
+	destroy_shadow_queue(&qp->shadow_sq);
+	destroy_shadow_queue(&qp->shadow_mmq);
 	/* Ignore return code as there is not much we can do about it.
 	 * The error message is printed inside.
 	 */
-- 
2.43.0
