From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Thu, 27 Oct 2016 12:29:14 +0530
Message-ID: <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Convert the completion 'mlx5_ib_umr_context:done' to a wait_event as it
just waits for the return value to be filled.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 9 +++++----
 include/rdma/ib_verbs.h              | 1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index de31b5f..cf496b5 100644
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
index dfaf6f6..49ff2af 100644
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
-	context->status = -1;
-	init_completion(&context->done);
+	context->status = IB_WC_STATUS_NONE;
+	init_waitqueue_head(&context->wq);
 }
 
 static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
@@ -873,7 +873,8 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 	if (err) {
 		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
 	} else {
-		wait_for_completion(&umr_context.done);
+		wait_event(umr_context.wq,
+			   umr_context.status != IB_WC_STATUS_NONE);
 		if (umr_context.status != IB_WC_SUCCESS) {
 			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
 				     umr_context.status);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..8b15b6f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -823,6 +823,7 @@ struct ib_ah_attr {
 };
 
 enum ib_wc_status {
+	IB_WC_STATUS_NONE = -1,
 	IB_WC_SUCCESS,
 	IB_WC_LOC_LEN_ERR,
 	IB_WC_LOC_QP_OP_ERR,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
