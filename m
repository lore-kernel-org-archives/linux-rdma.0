From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libmlx4 1/2] Add RoCE IP based addressing support for UD QPs
Date: Tue, 11 Feb 2014 14:31:14 +0200
Message-ID: <1392121875-9712-2-git-send-email-ogerlitz@mellanox.com>
References: <1392121875-9712-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392121875-9712-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to implement IP based addressing for UD QPs, we need a way to
resolve the addresses internally.
The L2 params are passed to the provider driver using an extension verbs
- drv_ibv_create_ah_ex.
libmlx4 gets the extra mac and vid params from libibverbs and sets
mlx4_ah relevant attributes.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c  |    5 ++-
 src/mlx4.h  |    2 +
 src/verbs.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index c6e4c5c..807540d 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -196,7 +196,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	ibv_ctx->ops = mlx4_ctx_ops;
 
 	verbs_ctx->has_comp_mask = VERBS_CONTEXT_XRCD | VERBS_CONTEXT_SRQ |
-					VERBS_CONTEXT_QP;
+					VERBS_CONTEXT_QP |
+					VERBS_CONTEXT_CREATE_AH;
 	verbs_set_ctx_op(verbs_ctx, close_xrcd, mlx4_close_xrcd);
 	verbs_set_ctx_op(verbs_ctx, open_xrcd, mlx4_open_xrcd);
 	verbs_set_ctx_op(verbs_ctx, create_srq_ex, mlx4_create_srq_ex);
@@ -204,6 +205,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
 
+	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_ah_ex, mlx4_create_ah_ex);
+
 	return 0;
 
 }
diff --git a/src/mlx4.h b/src/mlx4.h
index d71450f..3015357 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -431,6 +431,8 @@ struct mlx4_qp *mlx4_find_qp(struct mlx4_context *ctx, uint32_t qpn);
 int mlx4_store_qp(struct mlx4_context *ctx, uint32_t qpn, struct mlx4_qp *qp);
 void mlx4_clear_qp(struct mlx4_context *ctx, uint32_t qpn);
 struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
+struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd,
+				 struct ibv_ah_attr_ex *attr_ex);
 int mlx4_destroy_ah(struct ibv_ah *ah);
 int mlx4_alloc_av(struct mlx4_pd *pd, struct ibv_ah_attr *attr,
 		   struct mlx4_ah *ah);
diff --git a/src/verbs.c b/src/verbs.c
index 623d576..e322a34 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -783,13 +783,11 @@ static int mlx4_resolve_grh_to_l2(struct ibv_pd *pd, struct mlx4_ah *ah,
 	return 0;
 }
 
-struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
+static struct ibv_ah *mlx4_create_ah_common(struct ibv_pd *pd,
+					    struct ibv_ah_attr *attr,
+					    uint8_t link_layer)
 {
 	struct mlx4_ah *ah;
-	struct ibv_port_attr port_attr;
-
-	if (ibv_query_port(pd->context, attr->port_num, &port_attr))
-		return NULL;
 
 	ah = malloc(sizeof *ah);
 	if (!ah)
@@ -799,7 +797,7 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 
 	ah->av.port_pd   = htonl(to_mpd(pd)->pdn | (attr->port_num << 24));
 
-	if (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET) {
+	if (link_layer != IBV_LINK_LAYER_ETHERNET) {
 		ah->av.g_slid = attr->src_path_bits;
 		ah->av.dlid   = htons(attr->dlid);
 		ah->av.sl_tclass_flowlabel = htonl(attr->sl << 28);
@@ -820,13 +818,83 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		memcpy(ah->av.dgid, attr->grh.dgid.raw, 16);
 	}
 
-	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET)
-		if (mlx4_resolve_grh_to_l2(pd, ah, attr)) {
-			free(ah);
-			return NULL;
+	return &ah->ibv_ah;
+}
+
+struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
+{
+	struct ibv_ah *ah;
+	struct ibv_port_attr port_attr;
+
+	if (ibv_query_port(pd->context, attr->port_num, &port_attr))
+		return NULL;
+
+	ah = mlx4_create_ah_common(pd, attr, port_attr.link_layer);
+	if (NULL != ah &&
+	    (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET ||
+	    !mlx4_resolve_grh_to_l2(pd, to_mah(ah), attr)))
+		return ah;
+
+	if (ah)
+		free(ah);
+	return NULL;
+}
+
+struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd,
+				 struct ibv_ah_attr_ex *attr_ex)
+{
+	struct ibv_port_attr port_attr;
+	struct ibv_ah *ah;
+	struct mlx4_ah *mah;
+
+	if (ibv_query_port(pd->context, attr_ex->port_num, &port_attr))
+		return NULL;
+
+	ah = mlx4_create_ah_common(pd, (struct ibv_ah_attr *)attr_ex,
+				   port_attr.link_layer);
+
+	if (NULL == ah)
+		return NULL;
+
+	mah = to_mah(ah);
+
+	/* If vlan was given, check that we could use it */
+	if (attr_ex->comp_mask & IBV_AH_ATTR_EX_VID &&
+	    attr_ex->vid <= 0xfff &&
+	    (0 == attr_ex->ll_address.len ||
+	     !(attr_ex->comp_mask & IBV_AH_ATTR_EX_LL)))
+		goto err;
+
+	/* ll_address.len == 0 means no ll address given */
+	if (attr_ex->comp_mask & IBV_AH_ATTR_EX_LL &&
+	    0 != attr_ex->ll_address.len) {
+		if (LL_ADDRESS_ETH != attr_ex->ll_address.type ||
+		    port_attr.link_layer != IBV_LINK_LAYER_ETHERNET)
+			/* mlx4 provider currently only support ethernet
+			 * extensions */
+			goto err;
+
+		/* link layer is ethernet */
+		if (6 != attr_ex->ll_address.len ||
+		    NULL == attr_ex->ll_address.address)
+			goto err;
+
+		memcpy(mah->mac, attr_ex->ll_address.address,
+		       attr_ex->ll_address.len);
+
+		if (attr_ex->comp_mask & IBV_AH_ATTR_EX_VID &&
+		    attr_ex->vid <= 0xfff) {
+				mah->av.port_pd |= htonl(1 << 29);
+				mah->vlan = attr_ex->vid |
+					((attr_ex->sl & 7) << 13);
 		}
+	}
 
-	return &ah->ibv_ah;
+	return ah;
+
+err:
+	free(ah);
+	return NULL;
 }
 
 int mlx4_destroy_ah(struct ibv_ah *ah)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
