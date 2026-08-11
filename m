Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A57D3F823D;
	Tue, 11 Aug 2026 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430143; cv=none; b=JlUF9vRQs7LM2NOHJbtUceEOL8j0V0uYb/Rjj8v8G8mg6HEKD3gtOi5yHJ8/T0WbsFanfC6yflXrDDoSKvzBIfK57uEDxVJW5VFL5UzqmQfeL/BSYRxxiBDnXMl9VVwUoNH7wCXawNLYP9E8dx+wxJnKvefNK/NjFl4TnxgKOcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430143; c=relaxed/simple;
	bh=dG90SXT+My8YjCzgmbD/VDRKGHse36hyIJphb3YY6pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INwR/XI0zAWomnXlL7EnmMwWbHBH3M9/QBPBtikSVHFRJ19HWfZuTrp9rUyibRxFGugppv98UpzH8zvLs86B1lcnitFvo9KKtYijp+iM3jQgAzi73h0QTYhd2TD7akaOG+CQ1CY5mhTihbSpVe0ynlcf18khTzV9i0M2bjUHPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 4D97320B7138; Mon, 10 Aug 2026 23:35:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D97320B7138
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
Subject: [PATCH net-next v2 08/13] net: mana: keep per-queue statistics in the port context
Date: Mon, 10 Aug 2026 23:35:05 -0700
Message-ID: <20260811063506.2428213-9-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063506.2428213-1-longli@microsoft.com>
References: <20260811063506.2428213-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct mana_rxq and struct mana_txq embed their statistics by value, and
mana_get_stats64()/mana_get_ethtool_stats() read them through
apc->rxqs[q] and apc->tx_qp[q]. The queues are destroyed and recreated
by every reconfiguration - ethtool channel count, ring size and private
flags, MTU changes and XDP attach - so the interface counters are reset
each time and rx_bytes/tx_bytes can be observed going backwards:

  rx_bytes before: 4475831638
  rx_bytes after:   526629152

Move the statistics into arrays owned by the port context, sized to
max_queues, allocated in mana_probe_port() and freed in mana_remove().
The queues keep pointers into those arrays, so a queue set can be freed
without losing the counters it accumulated.

mana_get_stats64() now walks max_queues rather than num_queues, so
counters accumulated on queues that a later reconfiguration removed are
still reported and the totals stay monotonic. The ethtool per-queue
statistics keep iterating num_queues, since mana_get_sset_count() sizes
the string table the same way.

Note this is not specific to the queue-set swap: the detach/attach path
reset the counters in exactly the same way. It matters more now only
because reconfiguration is hitless and therefore likely to be done on a
live link.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 112 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |   4 +-
 include/net/mana/mana.h                       |  27 ++++-
 4 files changed, 122 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1a6a490a84f2e5b4c9895645ff6f40beb55f497c..ff953cbfda0ea8b27d18367fd8047d2183f3591b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -75,7 +75,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 		count++;
 	}
 
-	tx_stats = &apc->tx_qp[q_idx]->txq.stats;
+	tx_stats = apc->tx_qp[q_idx]->txq.stats;
 
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->xdp_xmit += count;
@@ -102,7 +102,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
-	rx_stats = &rxq->stats;
+	rx_stats = rxq->stats;
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 89d5215db160572f633e32711f251a6b1d82b276..60ea12e7e866385688c9095759e7c03f28c7771f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -386,7 +386,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx]->txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx]->tx_cq;
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 
 	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
 	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
@@ -565,7 +565,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Populated the packet and bytes counters based on post GSO packet
 	 * calculations
 	 */
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->packets += num_gso_seg;
 	tx_stats->bytes += len + ((num_gso_seg - 1) * gso_hs);
@@ -611,9 +611,9 @@ static void mana_get_stats64(struct net_device *ndev,
 			     struct rtnl_link_stats64 *st)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
-	unsigned int num_queues = apc->num_queues;
 	struct mana_stats_rx *rx_stats;
 	struct mana_stats_tx *tx_stats;
+	unsigned int num_queues;
 	unsigned int start;
 	u64 packets, bytes;
 	int q;
@@ -621,6 +621,12 @@ static void mana_get_stats64(struct net_device *ndev,
 	if (!apc->port_is_up)
 		return;
 
+	/* Walk every slot, not just the queues currently open: counters
+	 * accumulated on queues that a later reconfiguration removed must
+	 * still be reported, or the interface totals would go backwards.
+	 */
+	num_queues = apc->max_queues;
+
 	netdev_stats_to_stats64(st, &ndev->stats);
 
 	if (apc->ac->hwc_timeout_occurred)
@@ -629,7 +635,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	st->rx_missed_errors = apc->ac->hc_stats.hc_rx_discards_no_wqe;
 
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -642,7 +648,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
@@ -1069,6 +1075,67 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
 	apc->rxqs = NULL;
 }
 
+/* Allocate the port-owned per-queue counters.
+ *
+ * Per-queue statistics are owned by the port context, not by the queues, so
+ * that a queue-set replacement (ethtool channel/ring/priv-flag change, MTU
+ * change, XDP attach) does not reset the interface counters. Sized to
+ * max_queues and allocated once.
+ *
+ * A swap adds no writer to a TX slot: mana_start_xmit() and mana_xdp_xmit()
+ * reach a txq only through apc->tx_qp[], and mana_publish_qset() swaps that
+ * array behind netif_tx_disable() and synchronize_net(), so a retiring txq
+ * can no longer be reached once the new set is installed. Those two callers
+ * can still race each other on one slot, but that is the existing lockless
+ * ndo_xdp_xmit() arrangement and not a consequence of replacing a queue set.
+ *
+ * The RX slots do overlap briefly. A retiring rxq keeps its NAPI until
+ * mana_free_qset() destroys it, so between mana_config_rss() steering onto
+ * the new RQs and that teardown, both generations at one index can update the
+ * same slot. MANA is 64-bit only, so u64_stats_sync carries no seqcount and
+ * there is nothing to corrupt; at worst a couple of increments are lost.
+ * Exposing counters that survive a rebuild is worth that.
+ *
+ * Closing that window is deliberately not worth it. Serialising the writers
+ * would put a lock in the per-packet receive path to protect a counter, and
+ * giving each queue set its own slots to merge later would make
+ * ndo_get_stats64() report a dip for the duration of the swap - the totals
+ * going backwards is the very thing this is meant to prevent, and a worse
+ * artefact than the occasional lost increment.
+ */
+static int mana_alloc_queue_stats(struct mana_port_context *apc)
+{
+	unsigned int i;
+
+	apc->rxq_stats = kcalloc(apc->max_queues, sizeof(*apc->rxq_stats),
+				 GFP_KERNEL);
+	if (!apc->rxq_stats)
+		return -ENOMEM;
+
+	apc->txq_stats = kcalloc(apc->max_queues, sizeof(*apc->txq_stats),
+				 GFP_KERNEL);
+	if (!apc->txq_stats) {
+		kfree(apc->rxq_stats);
+		apc->rxq_stats = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < apc->max_queues; i++) {
+		u64_stats_init(&apc->rxq_stats[i].syncp);
+		u64_stats_init(&apc->txq_stats[i].syncp);
+	}
+
+	return 0;
+}
+
+static void mana_free_queue_stats(struct mana_port_context *apc)
+{
+	kfree(apc->rxq_stats);
+	apc->rxq_stats = NULL;
+	kfree(apc->txq_stats);
+	apc->txq_stats = NULL;
+}
+
 static void mana_cleanup_indir_table(struct mana_port_context *apc)
 {
 	apc->indir_table_sz = 0;
@@ -2127,7 +2194,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = rxq->stats;
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2441,13 +2508,13 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	 * Coalesced CQEs have at least 2 packets, so index is pkt_i - 2.
 	 */
 	if (pkt_i > 1) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.coalesced_cqe[pkt_i - 2]++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		u64_stats_update_begin(&rxq->stats->syncp);
+		rxq->stats->coalesced_cqe[pkt_i - 2]++;
+		u64_stats_update_end(&rxq->stats->syncp);
 	} else if (!pkt_i && !pktlen) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.pkt_len0_err++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		u64_stats_update_begin(&rxq->stats->syncp);
+		rxq->stats->pkt_len0_err++;
+		u64_stats_update_end(&rxq->stats->syncp);
 		netdev_err_once(ndev,
 				"RX pkt len=0, rq=%u, cq=%u, rxobj=0x%llx\n",
 				rxq->gdma_id, cq->gdma_id, rxq->rxobj);
@@ -2579,8 +2646,8 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
-	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
-			  rxq->stats.bytes, &dim_sample);
+	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
+			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
 }
 
@@ -2797,7 +2864,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		/* Create SQ */
 		txq = &apc->tx_qp[i]->txq;
 
-		u64_stats_init(&txq->stats.syncp);
+		txq->stats = &apc->txq_stats[i];
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
@@ -3112,6 +3179,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
+	/* Wire up the port-owned statistics before the queue can be polled. */
+	rxq->stats = &apc->rxq_stats[rxq_idx];
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3262,7 +3331,6 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 			goto out;
 		}
 
-		u64_stats_init(&rxq->stats.syncp);
 
 		apc->rxqs[i] = rxq;
 
@@ -4712,6 +4780,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
 	}
 
+	err = mana_alloc_queue_stats(apc);
+	if (err)
+		goto free_net;
+
 	mutex_init(&apc->vport_mutex);
 	apc->vport_use_count = 0;
 
@@ -4734,7 +4806,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	err = mana_init_port(ndev);
 	if (err)
-		goto free_net;
+		goto free_stats;
 
 	err = mana_rss_table_alloc(apc);
 	if (err)
@@ -4771,6 +4843,11 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	mana_cleanup_indir_table(apc);
 reset_apc:
 	mana_cleanup_port_context(apc);
+free_stats:
+	/* The counter arrays are separate allocations, so free_netdev() does
+	 * not release them with the port context.
+	 */
+	mana_free_queue_stats(apc);
 free_net:
 	*ndev_storage = NULL;
 	netdev_err(ndev, "Failed to probe vPort %d: %d\n", port_idx, err);
@@ -5111,6 +5188,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
+		mana_free_queue_stats(apc);
 
 		/* Clear the slot before the netdev goes away. A later port
 		 * whose teardown has to reset the function walks ac->ports[]
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 2cadd0f0d74e358c1b670dd6980603e0358918eb..4c8799a2be86ca1f7e52cb23f6fb71afdf38acb5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -271,7 +271,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		data[i++] = *(u64 *)(phy_stats + mana_phy_stats[q].offset);
 
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -296,7 +296,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index bc9808f826f83df26c7af98daa181d91b7d2661d..32035605c70c66299b9f9707924ee267fa63cd9a 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -102,7 +102,11 @@ struct mana_stats_rx {
 	u64 pkt_len0_err;
 	u64 coalesced_cqe[MANA_CQE_COAL_PKTS_8 - 1];
 	struct u64_stats_sync syncp;
-};
+	/* Kept in a per-port array indexed by queue, so give each entry its
+	 * own cache line. Without it two queues polled on different CPUs
+	 * would share one, and every packet would bounce it between them.
+	 */
+} ____cacheline_aligned_in_smp;
 
 struct mana_stats_tx {
 	u64 packets;
@@ -117,7 +121,8 @@ struct mana_stats_tx {
 	u64 csum_partial;
 	u64 mana_map_err;
 	struct u64_stats_sync syncp;
-};
+	/* Per-queue array entry, same cache line reasoning as the RX side. */
+} ____cacheline_aligned_in_smp;
 
 struct mana_txq {
 	struct gdma_queue *gdma_sq;
@@ -153,7 +158,10 @@ struct mana_txq {
 	 */
 	bool retiring;
 
-	struct mana_stats_tx stats;
+	/* Points into apc->txq_stats[]. Owned by the port context, not by
+	 * this queue, so counters survive queue-set replacement.
+	 */
+	struct mana_stats_tx *stats;
 };
 
 /* skb data and frags dma mappings */
@@ -415,7 +423,10 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats_rx stats;
+	/* Points into apc->rxq_stats[]. Owned by the port context, not by
+	 * this queue, so counters survive queue-set replacement.
+	 */
+	struct mana_stats_rx *stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
@@ -618,6 +629,14 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
+	/* Per-queue statistics, max_queues entries each. Allocated once at
+	 * probe and freed at remove, never on queue teardown, so counters
+	 * are not reset by an ethtool/MTU/XDP reconfiguration. The queues
+	 * point into these arrays.
+	 */
+	struct mana_stats_rx *rxq_stats;
+	struct mana_stats_tx *txq_stats;
+
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
-- 
2.43.0

