From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 3/9] IB/mlx4: Fix create CQ error flow
Date: Thu, 10 Nov 2016 11:30:55 +0200
Message-ID: <1478770261-5775-4-git-send-email-leon@kernel.org>
References: <1478770261-5775-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, if ib_copy_to_udata fails, the CQ
won't be deleted from the radix tree and the HW (HW2SW).

Fixes: 225c7b1feef1 ('IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 1ea686b..6a0fec3 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -253,11 +253,14 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 	if (context)
 		if (ib_copy_to_udata(udata, &cq->mcq.cqn, sizeof (__u32))) {
 			err = -EFAULT;
-			goto err_dbmap;
+			goto err_cq_free;
 		}
 
 	return &cq->ibcq;
 
+err_cq_free:
+	mlx4_cq_free(dev->dev, &cq->mcq);
+
 err_dbmap:
 	if (context)
 		mlx4_ib_db_unmap_user(to_mucontext(context), &cq->db);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
