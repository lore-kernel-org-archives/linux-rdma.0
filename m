From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/11] ucm: fix lock init bug in ucm_cm_find
Date: Fri, 16 Oct 2009 16:52:11 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CCD@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


the lock should be setup as pointer to lock
not lock structure. Cleanup lock and list
in cm_find function and cm_print function.

Add debug aid by passing process id in
msg resv area. cleanup cr references
and change to cm for consistency.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |  120 +++++++++++++++++++++++++++++---------------------
 1 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 9d702a8..29f87b5 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -166,14 +166,14 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		    (cm->hca->ib_trans.rep_time * cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_REQ retry %d [lid, port, qpn]:"
-				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 " %x %x %x -> %x %x %x \n", 
 				 cm->retries,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
 				 ntohl(cm->msg.saddr.ib.qpn), 
 				 ntohs(cm->msg.daddr.ib.lid), 
 				 ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn)); 
+				 ntohl(cm->msg.dqpn));
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_connect(cm->ep, cm);
 			return;
@@ -181,17 +181,20 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		break;
 	case DCM_RTU_PENDING: 
 		*timer = cm->hca->ib_trans.cm_timer;  
-		if ((time - cm->timer)/1000 > cm->hca->ib_trans.rtu_time) {
+		if ((time - cm->timer)/1000 > 
+		    (cm->hca->ib_trans.rtu_time * cm->retries)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_REPLY retry %d [lid, port, qpn]:"
-				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 " %x %x %x -> %x %x %x r_pid %x,%d\n", 
 				 cm->retries,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
 				 ntohl(cm->msg.saddr.ib.qpn), 
 				 ntohs(cm->msg.daddr.ib.lid), 
 				 ntohs(cm->msg.dport),
-				 ntohl(cm->msg.daddr.ib.qpn));  
+				 ntohl(cm->msg.daddr.ib.qpn),  
+				 ntohl(*(DAT_UINT32*)cm->msg.resv),
+				 ntohl(*(DAT_UINT32*)cm->msg.resv)); 
 			dapl_os_unlock(&cm->lock);
 			ucm_reply(cm);
 			return;
@@ -204,14 +207,16 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		    (cm->hca->ib_trans.rep_time)) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
 				 " CM_DREQ retry %d [lid, port, qpn]:"
-				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 " %x %x %x -> %x %x %x r_pid %x,%d\n", 
 				 cm->retries,
 				 ntohs(cm->msg.saddr.ib.lid), 
 				 ntohs(cm->msg.sport),
 				 ntohl(cm->msg.saddr.ib.qpn), 
 				 ntohs(cm->msg.daddr.ib.lid), 
 				 ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn)); 
+				 ntohl(cm->msg.dqpn), 
+				 ntohl(*(DAT_UINT32*)cm->msg.resv),
+				 ntohl(*(DAT_UINT32*)cm->msg.resv)); 
 			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
                         return;
@@ -396,24 +401,24 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 {
 	dp_ib_cm_handle_t cm, next, found = NULL;
-	struct dapl_llist_entry	*list;
-	DAPL_OS_LOCK lock;
+	struct dapl_llist_entry	**list;
+	DAPL_OS_LOCK *lock;
 	int listenq = 0;
 
 	/* conn list first, duplicate requests for DCM_REQ */
-	list = tp->list;
-	lock = tp->lock;
+	list = &tp->list;
+	lock = &tp->lock;
 
 retry_listenq:
-	dapl_os_lock(&lock);
-        if (!dapl_llist_is_empty(&list))
-		next = dapl_llist_peek_head(&list);
+	dapl_os_lock(lock);
+        if (!dapl_llist_is_empty(list))
+		next = dapl_llist_peek_head(list);
 	else
 		next = NULL;
 
 	while (next) {
 		cm = next;
-		next = dapl_llist_next_entry(&list,
+		next = dapl_llist_next_entry(list,
 					     (DAPL_LLIST_ENTRY *)&cm->entry);
 		if (cm->state == DCM_DESTROY)
 			continue;
@@ -435,7 +440,7 @@ retry_listenq:
 				break; 
 			} else {
 				/* duplicate; bail and throw away */
-				dapl_os_unlock(&lock);
+				dapl_os_unlock(lock);
 				dapl_log(DAPL_DBG_TYPE_CM,
 					 " duplicate: op %s st %s [lid, port, qpn]:"
 					 " 0x%x %d 0x%x <- 0x%x %d 0x%x\n", 
@@ -451,13 +456,13 @@ retry_listenq:
 			}
 		}
 	}
-	dapl_os_unlock(&lock);
+	dapl_os_unlock(lock);
 
 	/* no duplicate request on connq, check listenq for new request */
 	if (ntohs(msg->op) == DCM_REQ && !listenq && !found) {
 		listenq = 1;
-		list = tp->llist;
-		lock = tp->llock;
+		list = &tp->llist;
+		lock = &tp->llock;
 		goto retry_listenq;
 	}
 
@@ -608,6 +613,7 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 		goto bail;
 
 	cm->msg.ver = htons(DCM_VER);
+	*(DAT_UINT32*)cm->msg.resv = htonl(dapl_os_getpid()); /* exchange PID for debugging */
 	
 	/* ACTIVE: init source address QP info from local EP */
 	if (ep) {
@@ -648,7 +654,7 @@ static void ucm_ud_free(DAPL_EP *ep)
 	DAPL_IA *ia = ep->header.owner_ia;
 	DAPL_HCA *hca = NULL;
 	ib_hca_transport_t *tp = &ia->hca_ptr->ib_trans;
-	dp_ib_cm_handle_t cr, next;
+	dp_ib_cm_handle_t cm, next;
 
 	dapl_os_lock(&tp->lock);
 	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&tp->list))
@@ -657,17 +663,17 @@ static void ucm_ud_free(DAPL_EP *ep)
 	    next = NULL;
 
 	while (next) {
-		cr = next;
+		cm = next;
 		next = dapl_llist_next_entry((DAPL_LLIST_HEAD*)&tp->list,
-					     (DAPL_LLIST_ENTRY*)&cr->entry);
-		if (cr->ep == ep)  {
+					     (DAPL_LLIST_ENTRY*)&cm->entry);
+		if (cm->ep == ep)  {
 			dapl_dbg_log(DAPL_DBG_TYPE_EP,
-				     " qp_free CR: ep %p cr %p\n", ep, cr);
-			dapl_os_lock(&cr->lock);
-			hca = cr->hca;
-			cr->ep = NULL;
-			cr->state = DCM_DESTROY;
-			dapl_os_unlock(&cr->lock);
+				     " qp_free CM: ep %p cm %p\n", ep, cm);
+			dapl_os_lock(&cm->lock);
+			hca = cm->hca;
+			cm->ep = NULL;
+			cm->state = DCM_DESTROY;
+			dapl_os_unlock(&cm->lock);
 		}
 	}
 	dapl_os_unlock(&tp->lock);
@@ -855,8 +861,12 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		dapl_os_unlock(&cm->lock);
 
 #ifdef DAPL_COUNTERS
-		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST)
+		/* called from check_timers in cm_thread, cm lock held */
+		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST) {
+			dapl_os_unlock(&cm->hca->ib_trans.lock);
 			dapls_print_cm_list(ep->header.owner_ia);
+			dapl_os_lock(&cm->hca->ib_trans.lock);
+		}
 #endif
 		dapl_evd_connection_callback(cm, 
 					     IB_CME_DESTINATION_UNREACHABLE,
@@ -928,6 +938,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				 ntohs(msg->saddr.ib.lid), 
 				 ntohl(msg->saddr.ib.qpn), 
 				 ntohs(msg->sport));
+			dapl_os_unlock(&cm->lock);
 			goto bail;
 		}
 		dapl_os_memcpy(cm->msg.p_data, 
@@ -1272,8 +1283,12 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 			
 		dapl_os_unlock(&cm->lock);
 #ifdef DAPL_COUNTERS
-		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST)
+		/* called from check_timers in cm_thread, cm lock held */
+		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST) {
+			dapl_os_unlock(&cm->hca->ib_trans.lock);
 			dapls_print_cm_list(dapl_llist_peek_head(&cm->hca->ia_list_head));
+			dapl_os_lock(&cm->hca->ib_trans.lock);
+		}
 #endif
 #ifdef DAT_EXTENSIONS
 		if (cm->msg.saddr.ib.qp_type == IBV_QPT_UD) {
@@ -1577,7 +1592,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA *ia,
 
 	/* reserve local port, then allocate CM object */
 	if (!ucm_get_port(&ia->hca_ptr->ib_trans, (uint16_t)sid)) {
-		dapl_dbg_log(DAPL_DBG_TYPE_CM,
+		dapl_dbg_log(DAPL_DBG_TYPE_WARN,
 			     " listen: ERROR %s on conn_qual 0x%x\n",
 			     strerror(errno), sid);
 		return DAT_CONN_QUAL_IN_USE;
@@ -2074,16 +2089,16 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 	/* Print in process CM's for this IA, if debug type set */
 	int i = 0;
 	dp_ib_cm_handle_t cm, next_cm;
-	struct dapl_llist_entry	*list;
-	DAPL_OS_LOCK lock;
+	struct dapl_llist_entry	**list;
+	DAPL_OS_LOCK *lock;
 	
 	/* LISTEN LIST */
-	list = ia_ptr->hca_ptr->ib_trans.llist;
-	lock = ia_ptr->hca_ptr->ib_trans.llock;
+	list = &ia_ptr->hca_ptr->ib_trans.llist;
+	lock = &ia_ptr->hca_ptr->ib_trans.llock;
 
-	dapl_os_lock(&lock);
-	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&list))
-		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)&list);
+	dapl_os_lock(lock);
+	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)list))
+		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)list);
  	else
 		next_cm = NULL;
 
@@ -2093,31 +2108,32 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 		next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
 						(DAPL_LLIST_ENTRY*)&cm->entry);
 
-		printf( "  LISTEN[%d]: sp %p %s uCM_QP: 0x%x %d 0x%x\n",
+		printf( "  LISTEN[%d]: sp %p %s uCM_QP: 0x%x %d 0x%x l_pid %x,%d\n",
 			i, cm->sp, dapl_cm_state_str(cm->state),
 			ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
-			ntohl(cm->msg.sqpn));
+			ntohl(cm->msg.sqpn), ntohl(*(DAT_UINT32*)cm->msg.resv), 
+			ntohl(*(DAT_UINT32*)cm->msg.resv)); 
 		i++;
 	}
-	dapl_os_unlock(&lock);
+	dapl_os_unlock(lock);
 
 	/* CONNECTION LIST */
-	list = ia_ptr->hca_ptr->ib_trans.list;
-	lock = ia_ptr->hca_ptr->ib_trans.lock;
+	list = &ia_ptr->hca_ptr->ib_trans.list;
+	lock = &ia_ptr->hca_ptr->ib_trans.lock;
 
-	dapl_os_lock(&lock);
-	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&list))
-		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)&list);
+	dapl_os_lock(lock);
+	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)list))
+		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)list);
  	else
 		next_cm = NULL;
 
         while (next_cm) {
 		cm = next_cm;
-		next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)&list,
+		next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
 						(DAPL_LLIST_ENTRY*)&cm->entry);
 
 		printf( "  CONN[%d]: ep %p cm %p %s %s"
-			"  0x%x %d 0x%x %s 0x%x %d 0x%x\n",
+			"  %x %x %x %s %x %x %x r_pid %x,%d\n",
 			i, cm->ep, cm,
 			cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
 			dapl_cm_state_str(cm->state),
@@ -2127,10 +2143,12 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 			cm->sp ? "<-" : "->",
 			ntohs(cm->msg.daddr.ib.lid),
 			ntohs(cm->msg.dport),
-			ntohl(cm->msg.daddr.ib.qpn));
+			ntohl(cm->msg.daddr.ib.qpn),
+			ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv), 
+			ntohs(cm->msg.op) == DCM_REQ ? 0 : ntohl(*(DAT_UINT32*)cm->msg.resv)); 
 		i++;
 	}
 	printf("\n");
-	dapl_os_unlock(&lock);
+	dapl_os_unlock(lock);
 }
 #endif
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
