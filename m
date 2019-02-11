From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 2/2] net/mlx5: Factor out HCA capabilities functions
Date: Mon, 11 Feb 2019 13:56:08 +0200
Message-ID: <20190211115608.22677-3-leon@kernel.org>
References: <20190211115608.22677-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211115608.22677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Combine all HCA capabilities setters under one function
and compile out the ODP related function in case kernel
was compiled without ODP support.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6d45518edbdc..d7145ab6105d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -459,6 +459,7 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
 	return err;
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 {
 	void *set_hca_cap;
@@ -502,6 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	kfree(set_ctx);
 	return err;
 }
+#endif
 
 static int handle_hca_cap(struct mlx5_core_dev *dev)
 {
@@ -576,6 +578,35 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
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
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	err = handle_hca_cap_odp(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		goto out;
+	}
+#endif
+
+out:
+	return err;
+}
+
 static int set_hca_ctrl(struct mlx5_core_dev *dev)
 {
 	struct mlx5_reg_host_endianness he_in;
@@ -963,21 +994,9 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto reclaim_boot_pages;
 	}
 
-	err = handle_hca_cap(dev);
+	err = set_hca_cap(dev);
 	if (err) {
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
-	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		dev_err(&pdev->dev, "set_hca_cap failed\n");
 		goto reclaim_boot_pages;
 	}
 
-- 
2.19.1
