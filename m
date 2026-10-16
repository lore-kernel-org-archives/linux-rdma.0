Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBB84E1C89;
	Fri, 16 Oct 2026 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165144; cv=none; b=MXhJX3bK3HbUjMDv2FGRA/7XZjrqMHDV8+SN7tJSUY9FZZ3hMGhqLtmkWGmcnlzCLr47QAQ1YRK00V7iP/LtoShIHEjb7BzhMRAFK0T8py3KEc2cDj5IIMqmqKdtR0HRtG37Rcjivu1SOP5uOVVc95lEJP+Z2KHJZZgYno2xFc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165144; c=relaxed/simple;
	bh=mO3YmSUNSzDXoHfAtJJWhYyKleJsIj4ozYZgkR+R4BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jqx4CFfXtcUXZJkbLQwwpJYphjMT+wguOI7bwBNWza1CGMLgcO95wy9qYCxMaCV3bGIF7GyIGCtfkWuzOFIpG6lsl6+BgVHTwvdjIfBV1dqvTyKKP8vepXgIseVzz71z559bn7jO4o7D3vo7cXG/l0kyWEOiBVWCZkPic8MD36s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VT7tlrOc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VT7tlrOc"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7ED720B716D;
	Fri, 16 Oct 2026 08:38:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7ED720B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165134;
	bh=Rbkk9ibay7cX6UD50YSZK7VKfXuDg9IC2RkFEVQBAdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT7tlrOcF3Ag2bZvSuF+vVA204WSVVPJTXeQoas4u7HJaXNcpS2Y+LahURz1hdWuQ
	 ImpL+G49HNpbm2XYGDwd7Ta8z1tdcKyZYcDQlD7rusaXxIGBz9+k+NksUaUXA8zZrH
	 wZT29J7UA9wsi6YYfAIDodq+5XhkkNF1rKSoR5lA=
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
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: [PATCH net-next v7 04/13] net: mana: swap queue sets in mana_set_channels
Date: Fri, 16 Oct 2026 15:38:37 +0000
Message-ID: <ec57f3853ef344a7d5ec8907ba530313b0163bae.1791710735.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Build a replacement queue set before quiescing TX. After closing the
TX/XDP gate and draining its readers, wait up to 120 seconds for ALL
old TX queues before changing pointers, queue counts or RSS. On a
timeout, reject the replacement and resume the unchanged old config
without reprogramming RSS or resetting the function.

Drain every old TX queue, including queues later patches may retain,
so even a later failed-rollback close cannot invoke legacy FLR for
old pending TX. Retirement and unpublished-set cleanup need no FLR.
Allocation failure preserves live queues and configuration. After
publication, failure attempts rollback; failed rollback closes the
port and holds carrier down until a successful reopen.

The preceding statistics preparation removes reader dependence on
queue lifetime. Add private retiring RX counters and writer handoff
with this first live swap. Keep old RX counters retired until RSS
restoration succeeds. Common resume_old handling for drain rejection
and successful rollback restarts DIM only on actually retired RXQs,
with NAPI disabled and DIM work drained, then folds counters after
writer quiescence before reopening the old set.

Publish initialized fields before reopening TX/XDP and drain readers
of transient RSS tables after restoring old pointers. Keep RX queue
indices valid until retiring queues stop delivering them.

The temporary SQ/RQ/CQ peak is old plus new; the port EQ pool is
shared, not doubled. Later patches avoid the extra queue allocation
for channel-count changes; full per-queue rebuilds still need it.

Join queue selection to the publication gate so it cannot read
transient RSS or queue-count state while TX is stopped. Old tail
RX queues can outlive the TX-count reduction; fall back to the
current RSS mapping when a recorded RX index is no longer valid.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   7 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 435 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  78 +++-
 include/net/mana/mana.h                       |  34 +-
 4 files changed, 509 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 2008c1741654..687b9ce7d9a3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -59,6 +59,11 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 	if (unlikely(!apc->port_is_up))
 		return 0;
 
+	/* Pair with the smp_wmb() in mana_publish_qset() before reading queue
+	 * state.
+	 */
+	smp_rmb();
+
 	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
 
 	for (i = 0; i < n; i++) {
@@ -95,7 +100,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
-	rx_stats = rxq->stats;
+	rx_stats = mana_rxq_stats(rxq);
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 744d5ebe8dbb..c80a06ffbe50 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -84,12 +84,25 @@ static int mana_open(struct net_device *ndev)
 		return err;
 	}
 
-	apc->port_is_up = true;
+	/* Publish the queues before opening the TX/XDP gate. */
+	smp_wmb();
+	WRITE_ONCE(apc->port_is_up, true);
 
 	/* Ensure port state updated before txq state */
 	smp_wmb();
 
 	netif_tx_wake_all_queues(ndev);
+
+	/* Undo a forced carrier-off unless a disconnect is pending behind RTNL.
+	 */
+	if (apc->carrier_forced_off) {
+		u32 ev = READ_ONCE(apc->ac->link_event);
+
+		apc->carrier_forced_off = false;
+		if (ev != HWC_DATA_HW_LINK_DISCONNECT)
+			netif_carrier_on(ndev);
+	}
+
 	netdev_dbg(ndev, "%s successful\n", __func__);
 	return 0;
 }
@@ -106,6 +119,7 @@ static int mana_close(struct net_device *ndev)
 
 static void mana_link_state_handle(struct work_struct *w)
 {
+	struct mana_port_context *apc;
 	struct mana_context *ac;
 	struct net_device *ndev;
 	u32 link_event;
@@ -131,7 +145,12 @@ static void mana_link_state_handle(struct work_struct *w)
 		if (!ndev)
 			continue;
 
+		apc = netdev_priv(ndev);
+
 		if (link_up) {
+			if (apc->carrier_forced_off)
+				continue;
+
 			netif_carrier_on(ndev);
 
 			__netdev_notify_peers(ndev);
@@ -312,8 +331,8 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 
 	rtnl_lock();
 
-	/* Block RDMA from grabbing the vport during the detach/attach
-	 * window, same as mana_set_channels().
+	/* Exclude RDMA across detach/attach; RTNL serializes channel_changing
+	 * writers.
 	 */
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = true;
@@ -366,6 +385,15 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (unlikely(!apc->port_is_up))
 		goto tx_drop;
 
+	/* Pair with mana_publish_qset()'s pre-gate smp_wmb(): observe queue
+	 * fields after reading port_is_up.
+	 */
+	smp_rmb();
+
+	/* Retiring RXQs may use indices beyond the live queue count. */
+	if (unlikely(txq_idx >= apc->num_queues))
+		goto tx_drop_count;
+
 	if (skb_cow_head(skb, MANA_HEADROOM))
 		goto tx_drop_count;
 
@@ -672,15 +700,25 @@ static int mana_get_tx_queue(struct net_device *ndev, struct sk_buff *skb,
 static u16 mana_select_queue(struct net_device *ndev, struct sk_buff *skb,
 			     struct net_device *sb_dev)
 {
+	struct mana_port_context *apc = netdev_priv(ndev);
+	unsigned int num_tx_queues;
 	int txq;
 
-	if (ndev->real_num_tx_queues == 1)
+	/* Queue selection also runs while TX is stopped. Observe the same
+	 * publication gate before reading the queue count or RSS table.
+	 */
+	if (!smp_load_acquire(&apc->port_is_up))
+		return 0;
+
+	num_tx_queues = READ_ONCE(ndev->real_num_tx_queues);
+	if (num_tx_queues == 1)
 		return 0;
 
 	txq = sk_tx_queue_get(skb->sk);
 
-	if (txq < 0 || skb->ooo_okay || txq >= ndev->real_num_tx_queues) {
-		if (skb_rx_queue_recorded(skb))
+	if (txq < 0 || skb->ooo_okay || txq >= num_tx_queues) {
+		if (skb_rx_queue_recorded(skb) &&
+		    skb_get_rx_queue(skb) < num_tx_queues)
 			txq = skb_get_rx_queue(skb);
 		else
 			txq = mana_get_tx_queue(ndev, skb, txq);
@@ -1123,6 +1161,58 @@ static void mana_free_queue_stats(struct mana_port_context *apc)
 	apc->txq_stats = NULL;
 }
 
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
@@ -1132,6 +1222,7 @@ static void mana_cleanup_indir_table(struct mana_port_context *apc)
 
 static int mana_init_port_context(struct mana_port_context *apc)
 {
+	kfree(apc->rxqs);
 	apc->rxqs = kzalloc_objs(struct mana_rxq *, apc->num_queues);
 
 	return !apc->rxqs ? -ENOMEM : 0;
@@ -2164,6 +2255,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
+	/* Order the stopped-state read before the retiring read. */
 	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
 	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
@@ -2228,7 +2320,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 			struct mana_rxcomp_oob *cqe, struct mana_rxq *rxq,
 			u32 pkt_len, u32 pkt_hash)
 {
-	struct mana_stats_rx *rx_stats = rxq->stats;
+	struct mana_stats_rx *rx_stats = mana_rxq_stats(rxq);
 	struct net_device *ndev = rxq->ndev;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
@@ -2543,12 +2635,12 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	 * Coalesced CQEs have at least 2 packets, so index is pkt_i - 2.
 	 */
 	if (pkt_i > 1) {
-		rx_stats = rxq->stats;
+		rx_stats = mana_rxq_stats(rxq);
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->coalesced_cqe[pkt_i - 2]++;
 		u64_stats_update_end(&rx_stats->syncp);
 	} else if (!pkt_i && !pktlen) {
-		rx_stats = rxq->stats;
+		rx_stats = mana_rxq_stats(rxq);
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->pkt_len0_err++;
 		u64_stats_update_end(&rx_stats->syncp);
@@ -2633,9 +2725,9 @@ static void mana_tx_dim_work(struct work_struct *work)
 	dim->state = DIM_START_MEASURE;
 }
 
-/* The caller must update apc->rx/tx_dim_enabled before disabling and
- * after enabling. And synchronize_net() before draining the DIM work,
- * so that NAPI cannot observe a stale flag.
+/* The caller must exclude NAPI, either by disabling it or by clearing the
+ * per-port DIM flag and calling synchronize_net(). When using the flag,
+ * publish enable only after reinitializing DIM.
  */
 void mana_dim_change(struct mana_cq *cq, bool enable)
 {
@@ -2683,6 +2775,10 @@ static void mana_update_rx_dim(struct mana_cq *cq)
 	if (!smp_load_acquire(&apc->rx_dim_enabled))
 		return;
 
+	/* Skip retiring RXQs; DIM reads shared per-index counters. */
+	if (READ_ONCE(rxq->retiring))
+		return;
+
 	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
 			  rxq->stats->bytes, &dim_sample);
 	net_dim(&cq->dim, &dim_sample);
@@ -3041,6 +3137,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		netif_napi_del_locked(napi);
 	}
 
+	/* NAPI is quiesced, so drain_stats has no remaining writer. */
+	mana_fold_rxq_stats(apc, rxq);
+
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
@@ -3231,6 +3330,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	rxq->ndev = ndev;
 	rxq->stats = &apc->rxq_stats[rxq_idx];
+	u64_stats_init(&rxq->drain_stats.syncp);
 	rxq->num_rx_buf = apc->rx_queue_size;
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
@@ -3837,7 +3937,9 @@ int mana_attach(struct net_device *ndev)
 		}
 	}
 
-	apc->port_is_up = apc->port_st_save;
+	/* Publish restored queues before opening the TX/XDP gate. */
+	smp_wmb();
+	WRITE_ONCE(apc->port_is_up, apc->port_st_save);
 
 	/* Ensure port state updated before txq state */
 	smp_wmb();
@@ -4053,9 +4155,305 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	return err;
 }
 
+/* Destroy caller-owned CQs before closing this dead-end port: closing also
+ * frees the shared EQ pool. Requires RTNL.
+ */
+void mana_publish_close_if_needed(struct mana_port_context *apc)
+{
+	ASSERT_RTNL();
+
+	if (!apc->publish_dead_end)
+		return;
+
+	apc->publish_dead_end = false;
+
+	if (mana_dealloc_queues(apc->ndev))
+		netdev_err(apc->ndev,
+			   "failed to close the port after a failed rollback\n");
+}
+
+/* Carried-over queues may still have full rings. */
+static void mana_start_txqs(struct mana_port_context *apc)
+{
+	struct net_device *ndev = apc->ndev;
+	unsigned int i;
+
+	if (!apc->tx_qp)
+		return;
+
+	/* Order port_is_up=true before ring reads to avoid a missed wakeup.
+	 * Pair with mana_poll_tx_cq()'s full barrier after its tail update.
+	 */
+	smp_mb();
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		if (mana_can_tx(apc->tx_qp[i]->txq.gdma_sq))
+			netif_tx_wake_queue(netdev_get_tx_queue(ndev, i));
+	}
+
+	/* The watchdog scans allocated queues, including the inactive tail.
+	 * Clear its driver stop bits without scheduling inactive qdiscs.
+	 */
+	for (; i < ndev->num_tx_queues; i++)
+		netif_tx_start_queue(netdev_get_tx_queue(ndev, i));
+}
+
+/* Retiring completions must not wake replacement queues. Mark the leaving set
+ * before unmarking the incoming set.
+ */
+static void mana_qset_set_retiring(struct mana_qset *qset,
+				   const struct mana_qset *keep, bool retiring)
+{
+	unsigned int q;
+
+	for (q = 0; q < qset->num_queues; q++) {
+		if (qset->tx_qp && qset->tx_qp[q])
+			WRITE_ONCE(qset->tx_qp[q]->txq.retiring, retiring);
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
+	}
+}
+
+static void mana_qset_restart_rx_dim(struct mana_qset *qset)
+{
+	struct mana_rxq *rxq;
+	struct mana_cq *cq;
+	unsigned int q;
+
+	if (!qset->rxqs)
+		return;
+
+	for (q = 0; q < qset->num_queues; q++) {
+		rxq = qset->rxqs[q];
+		if (!rxq || !READ_ONCE(rxq->retiring))
+			continue;
+
+		cq = &rxq->rx_cq;
+		napi_disable_locked(&cq->napi);
+		mana_dim_change(cq, false);
+		mana_dim_change(cq, true);
+		napi_enable_locked(&cq->napi);
+
+		/* An event may have arrived while NAPI was disabled. */
+		napi_schedule(&cq->napi);
+	}
+}
+
+/* Leave TX stopped and request RX disable; steering may be unrecoverable. */
+static void mana_publish_give_up(struct mana_port_context *apc)
+{
+	int err;
+
+	apc->rss_state = TRI_STATE_FALSE;
+
+	err = mana_disable_vport_rx(apc);
+	if (err && mana_en_need_log(apc, err))
+		netdev_err(apc->ndev, "failed to disable vPort RX: %d\n", err);
+
+	apc->carrier_forced_off = true;
+	netif_carrier_off(apc->ndev);
+	apc->publish_dead_end = true;
+}
+
+/* A replacement must not reset the function and invalidate its own queues. */
+static int mana_wait_qset_txqs(struct mana_port_context *apc)
+{
+	unsigned long timeout = jiffies + 120 * HZ;
+	struct mana_txq *txq;
+	unsigned int i;
+
+	if (!apc->tx_qp)
+		return 0;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		txq = &apc->tx_qp[i]->txq;
+		while (atomic_read(&txq->pending_sends)) {
+			if (time_after_eq(jiffies, timeout)) {
+				netdev_err(apc->ndev,
+					   "timed out draining TX queue %u for replacement\n",
+					   txq->gdma_txq_id);
+				return -ETIMEDOUT;
+			}
+
+			usleep_range(1000, 2000);
+		}
+	}
+
+	return 0;
+}
+
+/* Keep the RX count high until retiring RQs stop delivering their indices. */
+static int mana_raise_real_num_rx(struct net_device *ndev, unsigned int count)
+{
+	if (count <= ndev->real_num_rx_queues)
+		return 0;
+
+	return netif_set_real_num_rx_queues(ndev, count);
+}
+
+/* Publish under RTNL with TX gated. An error restores old pointers, not
+ * necessarily service. Free only owned queues.
+ */
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old)
+{
+	struct net_device *ndev = apc->ndev;
+	int err;
+
+	ASSERT_RTNL();
+
+	/* Close the XDP gate before stopping TX queues. Pair with
+	 * mana_poll_tx_cq()'s smp_rmb() to prevent mid-swap wakeups.
+	 */
+	WRITE_ONCE(apc->port_is_up, false);
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	netif_tx_disable(ndev);
+
+	mana_qset_snapshot(apc, out_old);
+
+	/* Mark before the grace period so old completions cannot wake the
+	 * replacement's stopped queue.
+	 */
+	mana_qset_set_retiring(out_old, newq, true);
+
+	/* Drain TX/XDP readers past the gate and polls missing retiring. */
+	synchronize_net();
+
+	err = mana_wait_qset_txqs(apc);
+	if (err)
+		goto resume_old;
+
+	mana_qset_set_retiring(newq, NULL, false);
+
+	mana_qset_install(apc, newq);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	err = mana_raise_real_num_rx(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	/* Install XDP and per-RXQ references before steering reaches new
+	 * queues.
+	 */
+	mana_chn_setxdp(apc, mana_xdp_get(apc));
+
+	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
+	if (err)
+		goto rollback;
+
+	/* Publish fields before opening the gate; pair with TX/XDP read
+	 * barriers. The post-gate full barrier cannot replace this.
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+
+	return 0;
+
+rollback:
+	netdev_err(ndev, "%s failed: %d, restoring previous queue set\n",
+		   __func__, err);
+
+	mana_qset_set_retiring(newq, out_old, true);
+
+	/* Quiesce new shared-slot writers before restoring old ones. */
+	synchronize_net();
+
+	mana_qset_install(apc, out_old);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	/* Drain network readers after restoring the old pointers, before
+	 * callers can discard the unpublished containers.
+	 */
+	synchronize_net();
+
+	if (netif_set_real_num_tx_queues(ndev, apc->num_queues) ||
+	    mana_raise_real_num_rx(ndev, apc->num_queues)) {
+		/* Inconsistent restored queue counts prohibit TX; leave the
+		 * port stopped.
+		 */
+		netdev_err(ndev, "failed to restore queue counts, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+	if (mana_config_rss(apc, TRI_STATE_TRUE, true, true)) {
+		/* Do not reopen TX with mismatched steering; RX disable is
+		 * best-effort.
+		 */
+		netdev_err(ndev, "failed to restore RSS steering, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+resume_old:
+	if (apc->rx_dim_enabled)
+		mana_qset_restart_rx_dim(out_old);
+	mana_qset_set_retiring(out_old, NULL, false);
+
+	/* Quiesce old drain_stats writers before folding. */
+	synchronize_net();
+	mana_fold_qset_rx_stats(apc, out_old);
+
+	/* Publish restored fields before reopening the gate, as on success. */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+
+	return err;
+}
+
+/* Create missing debugfs nodes once retiring names are gone. */
+static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+{
+	unsigned int i;
+
+	ASSERT_RTNL();
+
+	if (IS_ERR_OR_NULL(apc->mana_port_debugfs))
+		return;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (apc->tx_qp && apc->tx_qp[i] &&
+		    IS_ERR_OR_NULL(apc->tx_qp[i]->mana_tx_debugfs))
+			mana_create_txq_debugfs(apc, i);
+
+		if (apc->rxqs && apc->rxqs[i] &&
+		    IS_ERR_OR_NULL(apc->rxqs[i]->mana_rx_debugfs))
+			mana_create_rxq_debugfs(apc, i);
+	}
+}
+
 /* Under RTNL, free only queues no longer shared with the installed set. */
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 {
+	struct mana_port_context *apc = netdev_priv(scratch->ndev);
 	struct bpf_prog *retiring_prog;
 	unsigned int retiring_queues;
 
@@ -4080,7 +4478,9 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	mana_qset_install(scratch, qset);
 
-	/* Keep retiring RXQs' XDP programs and references until RX teardown. */
+	/* Keep retiring RXQs' XDP programs and references until RX teardown.
+	 * Read the program from the queues, not queue-set metadata.
+	 */
 	retiring_prog = mana_chn_xdp_peek(scratch);
 	retiring_queues = scratch->num_queues;
 
@@ -4100,6 +4500,13 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	scratch->rxqs = NULL;
 
 	memset(qset, 0, sizeof(*qset));
+
+	/* Retiring RQs can no longer deliver indices beyond the live queue
+	 * count.
+	 */
+	netif_set_real_num_rx_queues(apc->ndev, apc->num_queues);
+
+	mana_qset_debugfs_publish(apc);
 }
 
 int mana_detach(struct net_device *ndev, bool from_close)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 43c5c3bf5c40..913349edfe13 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -678,52 +678,82 @@ static int mana_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-/* mana_set_channels - change the number of queues on a port
- *
- * Returns -EBUSY if RDMA holds the vport with EQs sized to the
- * current num_queues.
- */
 static int mana_set_channels(struct net_device *ndev,
 			     struct ethtool_channels *channels)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
-	unsigned int old_count = apc->num_queues;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err;
 
-	/* Set channel_changing to block RDMA from grabbing the vport
-	 * during the detach/attach window. mana_cfg_vport() checks
-	 * this flag under vport_mutex and returns -EBUSY if set.
+	if (new_count < 1 || new_count > apc->max_queues) {
+		netdev_err(ndev, "Invalid combined_count %u (max %u)\n",
+			   new_count, apc->max_queues);
+		return -EINVAL;
+	}
+
+	if (new_count == apc->num_queues)
+		return 0;
+
+	/* Resize rxqs while down: mana_open() does not recreate the port
+	 * context. RDMA must not own the vport while num_queues changes.
 	 */
 	mutex_lock(&apc->vport_mutex);
-	if (!apc->port_is_up && apc->vport_use_count) {
+	if (!apc->port_is_up) {
+		struct mana_rxq **rxqs;
+
+		if (apc->vport_use_count) {
+			mutex_unlock(&apc->vport_mutex);
+			return -EBUSY;
+		}
+
+		rxqs = kzalloc_objs(struct mana_rxq *, new_count);
+		if (!rxqs) {
+			mutex_unlock(&apc->vport_mutex);
+			return -ENOMEM;
+		}
+
+		kfree(apc->rxqs);
+		apc->rxqs = rxqs;
+		apc->num_queues = new_count;
+		mutex_unlock(&apc->vport_mutex);
+		return 0;
+	}
+
+	/* The Ethernet port already holds a vport reference; exclude RDMA
+	 * through failure cleanup.
+	 */
+	if (apc->channel_changing) {
 		mutex_unlock(&apc->vport_mutex);
 		return -EBUSY;
 	}
 	apc->channel_changing = true;
 	mutex_unlock(&apc->vport_mutex);
 
-	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, new_count);
-	if (err) {
-		netdev_err(ndev, "Insufficient memory for new allocations");
+	scratch = mana_qset_scratch_alloc(apc);
+	if (!scratch) {
+		err = -ENOMEM;
 		goto clear_flag;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto out;
-	}
+	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
+			      apc->tx_queue_size, apc->priv_flags, &newq);
+	if (err)
+		goto free_scratch;
 
-	apc->num_queues = new_count;
-	err = mana_attach(ndev);
+	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		apc->num_queues = old_count;
-		netdev_err(ndev, "mana_attach failed: %d\n", err);
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
 
-out:
-	mana_pre_dealloc_rxbufs(apc);
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	/* Release unpublished queues before closing their shared EQ pool. */
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 485a6c9342fc..14025024acfa 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -419,8 +419,17 @@ struct mana_rxq {
 
 	u32 buf_index;
 
+	/* Port-owned live slot; use mana_rxq_stats() to select the writer's
+	 * slot.
+	 */
 	struct mana_stats_rx *stats;
 
+	/* Set under RTNL before another queue takes over this index. */
+	bool retiring;
+
+	/* Folded under RTNL after drain-stat writers quiesce. */
+	struct mana_stats_rx drain_stats;
+
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
 	void *xdp_save_va; /* for reusing */
@@ -617,8 +626,9 @@ struct mana_port_context {
 	unsigned int max_queues;
 	unsigned int num_queues;
 
-	/* Port-lifetime arrays with max_queues slots. Readers sum live and
-	 * retired RX counters.
+	/* Port-lifetime arrays with max_queues slots. Live RX queues write
+	 * rxq_stats[]; teardown and rollback fold drain_stats into
+	 * rxq_stats_ret[] under RTNL. Readers sum both.
 	 */
 	struct mana_stats_rx *rxq_stats;
 	struct mana_stats_rx *rxq_stats_ret;
@@ -634,12 +644,16 @@ struct mana_port_context {
 	struct mutex vport_mutex;
 	int vport_use_count;
 
-	/* Set by mana_set_channels() under vport_mutex to block RDMA
-	 * from grabbing the vport during the detach/attach window.
-	 * Checked by mana_cfg_vport() when called from the RDMA path.
-	 */
+	/* Exclude RDMA during reconfiguration; protected by vport_mutex. */
 	bool channel_changing;
 
+	/* Caller must close the port after releasing the unpublished set. */
+	bool publish_dead_end;
+
+	/* Hold carrier off after failed rollback until a successful reopen.
+	 */
+	bool carrier_forced_off;
+
 	/* Net shaper handle*/
 	struct net_shaper_handle handle;
 
@@ -713,10 +727,18 @@ int mana_detach(struct net_device *ndev, bool from_close);
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
 		    u32 priv_flags, struct mana_qset *out);
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old);
+void mana_publish_close_if_needed(struct mana_port_context *apc);
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
-- 
2.43.0

