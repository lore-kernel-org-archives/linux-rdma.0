Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A9D3D4112;
	Tue,  1 Sep 2026 01:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227138; cv=none; b=Ay/j3bkUmtA4AjLgLeGmxsAnZjhkjX9lb5XnLxTZZWWXjzsuoxv/NzARhSep42TNxa9QRQtXuFurZiFNXuC42SlrV4eLtK6FBzYl3u435K1kmgIiCBWq0Iz/lK3wEWuyvAcMVtvuRs7abY3a/+yyjRknL4aGdxyilTMKs3HDKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227138; c=relaxed/simple;
	bh=SQbmJ2Q8J0wU2RW6D0dpVNHziFLixf/b5qoRhJ2Nmbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqQ2MmNjeau5tPPl8PeKYiNIQnxX4dqyf+TVOmD33Sx6tVWYe1yyP8G0xgpqsuLg/AXrnpNie5zhX8cF4H3fI6d6/uCCzpg3DhK2adCCaV80+ZdgbJg0FmrMhCWCYSnapxhwYV2A9tDxL/e9l2CzJeQEpoqMuynEzi7M4qxhGtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A0D2020B6F0C; Mon, 31 Aug 2026 18:44:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A0D2020B6F0C
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
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 12/13] net: mana: keep the surviving queues when the channel count is reduced
Date: Mon, 31 Aug 2026 18:44:41 -0700
Message-ID: <20260901014442.2945689-13-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901014442.2945689-1-longli@microsoft.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A channel-count reduction rebuilds every queue it keeps, even though none
of their properties change. Shrinking 16 channels to 8 creates 8 TX and 8
RX queues and then destroys all 16 of each:

  set_channels 16 -> 8   created SQ=8  RQ=8  | destroyed SQ=16 RQ=16

A queue is derived from the ring sizes, the MTU/priv-flag/XDP buffer
layout and its EQ, none of which depend on the count, and queue i is
bound to EQ i at any count. Carry the survivors over and retire only the
tail: a reduction allocates two pointer arrays and a steering table
instead of a full queue set, the peak stays at one set rather than two,
and the queues that stay keep their page pools, posted RX buffers and
NAPI state.

A ring resize, MTU change, priv-flag toggle or XDP attach changes a
property of every queue, so those still rebuild.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 130 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  42 +++++-
 include/net/mana/mana.h                       |   4 +
 3 files changed, 171 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6769faada11bcd898d3991d0c286578a736eba12..ae7c664bf76ef2740ccbf73315931b4aca7bd43f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4327,7 +4327,135 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 	kvfree(scratch);
 }
 
-/* Build a queue set in @scratch, sized and configured from the arguments. The
+/* Carve the live set into a kept prefix [0, @new_count) in @out_new and a
+ * tail to retire in @out_tail. @apc is untouched, on failure too.
+ *
+ * Queue i is built from the ring sizes and the buffer layout and keeps EQ i
+ * at any count, so a reduction carries the survivors over and destroys only
+ * the tail. Allocates two pointer arrays and a steering table, nothing else:
+ * the queues that stay keep their page pools, posted buffers and NAPI.
+ */
+int mana_split_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int new_count,
+		    struct mana_qset *out_new, struct mana_qset *out_tail)
+{
+	unsigned int old_count = apc->num_queues;
+	struct mana_tx_qp **new_tx, **tail_tx;
+	struct mana_rxq **new_rx, **tail_rx;
+	unsigned int tail_count;
+	bool indir_lost;
+	unsigned int i;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(new_count == 0 || new_count >= old_count))
+		return -EINVAL;
+	if (WARN_ON(!apc->tx_qp || !apc->rxqs))
+		return -EINVAL;
+
+	tail_count = old_count - new_count;
+
+	/* Build the smaller set's steering table separately: mana_config_rss()
+	 * would otherwise index the shorter rxqs[] with entries still referring
+	 * to retired queues.
+	 */
+	scratch->num_queues = new_count;
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		return err;
+
+	if (mana_rss_table_keep(apc, new_count, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
+
+	new_tx = kzalloc_objs(struct mana_tx_qp *, new_count);
+	new_rx = kzalloc_objs(struct mana_rxq *, new_count);
+	tail_tx = kzalloc_objs(struct mana_tx_qp *, tail_count);
+	tail_rx = kzalloc_objs(struct mana_rxq *, tail_count);
+	if (!new_tx || !new_rx || !tail_tx || !tail_rx) {
+		err = -ENOMEM;
+		goto free_arrays;
+	}
+
+	for (i = 0; i < new_count; i++) {
+		new_tx[i] = apc->tx_qp[i];
+		new_rx[i] = apc->rxqs[i];
+	}
+	for (i = 0; i < tail_count; i++) {
+		tail_tx[i] = apc->tx_qp[new_count + i];
+		tail_rx[i] = apc->rxqs[new_count + i];
+	}
+
+	/* The kept prefix, with the new steering table. */
+	out_new->tx_qp		= new_tx;
+	out_new->rxqs		= new_rx;
+	out_new->indir_table	= scratch->indir_table;
+	out_new->indir_table_sz	= scratch->indir_table_sz;
+	out_new->rxobj_table	= scratch->rxobj_table;
+	out_new->default_rxobj	= apc->rxqs[0]->rxobj;
+	out_new->num_queues	= new_count;
+	out_new->rx_queue_size	= apc->rx_queue_size;
+	out_new->tx_queue_size	= apc->tx_queue_size;
+	out_new->priv_flags	= apc->priv_flags;
+	out_new->mtu		= apc->configured_mtu;
+	out_new->bpf_prog	= apc->bpf_prog;
+	out_new->rxfh_indir_lost = indir_lost;
+
+	/* Ownership of the table moved to @out_new. */
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+
+	/* The tail. It owns no steering table; bpf_prog is carried so that
+	 * retiring it drops exactly the tail's per-queue program references
+	 * and leaves the kept ones alone.
+	 */
+	memset(out_tail, 0, sizeof(*out_tail));
+	out_tail->tx_qp		= tail_tx;
+	out_tail->rxqs		= tail_rx;
+	out_tail->default_rxobj	= INVALID_MANA_HANDLE;
+	out_tail->num_queues	= tail_count;
+	out_tail->rx_queue_size	= apc->rx_queue_size;
+	out_tail->tx_queue_size	= apc->tx_queue_size;
+	out_tail->priv_flags	= apc->priv_flags;
+	out_tail->mtu		= apc->configured_mtu;
+	out_tail->bpf_prog	= apc->bpf_prog;
+
+	return 0;
+
+free_arrays:
+	kfree(new_tx);
+	kfree(new_rx);
+	kfree(tail_tx);
+	kfree(tail_rx);
+	mana_cleanup_indir_table(scratch);
+	return err;
+}
+
+/**
+ * mana_discard_split - drop the containers built by mana_split_qset()
+ * @newq:  set that was never published
+ * @tailq: matching tail
+ *
+ * Frees the pointer arrays and the steering table only: the queues they refer
+ * to are still owned by the live port context.
+ */
+void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
+{
+	kfree(newq->tx_qp);
+	kfree(newq->rxqs);
+	kfree(newq->indir_table);
+	kfree(newq->rxobj_table);
+	kfree(tailq->tx_qp);
+	kfree(tailq->rxqs);
+	memset(newq, 0, sizeof(*newq));
+	memset(tailq, 0, sizeof(*tailq));
+}
+
+/* Rebuild the queues at the current count in @scratch, for callers changing a
+ * per-queue property; a reduction goes through mana_split_qset() instead. The
  * installed set keeps serving traffic meanwhile. On error nothing is left
  * allocated.
  */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index c7ddd26cada258cdbb2dc8410e6af14d2cedae1e..b5587764333f1f357df6b86795c92ef2985f9ed3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -681,10 +681,11 @@ static int mana_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-/* Build the new queue set while the current one keeps serving traffic, then
- * swap. On failure the existing queues keep running and the requested value is
- * never replaced by a fallback. The vport is never torn down, so RDMA cannot
- * take it mid-reconfiguration.
+/* A reduction leaves every surviving queue configured as it was, so it retires
+ * the tail rather than rebuilding; an increase still builds a new set. On
+ * failure the existing queues keep running and the requested value is never
+ * replaced by a fallback. The vport is never torn down, so RDMA cannot take it
+ * mid-reconfiguration.
  */
 static int mana_set_channels(struct net_device *ndev,
 			     struct ethtool_channels *channels)
@@ -754,6 +755,39 @@ static int mana_set_channels(struct net_device *ndev,
 		goto clear_flag;
 	}
 
+	/* A reduction keeps its queues configured identically, so carry them
+	 * over and retire only the tail: no DMA ring, no hardware WQ object,
+	 * and no old+new peak.
+	 */
+	if (new_count < apc->num_queues) {
+		struct mana_qset tailq;
+
+		err = mana_split_qset(apc, scratch, new_count, &newq, &tailq);
+		if (err)
+			goto free_scratch; /* current qset untouched */
+
+		err = mana_publish_qset(apc, &newq, &oldq);
+		if (err) {
+			/* The old set is live again; drop only the containers
+			 * built above, never the queues they point at.
+			 */
+			mana_discard_split(&newq, &tailq);
+			goto free_scratch;
+		}
+
+		/* @oldq holds the original arrays and steering table. Every
+		 * queue they referenced is now owned by either the published
+		 * set or the tail, so only the containers are freed here.
+		 */
+		kfree(oldq.tx_qp);
+		kfree(oldq.rxqs);
+		kfree(oldq.indir_table);
+		kfree(oldq.rxobj_table);
+
+		mana_free_qset(apc, scratch, &tailq);
+		goto free_scratch;
+	}
+
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9d08257bc1fc47e7accc30a2ef2ae3db7acc7b9d..9fd555164df0de9ecd00fb840891025d566c0143 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -800,6 +800,10 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
+int mana_split_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int new_count,
+		    struct mana_qset *out_new, struct mana_qset *out_tail);
+void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-- 
2.43.0

