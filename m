Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C8C3B6C16;
	Wed,  7 Oct 2026 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377634; cv=none; b=dqJ4moGSVkpT1VV0xwi+5Sxqv9Nr+nXacfDkrJEYX1HoAuzMiqCsLhL2hG0auHpuiJOMdn8QtZsuFKFzLkev4JAFxzZCRf3PpJqeDYWWBnmz6Tk+CrToBcHkvVVMleA3Smo9HrkuH0zY4CckaBn1FujTnTQxWtM+WrosRvAUaJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377634; c=relaxed/simple;
	bh=SFFoFF5yPNBOd5fBlrpS+HUrawLXYyhxa36iuPfThVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1G/8dlRfzO21jPZ2z89Uw1nlnnmJF7k8bO5i14rureZ+e2aBydNAaKU2qM6YMK8tk9iclWKXV70sGZU1yckmr32eB8wYIJvp4uRF3lXLslxCvNi4zvSzWpKPcgEOpXxYq+cu8ZEKR3CnP6pwokkpNzZ/FqUiw2Vifs9/qfL0XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=kSpuK3z8; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kSpuK3z8"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7AC120B7169;
	Wed,  7 Oct 2026 05:52:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7AC120B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791377567;
	bh=ZMnnWeHXSpDVUt+A3fnCOldDm1t+4u/Z/535YbcqrB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSpuK3z8zhxFSZDIg3v4ela2O50cMXkBt7FzXrnWMXh0hLhUjFU3IXlh2JY3ePfM2
	 UIMmFOPIRfiViCSrW96RoGxTuyATpxPua23SSVZGnWhoNsH2neOHtyRyhrDZ28jVgt
	 Cf+Zst5eb2ULNa1UfnyZj33d1TC/5m4gIrCvwQos=
From: Wei Hu <weh@linux.microsoft.com>
To: Long Li <longli@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Shiraz Saleem <shirazsaleem@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Kees Cook <kees+treewide@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Manish Awasthi <mawasthi@linux.microsoft.com>,
	Wei Hu <weh@microsoft.com>
Subject: [PATCH net-next v6 2/4] net: mana: give each HWC message slot its own completion state
Date: Wed,  7 Oct 2026 12:53:28 +0000
Message-ID: <58fd3296e5fa48a9fc91eb4059a4f4162d4d8479.1790670523.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790665894.git.weh@linux.microsoft.com>
References: <cover.1790665894.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Concurrent requests require the response handler and the waiting sender to
agree on the lifetime and result state of each message slot.

Protect the caller's output buffer, Linux error and device status with a
per-slot lock. Publish the output buffer only while the sender is waiting
and withdraw it before every return. A late response therefore cannot copy
through a pointer to caller storage whose lifetime has ended.

Reinitialize completion and result state when the slot is acquired. If
the response records its result while the timed wait expires, return that
result instead of reporting a false timeout.

HWC responses contain only the slot ID. After a genuine timeout, prevent
the serialized bootstrap channel from reusing that ID until teardown. This
keeps a stale response from completing a later request before the next
patch replaces the depth-one latch with per-slot sender and response
ownership.

Split response-status handling and request cleanup into helpers so the send
path has structured returns rather than phase-jumping gotos.

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 134 +++++++++++++-----
 include/net/mana/hw_channel.h                 |   7 +-
 2 files changed, 106 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index b1d972968f0d..89b6e30863da 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -9,6 +9,7 @@
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
+	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	u32 index;
 
@@ -16,9 +17,22 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 
 	spin_lock_irqsave(&r->lock, flags);
 
+	if (hwc->hwc_timed_out) {
+		spin_unlock_irqrestore(&r->lock, flags);
+		up(&hwc->sema);
+		return -ETIMEDOUT;
+	}
+
 	index = find_first_zero_bit(hwc->inflight_msg_res.map,
 				    hwc->inflight_msg_res.size);
 
+	ctx = &hwc->caller_ctx[index];
+	reinit_completion(&ctx->comp_event);
+	ctx->output_buf = NULL;
+	ctx->output_buflen = 0;
+	ctx->error = -EINPROGRESS;
+	ctx->status_code = 0;
+
 	bitmap_set(hwc->inflight_msg_res.map, index, 1);
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -28,12 +42,15 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	return 0;
 }
 
-static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
+static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id,
+				   bool timed_out)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
+	if (timed_out)
+		hwc->hwc_timed_out = true;
 	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
 	spin_unlock_irqrestore(&r->lock, flags);
 
@@ -90,14 +107,21 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (err)
-		goto out;
 
-	ctx->status_code = resp_msg->status;
+	spin_lock(&ctx->lock);
+	if (!ctx->output_buf) {
+		spin_unlock(&ctx->lock);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
 
-	memcpy(ctx->output_buf, resp_msg, resp_len);
-out:
+	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
+	if (!err) {
+		ctx->status_code = resp_msg->status;
+		memcpy(ctx->output_buf, resp_msg, resp_len);
+	}
+
+	ctx->output_buf = NULL;
 	ctx->error = err;
 
 	/* Must post rx wqe before complete(), otherwise the next rx may
@@ -106,6 +130,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 
 	complete(&ctx->comp_event);
+	spin_unlock(&ctx->lock);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -694,8 +719,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
 		init_completion(&ctx[i].comp_event);
+		spin_lock_init(&ctx[i].lock);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -958,6 +985,38 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	vfree(old_cq_table);
 }
 
+static int mana_hwc_response_status(struct hw_channel_context *hwc,
+				    u32 command, int error, u32 status)
+{
+	if (error)
+		return error;
+
+	if (!status || status == GDMA_STATUS_MORE_ENTRIES)
+		return 0;
+
+	if (status == GDMA_STATUS_CMD_UNSUPPORTED)
+		return -EOPNOTSUPP;
+
+	if (command != MANA_QUERY_PHY_STAT)
+		dev_err(hwc->dev, "Command 0x%x failed with status: 0x%x\n",
+			command, status);
+
+	return -EPROTO;
+}
+
+static void mana_hwc_finish_request(struct hw_channel_context *hwc,
+				    struct hwc_caller_ctx *ctx, u16 msg_id,
+				    bool timed_out)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	mana_hwc_put_msg_index(hwc, msg_id, timed_out);
+}
+
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp)
 {
@@ -965,26 +1024,32 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
 	u32 dest_vrcq;
 	u32 dest_vrq;
 	u32 command;
+	u32 status;
 	u16 msg_id;
 	int err;
 
-	mana_hwc_get_msg_index(hwc, &msg_id);
+	err = mana_hwc_get_msg_index(hwc, &msg_id);
+	if (err)
+		return err;
 
 	tx_wr = &txq->msg_buf->reqs[msg_id];
+	ctx = hwc->caller_ctx + msg_id;
 
 	if (req_len > tx_wr->buf_len) {
 		dev_err(hwc->dev, "HWC: req msg size: %d > %d\n", req_len,
 			tx_wr->buf_len);
-		err = -EINVAL;
-		goto out;
+		mana_hwc_finish_request(hwc, ctx, msg_id, false);
+		return -EINVAL;
 	}
 
-	ctx = hwc->caller_ctx + msg_id;
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -1006,11 +1071,23 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
-		goto out;
+		mana_hwc_finish_request(hwc, ctx, msg_id, false);
+		return err;
 	}
 
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
+					 msecs_to_jiffies(hwc->hwc_timeout))) {
+		spin_lock_irqsave(&ctx->lock, flags);
+		ctx->output_buf = NULL;
+		err = ctx->error;
+		status = ctx->status_code;
+		spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (err != -EINPROGRESS) {
+			mana_hwc_finish_request(hwc, ctx, msg_id, false);
+			return mana_hwc_response_status(hwc, command, err, status);
+		}
+
 		if (hwc->hwc_timeout != 0)
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
 				command, hwc->hwc_timeout);
@@ -1019,27 +1096,16 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		if (hwc->hwc_timeout > 1)
 			hwc->hwc_timeout = 1;
 
-		err = -ETIMEDOUT;
-		goto out;
+		mana_hwc_finish_request(hwc, ctx, msg_id, true);
+		return -ETIMEDOUT;
 	}
 
-	if (ctx->error) {
-		err = ctx->error;
-		goto out;
-	}
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	err = ctx->error;
+	status = ctx->status_code;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
-	if (ctx->status_code && ctx->status_code != GDMA_STATUS_MORE_ENTRIES) {
-		if (ctx->status_code == GDMA_STATUS_CMD_UNSUPPORTED) {
-			err = -EOPNOTSUPP;
-			goto out;
-		}
-		if (command != MANA_QUERY_PHY_STAT)
-			dev_err(hwc->dev, "Command 0x%x failed with status: 0x%x\n",
-				command, ctx->status_code);
-		err = -EPROTO;
-		goto out;
-	}
-out:
-	mana_hwc_put_msg_index(hwc, msg_id);
-	return err;
+	mana_hwc_finish_request(hwc, ctx, msg_id, false);
+	return mana_hwc_response_status(hwc, command, err, status);
 }
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index eb1c005bc091..e733301f8740 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -168,10 +168,12 @@ struct hwc_wq {
 
 struct hwc_caller_ctx {
 	struct completion comp_event;
+	/* Protects the output buffer and response state from timeout. */
+	spinlock_t lock;
 	void *output_buf;
 	u32 output_buflen;
 
-	u32 error; /* Linux error code */
+	int error; /* Linux error code */
 	u32 status_code;
 };
 
@@ -201,6 +203,9 @@ struct hw_channel_context {
 	u32 dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Prevents message ID reuse after a timeout; protected by the map lock. */
+	bool hwc_timed_out;
+
 	/* The PF may own the HWC queues while this is true. */
 	bool setup_active;
 	struct hwc_caller_ctx *caller_ctx;
-- 
2.43.0

