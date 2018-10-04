From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v9 10/13] nvme-pci: Add support for P2P memory in requests
Date: Thu,  4 Oct 2018 15:27:44 -0600
Message-ID: <20181004212747.6301-11-logang@deltatee.com>
References: <20181004212747.6301-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181004212747.6301-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jens Axboe <axboe@kernel.dk>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

For P2P requests, we must use the pci_p2pmem_map_sg() function
instead of the dma_map_sg functions.

With that, we can then indicate PCI_P2P support in the request queue.
For this, we create an NVME_F_PCI_P2P flag which tells the core to
set QUEUE_FLAG_PCI_P2P in the request queue.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <keith.busch@intel.com>
---
 drivers/nvme/host/core.c |  4 ++++
 drivers/nvme/host/nvme.h |  1 +
 drivers/nvme/host/pci.c  | 17 +++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dd8ec1dd9219..6033ce2fd3e9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3051,7 +3051,11 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	ns->queue = blk_mq_init_queue(ctrl->tagset);
 	if (IS_ERR(ns->queue))
 		goto out_free_ns;
+
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
+	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
+		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
+
 	ns->queue->queuedata = ns;
 	ns->ctrl = ctrl;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bb4a2003c097..4030743c90aa 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -343,6 +343,7 @@ struct nvme_ctrl_ops {
 	unsigned int flags;
 #define NVME_F_FABRICS			(1 << 0)
 #define NVME_F_METADATA_SUPPORTED	(1 << 1)
+#define NVME_F_PCI_P2PDMA		(1 << 2)
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f434706a04e8..0d6c41bc2b35 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -745,8 +745,13 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		goto out;
 
 	ret = BLK_STS_RESOURCE;
-	nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents, dma_dir,
-			DMA_ATTR_NO_WARN);
+
+	if (is_pci_p2pdma_page(sg_page(iod->sg)))
+		nr_mapped = pci_p2pdma_map_sg(dev->dev, iod->sg, iod->nents,
+					  dma_dir);
+	else
+		nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
+					     dma_dir,  DMA_ATTR_NO_WARN);
 	if (!nr_mapped)
 		goto out;
 
@@ -788,7 +793,10 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 			DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
 	if (iod->nents) {
-		dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
+		/* P2PDMA requests do not need to be unmapped */
+		if (!is_pci_p2pdma_page(sg_page(iod->sg)))
+			dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
+
 		if (blk_integrity_rq(req))
 			dma_unmap_sg(dev->dev, &iod->meta_sg, 1, dma_dir);
 	}
@@ -2400,7 +2408,8 @@ static int nvme_pci_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.name			= "pcie",
 	.module			= THIS_MODULE,
-	.flags			= NVME_F_METADATA_SUPPORTED,
+	.flags			= NVME_F_METADATA_SUPPORTED |
+				  NVME_F_PCI_P2PDMA,
 	.reg_read32		= nvme_pci_reg_read32,
 	.reg_write32		= nvme_pci_reg_write32,
 	.reg_read64		= nvme_pci_reg_read64,
-- 
2.19.0
