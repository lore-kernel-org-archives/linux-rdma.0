Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F47E3C65F4;
	Tue,  1 Sep 2026 01:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227135; cv=none; b=k3WEtpV8a2HSKlea/Pga55p2xWbw5UquKfNAOhftY+wFyM750hQRSkk24elJYGeZKxCi2b9HyvWY4EQtUdWYzJ2TGe26c96kwQDsymBryVJLtrCUXB53FJfNVl5osafJJZAFb3EXC4hp/oufc+xD7rJOFYLA2FZYsXJIwR68U9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227135; c=relaxed/simple;
	bh=14CzcSBVBpywzwK3WypPfAoKRTyHeJEMwp1CY4psw84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+F33ROSjaCiR1wv78yuRuFEPYe7XSenrpitm2Z5stGvgrd5MJiXJg9HL8AZYb7wnBbbBrOpt2a7OTDkg4/lvJg4DCJmzhtknhN38TPbGPBB3sbDOUIENOE5wK6e6mxHqBRZcTM6KFAHmRItTiwqkb5FB/AWba1rhdrJlQPlN5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 6EDE320B6F12; Mon, 31 Aug 2026 18:44:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6EDE320B6F12
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
Subject: [PATCH net-next v3 10/13] net: mana: release EQs left idle by a channel-count reduction
Date: Mon, 31 Aug 2026 18:44:39 -0700
Message-ID: <20260901014442.2945689-11-longli@microsoft.com>
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

The shared EQ pool only grows, so it sits at the high-water mark of every
channel count the port has ever used. After "ethtool -L ens1 combined 32"
then "combined 4" the port still holds 32 EQs while using four:

  # ls /sys/kernel/debug/mana/7870:00:00.0/vport0/EQs | wc -l
  32

The pre-swap path recreated every EQ per reconfiguration, so this is new.

Release the EQs above the live queue count once a retiring set has been
torn down. That is the only safe point: a CQ holds the gdma_queue pointer
of its parent EQ, so an EQ may only be destroyed once the set referencing
it is gone.

The interrupts stay listed in /proc/interrupts either way, since
mana_gd_setup_irqs() references every vector at probe. What a shrink
returns is the pool slot, so a later increase can take it again.

mana_create_eq_debugfs() stored the new dentry in a stack copy rather than
in apc->eqs[i], leaving that field NULL. Nothing read it back before, since
teardown removed the parent directory recursively. The shrink above removes
one EQ's directory, so it needs the dentry actually recorded.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 73 +++++++++++++++----
 .../ethernet/microsoft/mana/mana_ethtool.c    | 15 ++--
 include/net/mana/mana.h                       |  3 +-
 4 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 0981327c284413f8a0e93856939a4b3c0f632d80..547fc8c769cb4c4f440a80d19092cab86e19894b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -228,7 +228,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "XDP: Re-config failed at publish");
-			mana_free_qset(scratch, &newq);
+			mana_free_qset(apc, scratch, &newq);
 			/* After the cleanup above: closing destroys the EQ pool
 			 * those queues' CQs were attached to.
 			 */
@@ -237,7 +237,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 			return err;
 		}
 
-		mana_free_qset(scratch, &oldq);
+		mana_free_qset(apc, scratch, &oldq);
 		mana_qset_scratch_free(scratch);
 	} else {
 		/* No queues to rebuild; mana_open() will size the RX buffers
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 69e34fab8fe8ead53ecac5820ab4932c84af5371..2295769da0306888f0a0bd7bb7a6098e908289f1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -968,16 +968,13 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 
 	err = mana_publish_qset(mpc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(mpc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(mpc, scratch, &oldq);
 
 free_scratch:
-	/* After the caller-side cleanup above, so the EQ pool outlives the
-	 * CQs that reference it.
-	 */
 	mana_publish_close_if_needed(mpc);
 	mana_qset_scratch_free(scratch);
 	return err;
@@ -1938,6 +1935,9 @@ void mana_destroy_eq(struct mana_port_context *apc)
 		msi = eq->eq.msix_index;
 		mana_gd_destroy_queue(gc, eq);
 		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+		/* Freed with the parent by debugfs_remove_recursive() above. */
+		apc->eqs[i].mana_eq_debugfs = NULL;
 	}
 
 	kfree(apc->eqs);
@@ -1948,15 +1948,16 @@ EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
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
@@ -2084,6 +2085,37 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
 	return err;
 }
 
+/* Release EQs above @keep, returning the MSI-X vectors freed. Only safe once
+ * no set references them, i.e. after mana_free_qset(), or a live CQ would
+ * point at a destroyed EQ.
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
@@ -4319,6 +4351,13 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
 	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
 		   num_queues, err);
 	return err;
@@ -4649,7 +4688,8 @@ static void mana_qset_debugfs_publish(struct mana_port_context *apc)
 /* Tear down @qset, no longer installed on @apc, against @scratch so the live
  * context never points at queues being freed.
  */
-void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
+void mana_free_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, struct mana_qset *qset)
 {
 	struct bpf_prog *retiring_prog;
 	unsigned int retiring_queues;
@@ -4745,12 +4785,19 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
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
index 4d7e64b1d32d9eca5fc006e13941f72f2176a131..c7ddd26cada258cdbb2dc8410e6af14d2cedae1e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -762,16 +762,13 @@ static int mana_set_channels(struct net_device *ndev,
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(apc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
-	/* After the caller-side cleanup above, so the EQ pool outlives the
-	 * CQs that reference it.
-	 */
 	mana_publish_close_if_needed(apc);
 	mana_qset_scratch_free(scratch);
 clear_flag:
@@ -862,11 +859,11 @@ static int mana_set_ringparam(struct net_device *ndev,
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
@@ -956,11 +953,11 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 
 	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		mana_free_qset(scratch, &newq);
+		mana_free_qset(apc, scratch, &newq);
 		goto free_scratch;
 	}
 
-	mana_free_qset(scratch, &oldq);
+	mana_free_qset(apc, scratch, &oldq);
 
 free_scratch:
 	mana_publish_close_if_needed(apc);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9a43856760776fb2c23786bbdbb36fdbe5d2be81..140948b2b45d5afa91e37d72219bb89783a030d5 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -797,7 +797,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
-void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
+void mana_free_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, struct mana_qset *qset);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
 
-- 
2.43.0

