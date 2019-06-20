From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 25/28] IB/core: Remove P2PDMA mapping support in rdma_rw_ctx
Date: Thu, 20 Jun 2019 10:12:37 -0600
Message-ID: <20190620161240.22738-26-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

There are no longer any users submitting P2PDMA struct pages to
rdma_rw_ctx. So it can be removed.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/infiniband/core/rw.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index cefa6b930bc8..350b9b730ddc 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -4,7 +4,6 @@
  */
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
-#include <linux/pci-p2pdma.h>
 #include <rdma/mr_pool.h>
 #include <rdma/rw.h>
 
@@ -271,11 +270,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	struct ib_device *dev = qp->pd->device;
 	int ret;
 
-	if (is_pci_p2pdma_page(sg_page(sg)))
-		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
-	else
-		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
-
+	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
@@ -635,9 +630,7 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 {
 	__rdma_rw_ctx_destroy(ctx, qp);
 
-	/* P2PDMA contexts do not need to be unmapped */
-	if (!is_pci_p2pdma_page(sg_page(sg)))
-		ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
-- 
2.20.1
