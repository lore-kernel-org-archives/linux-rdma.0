From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19 v3 6/6] IB/ipoib: remove unneeded locks
Date: Thu, 15 Jan 2015 15:59:41 -0500
Message-ID: <e5bfbf98c937c05cd226489853b51f345639f3da.1421355536.git.dledford@redhat.com>
References: <1421353631.2484.31.camel@redhat.com>
 <f0d0830949eb57626baa20a1d311b8e4b4f7768d.1421355536.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0d0830949eb57626baa20a1d311b8e4b4f7768d.1421355536.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <f0d0830949eb57626baa20a1d311b8e4b4f7768d.1421355536.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <f0d0830949eb57626baa20a1d311b8e4b4f7768d.1421355536.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
index 34727254339..9df74f831e2 100644
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
