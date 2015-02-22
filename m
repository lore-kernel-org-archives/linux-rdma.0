From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/9] IB/ipoib: fix MCAST_FLAG_BUSY usage
Date: Sat, 21 Feb 2015 19:27:05 -0500
Message-ID: <9d657f64ee961ee3b3233520d8b499b234a42bcd.1424562072.git.dledford@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit a9c8ba5884 ("IPoIB: Fix usage of uninitialized multicast
objects") added a new flag MCAST_JOIN_STARTED, but was not very strict
in how it was used.  We didn't always initialize the completion struct
before we set the flag, and we didn't always call complete on the
completion struct from all paths that complete it.  And when we did
complete it, sometimes we continued to touch the mcast entry after
the completion, opening us up to possible use after free issues.

This made it less than totally effective, and certainly made its use
confusing.  And in the flush function we would use the presence of this
flag to signal that we should wait on the completion struct, but we never
cleared this flag, ever.

In order to make things clearer and aid in resolving the rtnl deadlock
bug I've been chasing, I cleaned this up a bit.

 1) Remove the MCAST_JOIN_STARTED flag entirely
 2) Change MCAST_FLAG_BUSY so it now only means a join is in-flight
 3) Test mcast->mc directly to see if we have completed
    ib_sa_join_multicast (using IS_ERR_OR_NULL)
 4) Make sure that before setting MCAST_FLAG_BUSY we always initialize
    the mcast->done completion struct
 5) Make sure that before calling complete(&mcast->done), we always clear
    the MCAST_FLAG_BUSY bit
 6) Take the mcast_mutex before we call ib_sa_multicast_join and also
    take the mutex in our join callback.  This forces
    ib_sa_multicast_join to return and set mcast->mc before we process
    the callback.  This way, our callback can safely clear mcast->mc
    if there is an error on the join and we will do the right thing as
    a result in mcast_dev_flush.
 7) Because we need the mutex to synchronize mcast->mc, we can no
    longer call mcast_sendonly_join directly from mcast_send and
    instead must add sendonly join processing to the mcast_join_task
 8) Make MCAST_RUN mean that we have a working mcast subsystem, not that
    we have a running task.  We know when we need to reschedule our
    join task thread and don't need a flag to tell us.
 9) Add a helper for rescheduling the join task thread

A number of different races are resolved with these changes.  These
races existed with the old MCAST_FLAG_BUSY usage, the
MCAST_JOIN_STARTED flag was an attempt to address them, and while it
helped, a determined effort could still trip things up.

One race looks something like this:

Thread 1                             Thread 2
ib_sa_join_multicast (as part of running restart mcast task)
  alloc member
  call callback
                                     ifconfig ib0 down
				     wait_for_completion
    callback call completes
                                     wait_for_completion in
				     mcast_dev_flush completes
				       mcast->mc is PTR_ERR_OR_NULL
				       so we skip ib_sa_leave_multicast
    return from callback
  return from ib_sa_join_multicast
set mcast->mc = return from ib_sa_multicast

We now have a permanently unbalanced join/leave issue that trips up the
refcounting in core/multicast.c

Another like this:

Thread 1                   Thread 2         Thread 3
ib_sa_multicast_join
                                            ifconfig ib0 down
					    priv->broadcast = NULL
                           join_complete
			                    wait_for_completion
			   mcast->mc is not yet set, so don't clear
return from ib_sa_join_multicast and set mcast->mc
			   complete
			   return -EAGAIN (making mcast->mc invalid)
			   		    call ib_sa_multicast_leave
					    on invalid mcast->mc, hang
					    forever

By holding the mutex around ib_sa_multicast_join and taking the mutex
early in the callback, we force mcast->mc to be valid at the time we
run the callback.  This allows us to clear mcast->mc if there is an
error and the join is going to fail.  We do this before we complete
the mcast.  In this way, mcast_dev_flush always sees consistent state
in regards to mcast->mc membership at the time that the
wait_for_completion() returns.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  11 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 355 ++++++++++++++++---------
 2 files changed, 238 insertions(+), 128 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9ef432ae72e..c79dcd5ee8a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -98,9 +98,15 @@ enum {
 
 	IPOIB_MCAST_FLAG_FOUND	  = 0,	/* used in set_multicast_list */
 	IPOIB_MCAST_FLAG_SENDONLY = 1,
-	IPOIB_MCAST_FLAG_BUSY	  = 2,	/* joining or already joined */
+	/*
+	 * For IPOIB_MCAST_FLAG_BUSY
+	 * When set, in flight join and mcast->mc is unreliable
+	 * When clear and mcast->mc IS_ERR_OR_NULL, need to restart or
+	 *   haven't started yet
+	 * When clear and mcast->mc is valid pointer, join was successful
+	 */
+	IPOIB_MCAST_FLAG_BUSY	  = 2,
 	IPOIB_MCAST_FLAG_ATTACHED = 3,
-	IPOIB_MCAST_JOIN_STARTED  = 4,
 
 	MAX_SEND_CQE		  = 16,
 	IPOIB_CM_COPYBREAK	  = 256,
@@ -148,6 +154,7 @@ struct ipoib_mcast {
 
 	unsigned long created;
 	unsigned long backoff;
+	unsigned long delay_until;
 
 	unsigned long flags;
 	unsigned char logcount;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index bb1b69904f9..277e7ac7c4d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -66,6 +66,48 @@ struct ipoib_mcast_iter {
 	unsigned int       send_only;
 };
 
+/*
+ * This should be called with the mcast_mutex held
+ */
+static void __ipoib_mcast_schedule_join_thread(struct ipoib_dev_priv *priv,
+					       struct ipoib_mcast *mcast,
+					       bool delay)
+{
+	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
+		return;
+
+	/*
+	 * We will be scheduling *something*, so cancel whatever is
+	 * currently scheduled first
+	 */
+	cancel_delayed_work(&priv->mcast_task);
+	if (mcast && delay) {
+		/*
+		 * We had a failure and want to schedule a retry later
+		 */
+		mcast->backoff *= 2;
+		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
+			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
+		mcast->delay_until = jiffies + (mcast->backoff * HZ);
+		/*
+		 * Mark this mcast for its delay, but restart the
+		 * task immediately.  The join task will make sure to
+		 * clear out all entries without delays, and then
+		 * schedule itself to run again when the earliest
+		 * delay expires
+		 */
+		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+	} else if (delay) {
+		/*
+		 * Special case of retrying after a failure to
+		 * allocate the broadcast multicast group, wait
+		 * 1 second and try again
+		 */
+		queue_delayed_work(priv->wq, &priv->mcast_task, HZ);
+	} else
+		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+}
+
 static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
@@ -103,6 +145,7 @@ static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev,
 
 	mcast->dev = dev;
 	mcast->created = jiffies;
+	mcast->delay_until = jiffies;
 	mcast->backoff = 1;
 
 	INIT_LIST_HEAD(&mcast->list);
@@ -270,17 +313,31 @@ ipoib_mcast_sendonly_join_complete(int status,
 {
 	struct ipoib_mcast *mcast = multicast->context;
 	struct net_device *dev = mcast->dev;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	/*
+	 * We have to take the mutex to force mcast_sendonly_join to
+	 * return from ib_sa_multicast_join and set mcast->mc to a
+	 * valid value.  Otherwise we were racing with ourselves in
+	 * that we might fail here, but get a valid return from
+	 * ib_sa_multicast_join after we had cleared mcast->mc here,
+	 * resulting in mis-matched joins and leaves and a deadlock
+	 */
+	mutex_lock(&mcast_mutex);
 
 	/* We trap for port events ourselves. */
-	if (status == -ENETRESET)
-		return 0;
+	if (status == -ENETRESET) {
+		status = 0;
+		goto out;
+	}
 
 	if (!status)
 		status = ipoib_mcast_join_finish(mcast, &multicast->rec);
 
 	if (status) {
 		if (mcast->logcount++ < 20)
-			ipoib_dbg_mcast(netdev_priv(dev), "multicast join failed for %pI6, status %d\n",
+			ipoib_dbg_mcast(netdev_priv(dev), "sendonly multicast "
+					"join failed for %pI6, status %d\n",
 					mcast->mcmember.mgid.raw, status);
 
 		/* Flush out any queued packets */
@@ -290,11 +347,18 @@ ipoib_mcast_sendonly_join_complete(int status,
 			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
 		}
 		netif_tx_unlock_bh(dev);
-
-		/* Clear the busy flag so we try again */
-		status = test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY,
-					    &mcast->flags);
+		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
+	} else {
+		mcast->backoff = 1;
+		mcast->delay_until = jiffies;
+		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 	}
+out:
+	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+	if (status)
+		mcast->mc = NULL;
+	complete(&mcast->done);
+	mutex_unlock(&mcast_mutex);
 	return status;
 }
 
@@ -312,19 +376,18 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	int ret = 0;
 
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
-		ipoib_dbg_mcast(priv, "device shutting down, no multicast joins\n");
+		ipoib_dbg_mcast(priv, "device shutting down, no sendonly "
+				"multicast joins\n");
+		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+		complete(&mcast->done);
 		return -ENODEV;
 	}
 
-	if (test_and_set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags)) {
-		ipoib_dbg_mcast(priv, "multicast entry busy, skipping\n");
-		return -EBUSY;
-	}
-
 	rec.mgid     = mcast->mcmember.mgid;
 	rec.port_gid = priv->local_gid;
 	rec.pkey     = cpu_to_be16(priv->pkey);
 
+	mutex_lock(&mcast_mutex);
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
 					 priv->port, &rec,
 					 IB_SA_MCMEMBER_REC_MGID	|
@@ -337,12 +400,14 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	if (IS_ERR(mcast->mc)) {
 		ret = PTR_ERR(mcast->mc);
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-		ipoib_warn(priv, "ib_sa_join_multicast failed (ret = %d)\n",
-			   ret);
+		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
+			   "failed (ret = %d)\n", ret);
+		complete(&mcast->done);
 	} else {
-		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting join\n",
-				mcast->mcmember.mgid.raw);
+		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
+				"sendonly join\n", mcast->mcmember.mgid.raw);
 	}
+	mutex_unlock(&mcast_mutex);
 
 	return ret;
 }
@@ -390,6 +455,16 @@ static int ipoib_mcast_join_complete(int status,
 	ipoib_dbg_mcast(priv, "join completion for %pI6 (status %d)\n",
 			mcast->mcmember.mgid.raw, status);
 
+	/*
+	 * We have to take the mutex to force mcast_join to
+	 * return from ib_sa_multicast_join and set mcast->mc to a
+	 * valid value.  Otherwise we were racing with ourselves in
+	 * that we might fail here, but get a valid return from
+	 * ib_sa_multicast_join after we had cleared mcast->mc here,
+	 * resulting in mis-matched joins and leaves and a deadlock
+	 */
+	mutex_lock(&mcast_mutex);
+
 	/* We trap for port events ourselves. */
 	if (status == -ENETRESET) {
 		status = 0;
@@ -401,10 +476,8 @@ static int ipoib_mcast_join_complete(int status,
 
 	if (!status) {
 		mcast->backoff = 1;
-		mutex_lock(&mcast_mutex);
-		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
-		mutex_unlock(&mcast_mutex);
+		mcast->delay_until = jiffies;
+		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 
 		/*
 		 * Defer carrier on work to priv->wq to avoid a
@@ -412,37 +485,26 @@ static int ipoib_mcast_join_complete(int status,
 		 */
 		if (mcast == priv->broadcast)
 			queue_work(priv->wq, &priv->carrier_on_task);
-
-		status = 0;
-		goto out;
-	}
-
-	if (mcast->logcount++ < 20) {
-		if (status == -ETIMEDOUT || status == -EAGAIN) {
-			ipoib_dbg_mcast(priv, "multicast join failed for %pI6, status %d\n",
-					mcast->mcmember.mgid.raw, status);
-		} else {
-			ipoib_warn(priv, "multicast join failed for %pI6, status %d\n",
-				   mcast->mcmember.mgid.raw, status);
+	} else {
+		if (mcast->logcount++ < 20) {
+			if (status == -ETIMEDOUT || status == -EAGAIN) {
+				ipoib_dbg_mcast(priv, "multicast join failed for %pI6, status %d\n",
+						mcast->mcmember.mgid.raw, status);
+			} else {
+				ipoib_warn(priv, "multicast join failed for %pI6, status %d\n",
+					   mcast->mcmember.mgid.raw, status);
+			}
 		}
-	}
-
-	mcast->backoff *= 2;
-	if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
-		mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
 
-	/* Clear the busy flag so we try again */
-	status = test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-
-	mutex_lock(&mcast_mutex);
-	spin_lock_irq(&priv->lock);
-	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(priv->wq, &priv->mcast_task,
-				   mcast->backoff * HZ);
-	spin_unlock_irq(&priv->lock);
-	mutex_unlock(&mcast_mutex);
+		/* Requeue this join task with a backoff delay */
+		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
+	}
 out:
+	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+	if (status)
+		mcast->mc = NULL;
 	complete(&mcast->done);
+	mutex_unlock(&mcast_mutex);
 	return status;
 }
 
@@ -491,29 +553,18 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 		rec.hop_limit	  = priv->broadcast->mcmember.hop_limit;
 	}
 
-	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-	init_completion(&mcast->done);
-	set_bit(IPOIB_MCAST_JOIN_STARTED, &mcast->flags);
-
+	mutex_lock(&mcast_mutex);
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
 					 &rec, comp_mask, GFP_KERNEL,
 					 ipoib_mcast_join_complete, mcast);
 	if (IS_ERR(mcast->mc)) {
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-		complete(&mcast->done);
 		ret = PTR_ERR(mcast->mc);
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
-
-		mcast->backoff *= 2;
-		if (mcast->backoff > IPOIB_MAX_BACKOFF_SECONDS)
-			mcast->backoff = IPOIB_MAX_BACKOFF_SECONDS;
-
-		mutex_lock(&mcast_mutex);
-		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task,
-					   mcast->backoff * HZ);
-		mutex_unlock(&mcast_mutex);
+		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
+		complete(&mcast->done);
 	}
+	mutex_unlock(&mcast_mutex);
 }
 
 void ipoib_mcast_join_task(struct work_struct *work)
@@ -522,6 +573,9 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		container_of(work, struct ipoib_dev_priv, mcast_task.work);
 	struct net_device *dev = priv->dev;
 	struct ib_port_attr port_attr;
+	unsigned long delay_until = 0;
+	struct ipoib_mcast *mcast = NULL;
+	int create = 1;
 
 	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
 		return;
@@ -539,64 +593,102 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
 
+	/*
+	 * We have to hold the mutex to keep from racing with the join
+	 * completion threads on setting flags on mcasts, and we have
+	 * to hold the priv->lock because dev_flush will remove entries
+	 * out from underneath us, so at a minimum we need the lock
+	 * through the time that we do the for_each loop of the mcast
+	 * list or else dev_flush can make us oops.
+	 */
+	mutex_lock(&mcast_mutex);
+	spin_lock_irq(&priv->lock);
+	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+		goto out;
+
 	if (!priv->broadcast) {
 		struct ipoib_mcast *broadcast;
 
-		if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
-			return;
-
-		broadcast = ipoib_mcast_alloc(dev, 1);
+		broadcast = ipoib_mcast_alloc(dev, 0);
 		if (!broadcast) {
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
-			mutex_lock(&mcast_mutex);
-			if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-				queue_delayed_work(priv->wq, &priv->mcast_task,
-						   HZ);
-			mutex_unlock(&mcast_mutex);
-			return;
+			/*
+			 * Restart us after a 1 second delay to retry
+			 * creating our broadcast group and attaching to
+			 * it.  Until this succeeds, this ipoib dev is
+			 * completely stalled (multicast wise).
+			 */
+			__ipoib_mcast_schedule_join_thread(priv, NULL, 1);
+			goto out;
 		}
 
-		spin_lock_irq(&priv->lock);
 		memcpy(broadcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		       sizeof (union ib_gid));
 		priv->broadcast = broadcast;
 
 		__ipoib_mcast_add(dev, priv->broadcast);
-		spin_unlock_irq(&priv->lock);
 	}
 
 	if (!test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
-		if (!test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags))
-			ipoib_mcast_join(dev, priv->broadcast, 0);
-		return;
+		if (IS_ERR_OR_NULL(priv->broadcast->mc) &&
+		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags)) {
+			mcast = priv->broadcast;
+			create = 0;
+			if (mcast->backoff > 1 &&
+			    time_before(jiffies, mcast->delay_until)) {
+				delay_until = mcast->delay_until;
+				mcast = NULL;
+			}
+		}
+		goto out;
 	}
 
-	while (1) {
-		struct ipoib_mcast *mcast = NULL;
-
-		spin_lock_irq(&priv->lock);
-		list_for_each_entry(mcast, &priv->multicast_list, list) {
-			if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)
-			    && !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags)
-			    && !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
+	/*
+	 * We'll never get here until the broadcast group is both allocated
+	 * and attached
+	 */
+	list_for_each_entry(mcast, &priv->multicast_list, list) {
+		if (IS_ERR_OR_NULL(mcast->mc) &&
+		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags) &&
+		    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
+			if (mcast->backoff == 1 ||
+			    time_after_eq(jiffies, mcast->delay_until))
 				/* Found the next unjoined group */
 				break;
-			}
+			else if (!delay_until ||
+				 time_before(mcast->delay_until, delay_until))
+				delay_until = mcast->delay_until;
 		}
-		spin_unlock_irq(&priv->lock);
-
-		if (&mcast->list == &priv->multicast_list) {
-			/* All done */
-			break;
-		}
-
-		ipoib_mcast_join(dev, mcast, 1);
-		return;
 	}
 
-	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
+	if (&mcast->list == &priv->multicast_list) {
+		/*
+		 * All done, unless we have delayed work from
+		 * backoff retransmissions, but we will get
+		 * restarted when the time is right, so we are
+		 * done for now
+		 */
+		mcast = NULL;
+		ipoib_dbg_mcast(priv, "successfully joined all "
+				"multicast groups\n");
+	}
 
-	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
+out:
+	if (mcast) {
+		init_completion(&mcast->done);
+		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+	}
+	spin_unlock_irq(&priv->lock);
+	mutex_unlock(&mcast_mutex);
+	if (mcast) {
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+			ipoib_mcast_sendonly_join(mcast);
+		else
+			ipoib_mcast_join(dev, mcast, create);
+	}
+	if (delay_until)
+		queue_delayed_work(priv->wq, &priv->mcast_task,
+				   delay_until - jiffies);
 }
 
 int ipoib_mcast_start_thread(struct net_device *dev)
@@ -606,8 +698,8 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 	ipoib_dbg_mcast(priv, "starting multicast thread\n");
 
 	mutex_lock(&mcast_mutex);
-	if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
+	set_bit(IPOIB_MCAST_RUN, &priv->flags);
+	__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 	mutex_unlock(&mcast_mutex);
 
 	return 0;
@@ -635,7 +727,12 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	int ret = 0;
 
 	if (test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
+		ipoib_warn(priv, "ipoib_mcast_leave on an in-flight join\n");
+
+	if (!IS_ERR_OR_NULL(mcast->mc))
 		ib_sa_free_multicast(mcast->mc);
+	else
+		ipoib_dbg(priv, "ipoib_mcast_leave with mcast->mc invalid\n");
 
 	if (test_and_clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
 		ipoib_dbg_mcast(priv, "leaving MGID %pI6\n",
@@ -646,7 +743,9 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 				      be16_to_cpu(mcast->mcmember.mlid));
 		if (ret)
 			ipoib_warn(priv, "ib_detach_mcast failed (result = %d)\n", ret);
-	}
+	} else if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+		ipoib_dbg(priv, "leaving with no mcmember but not a "
+			  "SENDONLY join\n");
 
 	return 0;
 }
@@ -687,6 +786,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
+		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 	}
 
 	if (!mcast->ah) {
@@ -696,13 +796,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 			++dev->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
 		}
-
-		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-			ipoib_dbg_mcast(priv, "no address vector, "
-					"but multicast join already started\n");
-		else if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
-			ipoib_mcast_sendonly_join(mcast);
-
 		/*
 		 * If lookup completes between here and out:, don't
 		 * want to send packet twice.
@@ -761,9 +854,12 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* seperate between the wait to the leave*/
+	/*
+	 * make sure the in-flight joins have finished before we attempt
+	 * to leave
+	 */
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
-		if (test_bit(IPOIB_MCAST_JOIN_STARTED, &mcast->flags))
+		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			wait_for_completion(&mcast->done);
 
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
@@ -794,20 +890,14 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	unsigned long flags;
 	struct ib_sa_mcmember_rec rec;
 
-	ipoib_dbg_mcast(priv, "restarting multicast task\n");
+	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+		/*
+		 * shortcut...on shutdown flush is called next, just
+		 * let it do all the work
+		 */
+		return;
 
-	/*
-	 * We're running on the priv->wq right now, so we can't call
-	 * mcast_stop_thread as it wants to flush the wq and that
-	 * will deadlock.  We don't actually *need* to stop the
-	 * thread here anyway, so just clear the run flag, cancel
-	 * any delayed work, do our work, remove the old entries,
-	 * then restart the thread.
-	 */
-	mutex_lock(&mcast_mutex);
-	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
-	cancel_delayed_work(&priv->mcast_task);
-	mutex_unlock(&mcast_mutex);
+	ipoib_dbg_mcast(priv, "restarting multicast task\n");
 
 	local_irq_save(flags);
 	netif_addr_lock(dev);
@@ -893,14 +983,27 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	netif_addr_unlock(dev);
 	local_irq_restore(flags);
 
-	/* We have to cancel outside of the spinlock */
+	/*
+	 * make sure the in-flight joins have finished before we attempt
+	 * to leave
+	 */
+	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
+		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
+			wait_for_completion(&mcast->done);
+
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(mcast->dev, mcast);
 		ipoib_mcast_free(mcast);
 	}
 
-	if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
-		ipoib_mcast_start_thread(dev);
+	/*
+	 * Double check that we are still up
+	 */
+	if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
+		spin_lock_irqsave(&priv->lock, flags);
+		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
 }
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
