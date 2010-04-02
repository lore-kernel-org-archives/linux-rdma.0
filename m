From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] IB/mthca: use the dma state API instead of the pci
 equivalents
Date: Fri, 2 Apr 2010 13:29:39 +0900
Message-ID: <20100402132502L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The DMA API is preferred.

No functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_allocator.c |    8 ++++----
 drivers/infiniband/hw/mthca/mthca_eq.c        |    6 +++---
 drivers/infiniband/hw/mthca/mthca_provider.h  |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index c5ccc2d..b4e0cf4 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -211,7 +211,7 @@ int mthca_buf_alloc(struct mthca_dev *dev, int size, int max_direct,
 		if (!buf->direct.buf)
 			return -ENOMEM;
 
-		pci_unmap_addr_set(&buf->direct, mapping, t);
+		dma_unmap_addr_set(&buf->direct, mapping, t);
 
 		memset(buf->direct.buf, 0, size);
 
@@ -251,7 +251,7 @@ int mthca_buf_alloc(struct mthca_dev *dev, int size, int max_direct,
 				goto err_free;
 
 			dma_list[i] = t;
-			pci_unmap_addr_set(&buf->page_list[i], mapping, t);
+			dma_unmap_addr_set(&buf->page_list[i], mapping, t);
 
 			clear_page(buf->page_list[i].buf);
 		}
@@ -289,12 +289,12 @@ void mthca_buf_free(struct mthca_dev *dev, int size, union mthca_buf *buf,
 
 	if (is_direct)
 		dma_free_coherent(&dev->pdev->dev, size, buf->direct.buf,
-				  pci_unmap_addr(&buf->direct, mapping));
+				  dma_unmap_addr(&buf->direct, mapping));
 	else {
 		for (i = 0; i < (size + PAGE_SIZE - 1) / PAGE_SIZE; ++i)
 			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
 					  buf->page_list[i].buf,
-					  pci_unmap_addr(&buf->page_list[i],
+					  dma_unmap_addr(&buf->page_list[i],
 							 mapping));
 		kfree(buf->page_list);
 	}
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8c31fa3..4bb25bc 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -503,7 +503,7 @@ static int mthca_create_eq(struct mthca_dev *dev,
 			goto err_out_free_pages;
 
 		dma_list[i] = t;
-		pci_unmap_addr_set(&eq->page_list[i], mapping, t);
+		dma_unmap_addr_set(&eq->page_list[i], mapping, t);
 
 		clear_page(eq->page_list[i].buf);
 	}
@@ -578,7 +578,7 @@ static int mthca_create_eq(struct mthca_dev *dev,
 		if (eq->page_list[i].buf)
 			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
 					  eq->page_list[i].buf,
-					  pci_unmap_addr(&eq->page_list[i],
+					  dma_unmap_addr(&eq->page_list[i],
 							 mapping));
 
 	mthca_free_mailbox(dev, mailbox);
@@ -628,7 +628,7 @@ static void mthca_free_eq(struct mthca_dev *dev,
 	for (i = 0; i < npages; ++i)
 		pci_free_consistent(dev->pdev, PAGE_SIZE,
 				    eq->page_list[i].buf,
-				    pci_unmap_addr(&eq->page_list[i], mapping));
+				    dma_unmap_addr(&eq->page_list[i], mapping));
 
 	kfree(eq->page_list);
 	mthca_free_mailbox(dev, mailbox);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.h b/drivers/infiniband/hw/mthca/mthca_provider.h
index 90f4c4d..596acc4 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.h
+++ b/drivers/infiniband/hw/mthca/mthca_provider.h
@@ -46,7 +46,7 @@
 
 struct mthca_buf_list {
 	void *buf;
-	DECLARE_PCI_UNMAP_ADDR(mapping)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 };
 
 union mthca_buf {
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
