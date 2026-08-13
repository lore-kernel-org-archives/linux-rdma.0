Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B13836C9C5;
	Thu, 13 Aug 2026 05:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597502; cv=none; b=S7x5rVMeW684lXZVh/zJHWnBfuOvWn2WFfhMYOJEmhPSZLUoU78C8VRfnkAD0ibzishcjXPNzdALYrj8i6Wa27pvKC/kh/9KZzgBTbxAa++f3z41U7olO0l+Yc2SB2yl019JanH11hY3MPLgBN5kyymwTPL/kDsdC1OTLS+pOEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597502; c=relaxed/simple;
	bh=l/H7VD6XUwtRav9HalkNdgZcxBVBAIpb6V6p6jpzxxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4r1dfE68lG5lYhWu71QnNtE0bTqaXmLlptlGxDDI66K3q+P424KcHscWu0qz3MO+ccxsJ79EMyJ+CG2EAOqc5dzzgXqN66/pbXKEJ2skd5zqEqVUdRiX5lrPCcbs81wJvDH5+ppH8i/0vD6Cp9ac3OKuoDjscS/EXCTewnVfkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 1E5EE20B7136; Wed, 12 Aug 2026 22:04:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1E5EE20B7136
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
Subject: [PATCH net-next v2 06/13] net: mana: swap queue sets in mana_xdp_set
Date: Wed, 12 Aug 2026 22:04:11 -0700
Message-ID: <20260813050418.2906468-7-longli@microsoft.com>
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

Attaching or detaching an XDP program changes the RX buffer layout -
full pages with headroom rather than page fragments - so it rebuilds the
queues. Convert mana_xdp_set() to pre-allocate and swap, completing the
removal of detach/attach from the reconfiguration paths.

The program becomes part of the queue-set configuration, so it is
swapped atomically with the queues it was built for and restored by the
rollback path. Program references follow the same swap, so attaching no
longer leaves the queues briefly running without one.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 68 ++++++++++---------
 drivers/net/ethernet/microsoft/mana/mana_en.c | 14 ++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  7 +-
 include/net/mana/mana.h                       | 16 +++--
 4 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index e16ce2a0715839594a5837288c1d4c1de412e7fb..84b1484faaec8bf411ce402538862347e68954f0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -175,10 +175,17 @@ void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog)
 			bpf_prog_put(old_prog);
 }
 
+/* Attaching or detaching XDP changes the RX buffer layout (full pages vs
+ * fragments), so the RX queues are rebuilt. The swap helpers handle
+ * refcounting: mana_publish_qset() attaches the program to the new queues,
+ * mana_free_qset() drops the old set's references.
+ */
 static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	struct bpf_prog *old_prog;
 	struct gdma_context *gc;
 	int err;
@@ -198,46 +205,46 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
+		err = mana_alloc_qset(scratch, apc->num_queues,
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
+			/* After the cleanup above: closing destroys the EQ pool
+			 * those queues' CQs were attached to.
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
+		/* No queues to rebuild; mana_open() will size the RX buffers
+		 * for this program. One refcnt is held by the caller already,
+		 * so don't take another.
+		 */
+		apc->bpf_prog = prog;
 	}
 
 	if (old_prog)
@@ -250,11 +257,6 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
index c858a58577dfb1774b2b9394c01e9000edbe8bf9..e54ad4db918ce3d662092a94ac13c41a4b958d6a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -909,7 +909,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 
 	err = mana_alloc_qset(scratch, mpc->num_queues, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
-			      &newq);
+			      mpc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset and ndev->mtu untouched */
 
@@ -3944,6 +3944,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
+	out->bpf_prog		= ctx->bpf_prog;
 	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
@@ -3966,6 +3967,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
+	ctx->bpf_prog		= qset->bpf_prog;
 	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
@@ -4028,7 +4030,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  */
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4040,11 +4043,12 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 	scratch->tx_queue_size	= tx_queue_size;
 	scratch->priv_flags	= priv_flags;
 
-	/* mana_get_rxbuf_cfg() reads this when sizing RX buffers, so the
-	 * new set is built for the requested MTU without disturbing the
-	 * running set.
+	/* mana_get_rxbuf_cfg() reads both of these when sizing RX buffers,
+	 * so the new set is built for the requested MTU / XDP program
+	 * without disturbing the running set.
 	 */
 	scratch->configured_mtu	= mtu;
+	scratch->bpf_prog	= bpf_prog;
 
 	err = mana_init_port_context(scratch);
 	if (err)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index f4818305bec83f8a60ce02baf280b0d4b9fcb51e..0daacee28001ed45a66ef00449b2c2acbf2859d4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -724,7 +724,7 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset untouched, nothing to undo */
 
@@ -819,7 +819,8 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, apc->configured_mtu, &newq);
+			      apc->priv_flags, apc->configured_mtu,
+			      apc->bpf_prog, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -918,7 +919,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 
 	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset and priv_flags untouched */
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index b9d79240dbc7cc0fb106336d68b6f0cf3a34f2bf..4fcd5e307a4805b81c5c82482fc65a4ba68eea89 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -589,7 +589,7 @@ struct mana_port_context {
 
 	/* Indirection Table for RX & TX. The values are queue indexes */
 	u32 *indir_table;
-	u32 indir_table_sz;
+	u32			indir_table_sz;
 
 	/* Indirection table containing RxObject Handles */
 	mana_handle_t *rxobj_table;
@@ -715,11 +715,12 @@ struct mana_qset {
 	unsigned int		tx_queue_size;
 	u32			priv_flags;
 
-	/* MTU the RX buffers of this set were sized for. It feeds
-	 * mana_get_rxbuf_cfg(), so it is part of the queue-set
+	/* MTU and XDP program the RX buffers of this set were sized for.
+	 * Both feed mana_get_rxbuf_cfg(), so they are part of the queue-set
 	 * configuration and must be swapped atomically with the queues.
 	 */
 	int			mtu;
+	struct bpf_prog		*bpf_prog;
 
 	/* Per-queue-set debugfs root ("EQs"). Owned by the qset: it is
 	 * recreated by mana_create_eq() for each new set and torn down
@@ -738,15 +739,16 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
-/* Pre-allocate + swap reconfiguration. Allocation and teardown run against a
- * scratch context, so the live port context is mutated only inside
- * mana_publish_qset() with TX disabled. Both sets share a port-owned EQ pool.
+/* Pre-allocate + swap reconfiguration path (prototype). Allocation and
+ * teardown run against a scratch context so the live port context is only
+ * mutated inside mana_publish_qset(), with TX disabled.
  */
 struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc);
 void mana_qset_scratch_free(struct mana_port_context *scratch);
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out);
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-- 
2.43.0

