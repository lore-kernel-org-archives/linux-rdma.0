From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 10/10] verbs: Add a compatibility arch.h
Date: Thu,  9 Feb 2017 14:53:32 -0700
Message-ID: <1486677212-3188-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a bit of software out there that includes arch.h to get the
swap macros. Continue to provider a header that serves that purpose
but emit warnings when it is used.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/CMakeLists.txt |  1 +
 libibverbs/arch.h         | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 libibverbs/arch.h

diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
index 7e18a1e3e71d5e..7a52eddc810911 100644
--- a/libibverbs/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -1,4 +1,5 @@
 publish_headers(infiniband
+  arch.h
   kern-abi.h
   opcode.h
   sa-kern-abi.h
diff --git a/libibverbs/arch.h b/libibverbs/arch.h
new file mode 100644
index 00000000000000..bcbece8f2c521c
--- /dev/null
+++ b/libibverbs/arch.h
@@ -0,0 +1,51 @@
+/*
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
+#ifndef INFINIBAND_ARCH_H
+#define INFINIBAND_ARCH_H
+
+#include <stdint.h>
+#include <endian.h>
+
+#warning "This header is obsolete."
+
+#ifndef ntohll
+#undef htonll
+#undef ntohll
+/* Users should use the glibc functions directly, not these wrappers */
+static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
+static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
+#define htonll htonll
+#define ntohll ntohll
+#endif
+
+/* Barrier macros are no longer provided by libibverbs */
+
+#endif /* INFINIBAND_ARCH_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
