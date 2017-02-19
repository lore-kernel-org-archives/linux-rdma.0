From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 01/29] IB/mlx4: Use kcalloc() in mlx4_ib_alloc_pv_bufs()
Date: Sun, 19 Feb 2017 17:06:25 +0000
Message-ID: <B11341F8-7B7C-4BE5-9F87-C6C10A117F9C@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <e2a30e40-a7ad-585b-a694-ab1e9bd532c2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e2a30e40-a7ad-585b-a694-ab1e9bd532c2@users.sourceforge.net>
Content-Language: en-US
Content-ID: <B66DB0DA453F934BB2C9C9E0DC1EEF2E@Mellanox365.onmicrosoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:55 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 20:00:34 +0100
>=20
> * A multiplication for the size determination of a memory allocation
>  indicated that an array data structure should be processed.
>  Thus use the corresponding function "kcalloc".
>=20
>  This issue was detected by using the Coccinelle software.
>=20
> * Replace the specification of a data structure by a pointer dereference
>  to make the corresponding size determination a bit safer according to
>  the Linux coding style convention.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index db564ccc0f92..61bd81baeb29 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1600,8 +1600,8 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_dem=
ux_pv_ctx *ctx,
>        return -EINVAL;
>=20
>    tun_qp =3D &ctx->qp[qp_type];
> -
> -    tun_qp->ring =3D kzalloc(sizeof (struct mlx4_ib_buf) * MLX4_NUM_TUNN=
EL_BUFS,
> +    tun_qp->ring =3D kcalloc(MLX4_NUM_TUNNEL_BUFS,
> +                   sizeof(*tun_qp->ring),
>                   GFP_KERNEL);
>    if (!tun_qp->ring)
>        return -ENOMEM;
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd@mellanox.com> =
