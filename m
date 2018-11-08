From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 06/10] net/mlx5: Return success for PAGE_FAULT_RESUME in internal error state
Date: Thu,  8 Nov 2018 21:10:13 +0200
Message-ID: <20181108191017.21891-7-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

When the device is in internal error state, command interface isn't
accessible and the driver decides which commands to fail and which to
pass.
Move the PAGE_FAULT_RESUME command to the pass list in order to avoid
redundant failure messages.

Fixes: 89d44f0a6c73 ("net/mlx5_core: Add pci error handlers to mlx5_core driver")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a5a0823e5ada..7b18aff955f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -313,6 +313,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_FPGA_DESTROY_QP:
 	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_DEALLOC_MEMIC:
+	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -326,7 +327,6 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_CREATE_MKEY:
 	case MLX5_CMD_OP_QUERY_MKEY:
 	case MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS:
-	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 	case MLX5_CMD_OP_CREATE_EQ:
 	case MLX5_CMD_OP_QUERY_EQ:
 	case MLX5_CMD_OP_GEN_EQE:
-- 
2.19.1
