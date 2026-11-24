Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534876;
	b=um8/24xn5OG+uXDG80u7+caYPkcukDV/185ilMecztDUIKZ3P7/tu0hPiFB7FoXoUpvZ
	 zYGbXgmx5YsrnbWZvm8NEiWrCCY0mBq/KYeTsK3SO6Jbu96IGoRkWYcvCqwwUow694WuJ
	 SkqF8/4OZtRbwG+lSm2cPVLN2hQ9PMHvbsrJhOpmqrLWXNnupxUX15Cq0JSSOqej10GE8
	 wyXo8glr1FkD7uRu4TvEdWF6sTlV/BGFUvSlFAJ032Xd+VDPkJSpEceSKebwZSLwaBiet
	 nToUojy3neQPcS0CtOuuomZVL7YnDkcqOuYyBPINN9prh8/A2VdRLALxNVtJwbemF9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534876;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=mSa9yar2YruN3gYTFDdbjyXYY0+u4nrF6agPmcMWjdk=;
	b=Iudm/L7tsxEOFo94MIG/UteC/TQvIf3fr/PkMAYH1rGvCTOHFfHqz/nmSI09V86wFUzj
	 KqgEhzdyuYlGfT5m18rtaRaSx5xYRrgueh1rkvayJQuFDtOzsgQcaksIjSXdrnp1hF4ua
	 tgD02QvpCU1S3O4PXGt1pSVJTqVZyq9HP59RnvD4abLBmjESoT6lwebylXM4DOsX0t6C8
	 7V5HlKQRMRzgQn2/4hKmL+mSOFdKvKrE0qLPhhWeX4VXqCq9OHVupYmscsIqAsW50H1FC
	 s6u3b7bNsuC0xYCP6XD4BcAuSeVIfpOT2+d+PG86IVrVQmunsBRyGeXvq8UjpF9nIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=TlUL5Rr+;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA07606A68E;
	Tue, 24 Nov 2026 15:41:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FA07606A68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=TlUL5Rr+
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id C9D1A20B7172;
	Tue, 24 Nov 2026 07:41:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9D1A20B7172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534868;
	bh=mSa9yar2YruN3gYTFDdbjyXYY0+u4nrF6agPmcMWjdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlUL5Rr+8DrQfxbK89m4+fcbCThzUInYIA9JTeZuA1yprQp0z7LPzMT6Yrzsk2jRO
	 2QmDZOYjkMgCEnZE2+TBFIJ+uh04g+QkREQmE/p6GVEm9CF9PNv+ymnQTo0fZPlOFJ
	 huUgQn6B3zz6JDrAuck2qqk4IQbubft1Hf7nuf2M=
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
Subject: [PATCH net-next v12 4/5] net: mana: support concurrent HWC requests
Date: Tue, 24 Nov 2026 15:40:57 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.4@linux.microsoft.com>
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
Date: Mon, 7 Sep 2026 20:51:57 -0700

Queue competing callers and publish their SQ entries with one doorbell.
Wait for that batch's replies and senders before posting the next. No
new request can reach the PF after an unanswered command's deadline,
even if its sender hasn't run yet. Do not reuse the ID or TX buffer
until the sender has finished and the reply has arrived.

On normal response timeout the PF drains old client DMA and invalidates
outstanding commands. Check for an unanswered command's deadline under
the slot lock before accepting or consuming a reply. This lets a queued
caller detect the timeout even when the owner hasn't run. Stop posting,
wake the senders and discard their unconsumed replies.

Allow RDMA teardown of old objects to finish locally without a destroy
reply. Neither a failed post nor an external reset request establishes
DMA quiescence.

Drain senders before destroying the channel. Keep the HWC mappings
until the PF acknowledges teardown.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c             |   3 +-
 drivers/infiniband/hw/mana/mr.c               |   6 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |   2 +
 .../net/ethernet/microsoft/mana/gdma_main.c   |  97 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |  12 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 710 ++++++++++++------
 include/net/mana/gdma.h                       |  14 +
 include/net/mana/hw_channel.h                 |  43 +-
 8 files changed, 604 insertions(+), 283 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 858bbc325eb29fbb677499e251941a5909ccf29d..60a9f15e5e8c1d0c807ded7177d8da909a0626da 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -100,7 +100,8 @@ static int mana_gd_destroy_pd(struct mana_ib_dev *mdev, u64 pd_handle)
 
 	req.pd_handle = pd_handle;
 
-	return mana_gd_send_request(mdev_to_gc(mdev), sizeof(req), &req, sizeof(resp), &resp);
+	return mana_gd_send_teardown_request(mdev_to_gc(mdev), sizeof(req),
+					     &req, sizeof(resp), &resp);
 }
 
 int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
index 1233685b4b8906210a7648823265bccb6efaf578..9810aee3381e81fb63b96b73f8249d2cb629ad3b 100644
--- a/drivers/infiniband/hw/mana/mr.c
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -94,7 +94,8 @@ static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, u64 mr_handle)
 
 	req.mr_handle = mr_handle;
 
-	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	return mana_gd_send_teardown_request(gc, sizeof(req), &req,
+					     sizeof(resp), &resp);
 }
 
 struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
@@ -428,7 +429,8 @@ static int mana_ib_gd_destroy_dm(struct mana_ib_dev *mdev, struct mana_ib_dm *dm
 	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_DM, sizeof(req), sizeof(resp));
 	req.dm_handle = dm->dm_handle;
 
-	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	return mana_gd_send_teardown_request(gc, sizeof(req), &req,
+					     sizeof(resp), &resp);
 }
 
 int mana_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
index 2e0dcb902d7e263fad7341a1756441ec10d8339d..1f124cfbdefdcde94f9ea3d0e78eb1e9170d77c2 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
@@ -221,6 +221,8 @@ static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
+	init_waitqueue_head(&gc->hwc_drain_waitq);
 	dev_set_drvdata(&cdx_dev->dev, gc);
 	gc->bar0_pa = cdx_resource_start(cdx_dev, 0);
 	gc->bar0_size = cdx_resource_len(cdx_dev, 0);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 2d495db51d7463e260d32f9a52870df578ef0bee..0ada3861e259f1301bb6c243ca9c5e7d89abe25d 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -142,22 +142,21 @@ int mana_gd_init_registers(struct gdma_context *gc)
 		return mana_gd_init_vf_regs(gc);
 }
 
-/* Suppress logging when we set timeout to zero */
+/* Once admission is closed, follow-on request failures are expected. */
 bool mana_need_log(struct gdma_context *gc, int err)
 {
 	struct hw_channel_context *hwc;
+	unsigned long flags;
+	bool log;
 
-	if (err != -ETIMEDOUT)
-		return true;
-
-	if (!gc)
+	if (!gc || (err != -ETIMEDOUT && err != -ENODEV))
 		return true;
 
+	spin_lock_irqsave(&gc->hwc_lock, flags);
 	hwc = gc->hwc.driver_data;
-	if (hwc && hwc->hwc_timeout == 0)
-		return false;
-
-	return true;
+	log = hwc && READ_ONCE(hwc->state) == HWC_READY;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+	return log;
 }
 
 int mana_gd_query_max_resources(struct gdma_context *gc)
@@ -310,7 +309,8 @@ int mana_gd_query_max_resources(struct gdma_context *gc)
 	return 0;
 }
 
-static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 *timeout_val)
+static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 timeout_ms,
+				     u32 *new_timeout_ms)
 {
 	struct gdma_query_hwc_timeout_resp resp = {};
 	struct gdma_query_hwc_timeout_req req = {};
@@ -318,12 +318,12 @@ static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 *timeout_val)
 
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
@@ -375,15 +375,47 @@ int mana_gd_detect_devices(struct gdma_context *gc)
 	return gc->mana.dev_id.type == 0 ? -ENODEV : 0;
 }
 
+static int mana_gd_send(struct gdma_context *gc, u32 req_len, const void *req,
+			u32 resp_len, void *resp, bool teardown)
+{
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
+	err = mana_hwc_send_request(hwc, req_len, req, resp_len, resp,
+				    teardown);
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	if (--hwc->active_senders == 0)
+		wake_up(&gc->hwc_drain_waitq);
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	return err;
+}
+
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
-
-	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
+	return mana_gd_send(gc, req_len, req, resp_len, resp, false);
 }
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
+int mana_gd_send_teardown_request(struct gdma_context *gc, u32 req_len,
+				  const void *req, u32 resp_len, void *resp)
+{
+	return mana_gd_send(gc, req_len, req, resp_len, resp, true);
+}
+EXPORT_SYMBOL_NS(mana_gd_send_teardown_request, "NET_MANA");
+
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi, bool allow_scatter)
 {
@@ -1011,7 +1043,9 @@ static void mana_gd_deregister_irq(struct gdma_queue *queue)
 	synchronize_rcu();
 }
 
-int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+static int mana_gd_test_eq_request(struct gdma_context *gc,
+				   struct hw_channel_context *hwc,
+				   struct gdma_queue *eq)
 {
 	struct gdma_generate_test_event_req req = {};
 	struct gdma_general_resp resp = {};
@@ -1029,9 +1063,14 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	req.hdr.dev_id = eq->gdma_dev->dev_id;
 	req.queue_index = eq->id;
 
-	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (hwc)
+		err = mana_hwc_send_request(hwc, sizeof(req), &req,
+					    sizeof(resp), &resp, false);
+	else
+		err = mana_gd_send_request(gc, sizeof(req), &req,
+					   sizeof(resp), &resp);
 	if (err) {
-		if (mana_need_log(gc, err))
+		if (hwc || mana_need_log(gc, err))
 			dev_err(dev, "test_eq failed: %d\n", err);
 		goto out;
 	}
@@ -1060,6 +1099,16 @@ out:
 	return err;
 }
 
+int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+{
+	return mana_gd_test_eq_request(gc, NULL, eq);
+}
+
+int mana_gd_test_hwc_eq(struct hw_channel_context *hwc, struct gdma_queue *eq)
+{
+	return mana_gd_test_eq_request(hwc->gdma_dev->gdma_context, hwc, eq);
+}
+
 static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
 			       struct gdma_queue *queue)
 {
@@ -1295,6 +1344,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
+	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
@@ -1497,9 +1547,12 @@ int mana_gd_verify_vf_version(struct gdma_context *gc)
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
 
@@ -1537,12 +1590,16 @@ int mana_gd_verify_vf_version(struct gdma_context *gc)
 			   &gc->pf_cap_flags1);
 
 	if (resp.pf_cap_flags1 & GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG) {
-		err = mana_gd_query_hwc_timeout(gc, &hwc->hwc_timeout);
+		err = mana_gd_query_hwc_timeout(gc,
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
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index cec2e548f36ea70bd821bc085f77ac94e78b4541..5220147f153a2cede28efc6407e6254765677541 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -14,7 +14,6 @@
 #include <linux/xarray.h>
 
 #include <net/mana/mana.h>
-#include <net/mana/hw_channel.h>
 
 struct mana_dev_recovery {
 	struct list_head list;
@@ -119,7 +118,6 @@ out:
 /* Return true if recovery needs to escalate to PCI re-enumeration. */
 static bool mana_serv_reset(struct pci_dev *pdev)
 {
-	struct hw_channel_context *hwc;
 	struct gdma_context *gc;
 	int ret;
 
@@ -128,14 +126,14 @@ static bool mana_serv_reset(struct pci_dev *pdev)
 		return false;
 
 	gc = pci_get_drvdata(pdev);
-	hwc = gc->hwc.driver_data;
-	if (!hwc) {
+	if (!gc->hwc.driver_data) {
 		dev_err(&pdev->dev, "MANA service: no HWC\n");
 		goto out;
 	}
 
-	/* HWC is not responding in this case, so don't wait */
-	hwc->hwc_timeout = 0;
+	/* A service notification is not a DMA fence. Keep the normal HWC
+	 * response window for cleanup, including when all slots are in use.
+	 */
 
 	dev_info(&pdev->dev, "MANA reset cycle start\n");
 
@@ -616,6 +614,8 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
+	init_waitqueue_head(&gc->hwc_drain_waitq);
 	pci_set_drvdata(pdev, gc);
 	gc->bar0_pa = pci_resource_start(pdev, 0);
 	gc->bar0_size = pci_resource_len(pdev, 0);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index a98e58b83f9c75bf8b40183c73a9286670d4aef4..cf1b9c75b10e2f2bc3f8da06f1adc2d7af3d2b97 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,61 +6,103 @@
 #include <net/mana/hw_channel.h>
 #include <linux/vmalloc.h>
 
-static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
-{
-	struct gdma_resource *r = &hwc->inflight_msg_res;
-	struct hwc_caller_ctx *ctx;
-	unsigned long flags;
-	u32 index;
-
-	down(&hwc->sema);
-
-	spin_lock_irqsave(&r->lock, flags);
-
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
-
-	ctx = &hwc->caller_ctx[index];
-	spin_lock(&ctx->lock);
-	reinit_completion(&ctx->comp_event);
-	ctx->output_buf = NULL;
-	ctx->output_buflen = 0;
-	ctx->error = -EINPROGRESS;
-	ctx->status_code = 0;
+/* Private send outcome; don't confuse a local errno with DMA retirement. */
+enum { HWC_DMA_DRAINED = 1 };
 
-	bitmap_set(hwc->inflight_msg_res.map, index, 1);
-
-	spin_unlock(&ctx->lock);
-	spin_unlock_irqrestore(&r->lock, flags);
-
-	*msg_id = index;
+u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc)
+{
+	return READ_ONCE(hwc->hwc_timeout);
+}
 
-	return 0;
+/* Add a tick so starting near the next tick cannot shorten the PF window. */
+static unsigned long mana_hwc_window(u32 ms)
+{
+	return msecs_to_jiffies(ms) + 1;
 }
 
-static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
+static void mana_hwc_fail_pending(struct hw_channel_context *hwc, int result)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
-	unsigned long flags;
-
-	spin_lock_irqsave(&r->lock, flags);
-	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
-	spin_unlock_irqrestore(&r->lock, flags);
+	unsigned int i;
+
+	lockdep_assert_held(&r->lock);
+	for_each_set_bit(i, r->map, r->size) {
+		struct hwc_caller_ctx *ctx = &hwc->caller_ctx[i];
+
+		/* Retirement also invalidates a reply not yet consumed. An
+		 * ordinary stop has no such guarantee: keep a completed reply.
+		 */
+		if (!ctx->sender)
+			continue;
+		if (ctx->error != -EINPROGRESS && result != HWC_DMA_DRAINED)
+			continue;
+		ctx->error = result;
+		complete(&ctx->comp_event);
+	}
+}
 
-	up(&hwc->sema);
+/* Only unanswered posted requests have a running response timer. Sample it
+ * under the same lock that accepts a reply or hands it to the caller.
+ */
+static unsigned long mana_hwc_check_deadlines(struct hw_channel_context *hwc)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long remaining = MAX_SCHEDULE_TIMEOUT;
+	unsigned long now = jiffies;
+	unsigned int i;
+
+	lockdep_assert_held(&r->lock);
+	if (hwc->state != HWC_READY)
+		return remaining;
+
+	for_each_set_bit(i, r->map, r->size) {
+		struct hwc_caller_ctx *ctx = &hwc->caller_ctx[i];
+
+		if (!ctx->pending)
+			continue;
+		if (time_after_eq(now, ctx->deadline)) {
+			/* At a posted command's normal response timeout, the
+			 * PF has drained old client DMA and interrupt writes.
+			 * Unanswered commands have no effect; a late CREATE
+			 * cannot grant access. A failed post or a reset
+			 * notification alone gives no such guarantee.
+			 */
+			WRITE_ONCE(hwc->state, HWC_TIMED_OUT);
+			mana_hwc_fail_pending(hwc, HWC_DMA_DRAINED);
+			wake_up_all(&hwc->admission_waitq);
+			dev_err(hwc->dev, "HWC request %u timed out\n", i);
+			break;
+		}
+		remaining = min(remaining, ctx->deadline - now);
+	}
+	return remaining;
 }
 
-static int mana_hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
-				    const struct gdma_resp_hdr *resp_msg,
-				    u32 resp_len)
+void mana_hwc_timeout_update(struct hw_channel_context *hwc, u32 timeout_ms)
 {
-	if (resp_len < sizeof(*resp_msg))
-		return -EPROTO;
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long deadline;
+	unsigned int i;
 
-	if (resp_len > caller_ctx->output_buflen)
-		return -EPROTO;
+	/* Zero isn't a response window. Keep the last normal timeout and
+	 * never shorten the deadline of an already posted request.
+	 */
+	if (!timeout_ms)
+		return;
 
-	return 0;
+	guard(spinlock_irqsave)(&r->lock);
+	mana_hwc_check_deadlines(hwc);
+	WRITE_ONCE(hwc->hwc_timeout, timeout_ms);
+	if (hwc->state != HWC_READY)
+		return;
+
+	for_each_set_bit(i, r->map, r->size) {
+		struct hwc_caller_ctx *ctx = &hwc->caller_ctx[i];
+
+		deadline = ctx->posted_at + mana_hwc_window(timeout_ms);
+		if (ctx->pending && time_after(deadline, ctx->deadline))
+			ctx->deadline = deadline;
+	}
 }
 
 static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
@@ -86,44 +128,60 @@ static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
 	return err;
 }
 
+static int mana_hwc_refill(struct hw_channel_context *hwc,
+			   struct hwc_work_request *rx)
+{
+	int err;
+
+	lockdep_assert_held(&hwc->inflight_msg_res.lock);
+	err = mana_hwc_post_rx_wqe(hwc->rxq, rx);
+	rx->refill_needed = !!err;
+	return err;
+}
+
 static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 				 struct hwc_work_request *rx_req, u16 msg_id)
 {
-	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
+	struct gdma_resource *r = &hwc->inflight_msg_res;
 	struct hwc_caller_ctx *ctx;
-	int err;
 
-	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
-		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
-		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
-		return;
+	spin_lock(&r->lock);
+	mana_hwc_check_deadlines(hwc);
+	if (msg_id >= r->size || !test_bit(msg_id, r->map)) {
+		dev_err_ratelimited(hwc->dev, "Unexpected HWC response ID %u\n",
+				    msg_id);
+		goto repost;
 	}
 
-	ctx = hwc->caller_ctx + msg_id;
-
-	spin_lock(&ctx->lock);
-	if (!ctx->output_buf) {
-		spin_unlock(&ctx->lock);
-		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
-		return;
-	}
+	ctx = &hwc->caller_ctx[msg_id];
+	if (!ctx->pending)
+		goto repost;
 
-	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
-	if (!err) {
-		ctx->status_code = resp_msg->status;
-		memcpy(ctx->output_buf, resp_msg, resp_len);
+	ctx->pending = false;
+	if (!ctx->sender) {
+		__clear_bit(msg_id, r->map);
+		goto repost;
 	}
+	if (ctx->error != -EINPROGRESS)
+		goto repost;
 
-	ctx->output_buf = NULL;
-	ctx->error = err;
-
-	/* Must post rx wqe before complete(), otherwise the next rx may
-	 * hit no_wqe error.
+	/* Hold one RQ buffer with this occupied slot. The sender replenishes
+	 * the RQ before releasing the slot for another SQ submission.
 	 */
-	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
-
+	ctx->reply = rx_req;
+	ctx->reply_len = resp_len;
+	ctx->error = 0;
 	complete(&ctx->comp_event);
-	spin_unlock(&ctx->lock);
+	goto out;
+
+repost:
+	if (hwc->state == HWC_READY)
+		mana_hwc_refill(hwc, rx_req);
+	else
+		rx_req->refill_needed = true;
+out:
+	spin_unlock(&r->lock);
+	wake_up_all(&hwc->admission_waitq);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -227,7 +285,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			mana_hwc_timeout_update(hwc, val);
 			break;
 
 		case HWC_DATA_HW_LINK_CONNECT:
@@ -314,17 +372,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	 * modify it between reads.
 	 */
 	msg_id = READ_ONCE(resp->response.hwc_msg_id);
-	if (msg_id >= hwc->num_inflight_msg) {
-		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
-		return;
-	}
-
 	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, rx_req, msg_id);
-
-	/* Can no longer use 'resp', because the buffer is posted to the HW
-	 * in mana_hwc_handle_resp() above.
-	 */
-	resp = NULL;
 }
 
 static void mana_hwc_tx_event_handler(void *ctx, u32 gdma_txq_id,
@@ -647,10 +695,10 @@ out:
 	return err;
 }
 
-static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
-				struct hwc_work_request *req,
-				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
-				bool dest_pf)
+static int mana_hwc_stage_tx_wqe(const struct hwc_wq *hwc_txq,
+				 struct hwc_work_request *req,
+				 u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
+				 bool dest_pf)
 {
 	struct device *dev = hwc_txq->hwc->dev;
 	struct hwc_tx_oob *tx_oob;
@@ -686,7 +734,7 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
 	req->wqe_req.inline_oob_data = tx_oob;
 	req->wqe_req.client_data_unit = 0;
 
-	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	err = mana_gd_post_work_request(hwc_txq->gdma_wq, &req->wqe_req, NULL);
 	if (err)
 		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
 	return err;
@@ -697,51 +745,52 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
-	sema_init(&hwc->sema, num_msg);
-
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
 	if (err)
 		dev_err(hwc->dev, "Failed to init inflight_msg_res: %d\n", err);
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
+	for (i = 0; i < hwc->num_inflight_msg; ++i)
 		init_completion(&ctx[i].comp_event);
-		spin_lock_init(&ctx[i].lock);
-	}
 
 	hwc->caller_ctx = ctx;
 
-	return mana_gd_test_eq(gc, hwc->cq->gdma_eq);
+	/* Setup owns hwc directly; runtime publication follows this test. */
+	spin_lock_irqsave(&hwc->inflight_msg_res.lock, flags);
+	WRITE_ONCE(hwc->state, HWC_READY);
+	spin_unlock_irqrestore(&hwc->inflight_msg_res.lock, flags);
+
+	return mana_gd_test_hwc_eq(hwc, hwc->cq->gdma_eq);
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
@@ -874,68 +923,78 @@ static void mana_hwc_clear_cq_table(struct gdma_context *gc)
 	vfree(cq_table);
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
-	}
+	return drained;
+}
 
-	err = mana_hwc_test_channel(gc->hwc.driver_data,
-				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
-				    max_req_msg_size, max_resp_msg_size);
-	if (err) {
-		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
-		goto out;
+static void mana_hwc_stop_channel(struct hw_channel_context *hwc)
+{
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long flags;
+
+	if (hwc->num_inflight_msg) {
+		spin_lock_irqsave(&r->lock, flags);
+		mana_hwc_check_deadlines(hwc);
+		WRITE_ONCE(hwc->state, HWC_STOPPED);
+		mana_hwc_fail_pending(hwc, -ENODEV);
+		spin_unlock_irqrestore(&r->lock, flags);
+		wake_up_all(&hwc->admission_waitq);
 	}
 
-	return 0;
-out:
-	mana_hwc_destroy_channel(gc);
-	return err;
+	wait_event(gc->hwc_drain_waitq, mana_hwc_senders_drained(gc, hwc));
 }
 
 static void mana_hwc_fence_channel(struct gdma_context *gc,
@@ -951,13 +1010,12 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
 		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
 }
 
-void mana_hwc_destroy_channel(struct gdma_context *gc)
+static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	int err;
 
-	if (!hwc)
-		return;
+	mana_hwc_stop_channel(hwc);
 
 	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
 	 * software dispatch, but retain every PF-visible allocation.
@@ -969,7 +1027,8 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		return;
+		mana_hwc_retain_channel(hwc);
+		return false;
 	}
 
 	mana_hwc_clear_cq_table(gc);
@@ -994,11 +1053,10 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
 	hwc->gdma_dev->pdid = INVALID_PDID;
 
-	hwc->hwc_timeout = 0;
-
 	kfree(hwc);
-	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
+
+	return true;
 }
 
 static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
@@ -1016,12 +1074,12 @@ static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
  */
 void mana_hwc_free_retained_channel(struct gdma_context *gc)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct hw_channel_context *hwc = mana_hwc_unpublish_channel(gc);
 
 	if (!hwc)
 		return;
 
-	gc->hwc.driver_data = NULL;
+	mana_hwc_stop_channel(hwc);
 	mana_hwc_clear_cq_table(gc);
 
 	if (hwc->cq) {
@@ -1039,11 +1097,96 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
 	gc->hwc.gdma_context = NULL;
 }
 
-static int mana_hwc_response_status(struct hw_channel_context *hwc,
-				    u32 command, int error, u32 status)
+static int mana_hwc_create_bootstrap_channel(struct hw_channel_context *hwc)
+{
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
+	init_waitqueue_head(&hwc->admission_waitq);
+	INIT_LIST_HEAD(&hwc->submissions);
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
 {
-	if (error)
-		return error;
+	struct hw_channel_context *hwc;
+
+	hwc = mana_hwc_unpublish_channel(gc);
+	if (!hwc)
+		return;
+
+	mana_hwc_release_channel(hwc);
+}
+
+static int mana_hwc_response_result(struct hw_channel_context *hwc,
+				    u32 command, int err, u32 status)
+{
+	if (err)
+		return err;
 
 	if (!status || status == GDMA_STATUS_MORE_ENTRIES)
 		return 0;
@@ -1058,108 +1201,183 @@ static int mana_hwc_response_status(struct hw_channel_context *hwc,
 	return -EPROTO;
 }
 
-static void mana_hwc_finish_request(struct hw_channel_context *hwc,
-				    struct hwc_caller_ctx *ctx, u16 msg_id)
+/* Owned by the sender until its entry is removed under the map lock. */
+struct hwc_submission {
+	struct list_head entry;
+	const struct gdma_req_hdr *req;
+	u32 len;
+	unsigned int id;
+	int err;
+};
+
+static int mana_hwc_stage(struct hw_channel_context *hwc,
+			  struct hwc_submission *sub, unsigned int id)
 {
-	unsigned long flags;
+	struct hwc_work_request *tx = &hwc->txq->msg_buf->reqs[id];
+	struct gdma_req_hdr *hdr;
 
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = NULL;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	if (sub->len > tx->buf_len)
+		return -EMSGSIZE;
 
-	mana_hwc_put_msg_index(hwc, msg_id);
+	hdr = memcpy(tx->buf_va, sub->req, sub->len);
+	hdr->req.hwc_msg_id = id;
+	tx->msg_size = sub->len;
+	return mana_hwc_stage_tx_wqe(hwc->txq, tx, hwc->dest_vrq_id,
+				     hwc->dest_vrcq_id, false);
 }
 
-int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
-			  const void *req, u32 resp_len, void *resp)
+static void mana_hwc_post_batch(struct hw_channel_context *hwc)
 {
-	struct hwc_work_request *tx_wr;
-	struct hwc_wq *txq = hwc->txq;
-	struct gdma_req_hdr *req_msg;
-	struct hwc_caller_ctx *ctx;
-	unsigned long flags;
-	u32 dest_vrcq;
-	u32 dest_vrq;
-	u32 command;
-	u32 status;
-	u16 msg_id;
-	int err;
-
-	err = mana_hwc_get_msg_index(hwc, &msg_id);
-	if (err)
-		return err;
-
-	tx_wr = &txq->msg_buf->reqs[msg_id];
-	ctx = hwc->caller_ctx + msg_id;
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned int avail = r->size, count = 0, i;
+	unsigned long posted_at, deadline;
+	struct hwc_submission *sub;
+	int rx_err = 0;
+
+	lockdep_assert_held(&r->lock);
+	/* All replies from the previous batch have been taken. Retry any RQ
+	 * refill that failed before allowing another command to use it.
+	 */
+	for (i = 0; i < r->size; i++) {
+		struct hwc_work_request *rx = &hwc->rxq->msg_buf->reqs[i];
+		int err;
+
+		if (!rx->refill_needed)
+			continue;
+		err = mana_hwc_refill(hwc, rx);
+		if (err) {
+			avail--;
+			rx_err = err;
+		}
+	}
 
-	if (req_len > tx_wr->buf_len) {
-		dev_err(hwc->dev, "HWC: req msg size: %d > %d\n", req_len,
-			tx_wr->buf_len);
-		mana_hwc_finish_request(hwc, ctx, msg_id);
-		return -EINVAL;
+	for (i = 0; i < r->size && !list_empty(&hwc->submissions); i++) {
+		sub = list_first_entry(&hwc->submissions, struct hwc_submission,
+				       entry);
+		sub->err = avail ? mana_hwc_stage(hwc, sub, count) : rx_err;
+		if (!sub->err)
+			sub->id = count++;
+		list_del_init(&sub->entry);
+		if (count && count == avail)
+			break;
+	}
+	if (count) {
+		/* One tail write publishes the whole batch. No other SQ tail
+		 * can be written until this batch's slots are all released.
+		 */
+		mana_gd_wq_ring_doorbell(hwc->gdma_dev->gdma_context,
+					 hwc->txq->gdma_wq);
+		posted_at = jiffies;
+		deadline = posted_at + mana_hwc_window(hwc->hwc_timeout);
+		for (i = 0; i < count; i++) {
+			struct hwc_caller_ctx *ctx = &hwc->caller_ctx[i];
+
+			ctx->posted_at = posted_at;
+			ctx->deadline = deadline;
+			reinit_completion(&ctx->comp_event);
+			ctx->error = -EINPROGRESS;
+			ctx->sender = true;
+			ctx->pending = true;
+			__set_bit(i, r->map);
+		}
 	}
+	wake_up_all(&hwc->admission_waitq);
+}
 
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = resp;
-	ctx->output_buflen = resp_len;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+/* Return zero on transfer, otherwise wait for an owner or a posted deadline. */
+static long mana_hwc_admit(struct hw_channel_context *hwc,
+			   struct hwc_submission *sub)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long remaining;
 
-	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
-	if (req)
-		memcpy(req_msg, req, req_len);
+	guard(spinlock_irqsave)(&r->lock);
+	if (!list_empty(&sub->entry) && hwc->state == HWC_READY &&
+	    bitmap_empty(r->map, r->size))
+		mana_hwc_post_batch(hwc);
+	if (list_empty(&sub->entry))
+		return 0;
 
-	req_msg->req.hwc_msg_id = msg_id;
+	remaining = mana_hwc_check_deadlines(hwc);
+	if (hwc->state == HWC_READY)
+		return remaining;
 
-	tx_wr->msg_size = req_len;
-	command = req_msg->req.msg_type;
+	sub->err = hwc->state == HWC_TIMED_OUT ? HWC_DMA_DRAINED : -ENODEV;
+	list_del_init(&sub->entry);
+	return 0;
+}
 
-	/* The hardware reports the HWC destination queues through
-	 * HWC_INIT_DATA_DEST_RQ_ID and HWC_INIT_DATA_DEST_CQ_ID, and
-	 * always supplies values that are valid for this function, so no
-	 * PF-specific handling is needed here.
-	 */
-	dest_vrq = hwc->dest_vrq_id;
-	dest_vrcq = hwc->dest_vrcq_id;
+static int mana_hwc_wait_for_response(struct hw_channel_context *hwc,
+				      unsigned int id, u32 command,
+				      u32 resp_len, struct gdma_resp_hdr *resp)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	struct hwc_caller_ctx *ctx = &hwc->caller_ctx[id];
+	unsigned long flags, remaining;
+	u32 status = 0;
+	int err;
 
-	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
-	if (err) {
-		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
-		mana_hwc_finish_request(hwc, ctx, msg_id);
-		return err;
+	spin_lock_irqsave(&r->lock, flags);
+	for (;;) {
+		remaining = mana_hwc_check_deadlines(hwc);
+		if (ctx->error != -EINPROGRESS)
+			break;
+		spin_unlock_irqrestore(&r->lock, flags);
+		wait_for_completion_timeout(&ctx->comp_event, remaining);
+		spin_lock_irqsave(&r->lock, flags);
 	}
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
-			mana_hwc_finish_request(hwc, ctx, msg_id);
-			return mana_hwc_response_status(hwc, command, err,
-							status);
+	err = ctx->error;
+	if (!err) {
+		if (ctx->reply_len < sizeof(*resp) ||
+		    ctx->reply_len > resp_len ||
+		    ctx->reply_len > ctx->reply->buf_len) {
+			err = -EPROTO;
+		} else {
+			memcpy(resp, ctx->reply->buf_va, ctx->reply_len);
+			status = resp->status;
 		}
+	}
+	if (ctx->reply && hwc->state == HWC_READY)
+		mana_hwc_refill(hwc, ctx->reply);
+	ctx->reply = NULL;
+	ctx->sender = false;
+	if (!ctx->pending)
+		__clear_bit(id, r->map);
+	spin_unlock_irqrestore(&r->lock, flags);
+	wake_up_all(&hwc->admission_waitq);
+	return mana_hwc_response_result(hwc, command, err, status);
+}
 
-		if (hwc->hwc_timeout != 0)
-			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
+int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
+			  const void *req, u32 resp_len, void *resp,
+			  bool teardown)
+{
+	const struct gdma_req_hdr *hdr = req;
+	struct hwc_submission sub = { .req = req, .len = req_len };
+	DEFINE_WAIT(wait);
+	long remaining;
+	int err;
 
-		/* Reduce further waiting if HWC no response */
-		if (hwc->hwc_timeout > 1)
-			hwc->hwc_timeout = 1;
+	if (!hdr || req_len < sizeof(*hdr) || !resp)
+		return -EINVAL;
 
-		mana_hwc_finish_request(hwc, ctx, msg_id);
-		return -ETIMEDOUT;
+	scoped_guard(spinlock_irqsave, &hwc->inflight_msg_res.lock)
+		list_add_tail(&sub.entry, &hwc->submissions);
+	for (;;) {
+		prepare_to_wait(&hwc->admission_waitq, &wait,
+				TASK_UNINTERRUPTIBLE);
+		remaining = mana_hwc_admit(hwc, &sub);
+		if (!remaining)
+			break;
+		schedule_timeout(remaining);
 	}
-
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = NULL;
-	err = ctx->error;
-	status = ctx->status_code;
-	spin_unlock_irqrestore(&ctx->lock, flags);
-
-	mana_hwc_finish_request(hwc, ctx, msg_id);
-	return mana_hwc_response_status(hwc, command, err, status);
+	finish_wait(&hwc->admission_waitq, &wait);
+	err = sub.err;
+	if (!err)
+		err = mana_hwc_wait_for_response(hwc, sub.id, hdr->req.msg_type,
+						 resp_len, resp);
+
+	if (err == HWC_DMA_DRAINED)
+		return teardown ? 0 : -ETIMEDOUT;
+	return err;
 }
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 2da086a3b8f721d51827553d78261240c8d69a6f..7c07b286bd948894dcb95138700842dffcb23129 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -548,6 +548,12 @@ struct gdma_context {
 	/* Hardware communication channel (HWC) */
 	struct gdma_dev		hwc;
 
+	/* Sender drain; the final wakeup runs under hwc_lock. */
+	wait_queue_head_t	hwc_drain_waitq;
+
+	/* Protects HWC publication and active sender references. */
+	spinlock_t		hwc_lock;
+
 	/* Azure network adapter */
 	struct gdma_dev		mana;
 
@@ -1197,6 +1203,14 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
 
+/* For software teardown of an object whose lifetime excludes HWC replacement.
+ * A posted response timeout retires that generation. Return zero for local
+ * cleanup in that case, without filling resp or implying a PF response.
+ * Callers needing response fields must use mana_gd_send_request().
+ */
+int mana_gd_send_teardown_request(struct gdma_context *gc, u32 req_len,
+				  const void *req, u32 resp_len, void *resp);
+
 int mana_gd_destroy_dma_region(struct gdma_context *gc, u64 dma_region_handle);
 void mana_register_debugfs(void);
 void mana_unregister_debugfs(void);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index bcaf276976a81dca825ee08804a3b2fa5ee24a9a..c154264f0f7c30efb989243ce2d9282aefbc61a8 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -114,6 +114,7 @@ struct hwc_work_request {
 	void *buf_sge_addr;
 	u32 buf_len;
 	u32 msg_size;
+	bool refill_needed;
 
 	struct gdma_wqe_request wqe_req;
 	struct hwc_tx_oob tx_oob;
@@ -168,13 +169,24 @@ struct hwc_wq {
 
 struct hwc_caller_ctx {
 	struct completion comp_event;
-	/* Protects initialization, output storage and response state. */
-	spinlock_t lock;
-	void *output_buf;
-	u32 output_buflen;
+	/* Completed RQ buffer, not yet consumed by the sender. */
+	struct hwc_work_request *reply;
+	u32 reply_len;
+	int error;
 
-	int error; /* Linux error code */
-	u32 status_code;
+	/* The ID and TX buffer belong to the sender until it has taken its
+	 * result, and to the device until the corresponding response arrives.
+	 */
+	bool sender;
+	bool pending;
+	unsigned long posted_at;
+	unsigned long deadline;
+};
+
+enum hwc_channel_state {
+	HWC_STOPPED,
+	HWC_READY,
+	HWC_TIMED_OUT,
 };
 
 struct hw_channel_context {
@@ -197,8 +209,13 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
-	struct semaphore sema;
+	wait_queue_head_t admission_waitq;
+	struct list_head submissions;
+	/* The map lock serializes slot ownership, SQ publication, response
+	 * delivery, timeout changes and the transition to a faulted channel.
+	 */
 	struct gdma_resource inflight_msg_res;
+	enum hwc_channel_state state;
 
 	u32 dest_vrq_id;
 	u32 dest_vrcq_id;
@@ -209,6 +226,10 @@ struct hw_channel_context {
 	 * until it acknowledges DESTROY_HWC.
 	 */
 	bool setup_active;
+
+	/* mana_gd_send_request() callers, including waiters; under hwc_lock. */
+	unsigned int active_senders;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
@@ -217,6 +238,12 @@ void mana_hwc_destroy_channel(struct gdma_context *gc);
 void mana_hwc_free_retained_channel(struct gdma_context *gc);
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
-			  const void *req, u32 resp_len, void *resp);
+			  const void *req, u32 resp_len, void *resp,
+			  bool teardown);
+int mana_gd_test_hwc_eq(struct hw_channel_context *hwc,
+			struct gdma_queue *eq);
+
+u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc);
+void mana_hwc_timeout_update(struct hw_channel_context *hwc, u32 timeout_ms);
 
 #endif /* _HW_CHANNEL_H */
