From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC v1 04/10] IB/mlx5: Initialize mlx5_ib_qp signature related
Date: Mon, 28 Oct 2013 16:26:10 +0200
Message-ID: <1382970376-13776-5-git-send-email-sagig@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382970376-13776-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If user requested signature enable we Initialize
relevant mlx5_ib_qp members. we mark the qp as sig_enable
we initiatlize empty sig_err_list, and we increase qp size.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    3 +++
 drivers/infiniband/hw/mlx5/qp.c      |    5 +++++
 include/linux/mlx5/qp.h              |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 45d7424..758f0e1 100644
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
index 045f8cdb..c80122e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -734,6 +734,11 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
+	if (init_attr->create_flags == IB_QP_CREATE_SIGNATURE_EN) {
+		init_attr->cap.max_send_wr *= MLX5_SIGNATURE_SQ_MULT;
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
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
