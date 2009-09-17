From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH] IB/ipoib: Do not turn on carrier  to a non active port
Date: Thu, 17 Sep 2009 13:16:12 +0300
Message-ID: <4AB20C6C.9090005@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This patch fixes https://bugs.openfabrics.org/show_bug.cgi?id=1726
Multicast join can succeed even if IB port is down. This happens when OpenSM
runs on the same port as the requesting port. IPoIB on the other hand, calls
netif_carrier_on() when join succeeded without caring about the state of
the IB port. The result is - an IPoIB interface in RUNNING state but without
active IB port to support it. If a bonding interface uses this IPoIB interface
as a slave it might not detect that this slave is almost useless and failover
functionality will be damaged.
The fix here is to check the state of the IB port in the carrier_task before
calling netif_carrier_on().

Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    2 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   13 +++++++++++--
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..f29ce14 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -292,7 +292,7 @@ struct ipoib_dev_priv {
 
 	struct delayed_work pkey_poll_task;
 	struct delayed_work mcast_task;
-	struct work_struct carrier_on_task;
+	struct delayed_work  carrier_on_task;
 	struct work_struct flush_light;
 	struct work_struct flush_normal;
 	struct work_struct flush_heavy;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index e35f4a0..c452089 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -724,6 +724,8 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 	ipoib_dbg(priv, "downing ib_dev\n");
 
 	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
+	cancel_delayed_work(&priv->carrier_on_task);
+
 	netif_carrier_off(dev);
 
 	/* Shutdown the P_Key thread if still active */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2bf5116..5242e0d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1079,7 +1079,7 @@ static void ipoib_setup(struct net_device *dev)
 
 	INIT_DELAYED_WORK(&priv->pkey_poll_task, ipoib_pkey_poll);
 	INIT_DELAYED_WORK(&priv->mcast_task,   ipoib_mcast_join_task);
-	INIT_WORK(&priv->carrier_on_task, ipoib_mcast_carrier_on_task);
+	INIT_DELAYED_WORK(&priv->carrier_on_task, ipoib_mcast_carrier_on_task);
 	INIT_WORK(&priv->flush_light,   ipoib_ib_dev_flush_light);
 	INIT_WORK(&priv->flush_normal,   ipoib_ib_dev_flush_normal);
 	INIT_WORK(&priv->flush_heavy,   ipoib_ib_dev_flush_heavy);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 25874fc..b4b4016 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -361,13 +361,22 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 void ipoib_mcast_carrier_on_task(struct work_struct *work)
 {
 	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
-						   carrier_on_task);
+						   carrier_on_task.work);
+	struct ib_port_attr attr;
 
 	/*
 	 * Take rtnl_lock to avoid racing with ipoib_stop() and
 	 * turning the carrier back on while a device is being
 	 * removed.
 	 */
+
+	if (ib_query_port(priv->ca, priv->port, &attr) ||
+		attr.state != IB_PORT_ACTIVE) {
+		ipoib_dbg(priv, "wait with carrier until IB port is active\n");
+		if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+			queue_delayed_work(ipoib_workqueue, &priv->carrier_on_task, HZ);
+		return;
+	}
 	rtnl_lock();
 	netif_carrier_on(priv->dev);
 	rtnl_unlock();
@@ -403,7 +412,7 @@ static int ipoib_mcast_join_complete(int status,
 		 * deadlock on rtnl_lock here.
 		 */
 		if (mcast == priv->broadcast)
-			queue_work(ipoib_workqueue, &priv->carrier_on_task);
+			queue_delayed_work(ipoib_workqueue, &priv->carrier_on_task, 0);
 
 		return 0;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
