From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] RDMA/ocrdma: Fix the driver crash during rmmod.
Date: Mon, 28 Oct 2013 17:29:35 +0530
Message-ID: <75d878d4-23d5-498e-93cf-37bb240213fe@CMEXHTCAS1.ad.emulex.com>
References: <1382961575-22253-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382961575-22253-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

ocrdma_remove_free funtion can be called in a bottom-half context.
So the code in this funtion should not sleep.

Moved the resource cleanup code to ocrdma_remove instead of
ocrdma_remove_free.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 0ce7674..91443bc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -452,9 +452,6 @@ static void ocrdma_remove_free(struct rcu_head *rcu)
 {
 	struct ocrdma_dev *dev = container_of(rcu, struct ocrdma_dev, rcu);
 
-	ocrdma_free_resources(dev);
-	ocrdma_cleanup_hw(dev);
-
 	idr_remove(&ocrdma_dev_id, dev->id);
 	kfree(dev->mbx_cmd);
 	ib_dealloc_device(&dev->ibdev);
@@ -470,6 +467,10 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	spin_lock(&ocrdma_devlist_lock);
 	list_del_rcu(&dev->entry);
 	spin_unlock(&ocrdma_devlist_lock);
+
+	ocrdma_free_resources(dev);
+	ocrdma_cleanup_hw(dev);
+
 	call_rcu(&dev->rcu, ocrdma_remove_free);
 }
 
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
