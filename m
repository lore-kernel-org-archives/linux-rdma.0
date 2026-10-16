Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87A34D0A19;
	Fri, 16 Oct 2026 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165150; cv=none; b=CW4OZkL+TJ/YZo5m1jdj+CXyLHAfkZG+s0T0ImPG89E3pEI2Fou+S7nYUdJunA7NcdeDtU6FoYv4SnblM3iCVurNFYycJ4mmFqVMnkPhZT/YvF49ZVReShOOwJr9vrC1lKxtWthZQMH5d7T4h6f2xobPyWyBBbiKv5s3nNk4Iy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165150; c=relaxed/simple;
	bh=WTL6sTangNnpoPp83z6CnsvGwAcwsxa5INRAQ8wsYbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4gJKa2SHWejoOO/GleJzvQUnLA6WKAVrPBrI3zrCtb5B3EAun/q0nRPRqL214A7I+HC3IuSWmfCXg0/iuoTofrEO+tT6SQ8KaUc1krVt+Br90hooD8nZNJ4NZ3Ru1WmvFbThfGO3ZWl/3D8w6VqOkChlNCJQ/GgdW9jeUq5zko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gof7H20y; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gof7H20y"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1CA1E20B7167;
	Fri, 16 Oct 2026 08:39:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1CA1E20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165143;
	bh=RKgQy9aj1Yl2WviODOqln1kA22iVboOnVoSXD7c7550=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gof7H20yE3r/ULGV7oKOmm2QXa6ImRlWW+1TZN9UDWy0UG/XmjanU7T0KdWoFLfGc
	 IqoepB0yqzyjerbArXErhiZOXP0AR7GFewJ61ZtvLZlS1WpitP0vyybKTI16hyu7cG
	 D91+D/jPl3drCG3HBV4cD0rZE1wzupuK9aI30MaM=
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
Subject: [PATCH net-next v7 08/13] net: mana: swap queue sets in mana_xdp_set
Date: Fri, 16 Oct 2026 15:38:41 +0000
Message-ID: <c2e32fdbff549ac0d561716819d20ffad6236c5f.1791710735.git.weh@linux.microsoft.com>
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

Carry the XDP program with the queue set and install its per-queue
references before redirecting RSS. This keeps the RX buffer layout and
program together during publication and rollback.

Do not replace the live program during allocation. This also avoids the
pre-existing failed-preallocation stale-pointer bug; its standalone net
fix is linked below.

This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
RX buffers and page pools live. The port-owned EQ pool is shared,
not doubled. Device resource limits may reject this temporary peak;
allocation failure preserves the live queues and configuration.

Reserve RAW-QP admission under vport_mutex for the entire live
replacement, including unpublished queues, fail-close and scratch
cleanup. Preserve validation, no-op and down-port behavior.

Link: https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 75 +++++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c | 12 ++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 11 +--
 include/net/mana/mana.h                       |  5 +-
 4 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 687b9ce7d9a3..8eae57ca3aa8 100644
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
@@ -196,47 +198,59 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
+		/* Fail-close may release the Ethernet vport reference. */
+		mutex_lock(&apc->vport_mutex);
+		if (apc->channel_changing) {
+			mutex_unlock(&apc->vport_mutex);
+			return -EBUSY;
+		}
+		apc->channel_changing = true;
+		mutex_unlock(&apc->vport_mutex);
 
-		/* Pre-allocate buffers to prevent failure in mana_attach */
-		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
-		if (err) {
+		scratch = mana_qset_scratch_alloc(apc);
+		if (!scratch) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "XDP: Insufficient memory for tx/rx re-config");
-			apc->bpf_prog = old_prog;
-			return err;
+					   "XDP: Insufficient memory for re-config");
+			err = -ENOMEM;
+			goto clear_flag;
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
+			goto free_scratch;
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
+			goto free_scratch;
 		}
 
-		mana_chn_setxdp(apc, prog);
-		mana_pre_dealloc_rxbufs(apc);
+		mana_free_qset(scratch, &oldq);
+free_scratch:
+		mana_qset_scratch_free(scratch);
+clear_flag:
+		mutex_lock(&apc->vport_mutex);
+		apc->channel_changing = false;
+		mutex_unlock(&apc->vport_mutex);
+		if (err)
+			return err;
+	} else {
+		/* Use the caller's program reference; mana_open() installs it
+		 * on queues.
+		 */
+		apc->bpf_prog = prog;
 	}
 
 	if (old_prog)
@@ -249,11 +263,6 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
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
index c1ff4d9b8d45..9e952843de14 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -981,9 +981,9 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 		goto clear_flag;
 	}
 
-	err = mana_alloc_qset(mpc, scratch, mpc->num_queues,
-			      mpc->rx_queue_size, mpc->tx_queue_size,
-			      mpc->priv_flags, new_mtu, &newq);
+	err = mana_alloc_qset(mpc, scratch, mpc->num_queues, mpc->rx_queue_size,
+			      mpc->tx_queue_size, mpc->priv_flags, new_mtu,
+			      mpc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -4067,6 +4067,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
+	out->bpf_prog		= ctx->bpf_prog;
 }
 
 /* Vport identity and port debugfs outlive queue sets. */
@@ -4084,6 +4085,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
+	ctx->bpf_prog		= qset->bpf_prog;
 }
 
 /* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
@@ -4124,7 +4126,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4137,6 +4140,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	scratch->priv_flags	= priv_flags;
 
 	scratch->configured_mtu	= mtu;
+	scratch->bpf_prog	= bpf_prog;
 
 	err = mana_init_port_context(scratch);
 	if (err)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 43575aa3a168..96ddd739c024 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -739,7 +739,7 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
-			      apc->configured_mtu, &newq);
+			      apc->configured_mtu, apc->bpf_prog, &newq);
 	if (err)
 		goto free_scratch;
 
@@ -828,7 +828,8 @@ static int mana_set_ringparam(struct net_device *ndev,
 	}
 
 	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
-			      apc->priv_flags, apc->configured_mtu, &newq);
+			      apc->priv_flags, apc->configured_mtu,
+			      apc->bpf_prog, &newq);
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
@@ -917,9 +918,9 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
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
index 60c7df78316c..e64aa6ae7a4d 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -718,6 +718,8 @@ struct mana_qset {
 	u32			priv_flags;
 
 	int			mtu;
+	struct bpf_prog		*bpf_prog;
+
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -740,7 +742,8 @@ static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
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

