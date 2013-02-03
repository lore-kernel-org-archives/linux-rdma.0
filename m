From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 25/62] infiniband/cxgb4: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:26 -0800
Message-ID: <1359854463-2538-26-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 9c1644f..7f862da 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -260,20 +260,21 @@ static inline int _insert_handle(struct c4iw_dev *rhp, struct idr *idr,
 				 void *handle, u32 id, int lock)
 {
 	int ret;
-	int newid;
 
-	do {
-		if (!idr_pre_get(idr, lock ? GFP_KERNEL : GFP_ATOMIC))
-			return -ENOMEM;
-		if (lock)
-			spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(!ret && newid != id);
-		if (lock)
-			spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
-
-	return ret;
+	if (lock) {
+		idr_preload(GFP_KERNEL);
+		spin_lock_irq(&rhp->lock);
+	}
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
+
+	if (lock) {
+		spin_unlock_irq(&rhp->lock);
+		idr_preload_end();
+	}
+
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
