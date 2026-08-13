Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF1539F191;
	Thu, 13 Aug 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642996; cv=none; b=kjMlUrn6WH6fk+pHv4K47nKFbZ5gCLxnj9bFGvdR0TsVebvIPNLOqILlafji61tJQ7zR0/p1X+NHi7sCSTtBC3pLnL/hjOZ/Rtack8QnN/yK8kxSl3GtLLyr9MyxQGAnZBdaSwp2mXIhUny41WIR8D57gfzpAj2Z0CggC6JkA8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642996; c=relaxed/simple;
	bh=/AyhsuPh17jm/IRm0euhip5qTtXv2Nn+xRQOAGv0HcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmZZmrUheVjctL5DBTvEJLKih21/7mpf3zjEF/wEmEmW+s7VOxihM0+8uEhauxdYenpG827z5YE20A2+A+iBEIIuUncTPWPdressBlwiacYi3BpgALbuQZBZ3Mhd9y+J/FVvKZ/CJI2c+5Hij474zQWt0q/9dDCxLwXPrr6b3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 9876420B712D; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9876420B712D
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
Subject: [PATCH net v7 4/7] net: mana: validate hardware-supplied values in the HWC RX path
Date: Thu, 13 Aug 2026 10:42:36 -0700
Message-ID: <20260813174243.3044348-5-longli@microsoft.com>
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

mana_hwc_rx_event_handler() used lengths and indices taken straight from
device DMA without validation.  A buggy firmware or a malicious host (in
a confidential VM, where the DMA buffer is shared) could complete a wrong
or reused request or index out of bounds.  Validate before use:

  - read inline_oob_size_div4 once (through its u32 flags word) and reject
    any value but the one the driver programs, so a corrupted OOB size
    cannot move the SGE out of the WQE;
  - read sge->address once and require it to match the address the driver
    posted for that slot, not just an in-range index, so a wrong SGE
    cannot complete a neighbouring slot's request;
  - reject a resp_len larger than the RX buffer;
  - bounds-check hwc_msg_id before indexing the inflight bitmap and
    caller_ctx.

Repost the RX WQE on every early-return that can still identify its slot.
The cases that cannot -- a bad OOB size, an out-of-range index, or an
address matching no slot -- leak one WQE rather than repost the wrong one.
The RQ depth is never replenished, so count the leaks and, once they
exhaust it, log it and shorten the command timeout so callers fail fast.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
- Bound the RX slot index by msg_buf->num_reqs (the __counted_by array
  bound) instead of the queue depth.
- Rate-limit the device-triggered RX rejection messages.
- Tightened the commit message.
 .../net/ethernet/microsoft/mana/hw_channel.c  | 85 ++++++++++++++++---
 include/net/mana/hw_channel.h                 |  5 ++
 2 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 7e01596df11b639b1801bef7bdb09c91dfeb0543..2691d609459122bdbafb144a8b77ac3785c0eddb 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -83,13 +83,29 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	struct hwc_caller_ctx *ctx;
 	int err;
 
+	/* The caller already bounds msg_id; re-check at the indexing site. */
+	if (msg_id >= hwc->num_inflight_msg) {
+		dev_err_ratelimited(hwc->dev, "hwc_rx: msg_id %u >= max %u\n",
+				    msg_id, hwc->num_inflight_msg);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
+
 	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
-		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
+		dev_err_ratelimited(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 		return;
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	/* An oversized resp_len cannot fit the RX buffer: reject it. */
+	if (resp_len > rx_req->buf_len) {
+		dev_err_ratelimited(hwc->dev, "HWC RX: resp_len %u > buf_len %u\n",
+				    resp_len, rx_req->buf_len);
+		resp_len = 0;
+	}
+
 	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
 	if (err)
 		goto out;
@@ -237,18 +253,37 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 	}
 }
 
+/* Drop an RX WQE with an untrusted SGE rather than repost it, which could
+ * double-post a buffer the device still owns.  This lowers the RQ depth;
+ * once it is exhausted the channel can no longer receive, so log it and
+ * shorten the timeout to fail callers fast.
+ */
+static void mana_hwc_rx_leak_wqe(struct hw_channel_context *hwc)
+{
+	if (++hwc->rx_leaked_wqe == hwc->rxq->queue_depth) {
+		dev_err(hwc->dev,
+			"HWC RX: RQ exhausted after %u leaked WQEs; channel unusable\n",
+			hwc->rx_leaked_wqe);
+		if (hwc->hwc_timeout > 1)
+			hwc->hwc_timeout = 1;
+	}
+}
+
 static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 				      const struct hwc_rx_oob *rx_oob)
 {
 	struct hw_channel_context *hwc = ctx;
 	struct hwc_wq *hwc_rxq = hwc->rxq;
 	struct hwc_work_request *rx_req;
+	struct gdma_wqe oob_snapshot;
 	struct gdma_resp_hdr *resp;
 	struct gdma_wqe *dma_oob;
 	struct gdma_queue *rq;
 	struct gdma_sge *sge;
 	u64 rq_base_addr;
 	u64 rx_req_idx;
+	u64 sge_addr;
+	u32 oob_div4;
 	u16 msg_id;
 	u8 *wqe;
 
@@ -259,28 +294,58 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	wqe = mana_gd_get_wqe_ptr(rq, rx_oob->wqe_offset / GDMA_WQE_BU_SIZE);
 	dma_oob = (struct gdma_wqe *)wqe;
 
-	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
+	/* inline_oob_size_div4 comes from device memory (host-writable in a
+	 * CVM), so read it once from the shared flags word.  The driver only
+	 * ever programs INLINE_OOB_SMALL_SIZE, so reject any other value.
+	 */
+	oob_snapshot.flags = READ_ONCE(dma_oob->flags);
+	oob_div4 = oob_snapshot.inline_oob_size_div4;
+	if (oob_div4 != INLINE_OOB_SMALL_SIZE / 4) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC RX: unexpected inline_oob_size_div4=%u\n",
+				    oob_div4);
+		mana_hwc_rx_leak_wqe(hwc);
+		return;
+	}
+	sge = (struct gdma_sge *)(wqe + 8 + oob_div4 * 4);
 
-	/* Select the RX work request for virtual address and for reposting. */
+	/* Recover the RX slot from the SGE address (read once, it is device
+	 * memory).  Require both an in-range index and an exact address
+	 * match, so a wrong SGE cannot complete an unrelated request.
+	 */
+	sge_addr = READ_ONCE(sge->address);
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
-	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
+	rx_req_idx = (sge_addr - rq_base_addr) / hwc->max_resp_msg_size;
 
 	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
-		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
-			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
+		/* Out-of-range index: corrupted SGE, leak the WQE. */
+		dev_err_ratelimited(hwc->dev,
+				    "HWC RX: SGE idx %llu >= num_reqs %u\n",
+				    rx_req_idx, hwc_rxq->msg_buf->num_reqs);
+		mana_hwc_rx_leak_wqe(hwc);
 		return;
 	}
 
 	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
+	if (sge_addr != (u64)rx_req->buf_sge_addr) {
+		/* Address does not match the posted slot: leak the WQE. */
+		dev_err_ratelimited(hwc->dev,
+				    "HWC RX: invalid SGE address %llx (idx=%llu)\n",
+				    sge_addr, rx_req_idx);
+		mana_hwc_rx_leak_wqe(hwc);
+		return;
+	}
+
 	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
 
-	/* Read msg_id once from DMA buffer to prevent TOCTOU:
-	 * DMA memory is shared/unencrypted in CVMs - host can
-	 * modify it between reads.
+	/* Read msg_id once: it is host-writable DMA memory.  A short response
+	 * is left for mana_hwc_handle_resp() to reject, so it cannot stall
+	 * the channel.
 	 */
 	msg_id = READ_ONCE(resp->response.hwc_msg_id);
 	if (msg_id >= hwc->num_inflight_msg) {
-		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
+		dev_err_ratelimited(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
+		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
 		return;
 	}
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 73671f479399ac296cf472ec6449e5e6b00a8515..58ea72f32135674d41fb1469e4cce4b0d8e87560 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -200,6 +200,11 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* RX WQEs dropped after an untrusted SGE; at RQ depth the channel
+	 * can no longer receive.
+	 */
+	u32 rx_leaked_wqe;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

