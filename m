From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IPoIB: fix faulty list maintenance in path and neigh list
Date: Tue, 01 Feb 2011 11:12:47 -0500
Message-ID: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Added list_del to ipoib_mcast_free() and path_free() to remove the neigh from
the path's neigh_list link list before freeing the memory it consumes.
This makes the code consistent with ipoib_cm_handle_tx_wc() and other locations where the list_del() preceeds the call to ipoib_neigh_free().

Similarly, at list_del() now preceeds path_free() to remove the path from
ipoib_dev_priv's path_list.

Additionally, the fields neigh->ah and neigh->list were not being initialized
upon allocation.  The patch insures that these two remaining fields are
initialized correctly.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    4 ++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9ff7bc7..ddd52f6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -283,6 +283,7 @@ static void path_free(struct net_device *dev, struct ipoib_path *path)
 		if (neigh->ah)
 			ipoib_put_ah(neigh->ah);
 
+		list_del(&neigh->list);
 		ipoib_neigh_free(dev, neigh);
 	}
 
@@ -390,6 +391,7 @@ void ipoib_flush_paths(struct net_device *dev)
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 		wait_for_completion(&path->done);
+		list_del(&path->list);
 		path_free(dev, path);
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
@@ -882,12 +884,14 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 	if (!neigh)
 		return NULL;
 
+	neigh->ah = NULL;
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
 	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
 	*to_ipoib_neigh(neighbour) = neigh;
 	skb_queue_head_init(&neigh->queue);
 	ipoib_cm_set(neigh, NULL);
+	INIT_LIST_HEAD(&neigh->list);
 
 	return neigh;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..05f4c9a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -86,6 +86,7 @@ static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 		 */
 		if (neigh->ah)
 			ipoib_put_ah(neigh->ah);
+		list_del(&neigh->list);
 		ipoib_neigh_free(dev, neigh);
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
