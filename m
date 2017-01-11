From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/core: Declare all common IB types
Date: Wed, 11 Jan 2017 12:53:52 +0200
Message-ID: <1484132033-3346-7-git-send-email-matanb@mellanox.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484132033-3346-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch declares all the required information for creating and
destroying all common IB types. The refactored infrastructure treats
types in a more object oriented way. Each type encapsulates all the
required information for its creation and destruction.

This patch is required in order to transform all currently uverbs_cmd
verbs to initialize and destroy objects using the refactored
infrastructure. These types are used in downstream patches.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile           |   2 +-
 drivers/infiniband/core/uverbs.h           |   3 +
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 212 +++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c      |   6 +-
 include/rdma/uverbs_ioctl_cmd.h            |  68 +++++++++
 5 files changed, 287 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 1819623..7676592 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -29,4 +29,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				rdma_core.o
+				rdma_core.o uverbs_ioctl_cmd.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 6344b80..1940bb9 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -176,6 +176,7 @@ struct ib_ucq_object {
 };
 
 void idr_remove_uobj(struct ib_uobject *uobj);
+extern const struct file_operations uverbs_event_fops;
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					struct ib_device *ib_dev,
@@ -199,6 +200,8 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void ib_uverbs_detach_umcast(struct ib_qp *qp,
+			     struct ib_uqp_object *uobj);
 
 struct ib_uverbs_flow_spec {
 	union {
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
new file mode 100644
index 0000000..c49abf6
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -0,0 +1,212 @@
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
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <linux/bug.h>
+#include <linux/file.h>
+#include "rdma_core.h"
+#include "uverbs.h"
+
+void uverbs_free_ah(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	ib_destroy_ah((struct ib_ah *)uobject->object);
+}
+
+void uverbs_free_flow(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject)
+{
+	ib_destroy_flow((struct ib_flow *)uobject->object);
+}
+
+void uverbs_free_mw(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	uverbs_dealloc_mw((struct ib_mw *)uobject->object);
+}
+
+void uverbs_free_qp(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
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
+void uverbs_free_rwq_ind_tbl(const struct uverbs_type_alloc_action *type_alloc_action,
+			     struct ib_uobject *uobject)
+{
+	struct ib_rwq_ind_table *rwq_ind_tbl = uobject->object;
+	struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
+
+	ib_destroy_rwq_ind_table(rwq_ind_tbl);
+	kfree(ind_tbl);
+}
+
+void uverbs_free_wq(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	struct ib_wq *wq = uobject->object;
+	struct ib_uwq_object *uwq =
+		container_of(uobject, struct ib_uwq_object, uevent.uobject);
+
+	ib_destroy_wq(wq);
+	ib_uverbs_release_uevent(uobject->context->ufile, &uwq->uevent);
+}
+
+void uverbs_free_srq(const struct uverbs_type_alloc_action *type_alloc_action,
+		     struct ib_uobject *uobject)
+{
+	struct ib_srq *srq = uobject->object;
+	struct ib_uevent_object *uevent =
+		container_of(uobject, struct ib_uevent_object, uobject);
+
+	ib_destroy_srq(srq);
+	ib_uverbs_release_uevent(uobject->context->ufile, uevent);
+}
+
+void uverbs_free_cq(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
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
+void uverbs_free_mr(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	ib_dereg_mr((struct ib_mr *)uobject->object);
+}
+
+void uverbs_free_xrcd(const struct uverbs_type_alloc_action *type_alloc_action,
+		      struct ib_uobject *uobject)
+{
+	struct ib_xrcd *xrcd = uobject->object;
+
+	mutex_lock(&uobject->context->ufile->device->xrcd_tree_mutex);
+	ib_uverbs_dealloc_xrcd(uobject->context->ufile->device, xrcd);
+	mutex_unlock(&uobject->context->ufile->device->xrcd_tree_mutex);
+}
+
+void uverbs_free_pd(const struct uverbs_type_alloc_action *type_alloc_action,
+		    struct ib_uobject *uobject)
+{
+	ib_dealloc_pd((struct ib_pd *)uobject->object);
+}
+
+void uverbs_free_event_file(const struct uverbs_type_alloc_action *type_alloc_action,
+			    struct ib_uobject *uobject)
+{
+	struct ib_uverbs_event_file *event_file = (void *)(uobject + 1);
+
+	spin_lock_irq(&event_file->lock);
+	event_file->is_closed = 1;
+	spin_unlock_irq(&event_file->lock);
+
+	wake_up_interruptible(&event_file->poll_wait);
+	kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
+};
+
+DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
+		    &UVERBS_TYPE_ALLOC_FD(0, sizeof(struct ib_uobject) + sizeof(struct ib_uverbs_event_file),
+					  uverbs_free_event_file,
+					  &uverbs_event_fops,
+					  "[infinibandevent]", O_RDONLY));
+
+DECLARE_UVERBS_TYPE(uverbs_type_cq,
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
+					      uverbs_free_cq));
+
+DECLARE_UVERBS_TYPE(uverbs_type_qp,
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
+					      uverbs_free_qp));
+
+DECLARE_UVERBS_TYPE(uverbs_type_mw,
+		    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_mw));
+
+DECLARE_UVERBS_TYPE(uverbs_type_mr,
+		    /* 1 is used in order to free the MR after all the MWs */
+		    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr));
+
+DECLARE_UVERBS_TYPE(uverbs_type_srq,
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0,
+					      uverbs_free_srq));
+
+DECLARE_UVERBS_TYPE(uverbs_type_ah,
+		    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_ah));
+
+DECLARE_UVERBS_TYPE(uverbs_type_flow,
+		    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_flow));
+
+DECLARE_UVERBS_TYPE(uverbs_type_wq,
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0,
+					      uverbs_free_wq));
+
+DECLARE_UVERBS_TYPE(uverbs_type_rwq_ind_table,
+		    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_rwq_ind_tbl));
+
+DECLARE_UVERBS_TYPE(uverbs_type_xrcd,
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0,
+					      uverbs_free_xrcd));
+
+DECLARE_UVERBS_TYPE(uverbs_type_pd,
+		    /* 2 is used in order to free the PD after MRs */
+		    &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
+
+DECLARE_UVERBS_TYPES(uverbs_common_types,
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_PD, uverbs_type_pd),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_MR, uverbs_type_mr),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_COMP_CHANNEL, uverbs_type_comp_channel),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_CQ, uverbs_type_cq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_QP, uverbs_type_qp),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_AH, uverbs_type_ah),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_MW, uverbs_type_mw),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_SRQ, uverbs_type_srq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_FLOW, uverbs_type_flow),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_WQ, uverbs_type_wq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_RWQ_IND_TBL,
+				     uverbs_type_rwq_ind_table),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_XRCD, uverbs_type_xrcd),
+);
+EXPORT_SYMBOL(uverbs_common_types);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 6e38a7c..75c30d9 100644
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
 
@@ -477,7 +477,7 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static const struct file_operations uverbs_event_fops = {
+const struct file_operations uverbs_event_fops = {
 	.owner	 = THIS_MODULE,
 	.read	 = ib_uverbs_event_read,
 	.poll    = ib_uverbs_event_poll,
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
new file mode 100644
index 0000000..bab280c
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
+enum uverbs_common_types {
+	UVERBS_TYPE_PD,
+	UVERBS_TYPE_COMP_CHANNEL,
+	UVERBS_TYPE_CQ,
+	UVERBS_TYPE_QP,
+	UVERBS_TYPE_SRQ,
+	UVERBS_TYPE_AH,
+	UVERBS_TYPE_MR,
+	UVERBS_TYPE_MW,
+	UVERBS_TYPE_FLOW,
+	UVERBS_TYPE_XRCD,
+	UVERBS_TYPE_RWQ_IND_TBL,
+	UVERBS_TYPE_WQ,
+	UVERBS_TYPE_LAST,
+};
+
+extern const struct uverbs_type uverbs_type_cq;
+extern const struct uverbs_type uverbs_type_qp;
+extern const struct uverbs_type uverbs_type_rwq_ind_table;
+extern const struct uverbs_type uverbs_type_wq;
+extern const struct uverbs_type uverbs_type_srq;
+extern const struct uverbs_type uverbs_type_ah;
+extern const struct uverbs_type uverbs_type_flow;
+extern const struct uverbs_type uverbs_type_comp_channel;
+extern const struct uverbs_type uverbs_type_mr;
+extern const struct uverbs_type uverbs_type_mw;
+extern const struct uverbs_type uverbs_type_pd;
+extern const struct uverbs_type uverbs_type_xrcd;
+extern const struct uverbs_type_group uverbs_common_types;
+#endif
+
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
