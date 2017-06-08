From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next v3 1/3] IB/CM: Add OPA Path record support to CM
Date: Thu,  8 Jun 2017 13:38:02 -0400
Message-ID: <1496943484-44065-2-git-send-email-don.hiatt@intel.com>
References: <1496943484-44065-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496943484-44065-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add OPA path record support to the Connection Manager.

Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 50 +++++++++++++++++++++++++++++++++++++-------
 include/rdma/opa_addr.h      | 18 ++++++++++++++++
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 8525d65..f8602e0 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1175,6 +1175,11 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 {
 	struct sa_path_rec *pri_path = param->primary_path;
 	struct sa_path_rec *alt_path = param->alternate_path;
+	bool pri_ext = false;
+
+	if (pri_path->rec_type == SA_PATH_REC_TYPE_OPA)
+		pri_ext = opa_is_extended_lid(pri_path->opa.dlid,
+					      pri_path->opa.slid);
 
 	cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
 			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
@@ -1202,18 +1207,24 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 		cm_req_set_srq(req_msg, param->srq);
 	}
 
+	req_msg->primary_local_gid = pri_path->sgid;
+	req_msg->primary_remote_gid = pri_path->dgid;
+	if (pri_ext) {
+		req_msg->primary_local_gid.global.interface_id
+			= OPA_MAKE_ID(be32_to_cpu(pri_path->opa.slid));
+		req_msg->primary_remote_gid.global.interface_id
+			= OPA_MAKE_ID(be32_to_cpu(pri_path->opa.dlid));
+	}
 	if (pri_path->hop_limit <= 1) {
-		req_msg->primary_local_lid =
+		req_msg->primary_local_lid = pri_ext ? 0 :
 			htons(ntohl(sa_path_get_slid(pri_path)));
-		req_msg->primary_remote_lid =
+		req_msg->primary_remote_lid = pri_ext ? 0 :
 			htons(ntohl(sa_path_get_dlid(pri_path)));
 	} else {
 		/* Work-around until there's a way to obtain remote LID info */
 		req_msg->primary_local_lid = IB_LID_PERMISSIVE;
 		req_msg->primary_remote_lid = IB_LID_PERMISSIVE;
 	}
-	req_msg->primary_local_gid = pri_path->sgid;
-	req_msg->primary_remote_gid = pri_path->dgid;
 	cm_req_set_primary_flow_label(req_msg, pri_path->flow_label);
 	cm_req_set_primary_packet_rate(req_msg, pri_path->rate);
 	req_msg->primary_traffic_class = pri_path->traffic_class;
@@ -1225,17 +1236,29 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 			       pri_path->packet_life_time));
 
 	if (alt_path) {
+		bool alt_ext = false;
+
+		if (alt_path->rec_type == SA_PATH_REC_TYPE_OPA)
+			alt_ext = opa_is_extended_lid(alt_path->opa.dlid,
+						      alt_path->opa.slid);
+
+		req_msg->alt_local_gid = alt_path->sgid;
+		req_msg->alt_remote_gid = alt_path->dgid;
+		if (alt_ext) {
+			req_msg->alt_local_gid.global.interface_id
+				= OPA_MAKE_ID(be32_to_cpu(alt_path->opa.slid));
+			req_msg->alt_remote_gid.global.interface_id
+				= OPA_MAKE_ID(be32_to_cpu(alt_path->opa.dlid));
+		}
 		if (alt_path->hop_limit <= 1) {
-			req_msg->alt_local_lid =
+			req_msg->alt_local_lid = alt_ext ? 0 :
 				htons(ntohl(sa_path_get_slid(alt_path)));
-			req_msg->alt_remote_lid =
+			req_msg->alt_remote_lid = alt_ext ? 0 :
 				htons(ntohl(sa_path_get_dlid(alt_path)));
 		} else {
 			req_msg->alt_local_lid = IB_LID_PERMISSIVE;
 			req_msg->alt_remote_lid = IB_LID_PERMISSIVE;
 		}
-		req_msg->alt_local_gid = alt_path->sgid;
-		req_msg->alt_remote_gid = alt_path->dgid;
 		cm_req_set_alt_flow_label(req_msg,
 					  alt_path->flow_label);
 		cm_req_set_alt_packet_rate(req_msg, alt_path->rate);
@@ -2843,6 +2866,11 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 			  const void *private_data,
 			  u8 private_data_len)
 {
+	bool alt_ext = false;
+
+	if (alternate_path->rec_type == SA_PATH_REC_TYPE_OPA)
+		alt_ext = opa_is_extended_lid(alternate_path->opa.dlid,
+					      alternate_path->opa.slid);
 	cm_format_mad_hdr(&lap_msg->hdr, CM_LAP_ATTR_ID,
 			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_LAP));
 	lap_msg->local_comm_id = cm_id_priv->id.local_id;
@@ -2856,6 +2884,12 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 		htons(ntohl(sa_path_get_dlid(alternate_path)));
 	lap_msg->alt_local_gid = alternate_path->sgid;
 	lap_msg->alt_remote_gid = alternate_path->dgid;
+	if (alt_ext) {
+		lap_msg->alt_local_gid.global.interface_id
+			= OPA_MAKE_ID(be32_to_cpu(alternate_path->opa.slid));
+		lap_msg->alt_remote_gid.global.interface_id
+			= OPA_MAKE_ID(be32_to_cpu(alternate_path->opa.dlid));
+	}
 	cm_lap_set_flow_label(lap_msg, alternate_path->flow_label);
 	cm_lap_set_traffic_class(lap_msg, alternate_path->traffic_class);
 	lap_msg->alt_hop_limit = alternate_path->hop_limit;
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
index 46d0567..9b5e642 100644
--- a/include/rdma/opa_addr.h
+++ b/include/rdma/opa_addr.h
@@ -77,4 +77,22 @@ static inline u32 opa_get_lid_from_gid(union ib_gid *gid)
 {
 	return be64_to_cpu(gid->global.interface_id) & 0xFFFFFFFF;
 }
+
+/**
+ * opa_is_extended_lid: Returns true if dlid or slid are
+ * extended.
+ *
+ * @dlid: The DLID
+ * @slid: The SLID
+ */
+static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
+{
+	if ((be32_to_cpu(dlid) >=
+	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
+	    (be32_to_cpu(slid) >=
+	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
+		return true;
+	else
+		return false;
+}
 #endif /* OPA_ADDR_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
