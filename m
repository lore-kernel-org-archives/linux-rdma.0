From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/6] net/mlx5: Use max_num_eqs for calculation of required MSIX vectors
Date: Wed,  8 Aug 2018 16:23:48 -0700
Message-ID: <20180808232353.15514-2-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Denis Drozdov <denisd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Denis Drozdov <denisd@mellanox.com>

New firmware has defined new HCA capability field called "max_num_eqs",
that is the number of available EQs after subtracting reserved FW EQs.

Before this capability the FW reported the EQ number in "log_max_eqs",
the reported value also contained FW reserved EQs, but the driver might
be failing to load on 320 cpus systems due to the fact that FW
reserved EQs were not available to the driver.

Now the driver has to obtain max_num_eqs value from new FW to get real
number of EQs available.

Signed-off-by: Denis Drozdov <denisd@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 +++-
 include/linux/mlx5/mlx5_ifc.h                  | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f9b950e1bd85..ad958b9b1b9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -321,7 +321,9 @@ static int mlx5_alloc_irq_vectors(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	struct mlx5_eq_table *table = &priv->eq_table;
-	int num_eqs = 1 << MLX5_CAP_GEN(dev, log_max_eq);
+	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
+		      MLX5_CAP_GEN(dev, max_num_eqs) :
+		      1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int nvec;
 	int err;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c14b81559505..2b0b6a8550bf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1131,7 +1131,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         general_obj_types[0x40];
 
-	u8         reserved_at_440[0x40];
+	u8         reserved_at_440[0x20];
+
+	u8         reserved_at_460[0x10];
+	u8         max_num_eqs[0x10];
 
 	u8         reserved_at_480[0x3];
 	u8         log_max_l2_table[0x5];
-- 
2.17.0
