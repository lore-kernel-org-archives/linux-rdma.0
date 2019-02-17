From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1] net/mlx5: Factor out HCA capabilities functions
Date: Sun, 17 Feb 2019 13:11:02 +0200
Message-ID: <20190217111102.13608-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Combine all HCA capabilities setters under one function
and compile out the ODP related function in case kernel
was compiled without ODP support.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
...
Changelog v0->v1:
 * Embedded config option check into ODP capability function flow
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 46 +++++++++++++------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6d45518edbdc..025dfaf3466b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -466,7 +466,8 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	int set_sz;
 	int err;

-	if (!MLX5_CAP_GEN(dev, pg))
+	if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) ||
+	    !MLX5_CAP_GEN(dev, pg))
 		return 0;

 	err = mlx5_core_get_caps(dev, MLX5_CAP_ODP);
@@ -576,6 +577,33 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 	return err;
 }

+static int set_hca_cap(struct mlx5_core_dev *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+	int err;
+
+	err = handle_hca_cap(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap failed\n");
+		goto out;
+	}
+
+	err = handle_hca_cap_atomic(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
+		goto out;
+	}
+
+	err = handle_hca_cap_odp(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		goto out;
+	}
+
+out:
+	return err;
+}
+
 static int set_hca_ctrl(struct mlx5_core_dev *dev)
 {
 	struct mlx5_reg_host_endianness he_in;
@@ -963,21 +991,9 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto reclaim_boot_pages;
 	}

-	err = handle_hca_cap(dev);
-	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap failed\n");
-		goto reclaim_boot_pages;
-	}
-
-	err = handle_hca_cap_atomic(dev);
-	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
-		goto reclaim_boot_pages;
-	}
-
-	err = handle_hca_cap_odp(dev);
+	err = set_hca_cap(dev);
 	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		dev_err(&pdev->dev, "set_hca_cap failed\n");
 		goto reclaim_boot_pages;
 	}
