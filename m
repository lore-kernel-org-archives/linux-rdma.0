Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856C130C16F;
	Wed, 12 Aug 2026 10:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786529158; cv=none; b=kiTLOJMvC5uuXDOH0AjOZFNnUVnid8eLg49KXNqdY6t9nfI1xyBWeuEt1DRQeJXugakEAQg0Luc9XG22dUnhUtpg3mdD4l66NKF4Rp7RZVQCbeDr/CxiiJofjP//6aPoY+uMRIvYll3e78jDVj44mMxin0bIoI3PXFbReIBVsUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786529158; c=relaxed/simple;
	bh=lKZC+V3RQRisArKL59FFCtfv8d8MdWeA3/qFxUuKQsE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L1U0XkhLWZ0l7gFXnJfiQ4tbdV1rAn7WUkELkJ2EOEtkuwX622eWNLU5Jpo70MZYQpsrtPM9pOgrwO0Xwi9+jTKs91tW6765xoubJzJO9HJ1pNqxHzRMVWLa+B0AW/COSGsvSwIaQFPeL+i6TupwUPodmpl2qBnEBg44AOr3Z/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jLGehwy4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jLGehwy4"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E805420B7168; Wed, 12 Aug 2026 03:05:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E805420B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786529131;
	bh=3V2VkDIoPwxH6EF0TbKVfDDlgFT/TzTRfVxo5rnYdD4=;
	h=From:To:Cc:Subject:Date:From;
	b=jLGehwy4yrMGXdEdu6mMqtjA2EpQvx9EwQCLs8Fq8EvTaETZ9sGhwPHywc3Qp+41o
	 DEz90U/yLlncdF7HRBsOVyTewAl76k7RGzUVTvZ+Lsq6tsQDJMydAr19Jm7V64m+tK
	 +WnZUo0QhrkUIRqH1F+zlMDn6SRP9V+me8rIKM10=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2] RDMA/mana_ib: Enable multi-port GSI QP support for mana_ib
Date: Wed, 12 Aug 2026 03:05:31 -0700
Message-ID: <20260812100531.2706494-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Snehal Sanghvi <snsanghvi@microsoft.com>

Add MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT so mana_ib can create a GSI QP
per IB port instead of just one. When the feature is negotiated, the port's
vNIC MAC is passed on GSI QP creation and each GSI QP is indexed in the QP
table by port so the GSI SQ drain can reach every port.

Also move MANA_SENDQ_MASK to BIT(0), freeing the top byte of the queue-id
key to index GSI QPs by port and scaling the feature to the full 8-bit port
range.

Signed-off-by: Snehal Sanghvi <snsanghvi@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v2: rebased on for-next
 drivers/infiniband/hw/mana/cq.c      | 26 +++++++++++++++++---------
 drivers/infiniband/hw/mana/main.c    | 28 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/mana/mana_ib.h | 16 ++++++++++++++--
 drivers/infiniband/hw/mana/qp.c      | 17 ++++++++++++++++-
 4 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d4e5e3f91..6f9ac8b4a 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -293,18 +293,12 @@ static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc
 	return wc_index;
 }
 
-void mana_drain_gsi_sqs(struct mana_ib_dev *mdev)
+static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
 {
-	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, MANA_GSI_QPN, false);
+	struct mana_ib_cq *cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct ud_sq_shadow_wqe *shadow_wqe;
-	struct mana_ib_cq *cq;
 	unsigned long flags;
 
-	if (!qp)
-		return;
-
-	cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
-
 	spin_lock_irqsave(&cq->cq_lock, flags);
 	while ((shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq))
 			!= NULL) {
@@ -315,8 +309,22 @@ void mana_drain_gsi_sqs(struct mana_ib_dev *mdev)
 
 	if (cq->ibcq.comp_handler)
 		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
 
-	mana_put_qp_ref(qp);
+void mana_drain_gsi_sqs(struct mana_ib_dev *mdev)
+{
+	struct mana_ib_qp *qp;
+	u32 port;
+
+	/* One GSI QP per port, indexed in the QP table by (port << 24 | MANA_GSI_QPN) */
+	for (port = 1; port <= mdev->ib_dev.phys_port_cnt; port++) {
+		qp = mana_get_qp_ref(mdev, (port << 24) | MANA_GSI_QPN, false);
+		if (!qp)
+			continue;
+
+		mana_drain_gsi_sq(qp);
+		mana_put_qp_ref(qp);
+	}
 }
 
 int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index e4414d208..5f86cde9d 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -592,7 +592,11 @@ int mana_ib_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
 	if (mana_ib_is_rnic(dev)) {
-		if (port_num == 1) {
+		bool port_supports_cm = (port_num == 1 ||
+			(dev->adapter_caps.feature_flags &
+			 MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT));
+
+		if (port_supports_cm) {
 			immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 			immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 		} else {
@@ -670,10 +674,14 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
 	ib_get_eth_speed(ibdev, port, &props->active_speed, &props->active_width);
 	props->pkey_tbl_len = 1;
 	if (mana_ib_is_rnic(dev)) {
+		bool port_supports_cm = (port == 1 ||
+			(dev->adapter_caps.feature_flags &
+			 MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT));
+
 		props->gid_tbl_len = 16;
 		props->ip_gids = true;
 		props->max_msg_sz = SZ_16M;
-		if (port == 1)
+		if (port_supports_cm)
 			props->port_cap_flags = IB_PORT_CM_SUP;
 	}
 
@@ -1134,6 +1142,7 @@ int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct mana_rnic_create_udqp_resp resp = {};
 	struct mana_rnic_create_udqp_req req = {};
+	struct net_device *ndev;
 	int err, i;
 
 	mana_gd_init_req_hdr(&req.hdr, MANA_IB_CREATE_UD_QP, sizeof(req), sizeof(resp));
@@ -1150,6 +1159,21 @@ int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 	req.max_send_sge = attr->cap.max_send_sge;
 	req.max_recv_sge = attr->cap.max_recv_sge;
 	req.qp_type = type;
+
+	/* For GSI QPs, pass the vNIC MAC so the SoC can associate the QP with
+	 * the correct port, transition to INIT, and allocate a per-port QPN.
+	 * MAC must be in reversed byte order.
+	 */
+	if (type == IB_QPT_GSI &&
+	    (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT)) {
+		ndev = mana_ib_get_netdev(&mdev->ib_dev, attr->port_num);
+		if (ndev) {
+			copy_in_reverse(req.mac, ndev->dev_addr, ETH_ALEN);
+			req.flags = MANA_UD_QP_FLAG_CREATE_IN_INIT;
+			req.hdr.req.msg_version = GDMA_MESSAGE_V2;
+		}
+	}
+
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index f69866696..fb9bc789b 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -24,8 +24,12 @@
 /* MANA doesn't have any limit for MR size */
 #define MANA_IB_MAX_MR_SIZE	U64_MAX
 
-/* Send queue ID mask */
-#define MANA_SENDQ_MASK	BIT(31)
+/*
+ * Send queue ID mask. Queue IDs are 2-bit aligned (see MANA_QID_SUBTYPE_MASK),
+ * so bit 0 is always free to tag send queues in the lookup table. This keeps
+ * the whole top byte available to index per-port GSI QPs by (port << 24).
+ */
+#define MANA_SENDQ_MASK	BIT(0)
 /* Queue ID encodes type in the lower 2 bits */
 #define MANA_QID_SUBTYPE_MASK 0x3
 
@@ -262,6 +266,8 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_CLIENT_ERROR_CQE_SUPPORT = BIT(4),
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
+	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
 };
 
 struct mana_ib_query_adapter_caps_resp {
@@ -445,8 +451,14 @@ struct mana_rnic_create_udqp_req {
 	u32 max_recv_wr;
 	u32 max_send_sge;
 	u32 max_recv_sge;
+	u8 mac[ETH_ALEN];     /* V2: port MAC for multi-port GSI */
+	u16 flags;            /* V2: MANA_UD_QP_FLAG_* */
 }; /* HW Data */
 
+enum mana_ud_qp_flags {
+	MANA_UD_QP_FLAG_CREATE_IN_INIT = BIT(0),
+};
+
 struct mana_rnic_create_udqp_resp {
 	struct gdma_resp_hdr hdr;
 	mana_handle_t qp_handle;
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 8b7be1255..cc3fc9093 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -509,8 +509,20 @@ static int mana_table_store_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 	if (err)
 		goto err_remove_sq;
 
+	/* GSI QPs are additionally indexed by (port << 24 | MANA_GSI_QPN) so the
+	 * per-port GSI SQ drain can find each of them by iterating ports.
+	 */
+	if (qp->ibqp.qp_type == IB_QPT_GSI) {
+		err = mana_table_store_qp_qid(mdev, qp,
+					      (qp->port << 24) | MANA_GSI_QPN, false);
+		if (err)
+			goto err_remove_rq;
+	}
+
 	return 0;
 
+err_remove_rq:
+	mana_table_remove_qp_qid(mdev, rq->id, false);
 err_remove_sq:
 	mana_table_remove_qp_qid(mdev, sq->id, true);
 	mana_table_drain_qp_ref(qp);
@@ -529,6 +541,8 @@ static void mana_table_remove_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp
 
 	mana_table_remove_qp_qid(mdev, sq->id, true);
 	mana_table_remove_qp_qid(mdev, rq->id, false);
+	if (qp->ibqp.qp_type == IB_QPT_GSI)
+		mana_table_remove_qp_qid(mdev, (qp->port << 24) | MANA_GSI_QPN, false);
 	mana_table_drain_qp_ref(qp);
 }
 
@@ -729,7 +743,8 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 		ibdev_err(&mdev->ib_dev, "Failed to create ud qp  %d\n", err);
 		goto destroy_shadow_queues;
 	}
-	qp->ibqp.qp_num = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
+	qp->ibqp.qp_num = (qp->ibqp.qp_type == IB_QPT_GSI) ?
+			  MANA_GSI_QPN : qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
 	qp->port = attr->port_num;
 
 	for (i = 0; i < MANA_UD_QUEUE_TYPE_MAX; ++i)
-- 
2.43.0

