From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 13/15] IB/mlx5: Use correct mdev for vport queries in ib_virt
Date: Thu,  4 Jan 2018 11:06:43 +0200
Message-ID: <20180104090645.4901-14-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When using dual port RoCE mode vport queries should be routed to the
respective port mlx5_core_dev instead of the IB devices master mdev.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/ib_virt.c | 84 +++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 649a3364f838..fcdc85e89ba8 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -52,26 +52,36 @@ int mlx5_ib_get_vf_config(struct ib_device *device, int vf, u8 port,
 			  struct ifla_vf_info *info)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *rep;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
 	int err;
 
 	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
 	if (!rep)
 		return -ENOMEM;
 
-	err = mlx5_query_hca_vport_context(mdev, 1, 1,  vf + 1, rep);
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = mlx5_query_hca_vport_context(mdev, 1, mdev_port_num, vf + 1,
+					   rep);
 	if (err) {
 		mlx5_ib_warn(dev, "failed to query port policy for vf %d (%d)\n",
 			     vf, err);
-		goto free;
+		goto put_mdev;
 	}
 	memset(info, 0, sizeof(*info));
 	info->linkstate = mlx_to_net_policy(rep->policy);
 	if (info->linkstate == __IFLA_VF_LINK_STATE_MAX)
 		err = -EINVAL;
 
-free:
+put_mdev:
+	mlx5_ib_put_native_port_mdev(dev, port);
+out:
 	kfree(rep);
 	return err;
 }
@@ -94,9 +104,10 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 			      u8 port, int state)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
-	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
 	int err;
 
 	in = kzalloc(sizeof(*in), GFP_KERNEL);
@@ -108,11 +119,21 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 		err = -EINVAL;
 		goto out;
 	}
+
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	in->field_select = MLX5_HCA_VPORT_SEL_STATE_POLICY;
-	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	err = mlx5_core_modify_hca_vport_context(mdev, 1, mdev_port_num,
+						 vf + 1, in);
 	if (!err)
 		vfs_ctx[vf].policy = in->policy;
 
+	mlx5_ib_put_native_port_mdev(dev, port);
 out:
 	kfree(in);
 	return err;
@@ -124,20 +145,29 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 	int out_sz = MLX5_ST_SZ_BYTES(query_vport_counter_out);
 	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_dev *dev;
+	u8 mdev_port_num;
 	void *out;
 	int err;
 
 	dev = to_mdev(device);
-	mdev = dev->mdev;
 
 	out = kzalloc(out_sz, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_query_vport_counter(mdev, true, vf, port, out, out_sz);
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		err = -ENODEV;
+		goto ex;
+	}
+
+	err = mlx5_core_query_vport_counter(mdev, true, vf, mdev_port_num, out,
+					    out_sz);
 	if (err)
 		goto ex;
 
+	mlx5_ib_put_native_port_mdev(dev, port);
+
 	stats->rx_packets = MLX5_GET64_PR(query_vport_counter_out, out, received_ib_unicast.packets);
 	stats->tx_packets = MLX5_GET64_PR(query_vport_counter_out, out, transmitted_ib_unicast.packets);
 	stats->rx_bytes = MLX5_GET64_PR(query_vport_counter_out, out, received_ib_unicast.octets);
@@ -152,20 +182,32 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
-	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
 	int err;
 
 	in = kzalloc(sizeof(*in), GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	in->field_select = MLX5_HCA_VPORT_SEL_NODE_GUID;
 	in->node_guid = guid;
-	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	err = mlx5_core_modify_hca_vport_context(mdev, 1, mdev_port_num,
+						 vf + 1, in);
 	if (!err)
 		vfs_ctx[vf].node_guid = guid;
+
+	mlx5_ib_put_native_port_mdev(dev, port);
+out:
 	kfree(in);
 	return err;
 }
@@ -173,20 +215,32 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
-	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
 	int err;
 
 	in = kzalloc(sizeof(*in), GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	in->field_select = MLX5_HCA_VPORT_SEL_PORT_GUID;
 	in->port_guid = guid;
-	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	err = mlx5_core_modify_hca_vport_context(mdev, 1, mdev_port_num,
+						 vf + 1, in);
 	if (!err)
 		vfs_ctx[vf].port_guid = guid;
+
+	mlx5_ib_put_native_port_mdev(dev, port);
+out:
 	kfree(in);
 	return err;
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
