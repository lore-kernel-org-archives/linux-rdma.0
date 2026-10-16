Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185344D1791;
	Fri, 16 Oct 2026 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165141; cv=none; b=BQ8A+BuVrAREac+eWh10ukck+356avSbPixMnLz1ODepXa9zEIyqYTUp05Ji7+DAE+tZWEFp79ikyo4dN0g58C+qlVEQKZWI2V7vGQcUd1wMO0cERR6jANbiqz2WFPks33QwomrKpUr6T8nnHOvf8mmjrlb1ZbkG0o827xVnI2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165141; c=relaxed/simple;
	bh=n0ZMAl9uDW0YtqzBpZmjp90a0dwHPcMUGdrFJurrfEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDcyYaYdcBEoITjknGfMq2jQG7RCCaLZBjhPzOl632hxx8yc10vBv5Xmrq0wOO6ca7saLsvE9I25RCM5xCJdI7WgYi5YKN4ioFJ0tM4QD9Ni4ML2wbTiWVfC6pAicCfJPoBp8S+reSzbMBk5fkjNAoDwPxhCqFfx9WPx4pQAVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TUPIzjB/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TUPIzjB/"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id B994820B7168;
	Fri, 16 Oct 2026 08:38:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B994820B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165128;
	bh=xihMUBXtoL7FRBKRAqRlKl72lQ1OpagGen1LNdY7OzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUPIzjB/jPM6hyE0coBXt0ktxFqe1KmVEhe1j+s3veFLq9M6/SVPx9l6gfLZ35LL0
	 pcWfwhkBr9MAT2nf1w4rdjCbQkZh56wrKlYMJV7hxur066lMu6BvfWAidT29Nqu6V8
	 7SYladSORbMC2YXSJhEnUFlmwHzy/4y2O7MnJMbc=
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
Subject: [PATCH net-next v7 01/13] net: mana: add queue-set allocation and teardown helpers
Date: Fri, 16 Oct 2026 15:38:34 +0000
Message-ID: <05911ee531022aa0103a35b45a70995aad74dc71.1791710735.git.weh@linux.microsoft.com>
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

Add queue-set allocation and teardown helpers using a scratch port
context without releasing the vport. These prepare reconfiguration
to retain its running queues if replacement allocation fails.

Leave ordinary mana_dealloc_queues() byte-identical to the pinned
base. Do not introduce reset generations, sibling-port rebuilds, or
an incomplete independent failed-FLR TX-buffer policy change.

Queue-set retirement itself performs no function reset. Its caller
must drain old published TX queues before publishing a replacement;
unpublished sets have never admitted TX. The first live-swap commit
adds that nonresetting pre-publication wait. These helpers have no
live replacement callers yet.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  24 +++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 184 +++++++++++++++++-
 include/net/mana/mana.h                       |  31 +++
 3 files changed, 236 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 484f061bc75e..ec708f3401a0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -263,3 +263,27 @@ int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 		return -EOPNOTSUPP;
 	}
 }
+
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
+/* Keep the per-queue program pointers until RX polling stops. */
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
index 489558176a5d..7586972e78e0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2047,7 +2047,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
-	if (txq_stopped && apc->port_is_up && avail_space >= MAX_TX_WQE_SIZE) {
+	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
+	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
 		apc->eth_stats.wake_queue++;
 	}
@@ -3042,11 +3043,11 @@ static int mana_push_wqe(struct mana_rxq *rxq)
 
 static int mana_create_page_pool(struct mana_rxq *rxq, struct gdma_context *gc)
 {
-	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
 	struct page_pool_params pprm = {};
 	int ret;
 
-	pprm.pool_size = mpc->rx_queue_size / rxq->frag_count + 1;
+	/* Size the pool for this RX queue, not the live configuration. */
+	pprm.pool_size = rxq->num_rx_buf / rxq->frag_count + 1;
 	pprm.nid = gc->numa_node;
 	pprm.napi = &rxq->rx_cq.napi;
 	pprm.netdev = rxq->ndev;
@@ -3795,6 +3796,179 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	return 0;
 }
 
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
+}
+
+/* Vport identity and port debugfs outlive queue sets. */
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
+}
+
+/* Copy the vport identity without borrowing the live queues. */
+struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
+{
+	struct mana_port_context *scratch;
+
+	scratch = kvzalloc_obj(*scratch, GFP_KERNEL);
+	if (!scratch)
+		return NULL;
+
+	*scratch = *apc;
+
+	scratch->eqs		= NULL;
+	scratch->tx_qp		= NULL;
+	scratch->rxqs		= NULL;
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+	scratch->default_rxobj	= INVALID_MANA_HANDLE;
+	scratch->mana_eqs_debugfs = NULL;
+
+	/* Do not consume the live set's pre-allocated RX buffers. */
+	scratch->rxbufs_pre	= NULL;
+	scratch->das_pre	= NULL;
+	scratch->rxbpre_total	= 0;
+
+	/* Suppress debugfs names that would collide with the live set. */
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
+	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
+		   num_queues, err);
+	return err;
+}
+
+/* Under RTNL, free only queues no longer shared with the installed set. */
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
+	if (qset->tx_qp) {
+		unsigned int q;
+
+		for (q = 0; q < qset->num_queues; q++) {
+			if (qset->tx_qp[q])
+				WRITE_ONCE(qset->tx_qp[q]->txq.retiring, true);
+		}
+	}
+
+	/* Keep retired queues and arrays through this grace period; local NAPI
+	 * synchronization does not drain other devices' XDP.
+	 */
+	synchronize_net();
+
+	mana_qset_install(scratch, qset);
+
+	/* Keep retiring RXQs' XDP programs and references until RX teardown. */
+	retiring_prog = mana_chn_xdp_peek(scratch);
+	retiring_queues = scratch->num_queues;
+
+	/* Published queues were drained before the swap; unpublished queues
+	 * have never admitted TX.
+	 */
+	/* Fence RQs before unmapping, but teardown proceeds on errors. */
+	mana_fence_rqs(scratch);
+
+	mana_destroy_rxqs(scratch);
+
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
 int mana_detach(struct net_device *ndev, bool from_close)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -4279,6 +4453,10 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		unregister_netdevice(ndev);
 		mana_cleanup_indir_table(apc);
 
+		/* Remove the port from reset walks before freeing its netdev.
+		 */
+		ac->ports[i] = NULL;
+
 		rtnl_unlock();
 
 		free_netdev(ndev);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 8c3dc9d0b299..1d91b62299f5 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -143,6 +143,9 @@ struct mana_txq {
 
 	bool napi_initialized;
 
+	/* Suppress completion wakeups on the replacement's netdev queue. */
+	bool retiring;
+
 	struct mana_stats_tx stats;
 };
 
@@ -548,6 +551,7 @@ struct mana_context {
 	u8 bm_hostmode;
 
 	struct mana_ethtool_hc_stats hc_stats;
+
 	struct workqueue_struct *per_port_queue_reset_wq;
 	/* Workqueue for querying hardware stats */
 	struct delayed_work gf_stats_work;
@@ -672,6 +676,23 @@ struct mana_port_context {
 	u32 steer_cqe_coalescing;
 };
 
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
+};
+
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
@@ -681,6 +702,14 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
+struct mana_port_context *
+mana_qset_scratch_alloc(struct mana_port_context *apc);
+void mana_qset_scratch_free(struct mana_port_context *scratch);
+int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
+		    unsigned int rx_queue_size, unsigned int tx_queue_size,
+		    u32 priv_flags, struct mana_qset *out);
+void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
 int mana_probe(struct gdma_dev *gd, bool resuming);
@@ -696,6 +725,8 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
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

