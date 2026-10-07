Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFA5409270;
	Wed,  7 Oct 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387273; cv=none; b=uYLC0GWft9a2Vt1sZ1l4SfF1FmnNC1CD2lrXXZVLOtr4KckYviGjFEv1AaBwRLi7CUESA/r0tqxEs2f3QKKn7111QsTiKe9Xm+rVo6t5/sd0gC7b86lu/Um9Gn+1tLThQQEUfh8MAC3ldHXcI5gFgE9t7HdbXUjwIEJUEGIpHjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387273; c=relaxed/simple;
	bh=1pctcpX93qwdjPIw6lglitQv3V5zeYbLG+QkLxRPxsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1CUTyRw4TUAHgbr3S3B8WbrAaVzzGjkZ4O58Xcjs0mIpjR4pWKJyEvwl4vL964U2q25AljuQ4TXbgVC30Memn4Cyym4EFduWLe888ZwTEGl/yapupWQ0t+NO3XCuGnmcA2Teh/+XKmx/z9qb3qBE0oJA9RH7BBuXF8hRwTzAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=STvhP58L; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="STvhP58L"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id DEA4020B7169; Wed,  7 Oct 2026 08:33:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DEA4020B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791387210;
	bh=w96+v2xCDjjmHWhO7NktiFm+YETbBlmB8n4bVhnZW64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STvhP58LrR//p3n4C7rAHdR1pZZ6yfs87KBwW+YTpGJpPQFzqUwNpdmUuQhukdEvW
	 Ok37k/apsAbbZOxpV2hnbtjR8UOpAgctnbG3h6Oq0nvOY+z36MudBQniUMGQDHbPwZ
	 lWi+2j8uaF6Gu8wRgWug/o+jUtkRB4hwXD4Xe4Jk=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v3 02/10] RDMA/mana: Create and destroy kernel RC QPs
Date: Wed,  7 Oct 2026 08:33:22 -0700
Message-ID: <20261007153330.2979799-3-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement kernel RC QP creation and destruction. This feature requires
extended-WQE and power-of-two-SQ support from the HW.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c    |   3 +-
 drivers/infiniband/hw/mana/mana_ib.h |   6 ++
 drivers/infiniband/hw/mana/qp.c      | 145 ++++++++++++++++++++++++++-
 3 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index ceb4ec58023a..fed20197addf 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -632,7 +632,8 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
 	props->max_qp = dev->adapter_caps.max_qp_count;
 	props->max_qp_wr = dev->adapter_caps.max_qp_wr;
 	props->device_cap_flags = IB_DEVICE_RC_RNR_NAK_GEN;
-	props->max_send_sge = dev->adapter_caps.max_send_sge_count;
+	/* Subtract 1 from max_send_sge to account for the reserved SGE */
+	props->max_send_sge = dev->adapter_caps.max_send_sge_count - 1;
 	props->max_recv_sge = dev->adapter_caps.max_recv_sge_count;
 	props->max_sge_rd = dev->adapter_caps.max_recv_sge_count;
 	props->max_cq = dev->adapter_caps.max_cq_count;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index ceb7830b8da1..61af35bf0e40 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -265,6 +265,10 @@ struct mana_ib_qp {
 	u32 sq_psn;
 	bool sq_sig_all;
 
+	/* Serializes receive WR posting. */
+	spinlock_t rq_lock;
+	/* Serializes send and memory-management WR posting. */
+	spinlock_t sq_lock;
 	/* Serializes QP modification and error-list transitions. */
 	struct mutex modify_lock;
 
@@ -272,6 +276,7 @@ struct mana_ib_qp {
 	struct list_head recv_err_node;
 	struct shadow_queue shadow_rq;
 	struct shadow_queue shadow_sq;
+	struct shadow_queue shadow_mmq;
 
 	refcount_t		refcount;
 	struct completion	free;
@@ -313,6 +318,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
 	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
 	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
 	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
 };
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index ae2ebbcc759a..1dc5b078b4ff 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -441,6 +441,32 @@ static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_type)
 			queue_size = attr->cap.max_recv_wr *
 				mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
 		break;
+	case IB_QPT_RC:
+		switch (queue_type) {
+		case MANA_RC_SEND_QUEUE_REQUESTER:
+			queue_size = attr->cap.max_send_wr *
+				mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
+						       INLINE_OOB_EXTRA_LARGE_SIZE);
+			break;
+		case MANA_RC_SEND_QUEUE_MMQ:
+			queue_size = attr->cap.max_send_wr *
+				mana_ib_wqe_size(1U, INLINE_OOB_EXTRA_LARGE_SIZE);
+			break;
+		case MANA_RC_SEND_QUEUE_RESPONDER:
+			queue_size = MANA_PAGE_SIZE;
+			break;
+		case MANA_RC_RECV_QUEUE_REQUESTER:
+			queue_size = attr->cap.max_send_wr *
+				mana_ib_wqe_size(attr->cap.max_send_sge, INLINE_OOB_SMALL_SIZE);
+			break;
+		case MANA_RC_RECV_QUEUE_RESPONDER:
+			queue_size = attr->cap.max_recv_wr *
+				mana_ib_wqe_size(attr->cap.max_recv_sge, INLINE_OOB_SMALL_SIZE);
+			break;
+		default:
+			return 0;
+		}
+		break;
 	default:
 		return 0;
 	}
@@ -460,6 +486,21 @@ static enum gdma_queue_type mana_ib_queue_type(struct ib_qp_init_attr *attr, u32
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
@@ -779,12 +820,107 @@ destroy_queues:
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
+	for (i = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
+		queue_size = mana_ib_queue_size(attr, i);
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
@@ -798,7 +934,10 @@ int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
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
@@ -1030,7 +1169,11 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
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
