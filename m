From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 5/5] Work with CQE version 1
Date: Sun,  6 Sep 2015 12:30:12 +0300
Message-ID: <1441531812-27716-6-git-send-email-hagaya@mellanox.com>
References: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441531812-27716-1-git-send-email-hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From now on, if the kernel supports CQE version 1, the library will
choose to work with it.


Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c  | 3 +++
 src/verbs.c | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index e64ba8d..3bf8cb4 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -582,6 +582,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	}
 
 	memset(&req, 0, sizeof(req));
+	memset(&resp, 0, sizeof(resp));
+
 	req.total_num_uuars = tot_uuars;
 	req.num_low_latency_uuars = low_lat_uuars;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &req.ibv_req, sizeof req,
@@ -600,6 +602,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	context->max_recv_wr	= resp.max_recv_wr;
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
 
+	context->cqe_version = resp.cqe_version;
 	if (context->cqe_version) {
 		if (context->cqe_version == 1)
 			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
diff --git a/src/verbs.c b/src/verbs.c
index c2f5493..ea943b7 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -961,8 +961,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	}
 
 	ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
-				   attr, &cmd.ibv_cmd,
-				   offsetof(struct mlx5_create_qp, uidx),
+				   attr, &cmd.ibv_cmd, sizeof(cmd),
 				   &resp.ibv_resp, sizeof(resp));
 	if (ret) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
@@ -1352,7 +1351,7 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	}
 
 	err = ibv_cmd_create_srq_ex(context, &msrq->vsrq, sizeof(msrq->vsrq),
-				    attr, &cmd.ibv_cmd, offsetof(struct mlx5_create_srq_ex, uidx),
+				    attr, &cmd.ibv_cmd, sizeof(cmd),
 				    &resp.ibv_resp, sizeof(resp));
 	if (err)
 		goto err_free_uidx;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
