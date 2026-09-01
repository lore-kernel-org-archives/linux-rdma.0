Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBC945560C;
	Tue,  1 Sep 2026 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292871; cv=none; b=WmVuoTIEfP6CtEItZIRO3rKU9FI8INXJfiDsHD8grchQzm3czOtlX6i0xKz/F0QZISBJSx+5npIpn9TcJYVFQOXvxFLzbKBW6QvrYrxmi/Q7NC42FRZk1w3UOL/Y6F533OBOCfJU9/E6VJqHn1Z8EHmkD506p/C9Gxkrfd2Q8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292871; c=relaxed/simple;
	bh=LpNbLkNIRatV6IwjRqYY23CWEcwh/PKkTN7PmbY289I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REIjdojffWcJkGcbQ9kH12G9dOppV0MOfqLFk8bXd2KiVOmLqdDWkJJxovECdsue1lgE04Gmp69Hn9HvgvDXfdOL18O92g/uxQKTgRp3Ay//6Acf+0RCYZdhRWlmKZz2doPk6UCxa19dEYUaxMaxp+z+D9pHJ0K1IC7PPqne/Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 0A6F720B7128; Tue,  1 Sep 2026 13:00:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A6F720B7128
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
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 2/4] net: mana: give each HWC message slot its own completion state
Date: Tue,  1 Sep 2026 13:00:14 -0700
Message-ID: <20260901200018.3194525-3-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901200018.3194525-1-longli@microsoft.com>
References: <20260901200018.3194525-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

An HWC message slot is currently owned jointly by the sender and the
response handler with nothing arbitrating between them: the sender
publishes ctx->output_buf, waits, and on timeout releases the slot, while
mana_hwc_handle_resp() writes through that pointer from the CQ interrupt.
At the bootstrap queue depth of one this is survivable because there is
never more than one command outstanding.

Give each slot the state it needs to be owned independently:

  - a per-slot spinlock, so the sender's timeout path and the response
    handler serialise on the slot rather than on the channel;
  - a refcount holding one reference for the sender and one for the
    response handler, with the last put releasing the bitmap slot, so
    neither side can retire a slot the other is still using;
  - a responded flag, set by whichever side gets there first, so a
    second response for the same request is dropped rather than applied
    twice.

ctx->output_buf becomes the sender's ownership marker: the handler
honours a response only while it is published and the slot has not
already been answered.  ctx->error also changes from u32 to int, since it
carries a negative errno.

A response that arrives after its slot has already been released and
reused is still applied to the new owner; the slot index is the only
thing correlating a response to a request, so nothing here can tell the
two apart.  The next patch stops the slot being released at all while a
response may still arrive.

No functional change is intended at the current queue depth of one.  This
is preparation for allowing several commands to be in flight at once,
which is what makes independent per-slot ownership necessary.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |   8 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 167 +++++++++++++++---
 include/net/mana/hw_channel.h                 |  18 +-
 3 files changed, 165 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index f92b2d0bf926e1b715ff665d37f8173a2103e6fe..a023d3e1a95deeea3d15860f6fe7cab24f0b64e5 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -331,7 +331,13 @@ static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
 	if (err || resp.hdr.status)
 		return err ? err : -EPROTO;
 
-	*timeout_val = resp.timeout_ms;
+	/* Zero is the driver's own "do not wait, do not log" sentinel, set by
+	 * mana_serv_reset() when the HWC has stopped responding.  A zero from
+	 * the device would enter that state instead: ignore it and keep the
+	 * caller's positive value.
+	 */
+	if (resp.timeout_ms)
+		*timeout_val = resp.timeout_ms;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 75fdccdc8c48201b011a243fd0bd41b84c477076..0056bdd8c53f5bf6b6b5f318f21faf7d9e14de53 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,9 +6,11 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
+/* Acquire a free inflight message slot, waiting for one if all are in use. */
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
+	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	u32 index;
 
@@ -19,6 +21,17 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	index = find_first_zero_bit(hwc->inflight_msg_res.map,
 				    hwc->inflight_msg_res.size);
 
+	ctx = &hwc->caller_ctx[index];
+	reinit_completion(&ctx->comp_event);
+	/* Take both references (sender + handle_resp) before publishing the
+	 * slot, so an early response cannot free it under the sender.
+	 */
+	refcount_set(&ctx->refcnt, 2);
+	ctx->responded = false;
+	ctx->msg_id = index;
+	ctx->error = -EINPROGRESS;
+
+	/* Publish the slot last, after it is fully initialised. */
 	bitmap_set(hwc->inflight_msg_res.map, index, 1);
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -40,6 +53,13 @@ static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
 	up(&hwc->sema);
 }
 
+static void hwc_ctx_put(struct hw_channel_context *hwc,
+			struct hwc_caller_ctx *ctx)
+{
+	if (refcount_dec_and_test(&ctx->refcnt))
+		mana_hwc_put_msg_index(hwc, ctx->msg_id);
+}
+
 static int mana_hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
 				    const struct gdma_resp_hdr *resp_msg,
 				    u32 resp_len)
@@ -90,22 +110,35 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (err)
-		goto out;
 
-	ctx->status_code = resp_msg->status;
+	spin_lock(&ctx->lock);
 
-	memcpy(ctx->output_buf, resp_msg, resp_len);
-out:
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
+
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
@@ -657,8 +690,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
+		spin_lock_init(&ctx[i].lock);
 		init_completion(&ctx[i].comp_event);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -669,6 +704,12 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
+	/* mana_hwc_init_event_handler() fills the bootstrap fields from hard
+	 * IRQ on GDMA_EQE_HWC_INIT_DATA and then signals hwc_init_eqe_comp on
+	 * GDMA_EQE_HWC_INIT_DONE.  The wait_for_completion() below pairs with
+	 * that complete(), so every value stored before INIT_DONE is ordered
+	 * against the reads that follow it here.
+	 */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
@@ -867,13 +908,19 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
 
@@ -885,8 +932,11 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
+
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -902,43 +952,108 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
+			/* A response raced in just after the timeout, so the
+			 * hardware is alive: keep the channel and report what
+			 * that response said rather than a timeout.  It may
+			 * itself be an error -- a malformed response leaves
+			 * -EPROTO here -- which is still the answer to this
+			 * command.
+			 */
+			hwc_ctx_put(hwc, ctx);
+			goto check_status;
+		}
+
+		if (wait_ms != 0)
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
+				command, wait_ms);
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
index 237608b488e5ee773d7889d3c1d291ca92ebbeb9..daff051472a0dd9f57ee0b9fb3d71029fca909ad 100644
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
-- 
2.43.0

