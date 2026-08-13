Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A45359A6B;
	Thu, 13 Aug 2026 05:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597505; cv=none; b=ZqmYrt0Y0pWwRc6KF8V9JU4BUbC1+fncL4b1jURzEY9CWtZiy0j81Sk5zieg1BXC7F8cdToP6p1MOc0toOBfepAkVJtKHugb67vsi2tkMdL4hmbKyZERNssHW4EuZHhtX2Z7DeJHJNPG/4QlG8g6HZuER6U9lZBzbTBbM8+WypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597505; c=relaxed/simple;
	bh=9+CKGBs+dUgpFKMfONS/NOkLv/pfzr3bgyzBvhTc+/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDfSBFJ793upH16IHtgsbKBk04DxkOz5N/QNgLt7Ch+R+Vs7zztFx8+IUcjnip650pPhOCE50Z+tbsC5999qRgbxpUtlmwqoz2pwwBrOZCtLI+6rCVEnurdN+NAT1fXTv29t2H/cbw9o4ikOVbw/ETvyBrQc4oQUN0CtbwTgln8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B7D0420B6F15; Wed, 12 Aug 2026 22:04:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B7D0420B6F15
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
Date: Wed, 12 Aug 2026 22:04:18 -0700
Message-ID: <20260813050418.2906468-14-longli@microsoft.com>
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

The reduction path already carries its surviving queues over. An increase
still builds a complete second set and throws the running one away, even
though it keeps every queue it already had:

  set_channels 4 -> 8    created SQ=8  RQ=8  | destroyed SQ=4  RQ=4

The same reasoning applies in both directions. Carry the running queues
over and build only the new tail, so growing 4 channels to 8 creates 4
SQ/RQ pairs instead of 8 and never holds 12 of each against the vport
maximum.

This completes the conversion, so advertise it to the firmware. Every
resize path - channel count, ring size, MTU, the full-page RX private
flag and XDP attach - now builds the new set before retiring the old and
keeps the old one running if that fails.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 246 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  41 ++-
 include/net/mana/gdma.h                       |  11 +-
 include/net/mana/mana.h                       |   7 +-
 5 files changed, 258 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 4b29406595b37877e1e5d14cf93d68aa3c4ace02..f47755fa866004612bd4bd06b417172c7acf9eb7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -213,7 +213,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return -ENOMEM;
 		}
 
-		err = mana_alloc_qset(apc, scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c2b8ac67963fb6134a21b682a1b9ee373b1d0b7c..2d8fcdedc8b66b07cce666f031104a385efd27d6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -913,7 +913,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -2825,7 +2825,11 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 	mana_gd_destroy_queue(gd->gdma_context, txq->gdma_sq);
 }
 
-static void mana_destroy_txq(struct mana_port_context *apc)
+/* The array itself is left in place: the grow path tears down only a range,
+ * and the queues below @first are still live and still referenced by it.
+ */
+static void mana_destroy_txq_from(struct mana_port_context *apc,
+				  unsigned int first)
 {
 	struct napi_struct *napi;
 	int i;
@@ -2833,7 +2837,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 	if (!apc->tx_qp)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		if (!apc->tx_qp[i])
 			continue;
 
@@ -2858,6 +2862,14 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 
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
@@ -2888,8 +2900,12 @@ static void mana_create_txq_debugfs(struct mana_port_context *apc, int idx)
 			    tx_qp->tx_cq.gdma_cq, &mana_dbg_q_fops);
 }
 
+/* @first is non-zero only for the grow path, which supplies an already
+ * allocated apc->tx_qp[] holding the carried-over queues. On error only the
+ * queues this call created are torn down.
+ */
 static int mana_create_txq(struct mana_port_context *apc,
-			   struct net_device *net)
+			   struct net_device *net, unsigned int first)
 {
 	struct mana_context *ac = apc->ac;
 	struct gdma_dev *gd = ac->gdma_dev;
@@ -2904,9 +2920,14 @@ static int mana_create_txq(struct mana_port_context *apc,
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
@@ -2923,7 +2944,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 	gc = gd->gdma_context;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		apc->tx_qp[i] = kvzalloc_obj(*apc->tx_qp[i]);
 		if (!apc->tx_qp[i]) {
 			err = -ENOMEM;
@@ -3031,7 +3052,10 @@ static int mana_create_txq(struct mana_port_context *apc,
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
 
@@ -3387,14 +3411,18 @@ static void mana_create_rxq_debugfs(struct mana_port_context *apc, int idx)
 			    &mana_dbg_q_fops);
 }
 
+/* @first is non-zero only for the grow path; the slots below it already hold
+ * carried-over queues. Queues created before a failure are left in
+ * apc->rxqs[] for the caller to tear down.
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
@@ -3413,14 +3441,16 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 	return err;
 }
 
-static void mana_destroy_rxqs(struct mana_port_context *apc)
+/* The array is left in place; see mana_destroy_txq_from(). */
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
@@ -3431,6 +3461,11 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
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
@@ -3815,7 +3850,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_vport;
 	}
 
-	err = mana_create_txq(apc, ndev);
+	err = mana_create_txq(apc, ndev, 0);
 	if (err) {
 		netdev_err(ndev, "Failed to create TXQ on vPort %u: %d\n",
 			   apc->port_idx, err);
@@ -3830,7 +3865,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_txq;
 	}
 
-	err = mana_add_rx_queues(apc, ndev);
+	err = mana_add_rx_queues(apc, ndev, 0);
 	if (err)
 		goto destroy_rxq;
 
@@ -4313,13 +4348,161 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
 	memset(tailq, 0, sizeof(*tailq));
 }
 
+/* The mirror image of mana_split_qset(): carry the existing queues over into
+ * @out_new and build only the [old, @new_count) tail. Growing 4 channels to 8
+ * creates 4 SQ/RQ pairs, not 8, and never holds 12 against the vport maximum.
+ *
+ * @out_fresh names just the queues created here, so a failed publish retires
+ * exactly those. On failure @apc is untouched.
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
+	bool indir_lost;
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
+	/* @scratch now describes the merged set; the builders fill only the
+	 * [old_count, new_count) slots.
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
+	if (mana_rss_table_keep(apc, new_count, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
+
+	mana_qset_snapshot(scratch, out_new);
+	out_new->rxfh_indir_lost = indir_lost;
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
+	/* mana_publish_qset() cannot do this: mana_chn_setxdp() decides from
+	 * rxqs[0], a carried-over queue that already holds the program, and
+	 * returns early. Address only the new queues through @out_fresh so
+	 * exactly fresh_count references are taken.
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
+ * Frees the pointer arrays and steering table only: carried-over queues
+ * belong to the live context, fresh ones are retired through @out_fresh.
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
 /* Rebuild the queues at the current count in @scratch, for callers changing a
  * per-queue property; a count change goes through mana_split_qset() or
  * mana_grow_qset(), so this never has to add an EQ. The installed set keeps
  * serving traffic meanwhile. On error nothing is left allocated.
  */
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out)
@@ -4330,7 +4513,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 
 	ASSERT_RTNL();
 
-	scratch->num_queues	= num_queues;
+	scratch->num_queues	= apc->num_queues;
 	scratch->rx_queue_size	= rx_queue_size;
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
@@ -4350,22 +4533,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
 
@@ -4374,7 +4554,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	 * them onto the new set's RX objects. A driver-generated table is
 	 * rebuilt instead, so it covers every queue of the new set.
 	 */
-	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
+	if (mana_rss_table_keep(apc, scratch->num_queues, &indir_lost))
 		memcpy(scratch->indir_table, apc->indir_table,
 		       apc->indir_table_sz * sizeof(*apc->indir_table));
 	else
@@ -4397,15 +4577,11 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
 
@@ -4667,7 +4843,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
  * Idempotent: a carried-over queue keeps its node; suppressed creation leaves
  * an error pointer, not NULL, so both read as "no node". Under RTNL.
  */
-static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+void mana_qset_debugfs_publish(struct mana_port_context *apc)
 {
 	unsigned int i;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 415422aa68672accd03c161732fa1e96dd5562ba..a1c24d41903c100fdd5155e80b068ed9eaca26f4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -660,7 +660,7 @@ static int mana_set_channels(struct net_device *ndev,
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
 	struct mana_port_context *scratch;
-	struct mana_qset newq, oldq;
+	struct mana_qset newq, oldq, freshq;
 	int err;
 
 	if (new_count < 1 || new_count > apc->max_queues) {
@@ -755,19 +755,41 @@ static int mana_set_channels(struct net_device *ndev,
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
 	mana_publish_close_if_needed(apc);
@@ -848,7 +870,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
+	err = mana_alloc_qset(apc, scratch, new_rx, new_tx,
 			      apc->priv_flags, apc->configured_mtu,
 			      apc->bpf_prog, &newq);
 	if (err) {
@@ -868,9 +890,6 @@ static int mana_set_ringparam(struct net_device *ndev,
 	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
-	/* After the caller-side cleanup above, so the EQ pool outlives the
-	 * CQs that reference it.
-	 */
 	mana_publish_close_if_needed(apc);
 	mana_qset_scratch_free(scratch);
 clear_flag:
@@ -947,7 +966,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 70a7f1fee5d3b0a6460cbd76159d01a369838d68..c54500700f6f2f4b432102364e64fd021e7c2c88 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -672,6 +672,14 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver recovers by itself when a queue resize fails: a failed resize leaves
+ * the queues that were already serving traffic in place, so the host does not
+ * have to bring the port back. This covers the resize itself failing. It does
+ * not promise recovery when restoring the previous queue set fails too, which
+ * leaves the port administratively down for the admin to bring back up.
+ */
+#define GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE BIT(31)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -688,7 +696,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
-	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)
+	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
+	 GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index cd41a135815710162b1e5fd3edafa119ae12d1dd..8857e7739d2c2505255403defb09749c85804922 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -756,7 +756,7 @@ int mana_detach(struct net_device *ndev, bool from_close);
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
@@ -764,11 +764,16 @@ int mana_split_qset(struct mana_port_context *apc,
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

