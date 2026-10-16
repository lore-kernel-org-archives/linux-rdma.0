Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0226D4FD275;
	Fri, 16 Oct 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165148; cv=none; b=ffZtKXnZZNWsr0wEmuEdvB1uQUU8JF07fRoKXEEn7EMbcXg7U4SAoxYV6xk8MNbwava3kwdj8FrXOuPhsfm6hVGDmROvY2iVWjAebp4KckD+Ulk0KGMYg1EfaVUGqUqV1NyE8MeayfWduSsNkICK3a/40ekcgS6AX6W4M2gQ7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165148; c=relaxed/simple;
	bh=x65Dlw3tdFCtngunrRuJLemiOyF+A52eaonXCqjCdLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoK3DqR71dpcLB2SWRg3+Y2/4Kf8pOlcAH7BcW5C/0u9TT4IvXO9O7rADX5CEA9kEJ/+G+dw0OE/DeARan3CAdZy45nTssfZfdmbv2HQHaiGj10/dxr9zrFfqA5AkPahDXQ7gMaCwu4dwYpsiLDMZyou8kyTvx+ngBAfduyqYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NK2oR9Fg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NK2oR9Fg"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5AFD520B716F;
	Fri, 16 Oct 2026 08:39:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5AFD520B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165141;
	bh=f2gOW0a2O0y2QtChbmKzQIrkTcF310ykPebOHgAKQXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK2oR9Fg/pqK9e4jSIpWY3FXW40N7mVTd3tmwN0sWRw6iKxDLIZqTsRKBW23sJkru
	 SSYms/B14P0nOKT7IYYUNWac2O49cxFaAaaGi56AKRPr8HFjaFYdaUgdpR3N/g7hfQ
	 hYfjTF8opSw+x1CR+DZOkBkFz72RIFXCuw2MXOLk=
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
Subject: [PATCH net-next v7 07/13] net: mana: swap queue sets in mana_change_mtu
Date: Fri, 16 Oct 2026 15:38:40 +0000
Message-ID: <87e016ed7479a33be87128b01bb07d2e1807c87d.1791710735.git.weh@linux.microsoft.com>
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

Carry the MTU in the queue set and size replacement RX buffers from it.
Publish ndev->mtu after RSS configuration succeeds; allocation failure
leaves the live queues and advertised MTU unchanged.

This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
RX buffers and page pools live. The port-owned EQ pool is shared,
not doubled. Device resource limits may reject this temporary peak;
allocation failure preserves the live queues and configuration.

Reserve RAW-QP admission under vport_mutex for the entire live
replacement, including unpublished queues, fail-close and scratch
cleanup. Preserve validation, no-op and down-port behavior.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 66 ++++++++++++++-----
 .../ethernet/microsoft/mana/mana_ethtool.c    | 10 +--
 include/net/mana/mana.h                       |  7 +-
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c80a06ffbe50..c1ff4d9b8d45 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -956,32 +956,52 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
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
+	/* Fail-close may release the Ethernet vport reference. */
+	mutex_lock(&mpc->vport_mutex);
+	if (mpc->channel_changing) {
+		mutex_unlock(&mpc->vport_mutex);
+		return -EBUSY;
+	}
+	mpc->channel_changing = true;
+	mutex_unlock(&mpc->vport_mutex);
+
+	scratch = mana_qset_scratch_alloc(mpc);
+	if (!scratch) {
+		err = -ENOMEM;
+		goto clear_flag;
 	}
 
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
+clear_flag:
+	mutex_lock(&mpc->vport_mutex);
+	mpc->channel_changing = false;
+	mutex_unlock(&mpc->vport_mutex);
 	return err;
 }
 
@@ -3335,7 +3355,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	mana_get_rxbuf_cfg(apc, ndev->mtu, &rxq->datasize, &rxq->alloc_size,
+	mana_get_rxbuf_cfg(apc, apc->configured_mtu, &rxq->datasize,
+			   &rxq->alloc_size,
 			   &rxq->headroom, &rxq->frag_count);
 	/* Create page pool for RX queue */
 	err = mana_create_page_pool(rxq, gc);
@@ -4045,6 +4066,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->rx_queue_size	= ctx->rx_queue_size;
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
+	out->mtu		= ctx->configured_mtu;
 }
 
 /* Vport identity and port debugfs outlive queue sets. */
@@ -4061,6 +4083,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->rx_queue_size	= qset->rx_queue_size;
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
+	ctx->configured_mtu	= qset->mtu;
 }
 
 /* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
@@ -4101,7 +4124,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4113,6 +4136,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
 
+	scratch->configured_mtu	= mtu;
+
 	err = mana_init_port_context(scratch);
 	if (err)
 		goto out_err;
@@ -4365,6 +4390,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (err)
 		goto rollback;
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Publish fields before opening the gate; pair with TX/XDP read
 	 * barriers. The post-gate full barrier cannot replace this.
 	 */
@@ -4420,6 +4447,8 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	synchronize_net();
 	mana_fold_qset_rx_stats(apc, out_old);
 
+	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
+
 	/* Publish restored fields before reopening the gate, as on success. */
 	smp_wmb();
 
@@ -4572,6 +4601,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->pf_filter_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
+	apc->configured_mtu = ndev->mtu;
 	apc->link_cfg_error = 1;
 	apc->cqe_coalescing_enable = 0;
 	apc->cqe8_coalescing_enable = 0;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 9c7c9879d0aa..43575aa3a168 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -738,7 +738,8 @@ static int mana_set_channels(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
-			      apc->tx_queue_size, apc->priv_flags, &newq);
+			      apc->tx_queue_size, apc->priv_flags,
+			      apc->configured_mtu, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -827,7 +828,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, &newq);
+			      apc->priv_flags, apc->configured_mtu, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -916,8 +917,9 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
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
index 14025024acfa..60c7df78316c 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -637,6 +637,10 @@ struct mana_port_context {
 	unsigned int rx_queue_size;
 	unsigned int tx_queue_size;
 
+	/* MTU used to size RX buffers, independent of ndev->mtu during a swap.
+	 */
+	int configured_mtu;
+
 	mana_handle_t port_handle;
 	mana_handle_t pf_filter_handle;
 
@@ -713,6 +717,7 @@ struct mana_qset {
 	unsigned int		tx_queue_size;
 	u32			priv_flags;
 
+	int			mtu;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -735,7 +740,7 @@ static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
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

