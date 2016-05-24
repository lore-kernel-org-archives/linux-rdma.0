From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 06:25:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following is a sketch, or outline, for an ioctl framework.
The purpose of the patch is to drive discussion and feedback on
various design decisions rather than low-level comments on the
code, so that the changes can be incorporated earlier in the
development cycle.  The code is entirely untested and some functionality
is not coded.

The general architecture behind the implementation is described below.

Conceptually, ioctl's are split into two main groups:
structured and unstructured.

Unstructured ioctls:
Unstructured ioctls are dispatched directly to a driver with
minimal processing by the framework.

Structured ioctls:
Structured ioctls are designed to support generic framework
processing.  These ioctls are dispatched to per-device routines and
are based on the object ioctl model which was previously posted to
the linux-rdma mail list.  It is anticipated that most ioctls
will be structured, and the following descriptions assume structured ioctls.

Ioctl commands:
There are 6 generic ioctl commands: QUERY, OPEN, CLOSE, MODIFY, READ,
and WRITE.  Commands target a specific functional domain, which may map
to specific objects.  The implementation has a 1:1 mapping, but this
is not required.  Possible domains include: DRIVER, DEVICE, PORT, CQ,
PD, MR, QP, etc.  The full set of domains, and how they map to objects,
needs to be determined.  Ioctls are routed to dispatch routines based
on the <domain, command> pair.  Additionally, each command includes
pre and post operation hooks.  The hooks allow command specific
(e.g. OPEN or CLOSE) functionality to be applied.

Ioctl descriptors:
Descriptors are kernel structures that describe how each ioctl should
be processed by the framework, and include the dispatch routine and
control flags.  Each device maintains an array of ioctl descriptors.
Discussion is needed on the format of the descriptors, though these
are easily changeable.

Ioctl format:
All ioctls start with the same basic header.  The header includes a version,
the length of any input data, and the domain.  Structured ioctls also include
an array of objects that the ioctl will require access to for processing.
This patch does not define the format of the ioctl data beyond the object
array.  That is ultimately determined based on the <domain, command>.
However, as seen in the patch, the format of the object array will matter
and needs discussion.

Kernel objects:
The framework maps object identifiers between user space and the kernel.
Based on descriptor control flags, it will provide exclusive access to objects
where needed.  The framework also handles clean-up in case of application exits
and supports device removal.  Event handling will also be supported by the
framework, though that work still needs to be done.

Architecturally, the framework supports drivers plugging into it independent
of any kernel interface that may be used.  It is also relatively independent
of any user space library or implementation which may require access to
kernel resources.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I restructured the email to show the headers first.
The code is also available in the dev branch on github.com/shefty/linux.

 drivers/infiniband/core/Makefile |    2 +-
 drivers/infiniband/core/urdma.c  |  373 ++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_uapi.h         |  140 ++++++++++++++
 include/uapi/rdma/rdma_ioctl.h   |  134 ++++++++++++++
 4 files changed, 648 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/core/urdma.c
 create mode 100644 include/rdma/rdma_uapi.h
 create mode 100644 include/uapi/rdma/rdma_ioctl.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..d70ba32 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -34,4 +34,4 @@ ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
 
-ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o urdma.o
diff --git a/include/uapi/rdma/rdma_ioctl.h b/include/uapi/rdma/rdma_ioctl.h
new file mode 100644
index 0000000..3e34791
--- /dev/null
+++ b/include/uapi/rdma/rdma_ioctl.h
@@ -0,0 +1,134 @@
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
+#include <rdma/ib_user_verbs.h>
+#include <linux/ioctl.h>
+
+
+/* ioctls are grouped into 1 of 8 domains/namespaces
+#define URDMA_DOMAIN(nr)	(_IOC_NR(nr) >> 5)
+enum {
+	URDMA_DOMAIN_OBJECT,
+	URDMA_DOMAIN_DRIVER,
+	URDMA_MAX_DOMAIN
+};
+*/
+
+#define URDMA_OP_MASK			0x7F
+#define URDMA_OP(nr)			(_IOC_NR(nr) & URDMA_OP_MASK)
+
+/* operations */
+enum {
+	URDMA_QUERY,
+	URDMA_OPEN,
+	URDMA_CLOSE,
+	URDMA_MODIFY,
+	URDMA_READ,
+	URDMA_WRITE,
+	URDMA_MAX_OP
+};
+
+/* driver specific object operations set the high-order op bit */
+#define URDMA_DRIVER_OP			(0x80)
+
+/* operation domains, doubles as object types */
+enum {
+	URDMA_DRIVER,	/* is this usable? */
+	URDMA_DEVICE,
+	URDMA_PORT,
+	URDMA_CQ,
+	URDMA_PD,
+	URDMA_AH,
+	URDMA_MR,
+	URDMA_SHARED_RX,
+	URDMA_SHARED_TX,
+	URDMA_QP,
+	URDMA_CMD_CTX,
+	/* others... */
+	URDMA_MAX_DOMAIN
+};
+
+/* driver specific domains set the high-order domain bit */
+#define URDMA_DRIVER_DOMAIN		(1 << 16)
+
+struct urdma_obj_id {
+	u32	instance_id;
+	u16	obj_type;
+	u16	resv;
+};
+
+/* ensure that data beyond header starts at 64-byte alignment */
+struct urdma_ioctl {
+	u8	version;
+	u8	count;
+	u16	domain;
+	u16	length;
+	u16	resv;
+	u64	flags;
+	union {
+		struct urdma_obj_id	obj_id[0];
+		u64			data[0];
+#ifdef __KERNEL__
+		void			*obj[0];
+#endif
+	};
+};
+
+
+#define URDMA_TYPE			0xda
+#define URDMA_IO(op)			_IO(URDMA_TYPE, op)
+#define URDMA_IOR(op, type)		_IOR(URDMA_TYPE, op, type)
+#define URDMA_IOW(op, type)		_IOW(URDMA_TYPE, op, type)
+#define URDMA_IOWR(op, type)		_IOWR(URDMA_TYPE, op, type)
+
+#define URDMA_DRIVER_CMD(op)		(op | URDMA_DRIVER_OP)
+#define URDMA_DRIVER_IO(op)		URDMA_IO(URDMA_DRIVER_CMD(op))
+#define URDMA_DRIVER_IOR(op, type)	URDMA_IOR(URDMA_DRIVER_CMD(op), type)
+#define URDMA_DRIVER_IOW(op, type)	URDMA_IOW(URDMA_DRIVER_CMD(op), type)
+#define URDMA_DRIVER_IOWR(op, type)	URDMA_IOWR(URDMA_DRIVER_CMD(op), type)
+
+#define URDMA_IOCTL(op)			URDMA_IOWR(URDMA_##op, struct urdma_ioctl)
+
+#define URDMA_IOCTL_QUERY		URDMA_IOCTL(QUERY)
+#define URDMA_IOCTL_OPEN		URDMA_IOCTL(OPEN)
+#define URDMA_IOCTL_CLOSE		URDMA_IOCTL(CLOSE)
+#define URDMA_IOCTL_MODIFY		URDMA_IOCTL(MODIFY)
+#define URDMA_IOCTL_READ		URDMA_IOCTL(READ)
+#define URDMA_IOCTL_WRITE		URDMA_IOCTL(WRITE)
+
+
+#endif /* RDMA_IOCTL_H */
+
diff --git a/include/rdma/rdma_uapi.h b/include/rdma/rdma_uapi.h
new file mode 100644
index 0000000..8b5105e
--- /dev/null
+++ b/include/rdma/rdma_uapi.h
@@ -0,0 +1,140 @@
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
+#include <rdma/ib_user_verbs.h>
+#include <uapi/rdma/rdma_ioctl.h>
+
+
+#define URDMA_OFFSET(dom, op)		(dom * URDMA_MAX_OP + op)
+#define URDMA_MAX_BASE			(URDMA_MAX_DOMAIN * URDMA_MAX_OP - 1)
+#define URDMA_DRIVER_OFFSET(op)		(op)
+
+/* Object and control flags */
+/* Operation on object requires exclusive access - e.g. MODIFY */
+#define URDMA_EXCL		(1 << 0)
+/* Events may be generated for the given object - e.g. CQ, QP */
+#define URDMA_EVENT		(1 << 1)
+/* Device resources have been freed */
+#define URDMA_CLOSED		(1 << 2)
+
+struct urdma_device;
+
+typedef long (*urdma_ioctl_handler_t)(struct urdma_device *dev,
+				      void *data, void *file_data);
+
+/* The purpose of this structure is to guide the behavior of the
+ * common ioctl processing code.
+ */
+struct urdma_ioctl_desc {
+	u64			flags;
+	unsigned int		cmd;
+	u16			length; /* max size needed */
+	urdma_ioctl_handler_t	func;
+	const char		*name;
+};
+
+typedef long (*urdma_ioctl_hook_t)(struct urdma_device *dev,
+				   struct urdma_ioctl *ioctl,
+				   struct urdma_ioctl_desc *desc,
+				   void *file_data);
+
+#define URDMA_DESC(_dom, _op, _func, _flags)			\
+	[URDMA_OFFSET(URDMA_##_dom, URDMA_##_op)] = {		\
+		.flags = _flags,				\
+		.cmd = URDMA_IOCTL_##_op,			\
+		.func = _func,					\
+		.name = #_dom "_" #_op				\
+	}
+
+#define URDMA_DRIVER_DESC(_dom, _op, _func, _flags)		\
+	[URDMA_DRIVER_OFFSET(URDMA_##_dom, URDMA_##_op)] = {	\
+		.flags = _flags,				\
+		.cmd = URDMA_IOCTL_##_op,			\
+		.func = _func,					\
+		.name = #_dom "_" #_op				\
+	}
+
+extern const struct urdma_ioctl_desc verbs_ioctl[URDMA_MAX_BASE];
+
+struct urdma_driver {
+	int			num_ioctls;
+	struct urdma_ioctl_desc	*ioctl;
+};
+
+/* will merge with ib_device, can be separated later to support
+ * non-verbs devices that do not plug into the kernel APIs
+ */
+struct urdma_device {
+	struct urdma_driver	*drv;
+	struct rw_semaphore	rw_lock;
+	int			flags;
+	int			num_ioctls;
+	struct urdma_ioctl_desc	*ioctl;
+
+	/* Order to cleanup obj_list.  Objects are destroyed from
+	 * obj_list[close_map[0]]..obj_list[close_map[n]]
+	 */
+	int			num_objs;
+	int			*close_map;
+	struct list_head	*obj_lists;
+};
+
+/* use ib_uobject? */
+/* urdma will protect against destroying an object that is in use,
+ * but all locking is pushed down to the drivers.
+ * Keep this structure as small as possible
+ */
+struct urdma_obj {
+	u64			ucontext;
+	void			*kcontext;
+	u32			instance_id;	/* idr index */
+	u16			obj_type;
+	u16			flags;
+	struct urdma_device	*dev;
+	struct list_head	entry;
+	atomic_t		use_cnt;
+	//struct kref		ref;
+	//struct rw_semaphore	mutex;
+};
+
+struct urdma_map {
+	struct idr		idr;
+	struct mutex		lock;
+};
+
+
+#endif /* RDMA_UAPI_H */
+diff --git a/drivers/infiniband/core/urdma.c b/drivers/infiniband/core/urdma.c
new file mode 100644
index 0000000..bd84eb9
--- /dev/null
+++ b/drivers/infiniband/core/urdma.c
@@ -0,0 +1,373 @@
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
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <uapi/rdma/rdma_ioctl.h>
+#include <rdma/rdma_uapi.h>
+
+#include "uverbs.h"
+
+
+static long urdma_query_device(struct urdma_device *dev, void *data,
+			       void *file_data)
+{
+	return -ENOSYS;
+}
+
+/* shared ioctl function dispatch table, usable by all verbs devices */
+const struct urdma_ioctl_desc verbs_ioctl[URDMA_MAX_BASE] = {
+	URDMA_DESC(DEVICE, QUERY, urdma_query_device, 0),
+//	URDMA_DESC(DEVICE, OPEN, urdma_open_device, URDMA_EVENT),
+	/* we could also assume exclusive access for modify/close operations */
+//	URDMA_DESC(DEVICE, CLOSE, urdma_close_device, URDMA_EXCL),
+//	URDMA_DESC(DEVICE, MODIFY, urdma_modify_device, URDMA_EXCL),
+//	URDMA_DESC(CQ, QUERY, urdma_query_cq, 0),
+//	URDMA_DESC(CQ, OPEN, urdma_open_cq, URDMA_EVENT),
+//	URDMA_DESC(CQ, CLOSE, urdma_close_cq, URDMA_EXCL),
+//	URDMA_DESC(CQ, MODIFY, urdma_modify_cq, URDMA_EXCL),
+	/* ... yadda yadda yadda */
+};
+EXPORT_SYMBOL(verbs_ioctl);
+
+
+/* Map instance id's to object structures.
+ * We can define per object/device/driver maps if needed for better
+ * parallelism, but use one for now.
+ */
+struct urdma_map map = { IDR_INIT(map.idr),
+			 __MUTEX_INITIALIZER(map.lock) };
+
+
+static struct urdma_obj * urdma_get_obj(struct idr *idr, struct urdma_device *dev,
+					struct urdma_obj_id *id, bool excl)
+{
+	struct urdma_obj *obj;
+
+	if (id->resv)
+		return ERR_PTR(-EINVAL);
+
+	obj = idr_find(idr, id->instance_id);
+	if (!obj || obj->dev != dev || obj->obj_type != id->obj_type)
+		return ERR_PTR(-ENOENT);
+	else if (obj->flags & URDMA_EXCL || (excl && atomic_read(&obj->use_cnt)))
+		return ERR_PTR(-EBUSY);
+
+	if (excl)
+		obj->flags |= URDMA_EXCL;
+	atomic_inc(&obj->use_cnt);
+	return obj;
+}
+
+static void urdma_put_obj(struct urdma_obj *obj)
+{
+	if (obj->flags & URDMA_EXCL)
+		obj->flags &= ~URDMA_EXCL;
+	atomic_dec(&obj->use_cnt);
+}
+
+static void urdma_unmap_obj(struct urdma_ioctl *ioctl, int index)
+{
+	struct urdma_obj *obj;
+
+	obj = ioctl->obj[index];
+	ioctl->obj_id[index].instance_id = obj->instance_id;
+	ioctl->obj_id[index].obj_type = obj->obj_type;
+	ioctl->obj_id[index].resv = 0;
+	urdma_put_obj(obj);
+}
+
+static void urdma_unmap_objs(struct urdma_device *dev, struct urdma_ioctl *ioctl)
+{
+	int i;
+
+	for (i = 0; i < ioctl->count; i++)
+		urdma_unmap_obj(ioctl, i);
+}
+
+static long urdma_map_objs(struct urdma_device *dev,
+			   struct urdma_ioctl *ioctl, bool excl)
+{
+	struct urdma_obj *obj;
+	int i;
+
+	mutex_lock(&map.lock);
+	for (i = 0; i < ioctl->count; i++) {
+		obj = urdma_get_obj(&map.idr, dev, &ioctl->obj_id[i],
+				    excl && i == 0);
+		if (IS_ERR(obj))
+			goto err;
+
+		ioctl->obj[i] = obj;
+	}
+	mutex_unlock(&map.lock);
+	return 0;
+err:
+	while (i--)
+		urdma_unmap_obj(ioctl, i);
+	return PTR_ERR(obj);
+}
+
+/* process driver specific ioctl
+ * driver ioctl's follow more conventional ioctl format
+ */
+long urdma_driver_ioctl(struct ib_uverbs_file *file_data, unsigned int cmd,
+			unsigned long arg)
+{
+	struct urdma_device *dev /*= file_data->dev*/;
+	struct urdma_driver *drv = dev->drv;
+	struct urdma_ioctl_desc *desc;
+	char stack_data[128], *data;
+	u16 size;
+	int offset;
+	long ret;
+
+	offset = URDMA_OP(cmd);
+	if (offset >= drv->num_ioctls || !drv->ioctl[offset].func)
+		return -EINVAL;
+
+	desc = &drv->ioctl[offset];
+	size = _IOC_SIZE(desc->cmd);
+	if (size > sizeof(stack_data)) {
+		data = kmalloc(size, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+	} else {
+		data = stack_data;
+	}
+
+	if (desc->cmd & IOC_IN) {
+		if (copy_from_user(data, (void __user *) arg, size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	} else if (desc->cmd & IOC_OUT) {
+		memset(data, 0, size);
+	}
+
+	/* data is in/out parameter */
+	ret = desc->func(dev, data, file_data);
+
+	if (desc->cmd & IOC_OUT) {
+		if (copy_to_user((void __user *) arg, data, size))
+			ret = -EFAULT;
+	}
+out:
+	if (data != stack_data)
+		kfree(data);
+	return ret;
+}
+
+static long urdma_pre_common(struct urdma_device *dev, struct urdma_ioctl *ioctl,
+			     struct urdma_ioctl_desc *desc, void *file_data)
+{
+	down_read(&dev->rw_lock);
+	if (dev->flags & URDMA_CLOSED) {
+		up_read(&dev->rw_lock);
+		return -ENODEV;
+	}
+
+	return urdma_map_objs(dev, ioctl, desc->flags & URDMA_EXCL);
+}
+
+static long urdma_post_common(struct urdma_device *dev, struct urdma_ioctl *ioctl,
+			      struct urdma_ioctl_desc *desc, void *file_data)
+{
+	urdma_unmap_objs(dev, ioctl);
+	up_read(&dev->rw_lock);
+	return 0;
+}
+
+static long urdma_pre_open(struct urdma_device *dev, struct urdma_ioctl *ioctl,
+			   struct urdma_ioctl_desc *desc, void *file_data)
+{
+	struct urdma_obj *obj;
+
+	obj = kzalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	obj->flags = URDMA_EXCL;
+	obj->obj_type = ioctl->domain;
+	atomic_set(&obj->use_cnt, 1);
+
+	mutex_lock(&map.lock);
+	obj->instance_id = idr_alloc(&map.idr, obj, 0, 0, GFP_KERNEL);
+	/* TODO: handle driver objects */
+	if (obj->instance_id >= 0)
+		list_add_tail(&obj->entry, &dev->obj_lists[obj->obj_type]);
+	mutex_unlock(&map.lock);
+
+	if (obj->instance_id < 0) {
+		kfree(obj);
+		return -ENOMEM;
+	}
+
+	/* new object added after input object array */
+	ioctl->obj[ioctl->count++] = obj;
+	return 0;
+}
+
+static long urdma_pre_close(struct urdma_device *dev, struct urdma_ioctl *ioctl,
+			    struct urdma_ioctl_desc *desc, void *file_data)
+{
+	if (ioctl->count != 1)
+		return -EINVAL;
+	return urdma_map_objs(dev, ioctl, desc->flags & URDMA_EXCL);
+}
+
+static long urdma_post_close(struct urdma_device *dev, struct urdma_ioctl *ioctl,
+			     struct urdma_ioctl_desc *desc, void *file_data)
+{
+	struct urdma_obj *obj;
+
+	obj = ioctl->obj[0];
+	ioctl->obj[0] = NULL;
+
+	mutex_lock(&map.lock);
+	idr_remove(&map.idr, obj->instance_id);
+	list_del(&obj->entry);
+	mutex_unlock(&map.lock);
+	kfree(obj);
+	return 0;
+}
+
+const static urdma_ioctl_hook_t urdma_pre_op[URDMA_MAX_OP] = {
+	[URDMA_QUERY] = urdma_pre_common,
+	[URDMA_OPEN] = urdma_pre_open,
+	[URDMA_CLOSE] = urdma_pre_close,
+	[URDMA_MODIFY] = urdma_pre_common,
+	[URDMA_READ] = urdma_pre_common,
+	[URDMA_WRITE]= urdma_pre_common,
+};
+
+const static urdma_ioctl_hook_t urdma_post_op[URDMA_MAX_OP] = {
+	[URDMA_QUERY] = urdma_post_common,
+	[URDMA_OPEN] = urdma_post_common,
+	[URDMA_CLOSE] = urdma_post_close,
+	[URDMA_MODIFY] = urdma_post_common,
+	[URDMA_READ] = urdma_post_common,
+	[URDMA_WRITE]= urdma_post_common,
+};
+
+long urdma_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct urdma_device *dev;
+	struct ib_uverbs_file *file_data;
+	struct urdma_ioctl_desc *desc;
+	struct urdma_ioctl hdr, *data;
+	char stack_data[128];
+	u8 op;
+	int offset;
+	long ret;
+
+	file_data = filp->private_data;
+	/* dev = file_data->dev; */
+
+	if (_IOC_NR(cmd) & URDMA_DRIVER_OP)
+		return urdma_driver_ioctl(file_data, cmd, arg);
+
+	op = URDMA_OP(cmd);
+	if (op > URDMA_MAX_OP || _IOC_SIZE(cmd) < sizeof(hdr))
+		return -EINVAL;
+
+	if (copy_from_user(&hdr, (void __user *) arg, sizeof(hdr)))
+		return -EFAULT;
+
+	offset = URDMA_OFFSET(hdr.domain, op);
+	if (offset >= dev->num_ioctls || !dev->ioctl[offset].func)
+		return -EINVAL;
+
+	desc = &dev->ioctl[offset];
+	if ((sizeof(hdr) + hdr.count * sizeof(hdr.obj_id) > hdr.length) ||
+	    (hdr.length > desc->length))
+		return -EINVAL;
+
+	if (desc->length > sizeof(stack_data)) {
+		data = kmalloc(desc->length, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+	} else {
+		data = (struct urdma_ioctl *) stack_data;
+	}
+
+	if (copy_from_user(data, (void __user *) arg, hdr.length)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (urdma_pre_op[op]) {
+		ret = urdma_pre_op[op](dev, data, desc, file_data);
+		if (ret)
+			goto out;
+	}
+
+	ret = desc->func(dev, data, file_data);
+
+	if (urdma_post_op[op]) {
+		ret = urdma_post_op[op](dev, data, desc, file_data);
+		if (ret)
+			goto out;
+	}
+
+	if (copy_to_user((void __user *) arg, data, data->length))
+		ret = -EFAULT;
+out:
+	if (data != (struct urdma_ioctl *) stack_data)
+		kfree(data);
+	return ret;
+}
+
+static void urdma_close_obj(struct urdma_device *dev, struct urdma_obj *obj)
+{
+	/* kernel initiated close, releaes device resources */
+}
+
+static void urdma_close_dev(struct urdma_device *dev)
+{
+	struct urdma_obj *obj;
+	int i;
+
+	down_write(&dev->rw_lock);
+	dev->flags |= URDMA_CLOSED;
+
+	for (i = 0; i < dev->num_objs; i++) {
+		list_for_each_entry(obj, &dev->obj_lists[dev->close_map[i]], entry) {
+			urdma_close_obj(dev, obj);
+		}
+	}
+	up_write(&dev->rw_lock);
+}
+
-- 
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
