Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797F840B366;
	Tue, 11 Aug 2026 06:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430180; cv=none; b=GbxLLwNJkHTklxMfdPPm7HsPZ6XLPvDfwMlkTcGqKaS4RvxpJXkkwpoG0rpQ4RdHJgIdxyh9o5j31xyuhXVBWDF+U8JQKOv4swRLWLUbvVADUJKXp4wvcKXwdvhAzFwqs5//adoeda/UqJPmm8WOdzJqlFZNAhKbJmoetaWRqbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430180; c=relaxed/simple;
	bh=cDHFd6iArFukhrbVHMCAYF/CLhCedN8SOdtFJKYFTXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJYVazGowWXDIgO+ZIbhgtR8RFw7+QgAgjC+UrM3u2Cwy/PhBb7lu12ON4WIwH7rQDK9aCT1pBHIc3vxXbmY/srylou48FlYURYk/bVLQ9wtzFrALWZzBn/1g+dnazALEKUtJBecX5wNl2cTJK0evXxAzhkmNT9rgHaLsrkTBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 7D28920B703B; Mon, 10 Aug 2026 23:35:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D28920B703B
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
Subject: [PATCH net-next v2 12/13] net: mana: keep the surviving queues when the channel count is reduced
Date: Mon, 10 Aug 2026 23:35:29 -0700
Message-ID: <20260811063530.2428424-4-longli@microsoft.com>
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

A channel-count reduction currently builds a whole new queue set and then
destroys the old one, even though the queues being kept do not change.
Shrinking 32 channels to 8 creates 8 TX and 8 RX queues, each with its own
DMA rings and hardware WQ object, and then destroys all 32 of each:

  set_channels 16 -> 8   created SQ=8  RQ=8  | destroyed SQ=16 RQ=16

None of that work is necessary. mana_create_txq() derives a TX queue only
from apc->tx_queue_size and apc->eqs[i], and mana_create_rxq() derives an
RX queue only from apc->rx_queue_size and the MTU/priv-flag/XDP buffer
layout. Neither depends on how many queues there are, and queue i is bound
to EQ i at any count, so queue i is configured identically before and
after. This is specific to the channel count: a ring resize, MTU change,
priv-flag toggle or XDP attach changes a property of every queue, so those
still rebuild.

Add mana_split_qset(), which carves the live set into the prefix to keep
and the tail to retire. It allocates two pointer arrays and a steering
table and moves the existing queue pointers into them; no DMA ring is
allocated and no WQ object is created. Both halves are then handed to the
existing mana_publish_qset() and mana_free_qset(), so the swap ordering,
the TX quiesce, the rollback and the TX drain are unchanged - the live
context is never mutated in place, which is what makes this safe under
traffic.

Two details worth noting. The steering table is rebuilt for the smaller
set rather than edited in place, because mana_config_rss() would otherwise
index the shorter rxqs[] with entries still referring to retired queues.
And the tail carries apc->bpf_prog so that mana_free_qset()'s
mana_chn_setxdp(NULL) drops exactly the tail's per-queue program
references; the kept queues are left alone because mana_chn_setxdp()
returns early when the program is unchanged.

A reduction now allocates two small arrays and a steering table instead of
a full queue set, so the peak stays at one set rather than two, and the
surviving queues keep their page pools, posted RX buffers and NAPI state
instead of being drained and refilled.

This completes the conversion, so advertise it to the firmware. Every
queue resize path - channel count, ring size, MTU, the full-page RX
private flag and XDP attach - now builds the new queue set before
retiring the old one and keeps the old one running if that fails, so a
failed resize no longer needs external intervention to restore the port.
Add GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE and set it
in GDMA_DRV_CAP_FLAGS1.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 146 ++++++++++++++++++
 .../ethernet/microsoft/mana/mana_ethtool.c    |  35 +++++
 include/net/mana/gdma.h                       |  11 +-
 include/net/mana/mana.h                       |   4 +
 4 files changed, 195 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 4cab3f658f2487671d26243d4e91f834580b3c5c..7cd2fd9ea050f10604dc0adb368c0aa4e7b6bb10 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4287,6 +4287,152 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 	kvfree(scratch);
 }
 
+/**
+ * mana_split_qset - carve the live queue set into a kept prefix and a tail
+ * @apc:       live port context
+ * @scratch:   scratch context, used to allocate the new steering table
+ * @new_count: number of queues to keep
+ * @out_new:   filled with the set to publish, queues [0, @new_count)
+ * @out_tail:  filled with the set to retire, queues [@new_count, num_queues)
+ *
+ * A channel-count reduction is the one reconfiguration where the surviving
+ * queues need no rebuilding at all. mana_create_txq() derives a TX queue only
+ * from apc->tx_queue_size and apc->eqs[i], and mana_create_rxq() derives an RX
+ * queue only from apc->rx_queue_size and the MTU/priv-flag/XDP buffer layout;
+ * neither depends on how many queues exist, and queue i keeps EQ i at any
+ * count. Queue i is therefore configured identically before and after, so the
+ * low queues can be carried over and only the tail destroyed.
+ *
+ * All this allocates is two pointer arrays and a steering table. No DMA ring
+ * is allocated and no hardware WQ object is created, so the peak stays at one
+ * set instead of two, and the surviving queues keep their page pools, their
+ * posted RX buffers and their NAPI state instead of being drained and refilled.
+ *
+ * Nothing in @apc is modified here. Both sets are handed back for the existing
+ * mana_publish_qset() and mana_free_qset() to install and retire, so the swap
+ * ordering, the rollback and the TX drain all keep working the way they do for
+ * a rebuilt set.
+ *
+ * On success the caller owns both sets. On failure @apc is untouched.
+ */
+int mana_split_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int new_count,
+		    struct mana_qset *out_new, struct mana_qset *out_tail)
+{
+	unsigned int old_count = apc->num_queues;
+	struct mana_tx_qp **new_tx, **tail_tx;
+	struct mana_rxq **new_rx, **tail_rx;
+	unsigned int tail_count;
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
+	/* Build the steering table for the smaller set separately, so the live
+	 * one keeps describing the live queues until mana_publish_qset() swaps
+	 * both over together. mana_config_rss() would otherwise index the new
+	 * (shorter) rxqs[] with entries that still refer to retired queues.
+	 */
+	scratch->num_queues = new_count;
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		return err;
+
+	if (mana_rss_table_keep(apc, new_count))
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
+
+	/* Ownership of the table moved to @out_new. */
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+
+	/* The tail. It owns no steering table; bpf_prog is carried so that
+	 * mana_free_qset()'s mana_chn_setxdp(NULL) drops exactly the tail's
+	 * per-queue program references and leaves the kept ones alone.
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
+ * Frees only the pointer arrays and the steering table. The queues they refer
+ * to are still owned by the live port context, so they must not be destroyed.
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
 /**
  * mana_alloc_qset - build a complete queue set in @scratch
  * @apc:	   live port context, owner of the shared EQ pool
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index a4d62ea8aec8f4aaa521af2c4fa4af6d928e9b4e..091b4a79ad238151b3a7f2014306b9551680c929 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -736,6 +736,41 @@ static int mana_set_channels(struct net_device *ndev,
 		goto clear_flag;
 	}
 
+	/* A reduction does not need new queues: the ones being kept are
+	 * configured identically before and after, so carry them over and
+	 * retire only the tail. This allocates no DMA ring and creates no
+	 * hardware WQ object, so it also avoids the old+new peak that a
+	 * rebuild has to pay.
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
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 70a7f1fee5d3b0a6460cbd76159d01a369838d68..c54500700f6f2f4b432102364e64fd021e7c2c88 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -672,6 +672,14 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver recovers by itself when a queue resize fails: a failed resize leaves
+ * the queues that were already serving traffic in place, so the host does not
+ * have to bring the port back. This covers the resize itself failing. It does
+ * not promise recovery when restoring the previous queue set fails too, which
+ * leaves the port administratively down for the admin to bring back up.
+ */
+#define GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE BIT(31)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -688,7 +696,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
-	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)
+	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
+	 GDMA_DRV_CAP_FLAG_1_SELF_RECOVERY_ON_QUEUE_RESIZE_FAILURE)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 52f1c8f9c2b968ad14c90849fd3286b2c046d1d3..8603f66ded7c2a8745d257ba4b8b5801a1c289e3 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -773,6 +773,10 @@ int mana_alloc_qset(struct mana_port_context *apc,
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

