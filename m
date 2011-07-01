From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 22/44] rxe_cq.h
Date: Fri, 01 Jul 2011 08:18:43 -0500
Message-ID: <20110701132201.759679115@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch22
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Declarations for completion queue details.

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/hw/rxe/rxe_cq.h |   52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

Index: infiniband/drivers/infiniband/hw/rxe/rxe_cq.h
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/rxe_cq.h
@@ -0,0 +1,52 @@
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
+/* cq implementation details */
+
+#ifndef RXE_CQ_H
+#define RXE_CQ_H
+
+int rxe_cq_chk_attr(struct rxe_dev *rxe, struct rxe_cq *cq,
+		    int cqe, int comp_vector, struct ib_udata *udata);
+
+int rxe_cq_from_init(struct rxe_dev *rxe, struct rxe_cq *cq, int cqe,
+		     int comp_vector, struct ib_ucontext *context,
+		     struct ib_udata *udata);
+
+int rxe_cq_resize_queue(struct rxe_cq *cq, int new_cqe, struct ib_udata *udata);
+
+int rxe_cq_post(struct rxe_cq *cq, struct rxe_cqe *cqe, int solicited);
+
+void rxe_cq_cleanup(void *arg);
+
+#endif /* RXE_CQ_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
