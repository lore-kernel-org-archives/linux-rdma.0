From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: fix CX4 link problem in back-to-back configuration
Date: Wed, 3 Mar 2010 13:13:26 -0600
Message-ID: <20100303191326.GA7916@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


commit 09124e1913cf2140941f60ab4fdf8576e1e8fd8d took out
too much code and broke CX4 link detection in back-to-back
configuration.  This will put back the code that does the link
check.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 7dd6ce6..a60efee 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1582,7 +1582,6 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	struct nes_vnic *nesvnic;
 	struct net_device *netdev;
 	struct nic_qp_map *curr_qp_map;
-	u32 u32temp;
 	u8 phy_type = nesdev->nesadapter->phy_type[nesdev->mac_index];
 
 	netdev = alloc_etherdev(sizeof(struct nes_vnic));
@@ -1694,6 +1693,10 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	     ((phy_type == NES_PHY_TYPE_PUMA_1G) &&
 	      (((PCI_FUNC(nesdev->pcidev->devfn) == 1) && (nesdev->mac_index == 2)) ||
 	       ((PCI_FUNC(nesdev->pcidev->devfn) == 2) && (nesdev->mac_index == 1)))))) {
+		u32 u32temp;
+		u32 link_mask;
+		u32 link_val;
+
 		u32temp = nes_read_indexed(nesdev, NES_IDX_PHY_PCS_CONTROL_STATUS0 +
 				(0x200 * (nesdev->mac_index & 1)));
 		if (phy_type != NES_PHY_TYPE_PUMA_1G) {
@@ -1702,13 +1705,36 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 				(0x200 * (nesdev->mac_index & 1)), u32temp);
 		}
 
+		/* Check and set linkup here.  This is for back to back */
+		/* configuration where second port won't get link interrupt */
+		switch (phy_type) {
+		case NES_PHY_TYPE_PUMA_1G:
+			if (nesdev->mac_index < 2) {
+				link_mask = 0x01010000;
+				link_val = 0x01010000;
+			} else {
+				link_mask = 0x02020000;
+				link_val = 0x02020000;
+			}
+			break;
+		default:
+			link_mask = 0x0f1f0000;
+			link_val = 0x0f0f0000;
+			break;
+		}
+
+		u32temp = nes_read_indexed(nesdev,
+					   NES_IDX_PHY_PCS_CONTROL_STATUS0 +
+					   (0x200 * (nesdev->mac_index & 1)));
+		if ((u32temp & link_mask) == link_val)
+			nesvnic->linkup = 1;
+
 		/* clear the MAC interrupt status, assumes direct logical to physical mapping */
 		u32temp = nes_read_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (0x200 * nesdev->mac_index));
 		nes_debug(NES_DBG_INIT, "Phy interrupt status = 0x%X.\n", u32temp);
 		nes_write_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (0x200 * nesdev->mac_index), u32temp);
 
 		nes_init_phy(nesdev);
-
 	}
 
 	return netdev;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
