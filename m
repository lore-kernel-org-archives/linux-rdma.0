From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 11/19 V4] mlx4_core: Activating ports according to function
	number
Date: Thu, 10 Jun 2010 22:02:41 +0300
Message-ID: <4C1136D1.1050102@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In devices with multiple physical functions, each function activates
only one port, according to the function number.
Even functions activate port 1, odd functions activate port2.
For every virtual function we query the FW to which physical function it belongs,
as all the functions are served by the master function.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cmd.c      |    8 ++++++++
 drivers/net/mlx4/fw.c       |   36 ++++++++++++++++++++++++++++++++++--
 drivers/net/mlx4/fw.h       |    1 +
 drivers/net/mlx4/main.c     |   19 ++++++++++++-------
 drivers/net/mlx4/mlx4.h     |    3 +++
 drivers/net/mlx4/port.c     |    9 +++++----
 include/linux/mlx4/cmd.h    |    1 +
 include/linux/mlx4/device.h |    6 +++---
 8 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index a4722e2..b25e40e 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -423,9 +423,11 @@ static int mlx4_RESOURCE_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 						       struct mlx4_cmd_mailbox *inbox,
 						       struct mlx4_cmd_mailbox *outbox)
 {
+	struct mlx4_priv *priv = mlx4_priv(dev);
 	u32 param1 = *((u32 *) &vhcr->in_param);
 	u32 param2 = *(((u32 *) &vhcr->in_param) + 1);
 	int ret;
+	u8 pf_num = priv->mfunc.master.slave_state[slave].pf_num;
 
 #if 0
 	char *res[] = {"QP", "CQ", "SRQ", "MPT", "MTT"};
@@ -508,6 +510,7 @@ static int mlx4_RESOURCE_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 			mlx4_free_mtt_range(dev, param1 /* first */, param2 /* order */);
 		break;
 	case RES_MAC:
+		vhcr->in_param |= (u64) (pf_num) << 48;
 		switch (vhcr->op) {
 		case MLX4_CMD_ALLOC_RES:
 			ret = mlx4_register_mac(dev, vhcr->op_modifier,
@@ -1096,6 +1099,11 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd, u16 para
 		if (slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR2)
 			goto reset_slave;
 		slave_state[slave].vhcr_dma |= param;
+		if (mlx4_QUERY_FUNC(dev, slave, &slave_state[slave].pf_num)) {
+			mlx4_err(dev, "Failed to determine physical function "
+				      "number for slave %d\n", slave);
+			goto reset_slave;
+		}
 		break;
 	case MLX4_COMM_CMD_VHCR_POST:
 		if ((slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR_EN) &&
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index d1427e5..55377c0 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -152,9 +152,13 @@ int mlx4_QUERY_SLAVE_CAP_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 
 	memcpy(caps, &dev->caps, sizeof *caps);
 
+	/* Ports are activated according to physical function number */
+	mlx4_set_port_mask(dev, caps, slave);
+
 	/* PDs have the same range in every guest; the distinction is in the msbs,
 	 * which contains the guest ID (vf + 1) */
 	caps->pd_base = slave + 1;
+	caps->function = slave;
 
 	/* All other resources are allocated by the master, but we still report
 	 * 'num' and 'reserved' capabilities as follows:
@@ -596,6 +600,7 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 
 #define QUERY_FW_OUT_SIZE             0x100
 #define QUERY_FW_VER_OFFSET            0x00
+#define QUERY_FW_PPF_ID		       0x09
 #define QUERY_FW_CMD_IF_REV_OFFSET     0x0a
 #define QUERY_FW_MAX_CMD_OFFSET        0x0f
 #define QUERY_FW_ERR_START_OFFSET      0x30
@@ -628,6 +633,9 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 		((fw_ver & 0xffff0000ull) >> 16) |
 		((fw_ver & 0x0000ffffull) << 16);
 
+	MLX4_GET(lg, outbox, QUERY_FW_PPF_ID);
+	dev->caps.function = lg;
+
 	MLX4_GET(cmd_if_rev, outbox, QUERY_FW_CMD_IF_REV_OFFSET);
 	if (cmd_if_rev < MLX4_COMMAND_INTERFACE_MIN_REV ||
 	    cmd_if_rev > MLX4_COMMAND_INTERFACE_MAX_REV) {
@@ -938,7 +946,8 @@ int mlx4_INIT_PORT(struct mlx4_dev *dev, int port)
 		mlx4_free_cmd_mailbox(dev, mailbox);
 	} else {
 		if (mlx4_is_master(dev))
-			err = mlx4_common_init_port(dev, 0, port);
+			err = mlx4_common_init_port(dev, dev->caps.function,
+						    port);
 		else
 			err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_INIT_PORT,
 				       MLX4_CMD_TIME_CLASS_A);
@@ -978,7 +987,7 @@ int mlx4_CLOSE_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *v
 int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port)
 {
 	if (mlx4_is_master(dev))
-		return mlx4_common_close_port(dev, 0, port);
+		return mlx4_common_close_port(dev, dev->caps.function, port);
 	else
 		return mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT, 1000);
 }
@@ -1012,3 +1021,26 @@ int mlx4_NOP(struct mlx4_dev *dev)
 	/* Input modifier of 0x1f means "finish as soon as possible." */
 	return mlx4_cmd(dev, 0, 0x1f, 0, MLX4_CMD_NOP, 100);
 }
+
+int mlx4_QUERY_FUNC(struct mlx4_dev *dev, int func, u8 *pf_num)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u8 *outbox;
+	int ret;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	outbox = mailbox->buf;
+
+	ret = mlx4_cmd_box(dev, 0, mailbox->dma, func & 0xff, 0,
+			   MLX4_CMD_QUERY_FUNC, MLX4_CMD_TIME_CLASS_A);
+	if (ret)
+		goto out;
+
+	*pf_num = outbox[3];
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return ret;
+}
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index a9d7e55..9fd15f1 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -178,5 +178,6 @@ int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
 int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev);
 int mlx4_NOP(struct mlx4_dev *dev);
 int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg);
+int mlx4_QUERY_FUNC(struct mlx4_dev *dev, int func, u8 *pf_num);
 
 #endif /* MLX4_FW_H */
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 9dca6f4..e670aa0 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -150,15 +150,18 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
 	return 0;
 }
 
-static void mlx4_set_port_mask(struct mlx4_dev *dev)
+void mlx4_set_port_mask(struct mlx4_dev *dev, struct mlx4_caps *caps, int function)
 {
 	int i;
+	int active = (function & 1) + 1;
 
-	dev->caps.port_mask = 0;
-	for (i = 1; i <= dev->caps.num_ports; ++i)
-		if (dev->caps.port_type[i] == MLX4_PORT_TYPE_IB)
-			dev->caps.port_mask |= 1 << (i - 1);
+	for (i = 1; i <= caps->num_ports; ++i) {
+		caps->port_mask[i] = caps->port_type[i];
+		if (dev->caps.pf_num > 1 && i != active)
+			caps->port_mask[i] = 0;
+	}
 }
+
 static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 {
 	int err;
@@ -271,7 +274,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		}
 	}
 
-	mlx4_set_port_mask(dev);
+	mlx4_set_port_mask(dev, &dev->caps, dev->caps.function);
 
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW] = dev_cap->reserved_qps;
 	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_ETH_ADDR] =
@@ -382,7 +385,7 @@ int mlx4_change_port_types(struct mlx4_dev *dev,
 				goto out;
 			}
 		}
-		mlx4_set_port_mask(dev);
+		mlx4_set_port_mask(dev, &dev->caps, dev->caps.function);
 		err = mlx4_register_device(dev);
 	}
 
@@ -922,6 +925,8 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 		}
 	}
 
+	mlx4_set_port_mask(dev, &dev->caps, dev->caps.function);
+
 	err = mlx4_QUERY_ADAPTER(dev, &adapter);
 	if (err) {
 		mlx4_err(dev, "QUERY_ADAPTER command failed, aborting.\n");
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 351956d..1a37f63 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -228,6 +228,8 @@ struct mlx4_slave_state {
 	u8 comm_toggle;
 	u8 last_cmd;
 	u8 init_port_mask;
+	u8 pf_num;
+	u8 function;
 	dma_addr_t vhcr_dma;
 	u16 mtu[MLX4_MAX_PORTS + 1];
 	__be32 ib_cap_mask[MLX4_MAX_PORTS + 1];
@@ -528,6 +530,7 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
 			   enum mlx4_port_type *port_type);
 int mlx4_change_port_types(struct mlx4_dev *dev,
 			   enum mlx4_port_type *port_types);
+void mlx4_set_port_mask(struct mlx4_dev *dev, struct mlx4_caps *caps, int function);
 
 void mlx4_init_mac_table(struct mlx4_dev *dev, struct mlx4_mac_table *table);
 void mlx4_init_vlan_table(struct mlx4_dev *dev, struct mlx4_vlan_table *table);
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index dcbfd72..902bd94 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -39,7 +39,7 @@
 #include "en_port.h"
 
 #define MLX4_MAC_VALID		(1ull << 63)
-#define MLX4_MAC_MASK		0xffffffffffffULL
+#define MLX4_MAC_MASK		0x7fffffffffffffffULL
 
 #define MLX4_VLAN_VALID		(1u << 31)
 #define MLX4_VLAN_MASK		0xfff
@@ -103,18 +103,19 @@ int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn)
 		if (!err)
 			*qpn = out_param;
 		return err;
-	}
+	} else
+		mac |= (u64) (dev->caps.function) << 48;
 
 	mlx4_dbg(dev, "Registering MAC: 0x%llx\n", (unsigned long long) mac);
 	mutex_lock(&table->mutex);
-	for (i = 0; i < MLX4_MAX_MAC_NUM - 1; i++) {
+	for (i = 0; i < MLX4_MAX_MAC_NUM; i++) {
 		if (free < 0 && !table->entries[i]) {
 			free = i;
 			continue;
 		}
 
 		if (mac == (MLX4_MAC_MASK & be64_to_cpu(table->entries[i]))) {
-			/* MAC already registered, Must not have duplicates */
+			/* MAC + PF already registered, Must not have duplicates */
 			err = -EEXIST;
 			goto out;
 		}
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index b8a2079..01a1873 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -57,6 +57,7 @@ enum {
 	MLX4_CMD_QUERY_PORT	 = 0x43,
 	MLX4_CMD_SENSE_PORT	 = 0x4d,
 	MLX4_CMD_SET_PORT	 = 0xc,
+	MLX4_CMD_QUERY_FUNC	 = 0x56,
 	MLX4_CMD_ACCESS_DDR	 = 0x2e,
 	MLX4_CMD_MAP_ICM	 = 0xffa,
 	MLX4_CMD_UNMAP_ICM	 = 0xff9,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index c543210..0765845 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -183,6 +183,7 @@ static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 
 struct mlx4_caps {
 	u64			fw_ver;
+	int			function;
 	int			pf_num;
 	int			num_ports;
 	int			vl_cap[MLX4_MAX_PORTS + 1];
@@ -249,7 +250,7 @@ struct mlx4_caps {
 	int                     log_num_prios;
 	enum mlx4_port_type	port_type[MLX4_MAX_PORTS + 1];
 	u8			supported_type[MLX4_MAX_PORTS + 1];
-	u32			port_mask;
+	enum mlx4_port_type	port_mask[MLX4_MAX_PORTS + 1];
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 };
 
@@ -409,8 +410,7 @@ struct mlx4_init_port_param {
 
 #define mlx4_foreach_port(port, dev, type)				\
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	\
-		if (((type) == MLX4_PORT_TYPE_IB ? (dev)->caps.port_mask : \
-		     ~(dev)->caps.port_mask) & 1 << ((port) - 1))
+		if ((type) == (dev)->caps.port_mask[(port)])
 
 static inline int mlx4_is_slave(struct mlx4_dev *dev)
 {
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
