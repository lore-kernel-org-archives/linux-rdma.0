From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 2/5] utils: Create utils directory to put all common code and move min/max into it
Date: Sun, 25 Sep 2016 09:50:04 +0300
Message-ID: <1474786207-2149-3-git-send-email-leon@kernel.org>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474786207-2149-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 CMakeLists.txt                    |  6 ++++++
 ibacm/linux/osd.h                 |  5 ++---
 libibverbs/examples/rc_pingpong.c |  8 +------
 libmlx5/src/mlx5.h                | 16 ++------------
 librdmacm/src/cma.h               |  5 ++---
 utils/math.h                      | 44 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 27 deletions(-)
 create mode 100644 utils/math.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 557d3a8..c997c6d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -38,6 +38,8 @@ set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
 set(BUILD_BIN ${CMAKE_BINARY_DIR}/bin)
 # Libraries
 set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
+# Common code
+set(COMMON_CODE utils)
 
 # Location to place provider .driver files
 set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
@@ -139,6 +141,10 @@ RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undef
 find_package(LDSymVer REQUIRED)
 
 #-------------------------
+# Common code
+include_directories(${COMMON_CODE})
+
+#-------------------------
 # Find libraries
 # pthread
 FIND_PACKAGE (Threads REQUIRED)
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 5ca4c6f..ec18f7b 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,6 +46,8 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
+#include "../../utils/math.h"
+
 #define ACM_CONF_DIR  IBACM_CONFIG_PATH
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
@@ -56,9 +58,6 @@
 #define container_of(ptr, type, field) \
 	((type *) ((void *) ptr - offsetof(type, field)))
 
-#define min(a, b) (a < b ? a : b)
-#define max(a, b) (a > b ? a : b)
-
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x) bswap_64(x)
 #else
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 9676783..cc45741 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -49,13 +49,7 @@
 
 #include "pingpong.h"
 
-#ifndef max
-#define max(x, y) (((x) > (y)) ? (x) : (y))
-#endif
-
-#ifndef min
-#define min(x, y) (((x) < (y)) ? (x) : (y))
-#endif
+#include "../../utils/math.h"
 
 enum {
 	PINGPONG_RECV_WRID = 1,
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index dc90892..453aeb8 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -42,6 +42,8 @@
 #include "list.h"
 #include "bitmap.h"
 
+#include "../../utils/math.h"
+
 #ifdef __GNUC__
 #define likely(x)	__builtin_expect((x), 1)
 #define unlikely(x)	__builtin_expect((x), 0)
@@ -91,20 +93,6 @@
 
 #endif
 
-#ifndef min
-#define min(a, b) \
-	({ typeof(a) _a = (a); \
-	   typeof(b) _b = (b); \
-	   _a < _b ? _a : _b; })
-#endif
-
-#ifndef max
-#define max(a, b) \
-	({ typeof(a) _a = (a); \
-	   typeof(b) _b = (b); \
-	   _a > _b ? _a : _b; })
-#endif
-
 #define HIDDEN		__attribute__((visibility("hidden")))
 
 #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index 98eba8d..d640688 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -47,6 +47,8 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
+#include "../../utils/math.h"
+
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
 #   ifndef VALGRIND_MAKE_MEM_DEFINED
@@ -68,9 +70,6 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
-#define max(a, b) ((a) > (b) ? a : b)
-#define min(a, b) ((a) < (b) ? a : b)
-
 #ifndef container_of
 #define container_of(ptr, type, field) \
 	((type *) ((void *)ptr - offsetof(type, field)))
diff --git a/utils/math.h b/utils/math.h
new file mode 100644
index 0000000..ffef543
--- /dev/null
+++ b/utils/math.h
@@ -0,0 +1,44 @@
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
+ *
+ */
+
+#ifndef _RDMA_MATH_H_
+#define _RDMA_MATH_H_
+/*
+ * This include contains all common mathematical functions
+ */
+#ifndef min
+#define min(a, b)	(((a) < (b)) ? (a) : (b))
+#endif
+
+#ifndef max
+#define max(a, b) 	(((a) > (b)) ? (a) : (b))
+#endif
+#endif /* _RDMA_MATH_H_ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
