Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999CD3DB339;
	Sat, 10 Oct 2026 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615291; cv=none; b=ZS+pdXxyMIcEeKhw1TXqnpeghdnzPjwiyJsIz+bYjVWTFezG/dryUrANvop3DG0IHCMFEoaGl2NPC5rnzy29CzVxHMZPWjQL9+XH6ets8HP6wHoGsQY83wiS2bG0044G/wSYWvXwO55igjD4QZDzduR8MzbqISS1TY224gFDizQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615291; c=relaxed/simple;
	bh=BZwtYSc3wGLGLOQ0/G5jZ8zzkq8QhpI7DZA470y4gRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILgIQw5ginxPBjA9TW44ekrTiT6Wgz+M+UVRdzw4D9DUqoh6SwlM+0TzricM/f4+N0lvsqnup8j4EVey/EL5QoL+oc1GiHinC30YYfTGGGl3ACgcT3nBFVLHqyoXq52j64Axanis+1zkzkC6OfuYwgQJXMDcaf4y/e0sepGIEbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cimu1yF5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cimu1yF5"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id EE3FB20B716D; Fri,  9 Oct 2026 23:54:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EE3FB20B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791615283;
	bh=Qy/iZEXfXTjvEfhzT1uRHu+cKOl8LO/w1B3KvSZvDRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cimu1yF56BTB5lrrjoQFo9Zk6VvtswJmIwhnTl3ESYYZHUFpDpKUqsRre+CQXSioT
	 1tVeJ6Xw2SvgQg+MwebZd5NtWEcT8bra6sT0H95CruNum7NcReHoVCMAT00521O64s
	 rjWLF6CaT93vYVkiAA82VzbYYeGl/PPCpWpQBK80=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 06/10] RDMA/mana_ib: Post send and memory-management WRs on RC QPs
Date: Fri,  9 Oct 2026 23:54:39 -0700
Message-ID: <20261010065443.3554193-7-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement send work request posting for RC QPs. Post communication WRs
to the send queue and memory WRs to the memory management queue.

Advertise the memory management extensions on adapters that support
extended WQEs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c    |   2 +
 drivers/infiniband/hw/mana/mana_ib.h |   1 +
 drivers/infiniband/hw/mana/wr.c      | 348 +++++++++++++++++++++++++++
 3 files changed, 351 insertions(+)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index f54905764f59..775b3cca8ec4 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -632,6 +632,8 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
 	props->max_qp = dev->adapter_caps.max_qp_count;
 	props->max_qp_wr = dev->adapter_caps.max_qp_wr;
 	props->device_cap_flags = IB_DEVICE_RC_RNR_NAK_GEN;
+	if (dev->adapter_caps.feature_flags & MANA_IB_FEATURE_EXTENDED_WQE_FORMAT)
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	props->max_send_sge = dev->adapter_caps.max_send_sge_count;
 	props->max_recv_sge = dev->adapter_caps.max_recv_sge_count;
 	props->max_sge_rd = dev->adapter_caps.max_recv_sge_count;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 1094429af801..f7cc9abeb071 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -325,6 +325,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
 	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_FMR_IN_OOB_SUPPORT = BIT(8),
 	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
 	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
 	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 5d42af91fce4..6cc67537c655 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -7,6 +7,71 @@
 
 #define MAX_WR_SGL_NUM (2)
 
+static inline u32 mana_count_packets(u32 msg_size, enum ib_mtu mtu)
+{
+	return (msg_size - !!msg_size) >> (mtu + 7);
+}
+
+static inline bool wr_is_mmq(enum ib_wr_opcode opcode)
+{
+	switch (opcode) {
+	case IB_WR_LOCAL_INV:
+	case IB_WR_REG_MR:
+	case IB_WR_REG_MR_INTEGRITY:
+	case IB_WR_BIND_MW:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline u8 convert_wr_to_wc(enum ib_wr_opcode opcode)
+{
+	switch (opcode) {
+	case IB_WR_SEND_WITH_IMM:
+	case IB_WR_SEND_WITH_INV:
+	case IB_WR_SEND:
+		return IB_WC_SEND;
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+	case IB_WR_RDMA_WRITE:
+		return IB_WC_RDMA_WRITE;
+	case IB_WR_RDMA_READ:
+		return IB_WC_RDMA_READ;
+	case IB_WR_LOCAL_INV:
+		return IB_WC_LOCAL_INV;
+	case IB_WR_BIND_MW:
+		return IB_WC_BIND_MW;
+	case IB_WR_REG_MR:
+		return IB_WC_REG_MR;
+	default:
+		return 0;
+	}
+}
+
+static inline u8 convert_wr_to_hw_opcode(enum ib_wr_opcode opcode)
+{
+	switch (opcode) {
+	case IB_WR_RDMA_WRITE:
+		return WQE_TYPE_WRITE;
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		return WQE_TYPE_WRITE_IMM;
+	case IB_WR_SEND:
+		return WQE_TYPE_RC_SEND;
+	case IB_WR_SEND_WITH_IMM:
+		return WQE_TYPE_RC_SEND_IMM;
+	case IB_WR_SEND_WITH_INV:
+		return WQE_TYPE_RC_SEND_INV;
+	case IB_WR_LOCAL_INV:
+		return WQE_TYPE_LOCAL_INV;
+	case IB_WR_RDMA_READ:
+		return WQE_TYPE_READ;
+	case IB_WR_REG_MR:
+		return WQE_TYPE_REG_MR;
+	default:
+		return 0;
+	}
+}
+
 static int mana_ib_post_rq(struct mana_ib_qp *qp, const struct ib_recv_wr *wr)
 {
 	struct ib_sge mana_ib_dummy_sge = {.addr = 1, .length = 0, .lkey = 0};
@@ -224,6 +289,287 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *
 	return err;
 }
 
+static int mana_ib_post_sq(struct mana_ib_qp *qp, const struct ib_send_wr *wr)
+{
+	struct gdma_queue *sq = qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER].kmem;
+	struct ib_sge mana_ib_dummy_sge = {.addr = 1, .length = 0, .lkey = 0};
+	struct gdma_posted_wqe_info wqe_info = {0};
+	struct gdma_wqe_request wqe_req = {0};
+	struct rdma_send_oob send_oob = {0};
+	struct shadow_wqe_header *shadow_wqe;
+	bool signaled = qp->sq_sig_all || (wr->send_flags & IB_SEND_SIGNALED);
+	u32 msg_sz = 0;
+	int err, i;
+
+	if (shadow_queue_full(&qp->shadow_sq))
+		return -ENOMEM;
+
+	if (wr->num_sge > MAX_TX_WQE_SGL_ENTRIES)
+		return -EINVAL;
+
+	for (i = 0; i < wr->num_sge; i++)
+		msg_sz += wr->sg_list[i].length;
+
+	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_sq);
+	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
+
+	wqe_req.num_sge = wr->num_sge;
+	wqe_req.ib_sgl = wr->sg_list;
+	wqe_req.flags = GDMA_WR_IB_SGL;
+
+	if (wr->num_sge == 0) {
+		wqe_req.ib_sgl = &mana_ib_dummy_sge;
+		wqe_req.num_sge = 1;
+	}
+
+	if (wr->opcode == IB_WR_RDMA_READ) {
+		struct gdma_queue *rq = qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
+		struct rdma_recv_oob recv_oob = {0};
+
+		recv_oob.psn_start = qp->sq_psn;
+		recv_oob.msn = qp->sq_ssn;
+
+		wqe_req.inline_oob_size = INLINE_OOB_SMALL_SIZE;
+		wqe_req.inline_oob_data = &recv_oob;
+		wqe_req.flags |= GDMA_WR_CHECK_SN;
+
+		err = mana_gd_post_work_request(rq, &wqe_req, &wqe_info);
+		if (err)
+			return err;
+
+		/* For reads we store the WQE size of the receive WQE */
+		shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
+
+		/* SQ WQE for read uses dummy SGE */
+		wqe_req.num_sge = 1;
+		wqe_req.ib_sgl = &mana_ib_dummy_sge;
+		wqe_req.flags = GDMA_WR_IB_SGL;
+	}
+
+	wqe_req.inline_oob_size = INLINE_OOB_EXTRA_LARGE_SIZE;
+	wqe_req.inline_oob_data = &send_oob;
+	wqe_req.client_data_unit = ib_mtu_enum_to_int(qp->mtu);
+	wqe_req.flags |= GDMA_WR_GENERATION_1;
+	wqe_req.wqe_size_in_bu = qp->rc_qp.wqe_size_in_bu;
+
+	send_oob.wqe_type = convert_wr_to_hw_opcode(wr->opcode);
+	send_oob.signaled = signaled;
+	send_oob.solicited = !!(wr->send_flags & IB_SEND_SOLICITED);
+	send_oob.psn = qp->sq_psn;
+	send_oob.ssn_or_rqpn = qp->sq_ssn;
+
+	if (qp->pending_mmq_fence) {
+		/* set local fence */
+		send_oob.fence = 1;
+		send_oob.fsn = qp->sq_fsn;
+		wqe_req.flags |= GDMA_WR_FENCE;
+	}
+
+	if (wr->send_flags & IB_SEND_FENCE) {
+		/* add remote fence */
+		if (qp->pending_mmq_fence)
+			wqe_req.flags |= GDMA_WR_FENCE_EXTENDED;
+		else
+			wqe_req.flags |= GDMA_WR_FENCE;
+	}
+
+	switch (wr->opcode) {
+	case IB_WR_SEND_WITH_INV:
+		send_oob.rc_send.invalidate_key = wr->ex.invalidate_rkey;
+		wqe_req.flags |= GDMA_WR_CHECK_SN;
+		break;
+	case IB_WR_SEND_WITH_IMM:
+		send_oob.rc_send.immediate = cpu_to_le32(be32_to_cpu(wr->ex.imm_data));
+		fallthrough;
+	case IB_WR_SEND:
+		wqe_req.flags |= GDMA_WR_CHECK_SN;
+		break;
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		send_oob.immediate_ext = cpu_to_le32(be32_to_cpu(wr->ex.imm_data));
+		fallthrough;
+	case IB_WR_RDMA_WRITE:
+	case IB_WR_RDMA_READ:
+		send_oob.rdma.address_hi = upper_32_bits(rdma_wr(wr)->remote_addr);
+		send_oob.rdma.address_low = lower_32_bits(rdma_wr(wr)->remote_addr);
+		send_oob.rdma.rkey = rdma_wr(wr)->rkey;
+		send_oob.rdma.dma_len = msg_sz;
+		if (wr->opcode == IB_WR_RDMA_READ) {
+			send_oob.read.rsn = qp->sq_rsn;
+			wqe_req.flags |= GDMA_WR_CHECK_RSN;
+		} else {
+			wqe_req.flags |= GDMA_WR_CHECK_SN;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = mana_gd_post_work_request(sq, &wqe_req, &wqe_info);
+	if (err)
+		return err;
+
+	shadow_wqe->wr_id = wr->wr_id;
+	shadow_wqe->send_opcode = convert_wr_to_wc(wr->opcode);
+	if (!signaled)
+		shadow_wqe->flags |= MANA_WQ_NO_SIGNAL_WC;
+	else if ((wr->send_flags & IB_SEND_FENCE) || qp->pending_mmq_fence)
+		shadow_wqe->flags |= MANA_WQ_FENCE_WC;
+	shadow_wqe->wqe_offset_or_psn = qp->sq_psn + mana_count_packets(msg_sz, qp->mtu);
+	shadow_wqe->fsn = qp->sq_fsn - 1;
+	shadow_queue_advance_producer(&qp->shadow_sq);
+
+	qp->pending_mmq_fence = false;
+	qp->sq_psn = shadow_wqe->wqe_offset_or_psn + 1;
+	qp->sq_ssn++;
+	if (wr->opcode == IB_WR_RDMA_READ)
+		qp->sq_rsn++;
+
+	return 0;
+}
+
+static u8 mana_ib_fmr_access_flags(int ib_access_flags)
+{
+	u8 access = mana_ib_verbs_to_gdma_access_flags(ib_access_flags);
+
+	return (access | GDMA_ACCESS_FLAG_INVALIDATE | GDMA_ACCESS_FLAG_FMR);
+}
+
+static void mana_ib_build_fmr_payload(const struct ib_reg_wr *wr, struct ib_sge *sge)
+{
+	struct mana_ib_mr *mr = container_of(wr->mr, struct mana_ib_mr, ibmr);
+	u8 access = mana_ib_fmr_access_flags(wr->access);
+	u8 *mst_base = (u8 *)mr->fmr.ptes;
+	struct mana_fmr_mst_entry *mst;
+
+	mst = (struct mana_fmr_mst_entry *)(mst_base +
+		mana_ib_fmr_header_offset(mr->fmr.pte_count));
+	memset(mst, 0, sizeof(struct mana_fmr_mst_entry));
+	mst->access_right = access;
+	mst->addr_type = GDMA_MR_TYPE_GVA;
+	mst->start_va = wr->mr->iova;
+	mst->length = wr->mr->length;
+	mst->page_size = order_base_2(wr->mr->page_size) - MANA_PAGE_SHIFT;
+
+	sge->addr = mr->fmr.dma_handle;
+	sge->lkey = mr->ibmr.pd->local_dma_lkey;
+	sge->length = mana_ib_fmr_buf_sz(mr->fmr.pte_count);
+}
+
+static int mana_ib_post_mmq(struct mana_ib_qp *qp, const struct ib_send_wr *wr)
+{
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct gdma_queue *queue = qp->rc_qp.queues[MANA_RC_SEND_QUEUE_MMQ].kmem;
+	struct ib_sge sge = {.addr = 1, .length = 0, .lkey = 0};
+	struct gdma_posted_wqe_info wqe_info = {0};
+	struct gdma_wqe_request wqe_req = {0};
+	struct rdma_send_oob send_oob = {0};
+	struct shadow_wqe_header *shadow_wqe;
+	bool signaled = qp->sq_sig_all || (wr->send_flags & IB_SEND_SIGNALED);
+	int ret;
+
+	if (shadow_queue_full(&qp->shadow_mmq))
+		return -ENOMEM;
+
+	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_mmq);
+	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
+
+	wqe_req.num_sge = 1;
+	wqe_req.ib_sgl = &sge;
+	wqe_req.flags = GDMA_WR_IB_SGL;
+
+	wqe_req.inline_oob_size = INLINE_OOB_EXTRA_LARGE_SIZE;
+	wqe_req.inline_oob_data = &send_oob;
+	wqe_req.client_data_unit = 0;
+	wqe_req.flags |= GDMA_WR_GENERATION_1;
+
+	send_oob.wqe_type = convert_wr_to_hw_opcode(wr->opcode);
+	send_oob.psn = qp->sq_fsn;
+	send_oob.ssn_or_rqpn = qp->sq_ssn;
+	send_oob.fsn = qp->sq_psn;
+	send_oob.signaled = signaled;
+
+	if (wr->send_flags & IB_SEND_FENCE)
+		wqe_req.flags |= GDMA_WR_FENCE | GDMA_WR_FENCE_EXTENDED;
+
+	switch (wr->opcode) {
+	case IB_WR_LOCAL_INV:
+		send_oob.mm.mkey = wr->ex.invalidate_rkey;
+		break;
+	case IB_WR_REG_MR:
+		send_oob.mm.mkey = reg_wr(wr)->key;
+		mana_ib_build_fmr_payload(reg_wr(wr), &sge);
+		if (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_FMR_IN_OOB_SUPPORT)
+			wqe_req.flags |= GDMA_WR_OOB_IN_SGL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = mana_gd_post_work_request(queue, &wqe_req, &wqe_info);
+	if (ret)
+		return ret;
+
+	shadow_wqe->wr_id = wr->wr_id;
+	shadow_wqe->send_opcode = convert_wr_to_wc(wr->opcode);
+	if (!signaled)
+		shadow_wqe->flags |= MANA_WQ_NO_SIGNAL_WC;
+	else if (wr->send_flags & IB_SEND_FENCE)
+		shadow_wqe->flags |= MANA_WQ_FENCE_WC;
+	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
+	shadow_wqe->wqe_offset_or_psn = qp->sq_psn - 1;
+	shadow_wqe->fsn = qp->sq_fsn;
+
+	shadow_queue_advance_producer(&qp->shadow_mmq);
+
+	qp->sq_fsn++;
+	qp->pending_mmq_fence = true;
+
+	return 0;
+}
+
+static int mana_ib_post_send_rc(struct mana_ib_qp *qp, const struct ib_send_wr *wr,
+				const struct ib_send_wr **bad_wr)
+{
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	bool ring_mmq = false, ring_sq = false, ring_rq = false;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&qp->sq_lock, flags);
+
+	for (; wr; wr = wr->next) {
+		if (wr_is_mmq(wr->opcode)) {
+			err = mana_ib_post_mmq(qp, wr);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				break;
+			}
+			ring_mmq = true;
+		} else {
+			err = mana_ib_post_sq(qp, wr);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				break;
+			}
+			if (wr->opcode == IB_WR_RDMA_READ)
+				ring_rq = true;
+			ring_sq = true;
+		}
+	}
+	if (ring_rq)
+		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev),
+					 qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem);
+	if (ring_mmq)
+		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev),
+					 qp->rc_qp.queues[MANA_RC_SEND_QUEUE_MMQ].kmem);
+	if (ring_sq)
+		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev),
+					 qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER].kmem);
+
+	spin_unlock_irqrestore(&qp->sq_lock, flags);
+	return err;
+}
+
 int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr)
 {
@@ -233,6 +579,8 @@ int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return mana_ib_post_send_ud(qp, wr, bad_wr);
+	case IB_QPT_RC:
+		return mana_ib_post_send_rc(qp, wr, bad_wr);
 	default:
 		/* Unsupported QP type */
 		*bad_wr = wr;

-- 
2.43.0
