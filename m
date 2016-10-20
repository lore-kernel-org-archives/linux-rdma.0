From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 5/6] libqedr: abi
Date: Thu, 20 Oct 2016 12:49:11 +0300
Message-ID: <1476956952-17388-6-git-send-email-Ram.Amrani@cavium.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476956952-17388-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

Introducing abi structures that allows interfacing with the kernel.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_abi.h | 120 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100644 providers/qedr/qelr_abi.h

diff --git a/providers/qedr/qelr_abi.h b/providers/qedr/qelr_abi.h
new file mode 100644
index 0000000..a7a0638
--- /dev/null
+++ b/providers/qedr/qelr_abi.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#ifndef __QELR_ABI_H__
+#define __QELR_ABI_H__
+
+#include <infiniband/kern-abi.h>
+
+#define QELR_ABI_VERSION			(8)
+
+struct qelr_get_context {
+	struct ibv_get_context cmd;		/* must be first */
+};
+
+struct qelr_alloc_ucontext_resp {
+	struct ibv_get_context_resp ibv_resp;	/* must be first */
+	__u64 db_pa;
+	__u32 db_size;
+
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_srq_wr;
+	__u32 sges_per_send_wr;
+	__u32 sges_per_recv_wr;
+	__u32 sges_per_srq_wr;
+	__u32 max_cqes;
+};
+
+struct qelr_alloc_pd_req {
+	struct ibv_alloc_pd cmd;		/* must be first */
+};
+
+struct qelr_alloc_pd_resp {
+	struct ibv_alloc_pd_resp ibv_resp;	/* must be first */
+	__u32 pd_id;
+};
+
+struct qelr_create_cq_req {
+	struct ibv_create_cq ibv_cmd;		/* must be first */
+
+	__u64 addr;	/* user space virtual address of CQ buffer */
+	__u64 len;	/* size of CQ buffer */
+};
+
+struct qelr_create_cq_resp {
+	struct ibv_create_cq_resp ibv_resp;	/* must be first */
+	__u32 db_offset;
+	__u16 icid;
+};
+
+struct qelr_reg_mr {
+	struct ibv_reg_mr ibv_cmd;		/* must be first */
+};
+
+struct qelr_reg_mr_resp {
+	struct ibv_reg_mr_resp ibv_resp;	/* must be first */
+};
+
+struct qelr_create_qp_req {
+	struct ibv_create_qp ibv_qp;	/* must be first */
+
+	__u32 qp_handle_hi;
+	__u32 qp_handle_lo;
+
+	/* SQ */
+	__u64 sq_addr;	/* user space virtual address of SQ buffer */
+	__u64 sq_len;		/* length of SQ buffer */
+
+	/* RQ */
+	__u64 rq_addr;	/* user space virtual address of RQ buffer */
+	__u64 rq_len;		/* length of RQ buffer */
+};
+
+struct qelr_create_qp_resp {
+	struct ibv_create_qp_resp ibv_resp;	/* must be first */
+
+	__u32 qp_id;
+	__u32 atomic_supported;
+
+	/* SQ */
+	__u32 sq_db_offset;
+	__u16 sq_icid;
+
+	/* RQ */
+	__u32 rq_db_offset;
+	__u16 rq_icid;
+
+	__u32 rq_db2_offset;
+};
+
+#endif /* __QELR_ABI_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
