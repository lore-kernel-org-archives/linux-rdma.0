From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 06/12] net/mlx4_core: Add support for RoCE v2 entropy
Date: Thu, 14 Jan 2016 17:50:37 +0200
Message-ID: <84e0fe497030299b218057074e291e904e01a56e.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In RoCE v2 we need to choose a source UDP port, we do so by using
entropy over the source and dest QPNs.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/qp.c | 26 ++++++++++++++++++++++++++
 include/linux/mlx4/qp.h                 | 13 ++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 168823d..d1cd9c3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -167,6 +167,12 @@ static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 		context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 	}
 
+	if ((cur_state == MLX4_QP_STATE_RTR) &&
+	    (new_state == MLX4_QP_STATE_RTS) &&
+	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
+		context->roce_entropy =
+			cpu_to_be16(mlx4_qp_roce_entropy(dev, qp->qpn));
+
 	*(__be32 *) mailbox->buf = cpu_to_be32(optpar);
 	memcpy(mailbox->buf + 8, context, sizeof *context);
 
@@ -921,3 +927,23 @@ int mlx4_qp_to_ready(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx4_qp_to_ready);
+
+u16 mlx4_qp_roce_entropy(struct mlx4_dev *dev, u32 qpn)
+{
+	struct mlx4_qp_context context;
+	struct mlx4_qp qp;
+	int err;
+
+	qp.qpn = qpn;
+	err = mlx4_qp_query(dev, &qp, &context);
+	if (!err) {
+		u32 dest_qpn = be32_to_cpu(context.remote_qpn) & 0xffffff;
+		u16 folded_dst = folded_qp(dest_qpn);
+		u16 folded_src = folded_qp(qpn);
+
+		return (dest_qpn != qpn) ?
+			((folded_dst ^ folded_src) | 0xC000) :
+			folded_src | 0xC000;
+	}
+	return 0xdead;
+}
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index fe052e2..cdf110d 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -204,7 +204,8 @@ struct mlx4_qp_context {
 	u32			reserved1;
 	__be32			next_send_psn;
 	__be32			cqn_send;
-	u32			reserved2[2];
+	__be16                  roce_entropy;
+	__be16                  reserved2[3];
 	__be32			last_acked_psn;
 	__be32			ssn;
 	__be32			params2;
@@ -487,4 +488,14 @@ static inline struct mlx4_qp *__mlx4_qp_lookup(struct mlx4_dev *dev, u32 qpn)
 
 void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp);
 
+static inline u16 folded_qp(u32 q)
+{
+	u16 res;
+
+	res = ((q & 0xff) ^ ((q & 0xff0000) >> 16)) | (q & 0xff00);
+	return res;
+}
+
+u16 mlx4_qp_roce_entropy(struct mlx4_dev *dev, u32 qpn);
+
 #endif /* MLX4_QP_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
