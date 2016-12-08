From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/23] IB/rdmavt: Fix trace hierarchy
Date: Wed, 07 Dec 2016 19:32:47 -0800
Message-ID: <20161208033246.21135.28386.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Split rdmavt traces into separate files to preserve the original
hierarchy since only one trace sub system may now be defined per header
file.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/trace.h     |  140 +-----------------------------
 drivers/infiniband/sw/rdmavt/trace_qp.h  |   96 +++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_rvt.h |   81 +++++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_tx.h  |  132 ++++++++++++++++++++++++++++
 4 files changed, 312 insertions(+), 137 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_qp.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rvt.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_tx.h

diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index 6c0457d..11a2afb 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -45,143 +45,9 @@
  *
  */
 
-#undef TRACE_SYSTEM_VAR
-#define TRACE_SYSTEM_VAR rdmavt
-
-#if !defined(__RDMAVT_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define __RDMAVT_TRACE_H
-
-#include <linux/tracepoint.h>
-#include <linux/trace_seq.h>
-
-#include <rdma/ib_verbs.h>
-#include <rdma/rdma_vt.h>
-
 #define RDI_DEV_ENTRY(rdi)   __string(dev, rdi->driver_f.get_card_name(rdi))
 #define RDI_DEV_ASSIGN(rdi)  __assign_str(dev, rdi->driver_f.get_card_name(rdi))
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM rdmavt
-
-TRACE_EVENT(rvt_dbg,
-	TP_PROTO(struct rvt_dev_info *rdi,
-		 const char *msg),
-	TP_ARGS(rdi, msg),
-	TP_STRUCT__entry(
-		RDI_DEV_ENTRY(rdi)
-		__string(msg, msg)
-	),
-	TP_fast_assign(
-		RDI_DEV_ASSIGN(rdi);
-		__assign_str(msg, msg);
-	),
-	TP_printk("[%s]: %s", __get_str(dev), __get_str(msg))
-);
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM rvt_qphash
-DECLARE_EVENT_CLASS(rvt_qphash_template,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket),
-	TP_STRUCT__entry(
-		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
-		__field(u32, qpn)
-		__field(u32, bucket)
-	),
-	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
-		__entry->qpn = qp->ibqp.qp_num;
-		__entry->bucket = bucket;
-	),
-	TP_printk(
-		"[%s] qpn 0x%x bucket %u",
-		__get_str(dev),
-		__entry->qpn,
-		__entry->bucket
-	)
-);
-
-DEFINE_EVENT(rvt_qphash_template, rvt_qpinsert,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket));
-
-DEFINE_EVENT(rvt_qphash_template, rvt_qpremove,
-	TP_PROTO(struct rvt_qp *qp, u32 bucket),
-	TP_ARGS(qp, bucket));
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM rvt_tx
-
-#define wr_opcode_name(opcode) { IB_WR_##opcode, #opcode  }
-#define show_wr_opcode(opcode)                             \
-__print_symbolic(opcode,                                   \
-	wr_opcode_name(RDMA_WRITE),                        \
-	wr_opcode_name(RDMA_WRITE_WITH_IMM),               \
-	wr_opcode_name(SEND),                              \
-	wr_opcode_name(SEND_WITH_IMM),                     \
-	wr_opcode_name(RDMA_READ),                         \
-	wr_opcode_name(ATOMIC_CMP_AND_SWP),                \
-	wr_opcode_name(ATOMIC_FETCH_AND_ADD),              \
-	wr_opcode_name(LSO),                               \
-	wr_opcode_name(SEND_WITH_INV),                     \
-	wr_opcode_name(RDMA_READ_WITH_INV),                \
-	wr_opcode_name(LOCAL_INV),                         \
-	wr_opcode_name(MASKED_ATOMIC_CMP_AND_SWP),         \
-	wr_opcode_name(MASKED_ATOMIC_FETCH_AND_ADD))
-
-#define POS_PRN \
-"[%s] wr_id %llx qpn %x psn 0x%x lpsn 0x%x length %u opcode 0x%.2x,%s size %u avail %u head %u last %u"
-
-TRACE_EVENT(
-	rvt_post_one_wr,
-	TP_PROTO(struct rvt_qp *qp, struct rvt_swqe *wqe),
-	TP_ARGS(qp, wqe),
-	TP_STRUCT__entry(
-		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
-		__field(u64, wr_id)
-		__field(u32, qpn)
-		__field(u32, psn)
-		__field(u32, lpsn)
-		__field(u32, length)
-		__field(u32, opcode)
-		__field(u32, size)
-		__field(u32, avail)
-		__field(u32, head)
-		__field(u32, last)
-	),
-	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
-		__entry->wr_id = wqe->wr.wr_id;
-		__entry->qpn = qp->ibqp.qp_num;
-		__entry->psn = wqe->psn;
-		__entry->lpsn = wqe->lpsn;
-		__entry->length = wqe->length;
-		__entry->opcode = wqe->wr.opcode;
-		__entry->size = qp->s_size;
-		__entry->avail = qp->s_avail;
-		__entry->head = qp->s_head;
-		__entry->last = qp->s_last;
-	),
-	TP_printk(
-		POS_PRN,
-		__get_str(dev),
-		__entry->wr_id,
-		__entry->qpn,
-		__entry->psn,
-		__entry->lpsn,
-		__entry->length,
-		__entry->opcode, show_wr_opcode(__entry->opcode),
-		__entry->size,
-		__entry->avail,
-		__entry->head,
-		__entry->last
-	)
-);
-
-#endif /* __RDMAVT_TRACE_H */
-
-#undef TRACE_INCLUDE_PATH
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_PATH .
-#define TRACE_INCLUDE_FILE trace
-#include <trace/define_trace.h>
+#include "trace_rvt.h"
+#include "trace_qp.h"
+#include "trace_tx.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace_qp.h b/drivers/infiniband/sw/rdmavt/trace_qp.h
new file mode 100644
index 0000000..4c77a31
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_qp.h
@@ -0,0 +1,96 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#if !defined(__RVT_TRACE_QP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_QP_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_vt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_qp
+
+DECLARE_EVENT_CLASS(rvt_qphash_template,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+		__field(u32, qpn)
+		__field(u32, bucket)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->bucket = bucket;
+	),
+	TP_printk(
+		"[%s] qpn 0x%x bucket %u",
+		__get_str(dev),
+		__entry->qpn,
+		__entry->bucket
+	)
+);
+
+DEFINE_EVENT(rvt_qphash_template, rvt_qpinsert,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket));
+
+DEFINE_EVENT(rvt_qphash_template, rvt_qpremove,
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
+	TP_ARGS(qp, bucket));
+
+
+#endif /* __RVT_TRACE_QP_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_qp
+#include <trace/define_trace.h>
+
diff --git a/drivers/infiniband/sw/rdmavt/trace_rvt.h b/drivers/infiniband/sw/rdmavt/trace_rvt.h
new file mode 100644
index 0000000..746f334
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_rvt.h
@@ -0,0 +1,81 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#if !defined(__RVT_TRACE_RVT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_RVT_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_vt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt
+
+TRACE_EVENT(rvt_dbg,
+	TP_PROTO(struct rvt_dev_info *rdi,
+		 const char *msg),
+	TP_ARGS(rdi, msg),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(rdi)
+		__string(msg, msg)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(rdi);
+		__assign_str(msg, msg);
+	),
+	TP_printk("[%s]: %s", __get_str(dev), __get_str(msg))
+);
+
+#endif /* __RVT_TRACE_MISC_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_rvt
+#include <trace/define_trace.h>
+
diff --git a/drivers/infiniband/sw/rdmavt/trace_tx.h b/drivers/infiniband/sw/rdmavt/trace_tx.h
new file mode 100644
index 0000000..0e03173
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_tx.h
@@ -0,0 +1,132 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#if !defined(__RVT_TRACE_TX_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_TX_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_vt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_tx
+
+#define wr_opcode_name(opcode) { IB_WR_##opcode, #opcode  }
+#define show_wr_opcode(opcode)                             \
+__print_symbolic(opcode,                                   \
+	wr_opcode_name(RDMA_WRITE),                        \
+	wr_opcode_name(RDMA_WRITE_WITH_IMM),               \
+	wr_opcode_name(SEND),                              \
+	wr_opcode_name(SEND_WITH_IMM),                     \
+	wr_opcode_name(RDMA_READ),                         \
+	wr_opcode_name(ATOMIC_CMP_AND_SWP),                \
+	wr_opcode_name(ATOMIC_FETCH_AND_ADD),              \
+	wr_opcode_name(LSO),                               \
+	wr_opcode_name(SEND_WITH_INV),                     \
+	wr_opcode_name(RDMA_READ_WITH_INV),                \
+	wr_opcode_name(LOCAL_INV),                         \
+	wr_opcode_name(MASKED_ATOMIC_CMP_AND_SWP),         \
+	wr_opcode_name(MASKED_ATOMIC_FETCH_AND_ADD))
+
+#define POS_PRN \
+"[%s] wr_id %llx qpn %x psn 0x%x lpsn 0x%x length %u opcode 0x%.2x,%s size %u avail %u head %u last %u"
+
+TRACE_EVENT(
+	rvt_post_one_wr,
+	TP_PROTO(struct rvt_qp *qp, struct rvt_swqe *wqe),
+	TP_ARGS(qp, wqe),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+		__field(u64, wr_id)
+		__field(u32, qpn)
+		__field(u32, psn)
+		__field(u32, lpsn)
+		__field(u32, length)
+		__field(u32, opcode)
+		__field(u32, size)
+		__field(u32, avail)
+		__field(u32, head)
+		__field(u32, last)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->wr_id = wqe->wr.wr_id;
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->psn = wqe->psn;
+		__entry->lpsn = wqe->lpsn;
+		__entry->length = wqe->length;
+		__entry->opcode = wqe->wr.opcode;
+		__entry->size = qp->s_size;
+		__entry->avail = qp->s_avail;
+		__entry->head = qp->s_head;
+		__entry->last = qp->s_last;
+	),
+	TP_printk(
+		POS_PRN,
+		__get_str(dev),
+		__entry->wr_id,
+		__entry->qpn,
+		__entry->psn,
+		__entry->lpsn,
+		__entry->length,
+		__entry->opcode, show_wr_opcode(__entry->opcode),
+		__entry->size,
+		__entry->avail,
+		__entry->head,
+		__entry->last
+	)
+);
+
+#endif /* __RVT_TRACE_TX_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_tx
+#include <trace/define_trace.h>
+

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
