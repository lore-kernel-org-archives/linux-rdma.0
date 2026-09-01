Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E733CF95E;
	Tue,  1 Sep 2026 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227138; cv=none; b=V8OblNjzWkch/Qi8QSi7SolYwxIlNt+gQ8gFOWsIBbRcG2UAr/nNvVnEUB9wBtRw2INN65B5FSsOCGq0xjAFd5IeROlyYs2qx5LKXtza/DgO+wRB5RdNsvFFbq7vQRDHuN8OQd8gWtZD4ok8Moy+Z7Ncy0gw6aUkQCN6RZ46VCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227138; c=relaxed/simple;
	bh=8ewdqON8GtF7hWFs9pCc1PTwsghk8Mat9GxLyK+RN+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea4xa4hQSWb8d6UjmO6jSH12WZ3LO01I15b0urpgwYNC+3YUT7NUS+3racWiY5nyaXytPgdyAi0TykO01PWA4gVMxcWpbqyrHELfypjjU39O1UiycCpU0S6ivoNrsZPNeYuf/l5ALbrUJVkRxBFCxH6dQFR+GQjTYzDS14hfmAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 0908F20B6F21; Mon, 31 Aug 2026 18:44:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0908F20B6F21
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
Subject: [PATCH net-next v3 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Mon, 31 Aug 2026 18:44:40 -0700
Message-ID: <20260901014442.2945689-12-longli@microsoft.com>
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

A queue rebuild regenerates the RSS indirection table from the driver
default, so a table the user installed with "ethtool -X" is silently
replaced by any reconfiguration that rebuilds the queues.

Carry it over instead when the queue count is unchanged: the entries are
queue indices, so they stay meaningful. A driver-generated table is
still regenerated, and a table that cannot be honoured for the new queue
count is reported to the core as lost - but only once the new set is
actually live, so a failed reconfiguration does not clear
IFF_RXFH_CONFIGURED on a port that kept its old queues.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 78 +++++++++++++++++--
 include/net/mana/mana.h                       |  6 ++
 2 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2295769da0306888f0a0bd7bb7a6098e908289f1..6769faada11bcd898d3991d0c286578a736eba12 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3634,6 +3634,38 @@ static void mana_rss_table_init(struct mana_port_context *apc)
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+/* Whether @apc's indirection table can be carried to a set of @num_queues,
+ * rather than rebuilt from the driver default.
+ *
+ * Only a user table ("ethtool -X") is kept; a driver one is rebuilt to spread
+ * over the new count. ethtool_check_max_channel() already refuses a reduction
+ * that leaves a user table pointing past the last queue, so the bounds check
+ * below only guards rebuild paths that bypass ethtool.
+ *
+ * @lost reports a table that cannot be carried instead of calling
+ * ethtool_rxfh_indir_lost() here, since the swap may still fail and leave the
+ * port on queues where the table still applies. False when none was set.
+ */
+static bool mana_rss_table_keep(struct mana_port_context *apc,
+				unsigned int num_queues, bool *lost)
+{
+	u32 i;
+
+	*lost = false;
+
+	if (!netif_is_rxfh_configured(apc->ndev))
+		return false;
+
+	for (i = 0; i < apc->indir_table_sz; i++) {
+		if (apc->indir_table[i] >= num_queues) {
+			*lost = true;
+			return false;
+		}
+	}
+
+	return true;
+}
+
 int mana_disable_vport_rx(struct mana_port_context *apc)
 {
 	return mana_cfg_vport_steering(apc, TRI_STATE_FALSE, false, false,
@@ -3904,6 +3936,7 @@ int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	bool indir_lost;
 	int err;
 
 	err = mana_create_vport(apc, ndev);
@@ -3949,7 +3982,18 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_rxq;
 	}
 
-	mana_rss_table_init(apc);
+	/* Keep a user-configured RSS table across a rebuild; the entries are
+	 * queue indices, so they stay meaningful as long as the queue count
+	 * is unchanged. Only a driver-generated table is regenerated here.
+	 *
+	 * Nothing to roll back to here, so report the loss as soon as it is
+	 * decided and keep the table and the core's view of it in step.
+	 */
+	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost)) {
+		if (indir_lost)
+			ethtool_rxfh_indir_lost(ndev);
+		mana_rss_table_init(apc);
+	}
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
 	if (err) {
@@ -4207,11 +4251,15 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
 	out->bpf_prog		= ctx->bpf_prog;
+
+	/* A set taken from a live context has nothing pending; the builders
+	 * set this after snapshotting if they had to drop the user's table.
+	 */
+	out->rxfh_indir_lost	= false;
 }
 
-/* Install @qset's fields onto @ctx. The vport (port_handle,
- * vport_use_count) and the port-level debugfs dir are deliberately not
- * touched: they outlive any individual queue set.
+/* The vport (port_handle, vport_use_count) and the port-level debugfs dir are
+ * not touched: they outlive any individual queue set.
  */
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
@@ -4290,6 +4338,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
+	bool indir_lost;
 	int err;
 
 	ASSERT_RTNL();
@@ -4333,9 +4382,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq;
 
-	mana_rss_table_init(scratch);
+	/* Carry a user-configured RSS table over to the new set. The entries
+	 * are queue indices, so mana_config_rss() in mana_publish_qset() maps
+	 * them onto the new set's RX objects. A driver-generated table is
+	 * rebuilt instead, so it covers every queue of the new set.
+	 */
+	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
 
 	mana_qset_snapshot(scratch, out);
+	out->rxfh_indir_lost = indir_lost;
 	return 0;
 
 cleanup_rxq:
@@ -4583,6 +4642,15 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	WRITE_ONCE(apc->port_is_up, true);
 	mana_start_txqs(apc);
 
+	/* The set that could not carry the user's indirection table is the one
+	 * serving traffic now, so the table really is gone. Reporting it here
+	 * rather than while the set was being built keeps a failed swap from
+	 * clearing IFF_RXFH_CONFIGURED on a port that kept its old queues, and
+	 * with them a table that is still valid and still programmed.
+	 */
+	if (newq->rxfh_indir_lost)
+		ethtool_rxfh_indir_lost(ndev);
+
 	return 0;
 
 rollback:
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 140948b2b45d5afa91e37d72219bb89783a030d5..9d08257bc1fc47e7accc30a2ef2ae3db7acc7b9d 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -762,6 +762,12 @@ struct mana_qset {
 	int			mtu;
 	struct bpf_prog		*bpf_prog;
 
+	/* The user's RSS indirection table could not be carried onto this set,
+	 * so a default one was generated for it. mana_publish_qset() tells the
+	 * core once this set is live; until then the port is still running on
+	 * a set where the user's table applies.
+	 */
+	bool			rxfh_indir_lost;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
-- 
2.43.0

