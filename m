From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/31] IB/ipoib: Update pathrec field if not valid record
Date: Tue, 14 Nov 2017 14:51:54 +0200
Message-ID: <20171114125218.20477-8-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case that the PathRecord is not valid (SM changed its network prefix)
ipoib will continue issue PathQuery requests with the same parameters
that are in its database, which are no longer valid anymore.

Now the driver in that case will re-initialize the record from a valid
place (the priv structure keeps the updated values), and a valid request
will be issued.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 49 +++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b173d618c59c..33f592cee5d8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -850,6 +850,23 @@ static void path_rec_completion(int status,
 	}
 }
 
+static void init_path_rec(struct ipoib_dev_priv *priv, struct ipoib_path *path,
+			  void *gid)
+{
+	path->dev = priv->dev;
+
+	if (rdma_cap_opa_ah(priv->ca, priv->port))
+		path->pathrec.rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		path->pathrec.rec_type = SA_PATH_REC_TYPE_IB;
+
+	memcpy(path->pathrec.dgid.raw, gid, sizeof(union ib_gid));
+	path->pathrec.sgid	    = priv->local_gid;
+	path->pathrec.pkey	    = cpu_to_be16(priv->pkey);
+	path->pathrec.numb_path     = 1;
+	path->pathrec.traffic_class = priv->broadcast->mcmember.traffic_class;
+}
+
 static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -862,21 +879,11 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	if (!path)
 		return NULL;
 
-	path->dev = dev;
-
 	skb_queue_head_init(&path->queue);
 
 	INIT_LIST_HEAD(&path->neigh_list);
 
-	if (rdma_cap_opa_ah(priv->ca, priv->port))
-		path->pathrec.rec_type = SA_PATH_REC_TYPE_OPA;
-	else
-		path->pathrec.rec_type = SA_PATH_REC_TYPE_IB;
-	memcpy(path->pathrec.dgid.raw, gid, sizeof (union ib_gid));
-	path->pathrec.sgid	    = priv->local_gid;
-	path->pathrec.pkey	    = cpu_to_be16(priv->pkey);
-	path->pathrec.numb_path     = 1;
-	path->pathrec.traffic_class = priv->broadcast->mcmember.traffic_class;
+	init_path_rec(priv, path, gid);
 
 	return path;
 }
@@ -1005,6 +1012,10 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+	/* no broadcast means that all paths are (going to be) not valid */
+	if (!priv->broadcast)
+		goto drop_and_unlock;
+
 	path = __path_find(dev, phdr->hwaddr + 4);
 	if (!path || !path->valid) {
 		int new_path = 0;
@@ -1014,6 +1025,10 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			new_path = 1;
 		}
 		if (path) {
+			if (!new_path)
+				/* make sure there is no changes in the existing path record */
+				init_path_rec(priv, path, phdr->hwaddr + 4);
+
 			if (skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
 				push_pseudo_header(skb, phdr->hwaddr);
 				__skb_queue_tail(&path->queue, skb);
@@ -1030,8 +1045,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			} else
 				__path_add(dev, path);
 		} else {
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
+			goto drop_and_unlock;
 		}
 
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1051,11 +1065,16 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 		push_pseudo_header(skb, phdr->hwaddr);
 		__skb_queue_tail(&path->queue, skb);
 	} else {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
+		goto drop_and_unlock;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
+	return;
+
+drop_and_unlock:
+	++dev->stats.tx_dropped;
+	dev_kfree_skb_any(skb);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
