From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: build: link librdmacm dependency to ib_acm usage
 for ucm and scm providers
Date: Fri, 19 Aug 2011 20:31:59 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E4E016@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add -lrdmacm to XLIBS for ucm and scm providers. Only set library
linking with conditional use of ib_acm as defined by DAPL_USE_IBACM.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am  |    8 ++++++--
 configure.in |    4 ++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index a430568..a9bdeda 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,6 +33,10 @@ XHEADERS =
 XLIBS =
 endif
 
+if DAPL_USE_IBACM
+XLIBS += -lrdmacm
+endif
+
 if DEFINE_ATTR_LINK_LAYER
 XFLAGS += -DDEFINE_ATTR_LINK_LAYER
 endif
@@ -362,7 +366,7 @@ dapl_udapl_libdaploscm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploscm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs -lrdmacm $(XLIBS)
+                                   -lpthread -libverbs $(XLIBS)
 endif
 if DEFINE_UCM                      
 #
@@ -477,7 +481,7 @@ dapl_udapl_libdaploucm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploucm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs -lrdmacm $(XLIBS)
+                                   -lpthread -libverbs $(XLIBS)
 endif
 
 libdatincludedir = $(includedir)/dat2
diff --git a/configure.in b/configure.in
index 30524d9..fb405ff 100644
--- a/configure.in
+++ b/configure.in
@@ -47,7 +47,11 @@ dnl End check for libraries
 
 if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
     AC_DEFINE(DAPL_USE_IBACM, 1, [set to 1 to use IB ACM services])
+    ac_use_acm=yes
+else
+    ac_use_acm=no
 fi
+AM_CONDITIONAL(DAPL_USE_IBACM, test "$ac_use_acm" = "yes")
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
