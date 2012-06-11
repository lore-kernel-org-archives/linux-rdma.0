From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 01/29] net/mlx4_core: Pass an invalid PCI id number to VFs
Date: Mon, 11 Jun 2012 13:45:42 +0300
Message-ID: <1339411570-4689-2-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, VFs have 0 in their dev->caps.function field.
This is a valid pci id (usually of the PF).

Pass an invalid pci id to the VF via QUERY_FW, to make sure that
if the value gets accessed in the VF driver, it will not be valid.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |   10 +++++++---
 include/linux/mlx4/device.h             |    2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 9c83bb8..4281ce0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -881,11 +881,12 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 		((fw_ver & 0xffff0000ull) >> 16) |
 		((fw_ver & 0x0000ffffull) << 16);
 
+	MLX4_GET(lg, outbox, QUERY_FW_PPF_ID);
+	dev->caps.function = lg;
+
 	if (mlx4_is_slave(dev))
 		goto out;
 
-	MLX4_GET(lg, outbox, QUERY_FW_PPF_ID);
-	dev->caps.function = lg;
 
 	MLX4_GET(cmd_if_rev, outbox, QUERY_FW_CMD_IF_REV_OFFSET);
 	if (cmd_if_rev < MLX4_COMMAND_INTERFACE_MIN_REV ||
@@ -966,9 +967,12 @@ int mlx4_QUERY_FW_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		return err;
 
-	/* for slaves, zero out everything except FW version */
+	/* for slaves, set pci PPF ID to invalid and zero out everything
+	 * else except FW version */
 	outbuf[0] = outbuf[1] = 0;
 	memset(&outbuf[8], 0, QUERY_FW_OUT_SIZE - 8);
+	outbuf[QUERY_FW_PPF_ID] = MLX4_INVALID_SLAVE_ID;
+
 	return 0;
 }
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6a8f002..8eadf0f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -534,6 +534,8 @@ struct mlx4_init_port_param {
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
 			((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE))
 
+#define MLX4_INVALID_SLAVE_ID	0xFF
+
 static inline int mlx4_is_master(struct mlx4_dev *dev)
 {
 	return dev->flags & MLX4_FLAG_MASTER;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
