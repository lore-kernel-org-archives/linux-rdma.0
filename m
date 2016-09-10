From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 8/8] net: hns: delete redundant broadcast packet filter process
Date: Sat, 10 Sep 2016 05:09:30 +0100
Message-ID: <20160910040930.25988-9-salil.mehta@huawei.com>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160910040930.25988-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

The broadcast packets is filtered in the hardware now, so this process
is no need in the driver, just delete it.

Signed-off-by: Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Reviewed-by: Yisen Zhuang <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 4105df8..d56dfca 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -574,7 +574,6 @@ static int hns_nic_poll_rx_skb(struct hns_nic_ring_data *ring_data,
 	struct sk_buff *skb;
 	struct hnae_desc *desc;
 	struct hnae_desc_cb *desc_cb;
-	struct ethhdr *eh;
 	unsigned char *va;
 	int bnum, length, i;
 	int pull_len;
@@ -600,7 +599,6 @@ static int hns_nic_poll_rx_skb(struct hns_nic_ring_data *ring_data,
 		ring->stats.sw_err_cnt++;
 		return -ENOMEM;
 	}
-	skb_reset_mac_header(skb);
 
 	prefetchw(skb->data);
 	length = le16_to_cpu(desc->rx.pkt_len);
@@ -682,14 +680,6 @@ out_bnum_err:
 		return -EFAULT;
 	}
 
-	/* filter out multicast pkt with the same src mac as this port */
-	eh = eth_hdr(skb);
-	if (unlikely(is_multicast_ether_addr(eh->h_dest) &&
-		     ether_addr_equal(ndev->dev_addr, eh->h_source))) {
-		dev_kfree_skb_any(skb);
-		return -EFAULT;
-	}
-
 	ring->stats.rx_pkts++;
 	ring->stats.rx_bytes += skb->len;
 
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
