From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Add support for legacy context size
Date: Sun, 27 Mar 2016 14:30:25 +0300
Message-ID: <1459078225-16205-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ibv_cmd_get_context fails in older kernels when passing
a request length that the kernel doesn't know.
To avoid breaking compatibility of new libmlx5 and older kernels,
when ibv_cmd_get_context fails with the full request length,
we try once again with the legacy length.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index d19c376..7bd01bd 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -533,6 +533,28 @@ static int single_threaded_app(void)
 	return 0;
 }
 
+static int mlx5_cmd_get_context(struct mlx5_context *context,
+				struct mlx5_alloc_ucontext *req,
+				size_t req_len,
+				struct mlx5_alloc_ucontext_resp *resp,
+				size_t resp_len)
+{
+	if (!ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+				 req_len, &resp->ibv_resp, resp_len))
+		return 0;
+
+	/* The ibv_cmd_get_context fails in older kernels when passing
+	 * a request length that the kernel doesn't know.
+	 * To avoid breaking compatibility of new libmlx5 and older
+	 * kernels, when ibv_cmd_get_context fails with the full
+	 * request length, we try once again with the legacy length.
+	 */
+	return ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+				   offsetof(struct mlx5_alloc_ucontext,
+					    cqe_version),
+				   &resp->ibv_resp, resp_len);
+}
+
 static int mlx5_init_context(struct verbs_device *vdev,
 			     struct ibv_context *ctx, int cmd_fd)
 {
@@ -598,8 +620,9 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	req.total_num_uuars = tot_uuars;
 	req.num_low_latency_uuars = low_lat_uuars;
 	req.cqe_version = MLX5_CQE_VERSION_V1;
-	if (ibv_cmd_get_context(&context->ibv_ctx, &req.ibv_req, sizeof req,
-				&resp.ibv_resp, sizeof resp))
+
+	if (mlx5_cmd_get_context(context, &req, sizeof(req), &resp,
+				 sizeof(resp)))
 		goto err_free_bf;
 
 	context->max_num_qps		= resp.qp_tab_size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
