From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 13/14] IB/mlx4: Implement ib_device callbacks
Date: Tue, 19 May 2015 17:27:16 +0300
Message-ID: <1432045637-9090-14-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

get_netdev: get the net_device on the physical port of the IB transport port. In
port aggregation mode it is required to return the netdev of the active port.

modify_gid: note for a change in the RoCE gid cache. Handle this by writing to
the harsware GID table. It is possible that indexes in cahce and hardware tables
won't match so a translation is required when modifying a QP or creating an
address handle.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 199 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  18 ++++
 include/linux/mlx4/device.h          |   3 +-
 3 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index abd0cf74..08ec498 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -45,6 +45,9 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
+
+#include <net/bonding.h>
 
 #include <linux/mlx4/driver.h>
 #include <linux/mlx4/cmd.h>
@@ -129,6 +132,202 @@ static int num_ib_ports(struct mlx4_dev *dev)
 	return ib_ports;
 }
 
+static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_num)
+{
+	struct mlx4_ib_dev *ibdev = to_mdev(device);
+
+	if (mlx4_is_bonded(ibdev->dev)) {
+		struct net_device *dev;
+		struct net_device *upper = NULL;
+
+		rcu_read_lock();
+
+		dev = mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
+		if (dev)
+			upper = netdev_master_upper_dev_get_rcu(dev);
+		else
+			goto unlock;
+		if (upper)
+			dev = bond_option_active_slave_get_rcu(netdev_priv(upper));
+unlock:
+		rcu_read_unlock();
+
+		return dev;
+	}
+
+	return mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
+}
+
+static int mlx4_ib_update_gids(struct gid_entry *gids,
+			       struct mlx4_ib_dev *ibdev,
+			       u8 port_num)
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
+	if (ib_cache_use_roce_gid_table(device, port_num))
+		return -EINVAL;
+
+	if (port_num > MLX4_MAX_PORTS)
+		return -EINVAL;
+
+	if (!context)
+		return -EINVAL;
+
+	spin_lock_bh(&iboe->lock);
+	port_gid_table = &iboe->gids[port_num - 1];
+
+	if (clear) {
+		struct gid_cache_context *ctx = *context;
+
+		if (ctx) {
+			ctx->refcount--;
+			if (!ctx->refcount) {
+				unsigned int real_index = ctx->real_index;
+
+				memcpy(&port_gid_table->gids[real_index].gid, &zgid, sizeof(*gid));
+				kfree(port_gid_table->gids[real_index].ctx);
+				port_gid_table->gids[real_index].ctx = NULL;
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
+				port_gid_table->gids[free].ctx = kmalloc(sizeof(*port_gid_table->gids[free].ctx), GFP_ATOMIC);
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
+		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC);
+		if (!gids) {
+			ret = -ENOMEM;
+		} else {
+			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
+				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
+				gids[i].gid_type = port_gid_table->gids[i].gid_type;
+			}
+		}
+	}
+	spin_unlock_bh(&iboe->lock);
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
+	unsigned long flags;
+
+	if (port_num > MLX4_MAX_PORTS)
+		return -EINVAL;
+
+	if (ib_cache_use_roce_gid_table(&ibdev->ib_dev, port_num))
+		return index;
+
+	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, &attr);
+	if (ret)
+		return ret;
+
+	if (!memcmp(&gid, &zgid, sizeof(gid)))
+		return -EINVAL;
+
+	spin_lock_irqsave(&iboe->lock, flags);
+	port_gid_table = &iboe->gids[port_num - 1];
+
+	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
+		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid)) &&
+		    (attr.gid_type == port_gid_table->gids[i].gid_type)) {
+			ctx = port_gid_table->gids[i].ctx;
+			break;
+		}
+	if (ctx)
+		real_index = ctx->real_index;
+	spin_unlock_irqrestore(&iboe->lock, flags);
+	return real_index;
+}
+
 static int mlx4_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props)
 {
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 3eee5da..0a32552 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -456,6 +456,21 @@ struct mlx4_ib_sriov {
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
 	spinlock_t		lock;
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
@@ -465,6 +480,7 @@ struct mlx4_ib_iboe {
 	struct notifier_block	nb_inet;
 	struct notifier_block	nb_inet6;
 	union ib_gid		gid_table[MLX4_MAX_PORTS][128];
+	struct mlx4_port_gid_table gids[MLX4_MAX_PORTS];
 };
 
 struct pkey_mgt {
@@ -815,5 +831,7 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 			  u64 start, u64 length, u64 virt_addr,
 			  int mr_access_flags, struct ib_pd *pd,
 			  struct ib_udata *udata);
+int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
+				    u8 port_num, int index);
 
 #endif /* MLX4_IB_H */
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 83e80ab..d439949 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -78,7 +78,8 @@ enum {
 
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
