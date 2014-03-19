From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/8] iw_cxgb4: release neigh entry
Date: Wed, 19 Mar 2014 17:44:40 +0530
Message-ID: <1395231285-4495-4-git-send-email-hariprasad@chelsio.com>
References: <1395231285-4495-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395231285-4495-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Always release the neigh entry in rx_pkt().

Based on original work by Santosh Rastapur <santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8332994..3629b52 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3347,13 +3347,13 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pi = (struct port_info *)netdev_priv(pdev);
 		tx_chan = cxgb4_port_chan(pdev);
 	}
+	neigh_release(neigh);
 	if (!e) {
 		pr_err("%s - failed to allocate l2t entry!\n",
 		       __func__);
 		goto free_dst;
 	}
 
-	neigh_release(neigh);
 	step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
 	rss_qid = dev->rdev.lldi.rxq_ids[pi->port_id * step];
 	window = (__force u16) htons((__force u16)tcph->window);
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
