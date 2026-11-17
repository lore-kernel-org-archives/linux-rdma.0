Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931276;
	b=GTSx+ATcHOIFPKygdH68ZwvG9gnBXTPcIYE8N4M50hjvEaTAmiQb95tr7WRQnu9PoLyn
	 ZLUuu3+zgqiDxWHObgBjNils9lOOFFqzB+vChcaHYxkEJpGVvNIeyXaiEz8bdDMX7fJAD
	 SfCJj/Kw52U0py/xlvHslNrmIkXnsjf/O86vEnO2xnFYbxk8lVDOHqokVlbb+iiY7UgDT
	 14TmX21cCsELvy0xtZSNEPB3ImH8fJyQF9OPtzb4tcmCPWdyedGvuq5o4QIE65zA9He6m
	 EWE9+tBmdQf4gv2E24qzf+Sl6qNjyL8thYfjovkV8Y4WU32K4u9t/dLiNJydk/0mSXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931276;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=XYdyTfSUzueQVvCDRsPhvLxTUSbaWYQF/jWn2LIlP8c=;
	b=sAlHX7x/v08IsBD5ABd5Ix7YJvrm/63rb42aeW9vT1zfZinyfpSPxl3QtTK7tbfaJeYR
	 OvenSu6oQELvCOQfDumBYFeEIhMn+insoVIxwOKHalrzc3wQLpKWHWUHrIVl4XFJnQt9O
	 dorAUl+MnjGC80m4LqVrq1CNLQL9iix45s+1fyCzZuxwiw5nVqSnzp71QTsHHwNCKNZye
	 ZnR3azWnJjUYXnbv+C9W9+AzMky00viq24jyaoMHhcSamqlDqTASykXsc+/3gVjIr48/U
	 q5MkMgoBLYMm/QJHzxdMaf9EH4zpY0poOMDawRHo8hD7K8UZPlrW7zwh7WMVtHKWy5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="n/5hDP+w";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC83606A896;
	Tue, 17 Nov 2026 16:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FC83606A896
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=n/5hDP+w
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id B112420B716C;
	Tue, 17 Nov 2026 08:01:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B112420B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794931269;
	bh=XYdyTfSUzueQVvCDRsPhvLxTUSbaWYQF/jWn2LIlP8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/5hDP+woofI2KDVuLPu3i/KBo8cta7Gt21fdSOhQDtsrm53YLzkJdna8q7HNO81J
	 pwEAkm8+Jnvbzsk6skYzVfhs/A5iYH2Qya598EGm/eKo7mfpGP7Q5/S4O90mUI1laB
	 LGvWt1i6iZzpJ2bpafqYzjd5UT0/KT8O3M3HuoPg=
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
Subject: [PATCH net-next v11 2/4] net: mana: give each HWC message slot its own completion state
Date: Tue, 17 Nov 2026 16:00:59 +0000
Message-ID: <42d753b49df1b873b2f0f6477771820e14e9fab4.1794751992.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
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
and withdraw it before every return. This fixes the original driver's
late response copy through caller storage whose lifetime has ended.

Reinitialize completion and result state under both the allocation and
per-slot locks when acquiring the slot. This also fixes stale completion
state surviving a timed-out request. A response handler can still hold the
per-slot lock after the previous sender has returned its admission permit,
so an unpublished bitmap bit alone is not sufficient protection. If the
response records its result while the timed wait expires, return that
result instead of reporting a false timeout.

Keep the baseline's post-timeout admission behavior at this step rather
than introducing a temporary channel-wide latch that suppresses subsequent
teardown commands. This patch alone does not solve late-response
correlation or TX-buffer reuse after a timeout. The next patch adds
response ownership, per-slot quarantine and the associated admission and
cleanup rules together; backporting the fixes needs that dependency.

Split response-status handling and request cleanup into helpers so the send
path has structured returns rather than phase-jumping gotos.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Link: https://lore.kernel.org/r/179455239815.2199510.4673285259543925635@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
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

