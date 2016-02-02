From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 5/7] Work with CQE version 1
Date: Tue,  2 Feb 2016 20:50:59 +0200
Message-ID: <1454439061-929-6-git-send-email-majd@mellanox.com>
References: <1454439061-929-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454439061-929-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>From now on, if the kernel supports CQE version 1, the library will
choose to work with it.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h | 13 +++++++++++--
 src/mlx5.c     |  4 ++++
 src/mlx5.h     |  5 +++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 4b21a17..6427cca 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -55,7 +55,11 @@ struct mlx5_alloc_ucontext {
 	__u32				total_num_uuars;
 	__u32				num_low_latency_uuars;
 	__u32				flags;
-	__u32				reserved;
+	__u32				comp_mask;
+	__u8				cqe_version;
+	__u8				reserved0;
+	__u16				reserved1;
+	__u32				reserved2;
 };
 
 struct mlx5_alloc_ucontext_resp {
@@ -70,7 +74,12 @@ struct mlx5_alloc_ucontext_resp {
 	__u32				max_recv_wr;
 	__u32				max_srq_recv_wr;
 	__u16				num_ports;
-	__u16				reserved;
+	__u16				reserved1;
+	__u32				comp_mask;
+	__u32				response_length;
+	__u8				cqe_version;
+	__u8				reserved2;
+	__u16				reserved3;
 };
 
 struct mlx5_alloc_pd_resp {
diff --git a/src/mlx5.c b/src/mlx5.c
index b942815..0469a78 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -590,8 +590,11 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	}
 
 	memset(&req, 0, sizeof(req));
+	memset(&resp, 0, sizeof(resp));
+
 	req.total_num_uuars = tot_uuars;
 	req.num_low_latency_uuars = low_lat_uuars;
+	req.cqe_version = MLX5_CQE_VERSION_V1;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &req.ibv_req, sizeof req,
 				&resp.ibv_resp, sizeof resp))
 		goto err_free_bf;
@@ -608,6 +611,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	context->max_recv_wr	= resp.max_recv_wr;
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
 
+	context->cqe_version = resp.cqe_version;
 	if (context->cqe_version) {
 		if (context->cqe_version == 1)
 			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
diff --git a/src/mlx5.h b/src/mlx5.h
index cda7c71..6b982c4 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -120,6 +120,11 @@ enum {
 	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1
 };
 
+enum {
+	MLX5_CQE_VERSION_V0	= 0,
+	MLX5_CQE_VERSION_V1	= 1,
+};
+
 #define MLX5_CQ_PREFIX "MLX_CQ"
 #define MLX5_QP_PREFIX "MLX_QP"
 #define MLX5_MR_PREFIX "MLX_MR"
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
