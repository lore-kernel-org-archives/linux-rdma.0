From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 04/10] IB/mlx5: Initialize mlx5_ib_qp signature related
Date: Mon, 16 Dec 2013 13:26:24 +0200
Message-ID: <1387193190-8837-5-git-send-email-sagig@mellanox.com>
References: <1387193190-8837-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387193190-8837-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If user requested signature enable we Initialize
relevant mlx5_ib_qp members. we mark the qp as sig_enable
and we check if wqe_size will fit compound REG_SIG_MR work
request (UMR + 2 x SET_PSV wqes), if computed wqe_size is
smaller we align wqe_size to MLX5_SIG_WQE_SIZE.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    3 +++
 drivers/infiniband/hw/mlx5/qp.c      |   10 ++++++++--
 include/linux/mlx5/qp.h              |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 43e0497..62b9e93 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -189,6 +189,9 @@ struct mlx5_ib_qp {
 
 	int			create_type;
 	u32			pa_lkey;
+
+	/* Store signature errors */
+	bool			signature_en;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7c6b4ba..07aa3ca 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -254,8 +254,11 @@ static int calc_send_wqe(struct ib_qp_init_attr *attr)
 	}
 
 	size += attr->cap.max_send_sge * sizeof(struct mlx5_wqe_data_seg);
-
-	return ALIGN(max_t(int, inl_size, size), MLX5_SEND_WQE_BB);
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN &&
+	    ALIGN(max_t(int, inl_size, size), MLX5_SEND_WQE_BB) < MLX5_SIG_WQE_SIZE)
+			return MLX5_SIG_WQE_SIZE;
+	else
+		return ALIGN(max_t(int, inl_size, size), MLX5_SEND_WQE_BB);
 }
 
 static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
@@ -282,6 +285,9 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 		sizeof(struct mlx5_wqe_inline_seg);
 	attr->cap.max_inline_data = qp->max_inline_data;
 
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN)
+		qp->signature_en = true;
+
 	wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size);
 	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
 	if (qp->sq.wqe_cnt > dev->mdev.caps.max_wqes) {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d9e3eac..711094c 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -37,6 +37,7 @@
 #include <linux/mlx5/driver.h>
 
 #define MLX5_INVALID_LKEY	0x100
+#define MLX5_SIG_WQE_SIZE (MLX5_SEND_WQE_BB * 5)
 
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
