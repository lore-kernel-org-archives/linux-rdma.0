From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx4: Fix ib device initialization error flow
Date: Tue, 21 Mar 2017 12:57:05 +0200
Message-ID: <20170321105706.9355-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "# v3 . 4+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

In mlx4_ib_add, procedure mlx4_ib_alloc_eqs is called to allocate EQs.

However, in the mlx4_ib_add error flow, procedure mlx4_ib_free_eqs is not
called to free the allocated EQs.

Fixes: e605b743f33d ("IB/mlx4: Increase the number of vectors (EQs) available for ULPs")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.4+
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fba94df28cf1..c7e6d137c162 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2941,6 +2941,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		mlx4_ib_delete_counters_table(ibdev, &ibdev->counters_table[i]);
 
 err_map:
+	mlx4_ib_free_eqs(dev, ibdev);
 	iounmap(ibdev->uar_map);
 
 err_uar:
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
