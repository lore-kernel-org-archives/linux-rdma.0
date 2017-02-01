From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 3/7] IB/core: Add idr based standard types
Date: Wed,  1 Feb 2017 14:39:01 +0200
Message-ID: <1485952745-58476-4-git-send-email-matanb@mellanox.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485952745-58476-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 drivers/infiniband/core/uverbs.h           |   2 +
 drivers/infiniband/core/uverbs_main.c      |   4 +-
 drivers/infiniband/core/uverbs_std_types.c | 165 +++++++++++++++++++++++++++++
 include/rdma/uverbs_std_types.h            |  50 +++++++++
 include/rdma/uverbs_types.h                |  16 +++
 6 files changed, 236 insertions(+), 3 deletions(-)
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
index 662a592..dd8048f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -204,6 +204,8 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj);
 
 struct ib_uverbs_flow_spec {
 	union {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8344afd..ba8b1eb 100644
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
 
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
new file mode 100644
index 0000000..9bbc4eb
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -0,0 +1,165 @@
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
+void uverbs_free_ah(struct ib_uobject *uobject)
+{
+	ib_destroy_ah((struct ib_ah *)uobject->object);
+}
+
+void uverbs_free_flow(struct ib_uobject *uobject)
+{
+	ib_destroy_flow((struct ib_flow *)uobject->object);
+}
+
+void uverbs_free_mw(struct ib_uobject *uobject)
+{
+	uverbs_dealloc_mw((struct ib_mw *)uobject->object);
+}
+
+void uverbs_free_qp(struct ib_uobject *uobject)
+{
+	struct ib_qp *qp = uobject->object;
+	struct ib_uqp_object *uqp =
+		container_of(uobject, struct ib_uqp_object, uevent.uobject);
+
+	if (qp == qp->real_qp)
+		ib_uverbs_detach_umcast(qp, uqp);
+	ib_destroy_qp(qp);
+	ib_uverbs_release_uevent(uobject->context->ufile, &uqp->uevent);
+}
+
+void uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject)
+{
+	struct ib_rwq_ind_table *rwq_ind_tbl = uobject->object;
+	struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
+
+	ib_destroy_rwq_ind_table(rwq_ind_tbl);
+	kfree(ind_tbl);
+}
+
+void uverbs_free_wq(struct ib_uobject *uobject)
+{
+	struct ib_wq *wq = uobject->object;
+	struct ib_uwq_object *uwq =
+		container_of(uobject, struct ib_uwq_object, uevent.uobject);
+
+	ib_destroy_wq(wq);
+	ib_uverbs_release_uevent(uobject->context->ufile, &uwq->uevent);
+}
+
+void uverbs_free_srq(struct ib_uobject *uobject)
+{
+	struct ib_srq *srq = uobject->object;
+	struct ib_uevent_object *uevent =
+		container_of(uobject, struct ib_uevent_object, uobject);
+
+	ib_destroy_srq(srq);
+	ib_uverbs_release_uevent(uobject->context->ufile, uevent);
+}
+
+void uverbs_free_cq(struct ib_uobject *uobject)
+{
+	struct ib_cq *cq = uobject->object;
+	struct ib_uverbs_event_file *ev_file = cq->cq_context;
+	struct ib_ucq_object *ucq =
+		container_of(uobject, struct ib_ucq_object, uobject);
+
+	ib_destroy_cq(cq);
+	ib_uverbs_release_ucq(uobject->context->ufile, ev_file, ucq);
+}
+
+void uverbs_free_mr(struct ib_uobject *uobject)
+{
+	ib_dereg_mr((struct ib_mr *)uobject->object);
+}
+
+void uverbs_free_xrcd(struct ib_uobject *uobject)
+{
+	struct ib_xrcd *xrcd = uobject->object;
+
+	mutex_lock(&uobject->context->ufile->device->xrcd_tree_mutex);
+	ib_uverbs_dealloc_xrcd(uobject->context->ufile->device, xrcd);
+	mutex_unlock(&uobject->context->ufile->device->xrcd_tree_mutex);
+}
+
+void uverbs_free_pd(struct ib_uobject *uobject)
+{
+	ib_dealloc_pd((struct ib_pd *)uobject->object);
+}
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_cq =
+	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
+				 uverbs_free_cq);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_qp =
+	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
+				 uverbs_free_qp);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_mw =
+	UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_mw);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_mr =
+	/* 1 is used in order to free the MR after all the MWs */
+	UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_srq =
+	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0,
+				 uverbs_free_srq);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_ah =
+	UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_ah);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_flow =
+	UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_flow);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_wq =
+	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0,
+				 uverbs_free_wq);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table =
+	UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_rwq_ind_tbl);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd =
+	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0,
+				 uverbs_free_xrcd);
+
+const struct uverbs_obj_idr_type uverbs_type_attrs_pd =
+	/* 2 is used in order to free the PD after MRs */
+	UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd);
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
index bb263f0..cdbf352 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -101,4 +101,20 @@ struct uverbs_obj_idr_type {
 	void (*hot_unplug)(struct ib_uobject *uobj);
 };
 
+extern const struct uverbs_obj_type_ops uverbs_idr_ops;
+
+#define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
+				   sizeof(char))
+#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order, _hot_unplug)		\
+	 {.type = {							\
+		.destroy_order = _order,				\
+		.ops = &uverbs_idr_ops,					\
+	 },								\
+	 .hot_unplug = _hot_unplug,					\
+	 .obj_size = (_size) +						\
+		UVERBS_BUILD_BUG_ON((_size) < sizeof(struct		\
+						     ib_uobject))}
+#define UVERBS_TYPE_ALLOC_IDR(_order, _hot_unplug)			\
+	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order,	\
+				  _hot_unplug)
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
