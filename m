From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 10/13] nvme-pci: Add support for P2P memory in requests
Date: Tue, 25 Sep 2018 10:22:28 -0600
Message-ID: <20180925162231.4354-11-logang@deltatee.com>
References: <20180925162231.4354-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180925162231.4354-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For P2P requests, we must use the pci_p2pmem_map_sg() function
instead of the dma_map_sg functions.

With that, we can then indicate PCI_P2P support in the request queue.
For this, we create an NVME_F_PCI_P2P flag which tells the core to
set QUEUE_FLAG_PCI_P2P in the request queue.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
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
