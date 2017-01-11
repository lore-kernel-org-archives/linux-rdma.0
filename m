From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/7] IB/core: Add generic ucontext initialization and teardown
Date: Wed, 11 Jan 2017 12:53:50 +0200
Message-ID: <1484132033-3346-5-git-send-email-matanb@mellanox.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484132033-3346-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When a ucontext is created, we need to initialize the list of objects.
This list consists of every user object that is associated with
this ucontext. The possible elements in this list are either a file
descriptor or an object which is represented by an IDR.
Every such an object, has a release function (which is called upon
object destruction) and a number associated to its release order.

When a ucontext is destroyed, the list is traversed while holding a
lock. This lock is necessary since a user might try to close a FD
file [s]he created and exists in this list.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 103 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/rdma_core.h |  14 +++++
 include/rdma/uverbs_ioctl.h         |  14 +++++
 3 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 193591d..4654c74 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -69,6 +69,12 @@ struct ib_ucontext_lock {
 	struct mutex lock;
 };
 
+static void init_uobjects_list_lock(struct ib_ucontext_lock *lock)
+{
+	mutex_init(&lock->lock);
+	kref_init(&lock->ref);
+}
+
 static void release_uobjects_list_lock(struct kref *ref)
 {
 	struct ib_ucontext_lock *lock = container_of(ref,
@@ -283,7 +289,7 @@ static void uverbs_uobject_add(struct ib_uobject *uobject)
 	mutex_unlock(&uobject->context->uobjects_lock->lock);
 }
 
-static void uverbs_uobject_remove(struct ib_uobject *uobject)
+static void uverbs_uobject_remove(struct ib_uobject *uobject, bool lock)
 {
 	/*
 	 * Calling remove requires exclusive access, so it's not possible
@@ -291,9 +297,11 @@ static void uverbs_uobject_remove(struct ib_uobject *uobject)
 	 * with exclusive access.
 	 */
 	uverbs_idr_remove_uobj(uobject);
-	mutex_lock(&uobject->context->uobjects_lock->lock);
+	if (lock)
+		mutex_lock(&uobject->context->uobjects_lock->lock);
 	list_del(&uobject->list);
-	mutex_unlock(&uobject->context->uobjects_lock->lock);
+	if (lock)
+		mutex_unlock(&uobject->context->uobjects_lock->lock);
 	put_uobj(uobject);
 }
 
@@ -326,7 +334,7 @@ static void uverbs_finalize_idr(struct ib_uobject *uobj,
 		break;
 	case UVERBS_ACCESS_DESTROY:
 		if (commit)
-			uverbs_uobject_remove(uobj);
+			uverbs_uobject_remove(uobj, true);
 		else
 			up_write(&uobj->usecnt);
 		break;
@@ -394,3 +402,90 @@ void uverbs_cleanup_fd(void *private_data)
 	kfree(uobject);
 }
 
+static unsigned int get_max_type_orders(const struct uverbs_root *root)
+{
+	unsigned int i;
+	unsigned int max = 0;
+
+	for (i = 0; i < root->num_groups; i++) {
+		unsigned int j;
+		const struct uverbs_type_group *types = root->type_groups[i];
+
+		for (j = 0; j < types->num_types; j++) {
+			/*
+			 * Either this type isn't supported by this ib_device
+			 * (as the group is an array of pointers to types
+			 * indexed by the type) or this type is supported, but
+			 * we can't instantiate objects from this type
+			 * (e.g. you can't instantiate objects of
+			 * UVERBS_DEVICE).
+			 */
+			if (!types->types[j] || !types->types[j]->alloc)
+				continue;
+			if (types->types[j]->alloc->order > max)
+				max = types->types[j]->alloc->order;
+		}
+	}
+
+	return max;
+}
+
+void uverbs_release_ucontext(struct ib_ucontext *ucontext)
+{
+	/*
+	 * Since FD objects could outlive their context, we use a kref'ed
+	 * lock. This lock is referenced when a context and FD objects are
+	 * created. This lock protects concurrent context release from FD
+	 * objects release. Therefore, we need to put this lock object in
+	 * the context and every FD object release.
+	 */
+	kref_put(&ucontext->uobjects_lock->ref, release_uobjects_list_lock);
+}
+
+void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext,
+			     const struct uverbs_root *root)
+{
+	unsigned int num_orders = get_max_type_orders(root);
+	unsigned int i;
+
+	for (i = 0; i <= num_orders; i++) {
+		struct ib_uobject *obj, *next_obj;
+
+		/*
+		 * This souldn't run while executing other commands on this
+		 * context. Thus, the only thing we should take care of is
+		 * releasing a FD while traversing this list. The FD could be
+		 * closed and released from the _release fop of this FD.
+		 * In order to mitigate this, we add a lock.
+		 * We take and release the lock per order traversal in order
+		 * to let other threads (which might still use the FDs) chance
+		 * to run.
+		 */
+		mutex_lock(&ucontext->uobjects_lock->lock);
+		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
+					 list)
+			if (obj->type->order == i) {
+				obj->type->free_fn(obj->type, obj);
+				if (obj->type->type == UVERBS_ATTR_TYPE_IDR)
+					uverbs_uobject_remove(obj, false);
+				else
+					uverbs_remove_fd(obj);
+			}
+		mutex_unlock(&ucontext->uobjects_lock->lock);
+	}
+	uverbs_release_ucontext(ucontext);
+}
+
+int uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
+{
+	ucontext->uobjects_lock = kmalloc(sizeof(*ucontext->uobjects_lock),
+					  GFP_KERNEL);
+	if (!ucontext->uobjects_lock)
+		return -ENOMEM;
+
+	init_uobjects_list_lock(ucontext->uobjects_lock);
+	INIT_LIST_HEAD(&ucontext->uobjects);
+
+	return 0;
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index c71a51c..d06bae6 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -58,6 +58,20 @@ void uverbs_finalize_object(struct ib_uobject *uobj,
 			    enum uverbs_idr_access access,
 			    bool success);
 /*
+ * These functions initialize and destroy the context. The context has a
+ * list of objects which is protected by a kref-ed lock, whose purpose is
+ * to protect concurrent FDs (e.g completion channel FDs) release while
+ * traversing the context and releasing its objects. initialize_ucontext
+ * should be called when we create a context. cleanup_ucontext removes all
+ * objects created in the ucontext. release_ucontext drops the reference from
+ * the lock.
+ */
+void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext,
+			     const struct uverbs_root *root);
+int uverbs_initialize_ucontext(struct ib_ucontext *ucontext);
+void uverbs_release_ucontext(struct ib_ucontext *ucontext);
+
+/*
  * Indicate this fd is no longer used by this consumer, but its memory isn't
  * released yet. The memory is released only when ib_uverbs_cleanup_fd is
  * called.
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 189e323..a8b0ff9 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -65,4 +65,18 @@ struct uverbs_type_alloc_action {
 	} fd;
 };
 
+struct uverbs_type {
+	const struct uverbs_type_alloc_action   *alloc;
+};
+
+struct uverbs_type_group {
+	size_t					num_types;
+	const struct uverbs_type		**types;
+};
+
+struct uverbs_root {
+	const struct uverbs_type_group		**type_groups;
+	size_t					num_groups;
+};
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
