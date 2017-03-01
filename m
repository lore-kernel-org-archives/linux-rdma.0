From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/20] IB/rdmavt: Add tracing for cq entry and poll
Date: Wed, 01 Mar 2017 10:22:21 -0800
Message-ID: <20170301182217.29989.56844.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following fields are defined for filtering and triggering:
- wr_id
- status
- opcode
- qpn
- length
- idx

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/cq.c       |    3 +
 drivers/infiniband/sw/rdmavt/trace.h    |    1 
 drivers/infiniband/sw/rdmavt/trace_cq.h |  127 +++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_cq.h

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 7aa7a4e..0ae2ff8 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -50,6 +50,7 @@
 #include <linux/kthread.h>
 #include "cq.h"
 #include "vt.h"
+#include "trace.h"
 
 /**
  * rvt_cq_enter - add a new entry to the completion queue
@@ -93,6 +94,7 @@ void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
 		}
 		return;
 	}
+	trace_rvt_cq_enter(cq, entry, head);
 	if (cq->ip) {
 		wc->uqueue[head].wr_id = entry->wr_id;
 		wc->uqueue[head].status = entry->status;
@@ -482,6 +484,7 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 		if (tail == wc->head)
 			break;
 		/* The kernel doesn't need a RMB since it has the lock. */
+		trace_rvt_cq_poll(cq, &wc->kqueue[tail], npolled);
 		*entry = wc->kqueue[tail];
 		if (tail >= cq->ibcq.cqe)
 			tail = 0;
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index e2d23ac..89554c0 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -52,3 +52,4 @@
 #include "trace_qp.h"
 #include "trace_tx.h"
 #include "trace_mr.h"
+#include "trace_cq.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace_cq.h b/drivers/infiniband/sw/rdmavt/trace_cq.h
new file mode 100644
index 0000000..a315850
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_cq.h
@@ -0,0 +1,127 @@
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
+#if !defined(__RVT_TRACE_CQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_CQ_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdmavt_cq.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_cq
+
+#define wc_opcode_name(opcode) { IB_WC_##opcode, #opcode  }
+#define show_wc_opcode(opcode)                                \
+__print_symbolic(opcode,                                      \
+	wc_opcode_name(SEND),                                 \
+	wc_opcode_name(RDMA_WRITE),                           \
+	wc_opcode_name(RDMA_READ),                            \
+	wc_opcode_name(COMP_SWAP),                            \
+	wc_opcode_name(FETCH_ADD),                            \
+	wc_opcode_name(LSO),                                  \
+	wc_opcode_name(LOCAL_INV),                            \
+	wc_opcode_name(REG_MR),                               \
+	wc_opcode_name(MASKED_COMP_SWAP),                     \
+	wc_opcode_name(RECV),                                 \
+	wc_opcode_name(RECV_RDMA_WITH_IMM))
+
+#define CQ_PRN \
+"[%s] idx %u wr_id %llx status %u opcode %u,%s length %u qpn %x"
+
+DECLARE_EVENT_CLASS(
+	rvt_cq_entry_template,
+	TP_PROTO(struct rvt_cq *cq, struct ib_wc *wc, u32 idx),
+	TP_ARGS(cq, wc, idx),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(cq->rdi)
+		__field(u64, wr_id)
+		__field(u32, status)
+		__field(u32, opcode)
+		__field(u32, qpn)
+		__field(u32, length)
+		__field(u32, idx)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(cq->rdi)
+		__entry->wr_id = wc->wr_id;
+		__entry->status = wc->status;
+		__entry->opcode = wc->opcode;
+		__entry->length = wc->byte_len;
+		__entry->qpn = wc->qp->qp_num;
+		__entry->idx = idx;
+	),
+	TP_printk(
+		CQ_PRN,
+		__get_str(dev),
+		__entry->idx,
+		__entry->wr_id,
+		__entry->status,
+		__entry->opcode, show_wc_opcode(__entry->opcode),
+		__entry->length,
+		__entry->qpn
+	)
+);
+
+DEFINE_EVENT(
+	rvt_cq_entry_template, rvt_cq_enter,
+	TP_PROTO(struct rvt_cq *cq, struct ib_wc *wc, u32 idx),
+	TP_ARGS(cq, wc, idx));
+
+DEFINE_EVENT(
+	rvt_cq_entry_template, rvt_cq_poll,
+	TP_PROTO(struct rvt_cq *cq, struct ib_wc *wc, u32 idx),
+	TP_ARGS(cq, wc, idx));
+
+#endif /* __RVT_TRACE_CQ_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_cq
+#include <trace/define_trace.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
