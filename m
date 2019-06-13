From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 01/12] net/mlx5: Fix mlx5_core_destroy_cq() error flow
Date: Thu, 13 Jun 2019 09:26:29 +0300
Message-ID: <20190613062640.28958-2-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

The firmware command to destroy a CQ might fail when the object is
referenced by other object and the ref count is managed by the firmware.

To enable a second successful destruction post the first failure need to
change  mlx5_eq_del_cq() to be a void function.

As an error in mlx5_eq_del_cq() is quite fatal from the option to
recover, a debug message inside it should be good enough and it was
changed to be void.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c     |  9 ++-------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 16 +++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h |  2 +-
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 713a17ee3751..703d88332bc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -158,13 +158,8 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {0};
 	int err;
 
-	err = mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
-	if (err)
-		return err;
-
-	err = mlx5_eq_del_cq(&cq->eq->core, cq);
-	if (err)
-		return err;
+	mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
+	mlx5_eq_del_cq(&cq->eq->core, cq);
 
 	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 23883d1fa22f..7c4213147541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -382,7 +382,7 @@ int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 	return err;
 }
 
-int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
+void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 {
 	struct mlx5_cq_table *table = &eq->cq_table;
 	struct mlx5_core_cq *tmp;
@@ -392,16 +392,14 @@ int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 	spin_unlock(&table->lock);
 
 	if (!tmp) {
-		mlx5_core_warn(eq->dev, "cq 0x%x not found in eq 0x%x tree\n", eq->eqn, cq->cqn);
-		return -ENOENT;
+		mlx5_core_dbg(eq->dev, "cq 0x%x not found in eq 0x%x tree\n",
+			      eq->eqn, cq->cqn);
+		return;
 	}
 
-	if (tmp != cq) {
-		mlx5_core_warn(eq->dev, "corruption on cqn 0x%x in eq 0x%x\n", eq->eqn, cq->cqn);
-		return -EINVAL;
-	}
-
-	return 0;
+	if (tmp != cq)
+		mlx5_core_dbg(eq->dev, "corruption on cqn 0x%x in eq 0x%x\n",
+			      eq->eqn, cq->cqn);
 }
 
 int mlx5_eq_table_init(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index c0fb6d72b695..eb105338467d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -70,7 +70,7 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev);
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
 
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
+void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn);
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
 void mlx5_cq_tasklet_cb(unsigned long data);
-- 
2.20.1
