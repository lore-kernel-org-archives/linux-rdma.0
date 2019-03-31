From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 5/8] IB/mlx5: Device resource control for privileged DEVX user
Date: Sun, 31 Mar 2019 19:44:47 +0300
Message-ID: <20190331164450.23618-6-leon@kernel.org>
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

For DEVX users who have SYS_RAWIO capability, we set the
internal device resources capability when creating the UCTX.
This will allow the device to restrict the allocation of internal
device resources such as SW ICM memory to privileged DEVX users
only.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d9d51a927b67..d39a3982ac51 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -85,6 +85,10 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user)
 	if (is_user && capable(CAP_NET_RAW) &&
 	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX))
 		cap |= MLX5_UCTX_CAP_RAW_TX;
+	if (is_user && capable(CAP_SYS_RAWIO) &&
+	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
+	     MLX5_UCTX_CAP_INTERNAL_DEV_RES))
+		cap |= MLX5_UCTX_CAP_INTERNAL_DEV_RES;
 
 	MLX5_SET(create_uctx_in, in, opcode, MLX5_CMD_OP_CREATE_UCTX);
 	MLX5_SET(uctx, uctx, cap, cap);
-- 
2.20.1
