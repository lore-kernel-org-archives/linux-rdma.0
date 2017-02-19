From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 11/29] IB/mlx4: Use kmalloc_array() in three functions
Date: Sun, 19 Feb 2017 17:21:57 +0000
Message-ID: <69F665D3-8CA0-4229-999B-DE2020ECA09E@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <3002f281-292a-c53e-0b37-d23a3be0d5d7@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3002f281-292a-c53e-0b37-d23a3be0d5d7@users.sourceforge.net>
Content-Language: en-US
Content-ID: <B96071430A1AC444A47F68BCEDB7DA42@Mellanox365.onmicrosoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:07 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 18 Feb 2017 10:32:32 +0100
>=20
> Multiplications for the size determination of memory allocations
> indicated that array data structures should be processed.
> Thus use the corresponding function "kmalloc_array".
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/main.c | 14 +++++++++-----
> 1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index ba6af84cc236..350c9148340e 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -304,7 +304,9 @@ static int mlx4_ib_add_gid(struct ib_device *device,
>        ctx->refcount++;
>    }
>    if (!ret && hw_update) {
> -        gids =3D kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC)=
;
> +        gids =3D kmalloc_array(MLX4_MAX_PORT_GIDS,
> +                     sizeof(*gids),
> +                     GFP_ATOMIC);
>        if (!gids) {
>            ret =3D -ENOMEM;
>        } else {
> @@ -359,7 +361,9 @@ static int mlx4_ib_del_gid(struct ib_device *device,
>    if (!ret && hw_update) {
>        int i;
>=20
> -        gids =3D kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC)=
;
> +        gids =3D kmalloc_array(MLX4_MAX_PORT_GIDS,
> +                     sizeof(*gids),
> +                     GFP_ATOMIC);
>        if (!gids) {
>            ret =3D -ENOMEM;
>        } else {
> @@ -2828,9 +2832,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>            goto err_counter;
>=20
>        ibdev->ib_uc_qpns_bitmap =3D
> -            kmalloc(BITS_TO_LONGS(ibdev->steer_qpn_count) *
> -                sizeof(long),
> -                GFP_KERNEL);
> +            kmalloc_array(BITS_TO_LONGS(ibdev->steer_qpn_count),
> +                      sizeof(long),
> +                      GFP_KERNEL);
>        if (!ibdev->ib_uc_qpns_bitmap)
>            goto err_steer_qp_release;
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
