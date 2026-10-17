Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFFB3E4111;
	Sat, 17 Oct 2026 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219460; cv=none; b=fdfZ88E2m9HFJt+vda06VRvfakt8qPz5D5tfhqy8fV6rWIeN48lvr4/NfcSBvq2ERz25Ue0lnaHXwshqgmI4KILOlMaME5fsBFD1Fvt071gz+k0IMKFKgRLlFjxeDvMmQ1kKlOOLgsljvKmIfHVDCQszyWC9dgH1Ba2RLqQaczA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219460; c=relaxed/simple;
	bh=4kO0KgQgTUyLX5DNKaqaxZkmXsWAkNYRHxrRUJoIpA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo845KLTQMznw3Z86NsF//pEGCDJtBvzmp/LUEZDTFOaI8FQy1uvyBUpK2g0gYUWjHcsU+zYLz5I3SUoLw3URPEVeK1mgB9mEtMsggz7ZqDOIBni5WRngotd/eO855m7sBOPBRe4CiKnuoByP5sBqPKpe0/g9lPmXgZNSNDMSCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=flv3+S6c; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="flv3+S6c"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 5679320B716C; Fri, 16 Oct 2026 23:44:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5679320B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792219453;
	bh=BvCUaVWI470iqdjXZh7SP+GUw9ziFNuq/JVw8WpCJEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flv3+S6cnDQRbU6Z5qM2mRDPEYlrDKM31PV07nQhYAGBA85GmJ6Lvv1n7kPutVCMC
	 uagUWKCydT7ZwKXUlRgmsA96icLNQorqIq+Gb76AX7Eb81FuDiREIZY6frHhD5vhZ/
	 tSnd8qqrlSDN1G2c0D7pjxQZ4+sNKUmlG4sk7AtM=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 03/10] net/mana: Extend GDMA encoding for new RDMA WQEs
Date: Fri, 16 Oct 2026 23:44:06 -0700
Message-ID: <20261017064413.995985-4-kotaranov@linux.microsoft.com>
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

Extend mana_gd_post_work_request() to support extra-large OOB data and
fixed-size WQEs. These formats are supported only for power-of-two WQE
sizes.

For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
the WQE header fields required by RC QPs based on the WR flags.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v2:
- Reject fixed WQEs that cannot fit the header, aligned OOB and SGEs.

 .../net/ethernet/microsoft/mana/gdma_main.c   | 55 ++++++++++++++++---
 include/net/mana/gdma.h                       | 21 +++++--
 2 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 05ba7055405d..2717889e626e 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1699,8 +1699,27 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	header->num_sge = wqe_req->num_sge;
 	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
 
+	if (client_oob_size == INLINE_OOB_EXTRA_LARGE_SIZE) {
+		/* Extra large oob is encoded as 7 */
+		header->inline_oob_size_div4 = 7;
+		/* Extra large oob has 8 byte padding  */
+		client_oob_size += 8;
+	}
+
+	if (wqe_req->wqe_size_in_bu) {
+		header->num_sge = (wqe_req->wqe_size_in_bu * GDMA_WQE_BU_SIZE
+			- sizeof(struct gdma_wqe) - client_oob_size) / sizeof(struct gdma_sge);
+		header->num_pad_sge = header->num_sge - wqe_req->num_sge;
+	}
+
+	header->check_rsn = !!(wqe_req->flags & GDMA_WR_CHECK_RSN);
+	header->check_sn = !!(wqe_req->flags & GDMA_WR_CHECK_SN);
+	header->fence = !!(wqe_req->flags & GDMA_WR_FENCE);
+	header->fence_extended = !!(wqe_req->flags & GDMA_WR_FENCE_EXTENDED);
+	header->generation1 = !!(wqe_req->flags & GDMA_WR_GENERATION_1);
+
 	if (oob_in_sgl) {
-		WARN_ON_ONCE(wqe_req->num_sge < 2);
+		WARN_ON_ONCE(wqe_req->num_sge < 1);
 
 		header->client_oob_in_sgl = 1;
 
@@ -1714,8 +1733,10 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	/* The size of gdma_wqe + client_oob_size must be less than or equal
 	 * to one Basic Unit (i.e. 32 bytes), so the pointer can't go beyond
 	 * the queue memory buffer boundary.
+	 * The exception is when the WQE size is fixed and a power of 2, as
+	 * such a wqe cannot go beyond the queue memory buffer boundary.
 	 */
-	ptr = wqe_ptr + sizeof(header);
+	ptr = wqe_ptr + sizeof(struct gdma_wqe);
 
 	if (wqe_req->inline_oob_data && wqe_req->inline_oob_size > 0) {
 		memcpy(ptr, wqe_req->inline_oob_data, wqe_req->inline_oob_size);
@@ -1724,8 +1745,8 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 			memset(ptr + wqe_req->inline_oob_size, 0,
 			       client_oob_size - wqe_req->inline_oob_size);
 	}
-
-	return sizeof(header) + client_oob_size;
+	/* The hw requires that (gdma_wqe + client_oob_size) is sge size aligned */
+	return ALIGN(sizeof(struct gdma_wqe) + client_oob_size, sizeof(struct gdma_sge));
 }
 
 static void mana_gd_write_sgl(struct gdma_queue *wq, u32 sgl_offset,
@@ -1784,7 +1805,8 @@ int mana_gd_post_work_request(struct gdma_queue *wq,
 		return -EINVAL;
 
 	if (wq->type == GDMA_RQ) {
-		if (client_oob_size != 0)
+		if (client_oob_size != 0 &&
+		    client_oob_size != INLINE_OOB_SMALL_SIZE)
 			return -EINVAL;
 
 		client_oob_size = INLINE_OOB_SMALL_SIZE;
@@ -1792,15 +1814,32 @@ int mana_gd_post_work_request(struct gdma_queue *wq,
 		max_wqe_size = GDMA_MAX_RQE_SIZE;
 	} else {
 		if (client_oob_size != INLINE_OOB_SMALL_SIZE &&
-		    client_oob_size != INLINE_OOB_LARGE_SIZE)
+		    client_oob_size != INLINE_OOB_LARGE_SIZE &&
+		    client_oob_size != INLINE_OOB_EXTRA_LARGE_SIZE)
 			return -EINVAL;
 
 		max_wqe_size = GDMA_MAX_SQE_SIZE;
 	}
 
 	sgl_data_size = sizeof(struct gdma_sge) * wqe_req->num_sge;
-	wqe_size = ALIGN(sizeof(struct gdma_wqe) + client_oob_size +
-			 sgl_data_size, GDMA_WQE_BU_SIZE);
+	if (wqe_req->wqe_size_in_bu) {
+		wqe_size = wqe_req->wqe_size_in_bu * GDMA_WQE_BU_SIZE;
+		oob_len = ALIGN(sizeof(struct gdma_wqe) + client_oob_size,
+				sizeof(struct gdma_sge));
+		if (wqe_size < oob_len ||
+		    wqe_req->num_sge > (wqe_size - oob_len) / sizeof(struct gdma_sge))
+			return -EINVAL;
+	} else {
+		wqe_size = ALIGN(sizeof(struct gdma_wqe) + client_oob_size +
+				 sgl_data_size, GDMA_WQE_BU_SIZE);
+	}
+	/* Ensure the WQE size is a power of 2 when a fixed wqe size or extra large OOB are used.
+	 * Otherwise, the WQE may cross the queue memory buffer boundary, which is not allowed.
+	 */
+	if (wqe_req->wqe_size_in_bu || client_oob_size == INLINE_OOB_EXTRA_LARGE_SIZE) {
+		if (!is_power_of_2(wqe_size))
+			return -EINVAL;
+	}
 	if (wqe_size > max_wqe_size)
 		return -EINVAL;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 332f394b82e1..508da28591ae 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -56,6 +56,11 @@ enum gdma_work_request_flags {
 	GDMA_WR_OOB_IN_SGL		= BIT(0),
 	GDMA_WR_PAD_BY_SGE0		= BIT(1),
 	GDMA_WR_IB_SGL			= BIT(2),
+	GDMA_WR_CHECK_SN                = BIT(3),
+	GDMA_WR_CHECK_RSN               = BIT(4),
+	GDMA_WR_FENCE                   = BIT(5),
+	GDMA_WR_FENCE_EXTENDED          = BIT(6),
+	GDMA_WR_GENERATION_1            = BIT(7),
 };
 
 enum gdma_eqe_type {
@@ -219,8 +224,8 @@ struct gdma_wqe_request {
 		struct ib_sge *ib_sgl;
 	};
 	u32 num_sge;
-
-	u32 inline_oob_size;
+	u16 wqe_size_in_bu;
+	u16 inline_oob_size;
 	const void *inline_oob_data;
 
 	u32 flags;
@@ -538,7 +543,9 @@ void mana_gd_ring_dim(struct gdma_queue *cq, u32 mod_usec, bool mod_usec_vld,
 		      u32 mod_comps, bool mod_comps_vld);
 
 struct gdma_wqe {
-	u32 reserved	:24;
+	u32 num_pad_sge	:5;
+	u32 generation1	:1;
+	u32 reserved	:18;
 	u32 last_vbytes	:8;
 
 	union {
@@ -548,9 +555,13 @@ struct gdma_wqe {
 			u32 num_sge		:8;
 			u32 inline_oob_size_div4:3;
 			u32 client_oob_in_sgl	:1;
-			u32 reserved1		:4;
+			u32 check_rsn		:1;
+			u32 fence		:1;
+			u32 fence_extended	:1;
+			u32 reserved1		:1;
 			u32 client_data_unit	:14;
-			u32 reserved2		:2;
+			u32 check_sn		:1;
+			u32 reserved2		:1;
 		};
 	};
 }; /* HW DATA */
-- 
2.43.0
