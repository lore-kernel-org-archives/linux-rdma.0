From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19 v4 7/7] IB/ipoib: fix race between mcast_dev_flush and mcast_join
Date: Mon, 19 Jan 2015 22:58:46 -0500
Message-ID: <b8cd7790a332c208421aa6dbd2afc58f9e422d31.1421725318.git.dledford@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a classic race between mcast_dev_flush and mcast_join_thread
in that the join thread is going to loop through all of the mcast
entries in the device mcast list, while dev_flush wants to remove
those entries from the list so that they can eventually be freed when
they are no longer busy.

As always, the list traversal and the list removal must be done under
the same lock to avoid races, so modify the join_task thread code to
hold onto the spinlock for the entirety of its run up until it has
saved the mcast entry that it's going to work on into a private pointer
and set the flags on that entry to mark it as busy.  Only then is it
safe to drop the lock and let mcast_dev_flush remove entries from the
list.

I also reworked the flow of the join_task thread to be more clear that
it is making a single pass at work to do and then exiting as soon as it
gets that single task queued off.

I then reworked both the regular and send only join routines to know
that they will be called with the BUSY flag already set on the mcast
entry they are passed, so any error condition means they need to
clear the flag and complete the task and they should not check the
busy status as it will now always be true.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 112 ++++++++++++-------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 424c602d5a0..972fa15a225 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -368,22 +368,16 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
 		ipoib_dbg_mcast(priv, "device shutting down, no sendonly "
 				"multicast joins\n");
+		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+		complete(&mcast->done);
 		return -ENODEV;
 	}
 
-	if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags)) {
-		ipoib_dbg_mcast(priv, "multicast entry busy, skipping "
-				"sendonly join\n");
-		return -EBUSY;
-	}
-
 	rec.mgid     = mcast->mcmember.mgid;
 	rec.port_gid = priv->local_gid;
 	rec.pkey     = cpu_to_be16(priv->pkey);
 
 	mutex_lock(&mcast_mutex);
-	init_completion(&mcast->done);
-	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
 					 priv->port, &rec,
 					 IB_SA_MCMEMBER_REC_MGID	|
@@ -552,8 +546,6 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 	}
 
 	mutex_lock(&mcast_mutex);
-	init_completion(&mcast->done);
-	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
 					 &rec, comp_mask, GFP_KERNEL,
 					 ipoib_mcast_join_complete, mcast);
@@ -574,6 +566,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		container_of(work, struct ipoib_dev_priv, mcast_task.work);
 	struct net_device *dev = priv->dev;
 	struct ib_port_attr port_attr;
+	struct ipoib_mcast *mcast = NULL;
+	int create = 1;
 
 	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
 		return;
@@ -591,16 +585,25 @@ void ipoib_mcast_join_task(struct work_struct *work)
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
+	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
+		goto out;
+
 	if (!priv->broadcast) {
 		struct ipoib_mcast *broadcast;
 
-		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-			return;
-
-		broadcast = ipoib_mcast_alloc(dev, 1);
+		broadcast = ipoib_mcast_alloc(dev, 0);
 		if (!broadcast) {
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
-			mutex_lock(&mcast_mutex);
 			/*
 			 * Restart us after a 1 second delay to retry
 			 * creating our broadcast group and attaching to
@@ -608,67 +611,64 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			 * completely stalled (multicast wise).
 			 */
 			__ipoib_mcast_continue_join_thread(priv, NULL, 1);
-			mutex_unlock(&mcast_mutex);
-			return;
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
 		if (IS_ERR_OR_NULL(priv->broadcast->mc) &&
-		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags))
-			ipoib_mcast_join(dev, priv->broadcast, 0);
-		return;
-	}
-
-	while (1) {
-		struct ipoib_mcast *mcast = NULL;
-
-		/*
-		 * Need the mutex so our flags are consistent, need the
-		 * priv->lock so we don't race with list removals in either
-		 * mcast_dev_flush or mcast_restart_task
-		 */
-		mutex_lock(&mcast_mutex);
-		spin_lock_irq(&priv->lock);
-		list_for_each_entry(mcast, &priv->multicast_list, list) {
-			if (IS_ERR_OR_NULL(mcast->mc) &&
-			    !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags) &&
-			    !test_bit(IPOIB_MCAST_FLAG_ATTACHED,
-				      &mcast->flags) &&
-			    (mcast->backoff == 1 ||
-			     time_after_eq(jiffies, mcast->delay_until))) {
-				/* Found the next unjoined group */
-				break;
-			}
+		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags)) {
+			mcast = priv->broadcast;
+			create = 0;
 		}
-		spin_unlock_irq(&priv->lock);
-		mutex_unlock(&mcast_mutex);
+		goto out;
+	}
 
-		if (&mcast->list == &priv->multicast_list) {
-			/* All done, unless we have delayed work from
-			 * backoff retransmissions, but we will get
-			 * restarted when the time is right, so we are
-			 * done for now
-			 */
+	/* We'll never get here until the broadcast group is both allocated
+	 * and attached
+	 */
+	list_for_each_entry(mcast, &priv->multicast_list, list) {
+		if (IS_ERR_OR_NULL(mcast->mc) &&
+		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags) &&
+		    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags) &&
+		    (mcast->backoff == 1 ||
+		     time_after_eq(jiffies, mcast->delay_until))) {
+			/* Found the next unjoined group */
 			break;
 		}
+	}
 
+	if (&mcast->list == &priv->multicast_list) {
+		/* All done, unless we have delayed work from
+		 * backoff retransmissions, but we will get
+		 * restarted when the time is right, so we are
+		 * done for now
+		 */
+		mcast = NULL;
+		ipoib_dbg_mcast(priv, "successfully joined all "
+				"multicast groups\n");
+	}
+
+out:
+	if (mcast) {
+		init_completion(&mcast->done);
+		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+	}
+	spin_unlock_irq(&priv->lock);
+	mutex_unlock(&mcast_mutex);
+	if (mcast) {
 		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
 			ipoib_mcast_sendonly_join(mcast);
 		else
-			ipoib_mcast_join(dev, mcast, 1);
-		return;
+			ipoib_mcast_join(dev, mcast, create);
 	}
-
-	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
+	return;
 }
 
 int ipoib_mcast_start_thread(struct net_device *dev)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
