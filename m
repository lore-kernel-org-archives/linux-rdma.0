From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 12/17] IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
Date: Sun,  7 Apr 2019 10:50:08 +0300
Message-ID: <20190407075013.12955-13-leon@kernel.org>
References: <20190407075013.12955-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190407075013.12955-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add support for ib callback counter_alloc_stats() and
counter_update_stats().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8e9dfc1119c2..77d5771da3b4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5398,6 +5398,27 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static struct rdma_hw_stats *
+mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_port *port = &dev->port[counter->port - 1];
+
+	/* Q counters are in the beginning of all counters */
+	return rdma_alloc_hw_stats_struct(port->cnts.names,
+					  port->cnts.num_q_counters,
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_port *port = &dev->port[counter->port - 1];
+
+	return mlx5_ib_query_q_counters(dev->mdev, port,
+					counter->stats, counter->id);
+}
+
 static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp)
 {
@@ -6331,6 +6352,8 @@ static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.get_hw_stats = mlx5_ib_get_hw_stats,
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
+	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
+	.counter_update_stats = mlx5_ib_counter_update_stats,
 };
 
 int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1
