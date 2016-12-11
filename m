From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 03/14] IB/core: Add generic ucontext initialization and teardown
Date: Sun, 11 Dec 2016 14:57:57 +0200
Message-ID: <1481461088-56355-4-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
---
 drivers/infiniband/core/rdma_core.c | 87 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h |  4 ++
 2 files changed, 91 insertions(+)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 398b61f..01221c0 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -73,6 +73,12 @@ struct ib_ucontext_lock {
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
@@ -343,6 +349,20 @@ void uverbs_rollback_object(struct ib_uobject *uobj,
 	return _uverbs_commit_object(uobj, access, false);
 }
 
+static void ib_uverbs_remove_fd(struct ib_uobject *uobject)
+{
+	/*
+	 * user should release the uobject in the release
+	 * callback.
+	 */
+	if (uobject->context) {
+		list_del(&uobject->list);
+		uobject->type->free_fn(uobject->type, uobject);
+		kref_put(&uobject->context->ufile->ref, ib_uverbs_release_file);
+		uobject->context = NULL;
+	}
+}
+
 void ib_uverbs_close_fd(struct file *f)
 {
 	struct ib_uobject *uobject = f->private_data - sizeof(struct ib_uobject);
@@ -395,3 +415,70 @@ void uverbs_commit_objects(struct uverbs_attr_array *attr_array,
 		}
 	}
 }
+
+static unsigned int get_type_orders(const struct uverbs_root *root)
+{
+	unsigned int i;
+	unsigned int max = 0;
+
+	for (i = 0; i < root->num_groups; i++) {
+		unsigned int j;
+		const struct uverbs_type_group *types = root->type_groups[i];
+
+		for (j = 0; j < types->num_types; j++) {
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
+void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext *ucontext,
+					     const struct uverbs_root *root)
+{
+	unsigned int num_orders = get_type_orders(root);
+	unsigned int i;
+
+	for (i = 0; i <= num_orders; i++) {
+		struct ib_uobject *obj, *next_obj;
+
+		/*
+		 * No need to take lock here, as cleanup should be called
+		 * after all commands finished executing. Newly executed
+		 * commands should fail.
+		 */
+		mutex_lock(&ucontext->uobjects_lock->lock);
+		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
+					 list)
+			if (obj->type->order == i) {
+				if (obj->type->type == UVERBS_ATTR_TYPE_IDR)
+					ib_uverbs_uobject_remove(obj, false);
+				else
+					ib_uverbs_remove_fd(obj);
+			}
+		mutex_unlock(&ucontext->uobjects_lock->lock);
+	}
+	kref_put(&ucontext->uobjects_lock->ref, release_uobjects_list_lock);
+}
+
+int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext *ucontext)
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
+void ib_uverbs_uobject_type_release_ucontext(struct ib_ucontext *ucontext)
+{
+	kfree(ucontext->uobjects_lock);
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 0bb4be3..9b91c1c 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -60,6 +60,10 @@ void uverbs_commit_objects(struct uverbs_attr_array *attr_array,
 			   const struct uverbs_action *action,
 			   bool success);
 
+void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext *ucontext,
+					     const struct uverbs_root *root);
+int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext *ucontext);
+void ib_uverbs_uobject_type_release_ucontext(struct ib_ucontext *ucontext);
 void ib_uverbs_close_fd(struct file *f);
 void ib_uverbs_cleanup_fd(void *private_data);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
