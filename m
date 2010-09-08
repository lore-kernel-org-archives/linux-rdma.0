From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl: add support for ibacm
Date: Wed, 8 Sep 2010 11:22:43 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB4EA157@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow DAPL out of band connection models to use ibacm to obtain
path record data.  This will enable support for a wider range of
topologies, where the SL is required from the SA to prevent
deadlock.

DAPL will obtain path record data using rdma_getaddrinfo, provided
that IB ACM support is enabled.  On failure, dapl will fall back to
using its default SL value.  The IB ACM can be configured to cache
path information or always query the SA to ensure that the SL that is
obtained is current.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am                    |    4 ++-
 configure.in                   |   14 ++++++++++++
 dapl/openib_common/qp.c        |   46 ++++++++++++++++++++++++++++++++++++++--
 dapl/openib_ucm/dapl_ib_util.h |    1 +
 dapl/openib_ucm/device.c       |    1 +
 5 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0be6298..141a68b 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -324,7 +324,7 @@ dapl_udapl_libdaploscm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploscm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs
+                                   -lpthread -libverbs -lrdmacm
                                    
 #
 # uDAPL OpenFabrics UD CM version for IB: libdaplucm.so
@@ -438,7 +438,7 @@ dapl_udapl_libdaploucm_la_SOURCES = dapl/udapl/dapl_init.c \
 
 dapl_udapl_libdaploucm_la_LDFLAGS = -version-info 2:0:0 $(daploscm_version_script) \
                                    -Wl,-init,dapl_init -Wl,-fini,dapl_fini \
-                                   -lpthread -libverbs
+                                   -lpthread -libverbs -lrdmacm
 
 libdatincludedir = $(includedir)/dat2
 
diff --git a/configure.in b/configure.in
index b67314c..c8c1422 100644
--- a/configure.in
+++ b/configure.in
@@ -31,9 +31,23 @@ AC_CHECK_MEMBER(struct ibv_port_attr.link_layer,
     AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "yes"), 
     AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "no"), 
     [#include <infiniband/verbs.h>])
+
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+AC_CHECK_MEMBER(struct ibv_path_record.service_id, [],
+    AC_MSG_ERROR([IB ACM support requires libibverbs 1.1.4 or greater.]),
+    [#include <infiniband/sa.h>])
+AC_CHECK_HEADER(infiniband/acm.h, [],
+    AC_MSG_ERROR([IB ACM requested but <infiniband/acm.h> not found.]))
+fi
+
 else
     AM_CONDITIONAL(DEFINE_ATTR_LINK_LAYER, test "yes" = "no")
 fi
+dnl End check for libraries
+
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+    AC_DEFINE(DAPL_USE_IBACM, 1, [set to 1 to use IB ACM services])
+fi
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 179eef0..5c5c10f 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -22,9 +22,15 @@
  * notice, one of the license notices in the documentation
  * and/or other materials provided with the distribution.
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
+
 #include "dapl.h"
 #include "dapl_adapter_util.h"
 #include "dapl_ep_util.h"
+#include <infiniband/sa.h>
+#include <rdma/rdma_cma.h>
 
 /*
  * dapl_ib_qp_alloc
@@ -359,6 +365,42 @@ void dapls_ib_reinit_ep(IN DAPL_EP * ep_ptr)
 }
 #endif				// _WIN32 || _WIN64
 
+#if DAPL_USE_IBACM
+uint8_t dapls_get_sl(DAPL_HCA *hca_ptr, uint16_t dlid)
+{
+	struct rdma_addrinfo hint, *res;
+	struct ibv_path_record path;
+	uint8_t sl = hca_ptr->ib_trans.sl;
+	int ret;
+
+	memset(&path, 0, sizeof path);
+	path.reversible_numpath = IBV_PATH_RECORD_REVERSIBLE | 1;
+	path.slid = hca_ptr->ib_trans.lid;
+	path.dlid = dlid;
+
+	memset(&hint, 0, sizeof hint);
+	hint.ai_route = &path;
+	hint.ai_route_len = sizeof(path);
+
+	ret = rdma_getaddrinfo(NULL, NULL, &hint, &res);
+	if (ret)
+		goto out;
+	
+	if (res->ai_route_len)
+		sl = ntohs(((struct ibv_path_record *) res->ai_route)->
+			   qosclass_sl) & 0xF;
+
+	rdma_freeaddrinfo(res);
+out:	
+	return sl;
+}
+#else
+uint8_t dapls_get_sl(DAPL_HCA *hca_ptr, uint16_t dlid)
+{
+	return hca_ptr->ib_trans.sl;
+}
+#endif
+
 /* 
  * Generic QP modify for init, reset, error, RTS, RTR
  * For UD, create_ah on RTR, qkey on INIT
@@ -422,7 +464,7 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 			qp_attr.ah_attr.grh.traffic_class =
 				ia_ptr->hca_ptr->ib_trans.tclass;
 		}
-		qp_attr.ah_attr.sl = ia_ptr->hca_ptr->ib_trans.sl;
+		qp_attr.ah_attr.sl = dapls_get_sl(ia_ptr->hca_ptr, lid);
 		qp_attr.ah_attr.src_path_bits = 0;
 		qp_attr.ah_attr.port_num = ia_ptr->hca_ptr->port_num;
 
@@ -582,7 +624,7 @@ dapls_create_ah(IN DAPL_HCA		*hca,
 		qp_attr.ah_attr.grh.hop_limit =	hca->ib_trans.hop_limit;
 		qp_attr.ah_attr.grh.traffic_class = hca->ib_trans.tclass;
 	}
-	qp_attr.ah_attr.sl = hca->ib_trans.sl;
+	qp_attr.ah_attr.sl = dapls_get_sl(hca, lid);
 	qp_attr.ah_attr.src_path_bits = 0;
 	qp_attr.ah_attr.port_num = hca->port_num;
 
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 25ce963..9fd573e 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -113,6 +113,7 @@ typedef struct _ib_hca_transport
 	struct ibv_comp_channel *rch;
 	struct ibv_ah		**ah;  
 	DAPL_OS_LOCK		plock;
+	uint16_t		lid;
 	uint8_t			*sid;  /* Sevice IDs, port space, bitarray? */
 	uint8_t			sl;
 	uint16_t		pkey;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 1959c76..88463e1 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -237,6 +237,7 @@ found:
 		goto err;
 	} else {
 		hca_ptr->ib_trans.addr.ib.lid = htons(port_attr.lid);
+		hca_ptr->ib_trans.lid = htons(port_attr.lid);
 	}
 
 	/* get gid for this hca-port, network order */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
