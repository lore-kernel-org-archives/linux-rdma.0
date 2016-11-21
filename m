From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v5 9/9] IB/mlx5: Replace semaphore umr_common:sem with wait_event
Date: Mon, 21 Nov 2016 11:38:16 +0530
Message-ID: <1479708496-9828-10-git-send-email-binoy.jayan@linaro.org>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Jenny Derzhavetz <jennyf@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Matan Barak <matanb@mellanox.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Remove semaphore umr_common:sem used to limit concurrent access to umr qp
and introduce an atomic value 'users' to keep track of the same. Use a
wait_event to block when the limit is reached.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 6 +-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 7 ++++++-
 drivers/infiniband/hw/mlx5/mr.c      | 6 ++++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 63036c7..9de716c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2437,10 +2437,6 @@ static void destroy_umrc_res(struct mlx5_ib_dev *dev)
 	ib_dealloc_pd(dev->umrc.pd);
 }
 
-enum {
-	MAX_UMR_WR = 128,
-};
-
 static int create_umr_res(struct mlx5_ib_dev *dev)
 {
 	struct ib_qp_init_attr *init_attr = NULL;
@@ -2520,7 +2516,7 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	dev->umrc.cq = cq;
 	dev->umrc.pd = pd;
 
-	sema_init(&dev->umrc.sem, MAX_UMR_WR);
+	init_waitqueue_head(&dev->umrc.wq);
 	ret = mlx5_mr_cache_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dcdcd19..de31b5f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -533,7 +533,12 @@ struct umr_common {
 	struct ib_qp	*qp;
 	/* control access to UMR QP
 	 */
-	struct semaphore	sem;
+	wait_queue_head_t	wq;
+	atomic_t		users;
+};
+
+enum {
+	MAX_UMR_WR = 128,
 };
 
 enum {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1593856..dfaf6f6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -867,7 +867,8 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 	mlx5_ib_init_umr_context(&umr_context);
 	umrwr->wr.wr_cqe = &umr_context.cqe;
 
-	down(&umrc->sem);
+	/* limit number of concurrent ib_post_send() on qp */
+	wait_event(umrc->wq, atomic_add_unless(&umrc->users, 1, MAX_UMR_WR));
 	err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
 	if (err) {
 		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
@@ -879,7 +880,8 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 			err = -EFAULT;
 		}
 	}
-	up(&umrc->sem);
+	atomic_dec(&umrc->users);
+	wake_up(&umrc->wq);
 	return err;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
