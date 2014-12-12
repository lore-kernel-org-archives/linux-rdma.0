From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/4] common: return appropriate handles with affiliated EP and EVD async events
Date: Fri, 12 Dec 2014 08:50:40 -0800
Message-ID: <1418403043-2221-2-git-send-email-arlin.r.davis@intel.com>
References: <1418403043-2221-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418403043-2221-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_evd_cq_async_error_callb.c |    4 +--
 dapl/common/dapl_evd_qp_async_error_callb.c |   33 +--------------------------
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/dapl/common/dapl_evd_cq_async_error_callb.c b/dapl/common/dapl_evd_cq_async_error_callb.c
index 2bd2a93..2edbce0 100644
--- a/dapl/common/dapl_evd_cq_async_error_callb.c
+++ b/dapl/common/dapl_evd_cq_async_error_callb.c
@@ -77,9 +77,7 @@ dapl_evd_cq_async_error_callback(IN ib_hca_handle_t ib_hca_handle,
 
 	dat_status = dapls_evd_post_async_error_event(async_evd,
 						      DAT_ASYNC_ERROR_EVD_OVERFLOW,
-						      (DAT_IA_HANDLE)
-						      async_evd->header.
-						      owner_ia);
+						      (DAT_HANDLE) evd);
 
 	if (dat_status != DAT_SUCCESS) {
 		dapl_os_panic("async EVD overflow\n");
diff --git a/dapl/common/dapl_evd_qp_async_error_callb.c b/dapl/common/dapl_evd_qp_async_error_callb.c
index bc05d0f..6ea9edb 100644
--- a/dapl/common/dapl_evd_qp_async_error_callb.c
+++ b/dapl/common/dapl_evd_qp_async_error_callb.c
@@ -60,36 +60,6 @@ dapl_evd_qp_async_error_callback(IN ib_hca_handle_t ib_hca_handle,
 				 IN ib_error_record_t * cause_ptr,
 				 IN void *context)
 {
-	/*
-	 * This is an affiliated error and hence should be able to 
-	 * supply us with exact information on the error type and QP. 
-	 *
-	 * However the Mellanox and IBM APIs for registering this callback 
-	 * are different. 
-	 *
-	 * The IBM API allows consumers to register the callback with 
-	 *
-	 * ib_int32_t 
-	 * ib_set_qp_async_error_eh_us (
-	 *          ib_hca_handle_t         hca_handle,
-	 *          ib_qp_async_handler_t   handler )
-	 *
-	 * Notice that this function does not take a context. The context is 
-	 * specified per QP in the call to ib_qp_create_us().
-	 *
-	 * In contrast the Mellanox API requires that the context be specified 
-	 * when the funciton is registered:
-	 *
-	 * VAPI_ret_t 
-	 * VAPI_set_async_event_handler (
-	 *          IN VAPI_hca_hndl_t              hca_hndl,
-	 *          IN VAPI_async_event_handler_t   handler,
-	 *          IN void*                        private_data )
-	 *
-	 * Therefore we always specify the context as the asyncronous EVD 
-	 * to be compatible with both APIs.
-	 */
-
 	DAPL_IA *ia_ptr;
 	DAPL_EP *ep_ptr;
 	DAPL_EVD *async_evd;
@@ -138,8 +108,7 @@ dapl_evd_qp_async_error_callback(IN ib_hca_handle_t ib_hca_handle,
 		 */
 		(void)dapls_evd_post_async_error_event(async_evd,
 						       async_event,
-						       async_evd->header.
-						       owner_ia);
+						       (DAT_HANDLE) ep_ptr);
 	}
 	dapl_dbg_log(DAPL_DBG_TYPE_CALLBACK | DAPL_DBG_TYPE_EXCEPTION,
 		     "%s() returns\n", __FUNCTION__);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
