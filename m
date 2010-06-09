From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: get and print eeprom version
Date: Wed, 9 Jun 2010 15:19:53 -0500
Message-ID: <20100609201953.GA2304@CTUNG-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Read and print eeprom version and save it off for later use.
Also delete a tab.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.h    |    3 ++-
 drivers/infiniband/hw/nes/nes_utils.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index bbbfe9f..aa9183d 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1100,11 +1100,12 @@ struct nes_adapter {
 	u32 wqm_wat;
 	u32 core_clock;
 	u32 firmware_version;
+	u32 eeprom_version;
 
 	u32 nic_rx_eth_route_err;
 
 	u32 et_rx_coalesce_usecs;
-	u32	et_rx_max_coalesced_frames;
+	u32 et_rx_max_coalesced_frames;
 	u32 et_rx_coalesce_usecs_irq;
 	u32 et_rx_max_coalesced_frames_irq;
 	u32 et_pkt_rate_low;
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index a9f5dd2..c3697c8 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -190,6 +190,11 @@ int nes_read_eeprom_values(struct nes_device *nesdev, struct nes_adapter *nesada
 		nesadapter->firmware_version = (((u32)(u8)(eeprom_data>>8))  <<  16) +
 				(u32)((u8)eeprom_data);
 
+		eeprom_data = nes_read16_eeprom(nesdev->regs, next_section_address + 10);
+		printk(PFX "EEPROM version %u.%u\n", (u8)(eeprom_data>>8), (u8)eeprom_data);
+		nesadapter->eeprom_version = (((u32)(u8)(eeprom_data>>8))  <<  16) +
+				(u32)((u8)eeprom_data);
+
 no_fw_rev:
 		/* eeprom is valid */
 		eeprom_offset = nesadapter->software_eeprom_offset;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
