Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534880;
	b=vZJ8lhCsP+hWpE0n/cHC9yDu+chHVFR8hoVvCpBsdfJrmP8Rn/4jsDqnODdL0yla+eXD
	 zeYPnnZ1Wao2DyYzBZlxxxl24DJgiNUqf2JU9JY048+DjrhPE6NU3XfC7zJOFsw4bzZy/
	 pf5aEfYT5Iq3qs8oxVuCh8rjwXpsXJjwt69BAgPtI3F79pPZRFEXmgxt0F2Hqek1WmMxU
	 fdF8kTrnIptbkJ5K43MTTXrC1viCVnj7qne3ZsMY3Lg/fO7OS56qd+CHB9bbD28UyxNgL
	 E8XvSeei37l4d6B44rHneP5fIG+V0XayNBC6uXML6xqFRkh9lZTjEDGis7japX8ehEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534880;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=zdOqAmDOC2VwCgyDkSVtDKwXBBeEUbT/Hr8+s4Gb6mI=;
	b=EB79yZE9dJBz2n8gEDVZbOVFvIEgKsV8q2uLmHa/c/TR2bDodAtj3BVvlmnFH2o+10Tc
	 gRWasgY7tqQawcyFZzpBqc8+VRcNMYrkDC9oEg/k3Ga9eWoriOvXbq1lrWuRdlVw49pQ9
	 FFaxA9xNnXsjSpar8Z5T6dSXr8jc4zZU4MMZamre0EydWhS7fvX3EVFM96+FGt2oZqEQi
	 vlwadEQM2o5TPvr4TsLPYbQMYoesoBa8IYnxUZpQZHo2x7w+57o8ZTMfZuHi6e4P+l6jU
	 AOs9B0oxIwSKkkiwcoTgANjeLQAgG4waFRmz9fZvQs8GqzlxzefF3yULnj/Rog4j8qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=AqigBdjO;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7415C606A68C;
	Tue, 24 Nov 2026 15:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7415C606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=AqigBdjO
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5B16520B718B;
	Tue, 24 Nov 2026 07:41:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B16520B718B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534872;
	bh=zdOqAmDOC2VwCgyDkSVtDKwXBBeEUbT/Hr8+s4Gb6mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqigBdjOaySqq7S9ZmtSXGxENcAXz4Pi2+Pl7BceAyHxFEmLrYIVjXu+UU3WyDAfn
	 hjd1xEc6hzAqRAT0ghFj9XiYsEnwy3MT4qfetvvdfd6Am4wfBtZ4mPsRwjS1IBlKmn
	 yo8arTOScFe7jfSx4d4P8NNTrAFoTWLFboZr76ws=
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
Subject: [PATCH net-next v12 5/5] net: mana: use the reported HWC queue depth
Date: Tue, 24 Nov 2026 15:40:58 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.5@linux.microsoft.com>
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
Date: Mon, 24 Aug 2026 20:04:01 +0000

The bootstrap channel handles one request at a time. Rebuild it at the
depth reported by the PF if all four descriptor rings still fit in
4 KiB and the message sizes match the bootstrap allocations. Otherwise
keep the bootstrap queues and enforce the reported transmit and receive
limits.

Test the new channel before publishing it. If the test fails, restore
and test a depth-one channel without changing the firmware timeout. Do
not reuse the queues if the PF did not acknowledge teardown.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c             |  12 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |   2 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 286 +++++++++++++++---
 include/net/mana/hw_channel.h                 |  16 +-
 4 files changed, 260 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 60a9f15e5e8c1d0c807ded7177d8da909a0626da..baf894342c156d1e4e71ec0476c829ee90957c82 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -415,28 +415,31 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 	unsigned int create_req_msg_size;
 	struct hw_channel_context *hwc;
 	struct ib_block_iter biter;
-	size_t max_pgs_add_cmd = 0;
+	size_t max_pgs_add_cmd;
 	size_t max_pgs_create_cmd;
 	struct gdma_context *gc;
 	size_t num_pages_total;
 	unsigned int tail = 0;
+	u32 req_limit;
 	u64 *page_addr_list;
 	void *request_buf;
 	int err = 0;
 
 	gc = mdev_to_gc(dev);
 	hwc = gc->hwc.driver_data;
+	req_limit = mana_hwc_get_max_req_size(hwc);
 
 	num_pages_total = ib_umem_num_dma_blocks(umem, page_sz);
 
 	max_pgs_create_cmd =
-		(hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
+		(req_limit - sizeof(*create_req)) / sizeof(u64);
+	max_pgs_add_cmd = (req_limit - sizeof(*add_req)) / sizeof(u64);
 	num_pages_to_handle =
 		min_t(size_t, num_pages_total, max_pgs_create_cmd);
 	create_req_msg_size =
 		struct_size(create_req, page_addr_list, num_pages_to_handle);
 
-	request_buf = kzalloc(hwc->max_req_msg_size, GFP_KERNEL);
+	request_buf = kzalloc(req_limit, GFP_KERNEL);
 	if (!request_buf)
 		return -ENOMEM;
 
@@ -479,9 +482,6 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 			if (err)
 				goto out;
 
-			max_pgs_add_cmd = (hwc->max_req_msg_size -
-				sizeof(*add_req)) / sizeof(u64);
-
 			add_req = request_buf;
 			add_req->dma_region_handle = *gdma_region;
 			add_req->reserved3 = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 0ada3861e259f1301bb6c243ca9c5e7d89abe25d..cf680263d3bbe7c9a0127bdf45a4bcad373b54e5 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1347,7 +1347,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
-	if (req_msg_size > hwc->max_req_msg_size)
+	if (req_msg_size > mana_hwc_get_max_req_size(hwc))
 		return -EINVAL;
 
 	req = kzalloc(req_msg_size, GFP_KERNEL);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index cf1b9c75b10e2f2bc3f8da06f1adc2d7af3d2b97..c78c2baf7048d83215da7e0e1927b88b209a60d5 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -4,6 +4,7 @@
 #include <net/mana/gdma.h>
 #include <net/mana/mana.h>
 #include <net/mana/hw_channel.h>
+#include <linux/sizes.h>
 #include <linux/vmalloc.h>
 
 /* Private send outcome; don't confuse a local errno with DMA retirement. */
@@ -231,7 +232,8 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_QUEUE_DEPTH:
-			hwc->hwc_init_q_depth_max = (u16)val;
+			/* Preserve the full 24-bit report for validation. */
+			hwc->hwc_init_q_depth_max = val;
 			break;
 
 		case HWC_INIT_DATA_MAX_REQUEST:
@@ -594,7 +596,8 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 
 	dma_buf->num_reqs = q_depth;
 
-	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
+	/* mana_gd_alloc_memory() requires a power-of-two length. */
+	buf_size = roundup_pow_of_two(MANA_PAGE_ALIGN(q_depth * max_msg_size));
 
 	gmi = &dma_buf->mem_info;
 	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
@@ -785,10 +788,15 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc)
 	return mana_gd_test_hwc_eq(hwc, hwc->cq->gdma_eq);
 }
 
-static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
-				      u16 *q_depth,
-				      u32 *max_req_msg_size,
-				      u32 *max_resp_msg_size)
+struct mana_hwc_init_report {
+	u32 queue_depth;
+	u32 max_req_msg_size;
+	u32 max_resp_msg_size;
+};
+
+static int
+mana_hwc_establish_channel(struct hw_channel_context *hwc,
+			   struct mana_hwc_init_report *report)
 {
 	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct gdma_queue *rq = hwc->rxq->gdma_wq;
@@ -800,6 +808,15 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	u32 cq_id;
 	int err;
 
+	hwc->hwc_init_q_depth_max = 0;
+	hwc->hwc_init_max_req_msg_size = 0;
+	hwc->hwc_init_max_resp_msg_size = 0;
+	hwc->hwc_init_max_num_cqs = 0;
+	hwc->hwc_init_cq_id = 0;
+	gc->hwc.pdid = INVALID_PDID;
+	hwc->dest_vrq_id = 0;
+	hwc->dest_vrcq_id = 0;
+
 	gc->hwc.doorbell = INVALID_DOORBELL;
 	WRITE_ONCE(hwc->hwc_init_error, 0);
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -820,9 +837,9 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	if (err)
 		return err;
 
-	*q_depth = hwc->hwc_init_q_depth_max;
-	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
-	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
+	report->queue_depth = hwc->hwc_init_q_depth_max;
+	report->max_req_msg_size = hwc->hwc_init_max_req_msg_size;
+	report->max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
 	/* Snapshot the device-reported count and id once, so the same value
 	 * sizes, bounds and indexes cq_table even across the sleeping
@@ -872,6 +889,9 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 {
 	int err;
 
+	if (q_depth > U16_MAX / 2)
+		return -EINVAL;
+
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
 	if (err)
 		return err;
@@ -904,10 +924,11 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
 
 	return 0;
 out:
-	/* mana_hwc_create_channel() will do the cleanup.*/
+	/* The setup path tears down any partially initialized queues. */
 	return err;
 }
 
@@ -923,6 +944,33 @@ static void mana_hwc_clear_cq_table(struct gdma_context *gc)
 	vfree(cq_table);
 }
 
+/* Setup is private; runtime teardown has unpublished and drained senders. */
+static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+
+	mana_hwc_clear_cq_table(gc);
+
+	if (hwc->cq) {
+		mana_hwc_destroy_cq(gc, hwc->cq);
+		hwc->cq = NULL;
+	}
+
+	if (hwc->txq) {
+		mana_hwc_destroy_wq(hwc, hwc->txq);
+		hwc->txq = NULL;
+	}
+	if (hwc->rxq) {
+		mana_hwc_destroy_wq(hwc, hwc->rxq);
+		hwc->rxq = NULL;
+	}
+
+	kfree(hwc->caller_ctx);
+	hwc->caller_ctx = NULL;
+	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	hwc->num_inflight_msg = 0;
+}
+
 static int mana_hwc_publish_channel(struct hw_channel_context *hwc)
 {
 	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
@@ -1010,45 +1058,38 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
 		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
 }
 
-static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
+static int mana_hwc_teardown_queues(struct hw_channel_context *hwc)
 {
 	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	int err;
 
 	mana_hwc_stop_channel(hwc);
-
-	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
-	 * software dispatch, but retain every PF-visible allocation.
-	 */
 	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
 				    &hwc->setup_active);
 	if (err) {
+		hwc->teardown_failed = true;
 		dev_err(hwc->dev,
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		mana_hwc_retain_channel(hwc);
-		return false;
+		return err;
 	}
 
-	mana_hwc_clear_cq_table(gc);
+	mana_hwc_destroy_queues(hwc);
 
-	/* Fence the EQ before releasing the remaining HWC state. */
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
-	if (hwc->txq)
-		mana_hwc_destroy_wq(hwc, hwc->txq);
-
-	if (hwc->rxq)
-		mana_hwc_destroy_wq(hwc, hwc->rxq);
-
-	kfree(hwc->caller_ctx);
-	hwc->caller_ctx = NULL;
+	return 0;
+}
 
-	mana_gd_free_res_map(&hwc->inflight_msg_res);
+static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 
-	hwc->num_inflight_msg = 0;
+	if (hwc->teardown_failed || mana_hwc_teardown_queues(hwc)) {
+		/* Leave any retry to the next destroy, not this unwind. */
+		hwc->teardown_failed = false;
+		mana_hwc_retain_channel(hwc);
+		return false;
+	}
 
 	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
 	hwc->gdma_dev->pdid = INVALID_PDID;
@@ -1097,32 +1138,177 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
 	gc->hwc.gdma_context = NULL;
 }
 
-static int mana_hwc_create_bootstrap_channel(struct hw_channel_context *hwc)
+static int
+mana_hwc_validate_report(struct hw_channel_context *hwc,
+			 const struct mana_hwc_init_report *report,
+			 u32 expected_depth, bool check_depth,
+			 bool require_exact_msg_sizes)
+{
+	if (!report->queue_depth || !report->max_req_msg_size ||
+	    !report->max_resp_msg_size) {
+		dev_err(hwc->dev,
+			"HWC: invalid maxima depth=%u req=%u resp=%u\n",
+			report->queue_depth, report->max_req_msg_size,
+			report->max_resp_msg_size);
+		return -EPROTO;
+	}
+
+	if (require_exact_msg_sizes &&
+	    (report->max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
+	     report->max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE)) {
+		dev_err(hwc->dev,
+			"HWC: rebuilt message maxima req=%u resp=%u, expected %u/%u\n",
+			report->max_req_msg_size, report->max_resp_msg_size,
+			HW_CHANNEL_MAX_REQUEST_SIZE,
+			HW_CHANNEL_MAX_RESPONSE_SIZE);
+		return -EPROTO;
+	}
+
+	if (check_depth && report->queue_depth != expected_depth) {
+		dev_err(hwc->dev, "HWC: rebuilt depth %u, expected %u\n",
+			report->queue_depth, expected_depth);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+static int mana_hwc_finish_channel(struct hw_channel_context *hwc,
+				   const struct mana_hwc_init_report *report)
 {
-	u32 max_req_msg_size, max_resp_msg_size;
-	u16 q_depth_max;
 	int err;
 
-	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
+	hwc->rx_msg_size_limit = report->max_req_msg_size;
+	hwc->tx_msg_size_limit = report->max_resp_msg_size;
+
+	err = mana_hwc_test_channel(hwc);
+	if (err)
+		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
+
+	return err;
+}
+
+static int mana_hwc_build_channel(struct hw_channel_context *hwc, u16 q_depth,
+				  struct mana_hwc_init_report *report)
+{
+	int err;
+
+	err = mana_hwc_init_queues(hwc, q_depth,
 				   HW_CHANNEL_MAX_REQUEST_SIZE,
 				   HW_CHANNEL_MAX_RESPONSE_SIZE);
 	if (err) {
-		dev_err(hwc->dev, "Failed to initialize HWC: %d\n", err);
+		dev_err(hwc->dev, "Failed to initialize HWC depth %u: %d\n",
+			q_depth, err);
 		return err;
 	}
 
-	err = mana_hwc_establish_channel(hwc, &q_depth_max, &max_req_msg_size,
-					 &max_resp_msg_size);
-	if (err) {
-		dev_err(hwc->dev, "Failed to establish HWC: %d\n", err);
+	err = mana_hwc_establish_channel(hwc, report);
+	if (err)
+		dev_err(hwc->dev, "Failed to establish HWC depth %u: %d\n",
+			q_depth, err);
+
+	return err;
+}
+
+static int
+mana_hwc_restore_bootstrap(struct hw_channel_context *hwc,
+			   struct mana_hwc_init_report *report)
+{
+	int err;
+
+	err = mana_hwc_build_channel(hwc,
+				     HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				     report);
+	if (err)
 		return err;
-	}
 
-	err = mana_hwc_test_channel(hwc);
+	err = mana_hwc_validate_report(hwc, report, 0, false, false);
 	if (err)
-		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
+		return err;
 
-	return err;
+	return mana_hwc_finish_channel(hwc, report);
+}
+
+static int mana_hwc_rebuild_channel(struct hw_channel_context *hwc,
+				    u16 q_depth,
+				    struct mana_hwc_init_report *report)
+{
+	int cleanup_err;
+	int err;
+
+	err = mana_hwc_teardown_queues(hwc);
+	if (err)
+		return err;
+
+	err = mana_hwc_build_channel(hwc, q_depth, report);
+	if (!err)
+		err = mana_hwc_validate_report(hwc, report, q_depth,
+					       true, true);
+	if (!err)
+		err = mana_hwc_finish_channel(hwc, report);
+	if (!err)
+		return 0;
+
+	dev_warn(hwc->dev,
+		 "HWC depth %u rebuild failed, restoring bootstrap: %d\n",
+		 q_depth, err);
+
+	cleanup_err = mana_hwc_teardown_queues(hwc);
+	if (cleanup_err)
+		return cleanup_err;
+
+	return mana_hwc_restore_bootstrap(hwc, report);
+}
+
+static bool mana_hwc_depth_fits(u32 depth)
+{
+	/* ESTABLISH_HWC supplies addresses, not ring sizes. The PF uses the
+	 * same 4 KiB descriptor rings after rebuild: depth changes how many
+	 * requests may be outstanding, not where the rings wrap.
+	 */
+	return depth <= SZ_4K / GDMA_MAX_SQE_SIZE &&
+	       depth <= SZ_4K / GDMA_MAX_RQE_SIZE &&
+	       depth <= SZ_4K / (2 * GDMA_CQE_SIZE) &&
+	       depth <= SZ_4K / (2 * GDMA_EQE_SIZE);
+}
+
+static int mana_hwc_prepare_channel(struct hw_channel_context *hwc)
+{
+	struct mana_hwc_init_report report;
+	u16 rebuild_depth;
+	int err;
+
+	err = mana_hwc_build_channel(hwc,
+				     HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+				     &report);
+	if (err)
+		return err;
+
+	err = mana_hwc_validate_report(hwc, &report, 0, false, false);
+	if (err)
+		return err;
+
+	if (!mana_hwc_depth_fits(report.queue_depth)) {
+		dev_warn(hwc->dev,
+			 "HWC depth %u exceeds ring capacity, keeping bootstrap\n",
+			 report.queue_depth);
+	} else if (report.queue_depth >
+		   HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH &&
+		   (report.max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE ||
+		    report.max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE)) {
+		dev_warn(hwc->dev,
+			 "HWC maxima req=%u resp=%u differ from rebuild policy %u/%u, keeping bootstrap\n",
+			 report.max_req_msg_size, report.max_resp_msg_size,
+			 HW_CHANNEL_MAX_REQUEST_SIZE,
+			 HW_CHANNEL_MAX_RESPONSE_SIZE);
+	} else if (report.queue_depth >
+		   HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
+		rebuild_depth = report.queue_depth;
+		return mana_hwc_rebuild_channel(hwc, rebuild_depth, &report);
+	}
+
+	return mana_hwc_finish_channel(hwc, &report);
 }
 
 int mana_hwc_create_channel(struct gdma_context *gc)
@@ -1156,7 +1342,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
-	err = mana_hwc_create_bootstrap_channel(hwc);
+	err = mana_hwc_prepare_channel(hwc);
 	if (err) {
 		mana_hwc_release_channel(hwc);
 		return err;
@@ -1206,6 +1392,7 @@ struct hwc_submission {
 	struct list_head entry;
 	const struct gdma_req_hdr *req;
 	u32 len;
+	u32 resp_len;
 	unsigned int id;
 	int err;
 };
@@ -1216,7 +1403,8 @@ static int mana_hwc_stage(struct hw_channel_context *hwc,
 	struct hwc_work_request *tx = &hwc->txq->msg_buf->reqs[id];
 	struct gdma_req_hdr *hdr;
 
-	if (sub->len > tx->buf_len)
+	if (sub->len > min(hwc->tx_msg_size_limit, tx->buf_len) ||
+	    sub->resp_len > min(hwc->rx_msg_size_limit, hwc->max_req_msg_size))
 		return -EMSGSIZE;
 
 	hdr = memcpy(tx->buf_va, sub->req, sub->len);
@@ -1353,7 +1541,9 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  bool teardown)
 {
 	const struct gdma_req_hdr *hdr = req;
-	struct hwc_submission sub = { .req = req, .len = req_len };
+	struct hwc_submission sub = {
+		.req = req, .len = req_len, .resp_len = resp_len,
+	};
 	DEFINE_WAIT(wait);
 	long remaining;
 	int err;
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index c154264f0f7c30efb989243ce2d9282aefbc61a8..23df7222e833988ec0e46be9b64904755d4a3571 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -4,6 +4,8 @@
 #ifndef _HW_CHANNEL_H
 #define _HW_CHANNEL_H
 
+#include <linux/minmax.h>
+
 #define DEFAULT_LOG2_THROTTLING_FOR_ERROR_EQ  4
 
 #define HW_CHANNEL_MAX_REQUEST_SIZE  0x1000
@@ -195,8 +197,12 @@ struct hw_channel_context {
 
 	u16 num_inflight_msg;
 	u32 max_req_msg_size;
+	u32 max_resp_msg_size;
+	/* Immutable reported maxima for the final RQ and SQ directions. */
+	u32 rx_msg_size_limit;
+	u32 tx_msg_size_limit;
 
-	u16 hwc_init_q_depth_max;
+	u32 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
 	u32 hwc_init_max_num_cqs;
@@ -226,6 +232,7 @@ struct hw_channel_context {
 	 * until it acknowledges DESTROY_HWC.
 	 */
 	bool setup_active;
+	bool teardown_failed;
 
 	/* mana_gd_send_request() callers, including waiters; under hwc_lock. */
 	unsigned int active_senders;
@@ -233,6 +240,13 @@ struct hw_channel_context {
 	struct hwc_caller_ctx *caller_ctx;
 };
 
+/* Host-to-PF requests are bounded by the negotiated TX limit and SQ stride. */
+static inline u32
+mana_hwc_get_max_req_size(const struct hw_channel_context *hwc)
+{
+	return min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);
+}
+
 int mana_hwc_create_channel(struct gdma_context *gc);
 void mana_hwc_destroy_channel(struct gdma_context *gc);
 void mana_hwc_free_retained_channel(struct gdma_context *gc);
