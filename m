From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/4] IB/mlx5: Support scatter to CQE for DC transport type
Date: Sun,  7 Oct 2018 12:03:35 +0300
Message-ID: <20181007090337.21037-3-leon@kernel.org>
References: <20181007090337.21037-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181007090337.21037-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

Scatter to CQE is a HW offload that saves PCI writes by scattering the
payload to the CQE.
This patch extends already existing functionality to support DC
transport type.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c      |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 drivers/infiniband/hw/mlx5/qp.c      | 71 ++++++++++++++++++++++++++----------
 3 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index dae30b6478bf..a41519dc8d3a 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1460,7 +1460,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 	return err;
 }
 
-int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq)
+int mlx5_ib_get_cqe_size(struct ib_cq *ibcq)
 {
 	struct mlx5_ib_cq *cq;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e5ec3fdaa4d5..f52dfed1395d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1127,7 +1127,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			  int page_shift, __be64 *pas, int access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
-int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq);
+int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
 int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
 int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index fa8e5dc65cb4..bae48bdf281c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1053,7 +1053,8 @@ static u32 get_rx_type(struct mlx5_ib_qp *qp, struct ib_qp_init_attr *attr)
 
 static int is_connected(enum ib_qp_type qp_type)
 {
-	if (qp_type == IB_QPT_RC || qp_type == IB_QPT_UC)
+	if (qp_type == IB_QPT_RC || qp_type == IB_QPT_UC ||
+	    qp_type == MLX5_IB_QPT_DCI)
 		return 1;
 
 	return 0;
@@ -1684,6 +1685,49 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return err;
 }
 
+static void configure_responder_scat_cqe(struct ib_qp_init_attr *init_attr,
+					 void *qpc)
+{
+	int rcqe_sz;
+
+	if (init_attr->qp_type == MLX5_IB_QPT_DCI)
+		return;
+
+	rcqe_sz = mlx5_ib_get_cqe_size(init_attr->recv_cq);
+
+	if (rcqe_sz == 128) {
+		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
+		return;
+	}
+
+	if (init_attr->qp_type != MLX5_IB_QPT_DCT)
+		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA32_CQE);
+}
+
+static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
+					 struct ib_qp_init_attr *init_attr,
+					 void *qpc)
+{
+	enum ib_qp_type qpt = init_attr->qp_type;
+	int scqe_sz;
+
+	if (qpt == IB_QPT_UC || qpt == IB_QPT_UD)
+		return;
+
+	if (init_attr->sq_sig_type != IB_SIGNAL_ALL_WR)
+		return;
+
+	scqe_sz = mlx5_ib_get_cqe_size(init_attr->send_cq);
+	if (scqe_sz == 128) {
+		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA64_CQE);
+		return;
+	}
+
+	if (init_attr->qp_type != MLX5_IB_QPT_DCI ||
+	    MLX5_CAP_GEN(dev->mdev, dc_req_scat_data_cqe))
+		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
+}
+
 static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, struct mlx5_ib_qp *qp)
@@ -1787,7 +1831,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			return err;
 
 		qp->wq_sig = !!(ucmd.flags & MLX5_QP_FLAG_SIGNATURE);
-		qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
+		if (MLX5_CAP_GEN(dev->mdev, sctr_data_cqe))
+			qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
 		if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS) {
 			if (init_attr->qp_type != IB_QPT_RAW_PACKET ||
 			    !tunnel_offload_supported(mdev)) {
@@ -1911,23 +1956,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
 
 	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
-		int rcqe_sz;
-		int scqe_sz;
-
-		rcqe_sz = mlx5_ib_get_cqe_size(dev, init_attr->recv_cq);
-		scqe_sz = mlx5_ib_get_cqe_size(dev, init_attr->send_cq);
-
-		if (rcqe_sz == 128)
-			MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
-		else
-			MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA32_CQE);
-
-		if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) {
-			if (scqe_sz == 128)
-				MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA64_CQE);
-			else
-				MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
-		}
+		configure_responder_scat_cqe(init_attr, qpc);
+		configure_requester_scat_cqe(dev, init_attr, qpc);
 	}
 
 	if (qp->rq.wqe_cnt) {
@@ -2302,6 +2332,9 @@ static struct ib_qp *mlx5_ib_create_dct(struct ib_pd *pd,
 	MLX5_SET64(dctc, dctc, dc_access_key, ucmd->access_key);
 	MLX5_SET(dctc, dctc, user_index, uidx);
 
+	if (ucmd->flags & MLX5_QP_FLAG_SCATTER_CQE)
+		configure_responder_scat_cqe(attr, dctc);
+
 	qp->state = IB_QPS_RESET;
 
 	return &qp->ibqp;
-- 
2.14.4
