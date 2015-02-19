From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/30] IB/core: Add gid_type to path and rdma_id_private
Date: Fri, 20 Feb 2015 03:32:25 +0530
Message-ID: <0ebef7be-0586-47bf-bcc4-f3ff21ca4f3b@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When using rdma cm, we want to take the gid_type from
the rdma_id_private. This is mandatory before adding
an API from user-space/configfs that sets
the gid_type of CM connection.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cm.c              |   19 ++++++++++++++-----
 drivers/infiniband/core/cma.c             |    2 ++
 drivers/infiniband/core/sa_query.c        |    3 ++-
 drivers/infiniband/core/uverbs_marshall.c |    1 +
 include/rdma/ib_sa.h                      |    1 +
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 7974e74..22dac05 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -358,9 +358,8 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					IB_GID_TYPE_IB, path->net,
-					path->ifindex,
-					&p, NULL)) {
+					path->gid_type, path->net,
+					path->ifindex, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
@@ -1521,6 +1520,8 @@ static int cm_req_handler(struct cm_work *work)
 	struct ib_cm_id *cm_id;
 	struct cm_id_private *cm_id_priv, *listen_cm_id_priv;
 	struct cm_req_msg *req_msg;
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
 	int ret;
 
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
@@ -1560,11 +1561,19 @@ static int cm_req_handler(struct cm_work *work)
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
 	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
-	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
+	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
+				work->port->port_num,
+				cm_id_priv->av.ah_attr.grh.sgid_index,
+				&gid, &gid_attr);
+	if (!ret) {
+		work->path[0].gid_type = gid_attr.gid_type;
+		ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
+	}
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
 				  work->port->port_num, 0, &work->path[0].sgid,
-				  NULL);
+				  &gid_attr);
+		work->path[0].gid_type = gid_attr.gid_type;
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
 			       NULL, 0);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 659676c..9afa410 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -146,6 +146,7 @@ struct rdma_id_private {
 	u8			tos;
 	u8			reuseaddr;
 	u8			afonly;
+	enum ib_gid_type	gid_type;
 };
 
 struct cma_multicast {
@@ -1936,6 +1937,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 		route->path_rec->net = &init_net;
 		route->path_rec->ifindex = addr->dev_addr.bound_dev_if;
+		route->path_rec->gid_type = id_priv->gid_type;
 	}
 	if (!ndev) {
 		ret = -ENODEV;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 705b6b8..f770049 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -546,7 +546,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, IB_GID_TYPE_IB,
+		ret = ib_find_cached_gid(device, &rec->sgid, rec->gid_type,
 					 rec->net, rec->ifindex, &port_num,
 					 &gid_index);
 		if (ret)
@@ -676,6 +676,7 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 			  mad->data, &rec);
 		rec.net = NULL;
 		rec.ifindex = 0;
+		rec.gid_type = IB_GID_TYPE_IB;
 		memset(rec.dmac, 0, ETH_ALEN);
 		query->callback(status, &rec, query->context);
 	} else
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 7d2f14c..af020f8 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -144,5 +144,6 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	memset(dst->dmac, 0, sizeof(dst->dmac));
 	dst->net = NULL;
 	dst->ifindex = 0;
+	dst->gid_type = IB_GID_TYPE_IB;
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index eea01e6..61bc231 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -157,6 +157,7 @@ struct ib_sa_path_rec {
 	u8           dmac[ETH_ALEN];
 	int	     ifindex;
 	struct net  *net;
+	enum ib_gid_type gid_type;
 };
 
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
