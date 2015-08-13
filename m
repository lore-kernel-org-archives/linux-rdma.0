From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V8 1/6] IB/uverbs: Fix reference counting usage of event files
Date: Thu, 13 Aug 2015 18:32:02 +0300
Message-ID: <1439479927-8751-2-git-send-email-yishaih@mellanox.com>
References: <1439479927-8751-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439479927-8751-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix the reference counting usage to be handled in the event file
creation/destruction function, instead of being done by the caller.
This is done for both async/non-async event files.

Based on Jason Gunthorpe report at https://www.mail-archive.com/
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg24680.html:
"The existing code for this is broken, in ib_uverbs_get_context all
the error paths between ib_uverbs_alloc_event_file and the
kref_get(file->ref) are wrong - this will result in fput() which will
call ib_uverbs_event_close, which will try to do kref_put and
ib_unregister_event_handler - which are no longer paired."

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    1 +
 drivers/infiniband/core/uverbs_cmd.c  |   11 +-------
 drivers/infiniband/core/uverbs_main.c |   44 ++++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ba365b6..60e6e3d 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -178,6 +178,7 @@ void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					int is_async);
+void ib_uverbs_free_async_event_file(struct ib_uverbs_file *uverbs_file);
 struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ff..5720a92 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -367,16 +367,6 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_file;
 	}
 
-	file->async_file = filp->private_data;
-
-	INIT_IB_EVENT_HANDLER(&file->event_handler, file->device->ib_dev,
-			      ib_uverbs_event_handler);
-	ret = ib_register_event_handler(&file->event_handler);
-	if (ret)
-		goto err_file;
-
-	kref_get(&file->async_file->ref);
-	kref_get(&file->ref);
 	file->ucontext = ucontext;
 
 	fd_install(resp.async_fd, filp);
@@ -386,6 +376,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	return in_len;
 
 err_file:
+	ib_uverbs_free_async_event_file(file);
 	fput(filp);
 
 err_fd:
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f6eef2d..c238eba 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -406,10 +406,9 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	}
 	spin_unlock_irq(&file->lock);
 
-	if (file->is_async) {
+	if (file->is_async)
 		ib_unregister_event_handler(&file->uverbs_file->event_handler);
-		kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
-	}
+	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
 	kref_put(&file->ref, ib_uverbs_release_event_file);
 
 	return 0;
@@ -541,13 +540,20 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 				NULL, NULL);
 }
 
+void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
+{
+	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+	file->async_file = NULL;
+}
+
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					int is_async)
 {
 	struct ib_uverbs_event_file *ev_file;
 	struct file *filp;
+	int ret;
 
-	ev_file = kmalloc(sizeof *ev_file, GFP_KERNEL);
+	ev_file = kzalloc(sizeof(*ev_file), GFP_KERNEL);
 	if (!ev_file)
 		return ERR_PTR(-ENOMEM);
 
@@ -556,15 +562,41 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	INIT_LIST_HEAD(&ev_file->event_list);
 	init_waitqueue_head(&ev_file->poll_wait);
 	ev_file->uverbs_file = uverbs_file;
+	kref_get(&ev_file->uverbs_file->ref);
 	ev_file->async_queue = NULL;
-	ev_file->is_async    = is_async;
 	ev_file->is_closed   = 0;
 
 	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
 				  ev_file, O_RDONLY);
 	if (IS_ERR(filp))
-		kfree(ev_file);
+		goto err_put_refs;
+
+	if (is_async) {
+		WARN_ON(uverbs_file->async_file);
+		uverbs_file->async_file = ev_file;
+		kref_get(&uverbs_file->async_file->ref);
+		INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
+				      uverbs_file->device->ib_dev,
+				      ib_uverbs_event_handler);
+		ret = ib_register_event_handler(&uverbs_file->event_handler);
+		if (ret)
+			goto err_put_file;
+
+		/* At that point async file stuff was fully set */
+		ev_file->is_async = 1;
+	}
+
+	return filp;
+
+err_put_file:
+	fput(filp);
+	kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_event_file);
+	uverbs_file->async_file = NULL;
+	return ERR_PTR(ret);
 
+err_put_refs:
+	kref_put(&ev_file->uverbs_file->ref, ib_uverbs_release_file);
+	kref_put(&ev_file->ref, ib_uverbs_release_event_file);
 	return filp;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
