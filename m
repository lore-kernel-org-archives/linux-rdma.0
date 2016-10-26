From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 9/9] IB/mlx5: Simplify completion into a wait_event
Date: Wed, 26 Oct 2016 13:31:14 +0530
Message-ID: <1477468874-16328-10-git-send-email-binoy.jayan@linaro.org>
References: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477468874-16328-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Convert the completion 'mlx5_ib_umr_context:done' to a wait_event as it
just waits for the return value to be filled.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 7 ++++---
 include/rdma/ib_verbs.h              | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dcdcd19..af682c5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -524,7 +524,7 @@ struct mlx5_ib_mw {
 struct mlx5_ib_umr_context {
 	struct ib_cqe		cqe;
 	enum ib_wc_status	status;
-	struct completion	done;
+	wait_queue_head_t	wq;
 };
 
 struct umr_common {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 19c292a..5228459 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -846,14 +846,14 @@ static void mlx5_ib_umr_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, struct mlx5_ib_umr_context, cqe);
 
 	context->status = wc->status;
-	complete(&context->done);
+	wake_up(&context->wq);
 }
 
 static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
 {
 	context->cqe.done = mlx5_ib_umr_done;
 	context->status = -1;
-	init_completion(&context->done);
+	init_waitqueue_head(&context->wq);
 }
 
 static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
@@ -866,13 +866,14 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 
 	mlx5_ib_init_umr_context(&umr_context);
 	umrwr->wr.wr_cqe = &umr_context.cqe;
+	umr_context.status = IB_WC_STATUS_NONE;
 
 	down(&umrc->sem);
 	err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
 	if (err) {
 		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
 	} else {
-		wait_for_completion(&umr_context.done);
+		wait_event(umr_context.wq, umr_context.status != IB_WC_STATUS_NONE);
 		if (umr_context.status != IB_WC_SUCCESS) {
 			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
 				     umr_context.status);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..994d967 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -844,7 +844,8 @@ enum ib_wc_status {
 	IB_WC_INV_EEC_STATE_ERR,
 	IB_WC_FATAL_ERR,
 	IB_WC_RESP_TIMEOUT_ERR,
-	IB_WC_GENERAL_ERR
+	IB_WC_GENERAL_ERR,
+	IB_WC_STATUS_NONE
 };
 
 const char *__attribute_const__ ib_wc_status_msg(enum ib_wc_status status);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
