From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 23/29] IB/mlx4: Improve size determinations in
 create_qp_common()
Date: Sun, 19 Feb 2017 19:54:07 +0000
Message-ID: <EA4233BB-E615-411E-BC99-14D8A2A367EE@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<9b7e9f1c-ccf4-6de6-158f-cd9f86f5edb4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9b7e9f1c-ccf4-6de6-158f-cd9f86f5edb4-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:15 PM, SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5ug@public.gmane.org=
e.net> wrote:
>=20
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 18 Feb 2017 18:29:30 +0100
>=20
> Replace the specification of two data structures by pointer dereferences
> as the parameter for the operator "sizeof" to make the corresponding size
> determinations a bit safer according to the Linux coding style convention=
.
>=20
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
> drivers/infiniband/hw/mlx4/qp.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4=
/qp.c
> index 11fec4a8fae5..cc7bd257a1fd 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -691,14 +691,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev=
, struct ib_pd *pd,
>        if (qp_type =3D=3D MLX4_IB_QPT_SMI || qp_type =3D=3D MLX4_IB_QPT_G=
SI ||
>            (qp_type & (MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_SMI_OWNE=
R |
>                MLX4_IB_QPT_PROXY_GSI | MLX4_IB_QPT_TUN_SMI_OWNER))) {
> -            sqp =3D kzalloc(sizeof (struct mlx4_ib_sqp), gfp);
> +            sqp =3D kzalloc(sizeof(*sqp), gfp);
>            if (!sqp)
>                return -ENOMEM;
>            qp =3D &sqp->qp;
>            qp->pri.vid =3D 0xFFFF;
>            qp->alt.vid =3D 0xFFFF;
>        } else {
> -            qp =3D kzalloc(sizeof (struct mlx4_ib_qp), gfp);
> +            qp =3D kzalloc(sizeof(*qp), gfp);
>            if (!qp)
>                return -ENOMEM;
>            qp->pri.vid =3D 0xFFFF;
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
