From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/7] IB/core: Add support for fd objects
Date: Wed, 11 Jan 2017 12:53:49 +0200
Message-ID: <1484132033-3346-4-git-send-email-matanb@mellanox.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484132033-3346-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The completion channel we use in verbs infrastructure is FD based.
Previously, we had a separate way to manage this object. Since we
strive for a single way to manage any kind of object in this
infrastructure, we conceptually treat all objects as subclasses
of ib_uobject.

This commit adds the necessary mechanism to support FD based objects
like their IDR counterparts. FD objects release need to be synchronized
with context release. Since FDs could outlives their context, we use
a kref on this lock. We initialize the lock and the kref in downstream
patches. This is acceptable, as we don't use this infrastructure until
a later point in this series.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c   | 134 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/rdma_core.h   |  12 +++
 drivers/infiniband/core/uverbs_main.c |   2 +-
 include/rdma/ib_verbs.h               |   4 +-
 include/rdma/uverbs_ioctl.h           |   8 ++
 5 files changed, 157 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 09b44ec..193591d 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -64,10 +64,20 @@ static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
 }
 
 struct ib_ucontext_lock {
+	struct kref  ref;
 	/* locking the uobjects_list */
 	struct mutex lock;
 };
 
+static void release_uobjects_list_lock(struct kref *ref)
+{
+	struct ib_ucontext_lock *lock = container_of(ref,
+						     struct ib_ucontext_lock,
+						     ref);
+
+	kfree(lock);
+}
+
 static void init_uobj(struct ib_uobject *uobj, struct ib_ucontext *context)
 {
 	init_rwsem(&uobj->usecnt);
@@ -184,6 +194,75 @@ static struct ib_uobject *uverbs_get_uobject_from_idr(const struct uverbs_type_a
 	return uobj;
 }
 
+static struct ib_uobject *uverbs_priv_fd_to_uobject(void *priv)
+{
+	return priv - sizeof(struct ib_uobject);
+}
+
+static struct ib_uobject *uverbs_get_uobject_from_fd(const struct uverbs_type_alloc_action *type_alloc,
+						     struct ib_ucontext *ucontext,
+						     enum uverbs_idr_access access,
+						     unsigned int fd)
+{
+	if (access == UVERBS_ACCESS_NEW) {
+		int _fd;
+		struct ib_uobject *uobj = NULL;
+		struct file *filp;
+
+		_fd = get_unused_fd_flags(O_CLOEXEC);
+		if (_fd < 0)
+			return ERR_PTR(_fd);
+
+		uobj = kmalloc(type_alloc->obj_size, GFP_KERNEL);
+		if (!uobj) {
+			put_unused_fd(_fd);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		init_uobj(uobj, ucontext);
+		filp = anon_inode_getfile(type_alloc->fd.name,
+					  type_alloc->fd.fops,
+					  uverbs_fd_uobj_to_priv(uobj),
+					  type_alloc->fd.flags);
+		if (IS_ERR(filp)) {
+			put_unused_fd(_fd);
+			kfree(uobj);
+			return (void *)filp;
+		}
+
+		/*
+		 * user_handle should be filled by the user,
+		 * the list is filled in the commit operation.
+		 */
+		uobj->type = type_alloc;
+		uobj->id = _fd;
+		uobj->object = filp;
+
+		return uobj;
+	} else if (access == UVERBS_ACCESS_READ) {
+		struct file *f = fget(fd);
+		struct ib_uobject *uobject;
+
+		if (!f)
+			return ERR_PTR(-EBADF);
+
+		uobject = uverbs_priv_fd_to_uobject(f->private_data);
+		if (f->f_op != type_alloc->fd.fops ||
+		    !uobject->context) {
+			fput(f);
+			return ERR_PTR(-EBADF);
+		}
+
+		/*
+		 * No need to protect it with a ref count, as fget increases
+		 * f_count.
+		 */
+		return uobject;
+	} else {
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+}
+
 struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_alloc_action *type_alloc,
 						   struct ib_ucontext *ucontext,
 						   enum uverbs_idr_access access,
@@ -193,7 +272,8 @@ struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_allo
 		return uverbs_get_uobject_from_idr(type_alloc, ucontext, access,
 						   id);
 	else
-		return ERR_PTR(-ENOENT);
+		return uverbs_get_uobject_from_fd(type_alloc, ucontext, access,
+						  id);
 }
 
 static void uverbs_uobject_add(struct ib_uobject *uobject)
@@ -253,12 +333,64 @@ static void uverbs_finalize_idr(struct ib_uobject *uobj,
 	}
 }
 
+static void uverbs_finalize_fd(struct ib_uobject *uobj,
+			       enum uverbs_idr_access access,
+			       bool commit)
+{
+	struct file *filp = uobj->object;
+
+	if (access == UVERBS_ACCESS_NEW) {
+		if (commit) {
+			uobj->uobjects_lock = uobj->context->uobjects_lock;
+			kref_get(&uobj->uobjects_lock->ref);
+			uverbs_uobject_add(uobj);
+			fd_install(uobj->id, uobj->object);
+		} else {
+			/* Unsuccessful NEW */
+			fput(filp);
+			put_unused_fd(uobj->id);
+			kfree(uobj);
+		}
+	} else {
+		fput(filp);
+	}
+}
+
 void uverbs_finalize_object(struct ib_uobject *uobj,
 			    enum uverbs_idr_access access,
 			    bool commit)
 {
 	if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
 		uverbs_finalize_idr(uobj, access, commit);
+	else if (uobj->type->type == UVERBS_ATTR_TYPE_FD)
+		uverbs_finalize_fd(uobj, access, commit);
 	else
 		WARN_ON(true);
 }
+
+static void uverbs_remove_fd(struct ib_uobject *uobject)
+{
+	if (uobject->context) {
+		list_del(&uobject->list);
+		uobject->context = NULL;
+	}
+}
+
+/* user should release the uobject in the release file_operation callback. */
+void uverbs_close_fd(struct file *f)
+{
+	struct ib_uobject *uobject = uverbs_priv_fd_to_uobject(f->private_data);
+
+	mutex_lock(&uobject->uobjects_lock->lock);
+	uverbs_remove_fd(uobject);
+	mutex_unlock(&uobject->uobjects_lock->lock);
+	kref_put(&uobject->uobjects_lock->ref, release_uobjects_list_lock);
+}
+
+void uverbs_cleanup_fd(void *private_data)
+{
+	struct ib_uobject *uobject = uverbs_priv_fd_to_uobject(private_data);
+
+	kfree(uobject);
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 0142573..c71a51c 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -57,5 +57,17 @@ struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_allo
 void uverbs_finalize_object(struct ib_uobject *uobj,
 			    enum uverbs_idr_access access,
 			    bool success);
+/*
+ * Indicate this fd is no longer used by this consumer, but its memory isn't
+ * released yet. The memory is released only when ib_uverbs_cleanup_fd is
+ * called.
+ */
+void uverbs_close_fd(struct file *f);
+void uverbs_cleanup_fd(void *private_data);
+
+static inline void *uverbs_fd_uobj_to_priv(struct ib_uobject *uobj)
+{
+	return uobj + 1;
+}
 
 #endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index daee2ba6..6e38a7c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -339,7 +339,7 @@ static void ib_uverbs_comp_dev(struct ib_uverbs_device *dev)
 	complete(&dev->comp);
 }
 
-static void ib_uverbs_release_file(struct kref *ref)
+void ib_uverbs_release_file(struct kref *ref)
 {
 	struct ib_uverbs_file *file =
 		container_of(ref, struct ib_uverbs_file, ref);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 47f560d..7992fcd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1335,6 +1335,7 @@ struct ib_fmr_attr {
 
 struct ib_ucontext {
 	struct ib_device       *device;
+	struct ib_uverbs_file  *ufile;
 	struct list_head	pd_list;
 	struct list_head	mr_list;
 	struct list_head	mw_list;
@@ -1376,7 +1377,7 @@ struct ib_uobject {
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
-	int			id;		/* index into kernel idr */
+	int			id;		/* index into kernel idr/fd */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
 	struct rw_semaphore	usecnt;		/* protects exclusive access */
@@ -1384,6 +1385,7 @@ struct ib_uobject {
 	int			live;
 
 	const struct uverbs_type_alloc_action *type;
+	struct ib_ucontext_lock	*uobjects_lock;
 };
 
 struct ib_udata {
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 903f6b3..189e323 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -35,8 +35,11 @@
 
 #include <linux/kernel.h>
 
+struct ib_uobject;
+
 enum uverbs_attr_type {
 	UVERBS_ATTR_TYPE_IDR,
+	UVERBS_ATTR_TYPE_FD,
 };
 
 enum uverbs_idr_access {
@@ -55,6 +58,11 @@ struct uverbs_type_alloc_action {
 	int				order;
 	size_t				obj_size;
 	free_type			free_fn;
+	struct {
+		const struct file_operations	*fops;
+		const char			*name;
+		int				flags;
+	} fd;
 };
 
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
