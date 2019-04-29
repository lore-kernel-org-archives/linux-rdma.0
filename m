From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 09/17] IB/mlx5: Support statistic q counter configuration
Date: Mon, 29 Apr 2019 11:34:45 +0300
Message-ID: <20190429083453.16654-10-leon@kernel.org>
References: <20190429083453.16654-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add support for ib callbacks counter_bind_qp() and counter_unbind_qp().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 06da76df4aa1..18a3e855d45b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5450,6 +5450,59 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
+				   struct ib_qp *qp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	u16 cnt_set_id = 0;
+	int err;
+
+	if (counter->id == 0) {
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
+	if (cnt_set_id != 0) {
+		mlx5_core_dealloc_q_counter(dev->mdev, cnt_set_id);
+		counter->id = 0;
+	}
+
+	return err;
+}
+
+static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp, bool force)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct rdma_counter *counter = qp->counter;
+	int err;
+
+	err = mlx5_ib_qp_set_counter(qp, NULL);
+	if (err && !force)
+		return err;
+
+	/*
+	 * Deallocate the counter if this is the last QP bound on it;
+	 * If @force is set then we still deallocate the q counter
+	 * no matter if there's any error in previous. used for cases
+	 * like qp destroy.
+	 */
+	if (atomic_read(&counter->usecnt) == 1)
+		return mlx5_core_dealloc_q_counter(dev->mdev, counter->id);
+
+	return 0;
+}
+
 static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
@@ -6306,6 +6359,8 @@ static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
 static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.alloc_hw_stats = mlx5_ib_alloc_hw_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
+	.counter_bind_qp = mlx5_ib_counter_bind_qp,
+	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
 };
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1
