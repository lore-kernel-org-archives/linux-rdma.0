Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3083F484B;
	Tue, 11 Aug 2026 06:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430139; cv=none; b=hNyZr+6ePKJAiRKI9um9+lmoDmlKztE54R8+xOhmBBFfuvSH3ObFhfihzupA67E1G7ZiQehIZC+RkPxlcXfcZs78Fj2xh1OhvWVHFMuj0ovWBF34wk2q2BvyH4mrqsQ/89Ouh2+UJ7a5r2RrdF41dyXY3aen3rH/6ezgkoqoU2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430139; c=relaxed/simple;
	bh=jkPG3D0RO25WOdFIGxiMnCIW9USLXslmNqAa3mUYFsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBkSXvMQ6IV4xqwNHThJA3CBpno39Dyi/cBv0LslZyr39ytfeg+Oo8mwkkAT60j6GIgZxHucG+o7X1uY7XOqB9KOlsevSHOXE4o55imwYkFnLKEIfJHK7mLEiWtsMJfN7OV4Upsa4YQRt25sQfsM2lG1mSBol1L0ILC79R1hyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 205B220B710C; Mon, 10 Aug 2026 23:35:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 205B220B710C
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
Subject: [PATCH net-next v2 02/13] net: mana: swap queue sets in mana_set_channels
Date: Mon, 10 Aug 2026 23:34:59 -0700
Message-ID: <20260811063506.2428213-3-longli@microsoft.com>
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

Add mana_publish_qset(), which installs a queue set built by
mana_alloc_qset() onto the live port context and hands the previous set
back to the caller, and use it to convert mana_set_channels() away from
detach/attach.

The publish ordering is:

  carrier off -> netif_tx_disable -> swap pointers -> update netdev
  queue counts -> reprogram RSS/steering -> netif_tx_start_all_queues
  -> carrier restore

netif_tx_disable() is load-bearing. mana_start_xmit() dereferences
apc->tx_qp[] guarded only by apc->port_is_up, so swapping the array with
TX live would let an in-flight xmit use a pointer that the caller is
about to free, and would let ndo_select_queue() hand out an index
derived from a stale real_num_tx_queues.

The old set's NAPI keeps running between the swap and mana_free_qset().
That is safe: the old CQs and RQs are still fully constructed, and
mana_destroy_txq()/mana_destroy_rxq() perform napi_synchronize() and
napi_disable_locked() before freeing anything.

If mana_publish_qset() fails partway it reinstalls the old set and
points steering back at it, so the caller only has to free the new set.

For mana_set_channels() this removes the failure mode entirely. The new
queues are built before anything is torn down, so an allocation failure
returns the error with the running configuration untouched, and the
value the user asked for is never silently replaced by a fallback. The
vport is never released, so vport_use_count stays above zero and RDMA
cannot claim it mid-reconfiguration.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   7 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 402 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 103 ++++-
 include/net/mana/mana.h                       |  13 +
 4 files changed, 502 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index ca602e27044f92b87295cbc2de924adc71efa780..e16ce2a0715839594a5837288c1d4c1de412e7fb 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -59,6 +59,13 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 	if (unlikely(!apc->port_is_up))
 		return 0;
 
+	/* Pair with the smp_wmb() in mana_publish_qset(), as mana_start_xmit()
+	 * does. This path is gated only by the flag above, so without the
+	 * barrier it could pick q_idx from a stale real_num_tx_queues and
+	 * index a freshly installed, smaller apc->tx_qp[].
+	 */
+	smp_rmb();
+
 	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
 
 	for (i = 0; i < n; i++) {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index bf15222deb77679257f46d36800fdc4006c612a0..5f682e3d5a706149954764d083b70f25906f28df 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -363,6 +363,23 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (unlikely(!apc->port_is_up))
 		goto tx_drop;
 
+	/* Pair with the smp_wmb() in mana_publish_qset(): a queue set can be
+	 * replaced while the port stays up, and the gate above is what says
+	 * the new one is installed. The check below and the dereference must
+	 * not be satisfied from before it, or a stale apc->num_queues would
+	 * admit an index that is past the end of a freshly shrunk
+	 * apc->tx_qp[]. A control dependency does not order loads.
+	 */
+	smp_rmb();
+
+	/* The stack keeps skb->queue_mapping below real_num_tx_queues, but an
+	 * XDP_TX from a queue set that is being retired carries the index of
+	 * its own RX queue, which can be past the end of a smaller replacement
+	 * apc->tx_qp[]. Drop rather than dereference outside the array.
+	 */
+	if (unlikely(txq_idx >= apc->num_queues))
+		goto tx_drop_count;
+
 	if (skb_cow_head(skb, MANA_HEADROOM))
 		goto tx_drop_count;
 
@@ -1042,6 +1059,12 @@ static void mana_cleanup_indir_table(struct mana_port_context *apc)
 
 static int mana_init_port_context(struct mana_port_context *apc)
 {
+	/* A port reconfigured while down already has an apc->rxqs sized for
+	 * the new queue count, and mana_detach() takes its "already detached"
+	 * early return without releasing it. Free it rather than overwrite
+	 * the pointer.
+	 */
+	kfree(apc->rxqs);
 	apc->rxqs = kzalloc_objs(struct mana_rxq *, apc->num_queues);
 
 	return !apc->rxqs ? -ENOMEM : 0;
@@ -2015,6 +2038,12 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
+	/* The retiring test is ordered by the same barrier. Reaching it with
+	 * txq_stopped set means the queue that replaced this one has already
+	 * run and stopped net_txq, which happens strictly after
+	 * mana_publish_qset() marked this queue retiring and reopened the
+	 * gate, so the flag read here cannot predate that store.
+	 */
 	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
 	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
@@ -3890,10 +3919,16 @@ static int mana_dealloc_queues(struct net_device *ndev)
  * The swap path builds a *new* set of EQs/TXQs/RXQs while the current set
  * keeps serving traffic. If allocation fails the current qset is untouched
  * and we return the error; the user's requested value is never silently
- * replaced by a fallback. Publishing a new set onto the live port
- * context is added separately. The vport is never torn down: vport_use_count
+ * replaced by a fallback. Once the new qset is ready we publish it onto apc
+ * and destroy the old one. The vport is never torn down: vport_use_count
  * stays at 1 throughout, so RDMA cannot hijack it.
  *
+ * The cost of never dropping the working queues is that a rebuild needs room
+ * for both sets at once, so one at the vport's maximum queue count can be
+ * refused by the firmware where a teardown-first sequence would have fit.
+ * That surfaces as a failed ethtool operation with the port still running on
+ * its previous queues, which is the trade this path exists to make.
+ *
  * Allocation and teardown run against a *scratch* mana_port_context rather
  * than the live one. This is essential, not cosmetic: an earlier revision
  * temporarily NULLed apc->tx_qp so the allocators could
@@ -4079,6 +4114,353 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	return err;
 }
 
+/* Stop the device delivering into whichever queue set steering still names.
+ *
+ * Used when mana_publish_qset() cannot restore a consistent configuration:
+ * the caller is about to free the set that was being published, and steering
+ * may still point at it. Disabling vport RX stops delivery to every RQ of
+ * this vport, so destroying those queues afterwards is safe; the fence then
+ * waits for RX the device had already accepted. Same order as the teardown
+ * in mana_dealloc_queues(). The port is left down; a down/up rebuilds it.
+ */
+/* Last resort when a swap fails and the previous queue set cannot be put back
+ * the way it was.
+ *
+ * Leaving the port up is not an option: the netdev queue counts no longer
+ * describe apc->tx_qp[], or steering no longer matches apc->rxqs[]. Leaving it
+ * merely stopped is not either, because apc->port_is_up would be false while
+ * the queues are still allocated, and mana_detach() only tears queues down
+ * when it observes the port up. A later close would skip the teardown and the
+ * next open would trip WARN_ON(apc->eqs) in mana_create_eq(), leaving the port
+ * unusable for good.
+ *
+ * So close it properly: destroy what is installed and leave the clean
+ * "administratively down" state that mana_open() knows how to rebuild from.
+ */
+/**
+ * mana_publish_close_if_needed - close a port mana_publish_qset() gave up on
+ * @apc: port context
+ *
+ * mana_publish_qset() cannot do this itself. Closing destroys the shared EQ
+ * pool, and the queue set it failed to publish still owns CQs attached to
+ * those EQs, so the EQs have to go last - the same order mana_dealloc_queues()
+ * uses. Only the caller knows how to release that set, since a rebuild owns
+ * its queues outright while a grow or a shrink shares some with the live set.
+ * So the caller releases it first and calls this afterwards.
+ *
+ * RX delivery is already off by then: mana_publish_qset() disables vport RX
+ * before it gives up, so the caller is never freeing queues the device can
+ * still write into.
+ *
+ * Does nothing unless mana_publish_qset() actually hit that dead end. Must be
+ * called under RTNL.
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
+	/* mana_dealloc_queues() requires the port already marked down, which
+	 * mana_publish_qset() did before the swap it is unwinding.
+	 */
+	if (mana_dealloc_queues(apc->ndev))
+		netdev_err(apc->ndev,
+			   "failed to close the port after a failed rollback\n");
+}
+
+/* Start the netdev queues that can actually take work.
+ *
+ * netif_tx_disable() stops every queue for the duration of a swap, including
+ * one that is carried over with its ring already full. Starting that queue
+ * again unconditionally would hand the stack a queue with no room, and
+ * mana_start_xmit() would drop the packet it gets. Leave those stopped: the
+ * completion that frees space wakes them through mana_poll_tx_cq(), the same
+ * way it would have without a swap. Must run after apc->port_is_up is set,
+ * or that wakeup path is still gated off.
+ */
+static void mana_start_txqs(struct mana_port_context *apc)
+{
+	struct net_device *ndev = apc->ndev;
+	unsigned int i;
+
+	if (!apc->tx_qp)
+		return;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		if (mana_can_tx(apc->tx_qp[i]->txq.gdma_sq))
+			netif_tx_wake_queue(netdev_get_tx_queue(ndev, i));
+	}
+}
+
+/* Mark or unmark every TX queue in @qset as on its way out.
+ *
+ * A retiring queue shares its struct netdev_queue with whatever replaced it
+ * at the same index, and it only ever drains, so it always looks like it has
+ * room. Without this flag its completions would wake a netdev queue that the
+ * live queue stopped because its ring was full.
+ *
+ * A queue that both sets own, which is what a grow or a shrink carries over,
+ * must end up unmarked: callers apply this to the set that is leaving first
+ * and to the set that is becoming live second.
+ */
+static void mana_qset_set_retiring(struct mana_qset *qset, bool retiring)
+{
+	unsigned int q;
+
+	if (!qset->tx_qp)
+		return;
+
+	for (q = 0; q < qset->num_queues; q++) {
+		if (qset->tx_qp[q])
+			WRITE_ONCE(qset->tx_qp[q]->txq.retiring, retiring);
+	}
+}
+
+/* Give up on a swap: the port has to go down, and the caller is about to free
+ * a queue set that steering may still point at.
+ *
+ * mana_free_qset() skips the vport-level RX disable because a completed
+ * publish has already repointed steering at the set that stays. Here it has
+ * not: restoring steering is exactly what failed. So stop the device
+ * delivering now, before the caller destroys those RQs and frees the buffers
+ * the device would otherwise keep writing into.
+ *
+ * This is the narrow steering request - no key, indirection table or
+ * default-rxobj update - so it can still land where the full
+ * mana_config_rss() restore did not.
+ *
+ * Only RX delivery is stopped here. Destroying the port is left to
+ * mana_publish_close_if_needed(), because that tears down the shared EQ pool,
+ * which has to outlive the CQs the caller has yet to release.
+ */
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
+	apc->publish_dead_end = true;
+}
+
+/**
+ * mana_publish_qset - swap @newq onto @apc, returning the old set
+ * @apc:      live port context
+ * @newq:     new queue set (from mana_alloc_qset)
+ * @out_old:  filled with the previous queue set, for the caller to free
+ *
+ * Publishes the new set in this order:
+ *
+ *   carrier off -> netif_tx_disable -> swap pointers -> update netdev
+ *   queue counts -> reprogram RSS/steering -> reattach XDP ->
+ *   netif_tx_start_all_queues -> carrier restore
+ *
+ * netif_tx_disable() is load-bearing: mana_start_xmit() dereferences
+ * apc->tx_qp[] guarded only by apc->port_is_up, so swapping the array with
+ * TX live would let an in-flight xmit use a stale pointer. Stopping the
+ * queues also keeps ndo_select_queue() from handing out an index derived
+ * from a stale real_num_tx_queues. ndo_xdp_xmit() does not go through the
+ * txq-stopped checks at all, so apc->port_is_up is cleared across the same
+ * window to fence it out.
+ *
+ * On failure the old set is reinstalled and steering pointed back at it,
+ * so the caller only has to free @newq.
+ *
+ * Must be called under RTNL.
+ *
+ * NOTE: the old set's NAPI keeps running until mana_free_qset(); that is
+ * safe because the old CQs/RQs are still fully constructed, and
+ * mana_destroy_txq()/mana_destroy_rxq() perform napi_synchronize() +
+ * napi_disable_locked() before freeing anything.
+ */
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old)
+{
+	struct net_device *ndev = apc->ndev;
+	bool carrier_ok;
+	int err;
+
+	ASSERT_RTNL();
+
+	carrier_ok = netif_carrier_ok(ndev);
+	netif_carrier_off(ndev);
+
+	/* Clear port_is_up before stopping the queues, and pair the store with
+	 * the smp_rmb() in mana_poll_tx_cq(). That reader samples
+	 * netif_tx_queue_stopped() first, so publishing in this order means a
+	 * completion that sees a queue this function stopped also sees
+	 * port_is_up false and will not wake it back up mid-swap. This is the
+	 * same protocol mana_detach() uses; doing it the other way round let a
+	 * TX completion re-enable a queue that had just been disabled.
+	 *
+	 * It also fences ndo_xdp_xmit(): mana_xdp_xmit() runs from a
+	 * redirecting device's NAPI, bypasses the txq-stopped checks and is
+	 * gated only by apc->port_is_up. Left running it could pick q_idx from
+	 * a real_num_tx_queues that no longer matches the freshly installed
+	 * (possibly smaller) apc->tx_qp[], or dereference the retiring array.
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
+	/* Mark the outgoing set before the grace period below, not after it.
+	 * A completion that samples the flag clear must not still be in
+	 * flight once the new set is installed and the gate reopens, or it
+	 * could resume and wake a netdev queue that the queue replacing it
+	 * had already stopped because its ring was full.
+	 */
+	mana_qset_set_retiring(out_old, true);
+
+	/* Wait out any transmit or ndo_xdp_xmit() that was already past the
+	 * port_is_up test before the swap touches apc->tx_qp / the counts,
+	 * and any completion that still saw the flag clear above.
+	 */
+	synchronize_net();
+
+	/* Whatever the incoming set carries over from the outgoing one is
+	 * staying, so it is not retiring. Ordered after the marking above,
+	 * and still before the gate reopens.
+	 */
+	mana_qset_set_retiring(newq, false);
+
+	mana_qset_install(apc, newq);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	err = netif_set_real_num_rx_queues(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	/* Carry the XDP program over to the new RXQs before steering can
+	 * reach them; they were created with bpf_prog == NULL, so a packet
+	 * arriving first would take the pass path despite a program being
+	 * attached. This also takes the per-queue references that
+	 * mana_free_qset() drops for the old set.
+	 */
+	mana_chn_setxdp(apc, mana_xdp_get(apc));
+
+	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
+	if (err)
+		goto rollback;
+
+	/* Pair with the queue-state stores above: a datapath reader that sees
+	 * the gate open must also see the queue set it is about to index.
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+	if (carrier_ok)
+		netif_carrier_on(ndev);
+
+	return 0;
+
+rollback:
+	netdev_err(ndev, "mana_publish_qset failed: %d, restoring previous queue set\n",
+		   err);
+
+	/* The roles are swapped now: @newq is the set going away and @out_old
+	 * is live again. Same ordering rule, leaving set first.
+	 */
+	mana_qset_set_retiring(newq, true);
+	mana_qset_set_retiring(out_old, false);
+
+	mana_qset_install(apc, out_old);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	if (netif_set_real_num_tx_queues(ndev, apc->num_queues) ||
+	    netif_set_real_num_rx_queues(ndev, apc->num_queues)) {
+		/* The netdev queue counts no longer describe the restored
+		 * apc->tx_qp[], so resuming TX could index past it. Leave the
+		 * port stopped and the carrier down instead; that is visible
+		 * to the admin and recoverable with a down/up.
+		 *
+		 * Steering can still point at @newq, which the caller frees
+		 * next, so shut RX down at the vport first.
+		 */
+		netdev_err(ndev, "failed to restore queue counts, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+	if (mana_config_rss(apc, TRI_STATE_TRUE, true, true)) {
+		/* Steering may still point at the queue set the caller is
+		 * about to free, and it cannot be repointed. Disable vport RX
+		 * so the device stops delivering into those queues before they
+		 * are destroyed, and stay down rather than run with steering
+		 * that does not match apc->rxqs[].
+		 */
+		netdev_err(ndev, "failed to restore RSS steering, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+	/* Same pairing as the success path: the restored queue set has to be
+	 * visible before the gate reopens on it.
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+	if (carrier_ok)
+		netif_carrier_on(ndev);
+
+	/* out_old is live again on apc; caller must only free newq. */
+	return err;
+}
+
+/**
+ * mana_qset_debugfs_publish - give live queues the debugfs nodes they lack
+ * @apc: live port context
+ *
+ * Queues built through a scratch context are created with debugfs suppressed,
+ * so that the incoming and outgoing sets do not fight over the same names
+ * under vport%d while both are alive. Once the retiring set is gone its names
+ * are free, and the queues that are now serving traffic can take them.
+ *
+ * Idempotent: a queue that already has a node, such as one carried over by a
+ * grow or a shrink, is left alone. Suppressed creation leaves the error
+ * pointer from the scratch parent behind rather than NULL, so both have to
+ * count as "no node". Must be called under RTNL.
+ */
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
 /**
  * mana_free_qset - tear down all queues in @qset
  * @scratch: scratch context from mana_qset_scratch_alloc()
@@ -4128,6 +4510,15 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	mana_qset_install(scratch, qset);
 
+	/* Teardown from here follows the same order as mana_dealloc_queues(),
+	 * with one exception: no vport-level RX disable. mana_publish_qset()
+	 * has already pointed steering at the incoming set, so nothing new is
+	 * delivered to these queues, and disabling vport RX would stop the set
+	 * that is now live. In the one case where it could not repoint
+	 * steering, it disabled vport RX itself before returning, so the
+	 * "nothing new is delivered" invariant holds there too.
+	 */
+
 	/* Note what this set owes the XDP program, but leave the queues
 	 * pointing at it. They are still polling, and a packet already in a
 	 * retiring RQ has to keep running the program rather than slip past
@@ -4193,6 +4584,13 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	scratch->rxqs = NULL;
 
 	memset(qset, 0, sizeof(*qset));
+
+	/* Queues built through a scratch context carry no debugfs nodes,
+	 * because both sets are alive during the swap and would collide on
+	 * the same names. The retiring set's nodes are gone now, so the
+	 * published queues can finally take those names.
+	 */
+	mana_qset_debugfs_publish(netdev_priv(scratch->ndev));
 }
 
 /* --- end of pre-allocate + swap reconfiguration path ---------------------- */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ece7ff9cc409a806b6a6de70a85b44874bfa6dad..43ae71eb6b5fecc8973bf7aea4ebbfffd19bd7cd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -650,50 +650,111 @@ static int mana_set_coalesce(struct net_device *ndev,
 
 /* mana_set_channels - change the number of queues on a port
  *
- * Returns -EBUSY if RDMA holds the vport with EQs sized to the
- * current num_queues.
+ * Uses the pre-allocate + swap path (mana_alloc_qset / mana_publish_qset
+ * / mana_free_qset). If allocation of the new queue set fails, the
+ * existing queues keep running unchanged and we simply return -ENOMEM;
+ * the user's requested setting is never silently mutated to a fallback
+ * value. The vport is never torn down, so RDMA cannot race in and take
+ * ownership of it during the reconfiguration window.
  */
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
+	/* If the port is administratively down there are no queues to swap,
+	 * so record the new count and resize the arrays that are indexed by
+	 * it. mana_open() will use the new value.
+	 *
+	 * apc->rxqs has to grow here: it is sized by apc->num_queues in
+	 * mana_init_port_context(), and mana_open() goes straight to
+	 * mana_alloc_queues() without rebuilding the port context, so
+	 * mana_add_rx_queues() would write past the end of the old array.
+	 *
+	 * RDMA can still own the vport while the ethernet port is down, and
+	 * it derives an EQ from apc->eqs[] modulo apc->num_queues, so the
+	 * count must not move underneath it. Take the same mutex the swap
+	 * path uses and refuse the change while the vport is in use.
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
+	/* Block RDMA from acquiring the vport for the duration. Unlike the
+	 * detach/attach path this is a much shorter window and the vport
+	 * never actually goes idle (vport_use_count stays > 0).
+	 *
+	 * Deliberately no vport_use_count test here, unlike the port-down
+	 * branch above: bringing the port up takes the vport itself
+	 * (mana_create_vport()), so the count is always non-zero at this
+	 * point and testing it would fail every call. That reference is also
+	 * what makes the swap safe, since mana_cfg_vport() refuses a second
+	 * holder and RAW QPs - the only users of apc->eqs[] modulo
+	 * apc->num_queues - cannot exist while the ethernet port owns it.
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
+	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
+			      apc->tx_queue_size, apc->priv_flags, &newq);
+	if (err)
+		goto free_scratch; /* current qset untouched, nothing to undo */
 
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
+	/* After the caller-side cleanup above, so the EQ pool outlives the
+	 * CQs that reference it.
+	 */
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 4727c231bf0391bd9a1e9ff15c65815a6a3d01dd..e4aaad7bec34297cf406181560a1839d3e6a73df 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -634,6 +634,16 @@ struct mana_port_context {
 	 */
 	bool channel_changing;
 
+	/* mana_publish_qset() could neither publish the new queue set nor put
+	 * the previous one back. It has already disabled vport RX, so nothing
+	 * is being delivered; what is left is closing the port, and that can
+	 * only happen after the caller has torn down the set it was trying to
+	 * publish: those queues own CQs attached to the shared EQ pool, and
+	 * closing destroys that pool. Checked through
+	 * mana_publish_close_if_needed().
+	 */
+	bool publish_dead_end;
+
 	/* Net shaper handle*/
 	struct net_shaper_handle handle;
 
@@ -730,6 +740,9 @@ void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out);
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old);
+void mana_publish_close_if_needed(struct mana_port_context *apc);
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
-- 
2.43.0

