From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 4/4] ib/mlx4: get extended port capabilities
Date: Mon, 19 Sep 2011 18:03:39 +0300
Message-ID: <CAN+0-cZJ2PPnQ96HQmy=-k5P-UNdkv825SdjY_e2xbmzKEde3Q@mail.gmail.com>
References: <CAN+0-caTL5VMr_kQcVXSDp8v2TkoguRwTxu5pP2V-rW_0asHPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN+0-caTL5VMr_kQcVXSDp8v2TkoguRwTxu5pP2V-rW_0asHPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An Extended Port Info packet is sent to each hw port during HCA init
and if returns without error it is assumed the port supports
extended port capabilities.

If the port supports extended capabilities and the active speed is
QDR, FDR-10 link encoding is set according to Extended Port Info.


Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
drivers/infiniband/hw/mlx4/main.c | =A0 28 ++++++++++++++++++++++++++--
drivers/net/mlx4/main.c =A0 =A0 =A0 =A0 =A0 | =A0 10 ++++++++++
drivers/net/mlx4/mlx4.h =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
drivers/net/mlx4/port.c =A0 =A0 =A0 =A0 =A0 | =A0 38 ++++++++++++++++++=
++++++++++++++++++++
include/linux/mlx4/device.h =A0 =A0 =A0 | =A0 =A05 +++++
5 files changed, 80 insertions(+), 2 deletions(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/infiniband/hw/mlx4/main.c =A0 =A0 =A0 =A0 =A0 =A0 =A02011=
-09-14
13:50:52.408510900 +0300
+++ b/drivers/infiniband/hw/mlx4/main.c =A0 =A0 =A0 =A0 =A0 2011-09-14
13:51:05.926213900 +0300
@@ -54,6 +54,8 @@
#define DRV_VERSION =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"1.0"
#define DRV_RELDATE "April 4, 2008"

+#define MLX4_ATTR_EXTENDED_PORT_INFO =A0 =A0 =A0 =A0 =A0 =A0cpu_to_be1=
6(0xff90)
+
MODULE_AUTHOR("Roland Dreier");
MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
MODULE_LICENSE("Dual BSD/GPL");
@@ -272,9 +274,31 @@ static int mlx4_ib_query_port(struct ib_
=A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, =
port, NULL,
NULL, in_mad, out_mad);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
+ =A0 =A0 =A0 =A0 =A0 =A0 if (mlx4_ib_port_link_layer(ibdev, port) =3D=3D
IB_LINK_LAYER_INFINIBAND) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_link_query=
_port(ibdev, port, props, out_mad);

- =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D mlx4_ib_port_link_layer(ibdev, por=
t) =3D=3D
IB_LINK_LAYER_INFINIBAND ?
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ib_link_qu=
ery_port(ibdev, port, props, out_mad) :
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If reporte=
d active speed is QDR,
check if is FDR-10 */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (props->ac=
tive_speed =3D=3D 4) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 if
(to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
+
MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
+
+
init_query_mad(in_mad);
+
in_mad->attr_id =3D MLX4_ATTR_EXTENDED_PORT_INFO;
+
in_mad->attr_mod =3D cpu_to_be32(port);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D
mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
+
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, NULL, in_mad, =
out_mad);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err
|| be16_to_cpu(*(__be16 *)
+
(((u8 *)out_mad) + 4)))
+
=A0 =A0 =A0 goto out;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
Checking LinkSpeedActive for FDR-10 */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if
(out_mad->data[15] & 0x1)
+
=A0 =A0 =A0 props->link_encoding =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 =A0 =A0 =A0 } else
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eth_link_qu=
ery_port(ibdev, port, props, out_mad);

=A0out:
Index: b/drivers/net/mlx4/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/net/mlx4/main.c =A0 =A02011-09-14 13:22:31.000000000 +030=
0
+++ b/drivers/net/mlx4/main.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02011-09-14=
 13:51:05.934715600 +0300
@@ -881,6 +881,7 @@ static int mlx4_setup_hca(struct mlx4_de
=A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mlx4_priv *priv =3D mlx4_priv(dev);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 int port;
+ =A0 =A0 =A0 =A0 =A0 =A0 u64 ext_port_default_caps;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 __be32 ib_port_default_caps;

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D mlx4_init_uar_table(dev);
@@ -998,6 +999,15 @@ static int mlx4_setup_hca(struct mlx4_de
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ib
capabilities (%d). Continuing with "
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "caps
=3D 0\n", port, err);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev->caps.i=
b_port_def_cap[port] =3D
ib_port_default_caps;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_port_defa=
ult_caps =3D 0;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D mlx4_=
get_ext_port_caps(dev, port,
&ext_port_default_caps);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 mlx4_warn(dev, "failed
to get port %d extended "
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "port
capabilities support (%d). Assuming "
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "not
supported\n", port, err);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev->caps.ext=
_port_cap[port] =3D
ext_port_default_caps;
+
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D mlx=
4_SET_PORT(dev, port);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mlx4_err(dev, "Failed
to set port %d, aborting\n",
Index: b/drivers/net/mlx4/mlx4.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/net/mlx4/mlx4.h =A0 2011-09-14 13:22:31.000000000 +0300
+++ b/drivers/net/mlx4/mlx4.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02011-09-14=
 13:51:05.941216900 +0300
@@ -450,6 +450,7 @@ void mlx4_init_vlan_table(struct mlx4_de

=A0int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
+int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_ext=
_caps);

=A0int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, =
u8 gid[16],
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 enum mlx4_protocol
prot, enum mlx4_steer_type steer);
Index: b/drivers/net/mlx4/port.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/net/mlx4/port.c =A0 =A0 2011-09-14 13:22:31.000000000 +03=
00
+++ b/drivers/net/mlx4/port.c =A02011-09-14 13:51:05.947218100 +0300
@@ -464,6 +464,44 @@ int mlx4_get_port_ib_caps(struct mlx4_de
=A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
}

+int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_ext=
_caps)
+{
+ =A0 =A0 =A0 =A0 =A0 =A0 struct mlx4_cmd_mailbox *inmailbox, *outmailb=
ox;
+ =A0 =A0 =A0 =A0 =A0 =A0 u8 *inbuf, *outbuf;
+ =A0 =A0 =A0 =A0 =A0 =A0 int err;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 inmailbox =3D mlx4_alloc_cmd_mailbox(dev);
+ =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(inmailbox))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ER=
R(inmailbox);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 outmailbox =3D mlx4_alloc_cmd_mailbox(dev);
+ =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(outmailbox)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlx4_free_cmd=
_mailbox(dev, inmailbox);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ER=
R(outmailbox);
+ =A0 =A0 =A0 =A0 =A0 =A0 }
+
+ =A0 =A0 =A0 =A0 =A0 =A0 inbuf =3D inmailbox->buf;
+ =A0 =A0 =A0 =A0 =A0 =A0 outbuf =3D outmailbox->buf;
+ =A0 =A0 =A0 =A0 =A0 =A0 memset(inbuf, 0, 256);
+ =A0 =A0 =A0 =A0 =A0 =A0 memset(outbuf, 0, 256);
+ =A0 =A0 =A0 =A0 =A0 =A0 inbuf[0] =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 inbuf[1] =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 inbuf[2] =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 inbuf[3] =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 *(__be16 *) (&inbuf[16]) =3D cpu_to_be16(0xff=
90);
+ =A0 =A0 =A0 =A0 =A0 =A0 *(__be32 *) (&inbuf[20]) =3D cpu_to_be32(port=
);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 err =3D mlx4_cmd_box(dev, inmailbox->dma, out=
mailbox->dma, port, 3,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0MLX4_CMD_MAD_IFC,
MLX4_CMD_TIME_CLASS_C);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 if ((!err) && (!be16_to_cpu(*(__be16 *) (outb=
uf + 4))))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *get_ext_caps=
 |=3D
MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 mlx4_free_cmd_mailbox(dev, inmailbox);
+ =A0 =A0 =A0 =A0 =A0 =A0 mlx4_free_cmd_mailbox(dev, outmailbox);
+ =A0 =A0 =A0 =A0 =A0 =A0 return err;
+}
+
int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
{
=A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mlx4_cmd_mailbox *mailbox;
Index: b/include/linux/mlx4/device.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/linux/mlx4/device.h =A0 =A0 =A0 =A0 =A0 =A02011-09-14 13:=
22:31.000000000 +0300
+++ b/include/linux/mlx4/device.h =A0 =A0 =A0 =A0 2011-09-14 13:51:05.9=
55219700 +0300
@@ -83,6 +83,10 @@ enum {
};

=A0enum {
+ =A0 =A0 =A0 =A0 =A0 =A0 MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO =A0 =
=A0=3D 1 << =A00
+};
+
+enum {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 MLX4_BMME_FLAG_LOCAL_INV =A0 =A0 =A0 =A0 =A0=
 =A0 =3D 1 << =A06,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 MLX4_BMME_FLAG_REMOTE_INV =A0 =A0 =A0 =A0 =3D=
 1 << =A07,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 MLX4_BMME_FLAG_TYPE_2_WIN =A0 =A0 =A0 =A0 =A0=
=3D 1 << =A09,
@@ -276,6 +280,7 @@ struct mlx4_caps {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_mask;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 enum mlx4_port_type =A0possible_type[MLX4_M=
AX_PORTS + 1];
=A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_counters;
+ =A0 =A0 =A0 =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 e=
xt_port_cap[MLX4_MAX_PORTS + 1];
};

=A0struct mlx4_buf_list {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
