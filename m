From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 14/45] RDMA/cxgb4: Remove a set-but-not-used variable
Date: Wed, 11 Oct 2017 10:48:56 -0700
Message-ID: <20171011174927.25113-15-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6e84179b4f9a..78e2916f9c78 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3877,7 +3877,6 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct net_device *pdev;
 	u16 rss_qid, eth_hdr_len;
 	int step;
-	u32 tx_chan;
 	struct neighbour *neigh;
 
 	/* Drop all non-SYN packets */
@@ -3959,14 +3958,12 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 				    pdev, 0);
 		pi = (struct port_info *)netdev_priv(pdev);
-		tx_chan = cxgb4_port_chan(pdev);
 		dev_put(pdev);
 	} else {
 		pdev = get_real_dev(neigh->dev);
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 					pdev, 0);
 		pi = (struct port_info *)netdev_priv(pdev);
-		tx_chan = cxgb4_port_chan(pdev);
 	}
 	neigh_release(neigh);
 	if (!e) {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
