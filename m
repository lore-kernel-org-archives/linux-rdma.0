Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5102EDD78;
	Sat,  5 Sep 2026 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788569084; cv=none; b=lIs5zIT0ei/dVtqxZLgGGXdRhEBcfTfp9umM8bFNd0sqdUEWb+jmm8PDa1Dr/+pc7cqBADuyzvTtd8XD4dG6qjP1NdTVb/ufxH29IQwW9RNCjVQbYmKFCyZIdZFoanaLMLJRVXTR/y6bRBFC/P7mC6NyKT4olLESYjCcLvrRhe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788569084; c=relaxed/simple;
	bh=AB/1YXHK2PmOEoylzqWAd6eEVPGd6KSQLDbaN4SHlvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m+S5Cw5YlPTziAImjShby3ClQi8PxWl1vADx0HxSqpFYg2GAjR/20EvzNV5H31ofgosYoSsLmYnpZuVLv5OUquEt3DeIrQMOZ5ADlbIKc779Zxs74+U0+J96DpyqvN9njvP7ikCsRPZi4uMyyl/9KOYy0wFetvF+SpJczgpspOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 25D6320B7167; Fri,  4 Sep 2026 17:44:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 25D6320B7167
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
Subject: [PATCH net] net: mana: do not discard an ethtool-configured RSS table on a queue rebuild
Date: Fri,  4 Sep 2026 17:44:01 -0700
Message-ID: <20260905004401.3937066-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_alloc_queues() regenerates the RSS indirection table from the driver
default every time the queues are built, so a table installed with
"ethtool -X" is silently replaced by any operation that rebuilds them:
an MTU change, a ring-size, channel-count or private-flag change, an XDP
attach, TX-timeout reset recovery, or resume.

The driver never clears the core's IFF_RXFH_CONFIGURED, so
netif_is_rxfh_configured() keeps reporting a user table while the
hardware has been reprogrammed with the default one. "ethtool -x" then
shows a table the user did not ask for, with no indication it changed:

  # ethtool -X ens1 equal 2
  # ethtool -x ens1
  RX flow hash indirection table for ens1 with 16 RX ring(s):
      0:      0     1     0     1     0     1     0     1
      8:      0     1     0     1     0     1     0     1
  # ip link set ens1 mtu 1400
  # ethtool -x ens1
  RX flow hash indirection table for ens1 with 16 RX ring(s):
      0:      0     1     2     3     4     5     6     7
      8:      8     9    10    11    12    13    14    15

Keep the table instead, and rebuild it only when it is driver-generated
or cannot be honoured. An entry may not be kept if it points past the
last queue: mana_config_rss() uses these entries to index apc->rxqs[],
which holds apc->num_queues pointers. That is reachable because
mana_attach() calls mana_init_port(), which lowers apc->num_queues to the
maximum the device reports, so a table configured for more queues can
outlive them.

A table that cannot be kept is still replaced by the default silently,
without ethtool_rxfh_indir_lost(). That helper sends
ETHTOOL_MSG_RSS_NTF, which requires the netdev instance lock, and
mana_alloc_queues() runs both with that lock held, from ndo_open, and
without it, from mana_attach() on the reset and resume paths. Leaving
the core's view untouched is what the driver did for every table before
this change.

Opt the RSS ethtool operations into rtnl_lock() while here. Reading the
table in mana_alloc_queues() has to be serialized against mana_set_rxfh()
replacing it, and the two had no lock in common: mana_set_rxfh() ran under
the netdev instance lock alone, while mana_alloc_queues() reaches this
point holding only RTNL, from ndo_open and from mana_attach() on the reset
and resume paths. Taking the instance lock there instead is not possible,
since ndo_open already runs with it held. The same flag covers the netlink
and ioctl entry points.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 37 ++++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  3 +-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7a1ac853e3abcd28c4a1e5c6987ec631a18ad840..97386e17b9421aedefa25bab6fbf0b7b1f2996d4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3306,6 +3306,28 @@ static void mana_rss_table_init(struct mana_port_context *apc)
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+/* Whether the current indirection table can be kept for apc->num_queues,
+ * rather than rebuilt from the driver default.
+ *
+ * Only a user table ("ethtool -X") is worth keeping; a driver-generated one
+ * is rebuilt so that it spreads over every queue. An entry pointing past the
+ * last queue cannot be kept: mana_config_rss() uses these entries to index
+ * apc->rxqs[], which holds apc->num_queues pointers.
+ */
+static bool mana_rss_table_keep(struct mana_port_context *apc)
+{
+	u32 i;
+
+	if (!netif_is_rxfh_configured(apc->ndev))
+		return false;
+
+	for (i = 0; i < apc->indir_table_sz; i++)
+		if (apc->indir_table[i] >= apc->num_queues)
+			return false;
+
+	return true;
+}
+
 int mana_disable_vport_rx(struct mana_port_context *apc)
 {
 	return mana_cfg_vport_steering(apc, TRI_STATE_FALSE, false, false,
@@ -3621,7 +3643,20 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_rxq;
 	}
 
-	mana_rss_table_init(apc);
+	/* Keep a user-configured table across the rebuild: its entries are
+	 * queue indices and stay meaningful while they are all still in range.
+	 * Only a driver-generated table is regenerated here.
+	 *
+	 * A table that cannot be kept is replaced by the default without
+	 * telling the core, which keeps reporting the table as user
+	 * configured. That is what this function did for every table before,
+	 * and reporting it here is not an option: ethtool_rxfh_indir_lost()
+	 * sends ETHTOOL_MSG_RSS_NTF, which requires the netdev instance lock,
+	 * and this runs both with that lock held (ndo_open) and without it
+	 * (mana_attach() from the reset and resume paths).
+	 */
+	if (!mana_rss_table_keep(apc))
+		mana_rss_table_init(apc);
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
 	if (err) {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ece7ff9cc409a806b6a6de70a85b44874bfa6dad..e3acaf17efabcd62f7cffabdb8404cf16b917272 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -871,7 +871,8 @@ const struct ethtool_ops mana_ethtool_ops = {
 	.op_needs_rtnl		= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 				  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
 				  ETHTOOL_OP_NEEDS_RTNL_SPFLAGS |
-				  ETHTOOL_OP_NEEDS_RTNL_GLINK,
+				  ETHTOOL_OP_NEEDS_RTNL_GLINK |
+				  ETHTOOL_OP_NEEDS_RTNL_RSS,
 	.get_ethtool_stats	= mana_get_ethtool_stats,
 	.get_sset_count		= mana_get_sset_count,
 	.get_strings		= mana_get_strings,
-- 
2.43.0

