Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD523B42C7;
	Tue, 13 Oct 2026 08:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878767; cv=none; b=hI+lCO/j0At4PdxVdLve0Buq1NFl6vxLu2S249olvYM0ZyQmiQtQvj9PnlAxRKPfSljhYN2FzDKk//qZtUIBS9ERDFfdoiO2Lad4Xdyv9ErvT7G18tvt/seHw8zohAXtZXyDlaOOMb6GlI0Y1J2AvVj0Mpm2YYqQwo3ypMeeCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878767; c=relaxed/simple;
	bh=RRsP58P3144lVb31LewLeGxe5PCUBfo3K/BH9zeaCmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBEmK0Px9wmkxXhh1LQIOnqnLHBZSktT/qq8te3yJP8FDZq8ZFk2FQiEKhk3NT/OibtG7xu6ep0oJKticOY9NtsHFrRH/rVQktn8zM0UtaMhoCTj8NvaQq5qze71XuEwHrRgUwun4t4yU1HgLOxZqjzXEob5t2Zi4//LMWruRtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fLAYsdc1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fLAYsdc1"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id E846920B7169;
	Tue, 13 Oct 2026 01:05:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E846920B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791878760;
	bh=YmzqdVoTwO6ASXbkRP3cfYglruc6TgFt+gfGQCuumxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLAYsdc1/TCtiYxVTRVVG7fEqdxIfPI8BFlwWfRG9OMN0rLg98cU/e+30ifubs45f
	 iUzEiylHdcnHfi0F7d3T6dAxhVSXt3FnkoiOhZr6136/yw7cxI1mOUkrNHm3W4hyrl
	 vRzbV8b32zx6Xv2Bq+v/0vU7Xama8NSeyCAYtmNc=
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
Subject: [PATCH net-next v7 1/4] net: mana: prepare HWC ownership for safe reinitialization
Date: Tue, 13 Oct 2026 08:05:49 +0000
Message-ID: <e6ef84d7481de34f259d2b244f7994e3f1d9ab6f.1791561995.git.weh@linux.microsoft.com>
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

Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
second channel before publishing it. Prepare the existing HWC ownership and
teardown paths so that sequence cannot free or reuse state still reachable
by either the PF or an EQ handler.

The shared-memory aperture carries one request at a time. Serialize the
complete ESTABLISH_HWC and DESTROY_HWC transactions, including possession
polling and response validation. Record setup_active immediately before the
MMIO submission and clear it only after DESTROY_HWC is acknowledged.

Treat an unacknowledged destroy as retained PF ownership. Fence the HWC EQ
and withdraw its CQ from dispatch, but keep all queue memory and wrappers
for a later teardown retry. A new channel creation retries that retained
context before assigning fresh queues to the PF.

Snapshot the bootstrap CQ count and CQ ID after INIT_DONE. Publish the
fixed bound with the allocated table so later init events cannot grow the
bound past the allocation. The EQ handler acquires the table pointer but
does not take a per-event CQ reference; HWC teardown instead fences the
dedicated EQ and waits for the existing IRQ-side RCU readers before freeing
the table.

On acknowledged teardown, destroy the HWC EQ before the CQ and completion
buffer, then release the TX and RX queues. This ordering makes both the
normal reinitialization path and every failure unwind safe.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  25 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 150 +++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |  58 ++++++-
 include/net/mana/gdma.h                       |   3 +
 include/net/mana/hw_channel.h                 |   4 +
 include/net/mana/shm_channel.h                |  10 +-
 6 files changed, 217 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ae0ed700b3b9..69da65a405a4 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -754,6 +754,7 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	union gdma_eqe_info eqe_info;
 	enum gdma_eqe_type type;
 	struct gdma_event event;
+	struct gdma_queue **cq_table;
 	struct gdma_queue *cq;
 	struct gdma_eqe *eqe;
 	u32 cq_id;
@@ -765,11 +766,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	switch (type) {
 	case GDMA_EQE_COMPLETION:
 		cq_id = eqe->details[0] & 0xFFFFFF;
-		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
+		/* The IRQ handler's RCU read-side section protects the table
+		 * until HWC teardown has fenced its EQ and waited for readers.
+		 */
+		cq_table = smp_load_acquire(&gc->cq_table);
+		if (!cq_table || cq_id >= READ_ONCE(gc->max_num_cqs))
 			break;
 
-		cq = gc->cq_table[cq_id];
-		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
+		cq = READ_ONCE(cq_table[cq_id]);
+		if (!cq || WARN_ON_ONCE(cq->type != GDMA_CQ ||
+					cq->id != cq_id))
 			break;
 
 		if (cq->cq.callback)
@@ -993,23 +999,32 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	return err;
 }
 
-static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
+static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
 			       struct gdma_queue *queue)
 {
 	int err;
 
-	if (flush_evenets) {
+	if (queue->eq.msix_index == INVALID_PCI_MSIX_INDEX)
+		return;
+
+	if (flush_events) {
 		err = mana_gd_test_eq(gc, queue);
 		if (err && mana_need_log(gc, err))
 			dev_warn(gc->dev, "Failed to flush EQ: %d\n", err);
 	}
 
 	mana_gd_deregister_irq(queue);
+	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
 
 	if (queue->eq.disable_needed)
 		mana_gd_disable_queue(queue);
 }
 
+void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	mana_gd_destroy_eq(gc, false, queue);
+}
+
 static int mana_gd_create_eq(struct gdma_dev *gd,
 			     const struct gdma_queue_spec *spec,
 			     bool create_hwq, struct gdma_queue *queue)
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 3bca4b683134..b1d972968f0d 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -134,7 +134,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_INIT_DATA_CQID:
-			hwc->cq->gdma_cq->id = val;
+			WRITE_ONCE(hwc->hwc_init_cq_id, val);
 			break;
 
 		case HWC_INIT_DATA_RQID:
@@ -158,7 +158,11 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_MAX_NUM_CQS:
-			gd->gdma_context->max_num_cqs = val;
+			/* Store only; establish_channel() commits it to
+			 * max_num_cqs once, so a later event cannot grow the
+			 * bound past the allocation.  Pairs with its READ_ONCE().
+			 */
+			WRITE_ONCE(hwc->hwc_init_max_num_cqs, val);
 			break;
 
 		case HWC_INIT_DATA_PDID:
@@ -382,16 +386,49 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 	mana_gd_ring_cq(q_self, SET_ARM_BIT);
 }
 
-static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
+static int mana_hwc_publish_cq(struct gdma_context *gc,
+			       struct gdma_queue *cq)
 {
-	kfree(hwc_cq->comp_buf);
+	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
+	u32 id = READ_ONCE(cq->id);
 
-	if (hwc_cq->gdma_cq)
-		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
+	if (!cq_table || id >= READ_ONCE(gc->max_num_cqs) ||
+	    READ_ONCE(cq_table[id]))
+		return -EINVAL;
+
+	WRITE_ONCE(cq_table[id], cq);
+
+	return 0;
+}
+
+static void mana_hwc_unpublish_cq(struct gdma_context *gc,
+				  struct gdma_queue *cq)
+{
+	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
+	u32 id;
+
+	if (!cq_table || !cq)
+		return;
 
+	id = READ_ONCE(cq->id);
+	if (id < READ_ONCE(gc->max_num_cqs) &&
+	    READ_ONCE(cq_table[id]) == cq)
+		WRITE_ONCE(cq_table[id], NULL);
+}
+
+static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
+{
+	/* Destroy the EQ first: it deregisters the IRQ and drains in-flight
+	 * handlers, so none can touch the CQ after it is freed.
+	 */
 	if (hwc_cq->gdma_eq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
 
+	/* Safe to free now that the EQ handler is fenced. */
+	if (hwc_cq->gdma_cq)
+		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
+
+	kfree(hwc_cq->comp_buf);
 	kfree(hwc_cq);
 }
 
@@ -674,6 +711,9 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
+	struct gdma_queue **cq_table;
+	u32 num_cqs;
+	u32 cq_id;
 	int err;
 
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -683,7 +723,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				 cq->mem_info.dma_handle,
 				 rq->mem_info.dma_handle,
 				 sq->mem_info.dma_handle,
-				 eq->eq.msix_index);
+				 eq->eq.msix_index, &hwc->setup_active);
 	if (err)
 		return err;
 
@@ -694,15 +734,45 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
-	/* Both were set in mana_hwc_init_event_handler(). */
-	if (WARN_ON(cq->id >= gc->max_num_cqs))
+	/* Snapshot the device-reported count and id once, so the same value
+	 * sizes, bounds and indexes cq_table even across the sleeping
+	 * vcalloc() and a concurrent init event.
+	 */
+	num_cqs = READ_ONCE(hwc->hwc_init_max_num_cqs);
+	cq_id = READ_ONCE(hwc->hwc_init_cq_id);
+
+	/* Both operands come from untrusted HWC bootstrap events; a missing
+	 * MAX_NUM_CQS leaves num_cqs at 0.  Reject rather than WARN_ON() so a
+	 * malformed device response cannot panic a panic_on_warn guest.
+	 */
+	if (cq_id >= num_cqs) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC: bad CQ id %u >= max %u\n",
+				    cq_id, num_cqs);
 		return -EPROTO;
+	}
 
-	gc->cq_table = vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue *));
-	if (!gc->cq_table)
+	/* Init events remain enabled, so commit the validated CQ ID once. */
+	WRITE_ONCE(cq->id, cq_id);
+
+	cq_table = vcalloc(num_cqs, sizeof(*cq_table));
+	if (!cq_table)
 		return -ENOMEM;
 
-	gc->cq_table[cq->id] = cq;
+	/* Publish the bound and the initialised table together; the release
+	 * pairs with smp_load_acquire() in mana_gd_process_eqe().
+	 */
+	WRITE_ONCE(gc->max_num_cqs, num_cqs);
+	/* Pairs with smp_load_acquire() in mana_gd_process_eqe(). */
+	smp_store_release(&gc->cq_table, cq_table);
+
+	err = mana_hwc_publish_cq(gc, cq);
+	if (err) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC: failed to publish CQ %u: %d\n",
+				    cq_id, err);
+		return err;
+	}
 
 	return 0;
 }
@@ -759,6 +829,13 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	u16 q_depth_max;
 	int err;
 
+	/* Retry a retained context before assigning queues to the PF again. */
+	if (gd->driver_data) {
+		mana_hwc_destroy_channel(gc);
+		if (gd->driver_data)
+			return -ETIMEDOUT;
+	}
+
 	hwc = kzalloc_obj(*hwc);
 	if (!hwc)
 		return -ENOMEM;
@@ -808,30 +885,56 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	return err;
 }
 
+static void mana_hwc_fence_channel(struct gdma_context *gc,
+				   struct hw_channel_context *hwc)
+{
+	if (!hwc->cq)
+		return;
+
+	if (hwc->cq->gdma_eq)
+		mana_gd_fence_eq(gc, hwc->cq->gdma_eq);
+
+	if (hwc->cq->gdma_cq)
+		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
+}
+
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_queue **old_cq_table;
+	int err;
 
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
+	 * software dispatch, but retain every PF-visible allocation.
 	 */
-	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		gc->max_num_cqs = 0;
+	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
+				    &hwc->setup_active);
+	if (err) {
+		dev_err(hwc->dev,
+			"HWC teardown failed: %d, retaining PF-visible resources\n",
+			err);
+		mana_hwc_fence_channel(gc, hwc);
+		return;
 	}
 
+	/* Fence the EQ before releasing any state its handlers can reach. */
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
+
+	/* Reset only after mana_hwc_destroy_cq() has cleared the CQ table
+	 * slot, so it is not left dangling.
+	 */
+	WRITE_ONCE(gc->max_num_cqs, 0);
+
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
 
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
@@ -848,8 +951,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
+	old_cq_table = READ_ONCE(gc->cq_table);
+	/* Stop new table readers before waiting for existing IRQ readers. */
+	smp_store_release(&gc->cq_table, NULL);
+	synchronize_rcu();
+	vfree(old_cq_table);
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
index d21b5db06e50..df9d05062dd5 100644
--- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -125,13 +125,24 @@ static int mana_smc_read_response(struct shm_channel *sc, u32 msg_type,
 void mana_smc_init(struct shm_channel *sc, struct device *dev,
 		   void __iomem *base)
 {
+	/* The first call precedes channel publication. Later calls refresh the
+	 * BAR mapping after reset or resume without reinitializing a live lock.
+	 */
+	if (!sc->transaction_lock_initialized) {
+		mutex_init(&sc->transaction_lock);
+		sc->transaction_lock_initialized = true;
+	}
+
+	mutex_lock(&sc->transaction_lock);
 	sc->dev = dev;
 	sc->base = base;
+	mutex_unlock(&sc->transaction_lock);
 }
 
-int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
-		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index)
+static int mana_smc_setup_hwc_locked(struct shm_channel *sc, bool reset_vf,
+				     u64 eq_addr, u64 cq_addr, u64 rq_addr,
+				     u64 sq_addr, u32 eq_msix_index,
+				     bool *submitted)
 {
 	union smc_proto_hdr *hdr;
 	u16 all_addr_h4bits = 0;
@@ -144,6 +155,9 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	int err;
 	int i;
 
+	lockdep_assert_held(&sc->transaction_lock);
+	*submitted = false;
+
 	/* Ensure VF already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -229,6 +243,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	/* Write 256-message buffer to shared memory (final 32-bit write
 	 * triggers HW to set possession bit to PF).
 	 */
+	*submitted = true;
 	dword = (u32 *)shm_buf;
 	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
 		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
@@ -248,11 +263,32 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	return 0;
 }
 
-int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf)
+int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
+		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
+		       u32 eq_msix_index, bool *submitted)
+{
+	int err;
+
+	mutex_lock(&sc->transaction_lock);
+	err = mana_smc_setup_hwc_locked(sc, reset_vf, eq_addr, cq_addr,
+					rq_addr, sq_addr, eq_msix_index,
+					submitted);
+	mutex_unlock(&sc->transaction_lock);
+
+	return err;
+}
+
+static int mana_smc_teardown_hwc_locked(struct shm_channel *sc, bool reset_vf,
+					bool *setup_active)
 {
 	union smc_proto_hdr hdr = {};
 	int err;
 
+	lockdep_assert_held(&sc->transaction_lock);
+
+	if (!*setup_active)
+		return 0;
+
 	/* Ensure already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -283,5 +319,19 @@ int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf)
 		return err;
 	}
 
+	*setup_active = false;
+
 	return 0;
 }
+
+int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf,
+			  bool *setup_active)
+{
+	int err;
+
+	mutex_lock(&sc->transaction_lock);
+	err = mana_smc_teardown_hwc_locked(sc, reset_vf, setup_active);
+	mutex_unlock(&sc->transaction_lock);
+
+	return err;
+}
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index c610fc1067e0..4d49202b45c6 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -580,6 +580,9 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 
 void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
+/* Remove an EQ from interrupt dispatch without freeing its queue memory. */
+void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);
+
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 1ab2d66c891e..eb1c005bc091 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -185,6 +185,8 @@ struct hw_channel_context {
 	u16 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
+	u32 hwc_init_max_num_cqs;
+	u32 hwc_init_cq_id;
 
 	struct completion hwc_init_eqe_comp;
 
@@ -199,6 +201,8 @@ struct hw_channel_context {
 	u32 dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* The PF may own the HWC queues while this is true. */
+	bool setup_active;
 	struct hwc_caller_ctx *caller_ctx;
 };
 
diff --git a/include/net/mana/shm_channel.h b/include/net/mana/shm_channel.h
index dbabcfb95daf..c8daa61fa759 100644
--- a/include/net/mana/shm_channel.h
+++ b/include/net/mana/shm_channel.h
@@ -4,6 +4,8 @@
 #ifndef _SHM_CHANNEL_H
 #define _SHM_CHANNEL_H
 
+#include <linux/mutex.h>
+
 #define SMC_APERTURE_BITS 256
 #define SMC_BASIC_UNIT (sizeof(u32))
 #define SMC_APERTURE_DWORDS (SMC_APERTURE_BITS / (SMC_BASIC_UNIT * 8))
@@ -13,6 +15,9 @@
 struct shm_channel {
 	struct device *dev;
 	void __iomem *base;
+	/* Protects base and complete aperture request/response transactions. */
+	struct mutex transaction_lock;
+	bool transaction_lock_initialized;
 };
 
 void mana_smc_init(struct shm_channel *sc, struct device *dev,
@@ -20,8 +25,9 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
 
 int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index);
+		       u32 eq_msix_index, bool *submitted);
 
-int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf);
+int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf,
+			  bool *setup_active);
 
 #endif /* _SHM_CHANNEL_H */
-- 
2.43.0

