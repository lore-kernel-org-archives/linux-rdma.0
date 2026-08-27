Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E0447D92D;
	Thu, 27 Aug 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841502; cv=none; b=q9uBhT1TYOCcZ+1rdhbwbGeB386vJO1fZRfZqgZKKOIdfxQoq708BDIvQE8zuPjRDHclcIufN0lRDkHWDD7UUb3FAL/ApfYO2uIAmEqaWC4MYC4cMUihzn74+IP+suyFYQcG1R/6qTTJQvfREtt+A1r7NMTnSUgXeTULe3yoPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841502; c=relaxed/simple;
	bh=+AQVj0DHmwJ4lXH2/80JCwdp5xzgGHv+Z8WyfXY2AEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV7SqQiacs1U7Xw+pSIsiDiOdxzL30bSPgRy73EpMDC2OODTVnY8IKXZsNLdp8Rc6viKIpUQyfs1zRRtRz4ZVQEjejUpWCF5dpej+QgtkOpZq9RD12Gudlm+nvKwKw54Bb1wuVIDoz9sC8l9rKDPGJ8fNj5t0eBqsxWMN3MFqWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=d2wVGB0u; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="d2wVGB0u"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id BA7B720B7128; Thu, 27 Aug 2026 07:37:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BA7B720B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787841456;
	bh=rtNZKK9c3kxVe1/fuCoyNrVgTgZcyR3ViP5DXM1y5Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2wVGB0un7diIHZkfA/oc2xS3M3VNkQdahOwn2vpHYyr8OB7i4/NaLIp3hiLcJppk
	 nicCjKF9rFj5a7C/lIOlJEFGMq4htq0TxFURoF63VpyECKp+lFsqtafMUwPP64/dvG
	 MpXF+nf5z1gCmzYEM7Rhg8egszFkqlmbgggrtaJY=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 3/3] RDMA/mana_ib: fixed send wqe size support for RC QPs
Date: Thu, 27 Aug 2026 07:37:36 -0700
Message-ID: <20260827143736.2013093-4-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Support fixed-size send WQEs for RC QPs when requested by userspace.
Calculate the WQE size from the maximum send SGE count and the 32-byte
inline OOB size, round it up to a power of two, and pass the size to
hardware in basic units.

When supported by the adapter, also enable placing the message sequence
number in the WQE. Preserve the existing variable-size WQE behavior when
userspace does not request fixed-size WQEs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c    |  3 +++
 drivers/infiniband/hw/mana/mana_ib.h |  5 ++++-
 drivers/infiniband/hw/mana/qp.c      | 14 ++++++++++++++
 include/net/mana/gdma.h              |  1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 9d043f48e..57c6d9faa 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -1060,6 +1060,9 @@ int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
 	req.max_recv_sge = attr->cap.max_recv_sge;
 	req.flags = flags;
 
+	if (flags & MANA_RC_FLAG_FIXED_SIZE_WQE)
+		req.wqe_size_in_bu = qp->rc_qp.wqe_size_in_bu;
+
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 547ddf9dd..828ca75fd 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -180,6 +180,7 @@ enum mana_rc_queue_type {
 
 struct mana_ib_rc_qp {
 	struct mana_ib_queue queues[MANA_RC_QUEUE_TYPE_MAX];
+	u32 wqe_size_in_bu;
 };
 
 enum mana_uc_queue_type {
@@ -262,6 +263,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_CLIENT_ERROR_CQE_SUPPORT = BIT(4),
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
+	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
 };
 
 struct mana_ib_query_adapter_caps_resp {
@@ -391,7 +393,8 @@ struct mana_rnic_create_qp_req {
 	u32 max_recv_wr;
 	u32 max_send_sge;
 	u32 max_recv_sge;
-	u32 reserved;
+	u8 wqe_size_in_bu;
+	u8 reserved[3];
 }; /* HW Data */
 
 struct mana_rnic_create_qp_resp {
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index c6821ae5f..29bfee9ac 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -422,6 +422,11 @@ static u32 mana_ib_wqe_size(u32 sge, u32 oob_size)
 	return ALIGN(wqe_size, GDMA_WQE_BU_SIZE);
 }
 
+static u32 mana_ib_fixed_wqe_size(u32 sge, u32 oob_size)
+{
+	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
+}
+
 static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_type)
 {
 	u32 queue_size;
@@ -576,6 +581,15 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 		j++;
 	}
 
+	if (ucmd.comp_mask & MANA_IB_RC_QP_FIXED_WQE) {
+		u32 wqe_size = mana_ib_fixed_wqe_size(attr->cap.max_send_sge,
+						      INLINE_OOB_EXTRA_LARGE_SIZE);
+		flags |= MANA_RC_FLAG_FIXED_SIZE_WQE;
+		if (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT)
+			flags |= MANA_RC_FLAG_MSN_IN_WQE;
+		qp->rc_qp.wqe_size_in_bu = wqe_size / GDMA_WQE_BU_SIZE;
+	}
+
 	err = mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
 	if (err) {
 		ibdev_err(&mdev->ib_dev, "Failed to create rc qp  %d\n", err);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index de17c9bba..f3601ca78 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -522,6 +522,7 @@ struct gdma_wqe {
 
 #define INLINE_OOB_SMALL_SIZE 8
 #define INLINE_OOB_LARGE_SIZE 24
+#define INLINE_OOB_EXTRA_LARGE_SIZE 32
 
 #define MANA_MAX_TX_WQE_SGL_ENTRIES 30
 
-- 
2.43.0

