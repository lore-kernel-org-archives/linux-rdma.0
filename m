From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/11] ucm: update ucm provider for windows environment
Date: Fri, 16 Oct 2009 16:48:44 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CB7@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


add dapls_thread_signal abstraction and a new
cm_thread function specific for windows.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |  181 +++++++++++++++++++++++--------------------------
 1 files changed, 85 insertions(+), 96 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 099cadf..36ea419 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -35,87 +35,8 @@
 
 
 #if defined(_WIN32) || defined(_WIN64)
-enum DAPL_FD_EVENTS {
-	DAPL_FD_READ = 0x1,
-	DAPL_FD_WRITE = 0x2,
-	DAPL_FD_ERROR = 0x4
-};
-
-struct dapl_fd_set {
-	struct fd_set set[3];
-};
-
-static struct dapl_fd_set *dapl_alloc_fd_set(void)
-{
-	return dapl_os_alloc(sizeof(struct dapl_fd_set));
-}
-
-static void dapl_fd_zero(struct dapl_fd_set *set)
-{
-	FD_ZERO(&set->set[0]);
-	FD_ZERO(&set->set[1]);
-	FD_ZERO(&set->set[2]);
-}
-
-static int dapl_fd_set(DAPL_SOCKET s, struct dapl_fd_set *set,
-		       enum DAPL_FD_EVENTS event)
-{
-	FD_SET(s, &set->set[(event == DAPL_FD_READ) ? 0 : 1]);
-	FD_SET(s, &set->set[2]);
-	return 0;
-}
-
-static enum DAPL_FD_EVENTS dapl_poll(DAPL_SOCKET s, enum DAPL_FD_EVENTS event)
-{
-	struct fd_set rw_fds;
-	struct fd_set err_fds;
-	struct timeval tv;
-	int ret;
-
-	FD_ZERO(&rw_fds);
-	FD_ZERO(&err_fds);
-	FD_SET(s, &rw_fds);
-	FD_SET(s, &err_fds);
-
-	tv.tv_sec = 0;
-	tv.tv_usec = 0;
-
-	if (event == DAPL_FD_READ)
-		ret = select(1, &rw_fds, NULL, &err_fds, &tv);
-	else
-		ret = select(1, NULL, &rw_fds, &err_fds, &tv);
-
-	if (ret == 0)
-		return 0;
-	else if (ret == SOCKET_ERROR)
-		return WSAGetLastError();
-	else if (FD_ISSET(s, &rw_fds))
-		return event;
-	else
-		return DAPL_FD_ERROR;
-}
-
-static int dapl_select(struct dapl_fd_set *set, int time_ms)
-{
-	int ret;
-	struct timeval tv, *p_tv = NULL;
-
-	if (time_ms != -1) {
-		p_tv = &tv;
-		tv.tv_sec = time_ms/1000; 
-		tv.tv_usec = (time_ms%1000)*1000;
-	}
-
-	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: sleep\n");
-	ret = select(0, &set->set[0], &set->set[1], &set->set[2], p_tv);
-	dapl_dbg_log(DAPL_DBG_TYPE_CM, " dapl_select: wakeup\n");
-
-	if (ret == SOCKET_ERROR)
-		dapl_dbg_log(DAPL_DBG_TYPE_CM,
-			     " dapl_select: error 0x%x\n", WSAGetLastError());
-
-	return ret;
-}
+#include "..\..\..\..\..\etc\user\comp_channel.cpp"
+#include <rdma\winverbs.h>
 #else				// _WIN32 || _WIN64
 enum DAPL_FD_EVENTS {
 	DAPL_FD_READ = POLLIN,
@@ -194,6 +115,7 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 static void ucm_disconnect_final(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm);
+static void dapls_thread_signal(struct dapl_hca *hca);
 
 #define UCM_SND_BURST	50	
 
@@ -753,7 +675,7 @@ static void ucm_ud_free(DAPL_EP *ep)
 
 	/* wakeup work thread if necessary */
 	if (hca)
-		send(tp->scm[1], "w", sizeof "w", 0);
+		dapls_thread_signal(hca);
 }
 
 /* mark for destroy, remove all references, schedule cleanup */
@@ -797,10 +719,10 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 	dapl_os_unlock(&cm->lock);
 
 	/* wakeup work thread */
-	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+	dapls_thread_signal(cm->hca);
 }
 
-/* ACTIVE/PASSIVE: queue up connection object on CM list, wakeup thread */
+/* ACTIVE/PASSIVE: queue up connection object on CM list */
 static void ucm_queue_conn(dp_ib_cm_handle_t cm)
 {
 	/* add to work queue, list, for cm thread processing */
@@ -809,7 +731,7 @@ static void ucm_queue_conn(dp_ib_cm_handle_t cm)
 	dapl_llist_add_tail(&cm->hca->ib_trans.list,
 			    (DAPL_LLIST_ENTRY *)&cm->entry, cm);
 	dapl_os_unlock(&cm->hca->ib_trans.lock);
-	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0); 
+	dapls_thread_signal(cm->hca);
 }
 
 /* PASSIVE: queue up listen object on listen list */
@@ -868,7 +790,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		cm->msg.op = htons(DCM_DREQ);
 		cm->retries = 1;
 		finalize = 0; /* wait for DREP, wakeup timer thread */
-		send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+		dapls_thread_signal(cm->hca);
 		break;
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
@@ -953,9 +875,9 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		goto bail;
 
 	/* first time through, put on work queue */
-	if (cm->retries == 1) 
+	if (cm->retries == 1)
 		ucm_queue_conn(cm);
-	
+
 	return DAT_SUCCESS;
 
 bail:
@@ -1482,12 +1404,9 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 
 	if (ucm_reply(cm))
 		goto bail;
-
-	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
 	
-	/* Timed RTU, wakeup thread */
-	send(cm->hca->ib_trans.scm[1], "w", sizeof "w", 0);
-
+	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
+	dapls_thread_signal(cm->hca);
 	return DAT_SUCCESS;
 bail:
 	if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
@@ -2001,7 +1920,78 @@ ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
 	return ib_cm_event;
 }
 
-/* work thread for uAT, uCM, CQ, and async events */
+#if defined(_WIN32) || defined(_WIN64)
+static void dapls_thread_signal(struct dapl_hca *hca)
+{
+//	CompSetCancel(&ufds);
+}
+
+void cm_thread(void *arg)
+{
+	struct dapl_hca *hca = arg;
+	dp_ib_cm_handle_t cm, next;
+	COMP_SET ufds;
+	DWORD time_ms;
+
+	CompSetInit(&ufds);
+
+	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread: ENTER hca %p\n", hca);
+	dapl_os_lock(&hca->ib_trans.lock);
+	for (hca->ib_trans.cm_state = IB_THREAD_RUN;
+	     hca->ib_trans.cm_state == IB_THREAD_RUN &&
+	     dapl_llist_is_empty(&hca->ib_trans.list);
+	     dapl_os_lock(&hca->ib_trans.lock)) {
+
+		time_ms = INFINITE;
+		CompSetZero(&ufds);
+		CompSetAdd(&hca->ib_hca_handle->channel, &ufds);
+		CompSetAdd(&hca->ib_trans.rch->comp_channel, &ufds);
+
+		next = dapl_llist_is_empty(&hca->ib_trans.list) ? NULL :
+			dapl_llist_peek_head(&hca->ib_trans.list);
+
+		while (next) {
+			cm = next;
+			next = dapl_llist_next_entry(&hca->ib_trans.list,
+						     (DAPL_LLIST_ENTRY *)&cm->entry);
+			dapl_os_lock(&cm->lock);
+			if (cm->state == DCM_DESTROY || 
+			    hca->ib_trans.cm_state != IB_THREAD_RUN) {
+				dapl_llist_remove_entry(&hca->ib_trans.list,
+							(DAPL_LLIST_ENTRY *)&cm->entry);
+				dapl_os_unlock(&cm->lock);
+				dapl_os_free(cm, sizeof(*cm));
+				continue;
+			}
+			dapl_os_unlock(&cm->lock);
+			ucm_check_timers(cm, &time_ms);
+		}
+
+		dapl_os_unlock(&hca->ib_trans.lock);
+
+		hca->ib_hca_handle->channel.Milliseconds = time_ms;
+		hca->ib_trans.rch->comp_channel.Milliseconds = time_ms;
+		CompSetPoll(&ufds, time_ms);
+
+		hca->ib_hca_handle->channel.Milliseconds = 0;
+		hca->ib_trans.rch->comp_channel.Milliseconds = 0;
+		ucm_recv(&hca->ib_trans);
+		ucm_async_event(hca);
+	}
+
+	CompSetCleanup(&ufds);
+	hca->ib_trans.cm_state = IB_THREAD_EXIT;
+	dapl_os_unlock(&hca->ib_trans.lock);
+	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread(hca %p) exit\n", hca);
+}
+
+#else				// _WIN32 || _WIN64
+
+static void dapls_thread_signal(struct dapl_hca *hca)
+{
+	send(hca->ib_trans.scm[1], "w", sizeof "w", 0);
+}
+
 void cm_thread(void *arg)
 {
 	struct dapl_hca *hca = arg;
@@ -2047,7 +2037,6 @@ void cm_thread(void *arg)
 			}
 			dapl_os_unlock(&cm->lock);
 			ucm_check_timers(cm, &time_ms);
-			continue;
 		}
 
 		/* set to exit and all resources destroyed */
@@ -2086,7 +2075,7 @@ out:
 	hca->ib_trans.cm_state = IB_THREAD_EXIT;
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread(hca %p) exit\n", hca);
 }
-
+#endif
 
 #ifdef DAPL_COUNTERS
 /* Debug aid: List all Connections in process and state */
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
