From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 26/33] IB/mlx4: Implement ib_device callback - modify_gid
Date: Thu, 26 Mar 2015 02:50:15 +0530
Message-ID: <25f45f4e-6d68-4e8b-9935-4bfe296530be@CMEXHTCAS2.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427318422-12004-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is a new callbac that is required for RoCEv2 support.
In RoCE, GID table is managed in the IB core driver. The role of the
mlx4 driver is to synchronize the HW with the entries in the GID table.
Since it is possible that the same GID value will appear more than once
in the GID table (though with different attributes) it is required from
the mlx4 driver to maintain a reference counting mechanism and populate
the HW with a single value.
Since an index to the GID table is not necessarily the same as index to
the matching entry in the HW GID table, a translation between indexes is
required.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 226 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  18 +++
 include/linux/mlx4/cmd.h             |   3 +-
 include/linux/mlx4/device.h          |   3 +-
 4 files changed, 248 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 04e6603..96a6ec0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1555,6 +1555,230 @@ unlock:
 	return mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
 }
 
+static int mlx4_ib_update_gids_v1(struct gid_entry *gids,
+				  struct mlx4_ib_dev *ibdev,
+				  u8 port_num)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+	struct mlx4_dev *dev = ibdev->dev;
+	int i;
+	union ib_gid *gid_tbl;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return -ENOMEM;
+
+	gid_tbl = mailbox->buf;
+
+	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
+		memcpy(&gid_tbl[i], &gids[i].gid, sizeof(union ib_gid));
+
+	err = mlx4_cmd(dev, mailbox->dma,
+		       MLX4_SET_PORT_GID_TABLE << 8 | port_num,
+		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
+		       MLX4_CMD_WRAPPED);
+	if (mlx4_is_bonded(dev))
+		err += mlx4_cmd(dev, mailbox->dma,
+				MLX4_SET_PORT_GID_TABLE << 8 | 2,
+				1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
+				MLX4_CMD_WRAPPED);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
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
+		if (gids[i].gid_type == IB_GID_TYPE_ROCE_V2) {
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
+static int mlx4_ib_modify_gid(struct ib_device *device,
+			      u8 port_num, unsigned int index,
+			      const union ib_gid *gid,
+			      const struct ib_gid_attr *attr,
+			      void **context)
+{
+	struct mlx4_ib_dev *ibdev = to_mdev(device);
+	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_port_gid_table   *port_gid_table;
+	int free = -1, found = -1;
+	int ret = 0;
+	int clear = !memcmp(&zgid, gid, sizeof(*gid));
+	int hw_update = 0;
+	int i;
+	struct gid_entry *gids = NULL;
+
+	if (ib_cache_use_roce_gid_cache(device, port_num))
+		return -EINVAL;
+
+	if (port_num > MLX4_MAX_PORTS)
+		return -EINVAL;
+
+	if (!context)
+		return -EINVAL;
+
+	down_write(&iboe->sem);
+	port_gid_table = &iboe->gid_table[port_num - 1];
+
+	if (clear) {
+		struct gid_cache_context *ctx = *context;
+
+		if (ctx) {
+			ctx->refcount--;
+			if (!ctx->refcount) {
+				unsigned int index = ctx->real_index;
+
+				memcpy(&port_gid_table->gids[index].gid, &zgid, sizeof(*gid));
+				kfree(port_gid_table->gids[index].ctx);
+				port_gid_table->gids[index].ctx = NULL;
+				hw_update = 1;
+			}
+		}
+	} else {
+		for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i) {
+			if (!memcmp(&port_gid_table->gids[i].gid, gid, sizeof(*gid))) {
+				found = (port_gid_table->gids[i].gid_type == attr->gid_type) ? i : -1;
+				if (found >= 0)
+					break;
+			}
+			if (free < 0 && !memcmp(&port_gid_table->gids[i].gid, &zgid, sizeof(*gid)))
+				free = i; /* HW has space */
+		}
+
+		if (found < 0) {
+			if (free < 0) {
+				ret = -ENOSPC;
+			} else {
+				port_gid_table->gids[free].ctx = kmalloc(sizeof(*port_gid_table->gids[free].ctx), GFP_KERNEL);
+				if (!port_gid_table->gids[free].ctx) {
+					ret = -ENOMEM;
+				} else {
+					*context = port_gid_table->gids[free].ctx;
+					memcpy(&port_gid_table->gids[free].gid, gid, sizeof(*gid));
+					port_gid_table->gids[free].gid_type = attr->gid_type;
+					port_gid_table->gids[free].ctx->real_index = free;
+					port_gid_table->gids[free].ctx->refcount = 1;
+					hw_update = 1;
+				}
+			}
+		} else {
+			struct gid_cache_context *ctx = port_gid_table->gids[found].ctx;
+			*context = ctx;
+			ctx->refcount++;
+		}
+	}
+	if (!ret && hw_update) {
+		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_KERNEL);
+		if (!gids) {
+			ret = -ENOMEM;
+		} else {
+			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
+				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
+				gids[i].gid_type = port_gid_table->gids[i].gid_type;
+			}
+		}
+	}
+	up_write(&iboe->sem);
+
+	if (!ret && hw_update) {
+		ret = mlx4_ib_update_gids(gids, ibdev, port_num);
+		kfree(gids);
+	}
+
+	return ret;
+}
+
+int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
+				    u8 port_num, int index)
+{
+	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct gid_cache_context *ctx = NULL;
+	union ib_gid gid;
+	struct mlx4_port_gid_table   *port_gid_table;
+	int real_index = -EINVAL;
+	int i;
+	int ret;
+	struct ib_gid_attr attr;
+
+	if (port_num > MLX4_MAX_PORTS)
+		return -EINVAL;
+
+	if (ib_cache_use_roce_gid_cache(&ibdev->ib_dev, port_num))
+		return index;
+
+	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, &attr);
+	if (ret)
+		return ret;
+
+	if (!memcmp(&gid, &zgid, sizeof(gid)))
+		return -EINVAL;
+
+	down_read(&iboe->sem);
+	port_gid_table = &iboe->gid_table[port_num - 1];
+
+	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
+		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid)) &&
+		    (attr.gid_type == port_gid_table->gids[i].gid_type)) {
+			ctx = port_gid_table->gids[i].ctx;
+			break;
+		}
+	if (ctx)
+		real_index = ctx->real_index;
+	up_read(&iboe->sem);
+	return real_index;
+}
+
 static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 				 struct net_device *dev,
 				 unsigned long event)
@@ -1835,6 +2059,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
 	ibdev->ib_dev.get_netdev	= mlx4_ib_get_netdev;
+	ibdev->ib_dev.modify_gid	= mlx4_ib_modify_gid;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
@@ -1930,6 +2155,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_steer_free_bitmap;
 	}
 
+	memset(iboe->gid_table, 0, sizeof(struct mlx4_port_gid_table) * MLX4_MAX_PORTS);
 	for (j = 1; j <= ibdev->dev->caps.num_ports; j++)
 		atomic64_set(&iboe->mac[j - 1], ibdev->dev->caps.def_mac[j]);
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 166ebf9..018bda6 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -454,11 +454,27 @@ struct mlx4_ib_sriov {
 	struct idr pv_id_table;
 };
 
+struct gid_cache_context {
+	int real_index;
+	int refcount;
+};
+
+struct gid_entry {
+	union ib_gid	gid;
+	enum ib_gid_type gid_type;
+	struct gid_cache_context *ctx;
+};
+
+struct mlx4_port_gid_table {
+	struct gid_entry gids[MLX4_MAX_PORT_GIDS];
+};
+
 struct mlx4_ib_iboe {
 	struct rw_semaphore	sem; /* guard from concurrent access to data in this struct */
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
 	atomic64_t		mac[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
+	struct mlx4_port_gid_table gid_table[MLX4_MAX_PORTS];
 };
 
 struct pkey_mgt {
@@ -804,5 +820,7 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 			  u64 start, u64 length, u64 virt_addr,
 			  int mr_access_flags, struct ib_pd *pd,
 			  struct ib_udata *udata);
+int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
+				    u8 port_num, int index);
 
 #endif /* MLX4_IB_H */
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index d764350..8cec202 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -192,7 +192,8 @@ enum {
 	MLX4_SET_PORT_GID_TABLE = 0x5,
 	MLX4_SET_PORT_PRIO2TC	= 0x8,
 	MLX4_SET_PORT_SCHEDULER = 0x9,
-	MLX4_SET_PORT_VXLAN	= 0xB
+	MLX4_SET_PORT_VXLAN	= 0xB,
+	MLX4_SET_PORT_ROCE_ADDR	= 0xD
 };
 
 enum {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 9bdf157..dfc4a86 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -80,7 +80,8 @@ enum {
 
 enum {
 	MLX4_MAX_PORTS		= 2,
-	MLX4_MAX_PORT_PKEYS	= 128
+	MLX4_MAX_PORT_PKEYS	= 128,
+	MLX4_MAX_PORT_GIDS	= 128
 };
 
 /* base qkey for use in sriov tunnel-qp/proxy-qp communication.
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
