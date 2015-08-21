From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Fri, 21 Aug 2015 17:34:12 -0600
Message-ID: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Even though we don't expect the group to be created by the SM we
sill need to provide all the parameters to force the SM to validate
they are correct.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 47 +++++++++++++++++---------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 0d23e0568deb..c0e702c577d5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -448,8 +448,8 @@ out_locked:
 	return status;
 }
 
-static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
-			     int create)
+/* priv->lock must be held when calling */
+static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_sa_multicast *multicast;
@@ -471,7 +471,14 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		IB_SA_MCMEMBER_REC_PKEY		|
 		IB_SA_MCMEMBER_REC_JOIN_STATE;
 
-	if (create) {
+	if (mcast != priv->broadcast) {
+		/*
+		 * RFC 4391:
+		 *  The MGID MUST use the same P_Key, Q_Key, SL, MTU,
+		 *  and HopLimit as those used in the broadcast-GID.  The rest
+		 *  of attributes SHOULD follow the values used in the
+		 *  broadcast-GID as well.
+		 */
 		comp_mask |=
 			IB_SA_MCMEMBER_REC_QKEY			|
 			IB_SA_MCMEMBER_REC_MTU_SELECTOR		|
@@ -492,19 +499,35 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		rec.sl		  = priv->broadcast->mcmember.sl;
 		rec.flow_label	  = priv->broadcast->mcmember.flow_label;
 		rec.hop_limit	  = priv->broadcast->mcmember.hop_limit;
+
+		/*
+		 * Historically Linux IPoIB has never properly supported SEND
+		 * ONLY join. It emulated it by not providing all the required
+		 * attributes, which is enough to prevent group creation and
+		 * detect if there are full members or not. A major problem
+		 * with supporting SEND ONLY is detecting when the group is
+		 * auto-destroyed as IPoIB will cache the MLID..
+		 */
+#if 1
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+			comp_mask &= ~IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
+#else
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+			rec.join_state = 4;
+#endif
 	}
 
+	spin_unlock_irq(&priv->lock);
 	multicast = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
 					 &rec, comp_mask, GFP_KERNEL,
 					 ipoib_mcast_join_complete, mcast);
+	spin_lock_irq(&priv->lock);
 	if (IS_ERR(multicast)) {
 		ret = PTR_ERR(multicast);
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
-		spin_lock_irq(&priv->lock);
 		/* Requeue this join task with a backoff delay */
 		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 	}
 }
@@ -517,7 +540,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	struct ib_port_attr port_attr;
 	unsigned long delay_until = 0;
 	struct ipoib_mcast *mcast = NULL;
-	int create = 1;
 
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
 		return;
@@ -566,7 +588,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		if (IS_ERR_OR_NULL(priv->broadcast->mc) &&
 		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags)) {
 			mcast = priv->broadcast;
-			create = 0;
 			if (mcast->backoff > 1 &&
 			    time_before(jiffies, mcast->delay_until)) {
 				delay_until = mcast->delay_until;
@@ -590,13 +611,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 				/* Found the next unjoined group */
 				init_completion(&mcast->done);
 				set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-				if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
-					create = 0;
-				else
-					create = 1;
-				spin_unlock_irq(&priv->lock);
-				ipoib_mcast_join(dev, mcast, create);
-				spin_lock_irq(&priv->lock);
+				ipoib_mcast_join(dev, mcast);
 			} else if (!delay_until ||
 				 time_before(mcast->delay_until, delay_until))
 				delay_until = mcast->delay_until;
@@ -616,9 +631,9 @@ out:
 		init_completion(&mcast->done);
 		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	}
-	spin_unlock_irq(&priv->lock);
 	if (mcast)
-		ipoib_mcast_join(dev, mcast, create);
+		ipoib_mcast_join(dev, mcast);
+	spin_unlock_irq(&priv->lock);
 }
 
 int ipoib_mcast_start_thread(struct net_device *dev)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
