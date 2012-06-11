From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 25/29] net/mlx4_core: Adjustments to SET_PORT for SRIOV-IB
Date: Mon, 11 Jun 2012 13:46:06 +0300
Message-ID: <1339411570-4689-26-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Slave may not set the IS_SM capability for the port.
2. No DEV_MGR in multifunc mode.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/port.c |   10 ++++++++++
 include/linux/mlx4/device.h               |    5 +++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 90dc475..43c2fce 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -683,6 +683,16 @@ static int mlx4_common_set_port(struct mlx4_dev *dev, int slave, u32 in_mod,
 		new_cap_mask = ((__be32 *) inbox->buf)[1];
 	}
 
+	/* slave may not set the IS_SM capability for the port */
+	if (slave != dev->caps.function &&
+	    (be32_to_cpu(new_cap_mask) & MLX4_PORT_CAP_IS_SM))
+		return -EINVAL;
+
+	/* NO DEV_MGR in multifunc mode */
+	if (mlx4_is_mfunc(dev) &&
+	    (be32_to_cpu(new_cap_mask) & MLX4_PORT_CAP_DEV_MGMT_SUP))
+		return -EINVAL;
+
 	agg_cap_mask = 0;
 	slave_cap_mask =
 		priv->mfunc.master.slave_state[slave].ib_cap_mask[port];
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8fae22f..5127b68 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -53,6 +53,11 @@ enum {
 };
 
 enum {
+	MLX4_PORT_CAP_IS_SM	= 1 << 1,
+	MLX4_PORT_CAP_DEV_MGMT_SUP = 1 << 19,
+};
+
+enum {
 	MLX4_MAX_PORTS		= 2,
 	MLX4_MAX_PORT_PKEYS	= 128
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
