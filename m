From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/8] IPoIB: fix mcast_dev_flush/mcast_restart_task race
Date: Tue, 12 Aug 2014 19:38:11 -0400
Message-ID: <e1dbcfc25d8930b281aad12699ebf8fa82485b0e.1407885724.git.dledford@redhat.com>
References: <cover.1407885724.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Our mcast_dev_flush routine and our mcast_restart_task can race against
each other.  In particular, they both hold the priv->lock while
manipulating the rbtree and while removing mcast entries from the
multicast_list and while adding entries to the remove_list, but they
also both drop their locks prior to doing the actual removes.  The
mcast_dev_flush routine is run entirely under the rtnl lock and so has
at least some locking.  The actual race condition is like this:

Thread 1                                Thread 2
ifconfig ib0 up
  start multicast join for broadcast
  multicast join completes for broadcast
  start to add more multicast joins
    call mcast_restart_task to add new entries
                                        ifconfig ib0 down
					  mcast_dev_flush
					    mcast_leave(mcast A)
    mcast_leave(mcast A)

As mcast_leave calls ib_sa_multicast_leave, and as member in
core/multicast.c is ref counted, we run into an unbalanced refcount
issue.  To avoid stomping on each others removes, take the rtnl lock
specifically when we are deleting the entries from the remove list.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 37 ++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index f5e8da530d9..19e3fe75ebf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -810,7 +810,10 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* seperate between the wait to the leave*/
+	/*
+	 * make sure the in-flight joins have finished before we attempt
+	 * to leave
+	 */
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			wait_for_completion(&mcast->done);
@@ -931,14 +934,38 @@ void ipoib_mcast_restart_task(struct work_struct *work)
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
+	/*
+	 * We have to cancel outside of the spinlock, but we have to
+	 * take the rtnl lock or else we race with the removal of
+	 * entries from the remove list in mcast_dev_flush as part
+	 * of ipoib_stop() which will call mcast_stop_thread with
+	 * flush == 1 while holding the rtnl lock, and the
+	 * flush_workqueue won't complete until this restart_mcast_task
+	 * completes.  So do like the carrier on task and attempt to
+	 * take the rtnl lock, but if we can't before the ADMIN_UP flag
+	 * goes away, then just return and know that the remove list will
+	 * get flushed later by mcast_dev_flush.
+	 */
+	while (!rtnl_trylock()) {
+		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
+			return;
+		else
+			msleep(20);
+	}
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(mcast->dev, mcast);
 		ipoib_mcast_free(mcast);
 	}
-
-	if (test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-		ipoib_mcast_start_thread(dev);
+	ipoib_mcast_start_thread(dev);
+	rtnl_unlock();
 }
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
