From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Wed,  7 Jun 2017 15:22:42 +0300
Message-ID: <1496838172-39671-4-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In this ioctl interface, processing the command starts from
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

Each action has a specific handler, which could be either a common
handler or a driver specific handler.
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
attribute has a type (PTR_IN, PTR_OUT, IDR and FD) and a length.
Attributes could be validated through some attributes, like:
(*) Minimum size / Exact size
(*) Fops for FD
(*) Object type for IDR

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
the ids. Currently we have either common or driver specific groups.

Once validation and object fetching (or creation) completed, we call
the handler:
int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
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
4. The allocation descriptor of this type uverbs_obj_type.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile       |   2 +-
 drivers/infiniband/core/rdma_core.c    |  45 +++++
 drivers/infiniband/core/rdma_core.h    |   5 +
 drivers/infiniband/core/uverbs_ioctl.c | 360 +++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h                |   2 +
 include/rdma/uverbs_ioctl.h            | 100 ++++++++-
 include/uapi/rdma/rdma_user_ioctl.h    |  24 +++
 7 files changed, 528 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 6ebd9ad..e18f2f8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -30,4 +30,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				rdma_core.o uverbs_std_types.o
+				rdma_core.o uverbs_std_types.o uverbs_ioctl.o
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 3d3cf07..d16a519 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -40,6 +40,51 @@
 #include "core_priv.h"
 #include "rdma_core.h"
 
+int uverbs_group_idx(u16 *id, unsigned int ngroups)
+{
+	int ret = (*id & UVERBS_ID_GROUP_MASK) >> UVERBS_ID_GROUP_SHIFT;
+
+	if (ret >= ngroups)
+		return -EINVAL;
+
+	*id &= ~UVERBS_ID_GROUP_MASK;
+	return ret;
+}
+
+const struct uverbs_type *uverbs_get_type(const struct ib_device *ibdev,
+					  uint16_t type)
+{
+	const struct uverbs_spec_root *groups = ibdev->specs_root;
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
 void uverbs_uobject_get(struct ib_uobject *uobject)
 {
 	kref_get(&uobject->ref);
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 5cc00eb..1014a8a 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -43,6 +43,11 @@
 #include <rdma/ib_verbs.h>
 #include <linux/mutex.h>
 
+int uverbs_group_idx(u16 *id, unsigned int ngroups);
+const struct uverbs_type *uverbs_get_type(const struct ib_device *ibdev,
+					  uint16_t type);
+const struct uverbs_action *uverbs_get_action(const struct uverbs_type *type,
+					      uint16_t action);
 /*
  * These functions initialize the context and cleanups its uobjects.
  * The context has a list of objects which is protected by a mutex
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
new file mode 100644
index 0000000..a375a7b
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -0,0 +1,360 @@
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
+#include <rdma/rdma_user_ioctl.h>
+#include <rdma/uverbs_ioctl.h>
+#include "rdma_core.h"
+#include "uverbs.h"
+
+static int uverbs_process_attr(struct ib_device *ibdev,
+			       struct ib_ucontext *ucontext,
+			       const struct ib_uverbs_attr *uattr,
+			       u16 attr_id,
+			       const struct uverbs_attr_spec_group *attr_spec_group,
+			       struct uverbs_attr_array *attr_array,
+			       struct ib_uverbs_attr __user *uattr_ptr)
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
+		e->ptr_attr.ptr = (__force void __user *)uattr->data;
+		e->ptr_attr.len = uattr->len;
+		break;
+
+	case UVERBS_ATTR_TYPE_IDR:
+		if (uattr->data >> 32)
+			return -EINVAL;
+	/* fall through */
+	case UVERBS_ATTR_TYPE_FD:
+		if (uattr->len != 0 || !ucontext || uattr->data > INT_MAX)
+			return -EINVAL;
+
+		o_attr = &e->obj_attr;
+		type = uverbs_get_type(ibdev, spec->obj.obj_type);
+		if (!type)
+			return -EINVAL;
+		o_attr->type = type->type_attrs;
+		o_attr->uattr = uattr_ptr;
+
+		o_attr->id = (int)uattr->data;
+		o_attr->uobject = uverbs_get_uobject_from_context(
+					o_attr->type,
+					ucontext,
+					spec->obj.access,
+					o_attr->id);
+
+		if (IS_ERR(o_attr->uobject))
+			return PTR_ERR(o_attr->uobject);
+
+		if (spec->obj.access == UVERBS_ACCESS_NEW) {
+			u64 id = o_attr->uobject->id;
+
+			/* Copy the allocated id to the user-space */
+			if (put_user(id, &o_attr->uattr->data)) {
+				uverbs_finalize_object(o_attr->uobject,
+						       UVERBS_ACCESS_NEW,
+						       false);
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
+static int uverbs_uattrs_process(struct ib_device *ibdev,
+				 struct ib_ucontext *ucontext,
+				 const struct ib_uverbs_attr *uattrs,
+				 size_t num_uattrs,
+				 const struct uverbs_action *action,
+				 struct uverbs_attr_array *attr_array,
+				 struct ib_uverbs_attr __user *uattr_ptr)
+{
+	size_t i;
+	int ret = 0;
+	int num_given_groups = 0;
+
+	for (i = 0; i < num_uattrs; i++) {
+		const struct ib_uverbs_attr *uattr = &uattrs[i];
+		u16 attr_id = uattr->attr_id;
+		const struct uverbs_attr_spec_group *attr_spec_group;
+
+		ret = uverbs_group_idx(&attr_id, action->num_groups);
+		if (ret < 0) {
+			if (uattr->flags & UVERBS_ATTR_F_MANDATORY) {
+				uverbs_finalize_objects(attr_array,
+							action->attr_groups,
+							num_given_groups,
+							false);
+				return ret;
+			}
+			continue;
+		}
+
+		/*
+		 * ret is the found group, so increase num_give_groups if
+		 * necessary.
+		 */
+		if (ret >= num_given_groups)
+			num_given_groups = ret + 1;
+
+		attr_spec_group = action->attr_groups[ret];
+		ret = uverbs_process_attr(ibdev, ucontext, uattr, attr_id,
+					  attr_spec_group, &attr_array[ret],
+					  uattr_ptr++);
+		if (ret) {
+			uverbs_finalize_objects(attr_array,
+						action->attr_groups,
+						num_given_groups,
+						false);
+			return ret;
+		}
+	}
+
+	return num_given_groups;
+}
+
+static int uverbs_validate_kernel_mandatory(const struct uverbs_action *action,
+					    struct uverbs_attr_array *attr_array,
+					    unsigned int num_given_groups)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_given_groups; i++) {
+		const struct uverbs_attr_spec_group *attr_spec_group =
+			action->attr_groups[i];
+
+		if (!bitmap_subset(attr_spec_group->mandatory_attrs_bitmask,
+				   attr_array[i].valid_bitmap,
+				   attr_spec_group->num_attrs))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int uverbs_handle_action(struct ib_uverbs_attr __user *uattr_ptr,
+				const struct ib_uverbs_attr *uattrs,
+				size_t num_uattrs,
+				struct ib_device *ibdev,
+				struct ib_uverbs_file *ufile,
+				const struct uverbs_action *action,
+				struct uverbs_attr_array *attr_array)
+{
+	int ret;
+	int finalize_ret;
+	int num_given_groups;
+
+	num_given_groups = uverbs_uattrs_process(ibdev, ufile->ucontext, uattrs,
+						 num_uattrs, action, attr_array,
+						 uattr_ptr);
+	if (num_given_groups <= 0)
+		return -EINVAL;
+
+	ret = uverbs_validate_kernel_mandatory(action, attr_array,
+					       num_given_groups);
+	if (ret)
+		goto cleanup;
+
+	ret = action->handler(ibdev, ufile, attr_array, num_given_groups);
+cleanup:
+	finalize_ret = uverbs_finalize_objects(attr_array, action->attr_groups,
+					       num_given_groups, !ret);
+
+	return ret ? ret : finalize_ret;
+}
+
+#define UVERBS_OPTIMIZE_USING_STACK_SZ  256
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
+#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
+	uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
+#endif
+
+	if (hdr->reserved)
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
+	ctx_size = sizeof(*ctx) +
+		   sizeof(struct uverbs_attr_array) * action->num_groups +
+		   sizeof(*ctx->uattrs) * hdr->num_attrs +
+		   sizeof(*ctx->uverbs_attr_array->attrs) *
+		   action->num_child_attrs +
+		   sizeof(*ctx->uverbs_attr_array->valid_bitmap) *
+			(action->num_child_attrs / BITS_PER_LONG +
+			 action->num_groups);
+
+#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
+	if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
+		ctx = (void *)data;
+
+	if (!ctx)
+#endif
+	ctx = kmalloc(ctx_size, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->uverbs_attr_array = (void *)ctx + sizeof(*ctx);
+	ctx->uattrs = (void *)(ctx->uverbs_attr_array +
+			       action->num_groups);
+	curr_attr = (void *)(ctx->uattrs + hdr->num_attrs);
+	curr_bitmap = (void *)(curr_attr + action->num_child_attrs);
+
+	/*
+	 * We just fill the pointers and num_attrs here. The data itself will be
+	 * filled at a later stage (uverbs_process_attr)
+	 */
+	for (i = 0; i < action->num_groups; i++) {
+		unsigned int curr_num_attrs = action->attr_groups[i]->num_attrs;
+
+		ctx->uverbs_attr_array[i].attrs = curr_attr;
+		curr_attr += curr_num_attrs;
+		ctx->uverbs_attr_array[i].num_attrs = curr_num_attrs;
+		ctx->uverbs_attr_array[i].valid_bitmap = curr_bitmap;
+		bitmap_zero(curr_bitmap, curr_num_attrs);
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
+#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
+	if (ctx_size > UVERBS_OPTIMIZE_USING_STACK_SZ)
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
+	if (cmd == RDMA_VERBS_IOCTL) {
+		err = copy_from_user(&hdr, user_hdr, sizeof(hdr));
+
+		if (err || hdr.length > IB_UVERBS_MAX_CMD_SZ ||
+		    hdr.length != sizeof(hdr) + hdr.num_attrs * sizeof(struct ib_uverbs_attr)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (hdr.reserved) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		err = ib_uverbs_cmd_verbs(ib_dev, file, &hdr,
+					  (__user void *)arg + sizeof(hdr));
+	} else {
+		err = -ENOIOCTLCMD;
+	}
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+
+	return err;
+}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314e..36c5cc7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2245,6 +2245,8 @@ struct ib_device {
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
+
+	const struct uverbs_spec_root	     *specs_root;
 };
 
 struct ib_client {
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index e06f4cf..7fed6d9 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -41,8 +41,13 @@
  * =======================================
  */
 
+#define UVERBS_ID_GROUP_MASK 0xF000
+#define UVERBS_ID_GROUP_SHIFT 12
+
 enum uverbs_attr_type {
 	UVERBS_ATTR_TYPE_NA,
+	UVERBS_ATTR_TYPE_PTR_IN,
+	UVERBS_ATTR_TYPE_PTR_OUT,
 	UVERBS_ATTR_TYPE_IDR,
 	UVERBS_ATTR_TYPE_FD,
 };
@@ -54,29 +59,106 @@ enum uverbs_obj_access {
 	UVERBS_ACCESS_DESTROY
 };
 
+enum uverbs_attr_spec_flags {
+	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
+	/* Support extending attributes by length */
+	UVERBS_ATTR_SPEC_F_MIN_SZ	= 1U << 1,
+};
+
 struct uverbs_attr_spec {
 	enum uverbs_attr_type		type;
-	struct {
-		/*
-		 * higher bits mean the group and lower bits mean
-		 * the type id within the group.
-		 */
-		u16			obj_type;
-		u8			access;
-	} obj;
+	/* a combination of enum uverbs_attr_spec_flags */
+	u8				flags;
+	union {
+		u16				len;
+		struct {
+			/*
+			 * higher bits mean the group and lower bits mean
+			 * the type id within the group.
+			 */
+			u16			obj_type;
+			u8			access;
+		} obj;
+	};
 };
 
 struct uverbs_attr_spec_group {
 	struct uverbs_attr_spec		*attrs;
 	size_t				num_attrs;
+	/* populate at runtime */
+	unsigned long			*mandatory_attrs_bitmask;
+};
+
+struct uverbs_attr_array;
+struct ib_uverbs_file;
+
+enum uverbs_action_flags {
+	/*
+	 * Action marked with this flag creates a context (or root for all
+	 * objects).
+	 */
+	UVERBS_ACTION_FLAG_CREATE_ROOT = 1U << 0,
+};
+
+struct uverbs_action {
+	struct uverbs_attr_spec_group			**attr_groups;
+	size_t						num_groups;
+	size_t						num_child_attrs;
+	/* Combination of bits from enum uverbs_action_flags */
+	u32 flags;
+	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
+		       struct uverbs_attr_array *ctx, size_t num);
+};
+
+struct uverbs_action_group {
+	size_t					num_actions;
+	struct uverbs_action			**actions;
+};
+
+struct uverbs_type {
+	size_t					num_groups;
+	const struct uverbs_action_group	**action_groups;
+	const struct uverbs_obj_type		*type_attrs;
+};
+
+struct uverbs_type_group {
+	size_t					num_types;
+	const struct uverbs_type		**types;
+};
+
+struct uverbs_spec_root {
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
+	void	__user *ptr;
+	u16		len;
 };
 
 struct uverbs_obj_attr {
+	/*
+	 * pointer to the user-space given attribute, in order to write the
+	 * new uobject's id.
+	 */
+	struct ib_uverbs_attr __user	*uattr;
+	/* pointer to the kernel descriptor -> type, access, etc */
+	const struct uverbs_obj_type	*type;
 	struct ib_uobject		*uobject;
+	/* fd or id in idr of this object */
+	int				id;
 };
 
 struct uverbs_attr {
-	struct uverbs_obj_attr	obj_attr;
+	union {
+		struct uverbs_ptr_attr	ptr_attr;
+		struct uverbs_obj_attr	obj_attr;
+	};
 };
 
 struct uverbs_attr_array {
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 9388125..3a40b9d 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -43,6 +43,30 @@
 /* Legacy name, for user space application which already use it */
 #define IB_IOCTL_MAGIC		RDMA_IOCTL_MAGIC
 
+#define RDMA_VERBS_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
+
+enum ib_uverbs_attr_flags {
+	UVERBS_ATTR_F_MANDATORY = 1U << 0,
+};
+
+struct ib_uverbs_attr {
+	__u16 attr_id;		/* command specific type attribute */
+	__u16 len;		/* only for pointers */
+	__u16 flags;		/* combination of ib_uverbs_attr_flags */
+	__u16 reserved;
+	__u64 data;		/* ptr to command, inline data or idr/fd */
+};
+
+struct ib_uverbs_ioctl_hdr {
+	__u16 length;
+	__u16 object_type;
+	__u16 action;
+	__u16 num_attrs;
+	__u64 reserved;
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
