From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/22] IB/ipoib: fix ipoib_mcast_restart_task
Date: Wed, 11 Feb 2015 20:43:39 -0500
Message-ID: <2344c78b5303a9196e7ced779cad7c12209dba53.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are two intertwined problems here.

First, if we are downing the interface, we will get called as part of
the process.  When that happens, we don't really want to do anything
here as the next thing to happen is ipoib_mcast_dev_flush will get
called.  We just want to let it do all the work since we don't need to
do any address matches and such.  So, we should be testing for whether
or not the interface is up at the beginning of this function and
returning if it isn't.

Second, the attempt to grab the rtnl_lock to prevent racing against
ipoib_mcast_dev_flush was mistaken.  The removed mcast groups are on a
stack local list head and so once we've removed them from the mcast
rbtree, ipoib_mcast_dev_flush can no longer find them and race us on
removing them.  However, because we attempt to take the lock, and then
check the status of the interface, if our interface has gone down, we
simply return.  This is absolutely the wrong thing to do as it means we
just leaked all of the mcast entries on our remove list.

The fix is to check for the interface being up at the very beginning of
the function, and then to always remove our entries on the remove list
no matter what as they will get leaked otherwise, and skip taking the
rtnl_lock since it isn't needed anyway.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 972fa15a225..10e05437c83 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -871,6 +871,9 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	unsigned long flags;
 	struct ib_sa_mcmember_rec rec;
 
+	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
+		return;
+
 	ipoib_dbg_mcast(priv, "restarting multicast task\n");
 
 	local_irq_save(flags);
@@ -965,21 +968,6 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			wait_for_completion(&mcast->done);
 
-	/*
-	 * We have to cancel outside of the spinlock, but we have to
-	 * take the rtnl lock or else we race with the removal of
-	 * entries from the remove list in mcast_dev_flush as part
-	 * of ipoib_stop().  We detect the drop of the ADMIN_UP flag
-	 * to signal that we have hit this particular race, and we
-	 * return since we know we don't need to do anything else
-	 * anyway.
-	 */
-	while (!rtnl_trylock()) {
-		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-			return;
-		else
-			msleep(20);
-	}
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(mcast->dev, mcast);
 		ipoib_mcast_free(mcast);
@@ -988,7 +976,6 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	 * Restart our join task thread if needed
 	 */
 	__ipoib_mcast_continue_join_thread(priv, NULL, 0);
-	rtnl_unlock();
 }
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
