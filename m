Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DD23F6C3E;
	Tue, 11 Aug 2026 06:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430168; cv=none; b=OI5iubx1Q+2hy7qj9oOXB20jcTaWGWx+vCuGt7mIQdiob6OcgclzUMYkI/1I9170YZGZwfJpWxX8g/uxVlCNLYmaP5w3SdceYiS93SkfU++WPFgKSjMTaW5jitDrK1aDIC5aWNmIbqLstlb4BanPDar8g5EbgQ4iTFsI4rTvov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430168; c=relaxed/simple;
	bh=AJ8KKXkV4l003r10RHbyFmC3pZIZpRYxs8/gGbxiM7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovErRlOAcwLcRRLux1VpNtzc3pG9mkcQBg5AlK104CqP1jRBKaciTYrDOf3T2fSSBV+iukNuE4iD1uNG176R5OizMTBR3H8sw+jO9zBfjakOv7DAGyaKxFf3y8kgidUob/e7yKJCtMnGsC6LJEekvKO6jV9uSC3iaD03w6re/7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id E1A6120B7168; Mon, 10 Aug 2026 23:35:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E1A6120B7168
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
Subject: [PATCH net-next v2 10/13] net: mana: release EQs left idle by a channel-count reduction
Date: Mon, 10 Aug 2026 23:35:27 -0700
Message-ID: <20260811063530.2428424-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063530.2428424-1-longli@microsoft.com>
References: <20260811063530.2428424-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The shared EQ pool introduced by the previous patch is grow-only, so it
sits at the high-water mark of every channel count the port has ever
used. After "ethtool -L ens1 combined 32" followed by "combined 4" the
port keeps 32 EQs and 32 MSI-X vectors while using four:

  # ethtool -L ens1 combined 4
  # grep -c mana /proc/interrupts
  33

Before the queue-set swap this did not happen: mana_detach() destroyed
every EQ and mana_attach() created exactly num_queues of them, so the
interrupt count tracked the configured channel count.

Add mana_shrink_eqs() and call it from mana_free_qset(), which is the
one place where a queue set has just been torn down and the live count
is already known. Both callers benefit: on success the retiring set is
the old one and the pool shrinks to the new count, and if
mana_publish_qset() failed and rolled back, the new set is discarded and
the pool shrinks back to the restored count.

Shrinking is only safe there. A CQ holds the gdma_queue pointer of its
parent EQ, so an EQ may only be destroyed once the set referencing it is
gone.

mana_free_qset() therefore takes the live port context as well, since
the pool belongs to it rather than to the scratch context.

While here, fix mana_create_eq_debugfs(), which stored the new dentry in
a stack copy of the mana_eq rather than in apc->eqs[i]. Nothing noticed
because mana_destroy_eq() removes the whole "EQs" directory recursively,
but per-EQ removal is needed to shrink without leaving stale nodes
behind, which would then collide when the pool grows again.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 79 ++++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 12 +--
 include/net/mana/mana.h                       |  3 +-
 4 files changed, 78 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1bae4174e268f7f53b0880c5d1098cd0ef687f25..7031ecb4da2e0fd5b83aeb07aeb8d7ae56e16d65 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -235,7 +235,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "XDP: Re-config failed at publish");
-			mana_free_qset(scratch, &newq);
+			mana_free_qset(apc, scratch, &newq);
 			/* After the cleanup above: closing destroys the EQ pool
 			 * those queues' CQs were attached to.
 			 */
@@ -244,7 +244,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return err;
 		}
 
-		mana_free_qset(scratch, &oldq);
+		mana_free_qset(apc, scratch, &oldq);
 		mana_qset_scratch_free(scratch);
 	} else {
 		/* No queues to rebuild; mana_open() will size the RX buffers
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 71cbdebc5f3f7126495b2b11f0c673955fe0f8df..0d87440fbfbee7ac5729945d101eaa0c37745fbe 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -931,11 +931,11 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 
 	err = mana_publish_qset(mpc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(mpc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(mpc, scratch, &oldq);
 
 free_scratch:
 	/* After the caller-side cleanup above, so the EQ pool outlives the
@@ -1847,6 +1847,9 @@ void mana_destroy_eq(struct mana_port_context *apc)
 		msi = eq->eq.msix_index;
 		mana_gd_destroy_queue(gc, eq);
 		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+		/* Freed with the parent by debugfs_remove_recursive() above. */
+		apc->eqs[i].mana_eq_debugfs = NULL;
 	}
 
 	kfree(apc->eqs);
@@ -1857,15 +1860,16 @@ EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
 static void mana_create_eq_debugfs(struct mana_port_context *apc, int i)
 {
-	struct mana_eq eq = apc->eqs[i];
+	struct mana_eq *eq = &apc->eqs[i];
 	char eqnum[32];
 
 	sprintf(eqnum, "eq%d", i);
-	eq.mana_eq_debugfs = debugfs_create_dir(eqnum, apc->mana_eqs_debugfs);
-	debugfs_create_u32("head", 0400, eq.mana_eq_debugfs, &eq.eq->head);
-	debugfs_create_u32("tail", 0400, eq.mana_eq_debugfs, &eq.eq->tail);
-	debugfs_create_u32("irq", 0400, eq.mana_eq_debugfs, &eq.eq->eq.irq);
-	debugfs_create_file("eq_dump", 0400, eq.mana_eq_debugfs, eq.eq, &mana_dbg_q_fops);
+	eq->mana_eq_debugfs = debugfs_create_dir(eqnum, apc->mana_eqs_debugfs);
+	debugfs_create_u32("head", 0400, eq->mana_eq_debugfs, &eq->eq->head);
+	debugfs_create_u32("tail", 0400, eq->mana_eq_debugfs, &eq->eq->tail);
+	debugfs_create_u32("irq", 0400, eq->mana_eq_debugfs, &eq->eq->eq.irq);
+	debugfs_create_file("eq_dump", 0400, eq->mana_eq_debugfs, eq->eq,
+			    &mana_dbg_q_fops);
 }
 
 int mana_create_eq(struct mana_port_context *apc)
@@ -1999,6 +2003,43 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
 	return err;
 }
 
+/**
+ * mana_shrink_eqs - release EQs above @keep
+ * @apc:  port context
+ * @keep: number of EQs the live queue set still uses
+ *
+ * Returns the MSI-X vectors of the EQs a shrink left behind. Must only be
+ * called once no queue set references them, i.e. after the retiring set has
+ * been torn down by mana_free_qset(), otherwise a live CQ would be left
+ * pointing at a destroyed EQ.
+ */
+static void mana_shrink_eqs(struct mana_port_context *apc, unsigned int keep)
+{
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
+	struct gdma_queue *eq;
+	unsigned int msi;
+	unsigned int i;
+
+	if (!apc->eqs || keep >= apc->num_eqs)
+		return;
+
+	for (i = keep; i < apc->num_eqs; i++) {
+		eq = apc->eqs[i].eq;
+		if (!eq)
+			continue;
+
+		debugfs_remove_recursive(apc->eqs[i].mana_eq_debugfs);
+		apc->eqs[i].mana_eq_debugfs = NULL;
+
+		msi = eq->eq.msix_index;
+		mana_gd_destroy_queue(gc, eq);
+		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+	}
+
+	apc->num_eqs = keep;
+}
+
 static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
 {
 	struct mana_fence_rq_resp resp = {};
@@ -4224,7 +4265,7 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
  * Every queue is built in @scratch, so the queue set currently installed on
  * @apc keeps serving traffic throughout. @apc is touched only to grow the
  * shared EQ pool, which both sets reference while they are both live. On
- * error no queue is left allocated.
+ * error no queue is left allocated, and any EQ this call added is released.
  */
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
@@ -4294,6 +4335,13 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
+	/* Give back any EQ this attempt added to the shared pool rather than
+	 * holding its MSI-X vectors until some later teardown: the live set
+	 * still needs only apc->num_queues of them. Safe here because this
+	 * set's CQs have already been destroyed above.
+	 */
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	netdev_err(ndev, "mana_alloc_qset(num_queues=%u) failed: %d\n",
 		   num_queues, err);
 	return err;
@@ -4655,13 +4703,15 @@ static void mana_qset_debugfs_publish(struct mana_port_context *apc)
 
 /**
  * mana_free_qset - tear down all queues in @qset
+ * @apc:     live port context (owns the shared EQ pool)
  * @scratch: scratch context from mana_qset_scratch_alloc()
  * @qset:    queue set to destroy (must no longer be installed on the live apc)
  *
  * Runs the existing destroyers against @scratch so the live port context
  * is never made to point at queues that are being freed.
  */
-void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
+void mana_free_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, struct mana_qset *qset)
 {
 	struct bpf_prog *retiring_prog;
 	unsigned int retiring_queues;
@@ -4776,12 +4826,19 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	memset(qset, 0, sizeof(*qset));
 
+	/* This set is gone, so any EQ above the live queue count is now
+	 * unreferenced. Release those vectors instead of holding them at the
+	 * high-water mark. Safe here and only here: the retiring set's CQs
+	 * have just been destroyed.
+	 */
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	/* Queues built through a scratch context carry no debugfs nodes,
 	 * because both sets are alive during the swap and would collide on
 	 * the same names. The retiring set's nodes are gone now, so the
 	 * published queues can finally take those names.
 	 */
-	mana_qset_debugfs_publish(netdev_priv(scratch->ndev));
+	mana_qset_debugfs_publish(apc);
 }
 
 /* --- end of pre-allocate + swap reconfiguration path ---------------------- */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 03fe657334c49a69ebe9c2677b2b8268321a162d..a4d62ea8aec8f4aaa521af2c4fa4af6d928e9b4e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -744,11 +744,11 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(apc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
 	/* After the caller-side cleanup above, so the EQ pool outlives the
@@ -852,11 +852,11 @@ static int mana_set_ringparam(struct net_device *ndev,
 	if (err) {
 		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
 				   err);
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(apc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
 	/* After the caller-side cleanup above, so the EQ pool outlives the
@@ -949,11 +949,11 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(apc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
 	/* After the caller-side cleanup above, so the EQ pool outlives the
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index d09bf2c7cec0be06c4190caab1f0723a5c4956d6..52f1c8f9c2b968ad14c90849fd3286b2c046d1d3 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -776,7 +776,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+void mana_free_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, struct mana_qset *qset);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
-- 
2.43.0

