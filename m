Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67938378823;
	Tue, 13 Oct 2026 08:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878775; cv=none; b=OSwUc+2ICi2P0YCYOkGVDWKIRPgqz6XsVMQUAGeOKJ5J0fXzlnVCaw3iXYI2bfK8eY5ADtbpAJnk6Ioxz7h0qUD3rljXW4pbHA/ul9jmdRM/cIFKXt50BoVYUwKjtYlIMisvIgGre8MvWpFLGsxj4fXJu2+q5nIGTQuzPpgaCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878775; c=relaxed/simple;
	bh=pbAXSIZkKgVhH4wE60X6F4FA3h51XSTny77Y9S5Sc1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK7BptSektf4YqPxEPbws6S6G2FXxclXlQvrIe7jLy9RJNPTo9gfEZDNJCYVJlcgZTEwoaXIfZ6y7KSNagbg9iB1NA4O6JqAuVAQQ2hxTOZwoAfWoHEyNuH8FLqk20/55dODzPquiu4lnVtSIY9AmSV+lr8rIiPSB8xjAuKzJV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=SSDN+b6a; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="SSDN+b6a"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id F3D8720B7169;
	Tue, 13 Oct 2026 01:06:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F3D8720B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791878769;
	bh=J9vvytcy+SETWNcX/SNHHHUbv5Y1aPQOWiaQeBsTpmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSDN+b6aPDYR97lF3qag2/TIgteXUfqLNEip6DTZQzR8D7UU3SIonaYCdBOAGQ7q9
	 o/qj1dzR3iibnBDn68PyywmheZovSi1ywXUOC6J1QxxDnoIbP9Vw8sCsSg1Mx5Gakt
	 XbsdH4PyV9I/FSiAuQhj5+PJ5k50d6Vilv+DM8Hc=
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
Subject: [PATCH net-next v7 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Tue, 13 Oct 2026 08:05:52 +0000
Message-ID: <df59976f0f5e51ea5766451f02878bd04a4907cc.1791561995.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791561995.git.weh@linux.microsoft.com>
References: <cover.1791561995.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

The HWC starts with depth-one bootstrap queues. Treat the PF-reported depth
as a maximum and rebuild the channel exactly for reports from 2 through
128. Keep the untouched bootstrap queues for depth one and reports above
128, and require a rebuilt channel to repeat the selected depth.

Treat the reported request and response sizes as directional maxima.
Rebuild only when both reports equal the 4096-byte bootstrap allocation,
then enforce the effective report/allocation limit on every request and
expected response.

Keep each candidate channel private through queue creation, establishment
and the direct EQ test. Publish only the final tested channel. If a rebuild
fails after acknowledged teardown, destroy that candidate and establish
fresh bootstrap queues; never reuse mappings already handed to the PF.

Invalidate the previous HWC doorbell before every ESTABLISH_HWC. Accept a
new doorbell only after validating the BAR0 page geometry and reported
index, and suppress MMIO while re-establishment leaves the HWC doorbell
invalid.

Do not advertise the proposed dynamic-depth capability bit. Driver-version
advertisement occurs after HWC establishment and cannot negotiate behavior
needed while the channel is being created.

Use focused build, validation, rebuild and fallback helpers instead of the
goto-heavy creation flow from v5.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  24 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 290 +++++++++++++++---
 include/net/mana/gdma.h                       |   2 +
 include/net/mana/hw_channel.h                 |  10 +-
 4 files changed, 266 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e4a732039dbc..a73618a422bd 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -588,12 +588,26 @@ static int mana_gd_disable_queue(struct gdma_queue *queue)
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
 				  u32 tail_ptr, u8 num_req)
 {
-	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
 	union gdma_doorbell_entry e = {};
+	void __iomem *addr;
+
+	if (unlikely(db_index == INVALID_DOORBELL))
+		return;
+
+	addr = gc->db_page_base + gc->db_page_size * db_index;
 
 	switch (q_type) {
 	case GDMA_EQ:
@@ -1533,13 +1547,7 @@ int mana_gd_register_device(struct gdma_dev *gd)
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
index 9fdd84ccba65..c9f7db5a76a5 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -227,8 +227,16 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 	switch (event->type) {
 	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
 		eq_db.as_uint32 = event->details[0];
+		if (!mana_gd_is_valid_doorbell(gd->gdma_context,
+					       eq_db.doorbell)) {
+			dev_err(hwc->dev, "HWC: invalid doorbell %u\n",
+				eq_db.doorbell);
+			break;
+		}
+
 		hwc->cq->gdma_eq->id = eq_db.eq_id;
 		gd->doorbell = eq_db.doorbell;
+		hwc->hwc_init_doorbell = true;
 		break;
 
 	case GDMA_EQE_HWC_INIT_DATA:
@@ -250,7 +258,8 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_QUEUE_DEPTH:
-			hwc->hwc_init_q_depth_max = (u16)val;
+			/* Preserve the full 24-bit report for validation. */
+			hwc->hwc_init_q_depth_max = val;
 			break;
 
 		case HWC_INIT_DATA_MAX_REQUEST:
@@ -617,7 +626,8 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 
 	dma_buf->num_reqs = q_depth;
 
-	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
+	/* mana_gd_alloc_memory() requires a power-of-two length. */
+	buf_size = roundup_pow_of_two(MANA_PAGE_ALIGN(q_depth * max_msg_size));
 
 	gmi = &dma_buf->mem_info;
 	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
@@ -823,10 +833,15 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc)
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
@@ -838,6 +853,18 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	u32 cq_id;
 	int err;
 
+	hwc->hwc_init_q_depth_max = 0;
+	hwc->hwc_init_max_req_msg_size = 0;
+	hwc->hwc_init_max_resp_msg_size = 0;
+	hwc->hwc_init_max_num_cqs = 0;
+	hwc->hwc_init_cq_id = 0;
+	hwc->hwc_init_doorbell = false;
+	gc->hwc.pdid = INVALID_PDID;
+	/* Re-establish must not rearm through the previous channel's doorbell. */
+	gc->hwc.doorbell = INVALID_DOORBELL;
+	hwc->dest_vrq_id = 0;
+	hwc->dest_vrcq_id = 0;
+
 	init_completion(&hwc->hwc_init_eqe_comp);
 
 	err = mana_smc_setup_hwc(&gc->shm_channel, false,
@@ -852,9 +879,14 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
 	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
 		return -ETIMEDOUT;
 
-	*q_depth = hwc->hwc_init_q_depth_max;
-	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
-	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
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
@@ -904,6 +936,9 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 {
 	int err;
 
+	if (q_depth > U16_MAX / 2)
+		return -EINVAL;
+
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
 	if (err)
 		return err;
@@ -936,6 +971,7 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
+	hwc->max_resp_msg_size = max_resp_msg_size;
 
 	return 0;
 out:
@@ -943,6 +979,44 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	return err;
 }
 
+static void mana_hwc_clear_cq_table(struct gdma_context *gc)
+{
+	struct gdma_queue **cq_table;
+
+	cq_table = READ_ONCE(gc->cq_table);
+	WRITE_ONCE(gc->max_num_cqs, 0);
+	/* Stop new table readers before waiting for prior RCU readers. */
+	smp_store_release(&gc->cq_table, NULL);
+	synchronize_rcu();
+	vfree(cq_table);
+}
+
+/* Setup owns an unpublished HWC and has no runtime senders here. */
+static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+
+	if (hwc->cq) {
+		mana_hwc_destroy_cq(gc, hwc->cq);
+		hwc->cq = NULL;
+	}
+	mana_hwc_clear_cq_table(gc);
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
@@ -1060,17 +1134,11 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
 		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
 }
 
-static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
+static int mana_hwc_teardown_queues(struct hw_channel_context *hwc)
 {
 	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
-	struct gdma_queue **old_cq_table;
 	int err;
 
-	mana_hwc_stop_channel(hwc);
-
-	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
-	 * software dispatch, but retain every PF-visible allocation.
-	 */
 	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
 				    &hwc->setup_active);
 	if (err) {
@@ -1078,31 +1146,26 @@ static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		mana_hwc_retain_channel(hwc);
-		return false;
+		return err;
 	}
 
-	/* Fence the EQ before releasing any state its handlers can reach. */
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
-	/* Reset only after mana_hwc_destroy_cq() has cleared the CQ table
-	 * slot, so it is not left dangling.
-	 */
-	WRITE_ONCE(gc->max_num_cqs, 0);
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
@@ -1110,36 +1173,150 @@ static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
 	kfree(hwc);
 	gc->hwc.gdma_context = NULL;
 
-	old_cq_table = READ_ONCE(gc->cq_table);
-	/* Stop new table readers before waiting for existing IRQ readers. */
-	smp_store_release(&gc->cq_table, NULL);
-	synchronize_rcu();
-	vfree(old_cq_table);
-
 	return true;
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
+
+	return mana_hwc_validate_report(hwc, report, 0, false, false);
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
+		err = mana_hwc_validate_report(hwc, report, q_depth, true, true);
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
+		err = mana_hwc_rebuild_channel(hwc, rebuild_depth, &report);
+		if (err)
+			return err;
 	}
 
+	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
+	hwc->rx_msg_size_limit = report.max_req_msg_size;
+	hwc->tx_msg_size_limit = report.max_resp_msg_size;
+
 	err = mana_hwc_test_channel(hwc);
 	if (err)
 		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
@@ -1177,7 +1354,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
-	err = mana_hwc_create_bootstrap_channel(hwc);
+	err = mana_hwc_prepare_channel(hwc);
 	if (err) {
 		mana_hwc_release_channel(hwc);
 		return err;
@@ -1329,8 +1506,19 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
 	u32 command;
+	u32 req_limit;
+	u32 resp_limit;
 	int err;
 
+	req_limit = min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);
+	resp_limit = min(hwc->rx_msg_size_limit, hwc->max_req_msg_size);
+	if (req_len > req_limit || resp_len > resp_limit) {
+		dev_err(hwc->dev,
+			"HWC: message sizes req=%u/%u resp=%u/%u exceed channel maxima\n",
+			req_len, req_limit, resp_len, resp_limit);
+		return -EMSGSIZE;
+	}
+
 	err = mana_hwc_get_msg_index(hwc, resp, resp_len, &ctx);
 	if (err)
 		return err;
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 1e653b7cad72..c30a7eb6f7d3 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -594,6 +594,8 @@ void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);
 
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
+bool mana_gd_is_valid_doorbell(struct gdma_context *gc, u32 db_id);
+
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
 
 ssize_t mana_gd_read_ring(struct gdma_queue *q, char __user *buf,
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 01568d10b6fd..896effd1f716 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -11,6 +11,9 @@
 
 #define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1
 
+/* Largest supported rebuild depth; larger reports retain bootstrap queues. */
+#define HW_CHANNEL_MAX_QUEUE_DEPTH 128
+
 #define HWC_INIT_DATA_CQID		1
 #define HWC_INIT_DATA_RQID		2
 #define HWC_INIT_DATA_SQID		3
@@ -198,12 +201,17 @@ struct hw_channel_context {
 
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
 
 	struct completion hwc_init_eqe_comp;
 
-- 
2.43.0

