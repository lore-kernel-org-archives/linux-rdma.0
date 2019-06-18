From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v4 08/17] IB/mlx5: Add counter set id as a parameter for mlx5_ib_query_q_counters()
Date: Tue, 18 Jun 2019 20:26:16 +0300
Message-ID: <20190618172625.13432-9-leon@kernel.org>
References: <20190618172625.13432-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618172625.13432-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add counter set id as a parameter so that this API can be used for
querying any q counter.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3b1985215cb9..4493700099d4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5441,7 +5441,8 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,

 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct mlx5_ib_port *port,
-				    struct rdma_hw_stats *stats)
+				    struct rdma_hw_stats *stats,
+				    u16 set_id)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_q_counter_out);
 	void *out;
@@ -5452,9 +5453,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;

-	ret = mlx5_core_query_q_counter(mdev,
-					port->cnts.set_id, 0,
-					out, outlen);
+	ret = mlx5_core_query_q_counter(mdev, set_id, 0, out, outlen);
 	if (ret)
 		goto free;

@@ -5514,7 +5513,8 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 		       port->cnts.num_ext_ppcnt_counters;

 	/* q_counters are per IB device, query the master mdev */
-	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats);
+	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats,
+				       port->cnts.set_id);
 	if (ret)
 		return ret;
