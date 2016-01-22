From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/8] IB/rdmavt: Add support for tracing events
Date: Fri, 22 Jan 2016 13:00:28 -0800
Message-ID: <20160122210027.7850.77171.stgit@scvm10.sc.intel.com>
References: <20160122205822.7850.25466.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205822.7850.25466.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds support of tracing events using the kernels built-in event
tracing infrastructure. This can be extended to provide a wide range of
trace and debug capabilities which have a negligible impact on performance
when enabled. These should be preferred over the use of the rvt_pr*
functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/Makefile |    5 ++
 drivers/infiniband/sw/rdmavt/trace.c  |   49 +++++++++++++++++++
 drivers/infiniband/sw/rdmavt/trace.h  |   86 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c     |    5 ++
 4 files changed, 143 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.c
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.h

diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index 00f0188..ccaa799 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,4 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o
+rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o \
+	trace.o
+
+CFLAGS_trace.o = -I$(src)
diff --git a/drivers/infiniband/sw/rdmavt/trace.c b/drivers/infiniband/sw/rdmavt/trace.c
new file mode 100644
index 0000000..19afe39
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright(c) 2015 Intel Corporation.
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
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
new file mode 100644
index 0000000..22e86ff
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright(c) 2015 Intel Corporation.
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
+
+#undef TRACE_SYSTEM_VAR
+#define TRACE_SYSTEM_VAR rdmavt
+
+#if !defined(__RDMAVT_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RDMAVT_TRACE_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include <rdma/rdma_vt.h>
+
+#define RDI_DEV_ENTRY(rdi)   __string(dev, rdi->driver_f.get_card_name(rdi))
+#define RDI_DEV_ASSIGN(rdi)  __assign_str(dev, rdi->driver_f.get_card_name(rdi))
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rdmavt
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
+#endif /* __RDMAVT_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 136cc21..7f56a42 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -48,6 +48,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include "vt.h"
+#include "trace.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("RDMA Verbs Transport Library");
@@ -259,7 +260,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 		return -EINVAL;
 	}
 
-	/* Once we get past here we can use the rvt_pr macros */
+	/* Once we get past here we can use rvt_pr macros and tracepoints */
+	trace_rvt_dbg(rdi, "Driver attempting registration");
 	rvt_mmap_init(rdi);
 
 	/* Dev Ops */
@@ -370,6 +372,7 @@ EXPORT_SYMBOL(rvt_register_device);
 
 void rvt_unregister_device(struct rvt_dev_info *rdi)
 {
+	trace_rvt_dbg(rdi, "Driver is unregistering.");
 	if (!rdi)
 		return;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
