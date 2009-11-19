From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 40/53] IB/qib: Add qib_trace.h
Date: Thu, 19 Nov 2009 15:40:26 -0800
Message-ID: <20091119234026.30356.15383.stgit@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233655.30356.57433.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

creates the qib_trace.h file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_trace.h |   65 +++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_trace.h

diff --git a/drivers/infiniband/hw/qib/qib_trace.h b/drivers/infiniband/hw/qib/qib_trace.h
new file mode 100644
index 0000000..880168e
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_trace.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2008, 2009 QLogic Corporation. All rights reserved.
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
+#ifndef _QIB_TRACE_H
+#define _QIB_TRACE_H
+
+struct qib_evt_buf;
+
+extern struct qib_evt_buf *qib_trace_buf;
+
+void qib_trace_put8(struct qib_evt_buf *buf,
+		   int cpu, u64 tsc, u32 dbgmask, u8);
+
+void qib_trace_put16(struct qib_evt_buf *buf,
+		     int cpu, u64 tsc, u32 dbgmask, u16);
+
+void qib_trace_put32(struct qib_evt_buf *buf,
+		     int cpu, u64 tsc, u32 dbgmask, u32 val);
+
+void qib_trace_put64(struct qib_evt_buf *buf,
+		     int cpu, u64 tsc, u32 dbgmask, u64 val);
+
+void qib_trace_putblob(struct qib_evt_buf *buf,
+		       int cpu, u64 tsc, u32 dbgmask, void *blob, u16 len);
+
+void qib_trace_putstr(struct qib_evt_buf *buf,
+		      int cpu, u64 tsc, u32 dbgmask, const char *str);
+
+void qib_trace_vputstr(struct qib_evt_buf *buf,
+		       int cpu, u64 tsc, u32 dbgmask, const char *fmt, ...)
+		       __attribute__ ((format (printf, 5, 6)));
+
+int __init qib_trace_init(void);
+void qib_trace_fini(void);
+
+#endif

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
