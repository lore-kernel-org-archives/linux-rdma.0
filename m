From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 7/8] net/mlx5: Introduce new TIR creation core API
Date: Sun, 31 Mar 2019 19:44:49 +0300
Message-ID: <20190331164450.23618-8-leon@kernel.org>
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

Introducing new TIR creation core API which allows caller
to receive back from the call the full command outbox.

This comes as a preparation for the next patch that will
retrieve the TIR ICM address from the command outbox.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/transobj.c | 18 +++++++++++++-----
 include/linux/mlx5/transobj.h                  |  3 +++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index c4d4b76096dc..b1068500f1df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -182,16 +182,24 @@ int mlx5_core_query_sq_state(struct mlx5_core_dev *dev, u32 sqn, u8 *state)
 }
 EXPORT_SYMBOL_GPL(mlx5_core_query_sq_state);
 
+int mlx5_core_create_tir_out(struct mlx5_core_dev *dev,
+			     u32 *in, int inlen,
+			     u32 *out, int outlen)
+{
+	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
+
+	return mlx5_cmd_exec(dev, in, inlen, out, outlen);
+}
+EXPORT_SYMBOL(mlx5_core_create_tir_out);
+
 int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tirn)
 {
-	u32 out[MLX5_ST_SZ_DW(create_tir_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_tir_out)] = {};
 	int err;
 
-	MLX5_SET(create_tir_in, in, opcode, MLX5_CMD_OP_CREATE_TIR);
-
-	memset(out, 0, sizeof(out));
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_core_create_tir_out(dev, in, inlen,
+				       out, sizeof(out));
 	if (!err)
 		*tirn = MLX5_GET(create_tir_out, out, tirn);
 
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
index a261d5528ff7..dc6b1e7cb8c4 100644
--- a/include/linux/mlx5/transobj.h
+++ b/include/linux/mlx5/transobj.h
@@ -50,6 +50,9 @@ int mlx5_core_query_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *out);
 int mlx5_core_query_sq_state(struct mlx5_core_dev *dev, u32 sqn, u8 *state);
 int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tirn);
+int mlx5_core_create_tir_out(struct mlx5_core_dev *dev,
+			     u32 *in, int inlen,
+			     u32 *out, int outlen);
 int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
 			 int inlen);
 void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
-- 
2.20.1
