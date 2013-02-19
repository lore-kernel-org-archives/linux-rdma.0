From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.9 2/3] IB/ipoib: Add version and firmware info to ethtool reporting
Date: Tue, 19 Feb 2013 17:40:23 +0200
Message-ID: <1361288424-8376-3-git-send-email-ogerlitz@mellanox.com>
References: <1361288424-8376-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361288424-8376-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement version info as well as report firmware version and bus info
of the underlying IB HW device.

Signed-off-by: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h         |    2 ++
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   19 ++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    5 +++++
 3 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index a7ac097..eb71aaa 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -762,4 +762,6 @@ extern int ipoib_debug_level;
 
 #define IPOIB_QPN(ha) (be32_to_cpup((__be32 *) ha) & 0xffffff)
 
+extern const char ipoib_driver_version[];
+
 #endif /* _IPOIB_H */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 29bc7b5..c4b3940 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -39,7 +39,24 @@
 static void ipoib_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
-	strncpy(drvinfo->driver, "ipoib", sizeof(drvinfo->driver) - 1);
+	struct ipoib_dev_priv *priv = netdev_priv(netdev);
+	struct ib_device_attr *attr;
+
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	if (attr && !ib_query_device(priv->ca, attr))
+		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+			 "%d.%d.%d", (int)(attr->fw_ver >> 32),
+			 (int)(attr->fw_ver >> 16) & 0xffff,
+			 (int)attr->fw_ver & 0xffff);
+	kfree(attr);
+
+	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dma_device),
+		sizeof(drvinfo->bus_info));
+
+	strlcpy(drvinfo->version, ipoib_driver_version,
+		sizeof(drvinfo->version));
+
+	strlcpy(drvinfo->driver, "ib_ipoib", sizeof(drvinfo->driver));
 }
 
 static int ipoib_get_coalesce(struct net_device *dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3c2498f..e9ee07b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -49,9 +49,14 @@
 #include <linux/jhash.h>
 #include <net/arp.h>
 
+#define DRV_VERSION "1.0.0"
+
+const char ipoib_driver_version[] = DRV_VERSION;
+
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("IP-over-InfiniBand net driver");
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
 
 int ipoib_sendq_size __read_mostly = IPOIB_TX_RING_SIZE;
 int ipoib_recvq_size __read_mostly = IPOIB_RX_RING_SIZE;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
