From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/7] IB/mlx4: Add RoCE per GID support for add_gid and del_gid
Date: Tue, 29 Dec 2015 15:24:02 +0200
Message-ID: <1451395447-5198-3-git-send-email-matanb@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In RoCE, GID table is managed in the IB core driver. The role of the
mlx4 driver is to synchronize the HW with the entries in the GID table.
Since it is possible that the same GID value will appear more than once
in the GID table (though with different attributes) it is required from
the mlx4 driver to maintain a reference counting mechanism and populate
the HW with a single value. We use a new firmware command in order to
populate the GID table and store the type along with the GID value.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 69 +++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  1 +
 include/linux/mlx4/cmd.h             |  3 +-
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 627267f..988fa33 100644
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
@@ -187,6 +187,61 @@ static int mlx4_ib_update_gids(struct gid_entry *gids,
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
@@ -215,7 +270,8 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 	port_gid_table = &iboe->gids[port_num - 1];
 	spin_lock_bh(&iboe->lock);
 	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i) {
-		if (!memcmp(&port_gid_table->gids[i].gid, gid, sizeof(*gid))) {
+		if (!memcmp(&port_gid_table->gids[i].gid, gid, sizeof(*gid)) &&
+		    (port_gid_table->gids[i].gid_type == attr->gid_type))  {
 			found = i;
 			break;
 		}
@@ -233,6 +289,7 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 			} else {
 				*context = port_gid_table->gids[free].ctx;
 				memcpy(&port_gid_table->gids[free].gid, gid, sizeof(*gid));
+				port_gid_table->gids[free].gid_type = attr->gid_type;
 				port_gid_table->gids[free].ctx->real_index = free;
 				port_gid_table->gids[free].ctx->refcount = 1;
 				hw_update = 1;
@@ -248,8 +305,10 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
-			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++)
+			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
 				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
+				gids[i].gid_type = port_gid_table->gids[i].gid_type;
+			}
 		}
 	}
 	spin_unlock_bh(&iboe->lock);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 8916e9b..7179fb1 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -478,6 +478,7 @@ struct gid_cache_context {
 
 struct gid_entry {
 	union ib_gid	gid;
+	enum ib_gid_type gid_type;
 	struct gid_cache_context *ctx;
 };
 
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
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
