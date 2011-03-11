From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 4/7] RDMA/cxgb4: Use ULP_MODE_TCPDDP.
Date: Fri, 11 Mar 2011 16:30:21 -0600
Message-ID: <20110311223021.16418.16430.stgit@build.ogc.int>
References: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311222826.16418.43582.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Set the ULP mode for initial RDMA connection setup to
the proper DDP mode.  This avoids wasting some HW
resources while in streaming mode.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    2 ++
 drivers/net/cxgb4/t4_msg.h       |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 65d3fe6..b4d9e4c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -482,6 +482,7 @@ static int send_connect(struct c4iw_ep *ep)
 	       TX_CHAN(ep->tx_chan) |
 	       SMAC_SEL(ep->smac_idx) |
 	       DSCP(ep->tos) |
+	       ULP_MODE(ULP_MODE_TCPDDP) |
 	       RCV_BUFSIZ(rcv_win>>10);
 	opt2 = RX_CHANNEL(0) |
 	       RSS_QUEUE_VALID | RSS_QUEUE(ep->rss_qid);
@@ -1274,6 +1275,7 @@ static void accept_cr(struct c4iw_ep *ep, __be32 peer_ip, struct sk_buff *skb,
 	       TX_CHAN(ep->tx_chan) |
 	       SMAC_SEL(ep->smac_idx) |
 	       DSCP(ep->tos) |
+	       ULP_MODE(ULP_MODE_TCPDDP) |
 	       RCV_BUFSIZ(rcv_win>>10);
 	opt2 = RX_CHANNEL(0) |
 	       RSS_QUEUE_VALID | RSS_QUEUE(ep->rss_qid);
diff --git a/drivers/net/cxgb4/t4_msg.h b/drivers/net/cxgb4/t4_msg.h
index a550d0c..eb71b82 100644
--- a/drivers/net/cxgb4/t4_msg.h
+++ b/drivers/net/cxgb4/t4_msg.h
@@ -123,6 +123,7 @@ enum {
 	ULP_MODE_NONE          = 0,
 	ULP_MODE_ISCSI         = 2,
 	ULP_MODE_RDMA          = 4,
+	ULP_MODE_TCPDDP	       = 5,
 	ULP_MODE_FCOE          = 6,
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
