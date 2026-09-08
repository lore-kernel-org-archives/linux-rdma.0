Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C773D1DED5C;
	Tue,  8 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838173; cv=none; b=nNfJizSVKnFbYGnVNLNBfpSTtpXsOe+4TlRu1VO9sU1Nnv3e+F7MT4dQKxqoB43R3gC5LOZJiiIFLqe61zuk5JXxvv5hkzAc0V0vqacMt61bon04vS4Mm0xgeZdGQIl79CW2ptqx+opQ+ivWUGyGEeA+CBpwJ/NigGiRPRoSztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838173; c=relaxed/simple;
	bh=gN9hN6Qpg52gVEDRkk92tV0TLUqXJtd8FHYjWtWOzpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omPd/IOzMd9+7Tqur6bYY/A6GEVmA/I4qg4eeb2usn3RcgsDnpE165oTiBwtLyb8HkfS/NPlnKWx5fjPYWza3JTXl8u4LVYSVgSYjJWxC5XJ+zIm7OsApqhIPkto3t6QFLcEimxASCCVtbTMdEzBuhuXo1xwjkxTd5+hoLQTAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 4F38F20B703B; Mon,  7 Sep 2026 20:28:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4F38F20B703B
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
Subject: [PATCH net-next v4 10/13] net: mana: release EQs left idle by a channel-count reduction
Date: Mon,  7 Sep 2026 20:28:40 -0700
Message-ID: <20260908032843.397667-11-longli@microsoft.com>
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

Release EQs above the live queue count after retiring queues are freed
or replacement allocation fails. All CQs using those EQs must be gone.
Return their vector allocations to the pool; IRQ registrations remain.

Store each EQ's debugfs dentry in apc->eqs[] rather than a stack copy so
shrinking can remove individual EQ directories.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Derive the live port from scratch->ndev inside mana_free_qset()
    instead of adding a redundant parameter and shadowing local.
  - State the CQ-lifetime requirement for shrinking and shorten comments.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 49 ++++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  1 -
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 98007bb3ef7caa974849c3f4998854f15c925321..fc96837d69a00f97c090474ca69bf42cb4805353 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1881,6 +1881,8 @@ void mana_destroy_eq(struct mana_port_context *apc)
 		msi = eq->eq.msix_index;
 		mana_gd_destroy_queue(gc, eq);
 		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+		apc->eqs[i].mana_eq_debugfs = NULL;
 	}
 
 	kfree(apc->eqs);
@@ -1891,15 +1893,16 @@ EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
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
@@ -2008,11 +2011,37 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
 
 	return 0;
 out:
-	/* Retain partial growth for reuse; the live set still needs this pool.
-	 */
 	return err;
 }
 
+/* All CQs referencing EQs at or above @keep must be destroyed first. */
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
@@ -4148,6 +4177,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
 		   num_queues, err);
 	return err;
@@ -4453,6 +4484,8 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	 */
 	netif_set_real_num_rx_queues(apc->ndev, apc->num_queues);
 
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	mana_qset_debugfs_publish(apc);
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 77dcbd01a1f3da692c341f17d8f2a8301c02bd6b..53a76ae42333f46e8791c3c493887ede5c6bb410 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -752,7 +752,6 @@ static int mana_set_channels(struct net_device *ndev,
 	mana_free_qset(scratch, &oldq);
 
 free_scratch:
-	/* Release unpublished queues before closing their shared EQ pool. */
 	mana_publish_close_if_needed(apc);
 	mana_qset_scratch_free(scratch);
 clear_flag:
-- 
2.43.0
