From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCH net 7/9] RDMA/cxgb4: Calculate the filter server TID properly
Date: Mon, 16 Dec 2013 17:42:16 +0530
Message-ID: <1387195938-3531-8-git-send-email-hariprasad@chelsio.com>
References: <1387195938-3531-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1387195938-3531-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, kumaras@chelsio.com, hariprasad@chelsio.com, nirranjan@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Kumar Sanghvi <kumaras@chelsio.com>

Based on original work by Santosh Rastapur <santosh@chelsio.com>

Signed-off-by: Hariprasad Shenai <hariprasad@chelsio.com>
Signed-off-by: Kumar Sanghvi <kumaras@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 12fef76..02c7515 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3323,9 +3323,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	/*
 	 * Calculate the server tid from filter hit index from cpl_rx_pkt.
 	 */
-	stid = (__force int) cpu_to_be32((__force u32) rss->hash_val)
-					  - dev->rdev.lldi.tids->sftid_base
-					  + dev->rdev.lldi.tids->nstids;
+	stid = (__force int) cpu_to_be32((__force u32) rss->hash_val);
 
 	lep = (struct c4iw_ep *)lookup_stid(dev->rdev.lldi.tids, stid);
 	if (!lep) {
-- 
1.8.0
