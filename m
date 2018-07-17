From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/8] net/mlx5: Add XRQ commands definitions
Date: Mon, 16 Jul 2018 18:35:33 -0700
Message-ID: <20180717013537.26411-5-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

Update mlx5 command list and error return function to handle XRQ
commands.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a94955302482..10517b2a0643 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -278,6 +278,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DESTROY_PSV:
 	case MLX5_CMD_OP_DESTROY_SRQ:
 	case MLX5_CMD_OP_DESTROY_XRC_SRQ:
+	case MLX5_CMD_OP_DESTROY_XRQ:
 	case MLX5_CMD_OP_DESTROY_DCT:
 	case MLX5_CMD_OP_DEALLOC_Q_COUNTER:
 	case MLX5_CMD_OP_DESTROY_SCHEDULING_ELEMENT:
@@ -347,6 +348,9 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_CREATE_XRC_SRQ:
 	case MLX5_CMD_OP_QUERY_XRC_SRQ:
 	case MLX5_CMD_OP_ARM_XRC_SRQ:
+	case MLX5_CMD_OP_CREATE_XRQ:
+	case MLX5_CMD_OP_QUERY_XRQ:
+	case MLX5_CMD_OP_ARM_XRQ:
 	case MLX5_CMD_OP_CREATE_DCT:
 	case MLX5_CMD_OP_DRAIN_DCT:
 	case MLX5_CMD_OP_QUERY_DCT:
@@ -601,6 +605,10 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(FPGA_QUERY_QP);
 	MLX5_COMMAND_STR_CASE(FPGA_QUERY_QP_COUNTERS);
 	MLX5_COMMAND_STR_CASE(FPGA_DESTROY_QP);
+	MLX5_COMMAND_STR_CASE(CREATE_XRQ);
+	MLX5_COMMAND_STR_CASE(DESTROY_XRQ);
+	MLX5_COMMAND_STR_CASE(QUERY_XRQ);
+	MLX5_COMMAND_STR_CASE(ARM_XRQ);
 	MLX5_COMMAND_STR_CASE(CREATE_GENERAL_OBJECT);
 	MLX5_COMMAND_STR_CASE(DESTROY_GENERAL_OBJECT);
 	default: return "unknown command opcode";
-- 
2.17.0
