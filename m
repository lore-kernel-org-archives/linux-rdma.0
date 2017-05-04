From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 1/1] IB/ipoib: add get_link_ksettings in ethtool
Date: Thu,  4 May 2017 01:24:51 -0400
Message-ID: <1493875491-32048-2-git-send-email-yanjun.zhu@oracle.com>
References: <1493665155.3041.186.camel@redhat.com>
 <1493875491-32048-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493875491-32048-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tbogendoerfer-l3A5Bk7waGM@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to let the bonding driver report the correct speed
of the underlaying interfaces, when they are IPoIB, the ethtool
function get_link_ksettings() in the IPoIB driver is implemented.

Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Suggested-by: Håkon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Changes V2-->V3
  Replace get_settings with get_link_ksettings.
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 59 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h                 |  1 +
 2 files changed, 60 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index bac455a..dd00775 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -155,7 +155,66 @@ static int ipoib_get_sset_count(struct net_device __always_unused *dev,
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
+static int ipoib_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(netdev);
+	struct ib_port_attr attr;
+	int ret, speed, width;
+
+	if (!netif_carrier_ok(netdev)) {
+		cmd->base.speed = SPEED_UNKNOWN;
+		cmd->base.duplex = DUPLEX_UNKNOWN;
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
+	/* Except the following are set, the other members of
+	 * the struct ethtool_link_settings are initialized to
+	 * zero in the function __ethtool_get_link_ksettings.
+	 */
+	cmd->base.speed		 = speed * width;
+	cmd->base.duplex	 = DUPLEX_FULL;
+
+	cmd->base.phy_address	 = 0xFF;
+
+	cmd->base.autoneg	 = AUTONEG_ENABLE;
+	cmd->base.port		 = PORT_OTHER;
+
+	return 0;
+}
+
 static const struct ethtool_ops ipoib_ethtool_ops = {
+	.get_link_ksettings	= ipoib_get_link_ksettings,
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
