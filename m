From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19 11/10] IB/ipoib: don't queue a work struct up twice
Date: Mon, 26 Jan 2015 14:34:18 -0500
Message-ID: <d0700cb3ff9d0ef629196ea48ea181c7563f3e60.1422300678.git.dledford@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In b2d408f78b3 (IB/ipoib: make delayed tasks not hold up everything) I
added the ability to have some joins processed around delayed joins.
Because the join task processes one join at a time, we needed to queue
the task to run again immediately and then again at the appropriate
delay time.  I didn't think about the fact that our work struct can only
be on the workqueue once at a given time and instead tried to queue the
same struct up twice.  Instead, kick the queue again immediately on a
delayed restart attempt, when the task sees that it has nothing to do
but delayed work, it will pick the shortest work item and queue a delay
equal to its expiration.  Finally, in case we have delayed work, in the
send_mcast routine we need to cancel any delayed work before kicking the
thread immediately.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 49 ++++++++++++++++----------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index ad2bcd105e4..68b47bed33a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -71,29 +71,28 @@ static void __ipoib_mcast_continue_join_thread(struct ipoib_dev_priv *priv,
 					       int delay)
 {
 	if (test_bit(IPOIB_MCAST_RUN, &priv->flags)) {
-		/*
-		 * Mark this mcast for its delay and set a timer to kick the
-		 * thread when the delay completes
-		 */
 		if (mcast && delay) {
 			mcast->backoff *= 2;
 			if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
 				mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
 			mcast->delay_until = jiffies + (mcast->backoff * HZ);
-			queue_delayed_work(priv->wq, &priv->mcast_task,
-					   mcast->backoff * HZ);
+			/*
+			 * Mark this mcast for its delay, but restart the
+			 * task immediately.  It will make sure to clear
+			 * out all entries without delays, and then
+			 * schedule itself for run again when the delay
+			 * expires
+			 */
+			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 		} else if (delay) {
-			/* Special case of retrying after a failure to
+			/*
+			 * Special case of retrying after a failure to
 			 * allocate the broadcast multicast group, wait
 			 * 1 second and try again
 			 */
 			queue_delayed_work(priv->wq, &priv->mcast_task, HZ);
-		}
-		/*
-		 * But also rekick the thread immediately for any other
-		 * tasks in queue behind this one
-		 */
-		queue_delayed_work(priv->wq, &priv->mcast_task, delay);
+		} else
+			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 	}
 }
 
@@ -568,6 +567,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	struct ib_port_attr port_attr;
 	struct ipoib_mcast *mcast = NULL;
 	int create = 1;
+	unsigned long delay_until = 0;
 
 	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
 		return;
@@ -636,11 +636,14 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	list_for_each_entry(mcast, &priv->multicast_list, list) {
 		if (IS_ERR_OR_NULL(mcast->mc) &&
 		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags) &&
-		    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags) &&
-		    (mcast->backoff == 1 ||
-		     time_after_eq(jiffies, mcast->delay_until))) {
-			/* Found the next unjoined group */
-			break;
+		    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
+			if (mcast->backoff == 1 ||
+			    time_after_eq(jiffies, mcast->delay_until))
+				/* Found the next unjoined group */
+				break;
+			else if (!delay_until ||
+				 time_before(mcast->delay_until, delay_until))
+				delay_until = mcast->delay_until;
 		}
 	}
 
@@ -653,6 +656,9 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		mcast = NULL;
 		ipoib_dbg_mcast(priv, "successfully joined all "
 				"multicast groups\n");
+		if (delay_until)
+			queue_delayed_work(priv->wq, &priv->mcast_task,
+					   delay_until - jiffies);
 	}
 
 out:
@@ -766,6 +772,13 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
+		/*
+		 * Make sure that if we are currently waiting for a backoff
+		 * delay to expire, that we cancel that, run immediately,
+		 * and then requeue our task to fire when the backoff
+		 * timer is over.
+		 */
+		cancel_delayed_work(&priv->mcast_task);
 		__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	}
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
