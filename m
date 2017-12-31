From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/vmw_pvrdma: Use zeroing memory allocator than allocator/memset
Date: Sun, 31 Dec 2017 17:59:00 +0530
Message-ID: <1514723340-5793-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 1f4e187..1f85168 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -885,8 +885,8 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "device version %d, driver version %d\n",
 		 dev->dsr_version, PVRDMA_VERSION);
 
-	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
-				      &dev->dsrbase, GFP_KERNEL);
+	dev->dsr = dma_zalloc_coherent(&pdev->dev, sizeof(*dev->dsr),
+				       &dev->dsrbase, GFP_KERNEL);
 	if (!dev->dsr) {
 		dev_err(&pdev->dev, "failed to allocate shared region\n");
 		ret = -ENOMEM;
@@ -894,7 +894,6 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Setup the shared region */
-	memset(dev->dsr, 0, sizeof(*dev->dsr));
 	dev->dsr->driver_version = PVRDMA_VERSION;
 	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
 		PVRDMA_GOS_BITS_32 :
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
