From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/23] IB/rdmavt: Add trace of MR segs
Date: Wed, 07 Dec 2016 19:33:20 -0800
Message-ID: <20161208033318.21135.79304.stgit@scvm10.sc.intel.com>
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

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add tracing of MR segment information.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c       |    4 +
 drivers/infiniband/sw/rdmavt/trace.h    |    1 
 drivers/infiniband/sw/rdmavt/trace_mr.h |  112 +++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_mr.h

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 4acf179..562cf78 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -51,6 +51,7 @@
 #include <rdma/rdma_vt.h>
 #include "vt.h"
 #include "mr.h"
+#include "trace.h"
 
 /**
  * rvt_driver_mr_init - Init MR resources per driver
@@ -403,6 +404,7 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		}
 		mr->mr.map[m]->segs[n].vaddr = vaddr;
 		mr->mr.map[m]->segs[n].length = umem->page_size;
+		trace_rvt_mr_user_seg(&mr->mr, m, n, vaddr, umem->page_size);
 		n++;
 		if (n == RVT_SEGSZ) {
 			m++;
@@ -507,6 +509,7 @@ static int rvt_set_page(struct ib_mr *ibmr, u64 addr)
 	n = mapped_segs % RVT_SEGSZ;
 	mr->mr.map[m]->segs[n].vaddr = (void *)addr;
 	mr->mr.map[m]->segs[n].length = ps;
+	trace_rvt_mr_page_seg(&mr->mr, m, n, (void *)addr, ps);
 	mr->mr.length += ps;
 
 	return 0;
@@ -693,6 +696,7 @@ int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 	for (i = 0; i < list_len; i++) {
 		fmr->mr.map[m]->segs[n].vaddr = (void *)page_list[i];
 		fmr->mr.map[m]->segs[n].length = ps;
+		trace_rvt_mr_fmr_seg(&fmr->mr, m, n, (void *)page_list[i], ps);
 		if (++n == RVT_SEGSZ) {
 			m++;
 			n = 0;
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index 11a2afb..e2d23ac 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -51,3 +51,4 @@
 #include "trace_rvt.h"
 #include "trace_qp.h"
 #include "trace_tx.h"
+#include "trace_mr.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace_mr.h b/drivers/infiniband/sw/rdmavt/trace_mr.h
new file mode 100644
index 0000000..3318a6c
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_mr.h
@@ -0,0 +1,112 @@
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
+#if !defined(__RVT_TRACE_MR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_MR_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_mr.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_mr
+DECLARE_EVENT_CLASS(
+	rvt_mr_template,
+	TP_PROTO(struct rvt_mregion *mr, u16 m, u16 n, void *v, size_t len),
+	TP_ARGS(mr, m, n, v, len),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(mr->pd->device))
+		__field(void *, vaddr)
+		__field(struct page *, page)
+		__field(size_t, len)
+		__field(u32, lkey)
+		__field(u16, m)
+		__field(u16, n)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(mr->pd->device));
+		__entry->vaddr = v;
+		__entry->page = virt_to_page(v);
+		__entry->m = m;
+		__entry->n = n;
+		__entry->len = len;
+	),
+	TP_printk(
+		"[%s] vaddr %p page %p m %u n %u len %ld",
+		__get_str(dev),
+		__entry->vaddr,
+		__entry->page,
+		__entry->m,
+		__entry->n,
+		__entry->len
+	)
+);
+
+DEFINE_EVENT(
+	rvt_mr_template, rvt_mr_page_seg,
+	TP_PROTO(struct rvt_mregion *mr, u16 m, u16 n, void *v, size_t len),
+	TP_ARGS(mr, m, n, v, len));
+
+DEFINE_EVENT(
+	rvt_mr_template, rvt_mr_fmr_seg,
+	TP_PROTO(struct rvt_mregion *mr, u16 m, u16 n, void *v, size_t len),
+	TP_ARGS(mr, m, n, v, len));
+
+DEFINE_EVENT(
+	rvt_mr_template, rvt_mr_user_seg,
+	TP_PROTO(struct rvt_mregion *mr, u16 m, u16 n, void *v, size_t len),
+	TP_ARGS(mr, m, n, v, len));
+
+#endif /* __RVT_TRACE_MR_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_mr
+#include <trace/define_trace.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
