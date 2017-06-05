From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/CM: Create appropriate path records when handling CM request
Date: Mon,  5 Jun 2017 14:20:02 -0400
Message-ID: <1496686803-51338-3-git-send-email-don.hiatt@intel.com>
References: <1496686803-51338-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496686803-51338-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When handling an incoming conection request, ib_cm creates
either an IB or an OPA path record based on the gid field
in the request.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f8602e0..43d84cb 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1428,6 +1428,12 @@ static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
 		 (be32_to_cpu(local_qpn) > be32_to_cpu(remote_qpn))));
 }
 
+static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
+{
+	return ((req_msg->alt_local_lid) ||
+		(ib_is_opa_gid(&req_msg->alt_local_gid)));
+}
+
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
 				     struct sa_path_rec *alt_path)
@@ -1807,9 +1813,18 @@ static int cm_req_handler(struct cm_work *work)
 					 dev_net(gid_attr.ndev));
 			dev_put(gid_attr.ndev);
 		} else {
-			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
+			/*
+			 * If the gid in the request is an OPA GID,
+			 * create an OPA PR
+			 */
+			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
+			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
+					    work->port->port_num))
+				work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
+			else
+				work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
 		}
-		if (req_msg->alt_local_lid)
+		if (cm_req_has_alt_path(req_msg))
 			work->path[1].rec_type = work->path[0].rec_type;
 		cm_format_paths_from_req(req_msg, &work->path[0],
 					 &work->path[1]);
@@ -1834,16 +1849,21 @@ static int cm_req_handler(struct cm_work *work)
 					 dev_net(gid_attr.ndev));
 			dev_put(gid_attr.ndev);
 		} else {
-			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
+			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
+			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
+					    work->port->port_num))
+				work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
+			else
+				work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
 		}
-		if (req_msg->alt_local_lid)
+		if (cm_req_has_alt_path(req_msg))
 			work->path[1].rec_type = work->path[0].rec_type;
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
 			       NULL, 0);
 		goto rejected;
 	}
-	if (req_msg->alt_local_lid) {
+	if (cm_req_has_alt_path(req_msg)) {
 		ret = cm_init_av_by_path(&work->path[1], &cm_id_priv->alt_av,
 					 cm_id_priv);
 		if (ret) {
@@ -2962,8 +2982,6 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 				    struct sa_path_rec *path,
 				    struct cm_lap_msg *lap_msg)
 {
-	memset(path, 0, sizeof *path);
-	path->rec_type = SA_PATH_REC_TYPE_IB;
 	path->dgid = lap_msg->alt_local_gid;
 	path->sgid = lap_msg->alt_remote_gid;
 	sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
@@ -2999,6 +3017,13 @@ static int cm_lap_handler(struct cm_work *work)
 		return -EINVAL;
 
 	param = &work->cm_event.param.lap_rcvd;
+	memset(&work->path[0], 0, sizeof(work->path[0]));
+	if (ib_is_opa_gid(&lap_msg->alt_local_gid) &&
+	    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
+			    work->port->port_num))
+		work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
 	param->alternate_path = &work->path[0];
 	cm_format_path_from_lap(cm_id_priv, param->alternate_path, lap_msg);
 	work->cm_event.private_data = &lap_msg->private_data;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
