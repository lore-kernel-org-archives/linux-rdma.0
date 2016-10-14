From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/8] verbs: Use cmake to detect if net/if.h vs netling/route/link.h is broken
Date: Fri, 14 Oct 2016 16:14:12 -0600
Message-ID: <1476483257-16308-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If not then just use the header directly, otherwise use the work around.

The issue is that old libnl libraries include linux/if.h and the
declarations there conflict with net/if.h. New libraries do not
do this.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt       | 16 ++++++++++++++++
 buildlib/config.h.in |  2 ++
 libibverbs/neigh.c   |  5 +++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index bede766adf4d..58de78d6cde0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -210,6 +210,18 @@ else()
   set(NL_LIBRARIES "")
 endif()
 
+# Older stuff blows up if these headers are included together
+if (NOT NL_KIND EQUAL 0)
+  set(SAFE_CMAKE_REQUIRED_INCLUDES "${CMAKE_REQUIRED_INCLUDES}")
+  set(CMAKE_REQUIRED_INCLUDES "${NL_INCLUDE_DIRS}")
+  CHECK_C_SOURCE_COMPILES("
+#include <netlink/route/link.h>
+#include <net/if.h>
+ int main(int argc,const char *argv[]) {return 0;}"
+    HAVE_WORKING_IF_H)
+  set(CMAKE_REQUIRED_INCLUDES "${SAFE_CMAKE_REQUIRED_INCLUDES}")
+endif()
+
 # Statically determine sizeof(long), this is largely unnecessary, no new code
 # should rely on this.
 check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
@@ -325,6 +337,10 @@ if (NL_KIND EQUAL 1)
 endif()
 if (NL_KIND EQUAL 0)
   message(STATUS " neighbour resolution NOT enabled")
+else()
+  if (NOT HAVE_WORKING_IF_H)
+    message(STATUS " netlink/route/link.h and net/if.h NOT co-includable (old headers)")
+  endif()
 endif()
 if (NOT HAVE_RDMA_USER_RXE)
   message(STATUS " rdma/rdma_user_rxe.h NOT found (old system kernel headers)")
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 99103b779baf..23781807bce8 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -31,6 +31,8 @@
 // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
 #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
 
+#cmakedefine HAVE_WORKING_IF_H 1
+
 @SIZEOF_LONG_CODE@
 
 #if @NL_KIND@ == 3
diff --git a/libibverbs/neigh.c b/libibverbs/neigh.c
index 5acfcf06fcde..67a83eb0fd27 100644
--- a/libibverbs/neigh.c
+++ b/libibverbs/neigh.c
@@ -20,10 +20,11 @@
 #include <ifaddrs.h>
 #include <netdb.h>
 #include <assert.h>
-#ifndef _LINUX_IF_H
+#if HAVE_WORKING_IF_H
 #include <net/if.h>
 #else
-/*Workaround when there's a collision between the includes */
+/* We need this decl from net/if.h but old systems do not let use co-include
+   net/if.h and netlink/route/link.h */
 extern unsigned int if_nametoindex(__const char *__ifname) __THROW;
 #endif
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
