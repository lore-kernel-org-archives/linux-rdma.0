From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/8] IB/mlx5: Warn on allocated MEMIC buffers during cleanup
Date: Sun, 31 Mar 2019 19:44:45 +0300
Message-ID: <20190331164450.23618-4-leon@kernel.org>
References: <20190331164450.23618-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190331164450.23618-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Adding a warning on allocated MEMIC buffers that weren't
freed prior to driver tear down.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 562826ecfbdd..23436feaa22f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6005,6 +6005,8 @@ static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 		srcu_barrier(&dev->mr_srcu);
 		cleanup_srcu_struct(&dev->mr_srcu);
 	}
+
+	WARN_ON(!bitmap_empty(dev->dm.memic_alloc_pages, MLX5_MAX_MEMIC_PAGES));
 }
 
 static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
-- 
2.20.1
