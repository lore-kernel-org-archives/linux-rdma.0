Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B7A4A68A1;
	Wed,  9 Sep 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992721; cv=none; b=K1ka4kdd78YfUnqpHnBk97FLSL6zjmb5BRa8Qdsar1Rh+9tCBTo5tYgxpN6tdtjb+2G706prailULPExSOsudD3NNLDUDoaEf2XWKqHPj3bzFx2sLyF1YC/PjG1WZqPLq81FKr4dScLQuqIPSyYZ3+sbFvFgW+zUh7oGxZDmmJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992721; c=relaxed/simple;
	bh=tk/JSF7YOLaVaCZ58cEml+9RAP1u/qXEZOwK0esYZqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCUL1//Jv6TGs7PUBB+XdBJYQDMgBO+VCdSPDwTwqsXFeslWkppGKGQN4Cr2Xo4QvR4cuke8aRA3EG+zkJcPhSR4EtzEMemu/v9oHVZICvjqguClNhK3GYxy546NoexwkUtyyFLQmjA12TmbxNlCHPBBNxSDU1HeyFnokluvEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id E449620B717B; Wed,  9 Sep 2026 15:24:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E449620B717B
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
Subject: [PATCH net-next v5 13/13] net: mana: keep the existing queues when the channel count is raised
Date: Wed,  9 Sep 2026 15:24:16 -0700
Message-ID: <20260909222416.884246-14-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260909222416.884246-1-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep existing queues and allocate only the added tail. Growing N to M
now needs M SQ/RQ pairs at peak, rather than N + M.

Track the fresh queues separately for failure cleanup and XDP references.
Wait for TX-selection readers before freeing old containers, and clear
slots during partial teardown. Full rebuilds now keep the current count.

Advertise in-driver resize recovery after converting the live resize
paths. Failed rollback still requires recovery.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5:
  - Rebased onto current net-next; no changes to this patch.

Changes in v4:
  - Wait for TX-selection readers before freeing old containers.
  - Clear TX pointer-array slots after partial teardown.
  - Shorten comments and qualify the resize-recovery description.

 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 209 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  31 ++-
 include/net/mana/gdma.h                       |   8 +-
 include/net/mana/mana.h                       |   7 +-
 5 files changed, 217 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 2060e08d82277237307ac99ff7ad66b4b134e8b4..3acec1bb02a3403f15fd97a0b46b70b4b75c27b7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -206,7 +206,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return -ENOMEM;
 		}
 
-		err = mana_alloc_qset(apc, scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 158f9a6ce42157ad7afd45ec642405fbd81f0bac..29f54f91cb0094f65cdd09d82cf4f29f3d296437 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -927,7 +927,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -2878,7 +2878,9 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 	mana_gd_destroy_queue(gd->gdma_context, txq->gdma_sq);
 }
 
-static void mana_destroy_txq(struct mana_port_context *apc)
+/* Keep the array and queues below @first; clear freed slots. */
+static void mana_destroy_txq_from(struct mana_port_context *apc,
+				  unsigned int first)
 {
 	struct napi_struct *napi;
 	int i;
@@ -2886,7 +2888,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 	if (!apc->tx_qp)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		if (!apc->tx_qp[i])
 			continue;
 
@@ -2910,7 +2912,16 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 		mana_deinit_txq(apc, &apc->tx_qp[i]->txq);
 
 		kvfree(apc->tx_qp[i]);
+		apc->tx_qp[i] = NULL;
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
@@ -2941,8 +2952,11 @@ static void mana_create_txq_debugfs(struct mana_port_context *apc, int idx)
 			    tx_qp->tx_cq.gdma_cq, &mana_dbg_q_fops);
 }
 
+/* With @first nonzero, use the existing array and unwind only new queues on
+ * failure.
+ */
 static int mana_create_txq(struct mana_port_context *apc,
-			   struct net_device *net)
+			   struct net_device *net, unsigned int first)
 {
 	struct mana_context *ac = apc->ac;
 	struct gdma_dev *gd = ac->gdma_dev;
@@ -2957,9 +2971,14 @@ static int mana_create_txq(struct mana_port_context *apc,
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
@@ -2976,7 +2995,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 	gc = gd->gdma_context;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		apc->tx_qp[i] = kvzalloc_obj(*apc->tx_qp[i]);
 		if (!apc->tx_qp[i]) {
 			err = -ENOMEM;
@@ -3084,7 +3103,10 @@ static int mana_create_txq(struct mana_port_context *apc,
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
 
@@ -3440,14 +3462,15 @@ static void mana_create_rxq_debugfs(struct mana_port_context *apc, int idx)
 			    &mana_dbg_q_fops);
 }
 
+/* The caller must destroy queues added before a failure. */
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
@@ -3465,14 +3488,15 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 	return err;
 }
 
-static void mana_destroy_rxqs(struct mana_port_context *apc)
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
@@ -3483,6 +3507,11 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
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
@@ -3856,7 +3885,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_vport;
 	}
 
-	err = mana_create_txq(apc, ndev);
+	err = mana_create_txq(apc, ndev, 0);
 	if (err) {
 		netdev_err(ndev, "Failed to create TXQ on vPort %u: %d\n",
 			   apc->port_idx, err);
@@ -3871,7 +3900,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_txq;
 	}
 
-	err = mana_add_rx_queues(apc, ndev);
+	err = mana_add_rx_queues(apc, ndev, 0);
 	if (err)
 		goto destroy_rxq;
 
@@ -4254,8 +4283,137 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
 	memset(tailq, 0, sizeof(*tailq));
 }
 
+/* Carry existing queues into @out_new; allocate only the tail. @out_fresh
+ * isolates new queues for cleanup after a failed publish.
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
+	scratch->num_queues = new_count;
+	scratch->tx_qp = new_tx;
+	scratch->rxqs = new_rx;
+
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		goto free_arrays;
+
+	err = mana_grow_eqs(apc, new_count);
+	if (err)
+		goto cleanup_rss;
+
+	scratch->eqs = apc->eqs;
+	scratch->num_eqs = apc->num_eqs;
+
+	err = mana_create_txq(scratch, ndev, old_count);
+	if (err)
+		goto cleanup_rss;
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
+	/* Take XDP refs on fresh RXQs only. On the merged set,
+	 * mana_chn_setxdp() returns early on the carried rxqs[0].
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
+	/* Free containers only; carried queues remain live. */
+	scratch->tx_qp = NULL;
+	scratch->rxqs = NULL;
+	kfree(new_tx);
+	kfree(new_rx);
+	kfree(fresh_tx);
+	kfree(fresh_rx);
+
+	mana_shrink_eqs(apc, apc->num_queues);
+
+	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
+		   new_count, err);
+	return err;
+}
+
+/* Free merged containers only, not carried queues. The caller must retire fresh
+ * queues separately.
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
+/* Rebuild at the current count; resize uses split/grow. */
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out)
@@ -4266,7 +4424,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 
 	ASSERT_RTNL();
 
-	scratch->num_queues	= num_queues;
+	scratch->num_queues	= apc->num_queues;
 	scratch->rx_queue_size	= rx_queue_size;
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
@@ -4282,22 +4440,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq_array;
 
-	err = mana_grow_eqs(apc, num_queues);
-	if (err)
-		goto cleanup_rss;
-
+	/* Reuse the existing EQ pool; the queue count is unchanged. */
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
 
-	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
+	if (mana_rss_table_keep(apc, scratch->num_queues, &indir_lost))
 		memcpy(scratch->indir_table, apc->indir_table,
 		       apc->indir_table_sz * sizeof(*apc->indir_table));
 	else
@@ -4316,10 +4471,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
-	mana_shrink_eqs(apc, apc->num_queues);
-
 	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
-		   num_queues, err);
+		   apc->num_queues, err);
 	return err;
 }
 
@@ -4531,7 +4684,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 }
 
 /* Create missing debugfs nodes once retiring names are gone. */
-static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+void mana_qset_debugfs_publish(struct mana_port_context *apc)
 {
 	unsigned int i;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 0b8c2f61d6263c65a8119b94426f794b218ad55f..6586a9d2a13438bd85d0aa55c55c08a0b3301f78 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -684,7 +684,7 @@ static int mana_set_channels(struct net_device *ndev,
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
 	struct mana_port_context *scratch;
-	struct mana_qset newq, oldq;
+	struct mana_qset newq, oldq, freshq;
 	int err;
 
 	if (new_count < 1 || new_count > apc->max_queues) {
@@ -767,19 +767,33 @@ static int mana_set_channels(struct net_device *ndev,
 		goto free_scratch;
 	}
 
-	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, apc->bpf_prog, &newq);
+	err = mana_grow_qset(apc, scratch, new_count, &newq, &freshq);
 	if (err)
 		goto free_scratch;
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		/* Free only the new queues, then discard the merged containers.
+		 */
+		mana_free_qset(scratch, &freshq);
+		mana_discard_grow(&newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	/* Wait for ndo_select_queue() readers of oldq.indir_table. All queues
+	 * are now live in newq; free only the old and fresh containers.
+	 */
+	synchronize_net();
+
+	kfree(oldq.tx_qp);
+	kfree(oldq.rxqs);
+	kfree(oldq.indir_table);
+	kfree(oldq.rxobj_table);
+	kfree(freshq.tx_qp);
+	kfree(freshq.rxqs);
+
+	/* No retirement runs to publish the new queues' debugfs nodes. */
+	mana_qset_debugfs_publish(apc);
 
 free_scratch:
 	mana_publish_close_if_needed(apc);
@@ -856,7 +870,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
+	err = mana_alloc_qset(apc, scratch, new_rx, new_tx,
 			      apc->priv_flags, apc->configured_mtu,
 			      apc->bpf_prog, &newq);
 	if (err) {
@@ -876,7 +890,6 @@ static int mana_set_ringparam(struct net_device *ndev,
 	mana_free_qset(scratch, &oldq);
 
 free_scratch:
-	/* Release unpublished queues before closing their shared EQ pool. */
 	mana_publish_close_if_needed(apc);
 	mana_qset_scratch_free(scratch);
 clear_flag:
@@ -946,7 +959,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 308950f9b54b0485bac66b80d63e257eaf5f787e..666565ffb26aad6b77044ce1604568aa208a5b79 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -686,6 +686,11 @@ enum {
 /* Driver supports non-contiguous queue buffers */
 #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
 
+/* Resize failures are handled in-driver; a failed rollback still needs
+ * recovery.
+ */
+#define GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE BIT(31)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -703,7 +708,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
-	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
+	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
+	 GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 5ec75de0b644569acdf697e997c262d999295a06..cc936ae97a0318620c011ae55925595858e0fc3d 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -739,7 +739,7 @@ static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
 }
 
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
@@ -747,10 +747,15 @@ int mana_split_qset(struct mana_port_context *apc,
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
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+void mana_qset_debugfs_publish(struct mana_port_context *apc);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
-- 
2.43.0
