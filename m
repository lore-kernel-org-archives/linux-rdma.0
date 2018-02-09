From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 5/7] Support distros that have old kernel uapi headers
Date: Thu,  8 Feb 2018 20:09:02 -0700
Message-ID: <20180209030904.22370-6-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Old distros don't allow linux/in.h and others to be included after the
glibc headers that define conflicting definitions.

We don't actually need the linux headers, so just replace them with empty
files on the old distros.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                     | 14 ++++++++++++++
 buildlib/fixup-include/linux-in.h  |  2 ++
 buildlib/fixup-include/linux-in6.h |  2 ++
 3 files changed, 18 insertions(+)
 create mode 100644 buildlib/fixup-include/linux-in.h
 create mode 100644 buildlib/fixup-include/linux-in6.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e63f4cf563677a..3ba9a0bc6989d2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -250,6 +250,17 @@ CHECK_C_SOURCE_COMPILES("
   HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
   FAIL_REGEX "warning")
 
+# glibc and kernel uapi headers can co-exist
+CHECK_C_SOURCE_COMPILES("
+ #include <sys/socket.h>
+ #include <netinet/in.h>
+ #include <linux/in.h>
+ #include <linux/in6.h>
+ int main(int argc,const char *argv[]) { return 0; }"
+  HAVE_GLIBC_UAPI_COMPAT)
+RDMA_DoFixup("${HAVE_GLIBC_UAPI_COMPAT}" "linux/in.h")
+RDMA_DoFixup("${HAVE_GLIBC_UAPI_COMPAT}" "linux/in6.h")
+
 # Provide a shim if C11 stdatomic.h is not supported.
 if (NOT HAVE_SPARSE)
   CHECK_INCLUDE_FILE("stdatomic.h" HAVE_STDATOMIC)
@@ -522,3 +533,6 @@ endif()
 if (NOT HAVE_C_WREDUNDANT_DECLS)
   message(STATUS " -Wredundant-decls does NOT work")
 endif()
+if (NOT HAVE_GLIBC_UAPI_COMPAT)
+  message(STATUS " libc netinet/in.h and linux/in.h do NOT coexist")
+endif()
diff --git a/buildlib/fixup-include/linux-in.h b/buildlib/fixup-include/linux-in.h
new file mode 100644
index 00000000000000..07fdbdaeec44e8
--- /dev/null
+++ b/buildlib/fixup-include/linux-in.h
@@ -0,0 +1,2 @@
+/* if in.h can't be included just leave it empty */
+#include <netinet/in.h>
diff --git a/buildlib/fixup-include/linux-in6.h b/buildlib/fixup-include/linux-in6.h
new file mode 100644
index 00000000000000..87965b368c9562
--- /dev/null
+++ b/buildlib/fixup-include/linux-in6.h
@@ -0,0 +1,2 @@
+/* if in6.h can't be included just leave it empty */
+#include <netinet/in.h>
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
