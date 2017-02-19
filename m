From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 13/29] IB/mlx4: Split a condition check in five functions
Date: Sun, 19 Feb 2017 17:21:53 +0000
Message-ID: <B3B45072-167B-4013-92B8-A06AC5EFEDEE@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<c2594ee3-ce5f-f86b-980c-098adf3e4609@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c2594ee3-ce5f-f86b-980c-098adf3e4609@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:08 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 18 Feb 2017 14:43:34 +0100
>=20
> The kfree() function was called in up to two cases during error handling
> even if the passed variable contained a null pointer.
>=20
> * Split a condition check for memory allocation failures.
>=20
> * Adjust jump targets according to the Linux coding style convention.
>=20
> * Delete initialisations for variables at the beginning
>  which became unnecessary with this refactoring.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/main.c | 90 +++++++++++++++++++++++++---------=
-----
> 1 file changed, 59 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index b3b5ded85166..c0c299ffa0f6 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -432,8 +432,8 @@ static int mlx4_ib_query_device(struct ib_device *ibd=
ev,
>                struct ib_udata *uhw)
> {
>    struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad =3D NULL;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
>    int err;
>    int have_ib_ports;
>    struct mlx4_uverbs_ex_query_device cmd;
> @@ -458,10 +458,14 @@ static int mlx4_ib_query_device(struct ib_device *i=
bdev,
>    resp.response_length =3D offsetof(typeof(resp), response_length) +
>        sizeof(resp.response_length);
>    in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
> +    if (!in_mad)
> +        return -ENOMEM;
> +
>    out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
> -    err =3D -ENOMEM;
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad) {
> +        err =3D -ENOMEM;
> +        goto free_in_mad;
> +    }
>=20
>    init_query_mad(in_mad);
>    in_mad->attr_id =3D IB_SMP_ATTR_NODE_INFO;
> @@ -570,9 +574,9 @@ static int mlx4_ib_query_device(struct ib_device *ibd=
ev,
>            goto out;
>    }
> out:
> -    kfree(in_mad);
>    kfree(out_mad);
> -
> +free_in_mad:
> +    kfree(in_mad);
>    return err;
> }
>=20
> @@ -588,16 +592,21 @@ mlx4_ib_port_link_layer(struct ib_device *device, u=
8 port_num)
> static int ib_link_query_port(struct ib_device *ibdev, u8 port,
>                  struct ib_port_attr *props, int netw_view)
> {
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad =3D NULL;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
>    int ext_active_speed;
>    int mad_ifc_flags =3D MLX4_MAD_IFC_IGNORE_KEYS;
> -    int err =3D -ENOMEM;
> +    int err;
>=20
>    in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
> +    if (!in_mad)
> +        return -ENOMEM;
> +
>    out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad) {
> +        err =3D -ENOMEM;
> +        goto free_in_mad;
> +    }
>=20
>    init_query_mad(in_mad);
>    in_mad->attr_id  =3D IB_SMP_ATTR_PORT_INFO;
> @@ -670,8 +679,9 @@ static int ib_link_query_port(struct ib_device *ibdev=
, u8 port,
>         props->active_speed =3D IB_SPEED_SDR;
>=20
> out:
> -    kfree(in_mad);
>    kfree(out_mad);
> +free_in_mad:
> +    kfree(in_mad);
>    return err;
> }
>=20
> @@ -763,17 +773,22 @@ static int mlx4_ib_query_port(struct ib_device *ibd=
ev, u8 port,
> int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
>            union ib_gid *gid, int netw_view)
> {
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad =3D NULL;
> -    int err =3D -ENOMEM;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
> +    int err;
>    struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
>    int clear =3D 0;
>    int mad_ifc_flags =3D MLX4_MAD_IFC_IGNORE_KEYS;
>=20
>    in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
> +    if (!in_mad)
> +        return -ENOMEM;
> +
>    out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad) {
> +        err =3D -ENOMEM;
> +        goto free_in_mad;
> +    }
>=20
>    init_query_mad(in_mad);
>    in_mad->attr_id  =3D IB_SMP_ATTR_PORT_INFO;
> @@ -811,8 +826,9 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 p=
ort, int index,
> out:
>    if (clear)
>        memset(gid->raw + 8, 0, 8);
> -    kfree(in_mad);
>    kfree(out_mad);
> +free_in_mad:
> +    kfree(in_mad);
>    return err;
> }
>=20
> @@ -902,15 +918,20 @@ static void mlx4_init_sl2vl_tbl(struct mlx4_ib_dev =
*mdev)
> int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
>             u16 *pkey, int netw_view)
> {
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad =3D NULL;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
>    int mad_ifc_flags =3D MLX4_MAD_IFC_IGNORE_KEYS;
> -    int err =3D -ENOMEM;
> +    int err;
>=20
>    in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
> +    if (!in_mad)
> +        return -ENOMEM;
> +
>    out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad) {
> +        err =3D -ENOMEM;
> +        goto free_in_mad;
> +    }
>=20
>    init_query_mad(in_mad);
>    in_mad->attr_id  =3D IB_SMP_ATTR_PKEY_TABLE;
> @@ -927,8 +948,9 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 =
port, u16 index,
>    *pkey =3D be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
>=20
> out:
> -    kfree(in_mad);
>    kfree(out_mad);
> +free_in_mad:
> +    kfree(in_mad);
>    return err;
> }
>=20
> @@ -2083,15 +2105,20 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp,=
 union ib_gid *gid, u16 lid)
>=20
> static int init_node_data(struct mlx4_ib_dev *dev)
> {
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad =3D NULL;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
>    int mad_ifc_flags =3D MLX4_MAD_IFC_IGNORE_KEYS;
> -    int err =3D -ENOMEM;
> +    int err;
>=20
>    in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
> +    if (!in_mad)
> +        return -ENOMEM;
> +
>    out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad) {
> +        err =3D -ENOMEM;
> +        goto free_in_mad;
> +    }
>=20
>    init_query_mad(in_mad);
>    in_mad->attr_id =3D IB_SMP_ATTR_NODE_DESC;
> @@ -2114,8 +2141,9 @@ static int init_node_data(struct mlx4_ib_dev *dev)
>    memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
>=20
> out:
> -    kfree(in_mad);
>    kfree(out_mad);
> +free_in_mad:
> +    kfree(in_mad);
>    return err;
> }
>=20
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd@mellanox.com>=
