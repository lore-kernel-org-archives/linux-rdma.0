From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] RDMA/{cma, ucma}: Simplify and rename rdma_set_ib_paths
Date: Mon,  8 Jan 2018 17:04:45 +0200
Message-ID: <20180108150448.29069-4-leon@kernel.org>
References: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since 2006 there has been no user of rdmacm based application to make use
of setting multiple path records using rdma_set_ib_paths API.

Therefore code is simplified to allow setting one path record entry.
Now that it sets only single path, it is renamed to reflect the same.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c  | 10 +++++-----
 drivers/infiniband/core/ucma.c |  4 ++--
 include/rdma/rdma_cm_ib.h      |  8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f1321baf12d8..f1e425da926d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2518,8 +2518,8 @@ cma_iboe_set_path_rec_l2_fields(struct rdma_id_private *id_priv)
 	return ndev;
 }
 
-int rdma_set_ib_paths(struct rdma_cm_id *id,
-		      struct sa_path_rec *path_rec, int num_paths)
+int rdma_set_ib_path(struct rdma_cm_id *id,
+		     struct sa_path_rec *path_rec)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
@@ -2529,20 +2529,20 @@ int rdma_set_ib_paths(struct rdma_cm_id *id,
 			   RDMA_CM_ROUTE_RESOLVED))
 		return -EINVAL;
 
-	id->route.path_rec = kmemdup(path_rec, sizeof *path_rec * num_paths,
+	id->route.path_rec = kmemdup(path_rec, sizeof(*path_rec),
 				     GFP_KERNEL);
 	if (!id->route.path_rec) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	id->route.num_paths = num_paths;
+	id->route.num_paths = 1;
 	return 0;
 err:
 	cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_ADDR_RESOLVED);
 	return ret;
 }
-EXPORT_SYMBOL(rdma_set_ib_paths);
+EXPORT_SYMBOL(rdma_set_ib_path);
 
 static int cma_resolve_iw_route(struct rdma_id_private *id_priv, int timeout_ms)
 {
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index eb85b546e223..6d32af27bac6 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1231,9 +1231,9 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
 		struct sa_path_rec opa;
 
 		sa_convert_path_ib_to_opa(&opa, &sa_path);
-		ret = rdma_set_ib_paths(ctx->cm_id, &opa, 1);
+		ret = rdma_set_ib_path(ctx->cm_id, &opa);
 	} else {
-		ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
+		ret = rdma_set_ib_path(ctx->cm_id, &sa_path);
 	}
 	if (ret)
 		return ret;
diff --git a/include/rdma/rdma_cm_ib.h b/include/rdma/rdma_cm_ib.h
index 6947a6ba2557..6a69d71a21a5 100644
--- a/include/rdma/rdma_cm_ib.h
+++ b/include/rdma/rdma_cm_ib.h
@@ -36,17 +36,17 @@
 #include <rdma/rdma_cm.h>
 
 /**
- * rdma_set_ib_paths - Manually sets the path records used to establish a
+ * rdma_set_ib_path - Manually sets the path record used to establish a
  *   connection.
  * @id: Connection identifier associated with the request.
  * @path_rec: Reference to the path record
  *
  * This call permits a user to specify routing information for rdma_cm_id's
- * bound to Infiniband devices.  It is called on the client side of a
+ * bound to InfiniBand devices. It is called on the client side of a
  * connection and replaces the call to rdma_resolve_route.
  */
-int rdma_set_ib_paths(struct rdma_cm_id *id,
-		      struct sa_path_rec *path_rec, int num_paths);
+int rdma_set_ib_path(struct rdma_cm_id *id,
+		     struct sa_path_rec *path_rec);
 
 /* Global qkey for UDP QPs and multicast groups. */
 #define RDMA_UDP_QKEY 0x01234567
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
