From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/vmw_pvrdma: Fix incorrect cleanup on pvrdma_pci_probe error path
Date: Thu, 19 Jan 2017 13:20:40 -0800
Message-ID: <cd1027c125c3c098c59fa3c612e6bf617aa77dc9.1484859556.git.aditr@vmware.com>
References: <cover.1484859556.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1484859556.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the interrupt allocation failed we should start freeing the CQ rings
rather than unregistering the netdev notifier.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 231a1ce..bd8fbd3 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1029,7 +1029,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "failed to allocate interrupts\n");
 		ret = -ENOMEM;
-		goto err_netdevice;
+		goto err_free_cq_ring;
 	}
 
 	/* Allocate UAR table. */
@@ -1092,8 +1092,6 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 err_free_intrs:
 	pvrdma_free_irq(dev);
 	pvrdma_disable_msi_all(dev);
-err_netdevice:
-	unregister_netdevice_notifier(&dev->nb_netdev);
 err_free_cq_ring:
 	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
 err_free_async_ring:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
