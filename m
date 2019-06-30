From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v2 03/13] net/mlx5: Expose the API to register for ANY event
Date: Sun, 30 Jun 2019 19:23:24 +0300
Message-ID: <20190630162334.22135-4-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose the API to register for ANY event, mlx5_ib will be able to use
this functionality for its needs.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h | 3 ---
 include/linux/mlx5/driver.h                      | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 33f78d4d3724..c634a78d5cdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -949,6 +949,7 @@ int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_register(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_register);
 
 int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 {
@@ -959,3 +960,4 @@ int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_unregister);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index d826e63d5a17..3dfab91ae5f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -97,7 +97,4 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
 #endif
 
-int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d8ab633406c2..3f8b9d8e2070 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1047,6 +1047,8 @@ int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
 int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
+int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
+int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
 
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
 
-- 
2.20.1
