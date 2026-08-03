Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79892397E64;
	Mon,  3 Aug 2026 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800664; cv=none; b=dT4crlMVmvsHtcYeGJBa9bgFnGbVno4SCldROsoh1wSE0yqOexSI4uJOPjD5oybkAXprvZ6dlJddHhGmQqKm9tiacBzJTPDLjGdliCX3n7AySs+6mxcmzOtcK4UxpyTo0HZcovTa5sPCwfXAju7OsMOa3fQ7CSvOVm2Fg48pDoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800664; c=relaxed/simple;
	bh=l4buCzMmcGafZkdgRwS57NQofJuZCYiQBj/avQol5oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NStsPDJSGzx1zj2NBvYUrvxax0yNz5asGD+gWdzz9kplDJssIoBBwMEJW+KAYFBZwqi2/kYaDeXr7MIRZEfCoHkXH1ysRIl4gcVNqge+f7CtR4d3k3bj8CE/aZzWStuRdVbTShcCJ54iXLffys54iUOErAIiyCbRPhnowDhDjv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B98EB20B7167; Mon,  3 Aug 2026 16:44:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B98EB20B7167
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
Subject: [PATCH net v3 1/6] net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy
Date: Mon,  3 Aug 2026 16:43:39 -0700
Message-ID: <20260803234355.636038-2-longli@microsoft.com>
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

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c               | 46 ++++++++++++++++---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 25 ++++++++--
 .../net/ethernet/microsoft/mana/hw_channel.c  | 29 ++++++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c | 22 +++++++--
 include/net/mana/gdma.h                       | 21 ++++++++-
 5 files changed, 119 insertions(+), 24 deletions(-)

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
index e8b7ffb47eb9..fa6fcc2475c1 100644
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
 
@@ -1053,15 +1055,28 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 static void mana_gd_destroy_cq(struct gdma_context *gc,
 			       struct gdma_queue *queue)
 {
+	struct gdma_queue __rcu **cq_table;
 	u32 id = queue->id;
 
-	if (id >= gc->max_num_cqs)
+	/* No rcu_read_lock() here: mana_gd_destroy_cq() runs only on the
+	 * CQ-destroy/teardown path, where the base cq_table is stable.  See
+	 * the lifecycle note on gdma_context::cq_table in gdma.h for why the
+	 * "true" predicate is sound.
+	 */
+	cq_table = rcu_dereference_protected(gc->cq_table, true);
+	if (!cq_table || id >= gc->max_num_cqs)
 		return;
 
-	if (!gc->cq_table[id])
+	if (!rcu_access_pointer(cq_table[id]))
 		return;
 
-	gc->cq_table[id] = NULL;
+	rcu_assign_pointer(cq_table[id], NULL);
+
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
index 92bb55935c1c..65b025e8f211 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2496,6 +2496,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
 	struct gdma_context *gc;
+	struct gdma_queue __rcu **cq_table;
 	struct mana_txq *txq;
 	struct mana_cq *cq;
 	u32 txq_size;
@@ -2596,12 +2597,18 @@ static int mana_create_txq(struct mana_port_context *apc,
 
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
 
@@ -2821,6 +2828,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct gdma_queue_spec spec;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
+	struct gdma_queue __rcu **cq_table;
 	u32 cq_size, rq_size;
 	struct mana_rxq *rxq;
 	int err;
@@ -2905,12 +2913,18 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
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
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0c395917b214..0b48ded0aecd 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -418,7 +418,26 @@ struct gdma_context {
 
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
+	 * true).  The bare "true" is justified by teardown ordering, not by
+	 * a lock: the base table is replaced+freed only by
+	 * mana_hwc_destroy_channel() (and the create-time reinit), and every
+	 * teardown path first runs mana_remove() + mana_rdma_remove(), which
+	 * synchronously drain the netdev and the IB device
+	 * (unregister_netdevice / ib_unregister_device) that bound all
+	 * install/remove callers; the reinit case runs before either
+	 * consumer is probed.  So no slow-path caller can run while the base
+	 * table is being freed.
+	 */
+	struct gdma_queue	__rcu * __rcu *cq_table;
 
 	/* Protect eq_test_event and test_event_eq_id  */
 	struct mutex		eq_test_event_mutex;
-- 
2.43.0

