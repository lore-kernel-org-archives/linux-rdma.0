From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/22] IB/ipoib: Add a helper to restart the multicast task
Date: Wed, 11 Feb 2015 20:43:33 -0500
Message-ID: <930178ab8a03be9a3934c68214a8e54aaf2df445.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a simple helper to do the right thing when restarting
the multicast thread.  Call that helper from all the places
that need to restart the thread.  Add two places that didn't
restart the thread, but should have.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 46 ++++++++++++++++----------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 91b8fe118ec..cb1e495bd74 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -66,6 +66,13 @@ struct ipoib_mcast_iter {
 	unsigned int       send_only;
 };
 
+static void __ipoib_mcast_continue_join_thread(struct ipoib_dev_priv *priv,
+					       int delay)
+{
+	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
+		queue_delayed_work(priv->wq, &priv->mcast_task, delay);
+}
+
 static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
@@ -270,6 +277,7 @@ ipoib_mcast_sendonly_join_complete(int status,
 {
 	struct ipoib_mcast *mcast = multicast->context;
 	struct net_device *dev = mcast->dev;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/*
 	 * We have to take the mutex to force mcast_sendonly_join to
@@ -309,6 +317,7 @@ out:
 	complete(&mcast->done);
 	if (status == -ENETRESET)
 		status = 0;
+	__ipoib_mcast_continue_join_thread(priv, 0);
 	mutex_unlock(&mcast_mutex);
 	return status;
 }
@@ -360,6 +369,7 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 		complete(&mcast->done);
 		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
 			   "failed (ret = %d)\n", ret);
+		__ipoib_mcast_continue_join_thread(priv, 0);
 	} else {
 		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
 				"sendonly join\n", mcast->mcmember.mgid.raw);
@@ -431,8 +441,7 @@ static int ipoib_mcast_join_complete(int status,
 
 	if (!status) {
 		mcast->backoff = 1;
-		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+		__ipoib_mcast_continue_join_thread(priv, 0);
 
 		/*
 		 * Defer carrier on work to priv->wq to avoid a
@@ -454,6 +463,13 @@ static int ipoib_mcast_join_complete(int status,
 		mcast->backoff *= 2;
 		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
 			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
+		/*
+		 * XXX - This is wrong.  *Our* join failed, but because the
+		 * join thread does the joins in a serial fashion, if there
+		 * are any joins behind ours waiting to complete, they should
+		 * not be subjected to our backoff delay.
+		 */
+		__ipoib_mcast_continue_join_thread(priv, mcast->backoff * HZ);
 	}
 out:
 	spin_lock_irq(&priv->lock);
@@ -463,9 +479,6 @@ out:
 	complete(&mcast->done);
 	if (status == -ENETRESET)
 		status = 0;
-	if (status && test_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(priv->wq, &priv->mcast_task,
-				   mcast->backoff * HZ);
 	spin_unlock_irq(&priv->lock);
 	mutex_unlock(&mcast_mutex);
 
@@ -532,10 +545,13 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		mcast->backoff *= 2;
 		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
 			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
-
-		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task,
-					   mcast->backoff * HZ);
+		/*
+		 * XXX - This is wrong.  *Our* join failed, but because the
+		 * join thread does the joins in a serial fashion, if there
+		 * are any joins behind ours waiting to complete, they should
+		 * not be subjected to our backoff delay.
+		 */
+		__ipoib_mcast_continue_join_thread(priv, mcast->backoff * HZ);
 	}
 	mutex_unlock(&mcast_mutex);
 }
@@ -573,9 +589,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		if (!broadcast) {
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
 			mutex_lock(&mcast_mutex);
-			if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-				queue_delayed_work(priv->wq, &priv->mcast_task,
-						   HZ);
+			__ipoib_mcast_continue_join_thread(priv, HZ);
 			mutex_unlock(&mcast_mutex);
 			return;
 		}
@@ -723,8 +737,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
-		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+		__ipoib_mcast_continue_join_thread(priv, 0);
 	}
 
 	if (!mcast->ah) {
@@ -947,10 +960,9 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 		ipoib_mcast_free(mcast);
 	}
 	/*
-	 * Restart our join task if needed
+	 * Restart our join task thread if needed
 	 */
-	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+	__ipoib_mcast_continue_join_thread(priv, 0);
 	rtnl_unlock();
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
