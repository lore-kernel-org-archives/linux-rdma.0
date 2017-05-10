From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/CM: Convert OPA Path record to IB during CM request
Date: Wed, 10 May 2017 19:23:15 -0400
Message-ID: <1494458598-6911-2-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OPA path records need to be converted to IB path records
during a connection request. If the slid/dlid fields in the
OPA path records are extended, the resulting converted IB
path records will have the corresponding GIDs populated as
OPA GIDs

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 49 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 6b3b0be..9a7f4be 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1173,8 +1173,24 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 			  struct cm_id_private *cm_id_priv,
 			  struct ib_cm_req_param *param)
 {
-	struct sa_path_rec *pri_path = param->primary_path;
-	struct sa_path_rec *alt_path = param->alternate_path;
+	struct sa_path_rec *pri_path;
+	struct sa_path_rec *alt_path;
+	struct sa_path_rec conv_path;
+
+	if (param->primary_path->rec_type == SA_PATH_REC_TYPE_OPA) {
+		sa_convert_path_opa_to_ib(&conv_path, param->primary_path);
+		pri_path = &conv_path;
+	} else {
+		pri_path = param->primary_path;
+	}
+
+	if ((param->alternate_path) &&
+	    (param->alternate_path->rec_type == SA_PATH_REC_TYPE_OPA)) {
+		sa_convert_path_opa_to_ib(&conv_path, param->alternate_path);
+		alt_path = &conv_path;
+	} else {
+		alt_path = param->alternate_path;
+	}
 
 	cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
 			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
@@ -2843,6 +2859,9 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 			  const void *private_data,
 			  u8 private_data_len)
 {
+	struct sa_path_rec conv_path;
+	struct sa_path_rec *path;
+
 	cm_format_mad_hdr(&lap_msg->hdr, CM_LAP_ATTR_ID,
 			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_LAP));
 	lap_msg->local_comm_id = cm_id_priv->id.local_id;
@@ -2850,21 +2869,27 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 	cm_lap_set_remote_qpn(lap_msg, cm_id_priv->remote_qpn);
 	/* todo: need remote CM response timeout */
 	cm_lap_set_remote_resp_timeout(lap_msg, 0x1F);
+	if (alternate_path->rec_type == SA_PATH_REC_TYPE_OPA) {
+		sa_convert_path_opa_to_ib(&conv_path, alternate_path);
+		path = &conv_path;
+	} else {
+		path = alternate_path;
+	}
 	lap_msg->alt_local_lid =
-		htons(ntohl(sa_path_get_slid(alternate_path)));
+		htons(ntohl(sa_path_get_slid(path)));
 	lap_msg->alt_remote_lid =
-		htons(ntohl(sa_path_get_dlid(alternate_path)));
-	lap_msg->alt_local_gid = alternate_path->sgid;
-	lap_msg->alt_remote_gid = alternate_path->dgid;
-	cm_lap_set_flow_label(lap_msg, alternate_path->flow_label);
-	cm_lap_set_traffic_class(lap_msg, alternate_path->traffic_class);
-	lap_msg->alt_hop_limit = alternate_path->hop_limit;
-	cm_lap_set_packet_rate(lap_msg, alternate_path->rate);
-	cm_lap_set_sl(lap_msg, alternate_path->sl);
+		htons(ntohl(sa_path_get_dlid(path)));
+	lap_msg->alt_local_gid = path->sgid;
+	lap_msg->alt_remote_gid = path->dgid;
+	cm_lap_set_flow_label(lap_msg, path->flow_label);
+	cm_lap_set_traffic_class(lap_msg, path->traffic_class);
+	lap_msg->alt_hop_limit = path->hop_limit;
+	cm_lap_set_packet_rate(lap_msg, path->rate);
+	cm_lap_set_sl(lap_msg, path->sl);
 	cm_lap_set_subnet_local(lap_msg, 1); /* local only... */
 	cm_lap_set_local_ack_timeout(lap_msg,
 		cm_ack_timeout(cm_id_priv->av.port->cm_dev->ack_delay,
-			       alternate_path->packet_life_time));
+			       path->packet_life_time));
 
 	if (private_data && private_data_len)
 		memcpy(lap_msg->private_data, private_data, private_data_len);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
