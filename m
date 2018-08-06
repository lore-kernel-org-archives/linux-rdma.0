From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH v6 5/9] fm10k: Do not call pcie_print_link_status()
Date: Mon,  6 Aug 2018 18:25:39 -0500
Message-ID: <20180806232600.25694-5-mr.nuke.me@gmail.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806232600.25694-1-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Alexandru Gagniuc <mr.nuke.me@gmail.com>, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

This is now done by the PCI core to warn of sub-optimal bandwidth.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 15071e4adb98..079fd3c884ea 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2224,9 +2224,6 @@ static int fm10k_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* kick off service timer now, even when interface is down */
 	mod_timer(&interface->service_timer, (HZ * 2) + jiffies);
 
-	/* print warning for non-optimal configurations */
-	pcie_print_link_status(interface->pdev);
-
 	/* report MAC address for logging */
 	dev_info(&pdev->dev, "%pM\n", netdev->dev_addr);
 
-- 
2.17.1
