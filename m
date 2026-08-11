Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195433F7865;
	Tue, 11 Aug 2026 06:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430142; cv=none; b=l3pIdFnb42mpzESACle46r7jD7qQ+rH1Sx2P/ftVXyfUrMfiYMxs8NW49eOB39P6FsF+XAqKxS6VJKMKLGJ6mTbRD/rQWWKd9SCX2Is7t0zKrES5CmFjYc6od3dWDmBBHz8zNwUhPKs60+/VOFXk7EZ2PTC34ffdZouLcNvLYnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430142; c=relaxed/simple;
	bh=kvf04ChwxMv9vk2gWng2oOBCj4xoPh8t/R5pQ91rA8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4eeJ0xqeGV+zeyM39nQJBrnvIUi/UdW0aaPs03B0UfNhGfVNv5BNAPSxPiioTGYYVeQpQ3s78Hrdrs/FFpq2x7FsMOnblDpmHuz94G0yVmH7UecfGmem7QQBE3+EC2OzoMmmZX5rQiUytPqi85SCpDFxqAmBAbFj00vgwYFRig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 40AE420B7136; Mon, 10 Aug 2026 23:35:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 40AE420B7136
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
Date: Mon, 10 Aug 2026 23:35:03 -0700
Message-ID: <20260811063506.2428213-7-longli@microsoft.com>
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

Attaching or detaching an XDP program changes the RX buffer layout -
full pages with headroom rather than page fragments, see
mana_get_rxbuf_cfg() - so it rebuilds the queues. Convert
mana_xdp_set() to the pre-allocate and swap helpers, completing the
removal of detach/attach from the reconfiguration paths.

struct mana_qset gains bpf_prog, so the program the queues were built
for is swapped atomically with them and restored by the rollback path.

Refcounting is handled by the swap helpers. mana_publish_qset() already
re-attaches apc->bpf_prog to the new RX queues, which are created with
bpf_prog == NULL; installing qset->bpf_prog first means that same call
now attaches the new program. mana_free_qset() drops the old set's
per-queue references. The caller's reference is still consumed by the
port context and the old one released once, as before.

mana_pre_alloc_rxbufs() is no longer needed here. The TX timeout reset
handler is now its only caller.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 75 +++++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c | 15 ++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  7 +-
 include/net/mana/mana.h                       | 16 ++--
 4 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index e16ce2a0715839594a5837288c1d4c1de412e7fb..1a6a490a84f2e5b4c9895645ff6f40beb55f497c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -175,10 +175,24 @@ void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog)
 			bpf_prog_put(old_prog);
 }
 
+/* mana_xdp_set - attach or detach an XDP program
+ *
+ * Attaching or detaching XDP changes the RX buffer layout (full pages with
+ * headroom vs. page fragments), so the RX queues must be rebuilt. Uses the
+ * pre-allocate + swap path: the new set is built for @prog while the
+ * current one keeps serving traffic. On allocation failure nothing changes
+ * and the error is returned to the caller.
+ *
+ * mana_publish_qset() installs qset->bpf_prog onto apc and re-attaches it
+ * to the new RX queues, and mana_free_qset() drops the old set's per-queue
+ * references, so refcounting is handled by the swap helpers.
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
@@ -198,46 +212,46 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
@@ -250,11 +264,6 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
index 4c79d6e82d9a93786ea877fbcef2b3f9d4093a6c..e554a776e8a941f80831047610066eed115c02b9 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -919,7 +919,7 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 
 	err = mana_alloc_qset(scratch, mpc->num_queues, mpc->rx_queue_size,
 			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
-			      &newq);
+			      mpc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset and ndev->mtu untouched */
 
@@ -3986,6 +3986,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
+	out->bpf_prog		= ctx->bpf_prog;
 	out->mana_eqs_debugfs	= ctx->mana_eqs_debugfs;
 }
 
@@ -4008,6 +4009,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
+	ctx->bpf_prog		= qset->bpf_prog;
 	ctx->mana_eqs_debugfs	= qset->mana_eqs_debugfs;
 }
 
@@ -4072,6 +4074,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * @tx_queue_size: new TX ring size
  * @priv_flags:	   new priv-flag word (affects full-page RX)
  * @mtu:	   MTU the new set is sized for
+ * @bpf_prog:	   XDP program the new set is sized for, may be NULL
  * @out:	   output qset, populated on success
  *
  * The live port context is not referenced at all, so the currently
@@ -4080,7 +4083,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  */
 int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4092,11 +4096,12 @@ int mana_alloc_qset(struct mana_port_context *scratch, unsigned int num_queues,
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
index 2a6325256fad3edf1aafbc72f0cd5dc18d61384e..2cadd0f0d74e358c1b670dd6980603e0358918eb 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -738,7 +738,7 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_alloc_qset(scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset untouched, nothing to undo */
 
@@ -840,7 +840,8 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, apc->configured_mtu, &newq);
+			      apc->priv_flags, apc->configured_mtu,
+			      apc->bpf_prog, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -942,7 +943,7 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 
 	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
 			      apc->tx_queue_size, priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch; /* current qset and priv_flags untouched */
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 2fc75e6cd41a63878788182cd099379c8c698b33..bc9808f826f83df26c7af98daa181d91b7d2661d 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -590,7 +590,7 @@ struct mana_port_context {
 
 	/* Indirection Table for RX & TX. The values are queue indexes */
 	u32 *indir_table;
-	u32 indir_table_sz;
+	u32			indir_table_sz;
 
 	/* Indirection table containing RxObject Handles */
 	mana_handle_t *rxobj_table;
@@ -720,11 +720,12 @@ struct mana_qset {
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
@@ -743,15 +744,16 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
-/* Pre-allocate + swap reconfiguration path. Allocation and teardown run
- * against a scratch context so the live port context is never made to
- * point at queues that are still being built or freed.
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

