From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/12] IB/mlx4: Support modify_qp for RoCE v2
Date: Thu, 14 Jan 2016 17:50:39 +0200
Message-ID: <be8e4af916bd4df88d587178e9400ab444d81ee2.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support modify_qp for RoCE v2, we need to set
the gid_type in the QP context.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 37 ++++++++++++++++++++++++++++++++++---
 include/linux/mlx4/qp.h         |  2 +-
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index bb30a0f..cb1fa8d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1509,6 +1509,24 @@ static int create_qp_lb_counter(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 	return 0;
 }
 
+enum {
+	MLX4_QPC_ROCE_MODE_1 = 0,
+	MLX4_QPC_ROCE_MODE_2 = 2,
+	MLX4_QPC_ROCE_MODE_UNDEFINED = 0xff
+};
+
+static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
+{
+	switch (gid_type) {
+	case IB_GID_TYPE_ROCE:
+		return MLX4_QPC_ROCE_MODE_1;
+	case IB_GID_TYPE_ROCE_UDP_ENCAP:
+		return MLX4_QPC_ROCE_MODE_2;
+	default:
+		return MLX4_QPC_ROCE_MODE_UNDEFINED;
+	}
+}
+
 static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
@@ -1655,9 +1673,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		u16 vlan = 0xffff;
 		u8 smac[ETH_ALEN];
 		int status = 0;
+		int is_eth = rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
+			attr->ah_attr.ah_flags & IB_AH_GRH;
 
-		if (rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
-		    attr->ah_attr.ah_flags & IB_AH_GRH) {
+		if (is_eth) {
 			int index = attr->ah_attr.grh.sgid_index;
 
 			status = ib_get_cached_gid(ibqp->device, port_num,
@@ -1679,6 +1698,18 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 
 		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
 			   MLX4_QP_OPTPAR_SCHED_QUEUE);
+
+		if (is_eth &&
+		    (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR)) {
+			u8 qpc_roce_mode = gid_type_to_qpc(gid_attr.gid_type);
+
+			if (qpc_roce_mode == MLX4_QPC_ROCE_MODE_UNDEFINED) {
+				err = -EINVAL;
+				goto out;
+			}
+			context->rlkey_roce_mode |= (qpc_roce_mode << 6);
+		}
+
 	}
 
 	if (attr_mask & IB_QP_TIMEOUT) {
@@ -1850,7 +1881,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		sqd_event = 0;
 
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
-		context->rlkey |= (1 << 4);
+		context->rlkey_roce_mode |= (1 << 4);
 
 	/*
 	 * Before passing a kernel QP to the HW, make sure that the
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index cdf110d..587cdf9 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -194,7 +194,7 @@ struct mlx4_qp_context {
 	u8			mtu_msgmax;
 	u8			rq_size_stride;
 	u8			sq_size_stride;
-	u8			rlkey;
+	u8			rlkey_roce_mode;
 	__be32			usr_page;
 	__be32			local_qpn;
 	__be32			remote_qpn;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
