From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 2/2] ulps: Align several ULPs to use core/rdma_cm logging helpers
Date: Tue, 12 May 2015 12:41:45 +0300
Message-ID: <1431423705-3922-3-git-send-email-sagig@mellanox.com>
References: <1431423705-3922-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431423705-3922-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove rds & xprtrdma specific helpers and have them and
srp, iser, isert use the generic helpers. While we're at it
align svcrdma as well.

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   26 +++++---
 drivers/infiniband/ulp/isert/ib_isert.c  |   19 ++++--
 drivers/infiniband/ulp/srp/ib_srp.c      |   15 +++--
 net/rds/af_rds.c                         |    9 ---
 net/rds/ib.h                             |    1 -
 net/rds/ib_cm.c                          |   36 +-----------
 net/rds/ib_recv.c                        |    4 +-
 net/rds/ib_send.c                        |   38 +------------
 net/rds/rdma_transport.c                 |   34 +----------
 net/rds/rds.h                            |    1 -
 net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
 net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------------
 13 files changed, 72 insertions(+), 234 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index cc2dd35..7b4d105 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -51,19 +51,20 @@ static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
-	iser_err("got cq event %d \n", cause->event);
+	iser_err("cq event %s(%d)\n", ib_event_msg(cause->event), cause->event);
 }
 
 static void iser_qp_event_callback(struct ib_event *cause, void *context)
 {
-	iser_err("got qp event %d\n",cause->event);
+	iser_err("qp event %s(%d)\n", ib_event_msg(cause->event), cause->event);
 }
 
 static void iser_event_handler(struct ib_event_handler *handler,
 				struct ib_event *event)
 {
-	iser_err("async event %d on device %s port %d\n", event->event,
-		event->device->name, event->element.port_num);
+	iser_err("async event %s(%d) on device %s port %d\n",
+		 ib_event_msg(event->event), event->event,
+		 event->device->name, event->element.port_num);
 }
 
 /**
@@ -873,8 +874,9 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 	int ret = 0;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
-	iser_info("event %d status %d conn %p id %p\n",
-		  event->event, event->status, cma_id->context, cma_id);
+	iser_info("event %s(%d) status %d conn %p id %p\n",
+		  rdma_event_msg(event->event), event->event,
+		  event->status, cma_id->context, cma_id);
 
 	mutex_lock(&iser_conn->state_mutex);
 	switch (event->event) {
@@ -913,7 +915,8 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		}
 		break;
 	default:
-		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
+		iser_err("Unexpected RDMA CM event %s(%d)\n",
+			 rdma_event_msg(event->event), event->event);
 		break;
 	}
 	mutex_unlock(&iser_conn->state_mutex);
@@ -1173,10 +1176,13 @@ static void iser_handle_wc(struct ib_wc *wc)
 		}
 	} else {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			iser_err("wr id %llx status %d vend_err %x\n",
-				 wc->wr_id, wc->status, wc->vendor_err);
+			iser_err("%s(%d): wr id %llx vend_err %x\n",
+				 ib_wc_status_msg(wc->status), wc->status,
+				 wc->wr_id, wc->vendor_err);
 		else
-			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
+			iser_dbg("%s(%d): wr id %llx\n",
+				 ib_wc_status_msg(wc->status), wc->status,
+				 wc->wr_id);
 
 		if (wc->wr_id == ISER_BEACON_WRID)
 			/* all flush errors were consumed */
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 327529e..209e765 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -78,7 +78,9 @@ isert_qp_event_callback(struct ib_event *e, void *context)
 {
 	struct isert_conn *isert_conn = context;
 
-	isert_err("conn %p event: %d\n", isert_conn, e->event);
+	isert_err("conn %p event: %s(%d)\n", isert_conn,
+		  ib_event_msg(e->event), e->event);
+
 	switch (e->event) {
 	case IB_EVENT_COMM_EST:
 		rdma_notify(isert_conn->cm_id, IB_EVENT_COMM_EST);
@@ -897,7 +899,8 @@ static int
 isert_np_cma_handler(struct isert_np *isert_np,
 		     enum rdma_cm_event_type event)
 {
-	isert_dbg("isert np %p, handling event %d\n", isert_np, event);
+	isert_dbg("isert np %p, handling event %s(%d)\n",
+		  isert_np, rdma_event_msg(event), event);
 
 	switch (event) {
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -957,7 +960,8 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	int ret = 0;
 
-	isert_info("event %d status %d id %p np %p\n", event->event,
+	isert_info("event %s(%d) status %d id %p np %p\n",
+		   rdma_event_msg(event->event), event->event,
 		   event->status, cma_id, cma_id->context);
 
 	switch (event->event) {
@@ -2091,10 +2095,13 @@ isert_handle_wc(struct ib_wc *wc)
 		}
 	} else {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			isert_err("wr id %llx status %d vend_err %x\n",
-				  wc->wr_id, wc->status, wc->vendor_err);
+			isert_err("%s(%d): wr id %llx vend_err %x\n",
+				  ib_wc_status_msg(wc->status), wc->status,
+				  wc->wr_id, wc->vendor_err);
 		else
-			isert_dbg("flush error: wr id %llx\n", wc->wr_id);
+			isert_dbg("%s(%d): wr id %llx\n",
+				  ib_wc_status_msg(wc->status), wc->status,
+				  wc->wr_id);
 
 		if (wc->wr_id != ISER_FASTREG_LI_WRID)
 			isert_cq_comp_err(isert_conn, wc);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..86b8097 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -253,7 +253,7 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
 
 static void srp_qp_event(struct ib_event *event, void *context)
 {
-	pr_debug("QP event %d\n", event->event);
+	pr_debug("QP event %s(%d)\n", ib_event_msg(event->event), event->event);
 }
 
 static int srp_init_qp(struct srp_target_port *target,
@@ -1932,17 +1932,18 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 	if (target->connected && !target->qp_in_error) {
 		if (wr_id & LOCAL_INV_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "LOCAL_INV failed with status %d\n",
-				     wc_status);
+				     "LOCAL_INV failed with status %s(%d)\n",
+				     ib_wc_status_msg(wc_status), wc_status);
 		} else if (wr_id & FAST_REG_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "FAST_REG_MR failed status %d\n",
-				     wc_status);
+				     "FAST_REG_MR failed status %s(%d)\n",
+				     ib_wc_status_msg(wc_status), wc_status);
 		} else {
 			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed %s status %d for iu %p\n",
+				     PFX "failed %s status %s(%d) for iu %p\n",
 				     send_err ? "send" : "receive",
-				     wc_status, (void *)(uintptr_t)wr_id);
+				     ib_wc_status_msg(wc_status), wc_status,
+				     (void *)(uintptr_t)wr_id);
 		}
 		queue_work(system_long_wq, &target->tl_err_work);
 	}
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 1044337..11b623c 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -40,15 +40,6 @@
 
 #include "rds.h"
 
-char *rds_str_array(char **array, size_t elements, size_t index)
-{
-	if ((index < elements) && array[index])
-		return array[index];
-	else
-		return "unknown";
-}
-EXPORT_SYMBOL(rds_str_array);
-
 /* this is just used for stats gathering :/ */
 static DEFINE_SPINLOCK(rds_sock_lock);
 static unsigned long rds_sock_count;
diff --git a/net/rds/ib.h b/net/rds/ib.h
index c36d713..333611d 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -339,7 +339,6 @@ u32 rds_ib_ring_completed(struct rds_ib_work_ring *ring, u32 wr_id, u32 oldest);
 extern wait_queue_head_t rds_ib_ring_empty_wait;
 
 /* ib_send.c */
-char *rds_ib_wc_status_str(enum ib_wc_status status);
 void rds_ib_xmit_complete(struct rds_connection *conn);
 int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		unsigned int hdr_off, unsigned int sg, unsigned int off);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 31b74f5..6e33061 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -39,36 +39,6 @@
 #include "rds.h"
 #include "ib.h"
 
-static char *rds_ib_event_type_strings[] = {
-#define RDS_IB_EVENT_STRING(foo) \
-		[IB_EVENT_##foo] = __stringify(IB_EVENT_##foo)
-	RDS_IB_EVENT_STRING(CQ_ERR),
-	RDS_IB_EVENT_STRING(QP_FATAL),
-	RDS_IB_EVENT_STRING(QP_REQ_ERR),
-	RDS_IB_EVENT_STRING(QP_ACCESS_ERR),
-	RDS_IB_EVENT_STRING(COMM_EST),
-	RDS_IB_EVENT_STRING(SQ_DRAINED),
-	RDS_IB_EVENT_STRING(PATH_MIG),
-	RDS_IB_EVENT_STRING(PATH_MIG_ERR),
-	RDS_IB_EVENT_STRING(DEVICE_FATAL),
-	RDS_IB_EVENT_STRING(PORT_ACTIVE),
-	RDS_IB_EVENT_STRING(PORT_ERR),
-	RDS_IB_EVENT_STRING(LID_CHANGE),
-	RDS_IB_EVENT_STRING(PKEY_CHANGE),
-	RDS_IB_EVENT_STRING(SM_CHANGE),
-	RDS_IB_EVENT_STRING(SRQ_ERR),
-	RDS_IB_EVENT_STRING(SRQ_LIMIT_REACHED),
-	RDS_IB_EVENT_STRING(QP_LAST_WQE_REACHED),
-	RDS_IB_EVENT_STRING(CLIENT_REREGISTER),
-#undef RDS_IB_EVENT_STRING
-};
-
-static char *rds_ib_event_str(enum ib_event_type type)
-{
-	return rds_str_array(rds_ib_event_type_strings,
-			     ARRAY_SIZE(rds_ib_event_type_strings), type);
-};
-
 /*
  * Set the selected protocol version
  */
@@ -234,7 +204,7 @@ static void rds_ib_cm_fill_conn_param(struct rds_connection *conn,
 static void rds_ib_cq_event_handler(struct ib_event *event, void *data)
 {
 	rdsdebug("event %u (%s) data %p\n",
-		 event->event, rds_ib_event_str(event->event), data);
+		 event->event, ib_event_msg(event->event), data);
 }
 
 static void rds_ib_qp_event_handler(struct ib_event *event, void *data)
@@ -243,7 +213,7 @@ static void rds_ib_qp_event_handler(struct ib_event *event, void *data)
 	struct rds_ib_connection *ic = conn->c_transport_data;
 
 	rdsdebug("conn %p ic %p event %u (%s)\n", conn, ic, event->event,
-		 rds_ib_event_str(event->event));
+		 ib_event_msg(event->event));
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -252,7 +222,7 @@ static void rds_ib_qp_event_handler(struct ib_event *event, void *data)
 	default:
 		rdsdebug("Fatal QP Event %u (%s) "
 			"- connection %pI4->%pI4, reconnecting\n",
-			event->event, rds_ib_event_str(event->event),
+			event->event, ib_event_msg(event->event),
 			&conn->c_laddr, &conn->c_faddr);
 		rds_conn_drop(conn);
 		break;
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 1b981a4..cac5b45 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -956,7 +956,7 @@ static inline void rds_poll_cq(struct rds_ib_connection *ic,
 	while (ib_poll_cq(ic->i_recv_cq, 1, &wc) > 0) {
 		rdsdebug("wc wr_id 0x%llx status %u (%s) byte_len %u imm_data %u\n",
 			 (unsigned long long)wc.wr_id, wc.status,
-			 rds_ib_wc_status_str(wc.status), wc.byte_len,
+			 ib_wc_status_msg(wc.status), wc.byte_len,
 			 be32_to_cpu(wc.ex.imm_data));
 		rds_ib_stats_inc(s_ib_rx_cq_event);
 
@@ -978,7 +978,7 @@ static inline void rds_poll_cq(struct rds_ib_connection *ic,
 						  "status %u (%s), disconnecting and "
 						  "reconnecting\n", &conn->c_faddr,
 						  wc.status,
-						  rds_ib_wc_status_str(wc.status));
+						  ib_wc_status_msg(wc.status));
 		}
 
 		/*
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index bd3825d..25d0482 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -39,40 +39,6 @@
 #include "rds.h"
 #include "ib.h"
 
-static char *rds_ib_wc_status_strings[] = {
-#define RDS_IB_WC_STATUS_STR(foo) \
-		[IB_WC_##foo] = __stringify(IB_WC_##foo)
-	RDS_IB_WC_STATUS_STR(SUCCESS),
-	RDS_IB_WC_STATUS_STR(LOC_LEN_ERR),
-	RDS_IB_WC_STATUS_STR(LOC_QP_OP_ERR),
-	RDS_IB_WC_STATUS_STR(LOC_EEC_OP_ERR),
-	RDS_IB_WC_STATUS_STR(LOC_PROT_ERR),
-	RDS_IB_WC_STATUS_STR(WR_FLUSH_ERR),
-	RDS_IB_WC_STATUS_STR(MW_BIND_ERR),
-	RDS_IB_WC_STATUS_STR(BAD_RESP_ERR),
-	RDS_IB_WC_STATUS_STR(LOC_ACCESS_ERR),
-	RDS_IB_WC_STATUS_STR(REM_INV_REQ_ERR),
-	RDS_IB_WC_STATUS_STR(REM_ACCESS_ERR),
-	RDS_IB_WC_STATUS_STR(REM_OP_ERR),
-	RDS_IB_WC_STATUS_STR(RETRY_EXC_ERR),
-	RDS_IB_WC_STATUS_STR(RNR_RETRY_EXC_ERR),
-	RDS_IB_WC_STATUS_STR(LOC_RDD_VIOL_ERR),
-	RDS_IB_WC_STATUS_STR(REM_INV_RD_REQ_ERR),
-	RDS_IB_WC_STATUS_STR(REM_ABORT_ERR),
-	RDS_IB_WC_STATUS_STR(INV_EECN_ERR),
-	RDS_IB_WC_STATUS_STR(INV_EEC_STATE_ERR),
-	RDS_IB_WC_STATUS_STR(FATAL_ERR),
-	RDS_IB_WC_STATUS_STR(RESP_TIMEOUT_ERR),
-	RDS_IB_WC_STATUS_STR(GENERAL_ERR),
-#undef RDS_IB_WC_STATUS_STR
-};
-
-char *rds_ib_wc_status_str(enum ib_wc_status status)
-{
-	return rds_str_array(rds_ib_wc_status_strings,
-			     ARRAY_SIZE(rds_ib_wc_status_strings), status);
-}
-
 /*
  * Convert IB-specific error message to RDS error message and call core
  * completion handler.
@@ -293,7 +259,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		rdsdebug("wc wr_id 0x%llx status %u (%s) byte_len %u imm_data %u\n",
 			 (unsigned long long)wc.wr_id, wc.status,
-			 rds_ib_wc_status_str(wc.status), wc.byte_len,
+			 ib_wc_status_msg(wc.status), wc.byte_len,
 			 be32_to_cpu(wc.ex.imm_data));
 		rds_ib_stats_inc(s_ib_tx_cq_event);
 
@@ -344,7 +310,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 			rds_ib_conn_error(conn, "send completion on %pI4 had status "
 					  "%u (%s), disconnecting and reconnecting\n",
 					  &conn->c_faddr, wc.status,
-					  rds_ib_wc_status_str(wc.status));
+					  ib_wc_status_msg(wc.status));
 		}
 	}
 }
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 6cd9d1d..2082408 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -37,34 +37,6 @@
 
 static struct rdma_cm_id *rds_rdma_listen_id;
 
-static char *rds_cm_event_strings[] = {
-#define RDS_CM_EVENT_STRING(foo) \
-		[RDMA_CM_EVENT_##foo] = __stringify(RDMA_CM_EVENT_##foo)
-	RDS_CM_EVENT_STRING(ADDR_RESOLVED),
-	RDS_CM_EVENT_STRING(ADDR_ERROR),
-	RDS_CM_EVENT_STRING(ROUTE_RESOLVED),
-	RDS_CM_EVENT_STRING(ROUTE_ERROR),
-	RDS_CM_EVENT_STRING(CONNECT_REQUEST),
-	RDS_CM_EVENT_STRING(CONNECT_RESPONSE),
-	RDS_CM_EVENT_STRING(CONNECT_ERROR),
-	RDS_CM_EVENT_STRING(UNREACHABLE),
-	RDS_CM_EVENT_STRING(REJECTED),
-	RDS_CM_EVENT_STRING(ESTABLISHED),
-	RDS_CM_EVENT_STRING(DISCONNECTED),
-	RDS_CM_EVENT_STRING(DEVICE_REMOVAL),
-	RDS_CM_EVENT_STRING(MULTICAST_JOIN),
-	RDS_CM_EVENT_STRING(MULTICAST_ERROR),
-	RDS_CM_EVENT_STRING(ADDR_CHANGE),
-	RDS_CM_EVENT_STRING(TIMEWAIT_EXIT),
-#undef RDS_CM_EVENT_STRING
-};
-
-static char *rds_cm_event_str(enum rdma_cm_event_type type)
-{
-	return rds_str_array(rds_cm_event_strings,
-			     ARRAY_SIZE(rds_cm_event_strings), type);
-};
-
 int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 			      struct rdma_cm_event *event)
 {
@@ -74,7 +46,7 @@ int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 	int ret = 0;
 
 	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
-		 event->event, rds_cm_event_str(event->event));
+		 event->event, rdma_event_msg(event->event));
 
 	if (cm_id->device->node_type == RDMA_NODE_RNIC)
 		trans = &rds_iw_transport;
@@ -139,7 +111,7 @@ int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 	default:
 		/* things like device disconnect? */
 		printk(KERN_ERR "RDS: unknown event %u (%s)!\n",
-		       event->event, rds_cm_event_str(event->event));
+		       event->event, rdma_event_msg(event->event));
 		break;
 	}
 
@@ -148,7 +120,7 @@ out:
 		mutex_unlock(&conn->c_cm_lock);
 
 	rdsdebug("id %p event %u (%s) handling ret %d\n", cm_id, event->event,
-		 rds_cm_event_str(event->event), ret);
+		 rdma_event_msg(event->event), ret);
 
 	return ret;
 }
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 0d41155..099754c 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -575,7 +575,6 @@ struct rds_statistics {
 };
 
 /* af_rds.c */
-char *rds_str_array(char **array, size_t elements, size_t index);
 void rds_sock_addref(struct rds_sock *rs);
 void rds_sock_put(struct rds_sock *rs);
 void rds_wake_sk_sleep(struct rds_sock *rs);
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index dff0481..b3fda09 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -128,8 +128,8 @@ frwr_sendcompletion(struct ib_wc *wc)
 
 	/* WARNING: Only wr_id and status are reliable at this point */
 	r = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
-	dprintk("RPC:       %s: frmr %p (stale), status %d\n",
-		__func__, r, wc->status);
+	dprintk("RPC:       %s: frmr %p (stale), status %s(%d)\n",
+		__func__, r, ib_wc_status_msg(wc->status), wc->status);
 	r->r.frmr.fr_state = FRMR_IS_STALE;
 }
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index f609c1c..abd2d51 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -175,8 +175,8 @@ void svc_rdma_put_req_map(struct svc_rdma_req_map *map)
 static void cq_event_handler(struct ib_event *event, void *context)
 {
 	struct svc_xprt *xprt = context;
-	dprintk("svcrdma: received CQ event id=%d, context=%p\n",
-		event->event, context);
+	dprintk("svcrdma: received CQ event %s(%d), context=%p\n",
+		ib_event_msg(event->event), event->event, context);
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
 }
 
@@ -191,8 +191,9 @@ static void qp_event_handler(struct ib_event *event, void *context)
 	case IB_EVENT_COMM_EST:
 	case IB_EVENT_SQ_DRAINED:
 	case IB_EVENT_QP_LAST_WQE_REACHED:
-		dprintk("svcrdma: QP event %d received for QP=%p\n",
-			event->event, event->element.qp);
+		dprintk("svcrdma: QP event %s(%d) received for QP=%p\n",
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
+		dprintk("svcrdma: QP ERROR event %s(%d) received for QP=%p, "
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
+				dprintk("svcrdma: sq wc err status %s(%d)\n",
+					ib_wc_status_msg(wc->status),
 					wc->status);
 
 				/* Close the transport */
@@ -616,7 +619,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		dprintk("svcrdma: Connect request on cma_id=%p, xprt = %p, "
-			"event=%d\n", cma_id, cma_id->context, event->event);
+			"event=%s(%d)\n", cma_id, cma_id->context,
+			rdma_event_msg(event->event), event->event);
 		handle_connect_req(cma_id,
 				   event->param.conn.initiator_depth);
 		break;
@@ -636,7 +640,8 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 
 	default:
 		dprintk("svcrdma: Unexpected event on listening endpoint %p, "
-			"event=%d\n", cma_id, event->event);
+			"event=%s(%d)\n", cma_id, rdma_event_msg(event->event),
+			event->event);
 		break;
 	}
 
@@ -669,7 +674,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
 		break;
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		dprintk("svcrdma: Device removal cma_id=%p, xprt = %p, "
-			"event=%d\n", cma_id, xprt, event->event);
+			"event=%s(%d)\n", cma_id, xprt,
+			rdma_event_msg(event->event), event->event);
 		if (xprt) {
 			set_bit(XPT_CLOSE, &xprt->xpt_flags);
 			svc_xprt_enqueue(xprt);
@@ -677,7 +683,8 @@ static int rdma_cma_handler(struct rdma_cm_id *cma_id,
 		break;
 	default:
 		dprintk("svcrdma: Unexpected event on DTO endpoint %p, "
-			"event=%d\n", cma_id, event->event);
+			"event=%d\n", cma_id, rdma_event_msg(event->event),
+			event->event);
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
