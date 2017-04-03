From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/10] IB/mlx5: Fix UMR size calculation
Date: Mon,  3 Apr 2017 13:06:33 +0300
Message-ID: <20170403100640.3332-4-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Translation table updates of large UMR may require multiple post send
operations. The last operations can be in various lengths, but current
code set them to be the same length.

Fixes: 7d0cc6edcc70 ('IB/mlx5: Add MR cache for large UMR regions')
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1f09e11fa694..9a74260e9899 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1045,8 +1045,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	for (pages_mapped = 0;
 	     pages_mapped < pages_to_map && !err;
 	     pages_mapped += pages_iter, idx += pages_iter) {
+		npages = min_t(int, pages_iter, pages_to_map - pages_mapped);
 		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
-		npages = populate_xlt(mr, idx, pages_iter, xlt,
+		npages = populate_xlt(mr, idx, npages, xlt,
 				      page_shift, size, flags);
 
 		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
