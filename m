From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Mon,  3 Sep 2018 13:02:35 -0500
Message-ID: <20180903180242.14504-9-mr.nuke.me@gmail.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903180242.14504-1-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Alexandru Gagniuc <mr.nuke.me@gmail.com>, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

This is now done by the PCI core to warn of sub-optimal bandwidth.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index cf3e4a659052..888af98694f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1056,10 +1056,6 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	dev_info(&pdev->dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
 		 fw_rev_min(dev), fw_rev_sub(dev));
 
-	/* Only PFs hold the relevant PCIe information for this query */
-	if (mlx5_core_is_pf(dev))
-		pcie_print_link_status(dev->pdev);
-
 	/* on load removing any previous indication of internal error, device is
 	 * up
 	 */
-- 
2.17.1
