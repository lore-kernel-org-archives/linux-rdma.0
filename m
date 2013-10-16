From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 4/7] IB/ipoib: Avoid flushing the driver work-queue on dev_down
Date: Wed, 16 Oct 2013 17:37:50 +0300
Message-ID: <1381934273-29683-5-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The driver should not flush the whole workqueue when only one work (the
pkey poll one) needs to be cancelled, use cancel_delayed_work_sync instead.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 01594de..ff64b16 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -749,10 +749,8 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
 		mutex_lock(&pkey_mutex);
 		set_bit(IPOIB_PKEY_STOP, &priv->flags);
-		cancel_delayed_work(&priv->pkey_poll_task);
+		cancel_delayed_work_sync(&priv->pkey_poll_task);
 		mutex_unlock(&pkey_mutex);
-		if (flush)
-			flush_workqueue(ipoib_workqueue);
 	}
 
 	ipoib_mcast_stop_thread(dev, flush);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
