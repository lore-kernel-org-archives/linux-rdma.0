From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] Fix compiler warnings on PPC64 and others
Date: Thu, 8 Feb 2018 15:45:06 -0700
Message-ID: <20180208224506.GA2462@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have places in our code that assume __u64 is unsigned long long, and in
general this is the Linux kernel standard. However a few archs still use
unsigned long by default and require a -D__SANE_USERSPACE_TYPES__ to get
long long.

Detect this and provide the define to eliminate compilation warnings.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e63f4cf563677a..b08d3fd2cf4246 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -250,6 +250,20 @@ CHECK_C_SOURCE_COMPILES("
   HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
   FAIL_REGEX "warning")
 
+# Linux __u64 is an unsigned long long
+CHECK_C_SOURCE_COMPILES("
+#include <linux/types.h>
+ int main(int argc,const char *argv[]) { __u64 tmp = 0; unsigned long long *tmp2 = &tmp; return *tmp2; }"
+  HAVE_LONG_LONG_U64
+  FAIL_REGEX "warning")
+
+if (NOT HAVE_LONG_LONG_U64)
+  # Modern Linux has switched to use ull in all cases, but to avoid disturbing
+  # userspace some platforms continued to use unsigned long by default. This
+  # define will cause kernel headers to consistently use unsigned long long
+  add_definitions("-D__SANE_USERSPACE_TYPES__")
+endif()
+
 # Provide a shim if C11 stdatomic.h is not supported.
 if (NOT HAVE_SPARSE)
   CHECK_INCLUDE_FILE("stdatomic.h" HAVE_STDATOMIC)
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
