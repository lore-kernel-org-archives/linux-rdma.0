From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 04/12] net/mlx5: EQ, Remove redundant completion EQ list lock
Date: Mon, 19 Nov 2018 10:52:34 -0800
Message-ID: <20181119185242.21961-5-saeedm@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Completion EQs list is only modified on driver load/unload, locking is
not required, remove it.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 17 +++--------------
 include/linux/mlx5/driver.h                    |  3 ---
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index fd5926daa0a6..e75272503027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -810,8 +810,6 @@ int mlx5_eq_init(struct mlx5_core_dev *dev)
 {
 	int err;
 
-	spin_lock_init(&dev->priv.eq_table.lock);
-
 	err = mlx5_eq_debugfs_init(dev);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f5e6d375a8cc..f692c2a42130 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -704,7 +704,6 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 	int err = -ENOENT;
 	int i = 0;
 
-	spin_lock(&table->lock);
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		if (i++ == vector) {
 			*eqn = eq->eqn;
@@ -713,7 +712,6 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 			break;
 		}
 	}
-	spin_unlock(&table->lock);
 
 	return err;
 }
@@ -724,14 +722,11 @@ struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	struct mlx5_eq *eq;
 
-	spin_lock(&table->lock);
-	list_for_each_entry(eq, &table->comp_eqs_list, list)
-		if (eq->eqn == eqn) {
-			spin_unlock(&table->lock);
+	list_for_each_entry(eq, &table->comp_eqs_list, list) {
+		if (eq->eqn == eqn)
 			return eq;
-		}
+	}
 
-	spin_unlock(&table->lock);
 
 	return ERR_PTR(-ENOENT);
 }
@@ -747,17 +742,13 @@ static void free_comp_eqs(struct mlx5_core_dev *dev)
 		dev->rmap = NULL;
 	}
 #endif
-	spin_lock(&table->lock);
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		list_del(&eq->list);
-		spin_unlock(&table->lock);
 		if (mlx5_destroy_unmap_eq(dev, eq))
 			mlx5_core_warn(dev, "failed to destroy EQ 0x%x\n",
 				       eq->eqn);
 		kfree(eq);
-		spin_lock(&table->lock);
 	}
-	spin_unlock(&table->lock);
 }
 
 static int alloc_comp_eqs(struct mlx5_core_dev *dev)
@@ -798,9 +789,7 @@ static int alloc_comp_eqs(struct mlx5_core_dev *dev)
 			goto clean;
 		}
 		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->eqn);
-		spin_lock(&table->lock);
 		list_add_tail(&eq->list, &table->comp_eqs_list);
-		spin_unlock(&table->lock);
 	}
 
 	return 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4b62d71825c1..852e397c7624 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -484,9 +484,6 @@ struct mlx5_eq_table {
 	struct mlx5_eq		pfault_eq;
 #endif
 	int			num_comp_vectors;
-	/* protect EQs list
-	 */
-	spinlock_t		lock;
 };
 
 struct mlx5_uars_page {
-- 
2.19.1
