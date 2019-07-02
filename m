From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v5 09/17] IB/mlx5: Support statistic q counter configuration
Date: Tue,  2 Jul 2019 13:02:38 +0300
Message-ID: <20190702100246.17382-10-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add support for ib callbacks counter_bind_qp(), counter_unbind_qp()
and counter_dealloc().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4740cfda5b17..ffd6f16d3c37 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5552,6 +5552,47 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
+				   struct ib_qp *qp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	u16 cnt_set_id = 0;
+	int err;
+
+	if (!counter->id) {
+		err = mlx5_cmd_alloc_q_counter(dev->mdev,
+					       &cnt_set_id,
+					       MLX5_SHARED_RESOURCE_UID);
+		if (err)
+			return err;
+		counter->id = cnt_set_id;
+	}
+
+	err = mlx5_ib_qp_set_counter(qp, counter);
+	if (err)
+		goto fail_set_counter;
+
+	return 0;
+
+fail_set_counter:
+	mlx5_core_dealloc_q_counter(dev->mdev, cnt_set_id);
+	counter->id = 0;
+
+	return err;
+}
+
+static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp)
+{
+	return mlx5_ib_qp_set_counter(qp, NULL);
+}
+
+static int mlx5_ib_counter_dealloc(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+
+	return mlx5_core_dealloc_q_counter(dev->mdev, counter->id);
+}
+
 static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
@@ -6475,6 +6516,9 @@ static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
 static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.alloc_hw_stats = mlx5_ib_alloc_hw_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
+	.counter_bind_qp = mlx5_ib_counter_bind_qp,
+	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
+	.counter_dealloc = mlx5_ib_counter_dealloc,
 };
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1
