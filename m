From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx5: remove some extraneous spaces in indentations
Date: Mon,  9 Apr 2018 13:43:36 +0100
Message-ID: <20180409124336.29274-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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
2.15.1
