From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/mlx5: Fix mlx5_ib_alloc_mr error flow
Date: Tue, 26 Dec 2017 11:20:20 +0200
Message-ID: <20171226092020.8106-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ibmr.device is being set only after ib_alloc_mr() is
(successfully) complete. Therefore, in case mlx5_core_create_mkey()
return with error, the error flow calls mlx5_free_priv_descs()
which uses ibmr.device (which doesn't exist yet), causing
NULL dereference and gets the system into kernel panic.

To fix this, the IB device should be given to mr struct in earlier
stage (e.g. prior to calling mlx5_core_create_mkey()).

Fixes: 8a187ee52b04 ("IB/mlx5: Support the new memory registration API")
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ee0ee1f9994b..d109fe8290a7 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1637,6 +1637,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	MLX5_SET(mkc, mkc, access_mode, mr->access_mode);
 	MLX5_SET(mkc, mkc, umr_en, 1);

+	mr->ibmr.device = pd->device;
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmkey, in, inlen);
 	if (err)
 		goto err_destroy_psv;
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
