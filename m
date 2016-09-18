From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/8] IB/cxgb3: Move user vendor structures
Date: Sun, 18 Sep 2016 13:50:17 +0300
Message-ID: <1474195823-10429-3-git-send-email-leon@kernel.org>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves cxgb3 vendor's specific structures to
common UAPI folder which will be visible to all consumers.

These structures are used by user-space library driver
(libcxgb3) and currently manually copied to that library.

This move will allow cross-compile against these files and
simplify introduction of vendor specific data.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch.c          |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_user.h     | 74 ----------------------------
 include/uapi/rdma/cxgb3-abi.h               | 76 +++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 76 deletions(-)
 delete mode 100644 drivers/infiniband/hw/cxgb3/iwch_user.h
 create mode 100644 include/uapi/rdma/cxgb3-abi.h

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 8e77dc5..b3e1132 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -36,7 +36,7 @@
 
 #include "cxgb3_offload.h"
 #include "iwch_provider.h"
-#include "iwch_user.h"
+#include <rdma/cxgb3-abi.h>
 #include "iwch.h"
 #include "iwch_cm.h"
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 3edb806..1642413 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -58,7 +58,7 @@
 #include "iwch.h"
 #include "iwch_provider.h"
 #include "iwch_cm.h"
-#include "iwch_user.h"
+#include <rdma/cxgb3-abi.h>
 #include "common.h"
 
 static struct ib_ah *iwch_ah_create(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_user.h b/drivers/infiniband/hw/cxgb3/iwch_user.h
deleted file mode 100644
index a277c31..0000000
--- a/drivers/infiniband/hw/cxgb3/iwch_user.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- * Copyright (c) 2006 Chelsio, Inc. All rights reserved.
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
-#ifndef __IWCH_USER_H__
-#define __IWCH_USER_H__
-
-#define IWCH_UVERBS_ABI_VERSION	1
-
-/*
- * Make sure that all structs defined in this file remain laid out so
- * that they pack the same way on 32-bit and 64-bit architectures (to
- * avoid incompatibility between 32-bit userspace and 64-bit kernels).
- * In particular do not use pointer types -- pass pointers in __u64
- * instead.
- */
-struct iwch_create_cq_req {
-	__u64 user_rptr_addr;
-};
-
-struct iwch_create_cq_resp_v0 {
-	__u64 key;
-	__u32 cqid;
-	__u32 size_log2;
-};
-
-struct iwch_create_cq_resp {
-	__u64 key;
-	__u32 cqid;
-	__u32 size_log2;
-	__u32 memsize;
-	__u32 reserved;
-};
-
-struct iwch_create_qp_resp {
-	__u64 key;
-	__u64 db_key;
-	__u32 qpid;
-	__u32 size_log2;
-	__u32 sq_size_log2;
-	__u32 rq_size_log2;
-};
-
-struct iwch_reg_user_mr_resp {
-	__u32 pbl_addr;
-};
-#endif
diff --git a/include/uapi/rdma/cxgb3-abi.h b/include/uapi/rdma/cxgb3-abi.h
new file mode 100644
index 0000000..48a19bd
--- /dev/null
+++ b/include/uapi/rdma/cxgb3-abi.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2006 Chelsio, Inc. All rights reserved.
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
+#ifndef CXGB3_ABI_USER_H
+#define CXBG3_ABI_USER_H
+
+#include <linux/types.h>
+
+#define IWCH_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct iwch_create_cq_req {
+	__u64 user_rptr_addr;
+};
+
+struct iwch_create_cq_resp_v0 {
+	__u64 key;
+	__u32 cqid;
+	__u32 size_log2;
+};
+
+struct iwch_create_cq_resp {
+	__u64 key;
+	__u32 cqid;
+	__u32 size_log2;
+	__u32 memsize;
+	__u32 reserved;
+};
+
+struct iwch_create_qp_resp {
+	__u64 key;
+	__u64 db_key;
+	__u32 qpid;
+	__u32 size_log2;
+	__u32 sq_size_log2;
+	__u32 rq_size_log2;
+};
+
+struct iwch_reg_user_mr_resp {
+	__u32 pbl_addr;
+};
+#endif /* CXGB3_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
