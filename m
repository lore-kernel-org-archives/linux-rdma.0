From: Hagay Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v1  5/5] libmlx5: Work with CQE version 1
Date: Sun, 15 Nov 2015 13:30:59 +0200
Message-ID: <1447587059-26725-6-git-send-email-hagaya@dev-l-vrt-198-005.mtl.labs.mlnx>
References: <1447587059-26725-1-git-send-email-hagaya@dev-l-vrt-198-005.mtl.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447587059-26725-1-git-send-email-hagaya-15NSNdRadKCMbgUxWz6G6EUdt8N5EOSuJ7HPLuWx/II@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>From now on, if the kernel supports CQE version 1, the library will
choose to work with it.

Change-Id: I22aff64a5f98dde8cb1b6d771424df52ac5d682b
Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c  | 3 +++
 src/verbs.c | 9 +++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index 2ef5759..5e9b61c 100644
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
index 7d13ed2..92f273d 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -909,8 +909,7 @@ static int init_attr_v2(struct ibv_context *context, struct mlx5_qp *qp,
 	cmd.rq_wqe_shift = qp->rq.wqe_shift;
 	cmd.uidx = usr_idx;
 	err = ibv_cmd_create_qp_ex2(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
-				    attr, &cmd.ibv_cmd, sizeof(cmd.ibv_cmd),
-				    offsetof(struct mlx5_create_qp_ex, uidx),
+				    attr, &cmd.ibv_cmd, sizeof(cmd.ibv_cmd), sizeof(cmd),
 				    &resp.ibv_resp, sizeof(resp.ibv_resp),
 				    sizeof(resp));
 	if (!err)
@@ -944,8 +943,7 @@ static int init_attr_v1(struct ibv_context *context, struct mlx5_qp *qp,
 	cmd.uidx = usr_idx;
 
 	err = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
-				   attr, &cmd.ibv_cmd,
-				   offsetof(struct mlx5_create_qp, uidx),
+				   attr, &cmd.ibv_cmd, sizeof(cmd),
 				   &resp.ibv_resp, sizeof(resp));
 	if (!err)
 		*uuar_index = resp.uuar_index;
@@ -1423,8 +1421,7 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	}
 
 	err = ibv_cmd_create_srq_ex(context, &msrq->vsrq, sizeof(msrq->vsrq),
-				    attr, &cmd.ibv_cmd,
-				    offsetof(struct mlx5_create_srq_ex, uidx),
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
