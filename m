From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/7] IB/core: Add support for custom types
Date: Wed, 11 Jan 2017 12:53:48 +0200
Message-ID: <1484132033-3346-3-git-send-email-matanb@mellanox.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484132033-3346-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new ioctl infrastructure supports driver specific objects.
Each such object type has a free function, allocation size and an
order of destruction. This information is embedded in the same
table describing the various action allowed on the object, similarly
to object oriented programming.

When a ucontext is created, a new list is created in this ib_ucontext.
This list contains all objects created under this ib_ucontext.
When a ib_ucontext is destroyed, we traverse this list several time
destroying the various objects by the order mentioned in the object
type description. If few object types have the same destruction order,
they are destroyed in an order opposite to their creation order.

Adding an object is done in two parts.
First, an object is allocated and added to IDR/fd table. Then, the
command's handlers (in downstream patches) could work on this object
and fill in its required details.
After a successful command, ib_uverbs_uobject_enable is called and
this user objects becomes ucontext visible.

Removing an uboject is done by calling ib_uverbs_uobject_remove.

We should make sure IDR (per-device) and list (per-ucontext) could
be accessed concurrently without corrupting them.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |   3 +-
 drivers/infiniband/core/rdma_core.c | 264 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h |  61 +++++++++
 include/rdma/ib_verbs.h             |   9 ++
 include/rdma/uverbs_ioctl.h         |  60 ++++++++
 5 files changed, 396 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 include/rdma/uverbs_ioctl.h

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
index 0000000..09b44ec
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.c
@@ -0,0 +1,264 @@
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
+#include <rdma/uverbs_ioctl.h>
+#include "uverbs.h"
+#include "rdma_core.h"
+
+static int uverbs_lock_object(struct ib_uobject *uobj,
+			      enum uverbs_idr_access access)
+{
+	if (access == UVERBS_ACCESS_READ)
+		return down_read_trylock(&uobj->usecnt) == 1 ? 0 : -EBUSY;
+
+	/* lock is either WRITE or DESTROY - should be exclusive */
+	return down_write_trylock(&uobj->usecnt) == 1 ? 0 : -EBUSY;
+}
+
+static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "uverbs: get_uobj_rcu wasn't called in a rcu_read_lock()!");
+	/* object won't be released as we're protected in rcu */
+	uobj = idr_find(&context->device->idr, id);
+	if (uobj) {
+		if (uobj->context != context)
+			uobj = NULL;
+	}
+
+	return uobj;
+}
+
+struct ib_ucontext_lock {
+	/* locking the uobjects_list */
+	struct mutex lock;
+};
+
+static void init_uobj(struct ib_uobject *uobj, struct ib_ucontext *context)
+{
+	init_rwsem(&uobj->usecnt);
+	uobj->context     = context;
+}
+
+static int uverbs_idr_add_uobj(struct ib_uobject *uobj)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&uobj->context->device->idr_lock);
+
+	/*
+	 * We start with allocating an idr pointing to NULL. This represents an
+	 * object which isn't initialized yet. We'll replace it later on with
+	 * the real object once we commit.
+	 */
+	ret = idr_alloc(&uobj->context->device->idr, NULL, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		uobj->id = ret;
+
+	spin_unlock(&uobj->context->device->idr_lock);
+	idr_preload_end();
+
+	return ret < 0 ? ret : 0;
+}
+
+static void uverbs_idr_remove_uobj(struct ib_uobject *uobj)
+{
+	spin_lock(&uobj->context->device->idr_lock);
+	idr_remove(&uobj->context->device->idr, uobj->id);
+	spin_unlock(&uobj->context->device->idr_lock);
+}
+
+static void put_uobj(struct ib_uobject *uobj)
+{
+	/*
+	 * When we destroy an object, we first just lock it for WRITE and
+	 * actually DESTROY it in the finalize stage. So, the problematic
+	 * scenario is when we just stared the finalize stage of the
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
+/*
+ * Returns the ib_uobject, NULL if the requested object isn't found or an error.
+ * The caller should check for IS_ERR_OR_NULL.
+ */
+static struct ib_uobject *get_uobject_from_context(struct ib_ucontext *ucontext,
+						   const struct uverbs_type_alloc_action *type,
+						   u32 idr,
+						   enum uverbs_idr_access access)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	rcu_read_lock();
+	uobj = get_uobj_rcu(idr, ucontext);
+	if (!uobj)
+		goto free;
+
+	if (uobj->type != type) {
+		uobj = NULL;
+		goto free;
+	}
+
+	ret = uverbs_lock_object(uobj, access);
+	if (ret)
+		uobj = ERR_PTR(ret);
+free:
+	rcu_read_unlock();
+	return uobj;
+}
+
+static struct ib_uobject *uverbs_get_uobject_from_idr(const struct uverbs_type_alloc_action *type_alloc,
+						      struct ib_ucontext *ucontext,
+						      enum uverbs_idr_access access,
+						      uint32_t idr)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	if (access == UVERBS_ACCESS_NEW) {
+		uobj = kmalloc(type_alloc->obj_size, GFP_KERNEL);
+		if (!uobj)
+			return ERR_PTR(-ENOMEM);
+
+		init_uobj(uobj, ucontext);
+
+		uobj->type = type_alloc;
+		ret = uverbs_idr_add_uobj(uobj);
+		if (ret) {
+			kfree(uobj);
+			return ERR_PTR(ret);
+		}
+
+	} else {
+		uobj = get_uobject_from_context(ucontext, type_alloc, idr,
+						access);
+
+		if (IS_ERR_OR_NULL(uobj))
+			return ERR_PTR(-ENOENT);
+	}
+
+	return uobj;
+}
+
+struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_alloc_action *type_alloc,
+						   struct ib_ucontext *ucontext,
+						   enum uverbs_idr_access access,
+						   unsigned int id)
+{
+	if (type_alloc->type == UVERBS_ATTR_TYPE_IDR)
+		return uverbs_get_uobject_from_idr(type_alloc, ucontext, access,
+						   id);
+	else
+		return ERR_PTR(-ENOENT);
+}
+
+static void uverbs_uobject_add(struct ib_uobject *uobject)
+{
+	mutex_lock(&uobject->context->uobjects_lock->lock);
+	list_add(&uobject->list, &uobject->context->uobjects);
+	mutex_unlock(&uobject->context->uobjects_lock->lock);
+}
+
+static void uverbs_uobject_remove(struct ib_uobject *uobject)
+{
+	/*
+	 * Calling remove requires exclusive access, so it's not possible
+	 * another thread will use our object since the function is called
+	 * with exclusive access.
+	 */
+	uverbs_idr_remove_uobj(uobject);
+	mutex_lock(&uobject->context->uobjects_lock->lock);
+	list_del(&uobject->list);
+	mutex_unlock(&uobject->context->uobjects_lock->lock);
+	put_uobj(uobject);
+}
+
+static void uverbs_finalize_idr(struct ib_uobject *uobj,
+				enum uverbs_idr_access access,
+				bool commit)
+{
+	switch (access) {
+	case UVERBS_ACCESS_READ:
+		up_read(&uobj->usecnt);
+		break;
+	case UVERBS_ACCESS_NEW:
+		if (commit) {
+			uverbs_uobject_add(uobj);
+			spin_lock(&uobj->context->device->idr_lock);
+			/*
+			 * We already allocated this IDR with a NULL object, so
+			 * this shouldn't fail.
+			 */
+			WARN_ON(idr_replace(&uobj->context->device->idr,
+					    uobj, uobj->id));
+			spin_unlock(&uobj->context->device->idr_lock);
+		} else {
+			uverbs_idr_remove_uobj(uobj);
+			put_uobj(uobj);
+		}
+		break;
+	case UVERBS_ACCESS_WRITE:
+		up_write(&uobj->usecnt);
+		break;
+	case UVERBS_ACCESS_DESTROY:
+		if (commit)
+			uverbs_uobject_remove(uobj);
+		else
+			up_write(&uobj->usecnt);
+		break;
+	}
+}
+
+void uverbs_finalize_object(struct ib_uobject *uobj,
+			    enum uverbs_idr_access access,
+			    bool commit)
+{
+	if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
+		uverbs_finalize_idr(uobj, access, commit);
+	else
+		WARN_ON(true);
+}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
new file mode 100644
index 0000000..0142573
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005-2016 Mellanox Technologies. All rights reserved.
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
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/ib_verbs.h>
+#include <linux/mutex.h>
+
+/*
+ * Get an ib_uobject that corresponds to the given id from ucontext, assuming
+ * the object is from the given type. Lock it to the required access.
+ * This function could create (access == NEW) or destroy (access == DESTROY)
+ * objects if required. The action will be finalized only when
+ * uverbs_finalize_object is called.
+ */
+struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_type_alloc_action *type_alloc,
+						   struct ib_ucontext *ucontext,
+						   enum uverbs_idr_access access,
+						   unsigned int id);
+
+void uverbs_finalize_object(struct ib_uobject *uobj,
+			    enum uverbs_idr_access access,
+			    bool success);
+
+#endif /* RDMA_CORE_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cad2c00..47f560d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1331,6 +1331,8 @@ struct ib_fmr_attr {
 
 struct ib_umem;
 
+struct ib_ucontext_lock;
+
 struct ib_ucontext {
 	struct ib_device       *device;
 	struct list_head	pd_list;
@@ -1346,6 +1348,10 @@ struct ib_ucontext {
 	struct list_head	rwq_ind_tbl_list;
 	int			closing;
 
+	/* lock for uobjects list */
+	struct ib_ucontext_lock	*uobjects_lock;
+	struct list_head	uobjects;
+
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct rb_root      umem_tree;
@@ -1373,8 +1379,11 @@ struct ib_uobject {
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
+	struct rw_semaphore	usecnt;		/* protects exclusive access */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
+
+	const struct uverbs_type_alloc_action *type;
 };
 
 struct ib_udata {
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
new file mode 100644
index 0000000..903f6b3
--- /dev/null
+++ b/include/rdma/uverbs_ioctl.h
@@ -0,0 +1,60 @@
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
+#ifndef _UVERBS_IOCTL_
+#define _UVERBS_IOCTL_
+
+#include <linux/kernel.h>
+
+enum uverbs_attr_type {
+	UVERBS_ATTR_TYPE_IDR,
+};
+
+enum uverbs_idr_access {
+	UVERBS_ACCESS_READ,
+	UVERBS_ACCESS_WRITE,
+	UVERBS_ACCESS_NEW,
+	UVERBS_ACCESS_DESTROY
+};
+
+struct uverbs_type_alloc_action;
+typedef void (*free_type)(const struct uverbs_type_alloc_action *uobject_type,
+			  struct ib_uobject *uobject);
+
+struct uverbs_type_alloc_action {
+	enum uverbs_attr_type		type;
+	int				order;
+	size_t				obj_size;
+	free_type			free_fn;
+};
+
+#endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
