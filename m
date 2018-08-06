From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH v6 6/9] ixgbe: Do not call pcie_print_link_status()
Date: Mon,  6 Aug 2018 18:25:40 -0500
Message-ID: <20180806232600.25694-6-mr.nuke.me@gmail.com>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 26 -------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 62e57b05a0ae..7ecdc6c03a66 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -241,28 +241,6 @@ static inline bool ixgbe_pcie_from_parent(struct ixgbe_hw *hw)
 	}
 }
 
-static void ixgbe_check_minimum_link(struct ixgbe_adapter *adapter,
-				     int expected_gts)
-{
-	struct ixgbe_hw *hw = &adapter->hw;
-	struct pci_dev *pdev;
-
-	/* Some devices are not connected over PCIe and thus do not negotiate
-	 * speed. These devices do not have valid bus info, and thus any report
-	 * we generate may not be correct.
-	 */
-	if (hw->bus.type == ixgbe_bus_type_internal)
-		return;
-
-	/* determine whether to use the parent device */
-	if (ixgbe_pcie_from_parent(&adapter->hw))
-		pdev = adapter->pdev->bus->parent->self;
-	else
-		pdev = adapter->pdev;
-
-	pcie_print_link_status(pdev);
-}
-
 static void ixgbe_service_event_schedule(struct ixgbe_adapter *adapter)
 {
 	if (!test_bit(__IXGBE_DOWN, &adapter->state) &&
@@ -10585,10 +10563,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	}
 
-	/* don't check link if we failed to enumerate functions */
-	if (expected_gts > 0)
-		ixgbe_check_minimum_link(adapter, expected_gts);
-
 	err = ixgbe_read_pba_string_generic(hw, part_str, sizeof(part_str));
 	if (err)
 		strlcpy(part_str, "Unknown", sizeof(part_str));
-- 
2.17.1
