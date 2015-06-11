From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V4 1/5] IB/uverbs: Fix reference counting usage of event files
Date: Thu, 11 Jun 2015 15:56:50 +0300
Message-ID: <1434027414-711-2-git-send-email-yishaih@mellanox.com>
References: <1434027414-711-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434027414-711-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
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
---
 drivers/infiniband/core/uverbs_cmd.c  |    9 ---------
 drivers/infiniband/core/uverbs_main.c |   26 ++++++++++++++++++++++----
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a9f0489..0bbab72 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -367,16 +367,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
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
 	kref_get(&file->async_file->ref);
-	kref_get(&file->ref);
 	file->ucontext = ucontext;
 
 	fd_install(resp.async_fd, filp);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 88cce9b..882d24d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -405,10 +405,9 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
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
@@ -545,6 +544,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 {
 	struct ib_uverbs_event_file *ev_file;
 	struct file *filp;
+	int ret;
 
 	ev_file = kmalloc(sizeof *ev_file, GFP_KERNEL);
 	if (!ev_file)
@@ -562,8 +562,26 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
 				  ev_file, O_RDONLY);
 	if (IS_ERR(filp))
-		kfree(ev_file);
+		goto err;
 
+	if (is_async) {
+		uverbs_file->async_file = ev_file;
+		INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
+				      uverbs_file->device->ib_dev,
+				      ib_uverbs_event_handler);
+		ret = ib_register_event_handler(&uverbs_file->event_handler);
+		if (ret)
+			goto put_file;
+	}
+
+	kref_get(&uverbs_file->ref);
+	return filp;
+
+put_file:
+	fput(filp);
+	filp = ERR_PTR(ret);
+err:
+	kfree(ev_file);
 	return filp;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
