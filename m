From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/mlx5: Exposing modify CQ callback to uverbs layer
Date: Thu, 19 Oct 2017 08:35:21 +0300
Message-ID: <20171019053524.11135-4-leon@kernel.org>
References: <20171019053524.11135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019053524.11135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Exposed mlx5_ib_modify_cq to be called from ib device
verb list.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c   | 3 +++
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 include/linux/mlx5/cq.h           | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 01b218a3c277..18705cbcdc8c 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1149,6 +1149,9 @@ int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 	if (!MLX5_CAP_GEN(dev->mdev, cq_moderation))
 		return -ENOSYS;
 
+	if (cq_period > MLX5_MAX_CQ_PERIOD)
+		return -EINVAL;
+
 	err = mlx5_core_modify_cq_moderation(dev->mdev, &mcq->mcq,
 					     cq_period, cq_count);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c44dd0896f80..da4c577d653c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4020,7 +4020,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP)	|
-		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP);
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP)	|
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index cc718e245b1e..6be357b219ec 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -128,6 +128,9 @@ enum {
 	CQE_SIZE_128_PAD = 2,
 };
 
+#define MLX5_MAX_CQ_PERIOD (BIT(__mlx5_bit_sz(cqc, cq_period)) - 1)
+#define MLX5_MAX_CQ_COUNT (BIT(__mlx5_bit_sz(cqc, cq_max_count)) - 1)
+
 static inline int cqe_sz_to_mlx_sz(u8 size, int padding_128_en)
 {
 	return padding_128_en ? CQE_SIZE_128_PAD :
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
