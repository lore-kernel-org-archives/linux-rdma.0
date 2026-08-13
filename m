Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698DC35E94E;
	Thu, 13 Aug 2026 05:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597501; cv=none; b=m2kPVD7XJyjuJsHyaI41amqpuCOkhNAT+oQfHutCfoUVEJpsxajmiXc+MO923W/kj7az0H4Ju/Q42Dpq6CRpXJPb6bKvbcfR9dV5Fiq9/swsuUYzHZvPaF4NVY6eGYns2PUklEeSd3FY5/Nr5EjT5bCPqVRif1hHMLay+yG/Iio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597501; c=relaxed/simple;
	bh=FnnvaLitMNmYBziizgYj43JPRjdpw+mIxFIlS8p6QB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO9t5P45o9YTiEkREq77GJZY4SShOChGbNjYjfO+CFFhtHGwBmdnEhPde+gFLSoVfWoqNg9GcWNok9ejMkutDXzEr7HnSjhau9+ElDFNht//3YG6H0wULgDrxBA19Zx0TNO8Jx5b8Tb71XoH8n9V13CJ//nVwkhNXndTAWRsVp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 9339620B7129; Wed, 12 Aug 2026 22:04:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9339620B7129
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
Date: Wed, 12 Aug 2026 22:04:07 -0700
Message-ID: <20260813050418.2906468-3-longli@microsoft.com>
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
 drivers/net/ethernet/microsoft/mana/mana_en.c | 345 ++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  84 ++++-
 include/net/mana/mana.h                       |  10 +
 4 files changed, 400 insertions(+), 46 deletions(-)

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
index 60b1fc93d453b16bec37924e32ea54c64f179f1c..c0f31b386536a34af338c4d8be50537e2fe55317 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -363,6 +363,18 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
 
@@ -1042,6 +1054,11 @@ static void mana_cleanup_indir_table(struct mana_port_context *apc)
 
 static int mana_init_port_context(struct mana_port_context *apc)
 {
+	/* A port reconfigured while down already has an apc->rxqs, and
+	 * mana_detach() takes its "already detached" early return without
+	 * releasing it. Free it rather than overwrite the pointer.
+	 */
+	kfree(apc->rxqs);
 	apc->rxqs = kzalloc_objs(struct mana_rxq *, apc->num_queues);
 
 	return !apc->rxqs ? -ENOMEM : 0;
@@ -2015,6 +2032,10 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
+	/* Ordered by the same barrier: reaching here with txq_stopped set means
+	 * the replacement queue has already run, which is strictly after this
+	 * queue was marked retiring.
+	 */
 	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
 	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
@@ -3861,10 +3882,16 @@ static int mana_dealloc_queues(struct net_device *ndev)
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
@@ -4041,6 +4068,268 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
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
+	bool carrier_ok;
+	int err;
+
+	ASSERT_RTNL();
+
+	carrier_ok = netif_carrier_ok(ndev);
+	netif_carrier_off(ndev);
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
@@ -4070,41 +4359,36 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 		}
 	}
 
-	/* The datapath gates on apc->port_is_up and then dereferences
-	 * apc->tx_qp[] / apc->rxqs[] with no lock. mana_publish_qset() drains
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
@@ -4150,6 +4434,13 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
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
index 04b7a5c0fdabc9abc693065c32d4f60fc9ac6809..b12291555eaeb4fafc305ffe7d9e550ec01952c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -659,42 +659,88 @@ static int mana_set_channels(struct net_device *ndev,
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
index a7b7a00a57f176e9dc889f7b09b6ef56d5608a8e..66a653bad22eba511d8cf8cf71b572c604044ecb 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -633,6 +633,13 @@ struct mana_port_context {
 	 */
 	bool channel_changing;
 
+	/* mana_publish_qset() could neither publish the new set nor restore the
+	 * old one. Vport RX is already off; the port still has to be closed,
+	 * which mana_publish_close_if_needed() does once the caller has
+	 * released the set that failed.
+	 */
+	bool publish_dead_end;
+
 	/* Net shaper handle*/
 	struct net_shaper_handle handle;
 
@@ -729,6 +736,9 @@ void mana_qset_scratch_free(struct mana_port_context *scratch);
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

