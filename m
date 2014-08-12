From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/8] IPoIB: Consolidate rtnl_lock tasks in workqueue
Date: Tue, 12 Aug 2014 19:38:08 -0400
Message-ID: <2394730ce5ae1d46522dca04066293dd842edf16.1407885724.git.dledford@redhat.com>
References: <cover.1407885724.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Setting the mtu can safely be moved to the carrier_on_task, which keeps
us from needing to take the rtnl lock in the join_finish section.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index d4e005720d0..a0a42859f12 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -190,12 +190,6 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 		set_qkey = 1;
-
-		if (!ipoib_cm_admin_enabled(dev)) {
-			rtnl_lock();
-			dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
-			rtnl_unlock();
-		}
 	}
 
 	if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
@@ -371,6 +365,8 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
 	}
 
 	rtnl_lock();
+	if (!ipoib_cm_admin_enabled(priv->dev))
+		dev_set_mtu(priv->dev, min(priv->mcast_mtu, priv->admin_mtu));
 	netif_carrier_on(priv->dev);
 	rtnl_unlock();
 }
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
