Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0F532BF4B;
	Tue,  8 Sep 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788839567; cv=none; b=ZDhddnAhbxHp+f+p7gskrPb1GUvRTnxRL0Nr09JYhBK+tiZVNysMDZicmL7kbJR8qfTJZFBFafZmzxruZohs0sp5lIC/kBRO5J41p0PMpBCmjwA1kPAEbKU8iFtOHOzG8MnHnYExeXhR9CNHUL0tB/sXMpFhMwtXzQpYThIJfkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788839567; c=relaxed/simple;
	bh=XlKhyGXKosX93wop/obYqGozroIOE7whypy8YTAPc1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7RjzRm1kW+E5XpPW1wuKMgGkZtm/UQ97+Mbj7YvIsSYSNaEcalep1kku+2Hogg3dhGhei4nmOEGmycYTCeS2yyfo6As358MJxtrAq4Zo8L54CH0mYbecTglEq2oxCQI650NmL/G3i3t2JoITWjje2paCvheH8XXaenI8SyN1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B050520B7135; Mon,  7 Sep 2026 20:52:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B050520B7135
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
Subject: [PATCH net-next v5 3/4] net: mana: support concurrent HWC requests
Date: Mon,  7 Sep 2026 20:51:57 -0700
Message-ID: <20260908035201.402424-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260908035201.402424-1-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Serialize SQ posting and protect HWC lookup and sender accounting with
hwc_lock. Teardown stops admission, force-completes requests and drains
senders before destroying CQ, TXQ and RXQ. Preserve cancellation errors;
return -EPROTO instead of success for a response accepted before posting.

Bound FIFO slot admission with down_timeout(), independently of the
response wait. Admission expiry returns -ETIMEDOUT even for contention,
so existing callers may reset a responsive channel.

Quarantine posted requests on timeout, including zero-timeout cleanup,
until a response or teardown releases their slot. This closes the
late-response reuse window present at depth one. Keep depth one here.

Existing lifecycle and timeout-field races are not resolved here.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5 (v4 -> v5):
 - Return -EPROTO rather than success if a response precedes submission;
   preserve nonzero cancellation errors and existing reference cleanup.
 - Document separate FIFO admission and response budgets, including
   contention-triggered recovery and zero-timeout quarantine.
 - Correct and shorten locking, publication and teardown comments.

Changes in v4 (standalone net-next rework after the v3 split):
 - Rework former patch 6/7 as patch 3/4 on the new ownership preparation.
 - Use down_timeout() for semaphore admission and keep the slot until a
   timed-out request's response arrives or teardown releases it.
 - Retain quarantine for zero-timeout cleanup; do not use the former
   channel-wide timeout latch.
 - Serialize cancellation with SQ posting, preserve already recorded
   results during teardown, and retain guarded sender draining.

Changes in v3 (historical net fixes-only posting):
 - Defer the concurrency feature from the net submission.
 - Related slot-timeout ownership work was posted separately as fix 6/6.

Changes in v2 (v1 -> v2, former patch 6/7):
 - Replace atomic sender accounting with an hwc_lock-protected count and
   wait_event_lock_irq() drain to fence the final sender's wakeup.
 - Move force-completion and draining before teardown/FLR failure exits.

v1:
 - Introduce waitqueue/bitmap admission, per-slot synchronization,
   posting serialization and channel teardown gating in patch 6/7.

 .../net/ethernet/microsoft/mana/gdma_main.c   |  38 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 229 ++++++++++++++----
 include/net/mana/gdma.h                       |   9 +
 include/net/mana/hw_channel.h                 |  16 ++
 4 files changed, 239 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 8d86de0a334b21d77ab6bfb578917c56404bc856..eb88bae2b14d86de33e79eb597a076a7d6e54436 100644
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
 	if (hwc && hwc->hwc_timeout == 0)
-		return false;
+		need_log = false;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	return true;
+	return need_log;
 }
 
 static int mana_gd_query_max_resources(struct pci_dev *pdev)
@@ -391,9 +395,27 @@ static int mana_gd_detect_devices(struct pci_dev *pdev)
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
+
+	err = mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (--hwc->active_senders == 0)
+		wake_up(&gc->hwc_drain_waitq);
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+	return err;
 }
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
@@ -714,6 +736,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct hw_channel_context *hwc;
+	unsigned long flags;
 	int ret;
 
 	if (!gc) {
@@ -723,14 +746,17 @@ static void mana_serv_reset(struct pci_dev *pdev)
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
 	hwc->hwc_timeout = 0;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
 	dev_info(&pdev->dev, "MANA reset cycle start\n");
 
@@ -1337,6 +1363,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
+	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
@@ -1542,7 +1569,9 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	struct hw_channel_context *hwc;
 	int err;
 
+	/* The setup caller must exclude concurrent HWC teardown. */
 	hwc = gc->hwc.driver_data;
+
 	mana_gd_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
 			     sizeof(req), sizeof(resp));
 
@@ -2536,6 +2565,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
 	pci_set_drvdata(pdev, gc);
 	gc->bar0_pa = pci_resource_start(pdev, 0);
 	gc->bar0_size = pci_resource_len(pdev, 0);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 6605e7a9c481bcb11c95f90f627b7c422b62cc28..a4f7346d285f740c40f4f63c20348e30531f1435 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,7 +6,6 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
-/* Acquire a free inflight message slot, waiting for one if all are in use. */
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
@@ -14,12 +13,30 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	unsigned long flags;
 	u32 index;
 
-	down(&hwc->sema);
+	/* FIFO slot admission has a separate budget from the response wait.
+	 * Expiry reports -ETIMEDOUT even while earlier requests make progress,
+	 * so callers may initiate recovery on contention alone.
+	 */
+	if (down_timeout(&hwc->sema, msecs_to_jiffies(hwc->hwc_timeout)))
+		return -ETIMEDOUT;
 
 	spin_lock_irqsave(&r->lock, flags);
 
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+	if (!hwc->channel_up) {
+		spin_unlock_irqrestore(&r->lock, flags);
+		up(&hwc->sema);
+		return -ENODEV;
+	}
+
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
@@ -28,11 +45,12 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	 */
 	refcount_set(&ctx->refcnt, 2);
 	ctx->responded = false;
+	ctx->resp_pending = true;
 	ctx->msg_id = index;
 	ctx->error = -EINPROGRESS;
 
 	/* Publish the slot last, after it is fully initialised. */
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+	bitmap_set(r->map, index, 1);
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
@@ -101,6 +119,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 {
 	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
 	struct hwc_caller_ctx *ctx;
+	bool release;
 	int err;
 
 	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
@@ -113,13 +132,30 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 
 	spin_lock(&ctx->lock);
 
-	/* Honour a response only while the sender owns the slot (output_buf
-	 * published) and has not already been answered; otherwise drop it as
-	 * premature, stale or duplicate without touching the refcount.
+	/* The sender has not published its buffer yet, so nothing asked for
+	 * this response.  Keep the slot reserved and drop the message.
+	 */
+	if (!ctx->output_buf && !ctx->responded) {
+		spin_unlock(&ctx->lock);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		return;
+	}
+
+	/* Take the response-side reference away exactly once: releasing it
+	 * is what frees a slot whose sender has already given up.
 	 */
-	if (!ctx->output_buf || ctx->responded) {
+	release = ctx->resp_pending;
+	ctx->resp_pending = false;
+
+	if (ctx->responded) {
+		/* The sender timed out and abandoned the slot, or a response
+		 * was already applied.  Consume this one without writing
+		 * anything, then release the slot it was holding.
+		 */
 		spin_unlock(&ctx->lock);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		if (release)
+			hwc_ctx_put(hwc, ctx);
 		return;
 	}
 	ctx->responded = true;
@@ -138,7 +174,8 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	complete(&ctx->comp_event);
 	spin_unlock(&ctx->lock);
 
-	hwc_ctx_put(hwc, ctx);
+	if (release)
+		hwc_ctx_put(hwc, ctx);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -593,6 +630,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	hwc_wq->gdma_wq = queue;
 	hwc_wq->queue_depth = q_depth;
 	hwc_wq->hwc_cq = hwc_cq;
+	spin_lock_init(&hwc_wq->lock);
 
 	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
 				     &hwc_wq->msg_buf);
@@ -610,7 +648,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	return err;
 }
 
-static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
+static int mana_hwc_post_tx_wqe(struct hwc_wq *hwc_txq,
 				struct hwc_work_request *req,
 				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
 				bool dest_pf)
@@ -649,7 +687,10 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
 	req->wqe_req.inline_oob_data = tx_oob;
 	req->wqe_req.client_data_unit = 0;
 
+	spin_lock(&hwc_txq->lock);
 	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	spin_unlock(&hwc_txq->lock);
+
 	if (err)
 		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
 	return err;
@@ -675,6 +716,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	struct hwc_wq *hwc_rxq = hwc->rxq;
 	struct hwc_work_request *req;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
 	int err;
 	int i;
 
@@ -697,7 +739,19 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->caller_ctx = ctx;
 
-	return mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	/* Enable admission for the test EQ request. */
+	spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+	hwc->channel_up = true;
+	spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+
+	err = mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	if (err) {
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+	}
+
+	return err;
 }
 
 static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
@@ -797,6 +851,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	u32 max_req_msg_size, max_resp_msg_size;
 	struct gdma_dev *gd = &gc->hwc;
 	struct hw_channel_context *hwc;
+	unsigned long flags;
 	u16 q_depth_max;
 	int err;
 
@@ -805,10 +860,11 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 		return -ENOMEM;
 
 	gd->gdma_context = gc;
-	gd->driver_data = hwc;
 	hwc->gdma_dev = gd;
 	hwc->dev = gc->dev;
 	hwc->hwc_timeout = HW_CHANNEL_WAIT_RESOURCE_TIMEOUT_MS;
+	hwc->active_senders = 0;
+	init_waitqueue_head(&gc->hwc_drain_waitq);
 
 	/* HWC's instance number is always 0. */
 	gd->dev_id.as_uint32 = 0;
@@ -817,6 +873,11 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
+	/* Publish for setup; queue initialization below must precede senders. */
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	gc->hwc.driver_data = hwc;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
 	/* mana_hwc_init_queues() only creates the required data structures,
 	 * and doesn't touch the HWC device.
 	 */
@@ -851,11 +912,60 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
+	/* The caller must serialize setup and teardown operations. */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	unsigned long flags;
 
 	if (!hwc)
 		return;
 
+	/* Nonzero num_inflight_msg means queue initialization completed. */
+	if (hwc->num_inflight_msg) {
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+	}
+
+	/* Block new mana_gd_send_request() references before draining. */
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	gc->hwc.driver_data = NULL;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	/* Complete occupied slots and drop pending response-side references. */
+	if (hwc->caller_ctx) {
+		struct hwc_caller_ctx *ctx;
+		bool drop_resp_ref;
+		int i;
+
+		for (i = 0; i < hwc->num_inflight_msg; i++) {
+			if (!test_bit(i, hwc->inflight_msg_res.map))
+				continue;
+
+			ctx = &hwc->caller_ctx[i];
+
+			spin_lock_irqsave(&ctx->lock, flags);
+			/* Preserve an already recorded result. */
+			if (!ctx->responded)
+				ctx->error = -ENODEV;
+			drop_resp_ref = ctx->resp_pending;
+			ctx->resp_pending = false;
+			ctx->responded = true;
+			complete(&ctx->comp_event);
+			spin_unlock_irqrestore(&ctx->lock, flags);
+
+			if (drop_resp_ref)
+				hwc_ctx_put(hwc, ctx);
+		}
+	}
+
+	/* Pair with the last sender's wakeup under hwc_lock, so it finishes
+	 * accessing gc before the drain returns.
+	 */
+	spin_lock_irq(&gc->hwc_lock);
+	wait_event_lock_irq(gc->hwc_drain_waitq,
+			    hwc->active_senders == 0, gc->hwc_lock);
+	spin_unlock_irq(&gc->hwc_lock);
+
 	if (hwc->setup_active) {
 		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
 			hwc->setup_active = false;
@@ -864,14 +974,28 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	}
 	gc->max_num_cqs = 0;
 
+	/* Deregister the HWC EQ before freeing the work queues. */
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
+
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
 
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
+	if (hwc->caller_ctx) {
+		struct hwc_caller_ctx *ctx;
+		int i;
+
+		for (i = 0; i < hwc->num_inflight_msg; i++) {
+			if (!test_bit(i, hwc->inflight_msg_res.map))
+				continue;
+
+			ctx = &hwc->caller_ctx[i];
+			hwc_ctx_put(hwc, ctx);
+		}
+	}
 
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
@@ -886,7 +1010,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	hwc->hwc_timeout = 0;
 
 	kfree(hwc);
-	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
 	vfree(gc->cq_table);
@@ -903,6 +1026,8 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	bool drop_resp_ref;
+	bool abandoned = false;
+	bool cancelled;
 	u32 dest_vrcq = 0;
 	u32 dest_vrq = 0;
 	u32 command;
@@ -945,10 +1070,21 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		dest_vrcq = hwc->pf_dest_vrcq_id;
 	}
 
-	/* The response-side reference (from get_msg_index) keeps the slot
-	 * alive if hardware responds right after the doorbell.
+	/* Serialize cancellation with submission. An unsubmitted request
+	 * cannot succeed, even if an unsolicited response was accepted.
 	 */
-	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
+	spin_lock_irqsave(&ctx->lock, flags);
+	cancelled = ctx->responded;
+	if (cancelled)
+		err = ctx->error ?: -EPROTO;
+	else
+		err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq,
+					   false);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (cancelled)
+		goto out;
+
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
 		goto out;
@@ -965,43 +1101,40 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		ctx->output_buf = NULL;
 		err = ctx->error;
 		status = ctx->status_code;
+		if (err == -EINPROGRESS) {
+			/* Publish abandonment with buffer withdrawal so a late
+			 * response can reclaim the slot. Keep its reference.
+			 */
+			ctx->responded = true;
+			abandoned = true;
+		}
 		spin_unlock_irqrestore(&ctx->lock, flags);
 
-		if (err != -EINPROGRESS) {
-			/* A response raced in just after the timeout, so the
-			 * hardware is alive: keep the channel and report what
-			 * that response said rather than a timeout.  It may
-			 * itself be an error -- a malformed response leaves
-			 * -EPROTO here -- which is still the answer to this
-			 * command.
-			 */
+		if (!abandoned) {
+			/* A completion won the race with timeout; use its result. */
 			hwc_ctx_put(hwc, ctx);
 			goto check_status;
 		}
 
-		if (wait_ms != 0)
+		if (wait_ms != 0) {
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
 				command, wait_ms);
 
-		err = -ETIMEDOUT;
-
-		/* No-wait teardown (hwc_timeout == 0) is expected to expire;
-		 * just release the slot so the next teardown command can reuse
-		 * it.
-		 */
-		if (wait_ms == 0)
-			goto out;
+			/* Genuine timeout: shorten later waits so subsequent
+			 * commands fail fast instead of each draining the
+			 * full timeout.
+			 */
+			if (hwc->hwc_timeout > 1)
+				hwc->hwc_timeout = 1;
+		}
 
-		/* Genuine timeout: shorten later waits so subsequent commands
-		 * fail fast instead of each draining the full timeout.
-		 */
-		if (hwc->hwc_timeout > 1)
-			hwc->hwc_timeout = 1;
+		err = -ETIMEDOUT;
 
-		/* Release the slot via out:; a late response no longer touches
-		 * it, so the sender must drop the reference here.
+		/* Drop only the sender's reference; the response-side one is
+		 * what keeps the slot reserved.
 		 */
-		goto out;
+		hwc_ctx_put(hwc, ctx);
+		goto done;
 	}
 
 	/* Clear output_buf and read the result under the lock; the slot may
@@ -1034,14 +1167,12 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	err = 0;
 	goto done;
 out:
-	/* Error, no-wait teardown, or timeout: drop the sender's and the
-	 * response-side references.  Latch ->responded so a racing response
-	 * is a no-op, and only drop the response-side ref if it has not.
-	 */
+	/* Release any references still held by this unsubmitted request. */
 	ctx = hwc->caller_ctx + msg_id;
 	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->output_buf = NULL;
-	drop_resp_ref = !ctx->responded;
+	drop_resp_ref = ctx->resp_pending;
+	ctx->resp_pending = false;
 	ctx->responded = true;
 	spin_unlock_irqrestore(&ctx->lock, flags);
 	if (drop_resp_ref)
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 308950f9b54b0485bac66b80d63e257eaf5f787e..571a533e62e64790f9000d42ab0e833fe36ccff6 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -468,6 +468,15 @@ struct gdma_context {
 	/* Hardware communication channel (HWC) */
 	struct gdma_dev		hwc;
 
+	/* Sender drain; the final wakeup runs under hwc_lock. */
+	wait_queue_head_t	hwc_drain_waitq;
+
+	/* Protects HWC publication, sender references, and short accesses in
+	 * mana_need_log()/mana_serv_reset(). Setup and DMA-region readers
+	 * still require lifecycle ordering. Not all timeout writers use it.
+	 */
+	spinlock_t		hwc_lock;
+
 	/* Azure network adapter */
 	struct gdma_dev		mana;
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index b377e221aa5c8183825e65ac0972c6b9f959004c..fba27d8620a388a41ae7ddd3bf2b4792f7beec3d 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -164,6 +164,9 @@ struct hwc_wq {
 	u16 queue_depth;
 
 	struct hwc_cq *hwc_cq;
+
+	/* Serializes SQ posting; unused for the RQ. */
+	spinlock_t lock;
 };
 
 struct hwc_caller_ctx {
@@ -189,6 +192,9 @@ struct hwc_caller_ctx {
 	 * so a later or duplicate response is dropped.
 	 */
 	bool responded;
+
+	/* Response-side reference outstanding; protected by lock. */
+	bool resp_pending;
 };
 
 struct hw_channel_context {
@@ -196,6 +202,7 @@ struct hw_channel_context {
 	struct device *dev;
 
 	u16 num_inflight_msg;
+
 	u32 max_req_msg_size;
 
 	u16 hwc_init_q_depth_max;
@@ -208,6 +215,9 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
+	/* Admission permits. Timed-out requests retain theirs until a
+	 * response or teardown releases the slot.
+	 */
 	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
 
@@ -215,9 +225,15 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Checked after slot acquisition; cleared on teardown to reject sends. */
+	bool channel_up;
+
 	/* PF may own the queue mappings; state lasts only for this context. */
 	bool setup_active;
 
+	/* mana_gd_send_request() callers, including waiters; under hwc_lock. */
+	unsigned int active_senders;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0
