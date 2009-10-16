From: "Arlin Davis" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/11] uDAPL v2 - ucm: latest patch set for new ucm provider, complete timer/retry logic and windows abstractions
Date: Fri, 16 Oct 2009 16:48:41 -0700
Message-ID: <637C4F53CAAC4F9EA90B3911A946DC3E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

add timer/retry CM logic to the ucm provider

add reply, rtu and retry count options via
environment variables. Times in msecs.
DAPL_UCM_RETRY 10
DAPL_UCM_REP_TIME 400
DAPL_UCM_RTU_TIME 200

Add RTU_PENDING and DISC_RECV states

Add check timer code to the cm_thread
and the option to the select abstaction
to take timeout values in msecs.
DREQ, REQ, and REPLY will all be timed
and retried.

Split out reply code and disconnect_final
code to better facilitate retry timers.
Add checking for duplicate messages.

Added new UD extension events for errors.
DAT_IB_UD_CONNECTION_REJECT_EVENT
DAT_IB_UD_CONNECTION_ERROR_EVENT

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_debug.c             |    2 +-
 dapl/openib_common/dapl_ib_common.h  |   36 ++-
 dapl/openib_ucm/cm.c                 |  622 ++++++++++++++++++++++++----------
 dapl/openib_ucm/dapl_ib_util.h       |    8 +-
 dapl/openib_ucm/device.c             |   10 +-
 dat/include/dat2/dat_ib_extensions.h |   10 +-
 6 files changed, 485 insertions(+), 203 deletions(-)

diff --git a/dapl/common/dapl_debug.c b/dapl/common/dapl_debug.c
index 960bc00..904d075 100644
--- a/dapl/common/dapl_debug.c
+++ b/dapl/common/dapl_debug.c
@@ -50,7 +50,7 @@ void dapl_internal_dbg_log(DAPL_DBG_TYPE type, const char *fmt, ...)
 		if (DAPL_DBG_DEST_STDOUT & g_dapl_dbg_dest) {
 			va_start(args, fmt);
 			fprintf(stdout, "%s:%x: ", _ptr_host_,
-				dapl_os_gettid());
+				dapl_os_getpid());
 			dapl_os_vprintf(fmt, args);
 			va_end(args);
 		}
diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 065cfca..982621c 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -165,9 +165,12 @@ typedef uint16_t		ib_hca_port_t;
 #define DCM_HOP_LIMIT	0xff
 #define DCM_TCLASS	0
 
-/* DAPL uCM timers */
-#define DCM_RETRY_CNT		7
-#define DCM_RETRY_TIME_MS	1000
+/* DAPL uCM timers, default queue sizes */
+#define DCM_RETRY_CNT   10 
+#define DCM_REP_TIME    400	/* reply timeout in m_secs */
+#define DCM_RTU_TIME    200	/* rtu timeout in m_secs */
+#define DCM_QP_SIZE     500     /* uCM tx, rx qp size */
+#define DCM_CQ_SIZE     500     /* uCM cq size */
 
 /* DTO OPs, ordered for DAPL ENUM definitions */
 #define OP_RDMA_WRITE           IBV_WR_RDMA_WRITE
@@ -254,7 +257,7 @@ typedef enum
 
 typedef enum dapl_cm_op
 {
-	DCM_REQ,
+	DCM_REQ = 1,
 	DCM_REP,
 	DCM_REJ_USER, /* user reject */
 	DCM_REJ_CM,   /* cm reject, no SID */
@@ -279,7 +282,9 @@ typedef enum dapl_cm_state
 	DCM_RELEASED,
 	DCM_DISC_PENDING,
 	DCM_DISCONNECTED,
-	DCM_DESTROY
+	DCM_DESTROY,
+	DCM_RTU_PENDING,
+	DCM_DISC_RECV
 
 } DAPL_CM_STATE;
 
@@ -370,9 +375,26 @@ STATIC _INLINE_ char * dapl_cm_state_str(IN int st)
 		"CM_RELEASED",
 		"CM_DISC_PENDING",
 		"CM_DISCONNECTED",
-		"CM_DESTROY"
+		"CM_DESTROY",
+		"CM_RTU_PENDING",
+		"CM_DISC_RECV"
         };
-        return ((st < 0 || st > 13) ? "Invalid CM state?" : state[st]);
+        return ((st < 0 || st > 15) ? "Invalid CM state?" : state[st]);
+}
+
+STATIC _INLINE_ char * dapl_cm_op_str(IN int op)
+{
+	static char *ops[] = {
+		"INVALID",
+		"REQ",
+		"REP",
+		"REJ_USER",
+		"REJ_CM",
+		"RTU",
+		"DREQ",
+		"DREP",
+	};
+	return ((op < 1 || op > 7) ? "Invalid OP?" : ops[op]);
 }
 
 #endif /*  _DAPL_IB_COMMON_H_ */
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 4dc67c9..099cadf 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -95,12 +95,19 @@ static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
 		return DAPL_FD_ERROR;
 }
 
-static int dapl_select(struct dapl_fd_set *set)
+static int dapl_select(struct dapl_fd_set *set, int time_ms)
 {
 	int ret;
+	struct timeval tv, *p_tv = NULL;
+
+	if (time_ms != -1) {
+		p_tv = &tv;
+		tv.tv_sec = time_ms/1000; 
+		tv.tv_usec = (time_ms%1000)*1000;
+	}
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep\n");
-	ret = select(0, &set->set[0], &set->set[1], &set->set[2], NULL);
+	ret = select(0, &set->set[0], &set->set[1], &set->set[2], p_tv);
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup\n");
 
 	if (ret == SOCKET_ERROR)
@@ -166,24 +173,27 @@ static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
 		return fds.revents;
 }
 
-static int dapl_select(struct dapl_fd_set *set)
+static int dapl_select(struct dapl_fd_set *set, int time_ms)
 {
 	int ret;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep, fds=%d\n",
 		     set->index);
-	ret = poll(set->set, set->index, -1);
+	ret = poll(set->set, set->index, time_ms);
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup, ret=0x%x\n", ret);
 	return ret;
 }
 #endif
 
 /* forward declarations */
+static int ucm_reply(dp_ib_cm_handle_t cm);
 static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg);
 static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg);
 static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg);
 static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data, DAT_COUNT p_size);
+static void ucm_disconnect_final(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm);
+DAT_RETURN dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm);
 
 #define UCM_SND_BURST	50	
 
@@ -221,6 +231,77 @@ static void ucm_free_port(ib_hca_transport_t *tp, uint16_t port)
 	dapl_os_unlock(&tp->plock);
 }
 
+static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
+{
+	DAPL_OS_TIMEVAL time;
+
+        dapl_os_lock(&cm->lock);
+	dapl_os_get_time(&time); 
+	switch (cm->state) {
+	case DCM_REP_PENDING: 
+		*timer = cm->hca->ib_trans.cm_timer; 
+		/* wait longer each retry */
+		if ((time - cm->timer)/1000 > 
+		    (cm->hca->ib_trans.rep_time * cm->retries)) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " CM_REQ retry %d [lid, port, qpn]:"
+				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 cm->retries,
+				 ntohs(cm->msg.saddr.ib.lid), 
+				 ntohs(cm->msg.sport),
+				 ntohl(cm->msg.saddr.ib.qpn), 
+				 ntohs(cm->msg.daddr.ib.lid), 
+				 ntohs(cm->msg.dport),
+				 ntohl(cm->msg.dqpn)); 
+			dapl_os_unlock(&cm->lock);
+			dapli_cm_connect(cm->ep, cm);
+			return;
+		}
+		break;
+	case DCM_RTU_PENDING: 
+		*timer = cm->hca->ib_trans.cm_timer;  
+		if ((time - cm->timer)/1000 > cm->hca->ib_trans.rtu_time) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " CM_REPLY retry %d [lid, port, qpn]:"
+				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 cm->retries,
+				 ntohs(cm->msg.saddr.ib.lid), 
+				 ntohs(cm->msg.sport),
+				 ntohl(cm->msg.saddr.ib.qpn), 
+				 ntohs(cm->msg.daddr.ib.lid), 
+				 ntohs(cm->msg.dport),
+				 ntohl(cm->msg.daddr.ib.qpn));  
+			dapl_os_unlock(&cm->lock);
+			ucm_reply(cm);
+			return;
+		}
+		break;
+	case DCM_DISC_PENDING: 
+		*timer = cm->hca->ib_trans.cm_timer; 
+		/* wait longer each retry */
+		if ((time - cm->timer)/1000 > 
+		    (cm->hca->ib_trans.rep_time)) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " CM_DREQ retry %d [lid, port, qpn]:"
+				 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				 cm->retries,
+				 ntohs(cm->msg.saddr.ib.lid), 
+				 ntohs(cm->msg.sport),
+				 ntohl(cm->msg.saddr.ib.qpn), 
+				 ntohs(cm->msg.daddr.ib.lid), 
+				 ntohs(cm->msg.dport),
+				 ntohl(cm->msg.dqpn)); 
+			dapl_os_unlock(&cm->lock);
+			dapli_cm_disconnect(cm);
+                        return;
+		}
+		break;
+	default:
+		break;
+	}
+	dapl_os_unlock(&cm->lock);
+}
+
 /* SEND CM MESSAGE PROCESSING */
 
 /* Get CM UD message from send queue, called with s_lock held */
@@ -313,34 +394,75 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 {
 	dapl_os_lock(&cm->lock);
 	switch (cm->state) {
-	case DCM_LISTEN:
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: LISTEN\n");
+	case DCM_LISTEN: /* passive */
 		dapl_os_unlock(&cm->lock);
 		ucm_accept(cm, msg);
 		break;
-	case DCM_ACCEPTED:
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: ACCEPT_RTU\n");
+	case DCM_RTU_PENDING: /* passive */
 		dapl_os_unlock(&cm->lock);
 		ucm_accept_rtu(cm, msg);
 		break;
-	case DCM_CONN_PENDING:
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: CONN_RTU\n");
+	case DCM_REP_PENDING: /* active */
 		dapl_os_unlock(&cm->lock);
 		ucm_connect_rtu(cm, msg);
 		break;
-	case DCM_CONNECTED:
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: DREQ connect\n");
-		dapl_os_unlock(&cm->lock);
-		if (ntohs(msg->op) == DCM_DREQ)
+	case DCM_CONNECTED: /* active and passive */
+		/* DREQ, change state and process */
+		if (ntohs(msg->op) == DCM_DREQ) {
+			cm->state = DCM_DISC_RECV;
+			dapl_os_unlock(&cm->lock);
 			dapli_cm_disconnect(cm);
+			break;
+		} 
+		/* active: RTU was dropped, resend */
+		if (ntohs(msg->op) == DCM_REP) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				" RESEND RTU: op %s st %s [lid, port, qpn]:"
+				" 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				dapl_cm_op_str(ntohs(msg->op)), 
+				dapl_cm_state_str(cm->state),
+				ntohs(msg->saddr.ib.lid), 
+				ntohs(msg->sport),
+				ntohl(msg->saddr.ib.qpn), 
+				ntohs(msg->daddr.ib.lid), 
+				ntohs(msg->dport),
+				ntohl(msg->daddr.ib.qpn));  
+
+			cm->msg.op = htons(DCM_RTU);
+			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 		
+		}
+		dapl_os_unlock(&cm->lock);
 		break;
-	case DCM_DISC_PENDING:
+	case DCM_DISC_PENDING: /* active and passive */
+		/* DREQ or DREP, finalize */
+		dapl_os_unlock(&cm->lock);
+		ucm_disconnect_final(cm);
+		break;
+	case DCM_DISCONNECTED:
 	case DCM_DESTROY:
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, " ucm_recv: DREQ toss\n");
+		/* DREQ dropped, resend */
+		if (ntohs(msg->op) == DCM_DREQ) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				" RESEND DREP: op %s st %s [lid, port, qpn]:"
+				" 0x%x %d 0x%x -> 0x%x %d 0x%x\n", 
+				dapl_cm_op_str(ntohs(msg->op)), 
+				dapl_cm_state_str(cm->state),
+				ntohs(msg->saddr.ib.lid), 
+				ntohs(msg->sport),
+				ntohl(msg->saddr.ib.qpn), 
+				ntohs(msg->daddr.ib.lid), 
+				ntohs(msg->dport),
+				ntohl(msg->daddr.ib.qpn));  
+			cm->msg.op = htons(DCM_DREP);
+			ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 
+			
+		}
+		dapl_os_unlock(&cm->lock);
 		break;
+	
 	default:
 		dapl_log(DAPL_DBG_TYPE_WARN,
-				" process_recv: UNKNOWN state"
+				" ucm_recv: UNKNOWN state"
 				" <- op %d, st %d spsp %d sqpn %d\n", 
 				ntohs(msg->op), cm->state, 
 				ntohs(msg->sport), ntohl(msg->sqpn));
@@ -349,24 +471,19 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 	}
 }
 
-/* Find matching CM object for this receive message, return CM reference */
+/* Find matching CM object for this receive message, return CM reference, timer */
 dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 {
 	dp_ib_cm_handle_t cm, next, found = NULL;
 	struct dapl_llist_entry	*list;
 	DAPL_OS_LOCK lock;
+	int listenq = 0;
 
-	/* connect request - listen list, otherwise conn list */
-	if (ntohs(msg->op) == DCM_REQ) {
-		dapl_dbg_log(DAPL_DBG_TYPE_CM," search - listenQ\n");
-		list = tp->llist;
-		lock = tp->llock;
-	} else {
-		dapl_dbg_log(DAPL_DBG_TYPE_CM," search - connectQ\n");
-		list = tp->list;
-		lock = tp->lock;
-	}
+	/* conn list first, duplicate requests for DCM_REQ */
+	list = tp->list;
+	lock = tp->lock;
 
+retry_listenq:
 	dapl_os_lock(&lock);
         if (!dapl_llist_is_empty(&list))
 		next = dapl_llist_peek_head(&list);
@@ -380,46 +497,53 @@ dp_ib_cm_handle_t ucm_cm_find(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 		if (cm->state == DCM_DESTROY)
 			continue;
 		
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, 
-			     " MATCH? cm %p st %s sport %d sqpn %x lid %x\n", 
-			     cm, dapl_cm_state_str(cm->state),
-			     ntohs(cm->msg.sport), ntohl(cm->msg.sqpn),
-			     ntohs(cm->msg.saddr.ib.lid));
-
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, 
-			     "  src port %d=%d, sqp %x=%x slid %x=%x, iqp %x=%x\n",
-			     ntohs(cm->msg.sport), ntohs(msg->dport), 
-			     ntohl(cm->msg.sqpn), ntohl(msg->dqpn),
-			     ntohs(cm->msg.saddr.ib.lid), 
-			     ntohs(msg->daddr.ib.lid),
-			     ntohl(cm->msg.saddr.ib.qpn),  
-			     ntohl(msg->daddr.ib.qpn));
-		dapl_dbg_log(DAPL_DBG_TYPE_CM, 
-			     "  dst port %d=%d, sqp %x=%x slid %x=%x, iqp %x=%x\n",
-			     ntohs(cm->msg.dport), ntohs(msg->sport), 
-			     ntohl(cm->msg.dqpn), ntohl(msg->sqpn),
-			     ntohs(cm->msg.daddr.ib.lid), 
-			     ntohs(msg->saddr.ib.lid),
-			     ntohl(cm->msg.daddr.ib.qpn),  
-			     ntohl(msg->saddr.ib.qpn));
-
-		/* REQ: CM sPORT + QPN, match is good enough */
-		if ((cm->msg.sport == msg->dport) && 
-		    (cm->msg.sqpn == msg->dqpn)) {
-			if (ntohs(msg->op) == DCM_REQ) {
-				found = cm;
-				break;
-			/* NOT REQ: add remote CM sPORT, QPN, LID match */
-			} else if ((cm->msg.dport == msg->sport) &&
-				   (cm->msg.dqpn == msg->sqpn)  &&
-				   (cm->msg.daddr.ib.lid == 
-				    msg->saddr.ib.lid)) { 
+		/* CM sPORT + QPN, match is good enough for listenq */
+		if (listenq && 
+		    cm->msg.sport == msg->dport && 
+		    cm->msg.sqpn == msg->dqpn) {
+			found = cm;
+			break;
+		}	 
+		/* connectq, check src and dst, check duplicate conn_reqs */
+		if (!listenq && 
+		    cm->msg.sport == msg->dport && cm->msg.sqpn == msg->dqpn && 
+		    cm->msg.dport == msg->sport && cm->msg.dqpn == msg->sqpn && 
+		    cm->msg.daddr.ib.lid == msg->saddr.ib.lid) {
+			if (ntohs(msg->op) != DCM_REQ) {
 				found = cm;
-				break;
+				break; 
+			} else {
+				/* duplicate; bail and throw away */
+				dapl_os_unlock(&lock);
+				dapl_log(DAPL_DBG_TYPE_CM,
+					 " duplicate: op %s st %s [lid, port, qpn]:"
+					 " 0x%x %d 0x%x <- 0x%x %d 0x%x\n", 
+					 dapl_cm_op_str(ntohs(msg->op)), 
+					 dapl_cm_state_str(cm->state),
+					 ntohs(msg->daddr.ib.lid), 
+					 ntohs(msg->dport),
+					 ntohl(msg->daddr.ib.qpn), 
+					 ntohs(msg->saddr.ib.lid), 
+					 ntohs(msg->sport),
+					 ntohl(msg->saddr.ib.qpn));  
+				return NULL;
 			}
 		}
 	}
 	dapl_os_unlock(&lock);
+
+	/* no duplicate request on connq, check listenq for new request */
+	if (ntohs(msg->op) == DCM_REQ && !listenq && !found) {
+		listenq = 1;
+		list = tp->llist;
+		lock = tp->llock;
+		goto retry_listenq;
+	}
+
+	/* not match on listenq for valid request, send reject */
+	if (ntohs(msg->op) == DCM_REQ && !found)
+		ucm_reject(tp, msg);
+
 	return found;
 }
 
@@ -467,12 +591,16 @@ retry:
 			continue;
 		}
 		if (!(cm = ucm_cm_find(tp, msg))) {
-			dapl_log(DAPL_DBG_TYPE_CM,
-				 " ucm_recv: NO MATCH op %d port %d cqp %x\n", 
-				 ntohs(msg->op), ntohs(msg->dport), 
-				 ntohl(msg->dqpn));
-			if (ntohs(msg->op) == DCM_REQ)
-				ucm_reject(tp, msg);
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " ucm_recv: NO MATCH op %s 0x%x %d i0x%x c0x%x"
+				 " < 0x%x %d 0x%x\n", 
+				 dapl_cm_op_str(ntohs(msg->op)), 
+				 ntohs(msg->daddr.ib.lid), ntohs(msg->dport), 
+				 ntohl(msg->daddr.ib.qpn),
+				 ntohl(msg->sqpn),
+				 ntohs(msg->saddr.ib.lid), ntohs(msg->sport), 
+				 ntohl(msg->saddr.ib.qpn));
+
 			ucm_post_rmsg(tp, msg);
 			continue;
 		}
@@ -485,7 +613,6 @@ retry:
 	
 	/* finished this batch of WC's, poll and rearm */
 	goto retry;
-	
 }
 
 /* ACTIVE/PASSIVE: build and send CM message out of CM object */
@@ -504,8 +631,10 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 
 	len = (sizeof(*msg) - DCM_MAX_PDATA_SIZE);
 	dapl_os_memcpy(smsg, msg, len);
-	if (p_size)
+	if (p_size) {
+		smsg->p_size = ntohs(p_size);
 		dapl_os_memcpy(&smsg->p_data, p_data, p_size);
+	}
 
 	wr.next = NULL;
         wr.sg_list = &sge;
@@ -634,8 +763,10 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " cm_destroy: cm %p ep %p\n", cm, ep);
 
-	if (!cm && ep)
-		return (ucm_ud_free(ep));
+	if (!cm && ep) {
+		ucm_ud_free(ep);
+		return;
+	}
 
 	dapl_os_lock(&cm->lock);
 
@@ -669,7 +800,7 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
 }
 
-/* ACTIVE/PASSIVE: queue up connection object on CM list */
+/* ACTIVE/PASSIVE: queue up connection object on CM list, wakeup thread */
 static void ucm_queue_conn(dp_ib_cm_handle_t cm)
 {
 	/* add to work queue, list, for cm thread processing */
@@ -678,6 +809,7 @@ static void ucm_queue_conn(dp_ib_cm_handle_t cm)
 	dapl_llist_add_tail(&cm->hca->ib_trans.list,
 			    (DAPL_LLIST_ENTRY *)&cm->entry, cm);
 	dapl_os_unlock(&cm->hca->ib_trans.lock);
+	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0); 
 }
 
 /* PASSIVE: queue up listen object on listen list */
@@ -698,54 +830,68 @@ static void ucm_dequeue_listen(dp_ib_cm_handle_t cm) {
 	dapl_os_unlock(&cm->hca->ib_trans.llock);
 }
 
+static void ucm_disconnect_final(dp_ib_cm_handle_t cm) 
+{
+	/* no EP attachment or not RC, nothing to process */
+	if (cm->ep == NULL ||
+	    cm->ep->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC) 
+		return;
+
+	dapl_os_lock(&cm->lock);
+	if (cm->state == DCM_DISCONNECTED) {
+		dapl_os_unlock(&cm->lock);
+		return;
+	}
+		
+	cm->state = DCM_DISCONNECTED;
+	dapl_os_unlock(&cm->lock);
+
+	if (cm->sp) 
+		dapls_cr_callback(cm, IB_CME_DISCONNECTED, NULL, cm->sp);
+	else
+		dapl_evd_connection_callback(cm, IB_CME_DISCONNECTED, NULL, cm->ep);
+}
+
 /*
- * ACTIVE/PASSIVE: called from CR thread or consumer via ep_disconnect
- *                 or from ep_free
+ * called from consumer thread via ep_disconnect/ep_free or 
+ * from cm_thread when receiving DREQ
  */
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 {
-	DAPL_EP *ep = cm->ep;
-
-	if (ep == NULL)
-		return DAT_SUCCESS;
+	int finalize = 1;
 
 	dapl_os_lock(&cm->lock);
-	if ((cm->state == DCM_INIT) ||
-	    (cm->state == DCM_DISC_PENDING) ||
-	    (cm->state == DCM_DISCONNECTED) ||
-	    (cm->state == DCM_DESTROY)) {
+	switch (cm->state) {
+	case DCM_CONNECTED:
+		/* send DREQ, event after DREP or DREQ timeout */
+		cm->state = DCM_DISC_PENDING;
+		cm->msg.op = htons(DCM_DREQ);
+		cm->retries = 1;
+		finalize = 0; /* wait for DREP, wakeup timer thread */
+		send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+		break;
+	case DCM_DISC_PENDING:
+		/* DREQ timeout, resend until retries exhausted */
+		cm->msg.op = htons(DCM_DREQ);
+		if (cm->retries++ >= cm->hca->ib_trans.retries)
+			finalize = 1;
+		break;
+	case DCM_DISC_RECV:
+		/* DREQ received, send DREP and schedule event */
+		cm->msg.op = htons(DCM_DREP);
+		break;
+	default:
 		dapl_os_unlock(&cm->lock);
 		return DAT_SUCCESS;
-	} else {
-		/* send disc, schedule destroy */
-		cm->msg.op = htons(DCM_DREQ);
-		if (ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0)) {
-			dapl_log(DAPL_DBG_TYPE_WARN, 
-				 " disc_req: ERR-> %s lid %d qpn %d"
-				 " r_psp %d \n", strerror(errno), 
-				 htons(cm->msg.saddr.ib.lid), 
-				 htonl(cm->msg.saddr.ib.qpn), 
-				 htons(cm->msg.sport));
-		}
-		cm->state = DCM_DISC_PENDING;
 	}
+	
+	dapl_os_get_time(&cm->timer); /* reply expected */
+	ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0); 
 	dapl_os_unlock(&cm->lock);
 
-	/* disconnect events for RC's only */
-	if (ep->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
-		if (ep->cr_ptr) {
-			dapls_cr_callback(cm,
-					  IB_CME_DISCONNECTED,
-					  NULL,
-					  ((DAPL_CR *)ep->cr_ptr)->sp_ptr);
-		} else {
-			dapl_evd_connection_callback(ep->cm_handle,
-						     IB_CME_DISCONNECTED,
-						     NULL, ep);
-		}
-	}
-
-	/* scheduled destroy via disconnect clean in callback */
+	if (finalize)
+		ucm_disconnect_final(cm);
+	
 	return DAT_SUCCESS;
 }
 
@@ -765,43 +911,55 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		 htons(cm->msg.dport));
 
 	dapl_os_lock(&cm->lock);
-	if (cm->state == DCM_INIT) 
-		cm->state = DCM_CONN_PENDING;
-	else if (++cm->retries == DCM_RETRY_CNT) {
+	if (cm->state != DCM_REP_PENDING) {
+		dapl_os_unlock(&cm->lock);
+		return DAT_INVALID_STATE;
+	}
+	
+	if (cm->retries++ == cm->hca->ib_trans.retries) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
-			 " connect: RETRIES EXHAUSTED -> lid %d qpn %d r_psp"
-			 " %d p_sz=%d\n",
-			 strerror(errno), htons(cm->msg.daddr.ib.lid), 
-			 htonl(cm->msg.dqpn), htons(cm->msg.dport), 
-			 htons(cm->msg.p_size));
+			" CM_REQ: RETRIES EXHAUSTED:"
+			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+			 htons(cm->msg.saddr.ib.lid), 
+			 htonl(cm->msg.saddr.ib.qpn), 
+			 htons(cm->msg.sport), 
+			 htons(cm->msg.daddr.ib.lid), 
+			 htonl(cm->msg.dqpn), 
+			 htons(cm->msg.dport));
 
 		/* update ep->cm reference so we get cleaned up on callback */
 		if (cm->msg.saddr.ib.qp_type == IBV_QPT_RC);
 			ep->cm_handle = cm;
 
 		dapl_os_unlock(&cm->lock);
+
+#ifdef DAPL_COUNTERS
+		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST)
+			dapls_print_cm_list(ep->header.owner_ia);
+#endif
 		dapl_evd_connection_callback(cm, 
 					     IB_CME_DESTINATION_UNREACHABLE,
 					     NULL, ep);
-
+		
 		return DAT_ERROR(DAT_INVALID_ADDRESS, 
 				 DAT_INVALID_ADDRESS_UNREACHABLE);
 	}
 	dapl_os_unlock(&cm->lock);
 
 	cm->msg.op = htons(DCM_REQ);
+	dapl_os_get_time(&cm->timer); /* reply expected */
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, 
 		     &cm->msg.p_data, ntohs(cm->msg.p_size))) 		
 		goto bail;
 
 	/* first time through, put on work queue */
-	if (!cm->retries)
+	if (cm->retries == 1) 
 		ucm_queue_conn(cm);
-
+	
 	return DAT_SUCCESS;
 
 bail:
-	dapl_log(DAPL_DBG_TYPE_ERR, 
+	dapl_log(DAPL_DBG_TYPE_WARN, 
 		 " connect: ERR %s -> cm_lid %d cm_qpn %d r_psp %d p_sz=%d\n",
 		 strerror(errno), htons(cm->msg.daddr.ib.lid), 
 		 htonl(cm->msg.dqpn), htons(cm->msg.dport), 
@@ -821,7 +979,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	ib_cm_events_t event = IB_CME_CONNECTED;
 
 	dapl_os_lock(&cm->lock);
-	if (cm->state != DCM_CONN_PENDING) {
+	if (cm->state != DCM_REP_PENDING) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
 			 " CONN_RTU: UNEXPECTED state:"
 			 " op %d, st %s <- lid %d sqpn %d sport %d\n", 
@@ -831,7 +989,6 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		dapl_os_unlock(&cm->lock);
 		return;
 	}
-	dapl_os_unlock(&cm->lock);
 
 	/* save remote address information to EP and CM */
 	dapl_os_memcpy(&ep->remote_ia_address,
@@ -871,10 +1028,9 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		event = IB_CME_DESTINATION_REJECT;
 	
 	if (event != IB_CME_CONNECTED) {
-		dapl_log(DAPL_DBG_TYPE_CM,
-			 " CONN_RTU: REJ op=%d <- lid %x, iqp %x, psp %d\n",
-			 ntohs(msg->op), ntohs(msg->saddr.ib.lid), 
-			 ntohl(msg->saddr.ib.qpn), ntohs(msg->sport));
+		cm->state = DCM_REJECTED;
+		dapl_os_unlock(&cm->lock);
+
 #ifdef DAT_EXTENSIONS
 		if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD) 
 			goto ud_bail;
@@ -882,6 +1038,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 #endif
 		goto bail;
 	}
+	dapl_os_unlock(&cm->lock);
 
 	/* modify QP to RTR and then to RTS with remote info */
 	dapl_os_lock(&cm->ep->header.lock);
@@ -971,8 +1128,10 @@ ud_bail:
 
 		if (event == IB_CME_CONNECTED)
 			event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
-		else
+		else {
+			xevent.type = DAT_IB_UD_CONNECT_REJECT;
 			event = DAT_IB_UD_CONNECTION_REJECT_EVENT;
+		}
 
 		dapls_evd_post_connection_event_ext(
 				(DAPL_EVD *)cm->ep->param.connect_evd_handle,
@@ -996,11 +1155,12 @@ ud_bail:
 					     cm->msg.p_data, cm->ep);
 	}
 	return;
-
 bail:
 	if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD) 
 		dapls_ib_reinit_ep(cm->ep); /* reset QP state */
+
 	dapl_evd_connection_callback(NULL, event, cm->msg.p_data, cm->ep);
+	dapls_ib_cm_free(cm, NULL); 
 }
 
 /*
@@ -1022,7 +1182,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 	/* dest CM info from CR msg, source CM info from listen */
 	acm->sp = cm->sp;
 	acm->hca = cm->hca;
-	acm->state = DCM_ACCEPTING;
+	acm->retries = 1;
 	acm->msg.dport = msg->sport;
 	acm->msg.dqpn = msg->sqpn;
 	acm->msg.sport = cm->msg.sport; 
@@ -1049,7 +1209,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 		dapl_os_memcpy(acm->msg.p_data, 
 			       msg->p_data, ntohs(msg->p_size));
 		
-	acm->state = DCM_ACCEPTING_DATA;
+	acm->state = DCM_ACCEPTING;
 	ucm_queue_conn(acm);
 
 #ifdef DAT_EXTENSIONS
@@ -1086,7 +1246,7 @@ bail:
 static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 {
 	dapl_os_lock(&cm->lock);
-	if ((ntohs(msg->op) != DCM_RTU) || (cm->state != DCM_ACCEPTED)) {
+	if ((ntohs(msg->op) != DCM_RTU) || (cm->state != DCM_RTU_PENDING)) {
 		dapl_log(DAPL_DBG_TYPE_WARN, 
 			 " accept_rtu: UNEXPECTED op, state:"
 			 " op %d, st %s <- lid %x iqp %x sport %d\n", 
@@ -1168,6 +1328,59 @@ bail:
 }
 
 /*
+ * PASSIVE: user accepted, send reply message with pdata
+ */
+static int ucm_reply(dp_ib_cm_handle_t cm)
+{
+	dapl_os_lock(&cm->lock);
+	if (cm->state != DCM_RTU_PENDING) {
+		dapl_os_unlock(&cm->lock);
+		return -1;
+	}
+
+	if (++cm->retries == cm->hca->ib_trans.retries) {
+		dapl_log(DAPL_DBG_TYPE_WARN, 
+			 " CM_REP: RETRIES EXHAUSTED"
+			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+			 htons(cm->msg.saddr.ib.lid), 
+			 htons(cm->msg.sport), 
+			 htonl(cm->msg.saddr.ib.qpn), 
+			 htons(cm->msg.daddr.ib.lid), 
+			 htons(cm->msg.dport), 
+			 htonl(cm->msg.daddr.ib.qpn));
+			
+		dapl_os_unlock(&cm->lock);
+#ifdef DAT_EXTENSIONS
+		if (cm->msg.saddr.ib.qp_type == IBV_QPT_UD) {
+			DAT_IB_EXTENSION_EVENT_DATA xevent;
+					
+			/* post REJECT event with CONN_REQ p_data */
+			xevent.status = 0;
+			xevent.type = DAT_IB_UD_CONNECT_ERROR;
+					
+			dapls_evd_post_connection_event_ext(
+				(DAPL_EVD *)cm->ep->param.connect_evd_handle,
+				DAT_IB_UD_CONNECTION_ERROR_EVENT,
+				(DAT_EP_HANDLE)cm->ep,
+				(DAT_COUNT)ntohs(cm->msg.p_size),
+				(DAT_PVOID *)cm->msg.p_data,
+				(DAT_PVOID *)&xevent);
+		} else 
+#endif
+			dapls_cr_callback(cm, IB_CME_LOCAL_FAILURE, 
+					  NULL, cm->sp);
+		return -1;
+	}
+	dapl_os_get_time(&cm->timer); /* RTU expected */
+	dapl_os_unlock(&cm->lock);
+	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) 		
+		return -1;
+
+	return 0;
+}
+
+
+/*
  * PASSIVE: consumer accept, send local QP information, private data, 
  * queue on work thread to receive RTU information to avoid blocking
  * user thread. 
@@ -1182,7 +1395,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		return DAT_LENGTH_ERROR;
 
 	dapl_os_lock(&cm->lock);
-	if (cm->state != DCM_ACCEPTING_DATA) {
+	if (cm->state != DCM_ACCEPTING) {
 		dapl_os_unlock(&cm->lock);
 		return DAT_INVALID_STATE;
 	}
@@ -1193,7 +1406,8 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		     " iqp=%x qp_type %d, psize=%d\n",
 		     ntohs(cm->msg.daddr.ib.lid),
 		     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type, 
-		     ntohs(cm->msg.p_size));
+		     p_size);
+
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT_USR: remote GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
@@ -1204,7 +1418,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 #ifdef DAT_EXTENSIONS
 	if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD &&
 	    ep->qp_handle->qp_type != IBV_QPT_UD) {
-		dapl_dbg_log(DAPL_DBG_TYPE_ERR,
+		dapl_log(DAPL_DBG_TYPE_ERR,
 			     " ACCEPT_USR: ERR remote QP is UD,"
 			     ", but local QP is not\n");
 		return (DAT_INVALID_HANDLE | DAT_INVALID_HANDLE_EP);
@@ -1262,18 +1476,23 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_os_lock(&cm->lock);
 	cm->ep = ep;
 	cm->hca = ia->hca_ptr;
-	cm->state = DCM_ACCEPTED;
+	cm->state = DCM_RTU_PENDING;
+	dapl_os_get_time(&cm->timer); /* RTU expected */
 	dapl_os_unlock(&cm->lock);
 
-	if (ucm_send(&cm->hca->ib_trans, &cm->msg, p_data, p_size)) 		
+	if (ucm_reply(cm))
 		goto bail;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
-	return DAT_SUCCESS;
+	
+	/* Timed RTU, wakeup thread */
+	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
 
+	return DAT_SUCCESS;
 bail:
 	if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
 		dapls_ib_reinit_ep(ep);
+
 	dapls_ib_cm_free(cm, ep);
 	return DAT_INTERNAL_ERROR;
 }
@@ -1326,6 +1545,8 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 		cm->msg.p_size = htons(p_size);
 		dapl_os_memcpy(&cm->msg.p_data, p_data, p_size);
 	}
+	
+	cm->state = DCM_REP_PENDING;
 
 	/* build connect request, send to remote CM based on r_addr info */
 	return(dapli_cm_connect(ep, cm));
@@ -1571,7 +1792,6 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
 			   IN int reason,
 			   IN DAT_COUNT psize, IN const DAT_PVOID pdata)
 {
-
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
 		     " reject(cm %p reason %x, pdata %p, psize %d)\n",
 		     cm, reason, pdata, psize);
@@ -1579,22 +1799,24 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
         if (psize > DCM_MAX_PDATA_SIZE)
                 return DAT_LENGTH_ERROR;
 
-	cm->msg.op = htons(DCM_REJ_USER);
-	if (psize)
-		dapl_os_memcpy(&cm->msg.p_data, pdata, psize);
-		
-	/* cr_thread will destroy CR */
+	/* cr_thread will destroy CR, update saddr lid, gid info */
 	dapl_os_lock(&cm->lock);
-	cm->state = DCM_REJECTING;
-	dapl_os_unlock(&cm->lock);
-
-	if (ucm_send(&cm->hca->ib_trans, &cm->msg, NULL, 0)) {
+	cm->state = DCM_REJECTED;
+	cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid; 
+	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
+		       &cm->hca->ib_trans.addr.ib.gid, 16); 
+	cm->msg.op = htons(DCM_REJ_USER);
+	
+	if (ucm_send(&cm->hca->ib_trans, &cm->msg, pdata, psize)) {
 		dapl_log(DAPL_DBG_TYPE_WARN,
 			 " cm_reject: ERR: %s\n", strerror(errno));
 		return DAT_INTERNAL_ERROR;
 	}
+	dapl_os_unlock(&cm->lock);
 		
-	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+	/* cleanup and destroy CM resources */ 
+	dapls_ib_cm_free(cm, NULL);
+
 	return DAT_SUCCESS;
 }
 
@@ -1786,6 +2008,7 @@ void cm_thread(void *arg)
 	dp_ib_cm_handle_t cm, next;
 	struct dapl_fd_set *set;
 	char rbuf[2];
+	int time_ms;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread: ENTER hca %p\n", hca);
 	set = dapl_alloc_fd_set();
@@ -1796,11 +2019,12 @@ void cm_thread(void *arg)
 	hca->ib_trans.cm_state = IB_THREAD_RUN;
 
 	while (1) {
+		time_ms = -1; /* reset to blocking */
 		dapl_fd_zero(set);
 		dapl_fd_set(hca->ib_trans.scm[0], set, DAPL_FD_READ);	
 		dapl_fd_set(hca->ib_hca_handle->async_fd, set, DAPL_FD_READ);
 		dapl_fd_set(hca->ib_trans.rch->fd, set, DAPL_FD_READ);
-
+		
 		if (!dapl_llist_is_empty(&hca->ib_trans.list))
 			next = dapl_llist_peek_head(&hca->ib_trans.list);
 		else
@@ -1811,18 +2035,18 @@ void cm_thread(void *arg)
 			next = dapl_llist_next_entry(
 					&hca->ib_trans.list,
 					(DAPL_LLIST_ENTRY *)&cm->entry);
-
+			dapl_os_lock(&cm->lock);
 			if (cm->state == DCM_DESTROY || 
 			    hca->ib_trans.cm_state != IB_THREAD_RUN) {
 				dapl_llist_remove_entry(
 					&hca->ib_trans.list,
 					(DAPL_LLIST_ENTRY *)&cm->entry);
+				dapl_os_unlock(&cm->lock);
 				dapl_os_free(cm, sizeof(*cm));
 				continue;
 			}
-		
-			/* TODO: Check and process retries here */
-
+			dapl_os_unlock(&cm->lock);
+			ucm_check_timers(cm, &time_ms);
 			continue;
 		}
 
@@ -1832,9 +2056,7 @@ void cm_thread(void *arg)
 			break;
 
 		dapl_os_unlock(&hca->ib_trans.lock);
-		dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread: select sleep\n");
-		dapl_select(set);
-		dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread: select wake\n");
+		dapl_select(set, time_ms);
 
 		/* Process events: CM, ASYNC, NOTIFY THREAD */
 		if (dapl_poll(hca->ib_trans.rch->fd, 
@@ -1870,38 +2092,66 @@ out:
 /* Debug aid: List all Connections in process and state */
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 {
-	/* Print in process CR's for this IA, if debug type set */
+	/* Print in process CM's for this IA, if debug type set */
 	int i = 0;
-	dp_ib_cm_handle_t cr, next_cr;
+	dp_ib_cm_handle_t cm, next_cm;
+	struct dapl_llist_entry	*list;
+	DAPL_OS_LOCK lock;
+	
+	/* LISTEN LIST */
+	list = ia_ptr->hca_ptr->ib_trans.llist;
+	lock = ia_ptr->hca_ptr->ib_trans.llock;
 
-	dapl_os_lock(&ia_ptr->hca_ptr->ib_trans.lock);
-	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)
-				 &ia_ptr->hca_ptr->ib_trans.list))
-				 next_cr = dapl_llist_peek_head((DAPL_LLIST_HEAD*)
-				 &ia_ptr->hca_ptr->ib_trans.list);
+	dapl_os_lock(&lock);
+	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&list))
+		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)&list);
  	else
-		next_cr = NULL;
-
-        printf("\n DAPL IA CONNECTIONS IN PROCESS:\n");
-	while (next_cr) {
-		cr = next_cr;
-		next_cr = dapl_llist_next_entry((DAPL_LLIST_HEAD*)
-				 &ia_ptr->hca_ptr->ib_trans.list,
-				(DAPL_LLIST_ENTRY*)&cr->entry);
-
-		printf( "  CONN[%d]: sp %p ep %p %s %s %s"
-			" dst lid %x iqp %x port %d\n",
-			i, cr->sp, cr->ep, 
-			cr->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
-			dapl_cm_state_str(cr->state),
-			cr->sp ? "<-" : "->",
-			ntohs(cr->msg.daddr.ib.lid),
-			ntohl(cr->msg.daddr.ib.qpn),			
-			cr->sp ? 
-			(int)cr->sp->conn_qual : ntohs(cr->msg.dport) );
+		next_cm = NULL;
+
+        printf("\n DAPL IA LISTEN/CONNECTIONS IN PROCESS:\n");
+	while (next_cm) {
+		cm = next_cm;
+		next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)list,
+						(DAPL_LLIST_ENTRY*)&cm->entry);
+
+		printf( "  LISTEN[%d]: sp %p %s uCM_QP: 0x%x %d 0x%x\n",
+			i, cm->sp, dapl_cm_state_str(cm->state),
+			ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+			ntohl(cm->msg.sqpn));
+		i++;
+	}
+	dapl_os_unlock(&lock);
+
+	/* CONNECTION LIST */
+	list = ia_ptr->hca_ptr->ib_trans.list;
+	lock = ia_ptr->hca_ptr->ib_trans.lock;
+
+	dapl_os_lock(&lock);
+	if (!dapl_llist_is_empty((DAPL_LLIST_HEAD*)&list))
+		next_cm = dapl_llist_peek_head((DAPL_LLIST_HEAD*)&list);
+ 	else
+		next_cm = NULL;
+
+        while (next_cm) {
+		cm = next_cm;
+		next_cm = dapl_llist_next_entry((DAPL_LLIST_HEAD*)&list,
+						(DAPL_LLIST_ENTRY*)&cm->entry);
+
+		printf( "  CONN[%d]: ep %p cm %p %s %s"
+			"  0x%x %d 0x%x %s 0x%x %d 0x%x\n",
+			i, cm->ep, cm,
+			cm->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
+			dapl_cm_state_str(cm->state),
+			ntohs(cm->msg.saddr.ib.lid),
+			ntohs(cm->msg.sport),
+			ntohl(cm->msg.saddr.ib.qpn),	
+			cm->sp ? "<-" : "->",
+			ntohs(cm->msg.daddr.ib.lid),
+			ntohs(cm->msg.dport),
+			ntohl(cm->msg.daddr.ib.qpn));
 		i++;
 	}
 	printf("\n");
-	dapl_os_unlock(&ia_ptr->hca_ptr->ib_trans.lock);
+	dapl_os_unlock(&lock);
 }
 #endif
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index ef5358a..53f00bb 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -33,13 +33,11 @@
 #include "openib_osd.h"
 #include "dapl_ib_common.h"
 
-#define UCM_DEFAULT_CQE 500
-#define UCM_DEFAULT_QPE 500
-
 struct ib_cm_handle
 { 
 	struct dapl_llist_entry	entry;
 	DAPL_OS_LOCK		lock;
+	DAPL_OS_TIMEVAL		timer;
 	int			state;
 	int			retries;
 	struct dapl_hca		*hca;
@@ -92,6 +90,10 @@ typedef struct _ib_hca_transport
 	DAPL_SOCKET		scm[2];
 	int			cqe;
 	int			qpe;
+	int			retries;
+	int			cm_timer;
+	int			rep_time;
+	int			rtu_time;
 	DAPL_OS_LOCK		slock;	
 	int			s_hd;
 	int			s_tl;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index b887186..bd31cea 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -421,9 +421,13 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " ucm_create: \n");
 
-	/* get queue sizes */
-	tp->qpe = dapl_os_get_env_val("DAPL_UCM_QPE", UCM_DEFAULT_QPE);
-	tp->cqe = dapl_os_get_env_val("DAPL_UCM_CQE", UCM_DEFAULT_CQE);
+	/* setup CM timers and queue sizes */
+	tp->retries = dapl_os_get_env_val("DAPL_UCM_RETRY", DCM_RETRY_CNT);
+	tp->rep_time = dapl_os_get_env_val("DAPL_UCM_REP_TIME", DCM_REP_TIME);
+	tp->rtu_time = dapl_os_get_env_val("DAPL_UCM_RTU_TIME", DCM_RTU_TIME);
+	tp->cm_timer = DAPL_MIN(tp->rep_time,tp->rtu_time);
+	tp->qpe = dapl_os_get_env_val("DAPL_UCM_QP_SIZE", DCM_QP_SIZE);
+	tp->cqe = dapl_os_get_env_val("DAPL_UCM_CQ_SIZE", DCM_CQ_SIZE);
 	tp->pd = ibv_alloc_pd(hca->ib_hca_handle);
         if (!tp->pd) 
                 goto bail;
diff --git a/dat/include/dat2/dat_ib_extensions.h b/dat/include/dat2/dat_ib_extensions.h
index 59df1de..a32a4ed 100755
--- a/dat/include/dat2/dat_ib_extensions.h
+++ b/dat/include/dat2/dat_ib_extensions.h
@@ -71,9 +71,10 @@
  *         dat_query_counters(), dat_print_counters()
  *
  * 2.0.4 - Add DAT_IB_UD_CONNECTION_REJECT_EVENT extended UD event
+ * 2.0.5 - Add DAT_IB_UD extended UD connection error events
  *
  */
-#define DAT_IB_EXTENSION_VERSION	204	/* 2.0.4 */
+#define DAT_IB_EXTENSION_VERSION	205	/* 2.0.5 */
 #define DAT_ATTR_COUNTERS		"DAT_COUNTERS"
 #define DAT_IB_ATTR_FETCH_AND_ADD	"DAT_IB_FETCH_AND_ADD"
 #define DAT_IB_ATTR_CMP_AND_SWAP	"DAT_IB_CMP_AND_SWAP"
@@ -92,7 +93,8 @@ typedef enum dat_ib_event_number
 	DAT_IB_DTO_EVENT = DAT_IB_EXTENSION_RANGE_BASE,
 	DAT_IB_UD_CONNECTION_REQUEST_EVENT,
 	DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED,
-	DAT_IB_UD_CONNECTION_REJECT_EVENT
+	DAT_IB_UD_CONNECTION_REJECT_EVENT,
+	DAT_IB_UD_CONNECTION_ERROR_EVENT
 
 } DAT_IB_EVENT_NUMBER;
 
@@ -129,7 +131,9 @@ typedef enum dat_ib_ext_type
 	DAT_IB_UD_REMOTE_AH,		// 6
 	DAT_IB_UD_PASSIVE_REMOTE_AH,	// 7
 	DAT_IB_UD_SEND,			// 8
-	DAT_IB_UD_RECV			// 9
+	DAT_IB_UD_RECV,			// 9
+	DAT_IB_UD_CONNECT_REJECT,	// 10
+	DAT_IB_UD_CONNECT_ERROR,	// 11
 
 } DAT_IB_EXT_TYPE;
 
-- 
1.5.2.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
