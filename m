Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87294EBAD1;
	Fri,  9 Oct 2026 14:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556916; cv=none; b=lo08ebAXEW4b+idEtuTc/1zvrbSzhvtCihdE+aSXhaYGHMGec10FqcQIEXYdvQvq5x+BhBMS+Hb07h9robintVF3UtHXbD3jAburH1wpab2y6/+GuZWIZACzrOQZmexr0o2kXrbZ/C3kE6qJLssmjBtspUv/zprdgmSRUFf2+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556916; c=relaxed/simple;
	bh=oOAR9uM6jMAxb3MDVr/OypcqUWtATGYD1cP1X3m7jvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2PF/JzEg31Rdh9r0uXQZesokgoYRFev+nvmJ8hzkJ2F072KfKnxmX1f5rCh47kNAftGyKvm3PeGphNAawEYY5yOL4m3cm1XInmhtxZOQLkdvK6k6rXfMlyzMlNkZWxLkc+urOpHKwbf/alLA8UqZZZljeD71XfWWeau1EEerik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XklSg7LF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XklSg7LF"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4D3EC20B7172;
	Fri,  9 Oct 2026 07:41:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D3EC20B7172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556913;
	bh=y3kjZQnQX1BLL963AQ8zr3vaaYn7mP9UciD1t9exCeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XklSg7LFl3uTwsAful9otzflBfCF7GRUMdWEeDmtWkHo6jHKpi1k6jE2zS8o5Gm7J
	 ASZLRAOfhEkCOwQT0H15128HYIxVrnUE1qR1+3niA7I6CVEuTqw52WWH0/Vhfzcdiz
	 aIzA0G80AWbAqFWdkgdSTuAmmYUXSp8gcPJQ1Mco=
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
Subject: [PATCH net-next v6 10/13] net: mana: release EQs left idle by a channel-count reduction
Date: Fri,  9 Oct 2026 14:41:21 +0000
Message-ID: <6e4516ff65217677f0179ee4921752c3f86379ee.1790795005.git.weh@linux.microsoft.com>
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
index 9297ce15efce..86a09828b5f4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1910,6 +1910,8 @@ void mana_destroy_eq(struct mana_port_context *apc)
 		msi = eq->eq.msix_index;
 		mana_gd_destroy_queue(gc, eq);
 		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
+		apc->eqs[i].eq = NULL;
+		apc->eqs[i].mana_eq_debugfs = NULL;
 	}
 
 	kfree(apc->eqs);
@@ -1920,15 +1922,16 @@ EXPORT_SYMBOL_NS(mana_destroy_eq, "NET_MANA");
 
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
@@ -2037,11 +2040,37 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
 
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
@@ -4151,6 +4180,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	kfree(scratch->rxqs);
 	scratch->rxqs = NULL;
 out_err:
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
 		   num_queues, err);
 	return err;
@@ -4511,6 +4542,8 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	 */
 	netif_set_real_num_rx_queues(apc->ndev, apc->num_queues);
 
+	mana_shrink_eqs(apc, apc->num_queues);
+
 	mana_qset_debugfs_publish(apc);
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index a438bc6097d6..611521d2d6d1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -752,7 +752,6 @@ static int mana_set_channels(struct net_device *ndev,
 	mana_free_qset(scratch, &oldq);
 
 free_scratch:
-	/* Release unpublished queues before closing their shared EQ pool. */
 	mana_publish_close_if_needed(apc);
 	mana_qset_scratch_free(scratch);
 clear_flag:
