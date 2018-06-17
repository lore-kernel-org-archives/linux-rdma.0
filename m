From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v2 01/20] net/mlx5_core: Prevent warns in dmesg upon firmware commands
Date: Sun, 17 Jun 2018 12:59:47 +0300
Message-ID: <20180617100006.30663-2-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

When DEVX is used application builds by itself the command mail box,
this patch prevents warns upon firmware commands as of invalid user
space usage.

In addition,
A failure in destroy_mkey command was changed to be printed only under
debug mode.

This prevents a redundant warn when a memory window was used
with rereg_mr and finally was some kernel cleanup as of reset
flow/process termination.

In that case this command might temporarily fails as part of the cleanup
but finally it expects to succeed.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 487388aed98f..b99d6df3905b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -677,7 +677,7 @@ struct mlx5_ifc_mbox_out_bits {
 
 struct mlx5_ifc_mbox_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -697,6 +697,7 @@ static int mlx5_cmd_check(struct mlx5_core_dev *dev, void *in, void *out)
 	u8  status;
 	u16 opcode;
 	u16 op_mod;
+	u16 uid;
 
 	mlx5_cmd_mbox_status(out, &status, &syndrome);
 	if (!status)
@@ -704,8 +705,18 @@ static int mlx5_cmd_check(struct mlx5_core_dev *dev, void *in, void *out)
 
 	opcode = MLX5_GET(mbox_in, in, opcode);
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
+	uid    = MLX5_GET(mbox_in, in, uid);
 
-	mlx5_core_err(dev,
+	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
+		mlx5_core_err(dev,
+		      "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
+		      mlx5_command_str(opcode),
+		      opcode, op_mod,
+		      cmd_status_str(status),
+		      status,
+		      syndrome);
+	else
+		mlx5_core_dbg(dev,
 		      "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
 		      mlx5_command_str(opcode),
 		      opcode, op_mod,
-- 
2.14.4
