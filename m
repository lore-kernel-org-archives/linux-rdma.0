From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 3/7] IB/core: Add idr based standard types
Date: Sun, 19 Mar 2017 17:59:01 +0200
Message-ID: <1489939145-125246-4-git-send-email-matanb@mellanox.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the standard idr based types. These types are
used in downstream patches in order to initialize, destroy and
lookup IB standard objects which are based on idr objects.

An idr object requires filling out several parameters. Its op pointer
should point to uverbs_idr_ops and its size should be at least the
size of ib_uobject. We add a macro to make the type declaration easier.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile           |   2 +-
 drivers/infiniband/core/uverbs.h           |   5 +-
 drivers/infiniband/core/uverbs_cmd.c       |  16 +-
 drivers/infiniband/core/uverbs_main.c      |   8 +-
 drivers/infiniband/core/uverbs_std_types.c | 244 +++++++++++++++++++++++++++++
 include/rdma/uverbs_std_types.h            |  50 ++++++
 include/rdma/uverbs_types.h                |  14 ++
 7 files changed, 329 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types.c
 create mode 100644 include/rdma/uverbs_std_types.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 1819623..c336d9c 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				rdma_core.o
+				rdma_core.o uverbs_std_types.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 662a592..f09b39e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -201,9 +201,12 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
-void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
+int ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd,
+			   enum rdma_remove_reason why);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj);
 
 struct ib_uverbs_flow_spec {
 	union {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 29c621d..3d651f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -939,19 +939,25 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	return ret;
 }
 
-void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
-			    struct ib_xrcd *xrcd)
+int ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
+			   struct ib_xrcd *xrcd,
+			   enum rdma_remove_reason why)
 {
 	struct inode *inode;
+	int ret;
 
 	inode = xrcd->inode;
 	if (inode && !atomic_dec_and_test(&xrcd->usecnt))
-		return;
+		return 0;
 
-	ib_dealloc_xrcd(xrcd);
+	ret = ib_dealloc_xrcd(xrcd);
 
-	if (inode)
+	if (why == RDMA_REMOVE_DESTROY && ret)
+		atomic_inc(&xrcd->usecnt);
+	else if (inode)
 		xrcd_table_delete(dev, inode);
+
+	return ret;
 }
 
 ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8344afd..2e9047a 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -200,8 +200,8 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 	spin_unlock_irq(&file->async_file->lock);
 }
 
-static void ib_uverbs_detach_umcast(struct ib_qp *qp,
-				    struct ib_uqp_object *uobj)
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj)
 {
 	struct ib_uverbs_mcast_entry *mcast, *tmp;
 
@@ -316,7 +316,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
 		idr_remove_uobj(uobj);
-		ib_uverbs_dealloc_xrcd(file->device, xrcd);
+		ib_uverbs_dealloc_xrcd(file->device, xrcd,
+				       file->ucontext ? RDMA_REMOVE_CLOSE :
+				       RDMA_REMOVE_DRIVER_REMOVE);
 		kfree(uxrcd);
 	}
 	mutex_unlock(&file->device->xrcd_tree_mutex);
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
new file mode 100644
index 0000000..a514556
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -0,0 +1,244 @@
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
+#include <rdma/uverbs_std_types.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <linux/bug.h>
+#include <linux/file.h>
+#include "rdma_core.h"
+#include "uverbs.h"
+
+int uverbs_free_ah(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	return ib_destroy_ah((struct ib_ah *)uobject->object);
+}
+
+int uverbs_free_flow(struct ib_uobject *uobject,
+		     enum rdma_remove_reason why)
+{
+	return ib_destroy_flow((struct ib_flow *)uobject->object);
+}
+
+int uverbs_free_mw(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	return uverbs_dealloc_mw((struct ib_mw *)uobject->object);
+}
+
+int uverbs_free_qp(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	struct ib_qp *qp = uobject->object;
+	struct ib_uqp_object *uqp =
+		container_of(uobject, struct ib_uqp_object, uevent.uobject);
+	int ret;
+
+	if (why == RDMA_REMOVE_DESTROY) {
+		if (!list_empty(&uqp->mcast_list))
+			return -EBUSY;
+	} else if (qp == qp->real_qp) {
+		ib_uverbs_detach_umcast(qp, uqp);
+	}
+
+	ret = ib_destroy_qp(qp);
+	if (ret && why == RDMA_REMOVE_DESTROY)
+		return ret;
+
+	if (uqp->uxrcd)
+		atomic_dec(&uqp->uxrcd->refcnt);
+
+	ib_uverbs_release_uevent(uobject->context->ufile, &uqp->uevent);
+	return ret;
+}
+
+int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
+			    enum rdma_remove_reason why)
+{
+	struct ib_rwq_ind_table *rwq_ind_tbl = uobject->object;
+	struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
+	int ret;
+
+	ret = ib_destroy_rwq_ind_table(rwq_ind_tbl);
+	if (!ret || why != RDMA_REMOVE_DESTROY)
+		kfree(ind_tbl);
+	return ret;
+}
+
+int uverbs_free_wq(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	struct ib_wq *wq = uobject->object;
+	struct ib_uwq_object *uwq =
+		container_of(uobject, struct ib_uwq_object, uevent.uobject);
+	int ret;
+
+	ret = ib_destroy_wq(wq);
+	if (!ret || why != RDMA_REMOVE_DESTROY)
+		ib_uverbs_release_uevent(uobject->context->ufile, &uwq->uevent);
+	return ret;
+}
+
+int uverbs_free_srq(struct ib_uobject *uobject,
+		    enum rdma_remove_reason why)
+{
+	struct ib_srq *srq = uobject->object;
+	struct ib_uevent_object *uevent =
+		container_of(uobject, struct ib_uevent_object, uobject);
+	enum ib_srq_type  srq_type = srq->srq_type;
+	int ret;
+
+	ret = ib_destroy_srq(srq);
+
+	if (ret && why == RDMA_REMOVE_DESTROY)
+		return ret;
+
+	if (srq_type == IB_SRQT_XRC) {
+		struct ib_usrq_object *us =
+			container_of(uevent, struct ib_usrq_object, uevent);
+
+		atomic_dec(&us->uxrcd->refcnt);
+	}
+
+	ib_uverbs_release_uevent(uobject->context->ufile, uevent);
+	return ret;
+}
+
+int uverbs_free_cq(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	struct ib_cq *cq = uobject->object;
+	struct ib_uverbs_event_file *ev_file = cq->cq_context;
+	struct ib_ucq_object *ucq =
+		container_of(uobject, struct ib_ucq_object, uobject);
+	int ret;
+
+	ret = ib_destroy_cq(cq);
+	if (!ret || why != RDMA_REMOVE_DESTROY)
+		ib_uverbs_release_ucq(uobject->context->ufile, ev_file, ucq);
+	return ret;
+}
+
+int uverbs_free_mr(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	return ib_dereg_mr((struct ib_mr *)uobject->object);
+}
+
+int uverbs_free_xrcd(struct ib_uobject *uobject,
+		     enum rdma_remove_reason why)
+{
+	struct ib_xrcd *xrcd = uobject->object;
+	struct ib_uxrcd_object *uxrcd =
+		container_of(uobject, struct ib_uxrcd_object, uobject);
+	int ret;
+
+	mutex_lock(&uobject->context->ufile->device->xrcd_tree_mutex);
+	if (why == RDMA_REMOVE_DESTROY && atomic_read(&uxrcd->refcnt))
+		ret = -EBUSY;
+	else
+		ret = ib_uverbs_dealloc_xrcd(uobject->context->ufile->device,
+					     xrcd, why);
+	mutex_unlock(&uobject->context->ufile->device->xrcd_tree_mutex);
+
+	return ret;
+}
+
+int uverbs_free_pd(struct ib_uobject *uobject,
+		   enum rdma_remove_reason why)
+{
+	struct ib_pd *pd = uobject->object;
+
+	if (why == RDMA_REMOVE_DESTROY && atomic_read(&pd->usecnt))
+		return -EBUSY;
+
+	ib_dealloc_pd((struct ib_pd *)uobject->object);
+	return 0;
+}
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
+	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0),
+	.destroy_object = uverbs_free_cq,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_qp = {
+	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0),
+	.destroy_object = uverbs_free_qp,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_mw = {
+	.type = UVERBS_TYPE_ALLOC_IDR(0),
+	.destroy_object = uverbs_free_mw,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_mr = {
+	/* 1 is used in order to free the MR after all the MWs */
+	.type = UVERBS_TYPE_ALLOC_IDR(1),
+	.destroy_object = uverbs_free_mr,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_srq = {
+	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0),
+	.destroy_object = uverbs_free_srq,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_ah = {
+	.type = UVERBS_TYPE_ALLOC_IDR(0),
+	.destroy_object = uverbs_free_ah,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_flow = {
+	.type = UVERBS_TYPE_ALLOC_IDR(0),
+	.destroy_object = uverbs_free_flow,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_wq = {
+	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0),
+	.destroy_object = uverbs_free_wq,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table = {
+	.type = UVERBS_TYPE_ALLOC_IDR(0),
+	.destroy_object = uverbs_free_rwq_ind_tbl,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd = {
+	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0),
+	.destroy_object = uverbs_free_xrcd,
+};
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_pd = {
+	/* 2 is used in order to free the PD after MRs */
+	.type = UVERBS_TYPE_ALLOC_IDR(2),
+	.destroy_object = uverbs_free_pd,
+};
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
new file mode 100644
index 0000000..2edb776
--- /dev/null
+++ b/include/rdma/uverbs_std_types.h
@@ -0,0 +1,50 @@
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
+#ifndef _UVERBS_STD_TYPES__
+#define _UVERBS_STD_TYPES__
+
+#include <rdma/uverbs_types.h>
+
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_cq;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_qp;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_wq;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_srq;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_ah;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_flow;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_mr;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_mw;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_pd;
+extern const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd;
+#endif
+
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index 5d89e2b..93a3bcb 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -130,4 +130,18 @@ struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
 int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj);
 int rdma_alloc_commit_uobject(struct ib_uobject *uobj);
 
+extern const struct uverbs_obj_type_class uverbs_idr_class;
+
+#define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
+				   sizeof(char))
+#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order)				\
+	{								\
+		.destroy_order = _order,				\
+		.type_class = &uverbs_idr_class,			\
+		.obj_size = (_size) +					\
+			  UVERBS_BUILD_BUG_ON((_size) <			\
+					      sizeof(struct ib_uobject)), \
+	}
+#define UVERBS_TYPE_ALLOC_IDR(_order)					\
+	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order)
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
