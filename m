From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/9] dapl-2.0: scm: cr_thread occasionally segv's when
 disconnecting all-to-all MPI static connections
Date: Wed, 19 May 2010 11:25:22 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130DF@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Note: no valid calltrace for segv on cr_thread because
of state changing in switch statement from another
thread, jumped unknown location.

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x41a65940 (LWP 1328)]
0x00002b2e7d9d5134 in ?? ()

Add cm object locking on all state change/checking. When
freeing CM object wakeup cr_thread to process
state change to CM_FREE.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 4c8d4a1..975ffd5 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -436,6 +436,7 @@ void dapls_cm_free(dp_ib_cm_handle_t cm_ptr)
 	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_FREE;
 	while (cm_ptr->ref_count != 1) {
+		dapli_cm_thread_signal(cm_ptr);
 		dapl_os_unlock(&cm_ptr->lock);
 		dapl_os_sleep_usec(10000);
 		dapl_os_lock(&cm_ptr->lock);
@@ -524,7 +525,9 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 		goto bail;
 	}
 
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_REP_PENDING;
+	dapl_os_unlock(&cm_ptr->lock);
 
 	/* send qp info and pdata to remote peer */
 	exp = sizeof(ib_cm_msg_t) - DCM_MAX_PDATA_SIZE;
@@ -836,7 +839,10 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " connect_rtu: send RTU\n");
 
 	/* complete handshake after final QP state change, Just ver+op */
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_CONNECTED;
+	dapl_os_unlock(&cm_ptr->lock);
+
 	cm_ptr->msg.op = ntohs(DCM_RTU);
 	if (send(cm_ptr->socket, (char *)&cm_ptr->msg, 4, 0) == -1) {
 		int err = dapl_socket_errno();
@@ -914,7 +920,10 @@ bail:
 		goto ud_bail;
 #endif
 	/* close socket, and post error event */
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_REJECTED;
+	dapl_os_unlock(&cm_ptr->lock);
+
 	dapl_evd_connection_callback(NULL, event, cm_ptr->msg.p_data,
 				     DCM_MAX_PDATA_SIZE, ep_ptr);
 	dapli_cm_free(cm_ptr);
@@ -1093,8 +1102,9 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
 		}
 		p_data = acm_ptr->msg.p_data;
 	}
-
+	dapl_os_lock(&acm_ptr->lock);
 	acm_ptr->state = DCM_ACCEPTING_DATA;
+	dapl_os_unlock(&acm_ptr->lock);
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT: DST %s %x lid=0x%x, qpn=0x%x, psz=%d\n",
@@ -1235,7 +1245,9 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 	dapl_os_memcpy(local.resv, cm_ptr->msg.resv, 4); 
 #endif
 	cm_ptr->hca = ia_ptr->hca_ptr;
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_ACCEPTED;
+	dapl_os_unlock(&cm_ptr->lock);
 
 	/* Link CM to EP, already queued on work thread */
 	dapl_ep_link_cm(ep_ptr, cm_ptr);
@@ -1305,7 +1317,9 @@ static void dapli_socket_accept_rtu(dp_ib_cm_handle_t cm_ptr)
 	}
 
 	/* save state and reference to EP, queue for disc event */
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_CONNECTED;
+	dapl_os_unlock(&cm_ptr->lock);
 
 	/* final data exchange if remote QP state is good to go */
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: connected!\n");
@@ -1368,7 +1382,10 @@ bail:
 	if (cm_ptr->msg.saddr.ib.qp_type == IBV_QPT_UD) 
 		goto ud_bail;
 #endif
+	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_REJECTED;
+	dapl_os_unlock(&cm_ptr->lock);
+
 	dapls_cr_callback(cm_ptr, event, NULL, 0, cm_ptr->sp);
 	dapli_cm_free(cm_ptr);
 }
@@ -1759,47 +1776,55 @@ void cr_thread(void *arg)
 				     cr->socket);
 
 			/* data on listen, qp exchange, and on disc req */
+			dapl_os_lock(&cr->lock);
 			if ((ret == DAPL_FD_READ) || 
 			    (cr->state != DCM_CONN_PENDING && ret == DAPL_FD_ERROR)) {
 				if (cr->socket != DAPL_INVALID_SOCKET) {
 					switch (cr->state) {
 					case DCM_LISTEN:
+						dapl_os_unlock(&cr->lock);
 						dapli_socket_accept(cr);
-						break;
+                                                break;
 					case DCM_ACCEPTING:
+						dapl_os_unlock(&cr->lock);
 						dapli_socket_accept_data(cr);
 						break;
 					case DCM_ACCEPTED:
+						dapl_os_unlock(&cr->lock);
 						dapli_socket_accept_rtu(cr);
 						break;
 					case DCM_REP_PENDING:
+						dapl_os_unlock(&cr->lock);
 						dapli_socket_connect_rtu(cr);
 						break;
 					case DCM_CONNECTED:
+						dapl_os_unlock(&cr->lock);
 						dapli_socket_disconnect(cr);
 						break;
 					default:
+						dapl_os_unlock(&cr->lock);
 						break;
 					}
-				}
+				} else 
+					dapl_os_unlock(&cr->lock);
+
 			/* ASYNC connections, writable, readable, error; check status */
 			} else if (ret == DAPL_FD_WRITE ||
 				   (cr->state == DCM_CONN_PENDING && 
 				    ret == DAPL_FD_ERROR)) {
-
-			        if (ret == DAPL_FD_ERROR)
-					dapl_log(DAPL_DBG_TYPE_ERR, " CONN_PENDING - FD_ERROR\n");
 				
 				opt = 0;
 				opt_len = sizeof(opt);
 				ret = getsockopt(cr->socket, SOL_SOCKET,
 						 SO_ERROR, (char *)&opt,
 						 &opt_len);
+				dapl_os_unlock(&cr->lock);
 				if (!ret && !opt)
 					dapli_socket_connected(cr, opt);
 				else
 					dapli_socket_connected(cr, opt ? opt : dapl_socket_errno());
-			} 
+			} else 
+				dapl_os_unlock(&cr->lock);
 
 			dapls_cm_release(cr); /* release ref */
 			dapl_os_lock(&hca_ptr->ib_trans.lock);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
