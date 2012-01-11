From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/6] net/mlx4: allow for dynamic mtu configuration for IB
 ports
Date: Wed, 11 Jan 2012 19:02:17 +0200
Message-ID: <alpine.LRH.2.00.1201111901300.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set the mtu for IB ports by the driver instead of using the firmware
2KB default, with the default being 4KB. Allow for dynamic mtu
configuration through a new, per port sysfs entry.

As there's a dependency between the port mtu to the maximal number
of HW VLs the port can support, apply a mim/max approach, using a
loop that goes down from the highest possible number of VLs to
the lowest. Use the firmware return status as an indication for
the requested number of VLs being impossible with that mtu.

For now, and as done with the dynamic link type change / VPI support,
the sysfs entry to change the mtu is exposed only when running in
NON SRIOV mode. To allow changing the mtu for the master in SRIOV
mode, PF initiated FLR (Function Level Reset) has to be implemented.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---

Roland, on v1 - http://marc.info/?l=linux-rdma&m=130636143927387&w=2 you made a comment
saying "I mean set the MTU port-by-port with the module loaded, the same way we are
supposed to be able to do for the port type.  Rather than having one global module
parameter", see thread http://marc.info/?l=linux-rdma&m=130632548008337&w=2, this
posting addresses that comment

changes from v1
  - added ib_port_mtu field to mlx4 device ports and use it on SET_PORT
  - removed module param
  - added sysfs entries to set and show the port IB mtu
  - rebased the patch against Linus tree which has the SRIOV patches

Also, some code (enum ibta_mtu and ibta_mtu_to_int) could be eliminated
if we allow for the mlx4_core driver to "#include <rdma/ib_verbs.h>"
basically I don't see a concrete problem arising from such inclusion.

 drivers/net/ethernet/mellanox/mlx4/main.c |  118 ++++++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    2 +
 drivers/net/ethernet/mellanox/mlx4/port.c |   25 ++++++-
 include/linux/mlx4/device.h               |    1 +
 4 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 6bb62c5..7a58613 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -575,7 +575,6 @@ static ssize_t show_port_type(struct device *dev,

 	return strlen(buf);
 }
-
 static ssize_t set_port_type(struct device *dev,
 			     struct device_attribute *attr,
 			     const char *buf, size_t count)
@@ -648,6 +647,99 @@ out:
 	return err ? err : count;
 }

+enum ibta_mtu {
+	IB_MTU_256  = 1,
+	IB_MTU_512  = 2,
+	IB_MTU_1024 = 3,
+	IB_MTU_2048 = 4,
+	IB_MTU_4096 = 5
+};
+
+static inline int int_to_ibta_mtu(int mtu)
+{
+	switch (mtu) {
+	case 256:  return IB_MTU_256;
+	case 512:  return IB_MTU_512;
+	case 1024: return IB_MTU_1024;
+	case 2048: return IB_MTU_2048;
+	case 4096: return IB_MTU_4096;
+	default: return -1;
+	}
+}
+
+static inline int ibta_mtu_to_int(enum ibta_mtu mtu)
+{
+	switch (mtu) {
+	case IB_MTU_256:  return  256;
+	case IB_MTU_512:  return  512;
+	case IB_MTU_1024: return 1024;
+	case IB_MTU_2048: return 2048;
+	case IB_MTU_4096: return 4096;
+	default: return -1;
+	}
+}
+
+static ssize_t show_port_ib_mtu(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct mlx4_port_info *info = container_of(attr, struct mlx4_port_info,
+						   port_mtu_attr);
+	struct mlx4_dev *mdev = info->dev;
+
+	if (mdev->caps.port_type[info->port] == MLX4_PORT_TYPE_ETH)
+		mlx4_warn(mdev, "port level mtu is only used for IB ports\n");
+
+	sprintf(buf, "%d\n",
+			ibta_mtu_to_int(mdev->caps.port_ib_mtu[info->port]));
+	return strlen(buf);
+}
+
+static ssize_t set_port_ib_mtu(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct mlx4_port_info *info = container_of(attr, struct mlx4_port_info,
+						   port_mtu_attr);
+	struct mlx4_dev *mdev = info->dev;
+	struct mlx4_priv *priv = mlx4_priv(mdev);
+	int err, port, mtu, ibta_mtu = -1;
+
+	if (mdev->caps.port_type[info->port] == MLX4_PORT_TYPE_ETH) {
+		mlx4_warn(mdev, "port level mtu is only used for IB ports\n");
+		return -EINVAL;
+	}
+
+	err = sscanf(buf, "%d", &mtu);
+	if (err > 0)
+		ibta_mtu = int_to_ibta_mtu(mtu);
+
+	if (err <= 0 || ibta_mtu < 0) {
+		mlx4_err(mdev, "%s is invalid IBTA mtu\n", buf);
+		return -EINVAL;
+	}
+
+	mdev->caps.port_ib_mtu[info->port] = ibta_mtu;
+
+	mlx4_stop_sense(mdev);
+	mutex_lock(&priv->port_mutex);
+	mlx4_unregister_device(mdev);
+	for (port = 1; port <= mdev->caps.num_ports; port++) {
+		mlx4_CLOSE_PORT(mdev, port);
+		err = mlx4_SET_PORT(mdev, port);
+		if (err) {
+			mlx4_err(mdev, "Failed to set port %d, "
+				      "aborting\n", port);
+			goto err_set_port;
+		}
+	}
+	err = mlx4_register_device(mdev);
+err_set_port:
+	mutex_unlock(&priv->port_mutex);
+	mlx4_start_sense(mdev);
+	return err ? err : count;
+}
+
 static int mlx4_load_fw(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -1361,7 +1453,10 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 					  "ib capabilities (%d). Continuing "
 					  "with caps = 0\n", port, err);
 			dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
-
+			if (mlx4_is_mfunc(dev))
+				dev->caps.port_ib_mtu[port] = IB_MTU_2048;
+			else
+				dev->caps.port_ib_mtu[port] = IB_MTU_4096;
 			err = mlx4_check_ext_port_caps(dev, port);
 			if (err)
 				mlx4_warn(dev, "failed to get port %d extended "
@@ -1523,6 +1618,24 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		info->port = -1;
 	}

+	sprintf(info->dev_mtu_name, "mlx4_port%d_mtu", port);
+	info->port_mtu_attr.attr.name = info->dev_mtu_name;
+	if (mlx4_is_mfunc(dev))
+		info->port_mtu_attr.attr.mode = S_IRUGO;
+	else {
+		info->port_mtu_attr.attr.mode = S_IRUGO | S_IWUSR;
+		info->port_mtu_attr.store     = set_port_ib_mtu;
+	}
+	info->port_mtu_attr.show      = show_port_ib_mtu;
+	sysfs_attr_init(&info->port_mtu_attr.attr);
+
+	err = device_create_file(&dev->pdev->dev, &info->port_mtu_attr);
+	if (err) {
+		mlx4_err(dev, "Failed to create mtu file for port %d\n", port);
+		device_remove_file(&info->dev->pdev->dev, &info->port_attr);
+		info->port = -1;
+	}
+
 	return err;
 }

@@ -1532,6 +1645,7 @@ static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
 		return;

 	device_remove_file(&info->dev->pdev->dev, &info->port_attr);
+	device_remove_file(&info->dev->pdev->dev, &info->port_mtu_attr);
 }

 static int mlx4_init_steering(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index a80121a..e83887d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -680,6 +680,8 @@ struct mlx4_port_info {
 	char			dev_name[16];
 	struct device_attribute port_attr;
 	enum mlx4_port_type	tmp_type;
+	char			dev_mtu_name[16];
+	struct device_attribute port_mtu_attr;
 	struct mlx4_mac_table	mac_table;
 	struct radix_tree_root	mac_tree;
 	struct mlx4_vlan_table	vlan_table;
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 88b52e5..d1ac422 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -761,10 +761,18 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave,
 				    vhcr->op_modifier, inbox);
 }

+/* bit locations for set port command with zero op modifier */
+enum {
+	MLX4_SET_PORT_VL_CAP	 = 4, /* bits 7:4 */
+	MLX4_SET_PORT_MTU_CAP	 = 12, /* bits 15:12 */
+	MLX4_CHANGE_PORT_VL_CAP	 = 21,
+	MLX4_CHANGE_PORT_MTU_CAP = 22,
+};
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
-	int err;
+	int err, vl_cap;

 	if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
 		return 0;
@@ -776,8 +784,19 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 	memset(mailbox->buf, 0, 256);

 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
-	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
-		       MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
+
+	/* IB VL CAP enum isn't used by the firmware, just numerical values */
+	for (vl_cap = 8; vl_cap >= 1; vl_cap >>= 1) {
+		((__be32 *) mailbox->buf)[0] = cpu_to_be32(
+			(1 << MLX4_CHANGE_PORT_MTU_CAP) |
+			(1 << MLX4_CHANGE_PORT_VL_CAP)  |
+			(dev->caps.port_ib_mtu[port] << MLX4_SET_PORT_MTU_CAP) |
+			(vl_cap << MLX4_SET_PORT_VL_CAP));
+		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+				MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
+		if (err != -ENOMEM)
+			break;
+	}

 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 5c4fe8e..f241445 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -309,6 +309,7 @@ struct mlx4_caps {
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
 	u8			ext_port_cap[MLX4_MAX_PORTS + 1];
+	u8			port_ib_mtu[MLX4_MAX_PORTS + 1];
 };

 struct mlx4_buf_list {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
