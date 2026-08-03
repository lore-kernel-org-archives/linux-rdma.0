Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F06133F385;
	Mon,  3 Aug 2026 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800664; cv=none; b=nMe550DLY0Rq8uMu074ebevaN6zcaIXIAWK6AF/PAJFGM8p7zou13RJgm7QLbitigjy7Z1HxxQX4gtxwOrQGFAIPMsdBSLGGDPsIlFCShYIhJIL5WXQkgLwcsQUQyMLkYhD7WTUNxHKwdojqzxNKdFn2IzOzXHOHHwM7peeykDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800664; c=relaxed/simple;
	bh=+MXrgxswbaXqix6mWPwSbGqSYvDL37qVzs3oYzuXIjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ur5gMwqAfCJni32KM77CYLhTUoC9TzNcCOo9tSZxW34um8sZVLMJAZFO5RZBXK14m7gdMp9DuRVUj4dX5fDlzc9foD9d/AhSsF3eq5Nx1xymvCFd6eeMkalRl+6UZp5kiUxeea79Q/bV69DN0ADayvd8Xe26e+0NYd88dvXcaVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7E05920B7168; Mon,  3 Aug 2026 16:44:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E05920B7168
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3 2/6] net: mana: fix HWC RQ/SQ buffer size swap
Date: Mon,  3 Aug 2026 16:43:40 -0700
Message-ID: <20260803234355.636038-3-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HWC RQ receives responses and the SQ sends requests, but
mana_hwc_init_queues() sized the RQ with max_req_msg_size and the SQ with
max_resp_msg_size -- backwards.  A response larger than the undersized RQ
buffer could overflow it, and mana_hwc_rx_event_handler() recovered the
RX slot index by dividing by the wrong size (max_req_msg_size).

Size the RQ by max_resp_msg_size and the SQ by max_req_msg_size, store
max_resp_msg_size in hw_channel_context, and use it as the RX slot
stride.

Store the queue dimensions before creating the CQ, which registers the
RX completion handler: that handler divides by max_resp_msg_size and
range-checks num_inflight_msg, so both must be set before it can run.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c   | 18 ++++++++++++------
 include/net/mana/hw_channel.h                  |  1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 409e20caeccd..cbb56c764787 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -263,7 +263,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 
 	/* Select the RX work request for virtual address and for reposting. */
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
-	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
+	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
 
 	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
 		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
@@ -721,6 +721,15 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	if (err)
 		return err;
 
+	/* Set the queue dimensions before creating the CQ: doing so
+	 * registers mana_hwc_rx_event_handler(), which divides by
+	 * hwc->max_resp_msg_size and range-checks hwc->num_inflight_msg.
+	 * They must be valid before any RX completion can be delivered.
+	 */
+	hwc->num_inflight_msg = q_depth;
+	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
+
 	/* CQ is shared by SQ and RQ, so CQ's queue depth is the sum of SQ
 	 * queue depth and RQ queue depth.
 	 */
@@ -733,23 +742,20 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 		goto out;
 	}
 
-	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
+	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_resp_msg_size,
 				 hwc->cq, &hwc->rxq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
 		goto out;
 	}
 
-	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
+	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_req_msg_size,
 				 hwc->cq, &hwc->txq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
 		goto out;
 	}
 
-	hwc->num_inflight_msg = q_depth;
-	hwc->max_req_msg_size = max_req_msg_size;
-
 	return 0;
 out:
 	/* mana_hwc_create_channel() will do the cleanup.*/
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 16feb39616c1..73671f479399 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -181,6 +181,7 @@ struct hw_channel_context {
 
 	u16 num_inflight_msg;
 	u32 max_req_msg_size;
+	u32 max_resp_msg_size;
 
 	u16 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
-- 
2.43.0

