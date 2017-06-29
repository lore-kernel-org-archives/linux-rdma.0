From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx4: Cleanup resources upon device fatal
Date: Thu, 29 Jun 2017 17:41:57 +0300
Message-ID: <1498747317-2170-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Cleanup driver resources upon device fatal on closing commands. (e.g.
destroy qp/srq/cq etc.)

Currently when a device fatal error occurred the uverbs layer returns
from kernel EIO to indicate that the kernel driver low level
resources were already cleaned up.

However, closing commands as of destroy_qp/cq/srq might leak the user
space driver memory that had to be freed upon success.

The verbs layer (cmd.c) can't generally return a success in that case as
it had to deal with an application flow that still handles the reported
events in some other thread but the 'events_reported' data doesn't
exist as part of the command response.

In case the application takes control over the events before cleaning
its resources (e.g. by using one thread, ack events before destroying its resources)
the driver memory can be safely cleaned up.

Let applications that use mlx4 to set some environment variable to
indicate that so that won't be a memory leak upon driver device fatal.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/158

 providers/mlx4/mlx4.c  | 12 ++++++++++++
 providers/mlx4/mlx4.h  |  6 ++++++
 providers/mlx4/srq.c   |  2 +-
 providers/mlx4/verbs.c | 19 ++++++++++---------
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index b798b37..9ba80d4 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -43,6 +43,8 @@
 #include "mlx4.h"
 #include "mlx4-abi.h"
 
+int mlx4_cleanup_upon_device_fatal = 0;
+
 #ifndef PCI_VENDOR_ID_MELLANOX
 #define PCI_VENDOR_ID_MELLANOX			0x15b3
 #endif
@@ -118,6 +120,15 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
+static void mlx4_read_env(void)
+{
+	char *env_value;
+
+	env_value = getenv("MLX4_DEVICE_FATAL_CLEANUP");
+	if (env_value)
+		mlx4_cleanup_upon_device_fatal = (strcmp(env_value, "0")) ? 1 : 0;
+}
+
 static int mlx4_map_internal_clock(struct mlx4_device *mdev,
 				   struct ibv_context *ibv_ctx)
 {
@@ -159,6 +170,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	context = to_mctx(ibv_ctx);
 	ibv_ctx->cmd_fd = cmd_fd;
 
+	mlx4_read_env();
 	if (dev->abi_version <= MLX4_UVERBS_NO_DEV_CAPS_ABI_VERSION) {
 		if (ibv_cmd_get_context(ibv_ctx, &cmd, sizeof cmd,
 					&resp_v3.ibv_resp, sizeof resp_v3))
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index b4f6e86..4637c10 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -350,6 +350,12 @@ static inline void mlx4_update_cons_index(struct mlx4_cq *cq)
 	*cq->set_ci_db = htobe32(cq->cons_index & 0xffffff);
 }
 
+extern int mlx4_cleanup_upon_device_fatal;
+static inline int cleanup_on_fatal(int ret)
+{
+	return (ret == EIO && mlx4_cleanup_upon_device_fatal);
+}
+
 int mlx4_alloc_buf(struct mlx4_buf *buf, size_t size, int page_size);
 void mlx4_free_buf(struct mlx4_buf *buf);
 
diff --git a/providers/mlx4/srq.c b/providers/mlx4/srq.c
index f30cc2e..adcf0fa 100644
--- a/providers/mlx4/srq.c
+++ b/providers/mlx4/srq.c
@@ -308,7 +308,7 @@ int mlx4_destroy_xrc_srq(struct ibv_srq *srq)
 	pthread_spin_unlock(&mcq->lock);
 
 	ret = ibv_cmd_destroy_srq(srq);
-	if (ret) {
+	if (ret && !cleanup_on_fatal(ret)) {
 		pthread_spin_lock(&mcq->lock);
 		mlx4_store_xsrq(&mctx->xsrq_table, msrq->verbs_srq.srq_num, msrq);
 		pthread_spin_unlock(&mcq->lock);
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 80efd9a..5770430 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -218,7 +218,7 @@ int mlx4_free_pd(struct ibv_pd *pd)
 	int ret;
 
 	ret = ibv_cmd_dealloc_pd(pd);
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	free(to_mpd(pd));
@@ -255,10 +255,11 @@ int mlx4_close_xrcd(struct ibv_xrcd *ib_xrcd)
 	int ret;
 
 	ret = ibv_cmd_close_xrcd(xrcd);
-	if (!ret)
-		free(xrcd);
+	if (ret && !cleanup_on_fatal(ret))
+		return ret;
 
-	return ret;
+	free(xrcd);
+	return 0;
 }
 
 struct ibv_mr *mlx4_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
@@ -307,7 +308,7 @@ int mlx4_dereg_mr(struct ibv_mr *mr)
 	int ret;
 
 	ret = ibv_cmd_dereg_mr(mr);
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	free(mr);
@@ -342,7 +343,7 @@ int mlx4_dealloc_mw(struct ibv_mw *mw)
 	struct ibv_dealloc_mw cmd;
 
 	ret = ibv_cmd_dealloc_mw(mw, &cmd, sizeof(cmd));
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	free(mw);
@@ -629,7 +630,7 @@ int mlx4_destroy_cq(struct ibv_cq *cq)
 	int ret;
 
 	ret = ibv_cmd_destroy_cq(cq);
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	mlx4_free_db(to_mctx(cq->context), MLX4_DB_TYPE_CQ, to_mcq(cq)->set_ci_db);
@@ -733,7 +734,7 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
 		return mlx4_destroy_xrc_srq(srq);
 
 	ret = ibv_cmd_destroy_srq(srq);
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	mlx4_free_db(to_mctx(srq->context), MLX4_DB_TYPE_RQ, to_msrq(srq)->db);
@@ -1090,7 +1091,7 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 
 	pthread_mutex_lock(&to_mctx(ibqp->context)->qp_table_mutex);
 	ret = ibv_cmd_destroy_qp(ibqp);
-	if (ret) {
+	if (ret && !cleanup_on_fatal(ret)) {
 		pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
 		return ret;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
