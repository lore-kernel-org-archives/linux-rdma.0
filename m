From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 07/10] IB/mlx5: Set network_hdr_type upon RoCE responder completion
Date: Wed, 23 Dec 2015 15:17:51 +0200
Message-ID: <1450876674-21695-8-git-send-email-matanb@mellanox.com>
References: <1450876674-21695-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450876674-21695-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When handling a responder completion, if the link layer is Ethernet,
set the work completion network_hdr_type field according to CQE's
info and the IB_WC_WITH_NETWORK_HDR_TYPE flag.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 17 +++++++++++++++++
 include/linux/mlx5/device.h     |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 3dfd287..3ce5cfa7 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -171,6 +171,7 @@ enum {
 static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			     struct mlx5_ib_qp *qp)
 {
+	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
 	struct mlx5_ib_srq *srq;
 	struct mlx5_ib_wq *wq;
@@ -236,6 +237,22 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	} else {
 		wc->pkey_index = 0;
 	}
+
+	if (ll != IB_LINK_LAYER_ETHERNET)
+		return;
+
+	switch (wc->sl & 0x3) {
+	case MLX5_CQE_ROCE_L3_HEADER_TYPE_GRH:
+		wc->network_hdr_type = RDMA_NETWORK_IB;
+		break;
+	case MLX5_CQE_ROCE_L3_HEADER_TYPE_IPV6:
+		wc->network_hdr_type = RDMA_NETWORK_IPV6;
+		break;
+	case MLX5_CQE_ROCE_L3_HEADER_TYPE_IPV4:
+		wc->network_hdr_type = RDMA_NETWORK_IPV4;
+		break;
+	}
+	wc->wc_flags |= IB_WC_WITH_NETWORK_HDR_TYPE;
 }
 
 static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0b473cb..84aa7e0 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -629,6 +629,12 @@ enum {
 };
 
 enum {
+	MLX5_CQE_ROCE_L3_HEADER_TYPE_GRH	= 0x0,
+	MLX5_CQE_ROCE_L3_HEADER_TYPE_IPV6	= 0x1,
+	MLX5_CQE_ROCE_L3_HEADER_TYPE_IPV4	= 0x2,
+};
+
+enum {
 	CQE_L2_OK	= 1 << 0,
 	CQE_L3_OK	= 1 << 1,
 	CQE_L4_OK	= 1 << 2,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
