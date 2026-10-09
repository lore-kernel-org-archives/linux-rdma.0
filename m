Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84204E9C3E;
	Fri,  9 Oct 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556913; cv=none; b=u5QozOtY4nYGPXYlMMRkEkzKcSEgssJv7l0h6nxxcun6Bi8NADgOPQJ4rwPaiUxhtMBVJfwXhL90QRLnMkWJyx8OHSb4c2xXy/vqz+m91QMzq60CtizZhREmWH1YOxTQzqdHtm8GNexro1+b6jGY0gsKu5RG1B7hLssFjd7YvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556913; c=relaxed/simple;
	bh=GG06B7eO32+pBwku5xrT4fKRM2djPpIFo3oFxbLc87E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSN0ghbgY6KUcz9OKqtf71mSDWqoyOsHxVU5cBtkS4d8svPXjicveVSpQ9xdqAYXeJhhc32jsFo36WV2l/n1//cVNHY2cdFiBo00JYG2ehA73/sRHt2M0D0zXJjkATUqpDDQDcEQ90LNnClXlefJXEuzwK5Gq2YvS+O/TIsHHRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WMsJvMf7; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WMsJvMf7"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 12BE620B7171;
	Fri,  9 Oct 2026 07:41:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 12BE620B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556910;
	bh=HUiUSMo6wvYuERTFsF1XBVjBy04/mCR0mXoVpaj21K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMsJvMf7CV4KZ09+3D0nsnFgDx1XvZS0f/EAua2JA3/Ykb0/U1PtVo9+cbSdvS6xV
	 pEs+iBgWYfyLmwS8yj9TI5HA7newgxMlN+DEF1JpaiDrLjqPotA3UPFwYPc98baQhR
	 XTkZiBa3pXfsrQqVC4AKwpJvPtDHpkWFQ2H7ZhE0=
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
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 08/13] net: mana: swap queue sets in mana_xdp_set
Date: Fri,  9 Oct 2026 14:41:19 +0000
Message-ID: <3d43962ea65efad5e6bc8652f887b1b21dec4178.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
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
index 80950d5b62c5..0ad3a0fa6747 100644
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
index 4577a473ff42..51f9bfc64c6b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -952,9 +952,9 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
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
 
@@ -4039,6 +4039,7 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->tx_queue_size	= ctx->tx_queue_size;
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
+	out->bpf_prog		= ctx->bpf_prog;
 }
 
 /* Vport identity and port debugfs outlive queue sets. */
@@ -4056,6 +4057,7 @@ static void mana_qset_install(struct mana_port_context *ctx,
 	ctx->tx_queue_size	= qset->tx_queue_size;
 	ctx->priv_flags		= qset->priv_flags;
 	ctx->configured_mtu	= qset->mtu;
+	ctx->bpf_prog		= qset->bpf_prog;
 }
 
 /* Scratch starts without SQs/RQs and borrows the port's EQ pool. Never call
@@ -4096,7 +4098,8 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out)
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
 	int err;
@@ -4109,6 +4112,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	scratch->priv_flags	= priv_flags;
 
 	scratch->configured_mtu	= mtu;
+	scratch->bpf_prog	= bpf_prog;
 
 	err = mana_init_port_context(scratch);
 	if (err)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 2ad0fb4d5008..a438bc6097d6 100644
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
@@ -918,9 +919,9 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
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
index 3faad257e97e..5f9461bc16e9 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -707,6 +707,8 @@ struct mana_qset {
 	u32			priv_flags;
 
 	int			mtu;
+	struct bpf_prog		*bpf_prog;
+
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
@@ -729,7 +731,8 @@ static inline struct mana_stats_rx *mana_rxq_stats(struct mana_rxq *rxq)
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
-		    u32 priv_flags, int mtu, struct mana_qset *out);
+		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
+		    struct mana_qset *out);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
