From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 29/31] IB/{core, cm, cma, ipoib}: Rename ib_init_ah_from_path to ib_init_ah_attr_from_path
Date: Tue, 14 Nov 2017 14:52:16 +0200
Message-ID: <20171114125218.20477-30-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since ib_init_ah_from_path initializes the address handle attribute, it is
renamed to reflect so.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c              |  4 ++--
 drivers/infiniband/core/cma.c             |  7 ++++---
 drivers/infiniband/core/sa_query.c        |  8 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  3 ++-
 include/rdma/ib_sa.h                      | 10 +++++-----
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 19fd1699dc52..3bb82c6ec88d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -494,8 +494,8 @@ static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
 		return ret;
 
 	av->port = port;
-	ret = ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
-				   &av->ah_attr);
+	ret = ib_init_ah_attr_from_path(cm_dev->ib_device, port->port_num, path,
+					&av->ah_attr);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 19769ea4d71f..5ab646a24089 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3396,9 +3396,10 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 			event.status = ret;
 			break;
 		}
-		ib_init_ah_from_path(id_priv->id.device, id_priv->id.port_num,
-				     id_priv->id.route.path_rec,
-				     &event.param.ud.ah_attr);
+		ib_init_ah_attr_from_path(id_priv->id.device,
+					  id_priv->id.port_num,
+					  id_priv->id.route.path_rec,
+					  &event.param.ud.ah_attr);
 		event.param.ud.qp_num = rep->qpn;
 		event.param.ud.qkey = rep->qkey;
 		event.event = RDMA_CM_EVENT_ESTABLISHED;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index ab5e1024fea9..7cd37e77debb 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1227,9 +1227,9 @@ static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
 	return src_path_mask;
 }
 
-int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
-			 struct sa_path_rec *rec,
-			 struct rdma_ah_attr *ah_attr)
+int ib_init_ah_attr_from_path(struct ib_device *device, u8 port_num,
+			      struct sa_path_rec *rec,
+			      struct rdma_ah_attr *ah_attr)
 {
 	int ret;
 	u16 gid_index;
@@ -1341,7 +1341,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 
 	return 0;
 }
-EXPORT_SYMBOL(ib_init_ah_from_path);
+EXPORT_SYMBOL(ib_init_ah_attr_from_path);
 
 static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 33f592cee5d8..71a66a7d265e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -768,7 +768,8 @@ static void path_rec_completion(int status,
 	if (!status) {
 		struct rdma_ah_attr av;
 
-		if (!ib_init_ah_from_path(priv->ca, priv->port, pathrec, &av))
+		if (!ib_init_ah_attr_from_path(priv->ca, priv->port,
+					       pathrec, &av))
 			ah = ipoib_create_ah(dev, priv->pd, &av);
 	}
 
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 1f7f604db5aa..811cfcfcbe3d 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -549,12 +549,12 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 			     struct rdma_ah_attr *ah_attr);
 
 /**
- * ib_init_ah_from_path - Initialize address handle attributes based on an SA
- *   path record.
+ * ib_init_ah_attr_from_path - Initialize address handle attributes based on
+ *   an SA path record.
  */
-int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
-			 struct sa_path_rec *rec,
-			 struct rdma_ah_attr *ah_attr);
+int ib_init_ah_attr_from_path(struct ib_device *device, u8 port_num,
+			      struct sa_path_rec *rec,
+			      struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_sa_pack_path - Conert a path record from struct ib_sa_path_rec
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
