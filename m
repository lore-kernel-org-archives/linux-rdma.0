From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/9] RDMA/nes: Add additional SFP+ PHY uC status check and PHY reset
Date: Tue, 1 Dec 2009 16:19:53 -0600
Message-ID: <20091201221953.GA6936@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Add additional PHY uC status check in case PHY firmware is not running
properly with heartbeat.  Add a hard PHY reset if uC status is 0x0
after initial reset.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 3d9bbff..b59ca56 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1356,6 +1356,8 @@ int nes_init_phy(struct nes_device *nesdev)
 	}
 	if ((phy_type == NES_PHY_TYPE_ARGUS) ||
 	    (phy_type == NES_PHY_TYPE_SFP_D)) {
+		u32 first_time = 1;
+
 		/* Check firmware heartbeat */
 		nes_read_10G_phy_reg(nesdev, phy_index, 0x3, 0xd7ee);
 		temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
@@ -1363,8 +1365,13 @@ int nes_init_phy(struct nes_device *nesdev)
 		nes_read_10G_phy_reg(nesdev, phy_index, 0x3, 0xd7ee);
 		temp_phy_data2 = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
 
-		if (temp_phy_data != temp_phy_data2)
-			return 0;
+		if (temp_phy_data != temp_phy_data2) {
+			nes_read_10G_phy_reg(nesdev, phy_index, 0x3, 0xd7fd);
+			temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
+			if ((temp_phy_data & 0xff) > 0x20)
+				return 0;
+			printk(PFX "Reinitializing PHY\n");
+		}
 
 		/* no heartbeat, configure the PHY */
 		nes_write_10G_phy_reg(nesdev, phy_index, 0x1, 0x0000, 0x8000);
@@ -1400,7 +1407,7 @@ int nes_init_phy(struct nes_device *nesdev)
 		temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
 		do {
 			if (counter++ > 150) {
-				nes_debug(NES_DBG_PHY, "No PHY heartbeat\n");
+				printk(PFX "No PHY heartbeat\n");
 				break;
 			}
 			mdelay(1);
@@ -1414,11 +1421,20 @@ int nes_init_phy(struct nes_device *nesdev)
 			nes_read_10G_phy_reg(nesdev, phy_index, 0x3, 0xd7fd);
 			temp_phy_data = (u16)nes_read_indexed(nesdev, NES_IDX_MAC_MDIO_CONTROL);
 			if (counter++ > 300) {
-				nes_debug(NES_DBG_PHY, "PHY did not track\n");
-				break;
+				if (((temp_phy_data & 0xff) == 0x0) && first_time) {
+					first_time = 0;
+					counter = 0;
+					/* reset AMCC PHY and try again */
+					nes_write_10G_phy_reg(nesdev, phy_index, 0x3, 0xe854, 0x00c0);
+					nes_write_10G_phy_reg(nesdev, phy_index, 0x3, 0xe854, 0x0040);
+					continue;
+				} else {
+					printk(PFX "PHY did not track\n");
+					break;
+				}
 			}
 			mdelay(10);
-		} while (((temp_phy_data & 0xff) != 0x50) && ((temp_phy_data & 0xff) != 0x70));
+		} while ((temp_phy_data & 0xff) < 0x30);
 
 		/* setup signal integrity */
 		nes_write_10G_phy_reg(nesdev, phy_index, 0x1, 0xd003, 0x0000);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
