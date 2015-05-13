From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 3/3] IB/ucma: HW Device hot-removal support
Date: Wed, 13 May 2015 14:10:38 +0300
Message-ID: <1431515438-24042-4-git-send-email-yishaih@mellanox.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431515438-24042-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently, IB/cma remove_one flow blocks until all user descriptor managed by
IB/ucma are released. This prevents hot-removal of IB devices. This patch
allows IB/cma to remove devices regardless of user space activity. Upon getting
the RDMA_CM_EVENT_DEVICE_REMOVAL event we close all the underlying HW resources
for the given ucontext. The ucontext itself is still alive till its explicit
destroying by its creator.

Running applications at that time will have some zombie device, further
operations may fail.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |  130 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 119 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 45d67e9..538cf8f 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -74,6 +74,7 @@ struct ucma_file {
 	struct list_head	ctx_list;
 	struct list_head	event_list;
 	wait_queue_head_t	poll_wait;
+	struct workqueue_struct	*close_wq;
 };
 
 struct ucma_context {
@@ -89,6 +90,9 @@ struct ucma_context {
 
 	struct list_head	list;
 	struct list_head	mc_list;
+	int			closing;
+	int			destroying;
+	struct work_struct	close_work;
 };
 
 struct ucma_multicast {
@@ -107,6 +111,7 @@ struct ucma_event {
 	struct list_head	list;
 	struct rdma_cm_id	*cm_id;
 	struct rdma_ucm_event_resp resp;
+	struct work_struct	close_work;
 };
 
 static DEFINE_MUTEX(mut);
@@ -132,8 +137,12 @@ static struct ucma_context *ucma_get_ctx(struct ucma_file *file, int id)
 
 	mutex_lock(&mut);
 	ctx = _ucma_find_context(id, file);
-	if (!IS_ERR(ctx))
-		atomic_inc(&ctx->ref);
+	if (!IS_ERR(ctx)) {
+		if (ctx->closing)
+			ctx = ERR_PTR(-EIO);
+		else
+			atomic_inc(&ctx->ref);
+	}
 	mutex_unlock(&mut);
 	return ctx;
 }
@@ -144,6 +153,34 @@ static void ucma_put_ctx(struct ucma_context *ctx)
 		complete(&ctx->comp);
 }
 
+static void ucma_close_event_id(struct work_struct *work)
+{
+	struct ucma_event *uevent_close =  container_of(work, struct ucma_event, close_work);
+
+	rdma_destroy_id(uevent_close->cm_id);
+	kfree(uevent_close);
+}
+
+static void ucma_close_id(struct work_struct *work)
+{
+	struct ucma_context *ctx =  container_of(work, struct ucma_context, close_work);
+
+	/* Fence to ensure that ctx->closing was seen by all
+	 * ucma_get_ctx running
+	 */
+	mutex_lock(&mut);
+	mutex_unlock(&mut);
+
+	/* once all inflight tasks are finished, we close all underlying
+	 * resources. The context is still alive till its explicit destryoing
+	 * by its creator.
+	 */
+	ucma_put_ctx(ctx);
+	wait_for_completion(&ctx->comp);
+	/* No new events will be generated after destroying the id. */
+	rdma_destroy_id(ctx->cm_id);
+}
+
 static struct ucma_context *ucma_alloc_ctx(struct ucma_file *file)
 {
 	struct ucma_context *ctx;
@@ -152,6 +189,7 @@ static struct ucma_context *ucma_alloc_ctx(struct ucma_file *file)
 	if (!ctx)
 		return NULL;
 
+	INIT_WORK(&ctx->close_work, ucma_close_id);
 	atomic_set(&ctx->ref, 1);
 	init_completion(&ctx->comp);
 	INIT_LIST_HEAD(&ctx->mc_list);
@@ -242,6 +280,42 @@ static void ucma_set_event_context(struct ucma_context *ctx,
 	}
 }
 
+/* Called with file->mut locked for the relevant context. */
+static void ucma_removal_event_handler(struct rdma_cm_id *cm_id)
+{
+	struct ucma_context *ctx = cm_id->context;
+	struct ucma_event *con_req_eve;
+	int event_found = 0;
+
+	if (ctx->destroying)
+		return;
+
+	/* only if context is pointing to cm_id that it owns it and can be
+	 * queued to be closed, otherwise that cm_id is an inflight one that
+	 * is part of that context event list pending to be detached and
+	 * reattached to its new context as part of ucma_get_event,
+	 * handled separately below.
+	 */
+	if (ctx->cm_id == cm_id) {
+		ctx->closing = 1;
+		queue_work(ctx->file->close_wq, &ctx->close_work);
+		return;
+	}
+
+	list_for_each_entry(con_req_eve, &ctx->file->event_list, list) {
+		if (con_req_eve->cm_id == cm_id &&
+		    con_req_eve->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST) {
+			list_del(&con_req_eve->list);
+			INIT_WORK(&con_req_eve->close_work, ucma_close_event_id);
+			queue_work(ctx->file->close_wq, &con_req_eve->close_work);
+			event_found = 1;
+			break;
+		}
+	}
+	if (!event_found)
+		printk(KERN_ERR "ucma_removal_event_handler: warning: connect request event wasn't found\n");
+}
+
 static int ucma_event_handler(struct rdma_cm_id *cm_id,
 			      struct rdma_cm_event *event)
 {
@@ -276,14 +350,21 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 		 * We ignore events for new connections until userspace has set
 		 * their context.  This can only happen if an error occurs on a
 		 * new connection before the user accepts it.  This is okay,
-		 * since the accept will just fail later.
+		 * since the accept will just fail later. However, we do need
+		 * to release the underlying HW resources in case of a device
+		 * removal event.
 		 */
+		if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+			ucma_removal_event_handler(cm_id);
+
 		kfree(uevent);
 		goto out;
 	}
 
 	list_add_tail(&uevent->list, &ctx->file->event_list);
 	wake_up_interruptible(&ctx->file->poll_wait);
+	if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+		ucma_removal_event_handler(cm_id);
 out:
 	mutex_unlock(&ctx->file->mut);
 	return ret;
@@ -442,9 +523,15 @@ static void ucma_cleanup_mc_events(struct ucma_multicast *mc)
 }
 
 /*
- * We cannot hold file->mut when calling rdma_destroy_id() or we can
- * deadlock.  We also acquire file->mut in ucma_event_handler(), and
- * rdma_destroy_id() will wait until all callbacks have completed.
+ * ucma_free_ctx is called after the underlying rdma CM-ID is destroyed. At
+ * this point, no new events will be reported from the hardware. However, we
+ * still need to cleanup the UCMA context for this ID. Specifically, there
+ * might be events that have not yet been consumed by the user space software.
+ * These might include pending connect requests which we have not completed
+ * processing.  We cannot call rdma_destroy_id while holding the lock of the
+ * context (file->mut), as it might cause a deadlock. We therefore extract all
+ * relevant events from the context pending events list while holding the
+ * mutex. After that we release them as needed.
  */
 static int ucma_free_ctx(struct ucma_context *ctx)
 {
@@ -452,8 +539,6 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 	struct ucma_event *uevent, *tmp;
 	LIST_HEAD(list);
 
-	/* No new events will be generated after destroying the id. */
-	rdma_destroy_id(ctx->cm_id);
 
 	ucma_cleanup_multicast(ctx);
 
@@ -501,10 +586,20 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	ucma_put_ctx(ctx);
-	wait_for_completion(&ctx->comp);
-	resp.events_reported = ucma_free_ctx(ctx);
+	mutex_lock(&ctx->file->mut);
+	ctx->destroying = 1;
+	mutex_unlock(&ctx->file->mut);
+
+	flush_workqueue(ctx->file->close_wq);
+	/* At this point it's guaranteed that there is no inflight
+	 * closing task */
+	if (!ctx->closing) {
+		ucma_put_ctx(ctx);
+		wait_for_completion(&ctx->comp);
+		rdma_destroy_id(ctx->cm_id);
+	}
 
+	resp.events_reported = ucma_free_ctx(ctx);
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
 			 &resp, sizeof(resp)))
 		ret = -EFAULT;
@@ -1542,6 +1637,7 @@ static int ucma_open(struct inode *inode, struct file *filp)
 	INIT_LIST_HEAD(&file->ctx_list);
 	init_waitqueue_head(&file->poll_wait);
 	mutex_init(&file->mut);
+	file->close_wq = create_singlethread_workqueue("ucma_close_id");
 
 	filp->private_data = file;
 	file->filp = filp;
@@ -1556,16 +1652,28 @@ static int ucma_close(struct inode *inode, struct file *filp)
 
 	mutex_lock(&file->mut);
 	list_for_each_entry_safe(ctx, tmp, &file->ctx_list, list) {
+		ctx->destroying = 1;
 		mutex_unlock(&file->mut);
 
 		mutex_lock(&mut);
 		idr_remove(&ctx_idr, ctx->id);
 		mutex_unlock(&mut);
 
+		flush_workqueue(file->close_wq);
+		/* At that step once ctx was marked as destroying and workqueue
+		 * was flushed we are safe from any inflights handlers that
+		 * might put other closing task.
+		 */
+		if (!ctx->closing)
+			/* rdma_destroy_id ensures that no event handlers are
+			 * inflight for that id before releasing it.
+			 */
+			rdma_destroy_id(ctx->cm_id);
 		ucma_free_ctx(ctx);
 		mutex_lock(&file->mut);
 	}
 	mutex_unlock(&file->mut);
+	destroy_workqueue(file->close_wq);
 	kfree(file);
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
