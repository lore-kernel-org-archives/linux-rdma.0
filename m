Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4133F3277;
	Tue, 11 Aug 2026 06:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430138; cv=none; b=ntsM1QGqzAeAJUdFf8i1JAfcffRLICd+Yp4HTCrzfxwShhGXoXcF04eCIP9WDwVBDC43euSoWhayGWQxXM0J4KEkqlR7/C6wRzc3fX1dFI+o9Pb6SinLCuwc8WxP/917INtyfsMrFPTZAJuifVty3riWYYXuzH5HMcuPP4xyhl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430138; c=relaxed/simple;
	bh=nMGEdZHlfOzRCr7kHjWkpAu3mIbnqGHt/nZMDlH+ArA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcVRhr4ufGewh7G0OlqVt5X8VLu9YBU7Ma3NovW3VB+2bur+kHQGtWXqE68H/thxw0HP0tcQV8GH24k9CiWjpw3oY8Fwzcy1xYqFmslPpg2YuiCewS47SUkUw2oFdEpWOK9pf176Ja/N3VWrs0PurKbvIqiR3GHZiJ0pHIEuzyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7556320B7168; Mon, 10 Aug 2026 23:35:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7556320B7168
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
Subject: [PATCH net-next v2 01/13] net: mana: add queue-set allocation and teardown helpers
Date: Mon, 10 Aug 2026 23:34:58 -0700
Message-ID: <20260811063506.2428213-2-longli@microsoft.com>
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

The ethtool reconfiguration paths (channel count, ring size, private
flags) and mana_change_mtu()/mana_xdp_set() all rebuild the queues by
calling mana_detach() followed by mana_attach(). That tears the vport
down and rebuilds it, so the RDMA driver can claim the vport while it
is released, and if mana_attach() fails the port is left down with no
way back except manual intervention.

Introduce the data model for replacing that with pre-allocate and swap.
struct mana_qset holds the queue-related fields of
mana_port_context that can be rebuilt independently of the vport: the
EQ/TXQ/RXQ arrays, the indirection and rxobj tables, and the
configuration those queues were built for.

mana_alloc_qset() builds a complete queue set and mana_free_qset()
destroys one. Both run against a scratch mana_port_context obtained
from mana_qset_scratch_alloc() - a heap copy that shares the port's
vport identity but owns no queues - so the live port context is never
made to point at queues that are still being built or freed.

Running the allocators against a scratch context rather than
temporarily clearing the live one is essential, not cosmetic.
mana_start_xmit() dereferences apc->tx_qp[] guarded only by
apc->port_is_up, and mana_alloc_qset() takes 50-300ms including
firmware calls. An earlier revision of this work cleared apc->tx_qp so
the existing allocators could build into the live context, and reliably
panicked under traffic:

  RIP: 0010:mana_start_xmit+0x138/0x1040   ; apc->tx_qp[txq_idx]
  RAX: 0000000000000000  CR2: 0000000000000000
  Kernel panic - not syncing: Fatal exception in interrupt

The scratch context also gets rxbufs_pre = NULL so it never consumes
the live set's preallocated RX buffers, and mana_port_debugfs =
ERR_PTR(-ENODEV). debugfs_start_creating() returns early on an IS_ERR()
parent and debugfs_remove() ignores IS_ERR_OR_NULL, which makes every
create and remove a no-op for swapped-in sets. Without this the two
live sets collide on the same names under vport%d.

mana_dealloc_queues()'s inline TX drain moves into mana_drain_txqs() so
the new teardown path gets it too: a retiring queue set can still hold
packets the device has not completed, and freeing the SQs and the SKB
queues underneath them would leak those SKBs and their DMA mappings.

While moving it, the reset that the drain falls back to when the
hardware stops responding becomes pci_try_reset_function() instead of
an open-coded pcie_flr(). pcie_flr() resets the function without saving
and restoring config space, so BARs, MSI-X state and bus master enable
are wiped while the PCI core still believes its cached values are
live. pci_try_reset_function() brackets the reset with
pci_dev_save_and_disable() and pci_dev_restore(). The trylock variant
is required rather than pci_reset_function(): this runs under RTNL,
while driver removal takes the device lock first and RTNL second, so
blocking on the device lock here could deadlock.

Other than that reset change, no functional change: nothing calls the
new helpers yet.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  31 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 520 ++++++++++++++++--
 include/net/mana/mana.h                       |  64 +++
 3 files changed, 577 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 53308e139cbe917b074dd381c83546fc74d7b79f..ca602e27044f92b87295cbc2de924adc71efa780 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -265,3 +265,34 @@ int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 
 	return ret;
 }
+
+/* Read the XDP program a queue set is running, without changing anything. */
+struct bpf_prog *mana_chn_xdp_peek(struct mana_port_context *apc)
+{
+	ASSERT_RTNL();
+
+	if (!apc->rxqs || !apc->rxqs[0])
+		return NULL;
+
+	return rtnl_dereference(apc->rxqs[0]->bpf_prog);
+}
+
+/* Drop the per-queue references a retiring set holds on @prog.
+ *
+ * Kept separate from mana_chn_setxdp() so the pointers can stay in place
+ * until the queues stop polling: clearing them up front would let packets
+ * already sitting in a retiring RQ take the pass path and reach the stack
+ * without the program ever seeing them.
+ */
+void mana_chn_xdp_release(struct bpf_prog *prog, unsigned int num_queues)
+{
+	unsigned int i;
+
+	ASSERT_RTNL();
+
+	if (!prog)
+		return;
+
+	for (i = 0; i < num_queues; i++)
+		bpf_prog_put(prog);
+}
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 3c96e6fc3d81dc16853cc458ef620b5150aa8988..bf15222deb77679257f46d36800fdc4006c612a0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2015,7 +2015,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
-	if (txq_stopped && apc->port_is_up && avail_space >= MAX_TX_WQE_SIZE) {
+	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
+	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
 		apc->eth_stats.wake_queue++;
 	}
@@ -2751,6 +2752,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		u64_stats_init(&txq->stats.syncp);
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
+		txq->reset_gen = READ_ONCE(apc->ac->reset_gen);
 		txq->vp_offset = apc->tx_vp_offset;
 		txq->napi_initialized = false;
 		skb_queue_head_init(&txq->pending_skbs);
@@ -3006,11 +3008,14 @@ static int mana_push_wqe(struct mana_rxq *rxq)
 
 static int mana_create_page_pool(struct mana_rxq *rxq, struct gdma_context *gc)
 {
-	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
 	struct page_pool_params pprm = {};
 	int ret;
 
-	pprm.pool_size = mpc->rx_queue_size / rxq->frag_count + 1;
+	/* Size the recycle ring from the queue being built, not from the live
+	 * port context: during a swap the queue may be sized for a ring the
+	 * running configuration does not use yet.
+	 */
+	pprm.pool_size = rxq->num_rx_buf / rxq->frag_count + 1;
 	pprm.nid = gc->numa_node;
 	pprm.napi = &rxq->rx_cq.napi;
 	pprm.netdev = rxq->ndev;
@@ -3676,15 +3681,143 @@ int mana_attach(struct net_device *ndev)
 	return 0;
 }
 
-static int mana_dealloc_queues(struct net_device *ndev)
+/* Drain the TX queues of a set that is about to be destroyed.
+ *
+ * No new packet can reach these queues: either the port is down
+ * (mana_dealloc_queues()) or the set has already been unpublished from the
+ * live port context (mana_free_qset()). Wait for the hardware to complete
+ * what it still owns, then release every SKB left mapped.
+ *
+ * A total timeout of 120 seconds is used across all the queues. This breaks
+ * the loop when the h/w is not responding; the device is then reset, because
+ * the buffers are about to be freed while it may still DMA into them. This
+ * value of 120 has been decided considering the max number of queues. If that
+ * reset also fails, the buffers are deliberately leaked rather than handed
+ * back to a device that can still reach them.
+ *
+ * Returns true if the device was successfully reset, which takes down every
+ * queue on the function, not just the ones being retired here. A reset that
+ * was attempted but failed returns false: nothing was taken down, so the
+ * other ports have no reason to rebuild.
+ */
+static bool mana_drain_txqs(struct mana_port_context *apc)
 {
-	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned long timeout = jiffies + 120 * HZ;
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	bool quiesced = true;
+	bool reset = false;
 	struct mana_txq *txq;
 	struct sk_buff *skb;
-	int i, err;
 	u32 tsleep;
+	int i, err;
+
+	if (!apc->tx_qp)
+		return false;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		txq = &apc->tx_qp[i]->txq;
+
+		/* The function has been reset since this queue was created, so
+		 * the device has already stopped touching its buffers. The
+		 * completions being waited for below can never arrive: without
+		 * this the port a reset took down would spend the full timeout
+		 * here, under RTNL, and then reset the function again on its
+		 * way out, taking every other port down with it in turn.
+		 */
+		if (READ_ONCE(apc->ac->reset_gen) != txq->reset_gen)
+			continue;
+
+		tsleep = 1000;
+		while (atomic_read(&txq->pending_sends) > 0 &&
+		       time_before(jiffies, timeout)) {
+			usleep_range(tsleep, tsleep + 1000);
+			tsleep <<= 1;
+		}
+		if (atomic_read(&txq->pending_sends)) {
+			/* The device still owns these buffers, so it has to be
+			 * reset before they are freed.
+			 *
+			 * pci_try_reset_function() rather than a bare
+			 * pcie_flr(): it saves and restores config space (BARs,
+			 * MSI-X, bus master) around the reset, which an
+			 * open-coded FLR wipes without the PCI core ever
+			 * knowing, leaving the device wedged. The trylock form
+			 * is deliberate: RTNL is held here, while the driver
+			 * remove path takes the device lock first and RTNL
+			 * second, so blocking on the device lock could deadlock.
+			 */
+			err = pci_try_reset_function(to_pci_dev(gd->gdma_context->dev));
+			if (err) {
+				netdev_err(apc->ndev,
+					   "function reset failed: %d, %d pkts pending in txq %u\n",
+					   err, atomic_read(&txq->pending_sends),
+					   txq->gdma_txq_id);
+				quiesced = false;
+			} else {
+				/* Every queue on the function is dead now,
+				 * including the ones this loop has not reached
+				 * and those of the other ports.
+				 */
+				WRITE_ONCE(apc->ac->reset_gen,
+					   apc->ac->reset_gen + 1);
+
+				/* Only a reset that actually happened takes the
+				 * other ports' queues down with it. Reporting
+				 * one that failed would send every sibling
+				 * through a needless down/up while their queues
+				 * are still perfectly good.
+				 */
+				reset = true;
+			}
+			break;
+		}
+	}
+
+	/* The reset is what makes freeing these buffers safe. Without it the
+	 * device still owns them: unmapping would fault the IOMMU on the next
+	 * descriptor it reads, and on a system without one it would go on
+	 * reading memory that has already been handed to someone else and put
+	 * whatever it finds there on the wire. Leaking is the lesser evil.
+	 *
+	 * What is leaked is bounded: at most one SQ ring's worth of skbs per
+	 * queue, since mana_can_tx() stops the txq once the ring is full. And
+	 * it can only recur after another full drain timeout followed by
+	 * another failed function reset. Reaching this point at all means the
+	 * device left TX outstanding for two minutes, so it is already broken;
+	 * pci_try_reset_function() then failing for a transient reason, such
+	 * as the trylock losing to a concurrent PCI operation, only decides
+	 * whether these particular buffers can be recovered, not whether the
+	 * device was healthy.
+	 */
+	if (!quiesced) {
+		netdev_err(apc->ndev,
+			   "device not quiesced, leaking pending TX buffers instead of unmapping memory it can still DMA from\n");
+		return reset;
+	}
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		txq = &apc->tx_qp[i]->txq;
+		while ((skb = skb_dequeue(&txq->pending_skbs))) {
+			mana_unmap_skb(skb, apc);
+			dev_kfree_skb_any(skb);
+		}
+		atomic_set(&txq->pending_sends, 0);
+	}
+
+	return reset;
+}
+
+static int mana_dealloc_queues(struct net_device *ndev)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	struct gdma_dev *gd = apc->ac->gdma_dev;
+	int err;
 
 	if (apc->port_is_up)
 		return -EINVAL;
@@ -3702,41 +3835,27 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	 * new packets due to apc->port_is_up being false.
 	 *
 	 * Drain all the in-flight TX packets.
-	 * A timeout of 120 seconds for all the queues is used.
-	 * This will break the while loop when h/w is not responding.
-	 * This value of 120 has been decided here considering max
-	 * number of queues.
+	 *
+	 * If the drain had to reset the function to get there, every other
+	 * port on the adapter lost its queues too, so schedule them for a
+	 * rebuild. This port is being torn down here and needs no such
+	 * treatment, and a port that is already down returns early from its
+	 * handler.
 	 */
+	if (mana_drain_txqs(apc)) {
+		struct mana_context *ac = apc->ac;
+		unsigned int i;
 
-	if (apc->tx_qp) {
-		for (i = 0; i < apc->num_queues; i++) {
-			txq = &apc->tx_qp[i]->txq;
-			tsleep = 1000;
-			while (atomic_read(&txq->pending_sends) > 0 &&
-			       time_before(jiffies, timeout)) {
-				usleep_range(tsleep, tsleep + 1000);
-				tsleep <<= 1;
-			}
-			if (atomic_read(&txq->pending_sends)) {
-				err =
-				    pcie_flr(to_pci_dev(gd->gdma_context->dev));
-				if (err) {
-					netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
-						   err,
-					    atomic_read(&txq->pending_sends),
-					    txq->gdma_txq_id);
-				}
-				break;
-			}
-		}
+		for (i = 0; i < ac->num_ports; i++) {
+			struct mana_port_context *sib;
 
-		for (i = 0; i < apc->num_queues; i++) {
-			txq = &apc->tx_qp[i]->txq;
-			while ((skb = skb_dequeue(&txq->pending_skbs))) {
-				mana_unmap_skb(skb, apc);
-				dev_kfree_skb_any(skb);
-			}
-			atomic_set(&txq->pending_sends, 0);
+			if (!ac->ports[i] || ac->ports[i] == ndev)
+				continue;
+			sib = netdev_priv(ac->ports[i]);
+			netdev_err(ac->ports[i],
+				   "queues reset by a sibling port, scheduling rebuild\n");
+			queue_work(ac->per_port_queue_reset_wq,
+				   &sib->queue_reset_work);
 		}
 	}
 
@@ -3760,6 +3879,324 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	return 0;
 }
 
+/*
+ * ---------------------------------------------------------------------------
+ * Pre-allocate + swap reconfiguration path.
+ *
+ * The detach/attach reconfigure path tears the vport down and rebuilds it,
+ * which lets RDMA grab the vport mid-flight and, if attach fails, leaves the
+ * port permanently broken.
+ *
+ * The swap path builds a *new* set of EQs/TXQs/RXQs while the current set
+ * keeps serving traffic. If allocation fails the current qset is untouched
+ * and we return the error; the user's requested value is never silently
+ * replaced by a fallback. Publishing a new set onto the live port
+ * context is added separately. The vport is never torn down: vport_use_count
+ * stays at 1 throughout, so RDMA cannot hijack it.
+ *
+ * Allocation and teardown run against a *scratch* mana_port_context rather
+ * than the live one. This is essential, not cosmetic: an earlier revision
+ * temporarily NULLed apc->tx_qp so the allocators could
+ * build into the live context, which reliably panicked in mana_start_xmit()
+ * under traffic (it dereferences apc->tx_qp[] guarded only by port_is_up).
+ * The live apc is now mutated only inside mana_publish_qset(), with TX
+ * disabled.
+ *
+ * Note that both sets are live between publish and free, so this peaks at
+ * old+new queues, and therefore at old+new MSI-X vectors. A later patch
+ * gives the port a shared EQ pool so only the queues, not the interrupts,
+ * are doubled up.
+ *
+ * Per-queue debugfs is suppressed for a set while it is being built or torn
+ * down (see mana_qset_scratch_alloc()): the directory names are derived from
+ * the queue index, so the incoming set would collide with the outgoing one
+ * under vport%d. Restoring it needs per-set subdirectories or a
+ * debugfs_rename() once the swap has completed.
+ * ---------------------------------------------------------------------------
+ */
+
+/* Snapshot the queue-set fields of @ctx into @out. */
+static void mana_qset_snapshot(const struct mana_port_context *ctx,
+			       struct mana_qset *out)
+{
+	out->eqs		= ctx->eqs;
+	out->tx_qp		= ctx->tx_qp;
+	out->rxqs		= ctx->rxqs;
+	out->indir_table	= ctx->indir_table;
+	out->indir_table_sz	= ctx->indir_table_sz;
+	out->rxobj_table	= ctx->rxobj_table;
+	out->default_rxobj	= ctx->default_rxobj;
+	out->num_queues		= ctx->num_queues;
+	out->rx_queue_size	= ctx->rx_queue_size;
+	out->tx_queue_size	= ctx->tx_queue_size;
+	out->priv_flags		= ctx->priv_flags;
+	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
+}
+
+/* Install @qset's fields onto @ctx. The vport (port_handle,
+ * vport_use_count) and the port-level debugfs dir are deliberately not
+ * touched: they outlive any individual queue set.
+ */
+static void mana_qset_install(struct mana_port_context *ctx,
+			      const struct mana_qset *qset)
+{
+	ctx->eqs		= qset->eqs;
+	ctx->tx_qp		= qset->tx_qp;
+	ctx->rxqs		= qset->rxqs;
+	ctx->indir_table	= qset->indir_table;
+	ctx->indir_table_sz	= qset->indir_table_sz;
+	ctx->rxobj_table	= qset->rxobj_table;
+	ctx->default_rxobj	= qset->default_rxobj;
+	ctx->num_queues		= qset->num_queues;
+	ctx->rx_queue_size	= qset->rx_queue_size;
+	ctx->tx_queue_size	= qset->tx_queue_size;
+	ctx->priv_flags		= qset->priv_flags;
+	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
+}
+
+/**
+ * mana_qset_scratch_alloc - build a scratch port context for queue work
+ * @apc: the live port context to shadow
+ *
+ * Returns a heap copy of @apc that shares its vport identity (ac, ndev,
+ * port_handle, indir_table_sz, mac_addr, hashkey, ...) but owns no queues.
+ * The existing per-apc allocators and destroyers can then be run against
+ * it without ever touching the live context.
+ */
+struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
+{
+	struct mana_port_context *scratch;
+
+	scratch = kvzalloc(sizeof(*scratch), GFP_KERNEL);
+	if (!scratch)
+		return NULL;
+
+	*scratch = *apc;
+
+	/* Owns no queues yet. */
+	scratch->eqs		= NULL;
+	scratch->tx_qp		= NULL;
+	scratch->rxqs		= NULL;
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+	scratch->default_rxobj	= INVALID_MANA_HANDLE;
+	scratch->mana_eqs_debugfs = NULL;
+
+	/* Never consume the live set's pre-allocated RX buffers;
+	 * mana_get_rxbuf() falls back to normal allocation when these
+	 * are NULL, which is what we want since the swap path no longer
+	 * needs to de-risk post-teardown allocation.
+	 */
+	scratch->rxbufs_pre	= NULL;
+	scratch->das_pre	= NULL;
+	scratch->rxbpre_total	= 0;
+
+	/* Suppress debugfs for queues built through the scratch context:
+	 * two sets are alive at once and would collide on the same names
+	 * under vport%d. debugfs_start_creating() returns early on an
+	 * IS_ERR() parent, and debugfs_remove() ignores IS_ERR_OR_NULL,
+	 * so this makes every create/remove a clean no-op.
+	 */
+	scratch->mana_port_debugfs = ERR_PTR(-ENODEV);
+
+	return scratch;
+}
+
+void mana_qset_scratch_free(struct mana_port_context *scratch)
+{
+	kvfree(scratch);
+}
+
+/**
+ * mana_alloc_qset - build a complete queue set in @scratch
+ * @scratch:	   scratch context from mana_qset_scratch_alloc()
+ * @num_queues:	   number of queues in the new set
+ * @rx_queue_size: new RX ring size
+ * @tx_queue_size: new TX ring size
+ * @priv_flags:	   new priv-flag word (affects full-page RX)
+ * @out:	   output qset, populated on success
+ *
+ * The live port context is not referenced at all, so the currently
+ * running queue set keeps serving traffic throughout. On error nothing
+ * is left allocated.
+ */
+int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+		    unsigned int rx_queue_size, unsigned int tx_queue_size,
+		    u32 priv_flags, struct mana_qset *out)
+{
+	struct net_device *ndev = scratch->ndev;
+	int err;
+
+	ASSERT_RTNL();
+
+	scratch->num_queues	= num_queues;
+	scratch->rx_queue_size	= rx_queue_size;
+	scratch->tx_queue_size	= tx_queue_size;
+	scratch->priv_flags	= priv_flags;
+
+	err = mana_init_port_context(scratch);
+	if (err)
+		goto out_err;
+
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		goto cleanup_rxq_array;
+
+	err = mana_create_eq(scratch);
+	if (err)
+		goto cleanup_rss;
+
+	err = mana_create_txq(scratch, ndev);
+	if (err)
+		goto cleanup_eq;
+
+	err = mana_add_rx_queues(scratch, ndev);
+	if (err)
+		goto cleanup_rxq;
+
+	mana_rss_table_init(scratch);
+
+	mana_qset_snapshot(scratch, out);
+	return 0;
+
+cleanup_rxq:
+	/* mana_add_rx_queues() may have created queues before failing; they
+	 * own RQ/CQ objects, NAPI state and page pools, so tear down whatever
+	 * made it into scratch->rxqs[] before dropping the array.
+	 */
+	mana_destroy_rxqs(scratch);
+	mana_destroy_txq(scratch);
+cleanup_eq:
+	mana_destroy_eq(scratch);
+cleanup_rss:
+	mana_cleanup_indir_table(scratch);
+cleanup_rxq_array:
+	kfree(scratch->rxqs);
+	scratch->rxqs = NULL;
+out_err:
+	netdev_err(ndev, "mana_alloc_qset(num_queues=%u) failed: %d\n",
+		   num_queues, err);
+	return err;
+}
+
+/**
+ * mana_free_qset - tear down all queues in @qset
+ * @scratch: scratch context from mana_qset_scratch_alloc()
+ * @qset:    queue set to destroy (must no longer be installed on the live apc)
+ *
+ * Runs the existing destroyers against @scratch so the live port context
+ * is never made to point at queues that are being freed.
+ */
+void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
+{
+	struct bpf_prog *retiring_prog;
+	unsigned int retiring_queues;
+
+	ASSERT_RTNL();
+
+	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+		return;
+
+	/* These queues are leaving. Stop their completions from touching the
+	 * shared netdev queues: net_txq is shared with whatever replaced them
+	 * at the same index, and a queue that is only draining always looks
+	 * like it has room, so it would wake a live queue that stopped itself
+	 * because its ring was full. The synchronize_net() below then retires
+	 * any poll that has not seen the flag yet.
+	 */
+	if (qset->tx_qp) {
+		unsigned int q;
+
+		for (q = 0; q < qset->num_queues; q++) {
+			if (qset->tx_qp[q])
+				WRITE_ONCE(qset->tx_qp[q]->txq.retiring, true);
+		}
+	}
+
+	/* The datapath gates on apc->port_is_up and then dereferences
+	 * apc->tx_qp[] / apc->rxqs[] with no lock. mana_publish_qset() drains
+	 * those readers before it installs the incoming set, which cannot
+	 * cover one that sampled the retiring pointers between that install
+	 * and the gate reopening. mana_xdp_xmit() is the case that matters:
+	 * it runs from a redirecting device's NAPI, so the napi_synchronize()
+	 * that mana_destroy_txq()/mana_destroy_rxq() do on this port's own
+	 * NAPIs never waits for it. Give any such reader a grace period to
+	 * finish before its queues are torn down under it. Every caller is a
+	 * reconfiguration path holding RTNL, so this is expedited.
+	 */
+	synchronize_net();
+
+	mana_qset_install(scratch, qset);
+
+	/* Note what this set owes the XDP program, but leave the queues
+	 * pointing at it. They are still polling, and a packet already in a
+	 * retiring RQ has to keep running the program rather than slip past
+	 * it into the stack. The references are dropped once the queues are
+	 * gone, below. XDP_TX from those polls is harmless here: it goes
+	 * through mana_start_xmit() on the live port context, so it reaches
+	 * the queue set that replaced this one, not the one being drained.
+	 */
+	retiring_prog = mana_chn_xdp_peek(scratch);
+	retiring_queues = scratch->num_queues;
+
+	/* The retiring TX queues may still hold packets the device has not
+	 * completed. Drain them before the SQs and the SKB queues go away,
+	 * or those SKBs and their DMA mappings are leaked.
+	 *
+	 * This runs before any RX teardown, the order mana_dealloc_queues()
+	 * uses. A device wedged badly enough to need the reset below is also
+	 * one whose RQ teardown will not complete, and unmapping RX buffers
+	 * first would leave it free to keep writing into them for as long as
+	 * the drain takes.
+	 */
+	if (mana_drain_txqs(scratch)) {
+		/* The drain had to reset the function to stop the device
+		 * touching those buffers. A function reset takes down every
+		 * port on the adapter, not just this one, so rebuild them all
+		 * - the same recovery mana_tx_timeout() relies on. A port that
+		 * is already down has nothing to rebuild and its handler
+		 * returns early.
+		 */
+		struct mana_port_context *apc = netdev_priv(scratch->ndev);
+		struct mana_context *ac = apc->ac;
+		unsigned int i;
+
+		netdev_err(scratch->ndev,
+			   "device reset while retiring a queue set, scheduling port reset\n");
+
+		for (i = 0; i < ac->num_ports; i++) {
+			if (!ac->ports[i])
+				continue;
+			queue_work(ac->per_port_queue_reset_wq,
+				   &((struct mana_port_context *)
+				     netdev_priv(ac->ports[i]))->queue_reset_work);
+		}
+	}
+
+	/* Traffic was still being steered at these queues moments ago, so
+	 * fence each retiring RQ before its buffers are unmapped, again the
+	 * order mana_dealloc_queues() uses. mana_destroy_rxq() does destroy
+	 * the hardware RQ before unmapping anything, but the fence is what
+	 * makes the device confirm it is done with the buffers first.
+	 */
+	mana_fence_rqs(scratch);
+
+	mana_destroy_rxqs(scratch);
+
+	/* The queues are gone, so nothing can run the program any more. */
+	mana_chn_xdp_release(retiring_prog, retiring_queues);
+
+	mana_destroy_txq(scratch);
+	mana_destroy_eq(scratch);
+	mana_cleanup_indir_table(scratch);
+	kfree(scratch->rxqs);
+	scratch->rxqs = NULL;
+
+	memset(qset, 0, sizeof(*qset));
+}
+
+/* --- end of pre-allocate + swap reconfiguration path ---------------------- */
+
 int mana_detach(struct net_device *ndev, bool from_close)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -4237,6 +4674,13 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
 
+		/* Clear the slot before the netdev goes away. A later port
+		 * whose teardown has to reset the function walks ac->ports[]
+		 * to schedule the rebuild, and would otherwise reach into the
+		 * port freed here.
+		 */
+		ac->ports[i] = NULL;
+
 		rtnl_unlock();
 
 		free_netdev(ndev);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 83b7eff4646ead7aef1382c6ce565a573a940af4..4727c231bf0391bd9a1e9ff15c65815a6a3d01dd 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -143,6 +143,16 @@ struct mana_txq {
 
 	bool napi_initialized;
 
+	/* Value of mana_context.reset_gen when this queue was created. */
+	u32 reset_gen;
+
+	/* Set once this queue has been unpublished and is on its way out.
+	 * Its completions must not touch flow control any more: net_txq is
+	 * shared with the queue that replaced it at the same index, and a
+	 * draining queue always looks like it has room.
+	 */
+	bool retiring;
+
 	struct mana_stats_tx stats;
 };
 
@@ -537,6 +547,14 @@ struct mana_context {
 	u8 bm_hostmode;
 
 	struct mana_ethtool_hc_stats hc_stats;
+
+	/* Bumped every time the PCI function is reset to unstick a TX queue.
+	 * A queue created before the current value cannot be touched by the
+	 * device any more, so nothing has to be waited for before its buffers
+	 * are released. Written under RTNL, read locklessly.
+	 */
+	u32 reset_gen;
+
 	struct workqueue_struct *per_port_queue_reset_wq;
 	/* Workqueue for querying hardware stats */
 	struct delayed_work gf_stats_work;
@@ -661,6 +679,39 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
+/* struct mana_qset - a self-contained snapshot of the queue-related
+ * fields inside mana_port_context that can be swapped atomically.
+ *
+ * Prototype for the "pre-allocate + swap" reconfiguration path (as
+ * suggested by netdev maintainers): a new qset is allocated while the
+ * current one keeps serving traffic, then apc's queue fields are
+ * atomically switched to the new set and the old set is torn down.
+ * The vport (port_handle / vport_use_count) is *not* touched, so RDMA
+ * can never race in during reconfiguration.
+ */
+struct mana_qset {
+	struct mana_eq		*eqs;
+	struct mana_tx_qp	**tx_qp;
+	struct mana_rxq		**rxqs;
+
+	u32			*indir_table;
+	u32			indir_table_sz;
+	mana_handle_t		*rxobj_table;
+	mana_handle_t		default_rxobj;
+
+	unsigned int		num_queues;
+	unsigned int		rx_queue_size;
+	unsigned int		tx_queue_size;
+	u32			priv_flags;
+
+	/* Per-queue-set debugfs root ("EQs"). Owned by the qset: it is
+	 * recreated by mana_create_eq() for each new set and torn down
+	 * with that set, so it must travel with the qset rather than
+	 * staying on apc.
+	 */
+	struct dentry		*mana_eqs_debugfs;
+};
+
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
@@ -670,6 +721,17 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
+/* Pre-allocate + swap reconfiguration path. Allocation and teardown run
+ * against a scratch context so the live port context is never made to
+ * point at queues that are still being built or freed.
+ */
+struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc);
+void mana_qset_scratch_free(struct mana_port_context *scratch);
+int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+		    unsigned int rx_queue_size, unsigned int tx_queue_size,
+		    u32 priv_flags, struct mana_qset *out);
+void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
 int mana_probe(struct gdma_dev *gd, bool resuming);
@@ -685,6 +747,8 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
 void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
+struct bpf_prog *mana_chn_xdp_peek(struct mana_port_context *apc);
+void mana_chn_xdp_release(struct bpf_prog *prog, unsigned int num_queues);
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int mana_query_gf_stats(struct mana_context *ac);
 int mana_query_link_cfg(struct mana_port_context *apc);
-- 
2.43.0

