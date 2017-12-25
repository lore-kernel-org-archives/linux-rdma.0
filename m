From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/9] mlx5: Dynamic BF size handling
Date: Mon, 25 Dec 2017 15:56:57 +0200
Message-ID: <1514210221-10466-6-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch reads from the mlx5 kernel driver the max number of BF
registers that can be allocated and initializes the context in
preparation for downstream patches.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  2 ++
 providers/mlx5/mlx5.c     | 17 ++++++++++++++++-
 providers/mlx5/mlx5.h     |  4 ++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index afc9e6f..ebe079b 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -101,6 +101,8 @@ struct mlx5_alloc_ucontext_resp {
 	__u64				hca_core_clock_offset;
 	__u32				log_uar_size;
 	__u32				num_uars_per_page;
+	__u32				num_dyn_bfregs;
+	__u32				reserved3;
 };
 
 struct mlx5_create_ah_resp {
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index d76964f..4c872c8 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -928,6 +928,16 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	context->num_ports	= resp.num_ports;
 	context->max_recv_wr	= resp.max_recv_wr;
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
+	context->num_dyn_bfregs = resp.num_dyn_bfregs;
+
+	if (context->num_dyn_bfregs) {
+		context->count_dyn_bfregs = calloc(context->num_dyn_bfregs,
+						   sizeof(*context->count_dyn_bfregs));
+		if (!context->count_dyn_bfregs) {
+			errno = ENOMEM;
+			goto err_free;
+		}
+	}
 
 	context->cqe_version = resp.cqe_version;
 	if (context->cqe_version) {
@@ -940,7 +950,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	adjust_uar_info(mdev, context, resp);
 
 	gross_uuars = context->tot_uuars / MLX5_NUM_NON_FP_BFREGS_PER_UAR * NUM_BFREGS_PER_UAR;
-	context->bfs = calloc(gross_uuars, sizeof(*context->bfs));
+	context->bfs = calloc(gross_uuars + context->num_dyn_bfregs, sizeof(*context->bfs));
+
 	if (!context->bfs) {
 		errno = ENOMEM;
 		goto err_free;
@@ -948,10 +959,12 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	context->cmds_supp_uhw = resp.cmds_supp_uhw;
 	context->vendor_cap_flags = 0;
+	context->start_dyn_bfregs_index = gross_uuars;
 
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
 	pthread_mutex_init(&context->uidx_table_mutex, NULL);
+	pthread_mutex_init(&context->dyn_bfregs_mutex, NULL);
 	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
 		context->qp_table[i].refcnt = 0;
 
@@ -1051,6 +1064,7 @@ err_free_bf:
 	free(context->bfs);
 
 err_free:
+	free(context->count_dyn_bfregs);
 	for (i = 0; i < MLX5_MAX_UARS; ++i) {
 		if (context->uar[i].reg)
 			munmap(context->uar[i].reg, page_size);
@@ -1066,6 +1080,7 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	int page_size = to_mdev(ibctx->device)->page_size;
 	int i;
 
+	free(context->count_dyn_bfregs);
 	free(context->bfs);
 	for (i = 0; i < MLX5_MAX_UARS; ++i) {
 		if (context->uar[i].reg)
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index ed75409..8d5d193 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -294,6 +294,10 @@ struct mlx5_context {
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 	struct mlx5dv_striding_rq_caps	striding_rq_caps;
 	uint32_t			tunnel_offloads_caps;
+	pthread_mutex_t			dyn_bfregs_mutex; /* protects the dynamic bfregs allocation */
+	uint32_t			num_dyn_bfregs;
+	uint32_t			*count_dyn_bfregs;
+	uint32_t			start_dyn_bfregs_index;
 };
 
 struct mlx5_bitmap {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
