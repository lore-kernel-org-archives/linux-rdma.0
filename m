From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/4] Detect if infiniband/arch.h is supported by the compiler
Date: Tue, 10 Jan 2017 12:02:09 -0700
Message-ID: <1484074931-3847-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484074931-3847-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If not then disable compiling providers that require coherent DMA.
Currently this is all of them.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3d546f22790d98..a8cc76d4a9f3c8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -278,6 +278,14 @@ check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
 
 include(RDMA_LinuxHeaders)
 
+# Determine if this arch supports cache coherent DMA. This isn't really an
+# arch specific property, but for our purposes arches that do not support it
+# also do not define wmb/etc which breaks our compile.
+CHECK_C_SOURCE_COMPILES("
+#include \"${CMAKE_CURRENT_SOURCE_DIR}/libibverbs/arch.h\"
+ int main(int argc,const char *argv[]) {return 0;}"
+  HAVE_COHERENT_DMA)
+
 #-------------------------
 # Apply fixups
 
@@ -358,6 +366,7 @@ add_subdirectory(librdmacm/man)
 add_subdirectory(libibcm)
 
 # Providers
+if (HAVE_COHERENT_DMA)
 add_subdirectory(providers/cxgb3)
 add_subdirectory(providers/cxgb4)
 add_subdirectory(providers/hfi1verbs)
@@ -372,6 +381,7 @@ add_subdirectory(providers/ocrdma)
 add_subdirectory(providers/qedr)
 add_subdirectory(providers/rxe)
 add_subdirectory(providers/rxe/man)
+endif()
 
 # Binaries
 add_subdirectory(ibacm)
@@ -396,6 +406,9 @@ message(STATUS "Missing Optional Items:")
 if (NOT HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE)
   message(STATUS " Compiler attribute always_inline NOT supported")
 endif()
+if (NOT HAVE_COHERENT_DMA)
+  message(STATUS " Architecture NOT able to do coherent DMA (check libibverbs/arch.h) some providers disabled!")
+endif()
 if (NOT HAVE_VALGRIND_MEMCHECK)
   message(STATUS " Valgrind memcheck.h NOT enabled")
 endif()
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
