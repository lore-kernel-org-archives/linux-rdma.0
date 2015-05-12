From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 6/6] RDS: Switch to generic logging helpers
Date: Tue, 12 May 2015 15:05:29 +0300
Message-ID: <1431432329-859-7-git-send-email-sagig@mellanox.com>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431432329-859-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/rds/af_rds.c         |    9 ---------
 net/rds/ib.h             |    1 -
 net/rds/ib_cm.c          |   36 +++---------------------------------
 net/rds/ib_recv.c        |    4 ++--
 net/rds/ib_send.c        |   38 ++------------------------------------
 net/rds/rdma_transport.c |   34 +++-------------------------------
 net/rds/rds.h            |    1 -
 7 files changed, 10 insertions(+), 113 deletions(-)

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
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
