Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EAD3C5832;
	Tue,  1 Sep 2026 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227131; cv=none; b=pw28oSXim84h3bG9qXVyEg6BY/iUoEfaDO8lKaRYPvUXso/7z/gGxYrrlneHY4BO7ylMwEF3wlOnGWns4wrm69PX4VFNulPXLWeSV6l3xAsm9W1+KbV3xqs/nADUIzujxGEF6Eff52XHbg/s8yvvY1qevyDSna2ESIjMhpGxFHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227131; c=relaxed/simple;
	bh=WAZMQTw0W8rnvXHXcT0ve1WPPPpJEc+BW2ipyOFzECI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTeX/HYll+70A9apH0ppMgXwHAA+rqDhH35cERfL95iPZaU0FzNIYD84hyHXNR7NIvz3r5PH6Uc66B8vOlR5V/fMAaRA0jV2n2iiA9aWbYgPwzp7bz/CSL54wLSa71xKa0t776aFN1/uXWRtaTMYOutZpKDDbx0AKRGKH2Ul71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id AAF7920B7129; Mon, 31 Aug 2026 18:44:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AAF7920B7129
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
Subject: [PATCH net-next v3 03/13] net: mana: swap queue sets in mana_set_channels
Date: Mon, 31 Aug 2026 18:44:32 -0700
Message-ID: <20260901014442.2945689-4-longli@microsoft.com>
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

Convert the channel count path away from detach/attach: build the new
queue set while the current one keeps serving traffic, then swap it in
and retire the old one.

An allocation failure now returns the error with the running
configuration untouched, instead of leaving the port down, and the value
the user asked for is never silently replaced by a fallback. The vport is
never released, so RDMA cannot claim it mid-reconfiguration. If the swap
itself fails the previous set is put back and the port keeps running on
it.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   7 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 386 ++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  92 +++--
 include/net/mana/mana.h                       |  18 +
 4 files changed, 455 insertions(+), 48 deletions(-)

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
index bd80658cf3efc4522ca51fc039242ae91669ea88..880a3ba37fd3e872dbfeb101c46ac8f527c4bbdd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -90,6 +90,25 @@ static int mana_open(struct net_device *ndev)
 	smp_wmb();
 
 	netif_tx_wake_all_queues(ndev);
+
+	/* A failed queue-set swap can dead-end the port and take the carrier
+	 * down. The link handler only reacts to real hardware transitions, so
+	 * this open is the one place that can undo it.
+	 *
+	 * Defer to the last thing the hardware said, though: ac->link_event is
+	 * written when the event arrives, before its work item gets to run, so
+	 * a disconnect already sitting behind RTNL is visible here. Restoring
+	 * the carrier on that would advertise a link the device has told us is
+	 * gone, and the handler would only correct it afterwards.
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
@@ -106,6 +125,7 @@ static int mana_close(struct net_device *ndev)
 
 static void mana_link_state_handle(struct work_struct *w)
 {
+	struct mana_port_context *apc;
 	struct mana_context *ac;
 	struct net_device *ndev;
 	u32 link_event;
@@ -131,6 +151,16 @@ static void mana_link_state_handle(struct work_struct *w)
 		if (!ndev)
 			continue;
 
+		/* The hardware has spoken, so it owns the carrier from here.
+		 * Drop any claim a failed queue-set swap left behind: the
+		 * flag records that this driver removed a working carrier,
+		 * which stops being true the moment the physical state
+		 * changes. Leaving it set would let a later open assert
+		 * carrier-up on a link the hardware has just reported down.
+		 */
+		apc = netdev_priv(ndev);
+		apc->carrier_forced_off = false;
+
 		if (link_up) {
 			netif_carrier_on(ndev);
 
@@ -366,6 +396,18 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (unlikely(!apc->port_is_up))
 		goto tx_drop;
 
+	/* Pair with the smp_wmb() in mana_publish_qset(). A control dependency
+	 * does not order loads, and a stale apc->num_queues would admit an
+	 * index past the end of a freshly shrunk apc->tx_qp[].
+	 */
+	smp_rmb();
+
+	/* XDP_TX from a retiring set carries its own RX queue index, which can
+	 * be past the end of a smaller replacement apc->tx_qp[].
+	 */
+	if (unlikely(txq_idx >= apc->num_queues))
+		goto tx_drop_count;
+
 	if (skb_cow_head(skb, MANA_HEADROOM))
 		goto tx_drop_count;
 
@@ -1045,6 +1087,11 @@ static void mana_cleanup_indir_table(struct mana_port_context *apc)
 
 static int mana_init_port_context(struct mana_port_context *apc)
 {
+	/* A port reconfigured while down already has an apc->rxqs, and
+	 * mana_detach() takes its "already detached" early return without
+	 * releasing it. Free it rather than overwrite the pointer.
+	 */
+	kfree(apc->rxqs);
 	apc->rxqs = kzalloc_objs(struct mana_rxq *, apc->num_queues);
 
 	return !apc->rxqs ? -ENOMEM : 0;
@@ -2091,6 +2138,10 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
+	/* Ordered by the same barrier: reaching here with txq_stopped set means
+	 * the replacement queue has already run, which is strictly after this
+	 * queue was marked retiring.
+	 */
 	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
 	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
@@ -4094,6 +4145,289 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	return err;
 }
 
+/* Close a port mana_publish_qset() gave up on; does nothing otherwise. Under
+ * RTNL.
+ *
+ * The caller releases the unpublished set first: closing destroys the shared
+ * EQ pool its CQs attach to, and only the caller knows whether it owns its
+ * queues or shares them with the live set. RX is already off.
+ *
+ * Merely stopping the port would leave port_is_up false with queues still
+ * allocated, so mana_detach() skips teardown and the next open trips
+ * WARN_ON(apc->eqs).
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
+/* Start only the netdev queues that can take work. A carried-over queue may
+ * still have a full ring, and restarting it would just make mana_start_xmit()
+ * drop; leave it for mana_poll_tx_cq() to wake. Must run after port_is_up is
+ * set, or that wakeup is gated off.
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
+/* A retiring queue shares its struct netdev_queue with whatever replaced it
+ * at the same index, and only ever drains, so it always looks like it has
+ * room. Without this flag its completions would wake a netdev queue that the
+ * live queue stopped on a full ring.
+ *
+ * A queue both sets own must end up unmarked, so callers mark the leaving set
+ * first and unmark the incoming one second.
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
+/* Give up on a swap. Steering may still point at the set the caller is about
+ * to free, and restoring it is exactly what failed, so stop delivery before
+ * those RQs and their buffers go away. This is the narrow steering request -
+ * no key, table or default-rxobj update - so it can land where the full
+ * mana_config_rss() restore did not.
+ *
+ * The carrier goes down here and stays down: this is the one outcome where
+ * the port really is out of service, so the link state should say so.
+ *
+ * Closing the port is left to mana_publish_close_if_needed(), which must run
+ * after the caller has released that set.
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
+	/* Only claim the carrier if it was actually up: the flag means "this
+	 * driver took a working carrier away", which is the only case
+	 * mana_open() may undo. If the link was already down for a hardware
+	 * reason there is nothing to restore, and forcing it on at reopen
+	 * would report a link that does not exist - the physical state is
+	 * event-driven and mana_link_state_handle() stores none for us to
+	 * consult, so it must stay the authority in that case.
+	 */
+	apc->carrier_forced_off = netif_carrier_ok(apc->ndev);
+	netif_carrier_off(apc->ndev);
+	apc->publish_dead_end = true;
+}
+
+/* Swap @newq onto @apc, handing the previous set back in @out_old for the
+ * caller to free. On failure the old set is reinstalled and the caller frees
+ * only @newq. Must be called under RTNL.
+ *
+ * netif_tx_disable() is load-bearing: mana_start_xmit() dereferences
+ * apc->tx_qp[] guarded only by apc->port_is_up, and ndo_xdp_xmit() bypasses
+ * the txq-stopped checks, so port_is_up is cleared over the same window.
+ */
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old)
+{
+	struct net_device *ndev = apc->ndev;
+	int err;
+
+	ASSERT_RTNL();
+
+	/* The carrier is deliberately left alone. A swap that succeeds, and one
+	 * that rolls back onto the old set, both end with the port serving
+	 * traffic on the same link, so reporting a carrier transition would
+	 * make a reconfiguration look like a link flap to userspace - DHCP
+	 * renewals, bond failovers, monitoring alerts. Only the dead-end paths
+	 * take the carrier down, in mana_publish_give_up().
+	 *
+	 * Nothing is lost by that: netif_carrier_off() only sets a bit and
+	 * schedules linkwatch, which cannot run until this function drops
+	 * RTNL. The transmit quiesce below is what actually stops traffic.
+	 */
+
+	/* Clear port_is_up before stopping the queues, pairing with the
+	 * smp_rmb() in mana_poll_tx_cq(): that reader samples
+	 * netif_tx_queue_stopped() first, so a completion seeing a queue
+	 * stopped here also sees port_is_up false and will not wake it
+	 * mid-swap. It also fences mana_xdp_xmit(), which is gated only by
+	 * port_is_up and would otherwise index a stale apc->tx_qp[].
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
+	/* Mark the outgoing set before the grace period, not after: a
+	 * completion that saw the flag clear must not still be in flight when
+	 * the gate reopens, or it could wake a netdev queue that its
+	 * replacement had stopped on a full ring.
+	 */
+	mana_qset_set_retiring(out_old, true);
+
+	/* Wait out any transmit or ndo_xdp_xmit() that was already past the
+	 * port_is_up test before the swap touches apc->tx_qp / the counts,
+	 * and any completion that still saw the flag clear above.
+	 */
+	synchronize_net();
+
+	/* Anything the incoming set carries over is staying, so clear the flag
+	 * again - after the marking above, before the gate reopens.
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
+	/* Carry the XDP program over before steering can reach the new RXQs:
+	 * they were created with bpf_prog == NULL, so a packet arriving first
+	 * would bypass an attached program. This also takes the per-queue
+	 * references that mana_free_qset() drops for the old set.
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
+
+	return 0;
+
+rollback:
+	netdev_err(ndev, "%s failed: %d, restoring previous queue set\n",
+		   __func__, err);
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
+		 *
+		 * @err stays the failure that started the rollback: that is
+		 * what the caller asked about, and the port being left down is
+		 * reported above.
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
+
+	/* out_old is live again on apc; caller must only free newq. */
+	return err;
+}
+
+/* Give live queues the debugfs nodes suppressed while they were built in a
+ * scratch context, whose names would collide under vport%d. Once the retiring
+ * set is gone the survivors take them.
+ *
+ * Idempotent: a carried-over queue keeps its node; suppressed creation leaves
+ * an error pointer, not NULL, so both read as "no node". Under RTNL.
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
 /* Tear down @qset, no longer installed on @apc, against @scratch so the live
  * context never points at queues being freed.
  */
@@ -4117,41 +4451,36 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 		}
 	}
 
-	/* The datapath gates on apc->port_is_up and then dereferences
-	 * apc->tx_qp[] / apc->rxqs[] with no lock. The publish step drains
-	 * those readers before it installs the incoming set, which cannot
-	 * cover one that sampled the retiring pointers between that install
-	 * and the gate reopening. mana_xdp_xmit() is the case that matters:
-	 * it runs from a redirecting device's NAPI, so the napi_synchronize()
-	 * that mana_destroy_txq()/mana_destroy_rxq() do on this port's own
-	 * NAPIs never waits for it. Give any such reader a grace period to
-	 * finish before its queues are torn down under it. Every caller is a
-	 * reconfiguration path holding RTNL, so this is expedited.
+	/* A reader that sampled the retiring pointers after mana_publish_qset()
+	 * installed the new set is not covered by the drain it did earlier.
+	 * mana_xdp_xmit() is the case that matters: it runs from another
+	 * device's NAPI, which this port's napi_synchronize() never waits for.
 	 */
 	synchronize_net();
 
 	mana_qset_install(scratch, qset);
 
-	/* Note what this set owes the XDP program, but leave the queues
-	 * pointing at it. They are still polling, and a packet already in a
-	 * retiring RQ has to keep running the program rather than slip past
-	 * it into the stack. The references are dropped once the queues are
-	 * gone, below. XDP_TX from those polls is harmless here: it goes
-	 * through mana_start_xmit() on the live port context, so it reaches
-	 * the queue set that replaced this one, not the one being drained.
+	/* Teardown follows mana_dealloc_queues()' order, minus the vport RX
+	 * disable: steering already points at the incoming set, and disabling
+	 * vport RX would stop the set that is now live. Where publish could
+	 * not repoint steering it disabled vport RX itself, so nothing is
+	 * delivered here either way.
+	 */
+
+	/* Note what this set owes the XDP program but leave the queues
+	 * pointing at it: they are still polling, and a packet already in a
+	 * retiring RQ must keep running the program rather than slip into the
+	 * stack. The references are dropped once the queues are gone, below.
 	 */
 	retiring_prog = mana_chn_xdp_peek(scratch);
 	retiring_queues = scratch->num_queues;
 
-	/* The retiring TX queues may still hold packets the device has not
-	 * completed. Drain them before the SQs and the SKB queues go away,
-	 * or those SKBs and their DMA mappings are leaked.
+	/* Drain packets the device has not completed before the SQs and SKB
+	 * queues go away, or those SKBs and their DMA mappings are leaked.
 	 *
-	 * This runs before any RX teardown, the order mana_dealloc_queues()
-	 * uses. A device wedged badly enough to need the reset below is also
-	 * one whose RQ teardown will not complete, and unmapping RX buffers
-	 * first would leave it free to keep writing into them for as long as
-	 * the drain takes.
+	 * This runs before any RX teardown, as mana_dealloc_queues() does:
+	 * unmapping RX buffers first would leave a wedged device free to keep
+	 * writing into them for as long as the drain takes.
 	 */
 	if (mana_drain_txqs(scratch)) {
 		/* The drain had to reset the function to stop the device
@@ -4197,6 +4526,13 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
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
index ece7ff9cc409a806b6a6de70a85b44874bfa6dad..2ef3d461e707287f6c9dbb04288c8d63a4bc9993 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -648,52 +648,98 @@ static int mana_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-/* mana_set_channels - change the number of queues on a port
- *
- * Returns -EBUSY if RDMA holds the vport with EQs sized to the
- * current num_queues.
+/* Build the new queue set while the current one keeps serving traffic, then
+ * swap. On failure the existing queues keep running and the requested value is
+ * never replaced by a fallback. The vport is never torn down, so RDMA cannot
+ * take it mid-reconfiguration.
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
+	/* Down: no queues to swap, so record the count and resize the arrays
+	 * indexed by it. apc->rxqs has to grow here because mana_open() goes
+	 * straight to mana_alloc_queues() without rebuilding the port context.
+	 *
+	 * RDMA can own the vport while the port is down and derives an EQ from
+	 * apc->eqs[] modulo apc->num_queues, so refuse while it is in use.
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
+	/* Block RDMA from acquiring the vport for the duration.
+	 *
+	 * No vport_use_count test here, unlike the branch above: bringing the
+	 * port up takes the vport itself, so the count is always non-zero. That
+	 * reference is also what makes the swap safe - RAW QPs, the only users
+	 * of apc->eqs[] modulo apc->num_queues, cannot exist while the ethernet
+	 * port owns it.
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
index 2117a30116c265d6cd9c8223ad4f5ea5d2818455..dd767ab623912a149b4445cea7453034c8d69e37 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -639,6 +639,21 @@ struct mana_port_context {
 	 */
 	bool channel_changing;
 
+	/* mana_publish_qset() could neither publish the new set nor restore the
+	 * old one. Vport RX is already off; the port still has to be closed,
+	 * which mana_publish_close_if_needed() does once the caller has
+	 * released the set that failed.
+	 */
+	bool publish_dead_end;
+
+	/* The dead end above took the carrier down for a software reason, not
+	 * a link event, so nothing else will ever put it back: the link
+	 * handler only runs on a real HWC_DATA_HW_LINK_* transition. Remember
+	 * it so the next successful open restores it, which is what makes the
+	 * documented "recoverable with a down/up" actually true.
+	 */
+	bool carrier_forced_off;
+
 	/* Net shaper handle*/
 	struct net_shaper_handle handle;
 
@@ -724,6 +739,9 @@ int mana_alloc_qset(struct mana_port_context *apc,
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

