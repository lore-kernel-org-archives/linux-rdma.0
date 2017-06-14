From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/5] IB/ipoib: Fix memory leaks for child interfaces priv
Date: Wed, 14 Jun 2017 09:59:05 +0300
Message-ID: <20170614065909.23650-2-leon@kernel.org>
References: <20170614065909.23650-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is a need to free priv explicitly and not just to release
the device, child priv is freed explicitly on remove flow and this
patch also includes priv free on error flow in P_key creation
and also in add_port.

Fixes: cd565b4b51e5 ('IB/IPoIB: Support acceleration options callbacks')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 7 ++++++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a115c0b7a310..0ddd9709e1df 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2237,6 +2237,7 @@ static struct net_device *ipoib_add_port(const char *format,
 
 device_init_failed:
 	free_netdev(priv->dev);
+	kfree(priv);
 
 alloc_mem_failed:
 	return ERR_PTR(result);
@@ -2277,7 +2278,7 @@ static void ipoib_add_one(struct ib_device *device)
 
 static void ipoib_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ipoib_dev_priv *priv, *tmp;
+	struct ipoib_dev_priv *priv, *tmp, *cpriv, *tcpriv;
 	struct list_head *dev_list = client_data;
 
 	if (!dev_list)
@@ -2301,6 +2302,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 
 		unregister_netdev(priv->dev);
 		free_netdev(priv->dev);
+
+		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list)
+			kfree(cpriv);
+
 		kfree(priv);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 36dc4fcaa3cd..1ee46194bbf5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -167,8 +167,10 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	rtnl_unlock();
 
-	if (result)
+	if (result) {
 		free_netdev(priv->dev);
+		kfree(priv);
+	}
 
 	return result;
 }
@@ -209,6 +211,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 
 	if (dev) {
 		free_netdev(dev);
+		kfree(priv);
 		return 0;
 	}
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
