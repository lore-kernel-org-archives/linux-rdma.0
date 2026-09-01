Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42216393DF5;
	Tue,  1 Sep 2026 01:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227128; cv=none; b=FGdP24HH2BRxj57UxQaNOvySOTGiokgR8qlr716aUT2rw38Z/eWnUyb4oKBtKenKYTvLlJtLlRQckzLXNyQSXInEiDKpXm5OO23Khn4jAfluMreebtthEdGoh30xCih5/wG6EaSmq2SGdCvmB71QYzWeUweDuGRK+mXodk9uKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227128; c=relaxed/simple;
	bh=eGFjKp6+XaqVM6o7oMt9Yc7h7H+PrUkZ1TQR1tj4/Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOG567OWfkpvgfRvXIMMcfh6YrqJ2i9w3bKX4Mz5elHouDLLXUC/Ey/ut8CvF3q1gXUNzpQ0/2g7AFrBuzqDV54BT0I945jZroaVKR98jN1EQuoUoeagm5C9yNKZPgf/2+ZXXsDATj04RCr/4BeFZJGVgxHLUDBgEuVY9ueo5SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7906120B710C; Mon, 31 Aug 2026 18:44:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7906120B710C
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
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 01/13] net: mana: add queue-set allocation and teardown helpers
Date: Mon, 31 Aug 2026 18:44:30 -0700
Message-ID: <20260901014442.2945689-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901014442.2945689-1-longli@microsoft.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ethtool reconfiguration paths (channel count, ring size, private
flags), mana_change_mtu() and mana_xdp_set() rebuild the queues with
mana_detach() then mana_attach(). That tears the vport down, so RDMA can
claim it while released, and a failed mana_attach() leaves the port down
with no way back but manual intervention.

Add the data model and helpers for pre-allocate and swap: a queue set
built, published and torn down independently of the vport, against a
scratch port context so the live one never points at queues still being
built or freed. Building in place is not an option: mana_start_xmit()
dereferences apc->tx_qp[] guarded only by apc->port_is_up.

The TX drain moves out of mana_dealloc_queues() so the new teardown path
gets it too, and its fallback reset becomes pci_try_reset_function()
rather than an open-coded pcie_flr(), which does not save and restore
config space. Trylock because this runs under RTNL while removal takes
the device lock first.

No functional change otherwise: nothing calls the new helpers yet.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  31 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 448 ++++++++++++++++--
 include/net/mana/mana.h                       |  53 +++
 3 files changed, 493 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 53308e139cbe917b074dd381c83546fc74d7b79f..ca602e27044f92b87295cbc2de924adc71efa780 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -265,3 +265,34 @@ int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 
 	return ret;
 }
+
+/* Read the XDP program a queue set is running, without changing anything. */
+struct bpf_prog *mana_chn_xdp_peek(struct mana_port_context *apc)
+{
+	ASSERT_RTNL();
+
+	if (!apc->rxqs || !apc->rxqs[0])
+		return NULL;
+
+	return rtnl_dereference(apc->rxqs[0]->bpf_prog);
+}
+
+/* Drop the per-queue references a retiring set holds on @prog.
+ *
+ * Kept separate from mana_chn_setxdp() so the pointers can stay in place
+ * until the queues stop polling: clearing them up front would let packets
+ * already sitting in a retiring RQ take the pass path and reach the stack
+ * without the program ever seeing them.
+ */
+void mana_chn_xdp_release(struct bpf_prog *prog, unsigned int num_queues)
+{
+	unsigned int i;
+
+	ASSERT_RTNL();
+
+	if (!prog)
+		return;
+
+	for (i = 0; i < num_queues; i++)
+		bpf_prog_put(prog);
+}
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7a1ac853e3abcd28c4a1e5c6987ec631a18ad840..b9d9543d1a6dc90b01f6ca378b8a32bd045d6da8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2018,7 +2018,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
-	if (txq_stopped && apc->port_is_up && avail_space >= MAX_TX_WQE_SIZE) {
+	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
+	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
 		apc->eth_stats.wake_queue++;
 	}
@@ -2754,6 +2755,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		u64_stats_init(&txq->stats.syncp);
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
+		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
 		txq->vp_offset = apc->tx_vp_offset;
 		txq->napi_initialized = false;
 		skb_queue_head_init(&txq->pending_skbs);
@@ -3009,11 +3011,14 @@ static int mana_push_wqe(struct mana_rxq *rxq)
 
 static int mana_create_page_pool(struct mana_rxq *rxq, struct gdma_context *gc)
 {
-	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
 	struct page_pool_params pprm = {};
 	int ret;
 
-	pprm.pool_size = mpc->rx_queue_size / rxq->frag_count + 1;
+	/* Size the recycle ring from the queue being built, not from the live
+	 * port context: during a swap the queue may be sized for a ring the
+	 * running configuration does not use yet.
+	 */
+	pprm.pool_size = rxq->num_rx_buf / rxq->frag_count + 1;
 	pprm.nid = gc->numa_node;
 	pprm.napi = &rxq->rx_cq.napi;
 	pprm.netdev = rxq->ndev;
@@ -3679,15 +3684,115 @@ int mana_attach(struct net_device *ndev)
 	return 0;
 }
 
-static int mana_dealloc_queues(struct net_device *ndev)
+/* Drain a set about to be destroyed: nothing new can reach it, so wait for the
+ * hardware to finish what it owns, then release every mapped SKB.
+ *
+ * The 120s budget is shared across all queues. On timeout the device is reset,
+ * since its buffers are about to be freed while it may still DMA into them; if
+ * that fails too they are leaked.
+ *
+ * Returns true only if a reset happened, taking every queue on the function
+ * down with it.
+ */
+static bool mana_drain_txqs(struct mana_port_context *apc)
 {
-	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned long timeout = jiffies + 120 * HZ;
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
+	bool quiesced = true;
+	bool reset = false;
 	struct mana_txq *txq;
 	struct sk_buff *skb;
-	int i, err;
 	u32 tsleep;
+	int i, err;
+
+	if (!apc->tx_qp)
+		return false;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		txq = &apc->tx_qp[i]->txq;
+
+		/* The function was reset after this queue was created, so the
+		 * device has stopped touching its buffers and the completions
+		 * waited for below can never arrive. Without this the port
+		 * would burn the full timeout under RTNL, then reset the
+		 * function again on the way out.
+		 */
+		if (READ_ONCE(apc->ac->reset_gen) != txq->reset_gen)
+			continue;
+
+		tsleep = 1000;
+		while (atomic_read(&txq->pending_sends) > 0 &&
+		       time_before(jiffies, timeout)) {
+			usleep_range(tsleep, tsleep + 1000);
+			tsleep <<= 1;
+		}
+		if (atomic_read(&txq->pending_sends)) {
+			/* The device still owns these buffers, so reset it
+			 * before they are freed. pci_try_reset_function()
+			 * rather than pcie_flr(): it saves and restores config
+			 * space, which a bare FLR wipes behind the PCI core's
+			 * back. Trylock because RTNL is held here while the
+			 * remove path takes the device lock first.
+			 */
+			err = pci_try_reset_function(to_pci_dev(gc->dev));
+			if (err) {
+				netdev_err(apc->ndev,
+					   "function reset failed: %d, %d pkts pending in txq %u\n",
+					   err,
+					   atomic_read(&txq->pending_sends),
+					   txq->gdma_txq_id);
+				quiesced = false;
+			} else {
+				/* Every queue on the function is dead now,
+				 * including the ones this loop has not reached
+				 * and those of the other ports.
+				 */
+				WRITE_ONCE(apc->ac->reset_gen,
+					   apc->ac->reset_gen + 1);
+
+				/* Only a reset that actually happened takes the
+				 * other ports down with it; reporting a failed
+				 * one would rebuild them for nothing.
+				 */
+				reset = true;
+			}
+			break;
+		}
+	}
+
+	/* Only a reset that actually happened makes freeing these safe; without
+	 * one the device still owns them. Leak instead, bounded at one SQ ring
+	 * of skbs per queue.
+	 */
+	if (!quiesced) {
+		netdev_err(apc->ndev,
+			   "device not quiesced, leaking pending TX buffers instead of unmapping memory it can still DMA from\n");
+		return reset;
+	}
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		txq = &apc->tx_qp[i]->txq;
+		while ((skb = skb_dequeue(&txq->pending_skbs))) {
+			mana_unmap_skb(skb, apc);
+			dev_kfree_skb_any(skb);
+		}
+		atomic_set(&txq->pending_sends, 0);
+	}
+
+	return reset;
+}
+
+static int mana_dealloc_queues(struct net_device *ndev)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	struct gdma_dev *gd = apc->ac->gdma_dev;
+	int err;
 
 	if (apc->port_is_up)
 		return -EINVAL;
@@ -3705,41 +3810,27 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	 * new packets due to apc->port_is_up being false.
 	 *
 	 * Drain all the in-flight TX packets.
-	 * A timeout of 120 seconds for all the queues is used.
-	 * This will break the while loop when h/w is not responding.
-	 * This value of 120 has been decided here considering max
-	 * number of queues.
+	 *
+	 * If the drain had to reset the function to get there, every other
+	 * port on the adapter lost its queues too, so schedule them for a
+	 * rebuild. This port is being torn down here and needs no such
+	 * treatment, and a down port stays down: with port_st_save false,
+	 * detach and attach both skip the queue work.
 	 */
+	if (mana_drain_txqs(apc)) {
+		struct mana_context *ac = apc->ac;
+		unsigned int i;
 
-	if (apc->tx_qp) {
-		for (i = 0; i < apc->num_queues; i++) {
-			txq = &apc->tx_qp[i]->txq;
-			tsleep = 1000;
-			while (atomic_read(&txq->pending_sends) > 0 &&
-			       time_before(jiffies, timeout)) {
-				usleep_range(tsleep, tsleep + 1000);
-				tsleep <<= 1;
-			}
-			if (atomic_read(&txq->pending_sends)) {
-				err =
-				    pcie_flr(to_pci_dev(gd->gdma_context->dev));
-				if (err) {
-					netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
-						   err,
-					    atomic_read(&txq->pending_sends),
-					    txq->gdma_txq_id);
-				}
-				break;
-			}
-		}
+		for (i = 0; i < ac->num_ports; i++) {
+			struct mana_port_context *sib;
 
-		for (i = 0; i < apc->num_queues; i++) {
-			txq = &apc->tx_qp[i]->txq;
-			while ((skb = skb_dequeue(&txq->pending_skbs))) {
-				mana_unmap_skb(skb, apc);
-				dev_kfree_skb_any(skb);
-			}
-			atomic_set(&txq->pending_sends, 0);
+			if (!ac->ports[i] || ac->ports[i] == ndev)
+				continue;
+			sib = netdev_priv(ac->ports[i]);
+			netdev_err(ac->ports[i],
+				   "queues reset by a sibling port, scheduling rebuild\n");
+			queue_work(ac->per_port_queue_reset_wq,
+				   &sib->queue_reset_work);
 		}
 	}
 
@@ -3763,6 +3854,278 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	return 0;
 }
 
+/*
+ * Pre-allocate and swap reconfiguration.
+ *
+ * Build a new queue set while the current one serves traffic, publish it, then
+ * destroy the old one. A failed allocation leaves the running config untouched,
+ * and the vport is never torn down, so RDMA cannot take it mid-swap. The cost
+ * is room for both sets at once, so a rebuild at the vport's maximum queue
+ * count can be refused, and both sets' EQs - and so their MSI-X vectors - are
+ * live at once.
+ *
+ * Everything builds in a scratch mana_port_context, since mana_start_xmit()
+ * dereferences apc->tx_qp[] guarded only by port_is_up. Per-queue debugfs is
+ * suppressed meanwhile, as the names would collide.
+ */
+
+/* Snapshot the queue-set fields of @ctx into @out. */
+static void mana_qset_snapshot(const struct mana_port_context *ctx,
+			       struct mana_qset *out)
+{
+	out->eqs		= ctx->eqs;
+	out->tx_qp		= ctx->tx_qp;
+	out->rxqs		= ctx->rxqs;
+	out->indir_table	= ctx->indir_table;
+	out->indir_table_sz	= ctx->indir_table_sz;
+	out->rxobj_table	= ctx->rxobj_table;
+	out->default_rxobj	= ctx->default_rxobj;
+	out->num_queues		= ctx->num_queues;
+	out->rx_queue_size	= ctx->rx_queue_size;
+	out->tx_queue_size	= ctx->tx_queue_size;
+	out->priv_flags		= ctx->priv_flags;
+}
+
+/* Install @qset's fields onto @ctx. The vport (port_handle,
+ * vport_use_count) and the port-level debugfs dir are deliberately not
+ * touched: they outlive any individual queue set.
+ */
+static void mana_qset_install(struct mana_port_context *ctx,
+			      const struct mana_qset *qset)
+{
+	ctx->eqs		= qset->eqs;
+	ctx->tx_qp		= qset->tx_qp;
+	ctx->rxqs		= qset->rxqs;
+	ctx->indir_table	= qset->indir_table;
+	ctx->indir_table_sz	= qset->indir_table_sz;
+	ctx->rxobj_table	= qset->rxobj_table;
+	ctx->default_rxobj	= qset->default_rxobj;
+	ctx->num_queues		= qset->num_queues;
+	ctx->rx_queue_size	= qset->rx_queue_size;
+	ctx->tx_queue_size	= qset->tx_queue_size;
+	ctx->priv_flags		= qset->priv_flags;
+}
+
+/**
+ * mana_qset_scratch_alloc - build a scratch port context for queue work
+ * @apc: the live port context to shadow
+ *
+ * Builds a heap copy of @apc that shares its vport identity but owns no
+ * queues, so the existing allocators and destroyers can run against it
+ * without touching the live context.
+ *
+ * Return: the scratch context, or NULL if it could not be allocated.
+ */
+struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
+{
+	struct mana_port_context *scratch;
+
+	scratch = kvzalloc_obj(*scratch, GFP_KERNEL);
+	if (!scratch)
+		return NULL;
+
+	*scratch = *apc;
+
+	/* Owns no queues yet. */
+	scratch->eqs		= NULL;
+	scratch->tx_qp		= NULL;
+	scratch->rxqs		= NULL;
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+	scratch->default_rxobj	= INVALID_MANA_HANDLE;
+	scratch->mana_eqs_debugfs = NULL;
+
+	/* Never consume the live set's pre-allocated RX buffers; the swap path
+	 * has no post-teardown allocation to de-risk.
+	 */
+	scratch->rxbufs_pre	= NULL;
+	scratch->das_pre	= NULL;
+	scratch->rxbpre_total	= 0;
+
+	/* Two sets are alive at once and would collide on the same names under
+	 * vport%d. An IS_ERR() parent makes every create and remove a no-op.
+	 */
+	scratch->mana_port_debugfs = ERR_PTR(-ENODEV);
+
+	return scratch;
+}
+
+void mana_qset_scratch_free(struct mana_port_context *scratch)
+{
+	kvfree(scratch);
+}
+
+/* Build a queue set in @scratch, sized and configured from the arguments. The
+ * installed set keeps serving traffic meanwhile. On error nothing is left
+ * allocated.
+ */
+int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+		    unsigned int rx_queue_size, unsigned int tx_queue_size,
+		    u32 priv_flags, struct mana_qset *out)
+{
+	struct net_device *ndev = scratch->ndev;
+	int err;
+
+	ASSERT_RTNL();
+
+	scratch->num_queues	= num_queues;
+	scratch->rx_queue_size	= rx_queue_size;
+	scratch->tx_queue_size	= tx_queue_size;
+	scratch->priv_flags	= priv_flags;
+
+	err = mana_init_port_context(scratch);
+	if (err)
+		goto out_err;
+
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		goto cleanup_rxq_array;
+
+	err = mana_create_eq(scratch);
+	if (err)
+		goto cleanup_rss;
+
+	err = mana_create_txq(scratch, ndev);
+	if (err)
+		goto cleanup_eq;
+
+	err = mana_add_rx_queues(scratch, ndev);
+	if (err)
+		goto cleanup_rxq;
+
+	mana_rss_table_init(scratch);
+
+	mana_qset_snapshot(scratch, out);
+	return 0;
+
+cleanup_rxq:
+	/* mana_add_rx_queues() may have created queues before failing; they
+	 * own RQ/CQ objects, NAPI state and page pools, so tear down whatever
+	 * made it into scratch->rxqs[] before dropping the array.
+	 */
+	mana_destroy_rxqs(scratch);
+	mana_destroy_txq(scratch);
+cleanup_eq:
+	mana_destroy_eq(scratch);
+cleanup_rss:
+	mana_cleanup_indir_table(scratch);
+cleanup_rxq_array:
+	kfree(scratch->rxqs);
+	scratch->rxqs = NULL;
+out_err:
+	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
+		   num_queues, err);
+	return err;
+}
+
+/* Tear down @qset, no longer installed on @apc, against @scratch so the live
+ * context never points at queues being freed.
+ */
+void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
+{
+	struct bpf_prog *retiring_prog;
+	unsigned int retiring_queues;
+
+	ASSERT_RTNL();
+
+	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+		return;
+
+	/* Keep their completions off the netdev queues they now share. */
+	if (qset->tx_qp) {
+		unsigned int q;
+
+		for (q = 0; q < qset->num_queues; q++) {
+			if (qset->tx_qp[q])
+				WRITE_ONCE(qset->tx_qp[q]->txq.retiring, true);
+		}
+	}
+
+	/* The datapath gates on apc->port_is_up and then dereferences
+	 * apc->tx_qp[] / apc->rxqs[] with no lock. The publish step drains
+	 * those readers before it installs the incoming set, which cannot
+	 * cover one that sampled the retiring pointers between that install
+	 * and the gate reopening. mana_xdp_xmit() is the case that matters:
+	 * it runs from a redirecting device's NAPI, so the napi_synchronize()
+	 * that mana_destroy_txq()/mana_destroy_rxq() do on this port's own
+	 * NAPIs never waits for it. Give any such reader a grace period to
+	 * finish before its queues are torn down under it. Every caller is a
+	 * reconfiguration path holding RTNL, so this is expedited.
+	 */
+	synchronize_net();
+
+	mana_qset_install(scratch, qset);
+
+	/* Note what this set owes the XDP program, but leave the queues
+	 * pointing at it. They are still polling, and a packet already in a
+	 * retiring RQ has to keep running the program rather than slip past
+	 * it into the stack. The references are dropped once the queues are
+	 * gone, below. XDP_TX from those polls is harmless here: it goes
+	 * through mana_start_xmit() on the live port context, so it reaches
+	 * the queue set that replaced this one, not the one being drained.
+	 */
+	retiring_prog = mana_chn_xdp_peek(scratch);
+	retiring_queues = scratch->num_queues;
+
+	/* The retiring TX queues may still hold packets the device has not
+	 * completed. Drain them before the SQs and the SKB queues go away,
+	 * or those SKBs and their DMA mappings are leaked.
+	 *
+	 * This runs before any RX teardown, the order mana_dealloc_queues()
+	 * uses. A device wedged badly enough to need the reset below is also
+	 * one whose RQ teardown will not complete, and unmapping RX buffers
+	 * first would leave it free to keep writing into them for as long as
+	 * the drain takes.
+	 */
+	if (mana_drain_txqs(scratch)) {
+		/* The drain had to reset the function to stop the device
+		 * touching those buffers. A function reset takes down every
+		 * port on the adapter, not just this one, so rebuild them all
+		 * - the same recovery mana_tx_timeout() relies on. A port that
+		 * is already down has nothing to rebuild and its handler
+		 * leaves it down.
+		 */
+		struct mana_port_context *apc = netdev_priv(scratch->ndev);
+		struct mana_context *ac = apc->ac;
+		struct mana_port_context *sib;
+		unsigned int i;
+
+		netdev_err(scratch->ndev,
+			   "device reset while retiring a queue set, scheduling port reset\n");
+
+		for (i = 0; i < ac->num_ports; i++) {
+			if (!ac->ports[i])
+				continue;
+			sib = netdev_priv(ac->ports[i]);
+			queue_work(ac->per_port_queue_reset_wq,
+				   &sib->queue_reset_work);
+		}
+	}
+
+	/* Traffic was still being steered at these queues moments ago, so
+	 * fence each retiring RQ before its buffers are unmapped, again the
+	 * order mana_dealloc_queues() uses. mana_destroy_rxq() does destroy
+	 * the hardware RQ before unmapping anything, but the fence is what
+	 * makes the device confirm it is done with the buffers first.
+	 */
+	mana_fence_rqs(scratch);
+
+	mana_destroy_rxqs(scratch);
+
+	/* The queues are gone, so nothing can run the program any more. */
+	mana_chn_xdp_release(retiring_prog, retiring_queues);
+
+	mana_destroy_txq(scratch);
+	mana_destroy_eq(scratch);
+	mana_cleanup_indir_table(scratch);
+	kfree(scratch->rxqs);
+	scratch->rxqs = NULL;
+
+	memset(qset, 0, sizeof(*qset));
+}
+
+/* --- end of pre-allocate + swap reconfiguration path ---------------------- */
+
 int mana_detach(struct net_device *ndev, bool from_close)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -4240,6 +4603,13 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
 
+		/* Clear the slot before the netdev goes away. A later port
+		 * whose teardown has to reset the function walks ac->ports[]
+		 * to schedule the rebuild, and would otherwise reach into the
+		 * port freed here.
+		 */
+		ac->ports[i] = NULL;
+
 		rtnl_unlock();
 
 		free_netdev(ndev);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 83b7eff4646ead7aef1382c6ce565a573a940af4..356aaa652fa6f8d3498383e2b7c976da677cfa22 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -143,6 +143,16 @@ struct mana_txq {
 
 	bool napi_initialized;
 
+	/* Value of mana_context.reset_gen when this queue was created. */
+	u32 reset_gen;
+
+	/* Set once this queue has been unpublished and is on its way out.
+	 * Its completions must not touch flow control any more: net_txq is
+	 * shared with the queue that replaced it at the same index, and a
+	 * draining queue always looks like it has room.
+	 */
+	bool retiring;
+
 	struct mana_stats_tx stats;
 };
 
@@ -537,6 +547,14 @@ struct mana_context {
 	u8 bm_hostmode;
 
 	struct mana_ethtool_hc_stats hc_stats;
+
+	/* Bumped on every PCI function reset. A queue created before the
+	 * current value can no longer be reached by the device, so its buffers
+	 * need no drain. All access is under RTNL: the bump is a non-atomic
+	 * read-modify-write, so a second writer would lose an increment.
+	 */
+	u32 reset_gen;
+
 	struct workqueue_struct *per_port_queue_reset_wq;
 	/* Workqueue for querying hardware stats */
 	struct delayed_work gf_stats_work;
@@ -661,6 +679,27 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
+/* The queue-related fields of mana_port_context that can be swapped as a
+ * unit. The vport (port_handle, vport_use_count) is not part of it and is
+ * never touched by a swap.
+ */
+struct mana_qset {
+	struct mana_eq		*eqs;
+	struct mana_tx_qp	**tx_qp;
+	struct mana_rxq		**rxqs;
+
+	u32			*indir_table;
+	u32			indir_table_sz;
+	mana_handle_t		*rxobj_table;
+	mana_handle_t		default_rxobj;
+
+	unsigned int		num_queues;
+	unsigned int		rx_queue_size;
+	unsigned int		tx_queue_size;
+	u32			priv_flags;
+
+};
+
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
@@ -670,6 +709,18 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
+/* Pre-allocate + swap reconfiguration. Allocation and teardown run against a
+ * scratch context, so the live port context is only ever mutated with TX
+ * disabled.
+ */
+struct mana_port_context *
+mana_qset_scratch_alloc(struct mana_port_context *apc);
+void mana_qset_scratch_free(struct mana_port_context *scratch);
+int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+		    unsigned int rx_queue_size, unsigned int tx_queue_size,
+		    u32 priv_flags, struct mana_qset *out);
+void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
 int mana_probe(struct gdma_dev *gd, bool resuming);
@@ -685,6 +736,8 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
 void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
+struct bpf_prog *mana_chn_xdp_peek(struct mana_port_context *apc);
+void mana_chn_xdp_release(struct bpf_prog *prog, unsigned int num_queues);
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int mana_query_gf_stats(struct mana_context *ac);
 int mana_query_link_cfg(struct mana_port_context *apc);
-- 
2.43.0

