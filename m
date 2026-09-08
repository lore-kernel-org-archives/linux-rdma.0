Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C433242D9;
	Tue,  8 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838172; cv=none; b=M6XOaxDc6Ws99TPMwCLmRNGZNl5PQDlQtOLI4wm4t9SfVE2TjAjBC5U68BbCbNDlcW13oJrR6TFCfePLD3W/LOaLOdCbqv9tcrXgpqPeksFJA4Kv8/9/HcqnVwJMt9RoFqiUocIWG4y0K49qsbOK05IUZiaVWko1vhuGe9CLQoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838172; c=relaxed/simple;
	bh=JfjhhilWL8leFgUwZcQ+3urMakjKZU29OQwNzw/8hJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUGR5ZOx2PzIO7lq+NQAn3mLme51zQ5rtYTMVHz1i5Wo9Jo4Dm6bCtLcnTlmU675LQj25PQFHTkAzHgmcz0ClECbOoHbui1SzwyMhmX0WdfuuBrd8RgE9w8a4/CvCyGr3xtVfuWDYaT8N9S8HN2EWd5BH4vU8awcr3lSqqZq9oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 27A0020B7001; Mon,  7 Sep 2026 20:28:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 27A0020B7001
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
Subject: [PATCH net-next v4 07/13] net: mana: swap queue sets in mana_xdp_set
Date: Mon,  7 Sep 2026 20:28:37 -0700
Message-ID: <20260908032843.397667-8-longli@microsoft.com>
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

Carry the XDP program with the queue set and install its per-queue
references before redirecting RSS. This keeps the RX buffer layout and
program together during publication and rollback.

Do not replace the live program during allocation. This also avoids the
pre-existing failed-preallocation stale-pointer bug; its standalone net
fix is linked below.

Link: https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Reference the separately submitted net fix and shorten the XDP
    ownership explanation.

Merge note:
  This overlaps the net submission:
  https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/

  Retain this patch's queue-set version of mana_xdp_set() when resolving
  the overlapping block. It does not assign the live program before
  allocation and removes the failure path where the net fix restores
  apc->bpf_prog.

 .../net/ethernet/microsoft/mana/mana_bpf.c    | 61 +++++++++----------
 drivers/net/ethernet/microsoft/mana/mana_en.c | 12 ++--
 .../ethernet/microsoft/mana/mana_ethtool.c    | 11 ++--
 include/net/mana/mana.h                       |  5 +-
 4 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 4365e26cc73874a727ea3cae93ec959956d2d42a..2dc2624128a9141012ab59b723dbfc9617ae6237 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -177,6 +177,8 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	struct bpf_prog *old_prog;
 	struct gdma_context *gc;
 	int err;
@@ -196,46 +198,44 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
-	/* One refcnt of the prog is hold by the caller already, so
-	 * don't increase refcnt for this one.
-	 */
-	apc->bpf_prog = prog;
-
 	if (apc->port_is_up) {
-		/* Re-create rxq's after xdp prog was loaded or unloaded.
-		 * Ex: re create rxq's to switch from full pages to smaller
-		 * size page fragments when xdp prog is unloaded and
-		 * vice-versa.
-		 */
-
-		/* Pre-allocate buffers to prevent failure in mana_attach */
-		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
-		if (err) {
+		scratch = mana_qset_scratch_alloc(apc);
+		if (!scratch) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "XDP: Insufficient memory for tx/rx re-config");
-			return err;
+					   "XDP: Insufficient memory for re-config");
+			return -ENOMEM;
 		}
 
-		err = mana_detach(ndev, false);
+		err = mana_alloc_qset(apc, scratch, apc->num_queues,
+				      apc->rx_queue_size, apc->tx_queue_size,
+				      apc->priv_flags, apc->configured_mtu,
+				      prog, &newq);
 		if (err) {
-			netdev_err(ndev,
-				   "mana_detach failed at xdp set: %d\n", err);
 			NL_SET_ERR_MSG_MOD(extack,
-					   "XDP: Re-config failed at detach");
-			goto err_dealloc_rxbuffs;
+					   "XDP: Re-config failed at alloc");
+			mana_qset_scratch_free(scratch);
+			return err;
 		}
 
-		err = mana_attach(ndev);
+		err = mana_publish_qset(apc, &newq, &oldq);
 		if (err) {
-			netdev_err(ndev,
-				   "mana_attach failed at xdp set: %d\n", err);
 			NL_SET_ERR_MSG_MOD(extack,
-					   "XDP: Re-config failed at attach");
-			goto err_dealloc_rxbuffs;
+					   "XDP: Re-config failed at publish");
+			mana_free_qset(scratch, &newq);
+			/* Free the queues before closing their shared EQ pool.
+			 */
+			mana_publish_close_if_needed(apc);
+			mana_qset_scratch_free(scratch);
+			return err;
 		}
 
-		mana_chn_setxdp(apc, prog);
-		mana_pre_dealloc_rxbufs(apc);
+		mana_free_qset(scratch, &oldq);
+		mana_qset_scratch_free(scratch);
+	} else {
+		/* Use the caller's program reference; mana_open() installs it
+		 * on queues.
+		 */
+		apc->bpf_prog = prog;
 	}
 
 	if (old_prog)
@@ -248,11 +248,6 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
 
 	return 0;
-
-err_dealloc_rxbuffs:
-	apc->bpf_prog = old_prog;
-	mana_pre_dealloc_rxbufs(apc);
-	return err;
 }
 
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7f7833f3e1aad43d250b15ddb35f59907d01929e..62c11af2fc422206f0ab8e144a4d082d62f7737d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -916,9 +916,9 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!scratch)
 		return -ENOMEM;
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues,
-			      mpc->rx_queue_size, mpc->tx_queue_size,
-			      mpc->priv_flags, new_mtu, &newq);
+	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
+			      mpc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -3916,6 +3916,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
+	out->bpf_prog		= ctx->bpf_prog;
 }
 
 /* Vport identity and port debugfs outlive queue sets. */
@@ -3933,6 +3934,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
+	ctx->bpf_prog		= qset->bpf_prog;
 }
 
 /* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
@@ -3973,7 +3975,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -3986,6 +3989,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	scratch->priv_flags	= priv_flags;
 
 	scratch->configured_mtu	= mtu;
+	scratch->bpf_prog	= bpf_prog;
 
 	err = mana_init_port_context(scratch);
 	if (err)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index c03944f95cf84dcbaa866e92f6c7d67100215b7b..32f40f5cd850e6c67ea0dd57cc45a51b37c43b93 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -709,7 +709,7 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -798,7 +798,8 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, apc->configured_mtu, &newq);
+			      apc->priv_flags, apc->configured_mtu,
+			      apc->bpf_prog, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -886,9 +887,9 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(apc, scratch, apc->num_queues,
-			      apc->rx_queue_size, apc->tx_queue_size,
-			      priv_flags, apc->configured_mtu, &newq);
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+			      apc->tx_queue_size, priv_flags,
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch;
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 02d60a6b7be423ae55a93fa21e53717e40918eb7..9b8c038042b4f90b0b5958fc33cdad36e169863c 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -698,6 +698,8 @@ struct mana_qset {
 	u32			priv_flags;
 
 	int			mtu;
+	struct bpf_prog		*bpf_prog;
+
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -715,7 +717,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out);
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-- 
2.43.0
