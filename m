From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/4] IB/mlx5: Assign SRQ type earlier
Date: Sun, 27 Nov 2016 15:18:20 +0200
Message-ID: <1480252702-8005-3-git-send-email-leon@kernel.org>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move the SRQ type assignment to be before actually using it
in create_srq_user() and in create_srq_kernel() functions.

Fixes: af1ba291c5e4 ('{net, IB}/mlx5: Refactor internal SRQ API')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 3857dbd..729b069 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -282,6 +282,7 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 	mlx5_ib_dbg(dev, "desc_size 0x%x, req wr 0x%x, srq size 0x%x, max_gs 0x%x, max_avail_gather 0x%x\n",
 		    desc_size, init_attr->attr.max_wr, srq->msrq.max, srq->msrq.max_gs,
 		    srq->msrq.max_avail_gather);
+	in.type = init_attr->srq_type;
 
 	if (pd->uobject)
 		err = create_srq_user(pd, srq, &in, udata, buf_size);
@@ -294,7 +295,6 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 		goto err_srq;
 	}
 
-	in.type = init_attr->srq_type;
 	in.log_size = ilog2(srq->msrq.max);
 	in.wqe_shift = srq->msrq.wqe_shift - 4;
 	if (srq->wq_sig)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
