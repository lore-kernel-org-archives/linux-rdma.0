From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] common: add srq support for openib verbs providers
Date: Mon, 15 Dec 2014 10:35:56 -0800
Message-ID: <1418668558-695-2-git-send-email-arlin.r.davis@intel.com>
References: <1418668558-695-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418668558-695-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Hanania <amir.hanania-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Amir Hanania <amir.hanania-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add necessary components and hooks to support ib_verbs shared
receive queues for both RC and UD QP's. External interfaces
were already provided per DAT 2.0 specification but internal
support was missing.

A new dtestsrq will be provided with package for testing and
example code.

Acked-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am                                 |    4 +
 dapl/common/dapl_adapter_util.h             |   13 +++
 dapl/common/dapl_cr_callback.c              |    2 +-
 dapl/common/dapl_ep_create.c                |    2 +-
 dapl/common/dapl_ep_create_with_srq.c       |   53 ++++++----
 dapl/common/dapl_ep_free.c                  |    5 +
 dapl/common/dapl_ep_post_recv.c             |    5 +
 dapl/common/dapl_ep_util.c                  |   29 ++++--
 dapl/common/dapl_ep_util.h                  |    3 +-
 dapl/common/dapl_evd_qp_async_error_callb.c |   15 ++-
 dapl/common/dapl_evd_util.c                 |   49 ++++++++-
 dapl/common/dapl_srq_create.c               |   23 ++---
 dapl/common/dapl_srq_free.c                 |   36 +++----
 dapl/common/dapl_srq_post_recv.c            |    6 +-
 dapl/common/dapl_srq_query.c                |    6 +-
 dapl/common/dapl_srq_resize.c               |    9 +-
 dapl/common/dapl_srq_set_lw.c               |    4 +-
 dapl/common/dapl_srq_util.c                 |    2 -
 dapl/include/dapl.h                         |    2 +
 dapl/openib_common/cq.c                     |    3 +-
 dapl/openib_common/dapl_ib_common.h         |    1 +
 dapl/openib_common/dapl_ib_dto.h            |   48 +++++++++
 dapl/openib_common/qp.c                     |    5 +
 dapl/openib_common/srq.c                    |  147 +++++++++++++++++++++++++++
 dapl/openib_common/util.c                   |    9 ++-
 dat/include/dat2/dat.h                      |    3 +-
 dat/include/dat2/dat_error.h                |    1 +
 test/dtest/Makefile.am                      |    6 +-
 28 files changed, 388 insertions(+), 103 deletions(-)
 create mode 100644 dapl/openib_common/srq.c

diff --git a/Makefile.am b/Makefile.am
index f9c4093..7ad5af1 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -273,6 +273,7 @@ dapl_udapl_libdaplofa_la_SOURCES = dapl/udapl/dapl_init.c \
         dapl/openib_common/cq.c                     \
         dapl/openib_common/qp.c                     \
         dapl/openib_common/util.c                   \
+        dapl/openib_common/srq.c                    \
         dapl/openib_cma/cm.c                        \
         dapl/openib_cma/device.c $(XPROGRAMS)
 
@@ -389,6 +390,7 @@ dapl_udapl_libdaploscm_la_SOURCES = dapl/udapl/dapl_init.c \
         dapl/openib_common/cq.c                     \
         dapl/openib_common/qp.c                     \
         dapl/openib_common/util.c                   \
+        dapl/openib_common/srq.c                    \
         dapl/openib_scm/cm.c                        \
         dapl/openib_scm/device.c $(XPROGRAMS)
 
@@ -505,6 +507,7 @@ dapl_udapl_libdaploucm_la_SOURCES = dapl/udapl/dapl_init.c \
         dapl/openib_common/cq.c                     \
         dapl/openib_common/qp.c                     \
         dapl/openib_common/util.c                   \
+        dapl/openib_common/srq.c                    \
         dapl/openib_ucm/cm.c                        \
         dapl/openib_ucm/device.c $(XPROGRAMS)
 
@@ -622,6 +625,7 @@ dapl_udapl_libdaplomcm_la_SOURCES = dapl/udapl/dapl_init.c \
         dapl/openib_common/cq.c                     \
         dapl/openib_common/qp.c                     \
         dapl/openib_common/util.c                   \
+        dapl/openib_common/srq.c                    \
         dapl/openib_mcm/cm.c                        \
         dapl/openib_mcm/mix.c                       \
         dapl/openib_mcm/proxy.c                     \
diff --git a/dapl/common/dapl_adapter_util.h b/dapl/common/dapl_adapter_util.h
index 9b12b2d..ba4e73b 100755
--- a/dapl/common/dapl_adapter_util.h
+++ b/dapl/common/dapl_adapter_util.h
@@ -263,6 +263,19 @@ dapls_evd_dto_wait (
 	IN DAPL_EVD			*evd_ptr,
 	IN uint32_t 			timeout);
 
+DAT_RETURN
+dapls_ib_srq_alloc (
+	IN DAPL_SRQ 			*srq_ptr);
+
+DAT_RETURN
+dapls_ib_srq_free (
+	IN DAPL_SRQ 			*srq_ptr);
+
+DAT_RETURN
+dapls_ib_srq_resize(
+	IN DAPL_SRQ 			*srq_ptr,
+	IN uint32_t 			new_max_wr);
+
 #ifdef DAT_EXTENSIONS
 void
 dapls_cqe_to_event_extension(
diff --git a/dapl/common/dapl_cr_callback.c b/dapl/common/dapl_cr_callback.c
index 8bfbb3e..1b7e6be 100644
--- a/dapl/common/dapl_cr_callback.c
+++ b/dapl/common/dapl_cr_callback.c
@@ -366,7 +366,7 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
 		 * requestor that we cant help them.
 		 */
 		ia_ptr = sp_ptr->header.owner_ia;
-		ep_ptr = dapl_ep_alloc(ia_ptr, NULL);
+		ep_ptr = dapl_ep_alloc(ia_ptr, NULL, DAT_FALSE);
 		if (ep_ptr == NULL) {
 			dapls_cr_free(cr_ptr);
 			/* Invoking function will call dapls_ib_cm_reject() */
diff --git a/dapl/common/dapl_ep_create.c b/dapl/common/dapl_ep_create.c
index ec11c7c..4001d26 100644
--- a/dapl/common/dapl_ep_create.c
+++ b/dapl/common/dapl_ep_create.c
@@ -237,7 +237,7 @@ dapl_ep_create(IN DAT_IA_HANDLE ia_handle,
 	}
 
 	/* Allocate EP */
-	ep_ptr = dapl_ep_alloc(ia_ptr, ep_attr);
+	ep_ptr = dapl_ep_alloc(ia_ptr, ep_attr, DAT_FALSE);
 	if (ep_ptr == NULL) {
 		dat_status =
 		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
diff --git a/dapl/common/dapl_ep_create_with_srq.c b/dapl/common/dapl_ep_create_with_srq.c
index b85abfd..1f489ff 100644
--- a/dapl/common/dapl_ep_create_with_srq.c
+++ b/dapl/common/dapl_ep_create_with_srq.c
@@ -84,6 +84,7 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 	DAT_EP_ATTR ep_attr_limit;
 	DAPL_EVD *evd_ptr;
 	DAT_RETURN dat_status;
+	*ep_handle = NULL;
 
 	dat_status = DAT_SUCCESS;
 	dapl_dbg_log(DAPL_DBG_TYPE_API,
@@ -146,25 +147,37 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		goto bail;
 	}
 
+	if (ep_handle == NULL) {
+		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG7);
+		goto bail;
+	}
+
+	if (DAPL_BAD_PTR(ep_attr)) {
+		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG6);
+		goto bail;
+	}
+
 	/*
 	 * Verify the SRQ handle. It is an error to invoke this call with
 	 * a NULL handle
 	 */
+	dapl_os_lock(&ia_ptr->header.lock);
 	if (DAPL_BAD_HANDLE(srq_handle, DAPL_MAGIC_SRQ)) {
 		dat_status =
 		    DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_SRQ);
+		dapl_os_unlock(&ia_ptr->header.lock);
 		goto bail;
 	}
-
-	if (ep_handle == NULL) {
-		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG7);
+	if (((DAPL_SRQ *) srq_handle)->param.srq_state ==
+						DAT_SRQ_STATE_SHUTDOWN) {
+		dat_status =
+		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_SRQ_SHUTDOWN);
+		dapl_os_unlock(&ia_ptr->header.lock);
 		goto bail;
-	}
 
-	if (DAPL_BAD_PTR(ep_attr)) {
-		dat_status = DAT_ERROR(DAT_INVALID_PARAMETER, DAT_INVALID_ARG6);
-		goto bail;
 	}
+	dapl_os_atomic_inc(&((DAPL_SRQ *) srq_handle)->srq_ref_count);
+	dapl_os_unlock(&ia_ptr->header.lock);
 
 	/*
 	 * Qualify EP Attributes are legal and make sense.  Note that if one
@@ -173,8 +186,7 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 	 * the respective queue.
 	 */
 	if (ep_attr != NULL &&
-	    (ep_attr->service_type != DAT_SERVICE_TYPE_RC ||
-	     (recv_evd_handle == DAT_HANDLE_NULL && ep_attr->max_recv_dtos != 0)
+	    ((recv_evd_handle == DAT_HANDLE_NULL && ep_attr->max_recv_dtos != 0)
 	     || (recv_evd_handle != DAT_HANDLE_NULL
 		 && ep_attr->max_recv_dtos == 0)
 	     || (request_evd_handle == DAT_HANDLE_NULL
@@ -186,6 +198,7 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		 dapl_ep_check_recv_completion_flags(ep_attr->
 						     recv_completion_flags)))) {
 		dat_status = DAT_INVALID_PARAMETER | DAT_INVALID_ARG6;
+		dapl_os_atomic_dec(&((DAPL_SRQ *) srq_handle)->srq_ref_count);
 		goto bail;
 	}
 
@@ -195,6 +208,7 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		dat_status = dapls_ib_query_hca(ia_ptr->hca_ptr,
 						NULL, &ep_attr_limit, NULL);
 		if (dat_status != DAT_SUCCESS) {
+			dapl_os_atomic_dec(&((DAPL_SRQ *) srq_handle)->srq_ref_count);
 			goto bail;
 		}
 		if (ep_attr->max_mtu_size > ep_attr_limit.max_mtu_size ||
@@ -209,6 +223,8 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		    ep_attr_limit.max_rdma_read_out)
 		{
 			dat_status = DAT_INVALID_PARAMETER | DAT_INVALID_ARG6;
+			dapl_os_atomic_dec(&((DAPL_SRQ *) srq_handle)->
+					   srq_ref_count);
 			goto bail;
 		}
 	}
@@ -246,22 +262,12 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		}
 	}
 
-	dat_status = DAT_NOT_IMPLEMENTED;
-
-	/*
-	 * XXX The rest of the EP code is useful in this case too,
-	 * XXX but need to complete the SRQ implementation before
-	 * XXX committing resources
-	 */
-	*ep_handle = ep_ptr = NULL;
-	goto bail;
-#ifdef notdef
-
 	/* Allocate EP */
-	ep_ptr = dapl_ep_alloc(ia_ptr, ep_attr);
+	ep_ptr = dapl_ep_alloc(ia_ptr, ep_attr, DAT_TRUE);
 	if (ep_ptr == NULL) {
 		dat_status =
 		    DAT_ERROR(DAT_INSUFFICIENT_RESOURCES, DAT_RESOURCE_MEMORY);
+		dapl_os_atomic_dec(&((DAPL_SRQ *) srq_handle)->srq_ref_count);
 		goto bail;
 	}
 
@@ -279,6 +285,7 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 	ep_ptr->param.recv_evd_handle = recv_evd_handle;
 	ep_ptr->param.request_evd_handle = request_evd_handle;
 	ep_ptr->param.connect_evd_handle = connect_evd_handle;
+	ep_ptr->param.srq_handle = srq_handle;
 
 	/*
 	 * Make sure we handle the NULL DTO EVDs
@@ -309,6 +316,8 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 		if (dat_status != DAT_SUCCESS) {
 			dapl_os_atomic_dec(&((DAPL_PZ *) pz_handle)->
 					   pz_ref_count);
+			dapl_os_atomic_dec(&((DAPL_SRQ *) srq_handle)->
+					   srq_ref_count);
 			dapl_ep_dealloc(ep_ptr);
 			goto bail;
 		}
@@ -340,8 +349,6 @@ dapl_ep_create_with_srq(IN DAT_IA_HANDLE ia_handle,
 
 	*ep_handle = ep_ptr;
 
-#endif				/* notdef */
-
       bail:
 	return dat_status;
 }
diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index 178cae6..62d7eff 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -162,6 +162,11 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 				   evd_ref_count);
 		param->connect_evd_handle = NULL;
 	}
+	if (param->srq_handle != NULL) {
+		dapl_os_atomic_dec(&((DAPL_SRQ *) param->srq_handle)->
+				   srq_ref_count);
+		param->srq_handle = NULL;
+	}
 
 	/*
 	 * Finish tearing everything down.
diff --git a/dapl/common/dapl_ep_post_recv.c b/dapl/common/dapl_ep_post_recv.c
index fe3a605..0ed0181 100644
--- a/dapl/common/dapl_ep_post_recv.c
+++ b/dapl/common/dapl_ep_post_recv.c
@@ -90,6 +90,11 @@ dapl_ep_post_recv(IN DAT_EP_HANDLE ep_handle,
 	}
 
 	ep_ptr = (DAPL_EP *) ep_handle;
+	if (ep_ptr->param.srq_handle) {
+		dat_status =
+		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_SRQ_IN_USE);
+		goto bail;
+	}
 
 	/*
 	 * Synchronization ok since this buffer is only used for receive
diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index 8ceb1be..42488d8 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -104,7 +104,8 @@ char *dapl_get_ep_state_str(DAT_EP_STATE state)
  * 	none
  *
  */
-DAPL_EP *dapl_ep_alloc(IN DAPL_IA * ia_ptr, IN const DAT_EP_ATTR * ep_attr)
+DAPL_EP *dapl_ep_alloc(IN DAPL_IA * ia_ptr, IN const DAT_EP_ATTR * ep_attr,
+		       IN DAT_BOOLEAN using_srq)
 {
 	DAPL_EP *ep_ptr;
 
@@ -172,13 +173,16 @@ DAPL_EP *dapl_ep_alloc(IN DAPL_IA * ia_ptr, IN const DAT_EP_ATTR * ep_attr)
 		goto bail;
 	}
 
-	if (DAT_SUCCESS != dapls_cb_create(&ep_ptr->recv_buffer,
-					   ep_ptr,
-					   ep_ptr->param.ep_attr.max_recv_dtos))
-	{
-		dapl_ep_dealloc(ep_ptr);
-		ep_ptr = NULL;
-		goto bail;
+	/* SRQ case - don't allocate as we use the SRQ recv buffer */
+	if (using_srq == DAT_FALSE) {
+		if (DAT_SUCCESS != dapls_cb_create(&ep_ptr->recv_buffer,
+						   ep_ptr,
+						   ep_ptr->param.ep_attr.max_recv_dtos))
+		{
+			dapl_ep_dealloc(ep_ptr);
+			ep_ptr = NULL;
+			goto bail;
+		}
 	}
 
 	dapls_io_trc_alloc(ep_ptr);
@@ -209,7 +213,8 @@ void dapl_ep_dealloc(IN DAPL_EP * ep_ptr)
 	ep_ptr->header.magic = DAPL_MAGIC_INVALID;	/* reset magic to prevent reuse */
 
 	dapls_cb_free(&ep_ptr->req_buffer);
-	dapls_cb_free(&ep_ptr->recv_buffer);
+	if (ep_ptr->recv_buffer.pool)
+		dapls_cb_free(&ep_ptr->recv_buffer);
 
 	if (NULL != ep_ptr->cxn_timer) {
 		dapl_os_free(ep_ptr->cxn_timer, sizeof(DAPL_OS_TIMER));
@@ -627,8 +632,10 @@ void dapls_ep_flush_cqs(DAPL_EP * ep_ptr)
 	if (ep_ptr->param.request_evd_handle)
 		dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
 	if (ep_ptr->param.recv_evd_handle)
-		while (dapls_cb_pending(&ep_ptr->recv_buffer))
-			dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.recv_evd_handle);
+		if (ep_ptr->recv_buffer.pool)
+			while (dapls_cb_pending(&ep_ptr->recv_buffer))
+				dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.
+							recv_evd_handle);
 }
 
 /*
diff --git a/dapl/common/dapl_ep_util.h b/dapl/common/dapl_ep_util.h
index 37805d4..5cf6080 100644
--- a/dapl/common/dapl_ep_util.h
+++ b/dapl/common/dapl_ep_util.h
@@ -46,7 +46,8 @@
 extern DAPL_EP * 
 dapl_ep_alloc (
     IN DAPL_IA			*ia,
-    IN const DAT_EP_ATTR	*ep_attr );
+    IN const DAT_EP_ATTR	*ep_attr,
+    IN DAT_BOOLEAN using_srq );
 
 extern void 
 dapl_ep_dealloc (
diff --git a/dapl/common/dapl_evd_qp_async_error_callb.c b/dapl/common/dapl_evd_qp_async_error_callb.c
index 6ea9edb..90767f5 100644
--- a/dapl/common/dapl_evd_qp_async_error_callb.c
+++ b/dapl/common/dapl_evd_qp_async_error_callb.c
@@ -67,10 +67,10 @@ dapl_evd_qp_async_error_callback(IN ib_hca_handle_t ib_hca_handle,
 	DAT_RETURN dat_status;
 
 #ifdef _VENDOR_IBAL_
-	dapl_dbg_log(DAPL_DBG_TYPE_ERR, "%s() IB err %s\n",
+	dapl_dbg_log(DAPL_DBG_TYPE_EXCEPTION, "%s() IB err %s\n",
 		     __FUNCTION__, ib_get_async_event_str(cause_ptr->code));
 #else
-	dapl_dbg_log(DAPL_DBG_TYPE_ERR, "%s() IB async QP err - ctx=%p\n",
+	dapl_dbg_log(DAPL_DBG_TYPE_EXCEPTION, "%s() IB async QP err - ctx=%p\n",
 		     __FUNCTION__, context);
 #endif
 
@@ -85,16 +85,21 @@ dapl_evd_qp_async_error_callback(IN ib_hca_handle_t ib_hca_handle,
 	async_evd = (DAPL_EVD *) ia_ptr->async_error_evd;
 	DAPL_CNTR(ia_ptr, DCNT_IA_ASYNC_QP_ERROR);
 
-	dapl_log(DAPL_DBG_TYPE_WARN, " -- %s: ep %p qp %p (%x) state %d\n",
+	dapl_log(DAPL_DBG_TYPE_EXCEPTION, " -- %s: ep %p qp %p (%x) state %d\n",
 		 __FUNCTION__,  ep_ptr, ep_ptr->qp_handle,
 		 ep_ptr->qpn, ep_ptr->param.ep_state);
 
 	/*
 	 * Transition to ERROR if we are connected; other states need to
-	 * complete first (e.g. pending states)
+	 * complete first (e.g. pending states) unless it's SRQ LAST_WQE_REACHED
+	 * which is a regular async event in case of disconnect.
 	 */
 	if (ep_ptr->param.ep_state == DAT_EP_STATE_CONNECTED) {
-		ep_ptr->param.ep_state = DAT_EP_STATE_ERROR;
+		if (!ep_ptr->param.srq_handle || cause_ptr->event_type != IBV_EVENT_QP_LAST_WQE_REACHED) {
+			dapl_os_lock(&ep_ptr->header.lock);
+			ep_ptr->param.ep_state = DAT_EP_STATE_ERROR;
+			dapl_os_unlock(&ep_ptr->header.lock);
+		}
 	}
 
 	dapl_os_assert(async_evd != NULL);
diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 6b9d1f7..85d8f64 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -738,8 +738,8 @@ dapls_evd_post_async_error_event(IN DAPL_EVD * evd_ptr,
 {
 	DAT_EVENT *event_ptr;
 
-	dapl_log(DAPL_DBG_TYPE_WARN,
-		 " WARNING: async event - %s evd=%p\n",
+	dapl_log(DAPL_DBG_TYPE_EXCEPTION,
+		 " async event - %s evd=%p\n",
 		 dapl_event_str(event_number), evd_ptr);
 
 	dapl_os_lock(&evd_ptr->header.lock);
@@ -975,7 +975,7 @@ dapls_evd_post_cr_event_ext(IN DAPL_SP * sp_ptr,
 		 * requestor that we cant help them.
 		 */
 		ia_ptr = sp_ptr->header.owner_ia;
-		ep_ptr = dapl_ep_alloc(ia_ptr, NULL);
+		ep_ptr = dapl_ep_alloc(ia_ptr, NULL, DAT_FALSE);
 		if (ep_ptr == NULL) {
 			dapls_cr_free(cr_ptr);
 			goto bail;
@@ -1086,6 +1086,7 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 	DAPL_COOKIE *cookie;
 	DAT_DTO_COMPLETION_STATUS dto_status;
 	DAPL_COOKIE_BUFFER *buffer;
+	DAPL_SRQ *srq_ptr = NULL;
 
 	/*
 	 * All that can be relied on if the status is bad is the status
@@ -1096,6 +1097,7 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 	cookie = (DAPL_COOKIE *) (uintptr_t) DAPL_GET_CQE_WRID(cqe_ptr);
 	dapl_os_assert((NULL != cookie));
 
+	/* In case of RECV SRQ DTO cookie->ep holds pointer to the SRQ */
 	ep_ptr = cookie->ep;
 	dapl_os_assert((NULL != ep_ptr));
 
@@ -1125,8 +1127,13 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 				break;
 			}
 #endif
-
-			if (DAPL_DTO_TYPE_RECV == cookie->val.dto.type)
+			if (DAPL_DTO_TYPE_RECV_SRQ == cookie->val.dto.type) {
+				/* in SRQ event we do NOT have ep pointer */
+				srq_ptr = (DAPL_SRQ *)ep_ptr;
+				buffer = &srq_ptr->recv_buffer;
+				ep_ptr = NULL;
+			}
+			else if (DAPL_DTO_TYPE_RECV == cookie->val.dto.type)
 				buffer = &ep_ptr->recv_buffer;
 			else
 				buffer = &ep_ptr->req_buffer;
@@ -1151,6 +1158,8 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 			}
 
 			dapls_cookie_dealloc(buffer, cookie);
+			if (srq_ptr)
+				dapl_os_atomic_dec(&srq_ptr->recv_count);
 			break;
 		}
 
@@ -1198,6 +1207,36 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 	    (dto_status != DAT_DTO_ERR_FLUSHED)) {
 		DAPL_EVD *evd_ptr;
 
+		/* In SRQ case we need to look up the EP */
+		if (ep_ptr == NULL) {
+			DAT_UINT32 qp_num = DAPL_GET_CQE_QP_NUM(cqe_ptr);
+			DAPL_IA *ia_ptr = (DAPL_IA *)srq_ptr->param.ia_handle;
+
+			dapl_os_lock(&ia_ptr->header.lock);
+			ep_ptr = (dapl_llist_is_empty(&ia_ptr->ep_list_head)
+				   ? NULL :
+				   dapl_llist_peek_head(&ia_ptr->ep_list_head));
+
+			while (ep_ptr != NULL) {
+				if (ep_ptr->qp_handle->qp->qp_num == qp_num)
+					break;
+
+				ep_ptr =
+				    dapl_llist_next_entry(&ia_ptr->ep_list_head,
+								&ep_ptr->header.
+								ia_list_entry);
+			}
+			dapl_os_unlock(&ia_ptr->header.lock);
+
+			if (ep_ptr == NULL ) {
+				dapl_dbg_log(DAPL_DBG_TYPE_DTO_COMP_ERR,
+					     " SRQ %p at ia %p - "
+					     "EP with qpn %d was not found\n",
+					     srq_ptr, ia_ptr, qp_num);
+				return;
+			}
+		}
+
 		/*
 		 * If we are connected, generate disconnect and generate an
 		 * event. We may be racing with other disconnect ops, so we
diff --git a/dapl/common/dapl_srq_create.c b/dapl/common/dapl_srq_create.c
index 77aeacd..43d1637 100644
--- a/dapl/common/dapl_srq_create.c
+++ b/dapl/common/dapl_srq_create.c
@@ -93,13 +93,7 @@ dapl_srq_create(IN DAT_IA_HANDLE ia_handle,
 
 	DAPL_CNTR(ia_ptr, DCNT_IA_SRQ_CREATE);
 
-	/*
-	 * Verify non-required parameters.
-	 * N.B. Assumption: any parameter that can be
-	 *      modified by dat_ep_modify() is not strictly
-	 *      required when the EP is created
-	 */
-	if (pz_handle != NULL && DAPL_BAD_HANDLE(pz_handle, DAPL_MAGIC_PZ)) {
+	if (DAPL_BAD_HANDLE(pz_handle, DAPL_MAGIC_PZ)) {
 		dat_status =
 		    DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_PZ);
 		goto bail;
@@ -114,10 +108,6 @@ dapl_srq_create(IN DAT_IA_HANDLE ia_handle,
 		goto bail;
 	}
 
-	/* SRQ provider not implemented */
-	dat_status = DAT_ERROR(DAT_NOT_IMPLEMENTED, DAT_NO_SUBTYPE);
-	goto bail;
-
 	/* Allocate SRQ */
 	srq_ptr = dapl_srq_alloc(ia_ptr, srq_attr);
 	if (srq_ptr == NULL) {
@@ -127,18 +117,25 @@ dapl_srq_create(IN DAT_IA_HANDLE ia_handle,
 	}
 
 	srq_ptr->param.ia_handle = (DAT_IA_HANDLE) ia_ptr;
-	srq_ptr->param.srq_state = DAT_SRQ_STATE_OPERATIONAL;
 	srq_ptr->param.pz_handle = pz_handle;
 
 	/*
-	 * XXX Allocate provider resource here!!!
+	 * Get a SRQ from the IB provider
 	 */
+	dat_status = dapls_ib_srq_alloc(srq_ptr);
+	if (dat_status != DAT_SUCCESS) {
+		dapl_srq_dealloc(srq_ptr);
+		goto bail;
+	}
 
 	/* Link it onto the IA */
 	dapl_ia_link_srq(ia_ptr, srq_ptr);
 
 	*srq_handle = srq_ptr;
 
+	/* Ready */
+	srq_ptr->param.srq_state = DAT_SRQ_STATE_OPERATIONAL;
+
       bail:
 	return dat_status;
 }
diff --git a/dapl/common/dapl_srq_free.c b/dapl/common/dapl_srq_free.c
index d93e188..dcb1278 100644
--- a/dapl/common/dapl_srq_free.c
+++ b/dapl/common/dapl_srq_free.c
@@ -72,6 +72,16 @@ DAT_RETURN DAT_API dapl_srq_free(IN DAT_SRQ_HANDLE srq_handle)
 
 	srq_ptr = (DAPL_SRQ *) srq_handle;
 	param = &srq_ptr->param;
+	ia_ptr = srq_ptr->header.owner_ia;
+
+	/*
+	 * Verify parameters
+	 */
+	if (DAPL_BAD_HANDLE(ia_ptr, DAPL_MAGIC_IA)) {
+		dat_status =
+		    DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_IA);
+		goto bail;
+	}
 
 	/*
 	 * Verify parameter & state
@@ -82,6 +92,7 @@ DAT_RETURN DAT_API dapl_srq_free(IN DAT_SRQ_HANDLE srq_handle)
 		goto bail;
 	}
 
+	dapl_os_lock(&ia_ptr->header.lock);
 	if (dapl_os_atomic_read(&srq_ptr->srq_ref_count) != 0) {
 		/*
 		 * The DAPL 1.2 spec says to return DAT_SRQ_IN_USE, which does
@@ -89,32 +100,17 @@ DAT_RETURN DAT_API dapl_srq_free(IN DAT_SRQ_HANDLE srq_handle)
 		 */
 		dat_status =
 		    DAT_ERROR(DAT_INVALID_STATE, DAT_INVALID_STATE_SRQ_IN_USE);
+		dapl_os_unlock(&ia_ptr->header.lock);
 		goto bail;
 	}
-
-	ia_ptr = srq_ptr->header.owner_ia;
+	param->srq_state = DAT_SRQ_STATE_SHUTDOWN;
+	dapl_os_unlock(&ia_ptr->header.lock);
 
 	DAPL_CNTR(ia_ptr, DCNT_IA_SRQ_FREE);
 
-	/*
-	 * Do verification of parameters and the state change atomically.
-	 */
-	dapl_os_lock(&srq_ptr->header.lock);
-
-	/* Remove the SRQ from the IA */
-	dapl_ia_unlink_srq(ia_ptr, srq_ptr);
-
-	dapl_os_unlock(&srq_ptr->header.lock);
-
-	/*
-	 * Finish tearing everything down.
-	 */
-
-	/*
-	 * Take care of the transport resource
-	 */
+	dapl_ia_unlink_srq(srq_ptr->header.owner_ia, srq_ptr);
 
-	/* XXX Put provider code here!!! */
+	dapls_ib_srq_free(srq_ptr);
 
 	/* Free the resource */
 	dapl_srq_dealloc(srq_ptr);
diff --git a/dapl/common/dapl_srq_post_recv.c b/dapl/common/dapl_srq_post_recv.c
index d46f9bd..fbe714c 100644
--- a/dapl/common/dapl_srq_post_recv.c
+++ b/dapl/common/dapl_srq_post_recv.c
@@ -95,7 +95,7 @@ dapl_srq_post_recv(IN DAT_SRQ_HANDLE srq_handle,
 	 * app must syncronize access to the SRQ.
 	 */
 	dat_status = dapls_dto_cookie_alloc(&srq_ptr->recv_buffer,
-					    DAPL_DTO_TYPE_RECV,
+					    DAPL_DTO_TYPE_RECV_SRQ,
 					    user_cookie, &cookie);
 	if (DAT_SUCCESS != dat_status) {
 		goto bail;
@@ -110,8 +110,8 @@ dapl_srq_post_recv(IN DAT_SRQ_HANDLE srq_handle,
 	/*
 	 * Invoke provider specific routine to post DTO
 	 */
-	/* XXX Put code here XXX */
-	/* XXX */ dat_status = DAT_ERROR(DAT_NOT_IMPLEMENTED, DAT_NO_SUBTYPE);
+	dat_status = dapls_ib_post_srq_recv(srq_ptr, cookie,
+					    num_segments, local_iov);
 
 	if (dat_status != DAT_SUCCESS) {
 		dapl_os_atomic_dec(&srq_ptr->recv_count);
diff --git a/dapl/common/dapl_srq_query.c b/dapl/common/dapl_srq_query.c
index f9ad443..6761095 100644
--- a/dapl/common/dapl_srq_query.c
+++ b/dapl/common/dapl_srq_query.c
@@ -84,11 +84,9 @@ dapl_srq_query(IN DAT_SRQ_HANDLE srq_handle,
 
 	srq_ptr = (DAPL_SRQ *) srq_handle;
 
-	/*
-	 * XXX Need to calculate available_dto_count and outstanding_dto_count
-	 */
 	srq_ptr->param.available_dto_count = DAT_VALUE_UNKNOWN;
-	srq_ptr->param.outstanding_dto_count = DAT_VALUE_UNKNOWN;
+	srq_ptr->param.outstanding_dto_count =
+				dapl_os_atomic_read(&srq_ptr->recv_count);
 
 	*srq_param = srq_ptr->param;
 	dats_get_ia_handle(srq_ptr->header.owner_ia, &srq_param->ia_handle);
diff --git a/dapl/common/dapl_srq_resize.c b/dapl/common/dapl_srq_resize.c
index 32386ff..aadc35e 100644
--- a/dapl/common/dapl_srq_resize.c
+++ b/dapl/common/dapl_srq_resize.c
@@ -66,7 +66,6 @@
 DAT_RETURN DAT_API
 dapl_srq_resize(IN DAT_SRQ_HANDLE srq_handle, IN DAT_COUNT srq_max_recv_dto)
 {
-	DAPL_IA *ia_ptr;
 	DAPL_SRQ *srq_ptr;
 	DAT_RETURN dat_status;
 
@@ -82,19 +81,17 @@ dapl_srq_resize(IN DAT_SRQ_HANDLE srq_handle, IN DAT_COUNT srq_max_recv_dto)
 	}
 
 	srq_ptr = (DAPL_SRQ *) srq_handle;
-	ia_ptr = srq_ptr->header.owner_ia;
 
 	/*
 	 * Check for nonsense requests per the spec
 	 */
-	if (srq_max_recv_dto <= srq_ptr->param.low_watermark) {
+	if (srq_max_recv_dto <= srq_ptr->param.low_watermark ||
+	    srq_max_recv_dto < dapl_os_atomic_read(&srq_ptr->recv_count)) {
 		dat_status = DAT_ERROR(DAT_INVALID_STATE, DAT_NO_SUBTYPE);
 		goto bail;
 	}
 
-	/* XXX Put implementation here XXX */
-
-	/* XXX */ dat_status = DAT_ERROR(DAT_NOT_IMPLEMENTED, DAT_NO_SUBTYPE);
+	dat_status = dapls_ib_srq_resize(srq_ptr, (uint32_t)srq_max_recv_dto);
 
       bail:
 	return dat_status;
diff --git a/dapl/common/dapl_srq_set_lw.c b/dapl/common/dapl_srq_set_lw.c
index 1e4254f..8202e4f 100644
--- a/dapl/common/dapl_srq_set_lw.c
+++ b/dapl/common/dapl_srq_set_lw.c
@@ -82,9 +82,7 @@ dapl_srq_set_lw(IN DAT_SRQ_HANDLE srq_handle, IN DAT_COUNT low_watermark)
 
 	srq_ptr = (DAPL_SRQ *) srq_handle;
 
-	/* XXX Put implementation here XXX */
-
-	/* XXX */ dat_status = DAT_ERROR(DAT_NOT_IMPLEMENTED, DAT_NO_SUBTYPE);
+	dat_status = DAT_ERROR(DAT_NOT_IMPLEMENTED, DAT_NO_SUBTYPE);
 
       bail:
 	return dat_status;
diff --git a/dapl/common/dapl_srq_util.c b/dapl/common/dapl_srq_util.c
index 3b29890..4cf30ef 100644
--- a/dapl/common/dapl_srq_util.c
+++ b/dapl/common/dapl_srq_util.c
@@ -84,7 +84,6 @@ DAPL_SRQ *dapl_srq_alloc(IN DAPL_IA * ia_ptr, IN const DAT_SRQ_ATTR * srq_attr)
 
 	/*
 	 * Initialize the body. 
-	 * XXX Assume srq_attrs is required
 	 */
 	srq_ptr->param.max_recv_dtos = srq_attr->max_recv_dtos;
 	srq_ptr->param.max_recv_iov = srq_attr->max_recv_iov;
@@ -122,7 +121,6 @@ void dapl_srq_dealloc(IN DAPL_SRQ * srq_ptr)
 	dapl_os_assert(srq_ptr->header.magic == DAPL_MAGIC_SRQ);
 
 	srq_ptr->header.magic = DAPL_MAGIC_INVALID;	/* reset magic to prevent reuse */
-	dapl_ia_unlink_srq(srq_ptr->header.owner_ia, srq_ptr);
 	dapls_cb_free(&srq_ptr->recv_buffer);
 	dapl_os_lock_destroy(&srq_ptr->header.lock);
 
diff --git a/dapl/include/dapl.h b/dapl/include/dapl.h
index df4b099..60de914 100755
--- a/dapl/include/dapl.h
+++ b/dapl/include/dapl.h
@@ -479,6 +479,7 @@ struct dapl_srq
     DAPL_ATOMIC		srq_ref_count;
     DAPL_COOKIE_BUFFER	recv_buffer;
     DAPL_ATOMIC		recv_count;
+    ib_srq_handle_t	srq_handle;
 };
 
 /* DAPL_PZ maps to DAT_PZ_HANDLE */
@@ -580,6 +581,7 @@ typedef enum dapl_dto_type
 {
     DAPL_DTO_TYPE_SEND,
     DAPL_DTO_TYPE_RECV,
+    DAPL_DTO_TYPE_RECV_SRQ,
     DAPL_DTO_TYPE_RDMA_WRITE,
     DAPL_DTO_TYPE_RDMA_READ,
 #ifdef DAT_EXTENSIONS
diff --git a/dapl/openib_common/cq.c b/dapl/openib_common/cq.c
index 254f907..feffded 100644
--- a/dapl/openib_common/cq.c
+++ b/dapl/openib_common/cq.c
@@ -114,7 +114,8 @@ DAT_RETURN dapls_ib_get_async_event(IN ib_error_record_t * err_record,
 	DAT_RETURN dat_status = DAT_SUCCESS;
 	int err_code = err_record->event_type;
 
-	dapl_log(DAPL_DBG_TYPE_WARN, " WARNING: %s\n", dapl_ib_async_str(err_code));
+	dapl_log(DAPL_DBG_TYPE_EXCEPTION, " %s %s\n", __FUNCTION__,
+				dapl_ib_async_str(err_code));
 
 	switch (err_code)
 	{
diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 42391b2..453f437 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -90,6 +90,7 @@ typedef	struct ibv_mw		*ib_mw_handle_t;
 typedef	struct ibv_wc		ib_work_completion_t;
 typedef struct ibv_ah		*ib_ah_handle_t;
 typedef union  ibv_gid		*ib_gid_handle_t;
+typedef struct ibv_srq		*ib_srq_handle_t;
 
 /* HCA context type maps to IB verbs  */
 typedef	struct ibv_context	*ib_hca_handle_t;
diff --git a/dapl/openib_common/dapl_ib_dto.h b/dapl/openib_common/dapl_ib_dto.h
index e9f6cfb..8801db4 100644
--- a/dapl/openib_common/dapl_ib_dto.h
+++ b/dapl/openib_common/dapl_ib_dto.h
@@ -112,6 +112,53 @@ dapls_ib_post_recv (
 }
 
 /*
+ * dapls_ib_post_srq_recv
+ *
+ * Provider specific Post SRQ RECV function
+ */
+STATIC _INLINE_ DAT_RETURN
+dapls_ib_post_srq_recv (
+	IN  DAPL_SRQ		*srq_ptr,
+	IN  DAPL_COOKIE		*cookie,
+	IN  DAT_COUNT		segments,
+	IN  DAT_LMR_TRIPLET	*local_iov )
+{
+	struct ibv_recv_wr wr;
+	struct ibv_recv_wr *bad_wr;
+	ib_data_segment_t *ds = (ib_data_segment_t *)local_iov;
+	DAT_COUNT i, total_len;
+	int ret;
+
+	dapl_dbg_log(DAPL_DBG_TYPE_SRQ,
+		     " post_srq_rcv: srq %p cookie %p segs %d l_iov %p\n",
+		     srq_ptr, cookie, segments, local_iov);
+
+	/* setup work request */
+	total_len = 0;
+	wr.next = 0;
+	wr.num_sge = segments;
+	wr.wr_id = (uint64_t)(uintptr_t)cookie;
+	wr.sg_list = ds;
+
+	if (cookie != NULL) {
+		for (i = 0; i < segments; i++) {
+			dapl_dbg_log(DAPL_DBG_TYPE_SRQ,
+				     " post_srq_rcv: l_key 0x%x va %p len %d\n",
+				     ds->lkey, ds->addr, ds->length );
+			total_len += ds->length;
+			ds++;
+		}
+		cookie->val.dto.size = total_len;
+	}
+
+	ret = ibv_post_srq_recv(srq_ptr->srq_handle, &wr, &bad_wr);
+	if (ret)
+		return(dapl_convert_errno(errno,"ibv_recv"));
+
+	return DAT_SUCCESS;
+}
+
+/*
  * dapls_ib_post_send
  *
  * Provider specific Post SEND function
@@ -504,6 +551,7 @@ STATIC _INLINE_ int dapls_cqe_opcode(ib_work_completion_t *cqe_p)
 
 #define DAPL_GET_CQE_OPTYPE(cqe_p) dapls_cqe_opcode(cqe_p)
 #define DAPL_GET_CQE_WRID(cqe_p) ((ib_work_completion_t*)cqe_p)->wr_id
+#define DAPL_GET_CQE_QP_NUM(cqe_p) ((ib_work_completion_t*)cqe_p)->qp_num
 #define DAPL_GET_CQE_STATUS(cqe_p) ((ib_work_completion_t*)cqe_p)->status
 #define DAPL_GET_CQE_VENDOR_ERR(cqe_p) ((ib_work_completion_t*)cqe_p)->vendor_err
 #define DAPL_GET_CQE_BYTESNUM(cqe_p) ((ib_work_completion_t*)cqe_p)->byte_len
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 24a2790..16dd5f0 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -61,8 +61,10 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 {
 	DAT_EP_ATTR *attr;
 	DAPL_EVD *rcv_evd, *req_evd;
+	DAPL_SRQ *dapl_srq = (DAPL_SRQ *)ep_ptr->param.srq_handle;
 	ib_cq_handle_t rcv_cq, req_cq;
 	ib_pd_handle_t ib_pd_handle;
+	ib_srq_handle_t ib_srq_handle = NULL;
 	int ret = EINVAL;
 	int max_inline = ia_ptr->hca_ptr->ib_trans.max_inline_send;
 	struct ibv_qp_init_attr qp_create;
@@ -72,6 +74,8 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 
 	attr = &ep_ptr->param.ep_attr;
 	ib_pd_handle = ((DAPL_PZ *) ep_ptr->param.pz_handle)->pd_handle;
+	if (dapl_srq)
+		ib_srq_handle = dapl_srq->srq_handle;
 	rcv_evd = (DAPL_EVD *) ep_ptr->param.recv_evd_handle;
 	req_evd = (DAPL_EVD *) ep_ptr->param.request_evd_handle;
 
@@ -167,6 +171,7 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 	qp_create.cap.max_inline_data = max_inline;
 	qp_create.qp_type = IBV_QPT_RC;
 	qp_create.qp_context = (void *)ep_ptr;
+	qp_create.srq = ib_srq_handle;
 
 #ifdef DAT_EXTENSIONS 
 	if ((int)attr->service_type == (int)DAT_IB_SERVICE_TYPE_UD) {
diff --git a/dapl/openib_common/srq.c b/dapl/openib_common/srq.c
new file mode 100644
index 0000000..3b6a38b
--- /dev/null
+++ b/dapl/openib_common/srq.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (c) 2009-2014 Intel Corporation.  All rights reserved.
+ *
+ * This Software is licensed under one of the following licenses:
+ *
+ * 1) under the terms of the "Common Public License 1.0" a copy of which is
+ *    available from the Open Source Initiative, see
+ *    http://www.opensource.org/licenses/cpl.php.
+ *
+ * 2) under the terms of the "The BSD License" a copy of which is
+ *    available from the Open Source Initiative, see
+ *    http://www.opensource.org/licenses/bsd-license.php.
+ *
+ * 3) under the terms of the "GNU General Public License (GPL) Version 2" a
+ *    copy of which is available from the Open Source Initiative, see
+ *    http://www.opensource.org/licenses/gpl-license.php.
+ *
+ * Licensee has the right to choose one of the above licenses.
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice and one of the license notices.
+ *
+ * Redistributions in binary form must reproduce both the above copyright
+ * notice, one of the license notices in the documentation
+ * and/or other materials provided with the distribution.
+ */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
+
+#include "dapl.h"
+#include "dapl_adapter_util.h"
+#include "dapl_ep_util.h"
+
+/*
+ * dapl_ib_srq_alloc
+ *
+ * Alloc a SRQ
+ *
+ * Input:
+ *	ia_handle	SRQ handle
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	DAT_SUCCESS
+ *	DAT_INSUFFICIENT_RESOURCES
+ *
+ */
+DAT_RETURN
+dapls_ib_srq_alloc(IN DAPL_SRQ *srq_ptr)
+{
+	struct ibv_srq_init_attr srq_init_attr;
+	ib_pd_handle_t ib_pd_handle;
+
+	dapl_dbg_log(DAPL_DBG_TYPE_SRQ,
+		     " srq alloc: srq %p\n", srq_ptr);
+
+	ib_pd_handle = ((DAPL_PZ *) srq_ptr->param.pz_handle)->pd_handle;
+	srq_init_attr.srq_context = NULL;
+	srq_init_attr.attr.max_wr = srq_ptr->param.max_recv_dtos;
+	srq_init_attr.attr.max_sge = srq_ptr->param.max_recv_iov;
+	srq_init_attr.attr.srq_limit = 0;
+
+	srq_ptr->srq_handle = ibv_create_srq(ib_pd_handle, &srq_init_attr);
+	if (!srq_ptr->srq_handle)
+		goto err;
+
+	return DAT_SUCCESS;
+
+err:
+	dapl_log(DAPL_DBG_TYPE_ERR, "ib_srq_alloc ERR %s\n", strerror(errno));
+
+	return dapl_convert_errno(ENOMEM, "srq_allocate" );
+}
+
+/*
+ * dapl_ib_srq_free
+ *
+ * Free a SRQ
+ *
+ * Input:
+ *	ia_handle	SRQ handle
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	DAT_SUCCESS
+ * 	DAT_INVALID_PARAMETER
+ * 	dapl_convert_errno
+ */
+DAT_RETURN
+dapls_ib_srq_free(IN DAPL_SRQ *srq_ptr)
+{
+
+	dapl_dbg_log(DAPL_DBG_TYPE_SRQ, " srq free: srq %p\n", srq_ptr);
+
+	if (srq_ptr->srq_handle == IB_INVALID_HANDLE)
+		return DAT_INVALID_PARAMETER;
+
+	if (ibv_destroy_srq(srq_ptr->srq_handle)) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			" srq_free: ibv_destroy_srq error - %s\n",
+			strerror(errno));
+		return (dapl_convert_errno(errno, "srq_free"));
+	}
+
+	return DAT_SUCCESS;
+}
+
+/*
+ * dapl_ib_srq_resize
+ *
+ *Resize a SRQ
+ *
+ * Input:
+ *	SRQ handle
+ *	New size
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	DAT_SUCCESS
+ *	DAT_INSUFFICIENT_RESOURCES
+ *
+ */
+DAT_RETURN
+dapls_ib_srq_resize(IN DAPL_SRQ *srq_ptr, IN uint32_t new_max_wr)
+{
+	struct ibv_srq_attr srq_attr;
+
+	dapl_dbg_log(DAPL_DBG_TYPE_SRQ, " srq resize: srq %p\n", srq_ptr);
+
+	srq_attr.max_wr = new_max_wr;
+
+	if (ibv_modify_srq(srq_ptr->srq_handle, &srq_attr, IBV_SRQ_MAX_WR)) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 " srq_resize: ibv_modify_srq error - %s\n",
+			 strerror(errno));
+		return (dapl_convert_errno(errno, "srq_resize"));
+	}
+
+	return DAT_SUCCESS;
+}
diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index b924b64..ad59f8f 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -638,11 +638,16 @@ void dapli_async_event_cb(struct _ib_hca_transport *hca)
 		case IBV_EVENT_SRQ_LIMIT_REACHED:
 		case IBV_EVENT_SQ_DRAINED:
 		{
+			DAPL_DBG_TYPE dbg_type = DAPL_DBG_TYPE_ERR;
 			struct dapl_ep *ep_ptr =
 				event.element.qp->qp_context;
 
-			dapl_log(DAPL_DBG_TYPE_ERR,
-				 "dapl async_event QP (%p) ERR %d\n",
+			if (event.event_type == IBV_EVENT_QP_LAST_WQE_REACHED &&
+			    ep_ptr->param.srq_handle) {
+				dbg_type = DAPL_DBG_TYPE_EVD;
+			}
+
+			dapl_log(dbg_type, "dapl async_event QP (%p) Event %d\n",
 				 ep_ptr, event.event_type);
 
 			/* report up if async callback still setup */
diff --git a/dat/include/dat2/dat.h b/dat/include/dat2/dat.h
index 261c56a..b74b778 100755
--- a/dat/include/dat2/dat.h
+++ b/dat/include/dat2/dat.h
@@ -577,8 +577,9 @@ typedef DAT_UINT64 DAT_EP_PARAM_MASK;
 
 typedef enum dat_srq_state
 {
+    DAT_SRQ_STATE_ERROR,
     DAT_SRQ_STATE_OPERATIONAL,
-    DAT_SRQ_STATE_ERROR
+    DAT_SRQ_STATE_SHUTDOWN
 } DAT_SRQ_STATE;
 
 #define DAT_VALUE_UNKNOWN (((DAT_COUNT) ~0)-1)
diff --git a/dat/include/dat2/dat_error.h b/dat/include/dat2/dat_error.h
index 251e6c4..48e0a0e 100644
--- a/dat/include/dat2/dat_error.h
+++ b/dat/include/dat2/dat_error.h
@@ -319,6 +319,7 @@ typedef enum dat_return_subtype
     DAT_INVALID_STATE_SRQ_OPERATIONAL,
     DAT_INVALID_STATE_SRQ_ERROR,
     DAT_INVALID_STATE_SRQ_IN_USE,
+    DAT_INVALID_STATE_SRQ_SHUTDOWN,
 
         /* DAT_LENGTH_ERROR has no subtypes */
 
diff --git a/test/dtest/Makefile.am b/test/dtest/Makefile.am
index 801d704..b5f7574 100755
--- a/test/dtest/Makefile.am
+++ b/test/dtest/Makefile.am
@@ -1,10 +1,13 @@
-bin_PROGRAMS = dtest dtestcm
+bin_PROGRAMS = dtest dtestcm dtestsrq
 dtest_SOURCES = dtest.c
 dtest_CFLAGS = -g -Wall -D_GNU_SOURCE 
 
 dtestcm_SOURCES = dtestcm.c
 dtestcm_CFLAGS = -g -Wall -D_GNU_SOURCE 
 
+dtestsrq_SOURCES = dtestsrq.c
+dtestsrq_CFLAGS = -g -Wall -D_GNU_SOURCE 
+
 if EXT_TYPE_IB
 bin_PROGRAMS += dtestx
 dtestx_SOURCES = dtestx.c
@@ -15,4 +18,5 @@ endif
 INCLUDES =  -I $(srcdir)/../../dat/include 
 dtest_LDADD = $(top_builddir)/dat/udat/libdat2.la
 dtestcm_LDADD = $(top_builddir)/dat/udat/libdat2.la
+dtestsrq_LDADD = $(top_builddir)/dat/udat/libdat2.la
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
