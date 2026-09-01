Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617A94570CF;
	Tue,  1 Sep 2026 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292874; cv=none; b=uSo3tCryQfuEhzVsVJrx8X6I4IIxLQVBjNtBfgCZ4badhO+NbfiPxjZaUHd1cZBq3Wqj+rYBt6Up6tYQPQ4s2qLNSE91AdcYMKtzCUg+k9ywmY64leJgccGSQlWz4LkpnEpLF7zwHvZ3YIK/4JcaSwVvGS2dYmqr1r2bQbNIz7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292874; c=relaxed/simple;
	bh=9i+yV/YFO+AUbhSMpAWS/qNBenB8mFJRmv14uBu6itI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSQPMlVlCqw5VFHc2YaAClfY+bLBV8W1ydwDLwE4utdGIYryOb4z+w0XDDLnxhEKkbhzJXZTxLXf40ddN87fPArei7v1EzggFwfSLhLjvv5JObDo1GydbJo7WTQmXl2AwrR6WpOrFqb/hSQSwYsrsftKNkL9vVXgqaoJTZ9cfhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 100E420B7129; Tue,  1 Sep 2026 13:00:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 100E420B7129
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
Subject: [PATCH net-next v4 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Tue,  1 Sep 2026 13:00:16 -0700
Message-ID: <20260901200018.3194525-5-longli@microsoft.com>
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

The HWC is first established at a bootstrap queue depth of 1.  Query the
device's maximum supported depth and, if larger, tear down and rebuild
the HWC queues at that depth before re-establishing the channel, so more
management commands can be in flight.  Advertise
GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH so the firmware knows the driver
supports a non-bootstrap depth.  That capability is sent by
mana_gd_verify_vf_version(), which is itself an HWC command and so
necessarily runs after the channel exists; the depth chosen here comes
from the device's own reported maximum.

mana_hwc_destroy_queues() tears down the CQ first, which deregisters the
EQ IRQ (mana_gd_deregister_irq() + synchronize_rcu()) so no interrupt
handler can touch the queues, then the TXQ, RXQ and inflight resources.

Validate the device-reported dimensions before they size DMA
allocations: take only the depth from the device and require the
negotiated message sizes to match the bootstrap ones, since mandatory
commands such as GDMA_VERIFY_VF_DRIVER_VERSION are much larger than the
protocol header minimum and mana_hwc_send_request() bounds a request
only against the slot it lands in; bound the depth by
HW_CHANNEL_MAX_QUEUE_DEPTH so the two coherent message buffers stay a
sane size; ensure
q_depth * max_msg_size plus alignment fits in u32, and cap CQ depth to
U16_MAX/2.  Round the message-buffer length up to a power of two, which
mana_gd_alloc_memory() requires and which the EQ and CQ rings already
did, so a device reporting dimensions whose product is not a power of
two still gets the larger depth instead of falling back.  Carry the
depth as u32 -- the device field is 24-bit, so
truncating to u16 on receipt could wrap a large value to a small depth
and silently pass these checks.

If the bootstrap channel cannot be torn down, keep using it at depth 1.
If the rebuild then fails before the new queue addresses were handed to
the PF, restore the bootstrap-depth channel: the device never saw them,
so the memory can be reused.  If they were already handed over the
device may still DMA into those queues, so tear the channel down once
more before reusing them -- only a successful DESTROY_HWC invalidates
the MST entries.  That matters because mana_smc_setup_hwc() marks the
handover before it reads the response, so a device that refuses the
larger depth still leaves the queues marked as handed over; retrying the
teardown lets such a device fall back to a working bootstrap channel
instead of failing probe outright.  If that teardown also fails, nothing
has established that the device is finished with the queues, so give up
rather than rebuild over them.

Reject a device-reported message size above the driver maximum, and
reset the negotiated init values before each establish so a firmware
that omits an HWC_INIT_DATA_* item cannot reuse stale dimensions or
drive an oversized DMA allocation.  The routing identities -- doorbell,
PDID and the PF destination queues -- are reset with them, since the
rebuilt queues are not the ones those described.  Because that reset
runs on every establish, a firmware that supplied the doorbell on the
first one but omits it on the second would leave INVALID_DOORBELL
behind, so refuse the channel in that case rather than let
mana_gd_ring_doorbell() turn it into an unchecked write far outside the
BAR.  The same write is already reachable without this patch when the
very first establish omits the doorbell; that is pre-existing and not
addressed here.  Anything else left unset either fails the dimension
checks above or leaves the queues unable to complete, which
mana_hwc_test_channel() already catches.  Finally, refuse a
rebuilt channel whose report contradicts the one its queues were built
from -- a shallower queue or smaller message limits -- rather than
oversubscribe what the device now admits to.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 297 +++++++++++++++++-
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/hw_channel.h                 |   9 +-
 3 files changed, 304 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 91fcf7c092113133d392f0e43f2eda62ca5cb919..83df4f194ee3bb41affb2110553d502322057b98 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -223,7 +223,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_QUEUE_DEPTH:
-			hwc->hwc_init_q_depth_max = (u16)val;
+			/* HWC_INIT_DATA_QUEUE_DEPTH is a 24-bit field.  Keep
+			 * the full device-reported value here; it is clamped
+			 * and validated in mana_hwc_create_channel() rather
+			 * than silently truncated to u16.
+			 */
+			hwc->hwc_init_q_depth_max = val;
 			break;
 
 		case HWC_INIT_DATA_MAX_REQUEST:
@@ -553,7 +558,11 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 
 	dma_buf->num_reqs = q_depth;
 
-	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
+	/* mana_gd_alloc_memory() only accepts a power-of-two length, as
+	 * already assumed for the EQ and CQ rings above.  The slots are
+	 * carved from the head of the buffer, so any tail is unused.
+	 */
+	buf_size = roundup_pow_of_two(MANA_PAGE_ALIGN(q_depth * max_msg_size));
 
 	gmi = &dma_buf->mem_info;
 	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
@@ -780,7 +789,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
-static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
+static int mana_hwc_establish_channel(struct gdma_context *gc, u32 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
@@ -797,6 +806,21 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
 	int err;
 
+	/* Clear the values a previous establish left behind so a firmware
+	 * that omits an HWC_INIT_DATA_* item on this cycle cannot silently
+	 * reuse stale dimensions from the last one.  The same applies to the
+	 * routing identities: the queues are rebuilt from scratch, so a
+	 * doorbell, PDID or PF destination left over from the previous
+	 * channel does not describe them.
+	 */
+	hwc->hwc_init_q_depth_max = 0;
+	hwc->hwc_init_max_req_msg_size = 0;
+	hwc->hwc_init_max_resp_msg_size = 0;
+	gc->hwc.doorbell = INVALID_DOORBELL;
+	gc->hwc.pdid = INVALID_PDID;
+	hwc->pf_dest_vrq_id = 0;
+	hwc->pf_dest_vrcq_id = 0;
+
 	init_completion(&hwc->hwc_init_eqe_comp);
 
 	err = mana_smc_setup_hwc(&gc->shm_channel, false,
@@ -815,6 +839,20 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
+	/* The doorbell was cleared before the handshake, so a firmware that
+	 * signals INIT_DONE without sending GDMA_EQE_HWC_INIT_EQ_ID_DB
+	 * leaves INVALID_DOORBELL behind.  mana_gd_ring_doorbell() turns
+	 * that into gc->db_page_base + gc->db_page_size * 0xffffffff, an
+	 * unchecked MMIO write far outside the mapped BAR, and the channel
+	 * test below rings it.  Everything else the device reports either
+	 * fails the dimension checks in mana_hwc_create_channel() or leaves
+	 * the queues unable to complete, which that test already catches.
+	 */
+	if (gc->hwc.doorbell == INVALID_DOORBELL) {
+		dev_err(hwc->dev, "HWC: no doorbell in init data\n");
+		return -EPROTO;
+	}
+
 	/* Both were set in mana_hwc_init_event_handler(). */
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
@@ -833,6 +871,12 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 {
 	int err;
 
+	/* CQ depth is q_depth * 2 (SQ + RQ) passed as u16 to create_cq.
+	 * Cap to prevent u16 truncation.
+	 */
+	if (q_depth > U16_MAX / 2)
+		q_depth = U16_MAX / 2;
+
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
 	if (err)
 		return err;
@@ -872,13 +916,64 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
+/* Tear down all HWC queues and free associated resources.  Used on
+ * the reinit-with-higher-queue-depth path and reinit fallback.
+ *
+ * PRECONDITION: must be called only during channel bring-up in
+ * mana_hwc_create_channel(), before the channel carries traffic:
+ * channel_up is still false, caller_ctx is not yet allocated, the
+ * data path is not probed yet, and active_senders is 0 — so no
+ * request or response user can reach these queues.  That is why this
+ * skips the hwc_lock-protected driver_data clear + active_senders
+ * drain that mana_hwc_destroy_channel() needs for the runtime
+ * teardown race; only the CQ-first ordering below (to fence off a
+ * pending interrupt) is required.  Bring-up itself runs under the
+ * PCI/PM device_lock, or under GC_IN_SERVICE on the service path;
+ * those two do not exclude each other, so a service reset racing a PM
+ * transition is not serialized — but that is pre-existing and applies
+ * equally to mana_hwc_destroy_channel(), which frees the same
+ * objects.  Calling this on a live, published channel would be a
+ * use-after-free.
+ */
+static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+
+	/* Destroy CQ first to deregister the EQ from the interrupt
+	 * handler list before freeing caller_ctx, TXQ, or RXQ memory.
+	 * A pending interrupt handler could still reach handle_resp()
+	 * which dereferences caller_ctx.
+	 */
+	if (hwc->cq) {
+		mana_hwc_destroy_cq(gc, hwc->cq);
+		hwc->cq = NULL;
+	}
+
+	kfree(hwc->caller_ctx);
+	hwc->caller_ctx = NULL;
+
+	if (hwc->txq) {
+		mana_hwc_destroy_wq(hwc, hwc->txq);
+		hwc->txq = NULL;
+	}
+
+	if (hwc->rxq) {
+		mana_hwc_destroy_wq(hwc, hwc->rxq);
+		hwc->rxq = NULL;
+	}
+
+	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	hwc->num_inflight_msg = 0;
+}
+
 int mana_hwc_create_channel(struct gdma_context *gc)
 {
 	u32 max_req_msg_size, max_resp_msg_size;
 	struct gdma_dev *gd = &gc->hwc;
 	struct hw_channel_context *hwc;
+	struct gdma_queue **old_cq_table;
 	unsigned long flags;
-	u16 q_depth_max;
+	u32 q_depth_max;
 	int err;
 
 	hwc = kzalloc_obj(*hwc);
@@ -926,8 +1021,200 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 		goto out;
 	}
 
+	/* The channel was bootstrapped at a minimal queue depth.  If the
+	 * device reports a higher maximum, tear down and rebuild with
+	 * the larger depth so more HWC commands can be in flight.
+	 */
+	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
+		/* q_depth_max now carries the full device-reported value
+		 * (HWC_INIT_DATA_QUEUE_DEPTH is 24-bit).  Clamp it before
+		 * the overflow check below, so an over-large but otherwise
+		 * valid depth is reduced instead of wrapping or being
+		 * rejected.  The bound also keeps the two coherent DMA
+		 * buffers, which scale with the depth, to a sane size.
+		 */
+		if (q_depth_max > HW_CHANNEL_MAX_QUEUE_DEPTH)
+			q_depth_max = HW_CHANNEL_MAX_QUEUE_DEPTH;
+
+		/* Sanity-check device-reported values before using them to
+		 * size DMA allocations.  Only the depth is taken from the
+		 * device: the rebuilt queues must keep the bootstrap
+		 * message sizes, because the rest of the driver already
+		 * assumes it can send any request up to
+		 * HW_CHANNEL_MAX_REQUEST_SIZE -- mandatory commands such as
+		 * GDMA_VERIFY_VF_DRIVER_VERSION are far larger than the
+		 * protocol header minimum, and mana_hwc_send_request() only
+		 * bounds a request against the slot it lands in.  Also check
+		 * that q_depth * max_msg_size plus alignment headroom fits
+		 * in u32 (for mana_hwc_alloc_dma_buf's MANA_PAGE_ALIGN).
+		 */
+		if (max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
+		    max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE ||
+		    (u64)q_depth_max * max_req_msg_size >
+			U32_MAX - MANA_PAGE_SIZE ||
+		    (u64)q_depth_max * max_resp_msg_size >
+			U32_MAX - MANA_PAGE_SIZE) {
+			dev_err(hwc->dev,
+				"HWC: invalid dims q=%u req=%u resp=%u\n",
+				q_depth_max, max_req_msg_size,
+				max_resp_msg_size);
+			q_depth_max = HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH;
+			goto skip_reinit;
+		}
+
+		err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+		if (err) {
+			/* Keep using the bootstrap-depth channel.  The
+			 * destroy request may already have been written to
+			 * the PF before the response failed, so the PF may
+			 * have invalidated the MST entries; nothing is freed
+			 * here, and mana_hwc_test_channel() below fails the
+			 * channel creation if the queues are no longer
+			 * usable.
+			 */
+			dev_err(hwc->dev,
+				"Failed to teardown HWC for reinit: %d\n",
+				err);
+			q_depth_max = HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH;
+			goto skip_reinit;
+		}
+
+		hwc->setup_active = false;
+
+		/* Destroy the queues before the CQ table they refer to:
+		 * mana_hwc_destroy_queues() releases the HWC CQ, so it must
+		 * run while cq_table is still valid.
+		 */
+		mana_hwc_destroy_queues(hwc);
+
+		old_cq_table = gc->cq_table;
+		gc->cq_table = NULL;
+		/* Clear the bound with the table: mana_gd_destroy_cq() gates
+		 * on max_num_cqs before indexing cq_table, so leaving a stale
+		 * bound behind would let it dereference the NULL table.
+		 */
+		gc->max_num_cqs = 0;
+		synchronize_rcu();
+		vfree(old_cq_table);
+
+		err = mana_hwc_init_queues(hwc, q_depth_max,
+					   max_req_msg_size,
+					   max_resp_msg_size);
+		if (err) {
+			dev_err(hwc->dev, "Failed to reinit HWC: %d\n", err);
+			goto reinit_fallback;
+		}
+
+		err = mana_hwc_establish_channel(gc, &q_depth_max,
+						 &max_req_msg_size,
+						 &max_resp_msg_size);
+		if (!err &&
+		    (q_depth_max < hwc->num_inflight_msg ||
+		     max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
+		     max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE)) {
+			/* The rebuilt channel contradicts the report its own
+			 * queues were built from: a shallower queue would be
+			 * oversubscribed by the slots already allocated, and
+			 * smaller message limits would be exceeded by every
+			 * command sized for the buffers already allocated.
+			 * The queues are handed to the PF by now, so give up
+			 * rather than run past what the device admits to.
+			 */
+			dev_err(hwc->dev,
+				"HWC: rebuilt q=%u req=%u resp=%u, built for %u/%u/%u\n",
+				q_depth_max, max_req_msg_size,
+				max_resp_msg_size, hwc->num_inflight_msg,
+				HW_CHANNEL_MAX_REQUEST_SIZE,
+				HW_CHANNEL_MAX_RESPONSE_SIZE);
+			err = -EPROTO;
+		}
+		if (err) {
+			dev_err(hwc->dev, "Failed to re-establish HWC: %d\n",
+				err);
+			/* setup_active tells us whether this attempt got
+			 * as far as handing the queue addresses to the PF.
+			 * If it did not, the device never saw them and the
+			 * bootstrap fallback can safely reuse the memory.
+			 *
+			 * If it did, the mappings are live and rebuilding
+			 * over them would let the device DMA into queues
+			 * this path is about to free.  Tear the channel down
+			 * once more first: only a successful DESTROY_HWC
+			 * invalidates the MST entries, and that is what makes
+			 * the fallback safe again -- so a device that refuses
+			 * the larger depth still ends up on a working
+			 * bootstrap channel rather than failing probe
+			 * outright.  If that teardown also fails, nothing has
+			 * established that the device is finished with the
+			 * queues, so give up rather than reuse them.
+			 */
+			if (hwc->setup_active) {
+				if (mana_smc_teardown_hwc(&gc->shm_channel,
+							  false)) {
+					dev_err(hwc->dev,
+						"Failed to tear down HWC after failed reinit\n");
+					goto out;
+				}
+				hwc->setup_active = false;
+			}
+			goto reinit_fallback;
+		}
+	}
+
+	goto skip_reinit;
+
+reinit_fallback:
+	/* Restore bootstrap-depth channel so the device remains functional.
+	 * Free cq_table if it was allocated by a partially successful
+	 * establish attempt.
+	 */
+	dev_warn(hwc->dev, "HWC reinit failed, falling back to bootstrap depth\n");
+
+	mana_hwc_destroy_queues(hwc);
+
+	old_cq_table = gc->cq_table;
+	gc->cq_table = NULL;
+	/* Clear the bound with the table, as above. */
+	gc->max_num_cqs = 0;
+	synchronize_rcu();
+	vfree(old_cq_table);
+
+	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				   HW_CHANNEL_MAX_REQUEST_SIZE,
+				   HW_CHANNEL_MAX_RESPONSE_SIZE);
+	if (err) {
+		dev_err(hwc->dev, "Failed to restore bootstrap HWC: %d\n", err);
+		goto out;
+	}
+
+	err = mana_hwc_establish_channel(gc, &q_depth_max, &max_req_msg_size,
+					 &max_resp_msg_size);
+	if (!err &&
+	    (max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
+	     max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE)) {
+		/* The queues above were rebuilt with the bootstrap sizes, so
+		 * a handshake that now reports different limits describes
+		 * queues that do not exist.  Commands are only bounded by the
+		 * slots they land in, so they would be sized for the
+		 * bootstrap limits and could exceed what the device accepts.
+		 */
+		dev_err(hwc->dev, "HWC: bootstrap reports req=%u resp=%u\n",
+			max_req_msg_size, max_resp_msg_size);
+		err = -EPROTO;
+	}
+	if (err) {
+		dev_err(hwc->dev, "Failed to re-establish bootstrap HWC: %d\n",
+			err);
+		goto out;
+	}
+
+skip_reinit:
+
+	/* No RCU needed: still in mana_hwc_create_channel, the
+	 * pointer has not been published to concurrent senders yet.
+	 */
 	err = mana_hwc_test_channel(gc->hwc.driver_data,
-				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				    hwc->num_inflight_msg,
 				    max_req_msg_size, max_resp_msg_size);
 	if (err) {
 		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index f97f63f8fee418f4ca36f88019690c096e6f2e6a..b435b2039c1f9d469f0f054ed37625cdfd1e1212 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -698,6 +698,9 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver supports dynamic queue depth for HWC */
+#define GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH BIT(29)
+
 /* Driver supports non-contiguous queue buffers */
 #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
 
@@ -716,6 +719,7 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_PROBE_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
+	 GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
 	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 5bddc87e8e78900097974968cefb6fb2d9415132..c2954f1f613736e7107c54d316bb12a804e83817 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -11,6 +11,13 @@
 
 #define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1
 
+/* Upper bound on the device-reported HWC queue depth.  The HWC is a
+ * control channel, so a modest depth already keeps enough management
+ * commands in flight, while the depth directly scales two coherent DMA
+ * buffers of q_depth * max_msg_size bytes each.
+ */
+#define HW_CHANNEL_MAX_QUEUE_DEPTH 128
+
 #define HWC_INIT_DATA_CQID		1
 #define HWC_INIT_DATA_RQID		2
 #define HWC_INIT_DATA_SQID		3
@@ -208,7 +215,7 @@ struct hw_channel_context {
 
 	u32 max_req_msg_size;
 
-	u16 hwc_init_q_depth_max;
+	u32 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
 
-- 
2.43.0

