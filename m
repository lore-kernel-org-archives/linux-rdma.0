From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Sun,  3 Jul 2016 15:28:18 +0300
Message-ID: <1467548899-21923-2-git-send-email-leon@kernel.org>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467548899-21923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Fixes an oops that might happen if uverbs_close races with
remove_one.

Both contexts may run ib_uverbs_cleanup_ucontext, it depends
on the flow.

Currently, there is no protection for a case that remove_one
didn't make the cleanup it runs to its end, the underlying
ib_device was freed then uverbs_close will call
ib_uverbs_cleanup_ucontext and OOPs.

Above might happen if uverbs_close deleted the file from the list
then remove_one didn't find it and runs to its end.

Fixes to protect against that case by a new cleanup lock so that
ib_uverbs_cleanup_ucontext will be called always before that
remove_one is ended.

Fixes: 35d4a0b63dc0 ("IB/uverbs: Fix race between ib_uverbs_open and remove_one")
Reported-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 37 +++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b7f3b8d..df26a74 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -116,6 +116,7 @@ struct ib_uverbs_event_file {
 struct ib_uverbs_file {
 	struct kref				ref;
 	struct mutex				mutex;
+	struct mutex                            cleanup_mutex; /* protect cleanup */
 	struct ib_uverbs_device		       *device;
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 426e0ac..0012fa5 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -969,6 +969,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	file->async_file = NULL;
 	kref_init(&file->ref);
 	mutex_init(&file->mutex);
+	mutex_init(&file->cleanup_mutex);
 
 	filp->private_data = file;
 	kobject_get(&dev->kobj);
@@ -994,18 +995,20 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_device *dev = file->device;
-	struct ib_ucontext *ucontext = NULL;
+
+	mutex_lock(&file->cleanup_mutex);
+	if (file->ucontext) {
+		ib_uverbs_cleanup_ucontext(file, file->ucontext);
+		file->ucontext = NULL;
+	}
+	mutex_unlock(&file->cleanup_mutex);
 
 	mutex_lock(&file->device->lists_mutex);
-	ucontext = file->ucontext;
-	file->ucontext = NULL;
 	if (!file->is_closed) {
 		list_del(&file->list);
 		file->is_closed = 1;
 	}
 	mutex_unlock(&file->device->lists_mutex);
-	if (ucontext)
-		ib_uverbs_cleanup_ucontext(file, ucontext);
 
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
@@ -1219,22 +1222,30 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 	mutex_lock(&uverbs_dev->lists_mutex);
 	while (!list_empty(&uverbs_dev->uverbs_file_list)) {
 		struct ib_ucontext *ucontext;
-
 		file = list_first_entry(&uverbs_dev->uverbs_file_list,
 					struct ib_uverbs_file, list);
 		file->is_closed = 1;
-		ucontext = file->ucontext;
 		list_del(&file->list);
-		file->ucontext = NULL;
 		kref_get(&file->ref);
 		mutex_unlock(&uverbs_dev->lists_mutex);
-		/* We must release the mutex before going ahead and calling
-		 * disassociate_ucontext. disassociate_ucontext might end up
-		 * indirectly calling uverbs_close, for example due to freeing
-		 * the resources (e.g mmput).
-		 */
+
 		ib_uverbs_event_handler(&file->event_handler, &event);
+
+		mutex_lock(&file->cleanup_mutex);
+		ucontext = file->ucontext;
+		file->ucontext = NULL;
+		mutex_unlock(&file->cleanup_mutex);
+
+		/* At this point ib_uverbs_close cannot be running
+		 * ib_uverbs_cleanup_ucontext
+		 */
 		if (ucontext) {
+			/* We must release the mutex before going ahead and
+			 * calling disassociate_ucontext. disassociate_ucontext
+			 * might end up indirectly calling uverbs_close,
+			 * for example due to freeing the resources
+			 * (e.g mmput).
+			 */
 			ib_dev->disassociate_ucontext(ucontext);
 			ib_uverbs_cleanup_ucontext(file, ucontext);
 		}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
