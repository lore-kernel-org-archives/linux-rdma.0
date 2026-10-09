Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3999A4E50A4;
	Fri,  9 Oct 2026 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556901; cv=none; b=KsCB2COGGQXVy7KBo3bXjcf3TGMpfkdqgrzvvEwn6GXCLpX5XNj8txjLZYbwINWWM8PWPMjomVGHj8pv7XxyjuHI7/CsCTeGd4hMgv4iRxpJz/EhEKOJEH30KLuZDIE8NE269K6u1Hz8XQAACXOc14/C5zd9kHUeXIHoFMeNn/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556901; c=relaxed/simple;
	bh=lWywrtAzq0jky5Psq6IH5czdsn5k4yg6XEYE1b6D590=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epWMDaDn65/t5hCwpvlV7RRN83OIDkKfJZIGuo5Fd1WsBThpoDm86PXnKJVmh+yEvphXQoOeAO8snnr9f3jIEkiW33l9Oc4Qfg+Z7baYfRUiX2lShJw4rjHQpCmpH+D6OYPoNc/pRhzJ2ADISOkFVeuqXk6KF+vux+YCvMViw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=SrzQ9JA+; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="SrzQ9JA+"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3F49D20B716B;
	Fri,  9 Oct 2026 07:41:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F49D20B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556898;
	bh=a49O+xZ80MR9z8X+a8AUopyEp5Mx+lmZKdpxPJcQBFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrzQ9JA+h85fY0kZFhWMNi5cTDukBYx1bkwbAUTMZA7lrfehxtp3HSRKvDfeyK+b4
	 8iOvOD8qxC0awE29xfgfYSai1BaKn6JQpGybb1JFIPqX+qLr/rYY4Dm6m7EDKTA/yS
	 W+5zqBicS0Sgs4RjTdYxQ1oYSx3XTm4wVLOkd910=
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
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 02/13] net: mana: share the EQ pool across a queue-set swap
Date: Fri,  9 Oct 2026 14:41:13 +0000
Message-ID: <5e46da0c96a1dd7c39ae856deccc82cd98ac1af5.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Make the EQ pool port-owned so overlapping queue sets share EQs instead
of requiring old + new vector allocations. Allocate max_queues slots and
track populated entries with num_eqs.

Grow the pool before creating replacement CQs. Additional EQs survive
allocation failure in this patch and are released at port teardown.

Initialize EQ callbacks, context, owner phase and throttle before IRQ
publication, so a live shared IRQ cannot observe an uninitialized EQ.
Preserve the existing hardware-create and unwind ordering.

A shared EQ also outlives individual CQs. After stopping a CQ's NAPI and
work and tearing down its WQ object, flush its actual parent EQ while the
CQ callback remains published. Remove only that CQ's table entry and wait
for RCU IRQ readers before freeing the CQ and its callback owner.

Pair the IRQ lookup with release publication at all CQ publishers. For
Ethernet, publish only after NAPI and DIM initialization. The HWC and RDMA
sites need the matching stores, not changes to their teardown or recovery
policies.

The EQ markers and reader waits are control-path costs; the IRQ lookup
uses an acquire load without new validity checks. Report failed markers
using the existing error-logging convention. This does not add a reset or
reclamation policy for arbitrary failed hardware commands.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c               |   3 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  22 ++--
 .../net/ethernet/microsoft/mana/hw_channel.c  |   3 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 115 ++++++++++++++----
 include/net/mana/mana.h                       |   6 +-
 5 files changed, 113 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d4e5e3f91268..0b6ad2547e0e 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -155,7 +155,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gdma_cq->type = GDMA_CQ;
 	gdma_cq->cq.callback = mana_ib_cq_handler;
 	gdma_cq->id = cq->queue.id;
-	gc->cq_table[cq->queue.id] = gdma_cq;
+	/* Pairs with the acquire load in mana_gd_process_eqe(). */
+	smp_store_release(&gc->cq_table[cq->queue.id], gdma_cq);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 8e9bfc1d6a2a..a7a491156f64 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -925,7 +925,8 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
 			break;
 
-		cq = gc->cq_table[cq_id];
+		/* Match release publication of the CQ and its callback state. */
+		cq = smp_load_acquire(&gc->cq_table[cq_id]);
 		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
 			break;
 
@@ -1187,17 +1188,17 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
 		return -EINVAL;
 	}
 
+	queue->eq.callback = spec->eq.callback;
+	queue->eq.context = spec->eq.context;
+	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
+	queue->eq.log2_throttle_limit = spec->eq.log2_throttle_limit ?: 1;
+
 	err = mana_gd_register_irq(queue, spec);
 	if (err) {
 		dev_err(dev, "Failed to register irq: %d\n", err);
 		return err;
 	}
 
-	queue->eq.callback = spec->eq.callback;
-	queue->eq.context = spec->eq.context;
-	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
-	queue->eq.log2_throttle_limit = spec->eq.log2_throttle_limit ?: 1;
-
 	if (create_hwq) {
 		err = mana_gd_create_hw_eq(gc, queue);
 		if (err)
@@ -1232,13 +1233,12 @@ static void mana_gd_destroy_cq(struct gdma_context *gc,
 {
 	u32 id = queue->id;
 
-	if (id >= gc->max_num_cqs)
+	if (id >= gc->max_num_cqs || !gc->cq_table)
 		return;
 
-	if (!gc->cq_table[id])
-		return;
-
-	gc->cq_table[id] = NULL;
+	/* Leave a reused ID alone, but still drain readers of this CQ. */
+	cmpxchg(&gc->cq_table[id], queue, NULL);
+	synchronize_rcu();
 }
 
 int mana_gd_create_hwc_queue(struct gdma_dev *gd,
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 3bca4b683134..aefb8646cd79 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -702,7 +702,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (!gc->cq_table)
 		return -ENOMEM;
 
-	gc->cq_table[cq->id] = cq;
+	/* Pairs with the acquire load in mana_gd_process_eqe(). */
+	smp_store_release(&gc->cq_table[cq->id], cq);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d4b8bb4e1f53..45cb23717151 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1733,7 +1733,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 	debugfs_remove_recursive(apc->mana_eqs_debugfs);
 	apc->mana_eqs_debugfs = NULL;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = 0; i < apc->num_eqs; i++) {
 		eq = apc->eqs[i].eq;
 		if (!eq)
 			continue;
@@ -1745,6 +1745,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 
 	kfree(apc->eqs);
 	apc->eqs = NULL;
+	apc->num_eqs = 0;
 }
 EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
@@ -1773,9 +1774,11 @@ int mana_create_eq(struct mana_port_context *apc)
 
 	if (WARN_ON(apc->eqs))
 		return -EEXIST;
-	apc->eqs = kzalloc_objs(struct mana_eq, apc->num_queues);
+	/* Keep EQ array addresses stable while CQs reference them. */
+	apc->eqs = kzalloc_objs(struct mana_eq, apc->max_queues);
 	if (!apc->eqs)
 		return -ENOMEM;
+	apc->num_eqs = 0;
 
 	spec.type = GDMA_EQ;
 	spec.monitor_avl_buf = false;
@@ -1805,6 +1808,7 @@ int mana_create_eq(struct mana_port_context *apc)
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
 		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
 	}
 
 	return 0;
@@ -1814,6 +1818,61 @@ int mana_create_eq(struct mana_port_context *apc)
 }
 EXPORT_SYMBOL_NS(mana_create_eq, "NET_MANA");
 
+/* Grow the shared EQ pool without replacing live entries. */
+static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
+{
+	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_context *gc = gd->gdma_context;
+	struct gdma_queue_spec spec = {};
+	struct gdma_irq_context *gic;
+	unsigned int i;
+	int err;
+	int msi;
+
+	if (WARN_ON(!apc->eqs))
+		return -EINVAL;
+
+	if (need > apc->max_queues)
+		return -EINVAL;
+
+	if (need <= apc->num_eqs)
+		return 0;
+
+	spec.type = GDMA_EQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = EQ_SIZE;
+	spec.eq.callback = NULL;
+	spec.eq.context = apc->eqs;
+	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
+
+	for (i = apc->num_eqs; i < need; i++) {
+		msi = (i + 1) % gc->num_msix_usable;
+
+		gic = mana_gd_get_gic(gc, !gc->msi_sharing, &msi);
+		if (IS_ERR(gic)) {
+			err = PTR_ERR(gic);
+			goto out;
+		}
+		spec.eq.msix_index = msi;
+
+		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
+		if (err) {
+			dev_err(gc->dev, "Failed to grow EQ %u : %d\n", i, err);
+			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+			goto out;
+		}
+		apc->eqs[i].eq->eq.irq = gic->irq;
+		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
+	}
+
+	return 0;
+out:
+	/* Retain partial growth for reuse; the live set still needs this pool.
+	 */
+	return err;
+}
+
 static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
 {
 	struct mana_fence_rq_resp resp = {};
@@ -2624,12 +2683,25 @@ static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
 
 static void mana_deinit_cq(struct mana_port_context *apc, struct mana_cq *cq)
 {
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
+	struct gdma_queue *gdma_cq = cq->gdma_cq;
+	struct gdma_queue *eq;
+	int err;
 
-	if (!cq->gdma_cq)
+	if (!gdma_cq)
 		return;
 
-	mana_gd_destroy_queue(gd->gdma_context, cq->gdma_cq);
+	eq = gdma_cq->cq.parent;
+	if (gdma_cq->id < gc->max_num_cqs && eq &&
+	    eq->id != INVALID_QUEUE_ID) {
+		/* Flush queued events after WQ teardown, before removing this CQ. */
+		err = mana_gd_test_eq(gc, eq);
+		if (err && mana_en_need_log(apc, err))
+			netdev_err(apc->ndev, "Failed to flush EQ %u for CQ %u: %d\n",
+				   eq->id, gdma_cq->id, err);
+	}
+
+	mana_gd_destroy_queue(gc, gdma_cq);
 }
 
 static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
@@ -2824,8 +2896,6 @@ static int mana_create_txq(struct mana_port_context *apc,
 			goto out;
 		}
 
-		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
-
 		mana_create_txq_debugfs(apc, i);
 
 		set_bit(NAPI_STATE_NO_BUSY_POLL, &cq->napi.state);
@@ -2840,6 +2910,9 @@ static int mana_create_txq(struct mana_port_context *apc,
 		napi_enable_locked(&cq->napi);
 		txq->napi_initialized = true;
 
+		/* Publish the initialized NAPI/DIM state to the EQ handler. */
+		smp_store_release(&gc->cq_table[cq->gdma_id], cq->gdma_cq);
+
 		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 	}
 
@@ -3150,8 +3223,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		goto out;
 	}
 
-	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
-
 	netif_napi_add_weight_locked(ndev, &cq->napi, mana_poll, 1);
 
 	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq, ndev, rxq_idx,
@@ -3167,6 +3238,9 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	napi_enable_locked(&cq->napi);
 
+	/* Publish the initialized NAPI/DIM state to the EQ handler. */
+	smp_store_release(&gc->cq_table[cq->gdma_id], cq->gdma_cq);
+
 	mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 out:
 	if (!err)
@@ -3771,7 +3845,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 static void mana_qset_snapshot(const struct mana_port_context *ctx,
 			       struct mana_qset *out)
 {
-	out->eqs		= ctx->eqs;
 	out->tx_qp		= ctx->tx_qp;
 	out->rxqs		= ctx->rxqs;
 	out->indir_table	= ctx->indir_table;
@@ -3788,7 +3861,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
-	ctx->eqs		= qset->eqs;
 	ctx->tx_qp		= qset->tx_qp;
 	ctx->rxqs		= qset->rxqs;
 	ctx->indir_table	= qset->indir_table;
@@ -3801,7 +3873,9 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->priv_flags		= qset->priv_flags;
 }
 
-/* Copy the vport identity without borrowing the live queues. */
+/* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
+ * mana_destroy_eq() on it.
+ */
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 {
 	struct mana_port_context *scratch;
@@ -3812,13 +3886,11 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 
 	*scratch = *apc;
 
-	scratch->eqs		= NULL;
 	scratch->tx_qp		= NULL;
 	scratch->rxqs		= NULL;
 	scratch->indir_table	= NULL;
 	scratch->rxobj_table	= NULL;
 	scratch->default_rxobj	= INVALID_MANA_HANDLE;
-	scratch->mana_eqs_debugfs = NULL;
 
 	/* Do not consume the live set's pre-allocated RX buffers. */
 	scratch->rxbufs_pre	= NULL;
@@ -3836,7 +3908,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 	kvfree(scratch);
 }
 
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out)
 {
@@ -3858,13 +3931,16 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	if (err)
 		goto cleanup_rxq_array;
 
-	err = mana_create_eq(scratch);
+	err = mana_grow_eqs(apc, num_queues);
 	if (err)
 		goto cleanup_rss;
 
+	scratch->eqs = apc->eqs;
+	scratch->num_eqs = apc->num_eqs;
+
 	err = mana_create_txq(scratch, ndev);
 	if (err)
-		goto cleanup_eq;
+		goto cleanup_rss;
 
 	err = mana_add_rx_queues(scratch, ndev);
 	if (err)
@@ -3878,8 +3954,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 cleanup_rxq:
 	mana_destroy_rxqs(scratch);
 	mana_destroy_txq(scratch);
-cleanup_eq:
-	mana_destroy_eq(scratch);
 cleanup_rss:
 	mana_cleanup_indir_table(scratch);
 cleanup_rxq_array:
@@ -3899,7 +3973,7 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	ASSERT_RTNL();
 
-	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+	if (!qset->rxqs && !qset->tx_qp)
 		return;
 
 	if (qset->tx_qp) {
@@ -3933,7 +4007,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_chn_xdp_release(retiring_prog, retiring_queues);
 
 	mana_destroy_txq(scratch);
-	mana_destroy_eq(scratch);
 	mana_cleanup_indir_table(scratch);
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 6a407b34fd68..d3a79e13e343 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -563,7 +563,9 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
+	/* Port-owned EQ pool: max_queues slots, num_eqs populated. */
 	struct mana_eq *eqs;
+	unsigned int num_eqs;
 	struct dentry *mana_eqs_debugfs;
 
 	enum TRI_STATE rss_state;
@@ -666,7 +668,6 @@ struct mana_port_context {
 };
 
 struct mana_qset {
-	struct mana_eq		*eqs;
 	struct mana_tx_qp	**tx_qp;
 	struct mana_rxq		**rxqs;
 
@@ -694,7 +695,8 @@ int mana_detach(struct net_device *ndev, bool from_close);
 struct mana_port_context *
 mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out);
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
