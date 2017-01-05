From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 1/1] IB/ipoib: Remove unnecessary returned value check
Date: Thu,  5 Jan 2017 03:56:08 -0500
Message-ID: <1483606568-17232-1-git-send-email-yanjun.zhu@oracle.com>
References: <20170105061236.GV12077@mtr-leonro.local>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105061236.GV12077-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the function ipoib_set_dev_features, the returned value is always 0.
As such, it is not necessary to check the returned value.
This is not a bug. It is a trivial problem.

Reviewed-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Change from v1 to v2:
 make change to __ipoib_vlan_add.
 change the commit header. 

 drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 4 +---
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index da12717..f568064 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -593,7 +593,7 @@ void ipoib_pkey_open(struct ipoib_dev_priv *priv);
 void ipoib_drain_cq(struct net_device *dev);
 
 void ipoib_set_ethtool_ops(struct net_device *dev);
-int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
+void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
 
 #define IPOIB_FLAGS_RC		0x80
 #define IPOIB_FLAGS_UC		0x40
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765..4e8e11e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1984,7 +1984,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 	return device_create_file(&dev->dev, &dev_attr_pkey);
 }
 
-int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
+void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 {
 	priv->hca_caps = hca->attrs.device_cap_flags;
 
@@ -1996,8 +1996,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 
 		priv->dev->features |= priv->dev->hw_features;
 	}
-
-	return 0;
 }
 
 static struct net_device *ipoib_add_port(const char *format,
@@ -2037,9 +2035,7 @@ static struct net_device *ipoib_add_port(const char *format,
 		goto device_init_failed;
 	}
 
-	result = ipoib_set_dev_features(priv, hca);
-	if (result)
-		goto device_init_failed;
+	ipoib_set_dev_features(priv, hca);
 
 	/*
 	 * Set the full membership bit, so that we join the right
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index a2f9f29..0c2988d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -61,9 +61,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 	priv->parent = ppriv->dev;
 	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
 
-	result = ipoib_set_dev_features(priv, ppriv->ca);
-	if (result)
-		goto err;
+	ipoib_set_dev_features(priv, ppriv->ca);
 
 	priv->pkey = pkey;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
