Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECFA31E82B;
	Tue,  8 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838172; cv=none; b=tUjrq7bKcNDfco3G/1v82Pr0v5yvVrCe0cUhs4uohUeGC/U/1oAtHnMcIz72FnqlSU/Kso3r+oV+bH6VTCehhI9n72MonuOjRfvtvSJb4sNe/LdIV5lscAu7q2ZjADUaxie/aOrxXs5/T43mo9xuBpRThNmlRdqnl3ZhhvEtM38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838172; c=relaxed/simple;
	bh=Msuqb4TuVU7r+z3ihf+RFPUFu2oD8/3EAd4WWaqjG5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7AMOyyYNDOBQqxKCx1FhThLvT+JPRSm22FTC9DmftNtYJgFz/MnDf0FQj74fdU8O6rkpt0T06aMNkydxez6Ia+xbXIct6WPrh9wX/nxZJFH2CSDZ94qrlc7/1cKPgzDxcd+Tcs/fb/7A1+1xXeOBHiTgiCCDG8Vdbmv7ytuOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 1A77120B713B; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1A77120B713B
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
Subject: [PATCH net-next v4 06/13] net: mana: swap queue sets in mana_change_mtu
Date: Mon,  7 Sep 2026 20:28:36 -0700
Message-ID: <20260908032843.397667-7-longli@microsoft.com>
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

Carry the MTU in the queue set and size replacement RX buffers from it.
Publish ndev->mtu after RSS configuration succeeds; allocation failure
leaves the live queues and advertised MTU unchanged.

This still rebuilds all queues, requiring both sets' SQ/RQ/CQ objects
and RX buffers temporarily. Resource limits can therefore reject an MTU
change that detach/attach previously accepted.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Document the two-set resource peak and possible allocation refusal
    at high queue counts; shorten comments.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 53 ++++++++++++-------
 .../ethernet/microsoft/mana/mana_ethtool.c    | 10 ++--
 include/net/mana/mana.h                       |  7 ++-
 3 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index bb9ef4e634a6edaf097bc85f2248c2ceea88fc05..7f7833f3e1aad43d250b15ddb35f59907d01929e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -902,32 +902,37 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
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
+	err = mana_alloc_qset(mpc, scratch, mpc->num_queues,
+			      mpc->rx_queue_size, mpc->tx_queue_size,
+			      mpc->priv_flags, new_mtu, &newq);
+	if (err)
+		goto free_scratch;
 
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
+	mana_publish_close_if_needed(mpc);
+	mana_qset_scratch_free(scratch);
 	return err;
 }
 
@@ -3153,7 +3158,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	mana_get_rxbuf_cfg(apc, ndev->mtu, &rxq->datasize, &rxq->alloc_size,
+	mana_get_rxbuf_cfg(apc, apc->configured_mtu, &rxq->datasize,
+			   &rxq->alloc_size,
 			   &rxq->headroom, &rxq->frag_count);
 	/* Create page pool for RX queue */
 	err = mana_create_page_pool(rxq, gc);
@@ -3909,6 +3915,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->rx_queue_size	= ctx->rx_queue_size;
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
+	out->mtu		= ctx->configured_mtu;
 }
 
 /* Vport identity and port debugfs outlive queue sets. */
@@ -3925,6 +3932,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->rx_queue_size	= qset->rx_queue_size;
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
+	ctx->configured_mtu	= qset->mtu;
 }
 
 /* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
@@ -3965,7 +3973,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -3977,6 +3985,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
 
+	scratch->configured_mtu	= mtu;
+
 	err = mana_init_port_context(scratch);
 	if (err)
 		goto out_err;
@@ -4153,6 +4163,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (err)
 		goto rollback;
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Publish fields before opening the gate; pair with TX/XDP read
 	 * barriers. The post-gate full barrier cannot replace this.
 	 */
@@ -4192,6 +4204,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		return err;
 	}
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Publish restored fields before reopening the gate, as on success. */
 	smp_wmb();
 
@@ -4362,6 +4376,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->pf_filter_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
+	apc->configured_mtu = ndev->mtu;
 	apc->link_cfg_error = 1;
 	apc->cqe_coalescing_enable = 0;
 	apc->cqe8_coalescing_enable = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index adc65b9146c7e74703db587a619678439ff0d84b..c03944f95cf84dcbaa866e92f6c7d67100215b7b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -708,7 +708,8 @@ static int mana_set_channels(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags, &newq);
+			      apc->tx_queue_size, apc->priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -797,7 +798,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, &newq);
+			      apc->priv_flags, apc->configured_mtu, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -885,8 +886,9 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
-			      apc->tx_queue_size, priv_flags, &newq);
+	err = mana_alloc_qset(apc, scratch, apc->num_queues,
+			      apc->rx_queue_size, apc->tx_queue_size,
+			      priv_flags, apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch;
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index e965d86b4d8502408f175bdbee5d77fb2e406df3..02d60a6b7be423ae55a93fa21e53717e40918eb7 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -616,6 +616,10 @@ struct mana_port_context {
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
+	/* MTU used to size RX buffers, independent of ndev->mtu during a swap.
+	 */
+	int configured_mtu;
+
 	mana_handle_t port_handle;
 	mana_handle_t pf_filter_handle;
 
@@ -693,6 +697,7 @@ struct mana_qset {
 	unsigned int		tx_queue_size;
 	u32			priv_flags;
 
+	int			mtu;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -710,7 +715,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out);
+		    u32 priv_flags, int mtu, struct mana_qset *out);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-- 
2.43.0
