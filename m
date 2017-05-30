From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Restore IB guid/policy for virtual functions
Date: Tue, 30 May 2017 10:18:24 +0300
Message-ID: <20170530071824.8933-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a user sets port_guid, node_guid or policy of an IB virtual
function, save this information in "struct mlx5_vf_context".

This information will be restored later when pci_resume is called.
To make sure this works, one can use aer-inject to generate PCI
errors on mlx5 devices and verify if relevant fields are restored
after PCI resume.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/ib_virt.c            |  9 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 42 +++++++++++++++++++++++++
 include/linux/mlx5/driver.h                     | 17 +++++-----
 3 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index c1b9de800fe5..649a3364f838 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -96,6 +96,7 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	int err;

 	in = kzalloc(sizeof(*in), GFP_KERNEL);
@@ -109,6 +110,8 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 	}
 	in->field_select = MLX5_HCA_VPORT_SEL_STATE_POLICY;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	if (!err)
+		vfs_ctx[vf].policy = in->policy;

 out:
 	kfree(in);
@@ -151,6 +154,7 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	int err;

 	in = kzalloc(sizeof(*in), GFP_KERNEL);
@@ -160,6 +164,8 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_NODE_GUID;
 	in->node_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	if (!err)
+		vfs_ctx[vf].node_guid = guid;
 	kfree(in);
 	return err;
 }
@@ -169,6 +175,7 @@ static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 	int err;

 	in = kzalloc(sizeof(*in), GFP_KERNEL);
@@ -178,6 +185,8 @@ static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_PORT_GUID;
 	in->port_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
+	if (!err)
+		vfs_ctx[vf].port_guid = guid;
 	kfree(in);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index e08627785590..78a5e3b510e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -32,6 +32,7 @@

 #include <linux/pci.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 #ifdef CONFIG_MLX5_CORE_EN
 #include "eswitch.h"
@@ -44,6 +45,38 @@ bool mlx5_sriov_is_enabled(struct mlx5_core_dev *dev)
 	return !!sriov->num_vfs;
 }

+static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf)
+{
+	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
+	struct mlx5_hca_vport_context *in;
+	int err = 0;
+
+	/* Restore sriov guid and policy settings */
+	if (sriov->vfs_ctx[vf].node_guid ||
+	    sriov->vfs_ctx[vf].port_guid ||
+	    sriov->vfs_ctx[vf].policy != MLX5_POLICY_INVALID) {
+		in = kzalloc(sizeof(*in), GFP_KERNEL);
+		if (!in)
+			return -ENOMEM;
+
+		in->node_guid = sriov->vfs_ctx[vf].node_guid;
+		in->port_guid = sriov->vfs_ctx[vf].port_guid;
+		in->policy = sriov->vfs_ctx[vf].policy;
+		in->field_select =
+			!!(in->port_guid) * MLX5_HCA_VPORT_SEL_PORT_GUID |
+			!!(in->node_guid) * MLX5_HCA_VPORT_SEL_NODE_GUID |
+			!!(in->policy) * MLX5_HCA_VPORT_SEL_STATE_POLICY;
+
+		err = mlx5_core_modify_hca_vport_context(dev, 1, 1, vf + 1, in);
+		if (err)
+			mlx5_core_warn(dev, "modify vport context failed, unable to restore VF %d settings\n", vf);
+
+		kfree(in);
+	}
+
+	return err;
+}
+
 static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
@@ -74,6 +107,15 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 		}
 		sriov->vfs_ctx[vf].enabled = 1;
 		sriov->enabled_vfs++;
+		if (MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_IB) {
+			err = sriov_restore_guids(dev, vf);
+			if (err) {
+				mlx5_core_warn(dev,
+					       "failed to restore VF %d settings, err %d\n",
+					       vf, err);
+			continue;
+			}
+		}
 		mlx5_core_dbg(dev, "successfully enabled VF* %d\n", vf);

 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2fcff6b4503f..3a3c229368bf 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -155,6 +155,13 @@ enum dbg_rsc_type {
 	MLX5_DBG_RSC_CQ,
 };

+enum port_state_policy {
+	MLX5_POLICY_DOWN	= 0,
+	MLX5_POLICY_UP		= 1,
+	MLX5_POLICY_FOLLOW	= 2,
+	MLX5_POLICY_INVALID	= 0xffffffff
+};
+
 struct mlx5_field_desc {
 	struct dentry	       *dent;
 	int			i;
@@ -518,6 +525,9 @@ struct mlx5_mkey_table {

 struct mlx5_vf_context {
 	int	enabled;
+	u64	port_guid;
+	u64	node_guid;
+	enum port_state_policy	policy;
 };

 struct mlx5_core_sriov {
@@ -812,13 +822,6 @@ struct mlx5_pas {
 	u8	log_sz;
 };

-enum port_state_policy {
-	MLX5_POLICY_DOWN	= 0,
-	MLX5_POLICY_UP		= 1,
-	MLX5_POLICY_FOLLOW	= 2,
-	MLX5_POLICY_INVALID	= 0xffffffff
-};
-
 enum phy_port_state {
 	MLX5_AAA_111
 };
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
