Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF9A3F1072;
	Wed,  9 Sep 2026 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992719; cv=none; b=PkTawTOHtYlE1Rsi2oSeiVIz8M5xCRC2cx0NWkGZvJ89WU1JPeIZZgRyBMgXNLTfeBeVdqnWnuyspACy85sI0BkqQhIKOJDkk6RiqXRNg97NQQT48aB6LpD7CQmPYRA/KUv6FdBRBGWedNBimxi7oWHNg8LAEXMUdIA0atUrBe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992719; c=relaxed/simple;
	bh=ajGJdWsuDg5QMuSuBVy4vWQaNhlPebGqnTubUE6HJf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyQHWaYD3QApbvcxgdPXlMNSrEJ9SZpGfau4nzboAHuHp1HTjDA845LVDoljzcUUTRfCh0hTTdszZux8YuwdS1R9ecu9qeexSgTDOD1sgw6M1jx9DqzOtvDxU1qf69yBtHrEQA15qFJ4SzzWSwxCWlr+t3c32ttNzpNiHtrXvng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id ABC8B20B7172; Wed,  9 Sep 2026 15:24:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ABC8B20B7172
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
Subject: [PATCH net-next v5 09/13] net: mana: keep per-queue statistics in the port context
Date: Wed,  9 Sep 2026 15:24:12 -0700
Message-ID: <20260909222416.884246-10-longli@microsoft.com>
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

Move RX/TX counters into port-lifetime arrays so queue rebuilds do not
reset them. Sum all max_queues slots for ndo_get_stats64(); keep the
current queue count for ethtool's per-queue output.

Retiring RX queues count into private drain_stats. Destruction and
rollback fold these into separate port slots after writer quiescence.
Report counters while down too, but gate the PHY query on port_is_up.

DIM now samples the persistent live counters and skips retiring queues.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5:
  - Rebased onto current net-next; no changes to this patch.

Changes in v4:
  - Remove the port-up early returns from both statistics readers;
    retain that condition only for the hardware PHY query.
  - Clarify drain-stat folding and DIM input changes; shorten comments.

 .../net/ethernet/microsoft/mana/mana_bpf.c    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 204 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  48 ++++-
 include/net/mana/mana.h                       |  30 ++-
 4 files changed, 242 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index debf0e77658620ee830b303f106bbd7b7c14ee5f..2060e08d82277237307ac99ff7ad66b4b134e8b4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -73,7 +73,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 		count++;
 	}
 
-	tx_stats = &apc->tx_qp[q_idx]->txq.stats;
+	tx_stats = apc->tx_qp[q_idx]->txq.stats;
 
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->xdp_xmit += count;
@@ -100,7 +100,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
-	rx_stats = &rxq->stats;
+	rx_stats = mana_rxq_stats(rxq);
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5752e3745ccc6ba26bdd8f9be3108e4f3de69be0..98007bb3ef7caa974849c3f4998854f15c925321 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -396,7 +396,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx]->txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx]->tx_cq;
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 
 	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
 	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
@@ -575,7 +575,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Populated the packet and bytes counters based on post GSO packet
 	 * calculations
 	 */
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->packets += num_gso_seg;
 	tx_stats->bytes += len + ((num_gso_seg - 1) * gso_hs);
@@ -621,15 +621,15 @@ static void mana_get_stats64(struct net_device *ndev,
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
 
-	if (!apc->port_is_up)
-		return;
+	/* Report even while down; dev_get_stats() zeroes its output. */
+	num_queues = apc->max_queues;
 
 	netdev_stats_to_stats64(st, &ndev->stats);
 
@@ -639,7 +639,18 @@ static void mana_get_stats64(struct net_device *ndev,
 	st->rx_missed_errors = apc->ac->hc_stats.hc_rx_discards_no_wqe;
 
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
@@ -652,7 +663,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
@@ -1065,6 +1076,105 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
 	apc->rxqs = NULL;
 }
 
+/* Port lifetime preserves counters across queue replacement. */
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
+/* Fold under RTNL after drain_stats writers quiesce. Clear drain_stats to
+ * prevent double counting on rollback.
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
@@ -2172,7 +2282,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = mana_rxq_stats(rxq);
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2405,6 +2515,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct net_device *ndev = rxq->ndev;
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
+	struct mana_stats_rx *rx_stats;
 	struct device *dev = gc->dev;
 	bool coalesced_8 = false;
 	bool coalesced = false;
@@ -2486,13 +2597,15 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
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
@@ -2624,8 +2737,12 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
-	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
-			  rxq->stats.bytes, &dim_sample);
+	/* Skip retiring RXQs; DIM reads shared per-index counters. */
+	if (READ_ONCE(rxq->retiring))
+		return;
+
+	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
+			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
 }
 
@@ -2842,7 +2959,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		/* Create SQ */
 		txq = &apc->tx_qp[i]->txq;
 
-		u64_stats_init(&txq->stats.syncp);
+		txq->stats = &apc->txq_stats[i];
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
@@ -2969,6 +3086,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		netif_napi_del_locked(napi);
 	}
 
+	/* NAPI is quiesced, so drain_stats has no remaining writer. */
+	mana_fold_rxq_stats(apc, rxq);
+
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
@@ -3154,6 +3274,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
+	rxq->stats = &apc->rxq_stats[rxq_idx];
+	u64_stats_init(&rxq->drain_stats.syncp);
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3304,8 +3426,6 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 			goto out;
 		}
 
-		u64_stats_init(&rxq->stats.syncp);
-
 		apc->rxqs[i] = rxq;
 
 		mana_create_rxq_debugfs(apc, i);
@@ -4076,16 +4196,27 @@ static void mana_start_txqs(struct mana_port_context *apc)
 /* Retiring completions must not wake replacement queues. Mark the leaving set
  * before unmarking the incoming set.
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
+		/* Carried RXQs remain the sole poll writers of shared slots. */
+		if (retiring && keep && q < keep->num_queues &&
+		    keep->rxqs && keep->rxqs[q] == qset->rxqs[q])
+			continue;
+
+		/* Switch to drain_stats; hand off shared slots after a grace
+		 * period.
+		 */
+		WRITE_ONCE(qset->rxqs[q]->retiring, retiring);
 	}
 }
 
@@ -4140,12 +4271,12 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	/* Mark before the grace period so old completions cannot wake the
 	 * replacement's stopped queue.
 	 */
-	mana_qset_set_retiring(out_old, true);
+	mana_qset_set_retiring(out_old, newq, true);
 
 	/* Drain TX/XDP readers past the gate and polls missing retiring. */
 	synchronize_net();
 
-	mana_qset_set_retiring(newq, false);
+	mana_qset_set_retiring(newq, NULL, false);
 
 	mana_qset_install(apc, newq);
 	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
@@ -4183,8 +4314,16 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	netdev_err(ndev, "%s failed: %d, restoring previous queue set\n",
 		   __func__, err);
 
-	mana_qset_set_retiring(newq, true);
-	mana_qset_set_retiring(out_old, false);
+	mana_qset_set_retiring(newq, out_old, true);
+
+	/* Quiesce new shared-slot writers before restoring old ones. */
+	synchronize_net();
+
+	mana_qset_set_retiring(out_old, NULL, false);
+
+	/* Quiesce old drain_stats writers before folding. */
+	synchronize_net();
+	mana_fold_qset_rx_stats(apc, out_old);
 
 	mana_qset_install(apc, out_old);
 	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
@@ -4393,6 +4532,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
 	}
 
+	err = mana_alloc_queue_stats(apc);
+	if (err)
+		goto free_net;
+
 	mutex_init(&apc->vport_mutex);
 	apc->vport_use_count = 0;
 
@@ -4415,7 +4558,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	err = mana_init_port(ndev);
 	if (err)
-		goto free_net;
+		goto free_stats;
 
 	err = mana_rss_table_alloc(apc);
 	if (err)
@@ -4452,6 +4595,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	mana_cleanup_indir_table(apc);
 reset_apc:
 	mana_cleanup_port_context(apc);
+free_stats:
+	mana_free_queue_stats(apc);
 free_net:
 	*ndev_storage = NULL;
 	netdev_err(ndev, "Failed to probe vPort %d: %d\n", port_idx, err);
@@ -4792,6 +4937,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
+		mana_free_queue_stats(apc);
 
 		/* Remove the port from reset walks before freeing its netdev.
 		 */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 32f40f5cd850e6c67ea0dd57cc45a51b37c43b93..77dcbd01a1f3da692c341f17d8f2a8301c02bd6b 100644
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
@@ -252,14 +258,11 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	u64 mana_map_err;
 	int q, i = 0, j;
 
-	if (!apc->port_is_up)
-		return;
-
-	/* We call this mana function to get the phy stats from GDMA and includes
-	 * aggregate tx/rx drop counters, Per-TC(Traffic Channel) tx/rx and pause
-	 * counters.
+	/* Counters outlive the queues, but suspend can destroy the HW channel
+	 * while the netdev remains registered. Gate only the PHY query.
 	 */
-	mana_query_phy_stats(apc);
+	if (apc->port_is_up)
+		mana_query_phy_stats(apc);
 
 	for (q = 0; q < ARRAY_SIZE(mana_eth_stats); q++)
 		data[i++] = *(u64 *)(eth_stats + mana_eth_stats[q].offset);
@@ -271,7 +274,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		data[i++] = *(u64 *)(phy_stats + mana_phy_stats[q].offset);
 
 	for (q = 0; q < num_queues; q++) {
-		rx_stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&rx_stats->syncp);
@@ -285,6 +288,33 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 				coalesced_cqe[j] = rx_stats->coalesced_cqe[j];
 		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
+		/* Snapshot separately so a retry cannot add retired counters
+		 * twice.
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
@@ -296,7 +326,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9b8c038042b4f90b0b5958fc33cdad36e169863c..6c6d906db207304cd2d32c474cf2e9e5f32f4738 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -102,7 +102,7 @@ struct mana_stats_rx {
 	u64 pkt_len0_err;
 	u64 coalesced_cqe[MANA_CQE_COAL_PKTS_8 - 1];
 	struct u64_stats_sync syncp;
-};
+} ____cacheline_aligned_in_smp;
 
 struct mana_stats_tx {
 	u64 packets;
@@ -117,7 +117,7 @@ struct mana_stats_tx {
 	u64 csum_partial;
 	u64 mana_map_err;
 	struct u64_stats_sync syncp;
-};
+} ____cacheline_aligned_in_smp;
 
 struct mana_txq {
 	struct gdma_queue *gdma_sq;
@@ -148,7 +148,7 @@ struct mana_txq {
 	/* Suppress completion wakeups on the replacement's netdev queue. */
 	bool retiring;
 
-	struct mana_stats_tx stats;
+	struct mana_stats_tx *stats;
 };
 
 /* skb data and frags dma mappings */
@@ -410,7 +410,16 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats_rx stats;
+	/* Port-owned live slot; use mana_rxq_stats() to select the writer's
+	 * slot.
+	 */
+	struct mana_stats_rx *stats;
+
+	/* Set under RTNL before another queue takes over this index. */
+	bool retiring;
+
+	/* Folded under RTNL after drain-stat writers quiesce. */
+	struct mana_stats_rx drain_stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
@@ -613,6 +622,14 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
+	/* Port-lifetime arrays with max_queues slots. Live RX queues write
+	 * rxq_stats[]; teardown and rollback fold drain_stats into
+	 * rxq_stats_ret[] under RTNL. Readers sum both.
+	 */
+	struct mana_stats_rx *rxq_stats;
+	struct mana_stats_rx *rxq_stats_ret;
+	struct mana_stats_tx *txq_stats;
+
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
@@ -714,6 +731,11 @@ int mana_detach(struct net_device *ndev, bool from_close);
 struct mana_port_context *
 mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
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
