From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libpvrdma: Fix up for ABI file
Date: Tue, 8 Nov 2016 15:06:18 -0800
Message-ID: <1478646378-21775-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reverted the ABI file to the kernel version. I added a new file that
includes this ABI file and duplicates only the required structures
for the library. This should be temporary until the UAPI is fixed
properly within libibverbs and the kernel.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 buildlib/fixup-include/rdma-pvrdma-abi.h | 56 ++++++++++-------------
 providers/pvrdma/cq.c                    | 10 ++---
 providers/pvrdma/pvrdma-abi-fix.h        | 76 ++++++++++++++++++++++++++++++++
 providers/pvrdma/pvrdma.h                |  2 +-
 providers/pvrdma/pvrdma_main.c           |  4 +-
 providers/pvrdma/qp.c                    | 12 ++---
 providers/pvrdma/verbs.c                 |  4 +-
 7 files changed, 116 insertions(+), 48 deletions(-)
 create mode 100644 providers/pvrdma/pvrdma-abi-fix.h

diff --git a/buildlib/fixup-include/rdma-pvrdma-abi.h b/buildlib/fixup-include/rdma-pvrdma-abi.h
index c7a38c5..5ca0e91 100644
--- a/buildlib/fixup-include/rdma-pvrdma-abi.h
+++ b/buildlib/fixup-include/rdma-pvrdma-abi.h
@@ -46,14 +46,14 @@
 #ifndef __PVRDMA_ABI_H__
 #define __PVRDMA_ABI_H__
 
-#include <infiniband/kern-abi.h>
+#include <linux/types.h>
 
-#define PVRDMA_UVERBS_ABI_VERSION	3
+#define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
 #define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
-#define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell offset. */
+#define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
 #define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
 #define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
-#define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell offset. */
+#define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell. */
 #define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
 #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
 #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
@@ -129,55 +129,47 @@ enum pvrdma_wc_flags {
 };
 
 struct pvrdma_alloc_ucontext_resp {
-	struct ibv_get_context_resp	ibv_resp;
-	__u32				qp_tab_size;
-	__u32				reserved;
+	__u32 qp_tab_size;
+	__u32 reserved;
 };
 
 struct pvrdma_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
-	__u32				pdn;
-	__u32				reserved;
+	__u32 pdn;
+	__u32 reserved;
 };
 
 struct pvrdma_create_cq {
-	struct ibv_create_cq		ibv_cmd;
-	__u64				buf_addr;
-	__u32				buf_size;
-	__u32				reserved;
+	__u64 buf_addr;
+	__u32 buf_size;
+	__u32 reserved;
 };
 
 struct pvrdma_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
-	__u32				cqn;
-	__u32				reserved;
+	__u32 cqn;
+	__u32 reserved;
 };
 
 struct pvrdma_resize_cq {
-	struct ibv_resize_cq		ibv_cmd;
-	__u64				buf_addr;
-	__u32				buf_size;
-	__u32				reserved;
+	__u64 buf_addr;
+	__u32 buf_size;
+	__u32 reserved;
 };
 
 struct pvrdma_create_srq {
-	struct ibv_create_srq		ibv_cmd;
-	__u64				buf_addr;
+	__u64 buf_addr;
 };
 
 struct pvrdma_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
-	__u32				srqn;
-	__u32				reserved;
+	__u32 srqn;
+	__u32 reserved;
 };
 
 struct pvrdma_create_qp {
-	struct ibv_create_qp		ibv_cmd;
-	__u64				rbuf_addr;
-	__u64				sbuf_addr;
-	__u32				rbuf_size;
-	__u32				sbuf_size;
-	__u64				qp_addr;
+	__u64 rbuf_addr;
+	__u64 sbuf_addr;
+	__u32 rbuf_size;
+	__u32 sbuf_size;
+	__u64 qp_addr;
 };
 
 /* PVRDMA masked atomic compare and swap */
diff --git a/providers/pvrdma/cq.c b/providers/pvrdma/cq.c
index bb4d1f7..0c7dcf6 100644
--- a/providers/pvrdma/cq.c
+++ b/providers/pvrdma/cq.c
@@ -214,8 +214,8 @@ struct ibv_cq *pvrdma_create_cq(struct ibv_context *context, int cqe,
 				int comp_vector)
 {
 	struct pvrdma_device *dev = to_vdev(context->device);
-	struct pvrdma_create_cq cmd;
-	struct pvrdma_create_cq_resp resp;
+	struct user_pvrdma_create_cq cmd;
+	struct user_pvrdma_create_cq_resp resp;
 	struct pvrdma_cq *cq;
 	int ret;
 
@@ -239,15 +239,15 @@ struct ibv_cq *pvrdma_create_cq(struct ibv_context *context, int cqe,
 
 	cq->ring_state = cq->buf.buf;
 
-	cmd.buf_addr = (uintptr_t) cq->buf.buf;
-	cmd.buf_size = cq->buf.length;
+	cmd.udata.buf_addr = (uintptr_t) cq->buf.buf;
+	cmd.udata.buf_size = cq->buf.length;
 	ret = ibv_cmd_create_cq(context, cqe, channel, comp_vector,
 				&cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof(resp));
 	if (ret)
 		goto err_buf;
 
-	cq->cqn = resp.cqn;
+	cq->cqn = resp.udata.cqn;
 	cq->cqe_cnt = cq->ibv_cq.cqe;
 
 	return &cq->ibv_cq;
diff --git a/providers/pvrdma/pvrdma-abi-fix.h b/providers/pvrdma/pvrdma-abi-fix.h
new file mode 100644
index 0000000..3d49aca
--- /dev/null
+++ b/providers/pvrdma/pvrdma-abi-fix.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_ABI_FIX_H__
+#define __PVRDMA_ABI_FIX_H__
+
+#include <rdma/pvrdma-abi.h>
+
+struct user_pvrdma_alloc_ucontext_resp {
+	struct ibv_get_context_resp		ibv_resp;
+	struct pvrdma_alloc_ucontext_resp	udata;
+};
+
+struct user_pvrdma_alloc_pd_resp {
+	struct ibv_alloc_pd_resp	ibv_resp;
+	struct pvrdma_alloc_pd_resp	udata;
+};
+
+struct user_pvrdma_create_cq {
+	struct ibv_create_cq		ibv_cmd;
+	struct pvrdma_create_cq		udata;
+};
+
+struct user_pvrdma_create_cq_resp {
+	struct ibv_create_cq_resp	ibv_resp;
+	struct pvrdma_create_cq_resp	udata;
+};
+
+struct user_pvrdma_create_qp {
+	struct ibv_create_qp		ibv_cmd;
+	struct pvrdma_create_qp		udata;
+};
+
+#endif /* __PVRDMA_ABI_FIX_H__ */
diff --git a/providers/pvrdma/pvrdma.h b/providers/pvrdma/pvrdma.h
index 1c9f9f7..29c9991 100644
--- a/providers/pvrdma/pvrdma.h
+++ b/providers/pvrdma/pvrdma.h
@@ -55,11 +55,11 @@
 #include <netinet/in.h>
 #include <sys/mman.h>
 #include <infiniband/driver.h>
-#include <rdma/pvrdma-abi.h>
 #include <ccan/minmax.h>
 
 #define BIT(nr) (1UL << (nr))
 
+#include "pvrdma-abi-fix.h"
 #include "pvrdma_ring.h"
 
 #ifndef likely
diff --git a/providers/pvrdma/pvrdma_main.c b/providers/pvrdma/pvrdma_main.c
index 909cf1e..9a7e07b 100644
--- a/providers/pvrdma/pvrdma_main.c
+++ b/providers/pvrdma/pvrdma_main.c
@@ -97,14 +97,14 @@ static int pvrdma_init_context_shared(struct pvrdma_context *context,
 				      int cmd_fd)
 {
 	struct ibv_get_context cmd;
-	struct pvrdma_alloc_ucontext_resp resp;
+	struct user_pvrdma_alloc_ucontext_resp resp;
 
 	context->ibv_ctx.cmd_fd = cmd_fd;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof(resp)))
 		return errno;
 
-	context->qp_tbl = calloc(resp.qp_tab_size & 0xFFFF,
+	context->qp_tbl = calloc(resp.udata.qp_tab_size & 0xFFFF,
 				 sizeof(struct pvrdma_qp *));
 	if (!context->qp_tbl)
 		return -ENOMEM;
diff --git a/providers/pvrdma/qp.c b/providers/pvrdma/qp.c
index 8a37b7f..8b7c5a7 100644
--- a/providers/pvrdma/qp.c
+++ b/providers/pvrdma/qp.c
@@ -100,7 +100,7 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 				struct ibv_qp_init_attr *attr)
 {
 	struct pvrdma_device *dev = to_vdev(pd->context->device);
-	struct pvrdma_create_qp cmd;
+	struct user_pvrdma_create_qp cmd;
 	struct ibv_create_qp_resp resp;
 	struct pvrdma_qp *qp;
 	int ret;
@@ -152,11 +152,11 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 		goto err_free;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.rbuf_addr = (uintptr_t)qp->rbuf.buf;
-	cmd.rbuf_size = qp->rbuf.length;
-	cmd.sbuf_addr = (uintptr_t)qp->sbuf.buf;
-	cmd.sbuf_size = qp->sbuf.length;
-	cmd.qp_addr = (uintptr_t) qp;
+	cmd.udata.rbuf_addr = (uintptr_t)qp->rbuf.buf;
+	cmd.udata.rbuf_size = qp->rbuf.length;
+	cmd.udata.sbuf_addr = (uintptr_t)qp->sbuf.buf;
+	cmd.udata.sbuf_size = qp->sbuf.length;
+	cmd.udata.qp_addr = (uintptr_t) qp;
 
 	ret = ibv_cmd_create_qp(pd, &qp->ibv_qp, attr,
 				&cmd.ibv_cmd, sizeof(cmd),
diff --git a/providers/pvrdma/verbs.c b/providers/pvrdma/verbs.c
index f20ea6c..7dc9c83 100644
--- a/providers/pvrdma/verbs.c
+++ b/providers/pvrdma/verbs.c
@@ -79,7 +79,7 @@ int pvrdma_query_port(struct ibv_context *context, uint8_t port,
 struct ibv_pd *pvrdma_alloc_pd(struct ibv_context *context)
 {
 	struct ibv_alloc_pd cmd;
-	struct pvrdma_alloc_pd_resp resp;
+	struct user_pvrdma_alloc_pd_resp resp;
 	struct pvrdma_pd *pd;
 
 	pd = malloc(sizeof(*pd));
@@ -92,7 +92,7 @@ struct ibv_pd *pvrdma_alloc_pd(struct ibv_context *context)
 		return NULL;
 	}
 
-	pd->pdn = resp.pdn;
+	pd->pdn = resp.udata.pdn;
 
 	return &pd->ibv_pd;
 }
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
