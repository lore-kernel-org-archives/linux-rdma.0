From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] configure: apply updates proposed by autoupdate
Date: Tue, 21 May 2013 00:39:53 +0200
Message-ID: <9fbdc108fb8a6ddbef67ed6b0f361c0253ea2325.1369089206.git.ydroneaud@opteya.com>
References: <cover.1369089206.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1369089206.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

'autoupdate' is a tool to help developer to update configure.ac.

This patch apply a few fixes as suggested by autoupdate.

It was tested on Debian 6.0.7 (Squeeze) and Fedora 17 (Beefy Miracle).

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8f79891..a1d5365 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
-AC_PREREQ(2.57)
-AC_INIT(libibverbs, 1.1.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_PREREQ([2.67])
+AC_INIT([libibverbs],[1.1.6],[linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org])
 AC_CONFIG_SRCDIR([src/ibverbs.h])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
@@ -11,14 +11,12 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 dnl Checks for programs
 AC_PROG_CC
-AC_GNU_SOURCE
+AC_USE_SYSTEM_EXTENSIONS
 AC_PROG_LN_S
-AC_PROG_LIBTOOL
-
 LT_INIT
 
 AC_ARG_WITH([valgrind],
-    AC_HELP_STRING([--with-valgrind],
+    AS_HELP_STRING([--with-valgrind],
         [Enable Valgrind annotations (small runtime overhead, default NO)]))
 if test x$with_valgrind = x || test x$with_valgrind = xno; then
     want_valgrind=no
@@ -84,9 +82,10 @@ fi
 AC_SUBST(LIBIBVERBS_VERSION_SCRIPT)
 
 AC_CACHE_CHECK(for .symver assembler support, ac_cv_asm_symver_support,
-    [AC_TRY_COMPILE(, [asm("symbol:\n.symver symbol, api@ABI\n");],
-        ac_cv_asm_symver_support=yes,
-        ac_cv_asm_symver_support=no)])
+    [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]],
+        [[asm("symbol:\n.symver symbol, api@ABI\n");]])],
+        [ac_cv_asm_symver_support=yes],
+        [ac_cv_asm_symver_support=no])])
 if test $ac_cv_asm_symver_support = yes; then
     AC_DEFINE([HAVE_SYMVER_SUPPORT], 1, [assembler has .symver support])
 fi
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
