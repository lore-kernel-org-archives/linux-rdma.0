From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/ipoib: Remove the unnecessary error check
Date: Wed, 18 Jan 2017 23:16:06 -0500
Message-ID: <1484799366-3463-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function ipoib_mcast_start_thread/ipoib_ib_dev_up always return zero.
As such, in the function ipoib_open, err_stop will never be reached.
So remove this err_stop and change the return type of the function
ipoib_mcast_start_thread/ipoib_ib_dev_up to void.

Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 6 +-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 4 +---
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index da12717..1783695 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -500,7 +500,7 @@ void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);
 
 int ipoib_ib_dev_open(struct net_device *dev);
-int ipoib_ib_dev_up(struct net_device *dev);
+void ipoib_ib_dev_up(struct net_device *dev);
 int ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_pkey_dev_check_presence(struct net_device *dev);
@@ -513,7 +513,7 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work);
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
-int ipoib_mcast_start_thread(struct net_device *dev);
+void ipoib_mcast_start_thread(struct net_device *dev);
 int ipoib_mcast_stop_thread(struct net_device *dev);
 
 void ipoib_mcast_dev_down(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5038f9d..910228b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -755,7 +755,7 @@ void ipoib_pkey_dev_check_presence(struct net_device *dev)
 		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 }
 
-int ipoib_ib_dev_up(struct net_device *dev)
+void ipoib_ib_dev_up(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
@@ -763,12 +763,12 @@ int ipoib_ib_dev_up(struct net_device *dev)
 
 	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
 		ipoib_dbg(priv, "PKEY is not assigned.\n");
-		return 0;
+		return;
 	}
 
 	set_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
 
-	return ipoib_mcast_start_thread(dev);
+	ipoib_mcast_start_thread(dev);
 }
 
 int ipoib_ib_dev_down(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765..d68056f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -126,8 +126,7 @@ int ipoib_open(struct net_device *dev)
 		goto err_disable;
 	}
 
-	if (ipoib_ib_dev_up(dev))
-		goto err_stop;
+	ipoib_ib_dev_up(dev);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		struct ipoib_dev_priv *cpriv;
@@ -150,9 +149,6 @@ int ipoib_open(struct net_device *dev)
 
 	return 0;
 
-err_stop:
-	ipoib_ib_dev_stop(dev);
-
 err_disable:
 	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index fddff40..8d42d54 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -674,7 +674,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	spin_unlock_irq(&priv->lock);
 }
 
-int ipoib_mcast_start_thread(struct net_device *dev)
+void ipoib_mcast_start_thread(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned long flags;
@@ -684,8 +684,6 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 	spin_lock_irqsave(&priv->lock, flags);
 	__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
 }
 
 int ipoib_mcast_stop_thread(struct net_device *dev)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
