From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 FIX For-3.19 3/3] IB/ipoib: make delayed tasks not hold up everything
Date: Wed, 14 Jan 2015 14:52:54 -0500
Message-ID: <10aa817d75bd494de6f28488b6bfe675e7eab653.1421264928.git.dledford@redhat.com>
References: <cover.1421264928.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421264928.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1421264928.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1421264928.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, the multicast join thread only processes one task at a
time.  It does this by having itself be scheduled as a delayed work
item, when it runs, it finds one, and only one, piece of work to
process, it then kicks that off via either the normal join process
or the sendonly join process, and then it immediately exits.  Both
of those process chains are responsible for restarting the task
when they have completed their specific action.  This makes the entire
join process serial with only one join supposedly ever outstanding at
a time.

However, if we fail a join, and we need to initiate a backoff delay,
that delay holds up the entire join process for all joins, not just
the failed join.  So modify the design such that we can have joins
in delay, and the multicast thread will ignore them until their time
comes around, and then we can process the rest of the queue without
waiting for the delayed items.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 85 +++++++++++++++++---------
 2 files changed, 56 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 8ba80a6d3a4..c79dcd5ee8a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -154,6 +154,7 @@ struct ipoib_mcast {
 
 	unsigned long created;
 	unsigned long backoff;
+	unsigned long delay_until;
 
 	unsigned long flags;
 	unsigned char logcount;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index cb1e495bd74..9291b2d569e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -67,10 +67,34 @@ struct ipoib_mcast_iter {
 };
 
 static void __ipoib_mcast_continue_join_thread(struct ipoib_dev_priv *priv,
+					       struct ipoib_mcast *mcast,
 					       int delay)
 {
-	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
+	if (test_bit(IPOIB_MCAST_RUN, &priv->flags)) {
+		/*
+		 * Mark this mcast for its delay and set a timer to kick the
+		 * thread when the delay completes
+		 */
+		if (mcast && delay) {
+			mcast->backoff *= 2;
+			if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
+				mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
+			mcast->delay_until = jiffies + (mcast->backoff * HZ);
+			queue_delayed_work(priv->wq, &priv->mcast_task, 
+					   mcast->backoff * HZ);
+		} else if (delay) {
+			/* Special case of retrying after a failure to
+			 * allocate the broadcast multicast group, wait
+			 * 1 second and try again
+			 */
+			queue_delayed_work(priv->wq, &priv->mcast_task, HZ);
+		}
+		/*
+		 * But also rekick the thread immediately for any other
+		 * tasks in queue behind this one
+		 */
 		queue_delayed_work(priv->wq, &priv->mcast_task, delay);
+	}
 }
 
 static void ipoib_mcast_free(struct ipoib_mcast *mcast)
@@ -110,6 +134,7 @@ static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev,
 
 	mcast->dev = dev;
 	mcast->created = jiffies;
+	mcast->delay_until = jiffies;
 	mcast->backoff = 1;
 
 	INIT_LIST_HEAD(&mcast->list);
@@ -309,6 +334,10 @@ ipoib_mcast_sendonly_join_complete(int status,
 			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
 		}
 		netif_tx_unlock_bh(dev);
+	} else {
+		/* Join completed, so reset any backoff parameters */
+		mcast->backoff = 1;
+		mcast->delay_until = jiffies;
 	}
 out:
 	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
@@ -317,7 +346,7 @@ out:
 	complete(&mcast->done);
 	if (status == -ENETRESET)
 		status = 0;
-	__ipoib_mcast_continue_join_thread(priv, 0);
+	__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	mutex_unlock(&mcast_mutex);
 	return status;
 }
@@ -369,7 +398,7 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 		complete(&mcast->done);
 		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
 			   "failed (ret = %d)\n", ret);
-		__ipoib_mcast_continue_join_thread(priv, 0);
+		__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	} else {
 		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
 				"sendonly join\n", mcast->mcmember.mgid.raw);
@@ -441,7 +470,8 @@ static int ipoib_mcast_join_complete(int status,
 
 	if (!status) {
 		mcast->backoff = 1;
-		__ipoib_mcast_continue_join_thread(priv, 0);
+		mcast->delay_until = jiffies;
+		__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 
 		/*
 		 * Defer carrier on work to priv->wq to avoid a
@@ -460,16 +490,8 @@ static int ipoib_mcast_join_complete(int status,
 			}
 		}
 
-		mcast->backoff *= 2;
-		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
-			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
-		/*
-		 * XXX - This is wrong.  *Our* join failed, but because the
-		 * join thread does the joins in a serial fashion, if there
-		 * are any joins behind ours waiting to complete, they should
-		 * not be subjected to our backoff delay.
-		 */
-		__ipoib_mcast_continue_join_thread(priv, mcast->backoff * HZ);
+		/* Requeue this join task with a backoff delay */
+		__ipoib_mcast_continue_join_thread(priv, mcast, 1);
 	}
 out:
 	spin_lock_irq(&priv->lock);
@@ -541,17 +563,8 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		complete(&mcast->done);
 		ret = PTR_ERR(mcast->mc);
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
-
-		mcast->backoff *= 2;
-		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
-			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
-		/*
-		 * XXX - This is wrong.  *Our* join failed, but because the
-		 * join thread does the joins in a serial fashion, if there
-		 * are any joins behind ours waiting to complete, they should
-		 * not be subjected to our backoff delay.
-		 */
-		__ipoib_mcast_continue_join_thread(priv, mcast->backoff * HZ);
+		/* Requeue this join task with a backoff delay */
+		__ipoib_mcast_continue_join_thread(priv, mcast, 1);
 	}
 	mutex_unlock(&mcast_mutex);
 }
@@ -589,7 +602,13 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		if (!broadcast) {
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
 			mutex_lock(&mcast_mutex);
-			__ipoib_mcast_continue_join_thread(priv, HZ);
+			/*
+			 * Restart us after a 1 second delay to retry
+			 * creating our broadcast group and attaching to
+			 * it.  Until this succeeds, this ipoib dev is
+			 * completely stalled (multicast wise).
+			 */
+			__ipoib_mcast_continue_join_thread(priv, NULL, 1);
 			mutex_unlock(&mcast_mutex);
 			return;
 		}
@@ -623,7 +642,9 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		list_for_each_entry(mcast, &priv->multicast_list, list) {
 			if (IS_ERR_OR_NULL(mcast->mc) &&
 			    !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags) &&
-			    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
+			    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags) &&
+			    (mcast->backoff == 1 ||
+			     time_after_eq(jiffies, mcast->delay_until))) {
 				/* Found the next unjoined group */
 				break;
 			}
@@ -632,7 +653,11 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		mutex_unlock(&mcast_mutex);
 
 		if (&mcast->list == &priv->multicast_list) {
-			/* All done */
+			/* All done, unless we have delayed work from
+			 * backoff retransmissions, but we will get
+			 * restarted when the time is right, so we are
+			 * done for now
+			 */
 			break;
 		}
 
@@ -737,7 +762,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
-		__ipoib_mcast_continue_join_thread(priv, 0);
+		__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	}
 
 	if (!mcast->ah) {
@@ -962,7 +987,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	/*
 	 * Restart our join task thread if needed
 	 */
-	__ipoib_mcast_continue_join_thread(priv, 0);
+	__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	rtnl_unlock();
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
