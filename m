From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Fix configuration of port capabilities
Date: Tue, 14 Feb 2017 07:25:38 +0200
Message-ID: <20170214052538.16562-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When the "ib_virt" cap it set, configuration of port capabilities need
to be done through mlx5_core_modify_hca_vport_context.
Since modify_hca_vport_context accepts mask and value, there is no need
to read the port capabilities and calculate the new cap values so we
avoid the mutex when ib_virt is set.

Fixes: e126ba97dba9edeb ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc02f5f05b38..b2baf77db59e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -985,6 +985,31 @@ static int mlx5_ib_modify_device(struct ib_device *ibdev, int mask,
 	return err;
 }

+static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u8 port_num, u32 mask,
+				u32 value)
+{
+	struct mlx5_hca_vport_context ctx = {};
+	int err;
+
+	err = mlx5_query_hca_vport_context(dev->mdev, 0,
+					   port_num, 0, &ctx);
+	if (err)
+		return err;
+
+	if (~ctx.cap_mask1_perm & mask) {
+		mlx5_ib_warn(dev, "trying to change bitmask 0x%X but change supported 0x%X\n",
+			     mask, ctx.cap_mask1_perm);
+		return -EINVAL;
+	}
+
+	ctx.cap_mask1 = value;
+	ctx.cap_mask1_perm = mask;
+	err = mlx5_core_modify_hca_vport_context(dev->mdev, 0,
+						 port_num, 0, &ctx);
+
+	return err;
+}
+
 static int mlx5_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
 			       struct ib_port_modify *props)
 {
@@ -992,6 +1017,16 @@ static int mlx5_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
 	struct ib_port_attr attr;
 	u32 tmp;
 	int err;
+	u32 change_mask;
+	u32 value;
+	bool is_ib = (mlx5_ib_port_link_layer(ibdev, port) ==
+		      IB_LINK_LAYER_INFINIBAND);
+
+	if (MLX5_CAP_GEN(dev->mdev, ib_virt) && is_ib) {
+		change_mask = props->clr_port_cap_mask | props->set_port_cap_mask;
+		value = ~props->clr_port_cap_mask | props->set_port_cap_mask;
+		return set_port_caps_atomic(dev, port, change_mask, value);
+	}

 	mutex_lock(&dev->cap_mask_mutex);

--
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
