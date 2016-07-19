From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V2 4/8] RDMA/core: Introduce add/remove uobj from types
Date: Tue, 19 Jul 2016 18:23:28 +0300
Message-ID: <1468941812-32286-5-git-send-email-matanb@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We introduce here adding new user objects to the type list.
Adding an object is done in two parts.
First, an object is allocated and added to IDR. Then, the command's
handlers (in downstream patches) could work on this object and fill
in its required details.
After a successful command, ib_uverbs_uobject_enable is called and
this user objects becomes ucontext visible.

Removing an uboject is done by calling ib_uverbs_uobject_remove.

We should make sure IDR (per-device) and lists (per-ucontext) could
be accessed concurrently without corrupting them.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 276 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h |  21 +++
 include/rdma/ib_verbs.h             |  16 ++-
 include/rdma/uverbs_ioctl.h         | 155 ++++++++++++++++++++
 4 files changed, 466 insertions(+), 2 deletions(-)
 create mode 100644 include/rdma/uverbs_ioctl.h

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 672ce82..d833874 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -33,6 +33,7 @@
 #include <rdma/ib_verbs.h>
 #include "uverbs.h"
 #include "rdma_core.h"
+#include <rdma/uverbs_ioctl.h>
 
 /*
  * lockless - the list shouldn't change. If disassociate is carrie out during
@@ -51,6 +52,189 @@ struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
 	return NULL;
 }
 
+static int uverbs_lock_object(struct ib_uobject *uobj,
+			      enum uverbs_idr_access access)
+{
+	if (access == UVERBS_IDR_ACCESS_READ)
+		return __atomic_add_unless(&uobj->usecnt, 1, -1) == -1 ?
+			-EBUSY : 0;
+	else
+		/* lock is either WRITE or DESTROY - should be exclusive */
+		return atomic_cmpxchg(&uobj->usecnt, 0, -1) == 0 ? 0 : -EBUSY;
+}
+
+static struct ib_uobject *get_uobj(int id, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	rcu_read_lock();
+	uobj = idr_find(&context->device->idr, id);
+	if (uobj && uobj->live) {
+		if (uobj->context != context)
+			uobj = NULL;
+	}
+	rcu_read_unlock();
+
+	return uobj;
+}
+
+static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
+		      struct ib_ucontext *context)
+{
+	uobj->user_handle = user_handle;
+	uobj->context     = context;
+	uobj->live        = 0;
+}
+
+static int add_uobj(struct ib_uobject *uobj)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&uobj->context->device->idr_lock);
+
+	ret = idr_alloc(&uobj->context->device->idr, uobj, 0, 0, GFP_NOWAIT);
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
+						   const struct uverbs_uobject_type *type,
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
+	if (uobj->type->type != type) {
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
+struct ib_uobject *uverbs_get_type_from_idr(struct uverbs_uobject_type *type,
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
+		init_uobj(uobj, 0, ucontext);
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
+static void uverbs_unlock_object(struct ib_uobject *uobj,
+				 enum uverbs_idr_access access,
+				 bool success)
+{
+	switch (access) {
+	case UVERBS_IDR_ACCESS_READ:
+		atomic_dec(&uobj->usecnt);
+		break;
+	case UVERBS_IDR_ACCESS_NEW:
+		if (success) {
+			atomic_set(&uobj->usecnt, 0);
+			ib_uverbs_uobject_enable(uobj);
+		} else {
+			remove_uobj(uobj);
+			put_uobj(uobj);
+		}
+		break;
+	case UVERBS_IDR_ACCESS_WRITE:
+		atomic_set(&uobj->usecnt, 0);
+		break;
+	case UVERBS_IDR_ACCESS_DESTROY:
+		if (success)
+			ib_uverbs_uobject_remove(uobj);
+		else
+			atomic_set(&uobj->usecnt, 0);
+		break;
+	}
+}
+
+void uverbs_unlock_objects(struct uverbs_attr_array *attr_array,
+			   size_t num,
+			   const struct action_spec *chain,
+			   bool success)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++) {
+		struct uverbs_attr_array *attr_spec_array = &attr_array[i];
+		const struct uverbs_attr_chain_spec *chain_spec =
+			chain->validator_chains[i];
+		unsigned int j;
+
+		for (j = 0; j < attr_spec_array->num_attrs; j++) {
+			struct uverbs_attr *attr = &attr_spec_array->attrs[j];
+			struct uverbs_attr_spec *spec = &chain_spec->attrs[j];
+
+			if (spec->type != UVERBS_ATTR_TYPE_IDR || !attr->valid)
+				continue;
+
+			/*
+			 * refcounts should be handled at the object level and
+			 * not at the uobject level.
+			 */
+			uverbs_unlock_object(attr->obj_attr.uobject,
+					     spec->idr.access, success);
+		}
+	}
+}
+
 int ib_uverbs_uobject_type_add(struct list_head	*head,
 			       void (*free)(struct uverbs_uobject_type *uobject_type,
 					    struct ib_uobject *uobject,
@@ -100,3 +284,95 @@ void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev)
 }
 EXPORT_SYMBOL(ib_uverbs_uobject_types_remove);
 
+void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext *ucontext)
+{
+	struct uverbs_uobject_list *uobject_list, *next_list;
+
+	list_for_each_entry_safe(uobject_list, next_list,
+				 &ucontext->uobjects_lists, type_list) {
+		struct ib_uobject *obj, *next_obj;
+
+		/*
+		 * No need to take lock here, as cleanup should be called
+		 * after all commands finished executing. Newly executed
+		 * commands should fail.
+		 */
+		list_for_each_entry_safe(obj, next_obj, &uobject_list->list,
+					 list)
+			ib_uverbs_uobject_remove(obj);
+
+		list_del(&uobject_list->type_list);
+	}
+}
+
+int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext *ucontext,
+					       struct list_head *type_list)
+{
+	/* create typed list in ucontext */
+	struct uverbs_uobject_type *type;
+	int err;
+
+	INIT_LIST_HEAD(&ucontext->uobjects_lists);
+
+	list_for_each_entry(type, type_list, type_list) {
+		struct uverbs_uobject_list *cur;
+
+		cur = kzalloc(sizeof(*cur), GFP_KERNEL);
+		if (!cur) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		cur->type = type;
+		INIT_LIST_HEAD(&cur->list);
+		list_add_tail(&cur->type_list, &ucontext->uobjects_lists);
+		mutex_init(&cur->uobj_lock);
+	}
+
+	return 0;
+
+err:
+	ib_uverbs_uobject_type_cleanup_ucontext(ucontext);
+	return err;
+}
+
+int ib_uverbs_uobject_add(struct ib_uobject *uobject,
+			  struct uverbs_uobject_type *uobject_type)
+{
+	int ret = -EINVAL;
+	struct uverbs_uobject_list *type;
+
+	/* No need for locking here is type list shouldn't be changed */
+	list_for_each_entry(type, &uobject->context->uobjects_lists, type_list)
+		if (type->type == uobject_type) {
+			uobject->type = type;
+			ret = add_uobj(uobject);
+			return ret;
+		}
+
+	return ret;
+}
+
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject)
+{
+	mutex_lock(&uobject->type->uobj_lock);
+	list_add(&uobject->list, &uobject->type->list);
+	mutex_unlock(&uobject->type->uobj_lock);
+	uobject->live = 1;
+}
+
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject)
+{
+	/*
+	 * Calling remove requires exclusive access, so it's not possible
+	 * another thread will use our object.
+	 */
+	uobject->live = 0;
+	uobject->type->type->free(uobject->type->type, uobject,
+				  uobject->context);
+	mutex_lock(&uobject->type->uobj_lock);
+	list_del(&uobject->list);
+	mutex_unlock(&uobject->type->uobj_lock);
+	remove_uobj(uobject);
+	put_uobj(uobject);
+}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index c734a76..3bf6667 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -37,16 +37,32 @@
 #ifndef UOBJECT_H
 #define UOBJECT_H
 
+#include <linux/idr.h>
+#include <rdma/uverbs_ioctl.h>
 #include <rdma/ib_verbs.h>
 #include <linux/mutex.h>
 
 struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
 					    uint16_t type);
+struct ib_uobject *uverbs_get_type_from_idr(struct uverbs_uobject_type *type,
+					    struct ib_ucontext *ucontext,
+					    enum uverbs_idr_access access,
+					    uint32_t idr);
 int ib_uverbs_uobject_type_add(struct list_head	*head,
 			       void (*free)(struct uverbs_uobject_type *uobject_type,
 					    struct ib_uobject *uobject,
 					    struct ib_ucontext *ucontext),
 			       uint16_t	obj_type);
+void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev);
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject);
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject);
+void uverbs_unlock_objects(struct uverbs_attr_array *attr_array,
+			   size_t num,
+			   const struct action_spec *chain,
+			   bool success);
+
+int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext *ucontext,
+					       struct list_head *type_list);
 
 struct uverbs_uobject_type {
 	struct list_head	type_list;
@@ -66,4 +82,9 @@ struct uverbs_uobject_list {
 	struct list_head		type_list;
 };
 
+int ib_uverbs_uobject_add(struct ib_uobject *uobject,
+			  struct uverbs_uobject_type *uobject_type);
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject);
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject);
+
 #endif /* UIDR_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6d7964f..85d4c41 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1346,16 +1346,28 @@ struct ib_ucontext {
 #endif
 };
 
+struct uverbs_object_list;
+
+#define OLD_ABI_COMPAT
+
 struct ib_uobject {
 	u64			user_handle;	/* handle given to us by userspace */
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr */
-	struct kref		ref;
-	struct rw_semaphore	mutex;		/* protects .live */
+#ifdef OLD_ABI_COMPAT
+	struct kref             ref;
+#endif
+	atomic_t		usecnt;
+#ifdef OLD_ABI_COMPAT
+	struct rw_semaphore     mutex;          /* protects .live */
+#endif
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
+	/* List of object under uverbs_object_type */
+	struct list_head	idr_list;
+	struct uverbs_uobject_list *type;	/* ptr to ucontext type */
 };
 
 struct ib_udata {
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
new file mode 100644
index 0000000..7733b11
--- /dev/null
+++ b/include/rdma/uverbs_ioctl.h
@@ -0,0 +1,155 @@
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
+struct ib_device;
+
+/*
+ * =======================================
+ *	Verbs action specifications
+ * =======================================
+ */
+
+enum uverbs_attr_type {
+	UVERBS_ATTR_TYPE_PTR_IN,
+	UVERBS_ATTR_TYPE_PTR_OUT,
+	UVERBS_ATTR_TYPE_IDR,
+	/*
+	 * TODO: we could add FD type for command which will migrate the events
+	 * to a specific FD.
+	 */
+};
+
+enum uverbs_idr_access {
+	UVERBS_IDR_ACCESS_READ,
+	UVERBS_IDR_ACCESS_WRITE,
+	UVERBS_IDR_ACCESS_NEW,
+	UVERBS_IDR_ACCESS_DESTROY
+};
+
+struct uverbs_attr_spec {
+	u16				len;
+	enum uverbs_attr_type		type;
+	struct {
+		u16			new_size;
+		u16			idr_type;
+		u8			access;
+	} idr;
+	/* TODO: In case of FD, we could validate here the fops pointer */
+};
+
+struct uverbs_attr_chain_spec {
+	struct uverbs_attr_spec		*attrs;
+	size_t				num_attrs;
+};
+
+struct action_spec {
+	const struct uverbs_attr_chain_spec		**validator_chains;
+	/* if > 0 -> validator, otherwise, error */
+	int (*dist)(__u16 *attr_id, void *priv);
+	void						*priv;
+	size_t						num_chains;
+};
+
+struct uverbs_attr_array;
+struct ib_uverbs_file;
+
+struct uverbs_action {
+	struct action_spec chain;
+	void *priv;
+	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
+		       struct uverbs_attr_array *ctx, size_t num, void *priv);
+};
+
+struct uverbs_type_actions {
+	size_t				num_actions;
+	const struct uverbs_action	*actions;
+};
+
+struct uverbs_types {
+	size_t					num_types;
+	const struct uverbs_type_actions	**types;
+};
+
+/* =================================================
+ *              Parsing infrastructure
+ * =================================================
+ */
+
+struct uverbs_ptr_attr {
+	void	* __user ptr;
+	__u16		len;
+};
+
+struct uverbs_obj_attr {
+	/*  idr handle */
+	__u32	idr;
+	/* pointer to the kernel descriptor -> type, access, etc */
+	const struct uverbs_attr_spec *val;
+	struct ib_uobject		*uobject;
+	struct uverbs_uobject_type	*type;
+};
+
+struct uverbs_attr {
+	bool valid;
+	union {
+		struct uverbs_ptr_attr	cmd_attr;
+		struct uverbs_obj_attr	obj_attr;
+	};
+};
+
+/* output of one validator */
+struct uverbs_attr_array {
+	size_t num_attrs;
+	/* arrays of attrubytes, index is the id i.e SEND_CQ */
+	struct uverbs_attr *attrs;
+};
+
+/* =================================================
+ *              Types infrastructure
+ * =================================================
+ */
+
+int ib_uverbs_uobject_type_add(struct list_head	*head,
+			       void (*free)(struct uverbs_uobject_type *uobject_type,
+					    struct ib_uobject *uobject,
+					    struct ib_ucontext *ucontext),
+			       uint16_t	obj_type);
+void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev);
+
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
