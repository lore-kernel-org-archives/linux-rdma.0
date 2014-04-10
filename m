From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Fix usage of libnl3
Date: Thu, 10 Apr 2014 11:27:13 +0300
Message-ID: <1397118433-8836-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When using libnl3, libibverbs should be linked with
libnl3 and not the utilities.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index add34b2..9293f86 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ if ! NO_RESOLVE_NEIGH
 src_libibverbs_la_SOURCES += src/neigh.c
 noinst_HEADERS = src/neigh.h
 endif
-src_libibverbs_la_LDFLAGS = -version-info 1 -export-dynamic \
+src_libibverbs_la_LDFLAGS = -version-info 1 -export-dynamic $(LIBNL_LIBS)\
     $(libibverbs_version_script)
 src_libibverbs_la_DEPENDENCIES = $(srcdir)/src/libibverbs.map
 
@@ -28,31 +28,31 @@ bin_PROGRAMS = examples/ibv_devices examples/ibv_devinfo \
     examples/ibv_dcini examples/ibv_dctgt
 
 examples_ibv_devices_SOURCES = examples/device_list.c
-examples_ibv_devices_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_devices_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_devinfo_SOURCES = examples/devinfo.c
-examples_ibv_devinfo_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_devinfo_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_rc_pingpong_SOURCES = examples/rc_pingpong.c examples/pingpong.c
-examples_ibv_rc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_rc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_uc_pingpong_SOURCES = examples/uc_pingpong.c examples/pingpong.c
-examples_ibv_uc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_uc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_ud_pingpong_SOURCES = examples/ud_pingpong.c examples/pingpong.c
-examples_ibv_ud_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_ud_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_srq_pingpong_SOURCES = examples/srq_pingpong.c examples/pingpong.c
-examples_ibv_srq_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_srq_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_shared_mr_SOURCES = examples/shared_mr.c
-examples_ibv_shared_mr_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_shared_mr_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_asyncwatch_SOURCES = examples/asyncwatch.c
-examples_ibv_asyncwatch_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_asyncwatch_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_xsrq_pingpong_SOURCES = examples/xsrq_pingpong.c examples/pingpong.c
-examples_ibv_xsrq_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_xsrq_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_cc_pingpong_SOURCES = examples/cc_pingpong.c
-examples_ibv_cc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_cc_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_task_pingpong_SOURCES = examples/task_pingpong.c
-examples_ibv_task_pingpong_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_task_pingpong_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_dcini_SOURCES = examples/dcini.c
-examples_ibv_dcini_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_dcini_LDADD = $(top_builddir)/src/libibverbs.la
 examples_ibv_dctgt_SOURCES = examples/dctgt.c examples/pingpong.c examples/dc.h
-examples_ibv_dctgt_LDADD = $(top_builddir)/src/libibverbs.la $(LIBNL_LIBS)
+examples_ibv_dctgt_LDADD = $(top_builddir)/src/libibverbs.la
 
 
 # Enable ibverbs library test
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
