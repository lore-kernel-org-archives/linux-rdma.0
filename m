From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] openib: add IB UD cm_free/ah_free extension support in UCM provider
Date: Mon, 15 Dec 2014 10:11:39 -0800
Message-ID: <1418667099-32449-4-git-send-email-arlin.r.davis@intel.com>
References: <1418667099-32449-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418667099-32449-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make changes to UCM provider for new CM and AH destroy extensions.
Allow consumer to schedule CM object destroy after CM connection
event has been processed. Active side will put CM object in
TIMEWAIT in case RTU is dropped, passive side can schedule
CM object destroy immediatly when called. In the case where
consumer requests CM object destroy, the provider will remove
all internal references to AH since consumer will call AH
destroy directly when finished with UD sends.

All other providers, MCM, CMA, SCM will return UNSUPPORTED
if new extensions are called.

See dtestx source for code examples of new extensions.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c           |    5 +++
 dapl/openib_cma/dapl_ib_util.h |    1 +
 dapl/openib_mcm/cm.c           |    5 +++
 dapl/openib_mcm/dapl_ib_util.h |    1 +
 dapl/openib_scm/cm.c           |    5 +++
 dapl/openib_scm/dapl_ib_util.h |    1 +
 dapl/openib_ucm/cm.c           |   77 ++++++++++++++++++++++++++++++++++++++-
 dapl/openib_ucm/dapl_ib_util.h |    1 +
 8 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 34ae3e3..18d9d09 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -262,6 +262,11 @@ void dapls_cm_free(dp_ib_cm_handle_t conn)
 	dapl_ep_unlink_cm(conn->ep, conn);
 }
 
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr)
+{
+	return DAT_NOT_IMPLEMENTED;
+}
+
 static struct dapl_cm_id *dapli_req_recv(struct dapl_cm_id *conn,
 					 struct rdma_cm_event *event)
 {
diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index de95485..1f3b63c 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -156,6 +156,7 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
 void dapls_cm_acquire(dp_ib_cm_handle_t cm);
 void dapls_cm_release(dp_ib_cm_handle_t cm);
 void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr);
 
 #ifdef DAPL_COUNTERS
 STATIC _INLINE_ void dapls_print_cm_list(IN DAPL_IA * ia_ptr)
diff --git a/dapl/openib_mcm/cm.c b/dapl/openib_mcm/cm.c
index 4c6778a..71f7355 100644
--- a/dapl/openib_mcm/cm.c
+++ b/dapl/openib_mcm/cm.c
@@ -817,6 +817,11 @@ void dapls_cm_free(dp_ib_cm_handle_t cm)
 	dapl_ep_unlink_cm(cm->ep, cm);
 }
 
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr)
+{
+	return DAT_NOT_IMPLEMENTED;
+}
+
 /* ACTIVE/PASSIVE: queue up connection object on CM list */
 void dapli_queue_conn(dp_ib_cm_handle_t cm)
 {
diff --git a/dapl/openib_mcm/dapl_ib_util.h b/dapl/openib_mcm/dapl_ib_util.h
index 9d9d73c..ab4d658 100644
--- a/dapl/openib_mcm/dapl_ib_util.h
+++ b/dapl/openib_mcm/dapl_ib_util.h
@@ -167,6 +167,7 @@ void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr);
 dp_ib_cm_handle_t dapls_cm_create(DAPL_HCA *hca, DAPL_EP *ep);
 DAT_RETURN dapls_modify_qp_rtu(struct ibv_qp *qp, uint32_t qpn, uint16_t lid, ib_gid_handle_t gid);
 
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index cf6993f..680d16b 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -470,6 +470,11 @@ void dapls_cm_free(dp_ib_cm_handle_t cm_ptr)
 	dapl_ep_unlink_cm(cm_ptr->ep, cm_ptr);
 }
 
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr)
+{
+	return DAT_NOT_IMPLEMENTED;
+}
+
 /*
  * ACTIVE/PASSIVE: called from CR thread or consumer via ep_disconnect
  *                 or from ep_free. 
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index d382226..0f48c44 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -141,6 +141,7 @@ void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr);
 
 #ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index a1e909a..e462632 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -226,6 +226,37 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
                         return;
 		}
 		break;
+	case DCM_TIMEWAIT:
+		/* TIMEWAIT after CM info saved, consumer called dat_ib_ud_cm_free() */
+		*timer = cm->hca->ib_trans.cm_timer;
+		if ((time - cm->timer)/1000 >
+		     (cm->hca->ib_trans.rtu_time << cm->retries)) {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				 " CM_TIMEWAIT %d %p [lid, port, cqp, iqp]:"
+				 " %x %x %x %x -> %x %x %x %x r_pid %x"
+				 " Time(ms) %d > %d\n",
+				 cm->retries+1, cm,
+				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+				 ntohl(cm->msg.d_id),
+				 (time - cm->timer)/1000,
+				 cm->hca->ib_trans.rtu_time << cm->retries);
+			cm->retries++;
+		}
+		if (cm->retries > 2) {
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+				" CM_TIMEWAIT expired (%d ms) for CM %p\n",
+				 cm, (time - cm->timer)/1000);
+			cm->ah = NULL;  /* consumer will free AH */
+			cm->state = DCM_FREE;
+			dapl_os_unlock(&cm->lock);
+			dapl_ep_unlink_cm(cm->ep, cm);  /* last CM ref */
+			return;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -700,6 +731,11 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
                 dapl_os_unlock(&cm->lock);
 		return;
 	}
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " dapls_cm_release: cm %p %s ep %p sp %p refs=%d\n",
+		 cm, dapl_cm_state_str(cm->state),
+		 cm->ep, cm->sp, cm->ref_count);
+
 	/* client, release local conn id port */
 	if (!cm->sp && cm->msg.sport)
 		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
@@ -763,6 +799,11 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 		dapl_os_memcpy(&cm->msg.saddr.ib.gid[0], 
 			       &hca->ib_trans.addr.ib.gid, 16);
         }
+	dapl_log(DAPL_DBG_TYPE_CM,
+		 " dapls_ib_cm_create: cm %p %s ep %p sp %p refs=%d\n",
+		 cm, dapl_cm_state_str(cm->state),
+		 cm->ep, cm->sp, cm->ref_count);
+
 	return cm;
 bail:
 	dapl_os_free(cm, sizeof(*cm));
@@ -825,6 +866,36 @@ void dapls_cm_free(dp_ib_cm_handle_t cm)
 	dapl_ep_unlink_cm(cm->ep, cm);
 }
 
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep, dp_ib_cm_handle_t cm)
+{
+	dapl_log(DAPL_DBG_TYPE_EXTENSION,
+		 " ud_cm_free: EP %p CM->ep %p CM %p refs %d\n",
+		 ep, cm->ep, cm, cm->ref_count);
+
+	if ((cm->ep != ep) ||
+	    (ep->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC)) {
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			 " ud_cm_free: WARN: EP %p != CM->EP %p or !UD type\n",
+			 ep, cm->ep);
+		return DAT_ERROR(DAT_INVALID_HANDLE, DAT_INVALID_HANDLE_EP);
+	}
+	cm->ah = NULL;  /* consumer freeing CM, will also free AH */
+
+	if (cm->sp) {
+		dapli_cm_free(cm); /* PASSIVE side: no need for time-wait */
+		dapl_ep_unlink_cm(cm->ep, cm); /* last CM ref, free memory */
+		return DAT_SUCCESS;
+	}
+
+	dapl_os_lock(&cm->hca->ib_trans.lock);
+	dapl_os_get_time(&cm->timer); /* ACTIVE side: in case RTU dropped */
+	cm->state = DCM_TIMEWAIT; /* schedule UD CM release */
+	dapl_os_unlock(&cm->hca->ib_trans.lock);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
+
+	return DAT_SUCCESS;
+}
+
 /* ACTIVE/PASSIVE: queue up connection object on CM list */
 static void dapli_queue_conn(dp_ib_cm_handle_t cm)
 {
@@ -1209,6 +1280,7 @@ ud_bail:
 		
 		/* post EVENT, modify_qp, AH already created, ucm msg */
 		xevent.status = 0;
+		xevent.context.as_ptr = cm;
 		xevent.type = DAT_IB_UD_REMOTE_AH;
 		xevent.remote_ah.qpn = ntohl(cm->msg.daddr.ib.qpn);
 		xevent.remote_ah.ah = dapls_create_ah(cm->hca, 
@@ -1278,11 +1350,11 @@ ud_bail:
 					     cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
 	}
 	dapl_log(DAPL_DBG_TYPE_CM_EST,
-		 " UCM_ACTIVE_CONN %p %d [lid port qpn] %x %x %x -> %x %x %x\n",
+		 " UCM_ACTIVE_CONN %p %d [lid port qpn] %x %x %x -> %x %x %x xevent=%d\n",
 		 cm->hca, cm->retries, ntohs(cm->msg.saddr.ib.lid),
 		 ntohs(cm->msg.sport), ntohl(cm->msg.saddr.ib.qpn),
 		 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-		 ntohl(cm->msg.dqpn));
+		 ntohl(cm->msg.dqpn), sizeof(DAT_IB_EXTENSION_EVENT_DATA));
 	return;
 bail:
 	dapl_evd_connection_callback(NULL, event, cm->msg.p_data, ntohs(cm->msg.p_size), cm->ep);
@@ -1400,6 +1472,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		
 		/* post EVENT, modify_qp, AH already created, ucm msg */
 		xevent.status = 0;
+		xevent.context.as_ptr = cm;
 		xevent.type = DAT_IB_UD_PASSIVE_REMOTE_AH;
 		xevent.remote_ah.qpn = ntohl(cm->msg.daddr.ib.qpn);
 		xevent.remote_ah.ah = dapls_create_ah(cm->hca, 
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 49f89fa..69d61a4 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -150,6 +150,7 @@ void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 void dapls_cm_acquire(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_release(dp_ib_cm_handle_t cm_ptr);
 void dapls_cm_free(dp_ib_cm_handle_t cm_ptr);
+DAT_RETURN dapls_ud_cm_free(DAPL_EP *ep_ptr, dp_ib_cm_handle_t cm_ptr);
 
 #ifdef DAPL_COUNTERS
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
