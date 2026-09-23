Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7649F52B1FE;
	Wed, 23 Sep 2026 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169171; cv=none; b=p+bB9iEuHyaM6P+zXzdUynQPvQ8lqPY1erHX/xURthzK5j0EgOLouKGngO6rD/SOFjSA4pS/i81iv83Kmy2d4ZRzEb5tpWLR/OYrYGOchdcEeWosMvTIghLzLll6lQQhinMGU2YS0Si0tC2hedc5nr9KMs1VPjK6UiRyBVxrbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169171; c=relaxed/simple;
	bh=kPtaMJloFy0zzan/t8HcOF3akAqyBrSlR4AZuXCgl5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsvNt31HLkM6q65n6IptXi2NWeGX0FNh7iN2qqJbnBDrLIEHecs72Hp0kRDSDHEM+nPP0GIo6yeXl0xbDgr2TBcARokhDIOYPrDhwR10mnvtiFv6uU4G3q+UoYK80aslwFlJ6S6+vJ34Vrf9vpfYqZGJ3pviF0rSmBT2i3i339s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=azEfHNH6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="azEfHNH6"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 4B80320B716A; Wed, 23 Sep 2026 06:11:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B80320B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790169115;
	bh=/ajvgisO0T95C7I6v+q0871DH3JaKxsY/0ZSAzLYJjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azEfHNH6mX+CTz7ica9kg8ivsa5FimOFQ8MejzUZn6rkdIYqLqaAdhn7XRtop509g
	 1dopqapNhlsnIGMRSenEfz7mEx5llp5BX97XIJgO7fXzOUpNRqZDQOC1Jcsz+zDHfG
	 9r2SpNhl1lWkmL2h3xW+Tg9RUATJ099NHQUxu/TY=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 2/5] RDMA/mana_ib: Revise UD send posting and WQE definitions
Date: Wed, 23 Sep 2026 06:11:52 -0700
Message-ID: <20260923131155.4055875-3-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Batch multiple send requests under a single doorbell. Move the send PSN
to the common QP structure so it can be shared by all QP types. Define
new WQE formats for UD and RC QPs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/mana_ib.h | 40 ++++++++++++++++++-
 drivers/infiniband/hw/mana/wr.c      | 58 ++++++++++++++++------------
 2 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 4da110b30..619578f16 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -206,7 +206,6 @@ enum mana_ud_queue_type {
 
 struct mana_ib_ud_qp {
 	struct mana_ib_queue queues[MANA_UD_QUEUE_TYPE_MAX];
-	u32 sq_psn;
 };
 
 struct mana_ib_qp {
@@ -222,6 +221,7 @@ struct mana_ib_qp {
 
 	/* The port on the IB device, starting with 1 */
 	u32 port;
+	u32 sq_psn;
 
 	struct list_head cq_send_list;
 	struct list_head cq_recv_list;
@@ -525,7 +525,16 @@ struct mana_rnic_set_qp_state_resp {
 
 enum WQE_OPCODE_TYPES {
 	WQE_TYPE_UD_SEND = 0,
+	WQE_TYPE_RC_SEND = 2,
+	WQE_TYPE_RC_SEND_IMM = 3,
+	WQE_TYPE_RC_SEND_INV = 4,
+	WQE_TYPE_WRITE = 5,
+	WQE_TYPE_WRITE_IMM = 6,
+	WQE_TYPE_READ = 7,
 	WQE_TYPE_UD_RECV = 8,
+	WQE_TYPE_RC_RECV = 9,
+	WQE_TYPE_REG_MR = 10,
+	WQE_TYPE_LOCAL_INV = 12,
 }; /* HW DATA */
 
 struct rdma_send_oob {
@@ -544,7 +553,36 @@ struct rdma_send_oob {
 			u32 reserved1;
 			u32 reserved2;
 		} ud_send;
+		union {
+			u32 immediate;
+			u32 invalidate_key;
+		} rc_send;
+		struct {
+			u32 address_hi;
+			u32 address_low;
+			u32 rkey;
+			u32 dma_len;
+		} rdma;
+		struct {
+			u32 mkey;
+		} mm;
 	};
+	union {
+		u32 immediate_ext;
+		struct {
+			u16 rsn;
+			u16 reserved;
+		} read;
+	};
+	u32 fsn : 24;
+	u32 reserved2   : 8;
+}; /* HW DATA */
+
+struct rdma_recv_oob {
+	u32 psn_start   : 24;
+	u32 reserved1   : 8;
+	u32 msn         : 24;
+	u32 reserved2   : 8;
 }; /* HW DATA */
 
 struct mana_rdma_cqe {
diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 8cd2980d4..f25df2fad 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -71,7 +71,7 @@ int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	return err;
 }
 
-static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr)
+static int mana_ib_post_send_ud_one(struct mana_ib_qp *qp, const struct ib_ud_wr *wr)
 {
 	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
 	struct mana_ib_ah *ah = container_of(wr->ah, struct mana_ib_ah, ibah);
@@ -84,11 +84,8 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 	struct shadow_wqe_header *shadow_wqe;
 	int err, i;
 
-	if (!ndev) {
-		ibdev_dbg(&mdev->ib_dev, "Invalid port %u in QP %u\n",
-			  qp->port, qp->ibqp.qp_num);
+	if (!ndev)
 		return -EINVAL;
-	}
 
 	if (wr->wr.opcode != IB_WR_SEND)
 		return -EINVAL;
@@ -110,7 +107,7 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 
 	wqe_req.num_sge = wr->wr.num_sge + 1;
 	wqe_req.sgl = gdma_sgl;
-	wqe_req.inline_oob_size = sizeof(struct rdma_send_oob);
+	wqe_req.inline_oob_size = INLINE_OOB_LARGE_SIZE;
 	wqe_req.inline_oob_data = &send_oob;
 	wqe_req.flags = GDMA_WR_OOB_IN_SGL;
 	wqe_req.client_data_unit = ib_mtu_enum_to_int(ib_mtu_int_to_enum(ndev->mtu));
@@ -119,7 +116,7 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 	send_oob.fence = !!(wr->wr.send_flags & IB_SEND_FENCE);
 	send_oob.signaled = !!(wr->wr.send_flags & IB_SEND_SIGNALED);
 	send_oob.solicited = !!(wr->wr.send_flags & IB_SEND_SOLICITED);
-	send_oob.psn = qp->ud_qp.sq_psn;
+	send_oob.psn = qp->sq_psn;
 	send_oob.ssn_or_rqpn = wr->remote_qpn;
 	send_oob.ud_send.remote_qkey =
 		qp->ibqp.qp_type == IB_QPT_GSI ? IB_QP1_QKEY : wr->remote_qkey;
@@ -128,40 +125,51 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 	if (err)
 		return err;
 
-	qp->ud_qp.sq_psn++;
+	qp->sq_psn++;
 	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_sq);
 	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
-	shadow_wqe->send_opcode = IB_WC_SEND;
 	shadow_wqe->wr_id = wr->wr.wr_id;
 	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
 	shadow_queue_advance_producer(&qp->shadow_sq);
 
-	mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
 	return 0;
 }
 
-int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
-		      const struct ib_send_wr **bad_wr)
+static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *wr,
+				const struct ib_send_wr **bad_wr)
 {
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct gdma_queue *queue = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].kmem;
+	bool ring_sq = false;
 	int err = 0;
-	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 
 	for (; wr; wr = wr->next) {
-		switch (ibqp->qp_type) {
-		case IB_QPT_UD:
-		case IB_QPT_GSI:
-			err = mana_ib_post_send_ud(qp, ud_wr(wr));
-			if (unlikely(err)) {
-				*bad_wr = wr;
-				return err;
-			}
+		err = mana_ib_post_send_ud_one(qp, ud_wr(wr));
+		if (unlikely(err)) {
+			*bad_wr = wr;
 			break;
-		default:
-			ibdev_dbg(ibqp->device, "Posting send wr on qp type %u is not supported\n",
-				  ibqp->qp_type);
-			return -EINVAL;
 		}
+		ring_sq = true;
 	}
 
+	if (ring_sq)
+		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
+
 	return err;
 }
+
+int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
+		      const struct ib_send_wr **bad_wr)
+{
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+
+	switch (ibqp->qp_type) {
+	case IB_QPT_UD:
+	case IB_QPT_GSI:
+		return mana_ib_post_send_ud(qp, wr, bad_wr);
+	default:
+		/* Unsupported QP type */
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+}
-- 
2.43.0

