From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 26/31] IB/{cm, umad}: Fix honor av init error
Date: Tue, 14 Nov 2017 14:52:13 +0200
Message-ID: <20171114125218.20477-27-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

cm_init_av_for_response depends on ib_init_ah_from_wc() whose return
status is ignored.
ib_init_ah_from_wc() can fail and its return status should be honored as
done in this patch.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c       | 34 +++++++++++++++++++++-------------
 drivers/infiniband/core/user_mad.c | 10 +++++++---
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index cbb385e02947..9a60d21ed0c3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -452,13 +452,13 @@ static void cm_set_private_data(struct cm_id_private *cm_id_priv,
 	cm_id_priv->private_data_len = private_data_len;
 }
 
-static void cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
-				    struct ib_grh *grh, struct cm_av *av)
+static int cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
+				   struct ib_grh *grh, struct cm_av *av)
 {
 	av->port = port;
 	av->pkey_index = wc->pkey_index;
-	ib_init_ah_from_wc(port->cm_dev->ib_device, port->port_num, wc,
-			   grh, &av->ah_attr);
+	return ib_init_ah_from_wc(port->cm_dev->ib_device, port->port_num, wc,
+				  grh, &av->ah_attr);
 }
 
 static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
@@ -1826,9 +1826,11 @@ static int cm_req_handler(struct cm_work *work)
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	cm_id_priv->id.remote_id = req_msg->local_comm_id;
-	cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
-				work->mad_recv_wc->recv_buf.grh,
-				&cm_id_priv->av);
+	ret = cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
+				      work->mad_recv_wc->recv_buf.grh,
+				      &cm_id_priv->av);
+	if (ret)
+		goto destroy;
 	cm_id_priv->timewait_info = cm_create_timewait_info(cm_id_priv->
 							    id.local_id);
 	if (IS_ERR(cm_id_priv->timewait_info)) {
@@ -3171,9 +3173,11 @@ static int cm_lap_handler(struct cm_work *work)
 
 	cm_id_priv->id.lap_state = IB_CM_LAP_RCVD;
 	cm_id_priv->tid = lap_msg->hdr.tid;
-	cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
-				work->mad_recv_wc->recv_buf.grh,
-				&cm_id_priv->av);
+	ret = cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
+				      work->mad_recv_wc->recv_buf.grh,
+				      &cm_id_priv->av);
+	if (ret)
+		goto unlock;
 	cm_init_av_by_path(param->alternate_path, &cm_id_priv->alt_av,
 			   cm_id_priv);
 	ret = atomic_inc_and_test(&cm_id_priv->work_count);
@@ -3426,6 +3430,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 	struct cm_id_private *cm_id_priv, *cur_cm_id_priv;
 	struct cm_sidr_req_msg *sidr_req_msg;
 	struct ib_wc *wc;
+	int ret;
 
 	cm_id = ib_create_cm_id(work->port->cm_dev->ib_device, NULL, NULL);
 	if (IS_ERR(cm_id))
@@ -3438,9 +3443,12 @@ static int cm_sidr_req_handler(struct cm_work *work)
 	wc = work->mad_recv_wc->wc;
 	cm_id_priv->av.dgid.global.subnet_prefix = cpu_to_be64(wc->slid);
 	cm_id_priv->av.dgid.global.interface_id = 0;
-	cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
-				work->mad_recv_wc->recv_buf.grh,
-				&cm_id_priv->av);
+	ret = cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
+				      work->mad_recv_wc->recv_buf.grh,
+				      &cm_id_priv->av);
+	if (ret)
+		goto out;
+
 	cm_id_priv->id.remote_id = sidr_req_msg->request_id;
 	cm_id_priv->tid = sidr_req_msg->hdr.tid;
 	atomic_inc(&cm_id_priv->work_count);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 4b64dd02e090..3179fed4b408 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -246,10 +246,14 @@ static void recv_handler(struct ib_mad_agent *agent,
 	if (packet->mad.hdr.grh_present) {
 		struct rdma_ah_attr ah_attr;
 		const struct ib_global_route *grh;
+		int ret;
 
-		ib_init_ah_from_wc(agent->device, agent->port_num,
-				   mad_recv_wc->wc, mad_recv_wc->recv_buf.grh,
-				   &ah_attr);
+		ret = ib_init_ah_from_wc(agent->device, agent->port_num,
+					 mad_recv_wc->wc,
+					 mad_recv_wc->recv_buf.grh,
+					 &ah_attr);
+		if (ret)
+			goto err2;
 
 		grh = rdma_ah_read_grh(&ah_attr);
 		packet->mad.hdr.gid_index = grh->sgid_index;
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
