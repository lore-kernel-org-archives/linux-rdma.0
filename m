From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 22/22] IB/ipoib: drop mcast_mutex usage
Date: Wed, 11 Feb 2015 20:43:45 -0500
Message-ID: <d2ae0fa10b8a98c8a8a1c6cf4c404369d2d5ed0e.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We needed the mcast_mutex when we had to protect two different workqueue
threads against stomping on each others work.  By no longer using
mcast->mc to directly store the return value of ib_sa_join_multicast, we
can switch all of the mcast flag/completion locking to being only the
priv->lock spinlock.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 55 +++++++++-----------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 355c320dc4d..e1fab519f96 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -55,8 +55,6 @@ MODULE_PARM_DESC(mcast_debug_level,
 		 "Enable multicast debug tracing if > 0");
 #endif
 
-static DEFINE_MUTEX(mcast_mutex);
-
 struct ipoib_mcast_iter {
 	struct net_device *dev;
 	union ib_gid       mgid;
@@ -340,16 +338,6 @@ static int ipoib_mcast_join_complete(int status,
 			"sendonly " : "",
 			mcast->mcmember.mgid.raw, status);
 
-	/*
-	 * We have to take the mutex to force mcast_join to
-	 * return from ib_sa_multicast_join and set mcast->mc to a
-	 * valid value.  Otherwise we were racing with ourselves in
-	 * that we might fail here, but get a valid return from
-	 * ib_sa_multicast_join after we had cleared mcast->mc here,
-	 * resulting in mis-matched joins and leaves and a deadlock
-	 */
-	mutex_lock(&mcast_mutex);
-
 	/* We trap for port events ourselves. */
 	if (status == -ENETRESET) {
 		status = 0;
@@ -410,11 +398,14 @@ static int ipoib_mcast_join_complete(int status,
 			__ipoib_mcast_continue_join_thread(priv, mcast, 1);
 	}
 out:
+	spin_lock_irq(&priv->lock);
 	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	if (status)
 		mcast->mc = NULL;
+	else
+		mcast->mc = multicast;
 	complete(&mcast->done);
-	mutex_unlock(&mcast_mutex);
+	spin_unlock_irq(&priv->lock);
 
 	return status;
 }
@@ -423,6 +414,7 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 			     int create)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_sa_multicast *multicast;
 	struct ib_sa_mcmember_rec rec = {
 		.join_state = 1
 	};
@@ -464,19 +456,20 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		rec.hop_limit	  = priv->broadcast->mcmember.hop_limit;
 	}
 
-	mutex_lock(&mcast_mutex);
-	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
+	multicast = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
 					 &rec, comp_mask, GFP_KERNEL,
 					 ipoib_mcast_join_complete, mcast);
-	if (IS_ERR(mcast->mc)) {
-		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-		complete(&mcast->done);
-		ret = PTR_ERR(mcast->mc);
+	if (IS_ERR(multicast)) {
+		ret = PTR_ERR(multicast);
+		mcast->mc = NULL;
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
+		spin_lock_irq(&priv->lock);
+		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 		/* Requeue this join task with a backoff delay */
 		__ipoib_mcast_continue_join_thread(priv, mcast, 1);
+		complete(&mcast->done);
+		spin_unlock_irq(&priv->lock);
 	}
-	mutex_unlock(&mcast_mutex);
 }
 
 void ipoib_mcast_join_task(struct work_struct *work)
@@ -505,15 +498,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
 
-	/*
-	 * We have to hold the mutex to keep from racing with the join
-	 * completion threads on setting flags on mcasts, and we have
-	 * to hold the priv->lock because dev_flush will remove entries
-	 * out from underneath us, so at a minimum we need the lock
-	 * through the time that we do the for_each loop of the mcast
-	 * list or else dev_flush can make us oops.
-	 */
-	mutex_lock(&mcast_mutex);
 	spin_lock_irq(&priv->lock);
 	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		goto out;
@@ -573,9 +557,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 				else
 					create = 1;
 				spin_unlock_irq(&priv->lock);
-				mutex_unlock(&mcast_mutex);
 				ipoib_mcast_join(dev, mcast, create);
-				mutex_lock(&mcast_mutex);
 				spin_lock_irq(&priv->lock);
 			} else if (!delay_until ||
 				 time_before(mcast->delay_until, delay_until))
@@ -597,7 +579,6 @@ out:
 		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	}
 	spin_unlock_irq(&priv->lock);
-	mutex_unlock(&mcast_mutex);
 	if (mcast)
 		ipoib_mcast_join(dev, mcast, create);
 	return;
@@ -606,13 +587,14 @@ out:
 int ipoib_mcast_start_thread(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "starting multicast thread\n");
 
-	mutex_lock(&mcast_mutex);
+	spin_lock_irqsave(&priv->lock, flags);
 	set_bit(IPOIB_MCAST_RUN, &priv->flags);
 	queue_delayed_work(priv->wq, &priv->mcast_task, 0);
-	mutex_unlock(&mcast_mutex);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
@@ -620,13 +602,14 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 int ipoib_mcast_stop_thread(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "stopping multicast thread\n");
 
-	mutex_lock(&mcast_mutex);
+	spin_lock_irqsave(&priv->lock, flags);
 	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
 	cancel_delayed_work(&priv->mcast_task);
-	mutex_unlock(&mcast_mutex);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	flush_workqueue(priv->wq);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
