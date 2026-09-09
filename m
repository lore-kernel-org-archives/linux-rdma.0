Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08B33BBFC4;
	Wed,  9 Sep 2026 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992714; cv=none; b=kLRu/YS7Jlvr1F6wKnPVpgDeF2mzT14knYbkEArRguDK91SMPBaT72a0NQs5erXPbTsqqPRDyUHRO80b/N3rebyksihnZo26KfO5P52ZCpeX8sFCOAVr1YHtfHyH0JCenB7MWlw9DqBhSnIoaPsXktCqkkQ7K0puaotT5QN2fRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992714; c=relaxed/simple;
	bh=9Uf9LyhrOINtLa296s7pUCplA8khPJ7z3n3b2i2AnI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY55LZGD/WMBcdV1Hixt0aB3NuwxWbmVwL9yKVK7B016Gz8cFp+S8BRdwZBDxckSDiYL44XJ71QlbwUvzVbm9V0OTriwsXfIC6lTaHajJM6qkSq5osKNaQfyaxiID9PJa9918h6cauNP7IydR9JJvaW1TYfRdueyUvCqdrQcVsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 3E08820B716A; Wed,  9 Sep 2026 15:24:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E08820B716A
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
Subject: [PATCH net-next v5 01/13] net: mana: add queue-set allocation and teardown helpers
Date: Wed,  9 Sep 2026 15:24:04 -0700
Message-ID: <20260909222416.884246-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260909222416.884246-1-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add queue-set allocation and teardown helpers using a scratch port
context, without releasing the vport. These prepare the reconfiguration
paths to retain their running queues if replacement allocation fails.

Extract the TX drain, retaining pcie_flr(). On reset failure, leave
pending TX SKBs mapped; this does not prevent subsequent ring and RX
teardown. Track successful drain-initiated resets and request best-effort
sibling rebuilds, without reinitializing the HWC. Clear removed ports
from ac->ports[] before those walks can reach them.

The new queue-set helpers have no callers yet.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5:
  - Rebase onto current net-next and refresh the mana_bpf.c hunk
    context after upstream 8d5f1bda7e8b removed the dead return.
    No functional changes.

Changes in v4:
  - Retain pcie_flr() and its existing failure log instead of the
    trylock-based PCI reset helper.
  - Clarify drain/reset limitations and shorten lifecycle comments.

 .../net/ethernet/microsoft/mana/mana_bpf.c    |  24 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 338 +++++++++++++++---
 include/net/mana/mana.h                       |  38 ++
 3 files changed, 353 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 70bb8c9dc34136409154bd733e08d0c2bc7f779e..29b8d61cad229d07898fd7725181e0133978ce5b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -262,3 +262,27 @@ int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 		return -EOPNOTSUPP;
 	}
 }
+
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
+/* Keep the per-queue program pointers until RX polling stops. */
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
index 7a1ac853e3abcd28c4a1e5c6987ec631a18ad840..5ac3ae9fd7ea2f786dddbd21d340884c008e1020 100644
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
@@ -3009,11 +3011,11 @@ static int mana_push_wqe(struct mana_rxq *rxq)
 
 static int mana_create_page_pool(struct mana_rxq *rxq, struct gdma_context *gc)
 {
-	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
 	struct page_pool_params pprm = {};
 	int ret;
 
-	pprm.pool_size = mpc->rx_queue_size / rxq->frag_count + 1;
+	/* Size the pool for this RX queue, not the live configuration. */
+	pprm.pool_size = rxq->num_rx_buf / rxq->frag_count + 1;
 	pprm.nid = gc->numa_node;
 	pprm.napi = &rxq->rx_cq.napi;
 	pprm.netdev = rxq->ndev;
@@ -3679,15 +3681,88 @@ int mana_attach(struct net_device *ndev)
 	return 0;
 }
 
-static int mana_dealloc_queues(struct net_device *ndev)
+/* Drain with a per-set timeout; return true only for a successful FLR. A false
+ * return does not guarantee DMA quiescence.
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
+		/* A previous function reset invalidated these queues. */
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
+			err = pcie_flr(to_pci_dev(gc->dev));
+			if (err) {
+				netdev_err(apc->ndev,
+					   "flr failed %d with %d pkts pending in txq %u\n",
+					   err,
+					   atomic_read(&txq->pending_sends),
+					   txq->gdma_txq_id);
+				quiesced = false;
+			} else {
+				/* Invalidate queues on every port after the
+				 * function reset.
+				 */
+				WRITE_ONCE(apc->ac->reset_gen,
+					   apc->ac->reset_gen + 1);
+
+				reset = true;
+			}
+			break;
+		}
+	}
+
+	/* A failed FLR cannot justify unmapping pending TX buffers. */
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
@@ -3698,48 +3773,21 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	if (gd->gdma_context->is_pf && !apc->ac->bm_hostmode)
 		mana_pf_deregister_filter(apc);
 
-	/* No packet can be transmitted now since apc->port_is_up is false.
-	 * There is still a tiny chance that mana_poll_tx_cq() can re-enable
-	 * a txq because it may not timely see apc->port_is_up being cleared
-	 * to false, but it doesn't matter since mana_start_xmit() drops any
-	 * new packets due to apc->port_is_up being false.
-	 *
-	 * Drain all the in-flight TX packets.
-	 * A timeout of 120 seconds for all the queues is used.
-	 * This will break the while loop when h/w is not responding.
-	 * This value of 120 has been decided here considering max
-	 * number of queues.
-	 */
+	/* After FLR, schedule a best-effort sibling-port rebuild. */
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
 
@@ -3763,6 +3811,198 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	return 0;
 }
 
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
+/* Vport identity and port debugfs outlive queue sets. */
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
+/* Copy the vport identity without borrowing the live queues. */
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
+	scratch->eqs		= NULL;
+	scratch->tx_qp		= NULL;
+	scratch->rxqs		= NULL;
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+	scratch->default_rxobj	= INVALID_MANA_HANDLE;
+	scratch->mana_eqs_debugfs = NULL;
+
+	/* Do not consume the live set's pre-allocated RX buffers. */
+	scratch->rxbufs_pre	= NULL;
+	scratch->das_pre	= NULL;
+	scratch->rxbpre_total	= 0;
+
+	/* Suppress debugfs names that would collide with the live set. */
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
+/* Under RTNL, free only queues no longer shared with the installed set. */
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
+	if (qset->tx_qp) {
+		unsigned int q;
+
+		for (q = 0; q < qset->num_queues; q++) {
+			if (qset->tx_qp[q])
+				WRITE_ONCE(qset->tx_qp[q]->txq.retiring, true);
+		}
+	}
+
+	/* Keep retired queues and arrays through this grace period; local NAPI
+	 * synchronization does not drain other devices' XDP.
+	 */
+	synchronize_net();
+
+	mana_qset_install(scratch, qset);
+
+	/* Keep retiring RXQs' XDP programs and references until RX teardown. */
+	retiring_prog = mana_chn_xdp_peek(scratch);
+	retiring_queues = scratch->num_queues;
+
+	/* Drain TX before unmapping RX buffers. */
+	if (mana_drain_txqs(scratch)) {
+		/* FLR also destroys the HWC; rebuilding ports is best-effort.
+		 * This path does not reinitialize the device.
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
+	/* Fence RQs before unmapping, but teardown proceeds on errors. */
+	mana_fence_rqs(scratch);
+
+	mana_destroy_rxqs(scratch);
+
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
 int mana_detach(struct net_device *ndev, bool from_close)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -4240,6 +4480,10 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
 
+		/* Remove the port from reset walks before freeing its netdev.
+		 */
+		ac->ports[i] = NULL;
+
 		rtnl_unlock();
 
 		free_netdev(ndev);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 83b7eff4646ead7aef1382c6ce565a573a940af4..4c00a98430262b6c8c25bc37c9d1c8b48d928629 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -143,6 +143,11 @@ struct mana_txq {
 
 	bool napi_initialized;
 
+	u32 reset_gen;
+
+	/* Suppress completion wakeups on the replacement's netdev queue. */
+	bool retiring;
+
 	struct mana_stats_tx stats;
 };
 
@@ -537,6 +542,12 @@ struct mana_context {
 	u8 bm_hostmode;
 
 	struct mana_ethtool_hc_stats hc_stats;
+
+	/* Generation of successful resets issued by mana_drain_txqs(), under
+	 * RTNL.
+	 */
+	u32 reset_gen;
+
 	struct workqueue_struct *per_port_queue_reset_wq;
 	/* Workqueue for querying hardware stats */
 	struct delayed_work gf_stats_work;
@@ -661,6 +672,23 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
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
@@ -670,6 +698,14 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
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
@@ -685,6 +721,8 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
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
