From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 14/14] IB/uverbs: Fix device cleanup
Date: Mon, 31 Jul 2017 10:09:24 +0300
Message-ID: <20170731070924.7193-15-leon@kernel.org>
References: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Uverbs device should be cleaned up only when there is no
potential usage of.

As part of ib_uverbs_remove_one which might be triggered upon reset flow
the device reference count is decreased as expected and leave the final
cleanup to the FDs that were opened.

Current code increases reference count upon opening a new command FD and
decreases it upon closing the file. The event FD is opened internally
and rely on the command FD by taking on it a reference count.

In case that the command FD was closed and just later the event FD we
may ensure that the device resources as of srcu are still alive as they
are still in use.

Fixing the above by moving the reference count decreasing to the place
where the command FD is really freed instead of doing that when it was
just closed.

fixes: 036b10635739 ("IB/uverbs: Enable device removal when there are active user space applications")
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 1ac99aec3d4e..96191e7f8c5f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -250,6 +250,7 @@ void ib_uverbs_release_file(struct kref *ref)
 	if (atomic_dec_and_test(&file->device->refcount))
 		ib_uverbs_comp_dev(file->device);
 
+	kobject_put(&file->device->kobj);
 	kfree(file);
 }
 
@@ -906,7 +907,6 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 static int ib_uverbs_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_file *file = filp->private_data;
-	struct ib_uverbs_device *dev = file->device;
 
 	mutex_lock(&file->cleanup_mutex);
 	if (file->ucontext) {
@@ -928,7 +928,6 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 			 ib_uverbs_release_async_event_file);
 
 	kref_put(&file->ref, ib_uverbs_release_file);
-	kobject_put(&dev->kobj);
 
 	return 0;
 }
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
