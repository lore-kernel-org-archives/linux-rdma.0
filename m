From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/mlx4: Add interface for selecting VFs to enable QP0 via MLX proxy QPs
Date: Thu, 29 May 2014 16:31:04 +0300
Message-ID: <1401370264-4818-7-git-send-email-ogerlitz@mellanox.com>
References: <1401370264-4818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401370264-4818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

This commit adds the sysfs interface for enabling QP0 on VFs
for selected VF/port.

By default, no VFs are enabled for QP0 operation.

To enable QP0 operation on a VF/port, under
/sys/class/infiniband/mlx4_x/iov/<b:d:f>/ports/x there are two new entries:

- smi_enabled (read-only). Indicates whether smi is currently
  enabled for the indicated VF/port

- enable_smi_admin (rw). Used by the admin to request that smi
  capability be enabled or disabled for the indicated VF/port.
  0 = disable, 1 = enable.
  The requested enablement will occur at the next reset of the
  VF (e.g. driver restart on the VM which owns the VF).


Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c       |  105 +++++++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   34 ++++++++++
 include/linux/mlx4/device.h              |    3 +
 3 files changed, 141 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 5a38e43..cb4c66e 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -389,8 +389,10 @@ struct mlx4_port {
 	struct mlx4_ib_dev    *dev;
 	struct attribute_group pkey_group;
 	struct attribute_group gid_group;
-	u8                     port_num;
+	struct device_attribute	enable_smi_admin;
+	struct device_attribute	smi_enabled;
 	int		       slave;
+	u8                     port_num;
 };
 
 
@@ -558,6 +560,101 @@ err:
 	return NULL;
 }
 
+static ssize_t sysfs_show_smi_enabled(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct mlx4_port *p =
+		container_of(attr, struct mlx4_port, smi_enabled);
+	ssize_t len = 0;
+
+	if (mlx4_vf_smi_enabled(p->dev->dev, p->slave, p->port_num))
+		len = sprintf(buf, "%d\n", 1);
+	else
+		len = sprintf(buf, "%d\n", 0);
+
+	return len;
+}
+
+static ssize_t sysfs_show_enable_smi_admin(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct mlx4_port *p =
+		container_of(attr, struct mlx4_port, enable_smi_admin);
+	ssize_t len = 0;
+
+	if (mlx4_vf_get_enable_smi_admin(p->dev->dev, p->slave, p->port_num))
+		len = sprintf(buf, "%d\n", 1);
+	else
+		len = sprintf(buf, "%d\n", 0);
+
+	return len;
+}
+
+static ssize_t sysfs_store_enable_smi_admin(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct mlx4_port *p =
+		container_of(attr, struct mlx4_port, enable_smi_admin);
+	int enable;
+
+	if (sscanf(buf, "%i", &enable) != 1 ||
+	    enable < 0 || enable > 1)
+		return -EINVAL;
+
+	if (mlx4_vf_set_enable_smi_admin(p->dev->dev, p->slave, p->port_num, enable))
+		return -EINVAL;
+	return count;
+}
+
+static int add_vf_smi_entries(struct mlx4_port *p)
+{
+	int is_eth = rdma_port_get_link_layer(&p->dev->ib_dev, p->port_num) ==
+			IB_LINK_LAYER_ETHERNET;
+	int ret;
+
+	/* do not display entries if eth transport, or if master */
+	if (is_eth || p->slave == mlx4_master_func_num(p->dev->dev))
+		return 0;
+
+	sysfs_attr_init(&p->smi_enabled.attr);
+	p->smi_enabled.show = sysfs_show_smi_enabled;
+	p->smi_enabled.store = NULL;
+	p->smi_enabled.attr.name = "smi_enabled";
+	p->smi_enabled.attr.mode = 0444;
+	ret = sysfs_create_file(&p->kobj, &p->smi_enabled.attr);
+	if (ret) {
+		pr_err("failed to create smi_enabled\n");
+		return ret;
+	}
+
+	sysfs_attr_init(&p->enable_smi_admin.attr);
+	p->enable_smi_admin.show = sysfs_show_enable_smi_admin;
+	p->enable_smi_admin.store = sysfs_store_enable_smi_admin;
+	p->enable_smi_admin.attr.name = "enable_smi_admin";
+	p->enable_smi_admin.attr.mode = 0644;
+	ret = sysfs_create_file(&p->kobj, &p->enable_smi_admin.attr);
+	if (ret) {
+		pr_err("failed to create enable_smi_admin\n");
+		sysfs_remove_file(&p->kobj, &p->smi_enabled.attr);
+		return ret;
+	}
+	return 0;
+}
+
+static void remove_vf_smi_entries(struct mlx4_port *p)
+{
+	int is_eth = rdma_port_get_link_layer(&p->dev->ib_dev, p->port_num) ==
+			IB_LINK_LAYER_ETHERNET;
+
+	if (is_eth || p->slave == mlx4_master_func_num(p->dev->dev))
+		return;
+
+	sysfs_remove_file(&p->kobj, &p->smi_enabled.attr);
+	sysfs_remove_file(&p->kobj, &p->enable_smi_admin.attr);
+}
+
 static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 {
 	struct mlx4_port *p;
@@ -602,6 +699,10 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	if (ret)
 		goto err_free_gid;
 
+	ret = add_vf_smi_entries(p);
+	if (ret)
+		goto err_free_gid;
+
 	list_add_tail(&p->kobj.entry, &dev->pkeys.pkey_port_list[slave]);
 	return 0;
 
@@ -669,6 +770,7 @@ err_add:
 		mport = container_of(p, struct mlx4_port, kobj);
 		sysfs_remove_group(p, &mport->pkey_group);
 		sysfs_remove_group(p, &mport->gid_group);
+		remove_vf_smi_entries(mport);
 		kobject_put(p);
 	}
 	kobject_put(dev->dev_ports_parent[slave]);
@@ -713,6 +815,7 @@ static void unregister_pkey_tree(struct mlx4_ib_dev *device)
 			port = container_of(p, struct mlx4_port, kobj);
 			sysfs_remove_group(p, &port->pkey_group);
 			sysfs_remove_group(p, &port->gid_group);
+			remove_vf_smi_entries(port);
 			kobject_put(p);
 			kobject_put(device->dev_ports_parent[slave]);
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 26c3eba..3370ecb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2567,3 +2567,37 @@ int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port)
 		MLX4_VF_SMI_ENABLED;
 }
 EXPORT_SYMBOL_GPL(mlx4_vf_smi_enabled);
+
+int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	if (slave == mlx4_master_func_num(dev))
+		return 1;
+
+	if (slave < 1 || slave >= dev->num_slaves ||
+	    port < 1 || port > MLX4_MAX_PORTS)
+		return 0;
+
+	return priv->mfunc.master.vf_admin[slave].enable_smi[port] ==
+		MLX4_VF_SMI_ENABLED;
+}
+EXPORT_SYMBOL_GPL(mlx4_vf_get_enable_smi_admin);
+
+int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
+				 int enabled)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	if (slave == mlx4_master_func_num(dev))
+		return 0;
+
+	if (slave < 1 || slave >= dev->num_slaves ||
+	    port < 1 || port > MLX4_MAX_PORTS ||
+	    enabled < 0 || enabled > 1)
+		return -EINVAL;
+
+	priv->mfunc.master.vf_admin[slave].enable_smi[port] = enabled;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_vf_set_enable_smi_admin);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index e2fc701..dcabe11 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1236,4 +1236,7 @@ int mlx4_get_base_gid_ix(struct mlx4_dev *dev, int slave, int port);
 
 int mlx4_config_vxlan_port(struct mlx4_dev *dev, __be16 udp_port);
 int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port);
+int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave, int port);
+int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
+				 int enable);
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
