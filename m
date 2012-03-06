From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] net/mlx4: remove redundant maintainance of extended port capabilities
Date: Tue,  6 Mar 2012 15:50:50 +0200
Message-ID: <1331041851-20498-3-git-send-email-ogerlitz@mellanox.com>
References: <1331041851-20498-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331041851-20498-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While doing the work for commit a6f7feae6d "IB/mlx4: pass SMP vendor-specific
attribute MADs to firmware" we realized that the firmware would respond
on all sorts of vendor specific mads. Hence, commit 97285b7817 "mlx4_core:
Add extended port capabilities support" adds redundant code into the driver,
since there's no real reaon to maintain the extended capabilities of the port,
as they can be queried on demand (e.g the FDR10 one). This patch reverts
commit 97285b7817 and removes the check for extended caps from the mlx4_ib
driver port query flow.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c         |   27 ++++++++----------
 drivers/net/ethernet/mellanox/mlx4/main.c |    7 -----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 -
 drivers/net/ethernet/mellanox/mlx4/port.c |   43 -----------------------------
 include/linux/mlx4/device.h               |    5 ---
 5 files changed, 12 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2749f73..5e00eb2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -225,21 +225,18 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 
 	/* If reported active speed is QDR, check if is FDR-10 */
 	if (props->active_speed == IB_SPEED_QDR) {
-		if (to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
-		    MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
-			init_query_mad(in_mad);
-			in_mad->attr_id = MLX4_ATTR_EXTENDED_PORT_INFO;
-			in_mad->attr_mod = cpu_to_be32(port);
-
-			err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
-					   NULL, NULL, in_mad, out_mad);
-			if (err)
-				return err;
+		init_query_mad(in_mad);
+		in_mad->attr_id = MLX4_ATTR_EXTENDED_PORT_INFO;
+		in_mad->attr_mod = cpu_to_be32(port);
 
-			/* Checking LinkSpeedActive for FDR-10 */
-			if (out_mad->data[15] & 0x1)
-				props->active_speed = IB_SPEED_FDR10;
-		}
+		err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
+				   NULL, NULL, in_mad, out_mad);
+		if (err)
+			return err;
+
+		/* Checking LinkSpeedActive for FDR-10 */
+		if (out_mad->data[15] & 0x1)
+			props->active_speed = IB_SPEED_FDR10;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index f057896..f8f8f51 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1363,13 +1363,6 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 					  "with caps = 0\n", port, err);
 			dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
 
-			err = mlx4_check_ext_port_caps(dev, port);
-			if (err)
-				mlx4_warn(dev, "failed to get port %d extended "
-					  "port capabilities support info (%d)."
-					  " Assuming not supported\n",
-					  port, err);
-
 			err = mlx4_SET_PORT(dev, port);
 			if (err) {
 				mlx4_err(dev, "Failed to set port %d, aborting\n",
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index ac2d606..30dc606 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1029,7 +1029,6 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 			    struct mlx4_cmd_mailbox *outbox,
 			    struct mlx4_cmd_info *cmd);
 int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
-int mlx4_check_ext_port_caps(struct mlx4_dev *dev, u8 port);
 
 
 int mlx4_QP_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index f44ae55..51708dd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -590,49 +590,6 @@ int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps)
 	return err;
 }
 
-int mlx4_check_ext_port_caps(struct mlx4_dev *dev, u8 port)
-{
-	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
-	u8 *inbuf, *outbuf;
-	int err, packet_error;
-
-	inmailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(inmailbox))
-		return PTR_ERR(inmailbox);
-
-	outmailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(outmailbox)) {
-		mlx4_free_cmd_mailbox(dev, inmailbox);
-		return PTR_ERR(outmailbox);
-	}
-
-	inbuf = inmailbox->buf;
-	outbuf = outmailbox->buf;
-	memset(inbuf, 0, 256);
-	memset(outbuf, 0, 256);
-	inbuf[0] = 1;
-	inbuf[1] = 1;
-	inbuf[2] = 1;
-	inbuf[3] = 1;
-
-	*(__be16 *) (&inbuf[16]) = MLX4_ATTR_EXTENDED_PORT_INFO;
-	*(__be32 *) (&inbuf[20]) = cpu_to_be32(port);
-
-	err = mlx4_cmd_box(dev, inmailbox->dma, outmailbox->dma, port, 3,
-			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C,
-			   MLX4_CMD_NATIVE);
-
-	packet_error = be16_to_cpu(*(__be16 *) (outbuf + 4));
-
-	dev->caps.ext_port_cap[port] = (!err && !packet_error) ?
-				       MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO
-				       : 0;
-
-	mlx4_free_cmd_mailbox(dev, inmailbox);
-	mlx4_free_cmd_mailbox(dev, outmailbox);
-	return err;
-}
-
 static int mlx4_common_set_port(struct mlx4_dev *dev, int slave, u32 in_mod,
 				u8 op_mod, struct mlx4_cmd_mailbox *inbox)
 {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 4b3fbf1..5397262 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -101,10 +101,6 @@ enum {
 #define MLX4_ATTR_EXTENDED_PORT_INFO	cpu_to_be16(0xff90)
 
 enum {
-	MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO	= 1 <<  0
-};
-
-enum {
 	MLX4_BMME_FLAG_LOCAL_INV	= 1 <<  6,
 	MLX4_BMME_FLAG_REMOTE_INV	= 1 <<  7,
 	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
@@ -314,7 +310,6 @@ struct mlx4_caps {
 	u32			port_mask[MLX4_MAX_PORTS + 1];
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
-	u8			ext_port_cap[MLX4_MAX_PORTS + 1];
 };
 
 struct mlx4_buf_list {
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
