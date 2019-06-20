From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 04/28] block: Never bounce dma-direct bios
Date: Thu, 20 Jun 2019 10:12:16 -0600
Message-ID: <20190620161240.22738-5-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

It is expected the creator of the dma-direct bio will ensure the
target device can access the DMA address it's creating bios for.
It's also not possible to bounce a dma-direct bio seeing the block
layer doesn't have any way to access the underlying data behind
the DMA address.

Thus, never bounce dma-direct bios.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/bounce.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bounce.c b/block/bounce.c
index f8ed677a1bf7..17e020a40cca 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -367,6 +367,14 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	if (!bio_has_data(*bio_orig))
 		return;
 
+	/*
+	 * For DMA direct bios, Upper layers are expected to ensure
+	 * the device in question can access the DMA addresses. So
+	 * it never makes sense to bounce a DMA direct bio.
+	 */
+	if (bio_is_dma_direct(*bio_orig))
+		return;
+
 	/*
 	 * for non-isa bounce case, just check if the bounce pfn is equal
 	 * to or bigger than the highest pfn in the system -- in that case,
-- 
2.20.1
