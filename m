From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix missing device local_dma_lkey
Date: Mon, 20 Jul 2015 13:08:06 -0400
Message-ID: <3095C235-676F-4A99-A27C-F2F332D9921F@oracle.com>
References: <1437411276-22731-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437411276-22731-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 20, 2015, at 12:54 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> The mlx5 driver exposes device capability IB_DEVICE_LOCAL_DMA_LKEY
> but does not set the the device local_dma_lkey. This breaks
> rpcrdma drivers.
>=20
> Query and set this lkey when creating the device resources.

Wow. This suggests no-one has been testing NFS/RDMA with mlx5? I
know I=92m not (yet). Anyway, this makes sense.


> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> drivers/infiniband/hw/mlx5/main.c            |  9 ++++++++-
> drivers/net/ethernet/mellanox/mlx5/core/fw.c | 22 +++++++++++++++++++=
+++
> include/linux/mlx5/device.h                  | 11 +++++++++++
> include/linux/mlx5/driver.h                  |  1 +
> 4 files changed, 42 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> index 11bd9ec..b272c8a 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1257,10 +1257,18 @@ static int create_dev_resources(struct mlx5_i=
b_resources *devr)
> 	struct ib_srq_init_attr attr;
> 	struct mlx5_ib_dev *dev;
> 	struct ib_cq_init_attr cq_attr =3D {.cqe =3D 1};
> +	u32 rsvd_lkey;
> 	int ret =3D 0;
>=20
> 	dev =3D container_of(devr, struct mlx5_ib_dev, devr);
>=20
> +	ret =3D mlx5_core_query_special_context(dev->mdev, &rsvd_lkey);
> +	if (ret) {
> +		pr_err("Failed to query special context %d\n", ret);
> +		return ret;
> +	}
> +	dev->ib_dev.local_dma_lkey =3D rsvd_lkey;
> +
> 	devr->p0 =3D mlx5_ib_alloc_pd(&dev->ib_dev, NULL, NULL);
> 	if (IS_ERR(devr->p0)) {
> 		ret =3D PTR_ERR(devr->p0);
> @@ -1422,7 +1430,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *=
mdev)
> 	strlcpy(dev->ib_dev.name, "mlx5_%d", IB_DEVICE_NAME_MAX);
> 	dev->ib_dev.owner		=3D THIS_MODULE;
> 	dev->ib_dev.node_type		=3D RDMA_NODE_IB_CA;
> -	dev->ib_dev.local_dma_lkey	=3D 0 /* not supported for now */;
> 	dev->num_ports		=3D MLX5_CAP_GEN(mdev, num_ports);
> 	dev->ib_dev.phys_port_cnt     =3D dev->num_ports;
> 	dev->ib_dev.num_comp_vectors    =3D
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/fw.c
> index 9335e5a..aa0d5ff 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> @@ -200,3 +200,25 @@ int mlx5_cmd_teardown_hca(struct mlx5_core_dev *=
dev)
>=20
> 	return err;
> }
> +
> +int mlx5_core_query_special_context(struct mlx5_core_dev *dev, u32 *=
rsvd_lkey)
> +{
> +	struct mlx5_cmd_query_special_contexts_mbox_in in;
> +	struct mlx5_cmd_query_special_contexts_mbox_out out;
> +	int err;
> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.hdr.opcode =3D cpu_to_be16(MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> +	err =3D mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
> +	if (err)
> +		return err;
> +
> +	if (out.hdr.status)
> +		err =3D mlx5_cmd_status_to_err(&out.hdr);
> +
> +	*rsvd_lkey =3D be32_to_cpu(out.resd_lkey);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(mlx5_core_query_special_context);
> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.=
h
> index b943cd9..6e4169c 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -402,6 +402,17 @@ struct mlx5_cmd_teardown_hca_mbox_out {
> 	u8			rsvd[8];
> };
>=20
> +struct mlx5_cmd_query_special_contexts_mbox_in {
> +	struct mlx5_inbox_hdr	hdr;
> +	u8			rsvd[8];
> +};
> +
> +struct mlx5_cmd_query_special_contexts_mbox_out {
> +	struct mlx5_outbox_hdr	hdr;
> +	__be32                  dump_fill_mkey;
> +	__be32                  resd_lkey;
> +};
> +
> struct mlx5_cmd_layout {
> 	u8		type;
> 	u8		rsvd0[3];
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.=
h
> index 5722d88..1e2e48c 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -828,6 +828,7 @@ void *mlx5_get_protocol_dev(struct mlx5_core_dev =
*mdev, int protocol);
> int mlx5_register_interface(struct mlx5_interface *intf);
> void mlx5_unregister_interface(struct mlx5_interface *intf);
> int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor=
_id);
> +int mlx5_core_query_special_context(struct mlx5_core_dev *dev, u32 *=
rsvd_lkey);
>=20
> struct mlx5_profile {
> 	u64	mask;

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
