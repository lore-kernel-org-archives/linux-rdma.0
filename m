Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE28A3AAF44;
	Mon,  3 Aug 2026 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800677; cv=none; b=m6zjeqQTppUQhp/WrP7Osb0+7Qt0vE8iQQnYz69+ua+oaPI7nE77RiPz6ezdT4ugM5AoF5ptPKVEFFpFS+/t/2L37KrI2xKNm0MwtsKs4I4FkPtPh/YH1HkYWW2+dTM9pHA1G0edX0aT06JWfCWIOX1FvSL1w2N371BESysJBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800677; c=relaxed/simple;
	bh=jls97aMrrE/7hRraIbY0HFHZBbb7vqX3C6bdRQ5CwFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bW8zRJuz1EhnrCIT+VMzKaSqLgxYjtD4J7JI/sBs74yP+i78xn+D2q2DfNiAbe7yBJDZudIkts8dKsi3sH9/7FWwCBB1zvKawVH1MblQ6AUt8csx3uIdx7etXZ2i7tj96U2x1wv1H+Prpoc90kCQP/cKMvQb7+p6AT0CrkhnF48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 1031320B7169; Mon,  3 Aug 2026 16:44:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1031320B7169
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
Subject: [PATCH net v3 6/6] net: mana: fix stale HWC response after command timeout
Date: Mon,  3 Aug 2026 16:43:44 -0700
Message-ID: <20260803234355.636038-7-longli@microsoft.com>
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

The HWC freed a message slot (mana_hwc_put_msg_index) the instant
mana_hwc_send_request() timed out, while the hardware command was still
pending and caller_ctx.output_buf still pointed at the caller's response
buffer.  A late response then raced two ways:

  - handle_resp() runs in CQ interrupt context and memcpy()'d into
    output_buf after the sender had returned and its buffer was gone.

  - the freed slot was reused by the next request, so the stale
    response completed the wrong command with another request's data.

Give each caller_ctx a spinlock, a refcount and an -EINPROGRESS
sentinel:

  - The sender publishes output_buf under the slot lock and NULLs it
    under the same lock on timeout/exit, so handle_resp() (also under
    the lock) skips the copy once the sender is gone.

  - The slot is released only when both the sender and handle_resp()
    have dropped their reference, so a msg_id whose response is still
    outstanding is never handed to a new request.

  - A duplicate or replayed response for the same msg_id is dropped
    via a per-slot "responded" flag, so the response-side reference is
    consumed exactly once and cannot over-release the slot.

  - On a genuine timeout the channel is marked hwc_timed_out and further
    mana_hwc_get_msg_index() callers fail with -ETIMEDOUT instead of
    reusing a slot whose response may still arrive.

Replace the depth-1 semaphore with a waitqueue + bitmap so a slot held
past a timeout does not deadlock admission and timed-out waiters can be
released.

Because the timeout latch keys off wait_for_completion_timeout()
returning immediately, ignore a zero HWC_DATA_CFG_HWC_TIMEOUT reported
by the device: msecs_to_jiffies(0) would time out every command at once
and latch the whole channel.  Keep the positive default instead.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 201 +++++++++++++++---
 include/net/mana/hw_channel.h                 |  25 ++-
 2 files changed, 190 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 1603968d7989..d92032b466af 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -7,25 +7,49 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 
+/* Acquire a free message slot from the inflight bitmap.  Returns
+ * -ETIMEDOUT if a prior HWC command has timed out (preserving the
+ * error code callers expect).
+ */
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	unsigned long flags;
 	u32 index;
 
-	down(&hwc->sema);
+	for (;;) {
+		spin_lock_irqsave(&r->lock, flags);
 
-	spin_lock_irqsave(&r->lock, flags);
+		if (hwc->hwc_timed_out) {
+			spin_unlock_irqrestore(&r->lock, flags);
+			return -ETIMEDOUT;
+		}
 
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+		index = find_first_zero_bit(r->map, r->size);
+		if (index < r->size) {
+			struct hwc_caller_ctx *ctx;
+
+			bitmap_set(r->map, index, 1);
+			ctx = &hwc->caller_ctx[index];
+			reinit_completion(&ctx->comp_event);
+			refcount_set(&ctx->refcnt, 1);
+			ctx->responded = false;
+			ctx->msg_id = index;
+			ctx->error = -EINPROGRESS;
+			spin_unlock_irqrestore(&r->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&r->lock, flags);
 
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+		wait_event(hwc->msg_waitq,
+			   hwc->hwc_timed_out ||
+			   !bitmap_full(r->map, r->size));
 
-	spin_unlock_irqrestore(&r->lock, flags);
+		if (hwc->hwc_timed_out)
+			return -ETIMEDOUT;
+	}
 
 	*msg_id = index;
-
 	return 0;
 }
 
@@ -35,10 +59,17 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
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
@@ -114,22 +145,44 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 		resp_len = 0;
 	}
 
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (err)
-		goto out;
+	spin_lock(&ctx->lock);
 
-	ctx->status_code = resp_msg->status;
+	if (ctx->responded) {
+		/* A response for this slot was already delivered; this is a
+		 * duplicate or replayed one.  Drop it so the hwc_ctx_put()
+		 * a first response performs is not done twice, which would
+		 * over-release the slot while the sender still owns it.
+		 */
+		spin_unlock(&ctx->lock);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
+	ctx->responded = true;
 
-	memcpy(ctx->output_buf, resp_msg, resp_len);
-out:
-	ctx->error = err;
+	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
 
-	/* Must post rx wqe before complete(), otherwise the next rx may
-	 * hit no_wqe error.
+	if (!err && ctx->output_buf) {
+		ctx->status_code = resp_msg->status;
+		memcpy(ctx->output_buf, resp_msg, resp_len);
+		ctx->error = 0;
+	} else if (ctx->output_buf) {
+		/* Only overwrite error if the sender hasn't timed out
+		 * or been force-completed by destroy.  When output_buf
+		 * is NULL, a terminal error (-ENODEV or timeout) has
+		 * already been set — preserve it so the sender doesn't
+		 * see a spurious success.
+		 */
+		ctx->error = err;
+	}
+
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
@@ -216,7 +269,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			/* A zero timeout would make every command time out
+			 * immediately and latch hwc_timed_out, disabling the
+			 * channel.  Ignore it and keep the positive default.
+			 */
+			if (val)
+				hwc->hwc_timeout = val;
 			break;
 
 		case HWC_DATA_HW_LINK_CONNECT:
@@ -708,7 +766,7 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
-	sema_init(&hwc->sema, num_msg);
+	init_waitqueue_head(&hwc->msg_waitq);
 
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
 	if (err)
@@ -738,8 +796,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
+		spin_lock_init(&ctx[i].lock);
 		init_completion(&ctx[i].comp_event);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -750,6 +810,9 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
+	/* No RCU needed: called only from mana_hwc_create_channel
+	 * during init, before the channel is published to senders.
+	 */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
@@ -999,13 +1062,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
 	u32 dest_vrcq = 0;
 	u32 dest_vrq = 0;
 	u32 command;
+	u32 status;
 	u16 msg_id;
 	int err;
 
-	mana_hwc_get_msg_index(hwc, &msg_id);
+	err = mana_hwc_get_msg_index(hwc, &msg_id);
+	if (err)
+		return err;
 
 	tx_wr = &txq->msg_buf->reqs[msg_id];
 
@@ -1017,8 +1084,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -1034,8 +1104,14 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		dest_vrcq = hwc->pf_dest_vrcq_id;
 	}
 
+	/* Take handle_resp's ref before posting — hardware can respond
+	 * immediately after the doorbell ring.
+	 */
+	refcount_inc(&ctx->refcnt);
+
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
+		refcount_dec(&ctx->refcnt);
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
 		goto out;
 	}
@@ -1046,31 +1122,86 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
 				command, hwc->hwc_timeout);
 
-		/* Reduce further waiting if HWC no response */
+		/* NULL out output_buf so a late handle_resp() won't write
+		 * into the caller's buffer after the sender returns, then
+		 * check whether handle_resp() already delivered a valid
+		 * response between the timeout firing and this lock
+		 * acquisition — ctx->error != -EINPROGRESS means it ran.
+		 */
+		spin_lock_irqsave(&ctx->lock, flags);
+		ctx->output_buf = NULL;
+		err = ctx->error;
+		status = ctx->status_code;
+		spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (err != -EINPROGRESS) {
+			/* handle_resp() delivered a valid response just after
+			 * the timeout fired.  The hardware is alive, so use
+			 * the response and leave the channel usable; do not
+			 * latch hwc_timed_out or degrade hwc_timeout for what
+			 * turned out to be a transient race.
+			 */
+			hwc_ctx_put(hwc, ctx);
+			goto check_status;
+		}
+
+		/* Genuine timeout: no response arrived.  Reduce further
+		 * waiting, and mark the channel timed out under the bitmap
+		 * lock so get_msg_index() cannot acquire new slots after this.
+		 */
 		if (hwc->hwc_timeout > 1)
 			hwc->hwc_timeout = 1;
 
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->hwc_timed_out = true;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+		wake_up_all(&hwc->msg_waitq);
+
 		err = -ETIMEDOUT;
-		goto out;
+		hwc_ctx_put(hwc, ctx);
+		goto done;
 	}
 
-	if (ctx->error) {
-		err = ctx->error;
-		goto out;
-	}
+	/* NULL output_buf so a late handle_resp() won't memcpy into
+	 * the caller's buffer after the sender exits.  Read error and
+	 * status_code under the same lock — after hwc_ctx_put the slot
+	 * may be reused and these fields overwritten.
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
+	/* Pre-post error paths: no WQE was submitted so handle_resp()
+	 * cannot race here.  refcount is 1 (no second ref taken).
+	 */
+	ctx = hwc->caller_ctx + msg_id;
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	hwc_ctx_put(hwc, ctx);
+done:
 	return err;
 }
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 3d8543acb5cc..5a55cedf0607 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -173,6 +173,23 @@ struct hwc_caller_ctx {
 
 	u32 error; /* Linux error code */
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
+	/* Set under lock by the first handle_resp() for this slot so a
+	 * duplicate or replayed response is dropped instead of consuming
+	 * the response-side reference a second time.
+	 */
+	bool responded;
 };
 
 struct hw_channel_context {
@@ -193,13 +210,19 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
-	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
+	/* Waitqueue for senders blocked on a full inflight bitmap. */
+	wait_queue_head_t msg_waitq;
 
 	u32 pf_dest_vrq_id;
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Set on first HWC timeout.  Causes get_msg_index() to return
+	 * -ETIMEDOUT instead of waiting, draining all queued senders.
+	 */
+	bool hwc_timed_out;
+
 	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
 	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
 	 * succeeds, on both the recoverable establish_channel path and the
-- 
2.43.0

