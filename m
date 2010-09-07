From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: correct register write in set TX pause param
Date: Tue, 7 Sep 2010 11:31:20 -0500
Message-ID: <20100907163120.GA4524@CTUNG-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Set TX pause param is writing to the wrong register
location causing the adpater to hang.  Correct the define
used to write the reigster.  This fixes OFED bug #2116.
https://bugs.openfabrics.org/show_bug.cgi?id=2116

Reported-by: Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 37a6733..3892e2c 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1447,14 +1447,14 @@ static int nes_netdev_set_pauseparam(struct net_device *netdev,
 				NES_IDX_MAC_TX_CONFIG + (nesdev->mac_index*0x200));
 		u32temp |= NES_IDX_MAC_TX_CONFIG_ENABLE_PAUSE;
 		nes_write_indexed(nesdev,
-				NES_IDX_MAC_TX_CONFIG_ENABLE_PAUSE + (nesdev->mac_index*0x200), u32temp);
+				NES_IDX_MAC_TX_CONFIG + (nesdev->mac_index*0x200), u32temp);
 		nesdev->disable_tx_flow_control = 0;
 	} else if ((et_pauseparam->tx_pause == 0) && (nesdev->disable_tx_flow_control == 0)) {
 		u32temp = nes_read_indexed(nesdev,
 				NES_IDX_MAC_TX_CONFIG + (nesdev->mac_index*0x200));
 		u32temp &= ~NES_IDX_MAC_TX_CONFIG_ENABLE_PAUSE;
 		nes_write_indexed(nesdev,
-				NES_IDX_MAC_TX_CONFIG_ENABLE_PAUSE + (nesdev->mac_index*0x200), u32temp);
+				NES_IDX_MAC_TX_CONFIG + (nesdev->mac_index*0x200), u32temp);
 		nesdev->disable_tx_flow_control = 1;
 	}
 	if ((et_pauseparam->rx_pause == 1) && (nesdev->disable_rx_flow_control == 1)) {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
