Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9F74E5330;
	Fri,  9 Oct 2026 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556903; cv=none; b=kQGWQjjporcxCRyFJnchQghfGG01fOFUiqVq4Ql6YqMFNEu8HkTmm2HI3buWn3T689ZnFMzj+RTR8Z4y8JaYCfxVYacottC3Pe8IFgQvAJheyf+IJ3+OBpuW/7rGYhNBhwZi4jqTQXf5BYrj6KUAlDYzBQdqmLe/otStibQQ7Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556903; c=relaxed/simple;
	bh=UckCHMeqCsOoRZ9fAa/DiCK0cUePZBFk8E6JQeQLv7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB3YDw3wAUeLsOBq3SPpGqFrmgpBewCJNC3Z+CJVgW9ZcNjFU642KYqj8ny8lRvan5w3BsljBFpPpQMK9vNUod7u7QzulVWaxAvwhHYosLwsVcsYo5TT1dU6Vvc9ChHCTIXPWqQGLbTs8BzMpHtOuL/gnXilsP7WzB+/QMB00po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lt2yda2X; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lt2yda2X"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4177020B716D;
	Fri,  9 Oct 2026 07:41:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4177020B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556900;
	bh=avsYxrtO3bDJPVVCQdLKsyR0xujj9IZxEr6YjjR5o6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt2yda2XMBMCO5sQ0IQxXI2E4cLJ36b+2LVds7SDo8E5W/kSNTAbBjNHHHAUQ/NN2
	 tb6YYlN2TnKSx0ByYwibstVzXtHZeG9ehq2NEFloC7RYd649Ekp+uEvRkZhxH9UIel
	 92u/muBftQYFuNkxbJti9SyXUYYlbhF/+9pBi2qM=
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
Subject: [PATCH net-next v6 03/13] net: mana: keep per-queue statistics in the port context
Date: Fri,  9 Oct 2026 14:41:14 +0000
Message-ID: <35bb5bd322e53edfb2e53e4b57ed2e678f3b5105.1790795005.git.weh@linux.microsoft.com>
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

Prepare port-lifetime RX/TX statistics before introducing live queue
replacement. Allocate max_queues slots before netdev registration,
unwind probe failures, and release them only after unregistering the
netdev. Queue writers use pointers into these arrays.

Make ndo_get_stats64 and ethtool statistics independent of replaceable
queue objects. Preserve counters while down, gating only the PHY
query. Reserve zeroed retired-RX slots for the next patch; no second
live queue generation or RX retirement handoff is enabled here.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 107 ++++++++++++++----
 .../ethernet/microsoft/mana/mana_ethtool.c    |  48 ++++++--
 include/net/mana/mana.h                       |  15 ++-
 4 files changed, 139 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index ff54f8966825..1905214bec48 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -68,7 +68,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 		count++;
 	}
 
-	tx_stats = &apc->tx_qp[q_idx]->txq.stats;
+	tx_stats = apc->tx_qp[q_idx]->txq.stats;
 
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->xdp_xmit += count;
@@ -95,7 +95,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
-	rx_stats = &rxq->stats;
+	rx_stats = rxq->stats;
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 45cb23717151..02cd5f7656ed 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -372,7 +372,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx]->txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx]->tx_cq;
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 
 	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
 	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
@@ -551,7 +551,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Populated the packet and bytes counters based on post GSO packet
 	 * calculations
 	 */
-	tx_stats = &txq->stats;
+	tx_stats = txq->stats;
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->packets += num_gso_seg;
 	tx_stats->bytes += len + ((num_gso_seg - 1) * gso_hs);
@@ -597,15 +597,15 @@ static void mana_get_stats64(struct net_device *ndev,
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
 
@@ -615,7 +615,18 @@ static void mana_get_stats64(struct net_device *ndev,
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
@@ -628,7 +639,7 @@ static void mana_get_stats64(struct net_device *ndev,
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		tx_stats = &apc->tx_qp[q]->txq.stats;
+		tx_stats = &apc->txq_stats[q];
 
 		do {
 			start = u64_stats_fetch_begin(&tx_stats->syncp);
@@ -1036,6 +1047,53 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
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
 static void mana_cleanup_indir_table(struct mana_port_context *apc)
 {
 	apc->indir_table_sz = 0;
@@ -2141,7 +2199,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = rxq->stats;
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2374,6 +2432,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct net_device *ndev = rxq->ndev;
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
+	struct mana_stats_rx *rx_stats;
 	struct device *dev = gc->dev;
 	bool coalesced_8 = false;
 	bool coalesced = false;
@@ -2455,13 +2514,15 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	 * Coalesced CQEs have at least 2 packets, so index is pkt_i - 2.
 	 */
 	if (pkt_i > 1) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.coalesced_cqe[pkt_i - 2]++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		rx_stats = rxq->stats;
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->coalesced_cqe[pkt_i - 2]++;
+		u64_stats_update_end(&rx_stats->syncp);
 	} else if (!pkt_i && !pktlen) {
-		u64_stats_update_begin(&rxq->stats.syncp);
-		rxq->stats.pkt_len0_err++;
-		u64_stats_update_end(&rxq->stats.syncp);
+		rx_stats = rxq->stats;
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->pkt_len0_err++;
+		u64_stats_update_end(&rx_stats->syncp);
 		netdev_err_once(ndev,
 				"RX pkt len=0, rq=%u, cq=%u, rxobj=0x%llx\n",
 				rxq->gdma_id, cq->gdma_id, rxq->rxobj);
@@ -2593,8 +2654,8 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
-	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
-			  rxq->stats.bytes, &dim_sample);
+	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
+			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
 }
 
@@ -2824,7 +2885,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		/* Create SQ */
 		txq = &apc->tx_qp[i]->txq;
 
-		u64_stats_init(&txq->stats.syncp);
+		txq->stats = &apc->txq_stats[i];
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->vp_offset = apc->tx_vp_offset;
@@ -3140,6 +3201,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
+	rxq->stats = &apc->rxq_stats[rxq_idx];
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3290,8 +3352,6 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 			goto out;
 		}
 
-		u64_stats_init(&rxq->stats.syncp);
-
 		apc->rxqs[i] = rxq;
 
 		mana_create_rxq_debugfs(apc, i);
@@ -4091,6 +4151,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
 	}
 
+	err = mana_alloc_queue_stats(apc);
+	if (err)
+		goto free_net;
+
 	mutex_init(&apc->vport_mutex);
 	apc->vport_use_count = 0;
 
@@ -4113,7 +4177,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	err = mana_init_port(ndev);
 	if (err)
-		goto free_net;
+		goto free_stats;
 
 	err = mana_rss_table_alloc(apc);
 	if (err)
@@ -4150,6 +4214,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	mana_cleanup_indir_table(apc);
 reset_apc:
 	mana_cleanup_port_context(apc);
+free_stats:
+	mana_free_queue_stats(apc);
 free_net:
 	*ndev_storage = NULL;
 	netdev_err(ndev, "Failed to probe vPort %d: %d\n", port_idx, err);
@@ -4491,6 +4557,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
+		mana_free_queue_stats(apc);
 
 		/* Remove the port from reset walks before freeing its netdev.
 		 */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ece7ff9cc409..f063462cd549 100644
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
index d3a79e13e343..d0cf92ac6fa8 100644
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
@@ -146,7 +146,7 @@ struct mana_txq {
 	/* Suppress completion wakeups on the replacement's netdev queue. */
 	bool retiring;
 
-	struct mana_stats_tx stats;
+	struct mana_stats_tx *stats;
 };
 
 /* skb data and frags dma mappings */
@@ -408,7 +408,7 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats_rx stats;
+	struct mana_stats_rx *stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
@@ -606,6 +606,13 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
+	/* Port-lifetime arrays with max_queues slots. Readers sum live and
+	 * retired RX counters.
+	 */
+	struct mana_stats_rx *rxq_stats;
+	struct mana_stats_rx *rxq_stats_ret;
+	struct mana_stats_tx *txq_stats;
+
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
