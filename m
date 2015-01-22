From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19 v5 09/10] IB/ipoib: flush the ipoib_workqueue on unregister
Date: Thu, 22 Jan 2015 09:31:34 -0500
Message-ID: <42f4127536f9182bccf11832c5c1544092f87030.1421936879.git.dledford@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When we unregister our event handler as a prelude to removing our
device, we need to go ahead and flush the ipoib_workqueue to make sure
there are no delayed flushes for the device we are getting ready to
remove.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6bad17d4d58..8810514cf40 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1643,6 +1643,7 @@ sysfs_failed:
 
 register_failed:
 	ib_unregister_event_handler(&priv->event_handler);
+	flush_workqueue(ipoib_workqueue);
 	/* Stop GC if started before flush */
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	cancel_delayed_work(&priv->neigh_reap_task);
@@ -1709,6 +1710,7 @@ static void ipoib_remove_one(struct ib_device *device)
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		ib_unregister_event_handler(&priv->event_handler);
+		flush_workqueue(ipoib_workqueue);
 
 		rtnl_lock();
 		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
