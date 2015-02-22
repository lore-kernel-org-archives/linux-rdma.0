From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/9] IB/ipoib: No longer use flush as a parameter
Date: Sat, 21 Feb 2015 19:27:04 -0500
Message-ID: <4ada146308b03bcdb466ebc78f19b81796d47cf9.1424562072.git.dledford@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Various places in the IPoIB code had a deadlock related to flushing
the ipoib workqueue.  Now that we have per device workqueues and a
specific flush workqueue, there is no longer a deadlock issue with
flushing the device specific workqueues and we can do so unilaterally.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  8 +++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 35 +++++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  8 +++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 18 ++++++++++---
 4 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index e940cd9f847..9ef432ae72e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -478,10 +478,10 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work);
 void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);
 
-int ipoib_ib_dev_open(struct net_device *dev, int flush);
+int ipoib_ib_dev_open(struct net_device *dev);
 int ipoib_ib_dev_up(struct net_device *dev);
-int ipoib_ib_dev_down(struct net_device *dev, int flush);
-int ipoib_ib_dev_stop(struct net_device *dev, int flush);
+int ipoib_ib_dev_down(struct net_device *dev);
+int ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_pkey_dev_check_presence(struct net_device *dev);
 
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
@@ -493,7 +493,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
-int ipoib_mcast_stop_thread(struct net_device *dev, int flush);
+int ipoib_mcast_stop_thread(struct net_device *dev);
 
 void ipoib_mcast_dev_down(struct net_device *dev);
 void ipoib_mcast_dev_flush(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2a56b7a11a9..e144d07d53c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -659,22 +659,21 @@ void ipoib_reap_ah(struct work_struct *work)
 				   round_jiffies_relative(HZ));
 }
 
-static void ipoib_flush_ah(struct net_device *dev, int flush)
+static void ipoib_flush_ah(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	cancel_delayed_work(&priv->ah_reap_task);
-	if (flush)
-		flush_workqueue(priv->wq);
+	flush_workqueue(priv->wq);
 	ipoib_reap_ah(&priv->ah_reap_task.work);
 }
 
-static void ipoib_stop_ah(struct net_device *dev, int flush)
+static void ipoib_stop_ah(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	ipoib_flush_ah(dev, flush);
+	ipoib_flush_ah(dev);
 }
 
 static void ipoib_ib_tx_timer_func(unsigned long ctx)
@@ -682,7 +681,7 @@ static void ipoib_ib_tx_timer_func(unsigned long ctx)
 	drain_tx_cq((struct net_device *)ctx);
 }
 
-int ipoib_ib_dev_open(struct net_device *dev, int flush)
+int ipoib_ib_dev_open(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
@@ -724,7 +723,7 @@ int ipoib_ib_dev_open(struct net_device *dev, int flush)
 dev_stop:
 	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_enable(&priv->napi);
-	ipoib_ib_dev_stop(dev, flush);
+	ipoib_ib_dev_stop(dev);
 	return -1;
 }
 
@@ -756,7 +755,7 @@ int ipoib_ib_dev_up(struct net_device *dev)
 	return ipoib_mcast_start_thread(dev);
 }
 
-int ipoib_ib_dev_down(struct net_device *dev, int flush)
+int ipoib_ib_dev_down(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
@@ -765,7 +764,7 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
 	netif_carrier_off(dev);
 
-	ipoib_mcast_stop_thread(dev, flush);
+	ipoib_mcast_stop_thread(dev);
 	ipoib_mcast_dev_flush(dev);
 
 	ipoib_flush_paths(dev);
@@ -825,7 +824,7 @@ void ipoib_drain_cq(struct net_device *dev)
 	local_bh_enable();
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev, int flush)
+int ipoib_ib_dev_stop(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_attr qp_attr;
@@ -895,7 +894,7 @@ timeout:
 	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
 		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
 
-	ipoib_flush_ah(dev, flush);
+	ipoib_flush_ah(dev);
 
 	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
 
@@ -919,7 +918,7 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		    (unsigned long) dev);
 
 	if (dev->flags & IFF_UP) {
-		if (ipoib_ib_dev_open(dev, 1)) {
+		if (ipoib_ib_dev_open(dev)) {
 			ipoib_transport_dev_cleanup(dev);
 			return -ENODEV;
 		}
@@ -1038,16 +1037,16 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	if (level == IPOIB_FLUSH_LIGHT) {
 		ipoib_mark_paths_invalid(dev);
 		ipoib_mcast_dev_flush(dev);
-		ipoib_flush_ah(dev, 0);
+		ipoib_flush_ah(dev);
 	}
 
 	if (level >= IPOIB_FLUSH_NORMAL)
-		ipoib_ib_dev_down(dev, 0);
+		ipoib_ib_dev_down(dev);
 
 	if (level == IPOIB_FLUSH_HEAVY) {
 		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
-			ipoib_ib_dev_stop(dev, 0);
-		if (ipoib_ib_dev_open(dev, 0) != 0)
+			ipoib_ib_dev_stop(dev);
+		if (ipoib_ib_dev_open(dev) != 0)
 			return;
 		if (netif_queue_stopped(dev))
 			netif_start_queue(dev);
@@ -1099,7 +1098,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	 */
 	ipoib_flush_paths(dev);
 
-	ipoib_mcast_stop_thread(dev, 1);
+	ipoib_mcast_stop_thread(dev);
 	ipoib_mcast_dev_flush(dev);
 
 	/*
@@ -1108,7 +1107,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	 * the neighbor garbage collection is stopped and reaped.
 	 * That should all be done now, so make a final ah flush.
 	 */
-	ipoib_stop_ah(dev, 1);
+	ipoib_stop_ah(dev);
 
 	ipoib_transport_dev_cleanup(dev);
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 64effe4faf7..26e0eedc2c6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -108,7 +108,7 @@ int ipoib_open(struct net_device *dev)
 
 	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
-	if (ipoib_ib_dev_open(dev, 1)) {
+	if (ipoib_ib_dev_open(dev)) {
 		if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
 			return 0;
 		goto err_disable;
@@ -139,7 +139,7 @@ int ipoib_open(struct net_device *dev)
 	return 0;
 
 err_stop:
-	ipoib_ib_dev_stop(dev, 1);
+	ipoib_ib_dev_stop(dev);
 
 err_disable:
 	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
@@ -157,8 +157,8 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ipoib_ib_dev_down(dev, 1);
-	ipoib_ib_dev_stop(dev, 0);
+	ipoib_ib_dev_down(dev);
+	ipoib_ib_dev_stop(dev);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		struct ipoib_dev_priv *cpriv;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 9d3c1ed576e..bb1b69904f9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -613,7 +613,7 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 	return 0;
 }
 
-int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
+int ipoib_mcast_stop_thread(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
@@ -624,8 +624,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
 	cancel_delayed_work(&priv->mcast_task);
 	mutex_unlock(&mcast_mutex);
 
-	if (flush)
-		flush_workqueue(priv->wq);
+	flush_workqueue(priv->wq);
 
 	return 0;
 }
@@ -797,7 +796,18 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 
 	ipoib_dbg_mcast(priv, "restarting multicast task\n");
 
-	ipoib_mcast_stop_thread(dev, 0);
+	/*
+	 * We're running on the priv->wq right now, so we can't call
+	 * mcast_stop_thread as it wants to flush the wq and that
+	 * will deadlock.  We don't actually *need* to stop the
+	 * thread here anyway, so just clear the run flag, cancel
+	 * any delayed work, do our work, remove the old entries,
+	 * then restart the thread.
+	 */
+	mutex_lock(&mcast_mutex);
+	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
+	cancel_delayed_work(&priv->mcast_task);
+	mutex_unlock(&mcast_mutex);
 
 	local_irq_save(flags);
 	netif_addr_lock(dev);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
