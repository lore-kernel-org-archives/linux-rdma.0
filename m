From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.2 1/1] RDMA/nes: Fix for incorrect recording of the MAC
 address
Date: Thu, 2 Jul 2015 12:52:29 -0500
Message-ID: <20150702175229.GA12160@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for incorrect recording of the MAC address

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 02120d3..4713dd7 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3861,7 +3861,7 @@ void nes_manage_arp_cache(struct net_device *netdev, unsigned char *mac_addr,
 				(((u32)mac_addr[2]) << 24) | (((u32)mac_addr[3]) << 16) |
 				(((u32)mac_addr[4]) << 8)  | (u32)mac_addr[5]);
 		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_HIGH_IDX] = cpu_to_le32(
-				(((u32)mac_addr[0]) << 16) | (u32)mac_addr[1]);
+				(((u32)mac_addr[0]) << 8) | (u32)mac_addr[1]);
 	} else {
 		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_ADDR_LOW_IDX] = 0;
 		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_HIGH_IDX] = 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
