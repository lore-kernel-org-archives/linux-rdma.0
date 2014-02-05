From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 4/5] IB/mlx4: Do IBoE GID table resets in port based manner
Date: Wed,  5 Feb 2014 15:13:01 +0200
Message-ID: <1391605982-4348-5-git-send-email-ogerlitz@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

The IBoE code used to reset the GID table did it for all Ethernet ports
of the device. Since the whole architecture of generating GIDs and responding
to events is port based, this is inefficient and can lead to wrong content
in the GID table. Change the reset flow to act accordingly.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 00a1651..85fbb41 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1408,7 +1408,6 @@ static void reset_gids_task(struct work_struct *work)
 	struct mlx4_cmd_mailbox *mailbox;
 	union ib_gid *gids;
 	int err;
-	int i;
 	struct mlx4_dev	*dev = gw->dev->dev;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
@@ -1420,18 +1419,16 @@ static void reset_gids_task(struct work_struct *work)
 	gids = mailbox->buf;
 	memcpy(gids, gw->gids, sizeof(gw->gids));
 
-	for (i = 1; i < gw->dev->num_ports + 1; i++) {
-		if (mlx4_ib_port_link_layer(&gw->dev->ib_dev, i) ==
-					    IB_LINK_LAYER_ETHERNET) {
-			err = mlx4_cmd(dev, mailbox->dma,
-				       MLX4_SET_PORT_GID_TABLE << 8 | i,
-				       1, MLX4_CMD_SET_PORT,
-				       MLX4_CMD_TIME_CLASS_B,
-				       MLX4_CMD_WRAPPED);
-			if (err)
-				pr_warn(KERN_WARNING
-					"set port %d command failed\n", i);
-		}
+	if (mlx4_ib_port_link_layer(&gw->dev->ib_dev, gw->port) ==
+				    IB_LINK_LAYER_ETHERNET) {
+		err = mlx4_cmd(dev, mailbox->dma,
+			       MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
+			       1, MLX4_CMD_SET_PORT,
+			       MLX4_CMD_TIME_CLASS_B,
+			       MLX4_CMD_WRAPPED);
+		if (err)
+			pr_warn(KERN_WARNING
+				"set port %d command failed\n", gw->port);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
@@ -1506,7 +1503,7 @@ static void mlx4_make_default_gid(struct  net_device *dev, union ib_gid *gid)
 }
 
 
-static int reset_gid_table(struct mlx4_ib_dev *dev)
+static int reset_gid_table(struct mlx4_ib_dev *dev, u8 port)
 {
 	struct update_gid_work *work;
 
@@ -1514,10 +1511,12 @@ static int reset_gid_table(struct mlx4_ib_dev *dev)
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
 		return -ENOMEM;
-	memset(dev->iboe.gid_table, 0, sizeof(dev->iboe.gid_table));
+
+	memset(dev->iboe.gid_table[port - 1], 0, sizeof(work->gids));
 	memset(work->gids, 0, sizeof(work->gids));
 	INIT_WORK(&work->work, reset_gids_task);
 	work->dev = dev;
+	work->port = port;
 	queue_work(wq, &work->work);
 	return 0;
 }
@@ -1670,9 +1669,11 @@ static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 {
 	struct	net_device *dev;
 	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	int i;
 
-	if (reset_gid_table(ibdev))
-		return -1;
+	for (i = 1; i <= ibdev->num_ports; ++i)
+		if (reset_gid_table(ibdev, i))
+			return -1;
 
 	read_lock(&dev_base_lock);
 	spin_lock(&iboe->lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
