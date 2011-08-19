From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: build: add selective enable/disable-xxx build
 switch for each openfabrics provider
Date: Fri, 19 Aug 2011 20:30:49 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E4E005@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following switches have been added to configure:

--disable-cma (disables the rdma_cm dapl provider build)
--disable-scm (disables the socket cm provider build)
--disable-ucm (disables the IB UD cm provider build)

all providers are enabled by default.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am  |   42 ++++++++++++++++++++++++++++++++++++------
 configure.in |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 1f74378..a430568 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -44,19 +44,31 @@ AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DDAT_CONF="\"$(sysconfdir)/dat.conf\""
 endif
 
 datlibdir = $(libdir)
+if DEFINE_CMA
 dapllibofadir = $(libdir)
+endif
+if DEFINE_SCM
 daplliboscmdir = $(libdir)
+endif
+if DEFINE_UCM
 daplliboucmdir = $(libdir)
+endif
 
 datlib_LTLIBRARIES = dat/udat/libdat2.la
+if DEFINE_CMA
 dapllibofa_LTLIBRARIES = dapl/udapl/libdaplofa.la
+endif
+if DEFINE_SCM
 daplliboscm_LTLIBRARIES = dapl/udapl/libdaploscm.la
+endif
+if DEFINE_UCM
 daplliboucm_LTLIBRARIES = dapl/udapl/libdaploucm.la
+endif
 
 dat_udat_libdat2_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAGS) \
 				-I$(srcdir)/dat/include/ -I$(srcdir)/dat/udat/ \
 				-I$(srcdir)/dat/udat/linux -I$(srcdir)/dat/common/ 
-
+if DEFINE_CMA
 dapl_udapl_libdaplofa_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAGS) \
 				-DOPENIB -DCQ_WAIT_OBJECT \
 				-I$(srcdir)/dat/include/ -I$(srcdir)/dapl/include/ \
@@ -64,7 +76,8 @@ dapl_udapl_libdaplofa_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAGS
 				-I$(srcdir)/dapl/openib_common \
 				-I$(srcdir)/dapl/openib_cma \
 				-I$(srcdir)/dapl/openib_cma/linux
-		
+endif
+if DEFINE_SCM
 dapl_udapl_libdaploscm_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAGS) \
                                 -DOPENIB -DCQ_WAIT_OBJECT \
                                 -I$(srcdir)/dat/include/ -I$(srcdir)/dapl/include/ \
@@ -72,7 +85,8 @@ dapl_udapl_libdaploscm_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAG
 				-I$(srcdir)/dapl/openib_common \
                                 -I$(srcdir)/dapl/openib_scm \
 				-I$(srcdir)/dapl/openib_scm/linux
-
+endif
+if DEFINE_UCM
 dapl_udapl_libdaploucm_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAGS) \
                                 -DOPENIB -DCQ_WAIT_OBJECT \
                                 -I$(srcdir)/dat/include/ -I$(srcdir)/dapl/include/ \
@@ -80,18 +94,30 @@ dapl_udapl_libdaploucm_la_CFLAGS = $(AM_CFLAGS) -D_GNU_SOURCE $(OSFLAGS) $(XFLAG
 				-I$(srcdir)/dapl/openib_common \
                                 -I$(srcdir)/dapl/openib_ucm \
 				-I$(srcdir)/dapl/openib_ucm/linux				
-
+endif
 if HAVE_LD_VERSION_SCRIPT
     dat_version_script = -Wl,--version-script=$(srcdir)/dat/udat/libdat2.map
+if DEFINE_CMA
     daplofa_version_script = -Wl,--version-script=$(srcdir)/dapl/udapl/libdaplofa.map
+endif
+if DEFINE_SCM
     daploscm_version_script = -Wl,--version-script=$(srcdir)/dapl/udapl/libdaploscm.map
+endif
+if DEFINE_UCM
     daploucm_version_script = -Wl,--version-script=$(srcdir)/dapl/udapl/libdaploucm.map
+endif
 else
     dat_version_script = 
+if DEFINE_CMA
     daplofa_version_script = 
+endif
+if DEFINE_SCM
     daploscm_version_script =
+endif
+if DEFINE_UCM
     daploucm_version_script =
 endif
+endif
 
 #
 # uDAT: libdat2.so
@@ -108,6 +134,7 @@ dat_udat_libdat2_la_SOURCES = dat/udat/udat.c \
 			dat/common/dat_sr.c
 dat_udat_libdat2_la_LDFLAGS = -version-info 2:0:0 $(dat_version_script) -ldl 
 
+if DEFINE_CMA
 #
 # uDAPL OpenFabrics rdma_cm version: libdaplofa.so
 #
@@ -221,7 +248,8 @@ dapl_udapl_libdaplofa_la_SOURCES = dapl/udapl/dapl_init.c \
 dapl_udapl_libdaplofa_la_LDFLAGS = -version-info 2:0:0 $(daplofa_version_script) \
 				   -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
 				   -lpthread -libverbs -lrdmacm $(XLIBS)
-				
+endif
+if DEFINE_SCM				
 #
 # uDAPL OpenFabrics Socket CM version for IB: libdaplscm.so
 #
@@ -335,7 +363,8 @@ dapl_udapl_libdaploscm_la_SOURCES = dapl/udapl/dapl_init.c \
 dapl_udapl_libdaploscm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
                                    -lpthread -libverbs -lrdmacm $(XLIBS)
-                                   
+endif
+if DEFINE_UCM                      
 #
 # uDAPL OpenFabrics UD CM version for IB: libdaplucm.so
 #
@@ -449,6 +478,7 @@ dapl_udapl_libdaploucm_la_SOURCES = dapl/udapl/dapl_init.c \
 dapl_udapl_libdaploucm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
                                    -lpthread -libverbs -lrdmacm $(XLIBS)
+endif
 
 libdatincludedir = $(includedir)/dat2
 
diff --git a/configure.in b/configure.in
index 56058a0..30524d9 100644
--- a/configure.in
+++ b/configure.in
@@ -67,6 +67,39 @@ AC_ARG_ENABLE(debug,
 esac],[debug=false])
 AM_CONDITIONAL(DEBUG, test x$debug = xtrue)
 
+dnl Support to enable/disable CMA (rdma_cm) provider library build
+AC_ARG_ENABLE([cma], 
+  AS_HELP_STRING([--disable-cma],[disable CMA (rdma_cm) provider build, default=enabled]),
+  [case "${enableval}" in
+    yes) cma=true ;;
+    no)  cma=false ;;
+    *) AC_MSG_ERROR(bad value ${enableval} for --enable-cma) ;; 
+  esac],
+  [cma=true])
+AM_CONDITIONAL(DEFINE_CMA, test x$cma = xtrue)
+
+dnl Support to enable/disable SCM (socket CM) provider library build
+AC_ARG_ENABLE([scm], 
+  AS_HELP_STRING([--disable-scm],[disable SCM (socket cm) provider build, default=enabled]),
+  [case "${enableval}" in
+    yes) scm=true ;;
+    no)  scm=false ;;
+    *) AC_MSG_ERROR(bad value ${enableval} for --enable-scm) ;; 
+  esac],
+  [scm=true])
+AM_CONDITIONAL(DEFINE_SCM, test x$scm = xtrue)
+
+dnl Support to enable/disable UCM (IB UD cm) provider library build
+AC_ARG_ENABLE([ucm], 
+  AS_HELP_STRING([--disable-ucm],[disable UCM (IB UD cm) provider build, default=enabled]),
+  [case "${enableval}" in
+    yes) ucm=true ;;
+    no)  ucm=false ;;
+    *) AC_MSG_ERROR(bad value ${enableval} for --enable-ucm) ;; 
+  esac],
+  [ucm=true])
+AM_CONDITIONAL(DEFINE_UCM, test x$ucm = xtrue)
+
 dnl Support ib_extension build - if enable-ext-type == ib 
 AC_ARG_ENABLE(ext-type,
 [  --enable-ext-type Enable extensions support for library: ib, none, default=ib],
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
