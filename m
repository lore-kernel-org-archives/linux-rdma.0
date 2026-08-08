Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C2F1E2834;
	Sat,  8 Aug 2026 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156486; cv=none; b=mYA92eHw94/4ebfTExVyGdWOHiTW1g4zOgZ1na5kZUtAqnD8pcZ31THYST9vOVSTu/jsGnReMIDsXbnmexVRGTiAJ0erceYgcKxa/gQVDFUnnwSuqeWN1B+qkPvAfpjmHHIN8pKAM8M6qk1BM+asRUEy13Vp9b6+eUWpRypJF7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156486; c=relaxed/simple;
	bh=c8Y8rP12JZF5QsyC4WIAZ4aRMfElPFWH8laKIWybBzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moUYStPP1/hPnvFbSwS/eR0wnOGzWyOZA4rvaTTul/YZwzQE+lg/O15oNCry0SpWIMmatkAvpLIHUp6odn29/4qOrpVuQ4xq+Sg3O98dtspqG/MzKOKsmFYHgnCu71wiF9bf12WJ7Gh6Agh502Bk4T4ZFE7jkxak4EVhvzsaNds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 136F220B7128; Fri,  7 Aug 2026 19:34:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 136F220B7128
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
	stephen@networkplumber.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Kees Cook <kees@kernel.org>,
	Shachar Raindel <shacharr@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 2/7] net: mana: fix HWC RQ/SQ buffer size swap
Date: Fri,  7 Aug 2026 19:34:11 -0700
Message-ID: <20260808023417.1746886-3-longli@microsoft.com>
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
max_resp_msg_size -- backwards.  mana_hwc_rx_event_handler() also
recovered the RX slot index by dividing by max_req_msg_size instead of
the response size that strides the RQ buffer.

Both mistakes are latent today: the only caller passes
HW_CHANNEL_MAX_REQUEST_SIZE and HW_CHANNEL_MAX_RESPONSE_SIZE, which are
both 0x1000, and the queues are never re-created with the
hardware-reported sizes (those are only used by mana_hwc_test_channel()),
so max_req_msg_size == max_resp_msg_size on every path and there is no
observable overflow or mis-indexing.  The bug would only surface if the
two sizes ever diverged.

Size the RQ by max_resp_msg_size and the SQ by max_req_msg_size, store
max_resp_msg_size in hw_channel_context, and use it as the RX slot stride
so the code is correct regardless of the two sizes.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
 - Reworded the changelog as a latent-correctness fix (both message
   sizes are 0x1000, so the swap has no observable overflow) and
   dropped the note about hoisting the queue dimensions above
   mana_hwc_create_cq().

 drivers/net/ethernet/microsoft/mana/hw_channel.c | 7 ++++---
 include/net/mana/hw_channel.h                    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 409e20caeccd..3f011ebbe7b3 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -263,7 +263,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 
 	/* Select the RX work request for virtual address and for reposting. */
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
-	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
+	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
 
 	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
 		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
@@ -733,14 +733,14 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
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
@@ -749,6 +749,7 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
 
 	return 0;
 out:
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

