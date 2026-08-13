Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6280395243;
	Thu, 13 Aug 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642996; cv=none; b=AI077Td51tSFLEkkQ4vlDXYsNxT7xejjyXg4qr8kUkXQt9fCxsBQQBhNwKlD8qj9LhFcZsY0gkO0OW4CAsnY8VR56aMx8HW0x1zKTFToF7UuV/7WHrg6vfa0qIp0QQeQ0cVEXEXWB3BEvLms0jalJTEKAoelr7nIFklHY4G4htk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642996; c=relaxed/simple;
	bh=nudQFYKz3B3ENixl3x83ZeSn1YRAz6ZQeM9Sww3tCsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho3z9aEBosNAQ8PBXU/oTfExlUo7KCqzT48QrBZwUvWGJkR6Mr4oSg8tFOdJaFm71mn9JXk3Y4sE9C3VmJ7O2WrXr9u/dhvtxV+5eJN33f+QwEcO6mZbl0fsV6iWuAZJGr3SjzlM5IbUFxW7IJhCqIwF8HxtV99Nj3her+Xw2OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7F36C20B7129; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F36C20B7129
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
Subject: [PATCH net v7 2/7] net: mana: fix HWC RQ/SQ buffer size swap
Date: Thu, 13 Aug 2026 10:42:34 -0700
Message-ID: <20260813174243.3044348-3-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813174243.3044348-1-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_hwc_init_queues() sized the RQ (which receives responses) with
max_req_msg_size and the SQ (which sends requests) with max_resp_msg_size
-- backwards -- and mana_hwc_rx_event_handler() strided the RQ by
max_req_msg_size when recovering the RX slot index.

This is latent today: the only caller passes equal sizes (both 0x1000)
and the queues are never re-created with the hardware-reported sizes, so
nothing overflows.  It would only surface if the two sizes diverged.

Size the RQ by max_resp_msg_size and the SQ by max_req_msg_size, and use
max_resp_msg_size as the RX slot stride.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
Commit-message wording only; no code change.
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 7 ++++---
 include/net/mana/hw_channel.h                    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index b5ed2dbce6ceb7f7a5196dfe5ba3534eb4c5d330..ccef9bf9c6bfde754c28f86103f0b05489091f02 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -263,7 +263,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 
 	/* Select the RX work request for virtual address and for reposting. */
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
-	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
+	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
 
 	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
 		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
@@ -737,14 +737,14 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
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
@@ -753,6 +753,7 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
 
 	return 0;
 out:
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 16feb39616c1bead1a043b3fadc2e18a90651516..73671f479399ac296cf472ec6449e5e6b00a8515 100644
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

