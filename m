From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 03/11] IB/ipoib: Make sure no in-flight joins while leaving that mcast
Date: Wed, 26 Jul 2017 21:12:24 +0300
Message-ID: <20170726181232.7363-4-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

While cleaning neighs and there is a send-only mcast neigh, the driver
should wait to finish its join process before trying to remove it.

Without this patch, we will see messages like: "ipoib_mcast_leave on an
in-flight join" and unexpected results in the join_complete.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index f80bf0f5d7cf..93e149efc1f5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -743,6 +743,14 @@ void ipoib_mcast_remove_list(struct list_head *remove_list)
 {
 	struct ipoib_mcast *mcast, *tmcast;
 
+	/*
+	 * make sure the in-flight joins have finished before we attempt
+	 * to leave
+	 */
+	list_for_each_entry_safe(mcast, tmcast, remove_list, list)
+		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
+			wait_for_completion(&mcast->done);
+
 	list_for_each_entry_safe(mcast, tmcast, remove_list, list) {
 		ipoib_mcast_leave(mcast->dev, mcast);
 		ipoib_mcast_free(mcast);
@@ -852,14 +860,6 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/*
-	 * make sure the in-flight joins have finished before we attempt
-	 * to leave
-	 */
-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
-		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-			wait_for_completion(&mcast->done);
-
 	ipoib_mcast_remove_list(&remove_list);
 	mutex_unlock(&priv->mcast_mutex);
 }
@@ -979,14 +979,6 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	netif_addr_unlock(dev);
 	local_irq_restore(flags);
 
-	/*
-	 * make sure the in-flight joins have finished before we attempt
-	 * to leave
-	 */
-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
-		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-			wait_for_completion(&mcast->done);
-
 	ipoib_mcast_remove_list(&remove_list);
 
 	/*
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
