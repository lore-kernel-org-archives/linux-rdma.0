From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 04/10] IB/mlx5: Initialize mlx5_ib_qp signature related
Date: Thu,  7 Nov 2013 17:54:02 +0200
Message-ID: <1383839648-19000-5-git-send-email-sagig@mellanox.com>
References: <1383839648-19000-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383839648-19000-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If user requested signature enable we Initialize
relevant mlx5_ib_qp members. we mark the qp as sig_enable
and we increase the effective SQ size, but still
limit the user max_send_wr to original size computed.

issue: 333508
Change-Id: I72c303f407fc8181139371d4c0a7e7e7550043e0
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    3 +++
 drivers/infiniband/hw/mlx5/qp.c      |   16 ++++++++++++----
 include/linux/mlx5/qp.h              |    1 +
 3 files changed, 16 insertions(+), 4 deletions(-)

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
index 7c6b4ba..f61e93c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -263,6 +263,7 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 {
 	int wqe_size;
 	int wq_size;
+	int eff_wq_size;
 
 	if (!attr->cap.max_send_wr)
 		return 0;
@@ -283,7 +284,14 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	attr->cap.max_inline_data = qp->max_inline_data;
 
 	wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size);
-	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN) {
+		eff_wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size *
+						 MLX5_SIGNATURE_SQ_MULT);
+		qp->signature_en = true;
+	} else {
+		eff_wq_size = wq_size;
+	}
+	qp->sq.wqe_cnt = eff_wq_size / MLX5_SEND_WQE_BB;
 	if (qp->sq.wqe_cnt > dev->mdev.caps.max_wqes) {
 		mlx5_ib_dbg(dev, "wqe count(%d) exceeds limits(%d)\n",
 			    qp->sq.wqe_cnt, dev->mdev.caps.max_wqes);
@@ -291,10 +299,10 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	}
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
 	qp->sq.max_gs = attr->cap.max_send_sge;
-	qp->sq.max_post = wq_size / wqe_size;
-	attr->cap.max_send_wr = qp->sq.max_post;
+	qp->sq.max_post = eff_wq_size / wqe_size;
+	attr->cap.max_send_wr = wq_size / wqe_size;
 
-	return wq_size;
+	return eff_wq_size;
 }
 
 static int set_user_buf_size(struct mlx5_ib_dev *dev,
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d9e3eac..174805c 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -37,6 +37,7 @@
 #include <linux/mlx5/driver.h>
 
 #define MLX5_INVALID_LKEY	0x100
+#define MLX5_SIGNATURE_SQ_MULT	3
 
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
