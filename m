Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BC23C4172;
	Tue,  1 Sep 2026 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227137; cv=none; b=a6q3AkfyvqRKCOsFPTISgcyqVkChSnNLmnBtgUT4NwWgPDAQmkelmvEVVSEWYROH1uBZuQy1SxbNsquVMYb8wfGZ+p0cLrSkJMNdkU3YCvd3i5gfLR5o+p7M6ehvRUvTdXZKRAygykyeZSFYapaunWE6lyqobNekBjzaC7VLDv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227137; c=relaxed/simple;
	bh=hBZc7ByABU9EfZGrQupXcsUd76d/j8iGz0DLS7h/uP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbPC64vlh+qOabDQp0ee8/LPKz3n5GFPHmtXSK8HcGcSdm90jILJhNK3FQ5y6aFwCcnKnBk4ZiuGdVFyvh6lIwxNVv6JE0LYnQkZCcZvGIkiLvkaM14gEgij6jjOZLx+YLx1v9cycq0Ki7ft4E2gHqy1ZF8DZjoCTCAA2ebeacI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id EDE2D20B700D; Mon, 31 Aug 2026 18:44:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EDE2D20B700D
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
Subject: [PATCH net-next v3 09/13] net: mana: keep per-queue statistics in the port context
Date: Mon, 31 Aug 2026 18:44:38 -0700
Message-ID: <20260901014442.2945689-10-longli@microsoft.com>
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
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 248 ++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  37 ++-
 include/net/mana/mana.h                       |  58 +++-
 4 files changed, 308 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index d2093625956bbef30d0d6c63121de8363b633489..0981327c284413f8a0e93856939a4b3c0f632d80 100644
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
+	rx_stats = mana_rxq_stats(rxq);
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5c5d1edd20f84d0d1a20d2a5bc0ecefea0d7aaed..69e34fab8fe8ead53ecac5820ab4932c84af5371 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -414,7 +414,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx]->txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx]->tx_cq;
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 
 	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
 	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
@@ -593,7 +593,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Populated the packet and bytes counters based on post GSO packet
 	 * calculations
 	 */
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->packets += num_gso_seg;
 	tx_stats->bytes += len + ((num_gso_seg - 1) * gso_hs);
@@ -639,9 +639,9 @@ static void mana_get_stats64(struct net_device *ndev,
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
@@ -649,6 +649,12 @@ static void mana_get_stats64(struct net_device *ndev,
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
@@ -656,8 +662,22 @@ static void mana_get_stats64(struct net_device *ndev,
 
 	st->rx_missed_errors = apc->ac->hc_stats.hc_rx_discards_no_wqe;
 
+	/* The live queue at each index and whatever retired there both count,
+	 * so add the two slots.
+	 */
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
+
+		do {
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
+
+		st->rx_packets += packets;
+		st->rx_bytes += bytes;
+
+		rx_stats = &apc->rxq_stats_ret[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -670,7 +690,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
@@ -1092,6 +1112,122 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
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
+	apc->rxq_stats_ret = kcalloc(apc->max_queues,
+				     sizeof(*apc->rxq_stats_ret), GFP_KERNEL);
+	if (!apc->rxq_stats_ret)
+		goto free_rxq_stats;
+
+	apc->txq_stats = kcalloc(apc->max_queues, sizeof(*apc->txq_stats),
+				 GFP_KERNEL);
+	if (!apc->txq_stats)
+		goto free_rxq_stats_ret;
+
+	for (i = 0; i < apc->max_queues; i++) {
+		u64_stats_init(&apc->rxq_stats[i].syncp);
+		u64_stats_init(&apc->rxq_stats_ret[i].syncp);
+		u64_stats_init(&apc->txq_stats[i].syncp);
+	}
+
+	return 0;
+
+free_rxq_stats_ret:
+	kfree(apc->rxq_stats_ret);
+	apc->rxq_stats_ret = NULL;
+free_rxq_stats:
+	kfree(apc->rxq_stats);
+	apc->rxq_stats = NULL;
+	return -ENOMEM;
+}
+
+static void mana_free_queue_stats(struct mana_port_context *apc)
+{
+	kfree(apc->rxq_stats);
+	apc->rxq_stats = NULL;
+	kfree(apc->rxq_stats_ret);
+	apc->rxq_stats_ret = NULL;
+	kfree(apc->txq_stats);
+	apc->txq_stats = NULL;
+}
+
+/* Add what @rxq counted while retiring to the per-index total. Must run under
+ * RTNL with the queue no longer writing to @drain_stats, so this is the only
+ * writer of the retired slot.
+ *
+ * Clears @drain_stats as it goes: a queue that survives a failed swap resumes
+ * counting into its live slot, and must not have these counts folded a second
+ * time when it is eventually destroyed.
+ */
+static void mana_fold_rxq_stats(struct mana_port_context *apc,
+				struct mana_rxq *rxq)
+{
+	struct mana_stats_rx *src = &rxq->drain_stats;
+	struct mana_stats_rx *dst;
+	unsigned int i;
+
+	ASSERT_RTNL();
+
+	if (!apc->rxq_stats_ret || rxq->rxq_idx >= apc->max_queues)
+		return;
+
+	dst = &apc->rxq_stats_ret[rxq->rxq_idx];
+
+	u64_stats_update_begin(&dst->syncp);
+	dst->packets		+= src->packets;
+	dst->bytes		+= src->bytes;
+	dst->xdp_drop		+= src->xdp_drop;
+	dst->xdp_tx		+= src->xdp_tx;
+	dst->xdp_redirect	+= src->xdp_redirect;
+	dst->pkt_len0_err	+= src->pkt_len0_err;
+	for (i = 0; i < ARRAY_SIZE(dst->coalesced_cqe); i++)
+		dst->coalesced_cqe[i] += src->coalesced_cqe[i];
+	u64_stats_update_end(&dst->syncp);
+
+	src->packets		= 0;
+	src->bytes		= 0;
+	src->xdp_drop		= 0;
+	src->xdp_tx		= 0;
+	src->xdp_redirect	= 0;
+	src->pkt_len0_err	= 0;
+	for (i = 0; i < ARRAY_SIZE(src->coalesced_cqe); i++)
+		src->coalesced_cqe[i] = 0;
+}
+
+/* Publish what every queue in @qset counted while it was marked retiring.
+ * For a set that is being destroyed this happens queue by queue; a set handed
+ * back by a failed swap needs it done in one pass, before it serves again.
+ */
+static void mana_fold_qset_rx_stats(struct mana_port_context *apc,
+				    struct mana_qset *qset)
+{
+	unsigned int q;
+
+	if (!qset->rxqs)
+		return;
+
+	for (q = 0; q < qset->num_queues; q++) {
+		if (qset->rxqs[q])
+			mana_fold_rxq_stats(apc, qset->rxqs[q]);
+	}
+}
+
 static void mana_cleanup_indir_table(struct mana_port_context *apc)
 {
 	apc->indir_table_sz = 0;
@@ -2220,7 +2356,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = mana_rxq_stats(rxq);
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2453,6 +2589,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct net_device *ndev = rxq->ndev;
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
+	struct mana_stats_rx *rx_stats;
 	struct device *dev = gc->dev;
 	bool coalesced_8 = false;
 	bool coalesced = false;
@@ -2534,13 +2671,15 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	 * Coalesced CQEs have at least 2 packets, so index is pkt_i - 2.
 	 */
 	if (pkt_i > 1) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.coalesced_cqe[pkt_i - 2]++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		rx_stats = mana_rxq_stats(rxq);
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->coalesced_cqe[pkt_i - 2]++;
+		u64_stats_update_end(&rx_stats->syncp);
 	} else if (!pkt_i && !pktlen) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.pkt_len0_err++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		rx_stats = mana_rxq_stats(rxq);
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->pkt_len0_err++;
+		u64_stats_update_end(&rx_stats->syncp);
 		netdev_err_once(ndev,
 				"RX pkt len=0, rq=%u, cq=%u, rxobj=0x%llx\n",
 				rxq->gdma_id, cq->gdma_id, rxq->rxobj);
@@ -2672,8 +2811,15 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
-	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
-			  rxq->stats.bytes, &dim_sample);
+	/* A retiring queue counts elsewhere and is about to be destroyed, so
+	 * there is no moderation left to tune and its samples would step off
+	 * the shared slot onto a counter that restarts at zero.
+	 */
+	if (READ_ONCE(rxq->retiring))
+		return;
+
+	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
+			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
 }
 
@@ -2890,7 +3036,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		/* Create SQ */
 		txq = &apc->tx_qp[i]->txq;
 
-		u64_stats_init(&txq->stats.syncp);
+		txq->stats = &apc->txq_stats[i];
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
@@ -3017,6 +3163,11 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		netif_napi_del_locked(napi);
 	}
 
+	/* No poller left, so this is the last chance to keep what the queue
+	 * counted after it stopped being the live one.
+	 */
+	mana_fold_rxq_stats(apc, rxq);
+
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
@@ -3205,6 +3356,9 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
+	/* Wire up the port-owned statistics before the queue can be polled. */
+	rxq->stats = &apc->rxq_stats[rxq_idx];
+	u64_stats_init(&rxq->drain_stats.syncp);
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3355,8 +3509,6 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 			goto out;
 		}
 
-		u64_stats_init(&rxq->stats.syncp);
-
 		apc->rxqs[i] = rxq;
 
 		mana_create_rxq_debugfs(apc, i);
@@ -4230,16 +4382,33 @@ static void mana_start_txqs(struct mana_port_context *apc)
  * A queue both sets own must end up unmarked, so callers mark the leaving set
  * first and unmark the incoming one second.
  */
-static void mana_qset_set_retiring(struct mana_qset *qset, bool retiring)
+static void mana_qset_set_retiring(struct mana_qset *qset,
+				   const struct mana_qset *keep, bool retiring)
 {
 	unsigned int q;
 
-	if (!qset->tx_qp)
-		return;
-
 	for (q = 0; q < qset->num_queues; q++) {
-		if (qset->tx_qp[q])
+		if (qset->tx_qp && qset->tx_qp[q])
 			WRITE_ONCE(qset->tx_qp[q]->txq.retiring, retiring);
+
+		if (!qset->rxqs || !qset->rxqs[q])
+			continue;
+
+		/* A queue @keep carries over serves the same index before and
+		 * after, so it stays the live writer of that index. Marking it
+		 * would strand the counts it takes during the swap in
+		 * drain_stats, which only mana_destroy_rxq() drains.
+		 */
+		if (retiring && keep && q < keep->num_queues &&
+		    keep->rxqs && keep->rxqs[q] == qset->rxqs[q])
+			continue;
+
+		/* Send this queue's counters to its own storage rather than
+		 * the shared per-index slot, which its replacement is about
+		 * to own. The caller's synchronize_net() makes the change
+		 * visible before that replacement can receive.
+		 */
+		WRITE_ONCE(qset->rxqs[q]->retiring, retiring);
 	}
 }
 
@@ -4327,7 +4496,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	 * the gate reopens, or it could wake a netdev queue that its
 	 * replacement had stopped on a full ring.
 	 */
-	mana_qset_set_retiring(out_old, true);
+	mana_qset_set_retiring(out_old, newq, true);
 
 	/* Wait out any transmit or ndo_xdp_xmit() that was already past the
 	 * port_is_up test before the swap touches apc->tx_qp / the counts,
@@ -4338,7 +4507,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	/* Anything the incoming set carries over is staying, so clear the flag
 	 * again - after the marking above, before the gate reopens.
 	 */
-	mana_qset_set_retiring(newq, false);
+	mana_qset_set_retiring(newq, NULL, false);
 
 	mana_qset_install(apc, newq);
 	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
@@ -4384,8 +4553,23 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	/* The roles are swapped now: @newq is the set going away and @out_old
 	 * is live again. Same ordering rule, leaving set first.
 	 */
-	mana_qset_set_retiring(newq, true);
-	mana_qset_set_retiring(out_old, false);
+	mana_qset_set_retiring(newq, out_old, true);
+
+	/* Same grace period as the forward path: a poll that sampled the flag
+	 * before the line above must finish before @out_old is unmarked, or
+	 * both sets would briefly count into apc->rxq_stats[].
+	 */
+	synchronize_net();
+
+	mana_qset_set_retiring(out_old, NULL, false);
+
+	/* @out_old counted into drain_stats while it was marked, and it is
+	 * about to serve again rather than be destroyed, so nothing else
+	 * would ever publish those packets. Fold them now, once the polls
+	 * that still saw the flag above have finished writing.
+	 */
+	synchronize_net();
+	mana_fold_qset_rx_stats(apc, out_old);
 
 	mana_qset_install(apc, out_old);
 	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
@@ -4647,6 +4831,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
 	}
 
+	err = mana_alloc_queue_stats(apc);
+	if (err)
+		goto free_net;
+
 	mutex_init(&apc->vport_mutex);
 	apc->vport_use_count = 0;
 
@@ -4669,7 +4857,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	err = mana_init_port(ndev);
 	if (err)
-		goto free_net;
+		goto free_stats;
 
 	err = mana_rss_table_alloc(apc);
 	if (err)
@@ -4706,6 +4894,11 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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
@@ -5046,6 +5239,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
+		mana_free_queue_stats(apc);
 
 		/* Clear the slot before the netdev goes away. A later port
 		 * whose teardown has to reset the function walks ac->ports[]
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 82bfd22cfe820c17aea66d6d3f6289165bf32894..4d7e64b1d32d9eca5fc006e13941f72f2176a131 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -242,6 +242,12 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	u64 xdp_tx;
 	u64 pkt_len0_err;
 	u64 coalesced_cqe[MANA_CQE_COAL_PKTS_8 - 1];
+	u64 ret_coalesced_cqe[MANA_CQE_COAL_PKTS_8 - 1];
+	u64 ret_packets, ret_bytes;
+	u64 ret_xdp_redirect;
+	u64 ret_pkt_len0_err;
+	u64 ret_xdp_drop;
+	u64 ret_xdp_tx;
 	u64 tso_packets;
 	u64 tso_bytes;
 	u64 tso_inner_packets;
@@ -271,7 +277,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		data[i++] = *(u64 *)(phy_stats + mana_phy_stats[q].offset);
 
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -285,6 +291,33 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 				coalesced_cqe[j] = rx_stats->coalesced_cqe[j];
 		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
+		/* Same index, counted by queues that have since retired. Read
+		 * into its own snapshot, since a retry must not add twice.
+		 */
+		rx_stats = &apc->rxq_stats_ret[q];
+
+		do {
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
+			ret_packets = rx_stats->packets;
+			ret_bytes = rx_stats->bytes;
+			ret_xdp_drop = rx_stats->xdp_drop;
+			ret_xdp_tx = rx_stats->xdp_tx;
+			ret_xdp_redirect = rx_stats->xdp_redirect;
+			ret_pkt_len0_err = rx_stats->pkt_len0_err;
+			for (j = 0; j < MANA_CQE_COAL_PKTS_8 - 1; j++)
+				ret_coalesced_cqe[j] =
+					rx_stats->coalesced_cqe[j];
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
+
+		packets += ret_packets;
+		bytes += ret_bytes;
+		xdp_drop += ret_xdp_drop;
+		xdp_tx += ret_xdp_tx;
+		xdp_redirect += ret_xdp_redirect;
+		pkt_len0_err += ret_pkt_len0_err;
+		for (j = 0; j < MANA_CQE_COAL_PKTS_8 - 1; j++)
+			coalesced_cqe[j] += ret_coalesced_cqe[j];
+
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
@@ -296,7 +329,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 61d136736cf6c455a132d7297badf5ab15b4693d..9a43856760776fb2c23786bbdbb36fdbe5d2be81 100644
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
@@ -415,7 +419,23 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats_rx stats;
+	/* Points into apc->rxq_stats[], which outlives the queue. Only the
+	 * live queue at this index writes there; once retiring is set this
+	 * queue counts into drain_stats instead, so the slot has one writer.
+	 * Use mana_rxq_stats() rather than either directly.
+	 */
+	struct mana_stats_rx *stats;
+
+	/* Set under RTNL before a different queue takes over this index. A
+	 * queue carried across a swap keeps serving its index and is never
+	 * marked.
+	 */
+	bool retiring;
+
+	/* What this queue counted after it stopped being the live one.
+	 * Folded into apc->rxq_stats_ret[] when the queue is destroyed.
+	 */
+	struct mana_stats_rx drain_stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
@@ -623,6 +643,19 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
+	/* Per-queue counters, max_queues entries each. Allocated at probe and
+	 * freed at remove, never on queue teardown, so a reconfiguration does
+	 * not reset them.
+	 *
+	 * rxq_stats[] is written by the live RX queue at that index and
+	 * rxq_stats_ret[] only under RTNL, by mana_destroy_rxq() folding in
+	 * what a retiring queue counted while it drained. One writer each;
+	 * readers add the two.
+	 */
+	struct mana_stats_rx *rxq_stats;
+	struct mana_stats_rx *rxq_stats_ret;
+	struct mana_stats_tx *txq_stats;
+
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
@@ -747,6 +780,15 @@ int mana_detach(struct net_device *ndev, bool from_close);
 struct mana_port_context *
 mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
+/* Where @rxq counts. A retiring queue is no longer the one serving its index,
+ * so it counts into its own storage and leaves the shared slot to whatever
+ * replaced it. Nothing is lost: mana_destroy_rxq() folds it back.
+ */
+static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
+{
+	return READ_ONCE(rxq->retiring) ? &rxq->drain_stats : rxq->stats;
+}
+
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-- 
2.43.0

