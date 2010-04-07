From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/37] librdmacm: move common definitions to internal header file
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <A7B37FB6E15D43979E919E8956DC8C4F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 Makefile.am |    2 +-
 src/cma.c   |   28 +---------------------
 src/cma.h   |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 2898ad9..c9be437 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -70,7 +70,7 @@ man_MANS = \
 
 EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
 	     include/infiniband/ib.h \
-	     src/librdmacm.map librdmacm.spec.in $(man_MANS)
+	     src/cma.h src/librdmacm.map librdmacm.spec.in $(man_MANS)
 
 dist-hook: librdmacm.spec
 	cp librdmacm.spec $(distdir)
diff --git a/src/cma.c b/src/cma.c
index c83d9d2..a85448b 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -50,39 +50,13 @@
 #include <byteswap.h>
 #include <stddef.h>
 
+#include "cma.h"
 #include <infiniband/driver.h>
 #include <infiniband/marshall.h>
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_cma_abi.h>
 #include <infiniband/ib.h>
 
-#ifdef INCLUDE_VALGRIND
-#   include <valgrind/memcheck.h>
-#   ifndef VALGRIND_MAKE_MEM_DEFINED
-#       warning "Valgrind requested, but VALGRIND_MAKE_MEM_DEFINED undefined"
-#   endif
-#endif
-
-#ifndef VALGRIND_MAKE_MEM_DEFINED
-#   define VALGRIND_MAKE_MEM_DEFINED(addr,len)
-#endif
-
-#define PFX "librdmacm: "
-
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-static inline uint64_t htonll(uint64_t x) { return bswap_64(x); }
-static inline uint64_t ntohll(uint64_t x) { return bswap_64(x); }
-#else
-static inline uint64_t htonll(uint64_t x) { return x; }
-static inline uint64_t ntohll(uint64_t x) { return x; }
-#endif
-
-static inline int ERR(int err)
-{
-	errno = err;
-	return -1;
-}
-
 #define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
 do {                                        \
 	struct ucma_abi_cmd_hdr *hdr;         \
diff --git a/src/cma.h b/src/cma.h
new file mode 100644
index 0000000..1c0ab8b
--- /dev/null
+++ b/src/cma.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c) 2005-2010 Intel Corporation.  All rights reserved.
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
+ *
+ */
+
+#if !defined(CMA_H)
+#define CMA_H
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif /* HAVE_CONFIG_H */
+
+#include <stdlib.h>
+#include <errno.h>
+#include <endian.h>
+#include <byteswap.h>
+
+#ifdef INCLUDE_VALGRIND
+#   include <valgrind/memcheck.h>
+#   ifndef VALGRIND_MAKE_MEM_DEFINED
+#       warning "Valgrind requested, but VALGRIND_MAKE_MEM_DEFINED undefined"
+#   endif
+#endif
+
+#ifndef VALGRIND_MAKE_MEM_DEFINED
+#   define VALGRIND_MAKE_MEM_DEFINED(addr,len)
+#endif
+
+#define PFX "librdmacm: "
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+static inline uint64_t htonll(uint64_t x) { return bswap_64(x); }
+static inline uint64_t ntohll(uint64_t x) { return bswap_64(x); }
+#else
+static inline uint64_t htonll(uint64_t x) { return x; }
+static inline uint64_t ntohll(uint64_t x) { return x; }
+#endif
+
+static inline int ERR(int err)
+{
+	errno = err;
+	return -1;
+}
+
+#endif /* CMA_H */
+



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
