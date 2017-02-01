From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 6/7] IB/core: Add support for fd objects
Date: Wed,  1 Feb 2017 14:39:04 +0200
Message-ID: <1485952745-58476-7-git-send-email-matanb@mellanox.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485952745-58476-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The completion channel we use in verbs infrastructure is FD based.
Previously, we had a separate way to manage this object. Since we
strive for a single way to manage any kind of object in this
infrastructure, we conceptually treat all objects as subclasses
of ib_uobject.

This commit adds the necessary mechanism to support FD based objects
like their IDR counterparts. FD objects release need to be synchronized
with context release. We use the cleanup_mutex on the uverbs_file for
that.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c   | 157 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/rdma_core.h   |   7 ++
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_main.c |   4 +-
 include/rdma/ib_verbs.h               |   6 ++
 include/rdma/uverbs_types.h           |  16 ++++
 6 files changed, 189 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 7ce4d67..1d24f26 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -160,6 +160,73 @@ static void uverbs_uobject_add(struct ib_uobject *uobject)
 	mutex_unlock(&uobject->context->lock);
 }
 
+static struct ib_uobject *alloc_begin_fd_uobject(const struct uverbs_obj_type *type,
+						 struct ib_ucontext *ucontext)
+{
+	const struct uverbs_obj_fd_type *fd_type =
+		container_of(type, struct uverbs_obj_fd_type, type);
+	int new_fd;
+	struct ib_uobject_file *uobj_file = NULL;
+	struct file *filp;
+
+	new_fd = get_unused_fd_flags(O_CLOEXEC);
+	if (new_fd < 0)
+		return ERR_PTR(new_fd);
+
+	uobj_file = kmalloc(fd_type->obj_size, GFP_KERNEL);
+	if (!uobj_file) {
+		put_unused_fd(new_fd);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	filp = anon_inode_getfile(fd_type->name,
+				  fd_type->fops,
+				  uobj_file,
+				  fd_type->flags);
+	if (IS_ERR(filp)) {
+		put_unused_fd(new_fd);
+		kfree(uobj_file);
+		return (void *)filp;
+	}
+
+	init_uobj(&uobj_file->uobj, ucontext, type);
+	uobj_file->uobj.id = new_fd;
+	uobj_file->uobj.object = filp;
+	uobj_file->ufile = ucontext->ufile;
+
+	return &uobj_file->uobj;
+}
+
+static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *type,
+						struct ib_ucontext *ucontext,
+						int id, bool write)
+{
+	struct file *f;
+	struct ib_uobject *uobject;
+	const struct uverbs_obj_fd_type *fd_type =
+		container_of(type, struct uverbs_obj_fd_type, type);
+
+	if (write)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	f = fget(id);
+	if (!f)
+		return ERR_PTR(-EBADF);
+
+	uobject = f->private_data;
+	if (f->f_op != fd_type->fops ||
+	    !uobject->context) {
+		fput(f);
+		return ERR_PTR(-EBADF);
+	}
+
+	/*
+	 * No need to protect it with a ref count, as fget increases
+	 * f_count.
+	 */
+	return uobject;
+}
+
 static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
 {
 	uverbs_uobject_add(uobj);
@@ -196,6 +263,38 @@ static void lookup_put_idr_uobject(struct ib_uobject *uobj, bool write)
 		up_read(&uobj->currently_used);
 }
 
+static void lookup_put_fd_uobject(struct ib_uobject *uobj, bool write)
+{
+	struct file *filp = uobj->object;
+
+	WARN_ON(write);
+	fput(filp);
+}
+
+static void alloc_commit_fd_uobject(struct ib_uobject *uobj)
+{
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+
+	kref_get(&uobj_file->ufile->ref);
+	uverbs_uobject_add(&uobj_file->uobj);
+	fd_install(uobj_file->uobj.id, uobj->object);
+	/* This shouldn't be used anymore. Use the file object instead */
+	uobj_file->uobj.id = 0;
+}
+
+static void alloc_abort_fd_uobject(struct ib_uobject *uobj)
+{
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+	struct file *filp = uobj->object;
+
+	/* Unsuccessful NEW */
+	fput(filp);
+	put_unused_fd(uobj_file->uobj.id);
+	uverbs_uobject_put(&uobj_file->uobj);
+}
+
 static void destroy_commit_idr_uobject(struct ib_uobject *uobj)
 {
 	uverbs_idr_remove_uobj(uobj);
@@ -233,6 +332,16 @@ static void release_idr_uobject(struct ib_uobject *uobj)
 	kfree_rcu(uobj, rcu);
 }
 
+static void release_fd_uobject(struct ib_uobject *uobj)
+{
+	kfree(container_of(uobj, struct ib_uobject_file, uobj));
+}
+
+static void destroy_commit_null_uobject(struct ib_uobject *uobj)
+{
+	WARN_ON(true);
+}
+
 const struct uverbs_obj_type_ops uverbs_idr_ops = {
 	.alloc_begin = alloc_begin_idr_uobject,
 	.lookup_get = lookup_get_idr_uobject,
@@ -254,8 +363,15 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 
 		/*
 		 * This shouldn't run while executing other commands on this
-		 * context, thus no lock is required.
+		 * context. Thus, the only thing we should take care of is
+		 * releasing a FD while traversing this list. The FD could be
+		 * closed and released from the _release fop of this FD.
+		 * In order to mitigate this, we add a lock.
+		 * We take and release the lock per order traversal in order
+		 * to let other threads (which might still use the FDs) chance
+		 * to run.
 		 */
+		mutex_lock(&ucontext->lock);
 		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
 					 list)
 			if (obj->type->destroy_order == cur_order) {
@@ -265,6 +381,7 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 				next_order = min(next_order,
 						 obj->type->destroy_order);
 			}
+		mutex_unlock(&ucontext->lock);
 		cur_order = next_order;
 	}
 }
@@ -275,3 +392,41 @@ void uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
 	INIT_LIST_HEAD(&ucontext->uobjects);
 }
 
+static void hot_unplug_fd_uobject(struct ib_uobject *uobj, bool device_removed)
+{
+	const struct uverbs_obj_fd_type *fd_type =
+		container_of(uobj->type, struct uverbs_obj_fd_type, type);
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+
+	fd_type->hot_unplug(uobj_file, device_removed);
+	uobj_file->uobj.context = NULL;
+}
+
+const struct uverbs_obj_type_ops uverbs_fd_ops = {
+	.alloc_begin = alloc_begin_fd_uobject,
+	.lookup_get = lookup_get_fd_uobject,
+	.alloc_commit = alloc_commit_fd_uobject,
+	.alloc_abort = alloc_abort_fd_uobject,
+	.lookup_put = lookup_put_fd_uobject,
+	.destroy_commit = destroy_commit_null_uobject,
+	.hot_unplug = hot_unplug_fd_uobject,
+	.release = release_fd_uobject,
+};
+
+void uverbs_close_fd(struct file *f)
+{
+	struct ib_uobject_file *uobj_file = f->private_data;
+
+	mutex_lock(&uobj_file->ufile->cleanup_mutex);
+	if (uobj_file->uobj.context) {
+		mutex_lock(&uobj_file->uobj.context->lock);
+		list_del(&uobj_file->uobj.list);
+		mutex_unlock(&uobj_file->uobj.context->lock);
+		uobj_file->uobj.context = NULL;
+	}
+	mutex_unlock(&uobj_file->ufile->cleanup_mutex);
+	kref_put(&uobj_file->ufile->ref, ib_uverbs_release_file);
+	uverbs_uobject_put(&uobj_file->uobj);
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index ab665a6..da4e808 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -52,4 +52,11 @@
 void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed);
 void uverbs_initialize_ucontext(struct ib_ucontext *ucontext);
 
+/*
+ * Indicate this fd is no longer used by this consumer, but its memory isn't
+ * released yet. Internally we call uverbs_uobject_put. When the last reference
+ * is put, we release the memory.
+ */
+void uverbs_close_fd(struct file *f);
+
 #endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 9fe5e02..20632ff 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -193,6 +193,7 @@ void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			   struct ib_ucq_object *uobj);
 void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 			      struct ib_uevent_object *uobj);
+void ib_uverbs_release_file(struct kref *ref);
 
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0eb4538..784eccc 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -229,7 +229,7 @@ static void ib_uverbs_comp_dev(struct ib_uverbs_device *dev)
 	complete(&dev->comp);
 }
 
-static void ib_uverbs_release_file(struct kref *ref)
+void ib_uverbs_release_file(struct kref *ref)
 {
 	struct ib_uverbs_file *file =
 		container_of(ref, struct ib_uverbs_file, ref);
@@ -1128,7 +1128,9 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 			 * (e.g mmput).
 			 */
 			ib_dev->disassociate_ucontext(ucontext);
+			mutex_lock(&file->cleanup_mutex);
 			ib_uverbs_cleanup_ucontext(file, ucontext, true);
+			mutex_unlock(&file->cleanup_mutex);
 		}
 
 		mutex_lock(&uverbs_dev->lists_mutex);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7ddb08f..941a764 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1372,6 +1372,12 @@ struct ib_uobject {
 	const struct uverbs_obj_type *type;
 };
 
+struct ib_uobject_file {
+	struct ib_uobject	uobj;
+	/* ufile contains the lock between context release and file close */
+	struct ib_uverbs_file	*ufile;
+};
+
 struct ib_udata {
 	const void __user *inbuf;
 	void __user *outbuf;
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index cdbf352..48b5e4e 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -101,6 +101,22 @@ struct uverbs_obj_idr_type {
 	void (*hot_unplug)(struct ib_uobject *uobj);
 };
 
+struct uverbs_obj_fd_type {
+	/*
+	 * In fd based objects, uverbs_obj_type_ops points to a generic
+	 * fd operations. In order to specialize the underlying types (e.g.
+	 * completion_channel), we use obj_size, fops, name and flags for fd
+	 * creation and hot_unplug for specific release callback.
+	 */
+	struct uverbs_obj_type  type;
+	size_t			obj_size;
+	void (*hot_unplug)(struct ib_uobject_file *uobj_file,
+			   bool device_removed);
+	const struct file_operations	*fops;
+	const char			*name;
+	int				flags;
+};
+
 extern const struct uverbs_obj_type_ops uverbs_idr_ops;
 
 #define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
