From: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Subject: [PATCH] net: ethernet: mellanox: correct page conversion
Date: Thu, 26 Feb 2015 12:59:28 -0600
Message-ID: <1424977168-19523-1-git-send-email-timur@codeaurora.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Current code is assuming that the addresses returned
by dma_alloc_coherent is a logical address. This is
not true on ARM/ARM64 systems. This patch uses
dma_to_phys API to reach to the actual physical address
and then convert to the page pointer.

Signed-off-by: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/alloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net/ethernet/mellanox/mlx4/alloc.c
index 963dd7e..8eca66a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
@@ -634,8 +634,13 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 			pages = kmalloc(sizeof *pages * buf->nbufs, gfp);
 			if (!pages)
 				goto err_free;
-			for (i = 0; i < buf->nbufs; ++i)
-				pages[i] = virt_to_page(buf->page_list[i].buf);
+			for (i = 0; i < buf->nbufs; ++i) {
+				phys_addr_t phys;
+
+				phys = dma_to_phys(&dev->pdev->dev,
+						   buf->page_list[i].map);
+				pages[i] = phys_to_page(phys);
+			}
 			buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP, PAGE_KERNEL);
 			kfree(pages);
 			if (!buf->direct.buf)
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
