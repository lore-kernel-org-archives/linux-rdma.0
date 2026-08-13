Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C83F37106E;
	Thu, 13 Aug 2026 05:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597502; cv=none; b=WHwQQYhH8qC4a3i3z2Ca3kSXydHrHVUWCjRlbr+JQHqJg/9YGHqKF0CoWT33Z97JNbcpdvp84u0sghWeMJyWibrxCYRd0ZOSOYGCfCU2Fubmj4ebYjMq3lJ5vtTrtoxbo8K0q+CUXQGPEYjogeuE+ttApguqclUt2qJHIOyhbB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597502; c=relaxed/simple;
	bh=tWo4NuotaAEwGrTVUFXvCDizS0bLq1la7XwE1WC2EF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVwB9CmupJtGQtsSohSOI7lhFNRlW7nmsJcUHTx7SpQ30P94GOXKrSszidI2kRztXPaStUPfAPInILqeU5ap1oaAmp5XVu2nNrHkEEEQfpFAwUfHvF8hzYUExEfRx4Lzk4vkpi26uheVEqbMOIi/uT731L0iMSE8gKCAVhgAU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 75DCA20B7135; Wed, 12 Aug 2026 22:04:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 75DCA20B7135
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
Subject: [PATCH net-next v2 05/13] net: mana: swap queue sets in mana_change_mtu
Date: Wed, 12 Aug 2026 22:04:10 -0700
Message-ID: <20260813050418.2906468-6-longli@microsoft.com>
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

The RX buffer layout depends on the MTU, so changing it rebuilds the
queues. Convert mana_change_mtu() to pre-allocate and swap.

The MTU becomes part of the queue-set configuration, so a new set can be
built for the new MTU while the running one still serves traffic at the
old one, and ndev->mtu is updated only once the new set is live.
Previously it was written before mana_attach() and rolled back on
failure, so a failed change was briefly visible to the stack.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 69 ++++++++++++++-----
 .../ethernet/microsoft/mana/mana_ethtool.c    |  8 ++-
 include/net/mana/mana.h                       | 13 +++-
 3 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c0f31b386536a34af338c4d8be50537e2fe55317..c858a58577dfb1774b2b9394c01e9000edbe8bf9 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -884,35 +884,49 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
 	return -ENOMEM;
 }
 
+/* ndev->mtu is updated only once the new set is live (mana_publish_qset), so
+ * a failed allocation leaves the queues and the advertised MTU untouched.
+ */
 static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct mana_port_context *mpc = netdev_priv(ndev);
-	unsigned int old_mtu = ndev->mtu;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err;
 
-	/* Pre-allocate buffers to prevent failure in mana_attach later */
-	err = mana_pre_alloc_rxbufs(mpc, new_mtu, mpc->num_queues);
-	if (err) {
-		netdev_err(ndev, "Insufficient memory for new MTU\n");
-		return err;
+	/* Port is down: no queues to rebuild, just record the new MTU.
+	 * mana_open() will size the RX buffers accordingly.
+	 */
+	if (!mpc->port_is_up) {
+		mpc->configured_mtu = new_mtu;
+		WRITE_ONCE(ndev->mtu, new_mtu);
+		return 0;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto out;
-	}
+	scratch = mana_qset_scratch_alloc(mpc);
+	if (!scratch)
+		return -ENOMEM;
 
-	WRITE_ONCE(ndev->mtu, new_mtu);
+	err = mana_alloc_qset(scratch, mpc->num_queues, mpc->rx_queue_size,
+			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
+			      &newq);
+	if (err)
+		goto free_scratch; /* current qset and ndev->mtu untouched */
 
-	err = mana_attach(ndev);
+	err = mana_publish_qset(mpc, &newq, &oldq);
 	if (err) {
-		netdev_err(ndev, "mana_attach failed: %d\n", err);
-		WRITE_ONCE(ndev->mtu, old_mtu);
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
 
-out:
-	mana_pre_dealloc_rxbufs(mpc);
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	/* After the caller-side cleanup above, so the EQ pool outlives the
+	 * CQs that reference it.
+	 */
+	mana_publish_close_if_needed(mpc);
+	mana_qset_scratch_free(scratch);
 	return err;
 }
 
@@ -3089,7 +3103,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	mana_get_rxbuf_cfg(apc, ndev->mtu, &rxq->datasize, &rxq->alloc_size,
+	mana_get_rxbuf_cfg(apc, apc->configured_mtu, &rxq->datasize,
+			   &rxq->alloc_size,
 			   &rxq->headroom, &rxq->frag_count);
 	/* Create page pool for RX queue */
 	err = mana_create_page_pool(rxq, gc);
@@ -3928,6 +3943,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->rx_queue_size	= ctx->rx_queue_size;
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
+	out->mtu		= ctx->configured_mtu;
 	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
@@ -3949,6 +3965,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->rx_queue_size	= qset->rx_queue_size;
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
+	ctx->configured_mtu	= qset->mtu;
 	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
@@ -4011,7 +4028,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  */
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4023,6 +4040,12 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
 
+	/* mana_get_rxbuf_cfg() reads this when sizing RX buffers, so the
+	 * new set is built for the requested MTU without disturbing the
+	 * running set.
+	 */
+	scratch->configured_mtu	= mtu;
+
 	err = mana_init_port_context(scratch);
 	if (err)
 		goto out_err;
@@ -4237,6 +4260,11 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (err)
 		goto rollback;
 
+	/* The new set is serving traffic, so advertise its MTU. A no-op unless
+	 * the caller is changing it.
+	 */
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Pair with the queue-state stores above: a datapath reader that sees
 	 * the gate open must also see the queue set it is about to index.
 	 */
@@ -4289,6 +4317,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		return err;
 	}
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Same pairing as the success path: the restored queue set has to be
 	 * visible before the gate reopens on it.
 	 */
@@ -4508,6 +4538,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->pf_filter_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
+	apc->configured_mtu = ndev->mtu;
 	apc->link_cfg_error = 1;
 	apc->cqe_coalescing_enable = 0;
 	apc->cqe8_coalescing_enable = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index dc3a0a22959ef19e2ea9921e81c7295aef628ccf..f4818305bec83f8a60ce02baf280b0d4b9fcb51e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -723,7 +723,8 @@ static int mana_set_channels(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags, &newq);
+			      apc->tx_queue_size, apc->priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch; /* current qset untouched, nothing to undo */
 
@@ -818,7 +819,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, &newq);
+			      apc->priv_flags, apc->configured_mtu, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -916,7 +917,8 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
-			      apc->tx_queue_size, priv_flags, &newq);
+			      apc->tx_queue_size, priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch; /* current qset and priv_flags untouched */
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 66a653bad22eba511d8cf8cf71b572c604044ecb..b9d79240dbc7cc0fb106336d68b6f0cf3a34f2bf 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -620,6 +620,11 @@ struct mana_port_context {
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
+	/* MTU the RX queues were built for. Equal to ndev->mtu except during a
+	 * swap, when the new set is built before ndev->mtu is updated.
+	 */
+	int configured_mtu;
+
 	mana_handle_t port_handle;
 	mana_handle_t pf_filter_handle;
 
@@ -710,6 +715,12 @@ struct mana_qset {
 	unsigned int		tx_queue_size;
 	u32			priv_flags;
 
+	/* MTU the RX buffers of this set were sized for. It feeds
+	 * mana_get_rxbuf_cfg(), so it is part of the queue-set
+	 * configuration and must be swapped atomically with the queues.
+	 */
+	int			mtu;
+
 	/* Per-queue-set debugfs root ("EQs"). Owned by the qset: it is
 	 * recreated by mana_create_eq() for each new set and torn down
 	 * with that set, so it must travel with the qset rather than
@@ -735,7 +746,7 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
 void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out);
+		    u32 priv_flags, int mtu, struct mana_qset *out);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-- 
2.43.0

