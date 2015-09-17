From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/2] Add mechanism for ipoib neigh state change
 notifications
Date: Thu, 17 Sep 2015 09:42:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442486283-9699-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Could we simplify it a bit. This compiles but avoids all the
generalizations and workqueues. Had to export two new functions from
ipoib_multicast.c though.



Subject: ipoib: Expire sendonly multicast joins on neighbor expiration

Add mcast_leave functionality to __ipoib_reap_neighbor.

Based on Erez work.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c	2015-09-09 13:14:03.412350354 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c	2015-09-17 09:34:03.169844055 -0500
@@ -1149,6 +1149,8 @@ static void __ipoib_reap_neigh(struct ip
 	unsigned long dt;
 	unsigned long flags;
 	int i;
+	LIST_HEAD(remove_list);
+	struct ipoib_mcast *mcast, *tmcast;

 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
 		return;
@@ -1176,6 +1178,18 @@ static void __ipoib_reap_neigh(struct ip
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
+
+				/* Is this multicast ? */
+				if (neigh->daddr[4] == 0xff) {
+					mcast = __ipoib_mcast_find(priv->dev, neigh->daddr + 4);
+
+					if (mcast && test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
+						list_del(&mcast->list);
+						rb_erase(&mcast->rb_node, &priv->multicast_tree);
+						list_add_tail(&mcast->list, &remove_list);
+					}
+				}
+
 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
@@ -1191,6 +1205,8 @@ static void __ipoib_reap_neigh(struct ip

 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
+		ipoib_mcast_leave(priv->dev, mcast);
 }

 static void ipoib_reap_neigh(struct work_struct *work)
Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h	2015-09-09 13:14:03.412350354 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib.h	2015-09-17 09:36:17.342455845 -0500
@@ -548,6 +548,8 @@ void ipoib_path_iter_read(struct ipoib_p

 int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
 		       union ib_gid *mgid, int set_qkey);
+int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast);
+struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid);

 int ipoib_init_qp(struct net_device *dev);
 int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca);
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c	2015-09-09 13:14:03.412350354 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c	2015-09-17 09:36:55.305497262 -0500
@@ -153,7 +153,7 @@ static struct ipoib_mcast *ipoib_mcast_a
 	return mcast;
 }

-static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
+struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node *n = priv->multicast_tree.rb_node;
@@ -675,7 +675,7 @@ int ipoib_mcast_stop_thread(struct net_d
 	return 0;
 }

-static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
+int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
