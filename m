From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/3] IB/mlx5: Add packet based credit mode support
Date: Fri, 30 Nov 2018 13:22:05 +0200
Message-ID: <20181130112206.19870-3-leon@kernel.org>
References: <20181130112206.19870-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181130112206.19870-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

The device can support two credit modes, message based (default) and
packet based. In order to enable packet based mode, the QP should be
created with special flag that indicates this.

This patch adds support for the new DV QP creation flag that can be used
for RC QPs in order to change the credit mode.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 15 +++++++++++++--
 include/uapi/rdma/mlx5-abi.h         |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4ad493f581de..95652ef8d89b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -462,6 +462,7 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_UNDERLAY			= 1 << 10,
 	MLX5_IB_QP_PCI_WRITE_END_PADDING	= 1 << 11,
 	MLX5_IB_QP_TUNNEL_OFFLOAD		= 1 << 12,
+	MLX5_IB_QP_PACKET_BASED_CREDIT		= 1 << 13,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 369db954edbe..485d3c838bf2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1917,7 +1917,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 					      MLX5_QP_FLAG_BFREG_INDEX |
 					      MLX5_QP_FLAG_TYPE_DCT |
 					      MLX5_QP_FLAG_TYPE_DCI |
-					      MLX5_QP_FLAG_ALLOW_SCATTER_CQE))
+					      MLX5_QP_FLAG_ALLOW_SCATTER_CQE |
+					      MLX5_QP_FLAG_PACKET_BASED_CREDIT_MODE))
 			return -EINVAL;
 
 		err = get_qp_user_index(to_mucontext(pd->uobject->context),
@@ -1953,6 +1954,15 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			qp->flags_en |= MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC;
 		}
 
+		if (ucmd.flags & MLX5_QP_FLAG_PACKET_BASED_CREDIT_MODE) {
+			if (init_attr->qp_type != IB_QPT_RC ||
+				!MLX5_CAP_GEN(dev->mdev, qp_packet_based)) {
+				mlx5_ib_dbg(dev, "packet based credit mode isn't supported\n");
+				return -EOPNOTSUPP;
+			}
+			qp->flags |= MLX5_IB_QP_PACKET_BASED_CREDIT;
+		}
+
 		if (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
 			if (init_attr->qp_type != IB_QPT_UD ||
 			    (MLX5_CAP_GEN(dev->mdev, port_type) !=
@@ -2049,7 +2059,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		MLX5_SET(qpc, qpc, cd_slave_send, 1);
 	if (qp->flags & MLX5_IB_QP_MANAGED_RECV)
 		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
-
+	if (qp->flags & MLX5_IB_QP_PACKET_BASED_CREDIT)
+		MLX5_SET(qpc, qpc, req_e2e_credit_mode, 1);
 	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
 		configure_responder_scat_cqe(init_attr, qpc);
 		configure_requester_scat_cqe(dev, init_attr,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 8fa9f90e2bb1..4af581170f62 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -48,6 +48,7 @@ enum {
 	MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC = 1 << 6,
 	MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC = 1 << 7,
 	MLX5_QP_FLAG_ALLOW_SCATTER_CQE	= 1 << 8,
+	MLX5_QP_FLAG_PACKET_BASED_CREDIT_MODE	= 1 << 9,
 };
 
 enum {
-- 
2.19.1
