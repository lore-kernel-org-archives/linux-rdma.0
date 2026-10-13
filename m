Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E865955409A;
	Tue, 13 Oct 2026 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928193; cv=none; b=YR5s3OtDGBUhVWPv3k/ynEws/0gswX8yLLMNkvBhvn1CP7dFmpB/wuAwG2r8sjhblEzbICZ/KbgnxelFCDIjX8TJ18xX2e0ab8NC5F+Xq/O/sJoY4gTZo6ZFTzUOmvCyMW6I6D6gcRj6ZNVUcQ40yZysY4UKv82fmoLn54bz/pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928193; c=relaxed/simple;
	bh=uafM/k/ZpxIftMCIx+N84qLs/csI8HotPy+mhkiDgIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E0EsJUzC7Ks2ru89Uu4X7WMetcXWqvo7QJduLGU/JUX/d7MkLqeUOgq5J25wLgrN3qjNUo0UiXVFfz79abc8BMpcgK010bT7a/EH68DSbXulsIFJEQ6eR7wgE6Ou94khZ75IWQJFkNhjNrgJR2njcZLL6WauDijauJLBWTVsblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=g6dO4B8X; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="g6dO4B8X"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 4A2D220B7166; Tue, 13 Oct 2026 14:49:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A2D220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791928188;
	bh=JJsNfB3bYrURaeP+0z1MCT4fNL6QGoZz1pHkN9KStOs=;
	h=From:To:Cc:Subject:Date:From;
	b=g6dO4B8XMZx5W+Rf5kEbaLyG0xBYOSY+0LmO7C4lV2oHkcVhJ3N5S8jdrjhB8MEzM
	 qcVUBTFlycvOPPVYxNaiF7SXrOI5DuCpQEJjXZfzC1e+6IQxBsr86nZd8v/07OJGlu
	 kwXmUQAtKkEe+Z5qWsdq14TWyzvtd8wApLvUMp0c=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: netdev@vger.kernel.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH net-next v3] net: mana: add BQL support
Date: Tue, 13 Oct 2026 17:49:37 -0400
Message-ID: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MANA doesn't support byte queue limits, so each TX queue can hold 256
WQEs by default, and up to 16384, of up to 64 KB TSO packets, before the
qdisc layer sees any backpressure. This adds latency to all the flows
sharing a queue, and defeats AQM qdiscs such as fq_codel, which rely on
BQL to keep the driver queues short.

Report the bytes queued and completed to BQL, except for the XDP_TX and
XDP_REDIRECT frames. These share the SQs, but bypass the qdisc and are
sent even when the queue is stopped, so BQL can't hold them back.
Counting them would let sustained XDP traffic keep the queue stopped,
starving the stack, and the TX watchdog would then either fire while the
completions still arrive, or, if the XDP sends refreshed trans_start,
not fire when the completions stop. The XDP SKBs are marked in their
skb->cb, next to the WQE size, so that their completions are skipped as
well.

Reset the BQL state when destroying the queues, once their NAPI is
disabled, since the SKBs still pending after a drain timeout are freed
without being completed.

Lost TX completions can now stop a queue sooner: it also stops when the
bytes in flight exceed the BQL limit, not only when the SQ is full, and
the limit may never grow enough to cover the lost bytes. This includes
the completions skipped by the WARN_ON_ONCE() early returns in
mana_poll_tx_cq(), which already leak SQ space: completing the SKBs
already freed there wouldn't reliably balance BQL, since
mana_gd_poll_cq() has already consumed the CQEs of the rest of the
batch. The TX watchdog then fires, as nothing refreshes the trans_start
of a queue stopped by BQL, and its handler resets the queues along with
their BQL state. The exception, as before this patch, is XDP traffic
keeping the SQ full: each XDP send then stops the queue again,
refreshing its trans_start.

Tested on two Standard_D16ds_v6 Azure VMs in a proximity placement
group, where the throughput is capped at 10.6 Gbps, with the DUT
alternately booting net-next (c1c1f0a31712) with and without this patch
applied.

The throughput stays at the cap with 1, 8 and 64 TCP flows, and the idle
TCP_RR latency doesn't change (p50 of 47 us with vs. without the patch).
With 16 senders of 64-byte UDP packets, the DUT sends 3.7 to 4.0 Mpps
without the patch and 3.7 to 4.1 Mpps with it. With bulk TCP flows
sharing the queues, the netperf TCP_RR latency drops (medians of 6
runs):

  16 queues, 64 flows: p50 4649 -> 2182 us, p99 5621 -> 2677 us
  1 queue, 8 flows:    p50 2554 ->  418 us, p99 2723 ->  624 us

The standing queue moves from the SQs to fq_codel, which now drops
packets: about 2500 qdisc drops and 88K TCP retransmissions per 48 s run
with 64 flows, against at most 29 retransmissions before. The
retransmissions are about 0.2% of the segments sent. The TCP_RR flows
lose no packets, and the packets of the bulk flows are dropped before
they reach the wire, so the goodput changes by less than 0.01%.

Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
v2: Only count the bytes of the packets sent on a stopped queue, so that
    XDP traffic doesn't keep the TX watchdog from firing on a queue
    stopped by BQL. (Sashiko)
v3: Leave the XDP frames out of BQL, rather than only counting the bytes
    of the packets sent on a stopped queue, which let sustained XDP
    traffic keep a queue stopped and trip the TX watchdog with a large
    SQ, and let a stack packet past the BQL limit when the SQ filled.
    Note in the commit message that, as before this patch, XDP traffic
    keeping the SQ full holds the watchdog off, and why the early
    returns in mana_poll_tx_cq() are left alone. (Sashiko)
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 52 ++++++++++++++++---
 include/net/mana/mana.h                       |  2 +
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 484f061bc75e..7c55f8724441 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -21,7 +21,7 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
 	ndevtxq = netdev_get_tx_queue(ndev, txq_idx);
 	__netif_tx_lock(ndevtxq, smp_processor_id());
 
-	rc = mana_start_xmit(skb, ndev);
+	rc = __mana_start_xmit(skb, ndev, true);
 
 	__netif_tx_unlock(ndevtxq);
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 489558176a5d..6b7c027e497e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -346,7 +346,14 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 	rtnl_unlock();
 }
 
-netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+/* skb->cb of the SKBs pending a TX completion */
+struct mana_skb_cb {
+	struct gdma_posted_wqe_info wqe_info;
+	bool xdp;
+};
+
+netdev_tx_t __mana_start_xmit(struct sk_buff *skb, struct net_device *ndev,
+			      bool xdp)
 {
 	enum mana_tx_pkt_format pkt_fmt = MANA_SHORT_PKT_FMT;
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -360,6 +367,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct gdma_queue *gdma_sq;
 	int err, len, num_gso_seg;
 	unsigned int csum_type;
+	struct mana_skb_cb *cb;
 	struct mana_txq *txq;
 	struct mana_cq *cq;
 
@@ -520,14 +528,16 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		goto free_sgl_ptr;
 	}
 
+	cb = (struct mana_skb_cb *)skb->cb;
+	cb->xdp = xdp;
+
 	skb_queue_tail(&txq->pending_skbs, skb);
 
 	len = skb->len;
 	num_gso_seg = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	net_txq = netdev_get_tx_queue(ndev, txq_idx);
 
-	err = mana_gd_post_work_request(gdma_sq, &pkg.wqe_req,
-					(struct gdma_posted_wqe_info *)skb->cb);
+	err = mana_gd_post_work_request(gdma_sq, &pkg.wqe_req, &cb->wqe_info);
 	if (!mana_can_tx(gdma_sq)) {
 		netif_tx_stop_queue(net_txq);
 		apc->eth_stats.stop_queue++;
@@ -543,6 +553,14 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	err = NETDEV_TX_OK;
 	atomic_inc(&txq->pending_sends);
 
+	/* Account the skb in BQL before the doorbell lets the hardware
+	 * complete it. XDP frames bypass the qdisc and BQL can't hold them
+	 * back, so leave them out: XDP traffic could otherwise keep the
+	 * queue stopped, starving the stack and tripping the TX watchdog.
+	 */
+	if (!xdp)
+		netdev_tx_sent_queue(net_txq, len);
+
 	mana_gd_wq_ring_doorbell(gd->gdma_context, gdma_sq);
 
 	/* skb may be freed after mana_gd_post_work_request. Do not use it. */
@@ -574,6 +592,11 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	return __mana_start_xmit(skb, ndev, false);
+}
+
 #if (MAX_SKB_FRAGS + 2 > MANA_MAX_TX_WQE_SGL_ENTRIES)
 static netdev_features_t mana_features_check(struct sk_buff *skb,
 					     struct net_device *ndev,
@@ -1938,9 +1961,10 @@ void mana_unmap_skb(struct sk_buff *skb, struct mana_port_context *apc)
 static void mana_poll_tx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *completions = cq->gdma_comp_buf;
-	struct gdma_posted_wqe_info *wqe_info;
 	unsigned int pkt_transmitted = 0;
 	unsigned int wqe_unit_cnt = 0;
+	unsigned int bql_bytes = 0;
+	unsigned int bql_pkts = 0;
 	unsigned int tx_bytes = 0;
 	struct mana_txq *txq = cq->txq;
 	struct mana_port_context *apc;
@@ -1948,6 +1972,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	struct gdma_queue *gdma_wq;
 	unsigned int avail_space;
 	struct net_device *ndev;
+	struct mana_skb_cb *cb;
 	struct sk_buff *skb;
 	bool txq_stopped;
 	int comp_read;
@@ -2018,12 +2043,16 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 		if (WARN_ON_ONCE(!skb))
 			return;
 
-		wqe_info = (struct gdma_posted_wqe_info *)skb->cb;
-		wqe_unit_cnt += wqe_info->wqe_size_in_bu;
+		cb = (struct mana_skb_cb *)skb->cb;
+		wqe_unit_cnt += cb->wqe_info.wqe_size_in_bu;
 
 		mana_unmap_skb(skb, apc);
 
 		tx_bytes += skb->len;
+		if (!cb->xdp) {
+			bql_pkts++;
+			bql_bytes += skb->len;
+		}
 
 		napi_consume_skb(skb, cq->budget);
 
@@ -2038,10 +2067,12 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	gdma_wq = txq->gdma_sq;
 	avail_space = mana_gd_wq_avail_space(gdma_wq);
 
+	net_txq = txq->net_txq;
+	netdev_tx_completed_queue(net_txq, bql_pkts, bql_bytes);
+
 	/* Ensure tail updated before checking q stop */
 	smp_mb();
 
-	net_txq = txq->net_txq;
 	txq_stopped = netif_tx_queue_stopped(net_txq);
 
 	/* Ensure checking txq_stopped before apc->port_is_up. */
@@ -2694,6 +2725,13 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			apc->tx_qp[i]->txq.napi_initialized = false;
 		}
 
+		/* Forget the SKBs freed without being completed after a drain
+		 * timeout, now that NAPI can't complete any. Doing it here also
+		 * covers the queues that a lower channel count won't recreate,
+		 * which could otherwise stay stopped.
+		 */
+		netdev_tx_reset_queue(apc->tx_qp[i]->txq.net_txq);
+
 		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE)
 			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 8c3dc9d0b299..e1fa9131c490 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -672,6 +672,8 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
+netdev_tx_t __mana_start_xmit(struct sk_buff *skb, struct net_device *ndev,
+			      bool xdp);
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
-- 
2.56.0

