Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2793C3789;
	Tue,  1 Sep 2026 01:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227129; cv=none; b=UwZXcyAlUPcIjW4aBu7WWLmabZ8tu8MwLQ0JNt4MMuFLh1xGSwyqE7BDCLljN6ZLQsfqolEzLTHX/Y+AuxNeL9PdJf4bNNCODC3x9r2FObsordBS7SYpulRKdkSiT02SzbfIWxPDtMRQi0rodF+PcTleA7gbgHhYA/9aqI/nGMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227129; c=relaxed/simple;
	bh=NeSvT/6wkEOcHk+yuzXqeOEygAej4YOu6O/jaV0w9E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Toon518oubpT9w0JqrC/c7n2cbtoI7EOnFn9fiq3965kAsfggvo1V96kNrIQaH7R2bPEX0NN2oxzioWzW24i0AjDFANtmC5NJqOytum2cHhCzQPodAqwghR21lbdttJIHzbX0kZ1A3DtQeKjotAMeiTvW4HJaeR021pBIvBnHac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 2161B20B7128; Mon, 31 Aug 2026 18:44:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2161B20B7128
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
Subject: [PATCH net-next v3 02/13] net: mana: share the EQ pool across a queue-set swap
Date: Mon, 31 Aug 2026 18:44:31 -0700
Message-ID: <20260901014442.2945689-3-longli@microsoft.com>
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

The queue-set swap the rest of this series builds on keeps the running
set alive while the new one is allocated, so both exist at once. EQs are
bound to MSI-X vectors, and a set that owned its EQs would make that peak
at old + new vectors rather than max(old, new).

With 32 usable vectors and a driver that comes up at 16 queues, 16 -> 17
would already need 33, so the advertised maximum would be unreachable:

  # ethtool -L ens1 combined 32
  netlink error: No space left on device
  mana 7870:00:00.0: No free MSI vectors available

Give the pool to the port rather than to a queue set, before any caller
is converted, so no intermediate patch in this series can hit that. The
pool only ever grows, up to the maximum channel count ethtool reports,
and is released on detach as before.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 107 +++++++++++++++---
 include/net/mana/mana.h                       |  13 ++-
 2 files changed, 100 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b9d9543d1a6dc90b01f6ca378b8a32bd045d6da8..bd80658cf3efc4522ca51fc039242ae91669ea88 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1733,7 +1733,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 	debugfs_remove_recursive(apc->mana_eqs_debugfs);
 	apc->mana_eqs_debugfs = NULL;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = 0; i < apc->num_eqs; i++) {
 		eq = apc->eqs[i].eq;
 		if (!eq)
 			continue;
@@ -1745,6 +1745,7 @@ void mana_destroy_eq(struct mana_port_context *apc)
 
 	kfree(apc->eqs);
 	apc->eqs = NULL;
+	apc->num_eqs = 0;
 }
 EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
@@ -1773,9 +1774,14 @@ int mana_create_eq(struct mana_port_context *apc)
 
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
@@ -1805,6 +1811,7 @@ int mana_create_eq(struct mana_port_context *apc)
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
 		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
 	}
 
 	return 0;
@@ -1814,6 +1821,72 @@ int mana_create_eq(struct mana_port_context *apc)
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
+ *
+ * Return: 0 on success, negative error code on failure.
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
@@ -3861,8 +3934,7 @@ static int mana_dealloc_queues(struct net_device *ndev)
  * destroy the old one. A failed allocation leaves the running config untouched,
  * and the vport is never torn down, so RDMA cannot take it mid-swap. The cost
  * is room for both sets at once, so a rebuild at the vport's maximum queue
- * count can be refused, and both sets' EQs - and so their MSI-X vectors - are
- * live at once.
+ * count can be refused; EQs are shared from a port-owned pool, not doubled.
  *
  * Everything builds in a scratch mana_port_context, since mana_start_xmit()
  * dereferences apc->tx_qp[] guarded only by port_is_up. Per-queue debugfs is
@@ -3873,7 +3945,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 static void mana_qset_snapshot(const struct mana_port_context *ctx,
 			       struct mana_qset *out)
 {
-	out->eqs		= ctx->eqs;
 	out->tx_qp		= ctx->tx_qp;
 	out->rxqs		= ctx->rxqs;
 	out->indir_table	= ctx->indir_table;
@@ -3893,7 +3964,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
-	ctx->eqs		= qset->eqs;
 	ctx->tx_qp		= qset->tx_qp;
 	ctx->rxqs		= qset->rxqs;
 	ctx->indir_table	= qset->indir_table;
@@ -3926,14 +3996,14 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 
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
 
 	/* Never consume the live set's pre-allocated RX buffers; the swap path
 	 * has no post-teardown allocation to de-risk.
@@ -3959,7 +4029,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * installed set keeps serving traffic meanwhile. On error nothing is left
  * allocated.
  */
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out)
 {
@@ -3981,13 +4052,20 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
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
@@ -4005,8 +4083,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	 */
 	mana_destroy_rxqs(scratch);
 	mana_destroy_txq(scratch);
-cleanup_eq:
-	mana_destroy_eq(scratch);
 cleanup_rss:
 	mana_cleanup_indir_table(scratch);
 cleanup_rxq_array:
@@ -4028,7 +4104,7 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	ASSERT_RTNL();
 
-	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+	if (!qset->rxqs && !qset->tx_qp)
 		return;
 
 	/* Keep their completions off the netdev queues they now share. */
@@ -4116,7 +4192,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_chn_xdp_release(retiring_prog, retiring_queues);
 
 	mana_destroy_txq(scratch);
-	mana_destroy_eq(scratch);
 	mana_cleanup_indir_table(scratch);
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 356aaa652fa6f8d3498383e2b7c976da677cfa22..2117a30116c265d6cd9c8223ad4f5ea5d2818455 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -577,7 +577,12 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
+	/* EQ pool, owned by the port rather than a queue set: EQs are bound to
+	 * MSI-X vectors, which a swap must not double-book. Sized to
+	 * max_queues; num_eqs is how many exist.
+	 */
 	struct mana_eq *eqs;
+	unsigned int num_eqs;
 	struct dentry *mana_eqs_debugfs;
 
 	enum TRI_STATE rss_state;
@@ -684,7 +689,6 @@ struct mana_port_context {
  * never touched by a swap.
  */
 struct mana_qset {
-	struct mana_eq		*eqs;
 	struct mana_tx_qp	**tx_qp;
 	struct mana_rxq		**rxqs;
 
@@ -710,13 +714,14 @@ int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
 /* Pre-allocate + swap reconfiguration. Allocation and teardown run against a
- * scratch context, so the live port context is only ever mutated with TX
- * disabled.
+ * scratch context, so the live port context is mutated only inside
+ * mana_publish_qset() with TX disabled. Both sets share a port-owned EQ pool.
  */
 struct mana_port_context *
 mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out);
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
-- 
2.43.0

