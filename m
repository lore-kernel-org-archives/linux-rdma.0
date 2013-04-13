From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] .gitignore updates and rename configure.in->.ac
Date: Sat, 13 Apr 2013 08:15:08 -0700
Message-ID: <1365866108-9731-2-git-send-email-jsquyres@cisco.com>
References: <1365866108-9731-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365866108-9731-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added some entries to config/.gitignore for newer versions of the GNU
Autotools.  Also renamed configure.in -> configure.ac to accomodate
newer GNU Autotools

(http://lists.gnu.org/archive/html/autotools-announce/2012-11/msg00000.html
announced the intent to drop support for "configure.in" in future
versions of Autoconf).

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 .gitignore   |  6 +++++
 configure.ac | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in | 74 ------------------------------------------------------------
 3 files changed, 80 insertions(+), 74 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/.gitignore b/.gitignore
index 78effef..d198dd1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,6 +6,7 @@ autom4te.cache
 aclocal.m4
 stamp-h.in
 config.h.in
+config.h.in~
 config.log
 config.h
 .libs
@@ -15,3 +16,8 @@ Makefile
 config.status
 stamp-h1
 libtool
+config/libtool.m4
+config/ltoptions.m4
+config/ltsugar.m4
+config/ltversion.m4
+config/lt~obsolete.m4
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..efdc5ac
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,74 @@
+dnl Process this file with autoconf to produce a configure script.
+
+AC_PREREQ(2.57)
+AC_INIT(libibverbs, 1.1.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_CONFIG_SRCDIR([src/ibverbs.h])
+AC_CONFIG_AUX_DIR(config)
+AC_CONFIG_MACRO_DIR(config)
+AC_CONFIG_HEADER(config.h)
+AM_INIT_AUTOMAKE([foreign])
+m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
+
+dnl Checks for programs
+AC_PROG_CC
+AC_GNU_SOURCE
+AC_PROG_LN_S
+AC_PROG_LIBTOOL
+
+LT_INIT
+
+AC_ARG_WITH([valgrind],
+    AC_HELP_STRING([--with-valgrind],
+        [Enable Valgrind annotations (small runtime overhead, default NO)]))
+if test x$with_valgrind = x || test x$with_valgrind = xno; then
+    want_valgrind=no
+    AC_DEFINE([NVALGRIND], 1, [Define to 1 to disable Valgrind annotations.])
+else
+    want_valgrind=yes
+    if test -d $with_valgrind; then
+        CPPFLAGS="$CPPFLAGS -I$with_valgrind/include"
+    fi
+fi
+
+dnl Checks for libraries
+AC_CHECK_LIB(dl, dlsym, [],
+    AC_MSG_ERROR([dlsym() not found.  libibverbs requires libdl.]))
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
+
+dnl Checks for header files.
+AC_HEADER_STDC
+AC_CHECK_HEADER(valgrind/memcheck.h,
+    [AC_DEFINE(HAVE_VALGRIND_MEMCHECK_H, 1,
+        [Define to 1 if you have the <valgrind/memcheck.h> header file.])],
+    [if test $want_valgrind = yes; then
+        AC_MSG_ERROR([Valgrind memcheck support requested, but <valgrind/memcheck.h> not found.])
+    fi])
+
+dnl Checks for typedefs, structures, and compiler characteristics.
+AC_C_CONST
+
+AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
+    [if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
+	ac_cv_version_script=yes
+    else
+	ac_cv_version_script=no
+    fi])
+
+if test $ac_cv_version_script = yes; then
+    LIBIBVERBS_VERSION_SCRIPT='-Wl,--version-script=$(srcdir)/src/libibverbs.map'
+else
+    LIBIBVERBS_VERSION_SCRIPT=
+fi
+AC_SUBST(LIBIBVERBS_VERSION_SCRIPT)
+
+AC_CACHE_CHECK(for .symver assembler support, ac_cv_asm_symver_support,
+    [AC_TRY_COMPILE(, [asm("symbol:\n.symver symbol, api@ABI\n");],
+        ac_cv_asm_symver_support=yes,
+        ac_cv_asm_symver_support=no)])
+if test $ac_cv_asm_symver_support = yes; then
+    AC_DEFINE([HAVE_SYMVER_SUPPORT], 1, [assembler has .symver support])
+fi
+
+AC_CONFIG_FILES([Makefile libibverbs.spec])
+AC_OUTPUT
diff --git a/configure.in b/configure.in
deleted file mode 100644
index efdc5ac..0000000
--- a/configure.in
+++ /dev/null
@@ -1,74 +0,0 @@
-dnl Process this file with autoconf to produce a configure script.
-
-AC_PREREQ(2.57)
-AC_INIT(libibverbs, 1.1.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
-AC_CONFIG_SRCDIR([src/ibverbs.h])
-AC_CONFIG_AUX_DIR(config)
-AC_CONFIG_MACRO_DIR(config)
-AC_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE([foreign])
-m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-
-dnl Checks for programs
-AC_PROG_CC
-AC_GNU_SOURCE
-AC_PROG_LN_S
-AC_PROG_LIBTOOL
-
-LT_INIT
-
-AC_ARG_WITH([valgrind],
-    AC_HELP_STRING([--with-valgrind],
-        [Enable Valgrind annotations (small runtime overhead, default NO)]))
-if test x$with_valgrind = x || test x$with_valgrind = xno; then
-    want_valgrind=no
-    AC_DEFINE([NVALGRIND], 1, [Define to 1 to disable Valgrind annotations.])
-else
-    want_valgrind=yes
-    if test -d $with_valgrind; then
-        CPPFLAGS="$CPPFLAGS -I$with_valgrind/include"
-    fi
-fi
-
-dnl Checks for libraries
-AC_CHECK_LIB(dl, dlsym, [],
-    AC_MSG_ERROR([dlsym() not found.  libibverbs requires libdl.]))
-AC_CHECK_LIB(pthread, pthread_mutex_init, [],
-    AC_MSG_ERROR([pthread_mutex_init() not found.  libibverbs requires libpthread.]))
-
-dnl Checks for header files.
-AC_HEADER_STDC
-AC_CHECK_HEADER(valgrind/memcheck.h,
-    [AC_DEFINE(HAVE_VALGRIND_MEMCHECK_H, 1,
-        [Define to 1 if you have the <valgrind/memcheck.h> header file.])],
-    [if test $want_valgrind = yes; then
-        AC_MSG_ERROR([Valgrind memcheck support requested, but <valgrind/memcheck.h> not found.])
-    fi])
-
-dnl Checks for typedefs, structures, and compiler characteristics.
-AC_C_CONST
-
-AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
-    [if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
-	ac_cv_version_script=yes
-    else
-	ac_cv_version_script=no
-    fi])
-
-if test $ac_cv_version_script = yes; then
-    LIBIBVERBS_VERSION_SCRIPT='-Wl,--version-script=$(srcdir)/src/libibverbs.map'
-else
-    LIBIBVERBS_VERSION_SCRIPT=
-fi
-AC_SUBST(LIBIBVERBS_VERSION_SCRIPT)
-
-AC_CACHE_CHECK(for .symver assembler support, ac_cv_asm_symver_support,
-    [AC_TRY_COMPILE(, [asm("symbol:\n.symver symbol, api@ABI\n");],
-        ac_cv_asm_symver_support=yes,
-        ac_cv_asm_symver_support=no)])
-if test $ac_cv_asm_symver_support = yes; then
-    AC_DEFINE([HAVE_SYMVER_SUPPORT], 1, [assembler has .symver support])
-fi
-
-AC_CONFIG_FILES([Makefile libibverbs.spec])
-AC_OUTPUT
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
