From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/9] net/mlx4_core: Directly expose fields of DMFS HW rule control segment
Date: Wed, 24 Apr 2013 16:58:47 +0300
Message-ID: <1366811932-28199-5-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some of struct mlx4_net_trans_rule_hw_ctrl fields were packed into u32
and accessed through bit field operations. Expose and access them
directly as u8 or u16.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c |   14 +++++++-------
 include/linux/mlx4/device.h              |    4 +++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 3cfd372..07712f9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -656,15 +656,15 @@ static void trans_rule_ctrl_to_hw(struct mlx4_net_trans_rule *ctrl,
 		[MLX4_FS_MC_SNIFFER]	= 0x5,
 	};
 
-	u32 dw = 0;
+	u8 flags = 0;
 
-	dw = ctrl->queue_mode == MLX4_NET_TRANS_Q_LIFO ? 1 : 0;
-	dw |= ctrl->exclusive ? (1 << 2) : 0;
-	dw |= ctrl->allow_loopback ? (1 << 3) : 0;
-	dw |= __promisc_mode[ctrl->promisc_mode] << 8;
-	dw |= ctrl->priority << 16;
+	flags = ctrl->queue_mode == MLX4_NET_TRANS_Q_LIFO ? 1 : 0;
+	flags |= ctrl->exclusive ? (1 << 2) : 0;
+	flags |= ctrl->allow_loopback ? (1 << 3) : 0;
 
-	hw->ctrl = cpu_to_be32(dw);
+	hw->flags = flags;
+	hw->type = __promisc_mode[ctrl->promisc_mode];
+	hw->prio = cpu_to_be16(ctrl->priority);
 	hw->port = ctrl->port;
 	hw->qpn = cpu_to_be32(ctrl->qpn);
 }
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index a69bda7..08e5bc1 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -964,7 +964,9 @@ struct mlx4_net_trans_rule {
 };
 
 struct mlx4_net_trans_rule_hw_ctrl {
-	__be32 ctrl;
+	__be16 prio;
+	u8 type;
+	u8 flags;
 	u8 rsvd1;
 	u8 funcid;
 	u8 vep;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
