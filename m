From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/22] IB/ipoib: remove unneeded locks
Date: Wed, 11 Feb 2015 20:43:37 -0500
Message-ID: <3cd3c664adb2877317c8f684ee344749b2915e45.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During the various work I've done on this, some extra locking has crept
in when things weren't working right.  This is one of those spots.
Remove the unneeded spinlocks.  The mutex is enough to protect against
what we need to protect against.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index a03b6a04203..424c602d5a0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -497,12 +497,10 @@ static int ipoib_mcast_join_complete(int status,
 		__ipoib_mcast_continue_join_thread(priv, mcast, 1);
 	}
 out:
-	spin_lock_irq(&priv->lock);
 	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	if (status)
 		mcast->mc = NULL;
 	complete(&mcast->done);
-	spin_unlock_irq(&priv->lock);
 	mutex_unlock(&mcast_mutex);
 
 	return status;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
