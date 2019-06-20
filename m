From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 28/28] memremap: Remove PCI P2PDMA page memory type
Date: Thu, 20 Jun 2019 10:12:40 -0600
Message-ID: <20190620161240.22738-29-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

There are no more users of MEMORY_DEVICE_PCI_P2PDMA and
is_pci_p2pdma_page(), so remove them.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/memremap.h |  5 -----
 include/linux/mm.h       | 13 -------------
 2 files changed, 18 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 1732dea030b2..2e5d9fcd4d69 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -51,16 +51,11 @@ struct vmem_altmap {
  * wakeup event whenever a page is unpinned and becomes idle. This
  * wakeup is used to coordinate physical address space management (ex:
  * fs truncate/hole punch) vs pinned pages (ex: device dma).
- *
- * MEMORY_DEVICE_PCI_P2PDMA:
- * Device memory residing in a PCI BAR intended for use with Peer-to-Peer
- * transactions.
  */
 enum memory_type {
 	MEMORY_DEVICE_PRIVATE = 1,
 	MEMORY_DEVICE_PUBLIC,
 	MEMORY_DEVICE_FS_DAX,
-	MEMORY_DEVICE_PCI_P2PDMA,
 };
 
 /*
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd0b5f4e1e45..f5fa9ec440e3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -966,19 +966,6 @@ static inline bool is_device_public_page(const struct page *page)
 		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
 }
 
-#ifdef CONFIG_PCI_P2PDMA
-static inline bool is_pci_p2pdma_page(const struct page *page)
-{
-	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
-}
-#else /* CONFIG_PCI_P2PDMA */
-static inline bool is_pci_p2pdma_page(const struct page *page)
-{
-	return false;
-}
-#endif /* CONFIG_PCI_P2PDMA */
-
 #else /* CONFIG_DEV_PAGEMAP_OPS */
 static inline void dev_pagemap_get_ops(void)
 {
-- 
2.20.1
