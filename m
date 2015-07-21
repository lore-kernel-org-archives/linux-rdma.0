From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx5: Expose correct page_size_cap in device attributes
Date: Tue, 21 Jul 2015 14:40:12 +0300
Message-ID: <1437478812-9650-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Should be all the page sizes that are supported by the
device.

Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 725f857..a90ef7a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -212,6 +212,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int err = -ENOMEM;
 	int max_rq_sg;
 	int max_sq_sg;
+	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
 
 	if (uhw->inlen || uhw->outlen)
 		return -EINVAL;
@@ -264,7 +265,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->hw_ver		   = mdev->pdev->revision;
 
 	props->max_mr_size	   = ~0ull;
-	props->page_size_cap	   = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	props->page_size_cap	   = ~(min_page_size - 1);
 	props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
 	props->max_qp_wr	   = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
 	max_rq_sg =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
