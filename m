From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 12/12] net/mlx5: EQ, Make EQE access methods inline
Date: Fri, 16 Nov 2018 13:59:01 -0800
Message-ID: <20181116215901.5874-13-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

These are one/two liner generic EQ access methods, better have them
declared static inline in eq.h.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 23 -----------------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  | 25 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 895401609c63..6ba8e401a0c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -46,7 +46,6 @@
 #include "diag/fw_tracer.h"
 
 enum {
-	MLX5_EQE_SIZE		= sizeof(struct mlx5_eqe),
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
 };
 
@@ -103,18 +102,6 @@ static int mlx5_cmd_destroy_eq(struct mlx5_core_dev *dev, u8 eqn)
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
-static struct mlx5_eqe *get_eqe(struct mlx5_eq *eq, u32 entry)
-{
-	return mlx5_buf_offset(&eq->buf, entry * MLX5_EQE_SIZE);
-}
-
-static struct mlx5_eqe *next_eqe_sw(struct mlx5_eq *eq)
-{
-	struct mlx5_eqe *eqe = get_eqe(eq, eq->cons_index & (eq->nent - 1));
-
-	return ((eqe->owner & 1) ^ !!(eq->cons_index & eq->nent)) ? NULL : eqe;
-}
-
 static const char *eqe_type_str(u8 type)
 {
 	switch (type) {
@@ -202,16 +189,6 @@ static enum mlx5_dev_event port_subtype_event(u8 subtype)
 	return -1;
 }
 
-static void eq_update_ci(struct mlx5_eq *eq, int arm)
-{
-	__be32 __iomem *addr = eq->doorbell + (arm ? 0 : 2);
-	u32 val = (eq->cons_index & 0xffffff) | (eq->eqn << 24);
-
-	__raw_writel((__force u32)cpu_to_be32(val), addr);
-	/* We still want ordering, just not swabbing, so add a barrier */
-	mb();
-}
-
 static void general_event_handler(struct mlx5_core_dev *dev,
 				  struct mlx5_eqe *eqe)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4cc2d442cef6..6d8c8a57d52b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -5,7 +5,8 @@
 #define __LIB_MLX5_EQ_H__
 #include <linux/mlx5/driver.h>
 
-#define MLX5_MAX_IRQ_NAME       (32)
+#define MLX5_MAX_IRQ_NAME   (32)
+#define MLX5_EQE_SIZE       (sizeof(struct mlx5_eqe))
 
 struct mlx5_eq_tasklet {
 	struct list_head      list;
@@ -39,6 +40,28 @@ struct mlx5_eq_comp {
 	struct list_head        list;
 };
 
+static inline struct mlx5_eqe *get_eqe(struct mlx5_eq *eq, u32 entry)
+{
+	return mlx5_buf_offset(&eq->buf, entry * MLX5_EQE_SIZE);
+}
+
+static inline struct mlx5_eqe *next_eqe_sw(struct mlx5_eq *eq)
+{
+	struct mlx5_eqe *eqe = get_eqe(eq, eq->cons_index & (eq->nent - 1));
+
+	return ((eqe->owner & 1) ^ !!(eq->cons_index & eq->nent)) ? NULL : eqe;
+}
+
+static inline void eq_update_ci(struct mlx5_eq *eq, int arm)
+{
+	__be32 __iomem *addr = eq->doorbell + (arm ? 0 : 2);
+	u32 val = (eq->cons_index & 0xffffff) | (eq->eqn << 24);
+
+	__raw_writel((__force u32)cpu_to_be32(val), addr);
+	/* We still want ordering, just not swabbing, so add a barrier */
+	mb();
+}
+
 int mlx5_eq_table_init(struct mlx5_core_dev *dev);
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_eq_table_create(struct mlx5_core_dev *dev);
-- 
2.19.1
