From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/7] IB/mlx5: Fix out-of-bound access
Date: Wed, 18 Jan 2017 14:10:30 +0200
Message-ID: <20170118121036.32642-2-leon@kernel.org>
References: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118121036.32642-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When we initialize buffer to create SRQ in kernel,
the number of pages was less than actually used in
following mlx5_fill_page_array().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.10+
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 6f4397e..7cb145f 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -165,8 +165,6 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	int err;
 	int i;
 	struct mlx5_wqe_srq_next_seg *next;
-	int page_shift;
-	int npages;

 	err = mlx5_db_alloc(dev->mdev, &srq->db);
 	if (err) {
@@ -179,7 +177,6 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 		err = -ENOMEM;
 		goto err_db;
 	}
-	page_shift = srq->buf.page_shift;

 	srq->head    = 0;
 	srq->tail    = srq->msrq.max - 1;
@@ -191,10 +188,8 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 			cpu_to_be16((i + 1) & (srq->msrq.max - 1));
 	}

-	npages = DIV_ROUND_UP(srq->buf.npages, 1 << (page_shift - PAGE_SHIFT));
-	mlx5_ib_dbg(dev, "buf_size %d, page_shift %d, npages %d, calc npages %d\n",
-		    buf_size, page_shift, srq->buf.npages, npages);
-	in->pas = mlx5_vzalloc(sizeof(*in->pas) * npages);
+	mlx5_ib_dbg(dev, "srq->buf.page_shift = %d\n", srq->buf.page_shift);
+	in->pas = mlx5_vzalloc(sizeof(*in->pas) * srq->buf.npages);
 	if (!in->pas) {
 		err = -ENOMEM;
 		goto err_buf;
@@ -208,7 +203,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	}
 	srq->wq_sig = !!srq_signature;

-	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
+	in->log_page_size = srq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type == IB_SRQT_XRC)
 		in->user_index = MLX5_IB_DEFAULT_UIDX;
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
