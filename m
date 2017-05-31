From: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: fix the calculation of ipv6 header size
Date: Wed, 31 May 2017 12:06:58 +0530
Message-ID: <1496212618-18785-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Take care of ipv6 checks while computing header length for deducing mtu
size of ipv6 servers. Due to the incorrect header length computation for
ipv6 servers, wrong mss is reported to the peer (client).

Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b6fe459..b54e184 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2517,7 +2517,8 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 		goto reject;
 	}
 
-	hdrs = sizeof(struct iphdr) + sizeof(struct tcphdr) +
+	hdrs = ((iptype == 4) ? sizeof(struct iphdr) : sizeof(struct ipv6hdr)) +
+	       sizeof(struct tcphdr) +
 	       ((enable_tcp_timestamps && req->tcpopt.tstamp) ? 12 : 0);
 	if (peer_mss && child_ep->mtu > (peer_mss + hdrs))
 		child_ep->mtu = peer_mss + hdrs;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
