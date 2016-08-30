From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 2/3] Avoid setting Infiniband-only fields when link layer is Ethernet
Date: Tue, 30 Aug 2016 20:16:59 +0300
Message-ID: <1472577420-8592-3-git-send-email-yishaih@mellanox.com>
References: <1472577420-8592-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472577420-8592-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some fields in UD address vector are reserved for link layer Ethernet
and shouldn't be set for RoCE packets:
- GRH bit
- Force Loopback
- Source LID (lower LMC bits)

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/verbs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 723620c..99bf23a 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1508,6 +1508,7 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	struct ibv_port_attr port_attr;
 	struct mlx5_ah *ah;
 	uint32_t tmp;
+	uint8_t grh;
 	int is_eth;
 
 	if (attr->port_num < 1 || attr->port_num > ctx->num_ports)
@@ -1532,13 +1533,21 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	if (!ah)
 		return NULL;
 
+	if (is_eth) {
+		/* Since RoCE packets must contain GRH, this bit is reserved
+		 * for RoCE and shouldn't be set.
+		 */
+		grh = 0;
+	} else {
+		ah->av.fl_mlid = attr->src_path_bits & 0x7f;
+		ah->av.rlid = htons(attr->dlid);
+		grh = 1;
+	}
 	ah->av.stat_rate_sl = (attr->static_rate << 4) | attr->sl;
-	ah->av.fl_mlid = attr->src_path_bits & 0x7f;
-	ah->av.rlid = htons(attr->dlid);
 	if (attr->is_global) {
 		ah->av.tclass = attr->grh.traffic_class;
 		ah->av.hop_limit = attr->grh.hop_limit;
-		tmp = htonl((1 << 30) |
+		tmp = htonl((grh << 30) |
 			    ((attr->grh.sgid_index & 0xff) << 20) |
 			    (attr->grh.flow_label & 0xfffff));
 		ah->av.grh_gid_fl = tmp;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
