From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Tue, 19 Jul 2016 18:23:29 +0300
Message-ID: <1468941812-32286-6-git-send-email-matanb@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In this proposed ioctl interface, processing the command starts from
properties of the command and fetching the appropriate user objects
before calling the handler.

Parsing and validation is done according to a specifier declared by
the driver's code. In the driver, all supported types are declared.
For each type we list all supported actions. Each action has a
specifies a handler, which could be either be a standard command or
a vendor specific command.
Along with the handler, a chain is specified as well. This chain
lists all supported attributes and is used for automatically
fetching and validating the command, response and its related objects.

Each chain consists of a validator_chains and a distribution function
which maps different command attributes to the different validators.
It also maps the attribute from the kABI world (which is vendor
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
meaning - the infrastructure will fail concurrent commands that at
least one of them requires concurrent access (WRITE/DESTROY),
synchronize actions with device removals (dissociate context events)
and take care of reference counting (increase/decrease). Automatically
reference count isn't coded yet, but the general concept here is to add
(INCREASE_REF, DECREASE_REF) to the access specification field and
update these reference in success automatically.

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
| vendor: uverbs_attr_array  |     +------------+
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

Ctx array's indices corresponds to the validators order. The indices
of core and vendor corresponds to the attributes name spaces of each
validator. Thus, we could think of the following as one object:
1. Set of attribute specification (with their attribute IDs)
2. Validator which owns (1) specifications
3. A function which could handle this attributes which the handler
   could call

That means that core and vendor are the validated function (3)
parameters and their types exist in this function namespace.

Since the requent used case, we propose a wrapper that
allows a definition of the following handler:
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
 drivers/infiniband/core/device.c           |   3 +
 drivers/infiniband/core/uverbs.h           |   4 +
 drivers/infiniband/core/uverbs_cmd.c       |   1 +
 drivers/infiniband/core/uverbs_ioctl.c     | 279 +++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_ioctl_cmd.c |  78 ++++++++
 drivers/infiniband/core/uverbs_main.c      |   6 +
 include/rdma/ib_verbs.h                    |   2 +
 include/rdma/uverbs_ioctl_cmd.h            |  68 +++++++
 include/uapi/rdma/rdma_user_ioctl.h        |  23 +++
 10 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 1819623..769a299 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				rdma_core.o
+				rdma_core.o uverbs_ioctl.o uverbs_ioctl_cmd.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5f09c40..b2e2ee2 100644
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
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 60d7c3d..86be861 100644
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
@@ -121,6 +124,7 @@ struct ib_uverbs_file {
 	struct ib_uverbs_event_file	       *async_file;
 	struct list_head			list;
 	int					is_closed;
+	struct rw_semaphore			close_sem;
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6af2c29..9648b80 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -361,6 +361,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	file->ucontext = ucontext;
+	ucontext->ufile = file;
 
 	fd_install(resp.async_fd, filp);
 
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
new file mode 100644
index 0000000..57ff7cb
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
+#include <rdma/rdma_ioctl.h>
+#include <rdma/uverbs_ioctl.h>
+#include "rdma_core.h"
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
+		/* If spec->len is zero, don't validate (flexible) */
+		if (spec->len && uattr->len != spec->len)
+			return -EINVAL;
+		e->cmd_attr.ptr = (void * __user)uattr->ptr_idr;
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
+	}
+
+	return n_val >= 0 ? n_val + 1 : n_val;
+}
+
+static int uverbs_handle_action(const struct ib_uverbs_attr *uattrs,
+				size_t num_attrs,
+				struct ib_device *ibdev,
+				struct ib_uverbs_file *ufile,
+				const struct uverbs_action *handler,
+				struct uverbs_attr_array *attr_array)
+{
+	int ret;
+	int n_val;
+
+	n_val = uverbs_validate(ibdev, ufile->ucontext, uattrs, num_attrs,
+				&handler->chain, attr_array);
+	if (n_val <= 0)
+		return n_val;
+
+	ret = handler->handler(ibdev, ufile, attr_array, n_val,
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
+	ctx->uverbs_attr_array = (void *)ctx + sizeof(*ctx);
+	ctx->uattrs = (void *)(ctx->uverbs_attr_array +
+			       action_spec->num_chains);
+	curr_attr = (void *)(ctx->uattrs + hdr->num_attrs);
+	for (i = 0; i < action_spec->num_chains; i++) {
+		ctx->uverbs_attr_array[i].attrs = curr_attr;
+		ctx->uverbs_attr_array[i].num_attrs =
+			action_spec->validator_chains[i]->num_attrs;
+		curr_attr += action_spec->validator_chains[i]->num_attrs;
+	}
+
+	err = copy_from_user(ctx->uattrs, buf,
+			     sizeof(*ctx->uattrs) * hdr->num_attrs);
+	if (err) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = uverbs_handle_action(ctx->uattrs, hdr->num_attrs, ib_dev,
+				   file, action, ctx->uverbs_attr_array);
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
index 0000000..4c2d30e4
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -0,0 +1,78 @@
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
+#include <rdma/ib_verbs.h>
+#include <linux/bug.h>
+#include "uverbs.h"
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
+EXPORT_SYMBOL(ib_uverbs_std_dist);
+
+int uverbs_action_std_handle(struct ib_device *ib_dev,
+			     struct ib_uverbs_file *ufile,
+			     struct uverbs_attr_array *ctx, size_t num,
+			     void *_priv)
+{
+	struct uverbs_action_std_handler *priv = _priv;
+
+	if (!ufile->ucontext)
+		return -EINVAL;
+
+	WARN_ON((num != 1) && (num != 2));
+	return priv->handler(ib_dev, ufile->ucontext, &ctx[0],
+			     (num == 2 ? &ctx[1] : NULL),
+			     priv->priv);
+}
+EXPORT_SYMBOL(uverbs_action_std_handle);
+
+int uverbs_action_std_ctx_handle(struct ib_device *ib_dev,
+				 struct ib_uverbs_file *ufile,
+				 struct uverbs_attr_array *ctx, size_t num,
+				 void *_priv)
+{
+	struct uverbs_action_std_ctx_handler *priv = _priv;
+
+	WARN_ON((num != 1) && (num != 2));
+	return priv->handler(ib_dev, ufile, &ctx[0], (num == 2 ? &ctx[1] : NULL), priv->priv);
+}
+EXPORT_SYMBOL(uverbs_action_std_ctx_handle);
+
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 333ed70..fa51568 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 
 #include <rdma/ib.h>
+#include <rdma/rdma_ioctl.h>
 
 #include "uverbs.h"
 
@@ -211,6 +212,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 {
 	struct ib_uobject *uobj, *tmp;
 
+	down_write(&file->close_sem);
 	context->closing = 1;
 
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
@@ -306,6 +308,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	}
 
 	put_pid(context->tgid);
+	up_write(&file->close_sem);
 
 	return context->device->dealloc_ucontext(context);
 }
@@ -915,6 +918,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 		goto err;
 	}
 
+	init_rwsem(&file->close_sem);
 	file->device	 = dev;
 	file->ucontext	 = NULL;
 	file->async_file = NULL;
@@ -973,6 +977,7 @@ static const struct file_operations uverbs_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -982,6 +987,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static struct ib_client uverbs_client = {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 85d4c41..4688463 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1314,6 +1314,7 @@ struct ib_umem;
 
 struct ib_ucontext {
 	struct ib_device       *device;
+	struct ib_uverbs_file  *ufile;
 	struct list_head	pd_list;
 	struct list_head	mr_list;
 	struct list_head	mw_list;
@@ -1976,6 +1977,7 @@ struct ib_device {
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	struct list_head type_list;
 
+	u16				driver_id;
 	const struct uverbs_types	*types;
 };
 
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
new file mode 100644
index 0000000..19806df
--- /dev/null
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -0,0 +1,68 @@
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
+int ib_uverbs_std_dist(__u16 *attr_id, void *priv);
+
+/* common validators */
+
+int uverbs_action_std_handle(struct ib_device *ib_dev,
+			     struct ib_uverbs_file *ufile,
+			     struct uverbs_attr_array *ctx, size_t num,
+			     void *_priv);
+int uverbs_action_std_ctx_handle(struct ib_device *ib_dev,
+				 struct ib_uverbs_file *ufile,
+				 struct uverbs_attr_array *ctx, size_t num,
+				 void *_priv);
+
+struct uverbs_action_std_handler {
+	int (*handler)(struct ib_device *ib_dev, struct ib_ucontext *ucontext,
+		       struct uverbs_attr_array *common,
+		       struct uverbs_attr_array *vendor,
+		       void *priv);
+	void *priv;
+};
+
+struct uverbs_action_std_ctx_handler {
+	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
+		       struct uverbs_attr_array *common,
+		       struct uverbs_attr_array *vendor,
+		       void *priv);
+	void *priv;
+};
+
+#endif
+
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 5c1117a..f6927fc 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -42,6 +42,29 @@
  */
 #define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
 
+#define RDMA_VERBS_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
+
+#define RDMA_DIRECT_IOCTL \
+	_IOWR(RDMA_IOCTL_MAGIC, 2, struct ib_uverbs_ioctl_hdr)
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
