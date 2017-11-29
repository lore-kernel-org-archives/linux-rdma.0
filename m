From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next] IB/ipoib: Warn when one port fails to initialize
Date: Wed, 29 Nov 2017 08:34:02 +0200
Message-ID: <20171129063402.3963-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If one port fails to initialize an error message should indicate the
reason and driver should continue serving the working port(s) and other
HCA(s).

Fixes: e4b2d06892c7 ("IB/ipoib: Remove device when one port fails to
init").

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 12b7f911f0e5..0c95101c45c8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2196,8 +2196,10 @@ static struct net_device *ipoib_add_port(const char *format,
 	int result = -ENOMEM;
 
 	priv = ipoib_intf_alloc(hca, port, format);
-	if (!priv)
+	if (!priv) {
+		pr_warn("%s, %d: ipoib_intf_alloc failed\n", hca->name, port);
 		goto alloc_mem_failed;
+	}
 
 	SET_NETDEV_DEV(priv->dev, hca->dev.parent);
 	priv->dev->dev_id = port - 1;
@@ -2326,8 +2328,7 @@ static void ipoib_add_one(struct ib_device *device)
 	}
 
 	if (!count) {
-		pr_err("Failed to init port, removing it\n");
-		ipoib_remove_one(device, dev_list);
+		kfree(dev_list);
 		return;
 	}
 
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
