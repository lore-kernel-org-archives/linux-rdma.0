From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 03/12] net/mlx5: EQ, No need to store eq index as a field
Date: Mon, 19 Nov 2018 10:52:33 -0800
Message-ID: <20181119185242.21961-4-saeedm@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

eq->index is used only for completion EQs and is assigned to be
the completion eq index, it is used only when traversing the completion
eqs list, and it can be calculated dynamically, thus remove the
eq->index field.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++--
 include/linux/mlx5/driver.h                    | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d5cea0a36e6a..f5e6d375a8cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -702,10 +702,11 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	struct mlx5_eq *eq, *n;
 	int err = -ENOENT;
+	int i = 0;
 
 	spin_lock(&table->lock);
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
-		if (eq->index == vector) {
+		if (i++ == vector) {
 			*eqn = eq->eqn;
 			*irqn = eq->irqn;
 			err = 0;
@@ -797,7 +798,6 @@ static int alloc_comp_eqs(struct mlx5_core_dev *dev)
 			goto clean;
 		}
 		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->eqn);
-		eq->index = i;
 		spin_lock(&table->lock);
 		list_add_tail(&eq->list, &table->comp_eqs_list);
 		spin_unlock(&table->lock);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 15cf6727a62d..4b62d71825c1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -399,7 +399,6 @@ struct mlx5_eq {
 	u8			eqn;
 	int			nent;
 	struct list_head	list;
-	int			index;
 	struct mlx5_rsc_debug	*dbg;
 	enum mlx5_eq_type	type;
 	union {
-- 
2.19.1
