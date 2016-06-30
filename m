From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 3/8] RDMA/core: Refactor IDR to be per-device
Date: Thu, 30 Jun 2016 16:39:26 +0300
Message-ID: <1467293971-25688-4-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The current code creates an IDR per type. Since types are currently
common for all drivers and known in advance, this was good enough.
However, the proposed ioctl based infrastructure allows each driver
to declare only some of the common types and declare its own specific
types.

Thus, we decided to implement IDR to be per device and refactor it to
use a new file.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile      |   2 +-
 drivers/infiniband/core/device.c      |  22 ++++
 drivers/infiniband/core/uidr.c        | 165 ++++++++++++++++++++++++++
 drivers/infiniband/core/uidr.h        |  55 +++++++++
 drivers/infiniband/core/uobject.c     |   1 +
 drivers/infiniband/core/uverbs.h      |  13 ---
 drivers/infiniband/core/uverbs_cmd.c  | 212 +++++++---------------------------
 drivers/infiniband/core/uverbs_main.c |  37 ++----
 include/rdma/ib_verbs.h               |   4 +
 9 files changed, 299 insertions(+), 212 deletions(-)
 create mode 100644 drivers/infiniband/core/uidr.c
 create mode 100644 drivers/infiniband/core/uidr.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 68190b4..c8bf8de 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				uobject.o
+				uidr.o uobject.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5516fb0..e0211d74 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -44,6 +44,7 @@
 #include <rdma/ib_cache.h>
 
 #include "core_priv.h"
+#include "uidr.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("core kernel InfiniBand API");
@@ -311,6 +312,18 @@ static int read_port_immutable(struct ib_device *device)
 	return 0;
 }
 
+static int ib_device_allocate_idrs(struct ib_device *device)
+{
+	spin_lock_init(&device->idr_lock);
+	idr_init(&device->idr);
+	return 0;
+}
+
+static void ib_device_destroy_idrs(struct ib_device *device)
+{
+	idr_destroy(&device->idr);
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -370,6 +383,14 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = ib_device_allocate_idrs(device);
+	if (ret) {
+		pr_warn("Couldn't allocate IDRs device %s with driver model\n",
+			device->name);
+		ib_cache_cleanup_one(device);
+		goto out;
+	}
+
 	device->reg_state = IB_DEV_REGISTERED;
 
 	list_for_each_entry(client, &client_list, list)
@@ -416,6 +437,7 @@ void ib_unregister_device(struct ib_device *device)
 	mutex_unlock(&device_mutex);
 
 	ib_device_unregister_sysfs(device);
+	ib_device_destroy_idrs(device);
 	ib_cache_cleanup_one(device);
 
 	down_write(&lists_rwsem);
diff --git a/drivers/infiniband/core/uidr.c b/drivers/infiniband/core/uidr.c
new file mode 100644
index 0000000..1acdf64
--- /dev/null
+++ b/drivers/infiniband/core/uidr.c
@@ -0,0 +1,165 @@
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
+#include <rdma/ib_verbs.h>
+#include "uidr.h"
+#include "uobject.h"
+
+int idr_add_uobj(struct ib_uobject *uobj)
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
+void idr_remove_uobj(struct ib_uobject *uobj)
+{
+	spin_lock(&uobj->context->device->idr_lock);
+	idr_remove(&uobj->context->device->idr, uobj->id);
+	spin_unlock(&uobj->context->device->idr_lock);
+}
+
+static struct ib_uobject *__idr_get_uobj(int id, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	rcu_read_lock();
+	uobj = idr_find(&context->device->idr, id);
+	if (uobj) {
+		if (uobj->context == context)
+			kref_get(&uobj->ref);
+		else
+			uobj = NULL;
+	}
+	rcu_read_unlock();
+
+	return uobj;
+}
+
+static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *context,
+					int nested)
+{
+	struct ib_uobject *uobj;
+
+	uobj = __idr_get_uobj(id, context);
+	if (!uobj)
+		return NULL;
+
+	if (nested)
+		down_read_nested(&uobj->mutex, SINGLE_DEPTH_NESTING);
+	else
+		down_read(&uobj->mutex);
+	if (!uobj->live) {
+		put_uobj_read(uobj);
+		return NULL;
+	}
+
+	return uobj;
+}
+
+struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = __idr_get_uobj(id, context);
+	if (!uobj)
+		return NULL;
+
+	down_write(&uobj->mutex);
+	if (!uobj->live) {
+		put_uobj_write(uobj);
+		return NULL;
+	}
+
+	return uobj;
+}
+
+static void *idr_read_obj(int id, struct ib_ucontext *context,
+			  int nested)
+{
+	struct ib_uobject *uobj;
+
+	uobj = idr_read_uobj(id, context, nested);
+	return uobj ? uobj->object : NULL;
+}
+
+struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(pd_handle, context, 0);
+}
+
+struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context,
+			  int nested)
+{
+	return idr_read_obj(cq_handle, context, nested);
+}
+
+struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(ah_handle, context, 0);
+}
+
+struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(qp_handle, context, 0);
+}
+
+struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = idr_write_uobj(qp_handle, context);
+	return uobj ? uobj->object : NULL;
+}
+
+struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(srq_handle, context, 0);
+}
+
+struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+			      struct ib_uobject **uobj)
+{
+	*uobj = idr_read_uobj(xrcd_handle, context, 0);
+	return *uobj ? (*uobj)->object : NULL;
+}
+
diff --git a/drivers/infiniband/core/uidr.h b/drivers/infiniband/core/uidr.h
new file mode 100644
index 0000000..581b394
--- /dev/null
+++ b/drivers/infiniband/core/uidr.h
@@ -0,0 +1,55 @@
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
+#ifndef UIDR_H
+#define UIDR_H
+
+#include <linux/idr.h>
+
+int idr_add_uobj(struct ib_uobject *uobj);
+void idr_remove_uobj(struct ib_uobject *uobj);
+struct ib_uobject *idr_write_uobj(int id, struct ib_ucontext *context);
+
+struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context);
+struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context,
+			  int nested);
+struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context);
+struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context);
+struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context);
+struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context);
+struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+			      struct ib_uobject **uobj);
+#endif /* UIDR_H */
diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
index 55138ea..86f6460 100644
--- a/drivers/infiniband/core/uobject.c
+++ b/drivers/infiniband/core/uobject.c
@@ -33,6 +33,7 @@
 #include <rdma/ib_verbs.h>
 
 #include "uobject.h"
+#include "uidr.h"
 
 /*
  * The ib_uobject locking scheme is as follows:
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..11bad7a 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -171,19 +171,6 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
-extern spinlock_t ib_uverbs_idr_lock;
-extern struct idr ib_uverbs_pd_idr;
-extern struct idr ib_uverbs_mr_idr;
-extern struct idr ib_uverbs_mw_idr;
-extern struct idr ib_uverbs_ah_idr;
-extern struct idr ib_uverbs_cq_idr;
-extern struct idr ib_uverbs_qp_idr;
-extern struct idr ib_uverbs_srq_idr;
-extern struct idr ib_uverbs_xrcd_idr;
-extern struct idr ib_uverbs_rule_idr;
-
-void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
-
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
 					int is_async);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index fd7e320..22406fe 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -41,7 +41,9 @@
 #include <asm/uaccess.h>
 
 #include "uverbs.h"
+#include "uidr.h"
 #include "uobject.h"
+
 #include "core_priv.h"
 
 static struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
@@ -54,136 +56,6 @@ static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
 
-static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
-{
-	int ret;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&ib_uverbs_idr_lock);
-
-	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		uobj->id = ret;
-
-	spin_unlock(&ib_uverbs_idr_lock);
-	idr_preload_end();
-
-	return ret < 0 ? ret : 0;
-}
-
-void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
-{
-	spin_lock(&ib_uverbs_idr_lock);
-	idr_remove(idr, uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
-}
-
-static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	rcu_read_lock();
-	uobj = idr_find(idr, id);
-	if (uobj) {
-		if (uobj->context == context)
-			kref_get(&uobj->ref);
-		else
-			uobj = NULL;
-	}
-	rcu_read_unlock();
-
-	return uobj;
-}
-
-static struct ib_uobject *idr_read_uobj(struct idr *idr, int id,
-					struct ib_ucontext *context, int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(idr, id, context);
-	if (!uobj)
-		return NULL;
-
-	if (nested)
-		down_read_nested(&uobj->mutex, SINGLE_DEPTH_NESTING);
-	else
-		down_read(&uobj->mutex);
-	if (!uobj->live) {
-		put_uobj_read(uobj);
-		return NULL;
-	}
-
-	return uobj;
-}
-
-static struct ib_uobject *idr_write_uobj(struct idr *idr, int id,
-					 struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = __idr_get_uobj(idr, id, context);
-	if (!uobj)
-		return NULL;
-
-	down_write(&uobj->mutex);
-	if (!uobj->live) {
-		put_uobj_write(uobj);
-		return NULL;
-	}
-
-	return uobj;
-}
-
-static void *idr_read_obj(struct idr *idr, int id, struct ib_ucontext *context,
-			  int nested)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_read_uobj(idr, id, context, nested);
-	return uobj ? uobj->object : NULL;
-}
-
-static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
-}
-
-static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
-{
-	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
-}
-
-static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
-}
-
-static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
-}
-
-static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
-{
-	struct ib_uobject *uobj;
-
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
-	return uobj ? uobj->object : NULL;
-}
-
-static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
-{
-	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
-}
-
-static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
-				     struct ib_uobject **uobj)
-{
-	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
-	return *uobj ? (*uobj)->object : NULL;
-}
-
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -451,7 +323,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
-	ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_idr;
 
@@ -475,7 +347,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_idr:
 	ib_dealloc_pd(pd);
@@ -498,7 +370,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_pd_idr, cmd.pd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	pd = uobj->object;
@@ -516,7 +388,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -692,7 +564,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
-	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_idr;
 
@@ -736,7 +608,7 @@ err_copy:
 	}
 
 err_insert_xrcd:
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_idr:
 	ib_dealloc_xrcd(xrcd);
@@ -770,7 +642,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
-	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.xrcd_handle, file->ucontext);
 	if (!uobj) {
 		ret = -EINVAL;
 		goto out;
@@ -803,7 +675,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	if (inode && !live)
 		xrcd_table_delete(file->device, inode);
 
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	idr_remove_uobj(uobj);
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
@@ -896,7 +768,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mr;
-	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unreg;
 
@@ -924,7 +796,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unreg:
 	ib_dereg_mr(mr);
@@ -969,8 +841,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	     (cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK)))
 			return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 
 	if (!uobj)
 		return -EINVAL;
@@ -1039,7 +910,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mr_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1054,7 +925,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1114,7 +985,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 
 	uobj->object = mw;
-	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_unalloc;
 
@@ -1141,7 +1012,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_unalloc:
 	uverbs_dealloc_mw(mw);
@@ -1167,7 +1038,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.mw_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
@@ -1182,7 +1053,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1296,7 +1167,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-	ret = idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	ret = idr_add_uobj(&obj->uobject);
 	if (ret)
 		goto err_free;
 
@@ -1322,7 +1193,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	return obj;
 
 err_cb:
-	idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
+	idr_remove_uobj(&obj->uobject);
 
 err_free:
 	ib_destroy_cq(cq);
@@ -1592,7 +1463,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	cq      = uobj->object;
@@ -1608,7 +1479,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -1779,7 +1650,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -1825,7 +1696,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	return 0;
 err_cb:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2009,7 +1880,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
-	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -2038,7 +1909,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	return in_len;
 
 err_remove:
-	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_qp(qp);
@@ -2278,7 +2149,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 
-	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
@@ -2301,7 +2172,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
-	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -2753,7 +2624,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
-	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
+	ret = idr_add_uobj(uobj);
 	if (ret)
 		goto err_destroy;
 
@@ -2778,7 +2649,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 err_destroy:
 	ib_destroy_ah(ah);
@@ -2803,7 +2674,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_ah_idr, cmd.ah_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.ah_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
@@ -2817,7 +2688,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3085,7 +2956,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
-	err = idr_add_uobj(&ib_uverbs_rule_idr, uobj);
+	err = idr_add_uobj(uobj);
 	if (err)
 		goto destroy_flow;
 
@@ -3110,7 +2981,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
 err_free:
@@ -3145,8 +3016,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
-			      file->ucontext);
+	uobj = idr_write_uobj(cmd.flow_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
@@ -3157,7 +3027,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 
 	put_uobj_write(uobj);
 
-	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
@@ -3245,7 +3115,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	ret = idr_add_uobj(&obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
@@ -3279,7 +3149,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
+	idr_remove_uobj(&obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
@@ -3455,7 +3325,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
+	uobj = idr_write_uobj(cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 	srq = uobj->object;
@@ -3476,7 +3346,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 		atomic_dec(&us->uxrcd->refcnt);
 	}
 
-	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+	idr_remove_uobj(uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 31f422a..5dce312 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "uidr.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -66,17 +67,6 @@ enum {
 
 static struct class *uverbs_class;
 
-DEFINE_SPINLOCK(ib_uverbs_idr_lock);
-DEFINE_IDR(ib_uverbs_pd_idr);
-DEFINE_IDR(ib_uverbs_mr_idr);
-DEFINE_IDR(ib_uverbs_mw_idr);
-DEFINE_IDR(ib_uverbs_ah_idr);
-DEFINE_IDR(ib_uverbs_cq_idr);
-DEFINE_IDR(ib_uverbs_qp_idr);
-DEFINE_IDR(ib_uverbs_srq_idr);
-DEFINE_IDR(ib_uverbs_xrcd_idr);
-DEFINE_IDR(ib_uverbs_rule_idr);
-
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
@@ -227,7 +217,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
 	}
@@ -236,7 +226,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+		idr_remove_uobj(uobj);
 		uverbs_dealloc_mw(mw);
 		kfree(uobj);
 	}
@@ -244,7 +234,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
 	}
@@ -254,7 +244,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uqp_object *uqp =
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
-		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
+		idr_remove_uobj(uobj);
 		if (qp != qp->real_qp) {
 			ib_close_qp(qp);
 		} else {
@@ -270,7 +260,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
@@ -282,7 +272,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
@@ -291,7 +281,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
 	}
@@ -302,7 +292,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uxrcd_object *uxrcd =
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
-		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_uverbs_dealloc_xrcd(file->device, xrcd);
 		kfree(uxrcd);
 	}
@@ -311,7 +301,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
-		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
+		idr_remove_uobj(uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
@@ -1326,13 +1316,6 @@ static void __exit ib_uverbs_cleanup(void)
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
 	if (overflow_maj)
 		unregister_chrdev_region(overflow_maj, IB_UVERBS_MAX_DEVICES);
-	idr_destroy(&ib_uverbs_pd_idr);
-	idr_destroy(&ib_uverbs_mr_idr);
-	idr_destroy(&ib_uverbs_mw_idr);
-	idr_destroy(&ib_uverbs_ah_idr);
-	idr_destroy(&ib_uverbs_cq_idr);
-	idr_destroy(&ib_uverbs_qp_idr);
-	idr_destroy(&ib_uverbs_srq_idr);
 }
 
 module_init(ib_uverbs_init);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 432bed5..14bfe3b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1706,6 +1706,10 @@ struct ib_device {
 
 	struct iw_cm_verbs	     *iwcm;
 
+	struct idr		idr;
+	/* Global lock in use to safely release device IDR */
+	spinlock_t		idr_lock;
+
 	/**
 	 * alloc_hw_stats - Allocate a struct rdma_hw_stats and fill in the
 	 *   driver initialized data.  The struct is kfree()'ed by the sysfs
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
