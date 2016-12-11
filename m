From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 02/14] IB/core: Add support for custom types
Date: Sun, 11 Dec 2016 14:57:56 +0200
Message-ID: <1481461088-56355-3-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile      |   3 +-
 drivers/infiniband/core/device.c      |   1 +
 drivers/infiniband/core/rdma_core.c   | 397 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h   |  71 ++++++
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_main.c |   2 +-
 include/rdma/ib_verbs.h               |  22 +-
 include/rdma/uverbs_ioctl.h           | 218 +++++++++++++++++++
 8 files changed, 710 insertions(+), 5 deletions(-)
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
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c3b68f5..43994b1 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -243,6 +243,7 @@ struct ib_device *ib_alloc_device(size_t size)
 	spin_lock_init(&device->client_data_lock);
 	INIT_LIST_HEAD(&device->client_data_list);
 	INIT_LIST_HEAD(&device->port_list);
+	INIT_LIST_HEAD(&device->type_list);
 
 	return device;
 }
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
new file mode 100644
index 0000000..398b61f
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.c
@@ -0,0 +1,397 @@
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
+#include "uverbs.h"
+#include "rdma_core.h"
+#include <rdma/uverbs_ioctl.h>
+
+static int uverbs_lock_object(struct ib_uobject *uobj,
+			      enum uverbs_idr_access access)
+{
+	if (access == UVERBS_IDR_ACCESS_READ)
+		return down_read_trylock(&uobj->usecnt) == 1 ? 0 : -EBUSY;
+
+	/* lock is either WRITE or DESTROY - should be exclusive */
+	return down_write_trylock(&uobj->usecnt) == 1 ? 0 : -EBUSY;
+}
+
+static struct ib_uobject *get_uobj(int id, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	rcu_read_lock();
+	uobj = idr_find(&context->device->idr, id);
+	if (uobj) {
+		if (uobj->context != context)
+			uobj = NULL;
+	}
+	rcu_read_unlock();
+
+	return uobj;
+}
+
+bool uverbs_is_live(struct ib_uobject *uobj)
+{
+	return uobj == get_uobj(uobj->id, uobj->context);
+}
+
+struct ib_ucontext_lock {
+	struct kref  ref;
+	/* locking the uobjects_list */
+	struct mutex lock;
+};
+
+static void release_uobjects_list_lock(struct kref *ref)
+{
+	struct ib_ucontext_lock *lock = container_of(ref,
+						     struct ib_ucontext_lock,
+						     ref);
+
+	kfree(lock);
+}
+
+static void init_uobj(struct ib_uobject *uobj, struct ib_ucontext *context)
+{
+	init_rwsem(&uobj->usecnt);
+	uobj->context     = context;
+}
+
+static int add_uobj(struct ib_uobject *uobj)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&uobj->context->device->idr_lock);
+
+	/* The uobject will be replaced with the actual one when we commit */
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
+static void remove_uobj(struct ib_uobject *uobj)
+{
+	spin_lock(&uobj->context->device->idr_lock);
+	idr_remove(&uobj->context->device->idr, uobj->id);
+	spin_unlock(&uobj->context->device->idr_lock);
+}
+
+static void put_uobj(struct ib_uobject *uobj)
+{
+	kfree_rcu(uobj, rcu);
+}
+
+static struct ib_uobject *get_uobject_from_context(struct ib_ucontext *ucontext,
+						   const struct uverbs_type_alloc_action *type,
+						   u32 idr,
+						   enum uverbs_idr_access access)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	rcu_read_lock();
+	uobj = get_uobj(idr, ucontext);
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
+
+	return NULL;
+}
+
+static int ib_uverbs_uobject_add(struct ib_uobject *uobject,
+				 const struct uverbs_type_alloc_action *uobject_type)
+{
+	uobject->type = uobject_type;
+	return add_uobj(uobject);
+}
+
+struct ib_uobject *uverbs_get_type_from_idr(const struct uverbs_type_alloc_action *type,
+					    struct ib_ucontext *ucontext,
+					    enum uverbs_idr_access access,
+					    uint32_t idr)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	if (access == UVERBS_IDR_ACCESS_NEW) {
+		uobj = kmalloc(type->obj_size, GFP_KERNEL);
+		if (!uobj)
+			return ERR_PTR(-ENOMEM);
+
+		init_uobj(uobj, ucontext);
+
+		/* lock idr */
+		ret = ib_uverbs_uobject_add(uobj, type);
+		if (ret) {
+			kfree(uobj);
+			return ERR_PTR(ret);
+		}
+
+	} else {
+		uobj = get_uobject_from_context(ucontext, type, idr,
+						access);
+
+		if (!uobj)
+			return ERR_PTR(-ENOENT);
+	}
+
+	return uobj;
+}
+
+struct ib_uobject *uverbs_get_type_from_fd(const struct uverbs_type_alloc_action *type,
+					   struct ib_ucontext *ucontext,
+					   enum uverbs_idr_access access,
+					   int fd)
+{
+	if (access == UVERBS_IDR_ACCESS_NEW) {
+		int _fd;
+		struct ib_uobject *uobj = NULL;
+		struct file *filp;
+
+		_fd = get_unused_fd_flags(O_CLOEXEC);
+		if (_fd < 0 || WARN_ON(type->obj_size < sizeof(struct ib_uobject)))
+			return ERR_PTR(_fd);
+
+		uobj = kmalloc(type->obj_size, GFP_KERNEL);
+		init_uobj(uobj, ucontext);
+
+		if (!uobj)
+			return ERR_PTR(-ENOMEM);
+
+		filp = anon_inode_getfile(type->fd.name, type->fd.fops,
+					  uobj + 1, type->fd.flags);
+		if (IS_ERR(filp)) {
+			put_unused_fd(_fd);
+			kfree(uobj);
+			return (void *)filp;
+		}
+
+		uobj->type = type;
+		uobj->id = _fd;
+		uobj->object = filp;
+
+		return uobj;
+	} else if (access == UVERBS_IDR_ACCESS_READ) {
+		struct file *f = fget(fd);
+		struct ib_uobject *uobject;
+
+		if (!f)
+			return ERR_PTR(-EBADF);
+
+		uobject = f->private_data - sizeof(struct ib_uobject);
+		if (f->f_op != type->fd.fops ||
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
+static void ib_uverbs_uobject_enable(struct ib_uobject *uobject)
+{
+	mutex_lock(&uobject->context->uobjects_lock->lock);
+	list_add(&uobject->list, &uobject->context->uobjects);
+	mutex_unlock(&uobject->context->uobjects_lock->lock);
+	spin_lock(&uobject->context->device->idr_lock);
+	idr_replace(&uobject->context->device->idr, uobject, uobject->id);
+	spin_unlock(&uobject->context->device->idr_lock);
+}
+
+static void ib_uverbs_uobject_remove(struct ib_uobject *uobject, bool lock)
+{
+	/*
+	 * Calling remove requires exclusive access, so it's not possible
+	 * another thread will use our object.
+	 */
+	remove_uobj(uobject);
+	if (lock)
+		mutex_lock(&uobject->context->uobjects_lock->lock);
+	list_del(&uobject->list);
+	if (lock)
+		mutex_unlock(&uobject->context->uobjects_lock->lock);
+	put_uobj(uobject);
+}
+
+static void uverbs_commit_idr(struct ib_uobject *uobj,
+			      enum uverbs_idr_access access,
+			      bool success)
+{
+	switch (access) {
+	case UVERBS_IDR_ACCESS_READ:
+		up_read(&uobj->usecnt);
+		break;
+	case UVERBS_IDR_ACCESS_NEW:
+		if (success) {
+			ib_uverbs_uobject_enable(uobj);
+		} else {
+			remove_uobj(uobj);
+			put_uobj(uobj);
+		}
+		break;
+	case UVERBS_IDR_ACCESS_WRITE:
+		up_write(&uobj->usecnt);
+		break;
+	case UVERBS_IDR_ACCESS_DESTROY:
+		if (success)
+			ib_uverbs_uobject_remove(uobj, true);
+		else
+			up_write(&uobj->usecnt);
+		break;
+	}
+}
+
+static void uverbs_commit_fd(struct ib_uobject *uobj,
+			     enum uverbs_idr_access access,
+			     bool success)
+{
+	struct file *filp = uobj->object;
+
+	if (access == UVERBS_IDR_ACCESS_NEW) {
+		if (success) {
+			kref_get(&uobj->context->ufile->ref);
+			uobj->uobjects_lock = uobj->context->uobjects_lock;
+			kref_get(&uobj->uobjects_lock->ref);
+			ib_uverbs_uobject_enable(uobj);
+			fd_install(uobj->id, uobj->object);
+		} else {
+			fput(uobj->object);
+			put_unused_fd(uobj->id);
+			kfree(uobj);
+		}
+	} else {
+		fput(filp);
+	}
+}
+
+static void _uverbs_commit_object(struct ib_uobject *uobj,
+				  enum uverbs_idr_access access,
+				  bool success)
+{
+	if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
+		uverbs_commit_idr(uobj, access, success);
+	else if (uobj->type->type == UVERBS_ATTR_TYPE_FD)
+		uverbs_commit_fd(uobj, access, success);
+	else
+		WARN_ON(true);
+}
+
+void uverbs_commit_object(struct ib_uobject *uobj,
+			  enum uverbs_idr_access access)
+{
+	return _uverbs_commit_object(uobj, access, true);
+}
+
+void uverbs_rollback_object(struct ib_uobject *uobj,
+			    enum uverbs_idr_access access)
+{
+	return _uverbs_commit_object(uobj, access, false);
+}
+
+void ib_uverbs_close_fd(struct file *f)
+{
+	struct ib_uobject *uobject = f->private_data - sizeof(struct ib_uobject);
+
+	mutex_lock(&uobject->uobjects_lock->lock);
+	if (uobject->context) {
+		list_del(&uobject->list);
+		kref_put(&uobject->context->ufile->ref, ib_uverbs_release_file);
+		uobject->context = NULL;
+	}
+	mutex_unlock(&uobject->uobjects_lock->lock);
+	kref_put(&uobject->uobjects_lock->ref, release_uobjects_list_lock);
+}
+
+void ib_uverbs_cleanup_fd(void *private_data)
+{
+	struct ib_uboject *uobject = private_data - sizeof(struct ib_uobject);
+
+	kfree(uobject);
+}
+
+void uverbs_commit_objects(struct uverbs_attr_array *attr_array,
+			   size_t num,
+			   const struct uverbs_action *action,
+			   bool success)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++) {
+		struct uverbs_attr_array *attr_spec_array = &attr_array[i];
+		const struct uverbs_attr_spec_group *attr_spec_group =
+			action->attr_groups[i];
+		unsigned int j;
+
+		for (j = 0; j < attr_spec_array->num_attrs; j++) {
+			struct uverbs_attr *attr = &attr_spec_array->attrs[j];
+			struct uverbs_attr_spec *spec = &attr_spec_group->attrs[j];
+
+			if (!uverbs_is_valid(attr_spec_array, j))
+				continue;
+
+			if (spec->type == UVERBS_ATTR_TYPE_IDR ||
+			    spec->type == UVERBS_ATTR_TYPE_FD)
+				/*
+				 * refcounts should be handled at the object
+				 * level and not at the uobject level.
+				 */
+				_uverbs_commit_object(attr->obj_attr.uobject,
+						      spec->obj.access, success);
+		}
+	}
+}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
new file mode 100644
index 0000000..0bb4be3
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.h
@@ -0,0 +1,71 @@
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
+struct ib_uobject *uverbs_get_type_from_idr(const struct uverbs_type_alloc_action *type,
+					    struct ib_ucontext *ucontext,
+					    enum uverbs_idr_access access,
+					    uint32_t idr);
+struct ib_uobject *uverbs_get_type_from_fd(const struct uverbs_type_alloc_action *type,
+					   struct ib_ucontext *ucontext,
+					   enum uverbs_idr_access access,
+					   int fd);
+bool uverbs_is_live(struct ib_uobject *uobj);
+void uverbs_rollback_object(struct ib_uobject *uobj,
+			    enum uverbs_idr_access access);
+void uverbs_commit_object(struct ib_uobject *uobj,
+				 enum uverbs_idr_access access);
+void uverbs_commit_objects(struct uverbs_attr_array *attr_array,
+			   size_t num,
+			   const struct uverbs_action *action,
+			   bool success);
+
+void ib_uverbs_close_fd(struct file *f);
+void ib_uverbs_cleanup_fd(void *private_data);
+
+static inline void *uverbs_fd_to_priv(struct ib_uobject *uobj)
+{
+	return uobj + 1;
+}
+
+#endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 8074705..ae7d4b8 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -180,6 +180,7 @@ void idr_remove_uobj(struct ib_uobject *uobj);
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
 					int is_async);
+void ib_uverbs_release_file(struct kref *ref);
 void ib_uverbs_free_async_event_file(struct ib_uverbs_file *uverbs_file);
 struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f783723..e63357a 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -341,7 +341,7 @@ static void ib_uverbs_comp_dev(struct ib_uverbs_device *dev)
 	complete(&dev->comp);
 }
 
-static void ib_uverbs_release_file(struct kref *ref)
+void ib_uverbs_release_file(struct kref *ref)
 {
 	struct ib_uverbs_file *file =
 		container_of(ref, struct ib_uverbs_file, ref);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b5d2075..282b0ba 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1329,8 +1329,11 @@ struct ib_fmr_attr {
 
 struct ib_umem;
 
+struct ib_ucontext_lock;
+
 struct ib_ucontext {
 	struct ib_device       *device;
+	struct ib_uverbs_file  *ufile;
 	struct list_head	pd_list;
 	struct list_head	mr_list;
 	struct list_head	mw_list;
@@ -1344,6 +1347,10 @@ struct ib_ucontext {
 	struct list_head	rwq_ind_tbl_list;
 	int			closing;
 
+	/* lock for uobjects list */
+	struct ib_ucontext_lock	*uobjects_lock;
+	struct list_head	uobjects;
+
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct rb_root      umem_tree;
@@ -1363,16 +1370,22 @@ struct ib_ucontext {
 #endif
 };
 
+struct uverbs_object_list;
+
 struct ib_uobject {
 	u64			user_handle;	/* handle given to us by userspace */
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
-	int			id;		/* index into kernel idr */
-	struct kref		ref;
-	struct rw_semaphore	mutex;		/* protects .live */
+	int			id;		/* index into kernel idr/fd */
+	struct kref             ref;
+	struct rw_semaphore	usecnt;		/* protects exclusive access */
+	struct rw_semaphore     mutex;          /* protects .live */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
+
+	const struct uverbs_type_alloc_action *type;
+	struct ib_ucontext_lock	*uobjects_lock;
 };
 
 struct ib_udata {
@@ -2101,6 +2114,9 @@ struct ib_device {
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
+	struct list_head type_list;
+
+	const struct uverbs_types_group	*types_group;
 };
 
 struct ib_client {
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
new file mode 100644
index 0000000..382321b
--- /dev/null
+++ b/include/rdma/uverbs_ioctl.h
@@ -0,0 +1,218 @@
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
+struct uverbs_object_type;
+struct ib_ucontext;
+struct ib_uobject;
+struct ib_device;
+struct uverbs_uobject_type;
+
+/*
+ * =======================================
+ *	Verbs action specifications
+ * =======================================
+ */
+
+#define UVERBS_ID_RESERVED_MASK 0xF000
+#define UVERBS_ID_RESERVED_SHIFT 12
+
+enum uverbs_attr_type {
+	UVERBS_ATTR_TYPE_NA,
+	UVERBS_ATTR_TYPE_PTR_IN,
+	UVERBS_ATTR_TYPE_PTR_OUT,
+	UVERBS_ATTR_TYPE_IDR,
+	UVERBS_ATTR_TYPE_FD,
+	UVERBS_ATTR_TYPE_FLAG,
+};
+
+enum uverbs_idr_access {
+	UVERBS_IDR_ACCESS_READ,
+	UVERBS_IDR_ACCESS_WRITE,
+	UVERBS_IDR_ACCESS_NEW,
+	UVERBS_IDR_ACCESS_DESTROY
+};
+
+enum uverbs_attr_spec_flags {
+	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
+	UVERBS_ATTR_SPEC_F_MIN_SZ	= 1U << 1,
+};
+
+struct uverbs_attr_spec {
+	enum uverbs_attr_type		type;
+	u8				flags;
+	union {
+		u16				len;
+		struct {
+			u16			obj_type;
+			u8			access;
+		} obj;
+		struct {
+			/* flags are always 64bits */
+			u64			mask;
+		} flag;
+	};
+};
+
+struct uverbs_attr_spec_group {
+	struct uverbs_attr_spec		*attrs;
+	size_t				num_attrs;
+	/* populate at runtime */
+	unsigned long			*mandatory_attrs_bitmask;
+};
+
+struct uverbs_attr_array;
+struct ib_uverbs_file;
+
+enum uverbs_action_flags {
+	UVERBS_ACTION_FLAG_CREATE_ROOT = 1 << 0,
+};
+
+struct uverbs_action {
+	const struct uverbs_attr_spec_group		**attr_groups;
+	size_t						num_groups;
+	u32 flags;
+	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
+		       struct uverbs_attr_array *ctx, size_t num);
+	u16 num_child_attrs;
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
+	struct {
+		const struct file_operations	*fops;
+		const char			*name;
+		int				flags;
+	} fd;
+};
+
+struct uverbs_action_group {
+	size_t					num_actions;
+	const struct uverbs_action		**actions;
+};
+
+struct uverbs_type {
+	size_t					num_groups;
+	const struct uverbs_action_group	**action_groups;
+	const struct uverbs_type_alloc_action	*alloc;
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
+/* =================================================
+ *              Parsing infrastructure
+ * =================================================
+ */
+
+struct uverbs_ptr_attr {
+	void	* __user ptr;
+	u16		len;
+};
+
+struct uverbs_fd_attr {
+	int		fd;
+};
+
+struct uverbs_uobj_attr {
+	/*  idr handle */
+	u32	idr;
+};
+
+struct uverbs_flag_attr {
+	u64	flags;
+};
+
+struct uverbs_obj_attr {
+	/* pointer to the kernel descriptor -> type, access, etc */
+	struct ib_uverbs_attr __user	*uattr;
+	const struct uverbs_type_alloc_action	*type;
+	struct ib_uobject		*uobject;
+	union {
+		struct uverbs_fd_attr		fd;
+		struct uverbs_uobj_attr		uobj;
+	};
+};
+
+struct uverbs_attr {
+	union {
+		struct uverbs_ptr_attr	cmd_attr;
+		struct uverbs_obj_attr	obj_attr;
+		struct uverbs_flag_attr flag_attr;
+	};
+};
+
+/* output of one validator */
+struct uverbs_attr_array {
+	unsigned long *valid_bitmap;
+	size_t num_attrs;
+	/* arrays of attrubytes, index is the id i.e SEND_CQ */
+	struct uverbs_attr *attrs;
+};
+
+static inline bool uverbs_is_valid(const struct uverbs_attr_array *attr_array,
+				   unsigned int idx)
+{
+	return test_bit(idx, attr_array->valid_bitmap);
+}
+
+/* =================================================
+ *              Types infrastructure
+ * =================================================
+ */
+
+int ib_uverbs_uobject_type_add(struct list_head	*head,
+			       void (*free)(struct uverbs_uobject_type *type,
+					    struct ib_uobject *uobject,
+					    struct ib_ucontext *ucontext),
+			       uint16_t	obj_type);
+void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev);
+
+#endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
