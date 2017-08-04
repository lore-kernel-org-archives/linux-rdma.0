From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 15/27] IB/CM: Create appropriate path records when
 handling CM request
Date: Fri, 04 Aug 2017 13:53:39 -0700
Message-ID: <20170804205338.17853.19282.stgit@scvm10.sc.intel.com>
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

When handling an incoming conection request, ib_cm creates
either an IB or an OPA path record based on the gid field
in the request.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 885c429..4d870a0 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1428,6 +1428,21 @@ static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
 		 (be32_to_cpu(local_qpn) > be32_to_cpu(remote_qpn))));
 }
 
+static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
+{
+	return ((req_msg->alt_local_lid) ||
+		(ib_is_opa_gid(&req_msg->alt_local_gid)));
+}
+
+static void cm_path_set_rec_type(struct ib_device *ib_device, u8 port_num,
+				 struct sa_path_rec *path, union ib_gid *gid)
+{
+	if (ib_is_opa_gid(gid) && rdma_cap_opa_ah(ib_device, port_num))
+		path->rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		path->rec_type = SA_PATH_REC_TYPE_IB;
+}
+
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
 				     struct sa_path_rec *alt_path)
@@ -1807,9 +1822,12 @@ static int cm_req_handler(struct cm_work *work)
 					 dev_net(gid_attr.ndev));
 			dev_put(gid_attr.ndev);
 		} else {
-			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
+			cm_path_set_rec_type(work->port->cm_dev->ib_device,
+					     work->port->port_num,
+					     &work->path[0],
+					     &req_msg->primary_local_gid);
 		}
-		if (req_msg->alt_local_lid)
+		if (cm_req_has_alt_path(req_msg))
 			work->path[1].rec_type = work->path[0].rec_type;
 		cm_format_paths_from_req(req_msg, &work->path[0],
 					 &work->path[1]);
@@ -1834,16 +1852,19 @@ static int cm_req_handler(struct cm_work *work)
 					 dev_net(gid_attr.ndev));
 			dev_put(gid_attr.ndev);
 		} else {
-			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
+			cm_path_set_rec_type(work->port->cm_dev->ib_device,
+					     work->port->port_num,
+					     &work->path[0],
+					     &req_msg->primary_local_gid);
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
@@ -2962,8 +2983,6 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 				    struct sa_path_rec *path,
 				    struct cm_lap_msg *lap_msg)
 {
-	memset(path, 0, sizeof *path);
-	path->rec_type = SA_PATH_REC_TYPE_IB;
 	path->dgid = lap_msg->alt_local_gid;
 	path->sgid = lap_msg->alt_remote_gid;
 	sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
@@ -2999,6 +3018,11 @@ static int cm_lap_handler(struct cm_work *work)
 		return -EINVAL;
 
 	param = &work->cm_event.param.lap_rcvd;
+	memset(&work->path[0], 0, sizeof(work->path[1]));
+	cm_path_set_rec_type(work->port->cm_dev->ib_device,
+			     work->port->port_num,
+			     &work->path[0],
+			     &lap_msg->alt_local_gid);
 	param->alternate_path = &work->path[0];
 	cm_format_path_from_lap(cm_id_priv, param->alternate_path, lap_msg);
 	work->cm_event.private_data = &lap_msg->private_data;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
