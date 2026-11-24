Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534872;
	b=yTUJFMfp9IIVQKjGzouh3lRvTf02pcq6u/rU2v8EcqK9a7WDQz9wkEF4PAcix5EoRhMN
	 mfuPshUkEG0+jLp7NRCOVMYJbU051ZnjFMFMDzFyv04pkoeodi+GOXSJBCYgv1LPqy0IY
	 57rOusBkzWHc1bGFrbAQEEjiqeI+qxztWgbS7onaELwC17P/mZfh9gfLp39xHBTbcuEbb
	 u5TxSX2cNsEAzTk8Q5P/25EyGdrnHnqan7oJt+Eo0P2GmiW6C+qsEDuGt++DrY0LpjIOT
	 luyKTOGqfvRMNoFFVtu5wCLncnyCHUjx2kpUPeqs1Z8hh67kJT1morQEKa4k+FfcEXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534872;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=F/F+/Vl9CXYnxppmJ1inDEnMHeZ7DKWXFKbh0mG1AVA=;
	b=bHL1SI8tdYz0WibyLCqR86kED2UUi3LVcPgMiRWYU/vShXdrWmDI1iaBqYuIaufyLlZm
	 Uv19rM8Aw+RjatvNC3SeH6yJpwMBlt9za0+1kyN6JQ8Jlx6fXReiIGjrMI/kMekSH1Ca6
	 AgkiI6fdz7EeEPTFG6YAI7DOe9LahDLkS50lyNO+N2uKccYLs4+lFEs82WNMDKBJUDhH1
	 naTe1fIej2xkkfHHi8kt0oMpnfuw5/c2gn6bJITjRxlH7ZQt9bGoLcs4QPzEoNNcKFiNI
	 pxDo3j0vedX1d9qdJCe+dar45LRC5SfIJlf4I+oysgPwZE2zG7diiLUfqB+9waFZyUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=mUZRuf+5;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1399606A32C;
	Tue, 24 Nov 2026 15:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1399606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=mUZRuf+5
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id D768420B7171;
	Tue, 24 Nov 2026 07:41:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D768420B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534866;
	bh=F/F+/Vl9CXYnxppmJ1inDEnMHeZ7DKWXFKbh0mG1AVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUZRuf+5/rvsWD2v+viEqarL9Dc1CrwWNo6bop59T9dFGT5jOdq1tk3EmZCGCRumD
	 QKbUslhhCSY6ZFugXo1Btwz9o7srbcISpD1rHqfpCn/IHQdNZf+DbBorR9u/f3FSpK
	 +I69L0tg0jSw2HUNaWzHl2LtPW0iZpvwY2Fqy18I=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org,
	shacharr@microsoft.com
Subject: [PATCH net-next v12 3/5] net: mana: protect the HWC response buffer until the sender returns
Date: Tue, 24 Nov 2026 15:40:56 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.3@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>
Date: Mon, 7 Sep 2026 20:51:56 -0700

A response can race with a sender that has timed out. Clear the output
pointer under the same lock used to copy the response, so the handler
cannot write to the caller's buffer after the sender returns.

Reset the completion and result under that lock when assigning a slot.
If the response wins the race with timeout, return its result. This
does not change admission or prevent reuse of the message ID.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 125 +++++++++++++-----
 include/net/mana/hw_channel.h                 |   4 +-
 2 files changed, 95 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 39a0ed32e43c7953885146b647249db6e03fb8bb..a98e58b83f9c75bf8b40183c73a9286670d4aef4 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -9,6 +9,7 @@
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
+	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	u32 index;
 
@@ -19,8 +20,17 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	index = find_first_zero_bit(hwc->inflight_msg_res.map,
 				    hwc->inflight_msg_res.size);
 
+	ctx = &hwc->caller_ctx[index];
+	spin_lock(&ctx->lock);
+	reinit_completion(&ctx->comp_event);
+	ctx->output_buf = NULL;
+	ctx->output_buflen = 0;
+	ctx->error = -EINPROGRESS;
+	ctx->status_code = 0;
+
 	bitmap_set(hwc->inflight_msg_res.map, index, 1);
 
+	spin_unlock(&ctx->lock);
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	*msg_id = index;
@@ -90,14 +100,21 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
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
@@ -106,6 +123,7 @@ out:
 	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 
 	complete(&ctx->comp_event);
+	spin_unlock(&ctx->lock);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -709,8 +727,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
 		init_completion(&ctx[i].comp_event);
+		spin_lock_init(&ctx[i].lock);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -1019,6 +1039,37 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
 	gc->hwc.gdma_context = NULL;
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
+				    struct hwc_caller_ctx *ctx, u16 msg_id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	mana_hwc_put_msg_index(hwc, msg_id);
+}
+
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp)
 {
@@ -1026,26 +1077,32 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
+		mana_hwc_finish_request(hwc, ctx, msg_id);
+		return -EINVAL;
 	}
 
-	ctx = hwc->caller_ctx + msg_id;
+	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = resp;
 	ctx->output_buflen = resp_len;
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
 	if (req)
@@ -1067,11 +1124,24 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
-		goto out;
+		mana_hwc_finish_request(hwc, ctx, msg_id);
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
+			mana_hwc_finish_request(hwc, ctx, msg_id);
+			return mana_hwc_response_status(hwc, command, err,
+							status);
+		}
+
 		if (hwc->hwc_timeout != 0)
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
 				command, hwc->hwc_timeout);
@@ -1080,27 +1150,16 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		if (hwc->hwc_timeout > 1)
 			hwc->hwc_timeout = 1;
 
-		err = -ETIMEDOUT;
-		goto out;
+		mana_hwc_finish_request(hwc, ctx, msg_id);
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
+	mana_hwc_finish_request(hwc, ctx, msg_id);
+	return mana_hwc_response_status(hwc, command, err, status);
 }
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index fc2c26f809047703244ffd30ff4a7a115c682617..bcaf276976a81dca825ee08804a3b2fa5ee24a9a 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -168,10 +168,12 @@ struct hwc_wq {
 
 struct hwc_caller_ctx {
 	struct completion comp_event;
+	/* Protects initialization, output storage and response state. */
+	spinlock_t lock;
 	void *output_buf;
 	u32 output_buflen;
 
-	u32 error; /* Linux error code */
+	int error; /* Linux error code */
 	u32 status_code;
 };
 
