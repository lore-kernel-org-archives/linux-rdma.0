Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8883ABD9D;
	Tue, 11 Aug 2026 06:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430178; cv=none; b=EfUT+mXBgYXa7T2AAmbJmn6Wk/KN60kYy0vodV16ANsRUOHVlaWynMZTO9kNjfI7vPhxnW8sG5EXH45EhLUKnNHHYM1BALbIv0YyDvScRKdHmshWlgwbmLpKldcEP5Tos3lEZ4t6qY3Awc58z9+ugfWioO30zXotkk/Zry4x+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430178; c=relaxed/simple;
	bh=FHiokBhCwu8PaeTYtoTMGjEL75SQ71NitNqJWX8HpnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDwR+8YKoiZ1yKGyqVfqPIudMgrA6azIIJr6awtC+uv+bCanQg+ErZJWN6FqX0BwOjU+RMtK2cMZMGWBOKGCQNYO8qVbZegYz0hQFUN9br2Ku69cxV1cLPR36dFyjsGqGTHjLWRHeSM4ouh97VKEvNYVdqp/fDiZv9g0JfkCWBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A291C20B6F01; Mon, 10 Aug 2026 23:35:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A291C20B6F01
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
Subject: [PATCH net-next v2 13/13] net: mana: keep the existing queues when the channel count is raised
Date: Mon, 10 Aug 2026 23:35:30 -0700
Message-ID: <20260811063530.2428424-5-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063530.2428424-1-longli@microsoft.com>
References: <20260811063530.2428424-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reduction path already carries its surviving queues over instead of
rebuilding them. An increase still builds a complete second set and
throws the running one away, even though it keeps every queue it already
had:

  set_channels 4 -> 8    created SQ=8  RQ=8  | destroyed SQ=4  RQ=4

The reasoning that makes a reduction safe is not directional. A TX queue
is built from apc->tx_queue_size and apc->eqs[i], an RX queue from
apc->rx_queue_size and the MTU/priv-flag/XDP buffer layout, and queue i
is bound to EQ i at any count. Nothing a queue is made of depends on how
many queues there are, so the queues that were already running are
configured identically before and after and can simply be carried over.

Add mana_grow_qset(), the mirror image of mana_split_qset(). It builds
the new set's pointer arrays with the running queues in [0, old) and
calls the builders for [old, new) only, so growing 4 channels to 8
creates 4 SQ/RQ pairs instead of 8 and never holds 12 of each against
the vport's advertised maximum. The queues that stay keep their page
pools, their posted RX buffers and their NAPI state. As with a reduction
the result is handed to the existing mana_publish_qset(), so the swap
ordering, the TX quiesce and the rollback are unchanged.

Building part of a set needs the builders to start at an index, so
mana_create_txq() and mana_add_rx_queues() take a first-queue argument,
and mana_destroy_txq_from() / mana_destroy_rxqs_from() tear down a range
without freeing the array the caller still needs. mana_create_txq()
allocates apc->tx_qp[] only when it is building from zero.

One thing does not carry over by itself. mana_chn_setxdp() decides what
to do by reading rxqs[0], which is now a queue that already has the
program, so the call in mana_publish_qset() returns early and would
leave the new queues without one. mana_grow_qset() therefore attaches
the program itself, addressing the new queues through a separate qset so
that exactly as many references are taken as there are new queues - the
same view mana_free_qset() uses to drop them again if the swap fails.

With this, mana_set_channels() no longer builds a set through
mana_alloc_qset(), and the four callers that remain - ring resize, MTU,
the full-page RX private flag and XDP attach - all rebuild at the
current queue count. mana_alloc_qset() can therefore never need a new
EQ, so drop its mana_grow_eqs() call and the queue count it was passed;
growing the pool is now something only mana_grow_qset() does.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 287 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  52 +++-
 include/net/mana/mana.h                       |   7 +-
 4 files changed, 293 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 7031ecb4da2e0fd5b83aeb07aeb8d7ae56e16d65..0edaea807c7fd21abb8ec0dc9d76894adbf77f92 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -220,7 +220,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return -ENOMEM;
 		}
 
-		err = mana_alloc_qset(apc, scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7cd2fd9ea050f10604dc0adb368c0aa4e7b6bb10..ed0e1ac8a7dc07ed64174d221bb7b09fa72f4731 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -923,7 +923,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -2874,7 +2874,12 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 	mana_gd_destroy_queue(gd->gdma_context, txq->gdma_sq);
 }
 
-static void mana_destroy_txq(struct mana_port_context *apc)
+/* Destroy the TX queues in [@first, apc->num_queues). The array itself is
+ * left in place: a partial teardown is used by the grow path, where the
+ * queues below @first are still live and still referenced by the array.
+ */
+static void mana_destroy_txq_from(struct mana_port_context *apc,
+				  unsigned int first)
 {
 	struct napi_struct *napi;
 	int i;
@@ -2882,7 +2887,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 	if (!apc->tx_qp)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		if (!apc->tx_qp[i])
 			continue;
 
@@ -2907,6 +2912,14 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 
 		kvfree(apc->tx_qp[i]);
 	}
+}
+
+static void mana_destroy_txq(struct mana_port_context *apc)
+{
+	if (!apc->tx_qp)
+		return;
+
+	mana_destroy_txq_from(apc, 0);
 
 	kfree(apc->tx_qp);
 	apc->tx_qp = NULL;
@@ -2937,8 +2950,14 @@ static void mana_create_txq_debugfs(struct mana_port_context *apc, int idx)
 			    tx_qp->tx_cq.gdma_cq, &mana_dbg_q_fops);
 }
 
+/* Create the TX queues in [@first, apc->num_queues).
+ *
+ * @first is non-zero only for the grow path, which supplies an already
+ * allocated apc->tx_qp[] holding the queues that are being carried over.
+ * On error only the queues this call created are torn down.
+ */
 static int mana_create_txq(struct mana_port_context *apc,
-			   struct net_device *net)
+			   struct net_device *net, unsigned int first)
 {
 	struct mana_context *ac = apc->ac;
 	struct gdma_dev *gd = ac->gdma_dev;
@@ -2953,9 +2972,14 @@ static int mana_create_txq(struct mana_port_context *apc,
 	int err;
 	int i;
 
-	apc->tx_qp = kzalloc_objs(struct mana_tx_qp *, apc->num_queues);
-	if (!apc->tx_qp)
-		return -ENOMEM;
+	if (first) {
+		if (WARN_ON(!apc->tx_qp))
+			return -EINVAL;
+	} else {
+		apc->tx_qp = kzalloc_objs(struct mana_tx_qp *, apc->num_queues);
+		if (!apc->tx_qp)
+			return -ENOMEM;
+	}
 
 	/*  The minimum size of the WQE is 32 bytes, hence
 	 *  apc->tx_queue_size represents the maximum number of WQEs
@@ -2972,7 +2996,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 	gc = gd->gdma_context;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		apc->tx_qp[i] = kvzalloc_obj(*apc->tx_qp[i]);
 		if (!apc->tx_qp[i]) {
 			err = -ENOMEM;
@@ -3080,7 +3104,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 out:
 	netdev_err(net, "Failed to create %d TX queues, %d\n",
 		   apc->num_queues, err);
-	mana_destroy_txq(apc);
+	if (first)
+		mana_destroy_txq_from(apc, first);
+	else
+		mana_destroy_txq(apc);
 	return err;
 }
 
@@ -3436,14 +3463,19 @@ static void mana_create_rxq_debugfs(struct mana_port_context *apc, int idx)
 			    &mana_dbg_q_fops);
 }
 
+/* Create the RX queues in [@first, apc->num_queues). @first is non-zero only
+ * for the grow path; the slots below it already hold carried-over queues.
+ * Queues created before a failure are left in apc->rxqs[] for the caller to
+ * tear down.
+ */
 static int mana_add_rx_queues(struct mana_port_context *apc,
-			      struct net_device *ndev)
+			      struct net_device *ndev, unsigned int first)
 {
 	struct mana_rxq *rxq;
 	int err = 0;
 	int i;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		rxq = mana_create_rxq(apc, i, &apc->eqs[i], ndev);
 		if (IS_ERR(rxq)) {
 			err = PTR_ERR(rxq);
@@ -3462,14 +3494,18 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 	return err;
 }
 
-static void mana_destroy_rxqs(struct mana_port_context *apc)
+/* Destroy the RX queues in [@first, apc->num_queues). The array itself is
+ * left in place; see mana_destroy_txq_from().
+ */
+static void mana_destroy_rxqs_from(struct mana_port_context *apc,
+				   unsigned int first)
 {
 	struct mana_rxq *rxq;
 	u32 rxq_idx;
 
 	if (apc->rxqs) {
 
-		for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
+		for (rxq_idx = first; rxq_idx < apc->num_queues; rxq_idx++) {
 			rxq = apc->rxqs[rxq_idx];
 			if (!rxq)
 				continue;
@@ -3480,6 +3516,11 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
 	}
 }
 
+static void mana_destroy_rxqs(struct mana_port_context *apc)
+{
+	mana_destroy_rxqs_from(apc, 0);
+}
+
 static void mana_destroy_vport(struct mana_port_context *apc)
 {
 	struct gdma_dev *gd = apc->ac->gdma_dev;
@@ -3863,7 +3904,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_vport;
 	}
 
-	err = mana_create_txq(apc, ndev);
+	err = mana_create_txq(apc, ndev, 0);
 	if (err) {
 		netdev_err(ndev, "Failed to create TXQ on vPort %u: %d\n",
 			   apc->port_idx, err);
@@ -3878,7 +3919,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_txq;
 	}
 
-	err = mana_add_rx_queues(apc, ndev);
+	err = mana_add_rx_queues(apc, ndev, 0);
 	if (err)
 		goto destroy_rxq;
 
@@ -4433,11 +4474,181 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
 	memset(tailq, 0, sizeof(*tailq));
 }
 
+/**
+ * mana_grow_qset - extend the live queue set with freshly built queues
+ * @apc:       live port context, owner of the shared EQ pool
+ * @scratch:   scratch context from mana_qset_scratch_alloc()
+ * @new_count: number of queues the new set must have
+ * @out_new:   filled with the set to publish, queues [0, @new_count)
+ * @out_fresh: filled with just the queues this call created, for rollback
+ *
+ * The mirror image of mana_split_qset(). A channel-count increase does not
+ * change any property of the queues that already exist: queue i is built from
+ * apc->tx_queue_size / apc->rx_queue_size, the MTU/priv-flag/XDP buffer layout
+ * and apc->eqs[i], none of which depend on how many queues there are. So the
+ * running queues are carried over and only the [old, @new_count) tail is
+ * built, instead of constructing a second full set and throwing the running
+ * one away.
+ *
+ * That also keeps the peak at @new_count queues rather than old + new: growing
+ * 4 channels to 8 creates 4 SQ/RQ pairs instead of 8, and never has 12 of each
+ * outstanding against the vport's advertised maximum. The queues that stay
+ * keep their page pools, their posted RX buffers and their NAPI state.
+ *
+ * @out_fresh describes the same queues as the tail of @out_new, but as a
+ * standalone set, so that a failed mana_publish_qset() can hand it to
+ * mana_free_qset() and retire exactly the queues this call created.
+ *
+ * On success the caller owns both sets. On failure @apc is untouched.
+ */
+int mana_grow_qset(struct mana_port_context *apc,
+		   struct mana_port_context *scratch, unsigned int new_count,
+		   struct mana_qset *out_new, struct mana_qset *out_fresh)
+{
+	unsigned int old_count = apc->num_queues;
+	struct mana_tx_qp **new_tx, **fresh_tx;
+	struct mana_rxq **new_rx, **fresh_rx;
+	struct net_device *ndev = apc->ndev;
+	unsigned int fresh_count;
+	unsigned int i;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(new_count <= old_count))
+		return -EINVAL;
+	if (WARN_ON(!apc->tx_qp || !apc->rxqs))
+		return -EINVAL;
+
+	fresh_count = new_count - old_count;
+
+	new_tx = kzalloc_objs(struct mana_tx_qp *, new_count);
+	new_rx = kzalloc_objs(struct mana_rxq *, new_count);
+	fresh_tx = kzalloc_objs(struct mana_tx_qp *, fresh_count);
+	fresh_rx = kzalloc_objs(struct mana_rxq *, fresh_count);
+	if (!new_tx || !new_rx || !fresh_tx || !fresh_rx) {
+		err = -ENOMEM;
+		goto free_arrays;
+	}
+
+	for (i = 0; i < old_count; i++) {
+		new_tx[i] = apc->tx_qp[i];
+		new_rx[i] = apc->rxqs[i];
+	}
+
+	/* Build into @scratch, which now describes the merged set: the
+	 * builders fill in the [old_count, new_count) slots and leave the
+	 * carried-over ones alone. Only the queue count differs from @apc,
+	 * so every other property is inherited as-is.
+	 */
+	scratch->num_queues = new_count;
+	scratch->tx_qp = new_tx;
+	scratch->rxqs = new_rx;
+
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		goto free_arrays;
+
+	/* Same shared, port-owned EQ pool as a full rebuild; this only adds
+	 * the vectors the extra queues need.
+	 */
+	err = mana_grow_eqs(apc, new_count);
+	if (err)
+		goto cleanup_rss;
+
+	scratch->eqs = apc->eqs;
+	scratch->num_eqs = apc->num_eqs;
+
+	err = mana_create_txq(scratch, ndev, old_count);
+	if (err)
+		goto cleanup_rss; /* create_txq already undid its own work */
+
+	err = mana_add_rx_queues(scratch, ndev, old_count);
+	if (err)
+		goto cleanup_rxq;
+
+	if (mana_rss_table_keep(apc, new_count))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
+
+	mana_qset_snapshot(scratch, out_new);
+
+	for (i = 0; i < fresh_count; i++) {
+		fresh_tx[i] = new_tx[old_count + i];
+		fresh_rx[i] = new_rx[old_count + i];
+	}
+
+	memset(out_fresh, 0, sizeof(*out_fresh));
+	out_fresh->tx_qp	= fresh_tx;
+	out_fresh->rxqs		= fresh_rx;
+	out_fresh->default_rxobj = INVALID_MANA_HANDLE;
+	out_fresh->num_queues	= fresh_count;
+	out_fresh->rx_queue_size = apc->rx_queue_size;
+	out_fresh->tx_queue_size = apc->tx_queue_size;
+	out_fresh->priv_flags	= apc->priv_flags;
+	out_fresh->mtu		= apc->configured_mtu;
+	out_fresh->bpf_prog	= apc->bpf_prog;
+
+	/* mana_publish_qset() cannot attach the XDP program to these queues:
+	 * mana_chn_setxdp() decides from rxqs[0], which is a carried-over
+	 * queue that already holds the program, and returns early. Attach it
+	 * here instead, addressing only the new queues through @out_fresh so
+	 * exactly fresh_count references are taken - the same view that
+	 * mana_free_qset() uses to drop them again.
+	 */
+	mana_qset_install(scratch, out_fresh);
+	mana_chn_setxdp(scratch, mana_xdp_get(apc));
+
+	return 0;
+
+cleanup_rxq:
+	mana_destroy_rxqs_from(scratch, old_count);
+	mana_destroy_txq_from(scratch, old_count);
+cleanup_rss:
+	mana_cleanup_indir_table(scratch);
+free_arrays:
+	/* Only the containers: every queue they name is still live on @apc. */
+	scratch->tx_qp = NULL;
+	scratch->rxqs = NULL;
+	kfree(new_tx);
+	kfree(new_rx);
+	kfree(fresh_tx);
+	kfree(fresh_rx);
+
+	/* Give back any EQ this attempt added rather than holding its MSI-X
+	 * vectors: the live set still needs only apc->num_queues of them, and
+	 * every CQ this call created has been destroyed above.
+	 */
+	mana_shrink_eqs(apc, apc->num_queues);
+
+	netdev_err(ndev, "mana_grow_qset(num_queues=%u) failed: %d\n",
+		   new_count, err);
+	return err;
+}
+
+/**
+ * mana_discard_grow - drop the merged containers built by mana_grow_qset()
+ * @newq: set that was never published
+ *
+ * Frees only the pointer arrays and the steering table. The carried-over
+ * queues belong to the live port context and the fresh ones are retired
+ * through the matching @out_fresh set, so no queue is destroyed here.
+ */
+void mana_discard_grow(struct mana_qset *newq)
+{
+	kfree(newq->tx_qp);
+	kfree(newq->rxqs);
+	kfree(newq->indir_table);
+	kfree(newq->rxobj_table);
+	memset(newq, 0, sizeof(*newq));
+}
+
 /**
  * mana_alloc_qset - build a complete queue set in @scratch
  * @apc:	   live port context, owner of the shared EQ pool
  * @scratch:	   scratch context from mana_qset_scratch_alloc()
- * @num_queues:	   number of queues in the new set
  * @rx_queue_size: new RX ring size
  * @tx_queue_size: new TX ring size
  * @priv_flags:	   new priv-flag word (affects full-page RX)
@@ -4445,13 +4656,18 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
  * @bpf_prog:	   XDP program the new set is sized for, may be NULL
  * @out:	   output qset, populated on success
  *
+ * Rebuilds the port's queues at the current queue count for callers that
+ * change a per-queue property. Changing the count itself does not come
+ * through here: mana_set_channels() carries the queues it keeps over with
+ * mana_split_qset() or mana_grow_qset(), so this never has to add an EQ and
+ * the existing pool always covers the set being built.
+ *
  * Every queue is built in @scratch, so the queue set currently installed on
- * @apc keeps serving traffic throughout. @apc is touched only to grow the
- * shared EQ pool, which both sets reference while they are both live. On
- * error no queue is left allocated, and any EQ this call added is released.
+ * @apc keeps serving traffic throughout. On error no queue is left
+ * allocated.
  */
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out)
@@ -4461,7 +4677,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 
 	ASSERT_RTNL();
 
-	scratch->num_queues	= num_queues;
+	scratch->num_queues	= apc->num_queues;
 	scratch->rx_queue_size	= rx_queue_size;
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
@@ -4481,22 +4697,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq_array;
 
-	/* Grow the port's shared EQ pool if this set needs more. The pool
-	 * belongs to @apc, not to either queue set, so both sets can be
-	 * live at once without double-booking MSI-X vectors.
+	/* The queue count is unchanged, so the port's shared EQ pool already
+	 * has an EQ for every queue this set will build. Both sets reference
+	 * the same pool while they are live, so a swap never needs old + new
+	 * MSI-X vectors.
 	 */
-	err = mana_grow_eqs(apc, num_queues);
-	if (err)
-		goto cleanup_rss;
-
 	scratch->eqs = apc->eqs;
 	scratch->num_eqs = apc->num_eqs;
 
-	err = mana_create_txq(scratch, ndev);
+	err = mana_create_txq(scratch, ndev, 0);
 	if (err)
 		goto cleanup_rss;
 
-	err = mana_add_rx_queues(scratch, ndev);
+	err = mana_add_rx_queues(scratch, ndev, 0);
 	if (err)
 		goto cleanup_rxq;
 
@@ -4505,7 +4718,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	 * them onto the new set's RX objects. A driver-generated table is
 	 * rebuilt instead, so it covers every queue of the new set.
 	 */
-	if (mana_rss_table_keep(apc, num_queues))
+	if (mana_rss_table_keep(apc, scratch->num_queues))
 		memcpy(scratch->indir_table, apc->indir_table,
 		       apc->indir_table_sz * sizeof(*apc->indir_table));
 	else
@@ -4527,15 +4740,11 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
-	/* Give back any EQ this attempt added to the shared pool rather than
-	 * holding its MSI-X vectors until some later teardown: the live set
-	 * still needs only apc->num_queues of them. Safe here because this
-	 * set's CQs have already been destroyed above.
+	/* No EQ to give back: this path never adds one, it reuses the pool
+	 * the live set is already using.
 	 */
-	mana_shrink_eqs(apc, apc->num_queues);
-
 	netdev_err(ndev, "mana_alloc_qset(num_queues=%u) failed: %d\n",
-		   num_queues, err);
+		   apc->num_queues, err);
 	return err;
 }
 
@@ -4873,7 +5082,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
  * pointer from the scratch parent behind rather than NULL, so both have to
  * count as "no node". Must be called under RTNL.
  */
-static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+void mana_qset_debugfs_publish(struct mana_port_context *apc)
 {
 	unsigned int i;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 091b4a79ad238151b3a7f2014306b9551680c929..408aa38fe64263446ca419b250370cf44bc8b4e4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -650,12 +650,14 @@ static int mana_set_coalesce(struct net_device *ndev,
 
 /* mana_set_channels - change the number of queues on a port
  *
- * Uses the pre-allocate + swap path (mana_alloc_qset / mana_publish_qset
- * / mana_free_qset). If allocation of the new queue set fails, the
- * existing queues keep running unchanged and we simply return -ENOMEM;
- * the user's requested setting is never silently mutated to a fallback
- * value. The vport is never torn down, so RDMA cannot race in and take
- * ownership of it during the reconfiguration window.
+ * A channel-count change leaves every surviving queue configured exactly as
+ * it was, so neither direction rebuilds them: a reduction carries the kept
+ * queues over and retires the tail (mana_split_qset), an increase carries all
+ * of them over and builds only the queues being added (mana_grow_qset). If
+ * the operation fails, the existing queues keep running unchanged and we
+ * simply return the error; the user's requested setting is never silently
+ * mutated to a fallback value. The vport is never torn down, so RDMA cannot
+ * race in and take ownership of it during the reconfiguration window.
  */
 static int mana_set_channels(struct net_device *ndev,
 			     struct ethtool_channels *channels)
@@ -663,7 +665,7 @@ static int mana_set_channels(struct net_device *ndev,
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
 	struct mana_port_context *scratch;
-	struct mana_qset newq, oldq;
+	struct mana_qset newq, oldq, freshq;
 	int err;
 
 	if (new_count < 1 || new_count > apc->max_queues) {
@@ -771,19 +773,41 @@ static int mana_set_channels(struct net_device *ndev,
 		goto free_scratch;
 	}
 
-	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, apc->bpf_prog, &newq);
+	/* An increase does not change the queues that already exist either, so
+	 * carry them over as well and build only the queues being added. The
+	 * peak stays at the new count instead of old + new.
+	 */
+	err = mana_grow_qset(apc, scratch, new_count, &newq, &freshq);
 	if (err)
 		goto free_scratch; /* current qset untouched, nothing to undo */
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(apc, scratch, &newq);
+		/* The old set is live again. Retire the queues that were just
+		 * built - @freshq names exactly those - and then drop the
+		 * merged containers without touching the carried-over queues.
+		 */
+		mana_free_qset(apc, scratch, &freshq);
+		mana_discard_grow(&newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(apc, scratch, &oldq);
+	/* Nothing is retired by a grow: every queue @oldq referenced is now
+	 * part of the published set, and so is every queue in @freshq. Only
+	 * the containers of both are released here.
+	 */
+	kfree(oldq.tx_qp);
+	kfree(oldq.rxqs);
+	kfree(oldq.indir_table);
+	kfree(oldq.rxobj_table);
+	kfree(freshq.tx_qp);
+	kfree(freshq.rxqs);
+
+	/* A grow retires nothing, so mana_free_qset() never runs to hand out
+	 * the debugfs names. The queues that were just added are the only
+	 * ones missing a node, and no retiring set is holding their names.
+	 */
+	mana_qset_debugfs_publish(apc);
 
 free_scratch:
 	/* After the caller-side cleanup above, so the EQ pool outlives the
@@ -874,7 +898,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
+	err = mana_alloc_qset(apc, scratch, new_rx, new_tx,
 			      apc->priv_flags, apc->configured_mtu,
 			      apc->bpf_prog, &newq);
 	if (err) {
@@ -976,7 +1000,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 8603f66ded7c2a8745d257ba4b8b5801a1c289e3..3c286ba9d1376cf0268e268ff3802b32e29202b0 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -769,7 +769,7 @@ int mana_detach(struct net_device *ndev, bool from_close);
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
@@ -777,11 +777,16 @@ int mana_split_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int new_count,
 		    struct mana_qset *out_new, struct mana_qset *out_tail);
 void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq);
+int mana_grow_qset(struct mana_port_context *apc,
+		   struct mana_port_context *scratch, unsigned int new_count,
+		   struct mana_qset *out_new, struct mana_qset *out_fresh);
+void mana_discard_grow(struct mana_qset *newq);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
 void mana_free_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, struct mana_qset *qset);
+void mana_qset_debugfs_publish(struct mana_port_context *apc);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
-- 
2.43.0

