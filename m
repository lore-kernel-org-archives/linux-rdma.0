From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/9] IB/ipoib: Fix deadlock over vlan_mutex
Date: Tue, 27 Dec 2016 15:39:05 +0200
Message-ID: <20161227133911.14340-4-leon@kernel.org>
References: <20161227133911.14340-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161227133911.14340-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch fixes Deadlock while executing ipoib_vlan_delete.

The function takes the vlan_rwsem semaphore and calls
unregister_netdevice. The later function calls
ipoib_mcast_stop_thread that cause workqueue flush.

When the queue has one of the ipoib_ib_dev_flush_xxx events,
a deadlock occur because these events also tries to catch the
same vlan_rwsem semaphore.

To fix, unregister_netdevice should be called after releasing
the semaphore.

Fixes: cbbe1efa4972 ("IPoIB: Fix deadlock between ipoib_open() and child interface create")
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index fd81111..9682183 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -196,7 +196,6 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
 		if (priv->pkey == pkey &&
 		    priv->child_type == IPOIB_LEGACY_CHILD) {
-			unregister_netdevice(priv->dev);
 			list_del(&priv->list);
 			dev = priv->dev;
 			break;
@@ -204,6 +203,11 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	}
 	up_write(&ppriv->vlan_rwsem);
 
+	if (dev) {
+		ipoib_dbg(ppriv, "delete child vlan %s\n", dev->name);
+		unregister_netdevice(dev);
+	}
+
 	rtnl_unlock();
 
 	if (dev) {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
