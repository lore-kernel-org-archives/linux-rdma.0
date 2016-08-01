From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 2/7] IB/mlx5: Support registration and invalidate operations on the UMR QP
Date: Mon,  1 Aug 2016 09:57:28 +0300
Message-ID: <1470034653-9097-3-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Currently the UMR QP only supports UMR work requests. There is nothing
preventing it from also supporting fast registration and local
invalidate operations. This would allow internal driver operations to
use the fast registration API internally, without having to create an RC
QP.

Use the ib_create_qp instead of mlx5_ib_create_qp in order to initialize
the PD field of the new UMR QP.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c |  6 +---
 drivers/infiniband/hw/mlx5/qp.c   | 71 +++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b48ad85315dc..f41254f3689a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2023,16 +2023,12 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	init_attr->cap.max_send_sge = 1;
 	init_attr->qp_type = MLX5_IB_QPT_REG_UMR;
 	init_attr->port_num = 1;
-	qp = mlx5_ib_create_qp(pd, init_attr, NULL);
+	qp = ib_create_qp(pd, init_attr);
 	if (IS_ERR(qp)) {
 		mlx5_ib_dbg(dev, "Couldn't create sync UMR QP\n");
 		ret = PTR_ERR(qp);
 		goto error_3;
 	}
-	qp->device     = &dev->ib_dev;
-	qp->real_qp    = qp;
-	qp->uobject    = NULL;
-	qp->qp_type    = MLX5_IB_QPT_REG_UMR;
 
 	attr->qp_state = IB_QPS_INIT;
 	attr->port_num = 1;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ce0a7ab35a22..861ec1f6a20b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3237,8 +3237,8 @@ static int set_psv_wr(struct ib_sig_domain *domain,
 	return 0;
 }
 
-static int set_reg_wr(struct mlx5_ib_qp *qp,
-		      struct ib_reg_wr *wr,
+static int set_reg_wr(struct mlx5_ib_qp *qp, struct ib_reg_wr *wr,
+		      unsigned int idx, struct mlx5_wqe_ctrl_seg *ctrl,
 		      void **seg, int *size)
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
@@ -3266,10 +3266,15 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	*seg += sizeof(struct mlx5_wqe_data_seg);
 	*size += (sizeof(struct mlx5_wqe_data_seg) / 16);
 
+	qp->sq.wr_data[idx] = IB_WR_REG_MR;
+	ctrl->imm = cpu_to_be32(wr->key);
+
 	return 0;
 }
 
-static void set_linv_wr(struct mlx5_ib_qp *qp, void **seg, int *size)
+static void set_linv_wr(struct mlx5_ib_qp *qp, struct ib_send_wr *wr,
+			unsigned int idx, struct mlx5_wqe_ctrl_seg *ctrl,
+			void **seg, int *size)
 {
 	set_linv_umr_seg(*seg);
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
@@ -3281,6 +3286,9 @@ static void set_linv_wr(struct mlx5_ib_qp *qp, void **seg, int *size)
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	if (unlikely((*seg == qp->sq.qend)))
 		*seg = mlx5_get_send_wqe(qp, 0);
+
+	qp->sq.wr_data[idx] = IB_WR_LOCAL_INV;
+	ctrl->imm = cpu_to_be32(wr->ex.invalidate_rkey);
 }
 
 static void dump_wqe(struct mlx5_ib_qp *qp, int idx, int size_16)
@@ -3476,17 +3484,14 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 			case IB_WR_LOCAL_INV:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
-				qp->sq.wr_data[idx] = IB_WR_LOCAL_INV;
-				ctrl->imm = cpu_to_be32(wr->ex.invalidate_rkey);
-				set_linv_wr(qp, &seg, &size);
+				set_linv_wr(qp, wr, idx, ctrl, &seg, &size);
 				num_sge = 0;
 				break;
 
 			case IB_WR_REG_MR:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
-				qp->sq.wr_data[idx] = IB_WR_REG_MR;
-				ctrl->imm = cpu_to_be32(reg_wr(wr)->key);
-				err = set_reg_wr(qp, reg_wr(wr), &seg, &size);
+				err = set_reg_wr(qp, reg_wr(wr), idx, ctrl,
+						 &seg, &size);
 				if (err) {
 					*bad_wr = wr;
 					goto out;
@@ -3613,23 +3618,45 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 			break;
 		case MLX5_IB_QPT_REG_UMR:
-			if (wr->opcode != MLX5_IB_WR_UMR) {
+			switch (wr->opcode) {
+			case MLX5_IB_WR_UMR:
+				qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
+				ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
+				set_reg_umr_segment(seg, wr);
+				seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
+				size += sizeof(struct mlx5_wqe_umr_ctrl_seg)
+					/ 16;
+				if (unlikely((seg == qend)))
+					seg = mlx5_get_send_wqe(qp, 0);
+				set_reg_mkey_segment(seg, wr);
+				seg += sizeof(struct mlx5_mkey_seg);
+				size += sizeof(struct mlx5_mkey_seg) / 16;
+				if (unlikely((seg == qend)))
+					seg = mlx5_get_send_wqe(qp, 0);
+				break;
+
+			case IB_WR_LOCAL_INV:
+				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+				set_linv_wr(qp, wr, idx, ctrl, &seg, &size);
+				num_sge = 0;
+				break;
+
+			case IB_WR_REG_MR:
+				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+				err = set_reg_wr(qp, reg_wr(wr), idx, ctrl,
+						 &seg, &size);
+				if (err) {
+					*bad_wr = wr;
+					goto out;
+				}
+				num_sge = 0;
+				break;
+
+			default:
 				err = -EINVAL;
 				mlx5_ib_warn(dev, "bad opcode\n");
 				goto out;
 			}
-			qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
-			ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
-			set_reg_umr_segment(seg, wr);
-			seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
-			size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
-			if (unlikely((seg == qend)))
-				seg = mlx5_get_send_wqe(qp, 0);
-			set_reg_mkey_segment(seg, wr);
-			seg += sizeof(struct mlx5_mkey_seg);
-			size += sizeof(struct mlx5_mkey_seg) / 16;
-			if (unlikely((seg == qend)))
-				seg = mlx5_get_send_wqe(qp, 0);
 			break;
 
 		default:
-- 
1.7.11.2
