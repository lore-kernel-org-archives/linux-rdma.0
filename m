From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 20/22] {NET,IB}/mlx4: Paravirtualize Node Guids for slaves
Date: Fri,  3 Aug 2012 11:40:56 +0300
Message-ID: <1343983258-6268-21-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is necessary in order to support > 1 VF/PF in a VM for software that
uses the node guid as a discriminator, such as librdmacm.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c          |   14 ++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    3 +++
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |   11 +++++++++++
 drivers/net/ethernet/mellanox/mlx4/main.c |   22 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 include/linux/mlx4/device.h               |    2 ++
 6 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index cee7bf6..f7b9a41 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_sa.h>
 #include <rdma/ib_cache.h>
 
+#include <linux/random.h>
 #include <linux/mlx4/cmd.h>
 #include <linux/gfp.h>
 #include <rdma/ib_pma.h>
@@ -89,6 +90,12 @@ static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num);
 static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 				int block, u32 change_bitmap);
 
+__be64 mlx4_ib_gen_node_guid(void)
+{
+#define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
+	return (cpu_to_be64( NODE_GUID_HI | random32()));
+}
+
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
 {
 	return cpu_to_be64(atomic_inc_return(&ctx->tid)) |
@@ -1958,6 +1965,13 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 		return 0;
 	}
 
+	for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
+		if (i == mlx4_master_func_num(dev->dev))
+			mlx4_put_slave_node_guid(dev->dev, i, dev->ib_dev.node_guid);
+		else
+			mlx4_put_slave_node_guid(dev->dev, i, mlx4_ib_gen_node_guid());
+	}
+
 	err = mlx4_ib_init_alias_guid_service(dev);
 	if (err) {
 		mlx4_ib_warn(&dev->ib_dev, "Failed init alias guid process.\n");
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e57a220..e04cbc9 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -723,4 +723,7 @@ int mlx4_ib_device_register_sysfs(struct mlx4_ib_dev *device) ;
 
 void mlx4_ib_device_unregister_sysfs(struct mlx4_ib_dev *device);
 
+__be64 mlx4_ib_gen_node_guid(void);
+
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 9717002..33df1db 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -651,6 +651,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 	struct ib_smp *outsmp = outbox->buf;
 	__be16 *outtab = (__be16 *)(outsmp->data);
 	__be32 slave_cap_mask;
+	__be64 slave_node_guid;
 	port = vhcr->in_modifier;
 
 	if (smp->base_version == 1 &&
@@ -710,6 +711,16 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 				}
 				return err;
 			}
+			if (smp->attr_id == IB_SMP_ATTR_NODE_INFO) {
+				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
+					     vhcr->in_modifier, vhcr->op_modifier,
+					     vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
+				if (!err) {
+					slave_node_guid =  mlx4_get_slave_node_guid(dev, slave);
+					memcpy(outsmp->data + 12, &slave_node_guid, 8);
+				}
+				return err;
+			}
 		}
 	}
 	if (slave != mlx4_master_func_num(dev) &&
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index cd82607..d5e4238 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -438,6 +438,28 @@ void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port, int i, int
 }
 EXPORT_SYMBOL(mlx4_sync_pkey_table);
 
+void mlx4_put_slave_node_guid(struct mlx4_dev *dev, int slave, __be64 guid)
+{
+	struct mlx4_priv *priv = container_of(dev, struct mlx4_priv, dev);
+
+	if (!mlx4_is_master(dev))
+		return;
+
+	priv->slave_node_guids[slave] = guid;
+}
+EXPORT_SYMBOL(mlx4_put_slave_node_guid);
+
+__be64 mlx4_get_slave_node_guid(struct mlx4_dev *dev, int slave)
+{
+	struct mlx4_priv *priv = container_of(dev, struct mlx4_priv, dev);
+
+	if (!mlx4_is_master(dev))
+		return 0;
+
+	return priv->slave_node_guids[slave];
+}
+EXPORT_SYMBOL(mlx4_get_slave_node_guid);
+
 int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 5c30488..d2ccec6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -734,6 +734,7 @@ struct mlx4_priv {
 	int			reserved_mtts;
 	int			fs_hash_mode;
 	u8 virt2phys_pkey[MLX4_MFUNC_MAX][MLX4_MAX_PORTS][MLX4_MAX_PORT_PKEYS];
+	__be64			slave_node_guids[MLX4_MFUNC_MAX];
 
 };
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index f8c9316..a8cb149 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -968,5 +968,7 @@ int mlx4_gen_port_state_change_eqe(struct mlx4_dev *dev, int slave, u8 port, u8
 enum slave_port_state mlx4_get_slave_port_state(struct mlx4_dev *dev, int slave, u8 port);
 int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave, u8 port, int event, enum slave_port_gen_event *gen_event);
 
+void mlx4_put_slave_node_guid(struct mlx4_dev *dev, int slave, __be64 guid);
+__be64 mlx4_get_slave_node_guid(struct mlx4_dev *dev, int slave);
 
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
