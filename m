From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 7/8] net: hns: bug fix about broadcast/multicast packets
Date: Sat, 10 Sep 2016 05:09:29 +0100
Message-ID: <20160910040930.25988-8-salil.mehta@huawei.com>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160910040930.25988-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Daode Huang <huangdaode@hisilicon.com>
List-Id: linux-rdma@vger.kernel.org

From: Daode Huang <huangdaode@hisilicon.com>

When the dsaf mode receives a broadcast packet, it will filter
the packet by comparing the received queue number and destination
queue number(get from forwarding table), if they are the same,
the packet will be filtered. Otherwise, the packet will be loopback.
So this patch select queue 0 to send broadcast and multicast packets.

Signed-off-by: Daode Huang <huangdaode@hisilicon.com>
Reviewed-by: Yisen Zhuang <yisen.zhuang@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 09ed237..4105df8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1597,6 +1597,20 @@ struct rtnl_link_stats64 *hns_nic_get_stats64(struct net_device *ndev,
 	return stats;
 }
 
+static u16
+hns_nic_select_queue(struct net_device *ndev, struct sk_buff *skb,
+		     void *accel_priv, select_queue_fallback_t fallback)
+{
+	struct hns_nic_priv *priv = netdev_priv(ndev);
+	struct ethhdr *eth_hdr = (struct ethhdr *)skb->data;
+
+	/*fix hardware broadcast/multicast packets queue loopback */
+	if (!AE_IS_VER1(priv->enet_ver) &&
+	    is_multicast_ether_addr(eth_hdr->h_dest))
+		return 0;
+	else
+		return fallback(ndev, skb);
+}
 static const struct net_device_ops hns_nic_netdev_ops = {
 	.ndo_open = hns_nic_net_open,
 	.ndo_stop = hns_nic_net_stop,
@@ -1612,6 +1626,7 @@ static const struct net_device_ops hns_nic_netdev_ops = {
 	.ndo_poll_controller = hns_nic_poll_controller,
 #endif
 	.ndo_set_rx_mode = hns_nic_set_rx_mode,
+	.ndo_select_queue = hns_nic_select_queue,
 };
 
 static void hns_nic_update_link_status(struct net_device *netdev)
-- 
1.9.1
