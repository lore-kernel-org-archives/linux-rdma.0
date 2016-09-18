From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/8] IB/mlx4: Move user vendor structures
Date: Sun, 18 Sep 2016 13:50:19 +0300
Message-ID: <1474195823-10429-5-git-send-email-leon@kernel.org>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves mlx4 vendor's specific structures to
common UAPI folder which will be visible to all consumers.

These structures are used by user-space library driver
(libmlx4) and currently manually copied to that library.

This move will allow cross-compile against these files and
simplify introduction of vendor specific data.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c   |   2 +-
 drivers/infiniband/hw/mlx4/main.c |   2 +-
 drivers/infiniband/hw/mlx4/qp.c   |   2 +-
 drivers/infiniband/hw/mlx4/srq.c  |   2 +-
 drivers/infiniband/hw/mlx4/user.h | 107 --------------------------------------
 include/uapi/rdma/mlx4-abi.h      | 107 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 111 insertions(+), 111 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx4/user.h
 create mode 100644 include/uapi/rdma/mlx4-abi.h

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 006db64..9ba29c3 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -37,7 +37,7 @@
 #include <linux/slab.h>
 
 #include "mlx4_ib.h"
-#include "user.h"
+#include <rdma/mlx4-abi.h>
 
 static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
 {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2af44c2..75c65f4 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -55,7 +55,7 @@
 #include <linux/mlx4/qp.h>
 
 #include "mlx4_ib.h"
-#include "user.h"
+#include <rdma/mlx4-abi.h>
 
 #define DRV_NAME	MLX4_IB_DRV_NAME
 #define DRV_VERSION	"2.2-1"
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 768085f..44c8a0d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -47,7 +47,7 @@
 #include <linux/mlx4/qp.h>
 
 #include "mlx4_ib.h"
-#include "user.h"
+#include <rdma/mlx4-abi.h>
 
 static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq,
 			     struct mlx4_ib_cq *recv_cq);
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 0597f3e..7dd3f26 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -37,7 +37,7 @@
 #include <linux/vmalloc.h>
 
 #include "mlx4_ib.h"
-#include "user.h"
+#include <rdma/mlx4-abi.h>
 
 static void *get_wqe(struct mlx4_ib_srq *srq, int n)
 {
diff --git a/drivers/infiniband/hw/mlx4/user.h b/drivers/infiniband/hw/mlx4/user.h
deleted file mode 100644
index 07e6769..0000000
--- a/drivers/infiniband/hw/mlx4/user.h
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
- * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef MLX4_IB_USER_H
-#define MLX4_IB_USER_H
-
-#include <linux/types.h>
-
-/*
- * Increment this value if any changes that break userspace ABI
- * compatibility are made.
- */
-
-#define MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION	3
-#define MLX4_IB_UVERBS_ABI_VERSION		4
-
-/*
- * Make sure that all structs defined in this file remain laid out so
- * that they pack the same way on 32-bit and 64-bit architectures (to
- * avoid incompatibility between 32-bit userspace and 64-bit kernels).
- * In particular do not use pointer types -- pass pointers in __u64
- * instead.
- */
-
-struct mlx4_ib_alloc_ucontext_resp_v3 {
-	__u32	qp_tab_size;
-	__u16	bf_reg_size;
-	__u16	bf_regs_per_page;
-};
-
-struct mlx4_ib_alloc_ucontext_resp {
-	__u32	dev_caps;
-	__u32	qp_tab_size;
-	__u16	bf_reg_size;
-	__u16	bf_regs_per_page;
-	__u32	cqe_size;
-};
-
-struct mlx4_ib_alloc_pd_resp {
-	__u32	pdn;
-	__u32	reserved;
-};
-
-struct mlx4_ib_create_cq {
-	__u64	buf_addr;
-	__u64	db_addr;
-};
-
-struct mlx4_ib_create_cq_resp {
-	__u32	cqn;
-	__u32	reserved;
-};
-
-struct mlx4_ib_resize_cq {
-	__u64	buf_addr;
-};
-
-struct mlx4_ib_create_srq {
-	__u64	buf_addr;
-	__u64	db_addr;
-};
-
-struct mlx4_ib_create_srq_resp {
-	__u32	srqn;
-	__u32	reserved;
-};
-
-struct mlx4_ib_create_qp {
-	__u64	buf_addr;
-	__u64	db_addr;
-	__u8	log_sq_bb_count;
-	__u8	log_sq_stride;
-	__u8	sq_no_prefetch;
-	__u8	reserved[5];
-};
-
-#endif /* MLX4_IB_USER_H */
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
new file mode 100644
index 0000000..af43175
--- /dev/null
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
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
+#ifndef MLX4_ABI_USER_H
+#define MLX4_ABI_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+
+#define MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION	3
+#define MLX4_IB_UVERBS_ABI_VERSION		4
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct mlx4_ib_alloc_ucontext_resp_v3 {
+	__u32	qp_tab_size;
+	__u16	bf_reg_size;
+	__u16	bf_regs_per_page;
+};
+
+struct mlx4_ib_alloc_ucontext_resp {
+	__u32	dev_caps;
+	__u32	qp_tab_size;
+	__u16	bf_reg_size;
+	__u16	bf_regs_per_page;
+	__u32	cqe_size;
+};
+
+struct mlx4_ib_alloc_pd_resp {
+	__u32	pdn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_cq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_resize_cq {
+	__u64	buf_addr;
+};
+
+struct mlx4_ib_create_srq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_srq_resp {
+	__u32	srqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_qp {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u8	log_sq_bb_count;
+	__u8	log_sq_stride;
+	__u8	sq_no_prefetch;
+	__u8	reserved[5];
+};
+
+#endif /* MLX4_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
