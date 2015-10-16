From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ipoib mcast sendonly join: Isolate common list remove code
Date: Fri, 16 Oct 2015 12:35:48 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1510161234060.27368@east.gentwo.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: ipoib mcast sendonly join: Isolate common list remove code

Code cleanup to remove multicast specific code from ipoib_main.c

The removal of a list of multicast groups occurs in three places.
Create a new function ipoib_mcast_remove_list(). Use this new
function in ipoib_main.c too.
That in turn allows the dropping of two functions that were
exported from ipoib_multicast.c for expiration of mc groups.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h
+++ linux/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -495,7 +495,6 @@ void ipoib_dev_cleanup(struct net_device
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
-void ipoib_mcast_free(struct ipoib_mcast *mc);

 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
@@ -549,7 +548,7 @@ void ipoib_path_iter_read(struct ipoib_p

 int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
 		       union ib_gid *mgid, int set_qkey);
-int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast);
+void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list);
 struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid);

 int ipoib_init_qp(struct net_device *dev);
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1150,7 +1150,7 @@ static void __ipoib_reap_neigh(struct ip
 	unsigned long flags;
 	int i;
 	LIST_HEAD(remove_list);
-	struct ipoib_mcast *mcast, *tmcast;
+	struct ipoib_mcast *mcast;
 	struct net_device *dev = priv->dev;

 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
@@ -1207,10 +1207,7 @@ static void __ipoib_reap_neigh(struct ip

 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
-		ipoib_mcast_leave(dev, mcast);
-		ipoib_mcast_free(mcast);
-	}
+	ipoib_mcast_remove_list(dev, &remove_list);
 }

 static void ipoib_reap_neigh(struct work_struct *work)
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -106,7 +106,7 @@ static void __ipoib_mcast_schedule_join_
 		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 }

-void ipoib_mcast_free(struct ipoib_mcast *mcast)
+static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
 	int tx_dropped = 0;
@@ -677,7 +677,7 @@ int ipoib_mcast_stop_thread(struct net_d
 	return 0;
 }

-int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
+static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret = 0;
@@ -704,6 +704,16 @@ int ipoib_mcast_leave(struct net_device
 	return 0;
 }

+void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list)
+{
+	struct ipoib_mcast *mcast, *tmcast;
+
+	list_for_each_entry_safe(mcast, tmcast, remove_list, list) {
+		ipoib_mcast_leave(dev, mcast);
+		ipoib_mcast_free(mcast);
+	}
+}
+
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -810,10 +820,7 @@ void ipoib_mcast_dev_flush(struct net_de
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			wait_for_completion(&mcast->done);

-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
-		ipoib_mcast_leave(dev, mcast);
-		ipoib_mcast_free(mcast);
-	}
+	ipoib_mcast_remove_list(dev, &remove_list);
 }

 static int ipoib_mcast_addr_is_valid(const u8 *addr, const u8 *broadcast)
@@ -939,10 +946,7 @@ void ipoib_mcast_restart_task(struct wor
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			wait_for_completion(&mcast->done);

-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
-		ipoib_mcast_leave(mcast->dev, mcast);
-		ipoib_mcast_free(mcast);
-	}
+	ipoib_mcast_remove_list(mcast->dev, &remove_list);

 	/*
 	 * Double check that we are still up
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
