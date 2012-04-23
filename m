From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/15] uDAPL v2.0 ucm: update UD cm provider to support new
 CM stat and error counters
Date: Mon, 23 Apr 2012 20:01:09 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481202A0@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 6b5867a..357dbf7 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -173,6 +173,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 (time - cm->timer)/1000,
 				 cm->hca->ib_trans.rep_time << cm->retries);
 			cm->retries++;
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_REQ_RETRY);
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_connect(cm->ep, cm);
 			return;
@@ -195,6 +196,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 (time - cm->timer)/1000, 
 				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_REP_RETRY);
 			dapl_os_unlock(&cm->lock);
 			ucm_reply(cm);
 			return;
@@ -217,6 +219,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 (time - cm->timer)/1000, 
 				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_DREQ_RETRY);
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
                         return;
@@ -273,6 +276,8 @@ retry:
 		polled++;
 		goto retry;
 	}
+	DAPL_CNTR_DATA(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_ERR_REQ_FULLQ, polled > 1 ? 1:0);
+	DAPL_CNTR_DATA(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_REQ_FULLQ_POLL, polled - 1);
 	return msg;
 }
 
@@ -322,6 +327,7 @@ static int ucm_reject(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 		     ntohs(smsg.daddr.ib.lid),
 		     ntohl(smsg.dqpn), ntohs(smsg.dport));
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_ERR_REJ_TX);
 	return (ucm_send(tp, &smsg, NULL, 0));
 }
 
@@ -366,7 +372,9 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 				 ntohl(cm->msg.d_id));
 
 			cm->msg.op = htons(DCM_RTU);
-			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 		
+			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
+
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_RTU_RETRY);
 		}
 		dapl_os_unlock(&cm->lock);
 		break;
@@ -393,6 +401,8 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 			cm->msg.op = htons(DCM_DREP);
 			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 
 			
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_DREP_RETRY);
+
 		} else if (ntohs(msg->op) != DCM_DREP){
 			/* DREP ok to ignore, any other print warning */
 			dapl_log(DAPL_DBG_TYPE_WARN,
@@ -401,6 +411,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 				cm, dapl_cm_op_str(ntohs(msg->op)),
 				dapl_cm_state_str(cm->state),
 				ntohs(msg->sport), ntohl(msg->sqpn));
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_UNEXPECTED);
 		}
 		dapl_os_unlock(&cm->lock);
 		break;
@@ -478,6 +489,8 @@ retry_listenq:
 					 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
 					 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn));
 
+					DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_REQ_DUP);
+
 					return NULL;
 			}
 		}
@@ -517,6 +530,10 @@ retry_listenq:
 			 ntohs(msg->sport), ntohl(msg->sqpn),
 			 ntohl(msg->saddr.ib.qpn), ntohl(msg->s_id),
 			 ntohl(msg->d_id));
+
+		if (ntohs(msg->op) == DCM_DREP) {
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_DREP_DUP);
+		}
 	}
 
 	return found;
@@ -878,6 +895,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		cm->msg.op = htons(DCM_DREQ);
 		finalize = 0; /* wait for DREP, wakeup timer after DREQ sent */
 		wakeup = 1;
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_DREQ_TX);
 		break;
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
@@ -894,6 +912,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 				htons(cm->msg.dport));
 			finalize = 1;
 		}
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_DREQ_RETRY);
 		break;
 	case DCM_DISC_RECV:
 		/* CM_THREAD: move to err state to flush, if not UD */
@@ -902,6 +921,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 
 		/* DREQ received, send DREP and schedule event, finalize */
 		cm->msg.op = htons(DCM_DREP);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_DREP_TX);
 		break;
 	case DCM_DISCONNECTED:
 		dapl_os_unlock(&cm->lock);
@@ -999,10 +1019,13 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		goto bail;
 	}
 	dapl_os_unlock(&cm->lock);
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+		  ep->qp_handle->qp_type == IBV_QPT_UD ? DCNT_IA_CM_AH_REQ_TX : DCNT_IA_CM_REQ_TX);
 
 	return DAT_SUCCESS;
 
 bail:
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR);
 	dapl_log(DAPL_DBG_TYPE_WARN, 
 		 " connect: snd ERR -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
 		 htons(cm->msg.daddr.ib.lid),
@@ -1080,7 +1103,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			 ntohs(msg->daddr.ib.lid), ntohl(msg->daddr.ib.qpn),
 			 ntohs(msg->dport), ntohs(msg->saddr.ib.lid),
 			 ntohl(msg->saddr.ib.qpn), ntohs(msg->sport));
-
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_REJ_RX);
 		event = IB_CME_DESTINATION_REJECT;
 	}
 	if (event != IB_CME_CONNECTED) {
@@ -1152,6 +1175,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		goto bail;
 	}
 	dapl_os_unlock(&cm->lock);
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_RTU_TX);
 
 	/* init cm_handle and post the event with private data */
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " ACTIVE: connected!\n");
@@ -1221,9 +1245,13 @@ ud_bail:
 
 		if (event != DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED)
 			dapli_cm_free(cm);
+
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_AH_RESOLVED);
+
 	} else
 #endif
 	{
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ACTIVE_EST);
 		dapl_evd_connection_callback(cm,
 					     IB_CME_CONNECTED,
 					     cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
@@ -1305,6 +1333,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 					    (DAT_COUNT)ntohs(acm->msg.p_size),
 					    (DAT_PVOID *)acm->msg.p_data,
 					    (DAT_PVOID *)&xevent);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_AH_REQ_TX);
 	} else
 #endif
 		/* trigger CR event and return SUCCESS */
@@ -1315,6 +1344,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 
 bail:
 	/* schedule work thread cleanup */
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR);
 	dapli_cm_free(acm);
 	return;
 }
@@ -1394,9 +1424,12 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
+
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_AH_RESOLVED);
 		dapli_cm_free(cm); /* still attached to EP */
 	} else {
 #endif
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_PASSIVE_EST);
 		dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
 	}
 	dapl_log(DAPL_DBG_TYPE_CM_EST,
@@ -1407,6 +1440,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		 ntohl(cm->msg.dqpn));
 	return;
 bail:
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR);
 	dapls_cr_callback(cm, IB_CME_LOCAL_FAILURE, NULL, 0, cm->sp);
 	dapli_cm_free(cm);
 }
@@ -1617,10 +1651,12 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	}
 	dapl_os_unlock(&cm->lock);
 
+	DAPL_CNTR(ia, DCNT_IA_CM_REP_TX);
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
 	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	return DAT_SUCCESS;
 bail:
+	DAPL_CNTR(ia, DCNT_IA_CM_ERR);
 	dapli_cm_free(cm);
 	return DAT_INTERNAL_ERROR;
 }
@@ -1829,6 +1865,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA *ia,
 	/* queue up listen socket to process inbound CR's */
 	cm->state = DCM_LISTEN;
 	dapli_queue_listen(cm);
+	DAPL_CNTR(ia, DCNT_IA_CM_LISTEN);
 
 	return DAT_SUCCESS;
 }
@@ -1966,6 +2003,10 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
 	else
 		cm->msg.op = htons(DCM_REJ_CM);
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+		  reason == IB_CM_REJ_REASON_CONSUMER_REJ ?
+		  DCNT_IA_CM_USER_REJ_TX : DCNT_IA_CM_ERR_REJ_TX);
+
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, pdata, psize)) {
 		dapl_log(DAPL_DBG_TYPE_WARN,
 			 " cm_reject: send ERR: %s\n", strerror(errno));
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
