From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 2/7] IB/core: Add support for idr types
Date: Wed,  1 Feb 2017 14:39:00 +0200
Message-ID: <1485952745-58476-3-git-send-email-matanb@mellanox.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485952745-58476-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new ioctl infrastructure supports driver specific objects.
Each such object type has a hot unplug function, allocation size and
an order of destruction.

When a ucontext is created, a new list is created in this ib_ucontext.
This list contains all objects created under this ib_ucontext.
When a ib_ucontext is destroyed, we traverse this list several time
destroying the various objects by the order mentioned in the object
type description. If few object types have the same destruction order,
they are destroyed in an order opposite to their creation.

Adding an object is done in two parts.
First, an object is allocated and added to idr tree. Then, the
command's handlers (in downstream patches) could work on this object
and fill in its required details.
After a successful command, the commit part is called and the user
objects become ucontext visible. If the handler failed, alloc_abort
should be called.

Removing an uboject is done by calling lookup_get with the write flag
and finalizing it with destroy_commit.

We should make sure idr (per-uverbs-file) and list (per-ucontext) could
be accessed concurrently without corrupting them.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |   3 +-
 drivers/infiniband/core/rdma_core.c | 277 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h |  55 +++++++
 include/rdma/ib_verbs.h             |   7 +
 include/rdma/uverbs_types.h         | 104 ++++++++++++++
 5 files changed, 445 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 include/rdma/uverbs_types.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index edaae9f..1819623 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -28,4 +28,5 @@ ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
 
-ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
+				rdma_core.o
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
new file mode 100644
index 0000000..7ce4d67
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.c
@@ -0,0 +1,277 @@
+/*
+ * Copyright (c) 2016, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/file.h>
+#include <linux/anon_inodes.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_types.h>
+#include "uverbs.h"
+#include "rdma_core.h"
+
+static void uverbs_uobject_put_ref(struct kref *ref)
+{
+	struct ib_uobject *uobj =
+		container_of(ref, struct ib_uobject, ref);
+
+	uobj->type->ops->release(uobj);
+}
+
+void uverbs_uobject_put(struct ib_uobject *uobj)
+{
+	kref_put(&uobj->ref, uverbs_uobject_put_ref);
+}
+
+static int uverbs_lock_object(struct ib_uobject *uobj, bool write)
+{
+	if (!write)
+		return down_read_trylock(&uobj->currently_used) == 1 ? 0 :
+			-EBUSY;
+
+	/* lock is either WRITE or DESTROY - should be exclusive */
+	return down_write_trylock(&uobj->currently_used) == 1 ? 0 : -EBUSY;
+}
+
+static void init_uobj(struct ib_uobject *uobj, struct ib_ucontext *context,
+		      const struct uverbs_obj_type *type)
+{
+	/*
+	 * user_handle should be filled by the handler,
+	 * The object is added to the list in the commit stage.
+	 */
+	init_rwsem(&uobj->currently_used);
+	uobj->context     = context;
+	uobj->type	  = type;
+	kref_init(&uobj->ref);
+}
+
+static int idr_add_uobj(struct ib_uobject *uobj)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&uobj->context->ufile->idr_lock);
+
+	/*
+	 * We start with allocating an idr pointing to NULL. This represents an
+	 * object which isn't initialized yet. We'll replace it later on with
+	 * the real object once we commit.
+	 */
+	ret = idr_alloc(&uobj->context->ufile->idr, NULL, 0,
+			min_t(unsigned long, U32_MAX - 1, INT_MAX), GFP_NOWAIT);
+	if (ret >= 0)
+		uobj->id = ret;
+
+	spin_unlock(&uobj->context->ufile->idr_lock);
+	idr_preload_end();
+
+	return ret < 0 ? ret : 0;
+}
+
+static void uverbs_idr_remove_uobj(struct ib_uobject *uobj)
+{
+	spin_lock(&uobj->context->ufile->idr_lock);
+	idr_remove(&uobj->context->ufile->idr, uobj->id);
+	spin_unlock(&uobj->context->ufile->idr_lock);
+}
+
+/* Returns the ib_uobject or an error. The caller should check for IS_ERR. */
+static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *type,
+						 struct ib_ucontext *ucontext,
+						 int id, bool write)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	rcu_read_lock();
+	/* object won't be released as we're protected in rcu */
+	uobj = idr_find(&ucontext->ufile->idr, id);
+	if (!uobj) {
+		uobj = ERR_PTR(-ENOENT);
+		goto free;
+	}
+
+	if (uobj->type != type) {
+		uobj = ERR_PTR(-EINVAL);
+		goto free;
+	}
+
+	ret = uverbs_lock_object(uobj, write);
+	if (ret)
+		uobj = ERR_PTR(ret);
+free:
+	rcu_read_unlock();
+	return uobj;
+}
+
+static struct ib_uobject *alloc_begin_idr_uobject(const struct uverbs_obj_type *type,
+						  struct ib_ucontext *ucontext)
+{
+	int ret;
+	const struct uverbs_obj_idr_type *idr_type =
+		container_of(type, struct uverbs_obj_idr_type, type);
+	struct ib_uobject *uobj = kmalloc(idr_type->obj_size, GFP_KERNEL);
+
+	if (!uobj)
+		return ERR_PTR(-ENOMEM);
+
+	init_uobj(uobj, ucontext, type);
+	ret = idr_add_uobj(uobj);
+	if (ret) {
+		kfree(uobj);
+		return ERR_PTR(ret);
+	}
+
+	return uobj;
+}
+
+static void uverbs_uobject_add(struct ib_uobject *uobject)
+{
+	mutex_lock(&uobject->context->lock);
+	list_add(&uobject->list, &uobject->context->uobjects);
+	mutex_unlock(&uobject->context->lock);
+}
+
+static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
+{
+	uverbs_uobject_add(uobj);
+	spin_lock(&uobj->context->ufile->idr_lock);
+	/*
+	 * We already allocated this IDR with a NULL object, so
+	 * this shouldn't fail.
+	 */
+	WARN_ON(idr_replace(&uobj->context->ufile->idr,
+			    uobj, uobj->id));
+	spin_unlock(&uobj->context->ufile->idr_lock);
+}
+
+static void _put_uobj_ref(struct kref *ref)
+{
+	kfree(container_of(ref, struct ib_uobject, ref));
+}
+
+static void alloc_abort_idr_uobject(struct ib_uobject *uobj)
+{
+	uverbs_idr_remove_uobj(uobj);
+	/*
+	 * we don't need kfree_rcu here, as the uobject wasn't exposed to any
+	 * other verb.
+	 */
+	kref_put(&uobj->ref, _put_uobj_ref);
+}
+
+static void lookup_put_idr_uobject(struct ib_uobject *uobj, bool write)
+{
+	if (write)
+		up_write(&uobj->currently_used);
+	else
+		up_read(&uobj->currently_used);
+}
+
+static void destroy_commit_idr_uobject(struct ib_uobject *uobj)
+{
+	uverbs_idr_remove_uobj(uobj);
+	mutex_lock(&uobj->context->lock);
+	list_del(&uobj->list);
+	mutex_unlock(&uobj->context->lock);
+	uverbs_uobject_put(uobj);
+}
+
+static void hot_unplug_idr_uobject(struct ib_uobject *uobj, bool device_removed)
+{
+	const struct uverbs_obj_idr_type *idr_type =
+		container_of(uobj->type, struct uverbs_obj_idr_type, type);
+
+	idr_type->hot_unplug(uobj);
+	uverbs_idr_remove_uobj(uobj);
+	uverbs_uobject_put(uobj);
+}
+
+static void release_idr_uobject(struct ib_uobject *uobj)
+{
+	/*
+	 * When we destroy an object, we first just lock it for WRITE and
+	 * actually DESTROY it in the finalize stage. So, the problematic
+	 * scenario is when we just started the finalize stage of the
+	 * destruction (nothing was executed yet). Now, the other thread
+	 * fetched the object for READ access, but it didn't lock it yet.
+	 * The DESTROY thread continues and starts destroying the object.
+	 * When the other thread continue - without the RCU, it would
+	 * access freed memory. However, the rcu_read_lock delays the free
+	 * until the rcu_read_lock of the READ operation quits. Since the
+	 * write lock of the object is still taken by the DESTROY flow, the
+	 * READ operation will get -EBUSY and it'll just bail out.
+	 */
+	kfree_rcu(uobj, rcu);
+}
+
+const struct uverbs_obj_type_ops uverbs_idr_ops = {
+	.alloc_begin = alloc_begin_idr_uobject,
+	.lookup_get = lookup_get_idr_uobject,
+	.alloc_commit = alloc_commit_idr_uobject,
+	.alloc_abort = alloc_abort_idr_uobject,
+	.lookup_put = lookup_put_idr_uobject,
+	.destroy_commit = destroy_commit_idr_uobject,
+	.hot_unplug = hot_unplug_idr_uobject,
+	.release = release_idr_uobject,
+};
+
+void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
+{
+	unsigned int cur_order = 0;
+
+	while (!list_empty(&ucontext->uobjects)) {
+		struct ib_uobject *obj, *next_obj;
+		unsigned int next_order = UINT_MAX;
+
+		/*
+		 * This shouldn't run while executing other commands on this
+		 * context, thus no lock is required.
+		 */
+		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
+					 list)
+			if (obj->type->destroy_order == cur_order) {
+				list_del(&obj->list);
+				obj->type->ops->hot_unplug(obj, device_removed);
+			} else {
+				next_order = min(next_order,
+						 obj->type->destroy_order);
+			}
+		cur_order = next_order;
+	}
+}
+
+void uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
+{
+	mutex_init(&ucontext->lock);
+	INIT_LIST_HEAD(&ucontext->uobjects);
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
new file mode 100644
index 0000000..ab665a6
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005-2017 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef RDMA_CORE_H
+#define RDMA_CORE_H
+
+#include <linux/idr.h>
+#include <rdma/uverbs_types.h>
+#include <rdma/ib_verbs.h>
+#include <linux/mutex.h>
+
+/*
+ * These functions initialize the context and cleanups its uobjects.
+ * The context has a list of objects which is protected by a mutex
+ * on the context. initialize_ucontext should be called when we create
+ * a context.
+ * cleanup_ucontext removes all uobjects from the context and puts them.
+ */
+void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed);
+void uverbs_initialize_ucontext(struct ib_ucontext *ucontext);
+
+#endif /* RDMA_CORE_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ab3cae4..4a2a0fc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1347,6 +1347,10 @@ struct ib_ucontext {
 	struct list_head	rwq_ind_tbl_list;
 	int			closing;
 
+	/* locking the uobjects_list */
+	struct mutex		lock;
+	struct list_head	uobjects;
+
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct rb_root      umem_tree;
@@ -1374,8 +1378,11 @@ struct ib_uobject {
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
+	struct rw_semaphore	currently_used;	/* protects exclusive access */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
+
+	const struct uverbs_obj_type *type;
 };
 
 struct ib_udata {
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
new file mode 100644
index 0000000..bb263f0
--- /dev/null
+++ b/include/rdma/uverbs_types.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2017, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _UVERBS_TYPES_
+#define _UVERBS_TYPES_
+
+#include <linux/kernel.h>
+#include <rdma/ib_verbs.h>
+
+struct uverbs_obj_type;
+
+struct uverbs_obj_type_ops {
+	/*
+	 * Get an ib_uobject that corresponds to the given id from ucontext,
+	 * These functions could create or destroy objects if required.
+	 * The action will be finalized only when commit, abort or put fops are
+	 * called.
+	 * The flow of the different actions is:
+	 * [alloc]:	 Starts with alloc_begin. The handlers logic is than
+	 *		 executed. If the handler is successful, alloc_commit
+	 *		 is called and the object is inserted to the repository.
+	 *		 Otherwise, alloc_abort is called and the object is
+	 *		 destroyed.
+	 * [lookup]:	 Starts with lookup_get which fetches and locks the
+	 *		 object. After the handler finished using the object, it
+	 *		 needs to call lookup_put to unlock it. The write flag
+	 *		 indicates if the object is locked for exclusive access.
+	 * [destroy]:	 Starts with lookup_get with write flag set. This locks
+	 *		 the object for exclusive access. If the handler code
+	 *		 completed successfully, destroy_commit is called and
+	 *		 the ib_uobject is removed from the context's uobjects
+	 *		 repository and put. Otherwise, lookup_put should be
+	 *		 called.
+	 * [hot_unplug]: Used when the context is destroyed (process
+	 *		 termination, reset flow).
+	 * [release]:    Releases the memory of the ib_uobject. This is called
+	 *		 when the last reference is put. We favored a callback
+	 *		 here as this might require tricks like kfree_rcu.
+	 *		 This shouldn't be called explicitly by the user as it's
+	 *		 used by uverbs_uobject_put.
+	 */
+	struct ib_uobject *(*alloc_begin)(const struct uverbs_obj_type *type,
+					  struct ib_ucontext *ucontext);
+	void (*alloc_commit)(struct ib_uobject *uobj);
+	void (*alloc_abort)(struct ib_uobject *uobj);
+
+	struct ib_uobject *(*lookup_get)(const struct uverbs_obj_type *type,
+					 struct ib_ucontext *ucontext, int id,
+					 bool write);
+	void (*lookup_put)(struct ib_uobject *uobj, bool write);
+	void (*destroy_commit)(struct ib_uobject *uobj);
+
+	void (*hot_unplug)(struct ib_uobject *uobj, bool device_removed);
+
+	void (*release)(struct ib_uobject *uobj);
+};
+
+struct uverbs_obj_type {
+	const struct uverbs_obj_type_ops * const ops;
+	unsigned int destroy_order;
+};
+
+struct uverbs_obj_idr_type {
+	/*
+	 * In idr based objects, uverbs_obj_type_ops points to a generic
+	 * idr operations. In order to specialize the underlying types (e.g. CQ,
+	 * QPs, etc.), we add obj_size and hot_unplug specific callbacks here.
+	 */
+	struct uverbs_obj_type  type;
+	size_t			obj_size;
+	/* The hot_unplug in ops initialized by idr, calls this callback */
+	void (*hot_unplug)(struct ib_uobject *uobj);
+};
+
+#endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
