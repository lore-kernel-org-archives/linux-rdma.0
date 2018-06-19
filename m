From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Limit scope of dump_fill_mkey function
Date: Tue, 19 Jun 2018 08:47:22 +0300
Message-ID: <20180619054724.32677-2-leon@kernel.org>
References: <20180619054724.32677-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180619054724.32677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

mlx5_core_dump_fill_mkey() is going to be used in next
patch in IB and doesn't need to be visible to whole
mlx5_core. Move that command to mlx5_ib.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c             | 15 +++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h             |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 17 -----------------
 include/linux/mlx5/driver.h                  |  2 --
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 188512bf46e6..ccc0b5d06a7d 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -32,6 +32,21 @@
 
 #include "cmd.h"
 
+int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)]   = {0};
+	int err;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*mkey = MLX5_GET(query_special_contexts_out, out,
+				 dump_fill_mkey);
+	return err;
+}
+
 int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
 {
 	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index e7206c8a8011..98ea4648c655 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
 
+int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey);
 int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out, int out_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index f4f02f775c93..0670165afd5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -146,23 +146,6 @@ int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
 }
 EXPORT_SYMBOL(mlx5_core_query_mkey);
 
-int mlx5_core_dump_fill_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *_mkey,
-			     u32 *mkey)
-{
-	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)]   = {0};
-	int err;
-
-	MLX5_SET(query_special_contexts_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (!err)
-		*mkey = MLX5_GET(query_special_contexts_out, out,
-				 dump_fill_mkey);
-	return err;
-}
-EXPORT_SYMBOL(mlx5_core_dump_fill_mkey);
-
 static inline u32 mlx5_get_psv(u32 *out, int psv_index)
 {
 	switch (psv_index) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 80cbb7fdce4a..1cb1c0317b77 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1067,8 +1067,6 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
 			   struct mlx5_core_mkey *mkey);
 int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
 			 u32 *out, int outlen);
-int mlx5_core_dump_fill_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *_mkey,
-			     u32 *mkey);
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn);
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn);
 int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
-- 
2.14.4
