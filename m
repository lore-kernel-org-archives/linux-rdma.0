From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 1/3] Verify correctness of RoCE UD packets
Date: Tue, 30 Aug 2016 20:16:58 +0300
Message-ID: <1472577420-8592-2-git-send-email-yishaih@mellanox.com>
References: <1472577420-8592-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472577420-8592-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When creating an AH, set the dmac field as well.
Also make sure that if link layer is Ethernet, AH attributes have a
GRH.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.h  |  3 ++-
 src/verbs.c | 29 ++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/src/mlx5.h b/src/mlx5.h
index 5833339..88d5181 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -509,7 +509,8 @@ struct mlx5_av {
 	uint8_t		stat_rate_sl;
 	uint8_t		fl_mlid;
 	uint16_t	rlid;
-	uint8_t		reserved0[10];
+	uint8_t		reserved0[4];
+	uint8_t		rmac[6];
 	uint8_t		tclass;
 	uint8_t		hop_limit;
 	uint32_t	grh_gid_fl;
diff --git a/src/verbs.c b/src/verbs.c
index 07e2545..723620c 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1504,13 +1504,30 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 
 struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
+	struct mlx5_context *ctx = to_mctx(pd->context);
+	struct ibv_port_attr port_attr;
 	struct mlx5_ah *ah;
 	uint32_t tmp;
-	struct mlx5_context *ctx = to_mctx(pd->context);
+	int is_eth;
 
 	if (attr->port_num < 1 || attr->port_num > ctx->num_ports)
 		return NULL;
 
+	if (ctx->cached_link_layer[attr->port_num - 1]) {
+		is_eth = ctx->cached_link_layer[attr->port_num - 1] ==
+			IBV_LINK_LAYER_ETHERNET;
+	} else {
+		if (ibv_query_port(pd->context, attr->port_num, &port_attr))
+			return NULL;
+
+		is_eth = (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET);
+	}
+
+	if (unlikely((!attr->is_global) && is_eth)) {
+		errno = EINVAL;
+		return NULL;
+	}
+
 	ah = calloc(1, sizeof *ah);
 	if (!ah)
 		return NULL;
@@ -1528,6 +1545,16 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		memcpy(ah->av.rgid, attr->grh.dgid.raw, 16);
 	}
 
+	if (is_eth) {
+		uint16_t vid;
+
+		if (ibv_resolve_eth_l2_from_gid(pd->context, attr, ah->av.rmac,
+						&vid)) {
+			free(ah);
+			return NULL;
+		}
+	}
+
 	return &ah->ibv_ah;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
