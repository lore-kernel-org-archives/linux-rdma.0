From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm/rsocket: Build librspreload library as part of
 build
Date: Wed, 11 Jul 2012 22:12:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A58252@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Build the rsocket preload library as part of the build.  To reduce the
risk of the preload library intercepting calls without the user's
knowledge, the preload library is installed into {_libdir}/rsocket.
    
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

diff --git a/Makefile.am b/Makefile.am
index 51b2f89..b271b45 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,11 +1,14 @@
 INCLUDES = -I$(srcdir)/include
 
+rslibdir = $(libdir)/rsocket
 lib_LTLIBRARIES = src/librdmacm.la
+rslib_LTLIBRARIES = src/librspreload.la
 
 ACLOCAL_AMFLAGS = -I config
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"$(sysconfdir)\" -DRDMADIR=\"@rdmadir@\"
 
 src_librdmacm_la_CFLAGS = $(AM_CFLAGS)
+src_librspreload_la_CFLAGS = $(AM_CFLAGS)
 
 if HAVE_LD_VERSION_SCRIPT
     librdmacm_version_script = -Wl,--version-script=$(srcdir)/src/librdmacm.map
@@ -19,6 +22,10 @@ src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 			   $(librdmacm_version_script)
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
 
+src_librspreload_la_SOURCES = src/preload.c src/indexer.c
+src_librspreload_la_LDFLAGS = -version-info 1 -export-dynamic
+src_librspreload_la_LIBADD = $(top_builddir)/src/librdmacm.la
+
 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
 	       examples/rdma_client examples/rdma_server examples/rdma_xclient \
 	       examples/rdma_xserver examples/rstream examples/rcopy
diff --git a/librdmacm.spec.in b/librdmacm.spec.in
index 7248137..4652bbc 100644
--- a/librdmacm.spec.in
+++ b/librdmacm.spec.in
@@ -44,6 +44,7 @@ rm -rf $RPM_BUILD_ROOT
 %makeinstall
 # remove unpackaged files from the buildroot
 rm -f $RPM_BUILD_ROOT%{_libdir}/*.la
+rm -f $RPM_BUILD_ROOT%{_libdir}/rsocket/*.la
 
 %clean
 rm -rf $RPM_BUILD_ROOT
@@ -53,13 +54,16 @@ rm -rf $RPM_BUILD_ROOT
 
 %files
 %defattr(-,root,root,-)
-%{_libdir}/librdmacm*.so.*
+%{_libdir}/lib*.so.*
+%{_libdir}/rsocket/lib*.so.*
 %doc AUTHORS COPYING README
 
 %files devel
 %defattr(-,root,root)
-%{_libdir}/lib*.so
+%{_libdir}/librdmacm*.so
+%{_libdir}/rsocket/librspreload*.so
 %{_libdir}/*.a
+%{_libdir}/rsocket/*.a
 %{_includedir}/*
 %{_mandir}/man3/*
 %{_mandir}/man7/*
diff --git a/src/preload.c b/src/preload.c
index d21389f..8758d5c 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -31,14 +31,6 @@
  *
  */
 
-/*
- * Build:
- * gcc -lrdmacm -Wall -shared -fPIC -o preload.so -D_GNU_SOURCE preload.c indexer.c
- *
- * Use:
- * LD_PRELOAD=preload.so binary --plus_args
- */
-
 #if HAVE_CONFIG_H
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
