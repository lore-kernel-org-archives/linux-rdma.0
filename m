From: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4] staging: rdma: amso1100: c2: Remove wrapper function
Date: Thu, 5 Nov 2015 02:25:58 +0530
Message-ID: <20151104205557.GA3550@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch removes the c2_print_macaddr() wrapper function which calls
the pr_debug standard kernel function only.

c2_print_macaddr() has been replaced by directly calling pr_debug().

Signed-off-by: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
        -Removed comment added in previous version
Changes in v3:
        -Corrected indentation
Changes in v4:
        -Removed trailing whitespace

 drivers/staging/rdma/amso1100/c2.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2.c b/drivers/staging/rdma/amso1100/c2.c
index 7f1e794..20bdb8c 100644
--- a/drivers/staging/rdma/amso1100/c2.c
+++ b/drivers/staging/rdma/amso1100/c2.c
@@ -87,11 +87,6 @@ static struct pci_device_id c2_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, c2_pci_table);
 
-static void c2_print_macaddr(struct net_device *netdev)
-{
-	pr_debug("%s: MAC %pM, IRQ %u\n", netdev->name, netdev->dev_addr, netdev->irq);
-}
-
 static void c2_set_rxbufsize(struct c2_port *c2_port)
 {
 	struct net_device *netdev = c2_port->netdev;
@@ -908,7 +903,8 @@ static struct net_device *c2_devinit(struct c2_dev *c2dev,
 	/* Validate the MAC address */
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		pr_debug("Invalid MAC Address\n");
-		c2_print_macaddr(netdev);
+		pr_debug("%s: MAC %pM, IRQ %u\n", netdev->name,
+			 netdev->dev_addr, netdev->irq);
 		free_netdev(netdev);
 		return NULL;
 	}
@@ -1142,7 +1138,8 @@ static int c2_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	}
 
 	/* Print out the MAC address */
-	c2_print_macaddr(netdev);
+	pr_debug("%s: MAC %pM, IRQ %u\n", netdev->name, netdev->dev_addr,
+		 netdev->irq);
 
 	ret = c2_rnic_init(c2dev);
 	if (ret) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
