From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/15] uDAPL v2.0 cma, scm, ucm: allow EP (QP) creation
 without EVD (CQ)
Date: Mon, 23 Apr 2012 20:00:55 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120257@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide ability to create a EP/QP with no EVD/CQ on either the
request or receive queue. The current implementation allows on
receive queue but not request queue. Not all ofa devices support
a null CQ so if necessary create a dummy CQ at the time of
QP creation. Also, if no CQ is specified set appropriate QP
max wr/sge attributes to zero.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 94bb1ed..16ce594 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -79,29 +79,30 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 	 * Create a CQ with zero entries under the covers to support and 
 	 * catch any invalid posting. 
 	 */
-	if (rcv_evd != DAT_HANDLE_NULL)
-		rcv_cq = rcv_evd->ib_cq_handle;
-	else if (!ia_ptr->hca_ptr->ib_trans.ib_cq_empty)
-		rcv_cq = ia_ptr->hca_ptr->ib_trans.ib_cq_empty;
-	else {
+	if ((!rcv_evd || !req_evd) && !ia_ptr->hca_ptr->ib_trans.ib_cq_empty) {
 		struct ibv_comp_channel *channel;
 
 		channel = ibv_create_comp_channel(ia_ptr->hca_ptr->ib_hca_handle);
 		if (!channel)
-			return (dapl_convert_errno(ENOMEM, "create_cq"));
+			return (dapl_convert_errno(ENOMEM, "create_cq_chan"));
 		  
 		/* Call IB verbs to create CQ */
 		rcv_cq = ibv_create_cq(ia_ptr->hca_ptr->ib_hca_handle,
-				       0, NULL, channel, 0);
+				       1, NULL, channel, 0);
 
 		if (rcv_cq == IB_INVALID_HANDLE) {
 			ibv_destroy_comp_channel(channel);
 			return (dapl_convert_errno(ENOMEM, "create_cq"));
 		}
-
 		ia_ptr->hca_ptr->ib_trans.ib_cq_empty = rcv_cq;
 	}
-	if (req_evd != DAT_HANDLE_NULL)
+
+	if (rcv_evd)
+		rcv_cq = rcv_evd->ib_cq_handle;
+	else
+		rcv_cq = ia_ptr->hca_ptr->ib_trans.ib_cq_empty;
+
+	if (req_evd)
 		req_cq = req_evd->ib_cq_handle;
 	else
 		req_cq = ia_ptr->hca_ptr->ib_trans.ib_cq_empty;
@@ -133,9 +134,12 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 #endif
 	/* Setup attributes and create qp */
 	dapl_os_memzero((void *)&qp_create, sizeof(qp_create));
+	qp_create.recv_cq = rcv_cq;
+	qp_create.cap.max_recv_wr = rcv_evd ? attr->max_recv_dtos:0;
+	qp_create.cap.max_recv_sge = rcv_evd ? attr->max_recv_iov:0;
 	qp_create.send_cq = req_cq;
-	qp_create.cap.max_send_wr = attr->max_request_dtos;
-	qp_create.cap.max_send_sge = attr->max_request_iov;
+	qp_create.cap.max_send_wr = req_evd ? attr->max_request_dtos:0;
+	qp_create.cap.max_send_sge = req_evd ? attr->max_request_iov:0;
 	qp_create.cap.max_inline_data =
 	    ia_ptr->hca_ptr->ib_trans.max_inline_send;
 	qp_create.qp_type = IBV_QPT_RC;
@@ -153,17 +157,6 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 		}
 	}
 #endif
-	
-	/* ibv assumes rcv_cq is never NULL, set to req_cq */
-	if (rcv_cq == NULL) {
-		qp_create.recv_cq = req_cq;
-		qp_create.cap.max_recv_wr = 0;
-		qp_create.cap.max_recv_sge = 0;
-	} else {
-		qp_create.recv_cq = rcv_cq;
-		qp_create.cap.max_recv_wr = attr->max_recv_dtos;
-		qp_create.cap.max_recv_sge = attr->max_recv_iov;
-	}
 
 #ifdef _OPENIB_CMA_
 	if (rdma_create_qp(conn->cm_id, ib_pd_handle, &qp_create)) {
@@ -178,7 +171,7 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 	ep_ptr->qp_handle = ibv_create_qp(ib_pd_handle, &qp_create);
 	if (!ep_ptr->qp_handle)
 		return (dapl_convert_errno(ENOMEM, "create_qp"));
-		
+
 	/* Setup QP attributes for INIT state on the way out */
 	if (dapls_modify_qp_state(ep_ptr->qp_handle,
 				  IBV_QPS_INIT, 0, 0, 0) != DAT_SUCCESS) {
@@ -188,7 +181,7 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 	}
 #endif
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " qp_alloc: qpn %p type %d sq %d,%d rq %d,%d\n",
+		     " qp_alloc: qpn 0x%x type %d sq %d,%d rq %d,%d\n",
 		     ep_ptr->qp_handle->qp_num, ep_ptr->qp_handle->qp_type,
 		     qp_create.cap.max_send_wr, qp_create.cap.max_send_sge,
 		     qp_create.cap.max_recv_wr, qp_create.cap.max_recv_sge);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
