From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 11/25] IB/mlx5: Set uid as part of SQ commands
Date: Mon, 17 Sep 2018 14:04:04 +0300
Message-ID: <20180917110418.18937-12-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of SQ commands so that the firmware can manage the
SQ object in a secured way.

The uid for the destroy command is set by mlx5_core.

This will enable using an SQ that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 31c69da7ccdf..24370635008e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1088,7 +1088,7 @@ static void destroy_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 
 static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 				   struct mlx5_ib_sq *sq, void *qpin,
-				   struct ib_pd *pd)
+				   struct ib_pd *pd, u16 uid)
 {
 	struct mlx5_ib_ubuffer *ubuffer = &sq->ubuffer;
 	__be64 *pas;
@@ -1116,6 +1116,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 		goto err_umem;
 	}
 
+	MLX5_SET(create_sq_in, in, uid, uid);
 	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 	MLX5_SET(sqc, sqc, flush_in_error_en, 1);
 	if (MLX5_CAP_ETH(dev->mdev, multi_pkt_send_wqe))
@@ -1336,7 +1337,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			return err;
 
-		err = create_raw_packet_qp_sq(dev, sq, in, pd);
+		err = create_raw_packet_qp_sq(dev, sq, in, pd, uid);
 		if (err)
 			goto err_destroy_tis;
 
@@ -2885,7 +2886,8 @@ static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
 				   struct mlx5_ib_sq *sq,
 				   int new_state,
-				   const struct mlx5_modify_raw_qp_param *raw_qp_param)
+				   const struct mlx5_modify_raw_qp_param *raw_qp_param,
+				   u16 uid)
 {
 	struct mlx5_ib_qp *ibqp = sq->base.container_mibqp;
 	struct mlx5_rate_limit old_rl = ibqp->rl;
@@ -2902,6 +2904,7 @@ static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
 	if (!in)
 		return -ENOMEM;
 
+	MLX5_SET(modify_sq_in, in, uid, uid);
 	MLX5_SET(modify_sq_in, in, sq_state, sq->state);
 
 	sqc = MLX5_ADDR_OF(modify_sq_in, in, ctx);
@@ -3019,7 +3022,8 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				return err;
 		}
 
-		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state, raw_qp_param);
+		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state,
+					       raw_qp_param, uid);
 	}
 
 	return 0;
-- 
2.14.4
