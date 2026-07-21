Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17DE46D2B8;
	Tue, 21 Jul 2026 23:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677448; cv=none; b=W8T4ziB+XncxA39oWY8NENQBBJZDk45MiaVAJ4snClrko2/xmeSYlna7+y4nezARa3EkUnO089WjuLdtYrATemQXC26ZKgylLV6ZNVBENeWijoxWGCf7wfUZQO0W2M23AbMUmH9XOfla0Ff97AzaTnKyqdIJC7OM65TNHBALRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677448; c=relaxed/simple;
	bh=blq4mPwrDKDWoWExs/ZnxLBXdC1s3cLszfT8uNMMK8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYXN+DFM6YmfpiXZgvLPIXbEfFFvytP5OOzqwxuQUQ4yV3He9PzOC/SGzaJMaxfhH+cQUSeHa7+6dJ4eeEzYjbknnqvjPY3Ayjp8hNnYNfvzrrcuSX6KO5kT9vXTooOkg44e6bpmx0EPAmR/Ojl6vJyvchdFAZpO4jVK7UeQkJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 347CC20B716B; Tue, 21 Jul 2026 16:43:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 347CC20B716B
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
Subject: [PATCH net-next v2 7/7] net: mana: add dynamic HWC queue depth with reinit path
Date: Tue, 21 Jul 2026 16:43:36 -0700
Message-ID: <20260721234339.1476932-8-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260721234339.1476932-1-longli@microsoft.com>
References: <20260721234339.1476932-1-longli@microsoft.com>
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
GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH so the firmware enables this only
when the driver supports it.

mana_hwc_destroy_queues() tears down the CQ first, which deregisters the
EQ IRQ (mana_gd_deregister_irq() + synchronize_rcu()) so no interrupt
handler can touch the queues, then the TXQ, RXQ and inflight resources.

Validate the device-reported dimensions before they size DMA
allocations: enforce the request/response header minimums, ensure
q_depth * max_msg_size plus alignment fits in u32, and cap CQ depth to
U16_MAX/2.  Carry the depth as u32 -- the device field is 24-bit, so
truncating to u16 on receipt could wrap a large value to a small depth
and silently pass these checks.

If reinit fails, fall back to the bootstrap-depth channel when its
teardown succeeded; if teardown also failed, hardware mappings may still
be active, so abort channel creation instead.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 190 +++++++++++++++++-
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/hw_channel.h                 |   2 +-
 3 files changed, 191 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 616fb088c559..0481d4044342 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -214,7 +214,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
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
@@ -808,7 +813,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
-static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
+static int mana_hwc_establish_channel(struct gdma_context *gc, u32 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
@@ -886,6 +891,12 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
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
@@ -926,13 +937,62 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
+/* Tear down all HWC queues and free associated resources.  Used on
+ * the reinit-with-higher-queue-depth path and reinit fallback.
+ *
+ * PRECONDITION: must be called only during channel bring-up in
+ * mana_hwc_create_channel(), before the channel is published to
+ * senders.  There the setup thread is effectively single-threaded
+ * (serialized against teardown by the PCI/PM device_lock or, on the
+ * service path, GC_IN_SERVICE, with the data path not yet probed),
+ * channel_up is still false, caller_ctx is not yet allocated, and
+ * active_senders is 0 — so no concurrent request/response user can
+ * touch these queues.  That is why this skips the hwc_lock-protected
+ * driver_data clear + active_senders drain that
+ * mana_hwc_destroy_channel() needs for the runtime teardown race;
+ * only the CQ-first ordering below (to fence off a pending interrupt)
+ * is required.  Calling this on a live, published channel would be a
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
+	struct gdma_queue __rcu **old_cq_table;
 	unsigned long flags;
-	u16 q_depth_max;
+	u32 q_depth_max;
 	int err;
 
 	hwc = kzalloc_obj(*hwc);
@@ -980,8 +1040,130 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 		goto out;
 	}
 
+	/* The channel was bootstrapped at a minimal queue depth.  If the
+	 * device reports a higher maximum, tear down and rebuild with
+	 * the larger depth so more HWC commands can be in flight.
+	 */
+	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
+		/* q_depth_max now carries the full device-reported value
+		 * (HWC_INIT_DATA_QUEUE_DEPTH is 24-bit).  Clamp it to the
+		 * depth the rest of the driver supports — create_cq() takes
+		 * q_depth * 2 as a u16 — before the overflow check below, so
+		 * an over-large but otherwise-valid depth is reduced to the
+		 * maximum instead of wrapping or being rejected.
+		 */
+		if (q_depth_max > U16_MAX / 2)
+			q_depth_max = U16_MAX / 2;
+
+		/* Sanity-check device-reported values before using them
+		 * to size DMA allocations.  Enforce protocol minimums
+		 * for message sizes and check that q_depth * max_msg_size
+		 * plus alignment headroom fits in u32 (for
+		 * mana_hwc_alloc_dma_buf's MANA_PAGE_ALIGN).
+		 */
+		if (!max_req_msg_size || !max_resp_msg_size ||
+		    max_req_msg_size < sizeof(struct gdma_req_hdr) ||
+		    max_resp_msg_size < sizeof(struct gdma_resp_hdr) ||
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
+			/* Keep using the bootstrap-depth channel. */
+			dev_err(hwc->dev,
+				"Failed to teardown HWC for reinit: %d\n",
+				err);
+			q_depth_max = HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH;
+			goto skip_reinit;
+		}
+
+		hwc->setup_active = false;
+
+		/* Destroy queues first — mana_gd_destroy_cq inside
+		 * unpublishes the CQ from cq_table via
+		 * rcu_assign_pointer(NULL) + synchronize_rcu.
+		 * Must happen while cq_table is still valid.
+		 */
+		mana_hwc_destroy_queues(hwc);
+
+		old_cq_table = rcu_replace_pointer(gc->cq_table, NULL, true);
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
+		if (err) {
+			dev_err(hwc->dev, "Failed to re-establish HWC: %d\n",
+				err);
+			/* establish_channel does internal teardown on
+			 * failure.  If teardown succeeded (setup_active
+			 * cleared), MST entries are invalidated and we
+			 * can try the bootstrap fallback.  If teardown
+			 * also failed (setup_active still set), hardware
+			 * mappings may still be active — skip fallback.
+			 */
+			if (hwc->setup_active)
+				goto out;
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
+	old_cq_table = rcu_replace_pointer(gc->cq_table, NULL, true);
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
index 01e845237b6a..a4eac6f7c366 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -708,6 +708,9 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver supports dynamic queue depth for HWC */
+#define GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH BIT(29)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -723,6 +726,7 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_PROBE_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
+	 GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)
 
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 30bc236286dc..eec5d3aa23e1 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -197,7 +197,7 @@ struct hw_channel_context {
 	u32 max_req_msg_size;
 	u32 max_resp_msg_size;
 
-	u16 hwc_init_q_depth_max;
+	u32 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
 
-- 
2.43.0

