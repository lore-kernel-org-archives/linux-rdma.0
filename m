From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 7/9] IB/mthca: Move user vendor structures
Date: Thu, 22 Sep 2016 17:31:17 +0300
Message-ID: <1474554679-21953-8-git-send-email-leon@kernel.org>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474554679-21953-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves mthca vendor's specific structures to
common UAPI folder which will be visible to all consumers.

These structures are used by user-space library driver
(libmthca) and currently manually copied to that library.

This move will allow cross-compile against these files and
simplify introduction of vendor specific data.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c |   2 +-
 include/uapi/rdma/mthca-abi.h                | 111 +++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/rdma/mthca-abi.h

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index da2335f..c0b6b3b 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -46,7 +46,7 @@
 
 #include "mthca_dev.h"
 #include "mthca_cmd.h"
-#include "mthca_user.h"
+#include <rdma/mthca-abi.h>
 #include "mthca_memfree.h"
 
 static void init_query_mad(struct ib_smp *mad)
diff --git a/include/uapi/rdma/mthca-abi.h b/include/uapi/rdma/mthca-abi.h
new file mode 100644
index 0000000..bcbf4ff
--- /dev/null
+++ b/include/uapi/rdma/mthca-abi.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
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
+#ifndef MTHCA_ABI_USER_H
+#define MTHCA_ABI_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define MTHCA_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct mthca_alloc_ucontext_resp {
+	__u32 qp_tab_size;
+	__u32 uarc_size;
+};
+
+struct mthca_alloc_pd_resp {
+	__u32 pdn;
+	__u32 reserved;
+};
+
+/*
+ * Mark the memory region with a DMA attribute that causes
+ * in-flight DMA to be flushed when the region is written to:
+ */
+#define MTHCA_MR_DMASYNC	0x1
+
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+	__u32 reserved;
+};
+
+struct mthca_create_cq {
+	__u32 lkey;
+	__u32 pdn;
+	__u64 arm_db_page;
+	__u64 set_db_page;
+	__u32 arm_db_index;
+	__u32 set_db_index;
+};
+
+struct mthca_create_cq_resp {
+	__u32 cqn;
+	__u32 reserved;
+};
+
+struct mthca_resize_cq {
+	__u32 lkey;
+	__u32 reserved;
+};
+
+struct mthca_create_srq {
+	__u32 lkey;
+	__u32 db_index;
+	__u64 db_page;
+};
+
+struct mthca_create_srq_resp {
+	__u32 srqn;
+	__u32 reserved;
+};
+
+struct mthca_create_qp {
+	__u32 lkey;
+	__u32 reserved;
+	__u64 sq_db_page;
+	__u64 rq_db_page;
+	__u32 sq_db_index;
+	__u32 rq_db_index;
+};
+#endif /* MTHCA_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
