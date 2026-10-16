Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC8F52758E;
	Fri, 16 Oct 2026 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165159; cv=none; b=s8tOGQBOG9hRc3d/QOzAR02qjkKzjWogBQ41ieMzICydgL43nqkfc2t43xf7LQkX02/GiyJlB//6owbRrre55eAgBCBXfN1hn9xGqj20y2FHGTnhzi5xGTR0KS/X4t7/vZupIIOicE8gp9EgblX7pm2Tuqq/QoCz+x1CINLHl70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165159; c=relaxed/simple;
	bh=XUNfCH1GxH7q7g/vmwjj4wc3bcyJquX8CPNqmYIoElY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc0thd/b9w4aSpYKSAmen4lA6kzvmUKc4Wjxn3GK4Zs5GHiFmY5juCJClj3TW01wVgRVMMiMpVCUZQS94KQDUwFv60lMl14Of4uQO7jpGO8RIX8M7Zj6r+cjfjSydelXT+x2/BhMH2OPDgzxnLYIa9fXWQ9ISu+Je8l8dUqxJ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HwDt0nHL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HwDt0nHL"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8AFFC20B716A;
	Fri, 16 Oct 2026 08:39:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8AFFC20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165151;
	bh=urzSpxwqT6JHKj3cNztQKbnIum1jH6Xma9sdV8agd0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwDt0nHLn7q/8Ysaf7nr4zgOmxtT5tUlhYcrY0CWLnNr7HMJP4m/EXOkOaVATsiPF
	 NWf8L5VOwDq3VBWAYPymwTT8A/pYLLfvapyoABYm+BmPDbo6p0+ZWfaWn/MjdLdS6i
	 VveusZoFP085h434O5WTNuTQenwBVeFLRFge82UA=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: [PATCH net-next v7 13/13] net: mana: keep the existing queues when the channel count is raised
Date: Fri, 16 Oct 2026 15:38:46 +0000
Message-ID: <73d87e454e79867ce3f2c685c9a06250cf6bd0c7.1791710735.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Keep existing queues and allocate only the added tail. Growing N to M
now needs M SQ/RQ pairs at peak, rather than N + M.

Track the fresh queues separately for failure cleanup and XDP references.
Wait for TX-selection readers before freeing old containers, and clear
slots during partial teardown. Full rebuilds now keep the current count.

Advertise in-driver resize recovery after converting the live resize
paths. Failed rollback still requires recovery.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 209 +++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  31 ++-
 include/net/mana/gdma.h                       |   8 +-
 include/net/mana/mana.h                       |   7 +-
 5 files changed, 217 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 8eae57ca3aa8..7dc9809db24e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -216,7 +216,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			goto clear_flag;
 		}
 
-		err = mana_alloc_qset(apc, scratch, apc->num_queues,
+		err = mana_alloc_qset(apc, scratch,
 				      apc->rx_queue_size, apc->tx_queue_size,
 				      apc->priv_flags, apc->configured_mtu,
 				      prog, &newq);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 13fc7ee909e8..f8055c62492c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -978,7 +978,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+	err = mana_alloc_qset(mpc, scratch, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
 			      mpc->bpf_prog, &newq);
 	if (err)
@@ -2946,7 +2946,9 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 	mana_gd_destroy_queue(gd->gdma_context, txq->gdma_sq);
 }
 
-static void mana_destroy_txq(struct mana_port_context *apc)
+/* Keep the array and queues below @first; clear freed slots. */
+static void mana_destroy_txq_from(struct mana_port_context *apc,
+				  unsigned int first)
 {
 	struct napi_struct *napi;
 	int i;
@@ -2954,7 +2956,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 	if (!apc->tx_qp)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		if (!apc->tx_qp[i])
 			continue;
 
@@ -2978,7 +2980,16 @@ static void mana_destroy_txq(struct mana_port_context *apc)
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
@@ -3009,8 +3020,11 @@ static void mana_create_txq_debugfs(struct mana_port_context *apc, int idx)
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
@@ -3025,9 +3039,14 @@ static int mana_create_txq(struct mana_port_context *apc,
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
@@ -3044,7 +3063,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 	gc = gd->gdma_context;
 
-	for (i = 0; i < apc->num_queues; i++) {
+	for (i = first; i < apc->num_queues; i++) {
 		apc->tx_qp[i] = kvzalloc_obj(*apc->tx_qp[i]);
 		if (!apc->tx_qp[i]) {
 			err = -ENOMEM;
@@ -3152,7 +3171,10 @@ static int mana_create_txq(struct mana_port_context *apc,
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
 
@@ -3513,14 +3535,15 @@ static void mana_create_rxq_debugfs(struct mana_port_context *apc, int idx)
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
@@ -3538,14 +3561,15 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
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
@@ -3556,6 +3580,11 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
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
@@ -3929,7 +3958,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_vport;
 	}
 
-	err = mana_create_txq(apc, ndev);
+	err = mana_create_txq(apc, ndev, 0);
 	if (err) {
 		netdev_err(ndev, "Failed to create TXQ on vPort %u: %d\n",
 			   apc->port_idx, err);
@@ -3944,7 +3973,7 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_txq;
 	}
 
-	err = mana_add_rx_queues(apc, ndev);
+	err = mana_add_rx_queues(apc, ndev, 0);
 	if (err)
 		goto destroy_rxq;
 
@@ -4282,8 +4311,137 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
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
@@ -4294,7 +4452,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 
 	ASSERT_RTNL();
 
-	scratch->num_queues	= num_queues;
+	scratch->num_queues	= apc->num_queues;
 	scratch->rx_queue_size	= rx_queue_size;
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
@@ -4310,22 +4468,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
@@ -4344,10 +4499,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
 
@@ -4632,7 +4785,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 }
 
 /* Create missing debugfs nodes once retiring names are gone. */
-static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+void mana_qset_debugfs_publish(struct mana_port_context *apc)
 {
 	unsigned int i;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 720376c830e2..43249addc72f 100644
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
@@ -947,7 +960,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+	err = mana_alloc_qset(apc, scratch, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index c610fc1067e0..f659188d5049 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -752,6 +752,11 @@ enum {
 /* Driver supports non-contiguous queue buffers */
 #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
 
+/* Resize failures are handled in-driver; a failed rollback still needs
+ * recovery.
+ */
+#define GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE BIT(31)
+
 /* Capabilities in the PCI-only group below rely on dynamic MSI-X allocation
  * and on the servicing and reset paths reached through
  * mana_schedule_serv_work(). Transports that provide neither leave
@@ -776,7 +781,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
-	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
+	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
+	 GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 761875c1153c..e7fcb2c3ae02 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -742,7 +742,7 @@ static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
 }
 
 int mana_alloc_qset(struct mana_port_context *apc,
-		    struct mana_port_context *scratch, unsigned int num_queues,
+		    struct mana_port_context *scratch,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
@@ -750,10 +750,15 @@ int mana_split_qset(struct mana_port_context *apc,
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

