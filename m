From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/5] ccan: Add CCAN min and max functionality
Date: Wed, 28 Sep 2016 18:33:06 +0300
Message-ID: <1475076789-14359-3-git-send-email-yishaih@mellanox.com>
References: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475076789-14359-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add CCAN min/max functionality and use it among the project.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                    |  1 +
 buildlib/publish_headers.cmake    | 18 ++++++++---
 ccan/CMakeLists.txt               |  5 +++
 ccan/build_assert.h               | 40 ++++++++++++++++++++++++
 ccan/config.h                     |  2 ++
 ccan/minmax.h                     | 65 +++++++++++++++++++++++++++++++++++++++
 ibacm/linux/osd.h                 |  5 ++-
 libibverbs/examples/rc_pingpong.c |  8 +----
 libmlx5/src/mlx5.h                | 15 +--------
 librdmacm/src/cma.h               |  5 ++-
 10 files changed, 133 insertions(+), 31 deletions(-)
 create mode 100644 ccan/CMakeLists.txt
 create mode 100644 ccan/build_assert.h
 create mode 100644 ccan/config.h
 create mode 100644 ccan/minmax.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a829cd4..34a21d1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -221,6 +221,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 
 #-------------------------
 # Sub-directories
+add_subdirectory(ccan)
 # Libraries
 add_subdirectory(libibumad/src)
 add_subdirectory(libibumad/man)
diff --git a/buildlib/publish_headers.cmake b/buildlib/publish_headers.cmake
index ccd2296..c1909d6 100644
--- a/buildlib/publish_headers.cmake
+++ b/buildlib/publish_headers.cmake
@@ -1,10 +1,9 @@
 # COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
 
-# Copy headers from the source directory to the proper place in the
-# build/include directory
-function(PUBLISH_HEADERS DEST)
+# Same as publish_headers but does not install them during the install phase
+function(publish_internal_headers DEST)
   if(NOT ARGN)
-    message(SEND_ERROR "Error: PUBLISH_HEADERS called without any files")
+    message(SEND_ERROR "Error: publish_internal_headers called without any files")
     return()
   endif()
 
@@ -15,6 +14,17 @@ function(PUBLISH_HEADERS DEST)
     get_filename_component(FIL ${SFIL} NAME)
     execute_process(COMMAND "ln" "-Tsf"
       "${CMAKE_CURRENT_SOURCE_DIR}/${SFIL}" "${DDIR}/${FIL}")
+  endforeach()
+endfunction()
+
+# Copy headers from the source directory to the proper place in the
+# build/include directory. This also installs them into /usr/include/xx during
+# the install phase
+function(publish_headers DEST)
+  publish_internal_headers("${DEST}" ${ARGN})
+
+  foreach(SFIL ${ARGN})
+    get_filename_component(FIL ${SFIL} NAME)
     install(FILES "${SFIL}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DEST}/" RENAME "${FIL}")
   endforeach()
 endfunction()
diff --git a/ccan/CMakeLists.txt b/ccan/CMakeLists.txt
new file mode 100644
index 0000000..8c5f750
--- /dev/null
+++ b/ccan/CMakeLists.txt
@@ -0,0 +1,5 @@
+publish_internal_headers(ccan
+  minmax.h
+  build_assert.h
+  config.h
+  )
diff --git a/ccan/build_assert.h b/ccan/build_assert.h
new file mode 100644
index 0000000..b9ecd84
--- /dev/null
+++ b/ccan/build_assert.h
@@ -0,0 +1,40 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_BUILD_ASSERT_H
+#define CCAN_BUILD_ASSERT_H
+
+/**
+ * BUILD_ASSERT - assert a build-time dependency.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can only be used within a function.
+ *
+ * Example:
+ *	#include <stddef.h>
+ *	...
+ *	static char *foo_to_char(struct foo *foo)
+ *	{
+ *		// This code needs string to be at start of foo.
+ *		BUILD_ASSERT(offsetof(struct foo, string) == 0);
+ *		return (char *)foo;
+ *	}
+ */
+#define BUILD_ASSERT(cond) \
+	do { (void) sizeof(char [1 - 2*!(cond)]); } while(0)
+
+/**
+ * BUILD_ASSERT_OR_ZERO - assert a build-time dependency, as an expression.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can be used in an expression: its value is "0".
+ *
+ * Example:
+ *	#define foo_to_char(foo)					\
+ *		 ((char *)(foo)						\
+ *		  + BUILD_ASSERT_OR_ZERO(offsetof(struct foo, string) == 0))
+ */
+#define BUILD_ASSERT_OR_ZERO(cond) \
+	(sizeof(char [1 - 2*!(cond)]) - 1)
+
+#endif /* CCAN_BUILD_ASSERT_H */
diff --git a/ccan/config.h b/ccan/config.h
new file mode 100644
index 0000000..b89ac94
--- /dev/null
+++ b/ccan/config.h
@@ -0,0 +1,2 @@
+#define HAVE_STATEMENT_EXPR 1
+#define HAVE_TYPEOF 1
diff --git a/ccan/minmax.h b/ccan/minmax.h
new file mode 100644
index 0000000..5642f65
--- /dev/null
+++ b/ccan/minmax.h
@@ -0,0 +1,65 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_MINMAX_H
+#define CCAN_MINMAX_H
+
+#include "config.h"
+
+#include <ccan/build_assert.h>
+
+#if !HAVE_STATEMENT_EXPR || !HAVE_TYPEOF
+/*
+ * Without these, there's no way to avoid unsafe double evaluation of
+ * the arguments
+ */
+#error Sorry, minmax module requires statement expressions and typeof
+#endif
+
+#if HAVE_BUILTIN_TYPES_COMPATIBLE_P
+#define MINMAX_ASSERT_COMPATIBLE(a, b) \
+	BUILD_ASSERT(__builtin_types_compatible_p(a, b))
+#else
+#define MINMAX_ASSERT_COMPATIBLE(a, b) \
+	do { } while (0)
+#endif
+
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
+		_a < _b ? _a : _b; \
+	})
+
+#define max(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
+		_a > _b ? _a : _b; \
+	})
+
+#define clamp(v, f, c)	(max(min((v), (c)), (f)))
+
+
+#define min_t(t, a, b) \
+	({ \
+		t _ta = (a); \
+		t _tb = (b); \
+		min(_ta, _tb); \
+	})
+#define max_t(t, a, b) \
+	({ \
+		t _ta = (a); \
+		t _tb = (b); \
+		max(_ta, _tb); \
+	})
+
+#define clamp_t(t, v, f, c) \
+	({ \
+		t _tv = (v); \
+		t _tf = (f); \
+		t _tc = (c); \
+		clamp(_tv, _tf, _tc); \
+	})
+
+#endif /* CCAN_MINMAX_H */
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 0113d10..f03980f 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,6 +46,8 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
+#include <ccan/minmax.h>
+
 #define ACM_CONF_DIR  IBACM_CONFIG_PATH
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
@@ -53,9 +55,6 @@
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
-#define min(a, b) (a < b ? a : b)
-#define max(a, b) (a > b ? a : b)
-
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x) bswap_64(x)
 #else
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 9676783..3ea4670 100644
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
+#include <ccan/minmax.h>
 
 enum {
 	PINGPONG_RECV_WRID = 1,
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index dc90892..80c69a4 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -41,6 +41,7 @@
 #include "mlx5-abi.h"
 #include "list.h"
 #include "bitmap.h"
+#include <ccan/minmax.h>
 
 #ifdef __GNUC__
 #define likely(x)	__builtin_expect((x), 1)
@@ -91,20 +92,6 @@
 
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
index e773591..68abe54 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -47,6 +47,8 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
+#include <ccan/minmax.h>
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
 /*
  * Fast synchronization for low contention locking.
  */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
