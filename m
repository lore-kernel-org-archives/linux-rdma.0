From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: [PATCH 1/1] infiniband: nes: return value of skb_linearize should be handled
Date: Wed,  7 Dec 2016 15:30:05 +0800
Message-ID: <1481095805-25010-1-git-send-email-zhouzhouyi@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, eric.dumazet@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
List-Id: linux-rdma@vger.kernel.org

Return value of skb_linearize should be handled in function 
nes_netdev_start_xmit.

Compiled in x86_64
Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com> 
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>

---
 drivers/infiniband/hw/nes/nes_nic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 2b27d13..dfd1f57 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -662,10 +662,14 @@ static int nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 				nesnic->sq_head &= nesnic->sq_size-1;
 			}
 		} else {
-			nesvnic->linearized_skbs++;
 			hoffset = skb_transport_header(skb) - skb->data;
 			nhoffset = skb_network_header(skb) - skb->data;
-			skb_linearize(skb);
+			if (skb_linearize(skb)) {
+				nesvnic->tx_sw_dropped++;
+				kfree_skb(skb);
+				return NETDEV_TX_OK;
+			}
+			nesvnic->linearized_skbs++;
 			skb_set_transport_header(skb, hoffset);
 			skb_set_network_header(skb, nhoffset);
 			if (!nes_nic_send(skb, netdev))
-- 
1.9.1
