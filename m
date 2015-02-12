From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/22] IB/ipoib: Handle -ENETRESET properly in our callback
Date: Wed, 11 Feb 2015 20:43:35 -0500
Message-ID: <96da4f01e70152dc0e7f4f32656f69cd3d188c45.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the core layer calls our callback with ENETRESET as the error, we
clear the status to 0 before returning indicating that we are going to
handle the error ourselves.  This causes the core layer to not free the
mcast->mc structure, but we are releasing our reference to it by
clearing mcast->mc.  So, preserve our reference to the multicast
structure so when we next run ipoib_mcast_dev_flush, it will be able
to properly release the mcast->mc entry at the right time in the right
way.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 957e7d2e80c..50d2de2270a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -315,8 +315,10 @@ ipoib_mcast_sendonly_join_complete(int status,
 	mutex_lock(&mcast_mutex);
 
 	/* We trap for port events ourselves. */
-	if (status == -ENETRESET)
+	if (status == -ENETRESET) {
+		status = 0;
 		goto out;
+	}
 
 	if (!status)
 		status = ipoib_mcast_join_finish(mcast, &multicast->rec);
@@ -344,8 +346,6 @@ out:
 	if (status)
 		mcast->mc = NULL;
 	complete(&mcast->done);
-	if (status == -ENETRESET)
-		status = 0;
 	__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	mutex_unlock(&mcast_mutex);
 	return status;
@@ -462,8 +462,10 @@ static int ipoib_mcast_join_complete(int status,
 	mutex_lock(&mcast_mutex);
 
 	/* We trap for port events ourselves. */
-	if (status == -ENETRESET)
+	if (status == -ENETRESET) {
+		status = 0;
 		goto out;
+	}
 
 	if (!status)
 		status = ipoib_mcast_join_finish(mcast, &multicast->rec);
@@ -499,8 +501,6 @@ out:
 	if (status)
 		mcast->mc = NULL;
 	complete(&mcast->done);
-	if (status == -ENETRESET)
-		status = 0;
 	spin_unlock_irq(&priv->lock);
 	mutex_unlock(&mcast_mutex);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
