Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F03E3ACEE9;
	Thu, 13 Aug 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642998; cv=none; b=E3hz63D3soO/mwGUWq8+cHMsFAL5MSRwkFUrI2HzbjGdtsWEwHGd81aZ+rBzPITSZJKf3S0DNuiMO5E9ouNi58D4HQaFIs2KKEb/RvOb/xF4PSBjjw7zTDHvACHyv4AofOnW8H854fShZvsmHS0toK87tbclVScbylmJoJMtjIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642998; c=relaxed/simple;
	bh=BlirB3Ds7K8TfuFe5tgq5R6vZXebtCIMNikENF55FSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvQF9xSfrMvcOuW7jukt7vMbU7oCqK1QIHv2Cz3SMo8xFicpTmZaZpE/PbhQfxJWroMr+lE6K5wDNvjQTN24K4Pqg5FRX2kQd0BsBLguPWFrzT3Fu01uh3gJphJrxptlZqp5/rm4glBPX/7kdmGJo1rnPkgJm6oUgF/o4AiSGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B39C520B7136; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B39C520B7136
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
Subject: [PATCH net v7 6/7] net: mana: fix stale HWC response after command timeout
Date: Thu, 13 Aug 2026 10:42:38 -0700
Message-ID: <20260813174243.3044348-7-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813174243.3044348-1-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

mana_hwc_send_request() freed the message slot (mana_hwc_put_msg_index)
as soon as it timed out, while the command was still pending and
caller_ctx.output_buf still pointed at the caller's buffer.  A late
response then either memcpy()'d into that buffer from CQ interrupt context
after the sender had returned, or completed the next request that reused
the slot with stale data.

Give each caller_ctx a spinlock, a refcount and an -EINPROGRESS sentinel
(caller_ctx::error becomes int to hold the negative value):

  - The sender publishes and clears output_buf under the slot lock;
    handle_resp() takes the same lock and skips the copy once it is NULL,
    so a late response can no longer write into a sender's buffer after
    it has returned.
  - Both references (sender and handle_resp) are taken up front in
    mana_hwc_get_msg_index(), so an early response cannot drop the slot
    under the sender, and a per-slot "responded" flag drops a duplicate
    response.

Responses are still correlated only by the reusable hwc_msg_id, so a
response that arrives after its slot has been released and reused can
still be delivered to the new owner; closing that fully needs a
per-request identity and is left to a separate change.

Replace the counting semaphore with a waitqueue + bitmap so a slot held
past a timeout cannot deadlock admission.

Ignore a device-reported zero hwc_timeout from both sources that feed it
and keep the positive default.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
- Dropped the terminal "timed out" latch: it could stop teardown
  commands from ever being posted to a slow device.  The core
  stale-response fix (per-slot lock, refcount and "responded" flag) and
  the wait-queue admission change are retained, and a timeout still
  shortens later waits so teardown is still posted.
- Softened the changelog; the msg_id reuse correlation gap is pre-existing
  and noted as out of scope.
 .../net/ethernet/microsoft/mana/gdma_main.c   |   7 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 186 ++++++++++++++----
 include/net/mana/hw_channel.h                 |  21 +-
 3 files changed, 173 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 02f901b2cb1faf4a34e6e3e53deebeeb056f528f..418e55aa033c3141f922fc7b38c9a44696dc9f0f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -310,7 +310,12 @@ static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
 	if (err || resp.hdr.status)
 		return err ? err : -EPROTO;
 
-	*timeout_val = resp.timeout_ms;
+	/* A zero timeout would make every HWC command time out immediately
+	 * and latch the channel (see the HWC_DATA_CFG_HWC_TIMEOUT handler).
+	 * Ignore a zero from the device and keep the caller's positive value.
+	 */
+	if (resp.timeout_ms)
+		*timeout_val = resp.timeout_ms;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 88188523dcd4863b254451e77cb569c12c150033..b1269f7da0563a22c3cbe599df55572e36908139 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,25 +6,41 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
+/* Acquire a free inflight message slot, waiting for one if all are in use. */
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	unsigned long flags;
 	u32 index;
 
-	down(&hwc->sema);
+	for (;;) {
+		spin_lock_irqsave(&r->lock, flags);
 
-	spin_lock_irqsave(&r->lock, flags);
-
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+		index = find_first_zero_bit(r->map, r->size);
+		if (index < r->size) {
+			struct hwc_caller_ctx *ctx;
 
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+			ctx = &hwc->caller_ctx[index];
+			reinit_completion(&ctx->comp_event);
+			/* Take both references (sender + handle_resp) before
+			 * publishing the slot, so an early response cannot free
+			 * it under the sender.
+			 */
+			refcount_set(&ctx->refcnt, 2);
+			ctx->responded = false;
+			ctx->msg_id = index;
+			ctx->error = -EINPROGRESS;
+			/* Publish the slot last, after it is fully initialised. */
+			bitmap_set(r->map, index, 1);
+			spin_unlock_irqrestore(&r->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&r->lock, flags);
 
-	spin_unlock_irqrestore(&r->lock, flags);
+		wait_event(hwc->msg_waitq, !bitmap_full(r->map, r->size));
+	}
 
 	*msg_id = index;
-
 	return 0;
 }
 
@@ -34,10 +50,17 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
-	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
+	bitmap_clear(r->map, msg_id, 1);
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	up(&hwc->sema);
+	wake_up(&hwc->msg_waitq);
+}
+
+static void hwc_ctx_put(struct hw_channel_context *hwc,
+			struct hwc_caller_ctx *ctx)
+{
+	if (refcount_dec_and_test(&ctx->refcnt))
+		mana_hwc_put_msg_index(hwc, ctx->msg_id);
 }
 
 static int mana_hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
@@ -106,22 +129,34 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 		resp_len = 0;
 	}
 
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (err)
-		goto out;
+	spin_lock(&ctx->lock);
 
-	ctx->status_code = resp_msg->status;
+	/* Honour a response only while the sender owns the slot (output_buf
+	 * published) and has not already been answered; otherwise drop it as
+	 * premature, stale or duplicate without touching the refcount.
+	 */
+	if (!ctx->output_buf || ctx->responded) {
+		spin_unlock(&ctx->lock);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
+	ctx->responded = true;
 
-	memcpy(ctx->output_buf, resp_msg, resp_len);
-out:
+	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
+	if (!err) {
+		ctx->status_code = resp_msg->status;
+		memcpy(ctx->output_buf, resp_msg, resp_len);
+	}
 	ctx->error = err;
 
-	/* Must post rx wqe before complete(), otherwise the next rx may
-	 * hit no_wqe error.
+	/* Post RX WQE before completing — the next response may arrive
+	 * immediately and needs a posted buffer.
 	 */
 	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
-
 	complete(&ctx->comp_event);
+	spin_unlock(&ctx->lock);
+
+	hwc_ctx_put(hwc, ctx);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -208,7 +243,9 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			/* Ignore a zero timeout; keep the positive default. */
+			if (val)
+				hwc->hwc_timeout = val;
 			break;
 
 		case HWC_DATA_HW_LINK_CONNECT:
@@ -695,7 +732,7 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
-	sema_init(&hwc->sema, num_msg);
+	init_waitqueue_head(&hwc->msg_waitq);
 
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
 	if (err)
@@ -725,8 +762,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
+		spin_lock_init(&ctx[i].lock);
 		init_completion(&ctx[i].comp_event);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -737,6 +776,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
+	/* Runs at init before the channel is used, so no locking is needed. */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
@@ -989,13 +1029,19 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
+	bool drop_resp_ref;
 	u32 dest_vrcq = 0;
 	u32 dest_vrq = 0;
 	u32 command;
+	u32 status;
+	u32 wait_ms;
 	u16 msg_id;
 	int err;
 
-	mana_hwc_get_msg_index(hwc, &msg_id);
+	err = mana_hwc_get_msg_index(hwc, &msg_id);
+	if (err)
+		return err;
 
 	tx_wr = &txq->msg_buf->reqs[msg_id];
 
@@ -1007,8 +1053,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -1024,43 +1073,104 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		dest_vrcq = hwc->pf_dest_vrcq_id;
 	}
 
+	/* The response-side reference (from get_msg_index) keeps the slot
+	 * alive if hardware responds right after the doorbell.
+	 */
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
 		goto out;
 	}
 
+	wait_ms = hwc->hwc_timeout;
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
-		if (hwc->hwc_timeout != 0)
+					 msecs_to_jiffies(wait_ms))) {
+		if (wait_ms != 0)
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
+				command, wait_ms);
+
+		/* Clear output_buf so a late response cannot write the caller's
+		 * buffer, then check whether one already arrived
+		 * (error != -EINPROGRESS).
+		 */
+		spin_lock_irqsave(&ctx->lock, flags);
+		ctx->output_buf = NULL;
+		err = ctx->error;
+		status = ctx->status_code;
+		spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (err != -EINPROGRESS) {
+			/* A valid response raced in just after the timeout;
+			 * the hardware is alive, so use it and keep the channel.
+			 */
+			hwc_ctx_put(hwc, ctx);
+			goto check_status;
+		}
+
+		err = -ETIMEDOUT;
+
+		/* No-wait teardown (hwc_timeout == 0) is expected to expire;
+		 * just release the slot so the next teardown command can reuse
+		 * it.
+		 */
+		if (wait_ms == 0)
+			goto out;
 
-		/* Reduce further waiting if HWC no response */
+		/* Genuine timeout: shorten later waits so subsequent commands
+		 * fail fast instead of each draining the full timeout.
+		 */
 		if (hwc->hwc_timeout > 1)
 			hwc->hwc_timeout = 1;
 
-		err = -ETIMEDOUT;
+		/* Release the slot via out:; a late response no longer touches
+		 * it, so the sender must drop the reference here.
+		 */
 		goto out;
 	}
 
-	if (ctx->error) {
-		err = ctx->error;
-		goto out;
-	}
+	/* Clear output_buf and read the result under the lock; the slot may
+	 * be reused after hwc_ctx_put().
+	 */
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	err = ctx->error;
+	status = ctx->status_code;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	hwc_ctx_put(hwc, ctx);
+
+check_status:
+	if (err)
+		goto done;
 
-	if (ctx->status_code && ctx->status_code != GDMA_STATUS_MORE_ENTRIES) {
-		if (ctx->status_code == GDMA_STATUS_CMD_UNSUPPORTED) {
+	if (status && status != GDMA_STATUS_MORE_ENTRIES) {
+		if (status == GDMA_STATUS_CMD_UNSUPPORTED) {
 			err = -EOPNOTSUPP;
-			goto out;
+			goto done;
 		}
+
 		if (command != MANA_QUERY_PHY_STAT)
 			dev_err(hwc->dev, "Command 0x%x failed with status: 0x%x\n",
-				command, ctx->status_code);
+				command, status);
 		err = -EPROTO;
-		goto out;
+		goto done;
 	}
+
+	err = 0;
+	goto done;
 out:
-	mana_hwc_put_msg_index(hwc, msg_id);
+	/* Error, no-wait teardown, or timeout: drop the sender's and the
+	 * response-side references.  Latch ->responded so a racing response
+	 * is a no-op, and only drop the response-side ref if it has not.
+	 */
+	ctx = hwc->caller_ctx + msg_id;
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	drop_resp_ref = !ctx->responded;
+	ctx->responded = true;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	if (drop_resp_ref)
+		refcount_dec(&ctx->refcnt);
+	hwc_ctx_put(hwc, ctx);
+done:
 	return err;
 }
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 6e77163a06d8f2622430281647268c54939c4dc0..ceabdc6242573f13d1284a967ea73bc01698e37d 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -171,8 +171,24 @@ struct hwc_caller_ctx {
 	void *output_buf;
 	u32 output_buflen;
 
-	u32 error; /* Linux error code */
+	int error; /* Linux error code (negative errno or 0) */
 	u32 status_code;
+
+	/* Protects output_buf against concurrent access from
+	 * handle_resp() (CQ interrupt) and the sender timeout path.
+	 */
+	spinlock_t lock;
+
+	/* Tracks sender + handle_resp ownership.  The last put
+	 * (refcount reaches 0) releases the bitmap slot.
+	 */
+	refcount_t refcnt;
+	u16 msg_id;
+
+	/* Set by the first handle_resp(), or by the sender's timeout path,
+	 * so a later or duplicate response is dropped.
+	 */
+	bool responded;
 };
 
 struct hw_channel_context {
@@ -193,8 +209,9 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
-	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
+	/* Waitqueue for senders blocked on a full inflight bitmap. */
+	wait_queue_head_t msg_waitq;
 
 	u32 pf_dest_vrq_id;
 	u32 pf_dest_vrcq_id;
-- 
2.43.0

