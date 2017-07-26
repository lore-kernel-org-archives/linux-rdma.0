From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 05/11] IB/ipoib: Set IPOIB_NEIGH_TBL_FLUSH after flushed completion initialization
Date: Wed, 26 Jul 2017 21:12:26 +0300
Message-ID: <20170726181232.7363-6-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set IPOIB_NEIGH_TBL_FLUSH bit after initializing the neighbor
flushed completion, otherwise the garbage collector may signal
a completion while it is not initialized yet.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8b7ec15a9d6e..f4403c52cd67 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1560,6 +1560,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 	int i, wait_flushed = 0;
 
 	init_completion(&priv->ntbl.flushed);
+	set_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -1604,7 +1605,6 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 
 	ipoib_dbg(priv, "ipoib_neigh_hash_uninit\n");
 	init_completion(&priv->ntbl.deleted);
-	set_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
 
 	/* Stop GC if called at init fail need to cancel work */
 	stopped = test_and_set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
