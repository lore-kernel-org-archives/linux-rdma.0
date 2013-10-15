From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 4/9] IB/mlx5: Initialize mlx5_ib_qp signature related
Date: Tue, 15 Oct 2013 18:38:25 +0300
Message-ID: <1381851510-17290-5-git-send-email-sagig@mellanox.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381851510-17290-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If user requested signature enable we Initialize
relevant mlx5_ib_qp members. we mark the qp as sig_enable
we initiatlize empty sig_err_list, and we increase qp size.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    5 +++++
 drivers/infiniband/hw/mlx5/qp.c      |    7 +++++++
 include/linux/mlx5/qp.h              |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 45d7424..1d5793e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -189,6 +189,11 @@ struct mlx5_ib_qp {
 
 	int			create_type;
 	u32			pa_lkey;
+
+	/* Store signature errors */
+	bool			signature_en;
+	struct list_head	sig_err_list;
+	spinlock_t		sig_err_lock;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 045f8cd..9a8c622 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -734,6 +734,13 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
+	if (init_attr->create_flags == IB_QP_CREATE_SIGNATURE_EN) {
+		init_attr->cap.max_send_wr *= MLX5_SIGNATURE_SQ_MULT;
+		spin_lock_init(&qp->sig_err_lock);
+		INIT_LIST_HEAD(&qp->sig_err_list);
+		qp->signature_en = true;
+	}
+
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
 
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
