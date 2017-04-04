From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 7/7] IB/core: Change completion channel to use the reworked objects schema
Date: Tue,  4 Apr 2017 13:31:47 +0300
Message-ID: <1491301907-32290-8-git-send-email-matanb@mellanox.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491301907-32290-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the standard fd based type - completion_channel.
The completion_channel is now prefixed with ib_uobject, similarly
to the rest of the uobjects.
This requires a few changes:
(1) We define a new completion channel fd based object type.
(2) completion_event and async_event are now two different types.
    This means they use different fops.
(3) We release the completion_channel exactly as we release other
    idr based objects.
(4) Since ib_uobjects are already kref-ed, we only add the kref to the
    async event.

A fd object requires filling out several parameters. Its op pointer
should point to uverbs_fd_ops and its size should be at least the
size if ib_uobject. We use a macro to make the type declaration
easier.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h           |  26 ++-
 drivers/infiniband/core/uverbs_cmd.c       |  57 +++---
 drivers/infiniband/core/uverbs_main.c      | 279 +++++++++++++++++------------
 drivers/infiniband/core/uverbs_std_types.c |  33 +++-
 include/rdma/uverbs_std_types.h            |   1 +
 include/rdma/uverbs_types.h                |   9 +
 6 files changed, 257 insertions(+), 148 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 5f8a7f2..826f827 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -102,17 +102,25 @@ struct ib_uverbs_device {
 };
 
 struct ib_uverbs_event_file {
-	struct kref				ref;
-	int					is_async;
-	struct ib_uverbs_file		       *uverbs_file;
 	spinlock_t				lock;
 	int					is_closed;
 	wait_queue_head_t			poll_wait;
 	struct fasync_struct		       *async_queue;
 	struct list_head			event_list;
+};
+
+struct ib_uverbs_async_event_file {
+	struct ib_uverbs_event_file		ev_file;
+	struct ib_uverbs_file		       *uverbs_file;
+	struct kref				ref;
 	struct list_head			list;
 };
 
+struct ib_uverbs_completion_event_file {
+	struct ib_uobject_file			uobj_file;
+	struct ib_uverbs_event_file		ev_file;
+};
+
 struct ib_uverbs_file {
 	struct kref				ref;
 	struct mutex				mutex;
@@ -120,7 +128,7 @@ struct ib_uverbs_file {
 	struct ib_uverbs_device		       *device;
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
-	struct ib_uverbs_event_file	       *async_file;
+	struct ib_uverbs_async_event_file       *async_file;
 	struct list_head			list;
 	int					is_closed;
 
@@ -182,14 +190,14 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device *ib_dev,
-					int is_async);
+extern const struct file_operations uverbs_event_fops;
+void ib_uverbs_init_event_file(struct ib_uverbs_event_file *ev_file);
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device *ib_dev);
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *uverbs_file);
-struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
-			   struct ib_uverbs_event_file *ev_file,
+			   struct ib_uverbs_completion_event_file *ev_file,
 			   struct ib_ucq_object *uobj);
 void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 			      struct ib_uevent_object *uobj);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 119c10d..b9024fa 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -47,6 +47,24 @@
 #include "uverbs.h"
 #include "core_priv.h"
 
+static struct ib_uverbs_completion_event_file *
+ib_uverbs_lookup_comp_file(int fd, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj = uobj_get_read(uobj_get_type(comp_channel),
+						fd, context);
+	struct ib_uobject_file *uobj_file;
+
+	if (IS_ERR(uobj))
+		return (void *)uobj;
+
+	uverbs_uobject_get(uobj);
+	uobj_put_read(uobj);
+
+	uobj_file = container_of(uobj, struct ib_uobject_file, uobj);
+	return container_of(uobj_file, struct ib_uverbs_completion_event_file,
+			    uobj_file);
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -116,7 +134,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_free;
 	resp.async_fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
+	filp = ib_uverbs_alloc_async_event_file(file, ib_dev);
 	if (IS_ERR(filp)) {
 		ret = PTR_ERR(filp);
 		goto err_fd;
@@ -908,8 +926,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
-	struct file				  *filp;
-	int ret;
+	struct ib_uobject			  *uobj;
+	struct ib_uverbs_completion_event_file	  *ev_file;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -917,25 +935,23 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		return ret;
-	resp.fd = ret;
+	uobj = uobj_alloc(uobj_get_type(comp_channel), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
 
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 0);
-	if (IS_ERR(filp)) {
-		put_unused_fd(resp.fd);
-		return PTR_ERR(filp);
-	}
+	resp.fd = uobj->id;
+
+	ev_file = container_of(uobj, struct ib_uverbs_completion_event_file,
+			       uobj_file.uobj);
+	ib_uverbs_init_event_file(&ev_file->ev_file);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
-		put_unused_fd(resp.fd);
-		fput(filp);
+		uobj_alloc_abort(uobj);
 		return -EFAULT;
 	}
 
-	fd_install(resp.fd, filp);
+	uobj_alloc_commit(uobj);
 	return in_len;
 }
 
@@ -953,7 +969,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 				       void *context)
 {
 	struct ib_ucq_object           *obj;
-	struct ib_uverbs_event_file    *ev_file = NULL;
+	struct ib_uverbs_completion_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
 	int                             ret;
 	struct ib_uverbs_ex_create_cq_resp resp;
@@ -968,9 +984,10 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		return obj;
 
 	if (cmd->comp_channel >= 0) {
-		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
-		if (!ev_file) {
-			ret = -EINVAL;
+		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel,
+						     file->ucontext);
+		if (IS_ERR(ev_file)) {
+			ret = PTR_ERR(ev_file);
 			goto err;
 		}
 	}
@@ -998,7 +1015,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	cq->uobject       = &obj->uobject;
 	cq->comp_handler  = ib_uverbs_comp_handler;
 	cq->event_handler = ib_uverbs_cq_event_handler;
-	cq->cq_context    = ev_file;
+	cq->cq_context    = &ev_file->ev_file;
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8ee1d08..0b0dab8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -156,37 +156,37 @@ static void ib_uverbs_release_dev(struct kobject *kobj)
 	.release = ib_uverbs_release_dev,
 };
 
-static void ib_uverbs_release_event_file(struct kref *ref)
+static void ib_uverbs_release_async_event_file(struct kref *ref)
 {
-	struct ib_uverbs_event_file *file =
-		container_of(ref, struct ib_uverbs_event_file, ref);
+	struct ib_uverbs_async_event_file *file =
+		container_of(ref, struct ib_uverbs_async_event_file, ref);
 
 	kfree(file);
 }
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
-			  struct ib_uverbs_event_file *ev_file,
+			  struct ib_uverbs_completion_event_file *ev_file,
 			  struct ib_ucq_object *uobj)
 {
 	struct ib_uverbs_event *evt, *tmp;
 
 	if (ev_file) {
-		spin_lock_irq(&ev_file->lock);
+		spin_lock_irq(&ev_file->ev_file.lock);
 		list_for_each_entry_safe(evt, tmp, &uobj->comp_list, obj_list) {
 			list_del(&evt->list);
 			kfree(evt);
 		}
-		spin_unlock_irq(&ev_file->lock);
+		spin_unlock_irq(&ev_file->ev_file.lock);
 
-		kref_put(&ev_file->ref, ib_uverbs_release_event_file);
+		uverbs_uobject_put(&ev_file->uobj_file.uobj);
 	}
 
-	spin_lock_irq(&file->async_file->lock);
+	spin_lock_irq(&file->async_file->ev_file.lock);
 	list_for_each_entry_safe(evt, tmp, &uobj->async_list, obj_list) {
 		list_del(&evt->list);
 		kfree(evt);
 	}
-	spin_unlock_irq(&file->async_file->lock);
+	spin_unlock_irq(&file->async_file->ev_file.lock);
 }
 
 void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
@@ -194,12 +194,12 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_event *evt, *tmp;
 
-	spin_lock_irq(&file->async_file->lock);
+	spin_lock_irq(&file->async_file->ev_file.lock);
 	list_for_each_entry_safe(evt, tmp, &uobj->event_list, obj_list) {
 		list_del(&evt->list);
 		kfree(evt);
 	}
-	spin_unlock_irq(&file->async_file->lock);
+	spin_unlock_irq(&file->async_file->ev_file.lock);
 }
 
 void ib_uverbs_detach_umcast(struct ib_qp *qp,
@@ -253,10 +253,12 @@ void ib_uverbs_release_file(struct kref *ref)
 	kfree(file);
 }
 
-static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
-				    size_t count, loff_t *pos)
+static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_file *file,
+				    struct ib_uverbs_file *uverbs_file,
+				    struct file *filp, char __user *buf,
+				    size_t count, loff_t *pos,
+				    bool is_async)
 {
-	struct ib_uverbs_event_file *file = filp->private_data;
 	struct ib_uverbs_event *event;
 	int eventsz;
 	int ret = 0;
@@ -275,12 +277,12 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 			 * and wake_up() guarentee this will see the null set
 			 * without using RCU
 			 */
-					     !file->uverbs_file->device->ib_dev)))
+					     !uverbs_file->device->ib_dev)))
 			return -ERESTARTSYS;
 
 		/* If device was disassociated and no event exists set an error */
 		if (list_empty(&file->event_list) &&
-		    !file->uverbs_file->device->ib_dev)
+		    !uverbs_file->device->ib_dev)
 			return -EIO;
 
 		spin_lock_irq(&file->lock);
@@ -288,7 +290,7 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 
 	event = list_entry(file->event_list.next, struct ib_uverbs_event, list);
 
-	if (file->is_async)
+	if (is_async)
 		eventsz = sizeof (struct ib_uverbs_async_event_desc);
 	else
 		eventsz = sizeof (struct ib_uverbs_comp_event_desc);
@@ -318,11 +320,31 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 	return ret;
 }
 
-static unsigned int ib_uverbs_event_poll(struct file *filp,
+static ssize_t ib_uverbs_async_event_read(struct file *filp, char __user *buf,
+					  size_t count, loff_t *pos)
+{
+	struct ib_uverbs_async_event_file *file = filp->private_data;
+
+	return ib_uverbs_event_read(&file->ev_file, file->uverbs_file, filp,
+				    buf, count, pos, true);
+}
+
+static ssize_t ib_uverbs_comp_event_read(struct file *filp, char __user *buf,
+					 size_t count, loff_t *pos)
+{
+	struct ib_uverbs_completion_event_file *comp_ev_file =
+		filp->private_data;
+
+	return ib_uverbs_event_read(&comp_ev_file->ev_file,
+				    comp_ev_file->uobj_file.ufile, filp,
+				    buf, count, pos, false);
+}
+
+static unsigned int ib_uverbs_event_poll(struct ib_uverbs_event_file *file,
+					 struct file *filp,
 					 struct poll_table_struct *wait)
 {
 	unsigned int pollflags = 0;
-	struct ib_uverbs_event_file *file = filp->private_data;
 
 	poll_wait(filp, &file->poll_wait, wait);
 
@@ -334,49 +356,98 @@ static unsigned int ib_uverbs_event_poll(struct file *filp,
 	return pollflags;
 }
 
-static int ib_uverbs_event_fasync(int fd, struct file *filp, int on)
+static unsigned int ib_uverbs_async_event_poll(struct file *filp,
+					       struct poll_table_struct *wait)
+{
+	return ib_uverbs_event_poll(filp->private_data, filp, wait);
+}
+
+static unsigned int ib_uverbs_comp_event_poll(struct file *filp,
+					      struct poll_table_struct *wait)
+{
+	struct ib_uverbs_completion_event_file *comp_ev_file =
+		filp->private_data;
+
+	return ib_uverbs_event_poll(&comp_ev_file->ev_file, filp, wait);
+}
+
+static int ib_uverbs_async_event_fasync(int fd, struct file *filp, int on)
 {
 	struct ib_uverbs_event_file *file = filp->private_data;
 
 	return fasync_helper(fd, filp, on, &file->async_queue);
 }
 
-static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
+static int ib_uverbs_comp_event_fasync(int fd, struct file *filp, int on)
 {
-	struct ib_uverbs_event_file *file = filp->private_data;
+	struct ib_uverbs_completion_event_file *comp_ev_file =
+		filp->private_data;
+
+	return fasync_helper(fd, filp, on, &comp_ev_file->ev_file.async_queue);
+}
+
+static int ib_uverbs_async_event_close(struct inode *inode, struct file *filp)
+{
+	struct ib_uverbs_async_event_file *file = filp->private_data;
+	struct ib_uverbs_file *uverbs_file = file->uverbs_file;
 	struct ib_uverbs_event *entry, *tmp;
 	int closed_already = 0;
 
-	mutex_lock(&file->uverbs_file->device->lists_mutex);
-	spin_lock_irq(&file->lock);
-	closed_already = file->is_closed;
-	file->is_closed = 1;
-	list_for_each_entry_safe(entry, tmp, &file->event_list, list) {
+	mutex_lock(&uverbs_file->device->lists_mutex);
+	spin_lock_irq(&file->ev_file.lock);
+	closed_already = file->ev_file.is_closed;
+	file->ev_file.is_closed = 1;
+	list_for_each_entry_safe(entry, tmp, &file->ev_file.event_list, list) {
 		if (entry->counter)
 			list_del(&entry->obj_list);
 		kfree(entry);
 	}
-	spin_unlock_irq(&file->lock);
+	spin_unlock_irq(&file->ev_file.lock);
 	if (!closed_already) {
 		list_del(&file->list);
-		if (file->is_async)
-			ib_unregister_event_handler(&file->uverbs_file->
-				event_handler);
+		ib_unregister_event_handler(&uverbs_file->event_handler);
+	}
+	mutex_unlock(&uverbs_file->device->lists_mutex);
+
+	kref_put(&uverbs_file->ref, ib_uverbs_release_file);
+	kref_put(&file->ref, ib_uverbs_release_async_event_file);
+
+	return 0;
+}
+
+static int ib_uverbs_comp_event_close(struct inode *inode, struct file *filp)
+{
+	struct ib_uverbs_completion_event_file *file = filp->private_data;
+	struct ib_uverbs_event *entry, *tmp;
+
+	spin_lock_irq(&file->ev_file.lock);
+	list_for_each_entry_safe(entry, tmp, &file->ev_file.event_list, list) {
+		if (entry->counter)
+			list_del(&entry->obj_list);
+		kfree(entry);
 	}
-	mutex_unlock(&file->uverbs_file->device->lists_mutex);
+	spin_unlock_irq(&file->ev_file.lock);
 
-	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
-	kref_put(&file->ref, ib_uverbs_release_event_file);
+	uverbs_close_fd(filp);
 
 	return 0;
 }
 
-static const struct file_operations uverbs_event_fops = {
+const struct file_operations uverbs_event_fops = {
 	.owner	 = THIS_MODULE,
-	.read	 = ib_uverbs_event_read,
-	.poll    = ib_uverbs_event_poll,
-	.release = ib_uverbs_event_close,
-	.fasync  = ib_uverbs_event_fasync,
+	.read	 = ib_uverbs_comp_event_read,
+	.poll    = ib_uverbs_comp_event_poll,
+	.release = ib_uverbs_comp_event_close,
+	.fasync  = ib_uverbs_comp_event_fasync,
+	.llseek	 = no_llseek,
+};
+
+static const struct file_operations uverbs_async_event_fops = {
+	.owner	 = THIS_MODULE,
+	.read	 = ib_uverbs_async_event_read,
+	.poll    = ib_uverbs_async_event_poll,
+	.release = ib_uverbs_async_event_close,
+	.fasync  = ib_uverbs_async_event_fasync,
 	.llseek	 = no_llseek,
 };
 
@@ -423,15 +494,15 @@ static void ib_uverbs_async_handler(struct ib_uverbs_file *file,
 	struct ib_uverbs_event *entry;
 	unsigned long flags;
 
-	spin_lock_irqsave(&file->async_file->lock, flags);
-	if (file->async_file->is_closed) {
-		spin_unlock_irqrestore(&file->async_file->lock, flags);
+	spin_lock_irqsave(&file->async_file->ev_file.lock, flags);
+	if (file->async_file->ev_file.is_closed) {
+		spin_unlock_irqrestore(&file->async_file->ev_file.lock, flags);
 		return;
 	}
 
 	entry = kmalloc(sizeof *entry, GFP_ATOMIC);
 	if (!entry) {
-		spin_unlock_irqrestore(&file->async_file->lock, flags);
+		spin_unlock_irqrestore(&file->async_file->ev_file.lock, flags);
 		return;
 	}
 
@@ -440,13 +511,13 @@ static void ib_uverbs_async_handler(struct ib_uverbs_file *file,
 	entry->desc.async.reserved   = 0;
 	entry->counter               = counter;
 
-	list_add_tail(&entry->list, &file->async_file->event_list);
+	list_add_tail(&entry->list, &file->async_file->ev_file.event_list);
 	if (obj_list)
 		list_add_tail(&entry->obj_list, obj_list);
-	spin_unlock_irqrestore(&file->async_file->lock, flags);
+	spin_unlock_irqrestore(&file->async_file->ev_file.lock, flags);
 
-	wake_up_interruptible(&file->async_file->poll_wait);
-	kill_fasync(&file->async_file->async_queue, SIGIO, POLL_IN);
+	wake_up_interruptible(&file->async_file->ev_file.poll_wait);
+	kill_fasync(&file->async_file->ev_file.async_queue, SIGIO, POLL_IN);
 }
 
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr)
@@ -509,15 +580,23 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
 {
-	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+	kref_put(&file->async_file->ref, ib_uverbs_release_async_event_file);
 	file->async_file = NULL;
 }
 
-struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					struct ib_device	*ib_dev,
-					int is_async)
+void ib_uverbs_init_event_file(struct ib_uverbs_event_file *ev_file)
 {
-	struct ib_uverbs_event_file *ev_file;
+	spin_lock_init(&ev_file->lock);
+	INIT_LIST_HEAD(&ev_file->event_list);
+	init_waitqueue_head(&ev_file->poll_wait);
+	ev_file->is_closed   = 0;
+	ev_file->async_queue = NULL;
+}
+
+struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
+					      struct ib_device	*ib_dev)
+{
+	struct ib_uverbs_async_event_file *ev_file;
 	struct file *filp;
 	int ret;
 
@@ -525,16 +604,11 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	if (!ev_file)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&ev_file->ref);
-	spin_lock_init(&ev_file->lock);
-	INIT_LIST_HEAD(&ev_file->event_list);
-	init_waitqueue_head(&ev_file->poll_wait);
+	ib_uverbs_init_event_file(&ev_file->ev_file);
 	ev_file->uverbs_file = uverbs_file;
 	kref_get(&ev_file->uverbs_file->ref);
-	ev_file->async_queue = NULL;
-	ev_file->is_closed   = 0;
-
-	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
+	kref_init(&ev_file->ref);
+	filp = anon_inode_getfile("[infinibandevent]", &uverbs_async_event_fops,
 				  ev_file, O_RDONLY);
 	if (IS_ERR(filp))
 		goto err_put_refs;
@@ -544,64 +618,33 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 		      &uverbs_file->device->uverbs_events_file_list);
 	mutex_unlock(&uverbs_file->device->lists_mutex);
 
-	if (is_async) {
-		WARN_ON(uverbs_file->async_file);
-		uverbs_file->async_file = ev_file;
-		kref_get(&uverbs_file->async_file->ref);
-		INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
-				      ib_dev,
-				      ib_uverbs_event_handler);
-		ret = ib_register_event_handler(&uverbs_file->event_handler);
-		if (ret)
-			goto err_put_file;
-
-		/* At that point async file stuff was fully set */
-		ev_file->is_async = 1;
-	}
+	WARN_ON(uverbs_file->async_file);
+	uverbs_file->async_file = ev_file;
+	kref_get(&uverbs_file->async_file->ref);
+	INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
+			      ib_dev,
+			      ib_uverbs_event_handler);
+	ret = ib_register_event_handler(&uverbs_file->event_handler);
+	if (ret)
+		goto err_put_file;
+
+	/* At that point async file stuff was fully set */
 
 	return filp;
 
 err_put_file:
 	fput(filp);
-	kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_event_file);
+	kref_put(&uverbs_file->async_file->ref,
+		 ib_uverbs_release_async_event_file);
 	uverbs_file->async_file = NULL;
 	return ERR_PTR(ret);
 
 err_put_refs:
 	kref_put(&ev_file->uverbs_file->ref, ib_uverbs_release_file);
-	kref_put(&ev_file->ref, ib_uverbs_release_event_file);
+	kref_put(&ev_file->ref, ib_uverbs_release_async_event_file);
 	return filp;
 }
 
-/*
- * Look up a completion event file by FD.  If lookup is successful,
- * takes a ref to the event file struct that it returns; if
- * unsuccessful, returns NULL.
- */
-struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd)
-{
-	struct ib_uverbs_event_file *ev_file = NULL;
-	struct fd f = fdget(fd);
-
-	if (!f.file)
-		return NULL;
-
-	if (f.file->f_op != &uverbs_event_fops)
-		goto out;
-
-	ev_file = f.file->private_data;
-	if (ev_file->is_async) {
-		ev_file = NULL;
-		goto out;
-	}
-
-	kref_get(&ev_file->ref);
-
-out:
-	fdput(f);
-	return ev_file;
-}
-
 static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
 {
 	u64 mask;
@@ -896,7 +939,8 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->device->lists_mutex);
 
 	if (file->async_file)
-		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
+		kref_put(&file->async_file->ref,
+			 ib_uverbs_release_async_event_file);
 
 	kref_put(&file->ref, ib_uverbs_release_file);
 	kobject_put(&dev->kobj);
@@ -1095,7 +1139,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 					struct ib_device *ib_dev)
 {
 	struct ib_uverbs_file *file;
-	struct ib_uverbs_event_file *event_file;
+	struct ib_uverbs_async_event_file *event_file;
 	struct ib_event event;
 
 	/* Pending running commands to terminate */
@@ -1144,21 +1188,20 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 	while (!list_empty(&uverbs_dev->uverbs_events_file_list)) {
 		event_file = list_first_entry(&uverbs_dev->
 					      uverbs_events_file_list,
-					      struct ib_uverbs_event_file,
+					      struct ib_uverbs_async_event_file,
 					      list);
-		spin_lock_irq(&event_file->lock);
-		event_file->is_closed = 1;
-		spin_unlock_irq(&event_file->lock);
+		spin_lock_irq(&event_file->ev_file.lock);
+		event_file->ev_file.is_closed = 1;
+		spin_unlock_irq(&event_file->ev_file.lock);
 
 		list_del(&event_file->list);
-		if (event_file->is_async) {
-			ib_unregister_event_handler(&event_file->uverbs_file->
-						    event_handler);
-			event_file->uverbs_file->event_handler.device = NULL;
-		}
+		ib_unregister_event_handler(
+			&event_file->uverbs_file->event_handler);
+		event_file->uverbs_file->event_handler.device =
+			NULL;
 
-		wake_up_interruptible(&event_file->poll_wait);
-		kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
+		wake_up_interruptible(&event_file->ev_file.poll_wait);
+		kill_fasync(&event_file->ev_file.async_queue, SIGIO, POLL_IN);
 	}
 	mutex_unlock(&uverbs_dev->lists_mutex);
 }
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index a514556..7f26af5 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -145,7 +145,11 @@ int uverbs_free_cq(struct ib_uobject *uobject,
 
 	ret = ib_destroy_cq(cq);
 	if (!ret || why != RDMA_REMOVE_DESTROY)
-		ib_uverbs_release_ucq(uobject->context->ufile, ev_file, ucq);
+		ib_uverbs_release_ucq(uobject->context->ufile, ev_file ?
+				      container_of(ev_file,
+						   struct ib_uverbs_completion_event_file,
+						   ev_file) : NULL,
+				      ucq);
 	return ret;
 }
 
@@ -186,6 +190,33 @@ int uverbs_free_pd(struct ib_uobject *uobject,
 	return 0;
 }
 
+int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_file,
+					    enum rdma_remove_reason why)
+{
+	struct ib_uverbs_completion_event_file *comp_event_file =
+		container_of(uobj_file, struct ib_uverbs_completion_event_file,
+			     uobj_file);
+	struct ib_uverbs_event_file *event_file = &comp_event_file->ev_file;
+
+	spin_lock_irq(&event_file->lock);
+	event_file->is_closed = 1;
+	spin_unlock_irq(&event_file->lock);
+
+	if (why == RDMA_REMOVE_DRIVER_REMOVE) {
+		wake_up_interruptible(&event_file->poll_wait);
+		kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
+	}
+	return 0;
+};
+
+const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel = {
+	.type = UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_completion_event_file), 0),
+	.context_closed = uverbs_hot_unplug_completion_event_file,
+	.fops = &uverbs_event_fops,
+	.name = "[infinibandevent]",
+	.flags = O_RDONLY,
+};
+
 const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
 	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0),
 	.destroy_object = uverbs_free_cq,
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 8885664..7771ce9 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -35,6 +35,7 @@
 
 #include <rdma/uverbs_types.h>
 
+extern const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel;
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_cq;
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_qp;
 extern const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table;
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index 5867429..a376921 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -146,9 +146,18 @@ struct uverbs_obj_fd_type {
 };
 
 extern const struct uverbs_obj_type_class uverbs_idr_class;
+extern const struct uverbs_obj_type_class uverbs_fd_class;
 
 #define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
 				   sizeof(char))
+#define UVERBS_TYPE_ALLOC_FD(_size, _order)				 \
+	{								 \
+		.destroy_order = _order,				 \
+		.type_class = &uverbs_fd_class,				 \
+		.obj_size = (_size) +					 \
+			  UVERBS_BUILD_BUG_ON((_size) <			 \
+					      sizeof(struct ib_uobject_file)),\
+	}
 #define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order)				\
 	{								\
 		.destroy_order = _order,				\
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
