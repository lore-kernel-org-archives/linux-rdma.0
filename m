Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239124;
	b=VFoSZ1i1FOCHXvx9ztKqOjEfuUluhqB7uZSV6hBYjZSYCEsIKFVxnctV00fXlyuR4eTf
	 kTd6ETEo7rJw/Jl8eNgL6GObxQ2hHNaQva8Lmb3OFVhxR2wjVXbSPiTr16mzMz//otgUm
	 NlvUXkyYUlXQiwSpFd6IMOxNThWvf8UV9Mq/HRck/eh6WXnNFgLQl5xQSP1w2bRXwh6vq
	 tBgt5W/SJSGHPaXM7kQnlx3av2dyjuWhTPzc9SWkADO+Kb5ci/kabIKLkbTxEptSSEVSq
	 LPHmRNs/FDeXdeZcMfWn/Rl09UsAmmCNXhzum7Ou/U92GJ71ufFKxQdYwXkZegilvoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239124;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Cd1j/B3pJzY0aU03c7gXA1sXIQpFXYWw2jtLx5nEQHc=;
	b=EgqMrgfCR4PFK4oE8QT9iBDI+msvUiTu0av3/uTCk/F4enNhjQknECdM7Q78UDFBF8iG
	 fXFPme/wMrocWQgsElB0Us2QOAX3RIdi5ipZaVRwjF/aSJr+NdQBpApds2CS7QhPn2rvO
	 Z6wt+1WYYsncYMTZvrTpmCArUQurm2LXWhzp9wVhwL1sCeW88xjcsTIbNArX7ATtc880u
	 PRqDsdJcAMQBphRqqveRahCYQ2DK5hXiHNXk+yRpqi/0dhL6+JfZZTJVO0J8n8YHJ9d0b
	 UT8ggqN1Pd3+EJnwmbZXFvMIbP3JLFCwA/yBRPxobi8oQJ8eTPL1kfbuhbU/57sbWLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J05PWQc6;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC50F606EE9B;
	Mon,  9 Nov 2026 15:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC50F606EE9B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=J05PWQc6
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 38A1120B716B;
	Mon,  9 Nov 2026 07:45:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 38A1120B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794239121;
	bh=Cd1j/B3pJzY0aU03c7gXA1sXIQpFXYWw2jtLx5nEQHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J05PWQc68MjM5f+MbIyMinUef0audUaQblwx5hXdQaLUK1J5ppIO0kkXLctrjq1a/
	 VsxXo1PV+ShsTS3IFLmO0AD4DFmaQ7IPXRj0XZd9tOV0gKrEd9RM/Pn7er3w2N/Kik
	 2MSNUFdeGC4eQPiZz23wcwHI/PcT7iI3LiH4cB1g=
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
	edumazet@kernel.org
Subject: [PATCH net-next v10 2/4] net: mana: give each HWC message slot its own completion state
Date: Mon,  9 Nov 2026 15:45:01 +0000
Message-ID: <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794208055.git.weh@linux.microsoft.com>
References: <cover.1794208055.git.weh@linux.microsoft.com>
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

Concurrent requests require the response handler and the waiting sender to
agree on the lifetime and result state of each message slot.

Protect the caller's output buffer, Linux error and device status with a
per-slot lock. Publish the output buffer only while the sender is waiting
and withdraw it before every return. A late response cannot copy through a
pointer to caller storage whose lifetime has ended.

Reinitialize completion and result state under both the allocation and
per-slot locks when acquiring the slot. A response handler can still hold
the per-slot lock after the previous sender has returned its admission
permit, so an unpublished bitmap bit alone is not sufficient protection.
If the response records its result while the timed wait expires, return
that result instead of reporting a false timeout.

Keep the baseline's post-timeout admission behavior at this step rather
than introducing a temporary channel-wide latch that suppresses subsequent
teardown commands. This does not solve late-response correlation after ID
reuse. The next patch adds response ownership, per-slot quarantine and the
associated admission and teardown rules together.

Split response-status handling and request cleanup into helpers so the send
path has structured returns rather than phase-jumping gotos.

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
Copilot-Session: 8c2361e6-c0f4-4b0c-bf01-b5e4cdacec50
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 125 +++++++++++++-----
 include/net/mana/hw_channel.h                 |   4 +-
 2 files changed, 95 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 9e0964072af9..6f0ccdeffc4f 100644
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
@@ -106,6 +123,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 
 	complete(&ctx->comp_event);
+	spin_unlock(&ctx->lock);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -696,8 +714,10 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i)
+	for (i = 0; i < q_depth; ++i) {
 		init_completion(&ctx[i].comp_event);
+		spin_lock_init(&ctx[i].lock);
+	}
 
 	hwc->caller_ctx = ctx;
 
@@ -1000,6 +1020,37 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
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
@@ -1007,26 +1058,32 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
@@ -1048,11 +1105,24 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
@@ -1061,27 +1131,16 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
index 1320bdfa9d2a..c7570a5f7376 100644
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
 
-- 
2.43.0

