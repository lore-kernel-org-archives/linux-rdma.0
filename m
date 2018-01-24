From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/vmw_pvrdma: Use standard way to check return value
Date: Wed, 24 Jan 2018 13:17:21 +0200
Message-ID: <20180124111721.8170-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To be compatible with other modules/drivers, change return code checks
from "if (rc != 0)" to "if (rc)".

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index d650a9fcde24..6f50220295c8 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -837,16 +837,16 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Enable 64-Bit DMA */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_consistent_dma_mask failed\n");
 			goto err_free_resource;
 		}
 	} else {
 		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_dma_mask failed\n");
 			goto err_free_resource;
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
