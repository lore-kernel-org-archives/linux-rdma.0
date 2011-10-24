From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-3.2 v2 3/5] ib/mlx4: Add extended port capabilities support
Date: Mon, 24 Oct 2011 11:02:34 +0200
Message-ID: <201110241102.35104.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An Extended Port Info packet is sent to each hw port during HCA init
and if returns without error it is assumed the port supports
extended port capabilities.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGU/bZweECJiwQ@public.gmane.org>
---

Changes from v1
- method mlx4_get_ext_port_caps changed to mlx4_check_ext_port_caps
- extended port capabilities are assigned inside mlx4_check_ext_port_caps rather that in mlx4_setup_hca
- ext_port_cap field is u8 instead of u64
- minor warning notification change in mlx4_setup_hca

 drivers/net/mlx4/main.c     |    7 +++++++
 drivers/net/mlx4/mlx4.h     |    1 +
 drivers/net/mlx4/port.c     |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h |    7 +++++++
 4 files changed, 57 insertions(+)

--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -998,6 +998,13 @@ static int mlx4_setup_hca(struct mlx4_de
 				  "ib capabilities (%d). Continuing with "
 				  "caps = 0\n", port, err);
 		dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
+
+		err = mlx4_check_ext_port_caps(dev, port);
+		if (err)
+			mlx4_warn(dev, "failed to get port %d extended "
+				  "port capabilities support info (%d)."
+				  " Assuming not supported\n", port, err);
+
 		err = mlx4_SET_PORT(dev, port);
 		if (err) {
 			mlx4_err(dev, "Failed to set port %d, aborting\n",
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -450,6 +450,7 @@ void mlx4_init_vlan_table(struct mlx4_de
 
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
 int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
+int mlx4_check_ext_port_caps(struct mlx4_dev *dev, u8 port);
 
 int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  enum mlx4_protocol prot, enum mlx4_steer_type steer);
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -464,6 +464,48 @@ int mlx4_get_port_ib_caps(struct mlx4_de
 	return err;
 }
 
+int mlx4_check_ext_port_caps(struct mlx4_dev *dev, u8 port)
+{
+	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
+	u8 *inbuf, *outbuf;
+	int err, packet_error;
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
+
+	*(__be16 *) (&inbuf[16]) = MLX4_ATTR_EXTENDED_PORT_INFO;
+	*(__be32 *) (&inbuf[20]) = cpu_to_be32(port);
+
+	err = mlx4_cmd_box(dev, inmailbox->dma, outmailbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
+
+	packet_error = be16_to_cpu(*(__be16 *) (outbuf + 4));
+
+	dev->caps.ext_port_cap[port] = (!err && !packet_error) ?
+				       MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO
+				       : 0;
+
+	mlx4_free_cmd_mailbox(dev, inmailbox);
+	mlx4_free_cmd_mailbox(dev, outmailbox);
+	return err;
+}
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -82,6 +82,12 @@ enum {
 	MLX4_DEV_CAP_FLAG_COUNTERS	= 1LL << 48
 };
 
+#define MLX4_ATTR_EXTENDED_PORT_INFO	cpu_to_be16(0xff90)
+
+enum {
+	MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO	= 1 <<  0
+};
+
 enum {
 	MLX4_BMME_FLAG_LOCAL_INV	= 1 <<  6,
 	MLX4_BMME_FLAG_REMOTE_INV	= 1 <<  7,
@@ -276,6 +282,7 @@ struct mlx4_caps {
 	u32			port_mask;
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
+	u8			ext_port_cap[MLX4_MAX_PORTS + 1];
 };
 
 struct mlx4_buf_list {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
