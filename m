From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 30/37] IB/IPoIB: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:30 -0800
Message-ID: <20170120210437.26389-31-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 7b6d40ff1acf..bac455a1942d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -65,7 +65,7 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 	ib_get_device_fw_str(priv->ca, drvinfo->fw_version,
 			     sizeof(drvinfo->fw_version));
 
-	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dma_device),
+	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dev.parent),
 		sizeof(drvinfo->bus_info));
 
 	strlcpy(drvinfo->version, ipoib_driver_version,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765a05ab..abb90a2781ba 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2011,7 +2011,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	if (!priv)
 		goto alloc_mem_failed;
 
-	SET_NETDEV_DEV(priv->dev, hca->dma_device);
+	SET_NETDEV_DEV(priv->dev, hca->dev.parent);
 	priv->dev->dev_id = port - 1;
 
 	result = ib_query_port(hca, port, &attr);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
