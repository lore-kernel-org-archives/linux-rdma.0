From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 5/8] net/mlx5: Add missing SET_DRIVER_VERSION command translation
Date: Mon, 16 Jul 2018 18:35:34 -0700
Message-ID: <20180717013537.26411-6-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos@mellanox.com>

When translating command opcodes to a string, SET_DRIVER_VERSION
command was missing.

Fixes: 42ca502e179d0 ('net/mlx5_core: Use a macro in mlx5_command_str()')
Signed-off-by: Noa Osherovich <noaos@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 10517b2a0643..041c18faea46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -458,6 +458,7 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(SET_HCA_CAP);
 	MLX5_COMMAND_STR_CASE(QUERY_ISSI);
 	MLX5_COMMAND_STR_CASE(SET_ISSI);
+	MLX5_COMMAND_STR_CASE(SET_DRIVER_VERSION);
 	MLX5_COMMAND_STR_CASE(CREATE_MKEY);
 	MLX5_COMMAND_STR_CASE(QUERY_MKEY);
 	MLX5_COMMAND_STR_CASE(DESTROY_MKEY);
-- 
2.17.0
