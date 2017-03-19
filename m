From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 6/7] IB/core: Add support for fd objects
Date: Sun, 19 Mar 2017 17:59:04 +0200
Message-ID: <1489939145-125246-7-git-send-email-matanb@mellanox.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
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
 drivers/infiniband/core/rdma_core.c   | 176 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/rdma_core.h   |   8 ++
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_main.c |   4 +-
 include/rdma/ib_verbs.h               |   6 ++
 include/rdma/uverbs_types.h           |  16 ++++
 6 files changed, 209 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 2512405..5820e53 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -151,6 +151,36 @@ static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *t
 	return uobj;
 }
 
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
+	/*
+	 * fget(id) ensures we are not currently running uverbs_close_fd,
+	 * and the caller is expected to ensure that uverbs_close_fd is never
+	 * done while a call top lookup is possible.
+	 */
+	if (f->f_op != fd_type->fops) {
+		fput(f);
+		return ERR_PTR(-EBADF);
+	}
+
+	return uobject;
+}
+
 struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_obj_type *type,
 					   struct ib_ucontext *ucontext,
 					   int id, bool write)
@@ -199,6 +229,46 @@ static struct ib_uobject *alloc_begin_idr_uobject(const struct uverbs_obj_type *
 	return uobj;
 }
 
+static struct ib_uobject *alloc_begin_fd_uobject(const struct uverbs_obj_type *type,
+						 struct ib_ucontext *ucontext)
+{
+	const struct uverbs_obj_fd_type *fd_type =
+		container_of(type, struct uverbs_obj_fd_type, type);
+	int new_fd;
+	struct ib_uobject *uobj;
+	struct ib_uobject_file *uobj_file;
+	struct file *filp;
+
+	new_fd = get_unused_fd_flags(O_CLOEXEC);
+	if (new_fd < 0)
+		return ERR_PTR(new_fd);
+
+	uobj = alloc_uobj(ucontext, type);
+	if (IS_ERR(uobj)) {
+		put_unused_fd(new_fd);
+		return uobj;
+	}
+
+	uobj_file = container_of(uobj, struct ib_uobject_file, uobj);
+	filp = anon_inode_getfile(fd_type->name,
+				  fd_type->fops,
+				  uobj_file,
+				  fd_type->flags);
+	if (IS_ERR(filp)) {
+		put_unused_fd(new_fd);
+		uverbs_uobject_put(uobj);
+		return (void *)filp;
+	}
+
+	uobj_file->uobj.id = new_fd;
+	uobj_file->uobj.object = filp;
+	uobj_file->ufile = ucontext->ufile;
+	INIT_LIST_HEAD(&uobj->list);
+	kref_get(&uobj_file->ufile->ref);
+
+	return uobj;
+}
+
 struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
 					    struct ib_ucontext *ucontext)
 {
@@ -232,6 +302,39 @@ static int __must_check remove_commit_idr_uobject(struct ib_uobject *uobj,
 	return ret;
 }
 
+static void alloc_abort_fd_uobject(struct ib_uobject *uobj)
+{
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+	struct file *filp = uobj->object;
+	int id = uobj_file->uobj.id;
+
+	/* Unsuccessful NEW */
+	fput(filp);
+	put_unused_fd(id);
+}
+
+static int __must_check remove_commit_fd_uobject(struct ib_uobject *uobj,
+						 enum rdma_remove_reason why)
+{
+	const struct uverbs_obj_fd_type *fd_type =
+		container_of(uobj->type, struct uverbs_obj_fd_type, type);
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+	int ret = fd_type->context_closed(uobj_file, why);
+
+	if (why == RDMA_REMOVE_DESTROY && ret)
+		return ret;
+
+	if (why == RDMA_REMOVE_DURING_CLEANUP) {
+		alloc_abort_fd_uobject(uobj);
+		return ret;
+	}
+
+	uobj_file->uobj.context = NULL;
+	return ret;
+}
+
 static void lockdep_check(struct ib_uobject *uobj, bool write)
 {
 #ifdef CONFIG_LOCKDEP
@@ -300,6 +403,19 @@ static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
 	spin_unlock(&uobj->context->ufile->idr_lock);
 }
 
+static void alloc_commit_fd_uobject(struct ib_uobject *uobj)
+{
+	struct ib_uobject_file *uobj_file =
+		container_of(uobj, struct ib_uobject_file, uobj);
+
+	uverbs_uobject_add(&uobj_file->uobj);
+	fd_install(uobj_file->uobj.id, uobj->object);
+	/* This shouldn't be used anymore. Use the file object instead */
+	uobj_file->uobj.id = 0;
+	/* Get another reference as we export this to the fops */
+	uverbs_uobject_get(&uobj_file->uobj);
+}
+
 int rdma_alloc_commit_uobject(struct ib_uobject *uobj)
 {
 	/* Cleanup is running. Calling this should have been impossible */
@@ -336,6 +452,15 @@ static void lookup_put_idr_uobject(struct ib_uobject *uobj, bool write)
 {
 }
 
+static void lookup_put_fd_uobject(struct ib_uobject *uobj, bool write)
+{
+	struct file *filp = uobj->object;
+
+	WARN_ON(write);
+	/* This indirectly calls uverbs_close_fd and free the object */
+	fput(filp);
+}
+
 void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool write)
 {
 	lockdep_check(uobj, write);
@@ -376,6 +501,39 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool write)
 	.needs_rcu = true,
 };
 
+static void _uverbs_close_fd(struct ib_uobject_file *uobj_file)
+{
+	struct ib_ucontext *ucontext;
+	struct ib_uverbs_file *ufile = uobj_file->ufile;
+	int ret;
+
+	mutex_lock(&uobj_file->ufile->cleanup_mutex);
+
+	/* uobject was either already cleaned up or is cleaned up right now anyway */
+	if (!uobj_file->uobj.context ||
+	    !down_read_trylock(&uobj_file->uobj.context->cleanup_rwsem))
+		goto unlock;
+
+	ucontext = uobj_file->uobj.context;
+	ret = _rdma_remove_commit_uobject(&uobj_file->uobj, RDMA_REMOVE_CLOSE,
+					  true);
+	up_read(&ucontext->cleanup_rwsem);
+	if (ret)
+		pr_warn("uverbs: unable to clean up uobject file in uverbs_close_fd.\n");
+unlock:
+	mutex_unlock(&ufile->cleanup_mutex);
+}
+
+void uverbs_close_fd(struct file *f)
+{
+	struct ib_uobject_file *uobj_file = f->private_data;
+	struct kref *uverbs_file_ref = &uobj_file->ufile->ref;
+
+	_uverbs_close_fd(uobj_file);
+	uverbs_uobject_put(&uobj_file->uobj);
+	kref_put(uverbs_file_ref, ib_uverbs_release_file);
+}
+
 void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 {
 	enum rdma_remove_reason reason = device_removed ?
@@ -396,7 +554,13 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 
 		/*
 		 * This shouldn't run while executing other commands on this
-		 * context.
+		 * context. Thus, the only thing we should take care of is
+		 * releasing a FD while traversing this list. The FD could be
+		 * closed and released from the _release fop of this FD.
+		 * In order to mitigate this, we add a lock.
+		 * We take and release the lock per order traversal in order
+		 * to let other threads (which might still use the FDs) chance
+		 * to run.
 		 */
 		mutex_lock(&ucontext->uobjects_lock);
 		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
@@ -432,3 +596,13 @@ void uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
 	init_rwsem(&ucontext->cleanup_rwsem);
 }
 
+const struct uverbs_obj_type_class uverbs_fd_class = {
+	.alloc_begin = alloc_begin_fd_uobject,
+	.lookup_get = lookup_get_fd_uobject,
+	.alloc_commit = alloc_commit_fd_uobject,
+	.alloc_abort = alloc_abort_fd_uobject,
+	.lookup_put = lookup_put_fd_uobject,
+	.remove_commit = remove_commit_fd_uobject,
+	.needs_rcu = false,
+};
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 0247bb5..1b82e7f 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -67,4 +67,12 @@
  */
 void uverbs_uobject_put(struct ib_uobject *uobject);
 
+/* Indicate this fd is no longer used by this consumer, but its memory isn't
+ * necessarily released yet. When the last reference is put, we release the
+ * memory. After this call is executed, calling uverbs_uobject_get isn't
+ * allowed.
+ * This must be called from the release file_operations of the file!
+ */
+void uverbs_close_fd(struct file *f);
+
 #endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 7b10142..8102698 100644
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
index 139d064..7a599d0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1400,6 +1400,12 @@ struct ib_uobject {
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
index 93a3bcb..55b8219 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -130,6 +130,22 @@ struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
 int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj);
 int rdma_alloc_commit_uobject(struct ib_uobject *uobj);
 
+struct uverbs_obj_fd_type {
+	/*
+	 * In fd based objects, uverbs_obj_type_ops points to generic
+	 * fd operations. In order to specialize the underlying types (e.g.
+	 * completion_channel), we use fops, name and flags for fd creation.
+	 * context_closed is called when the context is closed either when
+	 * the driver is removed or the process terminated.
+	 */
+	struct uverbs_obj_type  type;
+	int (*context_closed)(struct ib_uobject_file *uobj_file,
+			      enum rdma_remove_reason why);
+	const struct file_operations	*fops;
+	const char			*name;
+	int				flags;
+};
+
 extern const struct uverbs_obj_type_class uverbs_idr_class;
 
 #define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
