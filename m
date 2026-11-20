Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136967;
	b=W2udh1nO5cSLrbWwpuB3I0DrJkQ5yfPAxURT2iR/qJfo+PaeGKTlH+Uo6Kb87WmmWIVH
	 YiFwZ3ObFfV0DsTTtKDFgKW+2t7aAizOppTJC+5PGjZ7GiucTC5ztOkq5pZtDyOETIxQG
	 WKfnCudlOX5y75PYgagWZA84o8HXrb0HDqgObkufoz2TEuw2NMlR20O4RAe//TcULcHZD
	 QhJeaJazZca7OyvMLnaeb5Bik2Ax6n4Ambeav9nYMXyb33UJJxbKCnW68YQPMKG6qzDV1
	 A4hjZ1IWoHJ+t1NCf23yaY1/UgFNmXAuIq38Q5ta/DnCDSICdxgQsoyITs1Vs8dGbew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136967;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OvedSYQ7lUHjwd1/LqNlamBagWFIGuwSNrorzUM1QBg=;
	b=Cr4K5kesRkt86K70cxqOYwu0jTY2QyIf0P8ZumMHlUyjGXLkVTiBZN8Qo1BpD+dD8tDg
	 0hT3GHkJKQ29UU1xRjIFKe9gBqmPZMRBLQwqOg2+2D6JV2vvQlDStwZItXEJ2XU/0bLg8
	 I8MoL0p/2pNtcGJ1DJLM277Yiv2abOUTadqLSm+3K5NTlSOwsY0Z/tnJMgEzmZY+l6skB
	 DzA4f95kO8620u+WasPoVBZdygyUD7iAaAycbs5e+F6I13lllonvvqXMYuVKQdb0q9uoe
	 UfcTNIJ2Nc/5X7UX8iUecC4036GJh5/6ZccS1Zcqg9tDnhdkFHiBo7o7xX6ln6aseCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="KaQ/tSGF";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25436606A326;
	Fri, 20 Nov 2026 01:09:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25436606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=KaQ/tSGF
Received: by linux.microsoft.com (Postfix, from userid 1249)
	id 2666320B7169; Thu, 19 Nov 2026 17:09:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2666320B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795136965;
	bh=OvedSYQ7lUHjwd1/LqNlamBagWFIGuwSNrorzUM1QBg=;
	h=From:To:Cc:Subject:Date:From;
	b=KaQ/tSGFLnzknvAj4BW7+tLEN7ujzTsER1Ilgha19lAuv5uFf7KPGwhfVAuCmAHP7
	 7SpbPN7gpsopQrelU0wIjGtsCEoK4FqKHJ05XVnUmlqZXnkNhLrGt/sUOiOaAvqgc/
	 MUsiNylKsZ1avhRYxthQNbpM1PFNoGGGAeeVVNwg=
From: Snehal Sanghvi <snsanghvi@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: support enhanced connection establishment
Date: Thu, 19 Nov 2026 17:08:51 -0800
Message-ID: <20261120010851.616472-1-snsanghvi@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
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

From: Snehal Sanghvi <snsanghvi@microsoft.com>

Expose ECE when the firmware supports it. Return the firmware ECE offer
for RC and UC QPs, and use the RNIC set-state V4 layout for every modify
so that user ECE options reach the firmware and its current options are
returned; 0 means no update, and option bits are interpreted by the
firmware. Without firmware support, requests keep their legacy layout.

Reviewed-by: Konstantin Taranov <kotaranov@microsoft.com>
Signed-off-by: Snehal Sanghvi <snsanghvi@microsoft.com>
---
Matching rdma-core userspace implementation:
https://github.com/linux-rdma/rdma-core/pull/1866

 drivers/infiniband/hw/mana/main.c    | 12 +++++++--
 drivers/infiniband/hw/mana/mana_ib.h | 20 ++++++++++++---
 drivers/infiniband/hw/mana/qp.c      | 38 ++++++++++++++++++++--------
 include/uapi/rdma/mana-abi.h         | 15 +++++++++--
 4 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 8181b0cecd..75403e6bdf 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -250,6 +250,8 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 	ucmd_resp.comp_mask |= MANA_IB_UCNTX_RC_EXT_SUPPORT;
 	if (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT)
 		ucmd_resp.comp_mask |= MANA_IB_UCNTX_RC_SQ_POW2_SUPPORT;
+	if (mana_ib_ece_supported(mdev))
+		ucmd_resp.comp_mask |= MANA_IB_UCNTX_ECE_SUPPORT;
 	ret = ib_respond_udata(udata, ucmd_resp);
 	if (ret)
 		return ret;
@@ -1054,7 +1056,8 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 }
 
 int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
-			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags)
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags,
+			    u32 *ece_options)
 {
 	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
@@ -1092,11 +1095,14 @@ int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 		/* The GDMA regions are now owned by the RNIC QP handle */
 		qp->rc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
 	}
+	if (ece_options && mana_ib_ece_supported(mdev))
+		*ece_options = resp.ece_options;
 	return 0;
 }
 
 int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
-			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags)
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags,
+			    u32 *ece_options)
 {
 	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
@@ -1131,6 +1137,8 @@ int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 		/* The GDMA regions are now owned by the RNIC QP handle */
 		qp->uc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
 	}
+	if (mana_ib_ece_supported(mdev))
+		*ece_options = resp.ece_options;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index b7079af5d1..90e767d323 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -339,6 +339,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT = BIT(9),
 	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
 	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
+	MANA_IB_FEATURE_ECE_SUPPORT = BIT(19),
 };
 
 struct mana_ib_query_adapter_caps_resp {
@@ -476,7 +477,7 @@ struct mana_rnic_create_qp_resp {
 	struct gdma_resp_hdr hdr;
 	mana_handle_t rc_qp_handle;
 	u32 queue_ids[MANA_RC_QUEUE_TYPE_MAX];
-	u32 reserved;
+	u32 ece_options;
 }; /* HW Data*/
 
 struct mana_rnic_destroy_rnic_qp_req {
@@ -509,7 +510,7 @@ struct mana_rnic_create_uc_qp_resp {
 	struct gdma_resp_hdr hdr;
 	mana_handle_t qp_handle;
 	u32 queue_ids[MANA_UC_QUEUE_TYPE_MAX];
-	u32 reserved;
+	u32 ece_options;
 }; /* HW Data*/
 
 struct mana_rnic_create_udqp_req {
@@ -585,11 +586,15 @@ struct mana_rnic_set_qp_state_req {
 	u8 local_ack_timeout;
 	u8 max_rd_atomic;
 	u16 reserved2;
+	u32 mana_attr_mask;
+	u32 ece_options;
 	u32 reserved3;
 }; /* HW Data */
 
 struct mana_rnic_set_qp_state_resp {
 	struct gdma_resp_hdr hdr;
+	u32 ece_options;
+	u32 reserved;
 }; /* HW Data */
 
 enum WQE_OPCODE_TYPES {
@@ -913,6 +918,11 @@ static inline bool mana_ib_is_rnic(struct mana_ib_dev *mdev)
 	return mdev->gdma_dev->dev_id.type == GDMA_DEVICE_MANA_IB;
 }
 
+static inline bool mana_ib_ece_supported(struct mana_ib_dev *mdev)
+{
+	return mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_ECE_SUPPORT;
+}
+
 static inline struct net_device *mana_ib_get_netdev(struct ib_device *ibdev, u32 port)
 {
 	struct mana_ib_dev *mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
@@ -1046,10 +1056,12 @@ int mana_ib_gd_create_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq, u32 do
 int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq);
 
 int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
-			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags);
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags,
+			    u32 *ece_options);
 int mana_ib_gd_destroy_rnic_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp);
 int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
-			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags);
+			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags,
+			    u32 *ece_options);
 int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 			    struct ib_qp_init_attr *attr, u32 doorbell, u32 type);
 int mana_ib_gd_destroy_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 62980e0762..dec4a84f5c 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -656,7 +656,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 		qp->rc_qp.wqe_size_in_bu = wqe_size / GDMA_WQE_BU_SIZE;
 	}
 
-	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
+	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags, &resp.ece_options);
 	if (err) {
 		ibdev_err(&mdev->ib_dev, "Failed to create rc qp  %d\n", err);
 		goto destroy_queues;
@@ -720,7 +720,7 @@ static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 			goto destroy_queues;
 	}
 
-	err = mana_ib_gd_create_uc_qp(mdev, qp, attr, doorbell, flags);
+	err = mana_ib_gd_create_uc_qp(mdev, qp, attr, doorbell, flags, &resp.ece_options);
 	if (err)
 		goto destroy_queues;
 
@@ -920,7 +920,7 @@ static int mana_ib_create_rc_qp_kernel(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	if (err)
 		goto destroy_queues;
 
-	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
+	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags, NULL);
 	if (err)
 		goto deinit_queues;
 
@@ -996,18 +996,33 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 	struct mana_rnic_set_qp_state_resp resp = {};
 	struct mana_rnic_set_qp_state_req req = {};
+	struct mana_ib_modify_qp_resp uresp = {};
+	struct mana_ib_modify_qp ucmd = {};
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct mana_port_context *mpc;
 	struct net_device *ndev;
+	bool ece = mana_ib_ece_supported(mdev);
 	int err;
 
-	err = ib_no_udata_io(udata);
-	if (err)
-		return err;
+	if (udata && udata->inlen) {
+		err = ib_copy_validate_udata_in_cm(udata, ucmd, ece_options, 0);
+		if (err)
+			return err;
+	} else {
+		err = ib_no_udata_io(udata);
+		if (err)
+			return err;
+	}
 
-	mana_gd_init_req_hdr(&req.hdr, MANA_IB_SET_QP_STATE, sizeof(req), sizeof(resp));
+	/* ece_options 0 means no ECE update; only firmware with ECE gets V4. */
+	req.ece_options = ucmd.ece_options;
+	mana_gd_init_req_hdr(&req.hdr, MANA_IB_SET_QP_STATE,
+			     ece ? sizeof(req) : offsetofend(typeof(req), mana_attr_mask),
+			     ece ? sizeof(resp) : sizeof(resp.hdr));
 
-	req.hdr.req.msg_version = GDMA_MESSAGE_V3;
+	req.hdr.req.msg_version = ece ? GDMA_MESSAGE_V4 : GDMA_MESSAGE_V3;
+	if (ece)
+		req.hdr.resp.msg_version = GDMA_MESSAGE_V2;
 	req.hdr.dev_id = mdev->gdma_dev->dev_id;
 	req.adapter = mdev->adapter_handle;
 	req.qp_handle = qp->qp_handle;
@@ -1056,11 +1071,14 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		req.ah_attr.flow_label = attr->ah_attr.grh.flow_label;
 	}
 
-	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	err = mana_gd_send_request(gc, req.hdr.req.msg_size, &req, req.hdr.resp.msg_size, &resp);
 	if (err)
 		return err;
 
-	return 0;
+	if (!udata || !udata->inlen)
+		return 0;
+	uresp.ece_options = resp.ece_options;
+	return ib_respond_udata(udata, uresp);
 }
 
 static bool mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index ebc9a655b8..5149bd45ba 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -64,7 +64,17 @@ struct mana_ib_create_rc_qp {
 struct mana_ib_create_rc_qp_resp {
 	__u32 queue_id[4];
 	__u32 mmq_id;
-	__u32 reserved;
+	__u32 ece_options;
+};
+
+struct mana_ib_modify_qp {
+	__u32 comp_mask;
+	__u32 ece_options;
+};
+
+struct mana_ib_modify_qp_resp {
+	__u32 comp_mask;
+	__u32 ece_options;
 };
 
 struct mana_ib_create_uc_qp {
@@ -75,7 +85,7 @@ struct mana_ib_create_uc_qp {
 
 struct mana_ib_create_uc_qp_resp {
 	__u32 queue_id[3];
-	__u32 reserved;
+	__u32 ece_options;
 };
 
 struct mana_ib_create_wq {
@@ -112,6 +122,7 @@ enum mana_ib_ucontext_support {
 	MANA_IB_UCNTX_ALLOC_PDN_SUPPORT = 1 << 0,
 	MANA_IB_UCNTX_RC_EXT_SUPPORT = 1 << 1,
 	MANA_IB_UCNTX_RC_SQ_POW2_SUPPORT = 1 << 2,
+	MANA_IB_UCNTX_ECE_SUPPORT = 1 << 3,
 };
 
 struct mana_ib_alloc_ucontext_resp {

base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
