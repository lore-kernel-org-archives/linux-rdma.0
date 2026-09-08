Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43C631D72E;
	Tue,  8 Sep 2026 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838171; cv=none; b=LDXs+cuo9l3xHSUyZ+HtyzuYcWNKoB9PP2btZVfdI6RG1Wf3rXt7twtBxRWdrCo0CPVCQ6RFLBZ+zzV2tvCba3sNjKncqPXnhq1PTLoD8DZmLynry/c55B5Kb/n6rkxz9Q6pDHC6dQkMCOtBPlTW3VJUHCGm0Iws1NvNJu+l7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838171; c=relaxed/simple;
	bh=E9YQuD4Twq2QHEPiZefr6/uHhhnnDuJXFU8su7JF33I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLfmULaRckUb4O/5yZrjAaprxIobmped/48mUEUbI+qc24mibyYbiuKHgKWDei2uEc2pqwytzWCVasNbfk9wlBcIIn96jDH0j7MpP0umfuI4YNn36bLXvTwjaQjy9KIQ4Kk6CdPP+gbIQX0mjvWqiEpCaUIGigYM9xwoTcERyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id D931020B712B; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D931020B712B
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
Subject: [PATCH net-next v4 02/13] net: mana: share the EQ pool across a queue-set swap
Date: Mon,  7 Sep 2026 20:28:32 -0700
Message-ID: <20260908032843.397667-3-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260908032843.397667-1-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the EQ pool port-owned so overlapping queue sets share EQs instead
of requiring old + new vector allocations. Allocate max_queues slots and
track populated entries with num_eqs.

Grow the pool before creating replacement CQs. Additional EQs survive
allocation failure in this patch and are released at port teardown.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Clarify that allocation can grow the live, port-owned EQ pool and
    that partial growth is retained at this stage of the series.
  - Shorten the scratch-context ownership comments.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 86 ++++++++++++++++---
 include/net/mana/mana.h                       |  6 +-
 2 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5ac3ae9fd7ea2f786dddbd21d340884c008e1020..fc80d4bcde6c453d61222371d7763cff90b2a26a 100644
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
 
@@ -1773,9 +1774,11 @@ int mana_create_eq(struct mana_port_context *apc)
 
 	if (WARN_ON(apc->eqs))
 		return -EEXIST;
-	apc->eqs = kzalloc_objs(struct mana_eq, apc->num_queues);
+	/* Keep EQ array addresses stable while CQs reference them. */
+	apc->eqs = kzalloc_objs(struct mana_eq, apc->max_queues);
 	if (!apc->eqs)
 		return -ENOMEM;
+	apc->num_eqs = 0;
 
 	spec.type = GDMA_EQ;
 	spec.monitor_avl_buf = false;
@@ -1805,6 +1808,7 @@ int mana_create_eq(struct mana_port_context *apc)
 		}
 		apc->eqs[i].eq->eq.irq = gic->irq;
 		mana_create_eq_debugfs(apc, i);
+		apc->num_eqs = i + 1;
 	}
 
 	return 0;
@@ -1814,6 +1818,61 @@ int mana_create_eq(struct mana_port_context *apc)
 }
 EXPORT_SYMBOL_NS(mana_create_eq, "NET_MANA");
 
+/* Grow the shared EQ pool without replacing live entries. */
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
+	/* Retain partial growth for reuse; the live set still needs this pool.
+	 */
+	return err;
+}
+
 static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
 {
 	struct mana_fence_rq_resp resp = {};
@@ -3814,7 +3873,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 static void mana_qset_snapshot(const struct mana_port_context *ctx,
 			       struct mana_qset *out)
 {
-	out->eqs		= ctx->eqs;
 	out->tx_qp		= ctx->tx_qp;
 	out->rxqs		= ctx->rxqs;
 	out->indir_table	= ctx->indir_table;
@@ -3831,7 +3889,6 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
-	ctx->eqs		= qset->eqs;
 	ctx->tx_qp		= qset->tx_qp;
 	ctx->rxqs		= qset->rxqs;
 	ctx->indir_table	= qset->indir_table;
@@ -3844,7 +3901,9 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->priv_flags		= qset->priv_flags;
 }
 
-/* Copy the vport identity without borrowing the live queues. */
+/* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
+ * mana_destroy_eq() on it.
+ */
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 {
 	struct mana_port_context *scratch;
@@ -3855,13 +3914,11 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 
 	*scratch = *apc;
 
-	scratch->eqs		= NULL;
 	scratch->tx_qp		= NULL;
 	scratch->rxqs		= NULL;
 	scratch->indir_table	= NULL;
 	scratch->rxobj_table	= NULL;
 	scratch->default_rxobj	= INVALID_MANA_HANDLE;
-	scratch->mana_eqs_debugfs = NULL;
 
 	/* Do not consume the live set's pre-allocated RX buffers. */
 	scratch->rxbufs_pre	= NULL;
@@ -3879,7 +3936,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 	kvfree(scratch);
 }
 
-int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+int mana_alloc_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out)
 {
@@ -3901,13 +3959,16 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	if (err)
 		goto cleanup_rxq_array;
 
-	err = mana_create_eq(scratch);
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
@@ -3921,8 +3982,6 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 cleanup_rxq:
 	mana_destroy_rxqs(scratch);
 	mana_destroy_txq(scratch);
-cleanup_eq:
-	mana_destroy_eq(scratch);
 cleanup_rss:
 	mana_cleanup_indir_table(scratch);
 cleanup_rxq_array:
@@ -3942,7 +4001,7 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	ASSERT_RTNL();
 
-	if (!qset->rxqs && !qset->tx_qp && !qset->eqs)
+	if (!qset->rxqs && !qset->tx_qp)
 		return;
 
 	if (qset->tx_qp) {
@@ -3995,7 +4054,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_chn_xdp_release(retiring_prog, retiring_queues);
 
 	mana_destroy_txq(scratch);
-	mana_destroy_eq(scratch);
 	mana_cleanup_indir_table(scratch);
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 4c00a98430262b6c8c25bc37c9d1c8b48d928629..de026eeb8fc25f80d3e0f9613fb277eae9ae19a9 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -570,7 +570,9 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
+	/* Port-owned EQ pool: max_queues slots, num_eqs populated. */
 	struct mana_eq *eqs;
+	unsigned int num_eqs;
 	struct dentry *mana_eqs_debugfs;
 
 	enum TRI_STATE rss_state;
@@ -673,7 +675,6 @@ struct mana_port_context {
 };
 
 struct mana_qset {
-	struct mana_eq		*eqs;
 	struct mana_tx_qp	**tx_qp;
 	struct mana_rxq		**rxqs;
 
@@ -701,7 +702,8 @@ int mana_detach(struct net_device *ndev, bool from_close);
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
