Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27043F65FB;
	Tue, 11 Aug 2026 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430143; cv=none; b=RXQJ/HeoncS3B/nDwCafMS3MdhwC2rHYndVO8G0HxO6tnheXdvkJtCnpYKFQfBgcZnSsyMtdj9xSxrRsVfnlFrGxr+OKg/dOVfQhHnfesssXuFAPvJFV6qCwYhcEPhX0s/OrwOthtC9pZNP7v6/weiGn5zfcv5+Neavoy9FvqKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430143; c=relaxed/simple;
	bh=AnHJrSQUJXESc6dnbTI3E1aPlhbe1yoyLXPP2M+26f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPxYNMaHFLAxsI0huCi9NTQjqYSdU0rBolVN+MBv3Zw3WgeSchYzQ+1tnRQXa4w9TlQpdLgQbAx4KfrLmPfLtz3wgpVRk6CJXvC9654w57KYpqIWZg/VxQDcjDS/7Yh2SMRudWDzqadvVHeOIqy5K2hqZUUYKUspVgkmA0tFydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id CDD9320B7017; Mon, 10 Aug 2026 23:35:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CDD9320B7017
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
Date: Mon, 10 Aug 2026 23:35:06 -0700
Message-ID: <20260811063506.2428213-10-longli@microsoft.com>
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

Raising the channel count fails with -ENOSPC once the queue-set swap is
in use:

  # ethtool -L ens1 combined 32
  netlink error: No space left on device
  mana 7870:00:00.0: No free MSI vectors available
  mana 7870:00:00.0 ens1: mana_alloc_qset(num_queues=32) failed: -28

mana_alloc_qset() called mana_create_eq() to build a complete second set
of EQs while the running set still held its own. EQs are bound to MSI-X
vectors taken from gc->msi_bitmap, so peak demand was
old_num_queues + new_num_queues and had to fit in gc->num_msix_usable.
On a VM with 32 usable vectors and a driver that comes up at 16 queues,
16 -> 17 already needs 33 and fails, so the advertised maximum channel
count is unreachable and a ring resize is impossible at 32 channels.

Fix it by making the EQ pool belong to the port rather than to a queue
set. Both sets share it across a swap, so peak usage is max(old, new)
instead of the sum:

 - struct mana_qset no longer carries eqs or the EQ debugfs dir.
 - mana_port_context gains num_eqs, a high-water mark of how many EQs
   have been created. mana_create_eq() now sizes the array to
   max_queues, so growing it later never reallocates - the CQs of a live
   queue set hold pointers taken from those slots.
 - mana_grow_eqs() creates only the EQs a larger set needs. It is
   grow-only: EQs above the current queue count are kept for a later
   increase. The ceiling is apc->max_queues, the same value ethtool
   reports as maximum combined, so those vectors are by definition
   obtainable.
 - mana_alloc_qset() takes the live port context as well as the scratch
   one, since the pool it grows belongs to the former.
 - Neither mana_alloc_qset()'s error path nor mana_free_qset() tears the
   pool down any more; it is released by mana_destroy_eq() on detach as
   before.

mana_destroy_eq() now iterates num_eqs rather than num_queues. Those were
always equal before this patch, but with a grow-only pool they are not,
and iterating num_queues would leak the EQs above it.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 126 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |   6 +-
 include/net/mana/mana.h                       |  22 +--
 4 files changed, 119 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index ff953cbfda0ea8b27d18367fd8047d2183f3591b..1bae4174e268f7f53b0880c5d1098cd0ef687f25 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -220,7 +220,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return -ENOMEM;
 		}
 
-		err = mana_alloc_qset(scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch, apc->num_queues,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 60ea12e7e866385688c9095759e7c03f28c7771f..71cbdebc5f3f7126495b2b11f0c673955fe0f8df 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -923,7 +923,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -1839,7 +1839,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 	debugfs_remove_recursive(apc->mana_eqs_debugfs);
 	apc->mana_eqs_debugfs = NULL;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = 0; i < apc->num_eqs; i++) {
 		eq = apc->eqs[i].eq;
 		if (!eq)
 			continue;
@@ -1851,6 +1851,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 
 	kfree(apc->eqs);
 	apc->eqs = NULL;
+	apc->num_eqs = 0;
 }
 EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
@@ -1879,9 +1880,14 @@ int mana_create_eq(struct mana_port_context *apc)
 
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
@@ -1911,6 +1917,7 @@ int mana_create_eq(struct mana_port_context *apc)
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
 		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
 	}
 
 	return 0;
@@ -1920,6 +1927,78 @@ int mana_create_eq(struct mana_port_context *apc)
 }
 EXPORT_SYMBOL_NS(mana_create_eq, "NET_MANA");
 
+/**
+ * mana_grow_eqs - make sure the port has at least @need EQs
+ * @apc:  port context
+ * @need: number of EQs the new queue set requires
+ *
+ * EQs are bound to MSI-X vectors, which are a fixed per-device resource.
+ * Creating a second full set while the running one is still live would
+ * need old + new vectors and fails with -ENOSPC once that exceeds the
+ * pool, so the EQ pool is owned by the port and shared by both queue
+ * sets across a swap. Peak usage is therefore max(old, new), never the
+ * sum.
+ *
+ * Grow-only: EQs above the current queue count are kept for a later
+ * increase. The ceiling is apc->max_queues, which is the same value
+ * ethtool reports as the maximum combined channel count, so the vectors
+ * are by definition obtainable.
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
@@ -4026,9 +4105,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
  * disabled.
  *
  * Note that both sets are live between publish and free, so this peaks at
- * old+new queues, and therefore at old+new MSI-X vectors. A later patch
- * gives the port a shared EQ pool so only the queues, not the interrupts,
- * are doubled up.
+ * old+new queues. The EQs are not doubled up: they belong to a port-owned
+ * pool that both sets share, so a swap never needs old+new MSI-X vectors.
  *
  * Per-queue debugfs is suppressed for a set while it is being built or torn
  * down (see mana_qset_scratch_alloc()): the directory names are derived from
@@ -4042,7 +4120,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 static void mana_qset_snapshot(const struct mana_port_context *ctx,
 			       struct mana_qset *out)
 {
-	out->eqs		= ctx->eqs;
 	out->tx_qp		= ctx->tx_qp;
 	out->rxqs		= ctx->rxqs;
 	out->indir_table	= ctx->indir_table;
@@ -4055,7 +4132,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
 	out->bpf_prog		= ctx->bpf_prog;
-	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
 /* Install @qset's fields onto @ctx. The vport (port_handle,
@@ -4065,7 +4141,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
-	ctx->eqs		= qset->eqs;
 	ctx->tx_qp		= qset->tx_qp;
 	ctx->rxqs		= qset->rxqs;
 	ctx->indir_table	= qset->indir_table;
@@ -4078,7 +4153,6 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
 	ctx->bpf_prog		= qset->bpf_prog;
-	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
 /**
@@ -4101,13 +4175,14 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 	*scratch = *apc;
 
 	/* Owns no queues yet. */
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
 
 	/* Never consume the live set's pre-allocated RX buffers;
 	 * mana_get_rxbuf() falls back to normal allocation when these
@@ -4136,6 +4211,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 
 /**
  * mana_alloc_qset - build a complete queue set in @scratch
+ * @apc:	   live port context, owner of the shared EQ pool
  * @scratch:	   scratch context from mana_qset_scratch_alloc()
  * @num_queues:	   number of queues in the new set
  * @rx_queue_size: new RX ring size
@@ -4145,11 +4221,13 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * @bpf_prog:	   XDP program the new set is sized for, may be NULL
  * @out:	   output qset, populated on success
  *
- * The live port context is not referenced at all, so the currently
- * running queue set keeps serving traffic throughout. On error nothing
- * is left allocated.
+ * Every queue is built in @scratch, so the queue set currently installed on
+ * @apc keeps serving traffic throughout. @apc is touched only to grow the
+ * shared EQ pool, which both sets reference while they are both live. On
+ * error no queue is left allocated.
  */
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out)
@@ -4179,13 +4257,20 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
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
@@ -4203,8 +4288,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	 */
 	mana_destroy_rxqs(scratch);
 	mana_destroy_txq(scratch);
-cleanup_eq:
-	mana_destroy_eq(scratch);
 cleanup_rss:
 	mana_cleanup_indir_table(scratch);
 cleanup_rxq_array:
@@ -4585,7 +4668,7 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	ASSERT_RTNL();
 
-	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+	if (!qset->rxqs && !qset->tx_qp)
 		return;
 
 	/* These queues are leaving. Stop their completions from touching the
@@ -4687,7 +4770,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_chn_xdp_release(retiring_prog, retiring_queues);
 
 	mana_destroy_txq(scratch);
-	mana_destroy_eq(scratch);
 	mana_cleanup_indir_table(scratch);
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 4c8799a2be86ca1f7e52cb23f6fb71afdf38acb5..03fe657334c49a69ebe9c2677b2b8268321a162d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -736,7 +736,7 @@ static int mana_set_channels(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
@@ -839,7 +839,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
 			      apc->priv_flags, apc->configured_mtu,
 			      apc->bpf_prog, &newq);
 	if (err) {
@@ -941,7 +941,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 32035605c70c66299b9f9707924ee267fa63cd9a..d09bf2c7cec0be06c4190caab1f0723a5c4956d6 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -588,7 +588,13 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
+	/* EQ pool. Owned by the port, not by a queue set: EQs are bound to
+	 * MSI-X vectors, so a queue-set swap must not double-book them.
+	 * The array is sized to max_queues and num_eqs is a high-water mark
+	 * of how many have actually been created.
+	 */
 	struct mana_eq *eqs;
+	unsigned int num_eqs;
 	struct dentry *mana_eqs_debugfs;
 
 	enum TRI_STATE rss_state;
@@ -725,7 +731,6 @@ struct mana_port_context {
  * can never race in during reconfiguration.
  */
 struct mana_qset {
-	struct mana_eq		*eqs;
 	struct mana_tx_qp	**tx_qp;
 	struct mana_rxq		**rxqs;
 
@@ -745,13 +750,6 @@ struct mana_qset {
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
@@ -763,13 +761,15 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
-/* Pre-allocate + swap reconfiguration path (prototype). Allocation and
+/* Pre-allocate + swap reconfiguration path. Allocation and
  * teardown run against a scratch context so the live port context is only
- * mutated inside mana_publish_qset(), with TX disabled.
+ * mutated inside mana_publish_qset(), with TX disabled. The EQs live in a
+ * port-owned pool that both queue sets share across a swap.
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

