From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/5] IB/mlx4: Do not allow APM under RoCE
Date: Thu, 11 Sep 2014 14:11:19 +0300
Message-ID: <1410433880-12439-5-git-send-email-ogerlitz@mellanox.com>
References: <1410433880-12439-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410433880-12439-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Automatic Path Migration is not supported under RoCE. Therefore,
return a "not-supported" error if the caller attempts to set
an alternate path in a QP context.

In addition, if there are no IB ports configured, do not report
APM capability in the device flags returned by mlx4_ib_query_device.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   16 +++++++++++++++-
 drivers/infiniband/hw/mlx4/qp.c   |    6 ++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 681a936..d4dd930 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -119,6 +119,17 @@ static int check_flow_steering_support(struct mlx4_dev *dev)
 	return dmfs;
 }
 
+static int num_ib_ports(struct mlx4_dev *dev)
+{
+	int ib_ports = 0;
+	int i;
+
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+		ib_ports++;
+
+	return ib_ports;
+}
+
 static int mlx4_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props)
 {
@@ -126,6 +137,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
+	int have_ib_ports;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -142,6 +154,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	memset(props, 0, sizeof *props);
 
+	have_ib_ports = num_ib_ports(dev->dev);
+
 	props->fw_ver = dev->dev->caps.fw_ver;
 	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
@@ -152,7 +166,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
 		props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
-	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_APM)
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_APM && have_ib_ports)
 		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_UD_AV_PORT)
 		props->device_cap_flags |= IB_DEVICE_UD_AV_PORT_ENFORCE;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 25e0208..393423c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1424,6 +1424,12 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	int steer_qp = 0;
 	int err = -EINVAL;
 
+	/* APM is not supported under RoCE */
+	if (attr_mask & IB_QP_ALT_PATH &&
+	    rdma_port_get_link_layer(&dev->ib_dev, qp->port) ==
+	    IB_LINK_LAYER_ETHERNET)
+		return -ENOTSUPP;
+
 	context = kzalloc(sizeof *context, GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
