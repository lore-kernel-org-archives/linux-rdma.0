From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/ipoib: Remove IPOIB_MCAST_RUN bit
Date: Thu,  2 Apr 2015 13:39:04 +0300
Message-ID: <1427971145-26943-6-git-send-email-ogerlitz@mellanox.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

After Doug Ledford's changes there is no need in that bit, it's
semantic becomes subset of the IPOIB_FLAG_OPER_UP bit.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 2703d9a..bd94b0a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -87,7 +87,6 @@ enum {
 	IPOIB_FLAG_ADMIN_UP	  = 2,
 	IPOIB_PKEY_ASSIGNED	  = 3,
 	IPOIB_FLAG_SUBINTERFACE	  = 5,
-	IPOIB_MCAST_RUN		  = 6,
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
 	IPOIB_FLAG_UMCAST	  = 10,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index c83c958..0d23e05 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -71,7 +71,7 @@ static void __ipoib_mcast_schedule_join_thread(struct ipoib_dev_priv *priv,
 					       struct ipoib_mcast *mcast,
 					       bool delay)
 {
-	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
+	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
 		return;
 
 	/*
@@ -519,7 +519,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	struct ipoib_mcast *mcast = NULL;
 	int create = 1;
 
-	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
+	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
 		return;
 
 	if (ib_query_port(priv->ca, priv->port, &port_attr) ||
@@ -629,7 +629,6 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 	ipoib_dbg_mcast(priv, "starting multicast thread\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
-	set_bit(IPOIB_MCAST_RUN, &priv->flags);
 	__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -644,7 +643,6 @@ int ipoib_mcast_stop_thread(struct net_device *dev)
 	ipoib_dbg_mcast(priv, "stopping multicast thread\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
-	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
 	cancel_delayed_work(&priv->mcast_task);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
