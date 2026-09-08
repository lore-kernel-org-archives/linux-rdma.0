Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955DF332EA0;
	Tue,  8 Sep 2026 03:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838173; cv=none; b=GV6k/BzWt0/3vmW/1Z6m5gzNkRww3Jo1v3DoFQWu2e67csy74ny13TVNqrzppiAJoQqvYPju8zxA+RUthegRctvA6GjkCmcwxWHOEYMxhQDftlTmkXVH8gmuUI8Di3PeiP+H+iMsbYcDJpG+ya6TENUff+aV7az4b2rgvRexQBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838173; c=relaxed/simple;
	bh=5zCRYk03cUswIQ6ni3SHPXuFXpu9junCSrD7c7nPPD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+KA98lPJKDl2cqIqvVGA6lCjx0DuEBpIvqFbxXMuj7AErAaNCU0Nd1Uckuj2VAZtxRE/t6Parj00ghA5evEIoVONqPsdxT2CDuh7VGfvj/4aiNVpDbOxYiS53s+3h+XaefKI8xaVb0H7iWOaouLCqsSLpzlXJidBDpMXKQpvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 5CD3620B6F01; Mon,  7 Sep 2026 20:28:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5CD3620B6F01
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
Subject: [PATCH net-next v4 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Mon,  7 Sep 2026 20:28:41 -0700
Message-ID: <20260908032843.397667-12-longli@microsoft.com>
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

Preserve a user RSS table whenever all entries fit the requested queue
count. Regenerate driver defaults. On growth, a retained user table does
not steer RSS traffic to the added queues until the user updates it.

Report table loss only after successful queue-set publication. The
non-swap allocation path still replaces invalid tables silently because
its callers do not consistently hold the notification's netdev lock.

Require RTNL for RSS setters to serialize them with reset/resume rebuilds.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Require RTNL for RSS setters to serialize against reset/resume.
  - Drop loss notification from mana_alloc_queues(), where the netdev
    instance lock is not held by every caller.
  - Describe preservation by entry bounds, including channel growth;
    shorten comments.

Merge note:
  This overlaps the net submission:
  https://lore.kernel.org/all/20260905004401.3937066-1-longli@microsoft.com/

  Keep this patch's three-argument mana_rss_table_keep() and its callers
  when resolving the overlapping mana_en.c blocks. The explicit queue
  count is needed to validate an unpublished set; the loss flag defers
  swap-path notification. ETHTOOL_OP_NEEDS_RTNL_RSS is identical in both
  trees. This series does not depend on the net fix landing first.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 41 +++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  3 +-
 include/net/mana/mana.h                       |  2 +
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index fc96837d69a00f97c090474ca69bf42cb4805353..78be88b29c99ba2a349df6b43e13487db8c69be1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3548,6 +3548,27 @@ static void mana_rss_table_init(struct mana_port_context *apc)
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+/* Keep user tables with valid indices; defer loss notification. */
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
@@ -3818,6 +3839,7 @@ int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	bool indir_lost;
 	int err;
 
 	err = mana_create_vport(apc, ndev);
@@ -3863,7 +3885,9 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_rxq;
 	}
 
-	mana_rss_table_init(apc);
+	/* Loss notification needs a netdev instance lock we may lack. */
+	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost))
+		mana_rss_table_init(apc);
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
 	if (err) {
@@ -4066,9 +4090,10 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
 	out->bpf_prog		= ctx->bpf_prog;
+
+	out->rxfh_indir_lost	= false;
 }
 
-/* Vport identity and port debugfs outlive queue sets. */
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
@@ -4128,6 +4153,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
+	bool indir_lost;
 	int err;
 
 	ASSERT_RTNL();
@@ -4163,9 +4189,14 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq;
 
-	mana_rss_table_init(scratch);
+	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
 
 	mana_qset_snapshot(scratch, out);
+	out->rxfh_indir_lost = indir_lost;
 	return 0;
 
 cleanup_rxq:
@@ -4339,6 +4370,10 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	WRITE_ONCE(apc->port_is_up, true);
 	mana_start_txqs(apc);
 
+	/* Report a lost user table only after successful publication. */
+	if (newq->rxfh_indir_lost)
+		ethtool_rxfh_indir_lost(ndev);
+
 	return 0;
 
 rollback:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 53a76ae42333f46e8791c3c493887ede5c6bb410..acc82fa9f0057120920b5a09bbb2bc7185707e65 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -951,7 +951,8 @@ const struct ethtool_ops mana_ethtool_ops = {
 	.op_needs_rtnl		= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 				  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
 				  ETHTOOL_OP_NEEDS_RTNL_SPFLAGS |
-				  ETHTOOL_OP_NEEDS_RTNL_GLINK,
+				  ETHTOOL_OP_NEEDS_RTNL_GLINK |
+				  ETHTOOL_OP_NEEDS_RTNL_RSS,
 	.get_ethtool_stats	= mana_get_ethtool_stats,
 	.get_sset_count		= mana_get_sset_count,
 	.get_strings		= mana_get_strings,
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 6c6d906db207304cd2d32c474cf2e9e5f32f4738..84b8151f0693c7e7ef06a558c69e2d207b445921 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -717,6 +717,8 @@ struct mana_qset {
 	int			mtu;
 	struct bpf_prog		*bpf_prog;
 
+	/* Notify the core only after this set is published. */
+	bool			rxfh_indir_lost;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
-- 
2.43.0
