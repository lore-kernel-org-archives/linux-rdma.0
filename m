From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH] IB/ipoib: Add readout of statistics using ethtool
Date: Fri, 15 Apr 2016 12:17:48 +0200
Message-ID: <1460715468-16235-1-git-send-email-hans.westgaard.ry@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB collects statistics of traffic including number of packets
sent/received, number of bytes transferred, and certain errors. This
patch makes these statistics available to be queried by ethtool.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Tested-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 70 ++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index a53fa5f..52a1f30 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -36,6 +36,31 @@
 
 #include "ipoib.h"
 
+struct ipoib_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int stat_offset;
+};
+
+
+#define IPOIB_NETDEV_STAT(str, m) { \
+		.stat_string = str, \
+		.stat_offset = offsetof(struct rtnl_link_stats64, m) }
+
+
+
+static const struct ipoib_stats ipoib_gstrings_stats[] = {
+	IPOIB_NETDEV_STAT("rx_packets", rx_packets),
+	IPOIB_NETDEV_STAT("tx_packets", tx_packets),
+	IPOIB_NETDEV_STAT("rx_bytes",   rx_bytes),
+	IPOIB_NETDEV_STAT("tx_bytes",   tx_bytes),
+	IPOIB_NETDEV_STAT("tx_errors",  tx_errors),
+	IPOIB_NETDEV_STAT("rx_dropped", rx_dropped),
+	IPOIB_NETDEV_STAT("tx_dropped", tx_dropped)
+};
+
+#define IPOIB_GLOBAL_STATS_LEN	ARRAY_SIZE(ipoib_gstrings_stats)
+
+
 static void ipoib_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
@@ -92,11 +117,56 @@ static int ipoib_set_coalesce(struct net_device *dev,
 
 	return 0;
 }
+static void ipoib_get_ethtool_stats(struct net_device *dev,
+				    struct ethtool_stats __always_unused *stats,
+				    u64 *data)
+{
+	int i;
+	struct net_device_stats *net_stats = &dev->stats;
+	u8 *p = (u8 *)net_stats;
+
+	for (i = 0; i < IPOIB_GLOBAL_STATS_LEN; i++)
+		data[i] = *(u64 *)(p + ipoib_gstrings_stats[i].stat_offset);
+
+}
+static void ipoib_get_strings(struct net_device __always_unused *dev,
+			      u32 stringset, u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_TEST:
+		break;
+	case ETH_SS_STATS:
+		for (i = 0; i < IPOIB_GLOBAL_STATS_LEN; i++) {
+			memcpy(p, ipoib_gstrings_stats[i].stat_string,
+				ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	}
+}
+static int ipoib_get_sset_count(struct net_device __always_unused *dev,
+				 int sset)
+{
+	switch (sset) {
+	case ETH_SS_TEST:
+		return -EOPNOTSUPP;
+	case ETH_SS_STATS:
+		return IPOIB_GLOBAL_STATS_LEN;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
 
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
+	.get_strings		= ipoib_get_strings,
+	.get_ethtool_stats	= ipoib_get_ethtool_stats,
+	.get_sset_count		= ipoib_get_sset_count,
 };
 
 void ipoib_set_ethtool_ops(struct net_device *dev)
-- 
2.4.3
