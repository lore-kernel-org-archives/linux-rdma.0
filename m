From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] uDAPL v2: ucm: increase timers during subsequent
 retries, add create_ah error checking
Date: Wed, 28 Oct 2009 16:19:08 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835F08B517@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


- increase timers during subsequent retries,
- check/process create_ah errors during connect phase,
- cleanup some debug messaging.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   81 ++++++++++++++++++++++++++-----------------------
 1 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 96ee382..07b8458 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -163,17 +163,16 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		*timer = cm->hca->ib_trans.cm_timer; 
 		/* wait longer each retry */
 		if ((time - cm->timer)/1000 > 
-		    (cm->hca->ib_trans.rep_time * cm->retries)) {
+		    (cm->hca->ib_trans.rep_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_REQ retry %d [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x \n", 
-				 cm->retries,
-				 ntohs(cm->msg.saddr.ib.lid), 
-				 ntohs(cm->msg.sport),
-				 ntohl(cm->msg.saddr.ib.qpn), 
-				 ntohs(cm->msg.daddr.ib.lid), 
-				 ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn));
+				 " %x %x %x -> %x %x %x Time(ms) %llu > %llu\n", 
+				 cm->retries, ntohs(cm->msg.saddr.ib.lid), 
+				 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn), 
+				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.dqpn), (time - cm->timer)/1000, 
+				 cm->hca->ib_trans.rep_time << cm->retries);
+			cm->retries++;
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_connect(cm->ep, cm);
 			return;
@@ -182,10 +181,10 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 	case DCM_RTU_PENDING: 
 		*timer = cm->hca->ib_trans.cm_timer;  
 		if ((time - cm->timer)/1000 > 
-		    (cm->hca->ib_trans.rtu_time * cm->retries)) {
+		    (cm->hca->ib_trans.rtu_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_REPLY retry %d [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x r_pid %x,%d\n", 
+				 " %x %x %x -> %x %x %x r_pid %x,%d Time(ms) %llu > %llu\n", 
 				 cm->retries,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
@@ -194,7 +193,9 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 ntohs(cm->msg.dport),
 				 ntohl(cm->msg.daddr.ib.qpn),  
 				 ntohl(*(DAT_UINT32*)cm->msg.resv),
-				 ntohl(*(DAT_UINT32*)cm->msg.resv)); 
+				 ntohl(*(DAT_UINT32*)cm->msg.resv), 
+				 (time - cm->timer)/1000, cm->hca->ib_trans.rtu_time << cm->retries);
+			cm->retries++;
 			dapl_os_unlock(&cm->lock);
 			ucm_reply(cm);
 			return;
@@ -204,10 +205,10 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		*timer = cm->hca->ib_trans.cm_timer; 
 		/* wait longer each retry */
 		if ((time - cm->timer)/1000 > 
-		    (cm->hca->ib_trans.rep_time)) {
+		    (cm->hca->ib_trans.rtu_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_DREQ retry %d [lid, port, qpn]:"
-				 " %x %x %x -> %x %x %x r_pid %x,%d\n", 
+				 " %x %x %x -> %x %x %x r_pid %x,%d Time(ms) %llu > %llu\n", 
 				 cm->retries,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
@@ -216,7 +217,9 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 				 ntohs(cm->msg.dport),
 				 ntohl(cm->msg.dqpn), 
 				 ntohl(*(DAT_UINT32*)cm->msg.resv),
-				 ntohl(*(DAT_UINT32*)cm->msg.resv)); 
+				 ntohl(*(DAT_UINT32*)cm->msg.resv), 
+				 (time - cm->timer)/1000, cm->hca->ib_trans.rtu_time << cm->retries);
+			cm->retries++;
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
                         return;
@@ -448,8 +451,8 @@ retry_listenq:
 			} else {
 				/* duplicate; bail and throw away */
 				dapl_os_unlock(lock);
-				dapl_log(DAPL_DBG_TYPE_CM,
-					 " duplicate: op %s st %s [lid, port, qpn]:"
+				dapl_log(DAPL_DBG_TYPE_WARN,
+					 " DUPLICATE: op %s st %s [lid, port, qpn]:"
 					 " 0x%x %d 0x%x <- 0x%x %d 0x%x\n", 
 					 dapl_cm_op_str(ntohs(msg->op)), 
 					 dapl_cm_state_str(cm->state),
@@ -476,7 +479,18 @@ retry_listenq:
 	/* not match on listenq for valid request, send reject */
 	if (ntohs(msg->op) == DCM_REQ && !found)
 		ucm_reject(tp, msg);
-
+#if DAPL_DBG
+	if (!found) {
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			" ucm_recv: NO MATCH op %s 0x%x %d i0x%x c0x%x"
+			" < 0x%x %d 0x%x\n", 
+			dapl_cm_op_str(ntohs(msg->op)), 
+			ntohs(msg->daddr.ib.lid), ntohs(msg->dport), 
+			ntohl(msg->daddr.ib.qpn), ntohl(msg->sqpn),
+			ntohs(msg->saddr.ib.lid), ntohs(msg->sport), 
+			ntohl(msg->saddr.ib.qpn));
+	}
+#endif
 	return found;
 }
 
@@ -524,21 +538,10 @@ retry:
 			continue;
 		}
 		if (!(cm = ucm_cm_find(tp, msg))) {
-			dapl_log(DAPL_DBG_TYPE_WARN,
-				 " ucm_recv: NO MATCH op %s 0x%x %d i0x%x c0x%x"
-				 " < 0x%x %d 0x%x\n", 
-				 dapl_cm_op_str(ntohs(msg->op)), 
-				 ntohs(msg->daddr.ib.lid), ntohs(msg->dport), 
-				 ntohl(msg->daddr.ib.qpn),
-				 ntohl(msg->sqpn),
-				 ntohs(msg->saddr.ib.lid), ntohs(msg->sport), 
-				 ntohl(msg->saddr.ib.qpn));
-
 			ucm_post_rmsg(tp, msg);
 			continue;
 		}
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: match %p\n",cm);
-
+		
 		/* match, process it */
 		ucm_process_recv(tp, msg, cm);
 		ucm_post_rmsg(tp, msg);
@@ -804,14 +807,13 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		/* send DREQ, event after DREP or DREQ timeout */
 		cm->state = DCM_DISC_PENDING;
 		cm->msg.op = htons(DCM_DREQ);
-		cm->retries = 1;
 		finalize = 0; /* wait for DREP, wakeup timer thread */
 		dapls_thread_signal(&cm->hca->ib_trans.signal);
 		break;
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
 		cm->msg.op = htons(DCM_DREQ);
-		if (cm->retries++ >= cm->hca->ib_trans.retries)
+		if (cm->retries >= cm->hca->ib_trans.retries)
 			finalize = 1;
 		break;
 	case DCM_DISC_RECV:
@@ -854,7 +856,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		return DAT_INVALID_STATE;
 	}
 	
-	if (cm->retries++ == cm->hca->ib_trans.retries) {
+	if (cm->retries == cm->hca->ib_trans.retries) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
 			" CM_REQ: RETRIES EXHAUSTED:"
 			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
@@ -895,7 +897,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		goto bail;
 
 	/* first time through, put on work queue */
-	if (cm->retries == 1)
+	if (!cm->retries)
 		ucm_queue_conn(cm);
 
 	return DAT_SUCCESS;
@@ -1126,7 +1128,6 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 	/* dest CM info from CR msg, source CM info from listen */
 	acm->sp = cm->sp;
 	acm->hca = cm->hca;
-	acm->retries = 1;
 	acm->msg.dport = msg->sport;
 	acm->msg.dqpn = msg->sqpn;
 	acm->msg.sport = cm->msg.sport; 
@@ -1220,9 +1221,13 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 						      cm->ep->qp_handle, 
 						      htons(lid), 
 						      NULL);
-		if (xevent.remote_ah.ah == NULL) 
+		if (xevent.remote_ah.ah == NULL) {
+			dapl_log(DAPL_DBG_TYPE_ERR,
+				 " accept_rtu: ERR create_ah"
+				 " for qpn 0x%x lid 0x%x\n",
+				 xevent.remote_ah.qpn, lid);
 			goto bail;
-
+		}
 		cm->ah = xevent.remote_ah.ah; /* keep ref to destroy */
 		dapl_os_memcpy(&xevent.remote_ah.ia_addr,
 			       &cm->msg.daddr,
@@ -1283,7 +1288,7 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 		return -1;
 	}
 
-	if (++cm->retries == cm->hca->ib_trans.retries) {
+	if (cm->retries == cm->hca->ib_trans.retries) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
 			 " CM_REP: RETRIES EXHAUSTED"
 			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
