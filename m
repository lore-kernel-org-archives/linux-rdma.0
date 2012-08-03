From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 08/22] IB/mlx4: SRIOV multiplex and demultiplex MADs
Date: Fri,  3 Aug 2012 11:40:44 +0300
Message-ID: <1343983258-6268-9-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Special QPs are para-virtualized.

vHCAs are not given direct access to QP0/1. Rather, these QPs are opera=
ted by a
special context hosted by the PF, which mediates access to/from vHCAs.
This is done by opening a =E2=80=9Ctunnel=E2=80=9D per vHCA port per QP=
0/1. A tunnel comprises
a pair of UD QPs:  a =E2=80=9CTunnel QP=E2=80=9D in the PF-context and =
a =E2=80=9CProxy QP=E2=80=9D in the vHCA.
All vHCA MAD traffic must pass through the corresponding tunnel.
vHCA QPs cannot be assigned to VL15 and are denied of the well-known QK=
ey.

Outgoing messages are "de-multiplexed" (i.e., directed to the wire via
the real special QP).

Incoming messages are "multiplexed" (i.e. steered by the PPF to the cor=
rect
VF or to the PF)

QP0 access is restricted to the PF vHCA. VF vHCAs also have (virtual) Q=
P0=E2=80=99s,
but they never receive any SMPs and all SMPs sent are discarded.
QP1 traffic is allowed for all vHCAs, but special care is required to b=
ridge
the gap between the host and network views.

Specifically:
- Transaction IDs are mapped to guarantee uniqueness among vHCAs
- CM para-virtualization
  o   Incoming requests are steered to the correct vHCA according to th=
e embedded GID
  o   Local communication IDs are mapped to ensure uniqueness among vHC=
As
  (see the patch that adds CM paravirtualization.)
- Multicast para-virtualization
  o   The PF context aggregates membership state from all vHCAs
  o   The SA is contacted only when the aggregate membership changes
  o   If the aggregate does not change, the PF context will provide the
       requesting vHCA with the proper response
  (see the patch that adds multicast group paravirtualization.)

Incoming MADs are steered according to:
- the DGID If a GRH is present
- the mapped transaction ID for response MADs
- the embedded GID in CM requests
- the remote communication ID in other CM messages

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |  567 ++++++++++++++++++++++++++++++=
+++++++-
 1 files changed, 565 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/m=
lx4/mad.c
index 2413a08..a392a5c 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -32,6 +32,8 @@
=20
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
+#include <rdma/ib_sa.h>
+#include <rdma/ib_cache.h>
=20
 #include <linux/mlx4/cmd.h>
 #include <linux/gfp.h>
@@ -296,6 +298,254 @@ static void forward_trap(struct mlx4_ib_dev *dev,=
 u8 port_num, struct ib_mad *ma
 	}
 }
=20
+static int mlx4_ib_demux_sa_handler(struct ib_device *ibdev, int port,=
 int slave,
+							     struct ib_sa_mad *sa_mad)
+{
+	return 0;
+}
+
+int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 gui=
d)
+{
+	struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
+	int i;
+
+	for (i =3D 0; i < dev->dev->caps.sqp_demux; i++) {
+		if (dev->sriov.demux[port - 1].guid_cache[i] =3D=3D guid)
+			return i;
+	}
+	return -1;
+}
+
+
+static int get_pkey_phys_indices(struct mlx4_ib_dev *ibdev, u8 port, u=
8 ph_pkey_ix,
+				 u8 *full_pk_ix, u8 *partial_pk_ix,
+				 int *is_full_member)
+{
+	u16 search_pkey;
+	int fm;
+	int err =3D 0;
+	u16 pk;
+
+	err =3D ib_get_cached_pkey(&ibdev->ib_dev, port, ph_pkey_ix, &search_=
pkey);
+	if (err)
+		return err;
+
+	fm =3D (search_pkey & 0x8000) ? 1 : 0;
+	if (fm) {
+		*full_pk_ix =3D ph_pkey_ix;
+		search_pkey &=3D 0x7FFF;
+	} else {
+		*partial_pk_ix =3D ph_pkey_ix;
+		search_pkey |=3D 0x8000;
+	}
+
+	if (ib_find_exact_cached_pkey(&ibdev->ib_dev, port, search_pkey, &pk)=
)
+		pk =3D 0xFFFF;
+
+	if (fm)
+		*partial_pk_ix =3D (pk & 0xFF);
+	else
+		*full_pk_ix =3D (pk & 0xFF);
+
+	*is_full_member =3D fm;
+	return err;
+}
+
+int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
+			  enum ib_qp_type dest_qpt, struct ib_wc *wc,
+			  struct ib_grh *grh, struct ib_mad *mad)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+	struct mlx4_ib_demux_pv_ctx *tun_ctx;
+	struct mlx4_ib_demux_pv_qp *tun_qp;
+	struct mlx4_rcv_tunnel_mad *tun_mad;
+	struct ib_ah_attr attr;
+	struct ib_ah *ah;
+	struct ib_qp *src_qp =3D NULL;
+	unsigned tun_tx_ix =3D 0;
+	int dqpn;
+	int ret =3D 0;
+	int i;
+	int is_full_member =3D 0;
+	u16 tun_pkey_ix;
+	u8 ph_pkey_ix, full_pk_ix =3D 0, partial_pk_ix =3D 0;
+
+	if (dest_qpt > IB_QPT_GSI)
+		return -EINVAL;
+
+	tun_ctx =3D dev->sriov.demux[port-1].tun[slave];
+
+	/* check if proxy qp created */
+	if (!tun_ctx || tun_ctx->state !=3D DEMUX_PV_STATE_ACTIVE)
+		return -EAGAIN;
+
+	/* QP0 forwarding only for Dom0 */
+	if (!dest_qpt && (mlx4_master_func_num(dev->dev) !=3D slave))
+		return -EINVAL;
+
+	if (!dest_qpt)
+		tun_qp =3D &tun_ctx->qp[0];
+	else
+		tun_qp =3D &tun_ctx->qp[1];
+
+	/* compute pkey index for slave */
+	/* get physical pkey -- virtualized Dom0 pkey to phys*/
+	if (dest_qpt) {
+		ph_pkey_ix =3D
+			dev->pkeys.virt2phys_pkey[mlx4_master_func_num(dev->dev)][port - 1]=
[wc->pkey_index];
+
+		/* now, translate this to the slave pkey index */
+		ret =3D get_pkey_phys_indices(dev, port, ph_pkey_ix, &full_pk_ix,
+					    &partial_pk_ix, &is_full_member);
+		if (ret)
+			return -EINVAL;
+
+		for (i =3D 0; i < dev->dev->caps.pkey_table_len[port]; i++) {
+			if ((dev->pkeys.virt2phys_pkey[slave][port - 1][i] =3D=3D full_pk_i=
x) ||
+			    (is_full_member &&
+			     (dev->pkeys.virt2phys_pkey[slave][port - 1][i] =3D=3D partial_=
pk_ix)))
+				break;
+		}
+		if (i =3D=3D dev->dev->caps.pkey_table_len[port])
+			return -EINVAL;
+		tun_pkey_ix =3D i;
+	} else
+		tun_pkey_ix =3D dev->pkeys.virt2phys_pkey[slave][port - 1][0];
+
+	dqpn =3D dev->dev->caps.sqp_start + 8 * slave + port + (dest_qpt * 2)=
 - 1;
+
+	/* get tunnel tx data buf for slave */
+	src_qp =3D tun_qp->qp;
+
+	/* create ah. Just need an empty one with the port num for the post s=
end.
+	 * The driver will set the force loopback bit in post_send */
+	memset(&attr, 0, sizeof attr);
+	attr.port_num =3D port;
+	ah =3D ib_create_ah(tun_ctx->pd, &attr);
+	if (IS_ERR(ah))
+		return -ENOMEM;
+
+	/* allocate tunnel tx buf after pass failure returns */
+	spin_lock(&tun_qp->tx_lock);
+	if (tun_qp->tx_ix_head - tun_qp->tx_ix_tail >=3D
+	    (MLX4_NUM_TUNNEL_BUFS - 1))
+		ret =3D -EAGAIN;
+	else
+		tun_tx_ix =3D (++tun_qp->tx_ix_head) & (MLX4_NUM_TUNNEL_BUFS - 1);
+	spin_unlock(&tun_qp->tx_lock);
+	if (ret)
+		goto out;
+
+	tun_mad =3D (struct mlx4_rcv_tunnel_mad *) (tun_qp->tx_ring[tun_tx_ix=
].buf.addr);
+	if (tun_qp->tx_ring[tun_tx_ix].ah)
+		ib_destroy_ah(tun_qp->tx_ring[tun_tx_ix].ah);
+	tun_qp->tx_ring[tun_tx_ix].ah =3D ah;
+	ib_dma_sync_single_for_cpu(&dev->ib_dev,
+				   tun_qp->tx_ring[tun_tx_ix].buf.map,
+				   sizeof(struct mlx4_rcv_tunnel_mad),
+				   DMA_TO_DEVICE);
+
+	/* copy over to tunnel buffer */
+	if (grh)
+		memcpy(&tun_mad->grh, grh, sizeof(*grh));
+	memcpy(&tun_mad->mad, mad, sizeof(*mad));
+
+	/* adjust tunnel data */
+	tun_mad->hdr.pkey_index =3D cpu_to_be16(tun_pkey_ix);
+	tun_mad->hdr.sl_vid =3D cpu_to_be16(((u16)(wc->sl)) << 12);
+	tun_mad->hdr.slid_mac_47_32 =3D cpu_to_be16(wc->slid);
+	tun_mad->hdr.flags_src_qp =3D cpu_to_be32(wc->src_qp & 0xFFFFFF);
+	tun_mad->hdr.g_ml_path =3D (grh && (wc->wc_flags & IB_WC_GRH)) ? 0x80=
 : 0;
+
+	ib_dma_sync_single_for_device(&dev->ib_dev,
+				      tun_qp->tx_ring[tun_tx_ix].buf.map,
+				      sizeof(struct mlx4_rcv_tunnel_mad),
+				      DMA_TO_DEVICE);
+
+	list.addr =3D tun_qp->tx_ring[tun_tx_ix].buf.map;
+	list.length =3D sizeof(struct mlx4_rcv_tunnel_mad);
+	list.lkey =3D tun_ctx->mr->lkey;
+
+	wr.wr.ud.ah =3D ah;
+	wr.wr.ud.port_num =3D port;
+	wr.wr.ud.remote_qkey =3D IB_QP_SET_QKEY;
+	wr.wr.ud.remote_qpn =3D dqpn;
+	wr.next =3D NULL;
+	wr.wr_id =3D ((u64) tun_tx_ix) | MLX4_TUN_SET_WRID_QPN(dest_qpt);
+	wr.sg_list =3D &list;
+	wr.num_sge =3D 1;
+	wr.opcode =3D IB_WR_SEND;
+	wr.send_flags =3D IB_SEND_SIGNALED;
+
+	ret =3D ib_post_send(src_qp, &wr, &bad_wr);
+out:
+	if (ret)
+		ib_destroy_ah(ah);
+	return ret;
+}
+
+static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
+			struct ib_wc *wc, struct ib_grh *grh,
+			struct ib_mad *mad)
+{
+	struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
+	int err;
+	int slave;
+	u8 *slave_id;
+
+	/* Initially assume that this mad is for us */
+	slave =3D mlx4_master_func_num(dev->dev);
+
+	/* See if the slave id is encoded in a response mad */
+	if (mad->mad_hdr.method & 0x80) {
+		slave_id =3D (u8 *) &mad->mad_hdr.tid;
+		slave =3D *slave_id;
+		if (slave !=3D 255) /*255 indicates the dom0*/
+			*slave_id =3D 0; /* remap tid */
+	}
+
+	/* If a grh is present, we demux according to it */
+	if (wc->wc_flags & IB_WC_GRH) {
+		slave =3D mlx4_ib_find_real_gid(ibdev, port, grh->dgid.global.interf=
ace_id);
+		if (slave < 0) {
+			mlx4_ib_warn(ibdev, "failed matching grh\n");
+			return -ENOENT;
+		}
+	}
+	/* Class-specific handling */
+	switch (mad->mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_ADM:
+		if (mlx4_ib_demux_sa_handler(ibdev, port, slave,
+					     (struct ib_sa_mad *) mad))
+			return 0;
+		break;
+	case IB_MGMT_CLASS_DEVICE_MGMT:
+		if (mad->mad_hdr.method !=3D IB_MGMT_METHOD_GET_RESP)
+			return 0;
+		break;
+	default:
+		/* Drop unsupported classes for slaves in tunnel mode */
+		if (slave !=3D mlx4_master_func_num(dev->dev)) {
+			pr_debug("dropping unsupported ingress mad from class:%d "
+				 "for slave:%d\n", mad->mad_hdr.mgmt_class, slave);
+			return 0;
+		}
+	}
+	/*make sure that no slave=3D=3D255 was not handled yet.*/
+	if (slave >=3D dev->dev->caps.sqp_demux) {
+		mlx4_ib_warn(ibdev, "slave id: %d is bigger than allowed:%d\n",
+			     slave, dev->dev->caps.sqp_demux);
+		return -ENOENT;
+	}
+
+	err =3D mlx4_ib_send_to_slave(dev, slave, port, wc->qp->qp_type, wc, =
grh, mad);
+	if (err)
+		pr_debug("failed sending to slave %d via tunnel qp (%d)\n",
+			 slave, err);
+	return 0;
+}
+
 static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 p=
ort_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
 			struct ib_mad *in_mad, struct ib_mad *out_mad)
@@ -607,6 +857,216 @@ static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_=
demux_pv_ctx *ctx,
 	return ib_post_recv(tun_qp->qp, &recv_wr, &bad_recv_wr);
 }
=20
+static int mlx4_ib_multiplex_sa_handler(struct ib_device *ibdev, int p=
ort,
+		int slave, struct ib_sa_mad *sa_mad)
+{
+	return 0;
+}
+
+static int is_proxy_qp0(struct mlx4_ib_dev *dev, int qpn, int slave)
+{
+	int slave_start =3D dev->dev->caps.sqp_start + 8 * slave;
+
+	return (qpn >=3D slave_start && qpn <=3D slave_start + 1);
+}
+
+
+int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
+			 enum ib_qp_type dest_qpt, u16 pkey_index, u32 remote_qpn,
+			 u32 qkey, struct ib_ah_attr *attr, struct ib_mad *mad)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+	struct mlx4_ib_demux_pv_ctx *sqp_ctx;
+	struct mlx4_ib_demux_pv_qp *sqp;
+	struct mlx4_mad_snd_buf *sqp_mad;
+	struct ib_ah *ah;
+	struct ib_qp *send_qp =3D NULL;
+	unsigned wire_tx_ix =3D 0;
+	int ret =3D 0;
+	u16 wire_pkey_ix;
+	int src_qpnum;
+	u8 sgid_index;
+
+
+	sqp_ctx =3D dev->sriov.sqps[port-1];
+
+	/* check if proxy qp created */
+	if (!sqp_ctx || sqp_ctx->state !=3D DEMUX_PV_STATE_ACTIVE)
+		return -EAGAIN;
+
+	/* QP0 forwarding only for Dom0 */
+	if (dest_qpt =3D=3D IB_QPT_SMI && (mlx4_master_func_num(dev->dev) !=3D=
 slave))
+		return -EINVAL;
+
+	if (dest_qpt =3D=3D IB_QPT_SMI) {
+		src_qpnum =3D 0;
+		sqp =3D &sqp_ctx->qp[0];
+		wire_pkey_ix =3D dev->pkeys.virt2phys_pkey[slave][port - 1][0];
+	} else {
+		src_qpnum =3D 1;
+		sqp =3D &sqp_ctx->qp[1];
+		wire_pkey_ix =3D dev->pkeys.virt2phys_pkey[slave][port - 1][pkey_ind=
ex];
+	}
+
+	send_qp =3D sqp->qp;
+
+	/* create ah */
+	sgid_index =3D attr->grh.sgid_index;
+	attr->grh.sgid_index =3D 0;
+	ah =3D ib_create_ah(sqp_ctx->pd, attr);
+	if (IS_ERR(ah))
+		return -ENOMEM;
+	attr->grh.sgid_index =3D sgid_index;
+	to_mah(ah)->av.ib.gid_index =3D sgid_index;
+	/* get rid of force-loopback bit */
+	to_mah(ah)->av.ib.port_pd &=3D cpu_to_be32(0x7FFFFFFF);
+	spin_lock(&sqp->tx_lock);
+	if (sqp->tx_ix_head - sqp->tx_ix_tail >=3D
+	    (MLX4_NUM_TUNNEL_BUFS - 1))
+		ret =3D -EAGAIN;
+	else
+		wire_tx_ix =3D (++sqp->tx_ix_head) & (MLX4_NUM_TUNNEL_BUFS - 1);
+	spin_unlock(&sqp->tx_lock);
+	if (ret)
+		goto out;
+
+	sqp_mad =3D (struct mlx4_mad_snd_buf *) (sqp->tx_ring[wire_tx_ix].buf=
=2Eaddr);
+	if (sqp->tx_ring[wire_tx_ix].ah)
+		ib_destroy_ah(sqp->tx_ring[wire_tx_ix].ah);
+	sqp->tx_ring[wire_tx_ix].ah =3D ah;
+	ib_dma_sync_single_for_cpu(&dev->ib_dev,
+				   sqp->tx_ring[wire_tx_ix].buf.map,
+				   sizeof(struct mlx4_mad_snd_buf),
+				   DMA_TO_DEVICE);
+
+	memcpy(&sqp_mad->payload, mad, sizeof(*mad));
+
+	ib_dma_sync_single_for_device(&dev->ib_dev,
+				      sqp->tx_ring[wire_tx_ix].buf.map,
+				      sizeof(struct mlx4_mad_snd_buf),
+				      DMA_TO_DEVICE);
+
+	list.addr =3D sqp->tx_ring[wire_tx_ix].buf.map;
+	list.length =3D sizeof(struct mlx4_mad_snd_buf);
+	list.lkey =3D sqp_ctx->mr->lkey;
+
+	wr.wr.ud.ah =3D ah;
+	wr.wr.ud.port_num =3D port;
+	wr.wr.ud.pkey_index =3D wire_pkey_ix;
+	wr.wr.ud.remote_qkey =3D qkey;
+	wr.wr.ud.remote_qpn =3D remote_qpn;
+	wr.next =3D NULL;
+	wr.wr_id =3D ((u64) wire_tx_ix) | MLX4_TUN_SET_WRID_QPN(src_qpnum);
+	wr.sg_list =3D &list;
+	wr.num_sge =3D 1;
+	wr.opcode =3D IB_WR_SEND;
+	wr.send_flags =3D IB_SEND_SIGNALED;
+
+	ret =3D ib_post_send(send_qp, &wr, &bad_wr);
+out:
+	if (ret)
+		ib_destroy_ah(ah);
+	return ret;
+}
+
+static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, st=
ruct ib_wc *wc)
+{
+	struct mlx4_ib_dev *dev =3D to_mdev(ctx->ib_dev);
+	struct mlx4_ib_demux_pv_qp *tun_qp =3D &ctx->qp[MLX4_TUN_WRID_QPN(wc-=
>wr_id)];
+	int wr_ix =3D wc->wr_id & (MLX4_NUM_TUNNEL_BUFS - 1);
+	struct mlx4_tunnel_mad *tunnel =3D tun_qp->ring[wr_ix].addr;
+	struct mlx4_ib_ah ah;
+	struct ib_ah_attr ah_attr;
+	u8 *slave_id;
+	int slave;
+
+	/* Get slave that sent this packet */
+	if (wc->src_qp < dev->dev->caps.sqp_start ||
+	    wc->src_qp >=3D dev->dev->caps.base_tunnel_sqpn ||
+	    (wc->src_qp & 0x1) !=3D ctx->port - 1 ||
+	    wc->src_qp & 0x4) {
+		mlx4_ib_warn(ctx->ib_dev, "can't multiplex bad sqp:%d\n", wc->src_qp=
);
+		return;
+	}
+	slave =3D ((wc->src_qp & ~0x7) - dev->dev->caps.sqp_start) / 8;
+	if (slave !=3D ctx->slave) {
+		mlx4_ib_warn(ctx->ib_dev, "can't multiplex bad sqp:%d: "
+			     "belongs to another slave\n", wc->src_qp);
+		return;
+	}
+	if (slave !=3D mlx4_master_func_num(dev->dev) && !(wc->src_qp & 0x2))=
 {
+		mlx4_ib_warn(ctx->ib_dev, "can't multiplex bad sqp:%d: "
+			     "non-master trying to send QP0 packets\n", wc->src_qp);
+		return;
+	}
+
+	/* Map transaction ID */
+	ib_dma_sync_single_for_cpu(ctx->ib_dev, tun_qp->ring[wr_ix].map,
+				   sizeof(struct mlx4_tunnel_mad),
+				   DMA_FROM_DEVICE);
+	switch (tunnel->mad.mad_hdr.method) {
+	case IB_MGMT_METHOD_SET:
+	case IB_MGMT_METHOD_GET:
+	case IB_MGMT_METHOD_REPORT:
+	case IB_SA_METHOD_GET_TABLE:
+	case IB_SA_METHOD_DELETE:
+	case IB_SA_METHOD_GET_MULTI:
+	case IB_SA_METHOD_GET_TRACE_TBL:
+		slave_id =3D (u8 *) &tunnel->mad.mad_hdr.tid;
+		if (*slave_id) {
+			mlx4_ib_warn(ctx->ib_dev, "egress mad has non-null tid msb:%d "
+				     "class:%d slave:%d\n", *slave_id,
+				     tunnel->mad.mad_hdr.mgmt_class, slave);
+			return;
+		} else
+			*slave_id =3D slave;
+	default:
+		/* nothing */;
+	}
+
+	/* Class-specific handling */
+	switch (tunnel->mad.mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_ADM:
+		if (mlx4_ib_multiplex_sa_handler(ctx->ib_dev, ctx->port, slave,
+			      (struct ib_sa_mad *) &tunnel->mad))
+			return;
+		break;
+	case IB_MGMT_CLASS_DEVICE_MGMT:
+		if (tunnel->mad.mad_hdr.method !=3D IB_MGMT_METHOD_GET &&
+		    tunnel->mad.mad_hdr.method !=3D IB_MGMT_METHOD_SET)
+			return;
+		break;
+	default:
+		/* Drop unsupported classes for slaves in tunnel mode */
+		if (slave !=3D mlx4_master_func_num(dev->dev)) {
+			mlx4_ib_warn(ctx->ib_dev, "dropping unsupported egress mad from cla=
ss:%d "
+				     "for slave:%d\n", tunnel->mad.mad_hdr.mgmt_class, slave);
+			return;
+		}
+	}
+
+	/* We are using standard ib_core services to send the mad, so generat=
e a
+	 * stadard address handle by decoding the tunnelled mlx4_ah fields */
+	memcpy(&ah.av, &tunnel->hdr.av, sizeof(struct mlx4_av));
+	ah.ibah.device =3D ctx->ib_dev;
+	mlx4_ib_query_ah(&ah.ibah, &ah_attr);
+	if ((ah_attr.ah_flags & IB_AH_GRH) &&
+	    (ah_attr.grh.sgid_index !=3D slave)) {
+		mlx4_ib_warn(ctx->ib_dev, "slave:%d accessed invalid sgid_index:%d\n=
",
+			     slave, ah_attr.grh.sgid_index);
+		return;
+	}
+
+	mlx4_ib_send_to_wire(dev, slave, ctx->port,
+			     is_proxy_qp0(dev, wc->src_qp, slave) ?
+			     IB_QPT_SMI : IB_QPT_GSI,
+			     be16_to_cpu(tunnel->hdr.pkey_index),
+			     be32_to_cpu(tunnel->hdr.remote_qpn),
+			     be32_to_cpu(tunnel->hdr.qkey),
+			     &ah_attr, &tunnel->mad);
+}
+
 static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 				 enum ib_qp_type qp_type, int is_tun)
 {
@@ -731,7 +1191,57 @@ static void mlx4_ib_free_pv_qp_bufs(struct mlx4_i=
b_demux_pv_ctx *ctx,
=20
 static void mlx4_ib_tunnel_comp_worker(struct work_struct *work)
 {
-	/* dummy until next patch in series */
+	struct mlx4_ib_demux_pv_ctx *ctx;
+	struct mlx4_ib_demux_pv_qp *tun_qp;
+	struct ib_wc wc;
+	int ret;
+	ctx =3D container_of(work, struct mlx4_ib_demux_pv_ctx, work);
+	ib_req_notify_cq(ctx->cq, IB_CQ_NEXT_COMP);
+
+	while (ib_poll_cq(ctx->cq, 1, &wc) =3D=3D 1) {
+		tun_qp =3D &ctx->qp[MLX4_TUN_WRID_QPN(wc.wr_id)];
+		if (wc.status =3D=3D IB_WC_SUCCESS) {
+			switch (wc.opcode) {
+			case IB_WC_RECV:
+				mlx4_ib_multiplex_mad(ctx, &wc);
+				ret =3D mlx4_ib_post_pv_qp_buf(ctx, tun_qp,
+							     wc.wr_id &
+							     (MLX4_NUM_TUNNEL_BUFS - 1));
+				if (ret)
+					pr_err("Failed reposting tunnel "
+					       "buf:%lld\n", wc.wr_id);
+				break;
+			case IB_WC_SEND:
+				pr_debug("received tunnel send completion:"
+					 "wrid=3D0x%llx, status=3D0x%x\n",
+					 wc.wr_id, wc.status);
+				ib_destroy_ah(tun_qp->tx_ring[wc.wr_id &
+					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
+				tun_qp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
+					=3D NULL;
+				spin_lock(&tun_qp->tx_lock);
+				tun_qp->tx_ix_tail++;
+				spin_unlock(&tun_qp->tx_lock);
+
+				break;
+			default:
+				break;
+			}
+		} else  {
+			pr_debug("mlx4_ib: completion error in tunnel: %d."
+				 " status =3D %d, wrid =3D 0x%llx\n",
+				 ctx->slave, wc.status, wc.wr_id);
+			if (!MLX4_TUN_IS_RECV(wc.wr_id)) {
+				ib_destroy_ah(tun_qp->tx_ring[wc.wr_id &
+					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
+				tun_qp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
+					=3D NULL;
+				spin_lock(&tun_qp->tx_lock);
+				tun_qp->tx_ix_tail++;
+				spin_unlock(&tun_qp->tx_lock);
+			}
+		}
+	}
 }
=20
 static void pv_qp_event_handler(struct ib_event *event, void *qp_conte=
xt)
@@ -839,7 +1349,60 @@ err_qp:
  */
 static void mlx4_ib_sqp_comp_worker(struct work_struct *work)
 {
-	/* dummy until next patch in series */
+	struct mlx4_ib_demux_pv_ctx *ctx;
+	struct mlx4_ib_demux_pv_qp *sqp;
+	struct ib_wc wc;
+	struct ib_grh *grh;
+	struct ib_mad *mad;
+
+	ctx =3D container_of(work, struct mlx4_ib_demux_pv_ctx, work);
+	ib_req_notify_cq(ctx->cq, IB_CQ_NEXT_COMP);
+
+	while (mlx4_ib_poll_cq(ctx->cq, 1, &wc) =3D=3D 1) {
+		sqp =3D &ctx->qp[MLX4_TUN_WRID_QPN(wc.wr_id)];
+		if (wc.status =3D=3D IB_WC_SUCCESS) {
+			switch (wc.opcode) {
+			case IB_WC_SEND:
+				ib_destroy_ah(sqp->tx_ring[wc.wr_id &
+					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
+				sqp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
+					=3D NULL;
+				spin_lock(&sqp->tx_lock);
+				sqp->tx_ix_tail++;
+				spin_unlock(&sqp->tx_lock);
+				break;
+			case IB_WC_RECV:
+				mad =3D (struct ib_mad *) &(((struct mlx4_mad_rcv_buf *)
+						(sqp->ring[wc.wr_id &
+						(MLX4_NUM_TUNNEL_BUFS - 1)].addr))->payload);
+				grh =3D &(((struct mlx4_mad_rcv_buf *)
+						(sqp->ring[wc.wr_id &
+						(MLX4_NUM_TUNNEL_BUFS - 1)].addr))->grh);
+				mlx4_ib_demux_mad(ctx->ib_dev, ctx->port, &wc, grh, mad);
+				if (mlx4_ib_post_pv_qp_buf(ctx, sqp, wc.wr_id &
+							   (MLX4_NUM_TUNNEL_BUFS - 1)))
+					pr_err("Failed reposting SQP "
+					       "buf:%lld\n", wc.wr_id);
+				break;
+			default:
+				BUG_ON(1);
+				break;
+			}
+		} else  {
+			pr_debug("mlx4_ib: completion error in tunnel: %d."
+				 " status =3D %d, wrid =3D 0x%llx\n",
+				 ctx->slave, wc.status, wc.wr_id);
+			if (!MLX4_TUN_IS_RECV(wc.wr_id)) {
+				ib_destroy_ah(sqp->tx_ring[wc.wr_id &
+					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
+				sqp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
+					=3D NULL;
+				spin_lock(&sqp->tx_lock);
+				sqp->tx_ix_tail++;
+				spin_unlock(&sqp->tx_lock);
+			}
+		}
+	}
 }
=20
 static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int por=
t,
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
