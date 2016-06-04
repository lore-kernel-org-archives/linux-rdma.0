From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 5/7] IB/IPoIB: Disable bottom half when dealing with device address
Date: Sat,  4 Jun 2016 15:15:22 +0300
Message-ID: <1465042524-25852-6-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Align locking usage when touching device address with rest
of the kernel. Lock the bottom half when doing so using
netif_addr_lock_bh.

This also solves the following case as reported by lockdep:
	CPU0                    CPU1
	----                    ----
lock(_xmit_INFINIBAND);
				local_irq_disable();
				lock(&(&mc->mca_lock)->rlock);
				lock(_xmit_INFINIBAND);
<Interrupt>
lock(&(&mc->mca_lock)->rlock);

*** DEADLOCK ***

Fixes: 492a7e67ff83 ("IB/IPoIB: Allow setting the device address")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 8 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 8 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 45c40a1..dc6d241 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1015,7 +1015,7 @@ static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
 	if (ib_query_gid(priv->ca, priv->port, 0, &gid0, NULL))
 		return false;
 
-	netif_addr_lock(priv->dev);
+	netif_addr_lock_bh(priv->dev);
 
 	/* The subnet prefix may have changed, update it now so we won't have
 	 * to do it later
@@ -1026,12 +1026,12 @@ static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
 
 	search_gid.global.interface_id = priv->local_gid.global.interface_id;
 
-	netif_addr_unlock(priv->dev);
+	netif_addr_unlock_bh(priv->dev);
 
 	err = ib_find_gid(priv->ca, &search_gid, IB_GID_TYPE_IB,
 			  priv->dev, &port, &index);
 
-	netif_addr_lock(priv->dev);
+	netif_addr_lock_bh(priv->dev);
 
 	if (search_gid.global.interface_id !=
 	    priv->local_gid.global.interface_id)
@@ -1092,7 +1092,7 @@ static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
 	}
 
 out:
-	netif_addr_unlock(priv->dev);
+	netif_addr_unlock_bh(priv->dev);
 
 	return ret;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1cd569f..5f58c41 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1853,7 +1853,7 @@ static void set_base_guid(struct ipoib_dev_priv *priv, union ib_gid *gid)
 	struct ipoib_dev_priv *child_priv;
 	struct net_device *netdev = priv->dev;
 
-	netif_addr_lock(netdev);
+	netif_addr_lock_bh(netdev);
 
 	memcpy(&priv->local_gid.global.interface_id,
 	       &gid->global.interface_id,
@@ -1861,7 +1861,7 @@ static void set_base_guid(struct ipoib_dev_priv *priv, union ib_gid *gid)
 	memcpy(netdev->dev_addr + 4, &priv->local_gid, sizeof(priv->local_gid));
 	clear_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
 
-	netif_addr_unlock(netdev);
+	netif_addr_unlock_bh(netdev);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		down_read(&priv->vlan_rwsem);
@@ -1877,7 +1877,7 @@ static int ipoib_check_lladdr(struct net_device *dev,
 	union ib_gid *gid = (union ib_gid *)(ss->__data + 4);
 	int ret = 0;
 
-	netif_addr_lock(dev);
+	netif_addr_lock_bh(dev);
 
 	/* Make sure the QPN, reserved and subnet prefix match the current
 	 * lladdr, it also makes sure the lladdr is unicast.
@@ -1887,7 +1887,7 @@ static int ipoib_check_lladdr(struct net_device *dev,
 	    gid->global.interface_id == 0)
 		ret = -EINVAL;
 
-	netif_addr_unlock(dev);
+	netif_addr_unlock_bh(dev);
 
 	return ret;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 82fbc94..d3394b6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -582,13 +582,13 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		return;
 	}
 	priv->local_lid = port_attr.lid;
-	netif_addr_lock(dev);
+	netif_addr_lock_bh(dev);
 
 	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
-		netif_addr_unlock(dev);
+		netif_addr_unlock_bh(dev);
 		return;
 	}
-	netif_addr_unlock(dev);
+	netif_addr_unlock_bh(dev);
 
 	spin_lock_irq(&priv->lock);
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
