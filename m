From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: fix incorrect unlock in nes_process_mac_intr
Date: Tue, 25 May 2010 10:13:09 -0500
Message-ID: <20100525151309.GA2688@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


commit ce6e74f2 introduced a problem where unlock took place only
within an if statement.

sparse warning:

drivers/infiniband/hw/nes/nes_hw.c:2643:9: warning: context imbalance
in 'nes_process_mac_intr' - different lock contexts for basic block

Reported-by: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index bb9c775..57874a1 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2584,7 +2584,6 @@ static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 
 		if (phy_data & 0x0004) {
 			if (wide_ppm_offset &&
@@ -2639,6 +2638,8 @@ static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number)
 		}
 	}
 
+	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
+
 	nesadapter->mac_sw_state[mac_number] = NES_MAC_SW_IDLE;
 }
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
