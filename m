From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 6/8] RDMA/core: Add new ioctl interface
Date: Thu, 30 Jun 2016 16:39:29 +0300
Message-ID: <1467293971-25688-7-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In this proposed ioctl interface, processing the command starts from
validating properties of the command and fetching the appropriate user
objects before calling the handler.

Parsing and validation is done according to a specifier declared by
the driver's code. In the driver, all supported types are declared.
For each type we list all supported actions. Each action specifies a
handler, which could be either be a standard function or a vendor
specific function.
Along with the handler, a chain is specified as well. This chain
lists all supported attributes and is used for automatically
fetching and validating the command, response and its related objects.

Each chain consists of a validator_chains and a distribution function
which maps different command attributes to the different validators.
It also maps the attribute from the KABI world (which is vendor
specific) to the common kernel language.
Currently, in order to ease transition, we have a standard
distribution function which maps the attributes using the upper
attribute type bit.

A chain is an array of attributes. Each attribute has a type (PTR_IN,
PTR_OUT, IDR and in the future maybe FD, which could be used for
completion channel) and a length. Future work here might add
validation of mandatory attributes (i.e - make sure a specific
attribute was given).

If an IDR attribute is specified, the kernel also states the object
type and the required access (NEW, WRITE, READ or DESTROY).
All uobject management is done automatically by the infrastructure,
meaning - the infrastructure will fail when executing concurrent
actions and least one of these actions requires exclusive access
(WRITE/DESTROY).
Automatically synchronizing actions with device removals (dissociate
context events) and taking care of reference counting
(increase/decrease) is also one of the infrastructure goals.
Automatic reference counting isn't coded yet, but the general concept
here is to add (INCREASE_REF, DECREASE_REF) to the access
specification field and update these reference in success
automatically.

 types
+--------+
|        |                                                                          +--------+
|        |   actions    action      action_spec                           +-----+   |len     |
+--------+  +------+   +-------+   +----------------+   +------------+    |attr1+-> |type    |
| type   +> |action+-> |chain  +-> +validator_chains+-> |common_chain+--> +-----+   |idr_type|
+--------+  +------+   |handler|   |distribution_fn |   +------------+    |attr2|   |access  |
|        |  |      |   +-------+   +----------------+   |vendor chain|    +-----+   +--------+
|        |  |      |                                    +------------+
|        |  +------+
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
+--------+

Once validation and object fetching (or creation) completed, we call
the handler:
int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
               struct uverbs_attr_array *ctx, size_t num, void *priv);

Where ctx is an array of uverbs_attr_array. Each element in this array
is an array of attributes which corresponds to one validator.
For example, in the usually used case:

 ctx                               core
+----------------------------+     +------------+
| core: uverbs_attr_array    +---> | valid      |
+----------------------------+     | cmd_attr   |
| driver: uverbs_attr_array  |     +------------+
|----------------------------+--+  | valid      |
                                |  | cmd_attr   |
                                |  +------------+
                                |  | valid      |
                                |  | obj_attr   |
                                |  +------------+
                                |
                                |  driver
                                |  +------------+
                                +> | valid      |
                                   | cmd_attr   |
                                   +------------+
                                   | valid      |
                                   | cmd_attr   |
                                   +------------+
                                   | valid      |
                                   | obj_attr   |
                                   +------------+

Ctx array's indices corresponds to the various validators in the chain
spec and is given by the same order. The indices of core and driver
corresponds to the attributes name spaces of each validator.
Thus, we could think of the following as belong to one "object":
1. Set of attribute specification (with their attribute IDs)
2. Validator which owns (1) specifications
3. A function which could handle these attributes which the action's
   handler probably calls.

That means that core and driver attributes are the validated arguments
of function (3). Their "types" exist in this function scope in the
same way as bar exists in foo's scope in the following example:
int foo(some_type_t bar);

Since the common and vendor distinction is the frequent use case, we
propose a wrapper that allows a definition of the following handler:
int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
               struct uverbs_attr_array *common,
               struct uverbs_attr_array *vendor,
               void *priv);

Upon success, reference count of uobjects and use count will be a
updated automatically according to the specification.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile           |   2 +-
 drivers/infiniband/core/uidr.c             | 129 +++++++++++++
 drivers/infiniband/core/uidr.h             |  13 ++
 drivers/infiniband/core/uobject.c          |   2 +-
 drivers/infiniband/core/uverbs.h           |   4 +
 drivers/infiniband/core/uverbs_ioctl.c     | 279 +++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_ioctl_cmd.c |  57 ++++++
 drivers/infiniband/core/uverbs_main.c      |   6 +
 include/rdma/ib_verbs.h                    |   4 +
 include/rdma/uverbs_ioctl.h                | 202 +++++++++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  53 ++++++
 include/uapi/rdma/ib_user_ioctl.h          |  23 +++
 12 files changed, 772 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index c8bf8de..45caf7b 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				uidr.o uobject.o
+				uidr.o uobject.o uverbs_ioctl.o uverbs_ioctl_cmd.o
diff --git a/drivers/infiniband/core/uidr.c b/drivers/infiniband/core/uidr.c
index 1acdf64..72c4c77 100644
--- a/drivers/infiniband/core/uidr.c
+++ b/drivers/infiniband/core/uidr.c
@@ -31,9 +31,138 @@
  */
 
 #include <rdma/ib_verbs.h>
+#include <rdma/uverbs_ioctl.h>
 #include "uidr.h"
 #include "uobject.h"
 
+struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
+					    uint16_t type)
+{
+	struct uverbs_uobject_type *uobj_type;
+
+	list_for_each_entry(uobj_type, &ibdev->type_list, type_list) {
+		if (uobj_type->obj_type == type)
+			return uobj_type;
+	}
+
+	return NULL;
+}
+
+static int uverbs_lock_object(struct ib_uobject *uobj, int access)
+{
+	if (access == UVERBS_IDR_ACCESS_READ)
+		return __atomic_add_unless(&uobj->usecnt, 1, -1) == -1 ?
+			-EBUSY : 0;
+	else
+		/* lock is either WRITE or DESTROY - should be exclusive */
+		return atomic_cmpxchg(&uobj->usecnt, 0, -1) == 0 ? 0 : -EBUSY;
+}
+
+static struct ib_uobject *get_uobject_from_context(struct ib_ucontext *ucontext,
+						   const struct uverbs_uobject_type *type,
+						   uint32_t idr)
+{
+	struct uverbs_uobject_list *iter;
+	struct ib_uobject *uobj;
+
+	/* TODO: use something smarter.... hash? */
+	list_for_each_entry(iter, &ucontext->uobjects_lists, type_list)
+		if (iter->type == type)
+			list_for_each_entry(uobj, &iter->list, idr_list)
+				if (uobj->id == idr)
+					return uobj;
+
+	return NULL;
+}
+
+struct ib_uobject *uverbs_get_type_from_idr(struct uverbs_uobject_type *type,
+					    struct ib_ucontext *ucontext,
+					    int access,
+					    uint32_t idr)
+{
+	struct ib_uobject *uobj;
+	int ret;
+
+	if (access == UVERBS_IDR_ACCESS_NEW) {
+		uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
+		if (!uobj)
+			return ERR_PTR(-ENOMEM);
+
+		init_uobj(uobj, 0, ucontext, &type->lock_class);
+
+		/* lock idr */
+		ret = ib_uverbs_uobject_add(uobj, type);
+		if (ret)
+			goto free_uobj;
+
+		ret = uverbs_lock_object(uobj, access);
+		if (ret)
+			goto remove_uobj;
+	} else {
+		uobj = get_uobject_from_context(ucontext, type, idr);
+
+		if (uobj) {
+			ret = uverbs_lock_object(uobj, access);
+			if (ret)
+				return ERR_PTR(ret);
+			return uobj;
+		}
+
+		return ERR_PTR(-ENOENT);
+	}
+remove_uobj:
+	ib_uverbs_uobject_remove(uobj);
+free_uobj:
+	kfree(uobj);
+	return ERR_PTR(ret);
+}
+
+static void uverbs_unlock_object(struct ib_uobject *uobj, int access)
+{
+	if (access == UVERBS_IDR_ACCESS_READ) {
+		atomic_dec(&uobj->usecnt);
+	} else {
+		if (access == UVERBS_IDR_ACCESS_NEW)
+			ib_uverbs_uobject_enable(uobj);
+
+		if (access == UVERBS_IDR_ACCESS_WRITE ||
+		    access == UVERBS_IDR_ACCESS_NEW)
+			atomic_set(&uobj->usecnt, 0);
+
+		if (access == UVERBS_IDR_ACCESS_DESTROY)
+			ib_uverbs_uobject_remove(uobj);
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
+			/* TODO: if (!success) -> reduce refcount, otherwise
+			 * fetching from idr already increased the refcount
+			 */
+			uverbs_unlock_object(attr->obj_attr.uobject,
+					     spec->idr.access);
+		}
+	}
+}
+
 int idr_add_uobj(struct ib_uobject *uobj)
 {
 	int ret;
diff --git a/drivers/infiniband/core/uidr.h b/drivers/infiniband/core/uidr.h
index 581b394..9eb1e66 100644
--- a/drivers/infiniband/core/uidr.h
+++ b/drivers/infiniband/core/uidr.h
@@ -38,7 +38,20 @@
 #define UIDR_H
 
 #include <linux/idr.h>
+#include <rdma/uverbs_ioctl.h>
 
+struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
+					    uint16_t type);
+struct ib_uobject *uverbs_get_type_from_idr(struct uverbs_uobject_type *type,
+					    struct ib_ucontext *ucontext,
+					    int access,
+					    uint32_t idr);
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject);
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject);
+void uverbs_unlock_objects(struct uverbs_attr_array *attr_array,
+			   size_t num,
+			   const struct action_spec *chain,
+			   bool success);
 int idr_add_uobj(struct ib_uobject *uobj);
 void idr_remove_uobj(struct ib_uobject *uobj);
 struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context);
diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
index c480b3b..c3d1098 100644
--- a/drivers/infiniband/core/uobject.c
+++ b/drivers/infiniband/core/uobject.c
@@ -31,7 +31,7 @@
  */
 
 #include <rdma/ib_verbs.h>
-
+#include <rdma/uverbs_ioctl.h>
 #include "uobject.h"
 #include "uidr.h"
 
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 11bad7a..d2e964e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -42,6 +42,7 @@
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/cdev.h>
+#include <linux/rwsem.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -84,6 +85,8 @@
  * released when the CQ is destroyed.
  */
 
+long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
 struct ib_uverbs_device {
 	atomic_t				refcount;
 	int					num_comp_vectors;
@@ -122,6 +125,7 @@ struct ib_uverbs_file {
 	struct ib_uverbs_event_file	       *async_file;
 	struct list_head			list;
 	int					is_closed;
+	struct rw_semaphore			close_sem;
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
new file mode 100644
index 0000000..6160151
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -0,0 +1,279 @@
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
+#include <rdma/ib_user_ioctl.h>
+#include <rdma/uverbs_ioctl.h>
+#include "uidr.h"
+#include "uverbs.h"
+
+static int uverbs_validate_attr(struct ib_device *ibdev,
+				struct ib_ucontext *ucontext,
+				const struct ib_uverbs_attr *uattr,
+				u16 attr_id,
+				const struct uverbs_attr_chain_spec *chain_spec,
+				struct uverbs_attr *elements)
+{
+	const struct uverbs_attr_spec *spec;
+	struct uverbs_attr *e;
+
+	if (uattr->reserved)
+		return -EINVAL;
+
+	if (attr_id >= chain_spec->num_attrs)
+		return -EINVAL;
+
+	spec = &chain_spec->attrs[attr_id];
+	e = &elements[attr_id];
+
+	if (e->valid)
+		return -EINVAL;
+
+	switch (spec->type) {
+	case UVERBS_ATTR_TYPE_PTR_IN:
+	case UVERBS_ATTR_TYPE_PTR_OUT:
+		if (uattr->len != spec->len)
+			return -EINVAL;
+		e->cmd_attr.ptr = uattr->ptr_idr;
+		e->cmd_attr.len = uattr->len;
+		break;
+
+	case UVERBS_ATTR_TYPE_IDR:
+		if (uattr->len != 0 || (uattr->ptr_idr >> 32) || (!ucontext))
+			return -EINVAL;
+
+		e->obj_attr.idr = (uint32_t)uattr->ptr_idr;
+		e->obj_attr.val = spec;
+		e->obj_attr.type = uverbs_get_type(ibdev,
+						   spec->idr.idr_type);
+		if (!e->obj_attr.type)
+			return -EINVAL;
+
+		e->obj_attr.uobject = uverbs_get_type_from_idr(e->obj_attr.type,
+							       ucontext,
+							       spec->idr.access,
+							       e->obj_attr.idr);
+		if (!e->obj_attr.uobject)
+			return -EINVAL;
+
+		break;
+	};
+
+	e->valid = 1;
+	return 0;
+}
+
+static int uverbs_validate(struct ib_device *ibdev,
+			   struct ib_ucontext *ucontext,
+			   const struct ib_uverbs_attr *uattrs,
+			   size_t num_attrs,
+			   const struct action_spec *action_spec,
+			   struct uverbs_attr_array *attr_array)
+{
+	size_t i;
+	int ret;
+	int n_val = -1;
+
+	for (i = 0; i < num_attrs; i++) {
+		const struct ib_uverbs_attr *uattr = &uattrs[i];
+		__u16 attr_id = uattr->attr_id;
+		const struct uverbs_attr_chain_spec *chain_spec;
+
+		ret = action_spec->dist(&attr_id, action_spec->priv);
+		if (ret < 0)
+			return ret;
+
+		if (ret > n_val)
+			n_val = ret;
+
+		chain_spec = action_spec->validator_chains[ret];
+		ret = uverbs_validate_attr(ibdev, ucontext, uattr, attr_id,
+					   chain_spec, attr_array[ret].attrs);
+		if (ret)
+			return ret;
+
+		if (attr_array[ret].num_attrs < attr_id)
+			attr_array[ret].num_attrs = attr_id;
+	}
+
+	return n_val >= 0 ? n_val + 1 : n_val;
+}
+
+static int uverbs_handle_action(const struct ib_uverbs_attr *uattrs,
+				size_t num_attrs,
+				struct ib_device *ibdev,
+				struct ib_ucontext *ucontext,
+				const struct uverbs_action *handler,
+				struct uverbs_attr_array *attr_array)
+{
+	int ret;
+	int n_val;
+
+	n_val = uverbs_validate(ibdev, ucontext, uattrs, num_attrs,
+				&handler->chain, attr_array);
+	if (n_val <= 0)
+		return n_val;
+
+	ret = handler->handler(ibdev, ucontext, attr_array, n_val,
+			       handler->priv);
+	uverbs_unlock_objects(attr_array, n_val, &handler->chain, !ret);
+
+	return ret;
+}
+
+static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+				struct ib_uverbs_file *file,
+				struct ib_uverbs_ioctl_hdr *hdr,
+				void __user *buf)
+{
+	const struct uverbs_type_actions *type;
+	const struct uverbs_action *action;
+	const struct action_spec *action_spec;
+	long err = 0;
+	unsigned int num_specs = 0;
+	unsigned int i;
+	struct {
+		struct ib_uverbs_attr		*uattrs;
+		struct uverbs_attr_array	*uverbs_attr_array;
+	} *ctx = NULL;
+	struct uverbs_attr *curr_attr;
+	size_t ctx_size;
+
+	if (!ib_dev)
+		return -EIO;
+
+	if (ib_dev->types->num_types < hdr->object_type ||
+	    ib_dev->driver_id != hdr->driver_id)
+		return -EINVAL;
+
+	type = ib_dev->types->types[hdr->object_type];
+	if (!type || type->num_actions < hdr->action)
+		return -EOPNOTSUPP;
+
+	action = &type->actions[hdr->action];
+	if (!action)
+		return -EOPNOTSUPP;
+
+	action_spec = &action->chain;
+	for (i = 0; i < action_spec->num_chains;
+	     num_specs += action_spec->validator_chains[i]->num_attrs, i++)
+		;
+
+	ctx_size = sizeof(*ctx->uattrs) * hdr->num_attrs +
+		   sizeof(*ctx->uverbs_attr_array->attrs) * num_specs +
+		   sizeof(struct uverbs_attr_array) * action_spec->num_chains +
+		   sizeof(*ctx);
+
+	ctx = kzalloc(ctx_size, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->uverbs_attr_array = (void *)(ctx + 1);
+	ctx->uattrs = (void *)(&ctx->uverbs_attr_array + 1);
+	curr_attr = (void *)(ctx->uattrs + hdr->num_attrs);
+	for (i = 0; i < action_spec->num_chains; i++) {
+		ctx->uverbs_attr_array[i].attrs = curr_attr;
+		ctx->uverbs_attr_array[i].num_attrs =
+			action_spec->validator_chains[i]->num_attrs;
+		curr_attr += action_spec->validator_chains[i]->num_attrs;
+	}
+
+	err = copy_from_user(ctx->uattrs, hdr->attrs,
+			     sizeof(*ctx->uattrs) * hdr->num_attrs);
+	if (err) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = uverbs_handle_action(ctx->uattrs, hdr->num_attrs, ib_dev,
+				   file->ucontext, action, ctx->uverbs_attr_array);
+out:
+	kfree(ctx);
+	return err;
+}
+
+#define IB_UVERBS_MAX_CMD_SZ 4096
+
+long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_uverbs_ioctl_hdr __user *user_hdr =
+		(struct ib_uverbs_ioctl_hdr __user *)arg;
+	struct ib_uverbs_ioctl_hdr hdr;
+	struct ib_device *ib_dev;
+	int srcu_key;
+	long err;
+
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	ib_dev = srcu_dereference(file->device->ib_dev,
+				  &file->device->disassociate_srcu);
+	if (!ib_dev) {
+		err = -EIO;
+		goto out;
+	}
+
+	if (cmd == IB_USER_DIRECT_IOCTL_COMMAND) {
+		/* TODO? */
+		err = -ENOSYS;
+		goto out;
+	} else {
+		if (cmd != IB_USER_VERBS_IOCTL_COMMAND) {
+			err = -ENOIOCTLCMD;
+			goto out;
+		}
+
+		err = copy_from_user(&hdr, user_hdr, sizeof(hdr));
+
+		if (err || hdr.length > IB_UVERBS_MAX_CMD_SZ ||
+		    hdr.length <= sizeof(hdr) ||
+		    hdr.length != sizeof(hdr) + hdr.num_attrs * sizeof(struct ib_uverbs_attr)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* currently there are no flags supported */
+		if (hdr.flags) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		/* We're closing, fail all commands */
+		if (!down_read_trylock(&file->close_sem))
+			return -EIO;
+		err = ib_uverbs_cmd_verbs(ib_dev, file, &hdr,
+					  (__user void *)arg + sizeof(hdr));
+		up_read(&file->close_sem);
+	}
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+
+	return err;
+}
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
new file mode 100644
index 0000000..d38b7ec
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -0,0 +1,57 @@
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
+#include <rdma/uverbs_ioctl_cmd.h>
+#include <linux/bug.h>
+
+#define IB_UVERBS_VENDOR_FLAG	0x8000
+
+int ib_uverbs_std_dist(__u16 *attr_id, void *priv)
+{
+	if (*attr_id & IB_UVERBS_VENDOR_FLAG) {
+		*attr_id &= ~IB_UVERBS_VENDOR_FLAG;
+		return 1;
+	}
+	return 0;
+}
+
+int uverbs_action_std_handle(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *ctx, size_t num,
+			     void *_priv)
+{
+	struct uverbs_action_std_handler *priv = _priv;
+
+	WARN_ON(num != 2);
+
+	return priv->handler(ib_dev, ucontext, &ctx[0], &ctx[1], priv->priv);
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5dce312..ab20647 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 
 #include <rdma/ib.h>
+#include <rdma/ib_ioctl.h>
 
 #include "uverbs.h"
 #include "uidr.h"
@@ -212,6 +213,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 {
 	struct ib_uobject *uobj, *tmp;
 
+	down_write(&file->close_sem);
 	context->closing = 1;
 
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
@@ -307,6 +309,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	}
 
 	put_pid(context->tgid);
+	up_write(&file->close_sem);
 
 	return context->device->dealloc_ucontext(context);
 }
@@ -916,6 +919,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 		goto err;
 	}
 
+	init_rwsem(&file->close_sem);
 	file->device	 = dev;
 	file->ucontext	 = NULL;
 	file->async_file = NULL;
@@ -974,6 +978,7 @@ static const struct file_operations uverbs_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -983,6 +988,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static struct ib_client uverbs_client = {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c18155f..e402473 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1346,6 +1346,8 @@ struct ib_ucontext {
 #endif
 };
 
+struct uverbs_object_list;
+
 struct ib_uobject {
 	u64			user_handle;	/* handle given to us by userspace */
 	struct ib_ucontext     *context;	/* associated user context */
@@ -1353,6 +1355,7 @@ struct ib_uobject {
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
+	atomic_t		usecnt;
 	struct rw_semaphore	mutex;		/* protects .live */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
@@ -1967,6 +1970,7 @@ struct ib_device {
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	struct list_head type_list;
 
+	u16				driver_id;
 	const struct uverbs_types	*types;
 };
 
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
new file mode 100644
index 0000000..625bd6e
--- /dev/null
+++ b/include/rdma/uverbs_ioctl.h
@@ -0,0 +1,202 @@
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
+		u16			idr_type;
+		enum uverbs_idr_access	access;
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
+
+struct uverbs_action {
+	struct action_spec chain;
+	void *priv;
+	int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
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
+#define UVERBS_ATTR(_id, _len, _type)					\
+	[_id] = {.len = _len, .type = _type}
+#define UVERBS_ATTR_PTR_IN(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_IN)
+#define UVERBS_ATTR_PTR_OUT(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_OUT)
+#define UVERBS_ATTR_IDR_IN(_id, _idr_type, _access)			\
+	[_id] = {.type = UVERBS_ATTR_TYPE_IDR,				\
+		 .idr = {.idr_type = _idr_type,				\
+			 .access = _access} }
+#define UVERBS_ATTR_CHAIN_SPEC_SZ(...)					\
+	(sizeof((const struct uverbs_attr_spec[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_attr_spec))
+#define UVERBS_ATTR_CHAIN_SPEC(...)					\
+	(const struct uverbs_attr_chain_spec)				\
+	{.attrs = (struct uverbs_attr_spec[]){__VA_ARGS__},		\
+	 .num_attrs = UVERBS_ATTR_CHAIN_SPEC_SZ(__VA_ARGS__)}
+#define DECLARE_UVERBS_ATTR_CHAIN_SPEC(name, ...)			\
+	const struct uverbs_attr_chain_spec name =			\
+		UVERBS_ATTR_CHAIN_SPEC(__VA_ARGS__)
+#define UVERBS_ATTR_ACTION_SPEC_SZ(...)					  \
+	(sizeof((const struct uverbs_attr_chain_spec *[]){__VA_ARGS__}) / \
+				 sizeof(const struct uverbs_attr_chain_spec *))
+#define UVERBS_ATTR_ACTION_SPEC(_distfn, _priv, ...)			\
+	{.dist = _distfn,						\
+	 .priv = _priv,							\
+	 .num_chains =	UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),	\
+	 .validator_chains = (const struct uverbs_attr_chain_spec *[]){__VA_ARGS__} }
+#define UVERBS_STD_ACTION_SPEC(...)						\
+	UVERBS_ATTR_ACTION_SPEC(ib_uverbs_std_dist,				\
+				(void *)UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),\
+				__VA_ARGS__)
+#define UVERBS_STD_ACTION(_handler, _priv, ...)				\
+	{								\
+		.priv = &(struct uverbs_action_std_handler)		\
+			{.handler = _handler,				\
+			 .priv = _priv},				\
+		.handler = uverbs_action_std_handle,			\
+		.chain = UVERBS_STD_ACTION_SPEC(__VA_ARGS__)}
+#define UVERBS_ACTIONS_SZ(...)					\
+	(sizeof((const struct uverbs_action []){__VA_ARGS__}) /		\
+	 sizeof(const struct uverbs_action))
+#define UVERBS_ACTION(action_idx, _handler, _priv,  ...)		\
+	[action_idx] = UVERBS_STD_ACTION(_handler, _priv, __VA_ARGS__)
+#define UVERBS_ACTIONS(...)					\
+	((const struct uverbs_type_actions)				\
+	  {.num_actions = UVERBS_ACTIONS_SZ(__VA_ARGS__),		\
+	   .actions = (const struct uverbs_action[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_TYPE(name, ...)					\
+	const struct uverbs_type_actions name = UVERBS_ACTIONS(__VA_ARGS__)
+#define UVERBS_TYPES_SZ(...)						\
+	(sizeof((const struct uverbs_type_actions *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type_actions *))
+#define UVERBS_TYPE_ACTIONS(type_idx, ...)				\
+	[type_idx] = &UVERBS_ACTIONS(__VA_ARGS__)
+#define UVERBS_TYPE(type_idx, type_ptr)					\
+	[type_idx] = ((const struct uverbs_type_actions * const)&type_ptr)
+#define UVERBS_TYPES(...)						\
+	{.num_types = UVERBS_TYPES_SZ(__VA_ARGS__),			\
+	 .types = (const struct uverbs_type_actions *[]){__VA_ARGS__} }
+
+/* =================================================
+ *              Parsing infrastructure
+ * =================================================
+ */
+
+struct uverbs_ptr_attr {
+	__u64	ptr;
+	__u16	len;
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
+#endif
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
new file mode 100644
index 0000000..07cf6fa
--- /dev/null
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -0,0 +1,53 @@
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
+#ifndef _UVERBS_IOCTL_CMD_
+#define _UVERBS_IOCTL_CMD_
+
+#include <rdma/uverbs_ioctl.h>
+
+/* common validators */
+
+int uverbs_action_std_handle(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *ctx, size_t num,
+			     void *_priv);
+
+struct uverbs_action_std_handler {
+	int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
+		       struct uverbs_attr_array *common,
+		       struct uverbs_attr_array *vendor,
+		       void *priv);
+	void *priv;
+};
+#endif
+
diff --git a/include/uapi/rdma/ib_user_ioctl.h b/include/uapi/rdma/ib_user_ioctl.h
index d1928dea..bd25a86 100644
--- a/include/uapi/rdma/ib_user_ioctl.h
+++ b/include/uapi/rdma/ib_user_ioctl.h
@@ -38,6 +38,29 @@
 
 #define IB_IOCTL_MAGIC		0x1b
 
+#define IB_USER_VERBS_IOCTL_COMMAND \
+	_IOWR(IB_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
+
+#define IB_USER_DIRECT_IOCTL_COMMAND \
+	_IOWR(IB_IOCTL_MAGIC, 2, struct ib_uverbs_ioctl_hdr)
+
+struct ib_uverbs_attr {
+	__u16 attr_id;		/* command specific type attribute */
+	__u16 len;		/* NA for idr */
+	__u32 reserved;
+	 __u64 ptr_idr;		/* ptr typeo command/idr handle */
+};
+
+struct ib_uverbs_ioctl_hdr {
+	__u16 length;
+	__u16 flags;
+	__u16 object_type;
+	__u16 driver_id;
+	__u16 action;
+	__u16 num_attrs;
+	struct ib_uverbs_attr  attrs[0];
+};
+
 /* Legacy part
  * !!!! NOTE: It uses the same command index as VERBS
  */
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
