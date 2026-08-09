Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A4379C36;
	Sun,  9 Aug 2026 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786302087; cv=none; b=SX546NDox/E2HOe4F2V33GnXjbYYqvc4lk1QLWhLaa5+B0U+e/WhPOIZS9EavE3JGfVdx2T2iNNEXWCmuN1CzWedjlXQS3vnZZPRjMidoZWALvx7F+croKSeTpBdlAnSa5fROD5Fm0cJSnjhxI3BT8qrFfDsb5RU1AL+2i8a39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786302087; c=relaxed/simple;
	bh=HWH4CusTAx4mibhZI8/8YLkrdGY8j0j7gwBw+OqysO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAZzzWBleefSqQOaXB71XhDlIbsHoYf6o7TZSWJG9Tyj5dm3kmT/hrsoytSexwS4R0I5DhYUEdcTUAPz2WzzJsYHmf7JBCw4qddnpbGQ8j4B/WkLkf5uO7isWvaxatjCplLdtJgphujNmL/TRDnM2gw7j/88eDYih7/aQBpEOTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 2528320B7128; Sun,  9 Aug 2026 12:00:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2528320B7128
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
Subject: [PATCH net v5 4/7] net: mana: validate hardware-supplied values in the HWC RX path
Date: Sun,  9 Aug 2026 12:00:38 -0700
Message-ID: <20260809190047.2086368-5-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260809190047.2086368-1-longli@microsoft.com>
References: <20260809190047.2086368-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

mana_hwc_rx_event_handler() consumed lengths and indices taken straight
from device DMA without validation.  A buggy firmware or a malicious host
(in a confidential VM, where the DMA buffer is shared) could drive a
wrong or reused in-flight request to completion or index out of bounds.
Validate before use:

  - snapshot the device-supplied inline_oob_size_div4 (read once through
    its u32 flags word with READ_ONCE(), as it is a bit-field) and reject
    any value other than the one the driver programs
    (INLINE_OOB_SMALL_SIZE / 4), so a corrupted OOB size cannot move the
    SGE out of the WQE before it is dereferenced;
  - snapshot sge->address with READ_ONCE() and validate and use only the
    snapshot, so the value that is bounds-checked is the value that is
    used (the DMA buffer is host-writable in a confidential VM);
  - match the SGE address against the address the driver posted for that
    slot, not just an in-range index -- an in-range but wrong SGE would
    otherwise truncate onto a neighbouring slot and read a stale response;
  - reject a resp_len larger than the RX buffer.

As defence in depth, mana_hwc_handle_resp() also bounds-checks hwc_msg_id
before indexing the inflight bitmap and caller_ctx.  Its only caller
already rejects the same range with the value it passes by value, so this
is a guard at the indexing site, not a reachable out-of-bounds.

Repost the RX WQE on every validation early-return that can still
identify its slot.  The paths that cannot -- an unexpected OOB size, an
out-of-range index, or an SGE address matching no posted slot --
intentionally leak a single WQE rather than risk reposting the wrong one.
Because the HWC RQ depth is never replenished, count those leaks and,
once they exhaust the posted depth, log the terminal state and shorten
the command timeout so callers fail fast instead of draining silently.

A short response is no longer rejected in the handler: it reaches
mana_hwc_handle_resp(), whose mana_hwc_verify_resp_msg() fails it with
-EPROTO and completes the waiting sender, so a single malformed response
cannot convert into a channel-wide timeout.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5:
 - No code changes since v4 (resend as a standalone thread).

Changes in v4:
 - Removed the short-response early return so a malformed response
   reaches verify_resp_msg() -> -EPROTO and completes the sender instead
   of hanging it.
 - Account leaked RX WQEs and trip hwc_timeout on RQ exhaustion.
 - Read inline_oob_size_div4 (through its u32 flags word, as it is a
   bit-field) and sge->address with READ_ONCE() and reject any value
   other than the one the driver programs.
 - Reframed the msg_id check as defense in depth in the changelog.

 .../net/ethernet/microsoft/mana/hw_channel.c  | 116 ++++++++++++++++--
 include/net/mana/hw_channel.h                 |   6 +
 2 files changed, 111 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 19896bb5ce1a..5db8cfe2d844 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -83,6 +83,19 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	struct hwc_caller_ctx *ctx;
 	int err;
 
+	/* Defence in depth: the sole caller, mana_hwc_rx_event_handler(),
+	 * already rejects msg_id >= hwc->num_inflight_msg with the value it
+	 * passes here by value, so this cannot be reached out of range.  Keep
+	 * the guard at the indexing site so the bitmap and caller_ctx array
+	 * are never indexed without a bound in view.
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
@@ -90,6 +103,18 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
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
@@ -237,18 +262,39 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 	}
 }
 
+/* An RX WQE whose SGE the handler cannot trust is deliberately not
+ * reposted: reposting a slot we may have mis-identified could double-post
+ * a buffer the device still owns.  Each such leak permanently lowers the
+ * RQ's posted depth, so once the whole depth is gone the channel can no
+ * longer receive responses.  Make that terminal state explicit -- log it
+ * once and shorten the command timeout so callers fail fast -- rather than
+ * letting every later command drain its full timeout against a dead RQ.
+ */
+static void mana_hwc_rx_leak_wqe(struct hw_channel_context *hwc)
+{
+	if (++hwc->rx_leaked_wqe == hwc->rxq->queue_depth) {
+		dev_err(hwc->dev,
+			"HWC RX: RQ exhausted after %u leaked WQEs; channel unusable\n",
+			hwc->rx_leaked_wqe);
+		hwc->hwc_timeout = 1;
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
 
@@ -259,28 +305,76 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	wqe = mana_gd_get_wqe_ptr(rq, rx_oob->wqe_offset / GDMA_WQE_BU_SIZE);
 	dma_oob = (struct gdma_wqe *)wqe;
 
-	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
-
-	/* Select the RX work request for virtual address and for reposting. */
+	/* inline_oob_size_div4 lives in device-accessible RQ memory (shared
+	 * and host-writable in a confidential VM), so snapshot it once and
+	 * validate and use only the snapshot.  It is a bit-field, which
+	 * READ_ONCE() cannot take the size of, so read the u32 flags word it
+	 * shares through the union and extract the field from the local copy.
+	 * The driver programs INLINE_OOB_SMALL_SIZE for every HWC RQ WQE via
+	 * mana_gd_post_work_request(), so the only valid value is
+	 * INLINE_OOB_SMALL_SIZE / 4, which puts the SGE at wqe + 16 inside
+	 * this WQE's own BU.  Reject anything else -- the slot cannot be
+	 * trusted, so leak this RX WQE rather than repost the wrong one.
+	 */
+	oob_snapshot.flags = READ_ONCE(dma_oob->flags);
+	oob_div4 = oob_snapshot.inline_oob_size_div4;
+	if (oob_div4 != INLINE_OOB_SMALL_SIZE / 4) {
+		dev_err(hwc->dev, "HWC RX: unexpected inline_oob_size_div4=%u\n",
+			oob_div4);
+		mana_hwc_rx_leak_wqe(hwc);
+		return;
+	}
+	sge = (struct gdma_sge *)(wqe + 8 + oob_div4 * 4);
+
+	/* Recover the originating RX slot from the SGE address.  Snapshot it
+	 * once, for the same shared-memory reason: of the three terms only
+	 * sge_addr comes from device memory; rq_base_addr and
+	 * max_resp_msg_size are driver-private.  An in-range but wrong SGE
+	 * would otherwise truncate onto a neighbouring slot, letting us read
+	 * a stale response that could complete the wrong, reused in-flight
+	 * request.  Require the index in range AND the address to exactly
+	 * match the value the driver posted for that slot.
+	 */
+	sge_addr = READ_ONCE(sge->address);
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
-	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_resp_msg_size;
-
-	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
-		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
-			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
+	rx_req_idx = (sge_addr - rq_base_addr) / hwc->max_resp_msg_size;
+
+	if (rx_req_idx >= hwc_rxq->queue_depth) {
+		/* Cannot identify the slot, so we cannot safely repost this
+		 * WQE; leak it.  An out-of-range index means a corrupted SGE
+		 * from hardware or host tampering.
+		 */
+		dev_err(hwc->dev, "HWC RX: SGE idx %llu out of range\n",
+			rx_req_idx);
+		mana_hwc_rx_leak_wqe(hwc);
 		return;
 	}
 
 	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
+	if (sge_addr != (u64)rx_req->buf_sge_addr) {
+		/* In-range index but the address does not match what the
+		 * driver posted for that slot; the same unrecoverable case,
+		 * so leak this WQE rather than repost the wrong one.
+		 */
+		dev_err(hwc->dev, "HWC RX: invalid SGE address %llx (idx=%llu)\n",
+			sge_addr, rx_req_idx);
+		mana_hwc_rx_leak_wqe(hwc);
+		return;
+	}
+
 	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
 
-	/* Read msg_id once from DMA buffer to prevent TOCTOU:
-	 * DMA memory is shared/unencrypted in CVMs - host can
-	 * modify it between reads.
+	/* Read msg_id once from the DMA buffer to prevent TOCTOU: DMA memory
+	 * is shared/unencrypted in CVMs, so the host can modify it between
+	 * reads.  A short response is not rejected here; it is handed to
+	 * mana_hwc_handle_resp() below, whose mana_hwc_verify_resp_msg()
+	 * fails it with -EPROTO and completes the waiting sender, so one
+	 * malformed response cannot stall the whole channel.
 	 */
 	msg_id = READ_ONCE(resp->response.hwc_msg_id);
 	if (msg_id >= hwc->num_inflight_msg) {
 		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
+		mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
 		return;
 	}
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 73671f479399..787c6f96d5b5 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -200,6 +200,12 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Count of RX WQEs deliberately not reposted after an untrusted SGE
+	 * (see mana_hwc_rx_leak_wqe()); once it reaches the RQ depth the
+	 * channel can no longer receive responses.
+	 */
+	u32 rx_leaked_wqe;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

