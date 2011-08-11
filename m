From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] DAPL v2.0: build: add IB collective and FCA provider
 to dapl build package as an option --enable-coll-type
Date: Thu, 11 Aug 2011 00:42:30 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B7B@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New collective support and the FCA provider will only be built with
configure option of "--enable-coll-type=fca". Dependencies include
fca devel package, fca library, and mverbs library. This will not
be included in default builds.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am  |   16 +++++++++++-----
 configure.in |   22 ++++++++++++++++++++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 141a68b..55fe45b 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,9 +18,15 @@ endif
 if EXT_TYPE_IB
 XFLAGS = -DDAT_EXTENSIONS
 XPROGRAMS = dapl/openib_common/ib_extensions.c
+if COLL_TYPE_FCA
+XFLAGS += -DDAT_IB_COLLECTIVES -DDAT_FCA_PROVIDER
+XPROGRAMS += dapl/openib_common/collectives/fca_provider.c
+XLIBS = -lfca
+endif
 else
 XFLAGS =
 XPROGRAMS =
+XLIBS =
 endif
 
 if DEFINE_ATTR_LINK_LAYER
@@ -210,7 +216,7 @@ dapl_udapl_libdaplofa_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaplofa_la_LDFLAGS = -version-info 2:0:0 $(daplofa_version_script) \
 				   -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-				   -lpthread -libverbs -lrdmacm 
+				   -lpthread -libverbs -lrdmacm $(XLIBS)
 				
 #
 # uDAPL OpenFabrics Socket CM version for IB: libdaplscm.so
@@ -324,7 +330,7 @@ dapl_udapl_libdaploscm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploscm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs -lrdmacm
+                                   -lpthread -libverbs -lrdmacm $(XLIBS)
                                    
 #
 # uDAPL OpenFabrics UD CM version for IB: libdaplucm.so
@@ -438,7 +444,7 @@ dapl_udapl_libdaploucm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploucm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs -lrdmacm
+                                   -lpthread -libverbs -lrdmacm $(XLIBS)
 
 libdatincludedir = $(includedir)/dat2
 
@@ -498,7 +504,7 @@ EXTRA_DIST = dat/common/dat_dictionary.h \
 	     dapl/include/dapl_ipoib_names.h \
 	     dapl/include/dapl_vendor.h \
 	     dapl/openib_common/dapl_ib_dto.h \
-	     dapl/openib_common/dapl_ib_common.h \
+	     dapl/openib_common/dapl_ib_common.h 
 	     dapl/openib_cma/dapl_ib_util.h \
 	     dapl/openib_cma/linux/openib_osd.h \
 	     dapl/openib_scm/dapl_ib_util.h \
@@ -540,7 +546,7 @@ EXTRA_DIST = dat/common/dat_dictionary.h \
 	     test/dapltest/include/dapl_transaction_stats.h \
 	     test/dapltest/include/dapl_transaction_test.h \
 	     test/dapltest/include/dapl_version.h \
-	     test/dapltest/mdep/linux/dapl_mdep_user.h
+	     test/dapltest/mdep/linux/dapl_mdep_user.h $(XPROGRAMS)
 	 
 dist-hook: dapl.spec 
 	cp dapl.spec $(distdir)
diff --git a/configure.in b/configure.in
index c78942f..75c002c 100644
--- a/configure.in
+++ b/configure.in
@@ -83,6 +83,28 @@ AC_ARG_ENABLE(ext-type,
  ],[ext_type=ib])
 AM_CONDITIONAL(EXT_TYPE_IB, test "$ext_type" = "ib")
 
+dnl Support IB MPI collective extension build - if enable-coll-type == vendor_name 
+AC_ARG_ENABLE(coll-type,
+[  --enable-coll-type Enable IB collective support: fca, none, default=fca],
+ [ if   test "x$enableval" = "xfca" ; then
+      coll_type=fca
+      AC_CHECK_HEADER(fca/fca_api.h, [],
+        AC_MSG_ERROR([<fca/fca_api.h> not found. Is libfca devel package installed?]))
+      AC_CHECK_LIB(mverbs, ibv_m_post_send, [],
+        AC_MSG_ERROR([ibv_m_post_send() not found. Is libmverbs installed?]))
+      AC_CHECK_LIB(fca, fca_init, [],
+        AC_MSG_ERROR([fca_init() not found. Is libfca library installed?]))
+   elif test "x$enableval" = "xnone" ; then
+      coll_type=none
+   else
+      echo
+      echo "Error!"
+      echo "Unknown IB collective type' type"
+      exit -1
+   fi
+ ],[coll_type=fca])
+AM_CONDITIONAL(COLL_TYPE_FCA, test "$coll_type" = "fca")
+
 dnl Check for Redhat EL release 4
 AC_CACHE_CHECK(Check for RHEL4 system, ac_cv_rhel4,
     if test -f /etc/redhat-release &&
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
