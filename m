From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH 7/9] net/mlx4: Do not call pcie_print_link_status()
Date: Mon,  3 Sep 2018 13:02:34 -0500
Message-ID: <20180903180242.14504-8-mr.nuke.me@gmail.com>
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
 drivers/net/ethernet/mellanox/mlx4/main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index d2d59444f562..9902fa3a2c13 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3525,13 +3525,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
-	/* check if the device is functioning at its maximum possible speed.
-	 * No return code for this call, just warn the user in case of PCI
-	 * express device capabilities are under-satisfied by the bus.
-	 */
-	if (!mlx4_is_slave(dev))
-		pcie_print_link_status(dev->persist->pdev);
-
 	/* In master functions, the communication channel must be initialized
 	 * after obtaining its address from fw */
 	if (mlx4_is_master(dev)) {
-- 
2.17.1
