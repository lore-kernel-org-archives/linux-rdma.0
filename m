From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 6/9] IB/nes: Move user vendor structures
Date: Thu, 22 Sep 2016 17:31:16 +0300
Message-ID: <1474554679-21953-7-git-send-email-leon@kernel.org>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474554679-21953-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves nes vendor's specific structures to
common UAPI folder which will be visible to all consumers.

These structures are used by user-space library driver
(libmlx4) and currently manually copied to that library.

This move will allow cross-compile against these files and
simplify introduction of vendor specific data.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h      |   2 +-
 drivers/infiniband/hw/nes/nes_user.h | 114 -----------------------------------
 include/uapi/rdma/nes-abi.h          | 114 +++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 115 deletions(-)
 delete mode 100644 drivers/infiniband/hw/nes/nes_user.h
 create mode 100644 include/uapi/rdma/nes-abi.h

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index bd9d132..e7430c9 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -165,7 +165,7 @@ do { \
 #include "nes_hw.h"
 #include "nes_verbs.h"
 #include "nes_context.h"
-#include "nes_user.h"
+#include <rdma/nes-abi.h>
 #include "nes_cm.h"
 #include "nes_mgt.h"
 
diff --git a/drivers/infiniband/hw/nes/nes_user.h b/drivers/infiniband/hw/nes/nes_user.h
deleted file mode 100644
index 529c421..0000000
--- a/drivers/infiniband/hw/nes/nes_user.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
- * Copyright (c) 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Cisco Systems.  All rights reserved.
- * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
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
- *
- */
-
-#ifndef NES_USER_H
-#define NES_USER_H
-
-#include <linux/types.h>
-
-#define NES_ABI_USERSPACE_VER 2
-#define NES_ABI_KERNEL_VER    2
-
-/*
- * Make sure that all structs defined in this file remain laid out so
- * that they pack the same way on 32-bit and 64-bit architectures (to
- * avoid incompatibility between 32-bit userspace and 64-bit kernels).
- * In particular do not use pointer types -- pass pointers in __u64
- * instead.
- */
-
-struct nes_alloc_ucontext_req {
-	__u32 reserved32;
-	__u8  userspace_ver;
-	__u8  reserved8[3];
-};
-
-struct nes_alloc_ucontext_resp {
-	__u32 max_pds; /* maximum pds allowed for this user process */
-	__u32 max_qps; /* maximum qps allowed for this user process */
-	__u32 wq_size; /* size of the WQs (sq+rq) allocated to the mmaped area */
-	__u8  virtwq;  /* flag to indicate if virtual WQ are to be used or not */
-	__u8  kernel_ver;
-	__u8  reserved[2];
-};
-
-struct nes_alloc_pd_resp {
-	__u32 pd_id;
-	__u32 mmap_db_index;
-};
-
-struct nes_create_cq_req {
-	__u64 user_cq_buffer;
-	__u32 mcrqf;
-	__u8 reserved[4];
-};
-
-struct nes_create_qp_req {
-	__u64 user_wqe_buffers;
-	__u64 user_qp_buffer;
-};
-
-enum iwnes_memreg_type {
-	IWNES_MEMREG_TYPE_MEM = 0x0000,
-	IWNES_MEMREG_TYPE_QP = 0x0001,
-	IWNES_MEMREG_TYPE_CQ = 0x0002,
-	IWNES_MEMREG_TYPE_MW = 0x0003,
-	IWNES_MEMREG_TYPE_FMR = 0x0004,
-	IWNES_MEMREG_TYPE_FMEM = 0x0005,
-};
-
-struct nes_mem_reg_req {
-	__u32 reg_type;	/* indicates if id is memory, QP or CQ */
-	__u32 reserved;
-};
-
-struct nes_create_cq_resp {
-	__u32 cq_id;
-	__u32 cq_size;
-	__u32 mmap_db_index;
-	__u32 reserved;
-};
-
-struct nes_create_qp_resp {
-	__u32 qp_id;
-	__u32 actual_sq_size;
-	__u32 actual_rq_size;
-	__u32 mmap_sq_db_index;
-	__u32 mmap_rq_db_index;
-	__u32 nes_drv_opt;
-};
-
-#endif				/* NES_USER_H */
diff --git a/include/uapi/rdma/nes-abi.h b/include/uapi/rdma/nes-abi.h
new file mode 100644
index 0000000..6eb3734
--- /dev/null
+++ b/include/uapi/rdma/nes-abi.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
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
+ *
+ */
+
+#ifndef NES_ABI_USER_H
+#define NES_ABI_USER_H
+
+#include <linux/types.h>
+
+#define NES_ABI_USERSPACE_VER 2
+#define NES_ABI_KERNEL_VER    2
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct nes_alloc_ucontext_req {
+	__u32 reserved32;
+	__u8  userspace_ver;
+	__u8  reserved8[3];
+};
+
+struct nes_alloc_ucontext_resp {
+	__u32 max_pds; /* maximum pds allowed for this user process */
+	__u32 max_qps; /* maximum qps allowed for this user process */
+	__u32 wq_size; /* size of the WQs (sq+rq) allocated to the mmaped area */
+	__u8  virtwq;  /* flag to indicate if virtual WQ are to be used or not */
+	__u8  kernel_ver;
+	__u8  reserved[2];
+};
+
+struct nes_alloc_pd_resp {
+	__u32 pd_id;
+	__u32 mmap_db_index;
+};
+
+struct nes_create_cq_req {
+	__u64 user_cq_buffer;
+	__u32 mcrqf;
+	__u8 reserved[4];
+};
+
+struct nes_create_qp_req {
+	__u64 user_wqe_buffers;
+	__u64 user_qp_buffer;
+};
+
+enum iwnes_memreg_type {
+	IWNES_MEMREG_TYPE_MEM = 0x0000,
+	IWNES_MEMREG_TYPE_QP = 0x0001,
+	IWNES_MEMREG_TYPE_CQ = 0x0002,
+	IWNES_MEMREG_TYPE_MW = 0x0003,
+	IWNES_MEMREG_TYPE_FMR = 0x0004,
+	IWNES_MEMREG_TYPE_FMEM = 0x0005,
+};
+
+struct nes_mem_reg_req {
+	__u32 reg_type;	/* indicates if id is memory, QP or CQ */
+	__u32 reserved;
+};
+
+struct nes_create_cq_resp {
+	__u32 cq_id;
+	__u32 cq_size;
+	__u32 mmap_db_index;
+	__u32 reserved;
+};
+
+struct nes_create_qp_resp {
+	__u32 qp_id;
+	__u32 actual_sq_size;
+	__u32 actual_rq_size;
+	__u32 mmap_sq_db_index;
+	__u32 mmap_rq_db_index;
+	__u32 nes_drv_opt;
+};
+
+#endif	/* NES_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
