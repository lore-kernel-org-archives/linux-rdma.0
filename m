From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 07/14] IB/core: Add new ioctl interface
Date: Sun, 11 Dec 2016 14:58:01 +0200
Message-ID: <1481461088-56355-8-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In this proposed ioctl interface, processing the command starts from
properties of the command and fetching the appropriate user objects
before calling the handler.

Parsing and validation is done according to a specifier declared by
the driver's code. In the driver, all supported types are declared.
These types are separated to different type groups, each could be
declared in a different place (for example, common types and driver
specific types).

For each type we list all supported actions. Similarly to types,
actions are separated to actions groups too. Each group is declared
separately. This could be used in order to add actions to an existing
type.

Each action has a specifies a handler, which could be either a
standard command or a driver specific command.
Along with the handler, a group of attributes is specified as well.
This group lists all supported attributes and is used for automatic
fetching and validation of the command, response and its related
objects.

When a group of elements is used, the high bits of the elements ids
are used in order to calculate the group index. Then, these high bits
are masked out in order to have a zero based namespace for every
group. This is mandatory for compact representation and O(1) array
access.

A group of attributes is actually an array of attributes. Each
attribute has a type (PTR_IN, PTR_OUT, IDR, FD and FLAG) and a length.
Attributes could be validated through some attributes, like:
(*) Minimum size / Exact size
(*) Fops for FD
(*) Object type for IDR
(*) Mask for FLAG

If an IDR/fd attribute is specified, the kernel also states the object
type and the required access (NEW, WRITE, READ or DESTROY).
All uobject/fd management is done automatically by the infrastructure,
meaning - the infrastructure will fail concurrent commands that at
least one of them requires concurrent access (WRITE/DESTROY),
synchronize actions with device removals (dissociate context events)
and take care of reference counting (increase/decrease) for concurrent
actions invocation. The reference counts on the actual kernel objects
shall be handled by the handlers.

 types
+--------+
|        |
|        |   actions                                                                +--------+
|        |   group      action      action_spec                           +-----+   |len     |
+--------+  +------+[d]+-------+   +----------------+[d]+------------+    |attr1+-> |type    |
| type   +> |action+-> | spec  +-> +  attr_groups   +-> |common_chain+--> +-----+   |idr_type|
+--------+  +------+   |handler|   |                |   +------------+    |attr2|   |access  |
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

[d] = distribute ids to groups using the high order bits

The right types table is also chosen by using the high bits from
uverbs_types_groups.

Once validation and object fetching (or creation) completed, we call
the handler:
int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
               struct uverbs_attr_array *ctx, size_t num);

Where ctx is an array of uverbs_attr_array. Each element in this array
is an array of attributes which corresponds to one group of attributes.
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
                                |  vendor
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

Ctx array's indices corresponds to the attributes groups order. The indices
of core and driver corresponds to the attributes name spaces of each
group. Thus, we could think of the following as one object:
1. Set of attribute specification (with their attribute IDs)
2. Attribute group which owns (1) specifications
3. A function which could handle this attributes which the handler
   could call
4. The allocation descriptor of this type uverbs_type_alloc_action.

Upon success of a handler invocation, reference count of uobjects and
use count will be a updated automatically according to the
specification.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile       |   2 +-
 drivers/infiniband/core/device.c       |   3 +
 drivers/infiniband/core/rdma_core.c    |  59 +++++-
 drivers/infiniband/core/rdma_core.h    |   5 +
 drivers/infiniband/core/uverbs.h       |   3 +
 drivers/infiniband/core/uverbs_ioctl.c | 353 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c  |   3 +
 include/rdma/ib_verbs.h                |   3 +-
 include/uapi/rdma/rdma_user_ioctl.h    |  28 +++
 9 files changed, 449 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 7676592..121373c 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				rdma_core.o uverbs_ioctl_cmd.o
+				rdma_core.o uverbs_ioctl_cmd.o uverbs_ioctl.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 43994b1..c0c6365 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -245,6 +245,9 @@ struct ib_device *ib_alloc_device(size_t size)
 	INIT_LIST_HEAD(&device->port_list);
 	INIT_LIST_HEAD(&device->type_list);
 
+	/* TODO: don't forget to initialize device->driver_id, so verbs handshake between
+	 * user space<->kernel space will work for other values than driver_id == 0.
+	 */
 	return device;
 }
 EXPORT_SYMBOL(ib_alloc_device);
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 01221c0..1e08ebf 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -37,6 +37,51 @@
 #include "rdma_core.h"
 #include <rdma/uverbs_ioctl.h>
 
+int uverbs_group_idx(u16 *id, unsigned int ngroups)
+{
+	int ret = (*id & UVERBS_ID_RESERVED_MASK) >> UVERBS_ID_RESERVED_SHIFT;
+
+	if (ret >= ngroups)
+		return -EINVAL;
+
+	*id &= ~UVERBS_ID_RESERVED_MASK;
+	return ret;
+}
+
+const struct uverbs_type *uverbs_get_type(const struct ib_device *ibdev,
+					  uint16_t type)
+{
+	const struct uverbs_root *groups = ibdev->specs_root;
+	const struct uverbs_type_group *types;
+	int ret = uverbs_group_idx(&type, groups->num_groups);
+
+	if (ret < 0)
+		return NULL;
+
+	types = groups->type_groups[ret];
+
+	if (type >= types->num_types)
+		return NULL;
+
+	return types->types[type];
+}
+
+const struct uverbs_action *uverbs_get_action(const struct uverbs_type *type,
+					      uint16_t action)
+{
+	const struct uverbs_action_group *action_group;
+	int ret = uverbs_group_idx(&action, type->num_groups);
+
+	if (ret < 0)
+		return NULL;
+
+	action_group = type->action_groups[ret];
+	if (action >= action_group->num_actions)
+		return NULL;
+
+	return action_group->actions[action];
+}
+
 static int uverbs_lock_object(struct ib_uobject *uobj,
 			      enum uverbs_idr_access access)
 {
@@ -357,7 +402,6 @@ static void ib_uverbs_remove_fd(struct ib_uobject *uobject)
 	 */
 	if (uobject->context) {
 		list_del(&uobject->list);
-		uobject->type->free_fn(uobject->type, uobject);
 		kref_put(&uobject->context->ufile->ref, ib_uverbs_release_file);
 		uobject->context = NULL;
 	}
@@ -368,11 +412,7 @@ void ib_uverbs_close_fd(struct file *f)
 	struct ib_uobject *uobject = f->private_data - sizeof(struct ib_uobject);
 
 	mutex_lock(&uobject->uobjects_lock->lock);
-	if (uobject->context) {
-		list_del(&uobject->list);
-		kref_put(&uobject->context->ufile->ref, ib_uverbs_release_file);
-		uobject->context = NULL;
-	}
+	ib_uverbs_remove_fd(uobject);
 	mutex_unlock(&uobject->uobjects_lock->lock);
 	kref_put(&uobject->uobjects_lock->ref, release_uobjects_list_lock);
 }
@@ -454,10 +494,13 @@ void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext *ucontext,
 		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
 					 list)
 			if (obj->type->order == i) {
-				if (obj->type->type == UVERBS_ATTR_TYPE_IDR)
+				if (obj->type->type == UVERBS_ATTR_TYPE_IDR) {
+					obj->type->free_fn(obj->type, obj);
 					ib_uverbs_uobject_remove(obj, false);
-				else
+				} else {
+					obj->type->free_fn(obj->type, obj);
 					ib_uverbs_remove_fd(obj);
+				}
 			}
 		mutex_unlock(&ucontext->uobjects_lock->lock);
 	}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 9b91c1c..78a5339 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -42,6 +42,11 @@
 #include <rdma/ib_verbs.h>
 #include <linux/mutex.h>
 
+int uverbs_group_idx(u16 *id, unsigned int ngroups);
+const struct uverbs_type *uverbs_get_type(const struct ib_device *ibdev,
+					  uint16_t type);
+const struct uverbs_action *uverbs_get_action(const struct uverbs_type *type,
+					      uint16_t action);
 struct ib_uobject *uverbs_get_type_from_idr(const struct uverbs_type_alloc_action *type,
 					    struct ib_ucontext *ucontext,
 					    enum uverbs_idr_access access,
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 64f8658..d3ad81c 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -41,6 +41,7 @@
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/cdev.h>
+#include <linux/rwsem.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -83,6 +84,8 @@
  * released when the CQ is destroyed.
  */
 
+long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
 struct ib_uverbs_device {
 	atomic_t				refcount;
 	int					num_comp_vectors;
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
new file mode 100644
index 0000000..406b735
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -0,0 +1,353 @@
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
+#include <rdma/rdma_user_ioctl.h>
+#include <rdma/uverbs_ioctl.h>
+#include "rdma_core.h"
+#include "uverbs.h"
+
+static int uverbs_validate_attr(struct ib_device *ibdev,
+				struct ib_ucontext *ucontext,
+				const struct ib_uverbs_attr *uattr,
+				u16 attr_id,
+				const struct uverbs_attr_spec_group *attr_spec_group,
+				struct uverbs_attr_array *attr_array,
+				struct ib_uverbs_attr __user *uattr_ptr)
+{
+	const struct uverbs_attr_spec *spec;
+	struct uverbs_attr *e;
+	const struct uverbs_type *type;
+	struct uverbs_obj_attr *o_attr;
+	struct uverbs_attr *elements = attr_array->attrs;
+
+	if (uattr->reserved)
+		return -EINVAL;
+
+	if (attr_id >= attr_spec_group->num_attrs) {
+		if (uattr->flags & UVERBS_ATTR_F_MANDATORY)
+			return -EINVAL;
+		else
+			return 0;
+	}
+
+	spec = &attr_spec_group->attrs[attr_id];
+	e = &elements[attr_id];
+
+	switch (spec->type) {
+	case UVERBS_ATTR_TYPE_PTR_IN:
+	case UVERBS_ATTR_TYPE_PTR_OUT:
+		if (uattr->len < spec->len ||
+		    (!(spec->flags & UVERBS_ATTR_SPEC_F_MIN_SZ) &&
+		     uattr->len > spec->len))
+			return -EINVAL;
+
+		e->cmd_attr.ptr = (void * __user)uattr->ptr_idr;
+		e->cmd_attr.len = uattr->len;
+		break;
+
+	case UVERBS_ATTR_TYPE_FLAG:
+		e->flag_attr.flags = uattr->ptr_idr;
+		if (uattr->flags & UVERBS_ATTR_F_MANDATORY &&
+		    e->flag_attr.flags & ~spec->flag.mask)
+			return -EINVAL;
+		break;
+
+	case UVERBS_ATTR_TYPE_IDR:
+	case UVERBS_ATTR_TYPE_FD:
+		if (uattr->len != 0 || (uattr->ptr_idr >> 32) || (!ucontext))
+			return -EINVAL;
+
+		o_attr = &e->obj_attr;
+		type = uverbs_get_type(ibdev, spec->obj.obj_type);
+		if (!type)
+			return -EINVAL;
+		o_attr->type = type->alloc;
+		o_attr->uattr = uattr_ptr;
+
+		if (spec->type == UVERBS_ATTR_TYPE_IDR) {
+			o_attr->uobj.idr = (uint32_t)uattr->ptr_idr;
+			o_attr->uobject = uverbs_get_type_from_idr(o_attr->type,
+								   ucontext,
+								   spec->obj.access,
+								   o_attr->uobj.idr);
+		} else {
+			o_attr->fd.fd = (int)uattr->ptr_idr;
+			o_attr->uobject = uverbs_get_type_from_fd(o_attr->type,
+								  ucontext,
+								  spec->obj.access,
+								  o_attr->fd.fd);
+		}
+
+		if (IS_ERR(o_attr->uobject))
+			return -EINVAL;
+
+		if (spec->obj.access == UVERBS_IDR_ACCESS_NEW) {
+			u64 idr = o_attr->uobject->id;
+
+			if (put_user(idr, &o_attr->uattr->ptr_idr)) {
+				uverbs_rollback_object(o_attr->uobject,
+						       UVERBS_IDR_ACCESS_NEW);
+				return -EFAULT;
+			}
+		}
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	};
+
+	set_bit(attr_id, attr_array->valid_bitmap);
+	return 0;
+}
+
+static int uverbs_validate(struct ib_device *ibdev,
+			   struct ib_ucontext *ucontext,
+			   const struct ib_uverbs_attr *uattrs,
+			   size_t num_attrs,
+			   const struct uverbs_action *action,
+			   struct uverbs_attr_array *attr_array,
+			   struct ib_uverbs_attr __user *uattr_ptr)
+{
+	size_t i;
+	int ret;
+	int n_val = 0;
+
+	for (i = 0; i < num_attrs; i++) {
+		const struct ib_uverbs_attr *uattr = &uattrs[i];
+		u16 attr_id = uattr->attr_id;
+		const struct uverbs_attr_spec_group *attr_spec_group;
+
+		ret = uverbs_group_idx(&attr_id, action->num_groups);
+		if (ret < 0) {
+			if (uattr->flags & UVERBS_ATTR_F_MANDATORY)
+				return ret;
+
+			ret = 0;
+			continue;
+		}
+
+		if (ret >= n_val)
+			n_val = ret + 1;
+
+		attr_spec_group = action->attr_groups[ret];
+		ret = uverbs_validate_attr(ibdev, ucontext, uattr, attr_id,
+					   attr_spec_group, &attr_array[ret],
+					   uattr_ptr++);
+		if (ret) {
+			uverbs_commit_objects(attr_array, n_val,
+					      action, false);
+			return ret;
+		}
+	}
+
+	return ret ? ret : n_val;
+}
+
+static int uverbs_handle_action(struct ib_uverbs_attr __user *uattr_ptr,
+				const struct ib_uverbs_attr *uattrs,
+				size_t num_attrs,
+				struct ib_device *ibdev,
+				struct ib_uverbs_file *ufile,
+				const struct uverbs_action *handler,
+				struct uverbs_attr_array *attr_array)
+{
+	int ret;
+	int n_val;
+	unsigned int i;
+
+	n_val = uverbs_validate(ibdev, ufile->ucontext, uattrs, num_attrs,
+				handler, attr_array, uattr_ptr);
+	if (n_val <= 0)
+		return n_val;
+
+	for (i = 0; i < n_val; i++) {
+		const struct uverbs_attr_spec_group *attr_spec_group =
+			handler->attr_groups[i];
+
+		if (!bitmap_subset(attr_spec_group->mandatory_attrs_bitmask,
+				   attr_array[i].valid_bitmap,
+				   attr_spec_group->num_attrs)) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
+	}
+
+	ret = handler->handler(ibdev, ufile, attr_array, n_val);
+cleanup:
+	uverbs_commit_objects(attr_array, n_val, handler, !ret);
+
+	return ret;
+}
+
+#define UVERBS_OPTIMIZE_USING_STACK
+#ifdef UVERBS_OPTIMIZE_USING_STACK
+#define UVERBS_MAX_STACK_USAGE		512
+#endif
+static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+				struct ib_uverbs_file *file,
+				struct ib_uverbs_ioctl_hdr *hdr,
+				void __user *buf)
+{
+	const struct uverbs_type *type;
+	const struct uverbs_action *action;
+	long err = 0;
+	unsigned int i;
+	struct {
+		struct ib_uverbs_attr		*uattrs;
+		struct uverbs_attr_array	*uverbs_attr_array;
+	} *ctx = NULL;
+	struct uverbs_attr *curr_attr;
+	unsigned long *curr_bitmap;
+	size_t ctx_size;
+#ifdef UVERBS_OPTIMIZE_USING_STACK
+	uintptr_t data[UVERBS_MAX_STACK_USAGE / sizeof(uintptr_t)];
+#endif
+
+	if (ib_dev->driver_id != hdr->driver_id)
+		return -EINVAL;
+
+	type = uverbs_get_type(ib_dev, hdr->object_type);
+	if (!type)
+		return -EOPNOTSUPP;
+
+	action = uverbs_get_action(type, hdr->action);
+	if (!action)
+		return -EOPNOTSUPP;
+
+	if ((action->flags & UVERBS_ACTION_FLAG_CREATE_ROOT) ^ !file->ucontext)
+		return -EINVAL;
+
+	ctx_size = sizeof(*ctx->uattrs) * hdr->num_attrs +
+		   sizeof(*ctx->uverbs_attr_array->attrs) * action->num_child_attrs +
+		   sizeof(struct uverbs_attr_array) * action->num_groups +
+		   sizeof(*ctx->uverbs_attr_array->valid_bitmap) *
+			(action->num_child_attrs / BITS_PER_LONG +
+			 action->num_groups) +
+		   sizeof(*ctx);
+
+#ifdef UVERBS_OPTIMIZE_USING_STACK
+	if (ctx_size <= UVERBS_MAX_STACK_USAGE) {
+		memset(data, 0, ctx_size);
+		ctx = (void *)data;
+	}
+	if (!ctx)
+#endif
+	ctx = kzalloc(ctx_size, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->uverbs_attr_array = (void *)ctx + sizeof(*ctx);
+	ctx->uattrs = (void *)(ctx->uverbs_attr_array +
+			       action->num_groups);
+	curr_attr = (void *)(ctx->uattrs + hdr->num_attrs);
+	curr_bitmap = (void *)(curr_attr + action->num_child_attrs);
+
+	for (i = 0; i < action->num_groups; i++) {
+		unsigned int curr_num_attrs = action->attr_groups[i]->num_attrs;
+
+		ctx->uverbs_attr_array[i].attrs = curr_attr;
+		curr_attr += curr_num_attrs;
+		ctx->uverbs_attr_array[i].num_attrs = curr_num_attrs;
+		ctx->uverbs_attr_array[i].valid_bitmap = curr_bitmap;
+		curr_bitmap += BITS_TO_LONGS(curr_num_attrs);
+	}
+
+	err = copy_from_user(ctx->uattrs, buf,
+			     sizeof(*ctx->uattrs) * hdr->num_attrs);
+	if (err) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = uverbs_handle_action(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
+				   file, action, ctx->uverbs_attr_array);
+out:
+#ifdef UVERBS_OPTIMIZE_USING_STACK
+	if (ctx_size > UVERBS_MAX_STACK_USAGE)
+#endif
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
+	if (cmd == RDMA_DIRECT_IOCTL) {
+		/* TODO? */
+		err = -ENOSYS;
+		goto out;
+	} else {
+		if (cmd != RDMA_VERBS_IOCTL) {
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
+		err = ib_uverbs_cmd_verbs(ib_dev, file, &hdr,
+					  (__user void *)arg + sizeof(hdr));
+	}
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+
+	return err;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d3dacdd..273b48f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 
 #include <rdma/ib.h>
+#include <rdma/rdma_user_ioctl.h>
 
 #include "uverbs.h"
 #include "rdma_core.h"
@@ -906,6 +907,7 @@ static const struct file_operations uverbs_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -915,6 +917,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static struct ib_client uverbs_client = {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f8eeca4..d751404 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2102,7 +2102,8 @@ struct ib_device {
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
 	struct list_head type_list;
 
-	struct uverbs_root                      *specs_root;
+	u16					driver_id;
+	struct uverbs_root			*specs_root;
 };
 
 struct ib_client {
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 9388125..3e2f59a 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -43,6 +43,34 @@
 /* Legacy name, for user space application which already use it */
 #define IB_IOCTL_MAGIC		RDMA_IOCTL_MAGIC
 
+#define RDMA_VERBS_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
+
+#define RDMA_DIRECT_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 2, struct ib_uverbs_ioctl_hdr)
+
+enum ib_uverbs_attr_flags {
+	UVERBS_ATTR_F_MANDATORY = 1U << 0,
+};
+
+struct ib_uverbs_attr {
+	__u16 attr_id;		/* command specific type attribute */
+	__u16 len;		/* NA for idr */
+	__u16 flags;		/* combination of uverbs_attr_flags */
+	__u16 reserved;
+	__u64 ptr_idr;		/* ptr typeo command/idr handle */
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
 /*
  * General blocks assignments
  * It is closed on purpose do not expose it it user space
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
