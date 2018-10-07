From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/4] IB/mlx5: Allow scatter to CQE without global signaled WRs
Date: Sun,  7 Oct 2018 12:03:37 +0300
Message-ID: <20181007090337.21037-5-leon@kernel.org>
References: <20181007090337.21037-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181007090337.21037-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

Requester scatter to CQE is restricted to QPs configured to signal
all WRs.

This patch adds ability to enable scatter to cqe (force enable)
in the requester without sig_all, for users who do not want all WRs
signaled but rather just the ones whose data found in the CQE.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 14 +++++++++++---
 include/uapi/rdma/mlx5-abi.h    |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 17c4b6641933..4397b5f27125 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1706,15 +1706,20 @@ static void configure_responder_scat_cqe(struct ib_qp_init_attr *init_attr,
 
 static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
 					 struct ib_qp_init_attr *init_attr,
+					 struct mlx5_ib_create_qp *ucmd,
 					 void *qpc)
 {
 	enum ib_qp_type qpt = init_attr->qp_type;
 	int scqe_sz;
+	bool allow_scat_cqe = 0;
 
 	if (qpt == IB_QPT_UC || qpt == IB_QPT_UD)
 		return;
 
-	if (init_attr->sq_sig_type != IB_SIGNAL_ALL_WR)
+	if (ucmd)
+		allow_scat_cqe = ucmd->flags & MLX5_QP_FLAG_ALLOW_SCATTER_CQE;
+
+	if (!allow_scat_cqe && init_attr->sq_sig_type != IB_SIGNAL_ALL_WR)
 		return;
 
 	scqe_sz = mlx5_ib_get_cqe_size(init_attr->send_cq);
@@ -1735,7 +1740,8 @@ static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
 		MLX5_QP_FLAG_TUNNEL_OFFLOADS	| \
 		MLX5_QP_FLAG_BFREG_INDEX	| \
 		MLX5_QP_FLAG_TYPE_DCT		| \
-		MLX5_QP_FLAG_TYPE_DCI))
+		MLX5_QP_FLAG_TYPE_DCI		| \
+		MLX5_QP_FLAG_ALLOW_SCATTER_CQE))
 
 static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
@@ -1969,7 +1975,9 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
 		configure_responder_scat_cqe(init_attr, qpc);
-		configure_requester_scat_cqe(dev, init_attr, qpc);
+		configure_requester_scat_cqe(dev, init_attr,
+					     (pd && pd->uobject) ? &ucmd : NULL,
+					     qpc);
 	}
 
 	if (qp->rq.wqe_cnt) {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 6056625237cf..8fa9f90e2bb1 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -47,6 +47,7 @@ enum {
 	MLX5_QP_FLAG_TYPE_DCI		= 1 << 5,
 	MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC = 1 << 6,
 	MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC = 1 << 7,
+	MLX5_QP_FLAG_ALLOW_SCATTER_CQE	= 1 << 8,
 };
 
 enum {
-- 
2.14.4
