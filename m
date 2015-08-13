From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Remove inline from trace functions
Date: Thu, 13 Aug 2015 16:05:24 -0400
Message-ID: <20150813200524.28650.91753.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Inline in trace functions causes the following build error when
CONFIG_OPTIMIZE_INLINING is not defined in the kernel config:
error: function can never be inlined because it uses
variable argument lists

Reported by 0-day build:
https://lists.01.org/pipermail/kbuild-all/2015-August/011215.html

This patch converts to a non-inline version of the hfi1 trace functions

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/trace.c |   15 ++++++++++-
 drivers/staging/hfi1/trace.h |   56 +++++++++++++++++-------------------------
 2 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hfi1/trace.c b/drivers/staging/hfi1/trace.c
index afbb212..ea95591 100644
--- a/drivers/staging/hfi1/trace.c
+++ b/drivers/staging/hfi1/trace.c
@@ -48,7 +48,6 @@
  *
  */
 #define CREATE_TRACE_POINTS
-#define HFI1_TRACE_DO_NOT_CREATE_INLINES
 #include "trace.h"
 
 u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr)
@@ -208,4 +207,16 @@ const char *print_u64_array(
 	return ret;
 }
 
-#undef HFI1_TRACE_DO_NOT_CREATE_INLINES
+__hfi1_trace_fn(PKT);
+__hfi1_trace_fn(PROC);
+__hfi1_trace_fn(SDMA);
+__hfi1_trace_fn(LINKVERB);
+__hfi1_trace_fn(DEBUG);
+__hfi1_trace_fn(SNOOP);
+__hfi1_trace_fn(CNTR);
+__hfi1_trace_fn(PIO);
+__hfi1_trace_fn(DC8051);
+__hfi1_trace_fn(FIRMWARE);
+__hfi1_trace_fn(RCVCTRL);
+__hfi1_trace_fn(TID);
+
diff --git a/drivers/staging/hfi1/trace.h b/drivers/staging/hfi1/trace.h
index 5c34606..d7851c0 100644
--- a/drivers/staging/hfi1/trace.h
+++ b/drivers/staging/hfi1/trace.h
@@ -1339,22 +1339,17 @@ DECLARE_EVENT_CLASS(hfi1_trace_template,
 
 /*
  * It may be nice to macroize the __hfi1_trace but the va_* stuff requires an
- * actual function to work and can not be in a macro. Also the fmt can not be a
- * constant char * because we need to be able to manipulate the \n if it is
- * present.
+ * actual function to work and can not be in a macro.
  */
-#define __hfi1_trace_event(lvl) \
+#define __hfi1_trace_def(lvl) \
+void __hfi1_trace_##lvl(const char *funct, char *fmt, ...);		\
+									\
 DEFINE_EVENT(hfi1_trace_template, hfi1_ ##lvl,				\
 	TP_PROTO(const char *function, struct va_format *vaf),		\
 	TP_ARGS(function, vaf))
 
-#ifdef HFI1_TRACE_DO_NOT_CREATE_INLINES
-#define __hfi1_trace_fn(fn) __hfi1_trace_event(fn)
-#else
-#define __hfi1_trace_fn(fn) \
-__hfi1_trace_event(fn); \
-__printf(2, 3) \
-static inline void __hfi1_trace_##fn(const char *func, char *fmt, ...)	\
+#define __hfi1_trace_fn(lvl) \
+void __hfi1_trace_##lvl(const char *func, char *fmt, ...)		\
 {									\
 	struct va_format vaf = {					\
 		.fmt = fmt,						\
@@ -1363,36 +1358,29 @@ static inline void __hfi1_trace_##fn(const char *func, char *fmt, ...)	\
 									\
 	va_start(args, fmt);						\
 	vaf.va = &args;							\
-	trace_hfi1_ ##fn(func, &vaf);					\
+	trace_hfi1_ ##lvl(func, &vaf);					\
 	va_end(args);							\
 	return;								\
 }
-#endif
 
 /*
- * To create a new trace level simply define it as below. This will create all
- * the hooks for calling hfi1_cdbg(LVL, fmt, ...); as well as take care of all
+ * To create a new trace level simply define it below and as a __hfi1_trace_fn
+ * in trace.c. This will create all the hooks for calling
+ * hfi1_cdbg(LVL, fmt, ...); as well as take care of all
  * the debugfs stuff.
  */
-__hfi1_trace_fn(RVPKT);
-__hfi1_trace_fn(INIT);
-__hfi1_trace_fn(VERB);
-__hfi1_trace_fn(PKT);
-__hfi1_trace_fn(PROC);
-__hfi1_trace_fn(MM);
-__hfi1_trace_fn(ERRPKT);
-__hfi1_trace_fn(SDMA);
-__hfi1_trace_fn(VPKT);
-__hfi1_trace_fn(LINKVERB);
-__hfi1_trace_fn(VERBOSE);
-__hfi1_trace_fn(DEBUG);
-__hfi1_trace_fn(SNOOP);
-__hfi1_trace_fn(CNTR);
-__hfi1_trace_fn(PIO);
-__hfi1_trace_fn(DC8051);
-__hfi1_trace_fn(FIRMWARE);
-__hfi1_trace_fn(RCVCTRL);
-__hfi1_trace_fn(TID);
+__hfi1_trace_def(PKT);
+__hfi1_trace_def(PROC);
+__hfi1_trace_def(SDMA);
+__hfi1_trace_def(LINKVERB);
+__hfi1_trace_def(DEBUG);
+__hfi1_trace_def(SNOOP);
+__hfi1_trace_def(CNTR);
+__hfi1_trace_def(PIO);
+__hfi1_trace_def(DC8051);
+__hfi1_trace_def(FIRMWARE);
+__hfi1_trace_def(RCVCTRL);
+__hfi1_trace_def(TID);
 
 #define hfi1_cdbg(which, fmt, ...) \
 	__hfi1_trace_##which(__func__, fmt, ##__VA_ARGS__)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
