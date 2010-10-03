From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: re: mlx4: propagate node_description changes down to FW
Date: Sun, 03 Oct 2010 17:31:11 +0200
Message-ID: <4CA8A1BF.4050305@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jack, 

I just came across this patch of yours which was placed in ofed 1.5.2, I didn't see any track of it 
here @ linux-rdma (any specific reason for that?) - some questions/issues to discuss -

1st and most, (say) for 1k node cluster, is it correct that for each node doing start/restart of the openibd 
service a trap will be sent to opensm and the latter will heavy sweep?! this doesn't sound very much scalable...
have you tested it over large clusters? what was the impact?

Or.

mlx4: propagate node_description changes down to FW.

The Node Description cannot be changed via MADs (it is read-only).
Until now, it was changed in the driver, and the new Node Description
was simply overwritten by the driver on MAD responses.

The node description was modified in the driver by openibd via sysfs.
However, that generated a race condition, where OpenSM could get the
FW node description rather than the overwritten description if OpenSM
queried the device before openibd had a chance to enter the new description.

The solution is a new FW command (SET_NODE) which allows passing the
new node description to FW. When this command is invoked, FW issues
a 144 trap to OpenSM.  Upon receiving this trap, OpenSM initiates a
heavy sweep, thus updating the node description properly -- and eliminating
the race.

This patch works whether or not the new FW command is available.  If SET_NODE
is not available, things work as before.

Fixes FM82320

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Index: ofed_kernel/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/hw/mlx4/main.c	2010-09-27 17:20:54.069787000 +0200
+++ ofed_kernel/drivers/infiniband/hw/mlx4/main.c	2010-09-27 17:21:15.074810000 +0200
@@ -421,14 +421,34 @@ out:
 static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 				 struct ib_device_modify *props)
 {
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+
 	if (mask & ~IB_DEVICE_MODIFY_NODE_DESC)
 		return -EOPNOTSUPP;
 
-	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
-		spin_lock(&to_mdev(ibdev)->sm_lock);
-		memcpy(ibdev->node_desc, props->node_desc, 64);
-		spin_unlock(&to_mdev(ibdev)->sm_lock);
-	}
+	if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
+		return 0;
+
+	spin_lock(&to_mdev(ibdev)->sm_lock);
+	memcpy(ibdev->node_desc, props->node_desc, 64);
+	spin_unlock(&to_mdev(ibdev)->sm_lock);
+
+	/* if possible, pass node desc to FW, so it can generate
+	 * a 144 trap. If cmd fails, just ignore.
+	 */
+	mailbox = mlx4_alloc_cmd_mailbox(to_mdev(ibdev)->dev);
+	if (IS_ERR(mailbox))
+		return 0;
+
+	memset(mailbox->buf, 0, 256);
+	memcpy(mailbox->buf, props->node_desc, 64);
+	err = mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
+		       MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A);
+	if (err)
+		mlx4_ib_dbg("SET_NODE command failed (%d)", err);
+
+	mlx4_free_cmd_mailbox(to_mdev(ibdev)->dev, mailbox);
 
 	return 0;
 }
Index: ofed_kernel/include/linux/mlx4/cmd.h
===================================================================
--- ofed_kernel.orig/include/linux/mlx4/cmd.h	2010-09-27 17:20:40.519054000 +0200
+++ ofed_kernel/include/linux/mlx4/cmd.h	2010-09-27 17:21:15.081799000 +0200
@@ -58,6 +58,7 @@ enum {
 	MLX4_CMD_SENSE_PORT	 = 0x4d,
 	MLX4_CMD_HW_HEALTH_CHECK = 0x50,
 	MLX4_CMD_SET_PORT	 = 0xc,
+	MLX4_CMD_SET_NODE	 = 0x5a,
 	MLX4_CMD_ACCESS_DDR	 = 0x2e,
 	MLX4_CMD_MAP_ICM	 = 0xffa,
 	MLX4_CMD_UNMAP_ICM	 = 0xff9,
Index: ofed_kernel/drivers/net/mlx4/cmd.c
===================================================================
--- ofed_kernel.orig/drivers/net/mlx4/cmd.c	2010-09-27 17:20:32.995814000 +0200
+++ ofed_kernel/drivers/net/mlx4/cmd.c	2010-09-27 17:21:15.088792000 +0200
@@ -242,8 +242,11 @@ static int mlx4_cmd_poll(struct mlx4_dev
 					  __raw_readl(hcr + HCR_OUT_PARAM_OFFSET + 4));
 	stat = be32_to_cpu((__force __be32) __raw_readl(hcr + HCR_STATUS_OFFSET)) >> 24;
 	err = mlx4_status_to_errno(stat);
-	if (err)
-		mlx4_err(dev, "command 0x%x failed: fw status = 0x%x\n", op, stat);
+	if (err) {
+		if (op != MLX4_CMD_SET_NODE || stat != CMD_STAT_BAD_OP)
+			mlx4_err(dev, "command 0x%x failed: fw status = 0x%x\n",
+				 op, stat);
+	}
 
 out:
 	up(&priv->cmd.poll_sem);
@@ -296,8 +299,9 @@ static int mlx4_cmd_wait(struct mlx4_dev
 
 	err = context->result;
 	if (err) {
-		mlx4_err(dev, "command 0x%x failed: fw status = 0x%x\n",
-			 op, context->fw_status);
+		if (op != MLX4_CMD_SET_NODE || context->fw_status != CMD_STAT_BAD_OP)
+			mlx4_err(dev, "command 0x%x failed: fw status = 0x%x\n",
+				 op, context->fw_status);
 		goto out;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
