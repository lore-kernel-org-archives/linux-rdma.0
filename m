From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] net/mlx5_core: Warn on unsupported events of QP/RQ/SQ
Date: Thu, 10 Dec 2015 21:54:32 +0200
Message-ID: <1449777273-9219-6-git-send-email-majd@mellanox.com>
References: <1449777273-9219-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449777273-9219-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When an event arrives on QP/RQ/SQ, check whether it's supported,
and WARN_ON otherwise.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 52 ++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 27fed69..0b803a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -68,6 +68,52 @@ void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common)
 		complete(&common->free);
 }
 
+static u64 qp_allowed_event_types(void)
+{
+	u64 mask;
+
+	mask = MLX5_EVENT_TYPE_PATH_MIG |
+	       MLX5_EVENT_TYPE_COMM_EST |
+	       MLX5_EVENT_TYPE_SQ_DRAINED |
+	       MLX5_EVENT_TYPE_SRQ_LAST_WQE |
+	       MLX5_EVENT_TYPE_WQ_CATAS_ERROR |
+	       MLX5_EVENT_TYPE_PATH_MIG_FAILED |
+	       MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR |
+	       MLX5_EVENT_TYPE_WQ_ACCESS_ERROR;
+
+	return mask;
+}
+
+static u64 rq_allowed_event_types(void)
+{
+	u64 mask;
+
+	mask = MLX5_EVENT_TYPE_SRQ_LAST_WQE |
+	       MLX5_EVENT_TYPE_WQ_CATAS_ERROR;
+
+	return mask;
+}
+
+static u64 sq_allowed_event_types(void)
+{
+	return MLX5_EVENT_TYPE_WQ_CATAS_ERROR;
+}
+
+static bool is_event_type_allowed(int rsc_type, int event_type)
+{
+	switch (rsc_type) {
+	case MLX5_EVENT_QUEUE_TYPE_QP:
+		return !!(BIT(event_type) & qp_allowed_event_types());
+	case MLX5_EVENT_QUEUE_TYPE_RQ:
+		return !!(BIT(event_type) & rq_allowed_event_types());
+	case MLX5_EVENT_QUEUE_TYPE_SQ:
+		return !!(BIT(event_type) & sq_allowed_event_types());
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
 void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 {
 	struct mlx5_core_rsc_common *common = mlx5_get_rsc(dev, rsn);
@@ -76,6 +122,12 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	if (!common)
 		return;
 
+	if (!is_event_type_allowed((rsn >> 24), event_type)) {
+		mlx5_core_warn(dev, "event 0x%.2x is not allowed on resource 0x%.8x\n",
+			       event_type, rsn);
+		return;
+	}
+
 	switch (common->res) {
 	case MLX5_RES_QP:
 	case MLX5_RES_RQ:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
