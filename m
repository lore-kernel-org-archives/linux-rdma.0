From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx5: Expose correct max_fast_reg_page_list_len
Date: Thu,  3 Mar 2016 13:37:51 +0200
Message-ID: <1457005071-4900-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While documentation indicates that the number of translation
entries per memory key is unlimited, in practice, we can
only fit a finite amount of translation entries in a single
registration wqe (which is log_max_klm_list_size).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 90c5e24..136ed67 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -536,7 +536,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = MLX5_CAP_GEN(mdev, local_ca_ack_delay);
 	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
 	props->max_srq_sge	   = max_rq_sg - 1;
-	props->max_fast_reg_page_list_len = (unsigned int)-1;
+	props->max_fast_reg_page_list_len =
+		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
 	get_atomic_caps(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
