From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Automatically detect if ibacm is installed
Date: Wed, 4 Apr 2012 21:25:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519AC8F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the ibacm header file is available, automatically have the
librdmacm configured to use it.  This removes the --with-ib_acm
configure option.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/configure.in b/configure.in
index 8d89741..238ee59 100644
--- a/configure.in
+++ b/configure.in
@@ -23,15 +23,6 @@ if test "$with_valgrind" != "" && test "$with_valgrind" != "no"; then
 	fi
 fi
 
-AC_ARG_WITH([ib_acm],
-    AC_HELP_STRING([--with-ib_acm],
-		   [Use IB ACM for route resolution - default NO]))
-
-if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
-	AC_DEFINE([USE_IB_ACM], 1,
-		  [Define to 1 to use IB ACM for endpoint resolution])
-fi
-
 AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
 [       if test "$enableval" = "no"; then
                 disable_libcheck=yes
@@ -67,13 +58,10 @@ if test "$with_valgrind" != "" && test "$with_valgrind" != "no"; then
 AC_CHECK_HEADER(valgrind/memcheck.h, [],
     AC_MSG_ERROR([valgrind requested but <valgrind/memcheck.h> not found.]))
 fi
-
-if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
-AC_CHECK_HEADER(infiniband/acm.h, [],
-    AC_MSG_ERROR([IB ACM requested but <infiniband/acm.h> not found.]))
 fi
 
-fi
+AC_CHECK_HEADER(infiniband/acm.h, 
+	AC_DEFINE([USE_IB_ACM], 1, [setting IBACM support]), [])
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
