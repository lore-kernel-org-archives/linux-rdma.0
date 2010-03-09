From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: make nesadapter->phy_lock usage consistent
Date: Tue, 9 Mar 2010 15:50:40 -0600
Message-ID: <20100309215040.GA5912@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


nes_{read,write}_1G_phy_reg() are using phy_lock while
nes_{read,write}_10G_phy_reg() leave that to the caller.

Remove phy_lock from 1G routines and leave the locking to the caller.
Add additional phy_lock calls around 1G read/write.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c    |    8 +++-----
 drivers/infiniband/hw/nes/nes_nic.c   |   16 +++++++++++-----
 drivers/infiniband/hw/nes/nes_utils.c |    9 ---------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 9250755..5e83962 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2457,7 +2457,6 @@ static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number)
 		return;
 	}
 	nesadapter->mac_sw_state[mac_number] = NES_MAC_SW_INTERRUPT;
-	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 
 	/* ack the MAC interrupt */
 	mac_status = nes_read_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (mac_index * 0x200));
@@ -2468,11 +2467,9 @@ static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number)
 
 	if (mac_status & (NES_MAC_INT_LINK_STAT_CHG | NES_MAC_INT_XGMII_EXT)) {
 		nesdev->link_status_interrupts++;
-		if (0 == (++nesadapter->link_interrupt_count[mac_index] % ((u16)NES_MAX_LINK_INTERRUPTS))) {
-			spin_lock_irqsave(&nesadapter->phy_lock, flags);
+		if (0 == (++nesadapter->link_interrupt_count[mac_index] % ((u16)NES_MAX_LINK_INTERRUPTS)))
 			nes_reset_link(nesdev, mac_index);
-			spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
-		}
+
 		/* read the PHY interrupt status register */
 		if ((nesadapter->OneG_Mode) &&
 		(nesadapter->phy_type[mac_index] != NES_PHY_TYPE_PUMA_1G)) {
@@ -2586,6 +2583,7 @@ static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number)
 				break;
 			}
 		}
+		spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 
 		if (phy_data & 0x0004) {
 			if (wide_ppm_offset &&
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 91fdde3..c85bf0d 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1460,11 +1460,14 @@ static int nes_netdev_get_settings(struct net_device *netdev, struct ethtool_cmd
 			et_cmd->transceiver = XCVR_INTERNAL;
 			et_cmd->phy_address = mac_index;
 		} else {
+			unsigned long flags;
 			et_cmd->supported   = SUPPORTED_1000baseT_Full
 					    | SUPPORTED_Autoneg;
 			et_cmd->advertising = ADVERTISED_1000baseT_Full
 					    | ADVERTISED_Autoneg;
+			spin_lock_irqsave(&nesadapter->phy_lock, flags);
 			nes_read_1G_phy_reg(nesdev, 0, phy_index, &phy_data);
+			spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 			if (phy_data & 0x1000)
 				et_cmd->autoneg = AUTONEG_ENABLE;
 			else
@@ -1502,12 +1505,15 @@ static int nes_netdev_set_settings(struct net_device *netdev, struct ethtool_cmd
 	struct nes_vnic *nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
-	u16 phy_data;
 
 	if ((nesadapter->OneG_Mode) &&
 	    (nesadapter->phy_type[nesdev->mac_index] != NES_PHY_TYPE_PUMA_1G)) {
-		nes_read_1G_phy_reg(nesdev, 0, nesadapter->phy_index[nesdev->mac_index],
-				&phy_data);
+		unsigned long flags;
+		u16 phy_data;
+		u8 phy_index = nesadapter->phy_index[nesdev->mac_index];
+
+		spin_lock_irqsave(&nesadapter->phy_lock, flags);
+		nes_read_1G_phy_reg(nesdev, 0, phy_index, &phy_data);
 		if (et_cmd->autoneg) {
 			/* Turn on Full duplex, Autoneg, and restart autonegotiation */
 			phy_data |= 0x1300;
@@ -1515,8 +1521,8 @@ static int nes_netdev_set_settings(struct net_device *netdev, struct ethtool_cmd
 			/* Turn off autoneg */
 			phy_data &= ~0x1000;
 		}
-		nes_write_1G_phy_reg(nesdev, 0, nesadapter->phy_index[nesdev->mac_index],
-				phy_data);
+		nes_write_1G_phy_reg(nesdev, 0, phy_index, phy_data);
+		spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 729d525..73f1fb4 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -383,9 +383,6 @@ void nes_write_1G_phy_reg(struct nes_device *nesdev, u8 phy_reg, u8 phy_addr, u1
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 u32temp;
 	u32 counter;
-	unsigned long flags;
-
-	spin_lock_irqsave(&nesadapter->phy_lock, flags);
 
 	nes_write_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL,
 			0x50020000 | data | ((u32)phy_reg << 18) | ((u32)phy_addr << 23));
@@ -401,8 +398,6 @@ void nes_write_1G_phy_reg(struct nes_device *nesdev, u8 phy_reg, u8 phy_addr, u1
 	if (!(u32temp & 1))
 		nes_debug(NES_DBG_PHY, "Phy is not responding. interrupt status = 0x%X.\n",
 				u32temp);
-
-	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 }
 
 
@@ -413,14 +408,11 @@ void nes_write_1G_phy_reg(struct nes_device *nesdev, u8 phy_reg, u8 phy_addr, u1
  */
 void nes_read_1G_phy_reg(struct nes_device *nesdev, u8 phy_reg, u8 phy_addr, u16 *data)
 {
-	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 u32temp;
 	u32 counter;
-	unsigned long flags;
 
 	/* nes_debug(NES_DBG_PHY, "phy addr = %d, mac_index = %d\n",
 			phy_addr, nesdev->mac_index); */
-	spin_lock_irqsave(&nesadapter->phy_lock, flags);
 
 	nes_write_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL,
 			0x60020000 | ((u32)phy_reg << 18) | ((u32)phy_addr << 23));
@@ -440,7 +432,6 @@ void nes_read_1G_phy_reg(struct nes_device *nesdev, u8 phy_reg, u8 phy_addr, u16
 	} else {
 		*data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
 	}
-	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 }
 
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
