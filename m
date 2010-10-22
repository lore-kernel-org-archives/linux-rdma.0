From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: common: dat_evd_dequeue (poll_cq) fails  with
 invalid parameter after EP (qp) free
Date: Fri, 22 Oct 2010 13:15:26 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA209E6@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The QP's need to be flushed and processed via EVD's during
the EP (QP) destroy to avoid an error on poll_cq. IBAL
provider was not moving to ERR state during QP destroy.

Better flush CQ processing was added and pushed down to the provider
level via dapls_ib_qp_free() where it can move QP to ERR, flush CQ,
and then free QP after flushing. Because there is no QP_ERR_FLUSH
state on a QP the spin on poll_cq (until empty) after modify_qp
to ERR could return empty and before all WQE's are flushed. This
could result in a CQE being added to CQ with a invalid QP reference.
So, an additional check was added to flush_evds for the recv_q to
poll_cq until all recv's pending are complete. For transmit_q there
is no quarantee that the posted work is signaled and so the best
that can be done is poll_cq until empty.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_free.c |   25 ++++++++++++++-----------
 dapl/common/dapl_ep_util.c |    6 ++----
 dapl/ibal/dapl_ibal_qp.c   |   14 +++++++++++---
 dapl/openib_common/qp.c    |   32 ++++++++++++++++++++------------
 4 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index 32d50cc..a8deeb2 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -157,16 +157,6 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 				   pz_ref_count);
 		param->pz_handle = NULL;
 	}
-	if (param->recv_evd_handle != NULL) {
-		dapl_os_atomic_dec(&((DAPL_EVD *) param->recv_evd_handle)->
-				   evd_ref_count);
-		param->recv_evd_handle = NULL;
-	}
-	if (param->request_evd_handle != NULL) {
-		dapl_os_atomic_dec(&((DAPL_EVD *) param->request_evd_handle)->
-				   evd_ref_count);
-		param->request_evd_handle = NULL;
-	}
 	if (param->connect_evd_handle != NULL) {
 		dapl_os_atomic_dec(&((DAPL_EVD *) param->connect_evd_handle)->
 				   evd_ref_count);
@@ -202,7 +192,20 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 		}
 	}
 
-	dapls_ep_flush_cqs(ep_ptr);
+	/*
+	 * Release the EVD handles after we destroy the QP, so we can flush all
+	 * QP entries.
+	 */
+	if (param->recv_evd_handle != NULL) {
+		dapl_os_atomic_dec(&((DAPL_EVD *) param->recv_evd_handle)->
+				   evd_ref_count);
+		param->recv_evd_handle = NULL;
+	}
+	if (param->request_evd_handle != NULL) {
+		dapl_os_atomic_dec(&((DAPL_EVD *) param->request_evd_handle)->
+				   evd_ref_count);
+		param->request_evd_handle = NULL;
+	}
 
 	/* Free the resource */
 	dapl_ep_dealloc(ep_ptr);
diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index fc911a6..6646528 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -620,10 +620,8 @@ static void dapli_ep_flush_evd(DAPL_EVD *evd_ptr)
 
 void dapls_ep_flush_cqs(DAPL_EP * ep_ptr)
 {
-	if (ep_ptr->param.request_evd_handle)
-		dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
-
-	if (ep_ptr->param.recv_evd_handle)
+	dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
+	while (dapls_cb_pending(&ep_ptr->recv_buffer))
 		dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.recv_evd_handle);
 }
 
diff --git a/dapl/ibal/dapl_ibal_qp.c b/dapl/ibal/dapl_ibal_qp.c
index e843829..4ea57d7 100644
--- a/dapl/ibal/dapl_ibal_qp.c
+++ b/dapl/ibal/dapl_ibal_qp.c
@@ -317,6 +317,7 @@ dapls_ib_qp_free (
         IN  DAPL_IA                *ia_ptr,
         IN  DAPL_EP                *ep_ptr )
 {
+	ib_qp_handle_t qp;
 
 	UNREFERENCED_PARAMETER(ia_ptr);
 
@@ -327,12 +328,19 @@ dapls_ib_qp_free (
 	dapl_os_lock(&ep_ptr->header.lock);
 	if (( ep_ptr->qp_handle != IB_INVALID_HANDLE ))
 	{
-		ib_destroy_qp ( ep_ptr->qp_handle, ib_sync_destroy );
+		qp  = ep_ptr->qp_handle;
+		ep_ptr->qp_handle = IB_INVALID_HANDLE;
+		dapl_os_unlock(&ep_ptr->header.lock);
+
+		dapls_modify_qp_state_to_error(qp);
+		dapls_ep_flush_cqs(ep_ptr);
+
+		ib_destroy_qp ( qp, ib_sync_destroy );
 		dapl_dbg_log (DAPL_DBG_TYPE_EP, "--> DsQF: freed QP %p\n",
 				ep_ptr->qp_handle ); 
-		ep_ptr->qp_handle = IB_INVALID_HANDLE;
+	} else {
+		dapl_os_unlock(&ep_ptr->header.lock);
 	}
-	dapl_os_unlock(&ep_ptr->header.lock);
 
     return DAT_SUCCESS;
 }
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 5c5c10f..8db6f8e 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -215,30 +215,38 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
  */
 DAT_RETURN dapls_ib_qp_free(IN DAPL_IA * ia_ptr, IN DAPL_EP * ep_ptr)
 {
+	struct ibv_qp *qp;
+	struct ibv_qp_attr qp_attr;
+
 #ifdef _OPENIB_CMA_
 	dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+	if (!cm_ptr)
+		return DAT_SUCCESS;
+#endif
 
 	dapl_os_lock(&ep_ptr->header.lock);
-	if (cm_ptr && cm_ptr->cm_id->qp) {
+	if (ep_ptr->qp_handle != NULL) {
+		qp = ep_ptr->qp_handle;
+		dapl_os_unlock(&ep_ptr->header.lock);
+
+		qp_attr.qp_state = IBV_QPS_ERR;
+		ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE);
+		dapls_ep_flush_cqs(ep_ptr);
+
+		ep_ptr->qp_handle = NULL;
+#ifdef _OPENIB_CMA_
 		rdma_destroy_qp(cm_ptr->cm_id);
 		cm_ptr->cm_id->qp = NULL;
-		ep_ptr->qp_handle = NULL;
-	}
 #else
-	dapl_os_lock(&ep_ptr->header.lock);
-	if (ep_ptr->qp_handle != NULL) {
-		/* force error state to flush queue, then destroy */
-		dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0,0,0);
-
-		if (ibv_destroy_qp(ep_ptr->qp_handle)) {
+		if (ibv_destroy_qp(qp)) {
 			dapl_log(DAPL_DBG_TYPE_ERR, 
 				 " qp_free: ibv_destroy_qp error - %s\n",
 				 strerror(errno));
 		}
-		ep_ptr->qp_handle = NULL;
-	}
 #endif
-	dapl_os_unlock(&ep_ptr->header.lock);
+	} else {
+		dapl_os_unlock(&ep_ptr->header.lock);
+	}
 	return DAT_SUCCESS;
 }
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
