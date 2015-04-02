From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/ipoib: Save only IPOIB_MAX_PATH_REC_QUEUE skb's
Date: Thu,  2 Apr 2015 13:39:03 +0300
Message-ID: <1427971145-26943-5-git-send-email-ogerlitz@mellanox.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Whenever there is no path->ah to the destination, keep only defined
number of skb's. Otherwise there are cases that the driver can keep
infinite list of skb's.

For example, when one device want to send unicast arp to the destination,
and from some reason the SM doesn't respond, the driver currently keeps
all the skb's. If that unicast arp traffic stopped, all  these skb's
are kept by the path object till the interface is down.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 26e0eed..0d46100 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -640,8 +640,10 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 
 		if (!path->query && path_rec_start(dev, path))
 			goto err_path;
-
-		__skb_queue_tail(&neigh->queue, skb);
+		if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
+			__skb_queue_tail(&neigh->queue, skb);
+		else
+			goto err_drop;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -676,7 +678,12 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			new_path = 1;
 		}
 		if (path) {
-			__skb_queue_tail(&path->queue, skb);
+			if (skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
+				__skb_queue_tail(&path->queue, skb);
+			} else {
+				++dev->stats.tx_dropped;
+				dev_kfree_skb_any(skb);
+			}
 
 			if (!path->query && path_rec_start(dev, path)) {
 				spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
