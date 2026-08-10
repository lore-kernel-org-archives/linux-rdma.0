Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377E2372045;
	Mon, 10 Aug 2026 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786353858; cv=none; b=lepKW1V7G2r/O8SZUxnVD5fPaa6YuQ5BvwMRWybCYKD9kAPmbQOVzt8Z1lhLrhVtWeIAA+2IVbhq3w1Y7CbWAZcpD6PyUHoFepgXoQCveOTt1DDdFQTGov0UbpOlpOmAGPPyEoaKc3U+fmn3ckRmUjZ8onJybnQ4u+8dgEnq1fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786353858; c=relaxed/simple;
	bh=49mvVW5CObpEZXd+j91x0jh+ridfmgaolGAy9puzawI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QoiZzJQyai/78OzeQzqxwxN+cVNdX2G+J6hQThH3yYUQW/8OlgqohDbq4JmCFrOCZGai2EKDJH3PiDQY5m7gMq0VTBXIoOm+kUCRg12WHXJOEUWZY2nUeajYSnRHnqL9AfRW0vVYYVJlfGZ6+sEkJ8En/qXbOWlVdYEe6/nK4Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AY87YLVs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AY87YLVs"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id D967620B7167; Mon, 10 Aug 2026 02:23:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D967620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786353832;
	bh=dNudia17MsRgAYyOF7f2N3pDythE3lGWz92E2SoToSY=;
	h=From:To:Cc:Subject:Date:From;
	b=AY87YLVsX03UPIxqMQqVSw2lozFFHanQhLj1Y9mZwdcd1KhZ49E2weJlqSa2Z7wBL
	 UTEnpZ3K+wHSsaP37+VZt5emTVNI0rtqQuPmxDJ33oAwAXi07QXDQY0mkIak75cSY7
	 TJT66CxKJyW7wnRkT1WsKMKx8mk5drBMFeRNfWBQ=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: Enable multi-port GSI QP support for mana_ib
Date: Mon, 10 Aug 2026 02:23:52 -0700
Message-ID: <20260810092352.2216082-1-kotaranov@linux.microsoft.com>
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
It is rebased on the series "RDMA/mana_ib: Extend MANA RC QP support for UAPI".
It can be also applied to the next, but there will be a trivial conflict on
adding a new bit to the enum mana_ib_adapter_features.
 drivers/infiniband/hw/mana/cq.c      | 26 +++++++++++++++++---------
 drivers/infiniband/hw/mana/main.c    | 28 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/mana/mana_ib.h | 15 +++++++++++++--
 drivers/infiniband/hw/mana/qp.c      | 17 ++++++++++++++++-
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d4e5e3f912689..6f9ac8b4aac8e 100644
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
index 57c6d9faaa81b..83a97f1c5caab 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -593,7 +593,11 @@ int mana_ib_get_port_immutable(struct ib_device *ibdev, u32 port_num,
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
@@ -671,10 +675,14 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
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
 
@@ -1138,6 +1146,7 @@ int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct mana_rnic_create_udqp_resp resp = {};
 	struct mana_rnic_create_udqp_req req = {};
+	struct net_device *ndev;
 	int err, i;
 
 	mana_gd_init_req_hdr(&req.hdr, MANA_IB_CREATE_UD_QP, sizeof(req), sizeof(resp));
@@ -1154,6 +1163,21 @@ int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
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
index 828ca75fd6845..1be33ed8bd3b8 100644
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
 
@@ -264,6 +268,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
 	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
 };
 
 struct mana_ib_query_adapter_caps_resp {
@@ -450,8 +455,14 @@ struct mana_rnic_create_udqp_req {
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
index 29bfee9ac997f..fac43b3a5eb7b 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -514,8 +514,20 @@ static int mana_table_store_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
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
@@ -534,6 +546,8 @@ static void mana_table_remove_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp
 
 	mana_table_remove_qp_qid(mdev, sq->id, true);
 	mana_table_remove_qp_qid(mdev, rq->id, false);
+	if (qp->ibqp.qp_type == IB_QPT_GSI)
+		mana_table_remove_qp_qid(mdev, (qp->port << 24) | MANA_GSI_QPN, false);
 	mana_table_drain_qp_ref(qp);
 }
 
@@ -751,7 +765,8 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
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

