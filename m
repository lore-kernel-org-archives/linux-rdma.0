From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/CM: Set appropriate slid and dlid when handling CM request
Date: Mon,  5 Jun 2017 14:20:03 -0400
Message-ID: <1496686803-51338-4-git-send-email-don.hiatt@intel.com>
References: <1496686803-51338-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496686803-51338-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If extended LIDs are being used, a connection request contains
OPA GIDs in them. Extract the lids from the OPA gids and populate
slid/dlid fields in the path records that are created when handling
a connection request.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 67 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 43d84cb..5a38671 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1434,16 +1434,48 @@ static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
 		(ib_is_opa_gid(&req_msg->alt_local_gid)));
 }
 
+static void cm_format_path_lid_from_req(struct cm_req_msg *req_msg,
+					struct sa_path_rec *primary_path,
+					struct sa_path_rec *alt_path)
+{
+	u32 lid;
+
+	if (primary_path->rec_type != SA_PATH_REC_TYPE_OPA) {
+		sa_path_set_dlid(primary_path,
+				 htonl(ntohs(req_msg->primary_local_lid)));
+		sa_path_set_slid(primary_path,
+				 htonl(ntohs(req_msg->primary_remote_lid)));
+	} else {
+		lid = opa_get_lid_from_gid(&req_msg->primary_local_gid);
+		sa_path_set_dlid(primary_path, cpu_to_be32(lid));
+
+		lid = opa_get_lid_from_gid(&req_msg->primary_remote_gid);
+		sa_path_set_slid(primary_path, cpu_to_be32(lid));
+	}
+
+	if (!cm_req_has_alt_path(req_msg))
+		return;
+
+	if (alt_path->rec_type != SA_PATH_REC_TYPE_OPA) {
+		sa_path_set_dlid(alt_path,
+				 htonl(ntohs(req_msg->alt_local_lid)));
+		sa_path_set_slid(alt_path,
+				 htonl(ntohs(req_msg->alt_remote_lid)));
+	} else {
+		lid = opa_get_lid_from_gid(&req_msg->alt_local_gid);
+		sa_path_set_dlid(alt_path, cpu_to_be32(lid));
+
+		lid = opa_get_lid_from_gid(&req_msg->alt_remote_gid);
+		sa_path_set_slid(alt_path, cpu_to_be32(lid));
+	}
+}
+
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
 				     struct sa_path_rec *alt_path)
 {
 	primary_path->dgid = req_msg->primary_local_gid;
 	primary_path->sgid = req_msg->primary_remote_gid;
-	sa_path_set_dlid(primary_path,
-			 htonl(ntohs(req_msg->primary_local_lid)));
-	sa_path_set_slid(primary_path,
-			 htonl(ntohs(req_msg->primary_remote_lid)));
 	primary_path->flow_label = cm_req_get_primary_flow_label(req_msg);
 	primary_path->hop_limit = req_msg->primary_hop_limit;
 	primary_path->traffic_class = req_msg->primary_traffic_class;
@@ -1460,13 +1492,9 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	primary_path->packet_life_time -= (primary_path->packet_life_time > 0);
 	sa_path_set_service_id(primary_path, req_msg->service_id);
 
-	if (req_msg->alt_local_lid) {
+	if (cm_req_has_alt_path(req_msg)) {
 		alt_path->dgid = req_msg->alt_local_gid;
 		alt_path->sgid = req_msg->alt_remote_gid;
-		sa_path_set_dlid(alt_path,
-				 htonl(ntohs(req_msg->alt_local_lid)));
-		sa_path_set_slid(alt_path,
-				 htonl(ntohs(req_msg->alt_remote_lid)));
 		alt_path->flow_label = cm_req_get_alt_flow_label(req_msg);
 		alt_path->hop_limit = req_msg->alt_hop_limit;
 		alt_path->traffic_class = req_msg->alt_traffic_class;
@@ -1483,6 +1511,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		alt_path->packet_life_time -= (alt_path->packet_life_time > 0);
 		sa_path_set_service_id(alt_path, req_msg->service_id);
 	}
+	cm_format_path_lid_from_req(req_msg, primary_path, alt_path);
 }
 
 static u16 cm_get_bth_pkey(struct cm_work *work)
@@ -2978,14 +3007,29 @@ int ib_send_cm_lap(struct ib_cm_id *cm_id,
 }
 EXPORT_SYMBOL(ib_send_cm_lap);
 
+static void cm_format_path_lid_from_lap(struct cm_lap_msg *lap_msg,
+					struct sa_path_rec *path)
+{
+	u32 lid;
+
+	if (path->rec_type != SA_PATH_REC_TYPE_OPA) {
+		sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
+		sa_path_set_slid(path, htonl(ntohs(lap_msg->alt_remote_lid)));
+	} else {
+		lid = opa_get_lid_from_gid(&lap_msg->alt_local_gid);
+		sa_path_set_dlid(path, cpu_to_be32(lid));
+
+		lid = opa_get_lid_from_gid(&lap_msg->alt_remote_gid);
+		sa_path_set_slid(path, cpu_to_be32(lid));
+	}
+}
+
 static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 				    struct sa_path_rec *path,
 				    struct cm_lap_msg *lap_msg)
 {
 	path->dgid = lap_msg->alt_local_gid;
 	path->sgid = lap_msg->alt_remote_gid;
-	sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
-	sa_path_set_slid(path, htonl(ntohs(lap_msg->alt_remote_lid)));
 	path->flow_label = cm_lap_get_flow_label(lap_msg);
 	path->hop_limit = lap_msg->alt_hop_limit;
 	path->traffic_class = cm_lap_get_traffic_class(lap_msg);
@@ -2999,6 +3043,7 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 	path->packet_life_time_selector = IB_SA_EQ;
 	path->packet_life_time = cm_lap_get_local_ack_timeout(lap_msg);
 	path->packet_life_time -= (path->packet_life_time > 0);
+	cm_format_path_lid_from_lap(lap_msg, path);
 }
 
 static int cm_lap_handler(struct cm_work *work)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
