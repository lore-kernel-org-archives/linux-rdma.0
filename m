From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/core: Rename write flag to exclusive in rdma_core
Date: Tue, 18 Apr 2017 12:03:37 +0300
Message-ID: <1492506222-28999-2-git-send-email-matanb@mellanox.com>
References: <1492506222-28999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492506222-28999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We rename the "write" flags to "exclusive", as it's used for both
WRITE and DESTROY actions.

Fixes: 3832125624b7 ('IB/core: Add support for idr types')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 60 +++++++++++++++++++------------------
 include/rdma/uverbs_types.h         | 33 ++++++++++----------
 2 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index e5bdf7f..88d1e59 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -44,7 +44,7 @@ void uverbs_uobject_get(struct ib_uobject *uobject)
 	kref_get(&uobject->ref);
 }
 
-static void uverbs_uobject_put_ref(struct kref *ref)
+static void uverbs_uobject_free(struct kref *ref)
 {
 	struct ib_uobject *uobj =
 		container_of(ref, struct ib_uobject, ref);
@@ -57,21 +57,23 @@ static void uverbs_uobject_put_ref(struct kref *ref)
 
 void uverbs_uobject_put(struct ib_uobject *uobject)
 {
-	kref_put(&uobject->ref, uverbs_uobject_put_ref);
+	kref_put(&uobject->ref, uverbs_uobject_free);
 }
 
-static int uverbs_try_lock_object(struct ib_uobject *uobj, bool write)
+static int uverbs_try_lock_object(struct ib_uobject *uobj, bool exclusive)
 {
 	/*
-	 * When a read is required, we use a positive counter. Each read
-	 * request checks that the value != -1 and increment it. Write
-	 * requires an exclusive access, thus we check that the counter is
-	 * zero (nobody claimed this object) and we set it to -1.
-	 * Releasing a read lock is done by simply decreasing the counter.
-	 * As for writes, since only a single write is permitted, setting
-	 * it to zero is enough for releasing it.
+	 * When a shared access is required, we use a positive counter. Each
+	 * shared access request checks that the value != -1 and increment it.
+	 * Exclusive access is required for operations like write or destroy.
+	 * In exclusive access mode, we check that the counter is zero (nobody
+	 * claimed this object) and we set it to -1. Releasing a shared access
+	 * lock is done simply by decreasing the counter. As for exclusive
+	 * access locks, since only a single one of them is is allowed
+	 * concurrently, setting the counter to zero is enough for releasing
+	 * this lock.
 	 */
-	if (!write)
+	if (!exclusive)
 		return __atomic_add_unless(&uobj->usecnt, 1, -1) == -1 ?
 			-EBUSY : 0;
 
@@ -135,7 +137,7 @@ static void uverbs_idr_remove_uobj(struct ib_uobject *uobj)
 /* Returns the ib_uobject or an error. The caller should check for IS_ERR. */
 static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *type,
 						 struct ib_ucontext *ucontext,
-						 int id, bool write)
+						 int id, bool exclusive)
 {
 	struct ib_uobject *uobj;
 
@@ -155,14 +157,14 @@ static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *t
 
 static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *type,
 						struct ib_ucontext *ucontext,
-						int id, bool write)
+						int id, bool exclusive)
 {
 	struct file *f;
 	struct ib_uobject *uobject;
 	const struct uverbs_obj_fd_type *fd_type =
 		container_of(type, struct uverbs_obj_fd_type, type);
 
-	if (write)
+	if (exclusive)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	f = fget(id);
@@ -186,12 +188,12 @@ static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *ty
 
 struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_obj_type *type,
 					   struct ib_ucontext *ucontext,
-					   int id, bool write)
+					   int id, bool exclusive)
 {
 	struct ib_uobject *uobj;
 	int ret;
 
-	uobj = type->type_class->lookup_get(type, ucontext, id, write);
+	uobj = type->type_class->lookup_get(type, ucontext, id, exclusive);
 	if (IS_ERR(uobj))
 		return uobj;
 
@@ -200,7 +202,7 @@ struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_obj_type *type,
 		goto free;
 	}
 
-	ret = uverbs_try_lock_object(uobj, write);
+	ret = uverbs_try_lock_object(uobj, exclusive);
 	if (ret) {
 		WARN(ucontext->cleanup_reason,
 		     "ib_uverbs: Trying to lookup_get while cleanup context\n");
@@ -209,7 +211,7 @@ struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_obj_type *type,
 
 	return uobj;
 free:
-	uobj->type->type_class->lookup_put(uobj, write);
+	uobj->type->type_class->lookup_put(uobj, exclusive);
 	uverbs_uobject_put(uobj);
 	return ERR_PTR(ret);
 }
@@ -350,10 +352,10 @@ static int __must_check remove_commit_fd_uobject(struct ib_uobject *uobj,
 	return ret;
 }
 
-static void lockdep_check(struct ib_uobject *uobj, bool write)
+static void lockdep_check(struct ib_uobject *uobj, bool exclusive)
 {
 #ifdef CONFIG_LOCKDEP
-	if (write)
+	if (exclusive)
 		WARN_ON(atomic_read(&uobj->usecnt) > 0);
 	else
 		WARN_ON(atomic_read(&uobj->usecnt) == -1);
@@ -465,29 +467,29 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj)
 	uobj->type->type_class->alloc_abort(uobj);
 }
 
-static void lookup_put_idr_uobject(struct ib_uobject *uobj, bool write)
+static void lookup_put_idr_uobject(struct ib_uobject *uobj, bool exclusive)
 {
 }
 
-static void lookup_put_fd_uobject(struct ib_uobject *uobj, bool write)
+static void lookup_put_fd_uobject(struct ib_uobject *uobj, bool exclusive)
 {
 	struct file *filp = uobj->object;
 
-	WARN_ON(write);
+	WARN_ON(exclusive);
 	/* This indirectly calls uverbs_close_fd and free the object */
 	fput(filp);
 }
 
-void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool write)
+void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool exclusive)
 {
-	lockdep_check(uobj, write);
-	uobj->type->type_class->lookup_put(uobj, write);
+	lockdep_check(uobj, exclusive);
+	uobj->type->type_class->lookup_put(uobj, exclusive);
 	/*
 	 * In order to unlock an object, either decrease its usecnt for
-	 * read access or zero it in case of write access. See
+	 * read access or zero it in case of exclusive access. See
 	 * uverbs_try_lock_object for locking schema information.
 	 */
-	if (!write)
+	if (!exclusive)
 		atomic_dec(&uobj->usecnt);
 	else
 		atomic_set(&uobj->usecnt, 0);
@@ -512,7 +514,7 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool write)
 	 * When the other thread continue - without the RCU, it would
 	 * access freed memory. However, the rcu_read_lock delays the free
 	 * until the rcu_read_lock of the READ operation quits. Since the
-	 * write lock of the object is still taken by the DESTROY flow, the
+	 * exclusive lock of the object is still taken by the DESTROY flow, the
 	 * READ operation will get -EBUSY and it'll just bail out.
 	 */
 	.needs_kfree_rcu = true,
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index a376921..351ea18 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -54,17 +54,18 @@ struct uverbs_obj_type_class {
 	 *		 destroyed.
 	 * [lookup]:	 Starts with lookup_get which fetches and locks the
 	 *		 object. After the handler finished using the object, it
-	 *		 needs to call lookup_put to unlock it. The write flag
-	 *		 indicates if the object is locked for exclusive access.
-	 * [remove]:	 Starts with lookup_get with write flag set. This locks
-	 *		 the object for exclusive access. If the handler code
-	 *		 completed successfully, remove_commit is called and
-	 *		 the ib_uobject is removed from the context's uobjects
-	 *		 repository and put. The object itself is destroyed as
-	 *		 well. Once remove succeeds new krefs to the object
-	 *		 cannot be acquired by other threads or userspace and
-	 *		 the hardware driver is removed from the object.
-	 *		 Other krefs on the object may still exist.
+	 *		 needs to call lookup_put to unlock it. The exclusive
+	 *		 flag indicates if the object is locked for exclusive
+	 *		 access.
+	 * [remove]:	 Starts with lookup_get with exclusive flag set. This
+	 *		 locks the object for exclusive access. If the handler
+	 *		 code completed successfully, remove_commit is called
+	 *		 and the ib_uobject is removed from the context's
+	 *		 uobjects repository and put. The object itself is
+	 *		 destroyed as well. Once remove succeeds new krefs to
+	 *		 the object cannot be acquired by other threads or
+	 *		 userspace and the hardware driver is removed from the
+	 *		 object. Other krefs on the object may still exist.
 	 *		 If the handler code failed, lookup_put should be
 	 *		 called. This callback is used when the context
 	 *		 is destroyed as well (process termination,
@@ -77,10 +78,10 @@ struct uverbs_obj_type_class {
 
 	struct ib_uobject *(*lookup_get)(const struct uverbs_obj_type *type,
 					 struct ib_ucontext *ucontext, int id,
-					 bool write);
-	void (*lookup_put)(struct ib_uobject *uobj, bool write);
+					 bool exclusive);
+	void (*lookup_put)(struct ib_uobject *uobj, bool exclusive);
 	/*
-	 * Must be called with the write lock held. If successful uobj is
+	 * Must be called with the exclusive lock held. If successful uobj is
 	 * invalid on return. On failure uobject is left completely
 	 * unchanged
 	 */
@@ -121,8 +122,8 @@ struct uverbs_obj_idr_type {
 
 struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_obj_type *type,
 					   struct ib_ucontext *ucontext,
-					   int id, bool write);
-void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool write);
+					   int id, bool exclusive);
+void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool exclusive);
 struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
 					    struct ib_ucontext *ucontext);
 void rdma_alloc_abort_uobject(struct ib_uobject *uobj);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
