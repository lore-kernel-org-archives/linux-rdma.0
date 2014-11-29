From: Tina Johnson <tinajohnson.1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] drivers: infiniband: hw: Add pci_dma_mapping_error() call
Date: Sat, 29 Nov 2014 22:51:17 +0530
Message-ID: <1417281677-7133-1-git-send-email-tinajohnson.1234@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, Tina Johnson <tinajohnson.1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added a pci_dma_mapping_error() call to check for mapping errors before
further using the dma handle. The previously allocated skb is freed in
case of a mapping error. Unchecked dma handles were found using Coccinelle:

@rule1@
expression e1;
identifier x;
@@

*x = pci_map_single(...);
 ... when != pci_dma_mapping_error(e1,x)

Signed-off-by: Tina Johnson <tinajohnson.1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 766a71c..c623e82 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -231,6 +231,10 @@ static inline int c2_rx_alloc(struct c2_port *c2_port, struct c2_element *elem)
 	mapaddr =
 	    pci_map_single(c2dev->pcidev, skb->data, maplen,
 			   PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(c2dev->pcidev, mapaddr)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
 
 	/* Set the sk_buff RXP_header to RXP_HRXD_READY */
 	rxp_hdr = (struct c2_rxp_hdr *) skb->data;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
