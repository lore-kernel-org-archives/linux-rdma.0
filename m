From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/9] IB/ipoib: Fix memory corruption during ipoib cm connection establishment
Date: Sun, 28 Aug 2016 10:58:31 +0300
Message-ID: <1472371118-8260-3-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a new CM connection is being requested, ipoib driver copies data
from the path pointer in the CM/tx object, the path object might be
invalid at the point and memory corruption will happened later when now
the CM driver will try using that data.

The next scenario demonstrates it:
	neigh_add_path --> ipoib_cm_create_tx -->
	queue_work (pointer to path is in the cm/tx struct)
	#while the work is still in the queue,
	#the port goes down and causes the ipoib_flush_paths:
	ipoib_flush_paths --> path_free --> kfree(path)
	#at this point the work scheduled starts.
	ipoib_cm_tx_start --> copy from the (invalid)path pointer:
	(memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);)
	 -> memory corruption.

To fix that the driver now starts the CM/tx connection only if that
specific path exists in the general paths database.
This check is protected with the relevant locks, and uses the gid from
the neigh member in the CM/tx object which is valid according to the ref
count that was taken by the CM/tx.

Fixes: 839fcaba35 ('IPoIB: Connected mode experimental support')
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 16 ++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 4f7d9b4..9dbfcc0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -478,6 +478,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		struct ipoib_ah *address, u32 qpn);
 void ipoib_reap_ah(struct work_struct *work);
 
+struct ipoib_path *__path_find(struct net_device *dev, void *gid);
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
 int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 951d9ab..4ad297d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1318,6 +1318,8 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 	}
 }
 
+#define QPN_AND_OPTIONS_OFFSET	4
+
 static void ipoib_cm_tx_start(struct work_struct *work)
 {
 	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
@@ -1326,6 +1328,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 	struct ipoib_neigh *neigh;
 	struct ipoib_cm_tx *p;
 	unsigned long flags;
+	struct ipoib_path *path;
 	int ret;
 
 	struct ib_sa_path_rec pathrec;
@@ -1338,7 +1341,19 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		p = list_entry(priv->cm.start_list.next, typeof(*p), list);
 		list_del_init(&p->list);
 		neigh = p->neigh;
+
 		qpn = IPOIB_QPN(neigh->daddr);
+		/*
+		 * As long as the search is with these 2 locks,
+		 * path existence indicates its validity.
+		 */
+		path = __path_find(dev, neigh->daddr + QPN_AND_OPTIONS_OFFSET);
+		if (!path) {
+			pr_info("%s ignore not valid path %pI6\n",
+				__func__,
+				neigh->daddr + QPN_AND_OPTIONS_OFFSET);
+			goto free_neigh;
+		}
 		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
 
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1350,6 +1365,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		spin_lock_irqsave(&priv->lock, flags);
 
 		if (ret) {
+free_neigh:
 			neigh = p->neigh;
 			if (neigh) {
 				neigh->cm = NULL;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 74bcaa0..cc1c1b0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -485,7 +485,7 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 	return -EINVAL;
 }
 
-static struct ipoib_path *__path_find(struct net_device *dev, void *gid)
+struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node *n = priv->path_tree.rb_node;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
