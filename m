From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/5] mlx5: Add support to create a CQ with compressed CQEs
Date: Mon,  6 Mar 2017 16:06:44 +0200
Message-ID: <1488809204-30428-6-git-send-email-yishaih@mellanox.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488809204-30428-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch uses the vendor data mechanism that was introduced as
part of ibv_create_cq_ex to create a CQ with some vendor specific
attributes. Specifically, it enables creating a CQ in a mode that
few CQEs may be compressed into a single CQE.

Usage:
- The driver exposes its create_cq vendor data structure to be filled
  by the application. (i.e. mlx5dv_create_cq_vendor_data)

- Upon CQ creation if IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA bit was set,
  cast to the above structure and make sure that its input is supported.

- If input is valid, pass it via the vendor channel to mlx5 kernel driver.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  3 +++
 providers/mlx5/mlx5dv.h   | 10 ++++++++++
 providers/mlx5/verbs.c    | 35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index b07067b..cd1c876 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -118,6 +118,9 @@ struct mlx5_create_cq {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				cqe_size;
+	__u8				cqe_comp_en;
+	__u8				cqe_comp_res_format;
+	__u16				reserved;
 };
 
 struct mlx5_create_cq_resp {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 9f30e6e..fa53cff 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -292,12 +292,22 @@ struct mlx5_cqe64 {
 	uint8_t		op_own;
 };
 
+enum mlx5dv_create_cq_vendor_data_mask {
+	MLX5DV_CREATE_CQ_MASK_COMPRESSED_CQE	= 1 << 0,
+	MLX5DV_CREATE_CQ_MASK_RESERVED		= 1 << 1,
+};
+
 enum mlx5dv_cqe_comp_res_format {
 	MLX5DV_CQE_RES_FORMAT_HASH		= 1 << 0,
 	MLX5DV_CQE_RES_FORMAT_CSUM		= 1 << 1,
 	MLX5DV_CQE_RES_FORMAT_RESERVED		= 1 << 2,
 };
 
+struct mlx5dv_create_cq_vendor_data {
+	uint64_t comp_mask; /* Use enum mlx5dv_create_cq_vendor_data_mask */
+	uint8_t cqe_comp_res_format; /* Use enum mlx5dv_cqe_comp_res_format */
+};
+
 static MLX5DV_ALWAYS_INLINE
 uint8_t mlx5dv_get_cqe_owner(struct mlx5_cqe64 *cqe)
 {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 0e02772..289b318 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -332,7 +332,8 @@ enum {
 };
 
 enum {
-	CREATE_CQ_SUPPORTED_COMP_MASK = IBV_CQ_INIT_ATTR_MASK_FLAGS
+	CREATE_CQ_SUPPORTED_COMP_MASK = IBV_CQ_INIT_ATTR_MASK_FLAGS |
+					IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA
 };
 
 enum {
@@ -350,6 +351,8 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	int				ret;
 	int				ncqe;
 	FILE *fp = to_mctx(context)->dbg_fp;
+	struct mlx5dv_create_cq_vendor_data *vendor_data;
+	struct mlx5_context *mctx = to_mctx(context);
 
 	if (!cq_attr->cqe) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "CQE invalid\n");
@@ -428,6 +431,36 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	cmd.db_addr  = (uintptr_t) cq->dbrec;
 	cmd.cqe_size = cqe_sz;
 
+	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA) {
+		if (!(cq_attr->vendor_data)) {
+			mlx5_dbg(fp, MLX5_DBG_CQ, "Vendor data is requried\n");
+			errno = EINVAL;
+			goto err_db;
+		}
+
+		vendor_data = (struct mlx5dv_create_cq_vendor_data *)(cq_attr->vendor_data);
+
+		if (vendor_data->comp_mask & ~(MLX5DV_CREATE_CQ_MASK_RESERVED - 1)) {
+			mlx5_dbg(fp, MLX5_DBG_CQ,
+				 "Unsupported vendor comp_mask for create_cq\n");
+			errno = EINVAL;
+			goto err_db;
+		}
+
+		if (vendor_data->comp_mask & MLX5DV_CREATE_CQ_MASK_COMPRESSED_CQE) {
+			if (mctx->cqe_comp_caps.max_num &&
+			    (vendor_data->cqe_comp_res_format &
+			     mctx->cqe_comp_caps.supported_format)) {
+				cmd.cqe_comp_en = 1;
+				cmd.cqe_comp_res_format = vendor_data->cqe_comp_res_format;
+			} else {
+				mlx5_dbg(fp, MLX5_DBG_CQ, "CQE Compression is not supported\n");
+				errno = EINVAL;
+				goto err_db;
+			}
+		}
+	}
+
 	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
 				cq_attr->comp_vector,
 				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
