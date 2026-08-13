Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61D0361DCB;
	Thu, 13 Aug 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642996; cv=none; b=M5z+iYvTmmID35BMQAOlQqpWBPtvaz9GKYLkLBbmPt2y1Dc966NmytvkUa4SCvQGoW2PMJD9+M//f2tqrjDvtkKLwhBWdPhQNQ90mOZeTETRmK8E0jCzMICRtwqxU2stjAJ4VvzDNn2hMV6bmC11wSOyp96HUWgC0tM7qcKXqd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642996; c=relaxed/simple;
	bh=5srSlT3jNg1DrDDSs8JXiYOdDvWh/Hev9T0Kb765QdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9z/AGK3yv5YQm+62xlMvPhXeuadnYvZutYADO8gsdvEzcprE3xJBK7wNUwQjHJtJgJG6KUkxFk1ywyMsOmc8MjMzRA6TrcvvYTgNiLo4jxgyIVs/km6xk2WKOxs3vpOMkopqXNDh6xdtXTNj0yFAC+E4uuyxYoZk7TN3mAMEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7245D20B7128; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7245D20B7128
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
Subject: [PATCH net v7 1/7] net: mana: reference-count CQs looked up from the EQ handler
Date: Thu, 13 Aug 2026 10:42:33 -0700
Message-ID: <20260813174243.3044348-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813174243.3044348-1-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EQ interrupt handler (mana_gd_process_eqe) looks up the completing CQ
in gc->cq_table[cq_id] and runs its callback.  cq_table was a plain array,
read without RCU and freed without a grace period, so a concurrent CQ
teardown races the lookup into a use-after-free:

  CPU A (mana_gd_intr, hard IRQ)        CPU B (CQ destroy)
  ----------------------------------    ------------------------------
  cq = gc->cq_table[cq_id];  // valid
                                        gc->cq_table[id] = NULL;
                                        kfree(cq);          // freed
  cq->cq.callback(ctx, cq);  // use-after-free

Reference-count the CQ, like the driver's existing QP get/put.  Mark
cq_table __rcu and look it up under the handler's rcu_read_lock():
mana_gd_get_cq() takes a reference with refcount_inc_not_zero() and
mana_gd_put_cq() drops it after the callback.  Teardown clears the slot,
drops the publish reference, waits for any in-flight handler, then frees
the CQ with kfree_rcu().

On the RDMA destroy path (mana_ib_destroy_cq) clear the dispatch entry
before destroying the HW CQ.  A late completion then finds an empty slot
and is dropped, and a cq_id the device recycles cannot alias the
outgoing entry.

The cq_id bound is hardened in a later patch.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
Reworked from the v6 lock-based RCU scheme to lockless reference
counting per review feedback (Leon Romanovsky):
- Dropped gc->cq_table_lock; lookups take a reference under RCU with
  refcount_inc_not_zero() and the CQ is freed via kfree_rcu().
- publish/unpublish are lockless; the EQ-handler lookup uses
  smp_load_acquire() paired with the release-store that publishes the
  table.
- Reordered mana_ib_destroy_cq() to detach the software callback before
  destroying the hardware CQ, closing a CQ-id recycle window.
- Retitled (was "RCU-protect gc->cq_table lookups against concurrent CQ
  destroy").
 drivers/infiniband/hw/mana/cq.c               |  41 ++++---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 100 +++++++++++++++---
 .../net/ethernet/microsoft/mana/hw_channel.c  |  29 +++--
 drivers/net/ethernet/microsoft/mana/mana_en.c |   8 +-
 include/net/mana/gdma.h                       |  23 +++-
 5 files changed, 160 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index f2547989f422901075fa19a1ba48daf3e9a1ec96..022c82479ef6c47d78bc64b638f18aa25bbd3308 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -108,11 +108,12 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 
+	/* Detach the dispatch entry first, then stop the HW CQ and free the
+	 * queue.  A completion racing teardown then finds an empty slot, and
+	 * a recycled cq_id cannot alias this CQ.  Errors are logged inside.
+	 */
 	mana_ib_remove_cq_cb(mdev, cq);
 
-	/* Ignore return code as there is not much we can do about it.
-	 * The error message is printed inside.
-	 */
 	mana_ib_gd_destroy_cq(mdev, cq);
 
 	mana_ib_destroy_queue(mdev, &cq->queue);
@@ -132,12 +133,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 {
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct gdma_queue *gdma_cq;
+	int err;
 
-	if (cq->queue.id >= gc->max_num_cqs)
-		return -EINVAL;
-	/* Create CQ table entry, sharing a CQ between WQs is not supported */
-	if (gc->cq_table[cq->queue.id])
-		return -EINVAL;
 	if (cq->queue.kmem)
 		gdma_cq = cq->queue.kmem;
 	else
@@ -149,23 +146,41 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gdma_cq->type = GDMA_CQ;
 	gdma_cq->cq.callback = mana_ib_cq_handler;
 	gdma_cq->id = cq->queue.id;
-	gc->cq_table[cq->queue.id] = gdma_cq;
-	return 0;
+
+	err = mana_gd_publish_cq(gc, gdma_cq);
+	if (err && !cq->queue.kmem)
+		kfree(gdma_cq);
+
+	return err;
 }
 
 void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 {
 	struct gdma_context *gc = mdev_to_gc(mdev);
+	struct gdma_queue __rcu **cq_table;
+	struct gdma_queue *gdma_cq;
 
-	if (cq->queue.id >= gc->max_num_cqs || cq->queue.id == INVALID_QUEUE_ID)
+	if (cq->queue.id == INVALID_QUEUE_ID || cq->queue.id >= gc->max_num_cqs)
 		return;
 
 	if (cq->queue.kmem)
 	/* Then it will be cleaned and removed by the mana */
 		return;
 
-	kfree(gc->cq_table[cq->queue.id]);
-	gc->cq_table[cq->queue.id] = NULL;
+	rcu_read_lock();
+	cq_table = READ_ONCE(gc->cq_table);
+	gdma_cq = cq_table ? rcu_dereference(cq_table[cq->queue.id]) : NULL;
+	/* Match the CQ under RCU so the slot cannot be freed mid-check. */
+	if (gdma_cq && gdma_cq->cq.context != cq)
+		gdma_cq = NULL;
+	rcu_read_unlock();
+
+	if (!gdma_cq)
+		return;
+
+	/* Remove from the table, then free after a grace period. */
+	mana_gd_unpublish_cq(gc, gdma_cq);
+	kfree_rcu(gdma_cq, rcu);
 }
 
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e8b7ffb47eb982d139b80bc4fb4bbb0ad5307962..b29e078b419b3c16326ad890c8e97401e1d3f3a9 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -724,6 +724,9 @@ int mana_schedule_serv_work(struct gdma_context *gc, enum gdma_eqe_type type)
 	return 0;
 }
 
+static struct gdma_queue *mana_gd_get_cq(struct gdma_context *gc, u32 cq_id);
+static void mana_gd_put_cq(struct gdma_queue *cq);
+
 static void mana_gd_process_eqe(struct gdma_queue *eq)
 {
 	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
@@ -743,16 +746,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	switch (type) {
 	case GDMA_EQE_COMPLETION:
 		cq_id = eqe->details[0] & 0xFFFFFF;
-		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
-			break;
-
-		cq = gc->cq_table[cq_id];
-		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
+		cq = mana_gd_get_cq(gc, cq_id);
+		/* CQ already torn down: stale completion, drop it. */
+		if (!cq)
 			break;
 
-		if (cq->cq.callback)
+		if (!WARN_ON_ONCE(cq->type != GDMA_CQ || cq->id != cq_id) &&
+		    cq->cq.callback)
 			cq->cq.callback(cq->cq.context, cq);
 
+		mana_gd_put_cq(cq);
 		break;
 
 	case GDMA_EQE_TEST_EVENT:
@@ -1050,18 +1053,81 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 	queue->cq.callback = spec->cq.callback;
 }
 
-static void mana_gd_destroy_cq(struct gdma_context *gc,
-			       struct gdma_queue *queue)
+static struct gdma_queue *mana_gd_get_cq(struct gdma_context *gc, u32 cq_id)
 {
-	u32 id = queue->id;
+	struct gdma_queue __rcu **cq_table;
+	struct gdma_queue *cq = NULL;
 
-	if (id >= gc->max_num_cqs)
-		return;
+	/* IRQ reader: a stray completion can race the table publish in
+	 * mana_hwc_establish_channel(), so the acquire pairs with its
+	 * smp_store_release() to see a consistent table and bound.
+	 */
+	cq_table = smp_load_acquire(&gc->cq_table);
+	if (cq_table && cq_id < gc->max_num_cqs) {
+		cq = rcu_dereference(cq_table[cq_id]);
+		/* Fails if the CQ is being torn down. */
+		if (cq && !refcount_inc_not_zero(&cq->cq.refcount))
+			cq = NULL;
+	}
+
+	return cq;
+}
 
-	if (!gc->cq_table[id])
+static void mana_gd_put_cq(struct gdma_queue *cq)
+{
+	if (cq && refcount_dec_and_test(&cq->cq.refcount))
+		complete(&cq->cq.free);
+}
+
+int mana_gd_publish_cq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	struct gdma_queue __rcu **cq_table;
+
+	/* Only mana_gd_get_cq() (IRQ) races the table publish and needs the
+	 * acquire; this control path does not.
+	 */
+	cq_table = READ_ONCE(gc->cq_table);
+	if (!cq_table || queue->id >= gc->max_num_cqs)
+		return -EINVAL;
+
+	/* Sharing a CQ between WQs is not supported. */
+	if (rcu_access_pointer(cq_table[queue->id]))
+		return -EINVAL;
+
+	refcount_set(&queue->cq.refcount, 1);
+	init_completion(&queue->cq.free);
+	rcu_assign_pointer(cq_table[queue->id], queue);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS(mana_gd_publish_cq, "NET_MANA");
+
+void mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	struct gdma_queue __rcu **cq_table;
+
+	/* Only mana_gd_get_cq() (IRQ) races the table publish and needs the
+	 * acquire; this control path does not.
+	 */
+	cq_table = READ_ONCE(gc->cq_table);
+	if (!cq_table || queue->id >= gc->max_num_cqs ||
+	    rcu_access_pointer(cq_table[queue->id]) != queue)
 		return;
 
-	gc->cq_table[id] = NULL;
+	rcu_assign_pointer(cq_table[queue->id], NULL);
+
+	/* Drop the publish reference and wait for any handler that already
+	 * took one, so the caller can free the CQ.
+	 */
+	mana_gd_put_cq(queue);
+	wait_for_completion(&queue->cq.free);
+}
+EXPORT_SYMBOL_NS(mana_gd_unpublish_cq, "NET_MANA");
+
+static void mana_gd_destroy_cq(struct gdma_context *gc,
+			       struct gdma_queue *queue)
+{
+	mana_gd_unpublish_cq(gc, queue);
 }
 
 int mana_gd_create_hwc_queue(struct gdma_dev *gd,
@@ -1333,7 +1399,13 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 
 	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
 	mana_gd_free_memory(gmi);
-	kfree(queue);
+	/* The EQ handler may still be looking this CQ up; free it after a
+	 * grace period.
+	 */
+	if (queue->type == GDMA_CQ)
+		kfree_rcu(queue, rcu);
+	else
+		kfree(queue);
 }
 EXPORT_SYMBOL_NS(mana_gd_destroy_queue, "NET_MANA");
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e3c24d50dad07c65be9e94129dc09af9264f9f8d..b5ed2dbce6ceb7f7a5196dfe5ba3534eb4c5d330 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -674,6 +674,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
+	struct gdma_queue __rcu **cq_table;
 	int err;
 
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -698,11 +699,19 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
 
-	gc->cq_table = vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue *));
-	if (!gc->cq_table)
+	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
+	if (!cq_table)
 		return -ENOMEM;
 
-	gc->cq_table[cq->id] = cq;
+	/* Publish the initialised table; pairs with smp_load_acquire()
+	 * in mana_gd_get_cq().
+	 */
+	smp_store_release(&gc->cq_table, cq_table);
+
+	/* Publish the HWC CQ now that the table is in place. */
+	err = mana_gd_publish_cq(gc, cq);
+	if (WARN_ON(err))
+		return err;
 
 	return 0;
 }
@@ -811,6 +820,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_queue __rcu **old_cq_table;
 
 	if (!hwc)
 		return;
@@ -818,10 +828,8 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
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
@@ -832,6 +840,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->cq)
 		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
+	/* Reset only after mana_hwc_destroy_cq() has cleared the CQ table
+	 * slot, so it is not left dangling.
+	 */
+	gc->max_num_cqs = 0;
+
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
@@ -848,8 +861,10 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
 
-	vfree(gc->cq_table);
+	old_cq_table = gc->cq_table;
 	gc->cq_table = NULL;
+	/* All EQs are gone, so no EQ handler can be using the table. */
+	vfree(old_cq_table);
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 92bb55935c1c4e76e3912794eb3c4483fb331821..515b39f085c0d6519cc90a53b8d879c07e33264e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2596,13 +2596,11 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		cq->gdma_id = cq->gdma_cq->id;
 
-		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+		if (WARN_ON(mana_gd_publish_cq(gc, cq->gdma_cq))) {
 			err = -EINVAL;
 			goto out;
 		}
 
-		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
-
 		mana_create_txq_debugfs(apc, i);
 
 		set_bit(NAPI_STATE_NO_BUSY_POLL, &cq->napi.state);
@@ -2905,13 +2903,11 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	if (err)
 		goto out;
 
-	if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+	if (WARN_ON(mana_gd_publish_cq(gc, cq->gdma_cq))) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
-
 	netif_napi_add_weight_locked(ndev, &cq->napi, mana_poll, 1);
 
 	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq, ndev, rxq_idx,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0c395917b2144ec4c2faafa5d6c7de7a452f1ebf..abf243358bf82e2428478cb3cf2f387d9cd9ea28 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -333,6 +333,9 @@ struct gdma_queue {
 	u32 tail;
 	struct list_head entry;
 
+	/* For kfree_rcu(): CQs are looked up locklessly from the EQ handler. */
+	struct rcu_head rcu;
+
 	/* Extra fields specific to EQ/CQ. */
 	union {
 		struct {
@@ -352,6 +355,12 @@ struct gdma_queue {
 			void *context;
 
 			struct gdma_queue *parent; /* For CQ/EQ relationship */
+
+			/* Keep the CQ alive while the EQ handler runs its
+			 * callback; teardown waits on @free.
+			 */
+			refcount_t refcount;
+			struct completion free;
 		} cq;
 	};
 };
@@ -418,7 +427,11 @@ struct gdma_context {
 
 	/* This maps a CQ index to the queue structure. */
 	unsigned int		max_num_cqs;
-	struct gdma_queue	**cq_table;
+	/* Entries are published/cleared by CQ create/destroy and read
+	 * locklessly by the EQ handler under RCU.  max_num_cqs is the table
+	 * size; NULL means the table is torn down.
+	 */
+	struct gdma_queue __rcu	**cq_table;
 
 	/* Protect eq_test_event and test_event_eq_id  */
 	struct mutex		eq_test_event_mutex;
@@ -496,6 +509,14 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 
 void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
+/* Add a CQ to cq_table so the EQ handler can dispatch to it.  Returns
+ * -EINVAL if the id is out of range or already in use.
+ */
+int mana_gd_publish_cq(struct gdma_context *gc, struct gdma_queue *queue);
+
+/* Remove a CQ from cq_table and wait for the EQ handler to stop using it. */
+void mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue *queue);
+
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
-- 
2.43.0

