From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] dapl ucm: CM changes for UD extended port space and
 indexer
Date: Fri, 22 May 2015 21:46:17 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76BCE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change port manager to indexer and service ID manager
to bitarray indexer. Reduces footprint for service IDs
and allow direct lookup on CM messages.

New insert, remove, lookup functions for processing ID
based CM objects. Inbound requests, with the exception
of new CM requests, will no longer parse list but
use hash table lookups.

AH caching is now used to prevent unnecessarily
creating multiple AH's for same QP destination.

Add 24-bit port space support to CM processing code and
to wire protocol via DCM message reserve space.
Add version check to limit to 16-bit for backward compatibility.

Bump CM protocol version to 8 for xport and rtns fields.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c | 1255 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 826 insertions(+), 429 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 330b1c2..3d06c82 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -116,40 +116,9 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 static void ucm_disconnect_final(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm);
-
-/* Service ids - port space */
-static uint16_t ucm_get_port(ib_hca_transport_t *tp, uint16_t port)
-{
-	int i = 0;
-	
-	dapl_os_lock(&tp->plock);
-	/* get specific ID */
-	if (port) {
-		if (tp->sid[port] == 0) {
-			tp->sid[port] = 1;
-			i = port;
-		}
-		goto done;
-	} 
-	
-	/* get any free ID */
-	for (i = 0xffff; i > 0; i--) {
-		if (tp->sid[i] == 0) {
-			tp->sid[i] = 1;
-			break;
-		}
-	}
-done:
-	dapl_os_unlock(&tp->plock);
-	return i;
-}
-
-static void ucm_free_port(ib_hca_transport_t *tp, uint16_t port)
-{
-	dapl_os_lock(&tp->plock);
-	tp->sid[port] = 0;
-	dapl_os_unlock(&tp->plock);
-}
+static int dapli_queue_listen(dp_ib_cm_handle_t cm, uint16_t sid);
+static int dapli_queue_conn(dp_ib_cm_handle_t cm);
+static dp_ib_cm_handle_t dapli_cm_lookup(ib_hca_transport_t *tp, int cm_id);
 
 static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 {
@@ -163,16 +132,19 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		if ((time - cm->timer)/1000 >=
 		    (cm->hca->ib_trans.rep_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				 " CM_REQ retry %p %d [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x Time(ms) %d >= %d\n",
-				 cm, cm->retries+1,
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 " CM_REQ %d retry %d:"
+				 " %d %x %x %x %x -> %d %x %x %x %x: %d > %d(ms)\n",
+				 cm->cm_id, cm->retries+1,
+				 ntohl(cm->msg.s_id), ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
 				 (time - cm->timer)/1000,
 				 cm->hca->ib_trans.rep_time << cm->retries);
 			cm->retries++;
+			cm->msg.rtns = cm->retries;
 			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
 				    DCNT_IA_CM_ERR_REQ_RETRY);
 			dapl_os_unlock(&cm->lock);
@@ -185,17 +157,20 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		if ((time - cm->timer)/1000 >=
 		    (cm->hca->ib_trans.rtu_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				 " CM_REP retry %d %s [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x Time(ms) %d >= %d\n",
-				 cm->retries+1,
+				 " CM_REP %d retry %d %s:"
+				 " %d %x %x %x %x -> %d %x %x %x %x: %d > %d(ms)\n",
+				 cm->cm_id, cm->retries+1,
 				 dapl_cm_op_str(ntohs(cm->msg.op)),
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 ntohl(cm->msg.s_id), ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-				 ntohl(cm->msg.d_id), (time - cm->timer)/1000,
+				 (time - cm->timer)/1000,
 				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
+			cm->msg.rtns = cm->retries;
 			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
 				    DCNT_IA_CM_ERR_REP_RETRY);
 			dapl_os_unlock(&cm->lock);
@@ -208,16 +183,20 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		if ((time - cm->timer)/1000 >=
 		    (cm->hca->ib_trans.drep_time << cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				 " CM_DREQ retry %d [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x Time(ms) %d >= %d\n",
-				 cm->retries+1,
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 " CM_DREQ %d retry %d %s:"
+				 " %d %x %x %x %x -> %d %x %x %x %x: %d > %d(ms)\n",
+				 cm->cm_id, cm->retries+1,
+				 dapl_cm_op_str(ntohs(cm->msg.op)),
+				 ntohl(cm->msg.s_id),ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-				 ntohl(cm->msg.d_id), (time - cm->timer)/1000,
+				 (time - cm->timer)/1000,
 				 cm->hca->ib_trans.drep_time << cm->retries);
 			cm->retries++;
+			cm->msg.rtns = cm->retries;
 			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
 				    DCNT_IA_CM_ERR_DREQ_RETRY);
 			dapl_os_unlock(&cm->lock);
@@ -230,16 +209,18 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		if ((time - cm->timer)/1000 >= cm->hca->ib_trans.wait_time) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
 				 " CM_TIMEWAIT EXPIRED %d %p [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x"
+				 " %x %x %x %x l_id %d -> %x %x %x %x r_id %d"
 				 " Time(ms) %d >= %d\n",
 				 cm->retries+1, cm,
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 cm->cm_id, ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
 				 ntohl(cm->msg.d_id), (time - cm->timer)/1000,
 				 cm->hca->ib_trans.wait_time);
-			cm->ah = NULL;  /* consumer will free a UD AH */
+
 			cm->state = DCM_FREE;
 			dapl_os_unlock(&cm->lock);
 			if (cm->ep->qp_handle->qp->qp_type == IBV_QPT_UD)
@@ -304,7 +285,6 @@ retry:
 }
 
 /* RECEIVE CM MESSAGE PROCESSING */
-
 static int ucm_post_rmsg(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 {	
 	struct ibv_recv_wr recv_wr, *recv_err;
@@ -330,8 +310,10 @@ static int ucm_reject(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 	smsg.ver = htons(DCM_VER);
 	smsg.op = htons(DCM_REJ_CM);
 	smsg.dport = msg->sport;
+	smsg.dportx = msg->sportx;
 	smsg.dqpn = msg->sqpn;
 	smsg.sport = msg->dport; 
+	smsg.sportx = msg->dportx;
 	smsg.sqpn = msg->dqpn;
 
 	dapl_os_memcpy(&smsg.daddr, &msg->saddr, sizeof(union dcm_addr));
@@ -347,68 +329,207 @@ static int ucm_reject(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, 
 		     " CM reject -> LID %x, QPN %x PORT %x\n", 
 		     ntohs(smsg.daddr.ib.lid),
-		     ntohl(smsg.dqpn), ntohs(smsg.dport));
+		     ntohl(smsg.dqpn),
+		     UCM_PORT_NTOH(smsg.dportx,smsg.dport));
 
 	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_ERR_REJ_TX);
 	return (ucm_send(tp, &smsg, NULL, 0));
 }
 
+/* called with cm lock held */
+static void ucm_timewait_recv(ib_hca_transport_t *tp,
+		     	      ib_cm_msg_t *msg,
+		     	      dp_ib_cm_handle_t cm)
+{
+	uint16_t msg_op = ntohs(msg->op);
+
+	/* REP_IN, re-send RTU */
+	if (msg_op == DCM_REP) {
+		cm->retries++;
+		cm->msg.rtns = cm->retries;
+		cm->msg.op = htons(DCM_RTU);
+		ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_ERR_RTU_RETRY);
+		return;
+	}
+	/* DREQ_IN, send DREP */
+	if (msg_op == DCM_DREQ) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			"  DREQ_in: ep %p cm %p %s %s"
+			"  %x %x %x %s %x %x %x r %x l %x rtns %d\n",
+			cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
+			dapl_cm_state_str(cm->state), ntohs(cm->msg.saddr.ib.lid),
+			UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+			ntohl(cm->msg.saddr.ib.qpn),
+			cm->sp ? "<-" : "->", ntohs(cm->msg.daddr.ib.lid),
+			UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+			ntohl(cm->msg.daddr.ib.qpn),
+			ntohl(cm->msg.d_id), ntohl(cm->msg.s_id), msg->rtns);
+		cm->msg.op = htons(DCM_DREP);
+		ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_DREQ_RX);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_DREP_TX);
+		return;
+	}
+	/* DUPs or unexpected */
+	if (msg_op == DCM_DREP) {
+		if (msg_op != DCM_DREP) {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				"  DREP_in: ep %p cm %p %s %s %s"
+				"  %x %x %x %s %x %x %x rtns %d\n",
+				cm->ep, cm,
+				cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
+				dapl_cm_op_str(ntohs(cm->msg.op)),
+				dapl_cm_state_str(cm->state), ntohs(cm->msg.saddr.ib.lid),
+				UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+				ntohl(cm->msg.saddr.ib.qpn),
+				cm->sp ? "<-" : "->", ntohs(cm->msg.daddr.ib.lid),
+				UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+				ntohl(cm->msg.daddr.ib.qpn), msg->rtns);
+			DAPL_CNTR(((DAPL_IA *)
+				    dapl_llist_peek_head(&cm->hca->ia_list_head)),
+				    DCNT_IA_CM_ERR_DREP_DUP);
+		}
+	} else if (msg_op == DCM_RTU) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			" RTU_in: DUP on cm %p id %d"
+			" <- %s %s s_port %x s_cqpn %x rtn %d\n",
+			cm, cm->cm_id, dapl_cm_op_str(msg_op),
+			dapl_cm_state_str(cm->state),
+			ntohs(msg->sport), ntohl(msg->sqpn), msg->rtns);
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_ERR_RTU_DUP);
+	} else {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			" MSG_in: UNEXPECTED on cm %p id %d"
+			" <- %s %s s_port %x s_cqpn %x\n",
+			cm, cm->cm_id, dapl_cm_op_str(msg_op),
+			dapl_cm_state_str(cm->state),
+			ntohs(msg->sport), ntohl(msg->sqpn));
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_ERR_UNEXPECTED);
+	}
+}
+
 static void ucm_process_recv(ib_hca_transport_t *tp, 
 			     ib_cm_msg_t *msg, 
 			     dp_ib_cm_handle_t cm)
 {
+	uint16_t msg_op = ntohs(msg->op);
+
 	dapl_os_lock(&cm->lock);
 	switch (cm->state) {
 	case DCM_LISTEN: /* passive */
 		dapl_os_unlock(&cm->lock);
 		ucm_accept(cm, msg);
 		break;
-	case DCM_RTU_PENDING: /* passive */
+	case DCM_ACCEPTING: 	/* passive */
 		dapl_os_unlock(&cm->lock);
-		ucm_accept_rtu(cm, msg);
+		/* duplicate CM_REQ */
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " REQ_in: DUP cm %p id %d op %s (%s) %s:"
+			 " %d %x %x %x %x <- %d %x %x %x %x\n",
+                         cm, cm->cm_id, dapl_cm_op_str(msg_op),
+                         dapl_cm_op_str(ntohs(cm->msg.op)),
+                         dapl_cm_state_str(cm->state),
+                         ntohl(msg->d_id), ntohs(msg->daddr.ib.lid),
+                         UCM_PORT_NTOH(msg->dportx, msg->dport),
+                         ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
+                         ntohl(msg->s_id), ntohs(msg->saddr.ib.lid),
+                         UCM_PORT_NTOH(msg->sportx, msg->sport),
+                         ntohl(msg->sqpn), ntohl(msg->saddr.ib.qpn));
+
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
+			    DCNT_IA_CM_ERR_REQ_DUP);
+		break;
+	case DCM_RTU_PENDING: 	/* passive */
+		dapl_os_unlock(&cm->lock);
+		if (msg_op == DCM_RTU)
+			return ucm_accept_rtu(cm, msg);
+
+		if (msg_op == DCM_REQ) {
+			/* CM_REP out dropped? */
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				 " REQ_in: RESEND REP cm %p %s %s:"
+				 " %d %x %x %x %x -> %d %x %x %x %x\n",
+				 cm, dapl_cm_op_str(msg_op),
+				 dapl_cm_state_str(cm->state),
+				 ntohl(cm->msg.s_id), ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn));
+			/* resend reply */
+			cm->retries++;
+			cm->msg.rtns = cm->retries;
+			ucm_reply(cm);
+		}
 		break;
 	case DCM_REP_PENDING: /* active */
 		dapl_os_unlock(&cm->lock);
 		ucm_connect_rtu(cm, msg);
 		break;
 	case DCM_CONNECTED: /* active and passive */
-		if (ntohs(msg->op) == DCM_REP) {
+		if (msg_op == DCM_REP) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				 " RESEND RTU: op %s st %s [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x\n",
-				  dapl_cm_op_str(ntohs(msg->op)),
-				  dapl_cm_state_str(cm->state),
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 " REP_in: RESEND RTU cm %p %s %s:"
+				 " %d %x %x %x %x -> %d %x %x %x %x\n",
+				 cm, dapl_cm_op_str(msg_op),
+				 dapl_cm_state_str(cm->state),
+				 ntohl(cm->msg.s_id), ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-				 ntohl(cm->msg.d_id));
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn));
+			cm->retries++;
+			cm->msg.rtns = cm->retries;
 			cm->msg.op = htons(DCM_RTU);
 			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
 			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
 				    DCNT_IA_CM_ERR_RTU_RETRY);
 			dapl_os_unlock(&cm->lock);
-		} else if (ntohs(msg->op) == DCM_DREQ) {
+		} else if (msg_op == DCM_DREQ) {
 			cm->state = DCM_DREQ_IN;
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
+		} else {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				 " MSG_in: UNEXPECTED: cm %p %s %s:"
+				 "S %d %x %x %x %x <-> D %d %x %x %x %x\n",
+				 cm, dapl_cm_op_str(msg_op),
+				 dapl_cm_state_str(cm->state),
+				 ntohl(cm->msg.s_id), ntohs(cm->msg.saddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+				 ntohl(cm->msg.d_id), ntohs(cm->msg.daddr.ib.lid),
+				 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn));
+
+			dapl_os_unlock(&cm->lock);
 		}
 		break;
 	case DCM_DREQ_OUT: /* active and passive */
 		/* DREQ return DREP and finalize, DREP finalize */
-		if (ntohs(msg->op) == DCM_DREQ) {
+		if (msg_op == DCM_DREQ) {
 			cm->state = DCM_DREQ_IN;
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
 		} else {
-			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				"  DREP_IN: ep %p cm %p %s %s"
+			dapl_log(DAPL_DBG_TYPE_CM,
+				"  DREP_in: ep %p cm %p %s %s"
 				"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
 				cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
 				dapl_cm_state_str(cm->state), ntohs(cm->msg.saddr.ib.lid),
-				ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
+				UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+				ntohl(cm->msg.saddr.ib.qpn),
 				cm->sp ? "<-" : "->", ntohs(cm->msg.daddr.ib.lid),
-				ntohs(cm->msg.dport), ntohl(cm->msg.daddr.ib.qpn),
+				UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+				ntohl(cm->msg.daddr.ib.qpn),
 				ntohl(cm->msg.d_id), ntohl(cm->msg.s_id));
 			dapl_os_unlock(&cm->lock);
 			ucm_disconnect_final(cm);
@@ -416,36 +537,11 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 		break;
 	case DCM_TIMEWAIT: /* active and passive */
 	case DCM_FREE:
-		/* DREQ_IN, re-send DREP */
-		if (ntohs(msg->op) == DCM_DREQ) {
-			dapl_os_unlock(&cm->lock);
-			dapli_cm_disconnect(cm);
-			break;
-		} else if (ntohs(msg->op) == DCM_DREP){
-			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				"  DREP_IN: ep %p cm %p %s %s"
-				"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
-				cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
-				dapl_cm_state_str(cm->state), ntohs(cm->msg.saddr.ib.lid),
-				ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
-				cm->sp ? "<-" : "->", ntohs(cm->msg.daddr.ib.lid),
-				ntohs(cm->msg.dport), ntohl(cm->msg.daddr.ib.qpn),
-				ntohl(cm->msg.d_id), ntohl(cm->msg.s_id));
-			dapl_os_unlock(&cm->lock);
-		} else {
-			dapl_log(DAPL_DBG_TYPE_WARN,
-				" ucm_recv: UNEXPECTED MSG on cm %p"
-				" <- op %s, st %s spsp %x sqpn %x\n", 
-				cm, dapl_cm_op_str(ntohs(msg->op)),
-				dapl_cm_state_str(cm->state),
-				ntohs(msg->sport), ntohl(msg->sqpn));
-			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
-				    DCNT_IA_CM_ERR_UNEXPECTED);
-			dapl_os_unlock(&cm->lock);
-		}
+		ucm_timewait_recv(tp, msg, cm);
+		dapl_os_unlock(&cm->lock);
 		break;
 	case DCM_REJECTED:
-		if (ntohs(msg->op) == DCM_REJ_USER) {
+		if (msg_op == DCM_REJ_USER) {
 			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)),
 				    DCNT_IA_CM_USER_REJ_RX);
 			dapl_os_unlock(&cm->lock);
@@ -456,15 +552,62 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 		dapl_log(DAPL_DBG_TYPE_CM_WARN,
 			" ucm_recv: Warning, UNKNOWN state"
 			" <- op %s, %s spsp %x sqpn %x slid %x\n",
-			dapl_cm_op_str(ntohs(msg->op)),
+			dapl_cm_op_str(msg_op),
 			dapl_cm_state_str(cm->state),
-			ntohs(msg->sport), ntohl(msg->sqpn),
-			ntohs(msg->saddr.ib.lid));
+			UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+			ntohl(msg->sqpn), ntohs(msg->saddr.ib.lid));
 		dapl_os_unlock(&cm->lock);
 		break;
 	}
 }
 
+static inline int ucm_cmp(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg, int listen)
+{
+	uint32_t l_sport = UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport);
+	uint32_t l_dport = UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport);
+	uint32_t r_sport = UCM_PORT_NTOH(msg->sportx, msg->sport);
+	uint32_t r_dport = UCM_PORT_NTOH(msg->dportx, msg->dport);
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " ucm_cmp: CM  %s %s [l_id sqp dqp dlid sprt dprt]:"
+		 " %d %x %x %x %x %x\n",
+		 listen ? "":dapl_cm_op_str(ntohs(cm->msg.op)),
+		 dapl_cm_state_str(cm->state), cm->cm_id,
+		 ntohl(cm->msg.sqpn), ntohl(cm->msg.dqpn),
+		 ntohs(cm->msg.daddr.ib.lid),
+		 l_sport, l_dport);
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " ucm_cmp: MSG %s %s [d_id dqp sqp slid dport sport]:"
+		 " %d %x %x %x %x %x\n",
+		 dapl_cm_op_str(ntohs(msg->op)),
+		 dapl_cm_state_str(cm->state),
+		 ntohl(cm->msg.d_id),
+		 ntohl(msg->dqpn), ntohl(msg->sqpn),
+		 ntohs(msg->saddr.ib.lid),
+		 r_dport, r_sport);
+
+	if (listen) {
+		if (l_sport == r_dport &&
+		    cm->msg.sqpn == msg->dqpn)
+			return 1;
+		else
+			return 0;
+
+	}
+
+	if (l_sport == r_dport &&
+	    l_dport == r_sport &&
+	    cm->msg.sqpn == msg->dqpn &&
+	    cm->msg.dqpn == msg->sqpn &&
+	    cm->msg.daddr.ib.lid == msg->saddr.ib.lid) {
+		return 1;
+	}
+
+	return 0;
+}
+
+
 /* Find matching CM object for this receive message, return CM reference, timer */
 dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 {
@@ -472,13 +615,47 @@ dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 	struct dapl_llist_entry	**list;
 	DAPL_OS_LOCK *lock;
 	int listenq = 0;
+	uint16_t msg_op = ntohs(msg->op);
 
 	/* conn list first, duplicate requests for DCM_REQ */
 	list = &tp->list;
 	lock = &tp->lock;
 
+	dapl_log(DAPL_DBG_TYPE_CM,
+		" ucm_recv: %s %d %x %x i %x c %x < %d %x %x i %x c %x\n",
+		dapl_cm_op_str(msg_op),
+		ntohl(msg->d_id), ntohs(msg->daddr.ib.lid),
+		UCM_PORT_NTOH(msg->dportx, msg->dport),
+		ntohl(msg->daddr.ib.qpn), ntohl(msg->dqpn),
+		ntohl(msg->s_id), ntohs(msg->saddr.ib.lid),
+		UCM_PORT_NTOH(msg->sportx, msg->sport),
+		ntohl(msg->saddr.ib.qpn), ntohl(msg->sqpn));
+
 retry_listenq:
 	dapl_os_lock(lock);
+
+	/* if new REQ, goto listen list */
+	if ((msg_op == DCM_REQ) && !listenq && !msg->rtns)
+		goto skip_cqlist;
+
+	/* connectq: lookup using indexer */
+	if (!listenq && msg->d_id) {
+		int match;
+
+		cm = dapli_cm_lookup(tp, ntohl(msg->d_id));
+		if (cm && (cm->cm_id == ntohl(msg->d_id))) {
+			match = ucm_cmp(cm, msg, 0);
+			if (match) {
+				dapl_log(DAPL_DBG_TYPE_CM,
+					 "connect idxr[%d] match! cm %p %s\n",
+					 cm->cm_id, cm,
+					 dapl_cm_op_str(msg_op));
+				found = cm;
+				goto skip_cqlist; /* idxr hit */
+			}
+		}
+	}
+
         if (!dapl_llist_is_empty(list))
 		next = dapl_llist_peek_head(list);
 	else
@@ -491,51 +668,19 @@ retry_listenq:
 		if (cm->state == DCM_DESTROY || cm->state == DCM_FREE)
 			continue;
 		
-		/* CM sPORT + QPN, match is good enough for listenq */
-		if (listenq && 
-		    cm->msg.sport == msg->dport && 
-		    cm->msg.sqpn == msg->dqpn) {
+		if (ucm_cmp(cm, msg, listenq)) {
+			dapl_log(DAPL_DBG_TYPE_CM, "%s list match!\n",
+				 listenq ? "listen":"connect");
 			found = cm;
 			break;
-		}	 
-		/* connectq, check src and dst plus id's, check duplicate conn_reqs */
-		if (!listenq && 
-		    cm->msg.sport == msg->dport && cm->msg.sqpn == msg->dqpn && 
-		    cm->msg.dport == msg->sport && cm->msg.dqpn == msg->sqpn && 
-		    cm->msg.daddr.ib.lid == msg->saddr.ib.lid) {
-			if (ntohs(msg->op) != DCM_REQ) {
-				found = cm;
-				break; 
-			} else {
-				/* duplicate; bail and throw away */
-				dapl_os_unlock(lock);
-				dapl_log(DAPL_DBG_TYPE_CM_WARN,
-					 " DUPLICATE: cm %p op %s (%s) st %s"
-					 " [lid, port, cqp, iqp]:"
-					 " %x %x %x %x <- (%x %x %x %x :"
-					 " %x %x %x %x) -> %x %x %x %x\n",
-					 cm, dapl_cm_op_str(ntohs(msg->op)),
-					 dapl_cm_op_str(ntohs(cm->msg.op)),
-					 dapl_cm_state_str(cm->state),
-					 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-					 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-					 ntohs(msg->saddr.ib.lid), ntohs(msg->sport),
-					 ntohl(msg->sqpn), ntohl(msg->saddr.ib.qpn),
-					 ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
-					 ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
-					 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
-					 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn));
-
-					DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_ERR_REQ_DUP);
-
-					return NULL;
-			}
 		}
 	}
+
+skip_cqlist:
 	dapl_os_unlock(lock);
 
 	/* no duplicate request on connq, check listenq for new request */
-	if (ntohs(msg->op) == DCM_REQ && !listenq && !found) {
+	if ((msg_op == DCM_REQ) && !listenq && !found) {
 		listenq = 1;
 		list = &tp->llist;
 		lock = &tp->llock;
@@ -543,33 +688,36 @@ retry_listenq:
 	}
 
 	/* not match on listenq for valid request, send reject */
-	if (ntohs(msg->op) == DCM_REQ && !found) {
+	if ((msg_op == DCM_REQ) && !found) {
 		dapl_log(DAPL_DBG_TYPE_WARN,
-			" ucm_recv: NO LISTENER for %s %x %x i%x c%x"
-			" < %x %x %x, sending reject\n", 
-			dapl_cm_op_str(ntohs(msg->op)), 
-			ntohs(msg->daddr.ib.lid), ntohs(msg->dport), 
+			" NO LISTENER for %s %x %x i%x c%x"
+			" < %x %x %x REJECT rtns=%d\n",
+			dapl_cm_op_str(msg_op),
+			ntohs(msg->daddr.ib.lid),
+			UCM_PORT_NTOH(msg->dportx, msg->dport),
 			ntohl(msg->daddr.ib.qpn), ntohl(msg->sqpn),
-			ntohs(msg->saddr.ib.lid), ntohs(msg->sport), 
-			ntohl(msg->saddr.ib.qpn));
+			ntohs(msg->saddr.ib.lid),
+			UCM_PORT_NTOH(msg->sportx, msg->sport),
+			ntohl(msg->saddr.ib.qpn), msg->rtns);
 
 		ucm_reject(tp, msg);
-	}
 
-	if (!found) {
-		dapl_log(DAPL_DBG_TYPE_CM_WARN,
-			 " NO MATCH: op %s [lid, port, cqp, iqp, pid]:"
-			 " %x %x %x %x %x <- %x %x %x %x l_pid %x r_pid %x\n",
-			 dapl_cm_op_str(ntohs(msg->op)),
-			 ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
-			 ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
-			 ntohl(msg->d_id), ntohs(msg->saddr.ib.lid),
-			 ntohs(msg->sport), ntohl(msg->sqpn),
-			 ntohl(msg->saddr.ib.qpn), ntohl(msg->s_id),
-			 ntohl(msg->d_id));
-
-		if (ntohs(msg->op) == DCM_DREP) {
-			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)), DCNT_IA_CM_ERR_DREP_DUP);
+	} else if (!found) {
+		if (msg_op != DCM_DREP) {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				 " NO MATCH: op %s [lid, prt, cqp, iqp]:"
+				 " %x %x %x %x %x <- %x %x %x %x L %d R %d rtns=%d\n",
+				 dapl_cm_op_str(msg_op),
+				 ntohs(msg->daddr.ib.lid),
+				 UCM_PORT_NTOH(msg->dportx, msg->dport),
+				 ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
+				 ntohl(msg->d_id), ntohs(msg->saddr.ib.lid),
+				 UCM_PORT_NTOH(msg->sportx, msg->sport),
+				 ntohl(msg->sqpn), ntohl(msg->saddr.ib.qpn),
+				 ntohl(msg->s_id), ntohl(msg->d_id), msg->rtns);
+		} else if (msg->rtns) {
+			DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&tp->hca->ia_list_head)),
+				    DCNT_IA_CM_ERR_DREP_DUP);
 		}
 	}
 
@@ -620,6 +768,15 @@ retry:
 			ucm_post_rmsg(tp, msg);
 			continue;
 		}
+
+		if (ntohs(msg->ver) < DCM_VER_XPS) {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				 " cm_recv: peer (v%d < v%d) doesn't support"
+				 " %d-bit xport space, now 16-bit)\n",
+				 msg->ver, DCM_VER_XPS, tp->cm_array_bits);
+			tp->cm_array_bits = 16;
+		}
+
 		if (!(cm = ucm_cm_find(tp, msg))) {
 			ucm_post_rmsg(tp, msg);
 			continue;
@@ -629,6 +786,7 @@ retry:
 		ucm_process_recv(tp, msg, cm);
 		ucm_post_rmsg(tp, msg);
 	}
+	sched_yield();
 	
 	/* finished this batch of WC's, poll and rearm */
 	goto retry;
@@ -676,7 +834,8 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 		" ucm_send: op %s ln %d lid %x c_qpn %x rport %x\n",
 		dapl_cm_op_str(ntohs(smsg->op)), 
 		sge.length, htons(smsg->daddr.ib.lid), 
-		htonl(smsg->dqpn), htons(smsg->dport));
+		htonl(smsg->dqpn),
+		UCM_PORT_NTOH(smsg->dportx, smsg->dport));
 
 	/* empty slot, then create AH */
 	if (!tp->ah[dlid]) {
@@ -708,8 +867,6 @@ static void dapli_cm_dealloc(dp_ib_cm_handle_t cm) {
 
 	dapl_os_assert(!cm->ref_count);
 	dapl_os_lock_destroy(&cm->lock);
-	dapl_os_wait_object_destroy(&cm->d_event);
-	dapl_os_wait_object_destroy(&cm->f_event);
 	dapl_os_free(cm, sizeof(*cm));
 }
 
@@ -725,69 +882,63 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
 	dapl_os_lock(&cm->lock);
 	cm->ref_count--;
 	if (cm->ref_count) {
-		if ((cm->ref_count == 1) && (cm->list_entry.list_head))
-			dapl_os_wait_object_wakeup(&cm->f_event);
                 dapl_os_unlock(&cm->lock);
 		return;
 	}
 	dapl_log(DAPL_DBG_TYPE_CM,
-		 " dapls_cm_release: cm %p %s ep %p sp %p refs=%d\n",
+		 " dapls_cm_release: cm %p %s ep %p sp %p refs=%d sz=%d\n",
 		 cm, dapl_cm_state_str(cm->state),
-		 cm->ep, cm->sp, cm->ref_count);
+		 cm->ep, cm->sp, cm->ref_count, sizeof(*cm));
 
-	/* client, release local conn id port */
-	if (!cm->sp && cm->msg.sport)
-		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
-
-	/* clean up any UD address handles */
-	if (cm->ah) {
-		ibv_destroy_ah(cm->ah);
-		cm->ah = NULL;
-	}
 	dapl_os_unlock(&cm->lock);
 	dapli_cm_dealloc(cm);
+	return;
 }
 
-dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
+dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_HCA *hca, DAPL_EP *ep, uint16_t *sid)
 {
 	dp_ib_cm_handle_t cm;
+	int ret;
+
+	errno = -ENOMEM;
 
 	/* Allocate CM, init lock, and initialize */
-	if ((cm = dapl_os_alloc(sizeof(*cm))) == NULL)
+	if ((cm = dapl_os_alloc(sizeof(*cm))) == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM cm_create: ERR malloc(%s)\n",strerror(errno));
 		return NULL;
-
-	(void)dapl_os_memzero(cm, sizeof(*cm));
-	if (dapl_os_lock_init(&cm->lock))
-		goto bail;
-	
-	if (dapl_os_wait_object_init(&cm->f_event)) {
-		dapl_os_lock_destroy(&cm->lock);
-		goto bail;
 	}
-	if (dapl_os_wait_object_init(&cm->d_event)) {
-		dapl_os_lock_destroy(&cm->lock);
-		dapl_os_wait_object_destroy(&cm->f_event);
-		goto bail;
+	(void)dapl_os_memzero(cm, sizeof(*cm));
+	if (dapl_os_lock_init(&cm->lock)) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM cm_create: ERR lock(%s)\n",strerror(errno));
+		goto err1;
 	}
-	dapls_cm_acquire(cm);
 
 	cm->msg.ver = htons(DCM_VER);
-	cm->msg.s_id = htonl(dapl_os_getpid()); /* process id for src id */
+	cm->hca = hca;
 	
+	if (sid)
+		ret = dapli_queue_listen(cm, *sid);
+	else
+		ret = dapli_queue_conn(cm);
+
+	if (ret) {
+		errno = -EADDRINUSE;
+		goto err2;
+	}
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " cm_create: SRC portx %x port %x = %x\n",
+		 cm->msg.sportx, ntohs(cm->msg.sport),
+		 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport));
+
 	/* ACTIVE: init source address QP info from local EP */
 	if (ep) {
 		DAPL_HCA *hca = ep->header.owner_ia->hca_ptr;
 
-		cm->msg.sport = htons(ucm_get_port(&hca->ib_trans, 0));
-		if (!cm->msg.sport) {
-			dapl_os_wait_object_destroy(&cm->f_event);
-			dapl_os_wait_object_destroy(&cm->d_event);
-			dapl_os_lock_destroy(&cm->lock);
-			goto bail;
-		}
 		/* link CM object to EP */
 		dapl_ep_link_cm(ep, cm);
-		cm->hca = hca;
 		cm->ep = ep;
 
 		/* IB info in network order */
@@ -799,12 +950,18 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 			       &hca->ib_trans.addr.ib.gid, 16);
         }
 	dapl_log(DAPL_DBG_TYPE_CM,
-		 " dapls_ib_cm_create: cm %p %s ep %p sp %p refs=%d\n",
+		 " cm_create: cm %p %s ep %p refs=%d sport=0x%x\n",
 		 cm, dapl_cm_state_str(cm->state),
-		 cm->ep, cm->sp, cm->ref_count);
+		 cm->ep, cm->ref_count,
+		 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport));
 
+	dapls_cm_acquire(cm);
+	errno = 0;
 	return cm;
-bail:
+
+err2:
+	dapl_os_lock_destroy(&cm->lock);
+err1:
 	dapl_os_free(cm, sizeof(*cm));
 	return NULL;
 }
@@ -833,17 +990,19 @@ void dapli_cm_free(dp_ib_cm_handle_t cm)
 		dapl_os_unlock(&sp_ptr->header.lock);
 	}
 	cm->state = DCM_FREE;
-	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	dapl_os_unlock(&cm->lock);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
 }
 
 /* Blocking, ONLY called from dat_ep_free */
 void dapls_cm_free(dp_ib_cm_handle_t cm)
 {
+	struct dapl_ep *ep = cm->ep;
+
 	dapl_log(DAPL_DBG_TYPE_CM,
 		 " dapl_cm_free: cm %p %s ep %p refs=%d\n", 
 		 cm, dapl_cm_state_str(cm->state),
-		 cm->ep, cm->ref_count);
+		 ep, cm->ref_count);
 	
 	/* free from internal workq, wait until EP is last ref */
 	dapl_os_lock(&cm->lock);
@@ -853,16 +1012,17 @@ void dapls_cm_free(dp_ib_cm_handle_t cm)
 	if (cm->cr)
 		dapls_cr_free(cm->cr);
 
-	if (cm->ref_count != 1) {
+	if (cm->ref_count > 1) {
+		dapl_log(DAPL_DBG_TYPE_CM,
+			 " cm_free: EP %p CM->ep %p CM %p, refs %d > 1\n",
+			 ep, cm->ep, cm, cm->ref_count);
 		dapls_thread_signal(&cm->hca->ib_trans.signal);
-		dapl_os_unlock(&cm->lock);
-		dapl_os_wait_object_wait(&cm->f_event, DAT_TIMEOUT_INFINITE);
-		dapl_os_lock(&cm->lock);
 	}
+	cm->ep = NULL;
 	dapl_os_unlock(&cm->lock);
 
-	/* unlink, dequeue from EP. Final ref so release will destroy */
-	dapl_ep_unlink_cm(cm->ep, cm);
+	/* unlink, dequeue from EP */
+	dapl_ep_unlink_cm(ep, cm);
 }
 
 DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep, dp_ib_cm_handle_t cm)
@@ -878,7 +1038,6 @@ DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 			 ep, cm->ep);
 		return DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_EP);
 	}
-	cm->ah = NULL;  /* consumer freeing CM, will also free AH */
 
 	if (cm->sp) {
 		dapli_cm_free(cm); /* PASSIVE side: no need for time-wait */
@@ -886,38 +1045,251 @@ DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		return DAT_SUCCESS;
 	}
 
-	dapl_os_lock(&cm->hca->ib_trans.lock);
+	dapl_os_lock(&cm->lock);
 	dapl_os_get_time(&cm->timer); /* set timer for TIMEWAIT */
 	cm->state = DCM_TIMEWAIT; /* schedule UD CM release */
-	dapl_os_unlock(&cm->hca->ib_trans.lock);
-	dapls_thread_signal(&cm->hca->ib_trans.signal);
+	dapl_os_unlock(&cm->lock);
 
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	return DAT_SUCCESS;
 }
 
+static int dapli_cm_insert(ib_hca_transport_t *tp, dp_ib_cm_handle_t cm, uint32_t *port)
+{
+	int array_sz = UCM_ARRAY_SIZE(tp->cm_array_bits, tp->cm_entry_bits);
+	int entry_sz = UCM_ENTRY_SIZE(tp->cm_entry_bits);
+	int max_idx = ((entry_sz * (tp->cm_idxr_cur+1)) - 1);
+	int idx, entry_idx, array_idx, ret = -1;
+	void **entry;
+
+	if (*port && (*port > UCM_SID_SPACE))
+		goto err;
+
+	dapl_os_lock(&tp->ilock);
+
+	/* grow index space for CM */
+	if (tp->cm_cnt >= max_idx-1) {
+
+		dapl_log(DAPL_DBG_TYPE_CM,
+			 " cm_insert: grow cur %d, new %d \n",
+			max_idx, (tp->cm_idxr_cur+1) * entry_sz,
+			array_sz);
+
+		if (tp->cm_idxr_cur+1 == array_sz) {
+			dapl_log(DAPL_DBG_TYPE_ERR,
+		       		 " cm_insert: ERR max objects (%d),"
+				 " increase DAPL_UCM_ARRAY_BITS (cur=%d)\n",
+		       		max_idx, tp->cm_array_bits);
+			goto err2;
+		}
+
+		tp->cm_idxr_cur++;
+		tp->cm_idxr[tp->cm_idxr_cur] =
+			dapl_os_alloc(sizeof(void*) * entry_sz);
+
+		if (!tp->cm_idxr[tp->cm_idxr_cur]) {
+		       	dapl_log(DAPL_DBG_TYPE_ERR,
+		       		 " cm_insert: ERR (%s) alloc %d\n",
+		       		 strerror(errno), sizeof(void*) * entry_sz);
+		       	tp->cm_idxr_cur--;
+		       	goto err2;
+		}
+		(void)dapl_os_memzero(tp->cm_idxr[tp->cm_idxr_cur],
+				      sizeof(void*) * entry_sz);
+
+		max_idx = entry_sz * (tp->cm_idxr_cur+1);
+	}
+
+	if ((*port == 0) || (*port && *port >= max_idx)) {
+		idx = ++tp->cm_last; /* start from last free slot */
+
+		if (idx == max_idx)
+			idx = 1;
+
+		*port = 0; /* any slot */
+	} else {
+		idx = *port; /* in range, reserve SID port */
+	}
+
+	entry_idx = UCM_ENTRY_IDX(idx, entry_sz);
+	array_idx = UCM_ARRAY_IDX(idx, tp->cm_entry_bits);
+	entry = tp->cm_idxr[array_idx];
+
+	if (*port && entry[entry_idx])  /* requested sid taken */
+		goto err2;
+
+	while (entry[entry_idx]) {
+		if (++idx == max_idx )
+			idx = 1;
+
+		entry_idx = UCM_ENTRY_IDX(idx, entry_sz);
+		array_idx = UCM_ARRAY_IDX(idx, tp->cm_entry_bits);
+		entry = tp->cm_idxr[array_idx];
+	};
+
+	entry[entry_idx] = (void *)cm;
+	tp->cm_cnt++;
+
+	if (*port == 0)
+		tp->cm_last = idx;
+
+	*port = idx;
+	ret = 0;
+err2:
+	dapl_os_unlock(&tp->ilock);
+err:
+	return ret;
+}
+
+static void dapli_cm_remove(ib_hca_transport_t *tp, dp_ib_cm_handle_t cm)
+{
+	int idx = cm->cm_id;
+	int entry_idx, array_idx;
+	int entry_sz = UCM_ENTRY_SIZE(tp->cm_entry_bits);
+	int max_idx = UCM_ARRAY_IDX_MAX(tp->cm_array_bits);
+	void **entry;
+
+	if (!idx || idx > max_idx) {
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			 " cm_remove: CM %p idx %d invalid, max %d\n",
+			 cm, idx, max_idx);
+		return;
+	}
+	dapl_os_lock(&tp->ilock);
+	entry_idx = UCM_ENTRY_IDX(idx, entry_sz);
+	array_idx = UCM_ARRAY_IDX(idx, tp->cm_entry_bits);
+	entry = tp->cm_idxr[array_idx];
+
+	if (cm != entry[entry_idx]) {
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			 " cm_remove: CM %p != entry[%d] %p\n",
+			 cm, idx, entry[entry_idx]);
+		goto err;
+	}
+
+	cm->cm_id = 0;
+	entry[entry_idx] = NULL;
+	tp->cm_cnt--;
+	tp->cm_free = idx; /* hint for insert */
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " cm_remove: CM %p entry %p [%d][%d] cm_id=%d active %d %s\n",
+		 cm, entry, array_idx, entry_idx, idx, tp->cm_cnt,
+		 dapl_cm_state_str(cm->state));
+err:
+	dapl_os_unlock(&tp->ilock);
+}
+
+static dp_ib_cm_handle_t dapli_cm_lookup(ib_hca_transport_t *tp, int cm_id)
+{
+	int idx = cm_id;
+	int entry_sz = UCM_ENTRY_SIZE(tp->cm_entry_bits);
+	int entry_idx, array_idx, max_idx = UCM_ARRAY_IDX_MAX(tp->cm_array_bits);
+	dp_ib_cm_handle_t cm = NULL;
+	void **entry;
+
+	if (!idx)
+		return NULL;
+
+	if (idx >= max_idx) {
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			 " cm_lookup: idx %d invalid, max %d\n",
+			 cm, idx, max_idx);
+		return NULL;
+	}
+
+	dapl_os_lock(&tp->ilock);
+	entry_idx = UCM_ENTRY_IDX(idx, entry_sz);
+	array_idx = UCM_ARRAY_IDX(idx, tp->cm_entry_bits);
+	entry = tp->cm_idxr[array_idx];
+	cm = (dp_ib_cm_handle_t) entry[entry_idx];
+
+	if (!cm || (cm && (cm->cm_id != cm_id))) {
+		dapl_log(DAPL_DBG_TYPE_CM,
+			 "entry %p[%d][%d] idx %d !="
+			 " cm %p cm_id %d\n",
+			 entry, array_idx, entry_idx, idx,
+			 cm, cm ? cm->cm_id:0 );
+		cm = NULL;
+	}
+
+	dapl_os_unlock(&tp->ilock);
+	return cm;
+}
+
 /* ACTIVE/PASSIVE: queue up connection object on CM list */
-static void dapli_queue_conn(dp_ib_cm_handle_t cm)
+static int dapli_queue_conn(dp_ib_cm_handle_t cm)
 {
+	int ret = -1;
+	uint32_t port;
+
+	/* don't use reserved SID port */
+	dapl_os_lock(&cm->hca->ib_trans.llock);
+	do {
+		port = 0;
+		if (dapli_cm_insert(&cm->hca->ib_trans, cm, &port))
+			goto err;
+
+	} while (UCM_CHK_SID(cm->hca->ib_trans.sid, port));
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 "  qconn: CHK %p port %d sid[%d]=0x%x (lsh=%d)\n",
+		 cm, port, port/8, cm->hca->ib_trans.sid[port/8], port%8);
+
 	/* add to work queue, list, for cm thread processing */
 	dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->local_entry);
-	dapl_os_lock(&cm->hca->ib_trans.lock);
+	cm->state = DCM_INIT;
+	cm->cm_id = port;
+	cm->msg.s_id = htonl(port);
+	cm->msg.sport = (uint16_t)htons(UCM_PORT(port));
+	cm->msg.sportx = (uint8_t)UCM_PORTX(port);
 	dapls_cm_acquire(cm);
+
+	dapl_os_lock(&cm->hca->ib_trans.lock);
 	dapl_llist_add_tail(&cm->hca->ib_trans.list,
 			    (DAPL_LLIST_ENTRY *)&cm->local_entry, cm);
 	dapl_os_unlock(&cm->hca->ib_trans.lock);
+	ret = 0;
+err:
+	dapl_os_unlock(&cm->hca->ib_trans.llock);
 	dapls_thread_signal(&cm->hca->ib_trans.signal);
+	return ret;
 }
 
 /* PASSIVE: queue up listen object on listen list */
-static void dapli_queue_listen(dp_ib_cm_handle_t cm)
+static int dapli_queue_listen(dp_ib_cm_handle_t cm, uint16_t sid)
 {
+	int ret = -1;
+
+	dapl_os_lock(&cm->hca->ib_trans.llock);
+
+	if (UCM_CHK_SID(cm->hca->ib_trans.sid, sid))
+		goto err;
+
+	cm->cm_id = sid;
+	if (dapli_cm_insert(&cm->hca->ib_trans, cm, &cm->cm_id))
+		goto err;
+
+	UCM_SET_SID(cm->hca->ib_trans.sid, sid); /* reserve SID */
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 "  qlisten: SET %p port %d sid[%d]=0x%x (lsh=%d)\n",
+		 cm, sid, sid/8, cm->hca->ib_trans.sid[sid/8], sid%8);
+
 	/* add to work queue, llist, for cm thread processing */
 	dapl_llist_init_entry((DAPL_LLIST_ENTRY *)&cm->local_entry);
-	dapl_os_lock(&cm->hca->ib_trans.llock);
+
+	cm->state = DCM_LISTEN;
+	cm->msg.sport = (uint16_t)htons(UCM_PORT(sid));
+	cm->msg.sportx = 0;
 	dapls_cm_acquire(cm);
+
 	dapl_llist_add_tail(&cm->hca->ib_trans.llist,
 			    (DAPL_LLIST_ENTRY *)&cm->local_entry, cm);
+	ret = 0;
+err:
 	dapl_os_unlock(&cm->hca->ib_trans.llock);
+	return ret;
 }
 
 static void dapli_dequeue_listen(dp_ib_cm_handle_t cm) 
@@ -925,8 +1297,17 @@ static void dapli_dequeue_listen(dp_ib_cm_handle_t cm)
 	DAPL_HCA *hca = cm->hca;
 
 	dapl_os_lock(&hca->ib_trans.llock);
+	UCM_CLR_SID(cm->hca->ib_trans.sid, ntohs(cm->msg.sport)); /* reset SID */
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 "  dqlisten: CLR %p port %d sid[%d]=0x%x (lsh=%d)\n",
+		 cm, ntohs(cm->msg.sport), ntohs(cm->msg.sport)/8,
+		 cm->hca->ib_trans.sid[ntohs(cm->msg.sport)/8],
+		 ntohs(cm->msg.sport)%8);
+
 	dapl_llist_remove_entry(&hca->ib_trans.llist, 
 				(DAPL_LLIST_ENTRY *)&cm->local_entry);
+	dapli_cm_remove(&cm->hca->ib_trans, cm);
 	dapls_cm_release(cm);
 	dapl_os_unlock(&hca->ib_trans.llock);
 }
@@ -937,6 +1318,7 @@ static void dapli_cm_dequeue(dp_ib_cm_handle_t cm)
 	/* Remove from work queue, cr thread processing */
 	dapl_llist_remove_entry(&cm->hca->ib_trans.list,
 				(DAPL_LLIST_ENTRY *)&cm->local_entry);
+	dapli_cm_remove(&cm->hca->ib_trans, cm);
 	dapls_cm_release(cm);
 }
 
@@ -955,7 +1337,7 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 	dapl_os_get_time(&cm->timer); /* set timer for TIMEWAIT */
 	cm->state = DCM_TIMEWAIT;
 
-	dapl_log(DAPL_DBG_TYPE_CM_WARN,
+	dapl_log(DAPL_DBG_TYPE_CM,
 		"  DISC_EVENT: ep %p cm %p %s %s"
 		"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
 		cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
@@ -972,8 +1354,6 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 	else
 		dapl_evd_connection_callback(cm, IB_CME_DISCONNECTED, NULL, 0, cm->ep);
 
-	dapl_os_wait_object_wakeup(&cm->d_event);
-
 }
 
 /*
@@ -993,7 +1373,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 			dapls_modify_qp_state(cm->ep->qp_handle->qp, IBV_QPS_ERR,0,0,0);
 
 		/* send DREQ, event after DREP or DREQ timeout */
-		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+		dapl_log(DAPL_DBG_TYPE_CM,
 			"  DREQ_OUT: ep %p cm %p %s %s"
 			"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
 			cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
@@ -1027,7 +1407,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		    (cm->ep->qp_state != IBV_QPS_ERR))
 			dapls_modify_qp_state(cm->ep->qp_handle->qp, IBV_QPS_ERR,0,0,0);
 
-		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+		dapl_log(DAPL_DBG_TYPE_CM,
 			"  DREQ_IN: ep %p cm %p %s %s"
 			"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
 			cm->ep, cm, cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
@@ -1036,18 +1416,21 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 			cm->sp ? "<-" : "->", ntohs(cm->msg.daddr.ib.lid),
 			ntohs(cm->msg.dport), ntohl(cm->msg.daddr.ib.qpn),
 			ntohl(cm->msg.d_id), ntohl(cm->msg.s_id));
-	case DCM_TIMEWAIT:
-	case DCM_FREE:
-		/* DREQ received, send DREP, finalize */
-		cm->msg.op = htons(DCM_DREP);
+
 		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_DREQ_RX);
 		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_DREP_TX);
+		/* DREQ received, send DREP, finalize */
+		cm->msg.op = htons(DCM_DREP);
 		break;
+	case DCM_TIMEWAIT:
+	case DCM_FREE:
+		dapl_os_unlock(&cm->lock);
+		return DAT_SUCCESS;
 	default:
 		dapl_log(DAPL_DBG_TYPE_CM_WARN,
-			"  disconnect UNKNOWN state: ep %p cm %p %s %s"
-			"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
-			cm->ep, cm,
+			"  DISC unexpected: EP %p %d CM %p %s %s"
+			"  %x %x %x %s %x %x %x r %x l %x\n",
+			cm->ep, cm->ep->param.ep_state, cm,
 			cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
 			dapl_cm_state_str(cm->state),
 			ntohs(cm->msg.saddr.ib.lid),
@@ -1059,7 +1442,6 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 			ntohl(cm->msg.daddr.ib.qpn),
 			ntohl(cm->msg.d_id),
 			ntohl(cm->msg.s_id));
-
 		dapl_os_unlock(&cm->lock);
 		return DAT_SUCCESS;
 	}
@@ -1087,26 +1469,29 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		 " connect: lid %x i_qpn %x lport %x p_sz=%d -> "
 		 " lid %x c_qpn %x rport %x\n",
 		 htons(cm->msg.saddr.ib.lid), htonl(cm->msg.saddr.ib.qpn),
-		 htons(cm->msg.sport), htons(cm->msg.p_size),
+		 UCM_PORT_NTOH(cm->msg.sportx,cm->msg.sport),
+		 htons(cm->msg.p_size),
 		 htons(cm->msg.daddr.ib.lid), htonl(cm->msg.dqpn),
-		 htons(cm->msg.dport));
+		 UCM_PORT_NTOH(cm->msg.dportx,cm->msg.dport));
 
 	dapl_os_lock(&cm->lock);
 	if (cm->state != DCM_INIT && cm->state != DCM_REP_PENDING) {
 		dapl_os_unlock(&cm->lock);
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			"UCM connect: ERR invalid state(%d)\n",cm->state);
 		return DAT_INVALID_STATE;
 	}
 	
 	if (cm->retries == cm->hca->ib_trans.retries) {
 		dapl_log(DAPL_DBG_TYPE_ERR, 
-			" CM_REQ: RETRIES EXHAUSTED:"
+			"UCM connect: REQ RETRIES EXHAUSTED:"
 			 " 0x%x %x 0x%x -> 0x%x %x 0x%x\n",
 			 htons(cm->msg.saddr.ib.lid), 
 			 htonl(cm->msg.saddr.ib.qpn), 
-			 htons(cm->msg.sport), 
+			 UCM_PORT_NTOH(cm->msg.sportx,cm->msg.sport),
 			 htons(cm->msg.daddr.ib.lid), 
 			 htonl(cm->msg.dqpn), 
-			 htons(cm->msg.dport));
+			 UCM_PORT_NTOH(cm->msg.dportx,cm->msg.dport));
 
 		dapl_os_unlock(&cm->lock);
 
@@ -1141,10 +1526,10 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 
 bail:
 	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR);
-	dapl_log(DAPL_DBG_TYPE_WARN, 
-		 " connect: snd ERR -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
+	dapl_log(DAPL_DBG_TYPE_ERR,
+		 "UCM connect: snd ERR -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
 		 htons(cm->msg.daddr.ib.lid),
-		 htonl(cm->msg.dqpn), htons(cm->msg.dport), 
+		 htonl(cm->msg.dqpn), UCM_PORT_NTOH(cm->msg.dportx,cm->msg.dport),
 		 htons(cm->msg.p_size));
 
 	dapli_cm_free(cm);
@@ -1156,21 +1541,9 @@ bail:
  */
 static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 {
-	DAPL_OS_TIMEVAL time;
 	DAPL_EP *ep = cm->ep;
 	ib_cm_events_t event = IB_CME_CONNECTED;
 
-	dapl_os_get_time(&time);
-
-	if (((time - cm->timer)/1000) >= (cm->hca->ib_trans.rep_time * 5))
-		dapl_log(DAPL_DBG_TYPE_CM_WARN,
-			 " CM_REP_IN: Reply delayed %d ms: %x %x %x %x <- %x %x %x %x\n",
-			 (time - cm->timer)/1000,
-			 ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
-			 ntohl(cm->msg.sqpn), ntohl(msg->daddr.ib.qpn),
-			 ntohs(msg->saddr.ib.lid), ntohs(msg->sport),
-			 ntohl(cm->msg.dqpn), ntohl(msg->saddr.ib.qpn));
-
 	dapl_os_lock(&cm->lock);
 	if (cm->state != DCM_REP_PENDING) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
@@ -1179,7 +1552,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			 dapl_cm_op_str(ntohs(msg->op)), 
 			 dapl_cm_state_str(cm->state), 
 			 ntohs(msg->saddr.ib.lid), ntohl(msg->saddr.ib.qpn), 
-			 ntohs(msg->sport));
+			 UCM_PORT_NTOH(msg->sportx, msg->sport));
 		dapl_os_unlock(&cm->lock);
 		return;
 	}
@@ -1201,7 +1574,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				 dapl_cm_state_str(cm->state), 
 				 ntohs(msg->saddr.ib.lid), 
 				 ntohl(msg->saddr.ib.qpn), 
-				 ntohs(msg->sport));
+				 UCM_PORT_NTOH(msg->sportx, msg->sport));
 			dapl_os_unlock(&cm->lock);
 			goto bail;
 		}
@@ -1214,7 +1587,8 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		     " iqp=%x, qp_type=%d, port=%x psize=%d\n",
 		     ntohs(cm->msg.daddr.ib.lid),
 		     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type,
-		     ntohs(msg->sport), ntohs(msg->p_size));
+		     UCM_PORT_NTOH(msg->sportx, msg->sport),
+		     ntohs(msg->p_size));
 
 	if (ntohs(msg->op) == DCM_REP)
 		event = IB_CME_CONNECTED;
@@ -1228,11 +1602,14 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			 dapl_cm_op_str(ntohs(msg->op)),
 			 dapl_cm_state_str(cm->state),
 			 ntohs(msg->daddr.ib.lid), ntohl(msg->daddr.ib.qpn),
-			 ntohs(msg->dport), ntohs(msg->saddr.ib.lid),
-			 ntohl(msg->saddr.ib.qpn), ntohs(msg->sport));
+			 UCM_PORT_NTOH(msg->dportx, msg->dport),
+			 ntohs(msg->saddr.ib.lid),
+			 ntohl(msg->saddr.ib.qpn),
+			 UCM_PORT_NTOH(msg->sportx, msg->sport));
 		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR_REJ_RX);
 		event = IB_CME_DESTINATION_REJECT;
 	}
+
 	if (event != IB_CME_CONNECTED) {
 		dapl_log(DAPL_DBG_TYPE_CM, 
 			 " ACTIVE: CM_REQ REJECTED:"
@@ -1241,22 +1618,22 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			 dapl_cm_op_str(ntohs(msg->op)), 
 			 dapl_cm_state_str(cm->state), 
 			 ntohs(msg->daddr.ib.lid), ntohl(msg->daddr.ib.qpn), 
-			 ntohs(msg->dport), ntohs(msg->saddr.ib.lid), 
-			 ntohl(msg->saddr.ib.qpn), ntohs(msg->sport));
+			 UCM_PORT_NTOH(msg->dportx, msg->dport),
+			 ntohs(msg->saddr.ib.lid),
+			 ntohl(msg->saddr.ib.qpn),
+			 UCM_PORT_NTOH(msg->sportx, msg->sport));
 
 		cm->state = DCM_REJECTED;
 		dapl_os_unlock(&cm->lock);
 
-#ifdef DAT_EXTENSIONS
 		if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD) 
 			goto ud_bail;
 		else
-#endif
-		goto bail;
+			goto bail;
 	}
 	dapl_os_unlock(&cm->lock);
 
-        /* rdma_out, initiator, cannot exceed remote rdma_in max */
+	/* rdma_out, initiator, cannot exceed remote rdma_in max */
 	if (ntohs(cm->msg.ver) >= 7)
 		cm->ep->param.ep_attr.max_rdma_read_out =
 				DAPL_MIN(cm->ep->param.ep_attr.max_rdma_read_out,
@@ -1294,7 +1671,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	
 	/* Send RTU, no private data */
 	cm->msg.op = htons(DCM_RTU);
-	
+
 	dapl_os_lock(&cm->lock);
 	cm->state = DCM_CONNECTED;
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0)) {
@@ -1304,61 +1681,57 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	dapl_os_unlock(&cm->lock);
 	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_RTU_TX);
 
-	/* init cm_handle and post the event with private data */
-	dapl_dbg_log(DAPL_DBG_TYPE_EP, " ACTIVE: connected!\n");
-
 #ifdef DAT_EXTENSIONS
 ud_bail:
 	if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD) {
 		DAT_IB_EXTENSION_EVENT_DATA xevent;
 		uint16_t lid = ntohs(cm->msg.daddr.ib.lid);
 		
-		/* post EVENT, modify_qp, AH already created, ucm msg */
-		xevent.status = 0;
-		xevent.context.as_ptr = cm;
-		xevent.type = DAT_IB_UD_REMOTE_AH;
-		xevent.remote_ah.qpn = ntohl(cm->msg.daddr.ib.qpn);
-		xevent.remote_ah.ah = dapls_create_ah(cm->hca, 
-						      cm->ep->qp_handle->qp->pd,
-						      cm->ep->qp_handle->qp,
-						      htons(lid), 
-						      NULL);
-		if (xevent.remote_ah.ah == NULL) {
-			dapl_log(DAPL_DBG_TYPE_ERR,
-				 " active UD RTU: ERR create_ah"
-				 " for qpn 0x%x lid 0x%x\n",
-				 xevent.remote_ah.qpn, lid);
-			event = IB_CME_LOCAL_FAILURE;
-			goto bail;
-		}
-		cm->ah = xevent.remote_ah.ah; /* keep ref to destroy */
-
-		dapl_os_memcpy(&xevent.remote_ah.ia_addr,
-			       &cm->msg.daddr,
-			       sizeof(union dcm_addr));
-
-		/* remote ia_addr reference includes ucm qpn, not IB qpn */
-		((union dcm_addr*)
-			&xevent.remote_ah.ia_addr)->ib.qpn = cm->msg.dqpn;
-
-		dapl_dbg_log(DAPL_DBG_TYPE_EP,
-			     " ACTIVE: UD xevent ah %p qpn %x lid %x\n",
-			     xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
-		dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     	     " ACTIVE: UD xevent ia_addr qp_type %d"
-			     " lid 0x%x qpn 0x%x gid 0x"F64x" 0x"F64x" \n",
-			     ((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.qp_type,
-			     ntohs(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.lid),
-			     ntohl(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.qpn),
-			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
-			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
+		if (event == IB_CME_CONNECTED) {
+			struct ibv_ah **r_ah = cm->ep->qp_handle->ah;
 
-		if (event == IB_CME_CONNECTED)
+			/* post EVENT, modify_qp, AH already created?, ucm msg */
+			xevent.status = 0;
+			xevent.context.as_ptr = cm;
+			xevent.type = DAT_IB_UD_REMOTE_AH;
+			xevent.remote_ah.qpn = ntohl(cm->msg.daddr.ib.qpn);
+			if (!r_ah[lid]) {
+				r_ah[lid] = dapls_create_ah(cm->hca,
+							    cm->ep->qp_handle->qp->pd,
+					                    cm->ep->qp_handle->qp,
+						            htons(lid), NULL);
+				if (r_ah[lid] == NULL) {
+					dapl_log(DAPL_DBG_TYPE_ERR,
+						 " ACTIVE: UD RTU: ERR create_ah"
+						 " for qpn 0x%x lid 0x%x\n",
+						 xevent.remote_ah.qpn, lid);
+					event = IB_CME_LOCAL_FAILURE;
+					goto bail;
+				}
+			}
+			xevent.remote_ah.ah = r_ah[lid];
+
+			dapl_os_memcpy(&xevent.remote_ah.ia_addr,
+				       &cm->msg.daddr,
+				       sizeof(union dcm_addr));
+
+			/* remote ia_addr reference includes ucm qpn, not IB qpn */
+			((union dcm_addr*)&xevent.remote_ah.ia_addr)->ib.qpn = cm->msg.dqpn;
+
+			dapl_dbg_log(DAPL_DBG_TYPE_EP,
+				     " ACTIVE: UD xevent ah %p qpn %x lid %x\n",
+				     xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
+			dapl_dbg_log(DAPL_DBG_TYPE_EP,
+				     " ACTIVE: UD xevent ia_addr qp_type %d"
+				     " lid 0x%x qpn 0x%x\n",
+				     ((union dcm_addr*)
+					&xevent.remote_ah.ia_addr)->ib.qp_type,
+				     ntohs(((union dcm_addr*)
+					&xevent.remote_ah.ia_addr)->ib.lid),
+				     ntohl(((union dcm_addr*)
+					&xevent.remote_ah.ia_addr)->ib.qpn));
 			event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
-		else {
+		} else {
 			xevent.type = DAT_IB_UD_CONNECT_REJECT;
 			event = DAT_IB_UD_CONNECTION_REJECT_EVENT;
 		}
@@ -1371,11 +1744,12 @@ ud_bail:
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
 
-		if (event != (ib_cm_events_t)DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED)
+		if (event != (ib_cm_events_t)DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED) {
 			dapli_cm_free(cm);
+			return;
+		}
 
 		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_AH_RESOLVED);
-
 	} else
 #endif
 	{
@@ -1384,6 +1758,7 @@ ud_bail:
 					     IB_CME_CONNECTED,
 					     cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
 	}
+
 	dapl_log(DAPL_DBG_TYPE_CM_EST,
 		 " UCM_ACTIVE_CONN %p %d [lid port qpn] %x %x %x -> %x %x %x xevent=%d\n",
 		 cm->hca, cm->retries, ntohs(cm->msg.saddr.ib.lid),
@@ -1392,6 +1767,18 @@ ud_bail:
 		 ntohl(cm->msg.dqpn), sizeof(DAT_IB_EXTENSION_EVENT_DATA));
 	return;
 bail:
+	if (ntohs(msg->op) != DCM_REJ_USER) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " REP_in ERR: %s %s %x %x %x %x <- %x %x %x %x\n",
+			 dapl_cm_op_str(ntohs(msg->op)),
+			 dapl_cm_state_str(cm->state),
+			 ntohs(msg->daddr.ib.lid),
+			 UCM_PORT_NTOH(msg->dportx, msg->dport),
+			 ntohl(cm->msg.dqpn), ntohl(msg->daddr.ib.qpn),
+			 ntohs(msg->saddr.ib.lid),
+			 UCM_PORT_NTOH(msg->sportx, msg->sport),
+			 ntohl(cm->msg.sqpn), ntohl(msg->saddr.ib.qpn));
+	}
 	dapl_evd_connection_callback(NULL, event, cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
 	dapli_cm_free(cm);
 }
@@ -1407,19 +1794,20 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 	dp_ib_cm_handle_t acm;
 
 	/* Allocate accept CM and setup passive references */
-	if ((acm = dapls_ib_cm_create(NULL)) == NULL) {
+	if ((acm = dapls_ib_cm_create(cm->hca, NULL, NULL)) == NULL) {
 		dapl_log(DAPL_DBG_TYPE_WARN, " accept: ERR cm_create\n");
 		return;
 	}
-	dapl_os_get_time(&acm->timer); /* SVC response time */
 
 	/* dest CM info from CR msg, source CM info from listen */
 	acm->sp = cm->sp;
 	acm->hca = cm->hca;
 	acm->msg.op = msg->op;
 	acm->msg.dport = msg->sport;
+	acm->msg.dportx = msg->sportx;
 	acm->msg.dqpn = msg->sqpn;
 	acm->msg.sport = cm->msg.sport; 
+	acm->msg.sportx = cm->msg.sportx;
 	acm->msg.sqpn = cm->msg.sqpn;
 	acm->msg.p_size = msg->p_size;
 	acm->msg.d_id = msg->s_id;
@@ -1427,11 +1815,6 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 
 	/* CR saddr is CM daddr info, need EP for local saddr */
 	dapl_os_memcpy(&acm->msg.daddr, &msg->saddr, sizeof(union dcm_addr));
-	
-	dapl_log(DAPL_DBG_TYPE_CM,
-		 " accept: DST port=%x lid=%x, iqp=%x, psize=%d\n",
-		 ntohs(acm->msg.dport), ntohs(acm->msg.daddr.ib.lid), 
-		 htonl(acm->msg.daddr.ib.qpn), htons(acm->msg.p_size));
 
 	/* validate private data size before reading */
 	if (ntohs(msg->p_size) > DCM_MAX_PDATA_SIZE) {
@@ -1446,7 +1829,17 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 			       msg->p_data, ntohs(msg->p_size));
 		
 	acm->state = DCM_ACCEPTING;
-	dapli_queue_conn(acm);
+
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " accepting: op %s [id lid, port, cqp, iqp]:"
+		 " %d %x %x %x %x <- %d %x %x %x %x\n",
+		 dapl_cm_op_str(ntohs(msg->op)),
+		 ntohl(acm->msg.s_id), ntohs(msg->daddr.ib.lid),
+		 UCM_PORT_NTOH(msg->dportx, msg->dport),
+		 ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
+		 ntohl(msg->s_id), ntohs(msg->saddr.ib.lid),
+		 UCM_PORT_NTOH(msg->sportx, msg->sport),
+		 ntohl(msg->sqpn), ntohl(msg->saddr.ib.qpn));
 
 #ifdef DAT_EXTENSIONS
 	if (acm->msg.daddr.ib.qp_type == IBV_QPT_UD) {
@@ -1491,7 +1884,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			 dapl_cm_op_str(ntohs(msg->op)), 
 			 dapl_cm_state_str(cm->state), 
 			 ntohs(msg->saddr.ib.lid), ntohl(msg->saddr.ib.qpn), 
-			 ntohs(msg->sport));
+			 UCM_PORT_NTOH(msg->sportx, msg->sport));
 		dapl_os_unlock(&cm->lock);
 		goto bail;
 	}
@@ -1499,31 +1892,35 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	dapl_os_unlock(&cm->lock);
 	
 	/* final data exchange if remote QP state is good to go */
-	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: connected!\n");
+	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: Connected! RTU_in\n");
 
 #ifdef DAT_EXTENSIONS
 	if (cm->msg.saddr.ib.qp_type == IBV_QPT_UD) {
 		DAT_IB_EXTENSION_EVENT_DATA xevent;
 		uint16_t lid = ntohs(cm->msg.daddr.ib.lid);
+		struct ibv_ah **r_ah = cm->ep->qp_handle->ah;
 		
-		/* post EVENT, modify_qp, AH already created, ucm msg */
+		/* post EVENT, modify_qp, AH already created?, ucm msg */
 		xevent.status = 0;
 		xevent.context.as_ptr = cm;
 		xevent.type = DAT_IB_UD_PASSIVE_REMOTE_AH;
 		xevent.remote_ah.qpn = ntohl(cm->msg.daddr.ib.qpn);
-		xevent.remote_ah.ah = dapls_create_ah(cm->hca, 
-						      cm->ep->qp_handle->qp->pd,
-						      cm->ep->qp_handle->qp,
-						      htons(lid), 
-						      NULL);
-		if (xevent.remote_ah.ah == NULL) {
-			dapl_log(DAPL_DBG_TYPE_ERR,
-				 " passive UD RTU: ERR create_ah"
-				 " for qpn 0x%x lid 0x%x\n",
-				 xevent.remote_ah.qpn, lid);
-			goto bail;
+		if (!r_ah[lid]) {
+			r_ah[lid] = dapls_create_ah(cm->hca,
+						    cm->ep->qp_handle->qp->pd,
+						    cm->ep->qp_handle->qp,
+						    htons(lid), NULL);
+
+			if (r_ah[lid] == NULL) {
+				dapl_log(DAPL_DBG_TYPE_ERR,
+					 " PASSIVE: UD RTU: ERR create_ah"
+					 " for qpn 0x%x lid 0x%x\n",
+					 xevent.remote_ah.qpn, lid);
+				goto bail;
+			}
 		}
-		cm->ah = xevent.remote_ah.ah; /* keep ref to destroy */
+		xevent.remote_ah.ah = r_ah[lid];
+
 		dapl_os_memcpy(&xevent.remote_ah.ia_addr,
 			       &cm->msg.daddr,
 			        sizeof(union dcm_addr));
@@ -1536,15 +1933,13 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			     xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
 		     	     " PASSIVE: UD xevent ia_addr qp_type %d"
-			     " lid 0x%x qpn 0x%x gid 0x"F64x" 0x"F64x" \n",
+			     " lid 0x%x qpn 0x%x \n",
 			     ((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.qp_type,
 			     ntohs(((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.lid),
 			     ntohl(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.qpn),
-			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
-			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
+				&xevent.remote_ah.ia_addr)->ib.qpn));
 
 		dapls_evd_post_connection_event_ext(
 				(DAPL_EVD *)cm->ep->param.connect_evd_handle,
@@ -1561,14 +1956,25 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_PASSIVE_EST);
 		dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
 	}
+
 	dapl_log(DAPL_DBG_TYPE_CM_EST,
 		 " UCM_PASSIVE_CONN %p %d [lid port qpn] %x %x %x <- %x %x %x\n",
 		 cm->hca, cm->retries, ntohs(cm->msg.saddr.ib.lid),
-		 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
-		 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+		 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+		 ntohl(cm->msg.saddr.ib.qpn),
+		 ntohs(cm->msg.daddr.ib.lid),
+		 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 		 ntohl(cm->msg.dqpn));
 	return;
 bail:
+	dapl_log(DAPL_DBG_TYPE_CM_WARN,
+		 " RTU_in: ERR %d ms: %x %x %x <- %x %x %x\n",
+		 ntohs(cm->msg.saddr.ib.lid),
+		 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+		 ntohl(cm->msg.saddr.ib.qpn),
+		 ntohs(cm->msg.daddr.ib.lid),
+		 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
+		 ntohl(cm->msg.dqpn));
 	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm->hca->ia_list_head)), DCNT_IA_CM_ERR);
 	dapls_cr_callback(cm, IB_CME_LOCAL_FAILURE, NULL, 0, cm->sp);
 	dapli_cm_free(cm);
@@ -1587,10 +1993,10 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 			 cm->ep, cm, dapl_cm_state_str(cm->state),
 			 cm->ref_count,
 			 htons(cm->msg.saddr.ib.lid),
-			 htons(cm->msg.sport),
+			 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 			 htonl(cm->msg.saddr.ib.qpn),
 			 htons(cm->msg.daddr.ib.lid),
-			 htons(cm->msg.dport),
+			 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 			 htonl(cm->msg.daddr.ib.qpn),
 			 ntohl(cm->msg.s_id),
 			 ntohl(cm->msg.d_id));
@@ -1603,10 +2009,10 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 			" CM_REPLY: RETRIES EXHAUSTED (lid port qpn)"
 			 " %x %x %x -> %x %x %x\n",
 			 htons(cm->msg.saddr.ib.lid), 
-			 htons(cm->msg.sport), 
+			 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 			 htonl(cm->msg.saddr.ib.qpn), 
 			 htons(cm->msg.daddr.ib.lid), 
-			 htons(cm->msg.dport), 
+			 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 			 htonl(cm->msg.daddr.ib.qpn));
 			
 		dapl_os_unlock(&cm->lock);
@@ -1638,7 +2044,6 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 					  NULL, 0, cm->sp);
 		return -1;
 	}
-
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) {
 		dapl_log(DAPL_DBG_TYPE_ERR," accept ERR: ucm reply send()\n");
 		dapl_os_unlock(&cm->lock);
@@ -1659,23 +2064,10 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 {
 	DAPL_IA *ia = ep->header.owner_ia;
 	dp_ib_cm_handle_t cm = cr->ib_cm_handle;
-	DAPL_OS_TIMEVAL time;
 
 	if (p_size > DCM_MAX_PDATA_SIZE)
 		return DAT_LENGTH_ERROR;
 
-	dapl_os_get_time(&time);
-
-	if (((time - cm->timer)/1000) >= (cm->hca->ib_trans.rep_time * 5)) {
-		dapl_log(DAPL_DBG_TYPE_CM_WARN,
-			 " CM_REP_OUT: Accept delayed %d ms: %x %x %x %x -> %x %x %x %x\n",
-			 (time - cm->timer)/1000,
-			 htons(cm->hca->ib_trans.addr.ib.lid), htons(cm->msg.sport),
-			 ntohl(cm->msg.sqpn), htonl(ep->qp_handle->qp->qp_num),
-			 htons(cm->msg.daddr.ib.lid), htons(cm->msg.dport),
-			 ntohl(cm->msg.dqpn), htonl(cm->msg.daddr.ib.qpn));
-	}
-
 	dapl_os_lock(&cm->lock);
 	if (cm->state != DCM_ACCEPTING) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
@@ -1684,10 +2076,10 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 			 cm->ep, cm, dapl_cm_state_str(cm->state),
 			 cm->ref_count,
 			 htons(cm->hca->ib_trans.addr.ib.lid),
-			 htons(cm->msg.sport),
+			 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
 			 htonl(ep->qp_handle->qp->qp_num),
 			 htons(cm->msg.daddr.ib.lid),
-			 htons(cm->msg.dport),
+			 UCM_PORT_NTOH(cm->msg.dportx, cm->msg.dport),
 			 htonl(cm->msg.daddr.ib.qpn),
 			 ntohl(cm->msg.s_id),
 			 ntohl(cm->msg.d_id));
@@ -1697,19 +2089,13 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_os_unlock(&cm->lock);
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " ACCEPT_USR: remote lid=%x"
+		     " ACCEPT_USR: s_id %d r_id %d lid=%x"
 		     " iqp=%x qp_type %d, psize=%d\n",
+		     ntohl(cm->msg.s_id), ntohl(cm->msg.d_id),
 		     ntohs(cm->msg.daddr.ib.lid),
 		     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type, 
 		     p_size);
 
-	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " ACCEPT_USR: remote GID subnet %016llx id %016llx\n",
-		     (unsigned long long)
-		     htonll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
-		     (unsigned long long)
-		     htonll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
-
 #ifdef DAT_EXTENSIONS
 	if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD &&
 	    ep->qp_handle->qp->qp_type != IBV_QPT_UD) {
@@ -1719,8 +2105,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		return (DAT_INVALID_HANDLE | DAT_INVALID_HANDLE_EP);
 	}
 #endif
-
-        /* rdma_out, initiator, cannot exceed remote rdma_in max */
+	/* rdma_out, initiator, cannot exceed remote rdma_in max */
 	if (ntohs(cm->msg.ver) >= 7)
 		ep->param.ep_attr.max_rdma_read_out =
 				DAPL_MIN(ep->param.ep_attr.max_rdma_read_out,
@@ -1729,7 +2114,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	/* modify QP to RTR and then to RTS with remote info already read */
 	dapl_os_lock(&ep->header.lock);
 	if (dapls_modify_qp_state(ep->qp_handle->qp,
-				  IBV_QPS_RTR, 
+				  IBV_QPS_RTR,
 				  cm->msg.daddr.ib.qpn,
 				  cm->msg.daddr.ib.lid,
 				  (ib_gid_handle_t)cm->msg.daddr.ib.gid) != DAT_SUCCESS) {
@@ -1741,7 +2126,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		goto bail;
 	}
 	if (dapls_modify_qp_state(ep->qp_handle->qp,
-				  IBV_QPS_RTS, 
+				  IBV_QPS_RTS,
 				  cm->msg.daddr.ib.qpn,
 				  cm->msg.daddr.ib.lid,
 				  NULL) != DAT_SUCCESS) {
@@ -1793,7 +2178,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_os_unlock(&cm->lock);
 
 	DAPL_CNTR(ia, DCNT_IA_CM_REP_TX);
-	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
+	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: Accepted - REP_out\n");
 	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	return DAT_SUCCESS;
 bail:
@@ -1833,16 +2218,19 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 	DAPL_EP *ep = (DAPL_EP *)ep_handle;
 	dp_ib_cm_handle_t cm;
 	union dcm_addr *ucm_ia = (union dcm_addr *) r_addr;
+	uint16_t sid = (uint16_t)(r_psp & UCM_SID_MASK);
 
-	dapl_log(DAPL_DBG_TYPE_CM, " UCM connect -> AF %d LID 0x%x QPN 0x%x GID"
-		 " 0x" F64x ":" F64x " port %d sl %d qt %d\n",
-		 ucm_ia->ib.family, ntohs(ucm_ia->ib.lid), ntohl(ucm_ia->ib.qpn),
-		 (unsigned long long)ntohll(*(uint64_t*)&ucm_ia->ib.gid[0]),
-		 (unsigned long long)ntohll(*(uint64_t*)&ucm_ia->ib.gid[8]),
-		 ntohs(ucm_ia->ib.port), ucm_ia->ib.sl, ucm_ia->ib.qp_type);
-	
-	/* create CM object, initialize SRC info from EP */
-	cm = dapls_ib_cm_create(ep);
+	if (sid == 0) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " connect: ERR port_map, AF %d LID 0x%x QPN 0x%x"
+			 " sl %d qpt %d r_psp %"PRIx64"-> r_port %x\n",
+			  ucm_ia->ib.family, ntohs(ucm_ia->ib.lid),
+			 ntohl(ucm_ia->ib.qpn), ucm_ia->ib.sl,
+			 ucm_ia->ib.qp_type, r_psp, sid);
+		return DAT_INVALID_ADDRESS;
+	}
+	/* create CM object, initialize SRC info from EP, get sport, link to ep */
+	cm = dapls_ib_cm_create(ep->header.owner_ia->hca_ptr, ep, NULL);
 	if (cm == NULL)
 		return DAT_INSUFFICIENT_RESOURCES;
 
@@ -1850,7 +2238,8 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 	dapl_os_memcpy(&cm->msg.daddr, r_addr, sizeof(union dcm_addr));
 
 	/* remote uCM information, comes from consumer provider r_addr */
-	cm->msg.dport = htons((uint16_t)r_psp);
+	cm->msg.dport = (uint16_t)htons(UCM_PORT(sid));
+	cm->msg.dportx = 0;
 	cm->msg.dqpn = cm->msg.daddr.ib.qpn;
 	cm->msg.daddr.ib.qpn = 0; /* don't have a remote qpn until reply */
 	
@@ -1861,12 +2250,15 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 		cm->msg.p_size = htons(p_size);
 		dapl_os_memcpy(&cm->msg.p_data, p_data, p_size);
 	}
-	
-	cm->state = DCM_INIT;
-
-	/* link EP and CM, put on work queue */
-	dapli_queue_conn(cm);
 
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " connect: l_port %d -> AF %d LID 0x%x QPN 0x%x"
+		 " sl %d qpt %d r_psp %"PRIx64"-> r_port %x\n",
+		 UCM_PORT_NTOH(cm->msg.sportx, cm->msg.sport),
+		 ucm_ia->ib.family, ntohs(ucm_ia->ib.lid),
+		 ntohl(ucm_ia->ib.qpn), ucm_ia->ib.sl,
+		 ucm_ia->ib.qp_type, r_psp, sid);
+	
 	dapl_os_get_time(&cm->timer); /* REP expected */
 
 	/* build connect request, send to remote CM based on r_addr info */
@@ -1968,45 +2360,47 @@ dapls_ib_disconnect_clean(IN DAPL_EP *ep,
  */
 DAT_RETURN
 dapls_ib_setup_conn_listener(IN DAPL_IA *ia, 
-			     IN DAT_UINT64 sid, 
+			     IN DAT_CONN_QUAL r_psp,
 			     IN DAPL_SP *sp)
 {
 	ib_cm_srvc_handle_t cm = NULL;
+	uint16_t sid = (uint16_t)(r_psp & UCM_SID_MASK);
 
-	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " listen(ia %p ServiceID %x sp %p)\n",
-		     ia, sid, sp);
-
-	/* reserve local port, then allocate CM object */
-	if (!ucm_get_port(&ia->hca_ptr->ib_trans, (uint16_t)sid)) {
-		dapl_dbg_log(DAPL_DBG_TYPE_WARN,
-			     " listen: ERROR %s on conn_qual %x\n",
-			     strerror(errno), sid);
-		return DAT_CONN_QUAL_IN_USE;
+	if (sid == 0) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " listen ERR: port_map: qpn %x psp %"PRIx64"-> sid %x)\n",
+			 ia->hca_ptr->ib_trans.qp->qp_num, r_psp, sid);
+		return DAT_INVALID_PARAMETER;
 	}
 
-	/* cm_create will setup saddr for listen server */
-	if ((cm = dapls_ib_cm_create(NULL)) == NULL)
-		return DAT_INSUFFICIENT_RESOURCES;
+	/* cm_create will setup saddr for listen server and reserve port */
+	if ((cm = dapls_ib_cm_create(ia->hca_ptr, NULL, &sid)) == NULL) {
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " listen: ERROR %s on conn_qual %"PRIx64"-> sid %x\n",
+			 strerror(errno), r_psp, sid);
+
+		if (errno == -EADDRINUSE)
+			return DAT_CONN_QUAL_IN_USE;
+		else
+			return DAT_INSUFFICIENT_RESOURCES;
+	}
 
 	/* LISTEN: init DST address and QP info to local CM server info */
-	cm->sp = sp;
 	cm->hca = ia->hca_ptr;
-	cm->msg.sport = htons((uint16_t)sid);
+	cm->sp = sp;
 	cm->msg.sqpn = htonl(ia->hca_ptr->ib_trans.qp->qp_num);
 	cm->msg.saddr.ib.qp_type = IBV_QPT_UD;
         cm->msg.saddr.ib.lid = ia->hca_ptr->ib_trans.addr.ib.lid; 
 	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
 		       &cm->hca->ib_trans.addr.ib.gid, 16); 
 	
+	dapl_log(DAPL_DBG_TYPE_CM,
+		" listen(ia %p sp %p qpn %x - psp %"PRIx64"-> sid %x)\n",
+		ia, sp, ia->hca_ptr->ib_trans.qp->qp_num, r_psp, sid);
+
 	/* save cm_handle reference in service point */
 	sp->cm_srvc_handle = cm;
-
-	/* queue up listen socket to process inbound CR's */
-	cm->state = DCM_LISTEN;
-	dapli_queue_listen(cm);
 	DAPL_CNTR(ia, DCNT_IA_CM_LISTEN);
-
 	return DAT_SUCCESS;
 }
 
@@ -2036,12 +2430,11 @@ dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
 	/* free cm_srvc_handle and port, and mark CM for cleanup */
 	if (cm) {
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " remove_listener(ia %p sp %p cm %p psp=%x)\n",
-		     ia, sp, cm, ntohs(cm->msg.dport));
+		     " remove_listener(ia %p sp %p cm %p psp=0x%02x%x)\n",
+		     ia, sp, cm, cm->msg.sportx, ntohs(cm->msg.sport));
 
 		sp->cm_srvc_handle = NULL;
-		dapli_dequeue_listen(cm);  
-		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
+		dapli_dequeue_listen(cm);  /* dequeue and free port */
 		dapls_cm_release(cm);  /* last ref, dealloc */
 	}
 	return DAT_SUCCESS;
@@ -2123,14 +2516,16 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
 	dapl_os_lock(&cm->lock);
 	dapl_log(DAPL_DBG_TYPE_CM, 
 		 " PASSIVE: REJECTING CM_REQ:"
-		 " cm %p op %s, st %s slid %x iqp %x port %x ->"
-		 " dlid %x iqp %x port %x\n", cm,
+		 " cm %p op %s, st %s slid %x iqp %x port %x%x ->"
+		 " dlid %x iqp %x port %x%x\n", cm,
 		 dapl_cm_op_str(ntohs(cm->msg.op)), 
 		 dapl_cm_state_str(cm->state), 
 		 ntohs(cm->hca->ib_trans.addr.ib.lid), 
 		 ntohl(cm->msg.saddr.ib.qpn), 
-		 ntohs(cm->msg.sport), ntohs(cm->msg.daddr.ib.lid), 
-		 ntohl(cm->msg.daddr.ib.qpn), ntohs(cm->msg.dport));
+		 cm->msg.sportx, ntohs(cm->msg.sport),
+		 ntohs(cm->msg.daddr.ib.lid),
+		 ntohl(cm->msg.daddr.ib.qpn),
+		 cm->msg.dportx, ntohs(cm->msg.dport));
 
 	cm->state = DCM_REJECTED;
 	cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid; 
@@ -2316,19 +2711,19 @@ void cm_thread(void *arg)
 			if (cm->state == DCM_FREE || 
 			    hca->ib_trans.cm_state != IB_THREAD_RUN) {
 				dapl_os_unlock(&cm->lock);
-				dapl_log(DAPL_DBG_TYPE_CM, 
+				dapl_log(DAPL_DBG_TYPE_CM,
 					 " CM FREE: %p ep=%p st=%s refs=%d\n", 
 					 cm, cm->ep, dapl_cm_state_str(cm->state), 
 					 cm->ref_count);
 
-				dapls_cm_release(cm); /* release alloc ref */
-				dapli_cm_dequeue(cm); /* release workq ref */
-				dapls_cm_release(cm); /* release thread ref */
+				dapls_cm_release(cm); /* alloc ref */
+				dapli_cm_dequeue(cm); /* workq ref */
+				dapls_cm_release(cm); /* thread ref */
 				continue;
 			}
 			dapl_os_unlock(&cm->lock);
 			ucm_check_timers(cm, &time_ms);
-			dapls_cm_release(cm); /* release thread ref */
+			dapls_cm_release(cm); /* thread ref */
 		}
 
 		/* set to exit and all resources destroyed */
@@ -2337,6 +2732,8 @@ void cm_thread(void *arg)
 			break;
 
 		dapl_os_unlock(&hca->ib_trans.lock);
+		sched_yield();
+
 		dapl_select(set, time_ms);
 
 		/* Process events: CM, ASYNC, NOTIFY THREAD */
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
