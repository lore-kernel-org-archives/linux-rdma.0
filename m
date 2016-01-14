From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/12] net/mlx4_core: Configure mlx4 hardware for mixed RoCE v1/v2 modes
Date: Thu, 14 Jan 2016 17:50:34 +0200
Message-ID: <038a35e9079cdc0cfed2e6f94db880c906beb082.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the hardware supports RoCE v2 (mixed with RoCE v1) mode, we enable
it. This is necessary in order to support RoCE v2.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h | 5 ++++-
 drivers/net/ethernet/mellanox/mlx4/port.c | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 2404c22..7baef52 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -780,7 +780,10 @@ struct mlx4_set_port_general_context {
 	u16 reserved1;
 	u8 v_ignore_fcs;
 	u8 flags;
-	u8 ignore_fcs;
+	union {
+		u8 ignore_fcs;
+		u8 roce_mode;
+	};
 	u8 reserved2;
 	__be16 mtu;
 	u8 pptx;
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 7d63ba9..c4e4116 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -1520,6 +1520,8 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port, int pkey_tbl_sz)
 	return err;
 }
 
+#define SET_PORT_ROCE_2_FLAGS          0x10
+#define MLX4_SET_PORT_ROCE_V1_V2       0x2
 int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx)
 {
@@ -1539,6 +1541,11 @@ int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 	context->pprx = (pprx * (!pfcrx)) << 7;
 	context->pfcrx = pfcrx;
 
+	if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+		context->flags |= SET_PORT_ROCE_2_FLAGS;
+		context->roce_mode |=
+			MLX4_SET_PORT_ROCE_V1_V2 << 4;
+	}
 	in_mod = MLX4_SET_PORT_GENERAL << 8 | port;
 	err = mlx4_cmd(dev, mailbox->dma, in_mod, MLX4_SET_PORT_ETH_OPCODE,
 		       MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
