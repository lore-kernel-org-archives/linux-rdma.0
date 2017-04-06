From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v2 4/6] mlx5: support ->get_vector_affinity
Date: Thu,  6 Apr 2017 13:36:36 +0300
Message-ID: <1491474998-16423-5-git-send-email-sagi@grimberg.me>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Simply refer to the generic affinity mask helper.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/hw/mlx5/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4dc0a8785fe0..b12bc2294895 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3319,6 +3319,15 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return port->q_cnts.num_counters;
 }
 
+const struct cpumask *mlx5_ib_get_vector_affinity(struct ib_device *ibdev,
+		int comp_vector)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+
+	return pci_irq_get_affinity(dev->mdev->pdev,
+			MLX5_EQ_VEC_COMP_BASE + comp_vector);
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -3449,6 +3458,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
+	dev->ib_dev.get_vector_affinity	= mlx5_ib_get_vector_affinity;
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
 		dev->ib_dev.set_vf_link_state	= mlx5_ib_set_vf_link_state;
-- 
2.7.4
