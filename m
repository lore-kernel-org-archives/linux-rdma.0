From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 02/13] Switch valgrind memcheck.h to on by default
Date: Fri, 23 Sep 2016 13:16:57 -0600
Message-ID: <1474658228-5390-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We now recommend that this source be built with valgrind memcheck.h
present, so use it automatically if it is available. Users looking
to remove this tiny overhead can build with -DENABLE_VALGRIND=0

Downstream packagers should ensure the build is done with valgrind
headers available.

NOTE: Fedora/CentOS have shipped with valgrind turn on in their
packaging, so for most users this is no change.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 06dd98203349..be82c2896d75 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -10,8 +10,8 @@
 #  -DCMAKE_BUILD_TYPE=RelWithDebInfo
 #      Change the optimization level, Debug disables optimization,
 #      Release is for packagers
-#  -DENABLE_VALGRIND=1 (default disabled)
-#      Embed valgrind notations, this has a tiny negative performance impact
+#  -DENABLE_VALGRIND=0 (default enabled)
+#      Disable valgrind notations, this has a tiny positive performance impact
 #  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
 #      Do not link to libnl and do not resolve neighbours internally for Ethernet,
 #      and do not build iwpmd.
@@ -189,9 +189,11 @@ RDMA_DoFixup("${HAVE_RDMA_USER_RXE}" "rdma/rdma_user_rxe.h")
 #-------------------------
 # Apply fixups
 
-# FIXME: We should probably always enable memcheck.h, and only selectively
-# turn it off in the real high performance paths. There is no reason umad
-# should ever have memcheck disabled for instance.
+# We prefer to build with valgrind memcheck.h present, but if not, or the user
+# requested valgrind disabled, then replace it with our dummy stub.
+if (NOT DEFINED ENABLE_VALGRIND)
+  set(ENABLE_VALGRIND "ON" CACHE BOOL "Enable use of valgrind annotations")
+endif()
 if (ENABLE_VALGRIND)
   CHECK_INCLUDE_FILE("valgrind/memcheck.h" HAVE_VALGRIND_MEMCHECK)
   CHECK_INCLUDE_FILE("valgrind/drd.h" HAVE_VALGRIND_DRD)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
