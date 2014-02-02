From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 1/2] Add RoCE IP based addressing support for UD QPs
Date: Sun,  2 Feb 2014 17:55:00 +0200
Message-ID: <1391356501-4270-2-git-send-email-ogerlitz@mellanox.com>
References: <1391356501-4270-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391356501-4270-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to implement IP based addressing for UD QPs, we need a way to
resolve the Ethernet L2 addresses. The Eth L2 params are passed to the
provider driver from libibverbs using the extended verb drv_ibv_create_ah_ex.

That is,libmlx4 gets the extra mac and vlan-id params from libibverbs and
sets the mlx4_ah relevant attributes.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c  |    3 ++
 src/mlx4.h  |    2 +
 src/verbs.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index c6e4c5c..ca91df4 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -204,6 +204,9 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
 
+	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_ah_ex, mlx4_create_ah_ex);
+	verbs_ctx->has_comp_mask = VERBS_CONTEXT_CREATE_AH;
+
 	return 0;
 
 }
diff --git a/src/mlx4.h b/src/mlx4.h
index d71450f..b7afa31 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -431,6 +431,8 @@ struct mlx4_qp *mlx4_find_qp(struct mlx4_context *ctx, uint32_t qpn);
 int mlx4_store_qp(struct mlx4_context *ctx, uint32_t qpn, struct mlx4_qp *qp);
 void mlx4_clear_qp(struct mlx4_context *ctx, uint32_t qpn);
 struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
+struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd, struct ibv_ah_attr *attr,
+				 struct ibv_ah_attr_ex *attr_ex);
 int mlx4_destroy_ah(struct ibv_ah *ah);
 int mlx4_alloc_av(struct mlx4_pd *pd, struct ibv_ah_attr *attr,
 		   struct mlx4_ah *ah);
diff --git a/src/verbs.c b/src/verbs.c
index 623d576..38fa3d3 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -783,7 +783,8 @@ static int mlx4_resolve_grh_to_l2(struct ibv_pd *pd, struct mlx4_ah *ah,
 	return 0;
 }
 
-struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
+static struct ibv_ah *mlx4_create_ah_common(struct ibv_pd *pd,
+					    struct ibv_ah_attr *attr)
 {
 	struct mlx4_ah *ah;
 	struct ibv_port_attr port_attr;
@@ -820,13 +821,68 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
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
+	struct ibv_ah *ah = mlx4_create_ah_common(pd, attr);
+	struct ibv_port_attr port_attr;
+
+	if (NULL != ah &&
+	    !ibv_query_port(pd->context, attr->port_num, &port_attr) &&
+	    (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET ||
+	    !mlx4_resolve_grh_to_l2(pd, to_mah(ah), attr)))
+		return ah;
+
+	if (ah)
+		free(ah);
+	return NULL;
+}
+
+#define MLX4_CREATE_AH_EX_SUPPORTED_LL LL_ADDRESS_ETH
+struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd, struct ibv_ah_attr *attr,
+				 struct ibv_ah_attr_ex *attr_ex)
+{
+	struct ibv_ah *ah = mlx4_create_ah_common(pd, attr);
+	struct mlx4_ah *mah;
+
+	if (NULL == ah)
+		return NULL;
+
+	mah = to_mah(ah);
+
+	/* mlx4 provider currently only support ethernet extensions */
+	if (attr_ex->comp_mask & IBV_AH_ATTR_EX_LL &&
+	    ~MLX4_CREATE_AH_EX_SUPPORTED_LL & attr_ex->ll_address.type &&
+	    0 == attr_ex->ll_address.len)
+		goto err;
+
+	if (LL_ADDRESS_ETH == attr_ex->ll_address.type) {
+		/* link layer is ethernet */
+		if (6 != attr_ex->ll_address.len ||
+		    NULL == attr_ex->ll_address.address)
+			goto err;
+
+		memcpy(mah->mac, attr_ex->ll_address.address,
+		       attr_ex->ll_address.len);
+
+		if (attr_ex->comp_mask & IBV_AH_ATTR_EX_VID) {
+			if (attr_ex->vid <= 0xfff) {
+				mah->av.port_pd |= htonl(1 << 29);
+				mah->vlan = attr_ex->vid |
+					    ((attr->sl & 7) << 13);
+			} else {
+				goto err;
+			}
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
