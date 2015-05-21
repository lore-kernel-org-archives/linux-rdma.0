From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 3/3] IB/mlx4: Add support for SRIOV VF management
Date: Thu, 21 May 2015 19:24:07 +0300
Message-ID: <1432225447-6536-4-git-send-email-ogerlitz@mellanox.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432225447-6536-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for the set_vf_guid and get_vf_config verbs.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c        |   26 ++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   26 ++++++++++++++++++--------
 include/linux/mlx4/device.h              |    2 ++
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 57070c5..17b6fa7 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1325,6 +1325,27 @@ err_malloc:
 	return err;
 }
 
+static int mlx4_ib_set_vf_guid(struct ib_device *ibdev, int port, int vf, u64 guid)
+{
+	int slave;
+	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
+
+	slave = mlx4_get_slave_indx(mdev->dev, vf);
+	if (slave < 0)
+		return -EINVAL;
+
+	mlx4_store_admin_alias_guid(mdev, port, slave, cpu_to_be64(guid));
+
+	return 0;
+}
+
+static int mlx4_ib_get_vf_config(struct ib_device *ibdev, int port, int vf, struct ifla_vf_info *ivf)
+{
+	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
+
+	return mlx4_get_vf_config(mdev->dev, port, vf, ivf);
+}
+
 static struct mlx4_ib_gid_entry *find_gid_entry(struct mlx4_ib_qp *qp, u8 *raw)
 {
 	struct mlx4_ib_gid_entry *ge;
@@ -2250,6 +2271,11 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
 	}
 
+	if (mlx4_is_master(ibdev->dev)) {
+		ibdev->ib_dev.set_vf_guid   = mlx4_ib_set_vf_guid;
+		ibdev->ib_dev.get_vf_config = mlx4_ib_get_vf_config;
+	}
+
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW ||
 	    dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN) {
 		ibdev->ib_dev.alloc_mw = mlx4_ib_alloc_mw;
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 7761045..a544650 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2647,7 +2647,7 @@ u32 mlx4_comm_get_version(void)
 	 return ((u32) CMD_CHAN_IF_REV << 8) | (u32) CMD_CHAN_VER;
 }
 
-static int mlx4_get_slave_indx(struct mlx4_dev *dev, int vf)
+int mlx4_get_slave_indx(struct mlx4_dev *dev, int vf)
 {
 	if ((vf < 0) || (vf >= dev->persist->num_vfs)) {
 		mlx4_err(dev, "Bad vf number:%d (number of activated vf: %d)\n",
@@ -2657,6 +2657,7 @@ static int mlx4_get_slave_indx(struct mlx4_dev *dev, int vf)
 
 	return vf+1;
 }
+EXPORT_SYMBOL_GPL(mlx4_get_slave_indx);
 
 int mlx4_get_vf_indx(struct mlx4_dev *dev, int slave)
 {
@@ -3089,13 +3090,22 @@ int mlx4_get_vf_config(struct mlx4_dev *dev, int port, int vf, struct ifla_vf_in
 	s_info = &priv->mfunc.master.vf_admin[slave].vport[port];
 	ivf->vf = vf;
 
-	/* need to convert it to a func */
-	ivf->mac[0] = ((s_info->mac >> (5*8)) & 0xff);
-	ivf->mac[1] = ((s_info->mac >> (4*8)) & 0xff);
-	ivf->mac[2] = ((s_info->mac >> (3*8)) & 0xff);
-	ivf->mac[3] = ((s_info->mac >> (2*8)) & 0xff);
-	ivf->mac[4] = ((s_info->mac >> (1*8)) & 0xff);
-	ivf->mac[5] = ((s_info->mac)  & 0xff);
+	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_ETH) {
+		ivf->mac[0] = ((s_info->mac >> (5*8)) & 0xff);
+		ivf->mac[1] = ((s_info->mac >> (4*8)) & 0xff);
+		ivf->mac[2] = ((s_info->mac >> (3*8)) & 0xff);
+		ivf->mac[3] = ((s_info->mac >> (2*8)) & 0xff);
+		ivf->mac[4] = ((s_info->mac >> (1*8)) & 0xff);
+		ivf->mac[5] = ((s_info->mac)  & 0xff);
+	} else {
+		u64 guid = be64_to_cpu(s_info->guid);
+		ivf->mac[0] = ((guid >> (7*8)) & 0xff);
+		ivf->mac[1] = ((guid >> (6*8)) & 0xff);
+		ivf->mac[2] = ((guid >> (5*8)) & 0xff);
+		ivf->mac[3] = ((guid >> (2*8)) & 0xff);
+		ivf->mac[4] = ((guid >> (1*8)) & 0xff);
+		ivf->mac[5] = ((guid)  & 0xff);
+	}
 
 	ivf->vlan		= s_info->default_vlan;
 	ivf->qos		= s_info->default_qos;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 83e80ab..e5a70bd 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1382,6 +1382,8 @@ int mlx4_get_slave_from_roce_gid(struct mlx4_dev *dev, int port, u8 *gid,
 int mlx4_get_roce_gid_from_slave(struct mlx4_dev *dev, int port, int slave_id,
 				 u8 *gid);
 
+int mlx4_get_slave_indx(struct mlx4_dev *dev, int vf);
+
 int mlx4_FLOW_STEERING_IB_UC_QP_RANGE(struct mlx4_dev *dev, u32 min_range_qpn,
 				      u32 max_range_qpn);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
