From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 1/5] IB/mlx5: Add create_cq extended command
Date: Thu,  3 Dec 2015 17:44:19 +0200
Message-ID: <1449157463-25313-2-git-send-email-matanb@mellanox.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449157463-25313-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to create a CQ that supports timestamp, mlx5 needs to
support the extended create CQ command with the timestamp flag.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 3ce5cfa7..a9a7921 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -760,6 +760,10 @@ static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
 	mlx5_db_free(dev->mdev, &cq->db);
 }
 
+enum {
+	CQ_CREATE_FLAGS_SUPPORTED = IB_CQ_FLAGS_TIMESTAMP_COMPLETION
+};
+
 struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
@@ -783,6 +787,9 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 	if (entries < 0)
 		return ERR_PTR(-EINVAL);
 
+	if (attr->flags & ~CQ_CREATE_FLAGS_SUPPORTED)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	entries = roundup_pow_of_two(entries + 1);
 	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
 		return ERR_PTR(-EINVAL);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
