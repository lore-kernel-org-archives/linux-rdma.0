From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 16/27] IB/CM: Set appropriate slid and dlid when
 handling CM request
Date: Fri, 04 Aug 2017 13:53:45 -0700
Message-ID: <20170804205344.17853.75655.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If extended LIDs are being used, a connection request contains
OPA GIDs in them. Extract the lids from the OPA gids and populate
slid/dlid fields in the path records that are created when handling
a connection request.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c |   67 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4d870a0..d5ca101 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1443,16 +1443,48 @@ static void cm_path_set_rec_type(struct ib_device *ib_device, u8 port_num,
 		path->rec_type = SA_PATH_REC_TYPE_IB;
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
@@ -1469,13 +1501,9 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	primary_path->packet_life_time -= (primary_path->packet_life_time > 0);
 	primary_path->service_id = req_msg->service_id;
 
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
@@ -1492,6 +1520,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		alt_path->packet_life_time -= (alt_path->packet_life_time > 0);
 		alt_path->service_id = req_msg->service_id;
 	}
+	cm_format_path_lid_from_req(req_msg, primary_path, alt_path);
 }
 
 static u16 cm_get_bth_pkey(struct cm_work *work)
@@ -2979,14 +3008,29 @@ int ib_send_cm_lap(struct ib_cm_id *cm_id,
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
@@ -3000,6 +3044,7 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 	path->packet_life_time_selector = IB_SA_EQ;
 	path->packet_life_time = cm_lap_get_local_ack_timeout(lap_msg);
 	path->packet_life_time -= (path->packet_life_time > 0);
+	cm_format_path_lid_from_lap(lap_msg, path);
 }
 
 static int cm_lap_handler(struct cm_work *work)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
