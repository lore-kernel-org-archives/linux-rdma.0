Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C665538D6AD;
	Thu, 13 Aug 2026 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597504; cv=none; b=DizlQidH9QWSdheLzRWYqHcgyaM3Az2sd9y3KnxMWYwR1uP6mfq3eQImTAWCL16mcbQU++DoixnT7hCxEpNoVOR/ZJzwZlehewWgXmHTo+QZxfEwnvnGl7LgTlXKAsbhkBq+TVSDuNEZ24VTEWaEJRghJPO1UdThqDN1STPDZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597504; c=relaxed/simple;
	bh=x6JebuvLRDit7TdeciO52pd+2egRhwkuvtdDxmWG4Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2kdyCH3za4UcE79QvYUiB3qehvP7/5zxMxgydQHFy/grl9bGFuGRVeCjl9M4a5BVRO8qNpQ3WFLFfuCXYeYGS+9/nbwbcpNpmhFNatDE0+Dqq/W0EyWr1kQvXbun/tl/ZBwn6Mcc+lc5QkHZ0G2H4K7uGTGCXUbcC2MMQyyCH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 1A86620B7007; Wed, 12 Aug 2026 22:04:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1A86620B7007
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
Subject: [PATCH net-next v2 09/13] net: mana: share the EQ pool across a queue-set swap
Date: Wed, 12 Aug 2026 22:04:14 -0700
Message-ID: <20260813050418.2906468-10-longli@microsoft.com>
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

Raising the channel count fails with -ENOSPC once the queue-set swap is
in use:

  # ethtool -L ens1 combined 32
  netlink error: No space left on device
  mana 7870:00:00.0: No free MSI vectors available

Building a second set of EQs while the running set still held its own
meant peak demand of old + new MSI-X vectors. With 32 usable vectors and
a driver that comes up at 16 queues, 16 -> 17 already needs 33, so the
advertised maximum is unreachable.

Make the EQ pool belong to the port rather than to a queue set, so both
sets share it and peak usage is max(old, new) rather than the sum. The
pool only ever grows, up to the maximum channel count ethtool reports,
and is released on detach as before.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 173 +++++++++++-------
 .../ethernet/microsoft/mana/mana_ethtool.c    |   6 +-
 include/net/mana/mana.h                       |  34 ++--
 4 files changed, 120 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index ed9ec6b8af480a303bfa9c0dd9894f5049d8b6d6..05936453fbbfa59c563fdea50e0b40096c2b46ac 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -213,7 +213,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return -ENOMEM;
 		}
 
-		err = mana_alloc_qset(scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch, apc->num_queues,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 27484e5cf71a2216e7dc89c21ee0e9d95786cf30..be7f9f6626e42c33fc0e749e6897ecc8117222cf 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -913,7 +913,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -1809,7 +1809,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 	debugfs_remove_recursive(apc->mana_eqs_debugfs);
 	apc->mana_eqs_debugfs = NULL;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = 0; i < apc->num_eqs; i++) {
 		eq = apc->eqs[i].eq;
 		if (!eq)
 			continue;
@@ -1821,6 +1821,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 
 	kfree(apc->eqs);
 	apc->eqs = NULL;
+	apc->num_eqs = 0;
 }
 EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
@@ -1849,9 +1850,14 @@ int mana_create_eq(struct mana_port_context *apc)
 
 	if (WARN_ON(apc->eqs))
 		return -EEXIST;
-	apc->eqs = kzalloc_objs(struct mana_eq, apc->num_queues);
+	/* Size the array to the largest queue count this port can ever use,
+	 * so growing it later never has to reallocate (the CQs of a live
+	 * queue set hold pointers taken from these slots).
+	 */
+	apc->eqs = kzalloc_objs(struct mana_eq, apc->max_queues);
 	if (!apc->eqs)
 		return -ENOMEM;
+	apc->num_eqs = 0;
 
 	spec.type = GDMA_EQ;
 	spec.monitor_avl_buf = false;
@@ -1881,6 +1887,7 @@ int mana_create_eq(struct mana_port_context *apc)
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
 		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
 	}
 
 	return 0;
@@ -1890,6 +1897,70 @@ int mana_create_eq(struct mana_port_context *apc)
 }
 EXPORT_SYMBOL_NS(mana_create_eq, "NET_MANA");
 
+/**
+ * mana_grow_eqs - make sure the port has at least @need EQs
+ * @apc:  port context
+ * @need: number of EQs the new queue set requires
+ *
+ * EQs are bound to MSI-X vectors, so the pool is port-owned and shared across
+ * a swap: peak usage is max(old, new), not the sum. Grow-only, up to
+ * apc->max_queues.
+ */
+static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
+{
+	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_context *gc = gd->gdma_context;
+	struct gdma_queue_spec spec = {};
+	struct gdma_irq_context *gic;
+	unsigned int i;
+	int err;
+	int msi;
+
+	if (WARN_ON(!apc->eqs))
+		return -EINVAL;
+
+	if (need > apc->max_queues)
+		return -EINVAL;
+
+	if (need <= apc->num_eqs)
+		return 0;
+
+	spec.type = GDMA_EQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = EQ_SIZE;
+	spec.eq.callback = NULL;
+	spec.eq.context = apc->eqs;
+	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
+
+	for (i = apc->num_eqs; i < need; i++) {
+		msi = (i + 1) % gc->num_msix_usable;
+
+		gic = mana_gd_get_gic(gc, !gc->msi_sharing, &msi);
+		if (IS_ERR(gic)) {
+			err = PTR_ERR(gic);
+			goto out;
+		}
+		spec.eq.msix_index = msi;
+
+		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
+		if (err) {
+			dev_err(gc->dev, "Failed to grow EQ %u : %d\n", i, err);
+			mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+			goto out;
+		}
+		apc->eqs[i].eq->eq.irq = gic->irq;
+		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
+	}
+
+	return 0;
+out:
+	/* Keep whatever was created: the running queue set still needs its
+	 * own EQs, and the extras are reused by the next attempt.
+	 */
+	return err;
+}
+
 static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
 {
 	struct mana_fence_rq_resp resp = {};
@@ -3936,52 +4007,23 @@ static int mana_dealloc_queues(struct net_device *ndev)
 }
 
 /*
- * ---------------------------------------------------------------------------
- * Pre-allocate + swap reconfiguration path.
- *
- * The detach/attach reconfigure path tears the vport down and rebuilds it,
- * which lets RDMA grab the vport mid-flight and, if attach fails, leaves the
- * port permanently broken.
- *
- * The swap path builds a *new* set of EQs/TXQs/RXQs while the current set
- * keeps serving traffic. If allocation fails the current qset is untouched
- * and we return the error; the user's requested value is never silently
- * replaced by a fallback. Once the new qset is ready we publish it onto apc
- * and destroy the old one. The vport is never torn down: vport_use_count
- * stays at 1 throughout, so RDMA cannot hijack it.
+ * Pre-allocate and swap reconfiguration.
  *
- * The cost of never dropping the working queues is that a rebuild needs room
- * for both sets at once, so one at the vport's maximum queue count can be
- * refused by the firmware where a teardown-first sequence would have fit.
- * That surfaces as a failed ethtool operation with the port still running on
- * its previous queues, which is the trade this path exists to make.
+ * Build a new queue set while the current one serves traffic, publish it, then
+ * destroy the old one. A failed allocation leaves the running config untouched,
+ * and the vport is never torn down, so RDMA cannot take it mid-swap. The cost
+ * is room for both sets at once, so a rebuild at the vport's maximum queue
+ * count can be refused; EQs are shared from a port-owned pool, not doubled.
  *
- * Allocation and teardown run against a *scratch* mana_port_context rather
- * than the live one. This is essential, not cosmetic: an earlier revision
- * temporarily NULLed apc->tx_qp so the allocators could
- * build into the live context, which reliably panicked in mana_start_xmit()
- * under traffic (it dereferences apc->tx_qp[] guarded only by port_is_up).
- * The live apc is now mutated only inside mana_publish_qset(), with TX
- * disabled.
- *
- * Note that both sets are live between publish and free, so this peaks at
- * old+new queues, and therefore at old+new MSI-X vectors. A later patch
- * gives the port a shared EQ pool so only the queues, not the interrupts,
- * are doubled up.
- *
- * Per-queue debugfs is suppressed for a set while it is being built or torn
- * down (see mana_qset_scratch_alloc()): the directory names are derived from
- * the queue index, so the incoming set would collide with the outgoing one
- * under vport%d. Restoring it needs per-set subdirectories or a
- * debugfs_rename() once the swap has completed.
- * ---------------------------------------------------------------------------
+ * Everything builds in a scratch mana_port_context, since mana_start_xmit()
+ * dereferences apc->tx_qp[] guarded only by port_is_up. Per-queue debugfs is
+ * suppressed meanwhile, as the names would collide.
  */
 
 /* Snapshot the queue-set fields of @ctx into @out. */
 static void mana_qset_snapshot(const struct mana_port_context *ctx,
 			       struct mana_qset *out)
 {
-	out->eqs		= ctx->eqs;
 	out->tx_qp		= ctx->tx_qp;
 	out->rxqs		= ctx->rxqs;
 	out->indir_table	= ctx->indir_table;
@@ -3994,7 +4036,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
 	out->bpf_prog		= ctx->bpf_prog;
-	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
 /* Install @qset's fields onto @ctx. The vport (port_handle,
@@ -4004,7 +4045,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
-	ctx->eqs		= qset->eqs;
 	ctx->tx_qp		= qset->tx_qp;
 	ctx->rxqs		= qset->rxqs;
 	ctx->indir_table	= qset->indir_table;
@@ -4017,7 +4057,6 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
 	ctx->bpf_prog		= qset->bpf_prog;
-	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
 /**
@@ -4038,29 +4077,24 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 
 	*scratch = *apc;
 
-	/* Owns no queues yet. */
-	scratch->eqs		= NULL;
+	/* EQs stay shared with the live port: they are a vector-backed
+	 * resource and must not be duplicated for the new set.
+	 */
 	scratch->tx_qp		= NULL;
 	scratch->rxqs		= NULL;
 	scratch->indir_table	= NULL;
 	scratch->rxobj_table	= NULL;
 	scratch->default_rxobj	= INVALID_MANA_HANDLE;
-	scratch->mana_eqs_debugfs = NULL;
 
-	/* Never consume the live set's pre-allocated RX buffers;
-	 * mana_get_rxbuf() falls back to normal allocation when these
-	 * are NULL, which is what we want since the swap path no longer
-	 * needs to de-risk post-teardown allocation.
+	/* Never consume the live set's pre-allocated RX buffers; the swap path
+	 * has no post-teardown allocation to de-risk.
 	 */
 	scratch->rxbufs_pre	= NULL;
 	scratch->das_pre	= NULL;
 	scratch->rxbpre_total	= 0;
 
-	/* Suppress debugfs for queues built through the scratch context:
-	 * two sets are alive at once and would collide on the same names
-	 * under vport%d. debugfs_start_creating() returns early on an
-	 * IS_ERR() parent, and debugfs_remove() ignores IS_ERR_OR_NULL,
-	 * so this makes every create/remove a clean no-op.
+	/* Two sets are alive at once and would collide on the same names under
+	 * vport%d. An IS_ERR() parent makes every create and remove a no-op.
 	 */
 	scratch->mana_port_debugfs = ERR_PTR(-ENODEV);
 
@@ -4077,7 +4111,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * mana_grow_qset(), so this never has to add an EQ. The installed set keeps
  * serving traffic meanwhile. On error nothing is left allocated.
  */
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out)
@@ -4107,13 +4142,20 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	if (err)
 		goto cleanup_rxq_array;
 
-	err = mana_create_eq(scratch);
+	/* Grow the port's shared EQ pool if this set needs more. The pool
+	 * belongs to @apc, not to either queue set, so both sets can be
+	 * live at once without double-booking MSI-X vectors.
+	 */
+	err = mana_grow_eqs(apc, num_queues);
 	if (err)
 		goto cleanup_rss;
 
+	scratch->eqs = apc->eqs;
+	scratch->num_eqs = apc->num_eqs;
+
 	err = mana_create_txq(scratch, ndev);
 	if (err)
-		goto cleanup_eq;
+		goto cleanup_rss;
 
 	err = mana_add_rx_queues(scratch, ndev);
 	if (err)
@@ -4131,8 +4173,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	 */
 	mana_destroy_rxqs(scratch);
 	mana_destroy_txq(scratch);
-cleanup_eq:
-	mana_destroy_eq(scratch);
 cleanup_rss:
 	mana_cleanup_indir_table(scratch);
 cleanup_rxq_array:
@@ -4423,16 +4463,10 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	ASSERT_RTNL();
 
-	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+	if (!qset->rxqs && !qset->tx_qp)
 		return;
 
-	/* These queues are leaving. Stop their completions from touching the
-	 * shared netdev queues: net_txq is shared with whatever replaced them
-	 * at the same index, and a queue that is only draining always looks
-	 * like it has room, so it would wake a live queue that stopped itself
-	 * because its ring was full. The synchronize_net() below then retires
-	 * any poll that has not seen the flag yet.
-	 */
+	/* Keep their completions off the netdev queues they now share. */
 	if (qset->tx_qp) {
 		unsigned int q;
 
@@ -4511,7 +4545,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_chn_xdp_release(retiring_prog, retiring_queues);
 
 	mana_destroy_txq(scratch);
-	mana_destroy_eq(scratch);
 	mana_cleanup_indir_table(scratch);
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 26f5ea1f5091a7fab729ecf3468bdc13886fcccb..08e6fb7785cd3be72f8737083e6424783c5e0d21 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -722,7 +722,7 @@ static int mana_set_channels(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
@@ -818,7 +818,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
 			      apc->priv_flags, apc->configured_mtu,
 			      apc->bpf_prog, &newq);
 	if (err) {
@@ -917,7 +917,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 77cec5b44049202e21f919d4336fdf8ebc248a18..dfb6ba0012fda629192e4fe9cf8aba57fd5bb451 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -581,7 +581,12 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
+	/* EQ pool, owned by the port rather than a queue set: EQs are bound to
+	 * MSI-X vectors, which a swap must not double-book. Sized to
+	 * max_queues; num_eqs is how many exist.
+	 */
 	struct mana_eq *eqs;
+	unsigned int num_eqs;
 	struct dentry *mana_eqs_debugfs;
 
 	enum TRI_STATE rss_state;
@@ -702,18 +707,11 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
-/* struct mana_qset - a self-contained snapshot of the queue-related
- * fields inside mana_port_context that can be swapped atomically.
- *
- * Prototype for the "pre-allocate + swap" reconfiguration path (as
- * suggested by netdev maintainers): a new qset is allocated while the
- * current one keeps serving traffic, then apc's queue fields are
- * atomically switched to the new set and the old set is torn down.
- * The vport (port_handle / vport_use_count) is *not* touched, so RDMA
- * can never race in during reconfiguration.
+/* The queue-related fields of mana_port_context that can be swapped as a
+ * unit. The vport (port_handle, vport_use_count) is not part of it and is
+ * never touched by a swap.
  */
 struct mana_qset {
-	struct mana_eq		*eqs;
 	struct mana_tx_qp	**tx_qp;
 	struct mana_rxq		**rxqs;
 
@@ -733,13 +731,6 @@ struct mana_qset {
 	 */
 	int			mtu;
 	struct bpf_prog		*bpf_prog;
-
-	/* Per-queue-set debugfs root ("EQs"). Owned by the qset: it is
-	 * recreated by mana_create_eq() for each new set and torn down
-	 * with that set, so it must travel with the qset rather than
-	 * staying on apc.
-	 */
-	struct dentry		*mana_eqs_debugfs;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -751,13 +742,14 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
-/* Pre-allocate + swap reconfiguration path (prototype). Allocation and
- * teardown run against a scratch context so the live port context is only
- * mutated inside mana_publish_qset(), with TX disabled.
+/* Pre-allocate + swap reconfiguration. Allocation and teardown run against a
+ * scratch context, so the live port context is mutated only inside
+ * mana_publish_qset() with TX disabled. Both sets share a port-owned EQ pool.
  */
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
-- 
2.43.0

