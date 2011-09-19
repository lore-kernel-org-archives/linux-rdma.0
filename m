From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 4/4] ib/mlx4: get extended port capabilities
Date: Mon, 19 Sep 2011 19:06:59 +0300
Message-ID: <201109191906.59929.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An Extended Port Info packet is sent to each hw port during HCA init
and if returns without error it is assumed the port supports
extended port capabilities.

If the port supports extended capabilities and the active speed is
QDR, FDR-10 link encoding is set according to Extended Port Info.


Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   28 ++++++++++++++++++++++++++--
 drivers/net/mlx4/main.c           |   10 ++++++++++
 drivers/net/mlx4/mlx4.h           |    1 +
 drivers/net/mlx4/port.c           |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h       |    5 +++++
 5 files changed, 80 insertions(+), 2 deletions(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/main.c	2011-09-14 13:50:52.408510900 +0300
+++ b/drivers/infiniband/hw/mlx4/main.c	2011-09-14 13:51:05.926213900 +0300
@@ -54,6 +54,8 @@
 #define DRV_VERSION	"1.0"
 #define DRV_RELDATE	"April 4, 2008"
 
+#define MLX4_ATTR_EXTENDED_PORT_INFO            cpu_to_be16(0xff90)
+
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -272,9 +274,31 @@ static int mlx4_ib_query_port(struct ib_
 	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
+	if (mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND) {
+		ib_link_query_port(ibdev, port, props, out_mad);
 
-	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
-		ib_link_query_port(ibdev, port, props, out_mad) :
+		/* If reported active speed is QDR, check if is FDR-10 */
+		if (props->active_speed == 4) {
+			if (to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
+			    MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
+
+				init_query_mad(in_mad);
+				in_mad->attr_id = MLX4_ATTR_EXTENDED_PORT_INFO;
+				in_mad->attr_mod = cpu_to_be32(port);
+
+				err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
+						   NULL, NULL, in_mad, out_mad);
+
+				if (err || be16_to_cpu(*(__be16 *)
+				    (((u8 *)out_mad) + 4)))
+					goto out;
+
+				/* Checking LinkSpeedActive for FDR-10 */
+				if (out_mad->data[15] & 0x1)
+					props->link_encoding = 1;
+			}
+		}
+	} else
 		eth_link_query_port(ibdev, port, props, out_mad);
 
 out:
Index: b/drivers/net/mlx4/main.c
===================================================================
--- a/drivers/net/mlx4/main.c	2011-09-14 13:22:31.000000000 +0300
+++ b/drivers/net/mlx4/main.c	2011-09-14 13:51:05.934715600 +0300
@@ -881,6 +881,7 @@ static int mlx4_setup_hca(struct mlx4_de
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 	int port;
+	u64 ext_port_default_caps;
 	__be32 ib_port_default_caps;
 
 	err = mlx4_init_uar_table(dev);
@@ -998,6 +999,15 @@ static int mlx4_setup_hca(struct mlx4_de
 				  "ib capabilities (%d). Continuing with "
 				  "caps = 0\n", port, err);
 		dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
+
+		ext_port_default_caps = 0;
+		err = mlx4_get_ext_port_caps(dev, port, &ext_port_default_caps);
+		if (err)
+			mlx4_warn(dev, "failed to get port %d extended "
+				  "port capabilities support (%d). Assuming "
+				  "not supported\n", port, err);
+		dev->caps.ext_port_cap[port] = ext_port_default_caps;
+
 		err = mlx4_SET_PORT(dev, port);
 		if (err) {
 			mlx4_err(dev, "Failed to set port %d, aborting\n",
Index: b/drivers/net/mlx4/mlx4.h
===================================================================
--- a/drivers/net/mlx4/mlx4.h	2011-09-14 13:22:31.000000000 +0300
+++ b/drivers/net/mlx4/mlx4.h	2011-09-14 13:51:05.941216900 +0300
@@ -450,6 +450,7 @@ void mlx4_init_vlan_table(struct mlx4_de
 
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
 int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
+int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_ext_caps);
 
 int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  enum mlx4_protocol prot, enum mlx4_steer_type steer);
Index: b/drivers/net/mlx4/port.c
===================================================================
--- a/drivers/net/mlx4/port.c	2011-09-14 13:22:31.000000000 +0300
+++ b/drivers/net/mlx4/port.c	2011-09-14 13:51:05.947218100 +0300
@@ -464,6 +464,44 @@ int mlx4_get_port_ib_caps(struct mlx4_de
 	return err;
 }
 
+int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_ext_caps)
+{
+	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
+	u8 *inbuf, *outbuf;
+	int err;
+
+	inmailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(inmailbox))
+		return PTR_ERR(inmailbox);
+
+	outmailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(outmailbox)) {
+		mlx4_free_cmd_mailbox(dev, inmailbox);
+		return PTR_ERR(outmailbox);
+	}
+
+	inbuf = inmailbox->buf;
+	outbuf = outmailbox->buf;
+	memset(inbuf, 0, 256);
+	memset(outbuf, 0, 256);
+	inbuf[0] = 1;
+	inbuf[1] = 1;
+	inbuf[2] = 1;
+	inbuf[3] = 1;
+	*(__be16 *) (&inbuf[16]) = cpu_to_be16(0xff90);
+	*(__be32 *) (&inbuf[20]) = cpu_to_be32(port);
+
+	err = mlx4_cmd_box(dev, inmailbox->dma, outmailbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
+
+	if ((!err) && (!be16_to_cpu(*(__be16 *) (outbuf + 4))))
+		*get_ext_caps |= MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO;
+
+	mlx4_free_cmd_mailbox(dev, inmailbox);
+	mlx4_free_cmd_mailbox(dev, outmailbox);
+	return err;
+}
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
Index: b/include/linux/mlx4/device.h
===================================================================
--- a/include/linux/mlx4/device.h	2011-09-14 13:22:31.000000000 +0300
+++ b/include/linux/mlx4/device.h	2011-09-14 13:51:05.955219700 +0300
@@ -83,6 +83,10 @@ enum {
 };
 
 enum {
+	MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO	= 1 <<  0
+};
+
+enum {
 	MLX4_BMME_FLAG_LOCAL_INV	= 1 <<  6,
 	MLX4_BMME_FLAG_REMOTE_INV	= 1 <<  7,
 	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
@@ -276,6 +280,7 @@ struct mlx4_caps {
 	u32			port_mask;
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
+	u64                     ext_port_cap[MLX4_MAX_PORTS + 1];
 };
 
 struct mlx4_buf_list {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
