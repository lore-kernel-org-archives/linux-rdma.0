From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 1/1] IB/ipoib: add get_settings in ethtool
Date: Wed, 26 Apr 2017 05:02:34 -0400
Message-ID: <1493197354-3025-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to let the bonding driver report the correct speed
of the underlaying interfaces, when they are IPoIB, the ethtool
function get_settings() in the IPoIB driver is implemented.

Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 50 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h                 |  1 +
 2 files changed, 51 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index bac455a..7ebe52a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -155,7 +155,57 @@ static int ipoib_get_sset_count(struct net_device __always_unused *dev,
 	return -EOPNOTSUPP;
 }
 
+/* Return lane speed in unit of 1e6 bit/sec */
+static inline int ib_speed_enum_to_int(int speed)
+{
+	switch (speed) {
+	case IB_SPEED_SDR:
+		return SPEED_2500;
+	case IB_SPEED_DDR:
+		return SPEED_5000;
+	case IB_SPEED_QDR:
+	case IB_SPEED_FDR10:
+		return SPEED_10000;
+	case IB_SPEED_FDR:
+		return SPEED_14000;
+	case IB_SPEED_EDR:
+		return SPEED_25000;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
+static int ipoib_get_settings(struct net_device *netdev,
+			      struct ethtool_cmd *ecmd)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(netdev);
+	struct ib_port_attr attr;
+	int ret, speed, width;
+
+	if (!netif_carrier_ok(netdev)) {
+		ethtool_cmd_speed_set(ecmd, SPEED_UNKNOWN);
+		ecmd->duplex = DUPLEX_UNKNOWN;
+		return 0;
+	}
+
+	ret = ib_query_port(priv->ca, priv->port, &attr);
+	if (ret < 0)
+		return -EINVAL;
+
+	speed = ib_speed_enum_to_int(attr.active_speed);
+	width = ib_width_enum_to_int(attr.active_width);
+
+	if (speed < 0 || width < 0)
+		return -EINVAL;
+
+	ethtool_cmd_speed_set(ecmd, speed * width);
+	ecmd->duplex = DUPLEX_FULL;
+
+	return 0;
+}
+
 static const struct ethtool_ops ipoib_ethtool_ops = {
+	.get_settings		= ipoib_get_settings,
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 3dc91a4..55c3dcd 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1493,6 +1493,7 @@ enum ethtool_link_mode_bit_indices {
 #define SPEED_2500		2500
 #define SPEED_5000		5000
 #define SPEED_10000		10000
+#define SPEED_14000		14000
 #define SPEED_20000		20000
 #define SPEED_25000		25000
 #define SPEED_40000		40000
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
