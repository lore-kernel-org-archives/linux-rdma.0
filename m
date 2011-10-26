From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: clean up build
Date: Wed, 26 Oct 2011 14:26:25 -0700
Message-ID: <20111026142625.bf2c8ca1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am  |    1 -
 configure.in |   12 ------------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d7e8ce7..ea85280 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,7 +42,6 @@ AM_CFLAGS = -Wall $(DBGFLAGS)
 LDADD = libcommon.a
 
 libcommon_a_SOURCES = src/ibdiag_common.c
-libcommon_a_LDFLAGS = -libumad -libmad -losmcomp
 src_ibaddr_SOURCES = src/ibaddr.c
 src_ibnetdiscover_SOURCES = src/ibnetdiscover.c
 src_ibnetdiscover_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
diff --git a/configure.in b/configure.in
index 59de9f1..41e3f53 100644
--- a/configure.in
+++ b/configure.in
@@ -10,12 +10,6 @@ AM_INIT_AUTOMAKE
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
 
-AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
-[       if test x$enableval = xno ; then
-                disable_libcheck=yes
-        fi
-])
-
 dnl support debug mode
 AC_ARG_ENABLE(debug,
 [  --enable-debug Turn on debug mode],
@@ -30,8 +24,6 @@ dnl Checks for programs
 AC_PROG_CC
 AC_PROG_LIBTOOL
 
-if test "$disable_libcheck" != "yes"
-then
 dnl Checks for libraries
 AC_CHECK_LIB(ibumad, umad_init, [],
 	AC_MSG_ERROR([umad_init() not found. diags require libibumad.]))
@@ -49,20 +41,16 @@ if test "$ac_have_umad_port_link_layer" = "yes"; then
 fi
 AC_CHECK_LIB(osmcomp, cl_qmap_insert, [],
 	AC_MSG_ERROR([cl_qmap_insert() not found. diags require libosmcomp.]))
-fi
 
 dnl Checks for header files.
 AC_HEADER_STDC
 AC_CHECK_HEADERS([stdlib.h string.h unistd.h fcntl.h inttypes.h netinet/in.h sys/ioctl.h])
-if test "$disable_libcheck" != "yes"
-then
 AC_CHECK_HEADER(infiniband/umad.h, [],
 	AC_MSG_ERROR([<infiniband/umad.h> not found. diags require libibumad.])
 )
 AC_CHECK_HEADER(infiniband/mad.h, [],
 	AC_MSG_ERROR([<infiniband/mad.h> not found. diags require libibmad.])
 )
-fi
 
 dnl Checks for library functions
 AC_FUNC_ERROR_AT_LINE
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
