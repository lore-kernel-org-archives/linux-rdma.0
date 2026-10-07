Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB29449A3A1;
	Wed,  7 Oct 2026 12:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377648; cv=none; b=VrzfxLZkeMesmP0CYp3mtRTI4XKNRgHy+VmO8SHVjCGlx5bV1FzqyN1cZqPkLpxJ545SqOoFcQqi8SiFmYaN2zINXjc/uEKfGMKyy6PPgOCt6bPcYifdR4Xu7eQe2e0lSta9Klkr75yzjnnqnvxYIDi/x0OYbY0HFIg+4Llqm6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377648; c=relaxed/simple;
	bh=rz0qvM/oPfBSgAGkDz5sQNSE8ppfH0hgSGy7MrGKwUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDL9fyQnW7NZGGY32THvCbv5B2XhicGs4LQnXdB5POo4vkZi+SFvU/vKBGCkeflnQF3Xbhh75+BEI8563tq4lrkns9pkQWbuPf2G9Wz5SfH5Tc/h6RyU2cAnI4sP08g3LweC+vOXJttX/4+ENIiFnwOeIJaeTVw+uPgTHX+DUOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=U7kj/wtZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="U7kj/wtZ"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id BE77320B716D;
	Wed,  7 Oct 2026 05:52:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BE77320B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791377571;
	bh=2GjMbv8xcrS1K8mt1CsTKXwkSKs/ne7sptYV1WqKBzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7kj/wtZlZvSj0z8N4uSAkM5RVWi9dRQNAEo97t4zGqR+gOTOdzcFcjP5Z1hX1PSZ
	 Rn88ioajvJxgbe+zgFbarUFbhvKQxf5HJo4hcjynsCTagFDnXienMvalLAxXLLrcja
	 lF15UpSkLi0ChW4zOSt9LqylWWECZsRYVgFRBChk=
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
Subject: [PATCH net-next v6 3/4] net: mana: support concurrent HWC requests
Date: Wed,  7 Oct 2026 12:53:29 +0000
Message-ID: <e954bfad6e48734927d900458afc00aa0a9a2e69.1790670523.git.weh@linux.microsoft.com>
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

Replace the depth-one timeout latch with per-slot sender and response
ownership. Initialize each slot under the inflight resource lock, publish
its bitmap bit last, and release it only after both sides have finished.
This preserves response-buffer withdrawal and timeout quarantine while
allowing independent message IDs to make progress.

Serialize SQ posting so concurrent senders cannot corrupt the producer
state. A posted request which times out keeps its response reference and
admission permit until its late response arrives or teardown cancels it.

Return -EBUSY when all slots remain occupied. Admission pressure is not a
response timeout and must not make callers start dead-channel recovery.

Synchronize hwc_timeout updates with atomic access helpers. Teardown
cancellation is terminal for a channel instance, firmware and query
updates may replace only a live timeout, and fail-fast reduction may only
lower a live value to one millisecond.

Keep setup private until the queues, admission state, caller contexts and
direct EQ test are ready. Runtime teardown unpublishes the channel, rejects
new admissions, wakes waiters and drains active senders before releasing or
retaining PF-owned mappings.

Split admission, submission, waiting, response status and unwind into
helpers so mana_hwc_send_request() uses structured returns instead of
phase-jumping gotos.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  80 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 578 +++++++++++++-----
 include/net/mana/gdma.h                       |   9 +
 include/net/mana/hw_channel.h                 |  43 +-
 4 files changed, 527 insertions(+), 183 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index f63e236d4d19..bf4c528f8c75 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -162,6 +162,8 @@ static int mana_gd_init_registers(struct pci_dev *pdev)
 bool mana_need_log(struct gdma_context *gc, int err)
 {
 	struct hw_channel_context *hwc;
+	bool need_log = true;
+	unsigned long flags;
 
 	if (err != -ETIMEDOUT)
 		return true;
@@ -169,11 +171,13 @@ bool mana_need_log(struct gdma_context *gc, int err)
 	if (!gc)
 		return true;
 
+	spin_lock_irqsave(&gc->hwc_lock, flags);
 	hwc = gc->hwc.driver_data;
-	if (hwc && hwc->hwc_timeout == 0)
-		return false;
+	if (hwc && !mana_hwc_timeout_read(hwc))
+		need_log = false;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	return true;
+	return need_log;
 }
 
 static int mana_gd_query_max_resources(struct pci_dev *pdev)
@@ -317,7 +321,8 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 	return 0;
 }
 
-static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
+static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 timeout_ms,
+				     u32 *new_timeout_ms)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct gdma_query_hwc_timeout_resp resp = {};
@@ -326,12 +331,12 @@ static int mana_gd_query_hwc_timeout(struct pci_dev *pdev, u32 *timeout_val)
 
 	mana_gd_init_req_hdr(&req.hdr, GDMA_QUERY_HWC_TIMEOUT,
 			     sizeof(req), sizeof(resp));
-	req.timeout_ms = *timeout_val;
+	req.timeout_ms = timeout_ms;
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err || resp.hdr.status)
 		return err ? err : -EPROTO;
 
-	*timeout_val = resp.timeout_ms;
+	*new_timeout_ms = resp.timeout_ms;
 
 	return 0;
 }
@@ -387,9 +392,27 @@ static int mana_gd_detect_devices(struct pci_dev *pdev)
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct hw_channel_context *hwc;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	hwc = gc->hwc.driver_data;
+	if (!hwc) {
+		spin_unlock_irqrestore(&gc->hwc_lock, flags);
+		return -ENODEV;
+	}
+	hwc->active_senders++;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+	err = mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (--hwc->active_senders == 0)
+		wake_up(&gc->hwc_drain_waitq);
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	return err;
 }
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
@@ -710,6 +733,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct hw_channel_context *hwc;
+	unsigned long flags;
 	int ret;
 
 	if (!gc) {
@@ -719,14 +743,17 @@ static void mana_serv_reset(struct pci_dev *pdev)
 		return;
 	}
 
+	spin_lock_irqsave(&gc->hwc_lock, flags);
 	hwc = gc->hwc.driver_data;
 	if (!hwc) {
+		spin_unlock_irqrestore(&gc->hwc_lock, flags);
 		dev_err(&pdev->dev, "MANA service: no HWC\n");
 		goto out;
 	}
 
 	/* HWC is not responding in this case, so don't wait */
-	hwc->hwc_timeout = 0;
+	mana_hwc_timeout_cancel(hwc);
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
 	dev_info(&pdev->dev, "MANA reset cycle start\n");
 
@@ -1107,7 +1134,9 @@ static void mana_gd_deregister_irq(struct gdma_queue *queue)
 	synchronize_rcu();
 }
 
-int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+static int mana_gd_test_eq_request(struct gdma_context *gc,
+				   struct hw_channel_context *hwc,
+				   struct gdma_queue *eq)
 {
 	struct gdma_generate_test_event_req req = {};
 	struct gdma_general_resp resp = {};
@@ -1125,7 +1154,12 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	req.hdr.dev_id = eq->gdma_dev->dev_id;
 	req.queue_index = eq->id;
 
-	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (hwc)
+		err = mana_hwc_send_request(hwc, sizeof(req), &req,
+					    sizeof(resp), &resp);
+	else
+		err = mana_gd_send_request(gc, sizeof(req), &req,
+					   sizeof(resp), &resp);
 	if (err) {
 		if (mana_need_log(gc, err))
 			dev_err(dev, "test_eq failed: %d\n", err);
@@ -1156,6 +1190,17 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	return err;
 }
 
+int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+{
+	return mana_gd_test_eq_request(gc, NULL, eq);
+}
+
+int mana_gd_test_hwc_eq(struct hw_channel_context *hwc,
+			struct gdma_queue *eq)
+{
+	return mana_gd_test_eq_request(hwc->gdma_dev->gdma_context, hwc, eq);
+}
+
 static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
 			       struct gdma_queue *queue)
 {
@@ -1348,6 +1393,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
+	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
@@ -1551,9 +1597,12 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	struct gdma_verify_ver_resp resp = {};
 	struct gdma_verify_ver_req req = {};
 	struct hw_channel_context *hwc;
+	u32 timeout_ms;
 	int err;
 
+	/* The setup caller must exclude concurrent HWC teardown. */
 	hwc = gc->hwc.driver_data;
+
 	mana_gd_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
 			     sizeof(req), sizeof(resp));
 
@@ -1589,12 +1638,16 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 			   &gc->pf_cap_flags1);
 
 	if (resp.pf_cap_flags1 & GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG) {
-		err = mana_gd_query_hwc_timeout(pdev, &hwc->hwc_timeout);
+		err = mana_gd_query_hwc_timeout(pdev,
+						mana_hwc_timeout_read(hwc),
+						&timeout_ms);
 		if (err) {
 			dev_err(gc->dev, "Failed to set the hwc timeout %d\n", err);
 			return err;
 		}
-		dev_dbg(gc->dev, "set the hwc timeout to %u\n", hwc->hwc_timeout);
+		mana_hwc_timeout_update(hwc, timeout_ms);
+		dev_dbg(gc->dev, "set the hwc timeout to %u\n",
+			mana_hwc_timeout_read(hwc));
 	}
 	return 0;
 }
@@ -2547,6 +2600,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
 	pci_set_drvdata(pdev, gc);
 	gc->bar0_pa = pci_resource_start(pdev, 0);
 	gc->bar0_size = pci_resource_len(pdev, 0);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 89b6e30863da..9fdd84ccba65 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,57 +6,122 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
-static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
+u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc)
+{
+	return READ_ONCE(hwc->hwc_timeout);
+}
+
+void mana_hwc_timeout_update(struct hw_channel_context *hwc, u32 timeout_ms)
+{
+	u32 old_timeout;
+
+	if (!timeout_ms)
+		return;
+
+	old_timeout = mana_hwc_timeout_read(hwc);
+	while (old_timeout &&
+	       cmpxchg(&hwc->hwc_timeout, old_timeout, timeout_ms) != old_timeout)
+		old_timeout = mana_hwc_timeout_read(hwc);
+}
+
+void mana_hwc_timeout_cancel(struct hw_channel_context *hwc)
+{
+	xchg(&hwc->hwc_timeout, 0);
+}
+
+static void mana_hwc_timeout_reduce(struct hw_channel_context *hwc)
+{
+	u32 old_timeout = mana_hwc_timeout_read(hwc);
+
+	while (old_timeout > 1 &&
+	       cmpxchg(&hwc->hwc_timeout, old_timeout, 1) != old_timeout)
+		old_timeout = mana_hwc_timeout_read(hwc);
+}
+
+static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
+				  u32 resp_len,
+				  struct hwc_caller_ctx **caller_ctx)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
+	bool channel_up;
+	u32 wait_ms;
 	u32 index;
 
-	down(&hwc->sema);
+	wait_ms = mana_hwc_timeout_read(hwc);
+	if (down_timeout(&hwc->sema, msecs_to_jiffies(wait_ms))) {
+		spin_lock_irqsave(&r->lock, flags);
+		channel_up = hwc->channel_up;
+		spin_unlock_irqrestore(&r->lock, flags);
 
-	spin_lock_irqsave(&r->lock, flags);
+		/* Slot pressure is not evidence that the HWC stopped responding. */
+		return channel_up ? -EBUSY : -ENODEV;
+	}
 
-	if (hwc->hwc_timed_out) {
+	spin_lock_irqsave(&r->lock, flags);
+	if (!hwc->channel_up) {
 		spin_unlock_irqrestore(&r->lock, flags);
 		up(&hwc->sema);
-		return -ETIMEDOUT;
+		return -ENODEV;
 	}
 
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+	/* The semaphore admits at most r->size holders at a time, so a slot
+	 * acquired above always has a free bit waiting for it here.
+	 */
+	index = find_first_zero_bit(r->map, r->size);
+	if (WARN_ON_ONCE(index >= r->size)) {
+		spin_unlock_irqrestore(&r->lock, flags);
+		up(&hwc->sema);
+		return -EIO;
+	}
 
 	ctx = &hwc->caller_ctx[index];
 	reinit_completion(&ctx->comp_event);
-	ctx->output_buf = NULL;
-	ctx->output_buflen = 0;
+	/* Take both references (sender + response handler) before publishing
+	 * the slot, so an early response cannot free it under the sender.
+	 */
+	refcount_set(&ctx->refcnt, 2);
+	ctx->output_buf = resp;
+	ctx->output_buflen = resp_len;
 	ctx->error = -EINPROGRESS;
 	ctx->status_code = 0;
+	ctx->responded = false;
+	ctx->resp_pending = true;
+	ctx->msg_id = index;
 
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+	/* The response path takes r->lock before ctx->lock, so publishing the
+	 * bitmap last makes every field above visible before it can consume
+	 * the response-side reference.
+	 */
+	bitmap_set(r->map, index, 1);
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	*msg_id = index;
+	*caller_ctx = ctx;
 
 	return 0;
 }
 
-static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id,
-				   bool timed_out)
+static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
-	if (timed_out)
-		hwc->hwc_timed_out = true;
-	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
+	bitmap_clear(r->map, msg_id, 1);
 	spin_unlock_irqrestore(&r->lock, flags);
 
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
@@ -97,40 +162,54 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 				 struct hwc_work_request *rx_req, u16 msg_id)
 {
 	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
+	struct gdma_resource *r = &hwc->inflight_msg_res;
 	struct hwc_caller_ctx *ctx;
+	bool release;
 	int err;
 
-	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
+	spin_lock(&r->lock);
+	if (!test_bit(msg_id, r->map)) {
+		spin_unlock(&r->lock);
 		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 		return;
 	}
 
 	ctx = hwc->caller_ctx + msg_id;
-
 	spin_lock(&ctx->lock);
-	if (!ctx->output_buf) {
+	spin_unlock(&r->lock);
+
+	/* Consume the response-side reference exactly once. This releases a
+	 * quarantined slot after its late response arrives.
+	 */
+	release = ctx->resp_pending;
+	ctx->resp_pending = false;
+
+	if (ctx->responded) {
 		spin_unlock(&ctx->lock);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		if (release)
+			hwc_ctx_put(hwc, ctx);
 		return;
 	}
+	ctx->responded = true;
 
 	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
 	if (!err) {
 		ctx->status_code = resp_msg->status;
 		memcpy(ctx->output_buf, resp_msg, resp_len);
 	}
-
-	ctx->output_buf = NULL;
 	ctx->error = err;
 
-	/* Must post rx wqe before complete(), otherwise the next rx may
-	 * hit no_wqe error.
+	/* Post RX WQE before completing; the next response may arrive
+	 * immediately and needs a posted buffer.
 	 */
 	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
-
 	complete(&ctx->comp_event);
 	spin_unlock(&ctx->lock);
+
+	if (release)
+		hwc_ctx_put(hwc, ctx);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -221,7 +300,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			mana_hwc_timeout_update(hwc, val);
 			break;
 
 		case HWC_DATA_HW_LINK_CONNECT:
@@ -622,6 +701,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	hwc_wq->gdma_wq = queue;
 	hwc_wq->queue_depth = q_depth;
 	hwc_wq->hwc_cq = hwc_cq;
+	spin_lock_init(&hwc_wq->lock);
 
 	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
 				     &hwc_wq->msg_buf);
@@ -639,7 +719,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	return err;
 }
 
-static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
+static int mana_hwc_post_tx_wqe(struct hwc_wq *hwc_txq,
 				struct hwc_work_request *req,
 				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
 				bool dest_pf)
@@ -678,7 +758,10 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
 	req->wqe_req.inline_oob_data = tx_oob;
 	req->wqe_req.client_data_unit = 0;
 
+	spin_lock(&hwc_txq->lock);
 	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	spin_unlock(&hwc_txq->lock);
+
 	if (err)
 		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
 	return err;
@@ -697,43 +780,55 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 	return err;
 }
 
-static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
-				 u32 max_req_msg_size, u32 max_resp_msg_size)
+static int mana_hwc_test_channel(struct hw_channel_context *hwc)
 {
-	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct hwc_wq *hwc_rxq = hwc->rxq;
 	struct hwc_work_request *req;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
 	int err;
 	int i;
 
 	/* Post all WQEs on the RQ */
-	for (i = 0; i < q_depth; i++) {
+	for (i = 0; i < hwc->num_inflight_msg; i++) {
 		req = &hwc_rxq->msg_buf->reqs[i];
 		err = mana_hwc_post_rx_wqe(hwc_rxq, req);
 		if (err)
 			return err;
 	}
 
-	ctx = kzalloc_objs(*ctx, q_depth);
+	ctx = kzalloc_objs(*ctx, hwc->num_inflight_msg);
 	if (!ctx)
 		return -ENOMEM;
 
-	for (i = 0; i < q_depth; ++i) {
+	for (i = 0; i < hwc->num_inflight_msg; ++i) {
 		init_completion(&ctx[i].comp_event);
 		spin_lock_init(&ctx[i].lock);
 	}
 
 	hwc->caller_ctx = ctx;
 
-	return mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	/* Setup owns hwc directly; runtime publication follows this test. */
+	spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+	hwc->channel_up = true;
+	spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+
+	err = mana_gd_test_hwc_eq(hwc, hwc->cq->gdma_eq);
+	if (err) {
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+	}
+
+	return err;
 }
 
-static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
+static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
+				      u16 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
@@ -848,68 +943,108 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
-int mana_hwc_create_channel(struct gdma_context *gc)
+static int mana_hwc_publish_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (WARN_ON_ONCE(gc->hwc.driver_data))
+		err = -EBUSY;
+	else
+		gc->hwc.driver_data = hwc;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	return err;
+}
+
+static struct hw_channel_context *
+mana_hwc_unpublish_channel(struct gdma_context *gc)
 {
-	u32 max_req_msg_size, max_resp_msg_size;
-	struct gdma_dev *gd = &gc->hwc;
 	struct hw_channel_context *hwc;
-	u16 q_depth_max;
-	int err;
+	unsigned long flags;
 
-	/* Retry a retained context before assigning queues to the PF again. */
-	if (gd->driver_data) {
-		mana_hwc_destroy_channel(gc);
-		if (gd->driver_data)
-			return -ETIMEDOUT;
-	}
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	hwc = gc->hwc.driver_data;
+	gc->hwc.driver_data = NULL;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	hwc = kzalloc_obj(*hwc);
-	if (!hwc)
-		return -ENOMEM;
+	return hwc;
+}
 
-	gd->gdma_context = gc;
-	gd->driver_data = hwc;
-	hwc->gdma_dev = gd;
-	hwc->dev = gc->dev;
-	hwc->hwc_timeout = HW_CHANNEL_WAIT_RESOURCE_TIMEOUT_MS;
+static void mana_hwc_retain_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+	unsigned long flags;
 
-	/* HWC's instance number is always 0. */
-	gd->dev_id.as_uint32 = 0;
-	gd->dev_id.type = GDMA_DEVICE_HWC;
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (WARN_ON_ONCE(gc->hwc.driver_data))
+		dev_err(hwc->dev, "HWC retention slot is already occupied\n");
+	else
+		gc->hwc.driver_data = hwc;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+}
 
-	gd->pdid = INVALID_PDID;
-	gd->doorbell = INVALID_DOORBELL;
+static bool mana_hwc_senders_drained(struct gdma_context *gc,
+				     struct hw_channel_context *hwc)
+{
+	unsigned long flags;
+	bool drained;
 
-	/* mana_hwc_init_queues() only creates the required data structures,
-	 * and doesn't touch the HWC device.
-	 */
-	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
-				   HW_CHANNEL_MAX_REQUEST_SIZE,
-				   HW_CHANNEL_MAX_RESPONSE_SIZE);
-	if (err) {
-		dev_err(hwc->dev, "Failed to initialize HWC: %d\n", err);
-		goto out;
-	}
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	drained = hwc->active_senders == 0;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	err = mana_hwc_establish_channel(gc, &q_depth_max, &max_req_msg_size,
-					 &max_resp_msg_size);
-	if (err) {
-		dev_err(hwc->dev, "Failed to establish HWC: %d\n", err);
-		goto out;
+	return drained;
+}
+
+static void mana_hwc_stop_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+	unsigned long flags;
+	int i;
+
+	if (hwc->num_inflight_msg) {
+		spin_lock_irqsave(&r->lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&r->lock, flags);
+		/* Wake one admission waiter; each rejected waiter returns the
+		 * permit and wakes the next.
+		 */
+		up(&hwc->sema);
 	}
+	mana_hwc_timeout_cancel(hwc);
 
-	err = mana_hwc_test_channel(gc->hwc.driver_data,
-				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
-				    max_req_msg_size, max_resp_msg_size);
-	if (err) {
-		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
-		goto out;
+	for (i = 0; hwc->caller_ctx && i < hwc->num_inflight_msg; i++) {
+		struct hwc_caller_ctx *ctx;
+		bool drop_resp_ref;
+
+		spin_lock_irqsave(&r->lock, flags);
+		if (!test_bit(i, r->map)) {
+			spin_unlock_irqrestore(&r->lock, flags);
+			continue;
+		}
+
+		ctx = &hwc->caller_ctx[i];
+		spin_lock(&ctx->lock);
+		spin_unlock(&r->lock);
+
+		if (!ctx->responded)
+			ctx->error = -ENODEV;
+		ctx->output_buf = NULL;
+		drop_resp_ref = ctx->resp_pending;
+		ctx->resp_pending = false;
+		ctx->responded = true;
+		complete(&ctx->comp_event);
+		spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (drop_resp_ref)
+			hwc_ctx_put(hwc, ctx);
 	}
 
-	return 0;
-out:
-	mana_hwc_destroy_channel(gc);
-	return err;
+	wait_event(gc->hwc_drain_waitq, mana_hwc_senders_drained(gc, hwc));
 }
 
 static void mana_hwc_fence_channel(struct gdma_context *gc,
@@ -925,14 +1060,13 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
 		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
 }
 
-void mana_hwc_destroy_channel(struct gdma_context *gc)
+static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct gdma_queue **old_cq_table;
 	int err;
 
-	if (!hwc)
-		return;
+	mana_hwc_stop_channel(hwc);
 
 	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
 	 * software dispatch, but retain every PF-visible allocation.
@@ -944,7 +1078,8 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		return;
+		mana_hwc_retain_channel(hwc);
+		return false;
 	}
 
 	/* Fence the EQ before releasing any state its handlers can reach. */
@@ -972,10 +1107,7 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
 	hwc->gdma_dev->pdid = INVALID_PDID;
 
-	hwc->hwc_timeout = 0;
-
 	kfree(hwc);
-	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
 	old_cq_table = READ_ONCE(gc->cq_table);
@@ -983,13 +1115,151 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	smp_store_release(&gc->cq_table, NULL);
 	synchronize_rcu();
 	vfree(old_cq_table);
+
+	return true;
 }
 
-static int mana_hwc_response_status(struct hw_channel_context *hwc,
-				    u32 command, int error, u32 status)
+static int mana_hwc_create_bootstrap_channel(struct hw_channel_context *hwc)
 {
-	if (error)
-		return error;
+	u32 max_req_msg_size, max_resp_msg_size;
+	u16 q_depth_max;
+	int err;
+
+	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				   HW_CHANNEL_MAX_REQUEST_SIZE,
+				   HW_CHANNEL_MAX_RESPONSE_SIZE);
+	if (err) {
+		dev_err(hwc->dev, "Failed to initialize HWC: %d\n", err);
+		return err;
+	}
+
+	err = mana_hwc_establish_channel(hwc, &q_depth_max, &max_req_msg_size,
+					 &max_resp_msg_size);
+	if (err) {
+		dev_err(hwc->dev, "Failed to establish HWC: %d\n", err);
+		return err;
+	}
+
+	err = mana_hwc_test_channel(hwc);
+	if (err)
+		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
+
+	return err;
+}
+
+int mana_hwc_create_channel(struct gdma_context *gc)
+{
+	struct gdma_dev *gd = &gc->hwc;
+	struct hw_channel_context *hwc;
+	int err;
+
+	/* Retry a retained context before assigning queues to the PF again. */
+	if (gd->driver_data) {
+		mana_hwc_destroy_channel(gc);
+		if (gd->driver_data)
+			return -ETIMEDOUT;
+	}
+
+	hwc = kzalloc_obj(*hwc);
+	if (!hwc)
+		return -ENOMEM;
+
+	gd->gdma_context = gc;
+	hwc->gdma_dev = gd;
+	hwc->dev = gc->dev;
+	WRITE_ONCE(hwc->hwc_timeout, HW_CHANNEL_WAIT_RESOURCE_TIMEOUT_MS);
+	init_waitqueue_head(&gc->hwc_drain_waitq);
+
+	/* HWC's instance number is always 0. */
+	gd->dev_id.as_uint32 = 0;
+	gd->dev_id.type = GDMA_DEVICE_HWC;
+
+	gd->pdid = INVALID_PDID;
+	gd->doorbell = INVALID_DOORBELL;
+
+	err = mana_hwc_create_bootstrap_channel(hwc);
+	if (err) {
+		mana_hwc_release_channel(hwc);
+		return err;
+	}
+
+	err = mana_hwc_publish_channel(hwc);
+	if (err) {
+		mana_hwc_release_channel(hwc);
+		return err;
+	}
+
+	return 0;
+}
+
+void mana_hwc_destroy_channel(struct gdma_context *gc)
+{
+	struct hw_channel_context *hwc;
+
+	hwc = mana_hwc_unpublish_channel(gc);
+	if (!hwc)
+		return;
+
+	mana_hwc_release_channel(hwc);
+}
+
+static void mana_hwc_abort_request(struct hw_channel_context *hwc,
+				   struct hwc_caller_ctx *ctx)
+{
+	unsigned long flags;
+	bool drop_resp_ref;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->output_buf = NULL;
+	drop_resp_ref = ctx->resp_pending;
+	ctx->resp_pending = false;
+	ctx->responded = true;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (drop_resp_ref)
+		hwc_ctx_put(hwc, ctx);
+	hwc_ctx_put(hwc, ctx);
+}
+
+static int mana_hwc_submit_request(struct hw_channel_context *hwc,
+				   struct hwc_caller_ctx *ctx,
+				   struct hwc_work_request *tx_wr)
+{
+	unsigned long flags;
+	bool drop_resp_ref = false;
+	int err;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->responded) {
+		err = ctx->error ?: -ENODEV;
+	} else {
+		err = mana_hwc_post_tx_wqe(hwc->txq, tx_wr,
+					   hwc->dest_vrq_id,
+					   hwc->dest_vrcq_id, false);
+		if (err) {
+			ctx->output_buf = NULL;
+			drop_resp_ref = ctx->resp_pending;
+			ctx->resp_pending = false;
+			ctx->responded = true;
+		}
+	}
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (!err)
+		return 0;
+
+	if (drop_resp_ref)
+		hwc_ctx_put(hwc, ctx);
+	hwc_ctx_put(hwc, ctx);
+
+	return err;
+}
+
+static int mana_hwc_response_result(struct hw_channel_context *hwc,
+				    u32 command, int err, u32 status)
+{
+	if (err)
+		return err;
 
 	if (!status || status == GDMA_STATUS_MORE_ENTRIES)
 		return 0;
@@ -1004,108 +1274,86 @@ static int mana_hwc_response_status(struct hw_channel_context *hwc,
 	return -EPROTO;
 }
 
-static void mana_hwc_finish_request(struct hw_channel_context *hwc,
-				    struct hwc_caller_ctx *ctx, u16 msg_id,
-				    bool timed_out)
+static int mana_hwc_wait_for_response(struct hw_channel_context *hwc,
+				      struct hwc_caller_ctx *ctx,
+				      u32 command)
 {
 	unsigned long flags;
+	bool abandoned = false;
+	u32 wait_ms;
+	u32 status;
+	int err;
+
+	wait_ms = mana_hwc_timeout_read(hwc);
+	if (wait_for_completion_timeout(&ctx->comp_event,
+					msecs_to_jiffies(wait_ms))) {
+		spin_lock_irqsave(&ctx->lock, flags);
+		ctx->output_buf = NULL;
+		err = ctx->error;
+		status = ctx->status_code;
+		spin_unlock_irqrestore(&ctx->lock, flags);
+		hwc_ctx_put(hwc, ctx);
+
+		return mana_hwc_response_result(hwc, command, err, status);
+	}
 
 	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = NULL;
+	err = ctx->error;
+	status = ctx->status_code;
+	if (err == -EINPROGRESS) {
+		ctx->responded = true;
+		abandoned = true;
+	}
 	spin_unlock_irqrestore(&ctx->lock, flags);
 
-	mana_hwc_put_msg_index(hwc, msg_id, timed_out);
+	if (!abandoned) {
+		hwc_ctx_put(hwc, ctx);
+		return mana_hwc_response_result(hwc, command, err, status);
+	}
+
+	if (wait_ms)
+		dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
+			command, wait_ms);
+
+	mana_hwc_timeout_reduce(hwc);
+	hwc_ctx_put(hwc, ctx);
+
+	return -ETIMEDOUT;
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp)
 {
 	struct hwc_work_request *tx_wr;
-	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
-	unsigned long flags;
-	u32 dest_vrcq;
-	u32 dest_vrq;
 	u32 command;
-	u32 status;
-	u16 msg_id;
 	int err;
 
-	err = mana_hwc_get_msg_index(hwc, &msg_id);
+	err = mana_hwc_get_msg_index(hwc, resp, resp_len, &ctx);
 	if (err)
 		return err;
 
-	tx_wr = &txq->msg_buf->reqs[msg_id];
-	ctx = hwc->caller_ctx + msg_id;
-
+	tx_wr = &hwc->txq->msg_buf->reqs[ctx->msg_id];
 	if (req_len > tx_wr->buf_len) {
 		dev_err(hwc->dev, "HWC: req msg size: %d > %d\n", req_len,
 			tx_wr->buf_len);
-		mana_hwc_finish_request(hwc, ctx, msg_id, false);
+		mana_hwc_abort_request(hwc, ctx);
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = resp;
-	ctx->output_buflen = resp_len;
-	spin_unlock_irqrestore(&ctx->lock, flags);
-
-	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
+	req_msg = tx_wr->buf_va;
 	if (req)
 		memcpy(req_msg, req, req_len);
-
-	req_msg->req.hwc_msg_id = msg_id;
+	req_msg->req.hwc_msg_id = ctx->msg_id;
 
 	tx_wr->msg_size = req_len;
 	command = req_msg->req.msg_type;
 
-	/* The hardware reports the HWC destination queues through
-	 * HWC_INIT_DATA_DEST_RQ_ID and HWC_INIT_DATA_DEST_CQ_ID, and
-	 * always supplies values that are valid for this function, so no
-	 * PF-specific handling is needed here.
-	 */
-	dest_vrq = hwc->dest_vrq_id;
-	dest_vrcq = hwc->dest_vrcq_id;
-
-	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
-	if (err) {
-		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
-		mana_hwc_finish_request(hwc, ctx, msg_id, false);
+	err = mana_hwc_submit_request(hwc, ctx, tx_wr);
+	if (err)
 		return err;
-	}
-
-	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 msecs_to_jiffies(hwc->hwc_timeout))) {
-		spin_lock_irqsave(&ctx->lock, flags);
-		ctx->output_buf = NULL;
-		err = ctx->error;
-		status = ctx->status_code;
-		spin_unlock_irqrestore(&ctx->lock, flags);
-
-		if (err != -EINPROGRESS) {
-			mana_hwc_finish_request(hwc, ctx, msg_id, false);
-			return mana_hwc_response_status(hwc, command, err, status);
-		}
-
-		if (hwc->hwc_timeout != 0)
-			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
-
-		/* Reduce further waiting if HWC no response */
-		if (hwc->hwc_timeout > 1)
-			hwc->hwc_timeout = 1;
-
-		mana_hwc_finish_request(hwc, ctx, msg_id, true);
-		return -ETIMEDOUT;
-	}
-
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = NULL;
-	err = ctx->error;
-	status = ctx->status_code;
-	spin_unlock_irqrestore(&ctx->lock, flags);
 
-	mana_hwc_finish_request(hwc, ctx, msg_id, false);
-	return mana_hwc_response_status(hwc, command, err, status);
+	return mana_hwc_wait_for_response(hwc, ctx, command);
 }
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index f8278e3817c8..ff843e0ee839 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -468,6 +468,15 @@ struct gdma_context {
 	/* Hardware communication channel (HWC) */
 	struct gdma_dev		hwc;
 
+	/* Sender drain; the final wakeup runs under hwc_lock. */
+	wait_queue_head_t	hwc_drain_waitq;
+
+	/* Protects runtime HWC publication and active sender references.
+	 * Setup owns an unpublished HWC directly; timeout updates use atomic
+	 * access helpers and do not require this lock.
+	 */
+	spinlock_t		hwc_lock;
+
 	/* Azure network adapter */
 	struct gdma_dev		mana;
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index e733301f8740..01568d10b6fd 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -164,17 +164,32 @@ struct hwc_wq {
 	u16 queue_depth;
 
 	struct hwc_cq *hwc_cq;
+
+	/* Serializes SQ posting; unused for the RQ. */
+	spinlock_t lock;
 };
 
 struct hwc_caller_ctx {
 	struct completion comp_event;
-	/* Protects the output buffer and response state from timeout. */
+
+	/* The slot is initialized while unpublished under inflight_msg_res.lock.
+	 * Once its bitmap bit is set, lock protects every field below except
+	 * msg_id and refcnt. The sender owns output_buf; the response handler
+	 * may write it only while holding lock.
+	 */
 	spinlock_t lock;
 	void *output_buf;
 	u32 output_buflen;
-
-	int error; /* Linux error code */
+	int error;
 	u32 status_code;
+	bool responded;
+	bool resp_pending;
+
+	/* Tracks sender + response-handler ownership. The last put releases
+	 * the bitmap slot under inflight_msg_res.lock.
+	 */
+	refcount_t refcnt;
+	u16 msg_id;
 };
 
 struct hw_channel_context {
@@ -196,18 +211,30 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
+	/* Admission permits. Timed-out requests retain theirs until a
+	 * response or teardown releases the slot.
+	 */
 	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
 
 	u32 dest_vrq_id;
 	u32 dest_vrcq_id;
+
+	/* Zero permanently cancels waits for this channel instance. Firmware
+	 * and query updates may replace a live nonzero value; fail-fast may
+	 * only reduce a live value to one millisecond.
+	 */
 	u32 hwc_timeout;
 
-	/* Prevents message ID reuse after a timeout; protected by the map lock. */
-	bool hwc_timed_out;
+	/* Checked after slot acquisition; cleared on teardown to reject sends. */
+	bool channel_up;
 
 	/* The PF may own the HWC queues while this is true. */
 	bool setup_active;
+
+	/* mana_gd_send_request() callers, including waiters; under hwc_lock. */
+	unsigned int active_senders;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
@@ -216,5 +243,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc);
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp);
+int mana_gd_test_hwc_eq(struct hw_channel_context *hwc,
+			struct gdma_queue *eq);
+
+u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc);
+void mana_hwc_timeout_update(struct hw_channel_context *hwc, u32 timeout_ms);
+void mana_hwc_timeout_cancel(struct hw_channel_context *hwc);
 
 #endif /* _HW_CHANNEL_H */
-- 
2.43.0

