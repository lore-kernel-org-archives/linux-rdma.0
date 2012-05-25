From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 1/2] Report correct resource limits to a new user context
Date: Fri, 25 May 2012 05:57:13 +0300
Message-ID: <1337914634-13906-2-git-send-email-ogerlitz@mellanox.com>
References: <1337914634-13906-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337914634-13906-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

When creating a new user context, query device for various limits,
for use in sanity checks and other resource limitation needs.

Passing needed info back to userspace in this manner is preferable
to breaking the ABI.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c |   13 +++++++++++++
 src/mlx4.h |    3 +++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 8cf249a..4989c46 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -126,6 +126,7 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	struct ibv_get_context		cmd;
 	struct mlx4_alloc_ucontext_resp resp;
 	int				i;
+	struct ibv_device_attr		dev_attrs;
 
 	context = calloc(1, sizeof *context);
 	if (!context)
@@ -178,8 +179,20 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	context->ibv_ctx.ops = mlx4_ctx_ops;
 
+	if (mlx4_query_device(&context->ibv_ctx, &dev_attrs))
+		goto query_free;
+
+	context->max_qp_wr = dev_attrs.max_qp_wr;
+	context->max_sge = dev_attrs.max_sge;
+	context->max_cqe = dev_attrs.max_cqe;
+
 	return &context->ibv_ctx;
 
+query_free:
+	munmap(context->uar, to_mdev(ibdev)->page_size);
+	if (context->bf_page)
+		munmap(context->bf_page, to_mdev(ibdev)->page_size);
+
 err_free:
 	free(context);
 	return NULL;
diff --git a/src/mlx4.h b/src/mlx4.h
index 13c13d8..efaa7e9 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -156,6 +156,9 @@ struct mlx4_context {
 	int				num_qps;
 	int				qp_table_shift;
 	int				qp_table_mask;
+	int				max_qp_wr;
+	int				max_sge;
+	int				max_cqe;
 
 	struct mlx4_db_page	       *db_list[MLX4_NUM_DB_TYPE];
 	pthread_mutex_t			db_list_mutex;
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
