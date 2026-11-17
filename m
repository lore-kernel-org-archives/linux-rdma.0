Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931275;
	b=SmgyVG05rV86DEoVC6OFr8dwRxKeCt8cG1b5cV7nxt3eYhqjde1MQTzyT2MdRNZEKHSc
	 HHwjB13abRePkCe6cimDkl9ZchMJLUaze3GZF52pl3Hh+4X3zqIkMPbq8zma/tY73v+vQ
	 9tYFYNZ1wez8blZNA18i1WrH3+TntbKRmsGYWH+K9ypGJJ60tpXPcwb6Hgeazl0TwDsUj
	 VeZslP7WGpGoc/E1Kj+Ph+J1WpLDX4BJz9gwWC4KNIIRdIwMxWDRTIisWJLibvSnzCsDG
	 FB9LnAgo/hZKdqm2rZNnCe+SsOwr/0y+j2a0/SjSvMATyvRFql6N0OUlP7VV2lrVj4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931275;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=XpIsCIJQySdiTJeQ6zop1xxnVN7jI7xTsM6XhoA0Yu0=;
	b=Oqcdw01YBevYHdtjcVDuDhjOpBq3/Cty6nfXGzwhL0YFIpyHmTR5uKvhSfudNe2yrXZI
	 LneKYeHOdos9ClZsiCaTOT76D2OwMz6Qn4yw1VKmvxCIAMr4xVRG2X8Qnl52bCmT/k4VT
	 Tbg/IOrE05HuXFP35KsP+VPqkWVVcjh/k1vYlkywpy5JzTtUonypC76RVUof2s5c37EXU
	 TysmbE5k7s8aV97L/vNpqwfQJbU3zJET3w48TPEuWZiG22N091hWpFt4sWTTtn0FmLkuY
	 N8cf6lZVUFBWb+PecVScfu1KyGUSjZcEOLxe2pAsFHHopnnJA6Yw6ggiYu1OaJU/WOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gcKZqWFG;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C17C606A337;
	Tue, 17 Nov 2026 16:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C17C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gcKZqWFG
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7130620B716F;
	Tue, 17 Nov 2026 08:01:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7130620B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794931271;
	bh=XpIsCIJQySdiTJeQ6zop1xxnVN7jI7xTsM6XhoA0Yu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcKZqWFGiTvfGnTgyPQVtnJ/gCoTnK0i85tKPuLt7fA7dKnMeX2GgAOCdaAlQ8AXb
	 QYYRR1p3vVh/JVnFfjoe0SUj0C5g3cqN9kWfZITC7zJ9bVCcJUXptwOorhUrZ2mEem
	 MWOv7CTR1KxQmhSrlBnQNZyLDePMJ7sO7GjNC2TM=
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
Subject: [PATCH net-next v11 3/4] net: mana: support concurrent HWC requests
Date: Tue, 17 Nov 2026 16:01:00 +0000
Message-ID: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
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

Give HWC message slots separate sender and response ownership. Initialize
each slot under the inflight resource and per-slot locks, publish its
bitmap bit last, and release the slot only after both references are
released. The per-slot lock also excludes an older duplicate callback from
resetting or consuming the next caller's state.

Serialize SQ posting so concurrent senders cannot corrupt the producer
state. A posted request which times out keeps its response reference, ID
and TX buffer until its late response arrives or teardown cancels it. This
also fixes the original wrong-command response bug: releasing an ID at
timeout could deliver its late response to the next command using that ID.
The preceding per-slot state fix and this quarantine are both needed for a
dependency-complete backport. The bootstrap channel remains depth one
here; the next patch selects and allocates larger queues.

Wait for a free slot while any non-abandoned occupied slot can still make
progress. Partial abandonment alone does not end this wait. Wake waiters
on slot release, abandonment, cancellation and channel stop. Return
-ENOTCONN when the full pool is quarantined or cancelled with no free
slot, distinguishing local rejection from an admitted command's bounded
response timeout. A stopped channel returns -ENODEV. Retire each abandoned
response count with its response reference exactly once.

Local rejection must not make existing destructive callers free DMA that
the device still owns. Propagate it through queue disable, DMA-region and
WQ-object destruction. Withdraw software CQ/IRQ callbacks, but retain the
affected Ethernet queue memory and RX pages when their destroy was
rejected. Keep an EQ's MSI-X reference if its disable was not delivered.
Handle the same ownership transfer in failed EQ construction.

For RDMA, leave live verbs objects and their dependencies intact on local
rejection. Retain queue mappings on failed creation unwinds, including
regions already transferred to a QP/CQ handle and partial multi-command
DMA-region creation. Do not unpin their memory merely because a cleanup
request could not acquire an HWC slot. This may deliberately retain
resources on a failed cleanup; it is not proof of device quiescence.

Keep available slots usable for best-effort commands after cancellation.
Preserve the baseline cleanup policy for commands that were actually
posted and then timed out or received PF errors; this patch does not
repair that independent data-DMA failure policy. Keep timeout recovery and
expected logging consistent with the new local-rejection result.

Synchronize hwc_timeout updates with atomic access helpers. Cancellation
is terminal for a channel instance; firmware and query updates may replace
only a live timeout, and fail-fast may only lower a live value to one
millisecond.

Keep setup private until queues, admission state, caller contexts and the
direct EQ test are ready. Preserve the private test's specific failure
diagnostic without publishing the HWC early. Runtime teardown unpublishes
the channel, rejects new admissions, wakes waiters and drains active
senders before releasing or retaining PF-owned mappings. Initialize the
per-context drain waitqueue once in PCI/CDX probe, beside hwc_lock, not on
every channel creation. Apply the same unpublication and sender-drain
rules to final disposal of retained software state.

Split admission, submission, waiting, response status and unwind into
helpers so mana_hwc_send_request() uses structured returns.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@kernel.org
Link: https://lore.kernel.org/r/179455240021.2199510.18244084352437360589@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
Copilot-Session: 8c2361e6-c0f4-4b0c-bf01-b5e4cdacec50
---
 drivers/infiniband/hw/mana/cq.c               |  17 +-
 drivers/infiniband/hw/mana/main.c             |  72 ++-
 drivers/infiniband/hw/mana/mana_ib.h          |   5 +-
 drivers/infiniband/hw/mana/mr.c               |  28 +-
 drivers/infiniband/hw/mana/qp.c               | 106 +++-
 drivers/infiniband/hw/mana/wq.c               |   4 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |   2 +
 .../net/ethernet/microsoft/mana/gdma_main.c   | 150 ++++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |  16 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 599 +++++++++++++-----
 drivers/net/ethernet/microsoft/mana/mana_en.c |  49 +-
 include/net/mana/gdma.h                       |  20 +-
 include/net/mana/hw_channel.h                 |  46 +-
 include/net/mana/mana.h                       |   4 +-
 14 files changed, 827 insertions(+), 291 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 843e2c64b32b..95b7c250494b 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -149,7 +149,8 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 err_remove_cq_cb:
 	mana_ib_remove_cq_cb(mdev, cq);
 err_destroy_rnic_cq:
-	mana_ib_gd_destroy_cq(mdev, cq);
+	if (mana_gd_is_request_rejected(mana_ib_gd_destroy_cq(mdev, cq)))
+		WRITE_ONCE(cq->queue.retain_dma, true);
 err_destroy_queue:
 	mana_ib_destroy_queue(mdev, &cq->queue);
 
@@ -169,16 +170,14 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 
-	mana_ib_remove_cq_cb(mdev, cq);
-
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
-	mana_ib_gd_destroy_cq(mdev, cq);
+	err = mana_ib_gd_destroy_cq(mdev, cq);
+	if (mana_gd_is_request_rejected(err) ||
+	    READ_ONCE(cq->queue.retain_dma))
+		return err ? err : -ENOTCONN;
 
-	mana_ib_destroy_queue(mdev, &cq->queue);
+	mana_ib_remove_cq_cb(mdev, cq);
 
-	return 0;
+	return mana_ib_destroy_queue(mdev, &cq->queue);
 }
 
 static void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq)
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 858bbc325eb2..7d5a8fc7380d 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -282,6 +282,7 @@ int mana_ib_create_kernel_queue(struct mana_ib_dev *mdev, u32 size, enum gdma_qu
 
 	queue->id = INVALID_QUEUE_ID;
 	queue->gdma_region = GDMA_INVALID_DMA_REGION;
+	queue->retain_dma = false;
 	spec.type = type;
 	spec.monitor_avl_buf = false;
 	spec.queue_size = size;
@@ -303,6 +304,7 @@ int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
 	queue->umem = NULL;
 	queue->id = INVALID_QUEUE_ID;
 	queue->gdma_region = GDMA_INVALID_DMA_REGION;
+	queue->retain_dma = false;
 
 	if (is_cq)
 		umem = ib_umem_get_cq_buf_or_va(&mdev->ib_dev, NULL, addr,
@@ -326,19 +328,30 @@ int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
 
 	return 0;
 free_umem:
+	if (mana_gd_is_request_rejected(err) &&
+	    queue->gdma_region != GDMA_INVALID_DMA_REGION) {
+		queue->umem = umem;
+		queue->retain_dma = true;
+		return err;
+	}
 	ib_umem_release(umem);
 	return err;
 }
 
-void mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue)
+int mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue)
 {
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
-	mana_ib_gd_destroy_dma_region(mdev, queue->gdma_region);
+	int err;
+
+	if (READ_ONCE(queue->retain_dma))
+		return -ENOTCONN;
+
+	err = mana_ib_gd_destroy_dma_region(mdev, queue->gdma_region);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 	ib_umem_release(queue->umem);
 	if (queue->kmem)
-		mana_gd_destroy_queue(mdev_to_gc(mdev), queue->kmem);
+		return mana_gd_destroy_queue(mdev_to_gc(mdev), queue->kmem);
+	return 0;
 }
 
 static int
@@ -503,8 +516,15 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 			      max_pgs_add_cmd);
 	}
 
-	if (err)
-		mana_ib_gd_destroy_dma_region(dev, *gdma_region);
+	if (err) {
+		int destroy_err;
+
+		destroy_err = mana_ib_gd_destroy_dma_region(dev, *gdma_region);
+		if (mana_gd_is_request_rejected(destroy_err))
+			err = destroy_err;
+		else
+			*gdma_region = GDMA_INVALID_DMA_REGION;
+	}
 
 out:
 	kfree(request_buf);
@@ -824,6 +844,7 @@ int mana_ib_create_eqs(struct mana_ib_dev *mdev)
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct gdma_queue_spec spec = {};
 	struct gdma_irq_context *gic;
+	int destroy_err;
 	int err, i, msi;
 
 	spec.type = GDMA_EQ;
@@ -841,7 +862,8 @@ int mana_ib_create_eqs(struct mana_ib_dev *mdev)
 
 	err = mana_gd_create_mana_eq(mdev->gdma_dev, &spec, &mdev->fatal_err_eq);
 	if (err) {
-		mana_gd_put_gic(gc, false, 0);
+		if (!mana_gd_is_request_rejected(err))
+			mana_gd_put_gic(gc, false, 0);
 		return err;
 	}
 	mdev->fatal_err_eq->eq.irq = gic->irq;
@@ -865,7 +887,8 @@ int mana_ib_create_eqs(struct mana_ib_dev *mdev)
 
 		err = mana_gd_create_mana_eq(mdev->gdma_dev, &spec, &mdev->eqs[i]);
 		if (err) {
-			mana_gd_put_gic(gc, false, msi);
+			if (!mana_gd_is_request_rejected(err))
+				mana_gd_put_gic(gc, false, msi);
 			goto destroy_eqs;
 		}
 		mdev->eqs[i]->eq.irq = gic->irq;
@@ -875,28 +898,33 @@ int mana_ib_create_eqs(struct mana_ib_dev *mdev)
 
 destroy_eqs:
 	while (i-- > 0) {
-		mana_gd_destroy_queue(gc, mdev->eqs[i]);
-		mana_gd_put_gic(gc, false, (i + 1) % gc->num_msix_usable);
+		msi = (i + 1) % gc->num_msix_usable;
+		destroy_err = mana_gd_destroy_queue(gc, mdev->eqs[i]);
+		if (!mana_gd_is_request_rejected(destroy_err))
+			mana_gd_put_gic(gc, false, msi);
 	}
 	kfree(mdev->eqs);
 destroy_fatal_eq:
-	mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
-	mana_gd_put_gic(gc, false, 0);
+	destroy_err = mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
+	if (!mana_gd_is_request_rejected(destroy_err))
+		mana_gd_put_gic(gc, false, 0);
 	return err;
 }
 
 void mana_ib_destroy_eqs(struct mana_ib_dev *mdev)
 {
 	struct gdma_context *gc = mdev_to_gc(mdev);
-	int i, msi;
+	int err, i, msi;
 
-	mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
-	mana_gd_put_gic(gc, false, 0);
+	err = mana_gd_destroy_queue(gc, mdev->fatal_err_eq);
+	if (!mana_gd_is_request_rejected(err))
+		mana_gd_put_gic(gc, false, 0);
 
 	for (i = 0; i < mdev->ib_dev.num_comp_vectors; i++) {
-		mana_gd_destroy_queue(gc, mdev->eqs[i]);
 		msi = (i + 1) % gc->num_msix_usable;
-		mana_gd_put_gic(gc, false, msi);
+		err = mana_gd_destroy_queue(gc, mdev->eqs[i]);
+		if (!mana_gd_is_request_rejected(err))
+			mana_gd_put_gic(gc, false, msi);
 	}
 
 	kfree(mdev->eqs);
@@ -1037,6 +1065,7 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct mana_rnic_destroy_cq_resp resp = {};
 	struct mana_rnic_destroy_cq_req req = {};
+	int err;
 
 	if (cq->cq_handle == INVALID_MANA_HANDLE)
 		return 0;
@@ -1046,7 +1075,10 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	req.adapter = mdev->adapter_handle;
 	req.cq_handle = cq->cq_handle;
 
-	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (!err && !resp.hdr.status)
+		WRITE_ONCE(cq->queue.retain_dma, false);
+	return err;
 }
 
 int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 9173ca64d2e1..de7869ba556c 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -76,6 +76,8 @@ struct mana_ib_queue {
 	struct gdma_queue *kmem;
 	u64 gdma_region;
 	u64 id;
+	/* A locally rejected parent destroy left this mapping PF-owned. */
+	bool retain_dma;
 };
 
 struct mana_ib_dev {
@@ -823,7 +825,8 @@ int mana_ib_create_kernel_queue(struct mana_ib_dev *mdev, u32 size, enum gdma_qu
 				struct mana_ib_queue *queue);
 int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
 			 struct mana_ib_queue *queue, bool is_cq);
-void mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue);
+int mana_ib_destroy_queue(struct mana_ib_dev *mdev,
+			  struct mana_ib_queue *queue);
 
 struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
 				struct ib_wq_init_attr *init_attr,
diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
index 1233685b4b89..7b95f9f1db53 100644
--- a/drivers/infiniband/hw/mana/mr.c
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -107,8 +107,8 @@ struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	struct ib_device *ibdev = ibpd->device;
 	struct mana_ib_dev *dev;
 	struct mana_ib_mr *mr;
-	u64 dma_region_handle;
-	int err;
+	u64 dma_region_handle = GDMA_INVALID_DMA_REGION;
+	int err, destroy_err;
 
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -178,10 +178,16 @@ struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	return &mr->ibmr;
 
 err_dma_region:
-	mana_gd_destroy_dma_region(mdev_to_gc(dev), dma_region_handle);
+	destroy_err = mana_gd_destroy_dma_region(mdev_to_gc(dev),
+						 dma_region_handle);
+	if (mana_gd_is_request_rejected(destroy_err))
+		goto err_free;
+	dma_region_handle = GDMA_INVALID_DMA_REGION;
 
 err_umem:
-	ib_umem_release(mr->umem);
+	if (!mana_gd_is_request_rejected(err) ||
+	    dma_region_handle == GDMA_INVALID_DMA_REGION)
+		ib_umem_release(mr->umem);
 
 err_free:
 	kfree(mr);
@@ -199,8 +205,8 @@ struct ib_mr *mana_ib_reg_user_mr_dmabuf(struct ib_pd *ibpd, u64 start, u64 leng
 	struct ib_umem_dmabuf *umem_dmabuf;
 	struct mana_ib_dev *dev;
 	struct mana_ib_mr *mr;
-	u64 dma_region_handle;
-	int err;
+	u64 dma_region_handle = GDMA_INVALID_DMA_REGION;
+	int err, destroy_err;
 
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -252,10 +258,16 @@ struct ib_mr *mana_ib_reg_user_mr_dmabuf(struct ib_pd *ibpd, u64 start, u64 leng
 	return &mr->ibmr;
 
 err_dma_region:
-	mana_gd_destroy_dma_region(mdev_to_gc(dev), dma_region_handle);
+	destroy_err = mana_gd_destroy_dma_region(mdev_to_gc(dev),
+						 dma_region_handle);
+	if (mana_gd_is_request_rejected(destroy_err))
+		goto err_free;
+	dma_region_handle = GDMA_INVALID_DMA_REGION;
 
 err_umem:
-	ib_umem_release(mr->umem);
+	if (!mana_gd_is_request_rejected(err) ||
+	    dma_region_handle == GDMA_INVALID_DMA_REGION)
+		ib_umem_release(mr->umem);
 
 err_free:
 	kfree(mr);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 15c5d6cefd62..5e4eed814d61 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -5,6 +5,53 @@
 
 #include "mana_ib.h"
 
+static void mana_ib_retain_cq(struct ib_cq *ibcq)
+{
+	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
+
+	WRITE_ONCE(cq->queue.retain_dma, true);
+}
+
+static void mana_ib_destroy_wq_obj(struct mana_port_context *mpc, u32 type,
+				   mana_handle_t handle,
+				   struct mana_ib_queue *queue,
+				   struct ib_cq *cq)
+{
+	int err;
+
+	err = mana_destroy_wq_obj(mpc, type, handle);
+	if (mana_gd_is_request_rejected(err)) {
+		queue->retain_dma = true;
+		mana_ib_retain_cq(cq);
+	}
+}
+
+static void mana_ib_retain_qp(struct mana_ib_qp *qp)
+{
+	struct mana_ib_queue *queues;
+	int i, count;
+
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		queues = qp->rc_qp.queues;
+		count = MANA_RC_QUEUE_TYPE_MAX;
+		break;
+	case IB_QPT_UC:
+		queues = qp->uc_qp.queues;
+		count = MANA_UC_QUEUE_TYPE_MAX;
+		break;
+	default:
+		queues = qp->ud_qp.queues;
+		count = MANA_UD_QUEUE_TYPE_MAX;
+		break;
+	}
+
+	for (i = 0; i < count; i++)
+		queues[i].retain_dma = true;
+	mana_ib_retain_cq(qp->ibqp.send_cq);
+	mana_ib_retain_cq(qp->ibqp.recv_cq);
+}
+
 static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 				      struct net_device *ndev,
 				      mana_handle_t default_rxobj,
@@ -229,7 +276,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		/* Create CQ table entry */
 		ret = mana_ib_install_cq_cb(mdev, cq);
 		if (ret) {
-			mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+			mana_ib_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object,
+					       &wq->queue, ibcq);
 			goto free_vport;
 		}
 	}
@@ -261,7 +309,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 
 		mana_ib_remove_cq_cb(mdev, cq);
-		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+		mana_ib_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object,
+				       &wq->queue, ibcq);
 	}
 
 	mutex_lock(&mana_pd->vport_mutex);
@@ -405,7 +454,8 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	mana_ib_remove_cq_cb(mdev, send_cq);
 
 err_destroy_wq_obj:
-	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->qp_handle);
+	mana_ib_destroy_wq_obj(mpc, GDMA_SQ, qp->qp_handle,
+			       &qp->raw_sq, qp->ibqp.send_cq);
 
 err_destroy_queue:
 	mana_ib_destroy_queue(mdev, &qp->raw_sq);
@@ -634,7 +684,8 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	return 0;
 
 destroy_qp:
-	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(mana_ib_gd_destroy_rnic_qp(mdev, qp)))
+		mana_ib_retain_qp(qp);
 destroy_queues:
 	while (i-- > 0)
 		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
@@ -688,7 +739,8 @@ static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 		goto destroy_qp;
 	return 0;
 destroy_qp:
-	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(mana_ib_gd_destroy_rnic_qp(mdev, qp)))
+		mana_ib_retain_qp(qp);
 destroy_queues:
 	while (i-- > 0)
 		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
@@ -770,7 +822,8 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	return 0;
 
 destroy_qp:
-	mana_ib_gd_destroy_ud_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(mana_ib_gd_destroy_ud_qp(mdev, qp)))
+		mana_ib_retain_qp(qp);
 destroy_shadow_queues:
 	destroy_shadow_queue(&qp->shadow_rq);
 	destroy_shadow_queue(&qp->shadow_sq);
@@ -981,7 +1034,13 @@ static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
 		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
 		ibdev_dbg(&mdev->ib_dev, "destroying wq->rx_object %llu\n",
 			  wq->rx_object);
-		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+		if (wq->rx_object == INVALID_MANA_HANDLE)
+			continue;
+		err = mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+		if (mana_gd_is_request_rejected(err))
+			return err;
+		if (!err)
+			wq->rx_object = INVALID_MANA_HANDLE;
 	}
 
 	mutex_lock(&pd->vport_mutex);
@@ -1011,9 +1070,13 @@ static int mana_ib_destroy_qp_raw(struct mana_ib_qp *qp, struct ib_udata *udata)
 	mpc = netdev_priv(ndev);
 	pd = container_of(ibpd, struct mana_ib_pd, ibpd);
 
-	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->qp_handle);
+	err = mana_destroy_wq_obj(mpc, GDMA_SQ, qp->qp_handle);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 
-	mana_ib_destroy_queue(mdev, &qp->raw_sq);
+	err = mana_ib_destroy_queue(mdev, &qp->raw_sq);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 
 	mana_ib_uncfg_vport(mdev, pd, qp->port);
 
@@ -1030,12 +1093,11 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 	if (err)
 		return err;
 
-	mana_table_remove_qp(mdev, qp);
+	err = mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
-	mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	mana_table_remove_qp(mdev, qp);
 	for (i = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i)
 		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
 
@@ -1052,11 +1114,11 @@ static int mana_ib_destroy_uc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = mana_ib_gd_destroy_rnic_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(err))
+		return err;
+
 	mana_table_remove_qp(mdev, qp);
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
-	mana_ib_gd_destroy_rnic_qp(mdev, qp);
 	for (i = 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
 		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
 
@@ -1073,16 +1135,16 @@ static int mana_ib_destroy_ud_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = mana_ib_gd_destroy_ud_qp(mdev, qp);
+	if (mana_gd_is_request_rejected(err))
+		return err;
+
 	mana_table_remove_qp(mdev, qp);
 	mana_remove_qp_from_cqs(qp, false);
 
 	destroy_shadow_queue(&qp->shadow_rq);
 	destroy_shadow_queue(&qp->shadow_sq);
 
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
-	mana_ib_gd_destroy_ud_qp(mdev, qp);
 	for (i = 0; i < MANA_UD_QUEUE_TYPE_MAX; ++i)
 		mana_ib_destroy_queue(mdev, &qp->ud_qp.queues[i]);
 
diff --git a/drivers/infiniband/hw/mana/wq.c b/drivers/infiniband/hw/mana/wq.c
index 4042f26632c0..9884fb808b73 100644
--- a/drivers/infiniband/hw/mana/wq.c
+++ b/drivers/infiniband/hw/mana/wq.c
@@ -64,7 +64,9 @@ int mana_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
 
 	mdev = container_of(ib_dev, struct mana_ib_dev, ib_dev);
 
-	mana_ib_destroy_queue(mdev, &wq->queue);
+	err = mana_ib_destroy_queue(mdev, &wq->queue);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 
 	kfree(wq);
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
index 2e0dcb902d7e..1f124cfbdefd 100644
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
index fc460d83fb80..0160ad55a21f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -142,22 +142,26 @@ int mana_gd_init_registers(struct gdma_context *gc)
 		return mana_gd_init_vf_regs(gc);
 }
 
-/* Suppress logging when we set timeout to zero */
+/* Cancellation and unpublication make teardown request failures expected. */
 bool mana_need_log(struct gdma_context *gc, int err)
 {
 	struct hw_channel_context *hwc;
+	bool need_log = true;
+	unsigned long flags;
 
-	if (err != -ETIMEDOUT)
+	if (err != -ETIMEDOUT && err != -ENOTCONN && err != -ENODEV)
 		return true;
 
 	if (!gc)
 		return true;
 
+	spin_lock_irqsave(&gc->hwc_lock, flags);
 	hwc = gc->hwc.driver_data;
-	if (hwc && hwc->hwc_timeout == 0)
-		return false;
+	if (!hwc || !mana_hwc_timeout_read(hwc))
+		need_log = false;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
 
-	return true;
+	return need_log;
 }
 
 int mana_gd_query_max_resources(struct gdma_context *gc)
@@ -310,7 +314,8 @@ int mana_gd_query_max_resources(struct gdma_context *gc)
 	return 0;
 }
 
-static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 *timeout_val)
+static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 timeout_ms,
+				     u32 *new_timeout_ms)
 {
 	struct gdma_query_hwc_timeout_resp resp = {};
 	struct gdma_query_hwc_timeout_req req = {};
@@ -318,12 +323,12 @@ static int mana_gd_query_hwc_timeout(struct gdma_context *gc, u32 *timeout_val)
 
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
@@ -378,12 +383,48 @@ int mana_gd_detect_devices(struct gdma_context *gc)
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp)
 {
-	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct hw_channel_context *hwc;
+	unsigned long flags;
+	int err;
 
-	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
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
+
+	return err;
 }
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
+int mana_gd_cancel_hwc_timeout(struct gdma_context *gc)
+{
+	struct hw_channel_context *hwc;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&gc->hwc_lock, flags);
+	hwc = gc->hwc.driver_data;
+	if (hwc)
+		mana_hwc_timeout_cancel(hwc);
+	else
+		err = -ENODEV;
+	spin_unlock_irqrestore(&gc->hwc_lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_NS(mana_gd_cancel_hwc_timeout, "NET_MANA");
+
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi, bool allow_scatter)
 {
@@ -996,7 +1037,9 @@ static void mana_gd_deregister_irq(struct gdma_queue *queue)
 	synchronize_rcu();
 }
 
-int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+static int mana_gd_test_eq_request(struct gdma_context *gc,
+				   struct hw_channel_context *hwc,
+				   struct gdma_queue *eq)
 {
 	struct gdma_generate_test_event_req req = {};
 	struct gdma_general_resp resp = {};
@@ -1014,9 +1057,14 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
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
-		if (mana_need_log(gc, err))
+		if (hwc || mana_need_log(gc, err))
 			dev_err(dev, "test_eq failed: %d\n", err);
 		goto out;
 	}
@@ -1045,25 +1093,41 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	return err;
 }
 
-static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
-			       struct gdma_queue *queue)
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
+static int mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
+			      struct gdma_queue *queue)
 {
 	int err;
 
-	if (queue->eq.msix_index == INVALID_PCI_MSIX_INDEX)
-		return;
+	if (queue->eq.msix_index != INVALID_PCI_MSIX_INDEX) {
+		if (flush_events) {
+			err = mana_gd_test_eq(gc, queue);
+			if (err && mana_need_log(gc, err))
+				dev_warn(gc->dev, "Failed to flush EQ: %d\n",
+					 err);
+		}
 
-	if (flush_events) {
-		err = mana_gd_test_eq(gc, queue);
-		if (err && mana_need_log(gc, err))
-			dev_warn(gc->dev, "Failed to flush EQ: %d\n", err);
+		mana_gd_deregister_irq(queue);
+		queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
 	}
 
-	mana_gd_deregister_irq(queue);
-	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
+	if (!queue->eq.disable_needed)
+		return 0;
 
-	if (queue->eq.disable_needed)
-		mana_gd_disable_queue(queue);
+	err = mana_gd_disable_queue(queue);
+	if (!err)
+		queue->eq.disable_needed = false;
+	return err;
 }
 
 void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue)
@@ -1117,7 +1181,8 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
 	return 0;
 out:
 	dev_err(dev, "Failed to create EQ: %d\n", err);
-	mana_gd_destroy_eq(gc, false, queue);
+	if (mana_gd_is_request_rejected(mana_gd_destroy_eq(gc, false, queue)))
+		err = -ENOTCONN;
 	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
 	return err;
 }
@@ -1254,7 +1319,7 @@ int mana_gd_destroy_dma_region(struct gdma_context *gc, u64 dma_region_handle)
 		if (mana_need_log(gc, err))
 			dev_err(gc->dev, "Failed to destroy DMA region: %d, 0x%x\n",
 				err, resp.hdr.status);
-		return -EPROTO;
+		return mana_gd_is_request_rejected(err) ? err : -EPROTO;
 	}
 
 	return 0;
@@ -1280,6 +1345,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
+	/* The caller must keep the HWC alive throughout queue creation. */
 	hwc = gc->hwc.driver_data;
 	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
@@ -1385,7 +1451,10 @@ int mana_gd_create_mana_eq(struct gdma_dev *gd,
 out:
 	dev_err(gc->dev, "Failed to create queue type %d of size: %u, err: %d\n",
 		spec->type, spec->queue_size, err);
-	mana_gd_free_memory(gmi);
+	if (!mana_gd_is_request_rejected(err) ||
+	    (gmi->dma_region_handle == GDMA_INVALID_DMA_REGION &&
+	     !queue->eq.disable_needed))
+		mana_gd_free_memory(gmi);
 free_q:
 	kfree(queue);
 	return err;
@@ -1446,13 +1515,16 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 }
 EXPORT_SYMBOL_NS(mana_gd_create_mana_wq_cq, "NET_MANA");
 
-void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
+int mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 {
 	struct gdma_mem_info *gmi = &queue->mem_info;
+	int err;
 
 	switch (queue->type) {
 	case GDMA_EQ:
-		mana_gd_destroy_eq(gc, queue->eq.disable_needed, queue);
+		err = mana_gd_destroy_eq(gc, queue->eq.disable_needed, queue);
+		if (mana_gd_is_request_rejected(err))
+			return err;
 		break;
 
 	case GDMA_CQ:
@@ -1468,12 +1540,15 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 	default:
 		dev_err(gc->dev, "Can't destroy unknown queue: type=%d\n",
 			queue->type);
-		return;
+		return -EINVAL;
 	}
 
-	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
+	err = mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
+	if (mana_gd_is_request_rejected(err))
+		return err;
 	mana_gd_free_memory(gmi);
 	kfree(queue);
+	return 0;
 }
 EXPORT_SYMBOL_NS(mana_gd_destroy_queue, "NET_MANA");
 
@@ -1482,9 +1557,12 @@ int mana_gd_verify_vf_version(struct gdma_context *gc)
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
 
@@ -1522,12 +1600,16 @@ int mana_gd_verify_vf_version(struct gdma_context *gc)
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
index e59c0666db3b..15d376beb8b4 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -14,7 +14,6 @@
 #include <linux/xarray.h>
 
 #include <net/mana/mana.h>
-#include <net/mana/hw_channel.h>
 
 struct mana_dev_recovery {
 	struct list_head list;
@@ -85,7 +84,6 @@ static void mana_serv_fpga(struct pci_dev *pdev)
 static void mana_serv_reset(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
-	struct hw_channel_context *hwc;
 	int ret;
 
 	if (!gc) {
@@ -95,15 +93,13 @@ static void mana_serv_reset(struct pci_dev *pdev)
 		return;
 	}
 
-	hwc = gc->hwc.driver_data;
-	if (!hwc) {
+	/* HWC is not responding in this case, so don't wait */
+	ret = mana_gd_cancel_hwc_timeout(gc);
+	if (ret) {
 		dev_err(&pdev->dev, "MANA service: no HWC\n");
 		goto out;
 	}
 
-	/* HWC is not responding in this case, so don't wait */
-	hwc->hwc_timeout = 0;
-
 	dev_info(&pdev->dev, "MANA reset cycle start\n");
 
 	mana_gd_suspend(pdev, PMSG_SUSPEND);
@@ -111,7 +107,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 	msleep(MANA_SERVICE_PERIOD * 1000);
 
 	ret = mana_gd_resume(pdev);
-	if (ret == -ETIMEDOUT || ret == -EPROTO) {
+	if (ret == -ETIMEDOUT || ret == -ENOTCONN || ret == -EPROTO) {
 		/* Perform PCI rescan on device if we failed on HWC */
 		dev_err(&pdev->dev, "MANA service: resume failed, rescanning\n");
 		mana_serv_rescan(pdev);
@@ -582,6 +578,8 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	mutex_init(&gc->gic_mutex);
+	spin_lock_init(&gc->hwc_lock);
+	init_waitqueue_head(&gc->hwc_drain_waitq);
 	pci_set_drvdata(pdev, gc);
 	gc->bar0_pa = pci_resource_start(pdev, 0);
 	gc->bar0_size = pci_resource_len(pdev, 0);
@@ -647,7 +645,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * perform the device recovery procedure after MANA_SERVICE_PERIOD
 	 * seconds.
 	 */
-	if (err == -ETIMEDOUT || err == -EPROTO) {
+	if (err == -ETIMEDOUT || err == -ENOTCONN || err == -EPROTO) {
 		struct mana_dev_recovery *dev;
 		unsigned long flags;
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 6f0ccdeffc4f..8c2495ce5f52 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -6,48 +6,140 @@
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
+	       cmpxchg(&hwc->hwc_timeout, old_timeout,
+		       timeout_ms) != old_timeout)
+		old_timeout = mana_hwc_timeout_read(hwc);
+}
+
+void mana_hwc_timeout_cancel(struct hw_channel_context *hwc)
+{
+	xchg(&hwc->hwc_timeout, 0);
+	wake_up_all(&hwc->admission_waitq);
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
+static int mana_hwc_try_get_msg_index(struct hw_channel_context *hwc,
+				      void *resp, u32 resp_len,
+				      struct hwc_caller_ctx **caller_ctx)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	struct hwc_caller_ctx *ctx;
 	unsigned long flags;
 	u32 index;
-
-	down(&hwc->sema);
+	int err;
 
 	spin_lock_irqsave(&r->lock, flags);
+	if (!hwc->channel_up) {
+		spin_unlock_irqrestore(&r->lock, flags);
+		return -ENODEV;
+	}
 
-	index = find_first_zero_bit(hwc->inflight_msg_res.map,
-				    hwc->inflight_msg_res.size);
+	index = find_first_zero_bit(r->map, r->size);
+	if (index >= r->size) {
+		err = -EBUSY;
+		if (!mana_hwc_timeout_read(hwc) ||
+		    (u32)atomic_read(&hwc->abandoned_msgs) == r->size)
+			err = -ENOTCONN;
+		spin_unlock_irqrestore(&r->lock, flags);
+		return err;
+	}
 
 	ctx = &hwc->caller_ctx[index];
 	spin_lock(&ctx->lock);
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
 
 	spin_unlock(&ctx->lock);
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	*msg_id = index;
+	*caller_ctx = ctx;
 
 	return 0;
 }
 
+static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
+				  u32 resp_len,
+				  struct hwc_caller_ctx **caller_ctx)
+{
+	int err;
+
+	/* Healthy contention must not skip a destructive control request. */
+	wait_event(hwc->admission_waitq,
+		   (err = mana_hwc_try_get_msg_index(hwc, resp, resp_len,
+						    caller_ctx)) != -EBUSY);
+	return err;
+}
+
 static void mana_hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_id)
 {
 	struct gdma_resource *r = &hwc->inflight_msg_res;
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
-	bitmap_clear(hwc->inflight_msg_res.map, msg_id, 1);
+	bitmap_clear(r->map, msg_id, 1);
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	up(&hwc->sema);
+	wake_up(&hwc->admission_waitq);
+}
+
+static void hwc_ctx_put(struct hw_channel_context *hwc,
+			struct hwc_caller_ctx *ctx)
+{
+	if (refcount_dec_and_test(&ctx->refcnt))
+		mana_hwc_put_msg_index(hwc, ctx->msg_id);
+}
+
+static bool mana_hwc_clear_resp_pending(struct hw_channel_context *hwc,
+					struct hwc_caller_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->lock);
+
+	if (!ctx->resp_pending)
+		return false;
+
+	ctx->resp_pending = false;
+	if (ctx->error == -ETIMEDOUT)
+		atomic_dec(&hwc->abandoned_msgs);
+
+	return true;
 }
 
 static int mana_hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
@@ -90,40 +182,53 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
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
+	release = mana_hwc_clear_resp_pending(hwc, ctx);
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
@@ -214,7 +319,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			mana_hwc_timeout_update(hwc, val);
 			break;
 
 		case HWC_DATA_HW_LINK_CONNECT:
@@ -617,6 +722,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	hwc_wq->gdma_wq = queue;
 	hwc_wq->queue_depth = q_depth;
 	hwc_wq->hwc_cq = hwc_cq;
+	spin_lock_init(&hwc_wq->lock);
 
 	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
 				     &hwc_wq->msg_buf);
@@ -634,7 +740,7 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	return err;
 }
 
-static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
+static int mana_hwc_post_tx_wqe(struct hwc_wq *hwc_txq,
 				struct hwc_work_request *req,
 				u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
 				bool dest_pf)
@@ -673,7 +779,10 @@ static int mana_hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
 	req->wqe_req.inline_oob_data = tx_oob;
 	req->wqe_req.client_data_unit = 0;
 
+	spin_lock(&hwc_txq->lock);
 	err = mana_gd_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	spin_unlock(&hwc_txq->lock);
+
 	if (err)
 		dev_err(dev, "Failed to post WQE on HWC SQ: %d\n", err);
 	return err;
@@ -684,7 +793,7 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
 {
 	int err;
 
-	sema_init(&hwc->sema, num_msg);
+	atomic_set(&hwc->abandoned_msgs, 0);
 
 	err = mana_gd_alloc_res_map(num_msg, &hwc->inflight_msg_res);
 	if (err)
@@ -692,43 +801,55 @@ static int mana_hwc_init_inflight_msg(struct hw_channel_context *hwc,
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
@@ -855,68 +976,103 @@ static void mana_hwc_clear_cq_table(struct gdma_context *gc)
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
+		drop_resp_ref = mana_hwc_clear_resp_pending(hwc, ctx);
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
@@ -932,13 +1088,12 @@ static void mana_hwc_fence_channel(struct gdma_context *gc,
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
@@ -950,7 +1105,8 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 			"HWC teardown failed: %d, retaining PF-visible resources\n",
 			err);
 		mana_hwc_fence_channel(gc, hwc);
-		return;
+		mana_hwc_retain_channel(hwc);
+		return false;
 	}
 
 	mana_hwc_clear_cq_table(gc);
@@ -975,11 +1131,10 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
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
@@ -997,12 +1152,12 @@ static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
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
@@ -1020,11 +1175,145 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
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
+	drop_resp_ref = mana_hwc_clear_resp_pending(hwc, ctx);
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
 {
-	if (error)
-		return error;
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
+			drop_resp_ref = mana_hwc_clear_resp_pending(hwc, ctx);
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
@@ -1039,108 +1328,90 @@ static int mana_hwc_response_status(struct hw_channel_context *hwc,
 	return -EPROTO;
 }
 
-static void mana_hwc_finish_request(struct hw_channel_context *hwc,
-				    struct hwc_caller_ctx *ctx, u16 msg_id)
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
+		ctx->error = -ETIMEDOUT;
+		ctx->responded = true;
+		atomic_inc(&hwc->abandoned_msgs);
+		abandoned = true;
+	}
 	spin_unlock_irqrestore(&ctx->lock, flags);
 
-	mana_hwc_put_msg_index(hwc, msg_id);
+	if (!abandoned) {
+		hwc_ctx_put(hwc, ctx);
+		return mana_hwc_response_result(hwc, command, err, status);
+	}
+
+	wake_up_all(&hwc->admission_waitq);
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
-		mana_hwc_finish_request(hwc, ctx, msg_id);
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
-		mana_hwc_finish_request(hwc, ctx, msg_id);
-		return err;
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
-			mana_hwc_finish_request(hwc, ctx, msg_id);
-			return mana_hwc_response_status(hwc, command, err,
-							status);
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
-		mana_hwc_finish_request(hwc, ctx, msg_id);
-		return -ETIMEDOUT;
-	}
-
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->output_buf = NULL;
-	err = ctx->error;
-	status = ctx->status_code;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	err = mana_hwc_submit_request(hwc, ctx, tx_wr);
+	if (err)
+		return err == -ENODEV ? err : -ENOTCONN;
 
-	mana_hwc_finish_request(hwc, ctx, msg_id);
-	return mana_hwc_response_status(hwc, command, err, status);
+	return mana_hwc_wait_for_response(hwc, ctx, command);
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 744e6ceb7d2b..1af0ed35c598 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1741,8 +1741,8 @@ int mana_create_wq_obj(struct mana_port_context *apc,
 }
 EXPORT_SYMBOL_NS(mana_create_wq_obj, "NET_MANA");
 
-void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
-			 mana_handle_t wq_obj)
+int mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
+			mana_handle_t wq_obj)
 {
 	struct mana_destroy_wqobj_resp resp = {};
 	struct mana_destroy_wqobj_req req = {};
@@ -1760,7 +1760,7 @@ void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 		if (mana_en_need_log(apc, err))
 			netdev_err(ndev, "Failed to destroy WQ object: %d\n", err);
 
-		return;
+		return err;
 	}
 
 	err = mana_verify_resp_hdr(&resp.hdr, MANA_DESTROY_WQ_OBJ,
@@ -1768,6 +1768,8 @@ void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 	if (err || resp.hdr.status)
 		netdev_err(ndev, "Failed to destroy WQ object: %d, 0x%x\n", err,
 			   resp.hdr.status);
+
+	return err ? err : (resp.hdr.status ? -EPROTO : 0);
 }
 EXPORT_SYMBOL_NS(mana_destroy_wq_obj, "NET_MANA");
 
@@ -1791,8 +1793,8 @@ void mana_destroy_eq(struct mana_port_context *apc)
 			continue;
 
 		msi = eq->eq.msix_index;
-		mana_gd_destroy_queue(gc, eq);
-		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		if (!mana_gd_is_request_rejected(mana_gd_destroy_queue(gc, eq)))
+			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
 	}
 
 	kfree(apc->eqs);
@@ -1852,7 +1854,8 @@ int mana_create_eq(struct mana_port_context *apc)
 		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
 		if (err) {
 			dev_err(gc->dev, "Failed to create EQ %d : %d\n", i, err);
-			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+			if (!mana_gd_is_request_rejected(err))
+				mana_gd_put_gic(gc, !gc->msi_sharing, msi);
 			goto out;
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
@@ -2704,7 +2707,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 {
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
 	struct napi_struct *napi;
-	int i;
+	int i, err;
 
 	if (!apc->tx_qp)
 		return;
@@ -2730,21 +2733,29 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 		 */
 		netdev_tx_reset_queue(apc->tx_qp[i]->txq.net_txq);
 
+		err = 0;
 		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE)
-			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);
+			err = mana_destroy_wq_obj(apc, GDMA_SQ,
+						  apc->tx_qp[i]->tx_object);
 
 		if (apc->tx_qp[i]->txq.napi_initialized) {
-			/* Detach the CQ only after the WQ object is destroyed,
-			 * so a completion EQE that arrives before then still
-			 * finds the CQ in cq_table[] rather than being dropped
-			 * by mana_gd_process_eqe(). One grace period then
-			 * covers both mana_gd_intr() and NAPI users.
+			/* Keep the CQ published until the WQ destroy attempt
+			 * finishes, then detach before freeing or retaining its
+			 * memory. One grace period covers both mana_gd_intr()
+			 * and NAPI users.
 			 */
 			mana_gd_detach_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
 			netif_napi_del_locked(napi);
 			apc->tx_qp[i]->txq.napi_initialized = false;
 		}
 
+		if (mana_gd_is_request_rejected(err)) {
+			if (apc->tx_qp[i]->tx_cq.gdma_cq)
+				mana_gd_detach_cq(gc,
+						  apc->tx_qp[i]->tx_cq.gdma_cq);
+			continue;
+		}
+
 		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
 
 		mana_deinit_txq(apc, &apc->tx_qp[i]->txq);
@@ -2936,7 +2947,7 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	struct device *dev = gc->dev;
 	struct napi_struct *napi;
 	struct page *page;
-	int i;
+	int i, err = 0;
 
 	if (!rxq)
 		return;
@@ -2960,7 +2971,7 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		xdp_rxq_info_unreg(&rxq->xdp_rxq_shared);
 
 	if (rxq->rxobj != INVALID_MANA_HANDLE)
-		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
+		err = mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	if (napi_initialized) {
 		/* See the comment in mana_destroy_txq() */
@@ -2968,6 +2979,12 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		netif_napi_del_locked(napi);
 	}
 
+	if (mana_gd_is_request_rejected(err)) {
+		if (rxq->rx_cq.gdma_cq)
+			mana_gd_detach_cq(gc, rxq->rx_cq.gdma_cq);
+		return;
+	}
+
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
 	if (rxq->xdp_save_va)
@@ -4149,7 +4166,7 @@ static void mana_gf_stats_work_handler(struct work_struct *work)
 	int err;
 
 	err = mana_query_gf_stats(ac);
-	if (err == -ETIMEDOUT) {
+	if (err == -ETIMEDOUT || err == -ENOTCONN) {
 		/* HWC timeout detected - reset stats and stop rescheduling */
 		ac->hwc_timeout_occurred = true;
 		memset(&ac->hc_stats, 0, sizeof(ac->hc_stats));
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 8375a208a248..2e60e401b2e6 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -5,6 +5,7 @@
 #define _GDMA_H
 
 #include <linux/dma-mapping.h>
+#include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <rdma/ib_verbs.h>
 
@@ -548,6 +549,15 @@ struct gdma_context {
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
 
@@ -598,7 +608,13 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 			      const struct gdma_queue_spec *spec,
 			      struct gdma_queue **queue_ptr);
 
-void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
+int mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
+
+/* Local HWC rejection does not revoke the device's DMA ownership. */
+static inline bool mana_gd_is_request_rejected(int err)
+{
+	return err == -ENOTCONN || err == -ENODEV || err == -EMSGSIZE;
+}
 
 /* Remove an EQ from interrupt dispatch without freeing its queue memory. */
 void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);
@@ -1196,6 +1212,8 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
 
+int mana_gd_cancel_hwc_timeout(struct gdma_context *gc);
+
 int mana_gd_destroy_dma_region(struct gdma_context *gc, u64 dma_region_handle);
 void mana_register_debugfs(void);
 void mana_unregister_debugfs(void);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index c7570a5f7376..8f2ac3d37770 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -4,6 +4,8 @@
 #ifndef _HW_CHANNEL_H
 #define _HW_CHANNEL_H
 
+#include <linux/atomic.h>
+
 #define DEFAULT_LOG2_THROTTLING_FOR_ERROR_EQ  4
 
 #define HW_CHANNEL_MAX_REQUEST_SIZE  0x1000
@@ -164,17 +166,32 @@ struct hwc_wq {
 	u16 queue_depth;
 
 	struct hwc_cq *hwc_cq;
+
+	/* Serializes SQ posting; unused for the RQ. */
+	spinlock_t lock;
 };
 
 struct hwc_caller_ctx {
 	struct completion comp_event;
-	/* Protects initialization, output storage and response state. */
+
+	/* Initialize under inflight_msg_res.lock and lock, before publication.
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
@@ -196,15 +213,30 @@ struct hw_channel_context {
 	struct hwc_wq *txq;
 	struct hwc_cq *cq;
 
-	struct semaphore sema;
+	/* Wait for a slot, a response timeout, cancellation or channel stop. */
+	wait_queue_head_t admission_waitq;
 	struct gdma_resource inflight_msg_res;
+	/* Response references still outstanding after a sender timed out. */
+	atomic_t abandoned_msgs;
 
 	u32 dest_vrq_id;
 	u32 dest_vrcq_id;
+
+	/* Zero permanently cancels waits for this channel instance. Firmware
+	 * and query updates may replace a live nonzero value; fail-fast may
+	 * only reduce a live value to one millisecond.
+	 */
 	u32 hwc_timeout;
 
+	/* Checked during admission; cleared on teardown to reject sends. */
+	bool channel_up;
+
 	/* The PF may own the HWC queues while this is true. */
 	bool setup_active;
+
+	/* mana_gd_send_request() callers, including waiters; under hwc_lock. */
+	unsigned int active_senders;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
@@ -214,5 +246,11 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc);
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp);
+int mana_gd_test_hwc_eq(struct hw_channel_context *hwc,
+			struct gdma_queue *eq);
+
+u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc);
+void mana_hwc_timeout_update(struct hw_channel_context *hwc, u32 timeout_ms);
+void mana_hwc_timeout_cancel(struct hw_channel_context *hwc);
 
 #endif /* _HW_CHANNEL_H */
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 218d540bc994..31daaa341515 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -1162,8 +1162,8 @@ int mana_create_wq_obj(struct mana_port_context *apc,
 		       struct mana_obj_spec *cq_spec,
 		       mana_handle_t *wq_obj);
 
-void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
-			 mana_handle_t wq_obj);
+int mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
+			mana_handle_t wq_obj);
 
 int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 		   u32 doorbell_pg_id, bool check_channel_changing);
-- 
2.43.0

