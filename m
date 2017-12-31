From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/mthca: Use zeroing memory allocator than allocator/memset
Date: Sun, 31 Dec 2017 18:04:10 +0530
Message-ID: <1514723650-5990-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index c6fe89d..2a41ed7 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -623,13 +623,12 @@ int mthca_alloc_db(struct mthca_dev *dev, enum mthca_db_type type,
 	page = dev->db_tab->page + end;
 
 alloc:
-	page->db_rec = dma_alloc_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
-					  &page->mapping, GFP_KERNEL);
+	page->db_rec = dma_zalloc_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
+					   &page->mapping, GFP_KERNEL);
 	if (!page->db_rec) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(page->db_rec, 0, MTHCA_ICM_PAGE_SIZE);
 
 	ret = mthca_MAP_ICM_page(dev, page->mapping,
 				 mthca_uarc_virt(dev, &dev->driver_uar, i));
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
