From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 2/9] IB/cm: Use the source GID index type
Date: Thu, 15 Oct 2015 19:07:05 +0300
Message-ID: <1444925232-13598-3-git-send-email-matanb@mellanox.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444925232-13598-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previosuly, cm and cma modules supported only IB and RoCE v1 GID type.
In order to support multiple GID types, the gid_type is passed to
cm_init_av_by_path and stored in the path record.

The rdma cm client would use a default GID type that will be saved in
rdma_id_private.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c  | 25 ++++++++++++++++++++-----
 drivers/infiniband/core/cma.c |  2 ++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index a8e14be..985e4cd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -364,7 +364,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					IB_GID_TYPE_IB, ndev, &p, NULL)) {
+					path->gid_type, ndev, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
@@ -1595,6 +1595,8 @@ static int cm_req_handler(struct cm_work *work)
 	struct ib_cm_id *cm_id;
 	struct cm_id_private *cm_id_priv, *listen_cm_id_priv;
 	struct cm_req_msg *req_msg;
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
 	int ret;
 
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
@@ -1634,11 +1636,24 @@ static int cm_req_handler(struct cm_work *work)
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
 	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
-	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
+	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
+				work->port->port_num,
+				cm_id_priv->av.ah_attr.grh.sgid_index,
+				&gid, &gid_attr);
+	if (!ret) {
+		if (gid_attr.ndev)
+			dev_put(gid_attr.ndev);
+		work->path[0].gid_type = gid_attr.gid_type;
+		ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
+	}
 	if (ret) {
-		ib_get_cached_gid(work->port->cm_dev->ib_device,
-				  work->port->port_num, 0, &work->path[0].sgid,
-				  NULL);
+		int err = ib_get_cached_gid(work->port->cm_dev->ib_device,
+					    work->port->port_num, 0,
+					    &work->path[0].sgid,
+					    &gid_attr);
+		if (!err && gid_attr.ndev)
+			dev_put(gid_attr.ndev);
+		work->path[0].gid_type = gid_attr.gid_type;
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
 			       NULL, 0);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a56e957..2e592e6 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -214,6 +214,7 @@ struct rdma_id_private {
 	u8			tos;
 	u8			reuseaddr;
 	u8			afonly;
+	enum ib_gid_type	gid_type;
 };
 
 struct cma_multicast {
@@ -2276,6 +2277,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 		route->path_rec->net = &init_net;
 		route->path_rec->ifindex = addr->dev_addr.bound_dev_if;
+		route->path_rec->gid_type = id_priv->gid_type;
 	}
 	if (!ndev) {
 		ret = -ENODEV;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
