From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/17] ib/cm: Update protocol to support XRC
Date: Wed, 15 Jun 2011 06:28:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021034@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the REQ and REP messages to support XRC connection setup
according to the XRC Annex.  Several existing fields must be set
to 0 or 1 when connecting XRC QPs, and a reserved field is changed
to an extended transport type.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Note that there are discussions regarding this protocol that could result in
a minor change.

 drivers/infiniband/core/cm.c      |   49 +++++++++++++++++++++++++------------
 drivers/infiniband/core/cm_msgs.h |   13 +++++++++-
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f804e28..7577c1a 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1008,7 +1008,6 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	req_msg->service_id = param->service_id;
 	req_msg->local_ca_guid = cm_id_priv->id.device->node_guid;
 	cm_req_set_local_qpn(req_msg, cpu_to_be32(param->qp_num));
-	cm_req_set_resp_res(req_msg, param->responder_resources);
 	cm_req_set_init_depth(req_msg, param->initiator_depth);
 	cm_req_set_remote_resp_timeout(req_msg,
 				       param->remote_cm_response_timeout);
@@ -1017,12 +1016,16 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	cm_req_set_starting_psn(req_msg, cpu_to_be32(param->starting_psn));
 	cm_req_set_local_resp_timeout(req_msg,
 				      param->local_cm_response_timeout);
-	cm_req_set_retry_count(req_msg, param->retry_count);
 	req_msg->pkey = param->primary_path->pkey;
 	cm_req_set_path_mtu(req_msg, param->primary_path->mtu);
-	cm_req_set_rnr_retry_count(req_msg, param->rnr_retry_count);
 	cm_req_set_max_cm_retries(req_msg, param->max_cm_retries);
-	cm_req_set_srq(req_msg, param->srq);
+
+	if (param->qp_type != IB_QPT_XRC_TGT) {
+		cm_req_set_resp_res(req_msg, param->responder_resources);
+		cm_req_set_retry_count(req_msg, param->retry_count);
+		cm_req_set_rnr_retry_count(req_msg, param->rnr_retry_count);
+		cm_req_set_srq(req_msg, param->srq);
+	}
 
 	if (pri_path->hop_limit <= 1) {
 		req_msg->primary_local_lid = pri_path->slid;
@@ -1080,7 +1083,8 @@ static int cm_validate_req_param(struct ib_cm_req_param *param)
 	if (!param->primary_path)
 		return -EINVAL;
 
-	if (param->qp_type != IB_QPT_RC && param->qp_type != IB_QPT_UC)
+	if (param->qp_type != IB_QPT_RC && param->qp_type != IB_QPT_UC &&
+	    param->qp_type != IB_QPT_XRC_TGT)
 		return -EINVAL;
 
 	if (param->private_data &&
@@ -1145,7 +1149,8 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	cm_id_priv->retry_count = param->retry_count;
 	cm_id_priv->path_mtu = param->primary_path->mtu;
 	cm_id_priv->pkey = param->primary_path->pkey;
-	cm_id_priv->qp_type = param->qp_type;
+	cm_id_priv->qp_type = (param->qp_type == IB_QPT_XRC_TGT) ?
+			      IB_QPT_XRC_INI : param->qp_type;
 
 	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
 	if (ret)
@@ -1604,15 +1609,20 @@ static void cm_format_rep(struct cm_rep_msg *rep_msg,
 	cm_rep_set_local_qpn(rep_msg, cpu_to_be32(param->qp_num));
 	cm_rep_set_starting_psn(rep_msg, cpu_to_be32(param->starting_psn));
 	rep_msg->resp_resources = param->responder_resources;
-	rep_msg->initiator_depth = param->initiator_depth;
 	cm_rep_set_target_ack_delay(rep_msg,
 				    cm_id_priv->av.port->cm_dev->ack_delay);
 	cm_rep_set_failover(rep_msg, param->failover_accepted);
-	cm_rep_set_flow_ctrl(rep_msg, param->flow_control);
 	cm_rep_set_rnr_retry_count(rep_msg, param->rnr_retry_count);
-	cm_rep_set_srq(rep_msg, param->srq);
 	rep_msg->local_ca_guid = cm_id_priv->id.device->node_guid;
 
+	if (cm_id_priv->qp_type != IB_QPT_XRC_TGT) {
+		rep_msg->initiator_depth = param->initiator_depth;
+		cm_rep_set_flow_ctrl(rep_msg, param->flow_control);
+		cm_rep_set_srq(rep_msg, param->srq);
+	} else {
+		cm_rep_set_srq(rep_msg, 1);
+	}
+
 	if (param->private_data && param->private_data_len)
 		memcpy(rep_msg->private_data, param->private_data,
 		       param->private_data_len);
@@ -3492,7 +3502,8 @@ static int cm_init_qp_rtr_attr(struct cm_id_private *cm_id_priv,
 		qp_attr->path_mtu = cm_id_priv->path_mtu;
 		qp_attr->dest_qp_num = be32_to_cpu(cm_id_priv->remote_qpn);
 		qp_attr->rq_psn = be32_to_cpu(cm_id_priv->rq_psn);
-		if (cm_id_priv->qp_type == IB_QPT_RC) {
+		if (cm_id_priv->qp_type == IB_QPT_RC ||
+		    cm_id_priv->qp_type == IB_QPT_XRC_TGT) {
 			*qp_attr_mask |= IB_QP_MAX_DEST_RD_ATOMIC |
 					 IB_QP_MIN_RNR_TIMER;
 			qp_attr->max_dest_rd_atomic =
@@ -3537,15 +3548,21 @@ static int cm_init_qp_rts_attr(struct cm_id_private *cm_id_priv,
 		if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT) {
 			*qp_attr_mask = IB_QP_STATE | IB_QP_SQ_PSN;
 			qp_attr->sq_psn = be32_to_cpu(cm_id_priv->sq_psn);
-			if (cm_id_priv->qp_type == IB_QPT_RC) {
-				*qp_attr_mask |= IB_QP_TIMEOUT | IB_QP_RETRY_CNT |
-						 IB_QP_RNR_RETRY |
+			switch (cm_id_priv->qp_type) {
+			case IB_QPT_RC:
+			case IB_QPT_XRC_INI:
+				*qp_attr_mask |= IB_QP_RETRY_CNT | IB_QP_RNR_RETRY |
 						 IB_QP_MAX_QP_RD_ATOMIC;
-				qp_attr->timeout = cm_id_priv->av.timeout;
 				qp_attr->retry_cnt = cm_id_priv->retry_count;
 				qp_attr->rnr_retry = cm_id_priv->rnr_retry_count;
-				qp_attr->max_rd_atomic =
-					cm_id_priv->initiator_depth;
+				qp_attr->max_rd_atomic = cm_id_priv->initiator_depth;
+				/* fall through */
+			case IB_QPT_XRC_TGT:
+				*qp_attr_mask |= IB_QP_TIMEOUT;
+				qp_attr->timeout = cm_id_priv->av.timeout;
+				break;
+			default:
+				break;
 			}
 			if (cm_id_priv->alt_av.ah_attr.dlid) {
 				*qp_attr_mask |= IB_QP_PATH_MIG_STATE;
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index 7e63c08..d93e18c 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -86,7 +86,7 @@ struct cm_req_msg {
 	__be16 pkey;
 	/* path MTU:4, RDC exists:1, RNR retry count:3. */
 	u8 offset50;
-	/* max CM Retries:4, SRQ:1, rsvd:3 */
+	/* max CM Retries:4, SRQ:1, extended transport type:3 */
 	u8 offset51;
 
 	__be16 primary_local_lid;
@@ -175,6 +175,11 @@ static inline enum ib_qp_type cm_req_get_qp_type(struct cm_req_msg *req_msg)
 	switch(transport_type) {
 	case 0: return IB_QPT_RC;
 	case 1: return IB_QPT_UC;
+	case 3:
+		switch (req_msg->offset51 & 0x7) {
+		case 1: return IB_QPT_XRC_TGT;
+		default: return 0;
+		}
 	default: return 0;
 	}
 }
@@ -188,6 +193,12 @@ static inline void cm_req_set_qp_type(struct cm_req_msg *req_msg,
 						  req_msg->offset40) &
 						   0xFFFFFFF9) | 0x2);
 		break;
+	case IB_QPT_XRC_TGT:
+		req_msg->offset40 = cpu_to_be32((be32_to_cpu(
+						 req_msg->offset40) &
+						   0xFFFFFFF9) | 0x6);
+		req_msg->offset51 = (req_msg->offset51 & 0xF8) | 1;
+		break;
 	default:
 		req_msg->offset40 = cpu_to_be32(be32_to_cpu(
 						 req_msg->offset40) &


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
