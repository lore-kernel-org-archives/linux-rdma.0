From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Move multicast specific code out of ipoib_main.c
Date: Mon, 21 Dec 2015 08:42:54 -0600
Message-ID: <20151221144303.455957565@linux.com>
References: <20151221144252.575119561@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0002-Move-multicast-specific-code-out-of-ipoib_main.c.patch
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

V1->V2:
	- Rename function as requested by Ira

Code cleanup to move multicast specific code that checks for
a sendonly join to ipoib_multicast.c. This allows the removal
of the export of __ipoib_mcast_find().

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  3 ++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 13 +------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 21 ++++++++++++++++++++-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 989c409..a924933 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -549,7 +549,8 @@ void ipoib_path_iter_read(struct ipoib_path_iter *iter,
 int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
 		       union ib_gid *mgid, int set_qkey);
 void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list);
-struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid);
+void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
+				struct list_head *remove_list);
 
 int ipoib_init_qp(struct net_device *dev);
 int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 483ff20..620d9ca 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1150,7 +1150,6 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 	unsigned long flags;
 	int i;
 	LIST_HEAD(remove_list);
-	struct ipoib_mcast *mcast;
 	struct net_device *dev = priv->dev;
 
 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
@@ -1179,18 +1178,8 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
-				u8 *mgid = neigh->daddr + 4;
 
-				/* Is this multicast ? */
-				if (*mgid == 0xff) {
-					mcast = __ipoib_mcast_find(dev, mgid);
-
-					if (mcast && test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
-						list_del(&mcast->list);
-						rb_erase(&mcast->rb_node, &priv->multicast_tree);
-						list_add_tail(&mcast->list, &remove_list);
-					}
-				}
+				ipoib_check_and_add_mcast_sendonly(priv, neigh->daddr + 4, &remove_list);
 
 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 8acb420a..ab79b87 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -153,7 +153,7 @@ static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev,
 	return mcast;
 }
 
-struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
+static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node *n = priv->multicast_tree.rb_node;
@@ -704,6 +704,25 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
+/*
+ * Check if the multicast group is sendonly. If so remove it from the maps
+ * and add to the remove list
+ */
+void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
+				struct list_head *remove_list)
+{
+	/* Is this multicast ? */
+	if (*mgid == 0xff) {
+		struct ipoib_mcast *mcast = __ipoib_mcast_find(priv->dev, mgid);
+
+		if (mcast && test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
+			list_del(&mcast->list);
+			rb_erase(&mcast->rb_node, &priv->multicast_tree);
+			list_add_tail(&mcast->list, remove_list);
+		}
+	}
+}
+
 void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list)
 {
 	struct ipoib_mcast *mcast, *tmcast;
-- 
2.5.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
