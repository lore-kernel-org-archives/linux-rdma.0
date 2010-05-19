From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/12] dapl-2.0: ucm: fix issues with new EP to CM linking
 changes
Date: Wed, 19 May 2010 11:11:37 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C701308E@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add EP locking around QP modify
Remove release during disconnect event processing
Add check in cm_free to check state and schedule thread if necessary.
Add some additional debugging
Add processing in disconnect_clean for conn_req timeout
Remove extra CR's

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |  107 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 85c8b4b..8fed8f6 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -392,13 +392,13 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 			cm->msg.op = htons(DCM_DREP);
 			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 
 			
-		}
-		/* UD reply retried ok to ignore, any other print warning */
-		if (ntohs(msg->op) != DCM_REP) {
+		} else if (ntohs(msg->op) != DCM_DREP){
+			/* DREP ok to ignore, any other print warning */
 			dapl_log(DAPL_DBG_TYPE_WARN,
-				" ucm_recv: UNKNOWN operation"
-				" <- op %d, %s spsp %d sqpn %d\n", 
-				ntohs(msg->op), dapl_cm_state_str(cm->state),
+				" ucm_recv: UNEXPECTED MSG on cm %p"
+				" <- op %s, st %s spsp %d sqpn %d\n", 
+				cm, dapl_cm_op_str(ntohs(msg->op)),
+				dapl_cm_state_str(cm->state),
 				ntohs(msg->sport), ntohl(msg->sqpn));
 		}
 		dapl_os_unlock(&cm->lock);
@@ -635,11 +635,11 @@ void dapls_cm_acquire(dp_ib_cm_handle_t cm)
 void dapls_cm_release(dp_ib_cm_handle_t cm)
 {
 	dapl_os_lock(&cm->lock);
-	cm->ref_count--;
-	if (cm->ref_count) {
-                dapl_os_unlock(&cm->lock);
-		return;
-	}
+	cm->ref_count--;
+	if (cm->ref_count) {
+                dapl_os_unlock(&cm->lock);
+		return;
+	}
 	/* client, release local conn id port */
 	if (!cm->sp && cm->msg.sport)
 		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
@@ -652,9 +652,9 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
 	if (cm->ah) {
 		ibv_destroy_ah(cm->ah);
 		cm->ah = NULL;
-	}
-	dapl_os_unlock(&cm->lock);
-	dapli_cm_dealloc(cm);
+	}
+	dapl_os_unlock(&cm->lock);
+	dapli_cm_dealloc(cm);
 }
 
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
@@ -710,6 +710,11 @@ bail:
 /* schedule destruction of CM object */
 void dapli_cm_free(dp_ib_cm_handle_t cm)
 {
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " dapli_cm_free: cm %p %s ep %p refs=%d\n", 
+		 cm, dapl_cm_state_str(cm->state),
+		 cm->ep, cm->ref_count);
+
 	dapl_os_lock(&cm->lock);
 	cm->state = DCM_FREE;
 	dapls_thread_signal(&cm->hca->ib_trans.signal);
@@ -720,15 +725,18 @@ void dapli_cm_free(dp_ib_cm_handle_t cm)
 void dapls_cm_free(dp_ib_cm_handle_t cm)
 {
 	dapl_log(DAPL_DBG_TYPE_CM,
-		 " cm_free: cm %p %s ep %p refs=%d\n", 
+		 " dapl_cm_free: cm %p %s ep %p refs=%d\n", 
 		 cm, dapl_cm_state_str(cm->state),
 		 cm->ep, cm->ref_count);
 	
 	/* free from internal workq, wait until EP is last ref */
 	dapl_os_lock(&cm->lock);
-	cm->state = DCM_FREE;
+	if (cm->state != DCM_FREE) 
+		cm->state = DCM_FREE;
+	
 	while (cm->ref_count != 1) {
 		dapl_os_unlock(&cm->lock);
+		dapls_thread_signal(&cm->hca->ib_trans.signal);
 		dapl_os_sleep_usec(10000);
 		dapl_os_lock(&cm->lock);
 	}
@@ -804,8 +812,6 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 	else
 		dapl_evd_connection_callback(cm, IB_CME_DISCONNECTED, NULL, 0, cm->ep);
 
-	/* free local resources, EP ref will prevent destory until dat_ep_free */
-	dapls_cm_release(cm);
 }
 
 /*
@@ -815,6 +821,7 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 {
 	int finalize = 1;
+	int wakeup = 0;
 
 	dapl_os_lock(&cm->lock);
 	switch (cm->state) {
@@ -826,8 +833,8 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		/* send DREQ, event after DREP or DREQ timeout */
 		cm->state = DCM_DISC_PENDING;
 		cm->msg.op = htons(DCM_DREQ);
-		finalize = 0; /* wait for DREP, wakeup timer thread */
-		dapls_thread_signal(&cm->hca->ib_trans.signal);
+		finalize = 0; /* wait for DREP, wakeup timer after DREQ sent */
+		wakeup = 1;
 		break;
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
@@ -850,10 +857,29 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		if (cm->ep->qp_handle->qp_type != IBV_QPT_UD) 
 			dapls_modify_qp_state(cm->ep->qp_handle, IBV_QPS_ERR,0,0,0);
 
-		/* DREQ received, send DREP and schedule event */
+		/* DREQ received, send DREP and schedule event, finalize */
 		cm->msg.op = htons(DCM_DREP);
 		break;
+	case DCM_DISCONNECTED:
+		dapl_os_unlock(&cm->lock);
+		return DAT_SUCCESS;
 	default:
+		dapl_log(DAPL_DBG_TYPE_WARN, 
+			"  disconnect UNKNOWN state: ep %p cm %p %s %s"
+			"  %x %x %x %s %x %x %x r_pid %x,%d\n",
+			cm->ep, cm,
+			cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
+			dapl_cm_state_str(cm->state),
+			ntohs(cm->msg.saddr.ib.lid),
+			ntohs(cm->msg.sport),
+			ntohl(cm->msg.saddr.ib.qpn),	
+			cm->sp ? "<-" : "->",
+			ntohs(cm->msg.daddr.ib.lid),
+			ntohs(cm->msg.dport),
+			ntohl(cm->msg.daddr.ib.qpn),
+			ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv), 
+			ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv)); 
+
 		dapl_os_unlock(&cm->lock);
 		return DAT_SUCCESS;
 	}
@@ -861,6 +887,9 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 	dapl_os_get_time(&cm->timer); /* reply expected */
 	ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 
 	dapl_os_unlock(&cm->lock);
+	
+	if (wakeup)
+		dapls_thread_signal(&cm->hca->ib_trans.signal);
 
 	if (finalize) 
 		ucm_disconnect_final(cm);
@@ -1302,6 +1331,9 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 {
 	dapl_os_lock(&cm->lock);
 	if (cm->state != DCM_RTU_PENDING) {
+		dapl_log(DAPL_DBG_TYPE_ERR, 
+			 " CM_REPLY: wrong state %s",
+			 dapl_cm_state_str(cm->state));
 		dapl_os_unlock(&cm->lock);
 		return -1;
 	}
@@ -1375,6 +1407,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		dapl_os_unlock(&cm->lock);
 		return DAT_INVALID_STATE;
 	}
+	dapl_os_unlock(&cm->lock);
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT_USR: remote lid=%x"
@@ -1401,6 +1434,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 #endif
 
 	/* modify QP to RTR and then to RTS with remote info already read */
+	dapl_os_lock(&ep->header.lock);
 	if (dapls_modify_qp_state(ep->qp_handle,
 				  IBV_QPS_RTR, 
 				  cm->msg.daddr.ib.qpn,
@@ -1410,7 +1444,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 			 " ACCEPT_USR: QPS_RTR ERR %s -> lid %x qpn %x\n",
 			 strerror(errno), ntohs(cm->msg.daddr.ib.lid),
 			 ntohl(cm->msg.daddr.ib.qpn));
-		dapl_os_unlock(&cm->lock);
+		dapl_os_unlock(&ep->header.lock);
 		goto bail;
 	}
 	if (dapls_modify_qp_state(ep->qp_handle,
@@ -1422,9 +1456,10 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 			 " ACCEPT_USR: QPS_RTS ERR %s -> lid %x qpn %x\n",
 			 strerror(errno), ntohs(cm->msg.daddr.ib.lid),
 			 ntohl(cm->msg.daddr.ib.qpn));
-		dapl_os_unlock(&cm->lock);
+		dapl_os_unlock(&ep->header.lock);
 		goto bail;
 	}
+	dapl_os_unlock(&ep->header.lock);
 
 	/* save remote address information */
 	dapl_os_memcpy(&ep->remote_ia_address,
@@ -1449,8 +1484,9 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_ep_link_cm(ep, cm);
 	cm->ep = ep;
 	cm->hca = ia->hca_ptr;
+	
+	dapl_os_lock(&cm->lock);
 	cm->state = DCM_RTU_PENDING;
-	dapl_os_get_time(&cm->timer); /* RTU expected */
 	dapl_os_unlock(&cm->lock);
 
 	if (ucm_reply(cm)) {
@@ -1540,14 +1576,15 @@ dapls_ib_disconnect(IN DAPL_EP *ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
 	dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);
 
+	dapl_os_lock(&ep_ptr->header.lock);
 	if (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED ||
-		ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC) {
+	    ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC ||
+	    cm_ptr == NULL) {
+		dapl_os_unlock(&ep_ptr->header.lock);
 		return DAT_SUCCESS;
 	} 
+	dapl_os_unlock(&ep_ptr->header.lock);
 	
-	/* RC. Transition to error state to flush queue */
-        dapls_modify_qp_state(ep_ptr->qp_handle, IBV_QPS_ERR, 0, 0, 0);
-
 	return (dapli_cm_disconnect(cm_ptr));
 }
 
@@ -1575,7 +1612,19 @@ dapls_ib_disconnect_clean(IN DAPL_EP *ep,
 			  IN DAT_BOOLEAN active,
 			  IN const ib_cm_events_t ib_cm_event)
 {
-	/* nothing to cleanup */
+	if (ib_cm_event == IB_CME_TIMEOUT) {
+		dp_ib_cm_handle_t cm_ptr;
+
+		if ((cm_ptr = dapl_get_cm_from_ep(ep)) == NULL)
+			return;
+
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			"dapls_ib_disc_clean: CONN_TIMEOUT ep %p cm %p %s\n",
+			ep, cm_ptr, dapl_cm_state_str(cm_ptr->state));
+		
+		/* schedule release of socket and local resources */
+		dapli_cm_free(cm_ptr);
+	}
 }
 
 /*
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
