From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] DAPL v2.0: ucm: add debugging to include process id for
 better scale up debug aids
Date: Fri, 3 Dec 2010 15:33:08 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D94F7@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

use part of the resv[] area of the cm_msg to include local and
remote process ids. Add more debug messages to help isolate
problems related to many process problems.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    4 +-
 dapl/openib_ucm/cm.c                |  235 +++++++++++++++++++++++-----------
 2 files changed, 162 insertions(+), 77 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 3cb1fe3..bf4946c 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -96,7 +96,9 @@ typedef struct _ib_cm_msg
        uint32_t                sqpn;  /* src cm qpn */
        uint32_t                dqpn;  /* dst cm qpn */
        uint16_t                p_size;
-       uint8_t                 resv[14];
+       uint32_t                s_id;  /* src pid */
+       uint32_t                d_id;  /* dst pid */
+       uint8_t                 resv[6];
        union dcm_addr          saddr;
        union dcm_addr          daddr;
        union dcm_addr          saddr_alt;
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 0fe5e2e..25b3a39 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -163,12 +163,14 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                if ((time - cm->timer)/1000 >
                    (cm->hca->ib_trans.rep_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_CM_WARN,
-                                " CM_REQ retry %p %d [lid, port, qpn]:"
-                                " %x %x %x -> %x %x %x Time(ms) %llu > %d\n",
-                                cm, cm->retries+1, ntohs(cm->msg.saddr.ib.lid),
-                                ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
+                                " CM_REQ retry %p %d [lid, port, cqp, iqp]:"
+                                " %x %x %x %x -> %x %x %x %x Time(ms) %d > %d\n",
+                                cm, cm->retries+1,
+                                ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+                                ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
                                 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-                                ntohl(cm->msg.dqpn), (time - cm->timer)/1000,
+                                ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+                                (time - cm->timer)/1000,
                                 cm->hca->ib_trans.rep_time << cm->retries);
                        cm->retries++;
                        dapl_os_unlock(&cm->lock);
@@ -181,17 +183,15 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                if ((time - cm->timer)/1000 >
                    (cm->hca->ib_trans.rtu_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_CM_WARN,
-                                " CM_REPLY retry %d [lid, port, qpn]:"
-                                " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %d\n",
+                                " CM_REPLY retry %d %s [lid, port, cqp, iqp]:"
+                                " %x %x %x %x -> %x %x %x %x r_pid %x Time(ms) %d > %d\n",
                                 cm->retries+1,
-                                ntohs(cm->msg.saddr.ib.lid),
-                                ntohs(cm->msg.sport),
-                                ntohl(cm->msg.saddr.ib.qpn),
-                                ntohs(cm->msg.daddr.ib.lid),
-                                ntohs(cm->msg.dport),
-                                ntohl(cm->msg.daddr.ib.qpn),
-                                ntohl(*(DAT_UINT32*)cm->msg.resv),
-                                ntohl(*(DAT_UINT32*)cm->msg.resv),
+                                dapl_cm_op_str(ntohs(cm->msg.op)),
+                                ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+                                ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+                                ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+                                ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+                                ntohl(cm->msg.d_id),
                                 (time - cm->timer)/1000,
                                 cm->hca->ib_trans.rtu_time << cm->retries);
                        cm->retries++;
@@ -206,17 +206,14 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                if ((time - cm->timer)/1000 >
                    (cm->hca->ib_trans.rtu_time << cm->retries)) {
                        dapl_log(DAPL_DBG_TYPE_CM_WARN,
-                                " CM_DREQ retry %d [lid, port, qpn]:"
-                                " %x %x %x -> %x %x %x r_pid %x (%x) Time(ms) %llu > %d\n",
+                                " CM_DREQ retry %d [lid, port, cqp, iqp]:"
+                                " %x %x %x %x -> %x %x %x %x r_pid %x Time(ms) %d > %d\n",
                                 cm->retries+1,
-                                ntohs(cm->msg.saddr.ib.lid),
-                                ntohs(cm->msg.sport),
-                                ntohl(cm->msg.saddr.ib.qpn),
-                                ntohs(cm->msg.daddr.ib.lid),
-                                ntohs(cm->msg.dport),
-                                ntohl(cm->msg.dqpn),
-                                ntohl(*(DAT_UINT32*)cm->msg.resv),
-                                ntohl(*(DAT_UINT32*)cm->msg.resv),
+                                ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+                                ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+                                ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+                                ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+                                ntohl(cm->msg.d_id),
                                 (time - cm->timer)/1000,
                                 cm->hca->ib_trans.rtu_time << cm->retries);
                        cm->retries++;
@@ -353,16 +350,15 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
                /* active: RTU was dropped, resend */
                if (ntohs(msg->op) == DCM_REP) {
                        dapl_log(DAPL_DBG_TYPE_CM_WARN,
-                               " RESEND RTU: op %s st %s [lid, port, qpn]:"
-                               " %x %x %x -> %x %x %x\n",
-                               dapl_cm_op_str(ntohs(msg->op)),
-                               dapl_cm_state_str(cm->state),
-                               ntohs(msg->saddr.ib.lid),
-                               ntohs(msg->sport),
-                               ntohl(msg->saddr.ib.qpn),
-                               ntohs(msg->daddr.ib.lid),
-                               ntohs(msg->dport),
-                               ntohl(msg->daddr.ib.qpn));
+                                " RESEND RTU: op %s st %s [lid, port, cqp, iqp]:"
+                                " %x %x %x %x -> %x %x %x %x r_pid %x\n",
+                                 dapl_cm_op_str(ntohs(cm->msg.op)),
+                                 dapl_cm_state_str(cm->state),
+                                ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+                                ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+                                ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+                                ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+                                ntohl(cm->msg.d_id));

                        cm->msg.op = htons(DCM_RTU);
                        ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0);
@@ -418,7 +414,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 /* Find matching CM object for this receive message, return CM reference, timer */
 dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 {
-       dp_ib_cm_handle_t cm, next, found = NULL;
+       dp_ib_cm_handle_t cm = NULL, next, found = NULL;
        struct dapl_llist_entry **list;
        DAPL_OS_LOCK *lock;
        int listenq = 0;
@@ -448,7 +444,7 @@ retry_listenq:
                        found = cm;
                        break;
                }
-               /* connectq, check src and dst, check duplicate conn_reqs */
+               /* connectq, check src and dst plus id's, check duplicate conn_reqs */
                if (!listenq &&
                    cm->msg.sport == msg->dport && cm->msg.sqpn == msg->dqpn &&
                    cm->msg.dport == msg->sport && cm->msg.dqpn == msg->sqpn &&
@@ -460,18 +456,23 @@ retry_listenq:
                                /* duplicate; bail and throw away */
                                dapl_os_unlock(lock);
                                dapl_log(DAPL_DBG_TYPE_CM_WARN,
-                                        " DUPLICATE: cm %p op %s st %s [lid, port, qpn]:"
-                                        " %x %x %x <- %x %x %x\n", cm,
-                                        dapl_cm_op_str(ntohs(msg->op)),
+                                        " DUPLICATE: cm %p op %s (%s) st %s"
+                                        " [lid, port, cqp, iqp]:"
+                                        " %x %x %x %x <- (%x %x %x %x :"
+                                        " %x %x %x %x) -> %x %x %x %x\n",
+                                        cm, dapl_cm_op_str(ntohs(msg->op)),
+                                        dapl_cm_op_str(ntohs(cm->msg.op)),
                                         dapl_cm_state_str(cm->state),
-                                        ntohs(msg->daddr.ib.lid),
-                                        ntohs(msg->dport),
-                                        ntohl(msg->daddr.ib.qpn),
-                                        ntohs(msg->saddr.ib.lid),
-                                        ntohs(msg->sport),
-                                        ntohl(msg->saddr.ib.qpn));
-
-                               return NULL;
+                                        ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+                                        ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+                                        ntohs(msg->saddr.ib.lid), ntohs(msg->sport),
+                                        ntohl(msg->sqpn), ntohl(msg->saddr.ib.qpn),
+                                        ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
+                                        ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
+                                        ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+                                        ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn));
+
+                                       return NULL;
                        }
                }
        }
@@ -500,14 +501,16 @@ retry_listenq:
        }

        if (!found) {
-               dapl_log(DAPL_DBG_TYPE_CM,
-                       " ucm_recv: NO MATCH op %s %x %x i%x c%x"
-                       " < %x %x %x\n",
-                       dapl_cm_op_str(ntohs(msg->op)),
-                       ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
-                       ntohl(msg->daddr.ib.qpn), ntohl(msg->sqpn),
-                       ntohs(msg->saddr.ib.lid), ntohs(msg->sport),
-                       ntohl(msg->saddr.ib.qpn));
+               dapl_log(DAPL_DBG_TYPE_CM_WARN,
+                        " NO MATCH: op %s [lid, port, cqp, iqp, pid]:"
+                        " %x %x %x %x %x <- %x %x %x %x l_pid %x r_pid %x\n",
+                        dapl_cm_op_str(ntohs(msg->op)),
+                        ntohs(msg->daddr.ib.lid), ntohs(msg->dport),
+                        ntohl(msg->dqpn), ntohl(msg->daddr.ib.qpn),
+                        ntohl(msg->d_id), ntohs(msg->saddr.ib.lid),
+                        ntohs(msg->sport), ntohl(msg->sqpn),
+                        ntohl(msg->saddr.ib.qpn), ntohl(msg->s_id),
+                        ntohl(msg->d_id));
        }

        return found;
@@ -696,7 +699,7 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
        dapls_cm_acquire(cm);

        cm->msg.ver = htons(DCM_VER);
-       *(DAT_UINT32*)cm->msg.resv = htonl(dapl_os_getpid()); /* exchange PID for debugging */
+       cm->msg.s_id = htonl(dapl_os_getpid()); /* process id for src id */

        /* ACTIVE: init source address QP info from local EP */
        if (ep) {
@@ -886,7 +889,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
        default:
                dapl_log(DAPL_DBG_TYPE_WARN,
                        "  disconnect UNKNOWN state: ep %p cm %p %s %s"
-                       "  %x %x %x %s %x %x %x r_pid %x (%x)\n",
+                       "  %x %x %x %s %x %x %x r_id %x l_id %x\n",
                        cm->ep, cm,
                        cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
                        dapl_cm_state_str(cm->state),
@@ -897,8 +900,8 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
                        ntohs(cm->msg.daddr.ib.lid),
                        ntohs(cm->msg.dport),
                        ntohl(cm->msg.daddr.ib.qpn),
-                       ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv),
-                       ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv));
+                       ntohl(cm->msg.d_id),
+                       ntohl(cm->msg.s_id));

                dapl_os_unlock(&cm->lock);
                return DAT_SUCCESS;
@@ -1013,6 +1016,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
        }

        /* save remote address information to EP and CM */
+       cm->msg.d_id = msg->s_id;
        dapl_os_memcpy(&ep->remote_ia_address,
                       &msg->saddr, sizeof(union dcm_addr));
        dapl_os_memcpy(&cm->msg.daddr,
@@ -1108,10 +1112,11 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)

        dapl_os_lock(&cm->lock);
        cm->state = DCM_CONNECTED;
-       dapl_os_unlock(&cm->lock);
-
-       if (ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0))
+       if (ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0)) {
+               dapl_os_unlock(&cm->lock);
                goto bail;
+       }
+       dapl_os_unlock(&cm->lock);

        /* init cm_handle and post the event with private data */
        dapl_dbg_log(DAPL_DBG_TYPE_EP, " ACTIVE: connected!\n");
@@ -1178,6 +1183,7 @@ ud_bail:
                                (DAT_COUNT)ntohs(cm->msg.p_size),
                                (DAT_PVOID *)cm->msg.p_data,
                                (DAT_PVOID *)&xevent);
+               dapli_cm_free(cm); /* still attached to EP */
        } else
 #endif
        {
@@ -1186,8 +1192,8 @@ ud_bail:
                                             cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
        }
        dapl_log(DAPL_DBG_TYPE_CM_EST,
-                " UCM_ACTIVE_CONN %d [lid port qpn] %x %x %x -> %x %x %x\n",
-                cm->retries, ntohs(cm->msg.saddr.ib.lid),
+                " UCM_ACTIVE_CONN %p %d [lid port qpn] %x %x %x -> %x %x %x\n",
+                cm->hca, cm->retries, ntohs(cm->msg.saddr.ib.lid),
                 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
                 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
                 ntohl(cm->msg.dqpn));
@@ -1222,6 +1228,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
        acm->msg.sport = cm->msg.sport;
        acm->msg.sqpn = cm->msg.sqpn;
        acm->msg.p_size = msg->p_size;
+       acm->msg.d_id = msg->s_id;

        /* CR saddr is CM daddr info, need EP for local saddr */
        dapl_os_memcpy(&acm->msg.daddr, &msg->saddr, sizeof(union dcm_addr));
@@ -1354,8 +1361,8 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
                dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
        }
        dapl_log(DAPL_DBG_TYPE_CM_EST,
-                " UCM_PASSIVE_CONN %d [lid port qpn] %x %x %x <- %x %x %x\n",
-                cm->retries, ntohs(cm->msg.saddr.ib.lid),
+                " UCM_PASSIVE_CONN %p %d [lid port qpn] %x %x %x <- %x %x %x\n",
+                cm->hca, cm->retries, ntohs(cm->msg.saddr.ib.lid),
                 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
                 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
                 ntohl(cm->msg.dqpn));
@@ -1366,15 +1373,25 @@ bail:
 }

 /*
- * PASSIVE: user accepted, send reply message with pdata
+ * PASSIVE: user accepted, check and re-send reply message, called from cm_thread.
  */
 static int ucm_reply(dp_ib_cm_handle_t cm)
 {
        dapl_os_lock(&cm->lock);
        if (cm->state != DCM_RTU_PENDING) {
                dapl_log(DAPL_DBG_TYPE_ERR,
-                        " CM_REPLY: wrong state %s",
-                        dapl_cm_state_str(cm->state));
+                        " CM_REPLY: wrong state ep %p cm %p %s refs=%d"
+                        " %x %x i_%x -> %x %x i_%x l_pid %x r_pid %x\n",
+                        cm->ep, cm, dapl_cm_state_str(cm->state),
+                        cm->ref_count,
+                        htons(cm->msg.saddr.ib.lid),
+                        htons(cm->msg.sport),
+                        htonl(cm->msg.saddr.ib.qpn),
+                        htons(cm->msg.daddr.ib.lid),
+                        htons(cm->msg.dport),
+                        htonl(cm->msg.daddr.ib.qpn),
+                        ntohl(cm->msg.s_id),
+                        ntohl(cm->msg.d_id));
                dapl_os_unlock(&cm->lock);
                return -1;
        }
@@ -1446,6 +1463,19 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)

        dapl_os_lock(&cm->lock);
        if (cm->state != DCM_ACCEPTING) {
+               dapl_log(DAPL_DBG_TYPE_ERR,
+                        " CM_ACCEPT_USR: wrong state ep %p cm %p %s refs=%d"
+                        " %x %x i_%x -> %x %x i_%x l_pid %x r_pid %x\n",
+                        cm->ep, cm, dapl_cm_state_str(cm->state),
+                        cm->ref_count,
+                        htons(cm->hca->ib_trans.addr.ib.lid),
+                        htons(cm->msg.sport),
+                        htonl(ep->qp_handle->qp_num),
+                        htons(cm->msg.daddr.ib.lid),
+                        htons(cm->msg.dport),
+                        htonl(cm->msg.daddr.ib.qpn),
+                        ntohl(cm->msg.s_id),
+                        ntohl(cm->msg.d_id));
                dapl_os_unlock(&cm->lock);
                return DAT_INVALID_STATE;
        }
@@ -2130,11 +2160,11 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
                next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
                                                (DAPL_LLIST_ENTRY*)&cm->local_entry);

-               printf( "  LISTEN[%d]: sp %p %s uCM_QP: %x %x %x l_pid %x (%x)\n",
+               printf( "  LISTEN[%d]: sp %p %s uCM_QP: %x %x c_%x l_pid %x \n",
                        i, cm->sp, dapl_cm_state_str(cm->state),
                        ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
-                       ntohl(cm->msg.sqpn), ntohl(*(DAT_UINT32*)cm->msg.resv),
-                       ntohl(*(DAT_UINT32*)cm->msg.resv));
+                       ntohl(cm->msg.sqpn),
+                       ntohl(cm->msg.s_id));
                i++;
        }
        dapl_os_unlock(lock);
@@ -2155,22 +2185,75 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
                                                (DAPL_LLIST_ENTRY*)&cm->local_entry);

                printf( "  CONN[%d]: ep %p cm %p %s %s"
-                       "  %x %x %x %s %x %x %x r_pid %x (%x)\n",
+                       "  %x %x c_%x i_%x %s %x %x c_%x i_%x r_pid %x\n",
                        i, cm->ep, cm,
                        cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
                        dapl_cm_state_str(cm->state),
                        ntohs(cm->msg.saddr.ib.lid),
                        ntohs(cm->msg.sport),
+                       ntohl(cm->msg.sqpn),
                        ntohl(cm->msg.saddr.ib.qpn),
                        cm->sp ? "<-" : "->",
                        ntohs(cm->msg.daddr.ib.lid),
                        ntohs(cm->msg.dport),
+                       ntohl(cm->msg.dqpn),
                        ntohl(cm->msg.daddr.ib.qpn),
-                       ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv),
-                       ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv));
+                       ntohl(cm->msg.d_id));
                i++;
        }
        printf("\n");
        dapl_os_unlock(lock);
 }
+
+void dapls_print_cm_free_list(IN DAPL_IA *ia_ptr)
+{
+       DAPL_EP *ep, *next_ep;
+       dp_ib_cm_handle_t cm, next_cm;
+       int i = 0;
+
+       gethostname(_ctr_host_, sizeof(_ctr_host_));
+       printf("\n [%s:%x] DAPL EP CM FREE LIST:\n",
+               _ctr_host_ , dapl_os_getpid());
+
+       dapl_os_lock(&ia_ptr->header.lock);
+       ep = (dapl_llist_is_empty(&ia_ptr->ep_list_head) ?
+               NULL : dapl_llist_peek_head(&ia_ptr->ep_list_head));
+       while (ep != NULL) {
+               next_ep = dapl_llist_next_entry(&ia_ptr->ep_list_head,
+                                               &ep->header.ia_list_entry);
+               dapl_os_lock(&ep->header.lock);
+               cm = (dapl_llist_is_empty(&ep->cm_list_head) ?
+                       NULL : dapl_llist_peek_head(&ep->cm_list_head));
+               while (cm) {
+                       dapl_os_lock(&cm->lock);
+                       next_cm = dapl_llist_next_entry(&ep->cm_list_head,
+                                                       &cm->list_entry);
+                       if (cm->state == DCM_FREE) {
+                               printf( "  CONN[%d]: ep %p cm %p %s %s"
+                                       " %x %x c_%x i_%x l_pid %x %s"
+                                       " %x %x c_%x i_%x r_pid %x\n",
+                                       i, cm->ep, cm,
+                                       cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
+                                       dapl_cm_state_str(cm->state),
+                                       ntohs(cm->msg.saddr.ib.lid),
+                                       ntohs(cm->msg.sport),
+                                       ntohl(cm->msg.sqpn),
+                                       ntohl(cm->msg.saddr.ib.qpn),
+                                       ntohl(cm->msg.s_id),
+                                       cm->sp ? "<-" : "->",
+                                       ntohs(cm->msg.daddr.ib.lid),
+                                       ntohs(cm->msg.dport),
+                                       ntohl(cm->msg.dqpn),
+                                       ntohl(cm->msg.daddr.ib.qpn),
+                                       ntohl(cm->msg.d_id));
+                               i++;
+                       }
+                       dapl_os_unlock(&cm->lock);
+                       cm = next_cm;
+               }
+               dapl_os_unlock(&ep->header.lock);
+               ep = next_ep;
+       }
+       dapl_os_unlock(&ia_ptr->header.lock);
+}
 #endif
--
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
