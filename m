From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH v2 1/2] rdma/ucm: Sketch for an ioctl framework
Date: Wed, 15 Jun 2016 17:11:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB062505@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following is version 2 of an outline for an ioctl framework.
This framework targets the rdma cm, but is intended to be expanded
to include verbs and other rdma devices, such as usnic, qib, and hfi1.
This series includes a patch that ports the rdma cm create id
command to use the ioctl framework as an example.

The purpose of the patch is to drive discussion and feedback on
various design decisions, so that a single merged solution can be
developed.  The code is entirely untested and will not work without
completing the port of the existing write interface to ioctls.  I
wanted to get these concepts out for broader review, but moving
forward, I believe the two approaches are converging and we can begin
to focus development efforts.

The general architecture behind the implementation is described below.
I will respond to this email to highlight specific areas in the code
where further discussion will be useful.

Ioctls are logically grouped into name spaces.  Each name
space defines a set of ioctl handlers.  Ioctls are routed through the
framework, to a specific name space, and from there to handler routines
for that ioctl.  A name space may be associated with a specific kernel
driver, a hardware device, or a set of hardware resources on a device.
This series defines 2 name spaces:

- A name space manager, which is used to retrieve data about the
  name spaces that are available.
- The rdma ucm, which exports the rdma cm interfaces to user space.

(Note: I selected the term name space to correspond to programming
name spaces.  However, since Linux uses the same term for a different
purpose, the name should probably change.)


A name space is identified in the kernel by a structure with the
following fields:

uda_ns
======
id	Name space manager assigned identifier.  Note that the name
	space manager is always at id 0.
flags	Currently used to indicate when a name space has been closed and
	the underlying implementation (i.e. driver or device) is
	no longer available.  Once a name space has been closed, the
	only operations user space may perform is to release kernel
	resources.

idr	Used to map kernel resources back to user space.
lock	Protects access to the idr
ioctl_base
	Name spaces have unique opcode values.  Each name space has a
	hard coded limit of 128 opcodes.  The ioctl_base is the value
	of the starting opcode.  A name space that requires more than
	128 opcodes will need to span 2 'name spaces'.
num_ioctls
	Total number of function handlers supported by the name space
[get_]ioctl_desc()
	Handler that takes as input an ioctl, verifies that the
	ioctl is properly formatted, including all arguments are
	valid, and returns a descriptor that describes how to
	process the ioctl.
close()	Generic close routine to release any underlying resources
	associated with an object.  This is invoked by the framework
	to cleanup resources when the user space process exits.
name	Name spaces are identified by a character string.


A primary goal of a name space is to associate an ioctl with a
descriptor.  The descriptor tells the framework how to process the
ioctl.  A descriptor is a simple structure with these fields:

flags	Specifies if the operation creates a new object, destroys
	an object, and the type of access required (shared or
	exclusive) of the object.
func()	Function handler to invoke that is specific to the ioctl.
name	Debug character string


Ioctl format:
All ioctls start with the same basic header, followed by the same
data layout.

uda_ioctl
=========
ns_id	Identifies the name space which is the target of this ioctl.
	The name space manager is always at id 0.
length	Total size of the ioctl.  Note that additional input/output
	buffers may be provided as arguments, which would not be
	included as part of this length.
op	The actual operation to perform.  For debugging purposes,
	op values are not shared between name spaces.  The op
	is used as a simple index into a name space's descriptor table.
flags	Any flags associated with the operation.
obj_cnt	Kernel allocated objects follow the ioctl header.  This
	specifies the number of objects.
arg_cnt	A number of input/output arguments following any objects.
data	Ioctl data, including objects and arguments follow the
	header.  Notable data include the uda_obj_id and uda_arg
	structures.  The obj_cnt indicates the number of uda_obj_id
	structures, and arg_cnt specifies the number of uda_arg
	structures.



uda_obj_id
==========
instance_id
	An index into an idr, which represents a kernel object.
obj_type
	Identifies the type of object represented by the instance_id.
	The framework validates the obj_type against that stored by
	the kernel.
data	Object specific information (padding)

uda_arg
=======
offset	Byte offset from the start of the ioctl where the argument
	data begins.  In general, ioctl data is included as part of a
	single ioctl buffer.

attr_id	A unique identifier for the ioctl data.  The attribute id
	typically corresponds to a data structure.  Similar to
	opcodes, the attribute id's are unique, with some attributes
	shared between name spaces.  A reply email will call out a
	couple of important attributes.

length	Size of the argument data
data	Attribute specific information (padding)


This is the general flow of ioctl processing through the framework.

1. Copy ioctl header from user space.
2. Verify length of ioctl, including arg sizes.
3. Select target name space.
4. Name space verifies ioctl and returns descriptor.
5. Copy ioctl argument data from user space.
6. Verify and convert user space object identifiers to kernel
   objects.
7. Invoke ioctl handler
8. Return control to user space.

There are some kinks to work out of this, but I think it provides a
generic enough framework to support current and anticipated needs,
and seems to align with the work being presented in the ofvwg.  A
generic attribute validation scheme could easily fit into this
under the [get_]ioctl_desc() callback.  (I almost have the start of
one if you examine the patch details.)  Alternatively, by
defining a 'compat' attribute id, the existing write interface could
probably be ported almost as-is, though I'm not recommending this.

The event interface needs to be defined.  But if each device is
treated as a new name space, I think this will allow a single fd to
issue commands to any rdma device.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/Makefile |    2 +-
 drivers/infiniband/core/ucma.c   |    4 +-
 drivers/infiniband/core/urdma.c  |  396 ++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_uapi.h         |  131 +++++++++++++
 include/uapi/rdma/rdma_ioctl.h   |  148 ++++++++++++++
 5 files changed, 678 insertions(+), 3 deletions(-)
 create mode 100644 drivers/infiniband/core/urdma.c
 create mode 100644 include/rdma/rdma_uapi.h
 create mode 100644 include/uapi/rdma/rdma_ioctl.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..43af0a8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -26,7 +26,7 @@ rdma_cm-y :=			cma.o
 
 rdma_cm-$(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS) += cma_configfs.o
 
-rdma_ucm-y :=			ucma.o
+rdma_ucm-y :=			ucma.o urdma.o
 
 ib_addr-y :=			addr.o
 
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index dd3bcce..b289ce0 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -491,9 +491,9 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 err2:
 	rdma_destroy_id(ctx->cm_id);
 err1:
-	mutex_lock(&mut);
+	mutex_lock(&file->mut);
 	idr_remove(&ctx_idr, ctx->id);
-	mutex_unlock(&mut);
+	mutex_unlock(&file->mut);
 	kfree(ctx);
 	return ret;
 }
diff --git a/drivers/infiniband/core/urdma.c b/drivers/infiniband/core/urdma.c
new file mode 100644
index 0000000..428e75d
--- /dev/null
+++ b/drivers/infiniband/core/urdma.c
@@ -0,0 +1,396 @@
+/*
+ * Copyright (c) 2016 Intel Corporation, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
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
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/rwsem.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+
+#include <uapi/rdma/rdma_ioctl.h>
+#include <rdma/rdma_uapi.h>
+
+
+static DECLARE_RWSEM(rw_lock);
+static u16 max_ns;
+static struct uda_ns *ns_array[64];
+
+
+static struct uda_obj * uda_get_obj(struct uda_file *file, struct uda_ns *ns,
+				    struct uda_obj_id *id, bool excl)
+{
+	struct uda_obj *obj;
+
+	if (id->data)
+		return ERR_PTR(-EINVAL);
+
+	obj = idr_find(&ns->idr, id->instance_id);
+	if (!obj || obj->obj_type != id->obj_type || obj->file != file)
+		return ERR_PTR(-ENOENT);
+	else if (obj->flags & UDA_EXCL || (excl && atomic_read(&obj->use_cnt)))
+		return ERR_PTR(-EBUSY);
+
+	if (excl)
+		obj->flags |= UDA_EXCL;
+	atomic_inc(&obj->use_cnt);
+	return obj;
+}
+
+static void uda_put_obj(struct uda_obj *obj)
+{
+	if (obj->flags & UDA_EXCL)
+		obj->flags &= ~UDA_EXCL;
+	atomic_dec(&obj->use_cnt);
+}
+
+static void uda_unmap_obj(struct uda_ioctl *ioctl, int index)
+{
+	struct uda_obj *obj;
+
+	obj = ioctl->u.obj[index];
+	ioctl->u.obj_id[index].instance_id = obj->instance_id;
+	ioctl->u.obj_id[index].obj_type = obj->obj_type;
+	ioctl->u.obj_id[index].data = 0;
+	uda_put_obj(obj);
+}
+
+static void uda_unmap_objs(struct uda_ioctl *ioctl)
+{
+	int i;
+
+	for (i = 0; i < ioctl->obj_cnt; i++)
+		uda_unmap_obj(ioctl, i);
+}
+
+static long uda_map_objs(struct uda_file *file, struct uda_ns *ns,
+			 struct uda_ioctl *ioctl, bool excl)
+{
+	struct uda_obj *obj;
+	int i;
+
+	mutex_lock(&ns->lock);
+	for (i = 0; i < ioctl->obj_cnt; i++) {
+		obj = uda_get_obj(file, ns, &ioctl->u.obj_id[i], excl && i == 0);
+		if (IS_ERR(obj))
+			goto err;
+
+		ioctl->u.obj[i] = obj;
+	}
+	mutex_unlock(&ns->lock);
+	return 0;
+
+err:
+	while (i--)
+		uda_unmap_obj(ioctl, i);
+	mutex_unlock(&ns->lock);
+	return PTR_ERR(obj);
+}
+
+static void uda_post_close(struct uda_ns *ns, struct uda_ioctl *ioctl,
+			   struct uda_ioctl_desc *desc)
+{
+	struct uda_obj *obj;
+
+	obj = ioctl->u.obj[0];
+	ioctl->u.obj[0] = NULL;
+
+	mutex_lock(&ns->lock);
+	idr_remove(&ns->idr, obj->instance_id);
+	list_del(&obj->entry);
+	mutex_unlock(&ns->lock);
+	kfree(obj);
+}
+
+static void uda_post_common(struct uda_ns *ns, struct uda_ioctl *ioctl,
+			    struct uda_ioctl_desc *desc)
+{
+	if (desc->flags & UDA_CLOSED)
+		uda_post_close(ns, ioctl, desc);
+	else
+		uda_unmap_objs(ioctl);
+}
+
+static long uda_pre_open(struct uda_file *file, struct uda_ns *ns,
+			 struct uda_ioctl *ioctl, struct uda_ioctl_desc *desc)
+{
+	struct uda_obj *obj;
+	struct uda_arg *arg;
+	u16 index = ioctl->obj_cnt;
+	long ret;
+
+	if (!ioctl->arg_cnt)
+		return -EINVAL;
+
+	/* arg[0] = identifier of object to open, data = object id */
+	ret = uda_check_arg(ioctl, index, UDA_UCONTEXT, sizeof(u64));
+	if (ret)
+		return ret;
+
+	obj = kzalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	arg = &ioctl->u.arg[index];
+	obj->file = file;
+	obj->flags = UDA_EXCL;
+	obj->obj_type = arg->data;
+	obj->ucontext = *(u64 *) UDA_ARG_DATA(ioctl, index);
+	atomic_set(&obj->use_cnt, 1);
+
+	mutex_lock(&ns->lock);
+	obj->instance_id = idr_alloc(&ns->idr, obj, 0, 0, GFP_KERNEL);
+	if (obj->instance_id >= 0)
+		list_add(&obj->entry, &file->obj_list);
+	mutex_unlock(&ns->lock);
+
+	if (obj->instance_id < 0) {
+		kfree(obj);
+		return -ENOMEM;
+	}
+
+	/* new object added after object array */
+	ioctl->u.obj[ioctl->obj_cnt++] = obj;
+	ioctl->arg_cnt--;
+	return 0;
+}
+
+static long uda_check_args(struct uda_ioctl *ioctl)
+{
+	struct uda_arg *arg;
+	u16 i;
+
+	for (i = 0; i < ioctl->arg_cnt; i++) {
+		arg = &ioctl->u.arg[i + ioctl->obj_cnt];
+		if (arg->offset + arg->length > ioctl->length)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static long uda_pre_common(struct uda_file *file, struct uda_ns *ns,
+			   struct uda_ioctl *ioctl, struct uda_ioctl_desc *desc)
+{
+	long ret;
+
+	if (desc->flags & UDA_CLOSED) {
+		/* Limit of one object closed at a time */
+		if (ioctl->obj_cnt != 1)
+			return -EINVAL;
+	} else {
+		/* If name space has closed, we can only close objects */
+		if (ns->flags & UDA_CLOSED)
+			return -ENODEV;
+	}
+
+	ret = uda_map_objs(file, ns, ioctl, desc->flags & UDA_EXCL);
+	if (ret)
+		return ret;
+
+	if (desc->flags & UDA_OPEN) {
+		ret = uda_pre_open(file, ns, ioctl, desc);
+		if (ret)
+			goto err;
+	}
+
+	ret = uda_check_args(ioctl);
+	return ret;
+err:
+	uda_unmap_objs(ioctl);
+	return ret;
+}
+
+long uda_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct uda_file *file = filp->private_data;
+	struct uda_ns *ns;
+	struct uda_ioctl hdr, *data = NULL;
+	struct uda_ioctl_desc *desc;
+	char stack_data[128];
+	long ret;
+
+	if (_IOC_NR(cmd) & UDA_RAW_OP)
+		return -ENOSYS;	/* TODO: write me */
+
+	if (_IOC_NR(cmd) != UDA_UBER_OP || _IOC_SIZE(cmd) < sizeof(hdr))
+		return -EINVAL;
+
+	if (copy_from_user(&hdr, (void __user *) arg, sizeof(hdr)))
+		return -EFAULT;
+
+	if (((hdr.obj_cnt + hdr.arg_cnt) * sizeof(hdr.u) + sizeof(hdr) >
+	    hdr.length) || hdr.resv)
+		ret = -EINVAL;
+
+	down_read(&rw_lock);
+	if (hdr.ns_id > max_ns || !ns_array[hdr.ns_id]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ns = ns_array[hdr.ns_id];
+	if (hdr.op < ns->ioctl_base ||
+	    hdr.op >= (ns->ioctl_base + ns->num_ioctls)) {
+		ret = -ENOSYS;
+		goto out;
+	}
+
+	desc = ns->ioctl_desc(&hdr);
+	if (IS_ERR(desc)) {
+		ret = PTR_ERR(desc);
+		goto out;
+	}
+
+	if (hdr.length > sizeof(stack_data)) {
+		data = kmalloc(hdr.length, GFP_KERNEL);
+		if (!data) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		data = (struct uda_ioctl *) stack_data;
+	}
+
+	if (copy_from_user(data, (void __user *) arg, hdr.length)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = uda_pre_common(file, ns, data, desc);
+	if (ret)
+		goto out;
+
+	ret = desc->func(ns, data);
+	uda_post_common(ns, data, desc);
+out:
+	up_read(&rw_lock);
+	if (data != (struct uda_ioctl *) stack_data)
+		kfree(data);
+	return ret;
+}
+
+/* TODO: make this less suckish, update remove call when doing so */
+int uda_add_ns(struct uda_ns *ns)
+{
+	u16 i;
+
+	if (max_ns >= 64)
+		return -ENOMEM;
+
+	for (i = 0; i < max_ns; i++) {
+		if (!ns_array[i])
+			break;
+	}
+	ns_array[i] = ns;
+	ns->id = i;
+	if (i == max_ns)
+		max_ns++;
+	return 0; 
+}
+
+void uda_remove_ns(struct uda_ns *ns)
+{
+	//struct uda_obj *obj;
+
+	down_write(&rw_lock);
+	ns->flags |= UDA_CLOSED;
+
+	/* for each opened file
+	 *     for each object
+	 *         if object belongs to name space
+	 *             ns->close(ns, obj);
+	 */
+	ns_array[ns->id] = NULL;
+
+	while (!ns_array[max_ns - 1])
+		max_ns--;
+	up_write(&rw_lock);
+}
+
+
+/*
+ * Name space manager
+ */
+static long uda_check_query(struct uda_ioctl *ioctl)
+{
+	long ret;
+
+	if (ioctl->flags || ioctl->obj_cnt || ioctl->arg_cnt != 1)
+		return -EINVAL;
+
+	ret = uda_check_arg(ioctl, 0, UDA_IOVEC, sizeof(struct uda_iovec));
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static long uda_query_ns(struct uda_ns *ns, void *data)
+{
+//	struct uda_ioctl *ioctl = data;
+
+	/* TODO: for each name space, write out uda_ns_attr details */
+	return -ENOSYS;
+}
+
+static uda_ioctl_handler_t ns_mgr_check_ops[] = {
+	[UDA_NS_MGR_QUERY] = uda_check_query,
+};
+
+static struct uda_ioctl_desc ns_mgr_ops[] = {
+	UDA_DESC(NS_MGR, QUERY, uda_query_ns, 0),
+};
+
+static struct uda_ioctl_desc *ns_mgr_get_desc(struct uda_ioctl *ioctl)
+{
+	u32 op;
+
+	op = ioctl->op - UDA_NS_MGR_BASE;
+	if (ns_mgr_check_ops[op](ioctl))
+		return NULL;
+
+	return &ns_mgr_ops[op];
+}
+
+static struct uda_ns ns_mgr = {
+	.idr = IDR_INIT(ns_mgr.idr),
+	.lock = __MUTEX_INITIALIZER(ns_mgr.lock),
+	.ioctl_base = UDA_NS_MGR_BASE,
+	.num_ioctls = UDA_NS_MGR_IOCTLS, /* use array length */
+	.ioctl_desc = ns_mgr_get_desc,
+	.name = "urdma ioctl name space manager"
+};
+
+void uda_init(void)
+{
+	uda_add_ns(&ns_mgr);
+}
diff --git a/include/rdma/rdma_uapi.h b/include/rdma/rdma_uapi.h
new file mode 100644
index 0000000..2eef240
--- /dev/null
+++ b/include/rdma/rdma_uapi.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2016 Intel Corporation, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
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
+#ifndef RDMA_UAPI_H
+#define RDMA_UAPI_H
+
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/idr.h>
+#include <linux/list.h>
+
+#include <uapi/rdma/rdma_ioctl.h>
+
+
+/* Object and control flags */
+/* Indicates operation will allocate a new kernel object. */
+#define UDA_OPEN		(1 << 0)
+/* Indicates operation will destroy a kernel object */
+#define UDA_CLOSED		(1 << 1)
+/* Operation on object requires exclusive access */
+#define UDA_EXCL		(1 << 2)
+/* Events may be generated for the given object */
+#define UDA_EVENT		(1 << 3)
+
+struct uda_ns;
+struct uda_obj;
+
+typedef long (*uda_handler_t)(struct uda_ns *ns, void *data);
+typedef long (*uda_ioctl_handler_t)(struct uda_ioctl *ioctl);
+
+/* ioctl descriptor */
+struct uda_ioctl_desc {
+	u32			flags;
+	uda_handler_t		func;
+	const char		*name;
+};
+
+#define UDA_DESC(_NS, _OP, _func, _flags)	\
+	[UDA_ ## _NS ## _ ## _OP] = {		\
+		.flags = _flags,		\
+		.func = _func,			\
+		.name = #_NS "_" #_OP		\
+	}
+
+/* ioctl function namespace dispatcher */
+struct uda_ns {
+	int			id;
+	int			flags;
+	struct idr		idr;
+	struct mutex		lock;
+
+	uint64_t		ioctl_base;
+	int			num_ioctls;
+	struct uda_ioctl_desc	*(*ioctl_desc)(struct uda_ioctl *ioctl);
+
+	/* generic close routine to cleanup any object */
+	void			(*close)(struct uda_ns *ns,
+					 struct uda_obj *obj);
+	const char		*name;
+};
+
+/* instance of an opened rdma file */
+struct uda_file {
+	struct file		*filp;
+	struct list_head	obj_list;
+	struct list_head	event_list;
+	wait_queue_head_t	poll_wait;
+	// struct workqueue_struct	*close_wq;
+};
+	
+/* uda will protect against destroying an object that is in use,
+ * but all locking is pushed down to the drivers.
+ * Keep this structure as small as possible to minimize per object footprint
+ */
+struct uda_obj {
+	u64			ucontext;
+	void			*kcontext;
+	struct uda_file		*file;
+	u32			instance_id;	/* idr index */
+	u16			obj_type;
+	u16			flags;
+	struct list_head	entry;
+	atomic_t		use_cnt;
+};
+
+
+void uda_init(void);
+int uda_add_ns(struct uda_ns *ns);
+void uda_remove_ns(struct uda_ns *ns);
+long uda_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
+static inline long uda_check_arg(struct uda_ioctl *ioctl, int index,
+				 u16 attr_id, u16 length)
+{
+	struct uda_arg *arg;
+	arg = &ioctl->u.arg[index];
+	return (arg->attr_id != attr_id || arg->length != length) ?
+		-EINVAL : 0;
+}
+
+#endif /* RDMA_UAPI_H */
+
diff --git a/include/uapi/rdma/rdma_ioctl.h b/include/uapi/rdma/rdma_ioctl.h
new file mode 100644
index 0000000..6839044
--- /dev/null
+++ b/include/uapi/rdma/rdma_ioctl.h
@@ -0,0 +1,148 @@
+/*
+ * Copyright (c) 2016 Intel Corporation, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
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
+#ifndef RDMA_IOCTL_H
+#define RDMA_IOCTL_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+
+#define UDA_OP_MASK			0x7F
+#define UDA_OP(nr)			(_IOC_NR(nr) & UDA_OP_MASK)
+
+/* unstructured ioctls set the high-order op bit */
+#define UDA_RAW_OP			(0x80)
+
+/* size to u64 */
+struct uda_obj_id {
+	u32	instance_id;
+	u16	obj_type;
+	u16	data;		/* object specific */
+};
+
+/* size to u64 */
+struct uda_arg {
+	u16	offset;
+	u16	attr_id;
+	u16	length;
+	u16	data;		/* attribute specific */
+};
+
+struct uda_ioctl {
+	u16	ns_id;
+	u16	length;		/* total length of ioctl with data */
+	u32	op;
+	u32	flags;
+	/* data ordered as objects, in args, out args, other data */
+	u8	obj_cnt;
+	u8	arg_cnt;
+	u16	resv;
+	union {
+		struct uda_obj_id	obj_id[0];
+		struct uda_arg		arg[0];
+		u64			data[0];
+#ifdef __KERNEL__
+
+		void			*obj[0];
+#endif
+	}	u;
+};
+
+#define UDA_ARG_DATA(ioctl, argi) (((void *) ioctl) + (ioctl)->u.arg[argi].offset)
+
+/* must align with uda_ioctl */
+struct uda_raw_ioctl {
+	u16	ns_id;
+	u16	length;
+	u32	op;
+	u64	data[0];
+};
+
+#define UDA_TYPE		0x1b
+#define UDA_IOW(op, type)	_IOW(UDA_TYPE, op, type)
+#define UDA_IOWR(op, type)	_IOWR(UDA_TYPE, op, type)
+
+#define UDA_RAW_CMD(op)		(op | UDA_RAW_OP)
+#define UDA_RAW_IOW(op)		UDA_IOW(UDA_RAW_CMD(op), struct uda_raw_ioctl)
+#define UDA_RAW_IOWR(op)	UDA_IOWR(UDA_RAW_CMD(op), struct uda_raw_ioctl)
+
+#define UDA_UBER_OP		3	/* TODO: verify this */
+#define UDA_IOCTL(op)		UDA_IOWR(UDA_UBER_OP, struct uda_ioctl)
+
+#define UDA_MAX_NAME		64
+#define UDA_OP_RANGE		128
+
+
+/* name spaces */
+enum {
+	UDA_NS_MGR,
+};
+
+#define UDA_NS_BASE(NS)		(NS * UDA_OP_RANGE)
+#define UDA_NS_MGR_BASE		UDA_NS_BASE(UDA_NS_MGR)
+
+enum {
+	UDA_NS_MGR_QUERY,
+	UDA_NS_MGR_IOCTLS
+};
+
+enum {
+	UDA_NS_MGR_VERSION = 0,
+};
+
+enum {
+	UDA_RAW_ATTR,		/* provider specific attribute */
+	UDA_IOVEC,
+	UDA_OBJ_ID,
+	UDA_UCONTEXT,
+	UDA_NS_ATTR,
+};
+
+struct uda_iovec {
+	u64	addr;
+	u64	length;
+};
+
+struct uda_ns_attr {
+	char	name[UDA_MAX_NAME];
+	u32	op;
+	u32	flags;
+	u16	attr;
+	u16	id;
+	u16	version;
+	u16	resv;
+};
+
+
+#endif /* RDMA_IOCTL_H */
+
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
