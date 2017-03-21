From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 13/20] IB/rdmavt, IB/hfi1: Fix timer migration regressions
Date: Mon, 20 Mar 2017 17:25:55 -0700
Message-ID: <20170321002553.28538.16097.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

RC timeout counter isn't getting incremented.
Increment counter and add the trace for it.

Fixes: 87c23b4ab018 ("IB/rdmavt: Adding timer logic to rdmavt")
Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace_rc.h   |    7 --
 drivers/infiniband/sw/rdmavt/qp.c       |    6 +-
 drivers/infiniband/sw/rdmavt/trace.h    |    3 +
 drivers/infiniband/sw/rdmavt/trace_rc.h |  109 +++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+), 8 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rc.h

diff --git a/drivers/infiniband/hw/hfi1/trace_rc.h b/drivers/infiniband/hw/hfi1/trace_rc.h
index 5ea5005..8ce4765 100644
--- a/drivers/infiniband/hw/hfi1/trace_rc.h
+++ b/drivers/infiniband/hw/hfi1/trace_rc.h
@@ -1,5 +1,5 @@
 /*
-* Copyright(c) 2015, 2016 Intel Corporation.
+* Copyright(c) 2015, 2016, 2017 Intel Corporation.
 *
 * This file is provided under a dual BSD/GPLv2 license.  When using or
 * redistributing this file, you may do so under either license.
@@ -104,11 +104,6 @@
 	     TP_ARGS(qp, psn)
 );
 
-DEFINE_EVENT(hfi1_rc_template, hfi1_timeout,
-	     TP_PROTO(struct rvt_qp *qp, u32 psn),
-	     TP_ARGS(qp, psn)
-);
-
 DEFINE_EVENT(hfi1_rc_template, hfi1_rcv_error,
 	     TP_PROTO(struct rvt_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 3c55a8b..d7dabdf 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2016, 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -2052,8 +2052,12 @@ static void rvt_rc_timeout(unsigned long arg)
 	spin_lock_irqsave(&qp->r_lock, flags);
 	spin_lock(&qp->s_lock);
 	if (qp->s_flags & RVT_S_TIMER) {
+		struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
+
 		qp->s_flags &= ~RVT_S_TIMER;
+		rvp->n_rc_timeouts++;
 		del_timer(&qp->s_timer);
+		trace_rvt_rc_timeout(qp, qp->s_last_psn + 1);
 		if (rdi->driver_f.notify_restart_rc)
 			rdi->driver_f.notify_restart_rc(qp,
 							qp->s_last_psn + 1,
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index 89554c0..bb4b1e7 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2016, 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -53,3 +53,4 @@
 #include "trace_tx.h"
 #include "trace_mr.h"
 #include "trace_cq.h"
+#include "trace_rc.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace_rc.h b/drivers/infiniband/sw/rdmavt/trace_rc.h
new file mode 100644
index 0000000..9952769
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace_rc.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright(c) 2017 Intel Corporation.
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
+#if !defined(__RVT_TRACE_RC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVT_TRACE_RC_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_vt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_rc
+
+DECLARE_EVENT_CLASS(rvt_rc_template,
+		    TP_PROTO(struct rvt_qp *qp, u32 psn),
+		    TP_ARGS(qp, psn),
+		    TP_STRUCT__entry(
+			RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+			__field(u32, qpn)
+			__field(u32, s_flags)
+			__field(u32, psn)
+			__field(u32, s_psn)
+			__field(u32, s_next_psn)
+			__field(u32, s_sending_psn)
+			__field(u32, s_sending_hpsn)
+			__field(u32, r_psn)
+			),
+		    TP_fast_assign(
+			RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+			__entry->qpn = qp->ibqp.qp_num;
+			__entry->s_flags = qp->s_flags;
+			__entry->psn = psn;
+			__entry->s_psn = qp->s_psn;
+			__entry->s_next_psn = qp->s_next_psn;
+			__entry->s_sending_psn = qp->s_sending_psn;
+			__entry->s_sending_hpsn = qp->s_sending_hpsn;
+			__entry->r_psn = qp->r_psn;
+			),
+		    TP_printk(
+			"[%s] qpn 0x%x s_flags 0x%x psn 0x%x s_psn 0x%x s_next_psn 0x%x s_sending_psn 0x%x sending_hpsn 0x%x r_psn 0x%x",
+			__get_str(dev),
+			__entry->qpn,
+			__entry->s_flags,
+			__entry->psn,
+			__entry->s_psn,
+			__entry->s_next_psn,
+			__entry->s_sending_psn,
+			__entry->s_sending_hpsn,
+			__entry->r_psn
+			)
+);
+
+DEFINE_EVENT(rvt_rc_template, rvt_rc_timeout,
+	     TP_PROTO(struct rvt_qp *qp, u32 psn),
+	     TP_ARGS(qp, psn)
+);
+
+#endif /* __RVT_TRACE_RC_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_rc
+#include <trace/define_trace.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
