Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C19F38B7D6;
	Thu, 13 Aug 2026 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597503; cv=none; b=XbZLXKxwo9eLu+5Zst4+fjL8YQV9GIokCokzUBL3mPA3A5z9exeL8uY1zbu8O4j3EKKMwMJftZAqzbMbOJDYPwX0X1TNqwRJodgs3/iS60f8WpJhsCAwQzELS4u7QjlkGDSZJVUMXIK4gzuDnvtWXdfVoV//kPrSHSoBJ/WPSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597503; c=relaxed/simple;
	bh=EyqwwYKlioU3tUoS1UC4L/v1h+H7kqv4s/3KpwYv5Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSbrxgyAOEUKWas2mZ2lFFuQCcwwabhPE9amROZGU8VXNJC/xaUiwM4TSBIDBYlR/8yZerUuqkk8kDBj1u/aE4z7kHZzYAAsB+LegMcvHKcpncRhjW9zgAFLZjVaudvhia3I6mecPUaLwpsfZ4C/7KEEP/gEHad5tjTcS5MLoE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 6E3C520B7001; Wed, 12 Aug 2026 22:04:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E3C520B7001
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
Date: Wed, 12 Aug 2026 22:04:13 -0700
Message-ID: <20260813050418.2906468-9-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813050418.2906468-1-longli@microsoft.com>
References: <20260813050418.2906468-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct mana_rxq and struct mana_txq embed their statistics by value, so
every reconfiguration - ethtool channel count, ring size and private
flags, MTU changes, XDP attach - destroys and recreates them, resetting
the interface counters. rx_bytes can be observed going backwards:

  rx_bytes before: 4475831638
  rx_bytes after:   526629152

Move them into port-context arrays sized to max_queues and allocated for
the lifetime of the port, so a queue set can be freed without losing what
it accumulated. ndo_get_stats64() walks max_queues, so counters from
queues a later reconfiguration removed are still reported and the totals
stay monotonic. The ethtool per-queue statistics keep iterating the
current count, which is what sizes their string table.

Counters reset on detach/attach the same way before this, and are kept
across it now too; it matters more as reconfiguration is hitless and so
typically done on a live link.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 93 +++++++++++++++----
 .../ethernet/microsoft/mana/mana_ethtool.c    |  4 +-
 include/net/mana/mana.h                       | 28 ++++--
 4 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 84b1484faaec8bf411ce402538862347e68954f0..ed9ec6b8af480a303bfa9c0dd9894f5049d8b6d6 100644
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
index 2b3250483b43954c74d8cbf6a9e6e77880eac8ca..27484e5cf71a2216e7dc89c21ee0e9d95786cf30 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -381,7 +381,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx]->txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx]->tx_cq;
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 
 	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
 	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
@@ -560,7 +560,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Populated the packet and bytes counters based on post GSO packet
 	 * calculations
 	 */
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->packets += num_gso_seg;
 	tx_stats->bytes += len + ((num_gso_seg - 1) * gso_hs);
@@ -606,9 +606,9 @@ static void mana_get_stats64(struct net_device *ndev,
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
@@ -616,6 +616,12 @@ static void mana_get_stats64(struct net_device *ndev,
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
@@ -624,7 +630,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	st->rx_missed_errors = apc->ac->hc_stats.hc_rx_discards_no_wqe;
 
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -637,7 +643,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
@@ -1059,6 +1065,48 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
 	apc->rxqs = NULL;
 }
 
+/* Counters belong to the port, not the queues, so a queue-set replacement
+ * does not reset them. Sized to max_queues, allocated once.
+ *
+ * A swap adds no writer to a TX slot. RX slots do overlap briefly, since a
+ * retiring rxq keeps its NAPI until mana_free_qset() destroys it. MANA is
+ * 64-bit only, so u64_stats_sync has no seqcount and at worst a few
+ * increments are lost; the alternatives are a lock in the receive path or
+ * per-set slots that make ndo_get_stats64() dip during a swap.
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
@@ -2114,7 +2162,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = rxq->stats;
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2428,13 +2476,13 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
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
@@ -2566,8 +2614,8 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
-	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
-			  rxq->stats.bytes, &dim_sample);
+	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
+			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
 }
 
@@ -2784,7 +2832,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		/* Create SQ */
 		txq = &apc->tx_qp[i]->txq;
 
-		u64_stats_init(&txq->stats.syncp);
+		txq->stats = &apc->txq_stats[i];
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
@@ -3099,6 +3147,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
+	/* Wire up the port-owned statistics before the queue can be polled. */
+	rxq->stats = &apc->rxq_stats[rxq_idx];
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3249,7 +3299,6 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 			goto out;
 		}
 
-		u64_stats_init(&rxq->stats.syncp);
 
 		apc->rxqs[i] = rxq;
 
@@ -4555,6 +4604,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
 	}
 
+	err = mana_alloc_queue_stats(apc);
+	if (err)
+		goto free_net;
+
 	mutex_init(&apc->vport_mutex);
 	apc->vport_use_count = 0;
 
@@ -4577,7 +4630,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	err = mana_init_port(ndev);
 	if (err)
-		goto free_net;
+		goto free_stats;
 
 	err = mana_rss_table_alloc(apc);
 	if (err)
@@ -4614,6 +4667,11 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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
@@ -4954,6 +5012,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
+		mana_free_queue_stats(apc);
 
 		/* Clear the slot before the netdev goes away. A later port
 		 * whose teardown has to reset the function walks ac->ports[]
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 0daacee28001ed45a66ef00449b2c2acbf2859d4..26f5ea1f5091a7fab729ecf3468bdc13886fcccb 100644
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
index 4fcd5e307a4805b81c5c82482fc65a4ba68eea89..77cec5b44049202e21f919d4336fdf8ebc248a18 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -102,7 +102,10 @@ struct mana_stats_rx {
 	u64 pkt_len0_err;
 	u64 coalesced_cqe[MANA_CQE_COAL_PKTS_8 - 1];
 	struct u64_stats_sync syncp;
-};
+	/* Per-port array indexed by queue, so keep entries on separate cache
+	 * lines: queues polled on different CPUs would bounce a shared one.
+	 */
+} ____cacheline_aligned_in_smp;
 
 struct mana_stats_tx {
 	u64 packets;
@@ -117,7 +120,8 @@ struct mana_stats_tx {
 	u64 csum_partial;
 	u64 mana_map_err;
 	struct u64_stats_sync syncp;
-};
+	/* Per-queue array entry, same cache line reasoning as the RX side. */
+} ____cacheline_aligned_in_smp;
 
 struct mana_txq {
 	struct gdma_queue *gdma_sq;
@@ -146,14 +150,14 @@ struct mana_txq {
 	/* Value of mana_context.reset_gen when this queue was created. */
 	u32 reset_gen;
 
-	/* Set once this queue has been unpublished and is on its way out.
-	 * Its completions must not touch flow control any more: net_txq is
-	 * shared with the queue that replaced it at the same index, and a
-	 * draining queue always looks like it has room.
+	/* Unpublished and draining. Its completions must leave flow control
+	 * alone: net_txq is shared with its replacement, and a draining queue
+	 * always looks like it has room.
 	 */
 	bool retiring;
 
-	struct mana_stats_tx stats;
+	/* Points into apc->txq_stats[], which outlives the queue. */
+	struct mana_stats_tx *stats;
 };
 
 /* skb data and frags dma mappings */
@@ -415,7 +419,8 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats_rx stats;
+	/* Points into apc->rxq_stats[], which outlives the queue. */
+	struct mana_stats_rx *stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
@@ -617,6 +622,13 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
+	/* Per-queue counters, max_queues entries each. Allocated at probe and
+	 * freed at remove, never on queue teardown, so a reconfiguration does
+	 * not reset them.
+	 */
+	struct mana_stats_rx *rxq_stats;
+	struct mana_stats_tx *txq_stats;
+
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
-- 
2.43.0

