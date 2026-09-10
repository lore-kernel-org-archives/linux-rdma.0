Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9588248B;
	Thu, 10 Sep 2026 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789004680; cv=none; b=iWfbAwVzCgbmnEazwhqovM3+zg5/QlXGJUgo/7TODy5ul+gmd80qdeu5GWZ41QsZ6cvFXYCRdSe29njwblJYTCUDcijmkVphJZ5isaCcLVmY1agcvYOhMDOhgnu4L6DdVqIJIb5JNDJXsPD13ycHfJeJvk7yOEb0t6u13uR2Sxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789004680; c=relaxed/simple;
	bh=q+Mng43P5Szizwq43/WZgjuVDVsCTw3DVzSy+r00qwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rhktdU9t5q5ceOBqv5kk/fRgwtkmc1loUKPp5PFVl8CFkK4avWVrddtJmaDkyav+JWy9FKjx2PBbBps8AQwIyIdaBSY3cALnzyL3oZU/v3Ef5HsKe+3GYKw0MZ3d7/c19RbknsJvmO117Bf6XIGtRUa1bwj9qzS/ddVrm1dVPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lnLy8pZY; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lnLy8pZY"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.40])
	by linux.microsoft.com (Postfix) with ESMTPSA id A838020B7169;
	Wed,  9 Sep 2026 18:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A838020B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789004637;
	bh=AeESt3dXLhZu5c+z2nK4ARnEplzM+ZS2BXOM01nvXAo=;
	h=From:To:Cc:Subject:Date:From;
	b=lnLy8pZYww4VzTi0LF/KQFDNs1haDfuVYLWX8ttiDlF3pgYs0N9PZcHMaILmlIN8I
	 N+SaVRqZPjMZMfrrpF98SEWUFOWhhaKIThhQ4VnmkM0cbizPbVnNrsDb5fsq+bNf+T
	 U2x4nGvhrg2EEPrc1Y2V7Gt07nHUME7R4C02OIPE=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com
Cc: linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	horms@kernel.org,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com
Subject: [PATCH net-next v2] net: mana: Use the HWC destination queues reported by the hardware
Date: Thu, 10 Sep 2026 01:44:27 +0000
Message-ID: <20260910014427.54272-1-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hardware provides valid HWC destination vRQ and vRCQ IDs for all PFs
and VFs. Use these IDs unconditionally in mana_hwc_send_request(), as
the PF-specific gate is not required.

Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Changes in v2:
- State that the hardware supplies valid destination IDs for all PFs and
  VFs, so the PF-specific gate is unnecessary.
- Drop the PF prefix from the context fields and init-event constants.

v1:
https://lore.kernel.org/netdev/20260903184104.3194819-1-mawasthi@linux.microsoft.com/

 drivers/net/ethernet/microsoft/mana/hw_channel.c | 24 +++++++++++++-----------
 include/net/mana/hw_channel.h                    |  8 ++++----
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 263e7c4e2934186af037be4c80350a6e322b6771..3bca4b683134b8e5461c4071d59f6085da954cd7 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -170,12 +170,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			hwc->txq->msg_buf->gpa_mkey = val;
 			break;
 
-		case HWC_INIT_DATA_PF_DEST_RQ_ID:
-			hwc->pf_dest_vrq_id = val;
+		case HWC_INIT_DATA_DEST_RQ_ID:
+			hwc->dest_vrq_id = val;
 			break;
 
-		case HWC_INIT_DATA_PF_DEST_CQ_ID:
-			hwc->pf_dest_vrcq_id = val;
+		case HWC_INIT_DATA_DEST_CQ_ID:
+			hwc->dest_vrcq_id = val;
 			break;
 		}
 
@@ -855,13 +855,12 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp)
 {
-	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct hwc_work_request *tx_wr;
 	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
-	u32 dest_vrcq = 0;
-	u32 dest_vrq = 0;
+	u32 dest_vrcq;
+	u32 dest_vrq;
 	u32 command;
 	u16 msg_id;
 	int err;
@@ -890,10 +889,13 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	tx_wr->msg_size = req_len;
 	command = req_msg->req.msg_type;
 
-	if (gc->is_pf) {
-		dest_vrq = hwc->pf_dest_vrq_id;
-		dest_vrcq = hwc->pf_dest_vrcq_id;
-	}
+	/* The hardware reports the HWC destination queues through
+	 * HWC_INIT_DATA_DEST_RQ_ID and HWC_INIT_DATA_DEST_CQ_ID, and
+	 * always supplies values that are valid for this function, so no
+	 * PF-specific handling is needed here.
+	 */
+	dest_vrq = hwc->dest_vrq_id;
+	dest_vrcq = hwc->dest_vrcq_id;
 
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 16feb39616c1bead1a043b3fadc2e18a90651516..1ab2d66c891e42f3a847e62acf75b69fcf7ffb1e 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -20,8 +20,8 @@
 #define HWC_INIT_DATA_MAX_NUM_CQS	7
 #define HWC_INIT_DATA_PDID		8
 #define HWC_INIT_DATA_GPA_MKEY		9
-#define HWC_INIT_DATA_PF_DEST_RQ_ID	10
-#define HWC_INIT_DATA_PF_DEST_CQ_ID	11
+#define HWC_INIT_DATA_DEST_RQ_ID	10
+#define HWC_INIT_DATA_DEST_CQ_ID	11
 
 #define HWC_DATA_CFG_HWC_TIMEOUT 1
 #define HWC_DATA_HW_LINK_CONNECT 2
@@ -195,8 +195,8 @@ struct hw_channel_context {
 	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
 
-	u32 pf_dest_vrq_id;
-	u32 pf_dest_vrcq_id;
+	u32 dest_vrq_id;
+	u32 dest_vrcq_id;
 	u32 hwc_timeout;
 
 	struct hwc_caller_ctx *caller_ctx;

base-commit: ce48a0fdc56464b1afb03471dbdf38a5e0d571ad
-- 
2.54.0
