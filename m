From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Create and destroy address handle with kernel assistance
Date: Thu,  1 Dec 2016 16:25:53 +0200
Message-ID: <1480602353-8600-3-git-send-email-yishaih@mellanox.com>
References: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480602353-8600-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Depending on kernel support and when link layer is Ethernet, call kernel
when asked to create an address handle. Kernel will return destination
mac which is required to create the address handle. The alternative,
when kernel support is missing, is to use netlink which is less
efficient.  Destroying an address handle also needs kernel assistance to
clean resources that were allocated during address handle creation.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  7 +++++++
 providers/mlx5/mlx5.h     |  2 ++
 providers/mlx5/verbs.c    | 28 +++++++++++++++++++++++-----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 4b5b577..800915d 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -91,6 +91,13 @@ struct mlx5_alloc_ucontext_resp {
 	__u64				hca_core_clock_offset;
 };
 
+struct mlx5_create_ah_resp {
+	struct ibv_create_ah_resp	ibv_resp;
+	__u32				response_length;
+	__u8				dmac[ETHERNET_LL_SIZE];
+	__u8				reserved[6];
+};
+
 struct mlx5_alloc_pd_resp {
 	struct ibv_alloc_pd_resp	ibv_resp;
 	__u32				pdn;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index cb65429..cf314fc 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -217,6 +217,7 @@ enum mlx5_rsc_type {
 
 enum {
 	MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+	MLX5_USER_CMDS_SUPP_UHW_CREATE_AH    = 1 << 1,
 };
 
 struct mlx5_resource {
@@ -470,6 +471,7 @@ struct mlx5_av {
 struct mlx5_ah {
 	struct ibv_ah			ibv_ah;
 	struct mlx5_av			av;
+	bool				kern_ah;
 };
 
 struct mlx5_rwq {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index e288ebf..7107a5b 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1636,11 +1636,21 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	}
 
 	if (is_eth) {
-		uint16_t vid;
+		if (ctx->cmds_supp_uhw & MLX5_USER_CMDS_SUPP_UHW_CREATE_AH) {
+			struct mlx5_create_ah_resp resp = {};
 
-		if (ibv_resolve_eth_l2_from_gid(pd->context, attr, ah->av.rmac,
-						&vid))
-			goto err;
+			if (ibv_cmd_create_ah(pd, &ah->ibv_ah, attr, &resp.ibv_resp, sizeof(resp)))
+				goto err;
+
+			ah->kern_ah = true;
+			memcpy(ah->av.rmac, resp.dmac, ETHERNET_LL_SIZE);
+		} else {
+			uint16_t vid;
+
+			if (ibv_resolve_eth_l2_from_gid(pd->context, attr,
+							ah->av.rmac, &vid))
+				goto err;
+		}
 	}
 
 	return &ah->ibv_ah;
@@ -1651,8 +1661,16 @@ err:
 
 int mlx5_destroy_ah(struct ibv_ah *ah)
 {
-	free(to_mah(ah));
+	struct mlx5_ah *mah = to_mah(ah);
+	int err;
+
+	if (mah->kern_ah) {
+		err = ibv_cmd_destroy_ah(ah);
+		if (err)
+			return err;
+	}
 
+	free(mah);
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
