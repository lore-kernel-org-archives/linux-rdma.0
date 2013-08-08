From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm] cmtime: Add example program that times rdma cm calls
Date: Thu,  8 Aug 2013 16:18:04 -0700
Message-ID: <1376003884-28471-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

cmtime is a new sample program that measures how long it
takes for each step in the connection process to complete.
It can be used to analyze the performance of the various
CM steps.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index e1be9f3..4e3dee7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,7 +29,7 @@ src_librspreload_la_LIBADD = $(top_builddir)/src/librdmacm.la
 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
 	       examples/rdma_client examples/rdma_server examples/rdma_xclient \
 	       examples/rdma_xserver examples/rstream examples/rcopy \
-	       examples/riostream examples/udpong
+	       examples/riostream examples/udpong examples/cmtime
 examples_ucmatose_SOURCES = examples/cmatose.c examples/common.c
 examples_ucmatose_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rping_SOURCES = examples/rping.c
@@ -54,6 +54,8 @@ examples_rcopy_SOURCES = examples/rcopy.c
 examples_rcopy_LDADD = $(top_builddir)/src/librdmacm.la
 examples_udpong_SOURCES = examples/udpong.c examples/common.c
 examples_udpong_LDADD = $(top_builddir)/src/librdmacm.la
+examples_cmtime_SOURCES = examples/cmtime.c examples/common.c
+examples_cmtime_LDADD = $(top_builddir)/src/librdmacm.la
 
 librdmacmincludedir = $(includedir)/rdma
 infinibandincludedir = $(includedir)/infiniband
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
