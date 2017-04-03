From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 02/10] IB/mlx5: Fix function updating xlt emergency path
Date: Mon,  3 Apr 2017 13:06:32 +0300
Message-ID: <20170403100640.3332-3-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In memory shortage path we fall back to use spare buffer.
mlx5_ib_update_xlt() called from ib_uverbs_reg_mr when ibmr.ucontext
not initialized yet.

Scenario how to test it:
1. trigger memory exhaustion so __get_free_pages(GFP_KERNEL, 4) will fail
2. register MR
3. there should be no kernel oops

Fixes: 7d0cc6edcc70 ('IB/mlx5: Add MR cache for large UMR regions')
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b8f9382a8b7d..1f09e11fa694 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1009,7 +1009,7 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	}
 
 	if (!xlt) {
-		uctx = to_mucontext(mr->ibmr.uobject->context);
+		uctx = to_mucontext(mr->ibmr.pd->uobject->context);
 		mlx5_ib_warn(dev, "Using XLT emergency buffer\n");
 		size = PAGE_SIZE;
 		xlt = (void *)uctx->upd_xlt_page;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
