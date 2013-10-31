From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 3/6] IB/mlx5: Fix list_del of empty list
Date: Thu, 31 Oct 2013 15:26:33 +0200
Message-ID: <1383225996-14828-4-git-send-email-eli@mellanox.com>
References: <1383225996-14828-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383225996-14828-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For archs with pages size of 4K, when the chunk is freed, fwp is not in the
list so avoid attempting to delete it.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index ba816c2..37b6ad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -229,7 +229,8 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr)
 	set_bit(n, &fwp->bitmask);
 	if (fwp->free_count == MLX5_NUM_4K_IN_PAGE) {
 		rb_erase(&fwp->rb_node, &dev->priv.page_root);
-		list_del(&fwp->list);
+		if (fwp->free_count != 1)
+			list_del(&fwp->list);
 		dma_unmap_page(&dev->pdev->dev, addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
 		__free_page(fwp->page);
 		kfree(fwp);
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
