From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/12] IB/mlx4: Add support for setting RoCEv2 gids in hardware
Date: Thu, 14 Jan 2016 17:50:35 +0200
Message-ID: <8fddabc4b642d3d7c2bcb5d1d4d0c52614f898fc.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To tell hardware about a gid with type RoCEv2, software needs a new
modifier to the SET_PORT command: MLX4_SET_PORT_ROCE_ADDR. This can
replace the old method, MLX4_SET_PORT_GID_TABLE, for  RoCEv1 gids.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 63 +++++++++++++++++++++++++++++++++++++--
 include/linux/mlx4/cmd.h          |  3 +-
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 22c9c1c..2a1ee80 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -154,9 +154,9 @@ static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_n
 	return dev;
 }
 
-static int mlx4_ib_update_gids(struct gid_entry *gids,
-			       struct mlx4_ib_dev *ibdev,
-			       u8 port_num)
+static int mlx4_ib_update_gids_v1(struct gid_entry *gids,
+				  struct mlx4_ib_dev *ibdev,
+				  u8 port_num)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
@@ -187,6 +187,63 @@ static int mlx4_ib_update_gids(struct gid_entry *gids,
 	return err;
 }
 
+static int mlx4_ib_update_gids_v1_v2(struct gid_entry *gids,
+				     struct mlx4_ib_dev *ibdev,
+				     u8 port_num)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+	struct mlx4_dev *dev = ibdev->dev;
+	int i;
+	struct {
+		union ib_gid	gid;
+		__be32		rsrvd1[2];
+		__be16		rsrvd2;
+		u8		type;
+		u8		version;
+		__be32		rsrvd3;
+	} *gid_tbl;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return -ENOMEM;
+
+	gid_tbl = mailbox->buf;
+	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i) {
+		memcpy(&gid_tbl[i].gid, &gids[i].gid, sizeof(union ib_gid));
+		if (gids[i].gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
+			gid_tbl[i].version = 2;
+			if (!ipv6_addr_v4mapped((struct in6_addr *)&gids[i].gid))
+				gid_tbl[i].type = 1;
+			else
+				memset(&gid_tbl[i].gid, 0, 12);
+		}
+	}
+
+	err = mlx4_cmd(dev, mailbox->dma,
+		       MLX4_SET_PORT_ROCE_ADDR << 8 | port_num,
+		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
+		       MLX4_CMD_WRAPPED);
+	if (mlx4_is_bonded(dev))
+		err += mlx4_cmd(dev, mailbox->dma,
+				MLX4_SET_PORT_ROCE_ADDR << 8 | 2,
+				1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
+				MLX4_CMD_WRAPPED);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+static int mlx4_ib_update_gids(struct gid_entry *gids,
+			       struct mlx4_ib_dev *ibdev,
+			       u8 port_num)
+{
+	if (ibdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
+		return mlx4_ib_update_gids_v1_v2(gids, ibdev, port_num);
+
+	return mlx4_ib_update_gids_v1(gids, ibdev, port_num);
+}
+
 static int mlx4_ib_add_gid(struct ib_device *device,
 			   u8 port_num,
 			   unsigned int index,
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 58391f2..116b284 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -206,7 +206,8 @@ enum {
 	MLX4_SET_PORT_GID_TABLE = 0x5,
 	MLX4_SET_PORT_PRIO2TC	= 0x8,
 	MLX4_SET_PORT_SCHEDULER = 0x9,
-	MLX4_SET_PORT_VXLAN	= 0xB
+	MLX4_SET_PORT_VXLAN	= 0xB,
+	MLX4_SET_PORT_ROCE_ADDR	= 0xD
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
