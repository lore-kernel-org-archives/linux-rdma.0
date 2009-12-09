From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/11] RDMA/nes: crash in nes_accept
Date: Wed, 9 Dec 2009 16:40:46 -0600
Message-ID: <20091209224046.GA124324@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While running IMP_EXT's window test, the node crashed in nes_accept().
Here is the sequence of what happened.
(1) In MVAPICH2, connect request is received for port #0.

FIX:    For this, nes_connect() check to make sure local or remote tcp port
        is not 0.

(2) Remote node's (passive) tcp stack send reset when it gets connect
request because of port = 0. Active side sets the connect error to
IW_CM_EVENT_STATUS_REJECTED when it received the RST from remote node.

FIX: The corect error code is -ECONNRESET.

(3) Wrong error code of IW_CM_EVENT_STATUS_REJECTED causes core to destroy its
listener ports. Here there are connections which may have send MPA request up
and waiting for accept or reject. But the listener and its cm_nodes
have been freed already causing the crash noticed.

FIX: The cm_node is freed only if its state is not NES_CM_STATE_MPAREQ_RCVD.
If cm_node's state is NES_CM_STATE_MPAREQ_RCVD then its new state
is set to NES_CM_STATE_LISTENER_DESTROYED and it is not freed.
When nes_accept() or nes_reject() is received, its state is checked
for NES_CM_STATE_LISTENER_DESTROYED and in this case the cm_node is
freed and error is returned.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   77 +++++++++++++++++++++++-------------
 drivers/infiniband/hw/nes/nes_cm.h |    1 +
 2 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 08fcd25..ec04786 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -978,6 +978,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 				reset_entry);
 		{
 			struct nes_cm_node *loopback = cm_node->loopbackpartner;
+			enum nes_cm_node_state old_state;
 			if (NES_CM_STATE_FIN_WAIT1 <= cm_node->state) {
 				rem_ref_cm_node(cm_node->cm_core, cm_node);
 			} else {
@@ -989,11 +990,12 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 							 NES_CM_STATE_CLOSED;
 						WARN_ON(1);
 					} else {
-						cm_node->state =
-							NES_CM_STATE_CLOSED;
-						rem_ref_cm_node(
-							cm_node->cm_core,
-							cm_node);
+						old_state = cm_node->state;
+						cm_node->state = NES_CM_STATE_LISTENER_DESTROYED;
+						if (old_state != NES_CM_STATE_MPAREQ_RCVD)
+							rem_ref_cm_node(
+								cm_node->cm_core,
+								cm_node);
 					}
 				} else {
 					struct nes_cm_event event;
@@ -1009,6 +1011,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 							 loopback->loc_port;
 					event.cm_info.cm_id = loopback->cm_id;
 					cm_event_connect_error(&event);
+					cm_node->state = NES_CM_STATE_LISTENER_DESTROYED;
 					loopback->state = NES_CM_STATE_CLOSED;
 
 					event.cm_node = cm_node;
@@ -2131,30 +2134,39 @@ static int mini_cm_reject(struct nes_cm_core *cm_core,
 			cm_node->state = NES_CM_STATE_CLOSED;
 			rem_ref_cm_node(cm_core, cm_node);
 		} else {
-			ret = send_mpa_reject(cm_node);
-			if (ret) {
-				cm_node->state = NES_CM_STATE_CLOSED;
-				err = send_reset(cm_node, NULL);
-				if (err)
-					WARN_ON(1);
-			} else
-				cm_id->add_ref(cm_id);
+			if (cm_node->state == NES_CM_STATE_LISTENER_DESTROYED) {
+				rem_ref_cm_node(cm_core, cm_node);
+			} else {
+				ret = send_mpa_reject(cm_node);
+				if (ret) {
+					cm_node->state = NES_CM_STATE_CLOSED;
+					err = send_reset(cm_node, NULL);
+					if (err)
+						WARN_ON(1);
+				} else
+					cm_id->add_ref(cm_id);
+			}
 		}
 	} else {
 		cm_node->cm_id = NULL;
-		event.cm_node = loopback;
-		event.cm_info.rem_addr = loopback->rem_addr;
-		event.cm_info.loc_addr = loopback->loc_addr;
-		event.cm_info.rem_port = loopback->rem_port;
-		event.cm_info.loc_port = loopback->loc_port;
-		event.cm_info.cm_id = loopback->cm_id;
-		cm_event_mpa_reject(&event);
-		rem_ref_cm_node(cm_core, cm_node);
-		loopback->state = NES_CM_STATE_CLOSING;
+		if (cm_node->state == NES_CM_STATE_LISTENER_DESTROYED) {
+			rem_ref_cm_node(cm_core, cm_node);
+			rem_ref_cm_node(cm_core, loopback);
+		} else {
+			event.cm_node = loopback;
+			event.cm_info.rem_addr = loopback->rem_addr;
+			event.cm_info.loc_addr = loopback->loc_addr;
+			event.cm_info.rem_port = loopback->rem_port;
+			event.cm_info.loc_port = loopback->loc_port;
+			event.cm_info.cm_id = loopback->cm_id;
+			cm_event_mpa_reject(&event);
+			rem_ref_cm_node(cm_core, cm_node);
+			loopback->state = NES_CM_STATE_CLOSING;
 
-		cm_id = loopback->cm_id;
-		rem_ref_cm_node(cm_core, loopback);
-		cm_id->rem_ref(cm_id);
+			cm_id = loopback->cm_id;
+			rem_ref_cm_node(cm_core, loopback);
+			cm_id->rem_ref(cm_id);
+		}
 	}
 
 	return ret;
@@ -2198,6 +2210,7 @@ static int mini_cm_close(struct nes_cm_core *cm_core, struct nes_cm_node *cm_nod
 	case NES_CM_STATE_UNKNOWN:
 	case NES_CM_STATE_INITED:
 	case NES_CM_STATE_CLOSED:
+	case NES_CM_STATE_LISTENER_DESTROYED:
 		ret = rem_ref_cm_node(cm_core, cm_node);
 		break;
 	case NES_CM_STATE_TSA:
@@ -2716,8 +2729,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct nes_pd *nespd;
 	u64 tagged_offset;
 
-
-
 	ibqp = nes_get_qp(cm_id->device, conn_param->qpn);
 	if (!ibqp)
 		return -EINVAL;
@@ -2733,6 +2744,13 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		"%s\n", cm_node, nesvnic, nesvnic->netdev,
 		nesvnic->netdev->name);
 
+	if (NES_CM_STATE_LISTENER_DESTROYED == cm_node->state) {
+		if (cm_node->loopbackpartner)
+			rem_ref_cm_node(cm_node->cm_core, cm_node->loopbackpartner);
+		rem_ref_cm_node(cm_node->cm_core, cm_node);
+		return -EINVAL;
+	}
+
 	/* associate the node with the QP */
 	nesqp->cm_node = (void *)cm_node;
 	cm_node->nesqp = nesqp;
@@ -3003,6 +3021,9 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (!nesdev)
 		return -EINVAL;
 
+	if (!(cm_id->local_addr.sin_port) || !(cm_id->remote_addr.sin_port))
+		return -EINVAL;
+
 	nes_debug(NES_DBG_CM, "QP%u, current IP = 0x%08X, Destination IP = "
 		"0x%08X:0x%04X, local = 0x%08X:0x%04X.\n", nesqp->hwqp.qp_id,
 		ntohl(nesvnic->local_ipaddr),
@@ -3375,7 +3396,7 @@ static void cm_event_connect_error(struct nes_cm_event *event)
 	nesqp->cm_id = NULL;
 	cm_id->provider_data = NULL;
 	cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
-	cm_event.status = IW_CM_EVENT_STATUS_REJECTED;
+	cm_event.status = -ECONNRESET;
 	cm_event.provider_data = cm_id->provider_data;
 	cm_event.local_addr = cm_id->local_addr;
 	cm_event.remote_addr = cm_id->remote_addr;
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 911846a..d9825fd 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -200,6 +200,7 @@ enum nes_cm_node_state {
 	NES_CM_STATE_TIME_WAIT,
 	NES_CM_STATE_LAST_ACK,
 	NES_CM_STATE_CLOSING,
+	NES_CM_STATE_LISTENER_DESTROYED,
 	NES_CM_STATE_CLOSED
 };
 
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
