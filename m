From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] dapl-2.0 - ucm: modify debug CM output for consistency,
 all ports, qpn in hex
Date: Wed, 16 Jun 2010 10:21:20 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103BF242F@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Patch set for 2.0.29 release - bug fixes, PKEY/SL enhancement.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |  121 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 81 insertions(+), 40 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 94af988..806602f 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -165,9 +165,9 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                if ((time - cm->timer)/1000 >
                    (cm->hca->ib_trans.rep_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
-                                " CM_REQ retry %d [lid, port, qpn]:"
+                                " CM_REQ retry %d %p [lid, port, qpn]:"
                                 " %x %x %x -> %x %x %x Time(ms) %llu > %llu\n",
-                                cm->retries, ntohs(cm->msg.saddr.ib.lid),
+                                cm, cm->retries, ntohs(cm->msg.saddr.ib.lid),
                                 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
                                 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
                                 ntohl(cm->msg.dqpn), (time - cm->timer)/1000,
@@ -184,7 +184,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                    (cm->hca->ib_trans.rtu_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                 " CM_REPLY retry %d [lid, port, qpn]:"
-                                " %x %x %x -> %x %x %x r_pid %x,%d Time(ms) %llu > %llu\n",
+                                " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %llu\n",
                                 cm->retries,
                                 ntohs(cm->msg.saddr.ib.lid),
                                 ntohs(cm->msg.sport),
@@ -208,7 +208,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                    (cm->hca->ib_trans.rtu_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                 " CM_DREQ retry %d [lid, port, qpn]:"
-                                " %x %x %x -> %x %x %x r_pid %x,%d Time(ms) %llu > %llu\n",
+                                " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %llu\n",
                                 cm->retries,
                                 ntohs(cm->msg.saddr.ib.lid),
                                 ntohs(cm->msg.sport),
@@ -317,7 +317,7 @@ static int ucm_reject(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
        dapl_os_memcpy(&smsg.saddr, &msg->daddr, sizeof(union dcm_addr));

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
-                    " CM reject -> LID %x, QPN %x PORT %d\n",
+                    " CM reject -> LID %x, QPN %x PORT %x\n",
                     ntohs(smsg.daddr.ib.lid),
                     ntohl(smsg.dqpn), ntohs(smsg.dport));

@@ -354,7 +354,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                if (ntohs(msg->op) == DCM_REP) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                " RESEND RTU: op %s st %s [lid, port, qpn]:"
-                               " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+                               " %x %x %x -> %x %x %x\n",
                                dapl_cm_op_str(ntohs(msg->op)),
                                dapl_cm_state_str(cm->state),
                                ntohs(msg->saddr.ib.lid),
@@ -380,7 +380,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                if (ntohs(msg->op) == DCM_DREQ) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                " RESEND DREP: op %s st %s [lid, port, qpn]:"
-                               " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+                               " %x %x %x -> %x %x %x\n",
                                dapl_cm_op_str(ntohs(msg->op)),
                                dapl_cm_state_str(cm->state),
                                ntohs(msg->saddr.ib.lid),
@@ -396,7 +396,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                        /* DREP ok to ignore, any other print warning */
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                " ucm_recv: UNEXPECTED MSG on cm %p"
-                               " <- op %s, st %s spsp %d sqpn %d\n",
+                               " <- op %s, st %s spsp %x sqpn %x\n",
                                cm, dapl_cm_op_str(ntohs(msg->op)),
                                dapl_cm_state_str(cm->state),
                                ntohs(msg->sport), ntohl(msg->sqpn));
@@ -406,8 +406,9 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
        default:
                dapl_log(DAPL_DBG_TYPE_WARN,
                                " ucm_recv: UNKNOWN state"
-                               " <- op %d, %s spsp %d sqpn %d\n",
-                               ntohs(msg->op), dapl_cm_state_str(cm->state),
+                               " <- op %s, %s spsp %x sqpn %x\n",
+                               dapl_cm_op_str(ntohs(msg->op)),
+                               dapl_cm_state_str(cm->state),
                                ntohs(msg->sport), ntohl(msg->sqpn));
                dapl_os_unlock(&cm->lock);
                break;
@@ -459,8 +460,8 @@ retry_listenq:
                                /* duplicate; bail and throw away */
                                dapl_os_unlock(lock);
                                dapl_log(DAPL_DBG_TYPE_WARN,
-                                        " DUPLICATE: op %s st %s [lid, port, qpn]:"
-                                        " 0x%x %d 0x%x <- 0x%x %d 0x%x\n",
+                                        " DUPLICATE: cm %p op %s st %s [lid, port, qpn]:"
+                                        " %x %x %x <- %x %x %x\n", cm,
                                         dapl_cm_op_str(ntohs(msg->op)),
                                         dapl_cm_state_str(cm->state),
                                         ntohs(msg->daddr.ib.lid),
@@ -469,6 +470,7 @@ retry_listenq:
                                         ntohs(msg->saddr.ib.lid),
                                         ntohs(msg->sport),
                                         ntohl(msg->saddr.ib.qpn));
+
                                return NULL;
                        }
                }
@@ -484,13 +486,23 @@ retry_listenq:
        }

        /* not match on listenq for valid request, send reject */
-       if (ntohs(msg->op) == DCM_REQ && !found)
+       if (ntohs(msg->op) == DCM_REQ && !found) {
+               dapl_log(DAPL_DBG_TYPE_WARN,
+                       " ucm_recv: NO LISTENER for %s %x %x i%x c%x"
+                       " < %x %x %x, sending reject\n",
+                       dapl_cm_op_str(ntohs(msg->op)),
+                       ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
+                       ntohl(msg->daddr.ib.qpn), ntohl(msg->sqpn),
+                       ntohs(msg->saddr.ib.lid), ntohs(msg->sport),
+                       ntohl(msg->saddr.ib.qpn));
+
                ucm_reject(tp, msg);
+       }

        if (!found) {
                dapl_log(DAPL_DBG_TYPE_WARN,
-                       " ucm_recv: NO MATCH op %s 0x%x %d i0x%x c0x%x"
-                       " < 0x%x %d 0x%x\n",
+                       " ucm_recv: NO MATCH op %s %x %x i%x c%x"
+                       " < %x %x %x\n",
                        dapl_cm_op_str(ntohs(msg->op)),
                        ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
                        ntohl(msg->daddr.ib.qpn), ntohl(msg->sqpn),
@@ -593,8 +605,9 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
         sge.addr = (uintptr_t)smsg;

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
-               " ucm_send: op %d ln %d lid %x c_qpn %x rport %d\n",
-               ntohs(smsg->op), sge.length, htons(smsg->daddr.ib.lid),
+               " ucm_send: op %s ln %d lid %x c_qpn %x rport %s\n",
+               dapl_cm_op_str(ntohs(smsg->op)),
+               sge.length, htons(smsg->daddr.ib.lid),
                htonl(smsg->dqpn), htons(smsg->dport));

        /* empty slot, then create AH */
@@ -842,7 +855,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
                if (cm->retries >= cm->hca->ib_trans.retries) {
                        dapl_log(DAPL_DBG_TYPE_ERR,
                                " CM_DREQ: RETRIES EXHAUSTED:"
-                               " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+                               " %x %x %x -> %x %x %x\n",
                                htons(cm->msg.saddr.ib.lid),
                                htonl(cm->msg.saddr.ib.qpn),
                                htons(cm->msg.sport),
@@ -866,7 +879,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
        default:
                dapl_log(DAPL_DBG_TYPE_WARN,
                        "  disconnect UNKNOWN state: ep %p cm %p %s %s"
-                       "  %x %x %x %s %x %x %x r_pid %x,%d\n",
+                       "  %x %x %x %s %x %x %x r_pid %x (%x)\n",
                        cm->ep, cm,
                        cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
                        dapl_cm_state_str(cm->state),
@@ -905,8 +918,8 @@ DAT_RETURN
 dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 {
        dapl_log(DAPL_DBG_TYPE_EP,
-                " connect: lid %x i_qpn %x lport %d p_sz=%d -> "
-                " lid %x c_qpn %x rport %d\n",
+                " connect: lid %x i_qpn %x lport %x p_sz=%d -> "
+                " lid %x c_qpn %x rport %x\n",
                 htons(cm->msg.saddr.ib.lid), htonl(cm->msg.saddr.ib.qpn),
                 htons(cm->msg.sport), htons(cm->msg.p_size),
                 htons(cm->msg.daddr.ib.lid), htonl(cm->msg.dqpn),
@@ -921,7 +934,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
        if (cm->retries == cm->hca->ib_trans.retries) {
                dapl_log(DAPL_DBG_TYPE_ERR,
                        " CM_REQ: RETRIES EXHAUSTED:"
-                        " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+                        " 0x%x %x 0x%x -> 0x%x %x 0x%x\n",
                         htons(cm->msg.saddr.ib.lid),
                         htonl(cm->msg.saddr.ib.qpn),
                         htons(cm->msg.sport),
@@ -962,7 +975,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)

 bail:
        dapl_log(DAPL_DBG_TYPE_WARN,
-                " connect: ERR %s -> cm_lid %d cm_qpn %d r_psp %d p_sz=%d\n",
+                " connect: ERR %s -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
                 strerror(errno), htons(cm->msg.daddr.ib.lid),
                 htonl(cm->msg.dqpn), htons(cm->msg.dport),
                 htonl(cm->msg.p_size));
@@ -983,8 +996,9 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
        if (cm->state != DCM_REP_PENDING) {
                dapl_log(DAPL_DBG_TYPE_WARN,
                         " CONN_RTU: UNEXPECTED state:"
-                        " op %d, st %s <- lid %d sqpn %d sport %d\n",
-                        ntohs(msg->op), dapl_cm_state_str(cm->state),
+                        " op %s, st %s <- lid %x sqpn %x sport %x\n",
+                        dapl_cm_op_str(ntohs(msg->op)),
+                        dapl_cm_state_str(cm->state),
                         ntohs(msg->saddr.ib.lid), ntohl(msg->saddr.ib.qpn),
                         ntohs(msg->sport));
                dapl_os_unlock(&cm->lock);
@@ -1002,7 +1016,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
                if (ntohs(msg->p_size) > DCM_MAX_PDATA_SIZE) {
                        dapl_log(DAPL_DBG_TYPE_WARN,
                                 " CONN_RTU: invalid p_size %d:"
-                                " st %s <- lid %d sqpn %d spsp %d\n",
+                                " st %s <- lid %x sqpn %x spsp %x\n",
                                 ntohs(msg->p_size),
                                 dapl_cm_state_str(cm->state),
                                 ntohs(msg->saddr.ib.lid),
@@ -1017,7 +1031,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)

        dapl_dbg_log(DAPL_DBG_TYPE_CM,
                     " CONN_RTU: DST lid=%x,"
-                    " iqp=%x, qp_type=%d, port=%d psize=%d\n",
+                    " iqp=%x, qp_type=%d, port=%x psize=%d\n",
                     ntohs(cm->msg.daddr.ib.lid),
                     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type,
                     ntohs(msg->sport), ntohs(msg->p_size));
@@ -1030,6 +1044,16 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
                event = IB_CME_DESTINATION_REJECT;

        if (event != IB_CME_CONNECTED) {
+               dapl_log(DAPL_DBG_TYPE_CM,
+                        " ACTIVE: CM_REQ REJECTED:"
+                        " cm %p op %s, st %s dlid %x iqp %x port %x <-"
+                        " slid %x iqp %x port %x\n", cm,
+                        dapl_cm_op_str(ntohs(msg->op)),
+                        dapl_cm_state_str(cm->state),
+                        ntohs(msg->daddr.ib.lid), ntohl(msg->daddr.ib.qpn),
+                        ntohs(msg->dport), ntohs(msg->saddr.ib.lid),
+                        ntohl(msg->saddr.ib.qpn), ntohs(msg->sport));
+
                cm->state = DCM_REJECTED;
                dapl_os_unlock(&cm->lock);

@@ -1115,7 +1139,7 @@ ud_bail:
                        &xevent.remote_ah.ia_addr)->ib.qpn = cm->msg.dqpn;

                dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                            " ACTIVE: UD xevent ah %p qpn 0x%x lid 0x%x\n",
+                            " ACTIVE: UD xevent ah %p qpn %x lid %x\n",
                             xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
                dapl_dbg_log(DAPL_DBG_TYPE_EP,
                             " ACTIVE: UD xevent ia_addr qp_type %d"
@@ -1175,6 +1199,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
        /* dest CM info from CR msg, source CM info from listen */
        acm->sp = cm->sp;
        acm->hca = cm->hca;
+       acm->msg.op = msg->op;
        acm->msg.dport = msg->sport;
        acm->msg.dqpn = msg->sqpn;
        acm->msg.sport = cm->msg.sport;
@@ -1185,7 +1210,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
        dapl_os_memcpy(&acm->msg.daddr, &msg->saddr, sizeof(union dcm_addr));

        dapl_log(DAPL_DBG_TYPE_CM,
-                " accept: DST port=%d lid=%x, iqp=%x, psize=%d\n",
+                " accept: DST port=%x lid=%x, iqp=%x, psize=%d\n",
                 ntohs(acm->msg.dport), ntohs(acm->msg.daddr.ib.lid),
                 htonl(acm->msg.daddr.ib.qpn), htons(acm->msg.p_size));

@@ -1241,8 +1266,9 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
        if ((ntohs(msg->op) != DCM_RTU) || (cm->state != DCM_RTU_PENDING)) {
                dapl_log(DAPL_DBG_TYPE_WARN,
                         " accept_rtu: UNEXPECTED op, state:"
-                        " op %d, st %s <- lid %x iqp %x sport %d\n",
-                        ntohs(msg->op), dapl_cm_state_str(cm->state),
+                        " op %s, st %s <- lid %x iqp %x sport %x\n",
+                        dapl_cm_op_str(ntohs(msg->op)),
+                        dapl_cm_state_str(cm->state),
                         ntohs(msg->saddr.ib.lid), ntohl(msg->saddr.ib.qpn),
                         ntohs(msg->sport));
                dapl_os_unlock(&cm->lock);
@@ -1285,7 +1311,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
                        &xevent.remote_ah.ia_addr)->ib.qpn = cm->msg.dqpn;

                dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                            " PASSIVE: UD xevent ah %p qpn 0x%x lid 0x%x\n",
+                            " PASSIVE: UD xevent ah %p qpn %x lid %x\n",
                             xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
                dapl_dbg_log(DAPL_DBG_TYPE_EP,
                             " PASSIVE: UD xevent ia_addr qp_type %d"
@@ -1332,8 +1358,8 @@ static int ucm_reply(dp_ib_cm_handle_t cm)

        if (cm->retries == cm->hca->ib_trans.retries) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CM_REPLY: RETRIES EXHAUSTED"
-                        " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+                       " CM_REPLY: RETRIES EXHAUSTED (lid port qpn)"
+                        " %x %x %x -> %x %x %x\n",
                         htons(cm->msg.saddr.ib.lid),
                         htons(cm->msg.sport),
                         htonl(cm->msg.saddr.ib.qpn),
@@ -1661,13 +1687,13 @@ dapls_ib_setup_conn_listener(IN DAPL_IA *ia,
        ib_cm_srvc_handle_t cm = NULL;

        dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    " listen(ia %p ServiceID %d sp %p)\n",
+                    " listen(ia %p ServiceID %x sp %p)\n",
                     ia, sid, sp);

        /* reserve local port, then allocate CM object */
        if (!ucm_get_port(&ia->hca_ptr->ib_trans, (uint16_t)sid)) {
                dapl_dbg_log(DAPL_DBG_TYPE_WARN,
-                            " listen: ERROR %s on conn_qual 0x%x\n",
+                            " listen: ERROR %s on conn_qual %x\n",
                             strerror(errno), sid);
                return DAT_CONN_QUAL_IN_USE;
        }
@@ -1722,7 +1748,7 @@ dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
        /* free cm_srvc_handle and port, and mark CM for cleanup */
        if (cm) {
                dapl_dbg_log(DAPL_DBG_TYPE_EP,
-                    " remove_listener(ia %p sp %p cm %p psp=%d)\n",
+                    " remove_listener(ia %p sp %p cm %p psp=%x)\n",
                     ia, sp, cm, ntohs(cm->msg.dport));

                sp->cm_srvc_handle = NULL;
@@ -1806,6 +1832,17 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,

        /* cr_thread will destroy CR, update saddr lid, gid, qp_type info */
        dapl_os_lock(&cm->lock);
+       dapl_log(DAPL_DBG_TYPE_CM,
+                " PASSIVE: REJECTING CM_REQ:"
+                " cm %p op %s, st %s slid %x iqp %x port %x ->"
+                " dlid %x iqp %x port %x\n", cm,
+                dapl_cm_op_str(ntohs(cm->msg.op)),
+                dapl_cm_state_str(cm->state),
+                ntohs(cm->hca->ib_trans.addr.ib.lid),
+                ntohl(cm->msg.saddr.ib.qpn),
+                ntohs(cm->msg.sport), ntohs(cm->msg.daddr.ib.lid),
+                ntohl(cm->msg.daddr.ib.qpn), ntohs(cm->msg.dport));
+
        cm->state = DCM_REJECTED;
        cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid;
        cm->msg.saddr.ib.qp_type = cm->msg.daddr.ib.qp_type;
@@ -2039,6 +2076,7 @@ out:
 #endif

 #ifdef DAPL_COUNTERS
+static char _ctr_host_[128];
 /* Debug aid: List all Connections in process and state */
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 {
@@ -2058,13 +2096,16 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
        else
                next_cm = NULL;

-        printf("\n DAPL IA LISTEN/CONNECTIONS IN PROCESS:\n");
+       gethostname(_ctr_host_, sizeof(_ctr_host_));
+       printf("\n [%s:%x] DAPL IA LISTEN/CONNECTIONS IN PROCESS:\n",
+               _ctr_host_ , dapl_os_getpid());
+
        while (next_cm) {
                cm = next_cm;
                next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
                                                (DAPL_LLIST_ENTRY*)&cm->local_entry);

-               printf( "  LISTEN[%d]: sp %p %s uCM_QP: 0x%x %d 0x%x l_pid %x,%d\n",
+               printf( "  LISTEN[%d]: sp %p %s uCM_QP: %x %x %x l_pid %x (%x)\n",
                        i, cm->sp, dapl_cm_state_str(cm->state),
                        ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
                        ntohl(cm->msg.sqpn), ntohl(*(DAT_UINT32*)cm->msg.resv),
@@ -2089,7 +2130,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
                                                (DAPL_LLIST_ENTRY*)&cm->local_entry);

                printf( "  CONN[%d]: ep %p cm %p %s %s"
-                       "  %x %x %x %s %x %x %x r_pid %x,%d\n",
+                       "  %x %x %x %s %x %x %x r_pid %x (%x)\n",
                        i, cm->ep, cm,
                        cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
                        dapl_cm_state_str(cm->state),
--
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
