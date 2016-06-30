From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 2/8] RDMA/core: Move uobject code to separate files
Date: Thu, 30 Jun 2016 16:39:25 +0300
Message-ID: <1467293971-25688-3-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new proposed infrastructure allows driver's to declare new object
types. Furthermore, uobject management code will be used from both
the old legacy code and the new ioctl infrastructure.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile     |   3 +-
 drivers/infiniband/core/uobject.c    |  95 ++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uobject.h    |  87 ++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c | 101 +----------------------------------
 4 files changed, 185 insertions(+), 101 deletions(-)
 create mode 100644 drivers/infiniband/core/uobject.c
 create mode 100644 drivers/infiniband/core/uobject.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index edaae9f..68190b4 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -28,4 +28,5 @@ ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
 
-ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
+				uobject.o
diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
new file mode 100644
index 0000000..55138ea
--- /dev/null
+++ b/drivers/infiniband/core/uobject.c
@@ -0,0 +1,95 @@
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
+
+#include "uobject.h"
+
+/*
+ * The ib_uobject locking scheme is as follows:
+ *
+ * - uobj->context->device->idr_lock protects the uverbs idrs themselves, so
+ *   it needs to be held during all idr write operations.  When an object is
+ *   looked up, a reference must be taken on the object's kref before
+ *   dropping this lock.  For read operations, the rcu_read_lock()
+ *   and rcu_write_lock() but similarly the kref reference is grabbed
+ *   before the rcu_read_unlock().
+ *
+ * - Each object also has an rwsem.  This rwsem must be held for
+ *   reading while an operation that uses the object is performed.
+ *   For example, while registering an MR, the associated PD's
+ *   uobject.mutex must be held for reading.  The rwsem must be held
+ *   for writing while initializing or destroying an object.
+ *
+ * - In addition, each object has a "live" flag.  If this flag is not
+ *   set, then lookups of the object will fail even if it is found in
+ *   the idr.  This handles a reader that blocks and does not acquire
+ *   the rwsem until after the object is destroyed.  The destroy
+ *   operation will set the live flag to 0 and then drop the rwsem;
+ *   this will allow the reader to acquire the rwsem, see that the
+ *   live flag is 0, and then drop the rwsem and its reference to
+ *   object.  The underlying storage will not be freed until the last
+ *   reference to the object is dropped.
+ */
+
+void init_uobj(struct ib_uobject *uobj, u64 user_handle,
+	       struct ib_ucontext *context, struct uverbs_lock_class *c)
+{
+	uobj->user_handle = user_handle;
+	uobj->context     = context;
+	kref_init(&uobj->ref);
+	init_rwsem(&uobj->mutex);
+	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
+	uobj->live        = 0;
+}
+
+void release_uobj(struct kref *kref)
+{
+	kfree_rcu(container_of(kref, struct ib_uobject, ref), rcu);
+}
+
+void put_uobj(struct ib_uobject *uobj)
+{
+	kref_put(&uobj->ref, release_uobj);
+}
+
+void put_uobj_read(struct ib_uobject *uobj)
+{
+	up_read(&uobj->mutex);
+	put_uobj(uobj);
+}
+
+void put_uobj_write(struct ib_uobject *uobj)
+{
+	up_write(&uobj->mutex);
+	put_uobj(uobj);
+}
diff --git a/drivers/infiniband/core/uobject.h b/drivers/infiniband/core/uobject.h
new file mode 100644
index 0000000..2958ef7
--- /dev/null
+++ b/drivers/infiniband/core/uobject.h
@@ -0,0 +1,87 @@
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
+#ifndef UOBJECT_H
+#define UOBJECT_H
+
+struct uverbs_lock_class {
+	struct lock_class_key	key;
+	char			name[16];
+};
+
+void init_uobj(struct ib_uobject *uobj, u64 user_handle,
+	       struct ib_ucontext *context, struct uverbs_lock_class *c);
+
+void release_uobj(struct kref *kref);
+void put_uobj(struct ib_uobject *uobj);
+void put_uobj_read(struct ib_uobject *uobj);
+void put_uobj_write(struct ib_uobject *uobj);
+
+static inline void put_pd_read(struct ib_pd *pd)
+{
+	put_uobj_read(pd->uobject);
+}
+
+static inline void put_cq_read(struct ib_cq *cq)
+{
+	put_uobj_read(cq->uobject);
+}
+
+static inline void put_ah_read(struct ib_ah *ah)
+{
+	put_uobj_read(ah->uobject);
+}
+
+static inline void put_qp_read(struct ib_qp *qp)
+{
+	put_uobj_read(qp->uobject);
+}
+
+static inline void put_qp_write(struct ib_qp *qp)
+{
+	put_uobj_write(qp->uobject);
+}
+
+static inline void put_srq_read(struct ib_srq *srq)
+{
+	put_uobj_read(srq->uobject);
+}
+
+static inline void put_xrcd_read(struct ib_uobject *uobj)
+{
+	put_uobj_read(uobj);
+}
+#endif /* UIDR_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 1a8babb..fd7e320 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -41,13 +41,9 @@
 #include <asm/uaccess.h>
 
 #include "uverbs.h"
+#include "uobject.h"
 #include "core_priv.h"
 
-struct uverbs_lock_class {
-	struct lock_class_key	key;
-	char			name[16];
-};
-
 static struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
 static struct uverbs_lock_class mr_lock_class	= { .name = "MR-uobj" };
 static struct uverbs_lock_class mw_lock_class	= { .name = "MW-uobj" };
@@ -58,66 +54,6 @@ static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
 
-/*
- * The ib_uobject locking scheme is as follows:
- *
- * - ib_uverbs_idr_lock protects the uverbs idrs themselves, so it
- *   needs to be held during all idr write operations.  When an object is
- *   looked up, a reference must be taken on the object's kref before
- *   dropping this lock.  For read operations, the rcu_read_lock()
- *   and rcu_write_lock() but similarly the kref reference is grabbed
- *   before the rcu_read_unlock().
- *
- * - Each object also has an rwsem.  This rwsem must be held for
- *   reading while an operation that uses the object is performed.
- *   For example, while registering an MR, the associated PD's
- *   uobject.mutex must be held for reading.  The rwsem must be held
- *   for writing while initializing or destroying an object.
- *
- * - In addition, each object has a "live" flag.  If this flag is not
- *   set, then lookups of the object will fail even if it is found in
- *   the idr.  This handles a reader that blocks and does not acquire
- *   the rwsem until after the object is destroyed.  The destroy
- *   operation will set the live flag to 0 and then drop the rwsem;
- *   this will allow the reader to acquire the rwsem, see that the
- *   live flag is 0, and then drop the rwsem and its reference to
- *   object.  The underlying storage will not be freed until the last
- *   reference to the object is dropped.
- */
-
-static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
-		      struct ib_ucontext *context, struct uverbs_lock_class *c)
-{
-	uobj->user_handle = user_handle;
-	uobj->context     = context;
-	kref_init(&uobj->ref);
-	init_rwsem(&uobj->mutex);
-	lockdep_set_class_and_name(&uobj->mutex, &c->key, c->name);
-	uobj->live        = 0;
-}
-
-static void release_uobj(struct kref *kref)
-{
-	kfree_rcu(container_of(kref, struct ib_uobject, ref), rcu);
-}
-
-static void put_uobj(struct ib_uobject *uobj)
-{
-	kref_put(&uobj->ref, release_uobj);
-}
-
-static void put_uobj_read(struct ib_uobject *uobj)
-{
-	up_read(&uobj->mutex);
-	put_uobj(uobj);
-}
-
-static void put_uobj_write(struct ib_uobject *uobj)
-{
-	up_write(&uobj->mutex);
-	put_uobj(uobj);
-}
-
 static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
 {
 	int ret;
@@ -213,31 +149,16 @@ static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
 	return idr_read_obj(&ib_uverbs_pd_idr, pd_handle, context, 0);
 }
 
-static void put_pd_read(struct ib_pd *pd)
-{
-	put_uobj_read(pd->uobject);
-}
-
 static struct ib_cq *idr_read_cq(int cq_handle, struct ib_ucontext *context, int nested)
 {
 	return idr_read_obj(&ib_uverbs_cq_idr, cq_handle, context, nested);
 }
 
-static void put_cq_read(struct ib_cq *cq)
-{
-	put_uobj_read(cq->uobject);
-}
-
 static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
 }
 
-static void put_ah_read(struct ib_ah *ah)
-{
-	put_uobj_read(ah->uobject);
-}
-
 static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
@@ -251,26 +172,11 @@ static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 	return uobj ? uobj->object : NULL;
 }
 
-static void put_qp_read(struct ib_qp *qp)
-{
-	put_uobj_read(qp->uobject);
-}
-
-static void put_qp_write(struct ib_qp *qp)
-{
-	put_uobj_write(qp->uobject);
-}
-
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
 }
 
-static void put_srq_read(struct ib_srq *srq)
-{
-	put_uobj_read(srq->uobject);
-}
-
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
 				     struct ib_uobject **uobj)
 {
@@ -278,11 +184,6 @@ static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *contex
 	return *uobj ? (*uobj)->object : NULL;
 }
 
-static void put_xrcd_read(struct ib_uobject *uobj)
-{
-	put_uobj_read(uobj);
-}
-
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
