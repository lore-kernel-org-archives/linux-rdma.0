From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 08/44] rxe_mmap.h
Date: Fri, 01 Jul 2011 08:18:29 -0500
Message-ID: <20110701132201.083584104@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch8
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

declarations for mmap routines.

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/hw/rxe/rxe_mmap.h |   63 +++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

Index: infiniband/drivers/infiniband/hw/rxe/rxe_mmap.h
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/rxe_mmap.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2009-2011 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2009-2011 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#ifndef RXE_MMAP_H
+#define RXE_MMAP_H
+
+/* This info has to be copied to user space so that it can call mmap
+ * and get the right stuff mapped */
+struct mminfo {
+	__u64			offset;
+	__u32			size;
+	__u32			pad;
+};
+
+struct rxe_mmap_info {
+	struct list_head	pending_mmaps;
+	struct ib_ucontext	*context;
+	struct kref		ref;
+	void			*obj;
+
+	struct mminfo info;
+};
+
+void rxe_mmap_release(struct kref *ref);
+
+struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *dev,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj);
+
+int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+
+#endif /* RXE_MMAP_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
