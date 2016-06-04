From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for unresolved entries
Date: Sat,  4 Jun 2016 15:15:19 +0300
Message-ID: <1465042524-25852-3-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ipoib_neigh_get whenever tries to access specific neigh updates its
"alive" variable member, the neigh now considered as updated and won't
be cleaned by the GC process even if it needs to be resolved again.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2d7c163..c558c32 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1206,7 +1206,9 @@ struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 				neigh = NULL;
 				goto out_unlock;
 			}
-			neigh->alive = jiffies;
+
+			if (likely(skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE))
+				neigh->alive = jiffies;
 			goto out_unlock;
 		}
 	}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
