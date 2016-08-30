From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 3/3] Add support for RoCE v2 UD traffic
Date: Tue, 30 Aug 2016 20:17:00 +0300
Message-ID: <1472577420-8592-4-git-send-email-yishaih@mellanox.com>
References: <1472577420-8592-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472577420-8592-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For RoCE v2 packets, the rlid field of the UD address vector should
contain the UDP source port.
The UDP source port value is a random value within the IANA
recommended range (0xC000 - 0xFFFF).

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/verbs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 99bf23a..e5cdf32 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1502,11 +1502,14 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	return ret;
 }
 
+#define RROCE_UDP_SPORT_MIN 0xC000
+#define RROCE_UDP_SPORT_MAX 0xFFFF
 struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct mlx5_context *ctx = to_mctx(pd->context);
 	struct ibv_port_attr port_attr;
 	struct mlx5_ah *ah;
+	uint32_t gid_type;
 	uint32_t tmp;
 	uint8_t grh;
 	int is_eth;
@@ -1534,6 +1537,14 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		return NULL;
 
 	if (is_eth) {
+		if (ibv_query_gid_type(pd->context, attr->port_num,
+				       attr->grh.sgid_index, &gid_type))
+			goto err;
+
+		if (gid_type == IBV_GID_TYPE_ROCE_V2)
+			ah->av.rlid = htons(rand() % (RROCE_UDP_SPORT_MAX + 1
+						      - RROCE_UDP_SPORT_MIN)
+					    + RROCE_UDP_SPORT_MIN);
 		/* Since RoCE packets must contain GRH, this bit is reserved
 		 * for RoCE and shouldn't be set.
 		 */
@@ -1558,13 +1569,14 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		uint16_t vid;
 
 		if (ibv_resolve_eth_l2_from_gid(pd->context, attr, ah->av.rmac,
-						&vid)) {
-			free(ah);
-			return NULL;
-		}
+						&vid))
+			goto err;
 	}
 
 	return &ah->ibv_ah;
+err:
+	free(ah);
+	return NULL;
 }
 
 int mlx5_destroy_ah(struct ibv_ah *ah)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
