From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] net/mlx5: Continue driver initialization despite debugfs failure
Date: Thu, 13 Dec 2018 13:15:11 +0200
Message-ID: <20181213111511.27308-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, David Miller <davem@davemloft.net>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The failure to create debugfs entry is unpleasant event, but not enough
to abort drier initialization. Align the mlx5_core code to debugfs design
and continue execution whenever debugfs_create_dir() successes or not.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
It goes to -next and not to -rc, because this issue was forever.
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 778995573812..93fa48a7eabb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -661,11 +661,9 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)

 	priv->numa_node = dev_to_node(&dev->pdev->dev);

-	priv->dbg_root = debugfs_create_dir(dev_name(&pdev->dev), mlx5_debugfs_root);
-	if (!priv->dbg_root) {
-		dev_err(&pdev->dev, "Cannot create debugfs dir, aborting\n");
-		return -ENOMEM;
-	}
+	if (mlx5_debugfs_root)
+		priv->dbg_root =
+			debugfs_create_dir(pci_name(pdev), mlx5_debugfs_root);

 	err = mlx5_pci_enable_device(dev);
 	if (err) {
