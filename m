From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 12/29] {NET,IB}/mlx4_core: place phys gid and pkey tbl sizes in mlx4_phys_caps struct and paravirtualize them
Date: Tue, 19 Jun 2012 11:21:44 +0300
Message-ID: <1340094121-14858-13-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To allow easy paravirtualization of pkey and gid table sizes,
keep paravirtualized sizes in mlx4_dev->caps, but save the
actual physical sizes in FW in struct: mlx4_dev->phys_cap.

In addition, in SRIOV mode, do the following:

1. Reduce reported pkey table size by 1.
   This is done to reserve the highest pkey index for internal use,
   for declaring an invalid pkey in pkey paravirtualization.
   We require a pkey index which always contain an invalid pkey
   value for this purpose (i.e., one which cannot be modified by
   the subnet manager).  The way to do this is to reduce the
   pkey table size reported to the subnet manager by 1, so that
   it will not attempt to access the pkey at index #127.

2. Paravirtualize the gid table size to 1. Thus, each guest sees
   only a single gid (at its paravirtualized index 0).

In addition, since we are paravirtualizing the GID table size to 1,
we add paravirtualization of the master GID event here
(i.e., we do not do ib_dispatch_event for the GUID change
event on the master, since its (only) GUID never changes).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c          |   10 +++++--
 drivers/net/ethernet/mellanox/mlx4/fw.c   |   43 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/main.c |   32 +++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    4 ++-
 drivers/net/ethernet/mellanox/mlx4/port.c |   11 ++++++-
 include/linux/mlx4/device.h               |    2 +
 6 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index dbf315f..ff23063 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -185,8 +185,10 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			break;
 
 		case IB_SMP_ATTR_GUID_INFO:
-			mlx4_ib_dispatch_event(dev, port_num,
-					       IB_EVENT_GID_CHANGE);
+			/* paravirtualized master's guid is guid 0 -- does not change */
+			if (!mlx4_is_master(dev->dev))
+				mlx4_ib_dispatch_event(dev, port_num,
+						       IB_EVENT_GID_CHANGE);
 			break;
 		default:
 			break;
@@ -488,7 +490,9 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 		mlx4_ib_dispatch_event(dev, port, IB_EVENT_PKEY_CHANGE);
 		break;
 	case MLX4_DEV_PMC_SUBTYPE_GUID_INFO:
-		mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
+		/* paravirtualized master's guid is guid 0 -- does not change */
+		if (!mlx4_is_master(dev->dev))
+			mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
 		break;
 	default:
 		pr_warn("Unsupported subtype 0x%x for "
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index d7fa22e..dacbdfb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -738,9 +738,12 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 {
 	u64 def_mac;
 	u8 port_type;
+	u16 short_field;
 	int err;
 
 #define MLX4_VF_PORT_NO_LINK_SENSE_MASK	0xE0
+#define QUERY_PORT_CUR_MAX_PKEY_OFFSET	0x0c
+#define QUERY_PORT_CUR_MAX_GID_OFFSET	0x0e
 
 	err = mlx4_cmd_box(dev, 0, outbox->dma, vhcr->in_modifier, 0,
 			   MLX4_CMD_QUERY_PORT, MLX4_CMD_TIME_CLASS_B,
@@ -763,11 +766,51 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 
 		MLX4_PUT(outbox->buf, port_type,
 			 QUERY_PORT_SUPPORTED_TYPE_OFFSET);
+
+		short_field = 1; /* slave max gids */
+		MLX4_PUT(outbox->buf, short_field,
+			 QUERY_PORT_CUR_MAX_GID_OFFSET);
+
+		short_field = dev->caps.pkey_table_len[vhcr->in_modifier];
+		MLX4_PUT(outbox->buf, short_field,
+			 QUERY_PORT_CUR_MAX_PKEY_OFFSET);
 	}
 
 	return err;
 }
 
+int mlx4_get_slave_pkey_gid_tbl_len(struct mlx4_dev *dev, u8 port,
+				    int *gid_tbl_len, int *pkey_tbl_len)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32			*outbox;
+	u16			field;
+	int			err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	err =  mlx4_cmd_box(dev, 0, mailbox->dma, port, 0,
+			    MLX4_CMD_QUERY_PORT, MLX4_CMD_TIME_CLASS_B,
+			    MLX4_CMD_WRAPPED);
+	if (err)
+		goto out;
+
+	outbox = mailbox->buf;
+
+	MLX4_GET(field, outbox, QUERY_PORT_CUR_MAX_GID_OFFSET);
+	*gid_tbl_len = field;
+
+	MLX4_GET(field, outbox, QUERY_PORT_CUR_MAX_PKEY_OFFSET);
+	*pkey_tbl_len = field;
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+EXPORT_SYMBOL(mlx4_get_slave_pkey_gid_tbl_len);
+
 int mlx4_map_cmd(struct mlx4_dev *dev, u16 op, struct mlx4_icm *icm, u64 virt)
 {
 	struct mlx4_cmd_mailbox *mailbox;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 71cd6a4..f8867c2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -215,6 +215,10 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	for (i = 1; i <= dev->caps.num_ports; ++i) {
 		dev->caps.vl_cap[i]	    = dev_cap->max_vl[i];
 		dev->caps.ib_mtu_cap[i]	    = dev_cap->ib_mtu[i];
+		dev->phys_caps.gid_phys_table_len[i]  = dev_cap->max_gids[i];
+		dev->phys_caps.pkey_phys_table_len[i] = dev_cap->max_pkeys[i];
+		/* set gid and pkey table operating lengths by default
+		 * to non-sriov values */
 		dev->caps.gid_table_len[i]  = dev_cap->max_gids[i];
 		dev->caps.pkey_table_len[i] = dev_cap->max_pkeys[i];
 		dev->caps.port_width_cap[i] = dev_cap->max_port_width[i];
@@ -498,8 +502,13 @@ static int mlx4_slave_cap(struct mlx4_dev *dev)
 		return -ENODEV;
 	}
 
-	for (i = 1; i <= dev->caps.num_ports; ++i)
+	for (i = 1; i <= dev->caps.num_ports; ++i) {
 		dev->caps.port_mask[i] = dev->caps.port_type[i];
+		if (mlx4_get_slave_pkey_gid_tbl_len(dev, i,
+						    &dev->caps.gid_table_len[i],
+						    &dev->caps.pkey_table_len[i]))
+			return -ENODEV;
+	}
 
 	if (dev->caps.uar_page_size * (dev->caps.num_uars -
 				       dev->caps.reserved_uars) >
@@ -536,7 +545,7 @@ int mlx4_change_port_types(struct mlx4_dev *dev,
 		for (port = 1; port <= dev->caps.num_ports; port++) {
 			mlx4_CLOSE_PORT(dev, port);
 			dev->caps.port_type[port] = port_types[port - 1];
-			err = mlx4_SET_PORT(dev, port);
+			err = mlx4_SET_PORT(dev, port, -1);
 			if (err) {
 				mlx4_err(dev, "Failed to set port %d, "
 					      "aborting\n", port);
@@ -722,7 +731,7 @@ static ssize_t set_port_ib_mtu(struct device *dev,
 	mlx4_unregister_device(mdev);
 	for (port = 1; port <= mdev->caps.num_ports; port++) {
 		mlx4_CLOSE_PORT(mdev, port);
-		err = mlx4_SET_PORT(mdev, port);
+		err = mlx4_SET_PORT(mdev, port, -1);
 		if (err) {
 			mlx4_err(mdev, "Failed to set port %d, "
 				      "aborting\n", port);
@@ -1173,6 +1182,17 @@ err:
 	return -EIO;
 }
 
+static void mlx4_parav_master_pf_caps(struct mlx4_dev *dev)
+{
+	int i;
+
+	for (i = 1; i <= dev->caps.num_ports; i++) {
+		dev->caps.gid_table_len[i] = 1;
+		dev->caps.pkey_table_len[i] =
+			dev->phys_caps.pkey_phys_table_len[i] - 1;
+	}
+}
+
 static int mlx4_init_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv	  *priv = mlx4_priv(dev);
@@ -1212,6 +1232,9 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 			goto err_stop_fw;
 		}
 
+		if (mlx4_is_master(dev))
+			mlx4_parav_master_pf_caps(dev);
+
 		profile = default_profile;
 
 		icm_size = mlx4_make_profile(dev, &profile, &dev_cap,
@@ -1500,7 +1523,8 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 			else
 				dev->caps.port_ib_mtu[port] = IB_MTU_4096;
 
-			err = mlx4_SET_PORT(dev, port);
+			err = mlx4_SET_PORT(dev, port, mlx4_is_master(dev) ?
+					    dev->caps.pkey_table_len[port] : -1);
 			if (err) {
 				mlx4_err(dev, "Failed to set port %d, aborting\n",
 					port);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 4d11d12..cde6e51 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -969,7 +969,7 @@ int mlx4_change_port_types(struct mlx4_dev *dev,
 void mlx4_init_mac_table(struct mlx4_dev *dev, struct mlx4_mac_table *table);
 void mlx4_init_vlan_table(struct mlx4_dev *dev, struct mlx4_vlan_table *table);
 
-int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
+int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port, int pkey_tbl_sz);
 /* resource tracker functions*/
 int mlx4_get_slave_from_resource_id(struct mlx4_dev *dev,
 				    enum mlx4_resource resource_type,
@@ -1012,6 +1012,8 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 			    struct mlx4_cmd_info *cmd);
 int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
 
+int mlx4_get_slave_pkey_gid_tbl_len(struct mlx4_dev *dev, u8 port,
+				    int *gid_tbl_len, int *pkey_tbl_len);
 
 int mlx4_QP_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 			   struct mlx4_vhcr *vhcr,
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index a8fb529..90dc475 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -726,14 +726,15 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave,
 enum {
 	MLX4_SET_PORT_VL_CAP	 = 4, /* bits 7:4 */
 	MLX4_SET_PORT_MTU_CAP	 = 12, /* bits 15:12 */
+	MLX4_CHANGE_PORT_PKEY_TBL_SZ = 20,
 	MLX4_CHANGE_PORT_VL_CAP	 = 21,
 	MLX4_CHANGE_PORT_MTU_CAP = 22,
 };
 
-int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
+int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port, int pkey_tbl_sz)
 {
 	struct mlx4_cmd_mailbox *mailbox;
-	int err, vl_cap;
+	int err, vl_cap, pkey_tbl_flag = 0;
 
 	if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
 		return 0;
@@ -746,11 +747,17 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 
 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
 
+	if (pkey_tbl_sz >= 0 && mlx4_is_master(dev)) {
+		pkey_tbl_flag = 1;
+		((__be16 *) mailbox->buf)[20] = cpu_to_be16(pkey_tbl_sz);
+	}
+
 	/* IB VL CAP enum isn't used by the firmware, just numerical values */
 	for (vl_cap = 8; vl_cap >= 1; vl_cap >>= 1) {
 		((__be32 *) mailbox->buf)[0] = cpu_to_be32(
 			(1 << MLX4_CHANGE_PORT_MTU_CAP) |
 			(1 << MLX4_CHANGE_PORT_VL_CAP)  |
+			(pkey_tbl_flag << MLX4_CHANGE_PORT_PKEY_TBL_SZ) |
 			(dev->caps.port_ib_mtu[port] << MLX4_SET_PORT_MTU_CAP) |
 			(vl_cap << MLX4_SET_PORT_VL_CAP));
 		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index c0df6c9..19cc6db 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -269,6 +269,8 @@ static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 }
 
 struct mlx4_phys_caps {
+	u32			gid_phys_table_len[MLX4_MAX_PORTS + 1];
+	u32			pkey_phys_table_len[MLX4_MAX_PORTS + 1];
 	u32			num_phys_eqs;
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
