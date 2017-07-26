From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 02/11] IB/ipoib: Use cancel_delayed_work_sync when needed
Date: Wed, 26 Jul 2017 21:12:23 +0300
Message-ID: <20170726181232.7363-3-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The work mcast_task can re-queue itself, so instead of doing
cancel && flush_workqueue, that still can leave a queued task
on the air, use cancel_delayed_work_sync.

Also, no need to use lock over the cancel, the original lock was
due to bit assignment setting (IPOIB_MCAST_RUN) that is not in use
anymore.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 0a0b2ce45cbc..f80bf0f5d7cf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -684,15 +684,10 @@ void ipoib_mcast_start_thread(struct net_device *dev)
 int ipoib_mcast_stop_thread(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "stopping multicast thread\n");
 
-	spin_lock_irqsave(&priv->lock, flags);
-	cancel_delayed_work(&priv->mcast_task);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	flush_workqueue(priv->wq);
+	cancel_delayed_work_sync(&priv->mcast_task);
 
 	return 0;
 }
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
