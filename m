From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: propagate node_description changes down to FW to generate trap 144
Date: Mon, 4 Oct 2010 14:11:34 +0200
Message-ID: <201010041411.34956.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, yaeli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Node Description cannot be changed via MADs (it is read-only).
Until now, it was changed in the driver via sysfs, and the new Node
Description was simply inserted by the driver into MAD responses
(replacing the description returned by FW).

Until now, openibd used the sysfs interface to change the node description
at driver startup. However, that generated a race condition, where OpenSM
could get the FW node description rather than the sysfs description if OpenSM
queried the device before openibd had a chance to enter the new description.

The solution is a new FW command (SET_NODE) which allows passing the
new node description to FW. When this command is invoked, FW issues
a 144 trap to OpenSM.  Upon receiving this trap, OpenSM can query the
node to obtain the new node description -- thus eliminating the effects
of the race.

This patch simply adds invoking the SET_NODE command when a new node
description is entered via sysfs (thus causing trap 144 to be issued
by the FW).

The patch works whether or not the new FW command is available.  If SET_NODE
is not available, things operate as before (i.e., the node description
is changed in the driver, but no trap is issued).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
Roland,

I left the snooping and overwriting the node description as is.
That way, I do not need to test and remember if SET_NODE succeeded, and/or
I do not need to know which FW version introduced SET_NODE.

Since we need to keep the old method (snooping and overwriting) around anyway,
I think it is easier and simpler to keep things as they are, and only use
SET_NODE to generate trap 144.

Please note that I do not generate any errors if SET_NODE fails for any reason,
(including failure to allocate a mailbox) since the node description has been
successfully entered into the driver and is available.

Jack

Index: infiniband/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/main.c	2010-10-04 10:54:50.000000000 +0200
+++ infiniband/drivers/infiniband/hw/mlx4/main.c	2010-10-04 12:25:46.000000000 +0200
@@ -272,14 +272,31 @@ out:
 static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 				 struct ib_device_modify *props)
 {
+	struct mlx4_cmd_mailbox *mailbox;
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
+	mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
+		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A);
+
+	mlx4_free_cmd_mailbox(to_mdev(ibdev)->dev, mailbox);
 
 	return 0;
 }
Index: infiniband/include/linux/mlx4/cmd.h
===================================================================
--- infiniband.orig/include/linux/mlx4/cmd.h	2010-01-28 09:43:01.000000000 +0200
+++ infiniband/include/linux/mlx4/cmd.h	2010-10-04 11:10:27.000000000 +0200
@@ -57,6 +57,7 @@ enum {
 	MLX4_CMD_QUERY_PORT	 = 0x43,
 	MLX4_CMD_SENSE_PORT	 = 0x4d,
 	MLX4_CMD_SET_PORT	 = 0xc,
+	MLX4_CMD_SET_NODE	 = 0x5a,
 	MLX4_CMD_ACCESS_DDR	 = 0x2e,
 	MLX4_CMD_MAP_ICM	 = 0xffa,
 	MLX4_CMD_UNMAP_ICM	 = 0xff9,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
