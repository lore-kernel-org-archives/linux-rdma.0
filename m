From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: undefined symbol: dapls_print_cm_list
Date: Fri, 5 Feb 2010 12:04:11 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B2EB8D38@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



call prototype dependent on DAPL_COUNTERS definition.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/dapl_ib_util.h |    2 ++
 dapl/openib_scm/dapl_ib_util.h |    3 +++
 dapl/openib_ucm/dapl_ib_util.h |    3 +++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index 6b43c91..451a967 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -125,9 +125,11 @@ void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
 void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
 
+#ifdef DAPL_COUNTERS
 STATIC _INLINE_ void dapls_print_cm_list(IN DAPL_IA * ia_ptr)
 {
 	return;
 }
+#endif
 
 #endif /*  _DAPL_IB_UTIL_H_ */
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index 138a3dd..831084f 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -113,6 +113,9 @@ void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr);
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
 void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
+
+#ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
+#endif
 
 #endif /*  _DAPL_IB_UTIL_H_ */
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 6273459..d7844c6 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -119,7 +119,10 @@ void ucm_async_event(struct dapl_hca *hca);
 void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
 void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
+
+#ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
+#endif
 
 #endif /*  _DAPL_IB_UTIL_H_ */
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
