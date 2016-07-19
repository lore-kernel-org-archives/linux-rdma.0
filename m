From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 1/3] net/mlx4: Add diagnostic counters capability bit
Date: Tue, 19 Jul 2016 20:54:56 +0300
Message-ID: <1468950898-9674-2-git-send-email-leon@kernel.org>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468950898-9674-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a bit that indicates if the firmware supports per port
diagnostic counters.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 4 ++++
 include/linux/mlx4/device.h             | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index e970945..90a28ab 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -721,6 +721,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_RSVD_LKEY_OFFSET		0x98
 #define QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET		0xa0
 #define QUERY_DEV_CAP_ETH_BACKPL_OFFSET		0x9c
+#define QUERY_DEV_CAP_DIAG_RPRT_PER_PORT	0x9c
 #define QUERY_DEV_CAP_FW_REASSIGN_MAC		0x9d
 #define QUERY_DEV_CAP_VXLAN			0x9e
 #define QUERY_DEV_CAP_MAD_DEMUX_OFFSET		0xb0
@@ -935,6 +936,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_ETH_BACKPL_AN_REP;
 	if (field32 & (1 << 7))
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_RECOVERABLE_ERROR_EVENT;
+	MLX4_GET(field32, outbox, QUERY_DEV_CAP_DIAG_RPRT_PER_PORT);
+	if (field32 & (1 << 17))
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_FW_REASSIGN_MAC);
 	if (field & 1<<6)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_REASSIGN_MAC_EN;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index d46a0e7..7ff690b 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -220,6 +220,7 @@ enum {
 	MLX4_DEV_CAP_FLAG2_LB_SRC_CHK           = 1ULL << 32,
 	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1ULL <<  33,
 	MLX4_DEV_CAP_FLAG2_DMFS_UC_MC_SNIFFER   = 1ULL <<  34,
+	MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT	= 1ULL <<  35,
 };
 
 enum {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
