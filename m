Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429B538F651;
	Thu, 13 Aug 2026 05:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786597505; cv=none; b=dNy0Crh16pQBNm4VaNLec4CAxOd4+UJLJ0EV1r9vxS0JYCeIO858l3ehojodG9z+mkN1VQHgqYXbJtp5TLcYLKChaLjf9ClyO/NAlc9cvOPw41j2fncRXCFE4NKhG53keUOwa8528XHKFyzs9fNevwW95fHPolmKvu5r9VLea1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786597505; c=relaxed/simple;
	bh=xHJJj7mLPauJ/aixz6vMeUhRVI2XGJUdgTCl7y68hu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmgjmGnH75tEEN9RrkAZe19yyJh5OD4rx5dkHw1JevGMGAxNJ9MdYFgM16Lnyk7qDvZDnQs34GESUhzs5/41L4nh/cdEkkUfH6Ft8/U6KlbIovqvanqI+KaH3rggE+oSWDTa6ZAzKeX6OSmcSJmYMpvsG9CLmaaAikHEs84tvg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 75CBC20B7017; Wed, 12 Aug 2026 22:04:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 75CBC20B7017
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
Subject: [PATCH net-next v2 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Wed, 12 Aug 2026 22:04:16 -0700
Message-ID: <20260813050418.2906468-12-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813050418.2906468-1-longli@microsoft.com>
References: <20260813050418.2906468-1-longli@microsoft.com>
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
 include/net/mana/mana.h                       |  7 ++
 2 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7c43c2f9043ba591b58e4ee2211cf37da9fead36..6e77b59cfcf907f7e584625273972bf185501d20 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3496,6 +3496,38 @@ static void mana_rss_table_init(struct mana_port_context *apc)
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
@@ -3766,6 +3798,7 @@ int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	bool indir_lost;
 	int err;
 
 	err = mana_create_vport(apc, ndev);
@@ -3811,7 +3844,18 @@ int mana_alloc_queues(struct net_device *ndev)
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
@@ -4068,11 +4112,15 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
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
@@ -4150,6 +4198,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
+	bool indir_lost;
 	int err;
 
 	ASSERT_RTNL();
@@ -4193,9 +4242,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
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
@@ -4407,6 +4466,15 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (carrier_ok)
 		netif_carrier_on(ndev);
 
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
index 619c66f3c6192dd2988a1bba73e991df2a773923..0d7375adeb5366bbbb99a7faa931a8830f71ef10 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -731,6 +731,13 @@ struct mana_qset {
 	 */
 	int			mtu;
 	struct bpf_prog		*bpf_prog;
+
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

