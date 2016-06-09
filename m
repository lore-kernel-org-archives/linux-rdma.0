From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/13] IB/ipoib: Use new device FW version string
Date: Thu,  9 Jun 2016 17:54:06 -0400
Message-ID: <1465509248-11324-12-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Using this allows for devices to specify the format of their
firmware version rather than forcing a format.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 1502199c8e56..7b6d40ff1acf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -62,10 +62,8 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 {
 	struct ipoib_dev_priv *priv = netdev_priv(netdev);
 
-	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
-		 "%d.%d.%d", (int)(priv->ca->attrs.fw_ver >> 32),
-		 (int)(priv->ca->attrs.fw_ver >> 16) & 0xffff,
-		 (int)priv->ca->attrs.fw_ver & 0xffff);
+	ib_get_device_fw_str(priv->ca, drvinfo->fw_version,
+			     sizeof(drvinfo->fw_version));
 
 	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dma_device),
 		sizeof(drvinfo->bus_info));
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
