From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/9] dapl-2.0: cma, ucm: cleanup issues with dat_ep_free on
 a connected EP without disconnecting.
Date: Wed, 19 May 2010 11:25:18 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130DC@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


During EP free, disconnecting with ABRUPT close flag, the disconnect should wait
for the DISC event to fire to allow the CM to be properly destroyed upon return.

The cma must also release the lock when calling the blocking rdma_destroy_id given
the callback thread could attempt to acquire the lock for reference counting.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |   56 ++++++++++++++++++++++++++++++++++++-------------
 dapl/openib_ucm/cm.c |   15 ++++++++++++-
 2 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 1e846aa..503df96 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -209,18 +209,13 @@ void dapls_cm_acquire(dp_ib_cm_handle_t conn)
 void dapls_cm_release(dp_ib_cm_handle_t conn)
 {
 	dapl_os_lock(&conn->lock);
-	conn->ref_count--;
-	if (conn->ref_count) {
-                dapl_os_unlock(&conn->lock);
-		return;
-	}
-	if (conn->cm_id) {
-		if (conn->cm_id->qp)
-			rdma_destroy_qp(conn->cm_id);
-		rdma_destroy_id(conn->cm_id);
-	}
-	dapl_os_unlock(&conn->lock);
-	dapli_cm_dealloc(conn);
+	conn->ref_count--;
+	if (conn->ref_count) {
+                dapl_os_unlock(&conn->lock);
+		return;
+	}
+	dapl_os_unlock(&conn->lock);
+	dapli_cm_dealloc(conn);
 }
 
 /* BLOCKING: called from dapl_ep_free, EP link will be last ref */
@@ -235,10 +230,14 @@ void dapls_cm_free(dp_ib_cm_handle_t conn)
 	/* Destroy cm_id, wait until EP is last ref */
 	dapl_os_lock(&conn->lock);
 	if (conn->cm_id) {
-		if (conn->cm_id->qp)
-			rdma_destroy_qp(conn->cm_id);
-		rdma_destroy_id(conn->cm_id);
+		struct rdma_cm_id *cm_id = conn->cm_id;
+
+		if (cm_id->qp)
+			rdma_destroy_qp(cm_id);
 		conn->cm_id = NULL;
+		dapl_os_unlock(&conn->lock);
+		rdma_destroy_id(cm_id); /* blocking, event processing */
+		dapl_os_lock(&conn->lock);
 	}
 
 	/* EP linking is last reference */
@@ -640,6 +639,17 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 	/* no graceful half-pipe disconnect option */
 	rdma_disconnect(conn->cm_id);
 
+	/* ABRUPT close, wait for callback and DISCONNECTED state */
+	if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
+		dapl_os_lock(&ep_ptr->header.lock);
+		while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
+			dapl_os_unlock(&ep_ptr->header.lock);
+			dapl_os_sleep_usec(10000);
+			dapl_os_lock(&ep_ptr->header.lock);
+		}
+		dapl_os_unlock(&ep_ptr->header.lock);
+	}
+
 	/* 
 	 * DAT event notification occurs from the callback
 	 * Note: will fire even if DREQ goes unanswered on timeout 
@@ -759,6 +769,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
 	return DAT_SUCCESS;
 
 bail:
+	rdma_destroy_id(conn->cm_id);
 	dapls_cm_release(conn);
 	return dat_status;
 }
@@ -791,8 +802,13 @@ dapls_ib_remove_conn_listener(IN DAPL_IA * ia_ptr, IN DAPL_SP * sp_ptr)
 
 	if (conn != IB_INVALID_HANDLE) {
 		sp_ptr->cm_srvc_handle = NULL;
+		if (conn->cm_id) {
+			rdma_destroy_id(conn->cm_id);
+			conn->cm_id = NULL;
+		}
 		dapls_cm_release(conn);
 	}
+		
 	return DAT_SUCCESS;
 }
 
@@ -869,6 +885,7 @@ dapls_ib_accept_connection(IN DAT_CR_HANDLE cr_handle,
 		dapl_ep_unlink_cm(ep_ptr, ep_conn);
 		ep_conn->cm_id->qp = NULL;
 		ep_conn->ep = NULL;
+		rdma_destroy_id(ep_conn->cm_id);
 		dapls_cm_release(ep_conn);
 
 		/* add new CM to EP linking, qp_handle unchanged */
@@ -912,6 +929,7 @@ bail:
 	rdma_reject(cr_conn->cm_id, NULL, 0);
 
 	/* no EP linking, ok to destroy */
+	rdma_destroy_id(cr_conn->cm_id);
 	dapls_cm_release(cr_conn);
 	return dat_status;
 }
@@ -974,6 +992,7 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm_handle,
 			  cm_handle->p_data, offset + private_data_size);
 
 	/* no EP linking, ok to destroy */
+	rdma_destroy_id(cm_handle->cm_id);
 	dapls_cm_release(cm_handle);
 	return dapl_convert_errno(ret, "reject");
 }
@@ -1067,6 +1086,13 @@ void dapli_cma_event_cb(void)
 
 		dapls_cm_acquire(conn);
 		
+		/* destroying cm_id, consumer thread blocking waiting for ACK */
+		if (conn->cm_id == NULL) {
+			dapls_cm_release(conn);
+			rdma_ack_cm_event(event);
+			return;
+		}
+
 		dapl_dbg_log(DAPL_DBG_TYPE_CM,
 			     " cm_event: EVENT=%d ID=%p LID=%p CTX=%p\n",
 			     event->event, event->id, event->listen_id, conn);
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 5d5e7d2..c82147e 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1586,7 +1586,20 @@ dapls_ib_disconnect(IN DAPL_EP *ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 	} 
 	dapl_os_unlock(&ep_ptr->header.lock);
 	
-	return (dapli_cm_disconnect(cm_ptr));
+	dapli_cm_disconnect(cm_ptr);
+
+        /* ABRUPT close, wait for callback and DISCONNECTED state */
+        if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
+                dapl_os_lock(&ep_ptr->header.lock);
+                while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
+                        dapl_os_unlock(&ep_ptr->header.lock);
+                        dapl_os_sleep_usec(10000);
+                        dapl_os_lock(&ep_ptr->header.lock);
+                }
+                dapl_os_unlock(&ep_ptr->header.lock);
+        }
+
+	return DAT_SUCCESS;
 }
 
 /*
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
