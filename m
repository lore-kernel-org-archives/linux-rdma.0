From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V1 3/3] IB/mlx5: Add driver cross-channel support
Date: Sun, 20 Dec 2015 12:16:11 +0200
Message-ID: <1450606571-15877-4-git-send-email-leon@leon.nu>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450606571-15877-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support of cross-channel functionality to mlx5
driver. This includes ability to ignore overrun for CQ
which intended for cross-channel, export device capability and
configure the QP to be sync master/slave queues.

The cross-channel enabled QP supports combination of
three possible properties:
* WQE processing on the receive queue of this QP
* WQE processing on the send queue of this QP
* WQE are supported on the send queue

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      |  7 ++++-
 drivers/infiniband/hw/mlx5/main.c    |  3 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 16 +++++++++++
 drivers/infiniband/hw/mlx5/qp.c      | 54 +++++++++++++++++++++++++++++-------
 include/linux/mlx5/qp.h              |  3 ++
 5 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 3dfd287..c363b71 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -760,7 +760,7 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 	int eqn;
 	int err;
 
-	if (attr->flags)
+	if (check_cq_create_flags(attr->flags))
 		return ERR_PTR(-EINVAL);
 
 	if (entries < 0)
@@ -779,6 +779,7 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 	spin_lock_init(&cq->lock);
 	cq->resize_buf = NULL;
 	cq->resize_umem = NULL;
+	cq->create_flags = attr->flags;
 
 	if (context) {
 		err = create_cq_user(dev, udata, context, cq, entries,
@@ -796,6 +797,10 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 
 	cq->cqe_size = cqe_size;
 	cqb->ctx.cqe_sz_flags = cqe_sz_to_mlx_sz(cqe_size) << 5;
+
+	if (cq->create_flags & IB_CQ_FLAGS_IGNORE_OVERRUN)
+		cqb->ctx.cqe_sz_flags |= (1 << 1);
+
 	cqb->ctx.log_sz_usr_page = cpu_to_be32((ilog2(entries) << 24) | index);
 	err = mlx5_vector2eqn(dev->mdev, vector, &eqn, &irqn);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bdd60a6..be0d994 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -300,6 +300,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->odp_caps = dev->odp_caps;
 #endif
 
+	if (MLX5_CAP_GEN(mdev, cd))
+		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6333472..fdbd761 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -85,6 +85,10 @@ enum mlx5_ib_mad_ifc_flags {
 	MLX5_MAD_IFC_NET_VIEW		= 4,
 };
 
+enum {
+	MLX5_CROSS_CHANNEL_UUAR         = 0,
+};
+
 struct mlx5_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct list_head	db_page_list;
@@ -242,6 +246,9 @@ struct mlx5_ib_cq_buf {
 enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK     = 1 << 0,
 	MLX5_IB_QP_SIGNATURE_HANDLING           = 1 << 1,
+	MLX5_IB_QP_CROSS_CHANNEL		= 1 << 2,
+	MLX5_IB_QP_MANAGED_SEND			= 1 << 3,
+	MLX5_IB_QP_MANAGED_RECV			= 1 << 4,
 };
 
 struct mlx5_umr_wr {
@@ -284,6 +291,7 @@ struct mlx5_ib_cq {
 	struct mlx5_ib_cq_buf  *resize_buf;
 	struct ib_umem	       *resize_umem;
 	int			cqe_size;
+	u32			create_flags;
 };
 
 struct mlx5_ib_srq {
@@ -662,4 +670,12 @@ static inline int is_qp1(enum ib_qp_type qp_type)
 #define MLX5_MAX_UMR_SHIFT 16
 #define MLX5_MAX_UMR_PAGES (1 << MLX5_MAX_UMR_SHIFT)
 
+static inline u32 check_cq_create_flags(u32 flags)
+{
+	/*
+	 * It returns non-zero value for unsupported CQ
+	 * create flags, otherwise it returns zero.
+	 */
+	return (flags & ~IB_CQ_FLAGS_IGNORE_OVERRUN);
+}
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 307bdbc..c18bf42 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -615,18 +615,23 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	/*
 	 * TBD: should come from the verbs when we have the API
 	 */
-	uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_HIGH);
-	if (uuarn < 0) {
-		mlx5_ib_dbg(dev, "failed to allocate low latency UUAR\n");
-		mlx5_ib_dbg(dev, "reverting to medium latency\n");
-		uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_MEDIUM);
+	if (qp->flags & MLX5_IB_QP_CROSS_CHANNEL)
+		/* In CROSS_CHANNEL CQ and QP must use the same UAR */
+		uuarn = MLX5_CROSS_CHANNEL_UUAR;
+	else {
+		uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_HIGH);
 		if (uuarn < 0) {
-			mlx5_ib_dbg(dev, "failed to allocate medium latency UUAR\n");
-			mlx5_ib_dbg(dev, "reverting to high latency\n");
-			uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_LOW);
+			mlx5_ib_dbg(dev, "failed to allocate low latency UUAR\n");
+			mlx5_ib_dbg(dev, "reverting to medium latency\n");
+			uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_MEDIUM);
 			if (uuarn < 0) {
-				mlx5_ib_warn(dev, "uuar allocation failed\n");
-				return uuarn;
+				mlx5_ib_dbg(dev, "failed to allocate medium latency UUAR\n");
+				mlx5_ib_dbg(dev, "reverting to high latency\n");
+				uuarn = alloc_uuar(&context->uuari, MLX5_IB_LATENCY_CLASS_LOW);
+				if (uuarn < 0) {
+					mlx5_ib_warn(dev, "uuar allocation failed\n");
+					return uuarn;
+				}
 			}
 		}
 	}
@@ -880,6 +885,21 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		}
 	}
 
+	if (init_attr->create_flags &
+			(IB_QP_CREATE_CROSS_CHANNEL |
+			 IB_QP_CREATE_MANAGED_SEND |
+			 IB_QP_CREATE_MANAGED_RECV)) {
+		if (!MLX5_CAP_GEN(mdev, cd)) {
+			mlx5_ib_dbg(dev, "cross-channel isn't supported\n");
+			return -EINVAL;
+		}
+		if (init_attr->create_flags & IB_QP_CREATE_CROSS_CHANNEL)
+			qp->flags |= MLX5_IB_QP_CROSS_CHANNEL;
+		if (init_attr->create_flags & IB_QP_CREATE_MANAGED_SEND)
+			qp->flags |= MLX5_IB_QP_MANAGED_SEND;
+		if (init_attr->create_flags & IB_QP_CREATE_MANAGED_RECV)
+			qp->flags |= MLX5_IB_QP_MANAGED_RECV;
+	}
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
 
@@ -954,6 +974,13 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (qp->flags & MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK)
 		in->ctx.flags_pd |= cpu_to_be32(MLX5_QP_BLOCK_MCAST);
 
+	if (qp->flags & MLX5_IB_QP_CROSS_CHANNEL)
+		in->ctx.params2 |= cpu_to_be32(MLX5_QP_BIT_CC_MASTER);
+	if (qp->flags & MLX5_IB_QP_MANAGED_SEND)
+		in->ctx.params2 |= cpu_to_be32(MLX5_QP_BIT_CC_SLAVE_SEND);
+	if (qp->flags & MLX5_IB_QP_MANAGED_RECV)
+		in->ctx.params2 |= cpu_to_be32(MLX5_QP_BIT_CC_SLAVE_RECV);
+
 	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
 		int rcqe_sz;
 		int scqe_sz;
@@ -3110,6 +3137,13 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	if (qp->flags & MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK)
 		qp_init_attr->create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
 
+	if (qp->flags & MLX5_IB_QP_CROSS_CHANNEL)
+		qp_init_attr->create_flags |= IB_QP_CREATE_CROSS_CHANNEL;
+	if (qp->flags & MLX5_IB_QP_MANAGED_SEND)
+		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_SEND;
+	if (qp->flags & MLX5_IB_QP_MANAGED_RECV)
+		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_RECV;
+
 	qp_init_attr->sq_sig_type = qp->sq_signal_bits & MLX5_WQE_CTRL_CQ_UPDATE ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index f079fb1..511e03b 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -130,6 +130,9 @@ enum {
 	MLX5_QP_BIT_RWE				= 1 << 14,
 	MLX5_QP_BIT_RAE				= 1 << 13,
 	MLX5_QP_BIT_RIC				= 1 <<	4,
+	MLX5_QP_BIT_CC_SLAVE_RECV		= 1 <<  2,
+	MLX5_QP_BIT_CC_SLAVE_SEND		= 1 <<  1,
+	MLX5_QP_BIT_CC_MASTER			= 1 <<  0
 };
 
 enum {
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
