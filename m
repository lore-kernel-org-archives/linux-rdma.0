From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] DAPL v2.0: ucm: hold lock when sending ucm msgs to sync
 timer start with packet send
Date: Fri, 3 Dec 2010 15:33:12 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D94F9@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Releasing the lock after setting start timer and before
ucm_send could result in incorrect timeout on CM operations
if thread is scheduled out when releasing lock.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 25b3a39..fd3106a 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -969,13 +969,15 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		return DAT_ERROR(DAT_INVALID_ADDRESS, 
 				 DAT_INVALID_ADDRESS_UNREACHABLE);
 	}
-	dapl_os_unlock(&cm->lock);
 
 	cm->msg.op = htons(DCM_REQ);
 	dapl_os_get_time(&cm->timer); /* reply expected */
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, 
-		     &cm->msg.p_data, ntohs(cm->msg.p_size))) 		
+		     &cm->msg.p_data, ntohs(cm->msg.p_size))) {
+		dapl_os_unlock(&cm->lock);
 		goto bail;
+	}
+	dapl_os_unlock(&cm->lock);
 
 	/* first time through, link EP and CM, put on work queue */
 	if (!cm->retries) {
@@ -1183,7 +1185,6 @@ ud_bail:
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
-		dapli_cm_free(cm); /* still attached to EP */
 	} else
 #endif
 	{
@@ -1409,7 +1410,6 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 			
 		dapl_os_unlock(&cm->lock);
 #ifdef DAPL_COUNTERS
-		/* called from check_timers in cm_thread, cm lock held */
 		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST) {
 			dapl_os_unlock(&cm->hca->ib_trans.lock);
 			dapls_print_cm_list(dapl_llist_peek_head(&cm->hca->ia_list_head));
@@ -1437,12 +1437,14 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 					  NULL, 0, cm->sp);
 		return -1;
 	}
+
 	dapl_os_get_time(&cm->timer); /* RTU expected */
-	dapl_os_unlock(&cm->lock);
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) {
 		dapl_log(DAPL_DBG_TYPE_ERR," accept ERR: ucm reply send()\n");
+		dapl_os_unlock(&cm->lock);
 		return -1;
 	}
+	dapl_os_unlock(&cm->lock);
 	return 0;
 }
 
@@ -1545,9 +1547,9 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
 		       &cm->hca->ib_trans.addr.ib.gid, 16); 
 
-	/* 
-	 * UD: deliver p_data with REQ and EST event, keep REQ p_data in 
-	 * cm->msg.p_data and save REPLY accept data in cm->p_data for retries 
+	/*
+	 * UD: deliver p_data with REQ and EST event, keep REQ p_data in
+	 * cm->msg.p_data and save REPLY accept data in cm->p_data for retries
 	 */
 	cm->p_size = p_size;
 	dapl_os_memcpy(&cm->p_data, p_data, p_size);
@@ -1556,16 +1558,19 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_ep_link_cm(ep, cm);
 	cm->ep = ep;
 	cm->hca = ia->hca_ptr;
-	
+
+	/* Send RTU and change state under CM lock */
 	dapl_os_lock(&cm->lock);
-	dapl_os_get_time(&cm->timer); /* RTU expected */
 	cm->state = DCM_RTU_PENDING;
-	dapl_os_unlock(&cm->lock);
-
-	if (ucm_reply(cm)) {
+	dapl_os_get_time(&cm->timer); /* RTU expected */
+	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) {
+		dapl_log(DAPL_DBG_TYPE_ERR," accept ERR: ucm reply send()\n");
+		dapl_os_unlock(&cm->lock);
 		dapl_ep_unlink_cm(ep, cm);
 		goto bail;
 	}
+	dapl_os_unlock(&cm->lock);
+
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
 	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	return DAT_SUCCESS;
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
