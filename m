Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3B8330656;
	Tue,  8 Sep 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788839566; cv=none; b=H0iTcBjyfToG+DxswDredcI58++QNuvZC/pPtvW66kqTyfd7lPFvMjX990PzDukGIPa9MYweuacKl/azDcoOWb8KHdaHH5BiqjhyrHZGTszRa6/hcVFza1mQbPOYeJvw1aV4sDBgxjvBFZoPtqhyU1EiQiUXFYUiB4e7Mi/hnys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788839566; c=relaxed/simple;
	bh=qh6fctz2WVtdB5Ok5ibBH18n9SD1GOZArmgZxdDplPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kezDr759/TeCsqo8sjSC4ttR0DZO/bO7cb1U+sbpuETgOEmOlfVayZMWSgirbm3f0rIcFsC1Yyf6SaP3TsyM9MIruLdFd+mQxA9EQD1dDf62miFrmIxERxzq+scSGu2AgcRBHd7rqbUzxYFgCz4xeNVg2GKD67V3H+rGx5BT5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id BDC8720B7136; Mon,  7 Sep 2026 20:52:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDC8720B7136
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
Subject: [PATCH net-next v5 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Mon,  7 Sep 2026 20:51:58 -0700
Message-ID: <20260908035201.402424-5-longli@microsoft.com>
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

Rebuild depth-one HWC queues at the advertised maximum, capped at 128.
Preserve the 24-bit depth in u32, bound allocations and round message
buffers to a power of two. Advertise support in the driver-version request.

Keep bootstrap queues for incompatible initial dimensions. A failed
teardown or rebuild instead retries teardown of any submitted queues
before restoring depth one; never test queues after an indeterminate
destroy result. Abort creation if that teardown also fails. Reject
incompatible message sizes after bootstrap fallback, and guard CQ
unpublishing when a failed establish left no table.

Reset dimensions and routing IDs before each establish. The missing-
doorbell guard stops progression to the channel test on every attempt,
but does not cover BAR bounds or earlier IRQ rearming.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5 (v4 -> v5):
 - Handle CQ cleanup when establishment failed before allocating cq_table.
 - Route initial destroy failures through confirmed teardown and fresh
   bootstrap reconstruction, rather than testing possibly destroyed queues.
 - Share the teardown gate with failed larger-depth establishment.
 - Correct dimension-validation and doorbell-guard scope descriptions;
   shorten comments without broadening validation policy.

Changes in v4 (standalone net-next rework after the v3 split):
 - Rework former patch 7/7 as patch 4/4 without the net fixes as prerequisites.
 - Cap depth at 128 and round message-buffer allocations to a power of two.
 - Require bootstrap message sizes before increasing depth, and validate
   the rebuilt channel's report against its allocations.
 - Reset dimensions/routing IDs on each establish and reject a missing
   doorbell after the handshake.
 - Retry teardown before restoring depth one after failed re-establishment.
 - Retain u32 storage of the 24-bit depth and allocation-overflow checks.

Changes in v3 (historical net fixes-only posting):
 - Defer the dynamic-depth feature; it was not included in the net series.

Changes in v2 (v1 -> v2):
 - Retain dynamic-depth patch 7/7 on the revised concurrency prerequisites;
   rebase the series onto net-next.

v1:
 - Introduce depth-one bootstrap, rebuild at the reported depth, capability
   advertisement, allocation checks and bootstrap fallback in patch 7/7.

 .../net/ethernet/microsoft/mana/gdma_main.c   |   8 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 197 +++++++++++++++++-
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/hw_channel.h                 |   9 +-
 4 files changed, 209 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index eb88bae2b14d86de33e79eb597a076a7d6e54436..78424e1d884f18e6b216d627fc80e77630b0b350 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1260,15 +1260,17 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 static void mana_gd_destroy_cq(struct gdma_context *gc,
 			       struct gdma_queue *queue)
 {
+	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
 	u32 id = queue->id;
 
-	if (id >= gc->max_num_cqs)
+	/* HWC re-establishment can fail before allocating the CQ table. */
+	if (!cq_table || id >= gc->max_num_cqs)
 		return;
 
-	if (!gc->cq_table[id])
+	if (!cq_table[id])
 		return;
 
-	gc->cq_table[id] = NULL;
+	cq_table[id] = NULL;
 }
 
 int mana_gd_create_hwc_queue(struct gdma_dev *gd,
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index a4f7346d285f740c40f4f63c20348e30531f1435..750ee8f72999489a42b2bf6e8561480e6ce07133 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -216,7 +216,12 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
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
@@ -546,7 +551,11 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 
 	dma_buf->num_reqs = q_depth;
 
-	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
+	/* mana_gd_alloc_memory() only accepts a power-of-two length, as
+	 * already assumed for the EQ and CQ rings above.  The slots are
+	 * carved from the head of the buffer, so any tail is unused.
+	 */
+	buf_size = roundup_pow_of_two(MANA_PAGE_ALIGN(q_depth * max_msg_size));
 
 	gmi = &dma_buf->mem_info;
 	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
@@ -754,7 +763,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
-static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
+static int mana_hwc_establish_channel(struct gdma_context *gc, u32 *q_depth,
 				      u32 *max_req_msg_size,
 				      u32 *max_resp_msg_size)
 {
@@ -771,6 +780,15 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
 	int err;
 
+	/* Do not reuse dimensions or routing IDs from a previous establish. */
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
@@ -789,6 +807,14 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
+	/* Reject a missing doorbell before the channel test. This neither
+	 * validates its BAR range nor protects earlier IRQ rearming.
+	 */
+	if (gc->hwc.doorbell == INVALID_DOORBELL) {
+		dev_err(hwc->dev, "HWC: no doorbell in init data\n");
+		return -EPROTO;
+	}
+
 	/* Both were set in mana_hwc_init_event_handler(). */
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
@@ -807,6 +833,12 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
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
@@ -846,13 +878,44 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
+/* Bring-up only: requires no senders or concurrent lifecycle operations.
+ * This helper does not unpublish the HWC or drain senders.
+ */
+static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+
+	/* The CQ helper deregisters the HWC EQ before returning. */
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
@@ -896,8 +959,132 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 		goto out;
 	}
 
+	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
+		/* Bound DMA allocations before using the 24-bit depth. */
+		if (q_depth_max > HW_CHANNEL_MAX_QUEUE_DEPTH)
+			q_depth_max = HW_CHANNEL_MAX_QUEUE_DEPTH;
+
+		/* Keep bootstrap message sizes for mandatory commands.
+		 * Incompatible reports skip rebuilding, not channel creation.
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
+			dev_err(hwc->dev,
+				"Failed to teardown HWC for reinit: %d\n",
+				err);
+			goto reinit_fallback;
+		}
+
+		hwc->setup_active = false;
+
+		/* Unpublish the CQ and drain its EQ before freeing the table. */
+		mana_hwc_destroy_queues(hwc);
+
+		old_cq_table = gc->cq_table;
+		gc->cq_table = NULL;
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
+			/* The rebuilt channel must support the allocated depth
+			 * and message sizes.
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
+			goto reinit_fallback;
+		}
+	}
+
+	goto skip_reinit;
+
+reinit_fallback:
+	/* A failed handshake leaves queue ownership uncertain. */
+	if (hwc->setup_active) {
+		if (mana_smc_teardown_hwc(&gc->shm_channel, false)) {
+			dev_err(hwc->dev,
+				"Failed to tear down HWC before bootstrap fallback\n");
+			goto out;
+		}
+		hwc->setup_active = false;
+	}
+
+	/* The failed establish may not have allocated cq_table. */
+	dev_warn(hwc->dev, "HWC reinit failed, falling back to bootstrap depth\n");
+
+	mana_hwc_destroy_queues(hwc);
+
+	old_cq_table = gc->cq_table;
+	gc->cq_table = NULL;
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
+		/* The restored channel must report the allocated message sizes. */
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
 	err = mana_hwc_test_channel(gc->hwc.driver_data,
-				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				    hwc->num_inflight_msg,
 				    max_req_msg_size, max_resp_msg_size);
 	if (err) {
 		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 571a533e62e64790f9000d42ab0e833fe36ccff6..22dd7c9cecc8a74ed08075bee2b6db6f39ea9cc0 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -692,6 +692,9 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver supports dynamic queue depth for HWC */
+#define GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH BIT(29)
+
 /* Driver supports non-contiguous queue buffers */
 #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
 
@@ -710,6 +713,7 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_PROBE_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
+	 GDMA_DRV_CAP_FLAG_1_DYN_HWC_QUEUE_DEPTH | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
 	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index fba27d8620a388a41ae7ddd3bf2b4792f7beec3d..dfd92336b2b4dc0e9943732f9080887683ebfbbc 100644
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
@@ -205,7 +212,7 @@ struct hw_channel_context {
 
 	u32 max_req_msg_size;
 
-	u16 hwc_init_q_depth_max;
+	u32 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
 
-- 
2.43.0
