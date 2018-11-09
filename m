From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: [PATCH] infiniband/hw/cxgb3/cxio_hal.c: Use dma_zalloc_coherent
Date: Fri, 9 Nov 2018 22:20:29 +0530
Message-ID: <5be5bad9.1c69fb81.db750.d226@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca
Cc: jrdr.linux@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-rdma@vger.kernel.org

Replaced dma_alloc_coherent + memset with dma_zalloc_coherent

Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index dcb4bba..df4f7a3 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -291,13 +291,12 @@ int cxio_create_qp(struct cxio_rdev *rdev_p, u32 kernel_domain,
 	if (!wq->sq)
 		goto err3;
 
-	wq->queue = dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev),
+	wq->queue = dma_zalloc_coherent(&(rdev_p->rnic_info.pdev->dev),
 					     depth * sizeof(union t3_wr),
 					     &(wq->dma_addr), GFP_KERNEL);
 	if (!wq->queue)
 		goto err4;
 
-	memset(wq->queue, 0, depth * sizeof(union t3_wr));
 	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
 	wq->doorbell = (void __iomem *)rdev_p->rnic_info.kdb_addr;
 	if (!kernel_domain)
-- 
2.7.4
