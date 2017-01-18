From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/7] IB/mlx5: Add additional checks before processing MADs
Date: Wed, 18 Jan 2017 14:10:33 +0200
Message-ID: <20170118121036.32642-5-leon@kernel.org>
References: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118121036.32642-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parvi Kaustubhi <parvik-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Check the has_smi bit in vport context and class version of MADs
before allowing MADs processing to take place.
MAD_IFC SMI commands can be executed only if smi bit is set.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Parvi Kaustubhi <parvik-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mad.c  | 12 ++++++++++++
 drivers/infiniband/hw/mlx5/main.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/mlx5/driver.h       |  1 +
 3 files changed, 46 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 39e5848..af962e7 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -42,12 +42,24 @@ enum {
 	MLX5_IB_VENDOR_CLASS2 = 0xa
 };
 
+static bool can_do_mad_ifc(struct mlx5_ib_dev *dev, u8 port_num,
+			   struct ib_mad *in_mad)
+{
+	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED &&
+	    in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+		return true;
+	return dev->mdev->port_caps[port_num - 1].has_smi;
+}
+
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		 const void *in_mad, void *response_mad)
 {
 	u8 op_modifier = 0;
 
+	if (!can_do_mad_ifc(dev, port, (struct ib_mad *)in_mad))
+		return -EPERM;
+
 	/* Key check traps can't be generated unless we have in_wc to
 	 * tell us where to send the trap.
 	 */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0187f1d..1dea407 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2533,6 +2533,35 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 		ibdev->ib_active = false;
 }
 
+static int set_has_smi_cap(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_hca_vport_context vport_ctx;
+	int err;
+	int port;
+
+	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++) {
+		dev->mdev->port_caps[port - 1].has_smi = false;
+		if (MLX5_CAP_GEN(dev->mdev, port_type) ==
+		    MLX5_CAP_PORT_TYPE_IB) {
+			if (MLX5_CAP_GEN(dev->mdev, ib_virt)) {
+				err = mlx5_query_hca_vport_context(dev->mdev, 0,
+								   port, 0,
+								   &vport_ctx);
+				if (err) {
+					mlx5_ib_err(dev, "query_hca_vport_context for port=%d failed %d\n",
+						    port, err);
+					return err;
+				}
+				dev->mdev->port_caps[port - 1].has_smi =
+					vport_ctx.has_smi;
+			} else {
+				dev->mdev->port_caps[port - 1].has_smi = true;
+			}
+		}
+	}
+	return 0;
+}
+
 static void get_ext_port_caps(struct mlx5_ib_dev *dev)
 {
 	int port;
@@ -2557,6 +2586,10 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
 	if (!dprops)
 		goto out;
 
+	err = set_has_smi_cap(dev);
+	if (err)
+		goto out;
+
 	err = mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
 	if (err) {
 		mlx5_ib_warn(dev, "query_device failed %d\n", err);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 10e6325..319c3e5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -290,6 +290,7 @@ struct mlx5_port_caps {
 	int	gid_table_len;
 	int	pkey_table_len;
 	u8	ext_port_cap;
+	bool	has_smi;
 };
 
 struct mlx5_cmd_mailbox {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
