From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/3] Add a helper function to verify 64 bit comp mask
Date: Wed, 22 Nov 2017 14:11:06 +0200
Message-ID: <1511352668-1441-2-git-send-email-yishaih@mellanox.com>
References: <1511352668-1441-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511352668-1441-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The common check for a mask is as follows:
if (comp_mask & ~COMP_MASK_SUPPORTED_VALUES)
	return EINVAL

This can cause an issue when using 64 bit mask if the supported variable
is signed 32 bit: It will be bitwise inverted and then zeroed to 64
bits. This way wrong bits in the mask that exceed 32 bits will not raise
an error but will be ignored.

Add a helper function in driver.h to be used by providers code and fix
wrong mask checks where the above was found to be applicable.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/driver.h    | 5 +++++
 providers/mlx4/verbs.c | 4 ++--
 providers/mlx5/verbs.c | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 4b1e5dd..24b087a 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -400,6 +400,11 @@ static inline int verbs_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
 	return ENOSYS;
 }
 
+static inline bool check_comp_mask(uint64_t input, uint64_t supported)
+{
+	return (input & ~supported) == 0;
+}
+
 int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
 		       unsigned int index, enum ibv_gid_type *type);
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 8a2773f..ec02bd4 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -922,8 +922,8 @@ static struct ibv_qp *create_qp_ex(struct ibv_context *context,
 		goto err_free;
 
 	if (mlx4qp_attr) {
-		if (mlx4qp_attr->comp_mask &
-		    ~(MLX4DV_QP_INIT_ATTR_MASK_RESERVED - 1)) {
+		if (!check_comp_mask(mlx4qp_attr->comp_mask,
+		    MLX4DV_QP_INIT_ATTR_MASK_RESERVED - 1)) {
 			errno = EINVAL;
 			goto err_free;
 		}
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 19fc947..9187119 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -434,7 +434,8 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	cmd.cqe_size = cqe_sz;
 
 	if (mlx5cq_attr) {
-		if (mlx5cq_attr->comp_mask & ~(MLX5DV_CQ_INIT_ATTR_MASK_RESERVED - 1)) {
+		if (!check_comp_mask(mlx5cq_attr->comp_mask,
+				     MLX5DV_CQ_INIT_ATTR_MASK_RESERVED - 1)) {
 			mlx5_dbg(fp, MLX5_DBG_CQ,
 				   "Unsupported vendor comp_mask for create_cq\n");
 			errno = EINVAL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
