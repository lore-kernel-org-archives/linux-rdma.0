Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E14456DF6;
	Tue,  1 Sep 2026 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292873; cv=none; b=VzD0Ko5jzTzkdtUoubiXrnyQ8Krc+LAm5wKMI/BV3lghOa/N2hPMBvbniPAqY12Djj3vF7LOrK1DoWgrcwjr7XBpxPI5W50H9UYnfQ6XBh2Wk3/ILWC4PFL0X0OpX9+dKo+InzBcWyc1/FPfUKnSjl4eVQiaFWYwuLsSfpCjX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292873; c=relaxed/simple;
	bh=TQKNwUZqSEvenosZP95sz5EOSOR4niObNUjO1i4dsog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3kCep2hbezWqY8KHs0qafz4aDVTNW6RqyLYtzKp84lDoQ/Ez+0elI0ix8ggSQ+y9C9t5S8vCefed6cE7NxMHynie5iwuggBvE8YfYYu1gNzG+G7Ui7u7veljolrtywDWHRTpLTR0rmqnQMm15wjI7Ktz6x5Bz7ALeMX+xqEEsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 026A320B7166; Tue,  1 Sep 2026 13:00:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 026A320B7166
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
Subject: [PATCH net-next v4 3/4] net: mana: support concurrent HWC requests
Date: Tue,  1 Sep 2026 13:00:15 -0700
Message-ID: <20260901200018.3194525-4-longli@microsoft.com>
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

The HWC now manages message slots with a refcounted, per-slot-locked
bitmap (see the previous patch) but still runs at the bootstrap queue
depth of 1.  Prepare the channel for multiple in-flight requests and
make teardown safe against them.

  - Add a per-queue lock to hwc_wq; mana_gd_post_and_ring() is not safe
    to call concurrently on the same queue.

  - Bound the wait for a message slot.  A sender blocked in down() could
    only be woken by up(), which teardown never issued, so it slept with
    no way to observe that the channel was going away.  Keep the
    counting semaphore -- its count is exactly the number of free slots
    -- but acquire with down_timeout(), so a caller expires instead of
    blocking for ever, and re-check channel_up under the bitmap lock
    once a permit is held, returning the permit if the channel is on its
    way down.  A slot whose request timed out is never posted back (see
    below), so the count falls permanently until the response that owns
    it arrives or teardown reclaims it; that is what makes the bounded
    wait terminate rather than spin.  mlx5 gates its command slots the
    same way (down_timeout() on cmd->vars.sem, -EBUSY on expiry).

  - Add a channel_up flag, set once the channel is established and
    cleared under the bitmap lock in destroy_channel(), so
    mana_hwc_get_msg_index() rejects new senders during teardown.  It is
    read under the same lock that publishes a slot, so a sender that
    already holds a permit cannot miss the clear: it either publishes
    before teardown observes the bitmap, or finds the flag clear and
    posts the permit back.  Each released waiter posting its permit back
    releases the next, so the force-completion in destroy_channel() --
    which returns every in-flight slot, including the ones a timed-out
    request was holding -- drains the whole queue.

  - destroy_channel() must not free the HWC while senders are still in
    flight.  Count active senders in a gc->hwc_lock-protected counter;
    destroy_channel() force-completes the in-flight slots (-ENODEV), then
    drains the counter to zero with wait_event_lock_irq() before freeing.
    The counter changes only under hwc_lock and the last sender's
    wake_up() runs under that lock, so evaluating the drain condition
    under hwc_lock guarantees the waking sender has already dropped the
    lock -- finished touching gc -- before the drain returns; it cannot
    race the later free of gc.  The waitqueue itself lives on
    gdma_context, not hwc, so the wake never dereferences freed hwc.

  - The sender looks up the channel via gc->hwc.driver_data, which
    destroy_channel() clears and then frees.  Without serialization the
    lookup and the reference can straddle the free:

      CPU A (mana_gd_send_request)      CPU B (destroy_channel)
      ------------------------------    ------------------------------
      hwc = gc->hwc.driver_data;  // ok
                                        driver_data = NULL;
                                        wait active_senders == 0;  // 0!
                                        kfree(hwc);
      hwc->active_senders++;            // use-after-free

    Guard driver_data with a new gc->hwc_lock spinlock, taken by the
    readers (mana_gd_send_request, mana_need_log, mana_serv_reset) and by
    the publish/clear, so "load the pointer + take a sender reference" is
    atomic against the clear.  After the clear a sender either already
    holds a reference (and is waited for) or observes NULL and returns
    -ENODEV.  These are all control-plane paths (HWC commands sleep,
    reset runs on a workqueue), so a plain spinlock -- not RCU -- is
    sufficient.

With more than one slot in use, a timed-out command also stops being
harmless to retire.  The previous patch releases its slot while the
device may still answer, so the next request can take that slot and be
completed with the previous request's response -- responses are
correlated only by the slot index.  So do not release it: a slot whose
request reached the hardware stays taken until the response arrives, and
only that response frees it.  A request that never reached the hardware
cannot be answered, so its slot is still released immediately.

Slots held this way are counted, so a channel that is merely busy can be
told from one where nothing will ever free a slot again.  Once every slot
is held by an unanswered command, mana_hwc_get_msg_index() fails with
-ETIMEDOUT rather than sleeping on a queue no one can wake, which would
otherwise deadlock teardown and reset against a device that has stopped
responding.

The next patch raises the depth to the device-reported maximum.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  55 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 330 +++++++++++++++---
 include/net/mana/gdma.h                       |  15 +
 include/net/mana/hw_channel.h                 |  27 ++
 4 files changed, 384 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index a023d3e1a95deeea3d15860f6fe7cab24f0b64e5..9e7efce669ae0686e352cf953c051de160d74a0d 100644
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
@@ -393,9 +397,27 @@ static int mana_gd_detect_devices(struct pci_dev *pdev)
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
 
-	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (--hwc->active_senders == 0)
+		wake_up(&gc->hwc_drain_waitq);
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	return err;
 }
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
@@ -716,6 +738,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct hw_channel_context *hwc;
+	unsigned long flags;
 	int ret;
 
 	if (!gc) {
@@ -725,14 +748,17 @@ static void mana_serv_reset(struct pci_dev *pdev)
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
 
@@ -1339,6 +1365,16 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
+	/* No RCU needed: this runs only on the data-path queue-creation
+	 * path (mana_gd_create_mana_eq/mana_gd_create_mana_wq_cq, called
+	 * by mana_en under RTNL and by mana_ib RDMA verbs, or during
+	 * init).  Every teardown path — mana_gd_remove, mana_gd_suspend,
+	 * and the HWC reset/service path (which goes through
+	 * mana_gd_suspend) — drains those consumers via mana_rdma_remove()
+	 * + mana_remove() before mana_hwc_destroy_channel() clears
+	 * gc->hwc.driver_data, so no concurrent destroy can race with
+	 * this dereference.
+	 */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
@@ -1544,7 +1580,17 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	struct hw_channel_context *hwc;
 	int err;
 
+	/* No RCU needed: this runs only inside mana_gd_setup, on the
+	 * probe and resume paths.  The PCI/PM core holds device_lock
+	 * across .probe/.resume and .remove/.suspend, so setup cannot
+	 * overlap teardown of the same device.  The HWC reset/service
+	 * path is additionally serialized by GC_IN_SERVICE and runs
+	 * suspend (destroy) then resume (this) sequentially in one work
+	 * item.  driver_data was just set by mana_hwc_create_channel
+	 * earlier in this same setup call, so it is live here.
+	 */
 	hwc = gc->hwc.driver_data;
+
 	mana_gd_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
 			     sizeof(req), sizeof(resp));
 
@@ -2538,6 +2584,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
 	pci_set_drvdata(pdev, gc);
 	gc->bar0_pa = pci_resource_start(pdev, 0);
 	gc->bar0_size = pci_resource_len(pdev, 0);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 0056bdd8c53f5bf6b6b5f318f21faf7d9e14de53..91fcf7c092113133d392f0e43f2eda62ca5cb919 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,7 +6,11 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
-/* Acquire a free inflight message slot, waiting for one if all are in use. */
+/* Acquire a free message slot from the inflight bitmap, waiting for one if
+ * all are in use.  Returns -ENODEV if the channel is being torn down, or
+ * -ETIMEDOUT if a prior HWC command has timed out (preserving the error
+ * code callers expect).
+ */
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
@@ -14,12 +18,32 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 	unsigned long flags;
 	u32 index;
 
-	down(&hwc->sema);
+	/* Bounded wait for a slot.  A timed-out request keeps its slot until
+	 * the device answers for it, so the semaphore is never posted back
+	 * for that slot and a caller expires here rather than blocking on a
+	 * release that is not coming.  Teardown reclaims those slots, which
+	 * posts the semaphore and releases anyone waiting below.
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
@@ -28,11 +52,12 @@ static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
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
 
@@ -101,6 +126,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 {
 	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
 	struct hwc_caller_ctx *ctx;
+	bool release;
 	int err;
 
 	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
@@ -113,15 +139,32 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 
 	spin_lock(&ctx->lock);
 
-	/* Honour a response only while the sender owns the slot (output_buf
-	 * published) and has not already been answered; otherwise drop it as
-	 * premature, stale or duplicate without touching the refcount.
+	/* The sender has not published its buffer yet, so nothing asked for
+	 * this response.  Keep the slot reserved and drop the message.
 	 */
-	if (!ctx->output_buf || ctx->responded) {
+	if (!ctx->output_buf && !ctx->responded) {
 		spin_unlock(&ctx->lock);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 		return;
 	}
+
+	/* Take the response-side reference away exactly once: releasing it
+	 * is what frees a slot whose sender has already given up.
+	 */
+	release = ctx->resp_pending;
+	ctx->resp_pending = false;
+
+	if (ctx->responded) {
+		/* The sender timed out and abandoned the slot, or a response
+		 * was already applied.  Consume this one without writing
+		 * anything, then release the slot it was holding.
+		 */
+		spin_unlock(&ctx->lock);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
+		if (release)
+			hwc_ctx_put(hwc, ctx);
+		return;
+	}
 	ctx->responded = true;
 
 	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
@@ -138,7 +181,8 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 	complete(&ctx->comp_event);
 	spin_unlock(&ctx->lock);
 
-	hwc_ctx_put(hwc, ctx);
+	if (release)
+		hwc_ctx_put(hwc, ctx);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -593,6 +637,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	hwc_wq->gdma_wq = queue;
 	hwc_wq->queue_depth = q_depth;
 	hwc_wq->hwc_cq = hwc_cq;
+	spin_lock_init(&hwc_wq->lock);
 
 	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
 				     &hwc_wq->msg_buf);
@@ -610,7 +655,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	return err;
 }
 
-static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
+static int mana_hwc_post_tx_wqe(struct hwc_wq *hwc_txq,
 				struct hwc_work_request *req,
 				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
 				bool dest_pf)
@@ -649,7 +694,11 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
 	req->wqe_req.inline_oob_data = tx_oob;
 	req->wqe_req.client_data_unit = 0;
 
+	/* Serialize WQE posting — multiple senders may call concurrently. */
+	spin_lock(&hwc_txq->lock);
 	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	spin_unlock(&hwc_txq->lock);
+
 	if (err)
 		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
 	return err;
@@ -660,6 +709,9 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
+	/* One permit per slot; a permit is returned only when the slot is
+	 * released, so the count always mirrors the free slots.
+	 */
 	sema_init(&hwc->sema, num_msg);
 
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
@@ -675,6 +727,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	struct hwc_wq *hwc_rxq = hwc->rxq;
 	struct hwc_work_request *req;
 	struct hwc_caller_ctx *ctx;
+	unsigned long flags;
 	int err;
 	int i;
 
@@ -697,7 +750,34 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->caller_ctx = ctx;
 
-	return mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	/* channel_up must be set before the test EQ request, because
+	 * the request goes through mana_hwc_get_msg_index() which
+	 * checks channel_up.  caller_ctx is allocated above, so
+	 * concurrent access to a NULL caller_ctx is not possible.
+	 *
+	 * Publish it under the bitmap lock, the same one the waiters and
+	 * mana_hwc_destroy_channel() use, so the flag is never stored
+	 * concurrently with the teardown that clears it.
+	 */
+	spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+	hwc->channel_up = true;
+	spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+
+	err = mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	if (err) {
+		/* Clear channel_up under the bitmap lock, mirroring
+		 * mana_hwc_destroy_channel().  Any sender already waiting on
+		 * the semaphore is released by the slot holder that posts it,
+		 * or by the teardown the caller runs on this error; each
+		 * released waiter finds the flag clear and posts the permit
+		 * straight back, so one permit walks the whole queue.
+		 */
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+	}
+
+	return err;
 }
 
 static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
@@ -797,6 +877,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	u32 max_req_msg_size, max_resp_msg_size;
 	struct gdma_dev *gd = &gc->hwc;
 	struct hw_channel_context *hwc;
+	unsigned long flags;
 	u16 q_depth_max;
 	int err;
 
@@ -805,10 +886,11 @@ int mana_hwc_create_channel(struct gdma_context *gc)
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
@@ -817,6 +899,15 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
+	/* Publish driver_data last, under hwc_lock: the lock orders the hwc
+	 * initialisation above before the pointer becomes visible and
+	 * serialises the publish against the control-plane readers in
+	 * mana_gd_send_request(), mana_need_log() and mana_serv_reset().
+	 */
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	gc->hwc.driver_data = hwc;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
 	/* mana_hwc_init_queues() only creates the required data structures,
 	 * and doesn't touch the HWC device.
 	 */
@@ -851,11 +942,120 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
+	/* This is the only destroy entry point.  driver_data is read
+	 * plainly here (teardown is serialised against other teardown);
+	 * it is cleared under hwc_lock below before hwc is freed.
+	 */
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	unsigned long flags;
 
 	if (!hwc)
 		return;
 
+	/* Prevent new requests from starting.  Clear channel_up under the
+	 * bitmap lock so get_msg_index() cannot acquire a slot and increment
+	 * active_senders after this point.  Senders already waiting on the
+	 * semaphore are released by the force-completion loop below, which
+	 * returns every in-flight slot -- including the ones a timed-out
+	 * request was holding; each released waiter sees the flag clear and
+	 * posts its permit straight back, so they drain in turn.
+	 *
+	 * Gate on the bitmap rather than on channel_up: reading the flag
+	 * unlocked and only then taking the lock would let a concurrent
+	 * setup publish it in between and leave the channel up.  A zero
+	 * num_inflight_msg means mana_gd_alloc_res_map() never ran, so the
+	 * lock is not initialised yet -- and no sender can exist either.
+	 */
+	if (hwc->num_inflight_msg) {
+		spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+		hwc->channel_up = false;
+		spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+	}
+
+	/* Clear the pointer under hwc_lock so new callers in
+	 * mana_gd_send_request() see NULL and return -ENODEV.  The lock
+	 * makes the readers' "load driver_data + active_senders++"
+	 * atomic against this store, so once it returns no new sender can
+	 * take a reference; the active_senders drain below waits out those
+	 * that already did, before their hwc is freed.
+	 */
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	gc->hwc.driver_data = NULL;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	/* Force-complete any in-flight senders so they observe -ENODEV,
+	 * return, and drop their references.  This runs before the HWC
+	 * hardware teardown below, so a live interrupt may still deliver
+	 * a real response via handle_resp() concurrently — that is safe
+	 * because the per-slot refcount model tolerates a concurrent
+	 * complete() and both paths (handle_resp and this loop) drop
+	 * their refs without double-releasing the slot.
+	 */
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
+			/* Wake senders blocked on wait_for_completion.
+			 * Set error under lock to avoid racing with
+			 * handle_resp() which writes error under the
+			 * same lock.  The sender NULLs output_buf
+			 * after waking — doing it here would race
+			 * with a sender that hasn't set output_buf yet.
+			 *
+			 * Latch ->responded so that a response still in
+			 * flight cannot overwrite -ENODEV and report
+			 * success for a request the channel is abandoning.
+			 * handle_resp() then drops that response without
+			 * touching the refcount, so release the
+			 * response-side reference here instead.
+			 */
+			spin_lock_irqsave(&ctx->lock, flags);
+			/* Do not clobber a response mana_hwc_handle_resp() has
+			 * already delivered: its payload is in the caller's
+			 * buffer and the command really did complete, so
+			 * reporting -ENODEV would make the caller treat a
+			 * hardware object it now owns as never created.
+			 */
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
+	/* Wait for all sender threads to finish and drop their refs
+	 * before touching the hardware or freeing anything, so no
+	 * in-flight sender is still running when this function returns;
+	 * otherwise a stranded sender would dereference gc->hwc_lock /
+	 * gc->hwc_drain_waitq after the caller frees gc.
+	 * After this, only slots held by timed-out senders whose
+	 * handle_resp() never ran remain in the bitmap.
+	 *
+	 * active_senders is only ever modified under hwc_lock, and the
+	 * last sender's wake_up() runs under that lock before it is
+	 * released.  Evaluating the condition under hwc_lock therefore
+	 * guarantees that once we observe 0 the waking sender has
+	 * already dropped the lock -- i.e. finished touching gc -- so it
+	 * cannot race the caller freeing gc after this returns.
+	 */
+	spin_lock_irq(&gc->hwc_lock);
+	wait_event_lock_irq(gc->hwc_drain_waitq,
+			    hwc->active_senders == 0, gc->hwc_lock);
+	spin_unlock_irq(&gc->hwc_lock);
+
 	/* Tear down only if setup_hwc() handed the queues to the PF.  Until
 	 * then the device never saw them, so there is nothing to undo.
 	 */
@@ -871,14 +1071,36 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	}
 	gc->max_num_cqs = 0;
 
+	/* Destroy the HWC CQ object before the TXQ and RQ.  The
+	 * active_senders drain above already guarantees no sender is
+	 * still reaching the CQ through txq->hwc_cq.
+	 */
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
+
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
 
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
+	/* Safety net: the force-complete loop above dropped the
+	 * response-side reference of every occupied slot and the sender
+	 * drain released the matching sender references, so nothing should
+	 * still be set here.  Release anything that is, rather than leak it.
+	 */
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
@@ -893,7 +1115,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	hwc->hwc_timeout = 0;
 
 	kfree(hwc);
-	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
 	vfree(gc->cq_table);
@@ -910,6 +1131,8 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	bool drop_resp_ref;
+	bool abandoned = false;
+	bool cancelled;
 	u32 dest_vrcq = 0;
 	u32 dest_vrq = 0;
 	u32 command;
@@ -955,7 +1178,25 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	/* The response-side reference (from get_msg_index) keeps the slot
 	 * alive if hardware responds right after the doorbell.
 	 */
-	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
+	/* Submit under the slot lock, so mana_hwc_destroy_channel() cannot
+	 * cancel this request between the check and the doorbell: it takes
+	 * the same lock, so it either cancels before this runs -- and the
+	 * request is never handed to the device -- or after, when the
+	 * request is genuinely in flight.  Posting is a WQE write plus a
+	 * doorbell, so it does not sleep.
+	 */
+	spin_lock_irqsave(&ctx->lock, flags);
+	cancelled = ctx->responded;
+	if (cancelled)
+		err = ctx->error;
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
@@ -972,9 +1213,23 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		ctx->output_buf = NULL;
 		err = ctx->error;
 		status = ctx->status_code;
+		if (err == -EINPROGRESS) {
+			/* Give up on this request in the same critical section
+			 * that clears output_buf, so a response can never
+			 * observe the slot as "sender has not published yet"
+			 * and be discarded as premature -- that would strand
+			 * the slot, because only a response frees it.
+			 *
+			 * Keep the response-side reference: the device may
+			 * still answer, so the slot stays taken until it does
+			 * and must not be handed to another request.
+			 */
+			ctx->responded = true;
+			abandoned = true;
+		}
 		spin_unlock_irqrestore(&ctx->lock, flags);
 
-		if (err != -EINPROGRESS) {
+		if (!abandoned) {
 			/* A response raced in just after the timeout, so the
 			 * hardware is alive: keep the channel and report what
 			 * that response said rather than a timeout.  It may
@@ -986,29 +1241,25 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
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
@@ -1041,14 +1292,15 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	err = 0;
 	goto done;
 out:
-	/* Error, no-wait teardown, or timeout: drop the sender's and the
-	 * response-side references.  Latch ->responded so a racing response
-	 * is a no-op, and only drop the response-side ref if it has not.
+	/* Only reached before the request reached the hardware, so no
+	 * response can ever arrive for it: latch ->responded and drop both
+	 * the response-side and the sender's reference, freeing the slot.
 	 */
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
index 308950f9b54b0485bac66b80d63e257eaf5f787e..f97f63f8fee418f4ca36f88019690c096e6f2e6a 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -468,6 +468,21 @@ struct gdma_context {
 	/* Hardware communication channel (HWC) */
 	struct gdma_dev		hwc;
 
+	/* destroy_channel() waits here for all HWC senders to exit.
+	 * Lives on gc (not hwc) so wake_up() after the last sender's
+	 * atomic_dec doesn't dereference freed hwc memory.
+	 */
+	wait_queue_head_t	hwc_drain_waitq;
+
+	/* Serializes hwc.driver_data (the hw_channel_context pointer)
+	 * between the control-plane readers in mana_gd_send_request(),
+	 * mana_need_log() and mana_serv_reset() and the publish/clear in
+	 * mana_hwc_create_channel()/mana_hwc_destroy_channel().  All users
+	 * are control-plane (HWC commands sleep; reset runs on a workqueue),
+	 * so a plain spinlock -- not RCU -- is sufficient.
+	 */
+	spinlock_t		hwc_lock;
+
 	/* Azure network adapter */
 	struct gdma_dev		mana;
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index daff051472a0dd9f57ee0b9fb3d71029fca909ad..5bddc87e8e78900097974968cefb6fb2d9415132 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -164,6 +164,9 @@ struct hwc_wq {
 	u16 queue_depth;
 
 	struct hwc_cq *hwc_cq;
+
+	/* Serializes concurrent mana_gd_post_and_ring() calls. */
+	spinlock_t lock;
 };
 
 struct hwc_caller_ctx {
@@ -189,6 +192,12 @@ struct hwc_caller_ctx {
 	 * so a later or duplicate response is dropped.
 	 */
 	bool responded;
+
+	/* True while the response-side reference is still held, i.e. while a
+	 * response for this acquisition may still arrive.  Dropped exactly
+	 * once, by whoever establishes that no further response is coming.
+	 */
+	bool resp_pending;
 };
 
 struct hw_channel_context {
@@ -196,6 +205,7 @@ struct hw_channel_context {
 	struct device *dev;
 
 	u16 num_inflight_msg;
+
 	u32 max_req_msg_size;
 
 	u16 hwc_init_q_depth_max;
@@ -208,6 +218,12 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
+	/* Counts the message slots that are free to acquire.  A slot held by
+	 * a timed-out request is never posted back, so the count falls
+	 * permanently until the response that owns it arrives or teardown
+	 * reclaims it; a sender then expires in down_timeout() instead of
+	 * blocking on a slot nothing will release.
+	 */
 	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
 
@@ -215,6 +231,11 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Set after channel is fully established; cleared on teardown to
+	 * abort waiters in mana_hwc_get_msg_index() and reject new sends.
+	 */
+	bool channel_up;
+
 	/* True once mana_smc_setup_hwc() has handed the ESTABLISH_HWC message
 	 * to the PF, so the device may DMA into the HWC buffers.  That
 	 * function clears it on entry and sets it at the handover, so only a
@@ -225,6 +246,12 @@ struct hw_channel_context {
 	 */
 	bool setup_active;
 
+	/* Count of in-flight mana_gd_send_request() callers.  Protected
+	 * by gc->hwc_lock; the last sender to drop it to zero wakes
+	 * gc->hwc_drain_waitq for the mana_hwc_destroy_channel() drain.
+	 */
+	unsigned int active_senders;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

