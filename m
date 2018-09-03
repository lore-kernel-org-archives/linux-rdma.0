From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] net/mlx5: Add memic command opcode to command checker
Date: Mon,  3 Sep 2018 20:19:48 +0300
Message-ID: <20180903171948.19461-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Ariel Levkovich <lariel@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Adding the alloc/dealloc memic FW command opcodes to
avoid "unknown command" prints in the command string
converter and internal error status handler.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 853240f5ae82..39750fca371d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -312,6 +312,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT:
 	case MLX5_CMD_OP_FPGA_DESTROY_QP:
 	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_DEALLOC_MEMIC:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -435,6 +436,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_CREATE_GENERAL_OBJECT:
 	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_ALLOC_MEMIC:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -617,6 +619,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(MODIFY_GENERAL_OBJECT);
 	MLX5_COMMAND_STR_CASE(QUERY_GENERAL_OBJECT);
 	MLX5_COMMAND_STR_CASE(QUERY_MODIFY_HEADER_CONTEXT);
+	MLX5_COMMAND_STR_CASE(ALLOC_MEMIC);
+	MLX5_COMMAND_STR_CASE(DEALLOC_MEMIC);
 	default: return "unknown command opcode";
 	}
 }
-- 
2.14.4
