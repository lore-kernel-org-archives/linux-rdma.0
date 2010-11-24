From: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] RDMA/nes: fix incorrect SFP link status detection on
	driver init
Date: Wed, 24 Nov 2010 18:29:54 +0100
Message-ID: <20101124172953.14764.56132.stgit@linux.site>
References: <20101124172930.14764.20947.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101124172930.14764.20947.stgit-YbU/o29LwNHN0uC3ymp8PA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

During iw_nes initialization link status for SFP phy is always detected
as "up" regardless of real state (cable either connected or disconnected).
Add SFP phy specific link status detection to iw_nes initialization procedure.
Use link status recheck for netdev_open to detect delayed state updates.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes_nic.c |   43 ++++++++++++++++++++++++++++++++---
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index b2101bc..3c4191e 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -241,6 +241,15 @@ static int nes_netdev_open(struct net_de
 		netif_carrier_on(netdev);
 	}
 
+	spin_lock_irqsave(&nesdev->nesadapter->phy_lock, flags);
+	if (nesdev->nesadapter->phy_type[nesdev->mac_index] == NES_PHY_TYPE_SFP_D) {
+		if (nesdev->link_recheck)
+			cancel_delayed_work(&nesdev->work);
+		nesdev->link_recheck = 1;
+		schedule_delayed_work(&nesdev->work, NES_LINK_RECHECK_DELAY);
+	}
+	spin_unlock_irqrestore(&nesdev->nesadapter->phy_lock, flags);
+
 	spin_lock_irqsave(&nesvnic->port_ibevent_lock, flags);
 	if (nesvnic->of_device_registered) {
 		nesdev->nesadapter->send_term_ok = 1;
@@ -1782,8 +1791,11 @@ struct net_device *nes_netdev_init(struc
 	      (((PCI_FUNC(nesdev->pcidev->devfn) == 1) && (nesdev->mac_index == 2)) ||
 	       ((PCI_FUNC(nesdev->pcidev->devfn) == 2) && (nesdev->mac_index == 1)))))) {
 		u32 u32temp;
-		u32 link_mask;
-		u32 link_val;
+		u32 link_mask = 0;
+		u32 link_val = 0;
+		u16 temp_phy_data;
+		u16 phy_data = 0;
+		unsigned long flags;
 
 		u32temp = nes_read_indexed(nesdev, NES_IDX_PHY_PCS_CONTROL_STATUS0 +
 				(0x200 * (nesdev->mac_index & 1)));
@@ -1805,6 +1817,23 @@ struct net_device *nes_netdev_init(struc
 				link_val = 0x02020000;
 			}
 			break;
+		case NES_PHY_TYPE_SFP_D:
+			spin_lock_irqsave(&nesdev->nesadapter->phy_lock, flags);
+			nes_read_10G_phy_reg(nesdev,
+					     nesdev->nesadapter->phy_index[nesdev->mac_index],
+					     1, 0x9003);
+			temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+			nes_read_10G_phy_reg(nesdev,
+					     nesdev->nesadapter->phy_index[nesdev->mac_index],
+					     3, 0x0021);
+			nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+			nes_read_10G_phy_reg(nesdev,
+					     nesdev->nesadapter->phy_index[nesdev->mac_index],
+					     3, 0x0021);
+			phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+			spin_unlock_irqrestore(&nesdev->nesadapter->phy_lock, flags);
+			phy_data = (!temp_phy_data && (phy_data == 0x8000)) ? 0x4 : 0x0;
+			break;
 		default:
 			link_mask = 0x0f1f0000;
 			link_val = 0x0f0f0000;
@@ -1814,8 +1843,14 @@ struct net_device *nes_netdev_init(struc
 		u32temp = nes_read_indexed(nesdev,
 					   NES_IDX_PHY_PCS_CONTROL_STATUS0 +
 					   (0x200 * (nesdev->mac_index & 1)));
-		if ((u32temp & link_mask) == link_val)
-			nesvnic->linkup = 1;
+
+		if (phy_type == NES_PHY_TYPE_SFP_D) {
+			if (phy_data & 0x0004)
+				nesvnic->linkup = 1;
+		} else {
+			if ((u32temp & link_mask) == link_val)
+				nesvnic->linkup = 1;
+		}
 
 		/* clear the MAC interrupt status, assumes direct logical to physical mapping */
 		u32temp = nes_read_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (0x200 * nesdev->mac_index));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
