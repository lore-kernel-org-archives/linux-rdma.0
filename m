Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC06477E2B;
	Thu, 23 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808012; cv=none; b=teZGU5nlwJo+1IwaKLBO47WT8mMPs5no0KU5YqaFCxuL3KYU2BsMuz5KpB7WP5mKy+OBt4YscN5jugdXWV0SHHmH99KOsHYu7gqBMRPOWVBGV+MKslInISLbqWYNn/hoRpbIg2+dtCcpQvBvTQHvELMgzGia0aNgIAfETxDXV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808012; c=relaxed/simple;
	bh=ESSBXUygvXpcqSj09XaLHoAt+2JBsOrlMHvQ18Oz7kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ3p6ncN5H/TQtCHouQI/k7AAlnKuW/ExPeJPeI90mecYn/0VOMTEdhW4nSusM/zX/PLhrOP32f9zZspoxyqtVz4X0kBwQ3hp1LF2n9lWollgNmju1uffS/Xzf0YnZkCLGGM0FvBO24MOwnOjZoSkVOieOL7nzlZHHxuS8D4KlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=segslTqR; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="segslTqR"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 72C5D20B7169; Thu, 23 Jul 2026 04:59:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 72C5D20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784807995;
	bh=+95kBx7K1r26ts8MmTzfPGxiDWovmrV86uozjMxFuo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=segslTqRNUhABetEQCaXl0qiV9ZwjUl1Ox5jU+Dl9599nKIvfA6jBYfHSWr9RJM44
	 gFccCyPoM+aSzxFWKbK2ZB9B0i1LWHnwh+7d8KrOafmeLm21NU40Y+lrU8m+GBVAmw
	 EbYA8R0xwJbrBTpiAJQsZtC+QKhbIqdhnKnQDCa4=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 2/2] RDMA/mana_ib: UC QP support for UAPI
Date: Thu, 23 Jul 2026 04:59:55 -0700
Message-ID: <20260723115955.1859519-3-kotaranov@linux.microsoft.com>
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

Implement UC QP creation in the RNIC HW for user API. An UC QP is exposed
as three work queues: send, receive, and memory management. The latter is
used for bind and invalidate WQEs to support memory windows.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v5: no changes
v4: renamed rc_qp destroy helper to rnic_qp. Use the latest robust udata API.
Use new store/lookup introduced in 1/2
v3: use new udata helpers
v2: removed udata check and removed enum from mana-abi.h
 drivers/infiniband/hw/mana/main.c    | 49 ++++++++++++++--
 drivers/infiniband/hw/mana/mana_ib.h | 53 ++++++++++++++++--
 drivers/infiniband/hw/mana/qp.c      | 84 +++++++++++++++++++++++++++-
 include/uapi/rdma/mana-abi.h         | 11 ++++
 4 files changed, 184 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 0bfb1883a..52feb474b 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -1046,16 +1046,55 @@ int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 	return 0;
 }
 
-int mana_ib_gd_destroy_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags)
 {
-	struct mana_rnic_destroy_rc_qp_resp resp = {0};
-	struct mana_rnic_destroy_rc_qp_req req = {0};
+	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
+	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
+	struct mana_ib_pd *pd = container_of(qp->ibqp.pd, struct mana_ib_pd, ibpd);
 	struct gdma_context *gc = mdev_to_gc(mdev);
+	struct mana_rnic_create_uc_qp_resp resp = {};
+	struct mana_rnic_create_uc_qp_req req = {};
+	int err, i;
 
-	mana_gd_init_req_hdr(&req.hdr, MANA_IB_DESTROY_RC_QP, sizeof(req), sizeof(resp));
+	mana_gd_init_req_hdr(&req.hdr, MANA_IB_CREATE_UC_QP, sizeof(req), sizeof(resp));
 	req.hdr.dev_id = mdev->gdma_dev->dev_id;
 	req.adapter = mdev->adapter_handle;
-	req.rc_qp_handle = qp->qp_handle;
+	req.pd_handle = pd->pd_handle;
+	req.send_cq_handle = send_cq->cq_handle;
+	req.recv_cq_handle = recv_cq->cq_handle;
+	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; i++)
+		req.dma_region[i] = qp->uc_qp.queues[i].gdma_region;
+	req.doorbell_page = doorbell;
+	req.max_send_wr = attr->cap.max_send_wr;
+	req.max_recv_wr = attr->cap.max_recv_wr;
+	req.max_send_sge = attr->cap.max_send_sge;
+	req.max_recv_sge = attr->cap.max_recv_sge;
+	req.flags = flags;
+
+	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err)
+		return err;
+
+	qp->qp_handle = resp.qp_handle;
+	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; i++) {
+		qp->uc_qp.queues[i].id = resp.queue_ids[i];
+		/* The GDMA regions are now owned by the RNIC QP handle */
+		qp->uc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
+	}
+	return 0;
+}
+
+int mana_ib_gd_destroy_rnic_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
+{
+	struct mana_rnic_destroy_rnic_qp_resp resp = {0};
+	struct mana_rnic_destroy_rnic_qp_req req = {0};
+	struct gdma_context *gc = mdev_to_gc(mdev);
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_IB_DESTROY_RNIC_QP, sizeof(req), sizeof(resp));
+	req.hdr.dev_id = mdev->gdma_dev->dev_id;
+	req.adapter = mdev->adapter_handle;
+	req.qp_handle = qp->qp_handle;
 
 	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 }
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 18688072f..f69866696 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -182,6 +182,17 @@ struct mana_ib_rc_qp {
 	struct mana_ib_queue queues[MANA_RC_QUEUE_TYPE_MAX];
 };
 
+enum mana_uc_queue_type {
+	MANA_UC_SEND_QUEUE_REQUESTER = 0,
+	MANA_UC_RECV_QUEUE_RESPONDER,
+	MANA_UC_SEND_QUEUE_MMQ,
+	MANA_UC_QUEUE_TYPE_MAX,
+};
+
+struct mana_ib_uc_qp {
+	struct mana_ib_queue queues[MANA_UC_QUEUE_TYPE_MAX];
+};
+
 enum mana_ud_queue_type {
 	MANA_UD_SEND_QUEUE = 0,
 	MANA_UD_RECV_QUEUE,
@@ -200,6 +211,7 @@ struct mana_ib_qp {
 	union {
 		struct mana_ib_queue raw_sq;
 		struct mana_ib_rc_qp rc_qp;
+		struct mana_ib_uc_qp uc_qp;
 		struct mana_ib_ud_qp ud_qp;
 	};
 
@@ -235,8 +247,9 @@ enum mana_ib_command_code {
 	MANA_IB_CREATE_CQ       = 0x30008,
 	MANA_IB_DESTROY_CQ      = 0x30009,
 	MANA_IB_CREATE_RC_QP    = 0x3000a,
-	MANA_IB_DESTROY_RC_QP   = 0x3000b,
+	MANA_IB_DESTROY_RNIC_QP = 0x3000b,
 	MANA_IB_SET_QP_STATE	= 0x3000d,
+	MANA_IB_CREATE_UC_QP    = 0x30020,
 	MANA_IB_QUERY_VF_COUNTERS = 0x30022,
 	MANA_IB_QUERY_DEVICE_COUNTERS = 0x30023,
 };
@@ -386,16 +399,39 @@ struct mana_rnic_create_qp_resp {
 	u32 reserved;
 }; /* HW Data*/
 
-struct mana_rnic_destroy_rc_qp_req {
+struct mana_rnic_destroy_rnic_qp_req {
 	struct gdma_req_hdr hdr;
 	mana_handle_t adapter;
-	mana_handle_t rc_qp_handle;
+	mana_handle_t qp_handle;
 }; /* HW Data */
 
-struct mana_rnic_destroy_rc_qp_resp {
+struct mana_rnic_destroy_rnic_qp_resp {
 	struct gdma_resp_hdr hdr;
 }; /* HW Data */
 
+struct mana_rnic_create_uc_qp_req {
+	struct gdma_req_hdr hdr;
+	mana_handle_t adapter;
+	mana_handle_t pd_handle;
+	mana_handle_t send_cq_handle;
+	mana_handle_t recv_cq_handle;
+	u64 dma_region[MANA_UC_QUEUE_TYPE_MAX];
+	u64 flags;
+	u32 doorbell_page;
+	u32 max_send_wr;
+	u32 max_recv_wr;
+	u32 max_send_sge;
+	u32 max_recv_sge;
+	u32 reserved;
+}; /* HW Data */
+
+struct mana_rnic_create_uc_qp_resp {
+	struct gdma_resp_hdr hdr;
+	mana_handle_t qp_handle;
+	u32 queue_ids[MANA_UC_QUEUE_TYPE_MAX];
+	u32 reserved;
+}; /* HW Data*/
+
 struct mana_rnic_create_udqp_req {
 	struct gdma_req_hdr hdr;
 	mana_handle_t adapter;
@@ -589,6 +625,8 @@ static inline struct mana_ib_queue *mana_qp_get_sq(struct mana_ib_qp *qp)
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
 		return &qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER];
+	case IB_QPT_UC:
+		return &qp->uc_qp.queues[MANA_UC_SEND_QUEUE_REQUESTER];
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return &qp->ud_qp.queues[MANA_UD_SEND_QUEUE];
@@ -602,6 +640,8 @@ static inline struct mana_ib_queue *mana_qp_get_rq(struct mana_ib_qp *qp)
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
 		return &qp->rc_qp.queues[MANA_RC_RECV_QUEUE_RESPONDER];
+	case IB_QPT_UC:
+		return &qp->uc_qp.queues[MANA_UC_RECV_QUEUE_RESPONDER];
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return &qp->ud_qp.queues[MANA_UD_RECV_QUEUE];
@@ -766,8 +806,9 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq);
 
 int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags);
-int mana_ib_gd_destroy_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp);
-
+int mana_ib_gd_destroy_rnic_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp);
+int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags);
 int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 			    struct ib_qp_init_attr *attr, u32 doorbell, u32 type);
 int mana_ib_gd_destroy_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 47e1fadbd..8b7be1255 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -597,13 +597,67 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	return 0;
 
 destroy_qp:
-	mana_ib_gd_destroy_rc_qp(mdev, qp);
+	mana_ib_gd_destroy_rnic_qp(mdev, qp);
 destroy_queues:
 	while (i-- > 0)
 		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
 	return err;
 }
 
+static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
+				struct ib_qp_init_attr *attr, struct ib_udata *udata)
+{
+	struct mana_ib_dev *mdev = container_of(ibpd->device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	struct mana_ib_create_uc_qp_resp resp = {};
+	struct mana_ib_ucontext *mana_ucontext;
+	struct mana_ib_create_uc_qp ucmd;
+	u64 flags = 0;
+	u32 doorbell;
+	int err, i;
+
+	if (!udata)
+		return -EINVAL;
+
+	mana_ucontext = rdma_udata_to_drv_context(udata, struct mana_ib_ucontext, ibucontext);
+	doorbell = mana_ucontext->doorbell;
+	err = ib_copy_validate_udata_in_cm(udata, ucmd, comp_mask, 0);
+	if (err)
+		return err;
+
+	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i) {
+		err = mana_ib_create_queue(mdev, ucmd.queue_buf[i], ucmd.queue_size[i],
+					   &qp->uc_qp.queues[i]);
+		if (err)
+			goto destroy_queues;
+	}
+
+	err = mana_ib_gd_create_uc_qp(mdev, qp, attr, doorbell, flags);
+	if (err)
+		goto destroy_queues;
+
+	qp->ibqp.qp_num = qp->uc_qp.queues[MANA_UC_RECV_QUEUE_RESPONDER].id;
+	qp->port = attr->port_num;
+
+	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
+		resp.queue_id[i] = qp->uc_qp.queues[i].id;
+
+	err = ib_respond_udata(udata, resp);
+	if (err)
+		goto destroy_qp;
+
+	err = mana_table_store_qp(mdev, qp);
+	if (err)
+		goto destroy_qp;
+	return 0;
+destroy_qp:
+	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+destroy_queues:
+	while (i-- > 0)
+		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
+	return err;
+}
+
 static void mana_add_qp_to_cqs(struct mana_ib_qp *qp)
 {
 	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
@@ -713,6 +767,8 @@ int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		return mana_ib_create_qp_raw(ibqp, ibqp->pd, attr, udata);
 	case IB_QPT_RC:
 		return mana_ib_create_rc_qp(ibqp, ibqp->pd, attr, udata);
+	case IB_QPT_UC:
+		return mana_ib_create_uc_qp(ibqp, ibqp->pd, attr, udata);
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return mana_ib_create_ud_qp(ibqp, ibqp->pd, attr, udata);
@@ -803,6 +859,7 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	switch (ibqp->qp_type) {
 	case IB_QPT_RC:
+	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
@@ -908,13 +965,34 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 	/* Ignore return code as there is not much we can do about it.
 	 * The error message is printed inside.
 	 */
-	mana_ib_gd_destroy_rc_qp(mdev, qp);
+	mana_ib_gd_destroy_rnic_qp(mdev, qp);
 	for (i = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i)
 		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
 
 	return 0;
 }
 
+static int mana_ib_destroy_uc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
+{
+	struct mana_ib_dev *mdev =
+		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	int i, err;
+
+	err = ib_no_udata_io(udata);
+	if (err)
+		return err;
+
+	mana_table_remove_qp(mdev, qp);
+	/* Ignore return code as there is not much we can do about it.
+	 * The error message is printed inside.
+	 */
+	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
+		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
+
+	return 0;
+}
+
 static int mana_ib_destroy_ud_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 {
 	struct mana_ib_dev *mdev =
@@ -954,6 +1032,8 @@ int mana_ib_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		return mana_ib_destroy_qp_raw(qp, udata);
 	case IB_QPT_RC:
 		return mana_ib_destroy_rc_qp(qp, udata);
+	case IB_QPT_UC:
+		return mana_ib_destroy_uc_qp(qp, udata);
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return mana_ib_destroy_ud_qp(qp, udata);
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index 8336bf51b..169bf91b3 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -57,6 +57,17 @@ struct mana_ib_create_rc_qp_resp {
 	__u32 queue_id[4];
 };
 
+struct mana_ib_create_uc_qp {
+	__aligned_u64 queue_buf[3];
+	__u32 queue_size[3];
+	__u32 comp_mask;
+};
+
+struct mana_ib_create_uc_qp_resp {
+	__u32 queue_id[3];
+	__u32 reserved;
+};
+
 struct mana_ib_create_wq {
 	__aligned_u64 wq_buf_addr;
 	__u32 wq_buf_size;
-- 
2.43.0

