From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] libibmad: configure.ac: Update configure.in to configure.ac
Date: Mon, 26 Sep 2016 02:20:55 -0400
Message-ID: <1474870855-21158-3-git-send-email-ira.weiny@intel.com>
References: <1474870855-21158-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474870855-21158-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To avoid this warning:

automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.ac | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in | 66 ------------------------------------------------------------
 2 files changed, 66 insertions(+), 66 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 000000000000..843dbfd0d6b9
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,66 @@
+dnl Process this file with autoconf to produce a configure script.
+
+AC_PREREQ(2.57)
+AC_INIT(libibmad, 1.3.12, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_CONFIG_SRCDIR([src/sa.c])
+AC_CONFIG_AUX_DIR(config)
+AC_CONFIG_MACRO_DIR(config)
+AM_CONFIG_HEADER(config.h)
+AM_INIT_AUTOMAKE
+
+AC_SUBST(RELEASE, ${RELEASE:-unknown})
+AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
+
+dnl the library version info is available in the file: libibmad.ver
+ibmad_api_version=`grep LIBVERSION $srcdir/libibmad.ver | sed 's/LIBVERSION=//'`
+if test -z $ibmad_api_version; then
+   ibmad_api_version=1:0:0
+fi
+AC_SUBST(ibmad_api_version)
+
+AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
+[       if test x$enableval = xno ; then
+                disable_libcheck=yes
+        fi
+])
+
+AM_PROG_LIBTOOL
+
+dnl Checks for programs
+AC_PROG_CC
+
+dnl Checks for libraries
+if test "$disable_libcheck" != "yes"
+then
+AC_CHECK_LIB(ibumad, umad_init, [],
+	AC_MSG_ERROR([umad_init() not found. libibmad requires libibumad.]))
+fi
+
+dnl Checks for header files.
+AC_HEADER_STDC
+AC_CHECK_HEADERS([netinet/in.h stdlib.h string.h sys/time.h unistd.h])
+if test "$disable_libcheck" != "yes"
+then
+AC_CHECK_HEADER(infiniband/umad.h, [],
+	AC_MSG_ERROR([<infiniband/umad.h> not found. libibmad requires libibumad.])
+)
+fi
+
+dnl Checks for library functions
+AC_CHECK_FUNCS([memset strrchr strtol])
+
+dnl Checks for typedefs, structures, and compiler characteristics.
+AC_C_CONST
+AC_C_INLINE
+
+AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
+    if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
+        ac_cv_version_script=yes
+    else
+        ac_cv_version_script=no
+    fi)
+
+AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$ac_cv_version_script" = "yes")
+
+AC_CONFIG_FILES([Makefile libibmad.spec])
+AC_OUTPUT
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 843dbfd0d6b9..000000000000
--- a/configure.in
+++ /dev/null
@@ -1,66 +0,0 @@
-dnl Process this file with autoconf to produce a configure script.
-
-AC_PREREQ(2.57)
-AC_INIT(libibmad, 1.3.12, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
-AC_CONFIG_SRCDIR([src/sa.c])
-AC_CONFIG_AUX_DIR(config)
-AC_CONFIG_MACRO_DIR(config)
-AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE
-
-AC_SUBST(RELEASE, ${RELEASE:-unknown})
-AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
-
-dnl the library version info is available in the file: libibmad.ver
-ibmad_api_version=`grep LIBVERSION $srcdir/libibmad.ver | sed 's/LIBVERSION=//'`
-if test -z $ibmad_api_version; then
-   ibmad_api_version=1:0:0
-fi
-AC_SUBST(ibmad_api_version)
-
-AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
-[       if test x$enableval = xno ; then
-                disable_libcheck=yes
-        fi
-])
-
-AM_PROG_LIBTOOL
-
-dnl Checks for programs
-AC_PROG_CC
-
-dnl Checks for libraries
-if test "$disable_libcheck" != "yes"
-then
-AC_CHECK_LIB(ibumad, umad_init, [],
-	AC_MSG_ERROR([umad_init() not found. libibmad requires libibumad.]))
-fi
-
-dnl Checks for header files.
-AC_HEADER_STDC
-AC_CHECK_HEADERS([netinet/in.h stdlib.h string.h sys/time.h unistd.h])
-if test "$disable_libcheck" != "yes"
-then
-AC_CHECK_HEADER(infiniband/umad.h, [],
-	AC_MSG_ERROR([<infiniband/umad.h> not found. libibmad requires libibumad.])
-)
-fi
-
-dnl Checks for library functions
-AC_CHECK_FUNCS([memset strrchr strtol])
-
-dnl Checks for typedefs, structures, and compiler characteristics.
-AC_C_CONST
-AC_C_INLINE
-
-AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
-    if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
-        ac_cv_version_script=yes
-    else
-        ac_cv_version_script=no
-    fi)
-
-AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$ac_cv_version_script" = "yes")
-
-AC_CONFIG_FILES([Makefile libibmad.spec])
-AC_OUTPUT
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
