From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net: mlx5: remove pointless memcpy
Date: Fri,  2 Feb 2018 16:46:30 +0100
Message-ID: <20180202154636.1624079-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

gcc-8 notices that the memcpy in mlx5_core_query_xsrq() makes no
sense because the source and destination variables are identical:

drivers/net/ethernet/mellanox/mlx5/core/transobj.c: In function 'mlx5_core_query_xsrq':
drivers/net/ethernet/mellanox/mlx5/core/transobj.c:347:3: error: 'memcpy' source argument is the same as destination [-Werror=restrict]

Either one of the pointers should be something else, or the code is
completely bogus. Removing the memcpy() won't change the behavior
but gets rid of the warning.

Fixes: 01949d0109ee ("net/mlx5_core: Enable XRCs and SRQs when using ISSI > 0")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please review carefully, I have no idea what the author actually
intended here.
---
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index 9e38343a951f..75450f7d53bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -332,20 +332,12 @@ int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 xsrqn)
 int mlx5_core_query_xsrq(struct mlx5_core_dev *dev, u32 xsrqn, u32 *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrc_srq_in)] = {0};
-	void *srqc;
-	void *xrc_srqc;
 	int err;
 
 	MLX5_SET(query_xrc_srq_in, in, opcode,   MLX5_CMD_OP_QUERY_XRC_SRQ);
 	MLX5_SET(query_xrc_srq_in, in, xrc_srqn, xsrqn);
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out,
 			    MLX5_ST_SZ_BYTES(query_xrc_srq_out));
-	if (!err) {
-		xrc_srqc = MLX5_ADDR_OF(query_xrc_srq_out, out,
-					xrc_srq_context_entry);
-		srqc = MLX5_ADDR_OF(query_srq_out, out, srq_context_entry);
-		memcpy(srqc, xrc_srqc, MLX5_ST_SZ_BYTES(srqc));
-	}
 
 	return err;
 }
-- 
2.9.0
