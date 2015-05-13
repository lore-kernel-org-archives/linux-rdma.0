From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 5/6] xprtrdma, svcrdma: Switch to generic logging helpers
Date: Wed, 13 May 2015 12:35:04 +0300
Message-ID: <1431509705-16337-6-git-send-email-sagig@mellanox.com>
References: <1431509705-16337-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431509705-16337-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
 net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------------
 3 files changed, 25 insertions(+), 98 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index dff0481..d234521 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -128,8 +128,8 @@ frwr_sendcompletion(struct ib_wc *wc)
 
 	/* WARNING: Only wr_id and status are reliable at this point */
 	r = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
-	dprintk("RPC:       %s: frmr %p (stale), status %d\n",
-		__func__, r, wc->status);
+	dprintk("RPC:       %s: frmr %p (stale), status %s (%d)\n",
+		__func__, r, ib_wc_status_msg(wc->status), wc->status);
 	r->r.frmr.fr_state = FRMR_IS_STALE;
 }
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index f609c1c..13ee04f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -175,8 +175,8 @@ void svc_rdma_put_req_map(struct svc_rdma_req_map *map)
 static void cq_event_handler(struct ib_event *event, void *context)
 {
 	struct svc_xprt *xprt = context;
-	dprintk("svcrdma: received CQ event id=%d, context=%p\n",
-		event->event, context);
+	dprintk("svcrdma: received CQ event %s (%d), context=%p\n",
+		ib_event_msg(event->event), event->event, context);
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
 }
 
@@ -191,8 +191,9 @@ static void qp_event_handler(struct ib_event *event, void *context)
 	case IB_EVENT_COMM_EST:
 	case IB_EVENT_SQ_DRAINED:
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		dprintk("svcrdma: QP event %d received for QP=%p\n",
-			event->event, event->element.qp);
+		dprintk("svcrdma: QP event %s (%d) received for QP=%p\n",
+			ib_event_msg(event->event), event->event,
+			event->element.qp);
 		break;
 	/* These are considered fatal events */
 	case IB_EVENT_PATH_MIG_ERR:
@@ -201,9 +202,10 @@ static void qp_event_handler(struct ib_event *event, void *context)
 	case IB_EVENT_QP_ACCESS_ERR:
 	case IB_EVENT_DEVICE_FATAL:
 	default:
-		dprintk("svcrdma: QP ERROR event %d received for QP=%p, "
+		dprintk("svcrdma: QP ERROR event %s (%d) received for QP=%p, "
 			"closing transport\n",
-			event->event, event->element.qp);
+			ib_event_msg(event->event), event->event,
+			event->element.qp);
 		set_bit(XPT_CLOSE, &xprt->xpt_flags);
 		break;
 	}
@@ -402,7 +404,8 @@ static void sq_cq_reap(struct svcxprt_rdma *xprt)
 		for (i = 0; i < ret; i++) {
 			wc = &wc_a[i];
 			if (wc->status != IB_WC_SUCCESS) {
-				dprintk("svcrdma: sq wc err status %d\n",
+				dprintk("svcrdma: sq wc err status %s (%d)\n",
+					ib_wc_status_msg(wc->status),
 					wc->status);
 
 				/* Close the transport */
@@ -616,7 +619,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		dprintk("svcrdma: Connect request on cma_id=%p, xprt = %p, "
-			"event=%d\n", cma_id, cma_id->context, event->event);
+			"event = %s (%d)\n", cma_id, cma_id->context,
+			rdma_event_msg(event->event), event->event);
 		handle_connect_req(cma_id,
 				   event->param.conn.initiator_depth);
 		break;
@@ -636,7 +640,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 
 	default:
 		dprintk("svcrdma: Unexpected event on listening endpoint %p, "
-			"event=%d\n", cma_id, event->event);
+			"event = %s (%d)\n", cma_id,
+			rdma_event_msg(event->event), event->event);
 		break;
 	}
 
@@ -669,7 +674,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
 		break;
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		dprintk("svcrdma: Device removal cma_id=%p, xprt = %p, "
-			"event=%d\n", cma_id, xprt, event->event);
+			"event = %s (%d)\n", cma_id, xprt,
+			rdma_event_msg(event->event), event->event);
 		if (xprt) {
 			set_bit(XPT_CLOSE, &xprt->xpt_flags);
 			svc_xprt_enqueue(xprt);
@@ -677,7 +683,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
 		break;
 	default:
 		dprintk("svcrdma: Unexpected event on DTO endpoint %p, "
-			"event=%d\n", cma_id, event->event);
+			"event = %s (%d)\n", cma_id,
+			rdma_event_msg(event->event), event->event);
 		break;
 	}
 	return 0;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 4870d27..6f6b8a5 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -105,32 +105,6 @@ rpcrdma_run_tasklet(unsigned long data)
 
 static DECLARE_TASKLET(rpcrdma_tasklet_g, rpcrdma_run_tasklet, 0UL);
 
-static const char * const async_event[] = {
-	"CQ error",
-	"QP fatal error",
-	"QP request error",
-	"QP access error",
-	"communication established",
-	"send queue drained",
-	"path migration successful",
-	"path mig error",
-	"device fatal error",
-	"port active",
-	"port error",
-	"LID change",
-	"P_key change",
-	"SM change",
-	"SRQ error",
-	"SRQ limit reached",
-	"last WQE reached",
-	"client reregister",
-	"GID change",
-};
-
-#define ASYNC_MSG(status)					\
-	((status) < ARRAY_SIZE(async_event) ?			\
-		async_event[(status)] : "unknown async error")
-
 static void
 rpcrdma_schedule_tasklet(struct list_head *sched_list)
 {
@@ -148,7 +122,7 @@ rpcrdma_qp_async_error_upcall(struct ib_event *event, void *context)
 	struct rpcrdma_ep *ep = context;
 
 	pr_err("RPC:       %s: %s on device %s ep %p\n",
-	       __func__, ASYNC_MSG(event->event),
+	       __func__, ib_event_msg(event->event),
 		event->device->name, context);
 	if (ep->rep_connected == 1) {
 		ep->rep_connected = -EIO;
@@ -163,7 +137,7 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
 	struct rpcrdma_ep *ep = context;
 
 	pr_err("RPC:       %s: %s on device %s ep %p\n",
-	       __func__, ASYNC_MSG(event->event),
+	       __func__, ib_event_msg(event->event),
 		event->device->name, context);
 	if (ep->rep_connected == 1) {
 		ep->rep_connected = -EIO;
@@ -172,35 +146,6 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
 	}
 }
 
-static const char * const wc_status[] = {
-	"success",
-	"local length error",
-	"local QP operation error",
-	"local EE context operation error",
-	"local protection error",
-	"WR flushed",
-	"memory management operation error",
-	"bad response error",
-	"local access error",
-	"remote invalid request error",
-	"remote access error",
-	"remote operation error",
-	"transport retry counter exceeded",
-	"RNR retry counter exceeded",
-	"local RDD violation error",
-	"remove invalid RD request",
-	"operation aborted",
-	"invalid EE context number",
-	"invalid EE context state",
-	"fatal error",
-	"response timeout error",
-	"general error",
-};
-
-#define COMPLETION_MSG(status)					\
-	((status) < ARRAY_SIZE(wc_status) ?			\
-		wc_status[(status)] : "unexpected completion error")
-
 static void
 rpcrdma_sendcq_process_wc(struct ib_wc *wc)
 {
@@ -209,7 +154,7 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
 		if (wc->status != IB_WC_SUCCESS &&
 		    wc->status != IB_WC_WR_FLUSH_ERR)
 			pr_err("RPC:       %s: SEND: %s\n",
-			       __func__, COMPLETION_MSG(wc->status));
+			       __func__, ib_wc_status_msg(wc->status));
 	} else {
 		struct rpcrdma_mw *r;
 
@@ -302,7 +247,7 @@ out_schedule:
 out_fail:
 	if (wc->status != IB_WC_WR_FLUSH_ERR)
 		pr_err("RPC:       %s: rep %p: %s\n",
-		       __func__, rep, COMPLETION_MSG(wc->status));
+		       __func__, rep, ib_wc_status_msg(wc->status));
 	rep->rr_len = ~0U;
 	goto out_schedule;
 }
@@ -386,31 +331,6 @@ rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
 		rpcrdma_sendcq_process_wc(&wc);
 }
 
-#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
-static const char * const conn[] = {
-	"address resolved",
-	"address error",
-	"route resolved",
-	"route error",
-	"connect request",
-	"connect response",
-	"connect error",
-	"unreachable",
-	"rejected",
-	"established",
-	"disconnected",
-	"device removal",
-	"multicast join",
-	"multicast error",
-	"address change",
-	"timewait exit",
-};
-
-#define CONNECTION_MSG(status)						\
-	((status) < ARRAY_SIZE(conn) ?					\
-		conn[(status)] : "unrecognized connection error")
-#endif
-
 static int
 rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
@@ -476,7 +396,7 @@ connected:
 	default:
 		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
 			__func__, sap, rpc_get_port(sap), ep,
-			CONNECTION_MSG(event->event));
+			rdma_event_msg(event->event));
 		break;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
