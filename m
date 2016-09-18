From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 3/8] IB/cxgb4: Move user vendor structures
Date: Sun, 18 Sep 2016 13:50:18 +0300
Message-ID: <1474195823-10429-4-git-send-email-leon@kernel.org>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves cxgb4 vendor's specific structures to
common UAPI folder which will be visible to all consumers.

These structures are used by user-space library driver
(libcxgb4) and currently manually copied to that library.

This move will allow cross-compile against these files and
simplify introduction of vendor specific data.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 +-
 drivers/infiniband/hw/cxgb4/user.h     | 80 ---------------------------------
 include/uapi/rdma/cxgb4-abi.h          | 82 ++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 81 deletions(-)
 delete mode 100644 drivers/infiniband/hw/cxgb4/user.h
 create mode 100644 include/uapi/rdma/cxgb4-abi.h

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index aa47e0a..f83604b 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -58,7 +58,7 @@
 #include "cxgb4.h"
 #include "cxgb4_uld.h"
 #include "l2t.h"
-#include "user.h"
+#include <rdma/cxgb4-abi.h>
 
 #define DRV_NAME "iw_cxgb4"
 #define MOD DRV_NAME ":"
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
deleted file mode 100644
index 295f422..0000000
--- a/drivers/infiniband/hw/cxgb4/user.h
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
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
-#ifndef __C4IW_USER_H__
-#define __C4IW_USER_H__
-
-#define C4IW_UVERBS_ABI_VERSION	3
-
-/*
- * Make sure that all structs defined in this file remain laid out so
- * that they pack the same way on 32-bit and 64-bit architectures (to
- * avoid incompatibility between 32-bit userspace and 64-bit kernels).
- * In particular do not use pointer types -- pass pointers in __u64
- * instead.
- */
-struct c4iw_create_cq_resp {
-	__u64 key;
-	__u64 gts_key;
-	__u64 memsize;
-	__u32 cqid;
-	__u32 size;
-	__u32 qid_mask;
-	__u32 reserved; /* explicit padding (optional for i386) */
-};
-
-
-enum {
-	C4IW_QPF_ONCHIP = (1<<0)
-};
-
-struct c4iw_create_qp_resp {
-	__u64 ma_sync_key;
-	__u64 sq_key;
-	__u64 rq_key;
-	__u64 sq_db_gts_key;
-	__u64 rq_db_gts_key;
-	__u64 sq_memsize;
-	__u64 rq_memsize;
-	__u32 sqid;
-	__u32 rqid;
-	__u32 sq_size;
-	__u32 rq_size;
-	__u32 qid_mask;
-	__u32 flags;
-};
-
-struct c4iw_alloc_ucontext_resp {
-	__u64 status_page_key;
-	__u32 status_page_size;
-	__u32 reserved; /* explicit padding (optional for i386) */
-};
-#endif
diff --git a/include/uapi/rdma/cxgb4-abi.h b/include/uapi/rdma/cxgb4-abi.h
new file mode 100644
index 0000000..4c46658
--- /dev/null
+++ b/include/uapi/rdma/cxgb4-abi.h
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
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
+#ifndef CXGB4_ABI_USER_H
+#define CXGB4_ABI_USER_H
+
+#include <linux/types.h>
+
+#define C4IW_UVERBS_ABI_VERSION	3
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct c4iw_create_cq_resp {
+	__u64 key;
+	__u64 gts_key;
+	__u64 memsize;
+	__u32 cqid;
+	__u32 size;
+	__u32 qid_mask;
+	__u32 reserved; /* explicit padding (optional for i386) */
+};
+
+
+enum {
+	C4IW_QPF_ONCHIP = (1<<0)
+};
+
+struct c4iw_create_qp_resp {
+	__u64 ma_sync_key;
+	__u64 sq_key;
+	__u64 rq_key;
+	__u64 sq_db_gts_key;
+	__u64 rq_db_gts_key;
+	__u64 sq_memsize;
+	__u64 rq_memsize;
+	__u32 sqid;
+	__u32 rqid;
+	__u32 sq_size;
+	__u32 rq_size;
+	__u32 qid_mask;
+	__u32 flags;
+};
+
+struct c4iw_alloc_ucontext_resp {
+	__u64 status_page_key;
+	__u32 status_page_size;
+	__u32 reserved; /* explicit padding (optional for i386) */
+};
+#endif /* CXGB4_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
