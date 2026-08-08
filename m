Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9A42EB0F;
	Sat,  8 Aug 2026 02:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156486; cv=none; b=u/WyfW+D87MoN6CwnWpSGdPv1OvlT/hSghgGhbdXMLIdkpRJrwUS9yw7Jj15reyPyapAoA3RURp/FdiJz43a6N7NemWk0qqn1mJG7ucMqjvIJCY+ULrO4p/o397xf5QH8tnMs0mzbq0YAgWQqoxqHrS38P1BtW/2KMF86pZBhAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156486; c=relaxed/simple;
	bh=wUSZ7qSvOT0ngo8yg9UUUaedgviPquXH0Rlq4g2tuNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arXEzV2BqPgVjL9dIeZRKXPT9goSDE5WBmukU5i5Aslx84AflbpYzVx5EeITFQScpoFwGAz09tqL2IBaJjytpED9s+KtXs8dPRsPBNB2hU6llnsNaJ+e3wHs7/pgIoQ3bHeYKFo85/PF1ajkOZxmnawEKToSmuDKhKHm9Y3H2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 685FB20B7129; Fri,  7 Aug 2026 19:34:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 685FB20B7129
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
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Kees Cook <kees@kernel.org>,
	Shachar Raindel <shacharr@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/7] net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy
Date: Fri,  7 Aug 2026 19:34:10 -0700
Message-ID: <20260808023417.1746886-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EQ interrupt handler (mana_gd_process_eqe) looks up the completing CQ
in gc->cq_table[cq_id] and runs its callback, concurrently with CQ
teardown on another CPU that clears the slot and frees the CQ.  cq_table
was a plain pointer array freed with no grace period, so the two race
into a use-after-free:

  CPU A (mana_gd_intr, hard IRQ)        CPU B (CQ destroy)
  ----------------------------------    ------------------------------
  cq = gc->cq_table[cq_id];  // valid
                                        gc->cq_table[id] = NULL;
                                        kfree(cq);          // freed
  cq->cq.callback(ctx, cq);  // use-after-free

The handler's existing rcu_read_lock() only guards the per-IRQ EQ list
traversal; cq_table was never under any RCU contract, and a read-side
lock is inert unless the freer also defers the free past a grace period.

Put cq_table under RCU: annotate the base pointer and entries __rcu, read
with rcu_dereference() in the handler, publish with rcu_assign_pointer(),
and on teardown clear the slot then synchronize_rcu() before freeing the
CQ.  The grace period blocks until every in-flight handler has dropped
the old pointer, so the kfree() can no longer race the callback.

This fixes only the CQ lifetime (the use-after-free); it does not make
the cq_id bound trustworthy.  gc->max_num_cqs is still range-checked
outside the published table, and hardening that field against a spoofed
device value is a separate change.

netdev teardown destroys a CQ per TX and per RX queue, so one grace
period each in mana_gd_destroy_cq() would serialize up to
2 * MANA_MAX_NUM_QUEUES synchronize_rcu() calls under RTNL on every
ifdown, MTU change or ring/channel reconfigure.  Clear all of a port's
CQ slots first and take a single grace period per teardown instead:
mana_gd_unpublish_cq() clears a slot without waiting, and
mana_gd_destroy_cq() -- which still serves the single-CQ callers --
finds the slot already cleared and skips its own synchronize_rcu().

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
 - Replaced the per-CQ synchronize_rcu() in the netdev teardown paths
   with a two-pass quiesce/free that takes one grace period per
   teardown; mana_gd_unpublish_cq() splits the slot-clear from the
   grace period.
 - Snapshot cq->id and max_num_cqs with READ_ONCE() in
   mana_hwc_establish_channel() so one value sizes, bounds and indexes
   cq_table.
 - Corrected the gc->cq_table lifetime comment in gdma.h; rescoped the
   changelog to the use-after-free fix (the bound is patch 7).

 drivers/infiniband/hw/mana/cq.c               |  46 +++++-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  41 ++++--
 .../net/ethernet/microsoft/mana/hw_channel.c  |  29 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 136 ++++++++++++++----
 include/net/mana/gdma.h                       |  32 ++++-
 5 files changed, 234 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index f2547989f422..2bf4be21cede 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -131,12 +131,20 @@ static void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq)
 int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 {
 	struct gdma_context *gc = mdev_to_gc(mdev);
+	struct gdma_queue __rcu **cq_table;
 	struct gdma_queue *gdma_cq;
 
-	if (cq->queue.id >= gc->max_num_cqs)
+	/* No rcu_read_lock(): install/remove run within the IB device
+	 * lifetime, which mana_rdma_remove() (ib_unregister_device) drains
+	 * before the base cq_table can be freed.  See gdma_context::cq_table
+	 * in gdma.h for why "true" is sound.
+	 */
+	cq_table = rcu_dereference_protected(gc->cq_table, true);
+	if (!cq_table || cq->queue.id >= gc->max_num_cqs)
 		return -EINVAL;
+
 	/* Create CQ table entry, sharing a CQ between WQs is not supported */
-	if (gc->cq_table[cq->queue.id])
+	if (rcu_access_pointer(cq_table[cq->queue.id]))
 		return -EINVAL;
 	if (cq->queue.kmem)
 		gdma_cq = cq->queue.kmem;
@@ -149,23 +157,49 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gdma_cq->type = GDMA_CQ;
 	gdma_cq->cq.callback = mana_ib_cq_handler;
 	gdma_cq->id = cq->queue.id;
-	gc->cq_table[cq->queue.id] = gdma_cq;
+	rcu_assign_pointer(cq_table[cq->queue.id], gdma_cq);
 	return 0;
 }
 
 void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 {
 	struct gdma_context *gc = mdev_to_gc(mdev);
+	struct gdma_queue __rcu **cq_table;
+	struct gdma_queue *gdma_cq;
 
-	if (cq->queue.id >= gc->max_num_cqs || cq->queue.id == INVALID_QUEUE_ID)
+	if (cq->queue.id == INVALID_QUEUE_ID)
 		return;
 
 	if (cq->queue.kmem)
 	/* Then it will be cleaned and removed by the mana */
 		return;
 
-	kfree(gc->cq_table[cq->queue.id]);
-	gc->cq_table[cq->queue.id] = NULL;
+	/* No rcu_read_lock(): like mana_ib_install_cq_cb(), this runs within
+	 * the IB device lifetime that mana_rdma_remove() drains before the
+	 * base cq_table can be freed.  See gdma_context::cq_table in gdma.h.
+	 */
+	cq_table = rcu_dereference_protected(gc->cq_table, true);
+	if (!cq_table || cq->queue.id >= gc->max_num_cqs)
+		return;
+	/* Removers for a given CQ are serialized by the IB core, so the slot
+	 * is read and cleared without rcu_read_lock() or atomicity: a CQ is
+	 * never torn down while a live QP references it (cq->usecnt), nor
+	 * while the QP-create that installed the entry is still running (that
+	 * create holds a reference on the CQ uobject across its error path,
+	 * before usecnt is taken).  Any double-remove is therefore sequential
+	 * -- the later caller sees the NULL stored below and returns.
+	 */
+	gdma_cq = rcu_dereference_protected(cq_table[cq->queue.id], true);
+	if (!gdma_cq)
+		return;  /* already removed by a prior teardown path */
+
+	rcu_assign_pointer(cq_table[cq->queue.id], NULL);
+
+	/* Wait for in-flight EQ handlers that may have loaded the old
+	 * pointer via rcu_dereference() to finish before freeing.
+	 */
+	synchronize_rcu();
+	kfree(gdma_cq);
 }
 
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e8b7ffb47eb9..7714040d1df4 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -732,6 +732,7 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	union gdma_eqe_info eqe_info;
 	enum gdma_eqe_type type;
 	struct gdma_event event;
+	struct gdma_queue __rcu **cq_table;
 	struct gdma_queue *cq;
 	struct gdma_eqe *eqe;
 	u32 cq_id;
@@ -743,10 +744,11 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	switch (type) {
 	case GDMA_EQE_COMPLETION:
 		cq_id = eqe->details[0] & 0xFFFFFF;
-		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
+		cq_table = rcu_dereference(gc->cq_table);
+		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs || !cq_table))
 			break;
 
-		cq = gc->cq_table[cq_id];
+		cq = rcu_dereference(cq_table[cq_id]);
 		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
 			break;
 
@@ -1050,18 +1052,41 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 	queue->cq.callback = spec->cq.callback;
 }
 
-static void mana_gd_destroy_cq(struct gdma_context *gc,
-			       struct gdma_queue *queue)
+bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue)
 {
+	struct gdma_queue __rcu **cq_table;
 	u32 id = queue->id;
 
-	if (id >= gc->max_num_cqs)
-		return;
+	/* No rcu_read_lock() here: unpublish runs only on the
+	 * CQ-destroy/teardown path, where the base cq_table is stable.  See
+	 * the lifecycle note on gdma_context::cq_table in gdma.h for why the
+	 * "true" predicate is sound.
+	 */
+	cq_table = rcu_dereference_protected(gc->cq_table, true);
+	if (!cq_table || id >= gc->max_num_cqs)
+		return false;
+
+	if (!rcu_access_pointer(cq_table[id]))
+		return false;
+
+	rcu_assign_pointer(cq_table[id], NULL);
+	return true;
+}
 
-	if (!gc->cq_table[id])
+static void mana_gd_destroy_cq(struct gdma_context *gc,
+			       struct gdma_queue *queue)
+{
+	/* A batched teardown may already have cleared the slot and taken the
+	 * grace period; then there is nothing left to wait for.
+	 */
+	if (!mana_gd_unpublish_cq(gc, queue))
 		return;
 
-	gc->cq_table[id] = NULL;
+	/* Wait for in-flight EQ handlers that may have loaded the old
+	 * pointer via rcu_dereference() to finish before the caller
+	 * frees the CQ memory.
+	 */
+	synchronize_rcu();
 }
 
 int mana_gd_create_hwc_queue(struct gdma_dev *gd,
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e3c24d50dad0..409e20caeccd 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -674,6 +674,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
+	struct gdma_queue __rcu **cq_table;
 	int err;
 
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -698,11 +699,15 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
 
-	gc->cq_table = vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue *));
-	if (!gc->cq_table)
+	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
+	if (!cq_table)
 		return -ENOMEM;
 
-	gc->cq_table[cq->id] = cq;
+	rcu_assign_pointer(cq_table[cq->id], cq);
+	/* Publish the fully-initialised table last; pairs with the
+	 * rcu_dereference(gc->cq_table) in mana_gd_process_eqe().
+	 */
+	rcu_assign_pointer(gc->cq_table, cq_table);
 
 	return 0;
 }
@@ -811,6 +816,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_queue __rcu **old_cq_table;
 
 	if (!hwc)
 		return;
@@ -818,10 +824,8 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
 	 * non-zero, the HWC worked and we should tear down the HWC here.
 	 */
-	if (gc->max_num_cqs > 0) {
+	if (gc->max_num_cqs > 0)
 		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		gc->max_num_cqs = 0;
-	}
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
@@ -832,6 +836,14 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->cq)
 		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
+	/* Reset only after mana_hwc_destroy_cq() above has run with a valid
+	 * max_num_cqs so mana_gd_destroy_cq() clears the CQ table slot and
+	 * waits out in-flight EQ handlers (synchronize_rcu) before the CQ is
+	 * freed.  Clearing it earlier would make that path early-return and
+	 * skip the slot clear, leaving a dangling cq_table entry.
+	 */
+	gc->max_num_cqs = 0;
+
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
@@ -848,8 +860,9 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
+	old_cq_table = rcu_replace_pointer(gc->cq_table, NULL, true);
+	synchronize_rcu();
+	vfree(old_cq_table);
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 92bb55935c1c..5d215981bba8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2427,12 +2427,18 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 
 static void mana_destroy_txq(struct mana_port_context *apc)
 {
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
 	struct napi_struct *napi;
 	int i;
 
 	if (!apc->tx_qp)
 		return;
 
+	/* Pass 1: quiesce each CQ on the device and clear its cq_table slot.
+	 * Taking one grace period below for the whole port avoids up to
+	 * apc->num_queues serialized synchronize_rcu() calls (one per CQ in
+	 * mana_gd_destroy_cq()) under RTNL on every teardown.
+	 */
 	for (i = 0; i < apc->num_queues; i++) {
 		if (!apc->tx_qp[i])
 			continue;
@@ -2448,8 +2454,24 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			apc->tx_qp[i]->txq.napi_initialized = false;
 		}
 
-		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE)
-			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);
+		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE) {
+			mana_destroy_wq_obj(apc, GDMA_SQ,
+					    apc->tx_qp[i]->tx_object);
+			apc->tx_qp[i]->tx_object = INVALID_MANA_HANDLE;
+		}
+
+		if (apc->tx_qp[i]->tx_cq.gdma_cq)
+			mana_gd_unpublish_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
+	}
+
+	synchronize_rcu();
+
+	/* Pass 2: the slots are clear, so mana_gd_destroy_cq() skips its own
+	 * grace period; free the CQ, the TXQ and the queue pair.
+	 */
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
 
 		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
 
@@ -2496,6 +2518,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
 	struct gdma_context *gc;
+	struct gdma_queue __rcu **cq_table;
 	struct mana_txq *txq;
 	struct mana_cq *cq;
 	u32 txq_size;
@@ -2596,12 +2619,18 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		cq->gdma_id = cq->gdma_cq->id;
 
-		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+		/* No rcu_read_lock(): mana_create_txq runs under RTNL during
+		 * netdev bring-up, inside the netdev lifetime that
+		 * mana_remove() drains before the base cq_table can be freed.
+		 * See gdma_context::cq_table in gdma.h for why "true" is sound.
+		 */
+		cq_table = rcu_dereference_protected(gc->cq_table, true);
+		if (WARN_ON(!cq_table || cq->gdma_id >= gc->max_num_cqs)) {
 			err = -EINVAL;
 			goto out;
 		}
 
-		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
+		rcu_assign_pointer(cq_table[cq->gdma_id], cq->gdma_cq);
 
 		mana_create_txq_debugfs(apc, i);
 
@@ -2621,25 +2650,20 @@ static int mana_create_txq(struct mana_port_context *apc,
 	return err;
 }
 
-static void mana_destroy_rxq(struct mana_port_context *apc,
+/* Quiesce an RXQ's CQ on the device and clear its cq_table slot, without
+ * waiting for a grace period.  Split out of mana_destroy_rxq() so a batch
+ * teardown (mana_destroy_rxqs()) can quiesce every RXQ and then take a
+ * single synchronize_rcu() instead of one per RXQ.
+ */
+static void mana_quiesce_rxq(struct mana_port_context *apc,
 			     struct mana_rxq *rxq, bool napi_initialized)
-
 {
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
-	struct mana_recv_buf_oob *rx_oob;
-	struct device *dev = gc->dev;
-	struct napi_struct *napi;
-	struct page *page;
-	int i;
-
-	if (!rxq)
-		return;
+	struct napi_struct *napi = &rxq->rx_cq.napi;
 
 	debugfs_remove_recursive(rxq->mana_rx_debugfs);
 	rxq->mana_rx_debugfs = NULL;
 
-	napi = &rxq->rx_cq.napi;
-
 	if (napi_initialized) {
 		napi_synchronize(napi);
 
@@ -2650,8 +2674,27 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
-	if (rxq->rxobj != INVALID_MANA_HANDLE)
+	if (rxq->rxobj != INVALID_MANA_HANDLE) {
 		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
+		rxq->rxobj = INVALID_MANA_HANDLE;
+	}
+
+	if (rxq->rx_cq.gdma_cq)
+		mana_gd_unpublish_cq(gc, rxq->rx_cq.gdma_cq);
+}
+
+/* Free an RXQ once its cq_table slot has been cleared and a grace period
+ * has elapsed (see mana_quiesce_rxq()).  mana_deinit_cq() ->
+ * mana_gd_destroy_cq() finds the slot already NULL and skips its own
+ * synchronize_rcu().
+ */
+static void mana_free_rxq(struct mana_port_context *apc, struct mana_rxq *rxq)
+{
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
+	struct mana_recv_buf_oob *rx_oob;
+	struct device *dev = gc->dev;
+	struct page *page;
+	int i;
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
@@ -2685,6 +2728,23 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	kvfree(rxq);
 }
 
+static void mana_destroy_rxq(struct mana_port_context *apc,
+			     struct mana_rxq *rxq, bool napi_initialized)
+
+{
+	if (!rxq)
+		return;
+
+	mana_quiesce_rxq(apc, rxq, napi_initialized);
+
+	/* Wait for in-flight EQ handlers that may have loaded the old CQ
+	 * pointer via rcu_dereference() before freeing.
+	 */
+	synchronize_rcu();
+
+	mana_free_rxq(apc, rxq);
+}
+
 static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
 			    struct mana_rxq *rxq, struct device *dev)
 {
@@ -2821,6 +2881,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct gdma_queue_spec spec;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
+	struct gdma_queue __rcu **cq_table;
 	u32 cq_size, rq_size;
 	struct mana_rxq *rxq;
 	int err;
@@ -2905,12 +2966,18 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	if (err)
 		goto out;
 
-	if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+	/* No rcu_read_lock(): mana_create_rxq runs under RTNL during netdev
+	 * bring-up, inside the netdev lifetime that mana_remove() drains
+	 * before the base cq_table can be freed.  See gdma_context::cq_table
+	 * in gdma.h for why "true" is sound.
+	 */
+	cq_table = rcu_dereference_protected(gc->cq_table, true);
+	if (WARN_ON(!cq_table || cq->gdma_id >= gc->max_num_cqs)) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
+	rcu_assign_pointer(cq_table[cq->gdma_id], cq->gdma_cq);
 
 	netif_napi_add_weight_locked(ndev, &cq->napi, mana_poll, 1);
 
@@ -2987,16 +3054,31 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
 	struct mana_rxq *rxq;
 	u32 rxq_idx;
 
-	if (apc->rxqs) {
+	if (!apc->rxqs)
+		return;
 
-		for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
-			rxq = apc->rxqs[rxq_idx];
-			if (!rxq)
-				continue;
+	/* Pass 1: quiesce every RXQ's CQ and clear its cq_table slot. */
+	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
+		rxq = apc->rxqs[rxq_idx];
+		if (!rxq)
+			continue;
 
-			mana_destroy_rxq(apc, rxq, true);
-			apc->rxqs[rxq_idx] = NULL;
-		}
+		mana_quiesce_rxq(apc, rxq, true);
+	}
+
+	/* One grace period for the whole port instead of one per RXQ. */
+	synchronize_rcu();
+
+	/* Pass 2: the slots are clear, so mana_gd_destroy_cq() skips its own
+	 * grace period; free each RXQ.
+	 */
+	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
+		rxq = apc->rxqs[rxq_idx];
+		if (!rxq)
+			continue;
+
+		mana_free_rxq(apc, rxq);
+		apc->rxqs[rxq_idx] = NULL;
 	}
 }
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0c395917b214..b8b1b23f3c36 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -418,7 +418,31 @@ struct gdma_context {
 
 	/* This maps a CQ index to the queue structure. */
 	unsigned int		max_num_cqs;
-	struct gdma_queue	**cq_table;
+	/* Both the base pointer and each entry are RCU-managed.  The fast
+	 * path (mana_gd_process_eqe) reads the base via rcu_dereference()
+	 * under rcu_read_lock(), so the table is freed with
+	 * rcu_assign_pointer(NULL) + synchronize_rcu() and an in-flight
+	 * reader can never observe freed memory.
+	 *
+	 * The slow paths -- mana_gd_destroy_cq() and the CQ install/remove
+	 * callers (mana_create_txq/_rxq, mana_ib_install/remove_cq_cb) --
+	 * instead read the base with rcu_dereference_protected(cq_table,
+	 * true).  The bare "true" asserts teardown/bring-up ordering, not a
+	 * lock: the base table is allocated in mana_hwc_establish_channel()
+	 * and replaced+freed only by mana_hwc_destroy_channel() (via
+	 * mana_gd_cleanup_device()) and the create-time reinit.  The reinit
+	 * runs before either consumer is probed, and cleanup_device() runs
+	 * after mana_remove() / mana_rdma_remove() have detached the ports
+	 * under RTNL and drained the IB device, so no install/remove caller
+	 * is running when the base is freed.  This is an ordering argument
+	 * about when cleanup_device() runs: suspend and shutdown keep the
+	 * netdev registered, so it does not rely on unregister_netdevice()
+	 * having run on every path.  mana_hwc_destroy_channel() itself reads
+	 * cq_table (mana_hwc_destroy_cq()) before it replaces and vfree()s
+	 * the base, so that access is ordered ahead of the free by program
+	 * order.
+	 */
+	struct gdma_queue	__rcu * __rcu *cq_table;
 
 	/* Protect eq_test_event and test_event_eq_id  */
 	struct mutex		eq_test_event_mutex;
@@ -496,6 +520,12 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 
 void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
+/* Clear a CQ's cq_table slot without waiting for a grace period.  Batched
+ * teardown paths clear several slots and then take a single synchronize_rcu();
+ * single-CQ callers use mana_gd_destroy_cq() instead, which also waits.
+ */
+bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue);
+
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
-- 
2.43.0

