Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F433921DB;
	Tue, 11 Aug 2026 02:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415938; cv=none; b=EwQNgEtngLKIjvzKPuHm/24xAZgAeDtp5Qv/4wc4BJB8FbwjgqXJKhWM2ManEltEJovgAbzhVqt+DjSZSXkNZUMTS7bWLzll2lreTfkllC+4oY/HassgRRtgP0J+gz22hkC56lTsSGbIc3CVIHdCtWRwFiy86hAZ5Gjw7iLAX9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415938; c=relaxed/simple;
	bh=Jc6KUTmG3vypYPWL1qcHL8DbGClfqtd9CYcLcN+kGMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+H4HpRnKnIz28qZ5M9t25Ve+nDv8ClRMb5T0jDW/Dl2ooMExf0w/d8u0PqE9Lv98hQ3xqEonYkVebYD8NVDtKRvG9tDK05Iy2jmgwtiAtxaMstHxaAxeuGok6dm100jcWKgB6bObY25Mo+ZM1PDTP2MaZrK/f742TL15O//KKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C2A3D20B6F12; Mon, 10 Aug 2026 19:38:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C2A3D20B6F12
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
Subject: [PATCH net v6 6/7] net: mana: fix stale HWC response after command timeout
Date: Mon, 10 Aug 2026 19:38:20 -0700
Message-ID: <20260811023823.2391255-7-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811023823.2391255-1-longli@microsoft.com>
References: <20260811023823.2391255-1-longli@microsoft.com>
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
sentinel (and change caller_ctx::error from u32 to int so it holds
the negative errno values, including the sentinel, without relying on
unsigned wraparound):

  - The sender publishes output_buf under the slot lock and NULLs it
    under the same lock on timeout/exit, so handle_resp() (also under
    the lock) skips the copy once the sender is gone.

  - The slot is released only when both the sender and handle_resp()
    have dropped their reference, so a msg_id whose response is still
    outstanding is never handed to a new request.

  - Both references are taken up front in mana_hwc_get_msg_index(),
    under the same lock that publishes the slot, so a stale, duplicate
    or early response that arrives before the sender posts drops only
    the response-side reference and cannot release the slot out from
    under the sender.  A per-slot "responded" flag drops the payload of
    any such extra response.

  - On a genuine timeout the channel is marked hwc_timed_out and further
    mana_hwc_get_msg_index() callers fail with -ETIMEDOUT instead of
    reusing a slot whose response may still arrive.  The flag is read
    with READ_ONCE() outside the bitmap lock and written with
    WRITE_ONCE() under it.

Replace the counting semaphore with a waitqueue + bitmap so a slot held
past a timeout does not deadlock admission and timed-out waiters can be
released.

Because the timeout latch keys off wait_for_completion_timeout()
returning immediately, a zero hwc_timeout would time out every command
at once and latch the whole channel.  Ignore a device-reported zero from
both sources that feed hwc_timeout -- the HWC_DATA_CFG_HWC_TIMEOUT
reconfig event and the GDMA_QUERY_HWC_TIMEOUT response -- and keep the
positive default instead.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v6:
 - Initialise the caller_ctx refcount/state before publishing the
   inflight bitmap bit, so a racing or forged response cannot observe an
   uninitialised slot.
 - In mana_hwc_handle_resp(), honour a response only while the sender
   still owns the slot (output_buf published and not yet reclaimed), so a
   premature response cannot free the slot while its command is still in
   flight.
 - Do not latch hwc_timed_out for the deliberate no-wait teardown
   (hwc_timeout == 0), applied on both the admission gate and the
   post-wait check in mana_hwc_get_msg_index(); route the genuine-timeout
   path through the slot-release path so it drops both references.

Changes in v5:
 - No code changes since v4 (resend as a standalone thread).

Changes in v4:
 - Take both the sender and response-side references up front in
   mana_hwc_get_msg_index() (refcount initialised to 2, under the lock
   that publishes the slot) so an early/stale/forged response cannot
   free the slot before the sender posts; the pre-post error path
   latches ->responded to avoid a double drop.
 - Changed caller_ctx::error from u32 to int so it holds the negative
   -EINPROGRESS sentinel and errno values directly.
 - Reject a zero firmware-supplied HWC timeout in the query path as well
   as the reconfig path.
 - Access hwc_timed_out with READ_ONCE()/WRITE_ONCE(); comment and
   changelog fixes.

 .../net/ethernet/microsoft/mana/gdma_main.c   |   7 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 264 +++++++++++++++---
 include/net/mana/hw_channel.h                 |  27 +-
 3 files changed, 257 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index d40f25a1a74a739315716a4066987f1137de88d9..d4c7426750016fd21e88a15e071fd2fb3da67ebe 100644
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
index 959886434d07fa32c62dacb041945a4587d3bb16..759b65040a159339a5ab9a2eb95acaaa2e452f53 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -7,25 +7,77 @@
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
+		/* Reject new admissions once the channel has latched a genuine
+		 * timeout -- but not for a deliberate no-wait teardown, where
+		 * mana_serv_reset() sets hwc_timeout = 0 to best-effort post
+		 * the teardown commands.  Without this exception an earlier
+		 * timeout would block those teardown commands here before the
+		 * hwc_timeout == 0 path in mana_hwc_send_request() can run.
+		 */
+		if (hwc->hwc_timed_out && hwc->hwc_timeout != 0) {
+			spin_unlock_irqrestore(&r->lock, flags);
+			return -ETIMEDOUT;
+		}
 
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+		index = find_first_zero_bit(r->map, r->size);
+		if (index < r->size) {
+			struct hwc_caller_ctx *ctx;
+
+			ctx = &hwc->caller_ctx[index];
+			reinit_completion(&ctx->comp_event);
+			/* Initialise the slot before publishing its inflight
+			 * bit below.  The response-side reference is taken
+			 * here, under r->lock, so a stale or duplicate response
+			 * that lands before mana_hwc_send_request() posts the
+			 * request cannot drop the refcount to zero and free the
+			 * slot under the sender.  One reference is the sender's;
+			 * the other is released by mana_hwc_handle_resp().
+			 */
+			refcount_set(&ctx->refcnt, 2);
+			ctx->responded = false;
+			ctx->msg_id = index;
+			ctx->error = -EINPROGRESS;
+			/* Publish the slot last.  mana_hwc_handle_resp() honours
+			 * a response only after the sender sets ctx->output_buf
+			 * (under ctx->lock, after this function returns), so the
+			 * initialisation above is always visible before any
+			 * response is acted on.
+			 */
+			bitmap_set(r->map, index, 1);
+			spin_unlock_irqrestore(&r->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&r->lock, flags);
 
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+		wait_event(hwc->msg_waitq,
+			   (READ_ONCE(hwc->hwc_timed_out) &&
+			    READ_ONCE(hwc->hwc_timeout) != 0) ||
+			   !bitmap_full(r->map, r->size));
 
-	spin_unlock_irqrestore(&r->lock, flags);
+		/* Same no-wait teardown exception as the entry gate above:
+		 * when hwc_timeout == 0 do not bail on the latch, wait for a
+		 * slot to free so the best-effort teardown command can still
+		 * be posted instead of spinning here.
+		 */
+		if (READ_ONCE(hwc->hwc_timed_out) &&
+		    READ_ONCE(hwc->hwc_timeout) != 0)
+			return -ETIMEDOUT;
+	}
 
 	*msg_id = index;
-
 	return 0;
 }
 
@@ -35,10 +87,17 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
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
@@ -116,22 +175,41 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 		resp_len = 0;
 	}
 
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (err)
-		goto out;
-
-	ctx->status_code = resp_msg->status;
+	spin_lock(&ctx->lock);
+
+	/* Honour a response only while the sender is actively waiting on
+	 * this slot -- that is, it has published ctx->output_buf and not yet
+	 * reclaimed it.  A NULL output_buf means the sender has not posted
+	 * its request yet (so this is a premature, stale or forged response
+	 * that must not complete the slot and let it be freed while the real
+	 * request is still in flight) or it already timed out and took
+	 * ownership back.  ctx->responded drops a second, duplicate response.
+	 * In all these cases drop the response without touching the refcount
+	 * or the completion; the genuine response, the sender or the teardown
+	 * path still balances the references.
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
@@ -218,7 +296,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
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
@@ -732,7 +815,7 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
-	sema_init(&hwc->sema, num_msg);
+	init_waitqueue_head(&hwc->msg_waitq);
 
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
 	if (err)
@@ -762,8 +845,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
+		spin_lock_init(&ctx[i].lock);
 		init_completion(&ctx[i].comp_event);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -774,6 +859,9 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
+	/* No RCU needed: called only from mana_hwc_create_channel
+	 * during init, before the channel is published to senders.
+	 */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
@@ -1023,13 +1111,19 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
 
@@ -1041,8 +1135,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -1058,43 +1155,134 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		dest_vrcq = hwc->pf_dest_vrcq_id;
 	}
 
+	/* handle_resp()'s reference was taken in mana_hwc_get_msg_index(),
+	 * so hardware responding immediately after the doorbell ring cannot
+	 * release the slot before this sender is done with it.
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
+		err = -ETIMEDOUT;
+
+		/* A deliberate no-wait send -- mana_serv_reset() sets
+		 * hwc_timeout = 0 when the HWC is already unresponsive and it
+		 * only needs to best-effort post the teardown commands -- is
+		 * expected to expire here.  Do not latch hwc_timed_out for it:
+		 * that would make mana_hwc_get_msg_index() reject the remaining
+		 * teardown commands before they are even posted.  Release the
+		 * slot through the out: path so the next command can reuse it,
+		 * matching the pre-refcount behaviour where every command was
+		 * posted and only the wait was skipped.
+		 */
+		if (wait_ms == 0)
+			goto out;
 
-		/* Reduce further waiting if HWC no response */
+		/* Genuine timeout: no response arrived.  Reduce further
+		 * waiting, and mark the channel timed out under the bitmap
+		 * lock so get_msg_index() cannot acquire new slots after this.
+		 */
 		if (hwc->hwc_timeout > 1)
 			hwc->hwc_timeout = 1;
 
-		err = -ETIMEDOUT;
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		WRITE_ONCE(hwc->hwc_timed_out, true);
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+		wake_up_all(&hwc->msg_waitq);
+
+		/* Release the slot through out:, which also drops the
+		 * response-side reference taken in mana_hwc_get_msg_index().
+		 * A late response for this slot cannot drop it -- once the
+		 * sender NULLs output_buf, mana_hwc_handle_resp() early-returns
+		 * without touching the refcount -- so the sender must free it
+		 * here, otherwise the slot bit would leak until channel
+		 * teardown.
+		 */
 		goto out;
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
+	/* Reached by the pre-post error paths (request never submitted), by
+	 * the deliberate no-wait teardown, and by a genuine timeout (request
+	 * posted, but no valid response arrived).  In every case the sender
+	 * must drop the response-side reference taken in
+	 * mana_hwc_get_msg_index() and its own.  Guard against a stale or
+	 * forged response that raced in first: latch ->responded under the
+	 * lock so any later handle_resp() is a no-op, and drop the response-
+	 * side reference here only if handle_resp() has not already done so.
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
index 8340abd36af611c658fecb6f1604ce3d4aedbddc..23bf83e2a3ec6a5b19ab54db0a65ae41b74ad74c 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -171,8 +171,25 @@ struct hwc_caller_ctx {
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
+	/* Set under lock by the first handle_resp() for this slot so a
+	 * duplicate or replayed response is dropped instead of consuming
+	 * the response-side reference a second time.
+	 */
+	bool responded;
 };
 
 struct hw_channel_context {
@@ -193,8 +210,9 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
-	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
+	/* Waitqueue for senders blocked on a full inflight bitmap. */
+	wait_queue_head_t msg_waitq;
 
 	u32 pf_dest_vrq_id;
 	u32 pf_dest_vrcq_id;
@@ -206,6 +224,11 @@ struct hw_channel_context {
 	 */
 	u32 rx_leaked_wqe;
 
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

