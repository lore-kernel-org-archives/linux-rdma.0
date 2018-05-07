From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 1/6] net/mlx5: remove some extraneous spaces in indentations
Date: Mon,  7 May 2018 16:52:59 -0700
Message-ID: <20180507235304.25085-2-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Colin Ian King <colin.king@canonical.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several lines where there is an extraneous space causing
indentation misalignment. Remove them.

Cleans up Cocconelle warnings:

./drivers/net/ethernet/mellanox/mlx5/core/qp.c:409:3-18: code aligned
with following code on line 410
./drivers/net/ethernet/mellanox/mlx5/core/qp.c:415:3-18: code aligned
with following code on line 416
./drivers/net/ethernet/mellanox/mlx5/core/qp.c:421:3-18: code aligned
with following code on line 422

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 02d6c5b5d502..4ca07bfb6b14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -407,21 +407,21 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 	case MLX5_CMD_OP_RST2INIT_QP:
 		if (MBOX_ALLOC(mbox, rst2init_qp))
 			return -ENOMEM;
-		 MOD_QP_IN_SET_QPC(rst2init_qp, mbox->in, opcode, qpn,
-				   opt_param_mask, qpc);
-		 break;
+		MOD_QP_IN_SET_QPC(rst2init_qp, mbox->in, opcode, qpn,
+				  opt_param_mask, qpc);
+		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		if (MBOX_ALLOC(mbox, init2rtr_qp))
 			return -ENOMEM;
-		 MOD_QP_IN_SET_QPC(init2rtr_qp, mbox->in, opcode, qpn,
-				   opt_param_mask, qpc);
-		 break;
+		MOD_QP_IN_SET_QPC(init2rtr_qp, mbox->in, opcode, qpn,
+				  opt_param_mask, qpc);
+		break;
 	case MLX5_CMD_OP_RTR2RTS_QP:
 		if (MBOX_ALLOC(mbox, rtr2rts_qp))
 			return -ENOMEM;
-		 MOD_QP_IN_SET_QPC(rtr2rts_qp, mbox->in, opcode, qpn,
-				   opt_param_mask, qpc);
-		 break;
+		MOD_QP_IN_SET_QPC(rtr2rts_qp, mbox->in, opcode, qpn,
+				  opt_param_mask, qpc);
+		break;
 	case MLX5_CMD_OP_RTS2RTS_QP:
 		if (MBOX_ALLOC(mbox, rts2rts_qp))
 			return -ENOMEM;
-- 
2.14.3
