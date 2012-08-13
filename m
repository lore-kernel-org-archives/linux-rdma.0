From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes 1/2] IB/ipoib: Add missing locking when CM object is deleted
Date: Mon, 13 Aug 2012 17:39:49 +0300
Message-ID: <1344868790-21146-2-git-send-email-ogerlitz@mellanox.com>
References: <1344868790-21146-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344868790-21146-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit b63b70d8 "IPoIB: Use a private hash table for path lookup
in xmit path" introduced a bug where in ipoib_cm_destroy_tx a CM object
is moved between lists without any supported locking, which results
in list poison error (under stress test) which eventually leads to
crash. Previouslly when this routine was called, ancestors functions
were taking the device priv lock. Currently this function is called from
the RCU callback associated with neighbour deletion. Fix that by
taking that very same lock we used to before.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 95ecf4e..24683fd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1271,12 +1271,15 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
+	unsigned long flags;
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
+		spin_lock_irqsave(&priv->lock, flags);
 		list_move(&tx->list, &priv->cm.reap_list);
 		queue_work(ipoib_workqueue, &priv->cm.reap_task);
 		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
 			  tx->neigh->daddr + 4);
 		tx->neigh = NULL;
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
