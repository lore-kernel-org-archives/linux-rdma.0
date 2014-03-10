From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCHv5 net-next 23/31] iw_cxgb4: drop RX_DATA packets if the endpoint is gone
Date: Mon, 10 Mar 2014 22:38:20 +0530
Message-ID: <1394471308-4304-24-git-send-email-hariprasad@chelsio.com>
References: <1394471308-4304-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1394471308-4304-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, kumaras@chelsio.com, nirranjan@chelsio.com, hariprasad@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f4a9ebe..e7c6dfd 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1544,6 +1544,8 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	__u8 status = hdr->status;
 
 	ep = lookup_tid(t, tid);
+	if (!ep)
+		return 0;
 	PDBG("%s ep %p tid %u dlen %u\n", __func__, ep, ep->hwtid, dlen);
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, dlen);
-- 
1.8.4
