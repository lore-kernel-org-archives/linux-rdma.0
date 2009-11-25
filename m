From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v1: dtest, dapltest: conflict with dapl-2 utils
 package, change to dapl1, dapltest1
Date: Tue, 24 Nov 2009 16:11:28 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361B96A45@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix for bugzilla #1691 
 dapl-utils RPM conflicts with compat-dapl-utils on SLES11 but not on SLES10 or RHEL5

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dapltest/Makefile.am  |   10 +++++-----
 test/dapltest/configure.in |    4 ++--
 test/dtest/Makefile.am     |    8 ++++----
 test/dtest/configure.in    |    4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/test/dapltest/Makefile.am b/test/dapltest/Makefile.am
index 086286e..4effd8e 100755
--- a/test/dapltest/Makefile.am
+++ b/test/dapltest/Makefile.am
@@ -2,9 +2,9 @@ INCLUDES =  -I include \
 	    -I mdep/linux \
 	    -I $(srcdir)/../../dat/include
          
-bin_PROGRAMS = dapltest
-dapltest_CFLAGS = -g -Wall -D_GNU_SOURCE
-dapltest_SOURCES =				\
+bin_PROGRAMS = dapltest1
+dapltest1_CFLAGS = -g -Wall -D_GNU_SOURCE
+dapltest1_SOURCES =				\
 	cmd/dapl_main.c				\
 	cmd/dapl_params.c			\
 	cmd/dapl_fft_cmd.c			\
@@ -53,5 +53,5 @@ dapltest_SOURCES =				\
 	udapl/udapl_tdep.c			\
 	mdep/linux/dapl_mdep_user.c
 	
-dapltest_LDADD = $(top_builddir)/dat/udat/libdat.la
-dapltest_LDFLAGS = -lpthread  
+dapltest1_LDADD = $(top_builddir)/dat/udat/libdat.la
+dapltest1_LDFLAGS = -lpthread  
diff --git a/test/dapltest/configure.in b/test/dapltest/configure.in
index ebdd59d..cbef338 100755
--- a/test/dapltest/configure.in
+++ b/test/dapltest/configure.in
@@ -1,11 +1,11 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(dapltest, 1.2.1, dapl-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org)
+AC_INIT(dapltest1, 1.2.2, dapl-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org)
 AC_CONFIG_SRCDIR([$top_srcdir/dapl/test/dapltest/cmd/dapl_main.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(dapltest, 1.2.1)
+AM_INIT_AUTOMAKE(dapltest1, 1.2.2)
 
 AM_PROG_LIBTOOL
 
diff --git a/test/dtest/Makefile.am b/test/dtest/Makefile.am
index 70bc10a..496601c 100755
--- a/test/dtest/Makefile.am
+++ b/test/dtest/Makefile.am
@@ -1,5 +1,5 @@
-bin_PROGRAMS = dtest
-dtest_SOURCES = dtest.c
-dtest_CFLAGS = -g -Wall -D_GNU_SOURCE
+bin_PROGRAMS = dtest1
+dtest1_SOURCES = dtest.c
+dtest1_CFLAGS = -g -Wall -D_GNU_SOURCE
 INCLUDES =  -I $(srcdir)/../../dat/include 
-dtest_LDADD = $(top_builddir)/dat/udat/libdat.la
+dtest1_LDADD = $(top_builddir)/dat/udat/libdat.la
diff --git a/test/dtest/configure.in b/test/dtest/configure.in
index 822df5e..705c3d9 100755
--- a/test/dtest/configure.in
+++ b/test/dtest/configure.in
@@ -1,11 +1,11 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(dtest, 1.2.1, dapl-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org)
+AC_INIT(dtest1, 1.2.2, dapl-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org)
 AC_CONFIG_SRCDIR([$top_srcdir/dapl/test/dtest/dtest.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(dtest, 1.2.1)
+AM_INIT_AUTOMAKE(dtest1, 1.2.2)
 
 AM_PROG_LIBTOOL
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
