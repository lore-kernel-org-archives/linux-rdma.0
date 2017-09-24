From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 5/7] IB/ipoib: Fix inconsistency with free_netdev and free_rdma_netdev
Date: Sun, 24 Sep 2017 21:46:33 +0300
Message-ID: <20170924184635.31948-6-leon@kernel.org>
References: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924184635.31948-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Call free_rdma_netdev instead of free_netdev each time we want to
release a netdevice. This call is also relevant for future freeing
of offloaded child interfaces.

This patch also adds a missing call for free netdevice when releasing
a parent interface that has child interfaces using ipoib_remove_one.

Fixes: cd565b4b51e5 ('IB/IPoIB: Support acceleration options callbacks')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++++++----
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 10 ++++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index bac95b509a9b..dcc77014018d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2180,6 +2180,7 @@ static struct net_device *ipoib_add_port(const char *format,
 {
 	struct ipoib_dev_priv *priv;
 	struct ib_port_attr attr;
+	struct rdma_netdev *rn;
 	int result = -ENOMEM;
 
 	priv = ipoib_intf_alloc(hca, port, format);
@@ -2279,7 +2280,8 @@ static struct net_device *ipoib_add_port(const char *format,
 	ipoib_dev_cleanup(priv->dev);
 
 device_init_failed:
-	free_netdev(priv->dev);
+	rn = netdev_priv(priv->dev);
+	rn->free_rdma_netdev(priv->dev);
 	kfree(priv);
 
 alloc_mem_failed:
@@ -2328,7 +2330,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		return;
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
-		struct rdma_netdev *rn = netdev_priv(priv->dev);
+		struct rdma_netdev *parent_rn = netdev_priv(priv->dev);
 
 		ib_unregister_event_handler(&priv->event_handler);
 		flush_workqueue(ipoib_workqueue);
@@ -2350,10 +2352,15 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		unregister_netdev(priv->dev);
 		mutex_unlock(&priv->sysfs_mutex);
 
-		rn->free_rdma_netdev(priv->dev);
+		parent_rn->free_rdma_netdev(priv->dev);
+
+		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
+			struct rdma_netdev *child_rn;
 
-		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list)
+			child_rn = netdev_priv(cpriv->dev);
+			child_rn->free_rdma_netdev(cpriv->dev);
 			kfree(cpriv);
+		}
 
 		kfree(priv);
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index e01c58edca15..55a9b71ed05a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -179,7 +179,10 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	mutex_unlock(&ppriv->sysfs_mutex);
 
 	if (result && priv) {
-		free_netdev(priv->dev);
+		struct rdma_netdev *rn;
+
+		rn = netdev_priv(priv->dev);
+		rn->free_rdma_netdev(priv->dev);
 		kfree(priv);
 	}
 
@@ -232,7 +235,10 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	mutex_unlock(&ppriv->sysfs_mutex);
 
 	if (dev) {
-		free_netdev(dev);
+		struct rdma_netdev *rn;
+
+		rn = netdev_priv(dev);
+		rn->free_rdma_netdev(priv->dev);
 		kfree(priv);
 		return 0;
 	}
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
