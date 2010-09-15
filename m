From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [rds-devel] net-next pull request: RDS
Date: Wed, 15 Sep 2010 11:22:36 +0200
Message-ID: <4C90905C.8050101@Voltaire.com>
References: <4C892C9C.4060304@oracle.com> <4C8C9422.2070306@Voltaire.com>	<20100914183514.GA3417@takashi.pdx.zabbo.net> <AANLkTin69m0kK6bqUiwYeHRQT0Ehso16xA6RBtBFFgW3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin69m0kK6bqUiwYeHRQT0Ehso16xA6RBtBFFgW3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDS Devel <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Andrew Grover wrote:
> Once net-next gets pushed to mainline and Roland pulls from that, 
> then we'll be in a good position to put these helpers where they should go, 
> and change other ULPs to use them.

Andy, as Roland commented, you can push such helpers through Dave once Roland made a review of them, in a similar manner to a situation where an iser patch is merged by the iscsi maintainer, etc. if going to the review now... Roland - what's your take on the below patch net-next-2.6 and also on its net-next-2.6  "RDS/IB: print IB event strings as well as their number" 1bde04a63d532c2540d6fdee0a661530a62b1686 buddy?

Or.


commit 59f740a6aeb2cde2f79fe0df38262d4c1ef35cd8
Author: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Tue Aug 3 13:52:47 2010 -0700

    RDS/IB: print string constants in more places
    
    This prints the constant identifier for work completion status and rdma
    cm event types, like we already do for IB event types.
    
    A core string array helper is added that each string type uses.
    
    Signed-off-by: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 8e3886d..bb6ad81 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -40,6 +40,15 @@
 
 #include "rds.h"
 
+char *rds_str_array(char **array, size_t elements, size_t index)
+{
+	if ((index < elements) && array[index])
+		return array[index];
+	else
+		return "unknown";
+}
+EXPORT_SYMBOL(rds_str_array);
+
 /* this is just used for stats gathering :/ */
 static DEFINE_SPINLOCK(rds_sock_lock);
 static unsigned long rds_sock_count;
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 2189fd4..7ad3d57 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -345,6 +345,7 @@ u32 rds_ib_ring_completed(struct rds_ib_work_ring *ring, u32 wr_id, u32 oldest);
 extern wait_queue_head_t rds_ib_ring_empty_wait;
 
 /* ib_send.c */
+char *rds_ib_wc_status_str(enum ib_wc_status status);
 void rds_ib_xmit_complete(struct rds_connection *conn);
 int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		unsigned int hdr_off, unsigned int sg, unsigned int off);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 0e2fea8..bc3dbc1 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -39,7 +39,8 @@
 #include "ib.h"
 
 static char *rds_ib_event_type_strings[] = {
-#define RDS_IB_EVENT_STRING(foo) [IB_EVENT_##foo] = __stringify(foo)
+#define RDS_IB_EVENT_STRING(foo) \
+		[IB_EVENT_##foo] = __stringify(IB_EVENT_##foo)
 	RDS_IB_EVENT_STRING(CQ_ERR),
 	RDS_IB_EVENT_STRING(QP_FATAL),
 	RDS_IB_EVENT_STRING(QP_REQ_ERR),
@@ -63,11 +64,8 @@ static char *rds_ib_event_type_strings[] = {
 
 static char *rds_ib_event_str(enum ib_event_type type)
 {
-	if (type < ARRAY_SIZE(rds_ib_event_type_strings) &&
-	    rds_ib_event_type_strings[type])
-		return rds_ib_event_type_strings[type];
-	else
-		return "unknown";
+	return rds_str_array(rds_ib_event_type_strings,
+			     ARRAY_SIZE(rds_ib_event_type_strings), type);
 };
 
 /*
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index a2f5f6f..e29e0ca 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -966,8 +966,9 @@ static inline void rds_poll_cq(struct rds_ib_connection *ic,
 	struct rds_ib_recv_work *recv;
 
 	while (ib_poll_cq(ic->i_recv_cq, 1, &wc) > 0) {
-		rdsdebug("wc wr_id 0x%llx status %u byte_len %u imm_data %u\n",
-			 (unsigned long long)wc.wr_id, wc.status, wc.byte_len,
+		rdsdebug("wc wr_id 0x%llx status %u (%s) byte_len %u imm_data %u\n",
+			 (unsigned long long)wc.wr_id, wc.status,
+			 rds_ib_wc_status_str(wc.status), wc.byte_len,
 			 be32_to_cpu(wc.ex.imm_data));
 		rds_ib_stats_inc(s_ib_rx_cq_event);
 
@@ -985,10 +986,11 @@ static inline void rds_poll_cq(struct rds_ib_connection *ic,
 		} else {
 			/* We expect errors as the qp is drained during shutdown */
 			if (rds_conn_up(conn) || rds_conn_connecting(conn))
-				rds_ib_conn_error(conn, "recv completion on "
-						  "%pI4 had status %u, disconnecting and "
+				rds_ib_conn_error(conn, "recv completion on %pI4 had "
+						  "status %u (%s), disconnecting and "
 						  "reconnecting\n", &conn->c_faddr,
-						  wc.status);
+						  wc.status,
+						  rds_ib_wc_status_str(wc.status));
 		}
 
 		/*
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 15f7569..808544a 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -38,6 +38,40 @@
 #include "rds.h"
 #include "ib.h"
 
+static char *rds_ib_wc_status_strings[] = {
+#define RDS_IB_WC_STATUS_STR(foo) \
+		[IB_WC_##foo] = __stringify(IB_WC_##foo)
+	RDS_IB_WC_STATUS_STR(SUCCESS),
+	RDS_IB_WC_STATUS_STR(LOC_LEN_ERR),
+	RDS_IB_WC_STATUS_STR(LOC_QP_OP_ERR),
+	RDS_IB_WC_STATUS_STR(LOC_EEC_OP_ERR),
+	RDS_IB_WC_STATUS_STR(LOC_PROT_ERR),
+	RDS_IB_WC_STATUS_STR(WR_FLUSH_ERR),
+	RDS_IB_WC_STATUS_STR(MW_BIND_ERR),
+	RDS_IB_WC_STATUS_STR(BAD_RESP_ERR),
+	RDS_IB_WC_STATUS_STR(LOC_ACCESS_ERR),
+	RDS_IB_WC_STATUS_STR(REM_INV_REQ_ERR),
+	RDS_IB_WC_STATUS_STR(REM_ACCESS_ERR),
+	RDS_IB_WC_STATUS_STR(REM_OP_ERR),
+	RDS_IB_WC_STATUS_STR(RETRY_EXC_ERR),
+	RDS_IB_WC_STATUS_STR(RNR_RETRY_EXC_ERR),
+	RDS_IB_WC_STATUS_STR(LOC_RDD_VIOL_ERR),
+	RDS_IB_WC_STATUS_STR(REM_INV_RD_REQ_ERR),
+	RDS_IB_WC_STATUS_STR(REM_ABORT_ERR),
+	RDS_IB_WC_STATUS_STR(INV_EECN_ERR),
+	RDS_IB_WC_STATUS_STR(INV_EEC_STATE_ERR),
+	RDS_IB_WC_STATUS_STR(FATAL_ERR),
+	RDS_IB_WC_STATUS_STR(RESP_TIMEOUT_ERR),
+	RDS_IB_WC_STATUS_STR(GENERAL_ERR),
+#undef RDS_IB_WC_STATUS_STR
+};
+
+char *rds_ib_wc_status_str(enum ib_wc_status status)
+{
+	return rds_str_array(rds_ib_wc_status_strings,
+			     ARRAY_SIZE(rds_ib_wc_status_strings), status);
+}
+
 /*
  * Convert IB-specific error message to RDS error message and call core
  * completion handler.
@@ -257,8 +291,9 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 		rdsdebug("ib_req_notify_cq send failed: %d\n", ret);
 
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		rdsdebug("wc wr_id 0x%llx status %u byte_len %u imm_data %u\n",
-			 (unsigned long long)wc.wr_id, wc.status, wc.byte_len,
+		rdsdebug("wc wr_id 0x%llx status %u (%s) byte_len %u imm_data %u\n",
+			 (unsigned long long)wc.wr_id, wc.status,
+			 rds_ib_wc_status_str(wc.status), wc.byte_len,
 			 be32_to_cpu(wc.ex.imm_data));
 		rds_ib_stats_inc(s_ib_tx_cq_event);
 
@@ -306,10 +341,10 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 
 		/* We expect errors as the qp is drained during shutdown */
 		if (wc.status != IB_WC_SUCCESS && rds_conn_up(conn)) {
-			rds_ib_conn_error(conn,
-				"send completion on %pI4 "
-				"had status %u, disconnecting and reconnecting\n",
-				&conn->c_faddr, wc.status);
+			rds_ib_conn_error(conn, "send completion on %pI4 had status "
+					  "%u (%s), disconnecting and reconnecting\n",
+					  &conn->c_faddr, wc.status,
+					  rds_ib_wc_status_str(wc.status));
 		}
 	}
 }
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 550d348..e6ed10a 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -36,6 +36,34 @@
 
 static struct rdma_cm_id *rds_rdma_listen_id;
 
+static char *rds_cm_event_strings[] = {
+#define RDS_CM_EVENT_STRING(foo) \
+		[RDMA_CM_EVENT_##foo] = __stringify(RDMA_CM_EVENT_##foo)
+	RDS_CM_EVENT_STRING(ADDR_RESOLVED),
+	RDS_CM_EVENT_STRING(ADDR_ERROR),
+	RDS_CM_EVENT_STRING(ROUTE_RESOLVED),
+	RDS_CM_EVENT_STRING(ROUTE_ERROR),
+	RDS_CM_EVENT_STRING(CONNECT_REQUEST),
+	RDS_CM_EVENT_STRING(CONNECT_RESPONSE),
+	RDS_CM_EVENT_STRING(CONNECT_ERROR),
+	RDS_CM_EVENT_STRING(UNREACHABLE),
+	RDS_CM_EVENT_STRING(REJECTED),
+	RDS_CM_EVENT_STRING(ESTABLISHED),
+	RDS_CM_EVENT_STRING(DISCONNECTED),
+	RDS_CM_EVENT_STRING(DEVICE_REMOVAL),
+	RDS_CM_EVENT_STRING(MULTICAST_JOIN),
+	RDS_CM_EVENT_STRING(MULTICAST_ERROR),
+	RDS_CM_EVENT_STRING(ADDR_CHANGE),
+	RDS_CM_EVENT_STRING(TIMEWAIT_EXIT),
+#undef RDS_CM_EVENT_STRING
+};
+
+static char *rds_cm_event_str(enum rdma_cm_event_type type)
+{
+	return rds_str_array(rds_cm_event_strings,
+			     ARRAY_SIZE(rds_cm_event_strings), type);
+};
+
 int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 			      struct rdma_cm_event *event)
 {
@@ -44,8 +72,8 @@ int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 	struct rds_transport *trans;
 	int ret = 0;
 
-	rdsdebug("conn %p id %p handling event %u\n", conn, cm_id,
-		 event->event);
+	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
+		 event->event, rds_cm_event_str(event->event));
 
 	if (cm_id->device->node_type == RDMA_NODE_RNIC)
 		trans = &rds_iw_transport;
@@ -109,7 +137,8 @@ int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
 
 	default:
 		/* things like device disconnect? */
-		printk(KERN_ERR "RDS: unknown event %u!\n", event->event);
+		printk(KERN_ERR "RDS: unknown event %u (%s)!\n",
+		       event->event, rds_cm_event_str(event->event));
 		break;
 	}
 
@@ -117,7 +146,8 @@ out:
 	if (conn)
 		mutex_unlock(&conn->c_cm_lock);
 
-	rdsdebug("id %p event %u handling ret %d\n", cm_id, event->event, ret);
+	rdsdebug("id %p event %u (%s) handling ret %d\n", cm_id, event->event,
+		 rds_cm_event_str(event->event), ret);
 
 	return ret;
 }
diff --git a/net/rds/rds.h b/net/rds/rds.h
index aab5e94..aadaddb 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -566,6 +566,7 @@ struct rds_statistics {
 };
 
 /* af_rds.c */
+char *rds_str_array(char **array, size_t elements, size_t index);
 void rds_sock_addref(struct rds_sock *rs);
 void rds_sock_put(struct rds_sock *rs);
 void rds_wake_sk_sleep(struct rds_sock *rs);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
