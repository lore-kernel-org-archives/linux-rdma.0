From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix for incorrect multicast address
Date: Tue, 13 Nov 2012 16:20:41 -0600
Message-ID: <20121113222040.GA9236@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for incorrect multicast address in the perfect filter table

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 0564be7..9542e16 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -944,12 +944,13 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 					  addr,
 					  perfect_filter_register_address+(mc_index * 8),
 					  mc_nic_index);
-				macaddr_high  = ((u16) addr[0]) << 8;
-				macaddr_high += (u16) addr[1];
-				macaddr_low   = ((u32) addr[2]) << 24;
-				macaddr_low  += ((u32) addr[3]) << 16;
-				macaddr_low  += ((u32) addr[4]) << 8;
-				macaddr_low  += (u32) addr[5];
+				macaddr_high  = ((u8) addr[0]) << 8;
+				macaddr_high += (u8) addr[1];
+				macaddr_low   = ((u8) addr[2]) << 24;
+				macaddr_low  += ((u8) addr[3]) << 16;
+				macaddr_low  += ((u8) addr[4]) << 8;
+				macaddr_low  += (u8) addr[5];
+
 				nes_write_indexed(nesdev,
 						perfect_filter_register_address+(mc_index * 8),
 						macaddr_low);
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
