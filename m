Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931277;
	b=dhCZ+jzgb/mLpIBhoKk3fb5DoJifULPmTOC9uVCzSLf5x3+9b55CYkP1ZxCUmXk+Wf+A
	 0M3f0wLCTNUZoVsQ7ncSx9RK7CMRIOOJABQ37BJG+xiXBAtYa8N1MgUT00CZID9UiJzhm
	 CFeALRUmGGg06zeqtz0244ut8YnqhCfVn/ktZSNsQnVj2fCY5z1kOOktEYAEJ7Ds4GnsA
	 yg7GsAH2ukJN8R+piU3otWhGKXc2VTZACBe0Zs3/KhB2AT7dzyAhziN1Lvv5DOSQppXzQ
	 He+1DaOERboibnmgMy8noEcNEKpvilfqPYNtJHoHaZ2xKTZSfxYZLaCGaNV9QqmE9IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931277;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=J69Dw3nSW1E4WVkdB2U8NvYFRKLm7YsboFu99dWZlpg=;
	b=uCUNE+ggLKV0JYYBT47Rvj0LiO2rvc3G7RpIOHk3SNYYGMdxEawhaS47EVlR1snGTrNo
	 r0FYbgguRD8LM4T2JTsZv7F8S6Cu6MgQe1uduEoEkE2Uvx4qMMMCvHe5lnARi5aYOg9k8
	 nrkl2gfSSaZodgS1yvQmXBv5pbrRaO+TsvIF4wlk6PQhU8JoUX0JZ0/+lSL7IwgbjUt1/
	 WuB/CwQfq8og7PMkthpyOcv803KoTmsIdixa+BbCav/8IhSYluoxY2ci6O7qbkuyspS7Z
	 CDNgYfqEKqYc8THK+wE71wUlMzLzFzCxb2QADoNmPRy9PfobyRdS9AmS4VCIdY8yO4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=hUxoHFTI;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C48606A33B;
	Tue, 17 Nov 2026 16:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72C48606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=hUxoHFTI
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id D190D20B716D;
	Tue, 17 Nov 2026 08:01:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D190D20B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794931274;
	bh=J69Dw3nSW1E4WVkdB2U8NvYFRKLm7YsboFu99dWZlpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUxoHFTI7VYJ3K54vzXFY7Z4NyK7Yrup+IPuDPROFDwm+2Ou7HTgRvNbYAAdCQG1V
	 y9hzJmj5SUPQFTJ98KWlqxyuy0YkvhrDZsk7rRZ2eMXdvB6kecBP31lkippwWAzNP5
	 iLZOZm2owXh+c3B3+OotmasENsLaeleZp57WQfBQ=
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
Subject: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Tue, 17 Nov 2026 16:01:01 +0000
Message-ID: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
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

The HWC starts with depth-one bootstrap queues. Treat the PF-reported depth
as a maximum and rebuild the channel exactly for reports from 2 through
128. Keep the untouched bootstrap queues for depth one and reports above
128, and require a rebuilt channel to repeat the selected depth.

Treat the reported request and response sizes as directional maxima.
Rebuild only when both reports equal the 4096-byte bootstrap allocation.
Keep allocation strides separate from these limits, and share the effective
host-to-PF request budget with the GDMA and RDMA request builders. Bound
RDMA CREATE and ADD_PAGES batches by that budget, checking that the headers
and at least one page address fit before subtracting their sizes.

Require nonzero depth, request-size and response-size reports before
deciding whether to keep the bootstrap queues. Apply the same validation
to a restored bootstrap channel. A missing or zero required report fails
with -EPROTO, even at depth one; do not silently substitute guessed limits.

Reject oversized messages before acquiring a slot or publishing caller
storage. A retained, stopped channel still returns -ENODEV rather than
reporting a size error against uninitialized negotiated limits.

Keep each candidate private through queue creation, establishment and the
direct EQ test. Publish only the final tested channel. If a rebuild fails,
including its functional test, tear it down and restore fresh, tested
bootstrap queues. Stop if teardown is not acknowledged; never reuse
PF-owned mappings. Restore the previous live timeout budget before the
fallback so a failed test's fail-fast reduction does not poison the retry,
without reviving terminal cancellation.

Invalidate the previous HWC doorbell before every ESTABLISH_HWC. Validate
the BAR0 page geometry and reported index before accepting a new doorbell,
and suppress MMIO while it is invalid. The original driver accepted an
unchecked device-supplied index in its MMIO address calculation; this also
fixes that existing out-of-bounds MMIO path. Backports need the complete
ownership and validation dependencies, not the entire feature stack by
default. A malformed doorbell completes initialization with -EPROTO without
relying on later INIT_DONE events that might require re-arming through that
doorbell.

Use the initial PF report to select the queue geometry. The PF directs
this choice; the absence of VF size fields in ESTABLISH_HWC does not require
keeping the bootstrap geometry. Driver-version advertisement occurs after
HWC establishment and cannot negotiate behavior needed during creation.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@kernel.org
Link: https://lore.kernel.org/r/179455240227.2199510.2666165032389090040@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
Copilot-Session: 8c2361e6-c0f4-4b0c-bf01-b5e4cdacec50
---
 drivers/infiniband/hw/mana/main.c             |  19 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  26 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 316 +++++++++++++++---
 include/net/mana/gdma.h                       |   2 +
 include/net/mana/hw_channel.h                 |  19 +-
 5 files changed, 317 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 7d5a8fc7380d..6e036a25a9f7 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -427,28 +427,38 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
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
+	if (req_limit < struct_size(create_req, page_addr_list, 1) ||
+	    req_limit < struct_size(add_req, page_addr_list, 1)) {
+		ibdev_dbg(&dev->ib_dev,
+			  "HWC request budget %u is too small for DMA region commands\n",
+			  req_limit);
+		return -EMSGSIZE;
+	}
 
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
 
@@ -491,9 +501,6 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 			if (err)
 				goto out;
 
-			max_pgs_add_cmd = (hwc->max_req_msg_size -
-				sizeof(*add_req)) / sizeof(u64);
-
 			add_req = request_buf;
 			add_req->dma_region_handle = *gdma_region;
 			add_req->reserved3 = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 0160ad55a21f..6d766d84ec05 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -589,12 +589,26 @@ static int mana_gd_disable_queue(struct gdma_queue *queue)
 #define DOORBELL_OFFSET_EQ	0xFF8
 #define DOORBELL_OFFSET_DIM	0x820
 
+bool mana_gd_is_valid_doorbell(struct gdma_context *gc, u32 db_id)
+{
+	if (!gc->db_page_size || gc->db_page_off >= gc->bar0_size)
+		return false;
+
+	return gc->db_page_off +
+	       gc->db_page_size * ((u64)db_id + 1) <= gc->bar0_size;
+}
+
 static void mana_gd_ring_doorbell(struct gdma_context *gc, u32 db_index,
 				  enum gdma_queue_type q_type, u32 qid,
 				  u32 tail_ptr, u8 num_req, u8 client_offset)
 {
-	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
 	union gdma_doorbell_entry e = {};
+	void __iomem *addr;
+
+	if (unlikely(db_index == INVALID_DOORBELL))
+		return;
+
+	addr = gc->db_page_base + gc->db_page_size * db_index;
 
 	addr += client_offset;
 
@@ -1348,7 +1362,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
-	if (req_msg_size > hwc->max_req_msg_size)
+	if (req_msg_size > mana_hwc_get_max_req_size(hwc))
 		return -EINVAL;
 
 	req = kzalloc(req_msg_size, GFP_KERNEL);
@@ -1637,13 +1651,7 @@ int mana_gd_register_device(struct gdma_dev *gd)
 		return err ? err : -EPROTO;
 	}
 
-	/* Validate that doorbell page for db_id is within the BAR0 region.
-	 * In mana_gd_ring_doorbell(), the address is calculated as:
-	 *   addr = db_page_base + db_page_size * db_id
-	 *        = (bar0_va + db_page_off) + (db_page_size * db_id)
-	 * So we need: db_page_off + db_page_size * (db_id + 1) <= bar0_size
-	 */
-	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {
+	if (!mana_gd_is_valid_doorbell(gc, resp.db_id)) {
 		dev_err(gc->dev, "Doorbell ID %u out of range\n", resp.db_id);
 		return -EPROTO;
 	}
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 8c2495ce5f52..cb73d0725206 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -95,12 +95,30 @@ static int mana_hwc_try_get_msg_index(struct hw_channel_context *hwc,
 	return 0;
 }
 
-static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
-				  u32 resp_len,
+static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u32 req_len,
+				  void *resp, u32 resp_len,
 				  struct hwc_caller_ctx **caller_ctx)
 {
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long flags;
+	u32 req_limit;
+	u32 resp_limit;
 	int err;
 
+	req_limit = mana_hwc_get_max_req_size(hwc);
+	resp_limit = min(hwc->rx_msg_size_limit, hwc->max_req_msg_size);
+	if (req_len > req_limit || resp_len > resp_limit) {
+		spin_lock_irqsave(&r->lock, flags);
+		err = hwc->channel_up ? -EMSGSIZE : -ENODEV;
+		spin_unlock_irqrestore(&r->lock, flags);
+
+		if (err == -EMSGSIZE)
+			dev_err(hwc->dev,
+				"HWC: message sizes req=%u/%u resp=%u/%u exceed channel maxima\n",
+				req_len, req_limit, resp_len, resp_limit);
+		return err;
+	}
+
 	/* Healthy contention must not skip a destructive control request. */
 	wait_event(hwc->admission_waitq,
 		   (err = mana_hwc_try_get_msg_index(hwc, resp, resp_len,
@@ -246,8 +264,18 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 	switch (event->type) {
 	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
 		eq_db.as_uint32 = event->details[0];
+		if (!mana_gd_is_valid_doorbell(gd->gdma_context,
+					       eq_db.doorbell)) {
+			dev_err(hwc->dev, "HWC: invalid doorbell %u\n",
+				eq_db.doorbell);
+			WRITE_ONCE(hwc->hwc_init_error, -EPROTO);
+			complete(&hwc->hwc_init_eqe_comp);
+			break;
+		}
+
 		hwc->cq->gdma_eq->id = eq_db.eq_id;
 		gd->doorbell = eq_db.doorbell;
+		hwc->hwc_init_doorbell = true;
 		break;
 
 	case GDMA_EQE_HWC_INIT_DATA:
@@ -269,7 +297,8 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_QUEUE_DEPTH:
-			hwc->hwc_init_q_depth_max = (u16)val;
+			/* Preserve the full 24-bit report for validation. */
+			hwc->hwc_init_q_depth_max = val;
 			break;
 
 		case HWC_INIT_DATA_MAX_REQUEST:
@@ -638,7 +667,8 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 
 	dma_buf->num_reqs = q_depth;
 
-	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
+	/* mana_gd_alloc_memory() requires a power-of-two length. */
+	buf_size = roundup_pow_of_two(MANA_PAGE_ALIGN(q_depth * max_msg_size));
 
 	gmi = &dma_buf->mem_info;
 	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
@@ -844,10 +874,15 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc)
 	return err;
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
@@ -859,6 +894,19 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	u32 cq_id;
 	int err;
 
+	hwc->hwc_init_q_depth_max = 0;
+	hwc->hwc_init_max_req_msg_size = 0;
+	hwc->hwc_init_max_resp_msg_size = 0;
+	hwc->hwc_init_max_num_cqs = 0;
+	hwc->hwc_init_cq_id = 0;
+	hwc->hwc_init_doorbell = false;
+	WRITE_ONCE(hwc->hwc_init_error, 0);
+	gc->hwc.pdid = INVALID_PDID;
+	/* Do not rearm through the previous channel's doorbell. */
+	gc->hwc.doorbell = INVALID_DOORBELL;
+	hwc->dest_vrq_id = 0;
+	hwc->dest_vrcq_id = 0;
+
 	init_completion(&hwc->hwc_init_eqe_comp);
 
 	err = mana_smc_setup_hwc(&gc->shm_channel, false,
@@ -873,9 +921,18 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
 		return -ETIMEDOUT;
 
-	*q_depth = hwc->hwc_init_q_depth_max;
-	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
-	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
+	err = READ_ONCE(hwc->hwc_init_error);
+	if (err)
+		return err;
+
+	if (!hwc->hwc_init_doorbell) {
+		dev_err(hwc->dev, "HWC: missing valid doorbell in init data\n");
+		return -EPROTO;
+	}
+
+	report->queue_depth = hwc->hwc_init_q_depth_max;
+	report->max_req_msg_size = hwc->hwc_init_max_req_msg_size;
+	report->max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
 	/* Snapshot the device-reported count and id once, so the same value
 	 * sizes, bounds and indexes cq_table even across the sleeping
@@ -925,6 +982,9 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 {
 	int err;
 
+	if (q_depth > U16_MAX / 2)
+		return -EINVAL;
+
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
 	if (err)
 		return err;
@@ -957,10 +1017,11 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
 
 	return 0;
 out:
-	/* mana_hwc_create_channel() will do the cleanup.*/
+	/* The setup path tears down any partially initialized queues. */
 	return err;
 }
 
@@ -976,6 +1037,33 @@ static void mana_hwc_clear_cq_table(struct gdma_context *gc)
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
@@ -1088,16 +1176,11 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
 		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
 }
 
-static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
+static int mana_hwc_teardown_queues(struct hw_channel_context *hwc)
 {
 	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	int err;
 
-	mana_hwc_stop_channel(hwc);
-
-	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
-	 * software dispatch, but retain every PF-visible allocation.
-	 */
 	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
 				    &hwc->setup_active);
 	if (err) {
@@ -1105,28 +1188,26 @@ static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		mana_hwc_retain_channel(hwc);
-		return false;
+		return err;
 	}
 
-	mana_hwc_clear_cq_table(gc);
-
-	/* Fence the EQ before releasing the remaining HWC state. */
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
-	if (hwc->txq)
-		mana_hwc_destroy_wq(hwc, hwc->txq);
+	mana_hwc_destroy_queues(hwc);
 
-	if (hwc->rxq)
-		mana_hwc_destroy_wq(hwc, hwc->rxq);
+	return 0;
+}
 
-	kfree(hwc->caller_ctx);
-	hwc->caller_ctx = NULL;
+static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+	int err;
 
-	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	mana_hwc_stop_channel(hwc);
 
-	hwc->num_inflight_msg = 0;
+	err = mana_hwc_teardown_queues(hwc);
+	if (err) {
+		mana_hwc_retain_channel(hwc);
+		return false;
+	}
 
 	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
 	hwc->gdma_dev->pdid = INVALID_PDID;
@@ -1175,32 +1256,169 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
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
+{
+	int err;
+
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
 {
-	u32 max_req_msg_size, max_resp_msg_size;
-	u16 q_depth_max;
 	int err;
 
-	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
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
+	u32 timeout_ms = mana_hwc_timeout_read(hwc);
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
+	/* Do not carry the failed test's reduced wait into the retry. */
+	mana_hwc_timeout_update(hwc, timeout_ms);
+
+	return mana_hwc_restore_bootstrap(hwc, report);
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
+	if (report.queue_depth > HW_CHANNEL_MAX_QUEUE_DEPTH) {
+		dev_warn(hwc->dev,
+			 "HWC depth %u exceeds limit %u, keeping bootstrap\n",
+			 report.queue_depth, HW_CHANNEL_MAX_QUEUE_DEPTH);
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
@@ -1233,7 +1451,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
-	err = mana_hwc_create_bootstrap_channel(hwc);
+	err = mana_hwc_prepare_channel(hwc);
 	if (err) {
 		mana_hwc_release_channel(hwc);
 		return err;
@@ -1389,7 +1607,7 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	u32 command;
 	int err;
 
-	err = mana_hwc_get_msg_index(hwc, resp, resp_len, &ctx);
+	err = mana_hwc_get_msg_index(hwc, req_len, resp, resp_len, &ctx);
 	if (err)
 		return err;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 2e60e401b2e6..e4934c357c29 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -621,6 +621,8 @@ void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);
 
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
+bool mana_gd_is_valid_doorbell(struct gdma_context *gc, u32 db_id);
+
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
 
 ssize_t mana_gd_read_ring(struct gdma_queue *q, char __user *buf,
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 8f2ac3d37770..fd6d04e1e5cb 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -5,6 +5,7 @@
 #define _HW_CHANNEL_H
 
 #include <linux/atomic.h>
+#include <linux/minmax.h>
 
 #define DEFAULT_LOG2_THROTTLING_FOR_ERROR_EQ  4
 
@@ -13,6 +14,9 @@
 
 #define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1
 
+/* Largest supported rebuild depth; larger reports retain bootstrap queues. */
+#define HW_CHANNEL_MAX_QUEUE_DEPTH 128
+
 #define HWC_INIT_DATA_CQID		1
 #define HWC_INIT_DATA_RQID		2
 #define HWC_INIT_DATA_SQID		3
@@ -200,12 +204,18 @@ struct hw_channel_context {
 
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
 	u32 hwc_init_cq_id;
+	bool hwc_init_doorbell;
+	int hwc_init_error;
 
 	struct completion hwc_init_eqe_comp;
 
@@ -240,6 +250,13 @@ struct hw_channel_context {
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
-- 
2.43.0

