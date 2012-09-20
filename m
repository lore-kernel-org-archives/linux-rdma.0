From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] RDMA/nes: Fix for crash when tx chksum offload is off
Date: Thu, 20 Sep 2012 15:55:33 -0500
Message-ID: <20120920205533.GA5904@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When tx checksum offload is disabled for iWarp connection, skb->ip_summed needs to be set to CHECKSUM_NONE

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 49a9383..f843bb0 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -430,6 +430,8 @@ static void form_cm_frame(struct sk_buff *skb,
 	buf += sizeof(*tcph);
 
 	skb->ip_summed = CHECKSUM_PARTIAL;
+	if (!(cm_node->netdev->features & NETIF_F_IP_CSUM))
+		skb->ip_summed = CHECKSUM_NONE;
 	skb->protocol = htons(0x800);
 	skb->data_len = 0;
 	skb->mac_len = ETH_HLEN;
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
