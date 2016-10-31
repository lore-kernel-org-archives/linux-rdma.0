From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Report mlx5 CQE compression capabilities when querying device
Date: Mon, 31 Oct 2016 12:16:44 +0200
Message-ID: <1477909005-12867-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The capabilities include:
- Max number of compressed and aggregated CQEs in a single session,
  while zero means unsupported.
- For Responder, there are two formats of mini CQE: mini CQE with Rx
  hash and mini CQE with checksum. They're mutual exclusive.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 10 ++++++++++
 include/uapi/rdma/mlx5-abi.h      | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2217477..3a8d4b7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -669,6 +669,16 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
 	}
 
+	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
+		resp.cqe_comp_caps.max_num =
+			MLX5_CAP_GEN(dev->mdev, cqe_compression) ?
+			MLX5_CAP_GEN(dev->mdev, cqe_compression_max_num) : 0;
+		resp.cqe_comp_caps.supported_format =
+			MLX5_IB_CQE_RES_FORMAT_HASH |
+			MLX5_IB_CQE_RES_FORMAT_CSUM;
+		resp.response_length += sizeof(resp.cqe_comp_caps);
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index f5d0f4e..24a7435 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -124,11 +124,23 @@ struct mlx5_ib_rss_caps {
 	__u8 reserved[7];
 };
 
+enum mlx5_ib_cqe_comp_res_format {
+	MLX5_IB_CQE_RES_FORMAT_HASH	= 1 << 0,
+	MLX5_IB_CQE_RES_FORMAT_CSUM	= 1 << 1,
+	MLX5_IB_CQE_RES_RESERVED	= 1 << 2,
+};
+
+struct mlx5_ib_cqe_comp_caps {
+	__u32 max_num;
+	__u32 supported_format; /* enum mlx5_ib_cqe_comp_res_format */
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
 	struct	mlx5_ib_tso_caps tso_caps;
 	struct	mlx5_ib_rss_caps rss_caps;
+	struct	mlx5_ib_cqe_comp_caps cqe_comp_caps;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
