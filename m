Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A699395AD4;
	Mon,  3 Aug 2026 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800666; cv=none; b=te9vhP7wHY+1UULkaAJdakcsPbWNwLZApx1yN8Iou+KPS0V/LZ+SzAPikBavH93c1nR/g1CnuCcmToXfWBFMFuCe/Zf5fhN1dUQ6NqFk/HiJ3JeTqsrTxeX2FAj7YLeB0ooGKVT5zpXOik023rCDKgqPLesUMXEZd1ORJtA0tNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800666; c=relaxed/simple;
	bh=mxP/KynZ1dE6BR3/Ef+/OkgQY1f9BKD/jMCs4Rm3l/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFw33ZyTpodLxm25ofpHMhM5pOTmDFWgBfH6eq4e9JwOKbZJ4U5IxUG1Cu8s16CO2FxC+yNibMFy0S5EVD/eIDrRdoWbvk2o9BJ1X8xjwDUzBvVEJoDTmL5m2bZLlnetv1JLxAhULXVQhPgeZeXy1hJxkch8/ej7nHZZBE2jEYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C300820B7167; Mon,  3 Aug 2026 16:44:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C300820B7167
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
Subject: [PATCH net v3 4/6] net: mana: validate hardware-supplied values in the HWC RX path
Date: Mon,  3 Aug 2026 16:43:42 -0700
Message-ID: <20260803234355.636038-5-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

mana_hwc_rx_event_handler() and mana_hwc_handle_resp() consumed lengths
and indices taken straight from device DMA without validation.  A buggy
firmware or a malicious host (in a confidential VM, where the DMA buffer
is shared) could drive a wrong or reused in-flight request to completion
or index out of bounds.  Validate before use:

  - bounds-check the SGE pointer located via the device-supplied
    inline_oob_size_div4 before dereferencing it, so a corrupted OOB
    size cannot push the read past the RQ buffer;
  - match the SGE address against the address the driver posted for that
    slot, not just an in-range index -- an in-range but wrong SGE would
    otherwise truncate onto a neighbouring slot and read a stale response;
  - require the response to cover a full gdma_resp_hdr before reading
    hwc_msg_id, so a short response cannot complete a slot with stale
    bytes left by the buffer's previous occupant;
  - bounds-check hwc_msg_id in mana_hwc_handle_resp() before indexing the
    inflight bitmap and caller_ctx;
  - reject a resp_len larger than the RX buffer.

Repost the RX WQE on every validation early-return so a rejected response
does not permanently shrink the posted RQ depth.  The two paths that
cannot identify the slot (an out-of-bounds SGE pointer, or an SGE address
matching no posted slot) intentionally leak a single WQE rather than risk
reposting the wrong one.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 82 ++++++++++++++++++-
 1 file changed, 78 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index d701c427fe47..e378b8ec97c9 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -83,6 +83,17 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	struct hwc_caller_ctx *ctx;
 	int err;
 
+	/* Validate msg_id is in range before using it to index bitmap
+	 * and caller_ctx array.  Malicious firmware could send
+	 * out-of-range msg_id causing out-of-bounds access.
+	 */
+	if (msg_id >= hwc->num_inflight_msg) {
+		dev_err(hwc->dev, "hwc_rx: msg_id %u >= max %u\n",
+			msg_id, hwc->num_inflight_msg);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
+
 	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
 		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
@@ -90,6 +101,18 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	/* Reject responses larger than the RX DMA buffer — the SGE
+	 * limits what hardware can DMA, so an oversized resp_len
+	 * indicates a firmware bug.  Fail rather than silently
+	 * truncating.
+	 */
+	if (resp_len > rx_req->buf_len) {
+		dev_err(hwc->dev, "HWC RX: resp_len %u > buf_len %u\n",
+			resp_len, rx_req->buf_len);
+		resp_len = 0;
+	}
+
 	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
 	if (err)
 		goto out;
@@ -261,19 +284,69 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 
 	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
 
-	/* Select the RX work request for virtual address and for reposting. */
+	/* inline_oob_size_div4 is read from the WQE in device-accessible RQ
+	 * memory, so a malicious host in a CVM (or buggy firmware) could set
+	 * it to push the SGE past the RQ buffer.  Bounds-check the SGE it
+	 * locates before dereferencing sge->address below.  A validly posted
+	 * WQE keeps the SGE inside the ring (worst case ends exactly at the
+	 * buffer boundary); reject anything that would read past it.  The
+	 * slot cannot be trusted here, so leak this RX WQE rather than repost
+	 * the wrong one -- as in the SGE-address mismatch path below.
+	 */
+	if ((u8 *)(sge + 1) > (u8 *)rq->queue_mem_ptr + rq->queue_size) {
+		dev_err(hwc->dev, "HWC RX: SGE past RQ buffer, oob_div4=%u\n",
+			dma_oob->inline_oob_size_div4);
+		return;
+	}
+
+	/* Recover the originating RX slot from the SGE address.  Of the three
+	 * terms here only sge->address lives in device-accessible RQ memory;
+	 * rq_base_addr and max_resp_msg_size are driver-private constants.  An
+	 * in-range but wrong/unaligned SGE (corrupted WQE, or a malicious host
+	 * in a CVM) would otherwise truncate onto a neighbouring slot, letting
+	 * us read a stale response that could complete the wrong, reused
+	 * in-flight request.  Require the index to be in range AND the address
+	 * to exactly match the value the driver posted for that slot.
+	 */
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
 	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
 
-	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
-		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
-			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
+	if (rx_req_idx >= hwc_rxq->queue_depth) {
+		/* Cannot trust which WQE this is, so we cannot safely repost
+		 * it; leak one RX WQE and bail.  An out-of-range index means
+		 * a corrupted SGE from hardware (or host tampering), an
+		 * unrecoverable device error.
+		 */
+		dev_err(hwc->dev, "HWC RX: SGE idx %llu out of range\n",
+			rx_req_idx);
 		return;
 	}
 
 	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
+	if (sge->address != (u64)rx_req->buf_sge_addr) {
+		/* In-range index but the address does not match what the
+		 * driver posted for that slot; the same unrecoverable case,
+		 * so leak this WQE rather than repost the wrong one.
+		 */
+		dev_err(hwc->dev, "HWC RX: invalid SGE address %llx (idx=%llu)\n",
+			sge->address, rx_req_idx);
+		return;
+	}
+
 	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
 
+	/* Validate resp_len covers the response header before reading
+	 * hwc_msg_id.  A short response leaves stale data from the
+	 * previous buffer occupant, which could match a live slot and
+	 * complete the wrong request.
+	 */
+	if (rx_oob->tx_oob_data_size < sizeof(*resp)) {
+		dev_err(hwc->dev, "HWC RX: short resp_len=%u\n",
+			rx_oob->tx_oob_data_size);
+		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
+		return;
+	}
+
 	/* Read msg_id once from DMA buffer to prevent TOCTOU:
 	 * DMA memory is shared/unencrypted in CVMs - host can
 	 * modify it between reads.
@@ -281,6 +354,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	msg_id = READ_ONCE(resp->response.hwc_msg_id);
 	if (msg_id >= hwc->num_inflight_msg) {
 		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
+		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
 		return;
 	}
 
-- 
2.43.0

