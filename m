From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 4/8] configure: Apply updates proposed by autoupdate
Date: Tue, 16 Jul 2013 23:59:48 +0200
Message-ID: <faa02f5714534dc282a52f0dcb0676daa883d223.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

'autoupdate' is a tool to help developer to update configure.ac.

This patch applies a few fixes as suggested by autoupdate.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 20c2f94..a9e95c0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,18 +1,18 @@
 dnl Process this file with autoconf to produce a configure script.
 
-AC_PREREQ(2.57)
-AC_INIT(librdmacm, 1.0.17, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_PREREQ([2.63])
+AC_INIT([librdmacm],[1.0.17],[linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org])
 AC_CONFIG_SRCDIR([src/cma.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
-AC_CONFIG_HEADERS(config.h)
+AC_CONFIG_HEADERS([config.h])
 AM_INIT_AUTOMAKE([foreign])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-AM_PROG_LIBTOOL
+LT_INIT
 
 AC_ARG_WITH([valgrind],
-    AC_HELP_STRING([--with-valgrind],
+    AS_HELP_STRING([--with-valgrind],
 		   [Enable valgrind annotations - default NO]))
 
 if test "$with_valgrind" != "" && test "$with_valgrind" != "no"; then
@@ -50,8 +50,8 @@ AC_CHECK_MEMBER(struct ibv_path_record.service_id, [],
 
 dnl Check for gcc atomic intrinsics
 AC_MSG_CHECKING(compiler support for atomics)
-AC_TRY_LINK([int i = 0;],
-    [ return __sync_add_and_fetch(&i, 1) != __sync_sub_and_fetch(&i, 1); ],
+AC_LINK_IFELSE([AC_LANG_PROGRAM([[int i = 0;]],
+				[[ return __sync_add_and_fetch(&i, 1) != __sync_sub_and_fetch(&i, 1); ]])],
     [ AC_MSG_RESULT(yes) ],
     [
         AC_MSG_RESULT(no)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
