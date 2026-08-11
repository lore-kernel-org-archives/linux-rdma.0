Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91AD6386C17;
	Tue, 11 Aug 2026 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430143; cv=none; b=BiSt4RXIOtQN0D7mOwWnDIIwlyy9FvpWfktrb5l44zOB1Lu9Vf90H8a5Nsy9Tgp0elM4PYNsdyq8YFUPVPD1lroOSDKjhseczC6a5u8Ww3qETjCAFpqYVbB1663kXqGHVyQR1TJ8HU6qdOP+hwvnsNxAz99ji02HIJa2/uhIy6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430143; c=relaxed/simple;
	bh=/zAGfyZMwUm176AScQkuE9ZPnbfPpEA/IeTnXf2liLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh7fQR+m+WAei4L+DgEwD2COoxLWpKOU8042ssuL2Y3IF/vWwNR4/5mKsW92Xr4rBDWB9vuBcDjxKUYSZOwg/hVQalyM0xABHkPjuYQHIr4yAXL617zKJ6NeprUX5OVJMtPvB1z4xM6TLcVLebJGCPvJuLrxpzHqOcwvp2Iir8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B2F7F20B712B; Mon, 10 Aug 2026 23:35:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2F7F20B712B
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
Date: Mon, 10 Aug 2026 23:35:02 -0700
Message-ID: <20260811063506.2428213-6-longli@microsoft.com>
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

The RX buffer layout depends on the MTU - see mana_get_rxbuf_cfg() - so
changing it rebuilds the queues. Convert mana_change_mtu() to the
pre-allocate and swap helpers.

The MTU becomes part of the queue-set configuration:

 - struct mana_qset gains mtu, so it is swapped atomically with the
   queues it describes and restored by the rollback path.
 - mana_port_context gains configured_mtu, the MTU the current RX queues
   were built for. mana_create_rxq() now sizes buffers from it rather
   than ndev->mtu, so a new set can be built for a different MTU while
   ndev->mtu still advertises the old one.
 - mana_publish_qset() commits ndev->mtu once the new set is serving
   traffic. It is a no-op for callers that do not change the MTU.

Previously ndev->mtu was written before mana_attach() and rolled back on
failure, so a failed change was briefly visible to the stack.

mana_pre_alloc_rxbufs() is no longer needed here; de-risking allocation
after teardown is pointless when there is no teardown.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 75 ++++++++++++++-----
 .../ethernet/microsoft/mana/mana_ethtool.c    |  8 +-
 include/net/mana/mana.h                       | 14 +++-
 3 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5f682e3d5a706149954764d083b70f25906f28df..4c79d6e82d9a93786ea877fbcef2b3f9d4093a6c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -889,35 +889,54 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
 	return -ENOMEM;
 }
 
+/* mana_change_mtu - resize RX buffers for a new MTU
+ *
+ * Uses the pre-allocate + swap path: the new queue set is built for
+ * @new_mtu while the current one keeps serving traffic at the old MTU.
+ * ndev->mtu is only updated once the new set is live (see
+ * mana_publish_qset), so a failed allocation leaves both the queues and
+ * the advertised MTU untouched.
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
 
@@ -3097,7 +3116,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	mana_get_rxbuf_cfg(apc, ndev->mtu, &rxq->datasize, &rxq->alloc_size,
+	mana_get_rxbuf_cfg(apc, apc->configured_mtu, &rxq->datasize,
+			   &rxq->alloc_size,
 			   &rxq->headroom, &rxq->frag_count);
 	/* Create page pool for RX queue */
 	err = mana_create_page_pool(rxq, gc);
@@ -3965,6 +3985,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->rx_queue_size	= ctx->rx_queue_size;
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
+	out->mtu		= ctx->configured_mtu;
 	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
@@ -3986,6 +4007,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->rx_queue_size	= qset->rx_queue_size;
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
+	ctx->configured_mtu	= qset->mtu;
 	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
@@ -4049,6 +4071,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * @rx_queue_size: new RX ring size
  * @tx_queue_size: new TX ring size
  * @priv_flags:	   new priv-flag word (affects full-page RX)
+ * @mtu:	   MTU the new set is sized for
  * @out:	   output qset, populated on success
  *
  * The live port context is not referenced at all, so the currently
@@ -4057,7 +4080,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  */
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4069,6 +4092,12 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
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
@@ -4361,6 +4390,11 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (err)
 		goto rollback;
 
+	/* The new set is serving traffic: advertise its MTU. A no-op for
+	 * callers that are not changing the MTU.
+	 */
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Pair with the queue-state stores above: a datapath reader that sees
 	 * the gate open must also see the queue set it is about to index.
 	 */
@@ -4413,6 +4447,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		return err;
 	}
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Same pairing as the success path: the restored queue set has to be
 	 * visible before the gate reopens on it.
 	 */
@@ -4658,6 +4694,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->pf_filter_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
+	apc->configured_mtu = ndev->mtu;
 	apc->link_cfg_error = 1;
 	apc->cqe_coalescing_enable = 0;
 	apc->cqe8_coalescing_enable = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 9392b82d3d48a2638512a53f9c004629b0c679e5..2a6325256fad3edf1aafbc72f0cd5dc18d61384e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -737,7 +737,8 @@ static int mana_set_channels(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags, &newq);
+			      apc->tx_queue_size, apc->priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch; /* current qset untouched, nothing to undo */
 
@@ -839,7 +840,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, &newq);
+			      apc->priv_flags, apc->configured_mtu, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -940,7 +941,8 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
-			      apc->tx_queue_size, priv_flags, &newq);
+			      apc->tx_queue_size, priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch; /* current qset and priv_flags untouched */
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index e4aaad7bec34297cf406181560a1839d3e6a73df..2fc75e6cd41a63878788182cd099379c8c698b33 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -621,6 +621,12 @@ struct mana_port_context {
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
+	/* MTU the current RX queues were built for. Normally equal to
+	 * ndev->mtu, but during a queue-set swap the new set is built for
+	 * the new MTU while ndev->mtu still advertises the old one.
+	 */
+	int configured_mtu;
+
 	mana_handle_t port_handle;
 	mana_handle_t pf_filter_handle;
 
@@ -714,6 +720,12 @@ struct mana_qset {
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
@@ -739,7 +751,7 @@ struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
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

