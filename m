Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8AC51616C;
	Fri, 16 Oct 2026 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165153; cv=none; b=H7LLFIi79xCLO6EfYCnsUMe/jVszX98uchhaUup6inhWR1hUsCBbi0GutSePCptQ4AL2M1KBqZ8Dpf4ytIoqCBiPnKfvZ6Jjd3prufIMJq0v9b660Pa2TF6Kh+13hD0zLjzAT60QqzwA2pRQWHprsue3REs4wcgtvH8WrbdIrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165153; c=relaxed/simple;
	bh=Ba1U92WOKYNVOynqVQrAtMyF+DNXEoxSqzur0tsNthE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoRKr0DuipHrLTbN99223yJoFYt6G2jlRxNXTqruKyHgKRbFS1upY0khH26JOrSTouj7Mi2r1v9lswt0zV0xOFWbcyUXOhJcGiznDzYGbwgJS3XZFm3sqWmskSkjYetGAyeQ0fRP2I3b0WcQrJ68FViJw2mV0Wq0JDrb17RDL5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ffjY67kX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ffjY67kX"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 94AD320B7175;
	Fri, 16 Oct 2026 08:39:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94AD320B7175
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165146;
	bh=o1ctc1rUYfa8uAnZWEdjOH9+D4CjGrx/rGl9kLtKm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffjY67kXbqYPy1RJRw6/3WvjyMHPmapw9g5H5PKchWWGYsOlIAQUlLAzOTGhWC5ES
	 ClcbP3b5KJcPgokBRaqeAr/M+H34ksUu/IzRvry/yGuYayrkZK7eAjYEL07lBOL4mt
	 FydaFol7Krwv6v2prdVB6x//pABWsGOLcGjP+YK0=
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
Subject: [PATCH net-next v7 10/13] net: mana: release EQs left idle by a channel-count reduction
Date: Fri, 16 Oct 2026 15:38:43 +0000
Message-ID: <a237256aa7aeb9441014005d3e07c340c60d1878.1791710735.git.weh@linux.microsoft.com>
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

Release EQs above the live queue count after retiring queues are freed
or replacement allocation fails. All CQs using those EQs must be gone.
Return their vector allocations to the pool; IRQ registrations remain.

Store each EQ's debugfs dentry in apc->eqs[] rather than a stack copy so
shrinking can remove individual EQ directories.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 49 ++++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  1 -
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 80f16c96f16c..2aa18cb10d90 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1936,6 +1936,8 @@ void mana_destroy_eq(struct mana_port_context *apc)
 		msi = eq->eq.msix_index;
 		mana_gd_destroy_queue(gc, eq);
 		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+		apc->eqs[i].mana_eq_debugfs = NULL;
 	}
 
 	kfree(apc->eqs);
@@ -1946,15 +1948,16 @@ EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
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
@@ -2063,11 +2066,37 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
 
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
@@ -4176,6 +4205,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
 		   num_queues, err);
 	return err;
@@ -4536,6 +4567,8 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	 */
 	netif_set_real_num_rx_queues(apc->ndev, apc->num_queues);
 
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	mana_qset_debugfs_publish(apc);
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 96ddd739c024..d26fefbb72c3 100644
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

