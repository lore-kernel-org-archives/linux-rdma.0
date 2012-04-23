From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/15] uDAPL v2.0 scm: update socket cm provider to support
 new CM stat and error counters
Date: Mon, 23 Apr 2012 20:01:07 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120292@ORSMSX101.amr.corp.intel.com>
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
 dapl/openib_scm/cm.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index cac6a72..b095c2f 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -487,6 +487,7 @@ DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
 						     NULL, 0, cm_ptr->ep);
 		}
 	}
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_DREQ_TX);
 	
 	/* release from workq */
 	dapli_cm_free(cm_ptr);
@@ -526,6 +527,7 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 			dapli_cm_free(cm_ptr);
 			return;
 		}
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_ERR_TIMEOUT);
 		goto bail;
 	}
 
@@ -572,9 +574,13 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 		     htonll(*(uint64_t*)&cm_ptr->msg.saddr.ib.gid[0]),
 		     (unsigned long long)
 		     htonll(*(uint64_t*)&cm_ptr->msg.saddr.ib.gid[8]));
+
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_REQ_TX);
 	return;
 
 bail:
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_ERR);
+
 	/* mark CM object for cleanup */
 	dapli_cm_free(cm_ptr);
 	dapl_evd_connection_callback(NULL, IB_CME_DESTINATION_REJECT, NULL, 0, ep_ptr);
@@ -688,6 +694,8 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
 	dapli_cm_queue(cm_ptr);
 	return DAT_SUCCESS;
 bail:
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_ERR);
+
 	dapl_log(DAPL_DBG_TYPE_ERR,
 		 " connect ERROR: -> %s r_qual %d\n",
 		 inet_ntoa(((struct sockaddr_in *)r_addr)->sin_addr),
@@ -737,6 +745,7 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 		}
 		goto bail;
 	}
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_REP_RX);
 
 	/* keep the QP, address info in network order */
 	
@@ -870,6 +879,8 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 	/* post the event with private data */
 	event = IB_CME_CONNECTED;
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " ACTIVE: connected!\n");
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_RTU_TX);
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_ACTIVE_EST);
 
 #ifdef DAT_EXTENSIONS
 ud_bail:
@@ -900,6 +911,9 @@ ud_bail:
 					cm_ptr->ah, 
 					ntohs(cm_ptr->msg.saddr.ib.lid),
 					ntohl(cm_ptr->msg.saddr.ib.qpn));
+
+				DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)),
+					    DCNT_IA_CM_AH_RESOLVED);
 	
 			} else 
 				event = DAT_IB_UD_CONNECTION_ERROR_EVENT;
@@ -1014,6 +1028,8 @@ dapli_socket_listen(DAPL_IA * ia_ptr, DAT_CONN_QUAL serviceID, DAPL_SP * sp_ptr)
 		     " setup listen: port %d cr %p s_fd %d\n",
 		     serviceID + 1000, cm_ptr, cm_ptr->socket);
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_LISTEN);
+
 	return dat_status;
 bail:
 	/* Never queued, destroy here */
@@ -1128,6 +1144,8 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
 	acm_ptr->state = DCM_ACCEPTING_DATA;
 	dapl_os_unlock(&acm_ptr->lock);
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&acm_ptr->hca->ia_list_head)), DCNT_IA_CM_REQ_RX);
+
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT: DST %s %x lid=0x%x, qpn=0x%x, psz=%d\n",
 		     inet_ntoa(((struct sockaddr_in *)
@@ -1151,6 +1169,9 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
 					    (DAT_COUNT) exp,
 					    (DAT_PVOID *) acm_ptr->msg.p_data,
 					    (DAT_PVOID *) &xevent);
+
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&acm_ptr->hca->ia_list_head)),
+			    DCNT_IA_CM_AH_REQ_RX);
 	} else
 #endif
 		/* trigger CR event and return SUCCESS */
@@ -1318,6 +1339,8 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: accepted!\n");
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_REP_TX);
+
 	return DAT_SUCCESS;
 bail:
 	/* schedule cleanup from workq */
@@ -1345,6 +1368,8 @@ static void dapli_socket_accept_rtu(dp_ib_cm_handle_t cm_ptr)
 		goto bail;
 	}
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_RTU_RX);
+
 	/* save state and reference to EP, queue for disc event */
 	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_CONNECTED;
@@ -1395,6 +1420,8 @@ ud_bail:
 				(DAT_PVOID *) cm_ptr->msg.p_data,
 				(DAT_PVOID *) &xevent);
 
+		DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)), DCNT_IA_CM_AH_RESOLVED);
+
                 /* cleanup and release from local list, still on EP list */
 		dapli_cm_free(cm_ptr);
                 
@@ -1683,6 +1710,10 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm_ptr,
 		writev(cm_ptr->socket, iov, 1);
 	}
 
+	DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cm_ptr->hca->ia_list_head)),
+			  reason == IB_CM_REJ_REASON_CONSUMER_REJ ?
+			  DCNT_IA_CM_USER_REJ_TX : DCNT_IA_CM_ERR_REJ_TX);
+
 	/* release and cleanup CM object */
 	dapli_cm_free(cm_ptr);
 	return DAT_SUCCESS;
@@ -1837,6 +1868,8 @@ void cr_thread(void *arg)
 						break;
 					case DCM_CONNECTED:
 						dapl_os_unlock(&cr->lock);
+						DAPL_CNTR(((DAPL_IA *)dapl_llist_peek_head(&cr->hca->ia_list_head)),
+							    DCNT_IA_CM_DREQ_RX);
 						dapli_socket_disconnect(cr);
 						break;
 					case DCM_DISCONNECTED:
@@ -1958,3 +1991,4 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 	dapl_os_unlock(&ia_ptr->hca_ptr->ib_trans.lock);
 }
 #endif
+
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
